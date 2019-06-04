local M = class("HallMenuView2", import(".HallMenuView"))
--local M = class("HallMenuView2", cc.load("ViewBase"))
M.RESOURCE_FILENAME = "ui/newhall/hall_main2/hall_menu_view_2.lua"
M.RESOURCE_BINDING =
{
    ["nd_bottom"]   = {["varname"] = "nd_bottom"  },    -- 底部菜单栏
    ["nd_top"]      = {["varname"] = "nd_top"     },
    ["nd_userinfo"] = {["varname"] = "nd_userinfo"},
    ["nd_left"]     = {["varname"] = "nd_left"    },
    ["nd_honor"]    = {["varname"] = "nd_honor"   },
    ["nd_diamonds"] = {["varname"] = "nd_diamonds"},
    ["nd_bean"]     = {["varname"] = "nd_bean"    },
    ["ani_act"]     = {["varname"] = "ani_act"    },    -- 活动按钮动画

    ["ani_card"]    = {["varname"] = "ani_card"   },    -- 月卡动画
    ["btn_userinfo"]= {["varname"] = "btn_userinfo", ["events"] = {{event = "click", method = "onClickUserinfo"  }}},   -- 个人资料
    ["btn_notice"]  = {["varname"] = "btn_notice",   ["events"] = {{event = "click", method = "onClickNotice"    }}},   -- 公告
    ["btn_set"]     = {["varname"] = "btn_set",      ["events"] = {{event = "click", method = "onClickSetting"   }}},   -- 设置菜单
    ["btn_arena"]   = {["varname"] = "btn_arena",    ["events"] = {{event = "click", method = "onClickArena"     }}},   -- 大师赛
    ["btn_shop"]    = {["varname"] = "btn_shop",     ["events"] = {{event = "click", method = "onClickShop"      }}},   -- 商城
    ["btn_bag"]     = {["varname"] = "btn_bag",      ["events"] = {{event = "click", method = "onClickBag"       }}},   -- 背包
    ["btn_activity"]= {["varname"] = "btn_activity", ["events"] = {{event = "click", method = "onClickActivity"  }}},   -- 活动
    ["btn_exchange"]= {["varname"] = "btn_exchange", ["events"] = {{event = "click", method = "onClickExchange"  }}},   -- 兑换
    ["btn_honor"]   = {["varname"] = "btn_honor",    ["events"] = {{event = "click", method = "onClickHonor"     }}},   -- 荣誉系统
    ["btn_month_card"] = {["varname"] = "btn_month_card", ["events"] = {{event = "click", method = "onClickMonthCard"}}},   -- 月卡
    ["btn_room"]    = {["varname"] = "btn_room",     ["events"] = {{event = "click_color", method = "onClickFriendRoom"}}},   -- 好友房
    ["btn_fuli"]    = {["varname"] = "btn_fuli",     ["events"] = {{event = "click", method = "onClickFuli"      }}},   -- 福利
    ["btn_qiehuan"] = {["varname"] = "btn_qiehuan",  ["events"] = {{event = "click_color", method = "onClickDiQu"}}},   -- 地区
}
function M:onCreate()
    self:checkSwitch()
    self:initView()
    self:createUserAvatar()
    self:registerEventListener()
end

function M:initView()
    -- 适配
    local offsetX = gg.IIF(gg.isWideScreenPhone, 50, 0)
    self.nd_top:setPosition(cc.p(gg.getPhoneRight(), display.height - 44))
    self.nd_left:setPosition(cc.p(gg.getPhoneLeft(), display.height - 175 * display.scaleY))
    --self.nd_left:setScale(display.scaleY)
    self.nd_userinfo:setPosition(cc.p(gg.getPhoneLeft(), display.height - 45))
    if gg.isWideScreenPhone then
        local btnRoomW = self.btn_room:getContentSize().width
        --+ display.width - gg.getPhoneRight()
        self.btn_room:setContentSize(cc.size(btnRoomW, self.btn_room:getContentSize().height))
    end

    self.nd_left:setPositionY(display.cy)
    if display.width / display.height == 4/3 then
         self.nd_top:setScale(display.scaleX)
         self.nd_bottom:setScale(display.scaleX)
         self.nd_userinfo:setScale(display.scaleX)
         self.nd_left:setScale(display.scaleX)

         self.nd_bottom:findNode("menu_bg"):setContentSize(cc.size(display.width + 168, 76))
         self.nd_bottom:findNode("menu_bg"):setPositionX(gg.getPhoneLeft() - 90)
    else
         self.nd_bottom:findNode("menu_bg"):setContentSize(cc.size(display.width - 132, 76))
         self.nd_bottom:findNode("menu_bg"):setPositionX(gg.getPhoneLeft() - 72)
         self.nd_bottom:findNode("nd_right"):setPositionX(gg.getPhoneRight())
         self.nd_bottom:findNode("nd_left"):setPositionX(gg.getPhoneLeft())
         self.nd_left:setScale(math.min(display.scaleX, display.scaleY))
    end
    if gg.isWideScreenPhone then
        self.nd_bottom:findNode("menu_bg"):setContentSize(cc.size(display.width - 265 , 76))
        self.nd_bottom:findNode("menu_bg"):setPositionX(gg.getPhoneLeft() - 150)
    end
    self.nd_bottom:setPositionY(35)

    -- 添加点击方法
    self.nd_top:findNode("bean_bg"):onClick(function()
        gg.AudioManager:playClickEffect()
        GameApp:DoShell(self:getScene(), "Store://bean")
    end)
    self.nd_top:findNode("diamond_bg"):onClick(function()
        gg.AudioManager:playClickEffect()
        GameApp:DoShell(self:getScene(), "Store://diamond")
    end)

    -- 初始化先隐藏好友房按钮，防止审核等模式开启时闪一下的问题
    self.btn_room:setVisible(false)
end

-- 注册消息通知
function M:registerEventListener()
    self:addEventListener(gg.Event.HALL_WEB_INIT, handler(self, self.onEventWebInit))
    self:addEventListener(gg.Event.HALL_UPDATE_USER_DATA, handler(self, self.updateUserinfo))
    self:addEventListener(gg.Event.HALL_UPDATE_NOTICE_UNREAD_COUNT, handler(self, self.refreshUnreadNum))
    -- 玩家从游戏退出后检测是否有任务完成
    self:addEventListener(gg.Event.GAME_STOP, handler(self, self.onGameStop))
    -- 活动已读状态更改通知
    self:addEventListener(gg.Event.UPDATE_ACTIVITY_READED, handler(self, self.onEventActivityReaded))
    -- 月卡领取奖励通知
    self:addEventListener(gg.Event.GOT_PRIVILEGE_REWARD, handler(self, self.onEventGotMonthCardReward))
    -- 切换地区成功
    self:addEventListener(gg.Event.HALL_SELECT_AREA, handler(self, self.updateUserinfo))
end

-- 加入游戏房间
function M:joinGameRoom(noblur)
    self.nd_userinfo:setVisible(false)
    self.nd_left:setVisible(false)
    self.nd_bottom:setVisible(false)
    self:updateBtnsPos()
end

-- 返回大厅主界面操作
function M:backToHall()
    self.nd_userinfo:setVisible(true)
    self.nd_bottom:setVisible(true)
    self:updateBtnsPos()
    local roomEnabled = GameApp:CheckModuleEnable(ModuleTag.FriendRooms) and GameApp:CanCreateFriendRoom()
    self.btn_room:setVisible(roomEnabled)
    self:updateNodeShow(1)
end

function M:updateUserinfo()
    if not hallmanager or not hallmanager.userinfo then return end
	local userinfo = hallmanager.userinfo
    -- 根据玩家荣誉等级来设置好友房创建权限,是否显示出好友房按钮
    local roomEnabled = GameApp:CheckModuleEnable(ModuleTag.FriendRooms) and GameApp:CanCreateFriendRoom()
    self.btn_room:setVisible(roomEnabled)

    -- 设置玩家昵称
    local strNick = gg.SubUTF8StringByWidth(userinfo.nick, 130, 26, "")
    local txt_nickname = self.nd_userinfo:findNode("txt_nickname")
    txt_nickname:setString(strNick)

    local bgW = txt_nickname:getContentSize().width + 130
    -- 设置地区
    if IS_REVIEW_MODE then
        self.btn_qiehuan:setVisible(false)
    else
        local areaConfig = GameApp:getAreaConfig()
        local userRegion = gg.LocalConfig:GetRegionCode()
        local areaCode = tonumber(string.sub(tostring(userRegion), 1, 4))
        local areaName = checkstring(areaConfig[areaCode])
        if areaName == "" or string.len(areaName) == 0 then
            areaCode = tonumber(string.sub(tostring(userRegion), 1, 2))
            areaName = checkstring(areaConfig[areaCode])
        end
        local txt_diqu = self.btn_qiehuan:getChildByName("txt_diqu")
        txt_diqu:setString(areaName)

        local img_qiehuan = self.btn_qiehuan:getChildByName("img_qiehuan")
        img_qiehuan:setPositionX(txt_diqu:getContentSize().width + 15)
        local qhBtnW = txt_diqu:getContentSize().width + img_qiehuan:getContentSize().width
        self.btn_qiehuan:setContentSize(cc.size(qhBtnW + 20, self.btn_qiehuan:getContentSize().height))
        bgW = bgW + qhBtnW
    end

    local info_bg = self.nd_userinfo:findNode("info_bg")
    info_bg:setContentSize(cc.size(bgW, info_bg:getContentSize().height))
    local btn_userinfo = self.nd_userinfo:findNode("btn_userinfo")
    btn_userinfo:setContentSize(cc.size(bgW + 25, btn_userinfo:getContentSize().height))

    self.btn_qiehuan:setPositionX(bgW + 15)

    -- 加载用户头像
    local avatarPath = gg.IIF(userinfo.sex == 1, "common/hd_male.png", "common/hd_female.png")
    if userinfo.avatar == 0xFFFFFFFF then
        avatarPath = userinfo.avatarurl
        gg.ImageDownload:LoadUserAvaterImage({url = avatarPath, ismine = true, image = self._avatar}, function()
            self._avatar:setScale(75 / self._avatar:getContentSize().width)
        end)
    else
        self._avatar:loadTexture(avatarPath)
    end
    -- 设置豆子数 & 钻石数 & 礼券数
    local strBean = gg.IIF(tonumber(userinfo.money) >= 100000000, String:numToZn(userinfo.money, 8, 1), String:numToZn(userinfo.money, 4, 1))
    self.nd_top:findNode("txt_bean"):setString(strBean)
    self.nd_top:findNode("txt_diamond"):setString(checkint(userinfo.xzmoney))
    -- 设置荣誉等级显示
    self:updateHonorLv()

end
function M:onEventWebInit()
    self:refreshUnreadNum()
    self:updateUserinfo()
    -- 根据玩家荣誉等级来设置好友房创建权限,是否显示出好友房按钮
    local roomEnabled = GameApp:CheckModuleEnable(ModuleTag.FriendRooms) and GameApp:CanCreateFriendRoom()
    self.btn_room:setVisible(roomEnabled)
    -- 判断活动未读数量设置按钮动画
    local unreadCount = gg.ActivityPageCtrl:getActivityUnreadCount()
    if unreadCount > 0 then
        self:playActivityBtnAni(true)
    end
    -- 月卡可以领取时播放领取动画
    local gzStatus = gg.UserData:GetPrivilegeStatus()
    local xyStatus = gg.UserData:GetMonthCardVIPStatus()
    if gzStatus == 4 or xyStatus == 4 then
        self:playMonthCardAni(true)
    end

    local share_date = os.date("%Y%m%d", gg.UserData:GetShareTime())
    local curr_date = os.date("%Y%m%d", os.time())

    -- 第三方统计 SDK
    if hallmanager and hallmanager:IsConnected() then
        gg.ThirdParty:activeDevice(hallmanager.userinfo.id)
        local loginTimes = checkint(hallmanager:GetEffortData(0))
        if loginTimes == 1 then
            gg.ThirdParty:registerAccount(hallmanager.userinfo.id)
            -- 发送地区码给服务端
            if gg.LocalConfig:GetRegionCode() > 0 then
                gg.Dapi:UserRegion(gg.LocalConfig:GetRegionCode(), function(result)
                    printf("新用户登录发送地区码给服务端:%s", tostring(result.msg))
                    if REGION_CODE == 0 then
                        -- 家乡棋牌产品，走一遍断线重连来获取最新的数据
                        GameApp:UpdateReconnectState(false, true)
                        GameApp:ReconnectToHall(nil, true, true)
                    end
                end)
            end
        end
    end
  -- 不是审核模式，并且红包有开启。 注册7天内每天第一次登入 及 玩家没有领取红包 才能打开迎新红包界面
    -- 2018-06-14 增加限制条件：只有更新到新版本之后注册的新用户才能弹出参与七天红包界面
    -- 2018-08-08 屏蔽新手红包功能（by zhangbin)
    -- local outStatu = gg.UserData:GetRedPacketStatus()
    -- if not IS_REVIEW_MODE and outStatu == 1 and GameApp:CheckModuleEnable(ModuleTag[PROP_ID_261]) and gg.UserData:IsNewAppVersionUser(31) then
    --     self:showNewUserGift()
    -- else

    -- 尝试弹出新手/VIP超值礼包
    self:popGiftView()
    local curScene = GameApp:getRunningScene()
    --玩家在大厅并且第一次登入才需要弹出
    if curScene.name_ == "HallScene" and checkint(SIGN_POPUP) == 0 then
        cc.exports.SIGN_POPUP = checkint(SIGN_POPUP) + 1
        -- 尝试显示签到界面
        self:popSignView()
    end
end

function M:checkSwitch()
    -- 公告按钮
    if not GameApp:CheckModuleEnable(ModuleTag.Notice) then
        self.btn_notice:setVisible(false)
    end
    -- 钻石
    if not GameApp:CheckModuleEnable(ModuleTag.Diamond) then
        self.nd_diamonds:setVisible(false)
    end
    -- 活动开关
    if not GameApp:CheckModuleEnable(ModuleTag.Activity) then
        self.btn_activity:setVisible(false)
    end
    -- 贵族月卡和星耀月卡都关闭时不显示月卡按钮
    if not GameApp:CheckModuleEnable(ModuleTag.Privilege) and not GameApp:CheckModuleEnable(ModuleTag.XYMonthCard) then
        self.btn_month_card:setVisible(false)
    end
    -- 背包
    if not GameApp:CheckModuleEnable(ModuleTag.Bag) then
        self.btn_bag:setVisible(false)
    end
    -- 兑换
    if not GameApp:CheckModuleEnable(ModuleTag.Exchange) then
        self.btn_exchange:setVisible(false)
    end
    -- 商城
    if not GameApp:CheckModuleEnable(ModuleTag.Store) then
        self.btn_shop:setVisible(false)
    end
    -- 荣誉系统
    if not GameApp:CheckModuleEnable(ModuleTag.Honor) then
        self.nd_honor:setVisible(false)
    end
    -- 大师赛
    if not GameApp:CheckModuleEnable(ModuleTag.Arena) then
        self.btn_arena:setVisible(false)
    end
    -- 免费福利
    if not GameApp:CheckModuleEnable(ModuleTag.FreeWelfare) then
        self.btn_fuli:setVisible(false)
    end
    self:updateBtnsPos()
end

-- 根据开关显示调整按钮位置
function M:updateBtnsPos()
    -- 背包，兑换，活动按钮，荣誉系统均匀排布在底部
  --  local btnDis = (gg.getPhoneRight() - gg.getPhoneLeft() - 1060) / 5
    local btnDis = 25
    local btnTb = {self.btn_shop,self.btn_exchange, self.btn_notice,self.btn_activity}
    local posX = -415 - btnDis
    local nd_right =  self.nd_bottom:findNode("nd_right")
    local count = 1
    for i=1,4 do
        local line =  nd_right:findNode("img_line"..count)
        line:setVisible(false)
    end
    local linePos = 70
    for i,v in ipairs(btnTb) do
        if v:isVisible() then
            if v == self.btn_exchange then
                linePos = 80
            end
            local line =  nd_right:findNode("img_line"..count)
            line:setVisible(true)
            line:setPositionX(posX-linePos)

            v:setPositionX(posX)
            posX = posX - v:getContentSize().width - btnDis
            count = count+1
            linePos = 70
        end
    end
    self.nd_honor:setPositionX(100 + btnDis)

    -- 左侧分享，月卡按钮,限时特惠，
    local btnPosX = {-46+205, -193+205, -340+205}
    local showCnt = 0
    for i,v in ipairs(self.nd_left:getChildren()) do
        if v:isVisible() then
            showCnt = showCnt + 1
            v:setPositionY(btnPosX[showCnt])
        end
    end
    -- 顶部按钮
    self:topActivityBtns()
end

function M:topActivityBtns()
    --设置的按钮
    local firstPost = self.btn_set:getPositionX();
    local topRightTab = {self.btn_set,self.btn_bag}
    local showCnt = 0

    for i,v in ipairs(topRightTab) do
        if v:isVisible() then
            v:setPositionX(firstPost)
            showCnt = showCnt + 1
            local btnW = self:NextBtnHeight(topRightTab, showCnt)
            firstPost = firstPost - v:getContentSize().width / 2 - btnW - 20
        end
    end

    local btnPosX = firstPost -40 + 60 - 173 - 34
    local showCount = 0
    local topLeftTab = {self.nd_top:findNode("nd_bean"), self.nd_top:findNode("nd_diamonds"), self.nd_top:findNode("nd_diamonds_0")}
    for i,v in ipairs(topLeftTab) do
        if v:isVisible() then
            v:setPositionX(btnPosX + ((-173 - 34) * showCount))
            showCount = showCount + 1
        end
    end
end

return M

