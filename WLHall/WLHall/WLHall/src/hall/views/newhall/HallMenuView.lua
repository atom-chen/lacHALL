--
-- Author: Cai
-- Date: 2018-03-08
-- Describe：大厅菜单

local M = class("HallMenuView", cc.load("ViewBase"))
M.RESOURCE_FILENAME = "ui/newhall/hall_menu_view.lua"
M.RESOURCE_BINDING = {
    ["nd_bottom"]   = {["varname"] = "nd_bottom"  },    -- 底部菜单栏
    ["nd_top"]      = {["varname"] = "nd_top"     },
    ["nd_userinfo"] = {["varname"] = "nd_userinfo"},
    ["nd_left"]     = {["varname"] = "nd_left"    },
    ["nd_honor"]    = {["varname"] = "nd_honor"   },
    ["nd_diamonds"] = {["varname"] = "nd_diamonds"},
    ["nd_bean"]     = {["varname"] = "nd_bean"    },
    ["ani_act"]     = {["varname"] = "ani_act"    },    -- 活动按钮动画
    ["img_mfd2"]    = {["varname"] = "img_mfd2"   },-- 免费福利2

    ["img_mfd"]    = {["varname"] = "img_mfd"   },--免费豆左边豆豆图片
    ["ani_mfd1"]    = {["varname"] = "ani_mfd1"   }, -- 免费福利动画1
    ["ani_card"]    = {["varname"] = "ani_card"   },    -- 月卡动画
    ["ani_share"]   = {["varname"] = "ani_share"  },    -- 分享动画
    ["btn_userinfo"]= {["varname"] = "btn_userinfo", ["events"] = {{event = "click", method = "onClickUserinfo"  }}},   -- 个人资料
    ["btn_notice"]  = {["varname"] = "btn_notice",   ["events"] = {{event = "click", method = "onClickNotice"    }}},   -- 公告
    ["btn_set"]     = {["varname"] = "btn_set",      ["events"] = {{event = "click", method = "onClickSetting"   }}},   -- 设置菜单
    ["btn_share"]   = {["varname"] = "btn_share",    ["events"] = {{event = "click", method = "onClickShare"     }}},   -- 分享
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

local welfareData   = require("hall.models.WelfareData")
-- 礼包界面弹出冷却时间
local POP_TIME_LIMIT = 3 * 3600

function M:onCreate()
    self.ani_act:setVisible(false)
    self.ani_mfd1:setVisible(false)
    self.img_mfd2:setVisible(false)
    self.img_mfd:setVisible(true)
    self:initView()
    self:checkSwitch()
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
        local btnRoomW = self.btn_room:getContentSize().width + display.width - gg.getPhoneRight()
        self.btn_room:setContentSize(cc.size(btnRoomW, self.btn_room:getContentSize().height))
    end

    if display.width / display.height == 4/3 then
        self.nd_top:setScale(display.scaleX)
        self.nd_bottom:setScale(display.scaleX)
        self.nd_userinfo:setScale(display.scaleX)
        self.nd_left:setScale(display.scaleX)
        self.nd_left:setPosition(cc.p(self.nd_left:getPositionX(), self.nd_left:getPositionY() - 55))
    else
        self.nd_bottom:findNode("menu_bg"):setContentSize(cc.size(display.width, 72))
        self.nd_bottom:findNode("nd_right"):setPositionX(gg.getPhoneRight())
        self.nd_bottom:findNode("nd_left"):setPositionX(gg.getPhoneLeft())
        self.nd_left:setScale(display.scaleY)
    end

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

function M:checkSwitch()
    -- 公告按钮
	  if not GameApp:CheckModuleEnable(ModuleTag.Notice) then
        self.btn_notice:setVisible(false)
    end
    -- 钻石
    if not GameApp:CheckModuleEnable(ModuleTag.Diamond) then
        self.nd_diamonds:setVisible(false)
    end
    -- 分享开关关闭不显示分享按钮
    if not gg.UserData:CanDoShare() then
        self.btn_share:setVisible(false)
    end
    --不显示分享按钮
    self.btn_share:setVisible(false)
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

function M:createUserAvatar()
    local imgBg = self.nd_userinfo:findNode("img_avatar_bg")
    -- 创建头像
    local drawNode = gg.DrawNodeRoundRect(cc.DrawNode:create(), cc.rect(0, 0, 72, -72), 1, 4, cc.c4b(0, 0, 0, 1), cc.c4f(0, 0, 0, 1))
    local clipNode = cc.ClippingNode:create(drawNode)
	  clipNode:setInverted(false)
    clipNode:setPosition(0, 0)
    imgBg:addChild(clipNode)

    self._avatar = ccui.ImageView:create("common/hd_male.png")
    self._avatar:setPosition(36, 36)
    self._avatar:setScale(75 / self._avatar:getContentSize().width)
    clipNode:addChild(self._avatar)
end

-- 根据开关显示调整按钮位置
function M:updateBtnsPos()
    -- 背包，兑换，活动按钮，荣誉系统均匀排布在底部
    local btnDis = (gg.getPhoneRight() - gg.getPhoneLeft() - 1060) / 5
    btnDis = math.max(btnDis, 44)
    local btnTb = {self.btn_exchange, self.btn_activity, self.btn_fuli}
    local posX = -305 - btnDis
    for i,v in ipairs(btnTb) do
        if v:isVisible() then
            v:setPositionX(posX - v:getContentSize().width / 2)
            posX = posX - v:getContentSize().width - btnDis
        end
    end
    self.nd_honor:setPositionX(202 + btnDis)

    -- 左侧分享，限时特惠，月卡按钮
    local btnPosX = {-46, -191, -336}
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
    local topRightTab = {self.btn_set, self.btn_notice, self.btn_bag}
    local showCnt = 0

    for i,v in ipairs(topRightTab) do
        if v:isVisible() then
            v:setPositionX(firstPost)
            showCnt = showCnt + 1
            local btnW = self:NextBtnHeight(topRightTab, showCnt)
            firstPost = firstPost - v:getContentSize().width / 2 - btnW - 20
        end
    end

    local btnPosX = firstPost + 60 - 173 - 34
    local showCount = 0
    local topLeftTab = {self.nd_top:findNode("nd_bean"), self.nd_top:findNode("nd_diamonds"), self.nd_top:findNode("nd_diamonds_0")}
    for i,v in ipairs(topLeftTab) do
        if v:isVisible() then
            v:setPositionX(btnPosX + ((-173 - 34) * showCount))
            showCount = showCount + 1
        end
    end
end

--计算下个按钮的高度
function M:NextBtnHeight(topTab, index)
    local btn = topTab[index]
    if btn and btn:isVisible() then
        return btn:getContentSize().width / 2
    else
        return self:NextBtnHeight(topTab, index + 1)
    end
end

-- 刷新荣誉等级段位显示
function M:updateHonorLv()
    if not hallmanager or not hallmanager.userinfo then return end
    -- 根据荣誉等级计算出用户所在的等级
    local hlvExp = hallmanager:GetHonorValue()
    local grade, star = gg.GetHonorGradeAndLevel(hlvExp)
    -- 设置等级图标
    cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/cup.plist")
    local img_cup = self.nd_bottom:findNode("img_1")
    img_cup:ignoreContentAdaptWithSize(true)
    img_cup:loadTexture(string.format("hall/honor/grade_img_%d.png", grade), 1)
    img_cup:setScale(56 / img_cup:getContentSize().height)

    -- 初始星星数显示
    for i = 1 ,5 do
        self.nd_bottom:findNode("star_" .. i):setPercent(0)
    end
    -- 设置星星数显示
    for i=1,star do
        self.nd_bottom:findNode("star_" .. i):setPercent(100)
    end
    if star < 5 then
        local lv, minExp, nextExp= gg.GetHonorLevel(hlvExp)
        local percent = (hlvExp - minExp) / (nextExp - minExp) * 100
        self.nd_bottom:findNode("star_" .. star + 1):setPercent(percent)
    end
end

-- 加入游戏房间
function M:joinGameRoom(noblur)
    self.nd_userinfo:setVisible(false)
    self.nd_left:setVisible(false)
    -- 隐藏公告按钮
    self.btn_notice:setVisible(false)
    self:topActivityBtns()

    if not noblur then
        local bgv = self:getScene():getChildByName("BackgroundView")
        if bgv and bgv.showBlurBg then
            bgv:showBlurBg(true)
        end
    end
end

-- 设置界面的node显示，1：正常显示 2：隐藏底部和左边节点
function M:updateNodeShow(sType)
    self.nd_bottom:setVisible(sType == 1)
    self.nd_left:setVisible(sType == 1)
    self:checkSwitch()
end

-- 返回大厅主界面操作
function M:backToHall()
    self.nd_userinfo:setVisible(true)
    -- 隐藏公告按钮
    self.btn_notice:setVisible(true)
    self:topActivityBtns()
    local roomEnabled = GameApp:CheckModuleEnable(ModuleTag.FriendRooms) and GameApp:CanCreateFriendRoom()
    self.btn_room:setVisible(roomEnabled)
    self:updateNodeShow(1)
end

--==============================--
-- 通知
--==============================--
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
    -- 分享领取奖励成功，通知大厅关闭分享提示动画
    self:addEventListener(gg.Event.FIRST_DAILY_SHARE_SUCCESS, handler(self, self.onEventFirstShareSuccess))
    -- 切换地区成功
    self:addEventListener(gg.Event.HALL_SELECT_AREA, handler(self, self.updateUserinfo))
    -- 签到成功
    self:addEventListener(gg.Event.WELFARE_ACTIVITY, handler(self, self.onEventSignSuccess))
end

function M:onEventSignSuccess(event, actId)
    if actId == "mrqd" or actId ==  "share" then
        local signType, isSigned = welfareData:isShowSign()
        if isSigned and gg.UserData:GetShareGiftStatus() == 5 then
            self:playWelfareBtnAni(false)
        end
    end
end

function M:onGameStop( )
    -- 游戏退出到大厅，进行防沉迷检查
    gg.InvokeFuncNextFrame(function()
        if hallmanager then
            hallmanager:CheckTireTime()
        end
    end)
end

function M:onEventFirstShareSuccess()
    self:playShareAni(false)
end

function M:onEventGotMonthCardReward()
    -- 月卡无可以领取时停止播放动画
    local gzStatus = gg.UserData:GetPrivilegeStatus()
    local xyStatus = gg.UserData:GetMonthCardVIPStatus()
    if gzStatus ~= 4 and xyStatus ~= 4 then
        self:playMonthCardAni(false)
    end
end

function M:onEventActivityReaded()
    -- 活动界面关闭时检测是否还有未读活动，没有则关闭大厅动画
    local unreadCount = gg.ActivityPageCtrl:getActivityUnreadCount()
    if unreadCount == 0 then
        self:playActivityBtnAni(false)
    end
end

-- 更新用户信息
function M:updateUserinfo()
    if not hallmanager or not hallmanager.userinfo then return end
	local userinfo = hallmanager.userinfo
    -- 根据玩家荣誉等级来设置好友房创建权限,是否显示出好友房按钮
    local roomEnabled = GameApp:CheckModuleEnable(ModuleTag.FriendRooms) and GameApp:CanCreateFriendRoom()
    self.btn_room:setVisible(roomEnabled)

    -- 荣誉值变化分享有礼按钮的显示
    self.btn_share:setVisible(gg.UserData:CanDoShare())
    --不显示分享按钮
    self.btn_share:setVisible(false)

    -- 设置玩家昵称
    local strNick = gg.SubUTF8StringByWidth(userinfo.nick, 130, 26, "")
    local txt_nickname = self.nd_userinfo:findNode("txt_nickname")
    txt_nickname:setString(strNick)

    local bgW = txt_nickname:getContentSize().width + 130
    -- 设置地区
    if device.platform == "android" and IS_REVIEW_MODE then
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

-- 用户数据初始化
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
    -- 今天未分享播放分享动画
    if curr_date ~= share_date then
        self:playShareAni(true)
    end

    -- 未签到播放签到动画
    local signType, isSigned = welfareData:isShowSign()

    if not isSigned or gg.UserData:GetShareGiftStatus() == 3 then
        self:playWelfareBtnAni(true)
    end

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

    -- 检查各种弹出窗口
    self:checkPopupViews()
end

-- 检查各种登录弹出窗口
-- 所有的登录弹出窗口都在这里检查，以控制窗口的弹出顺序
-- 先检查的窗口会被后检查的窗口遮挡
function M:checkPopupViews()

    -- 检查是否有弹出的广告页
    gg.UserData:CheckAds()

    -- 尝试弹出签到界面
    -- 玩家在大厅并且第一次登入才需要弹出
    local curScene = GameApp:getRunningScene()
    if curScene.name_ == "HallScene" and checkint(SIGN_POPUP) == 0 then
        cc.exports.SIGN_POPUP = checkint(SIGN_POPUP) + 1
        -- 尝试显示签到界面
        self:popSignView()
    end

    -- 尝试弹出新手/VIP超值礼包
    self:popGiftView()

    -- 检查是否有推送的活动
    gg.ActivityPageCtrl:doCheckPush()

    -- 检查推送的公告和个人消息
    gg.UserData:CheckPushMsg()
end

-- 是否弹出迎新红包界面
-- function M:showNewUserGift()
--     local newGiftView = self:getScene():getChildByName("NewUserGiftView")
--     if newGiftView then
--         return
--     end
--     newGiftView = self:getScene():createView("NewUserGiftView")
--     newGiftView:pushInScene()
--     newGiftView:setPopViewCallback(handler(self, self.popGiftView))

--     local function removeEvent_(view)
--         newGiftView:setVisible(false)
--         view:addRemoveListener(function()
--             newGiftView:playEnterAni()
--         end)
--     end
--     -- 如果存在选择地区的界面，先隐藏掉新手红包界面
--     local provinceView = self:getScene():getChildByName("login/ProvinceMapView")
--     local areaView = self:getScene():getChildByName("login/AreaMapView")
--     if provinceView then
--         removeEvent_(provinceView)
--     elseif areaView then
--         removeEvent_(areaView)
--     else
--         newGiftView:playEnterAni()
--     end
-- end

-- 刷新公告未读数量
function M:refreshUnreadNum()
	if tolua.isnull(self) then return end
    -- 本地未读取的数据
	local localNoticeCnt = require("hall.models.AnnounceData"):getNotReadNum()
	local localMsgCnt = require("hall.models.MymsgData"):getNotReadNum()
	-- web接口通知的未读数据
	local newNoticeCnt = gg.UserData:GetNoticeCount()
	local newMsgCnt = gg.UserData:GetUserMsgCount()

    local unreadCnt = localNoticeCnt + newNoticeCnt + localMsgCnt + newMsgCnt
    local ico_bubble = self.btn_notice:findNode("ico_bubble")
    local txt_msgcnt = self.btn_notice:findNode("txt_msgcnt")
    ico_bubble:setVisible(unreadCnt > 0)
    if unreadCnt >= 100 then
        txt_msgcnt:setString("99+")
        ico_bubble:setContentSize(cc.size(42, 32))
        txt_msgcnt:setPositionX(21)
    else
        txt_msgcnt:setString(unreadCnt)
        ico_bubble:setContentSize(cc.size(33, 32))
    end
end

--==============================--
-- 点击事件
--==============================--
-- 个人资料
function M:onClickUserinfo()
    gg.AudioManager:playClickEffect()
    if GameApp:CheckModuleEnable(ModuleTag.PersonInfo) then
	    self:getScene():createView("personal.PersonMainView", "info"):pushInScene()
    end
end

-- 公告消息
function M:onClickNotice()
    gg.AudioManager:playClickEffect()
    GameApp:dispatchEvent(gg.Event.SHOW_VIEW, "announcement.MessageView", {push = true, popup = true})
end

-- 显示设置菜单
function M:onClickSetting()
    gg.AudioManager:playClickEffect()
    self:getScene():createView("HallRightMenuView"):pushInScene()
end

-- 大师赛
function M:onClickArena()
    gg.AudioManager:playClickEffect()
    GameApp:DoShell(self:getScene(), "Challenge://1")
end

-- 每日分享
function M:onClickShare()
    gg.AudioManager:playClickEffect()
    self:getScene():createView("share.ShareView"):pushInScene()
end

-- 最贵月卡
function M:onClickMonthCard()
    gg.AudioManager:playClickEffect()
    self:getScene():createView("active.ActivityView", {first_but_tag = 2}):pushInScene()
end

-- 商城
function M:onClickShop()
    gg.AudioManager:playClickEffect()
    GameApp:DoShell(self:getScene(), "Store://bean")
end

-- 活动
function M:onClickActivity()
    gg.AudioManager:playClickEffect()
    self:getScene():createView("active.ActivityView"):pushInScene()
end

-- 兑换
function M:onClickExchange()
    --礼品卷 "lipin"，话费标签：huafei，红包标签："hongbao" 兑换记录："duihuan"
    self:getScene():createView("gift.GiftView","lipin"):pushInScene()
end

-- 背包
function M:onClickBag()
    gg.AudioManager:playClickEffect()
    self:getScene():createView("BagMainView", true):pushInScene()
end

-- 显示好友房菜单
function M:onClickFriendRoom()
    gg.AudioManager:playClickEffect()
    if checkint(PACKAGE_TYPE) == 2 then
        self:joinGameRoom()
        self:getScene():getChildByName("HallMainView"):enterGameAction()
        self:getScene():createView("room.FriendRoomEntranceView"):pushInScene()
    else
        self:getScene():createView("newhall.HallRoomMenu"):pushInScene()
    end
end

-- 福利
function M:onClickFuli()
    gg.AudioManager:playClickEffect()
    self:getScene():createView("welfare.WelfareView"):pushInScene()

    -- 360渠道每天前五次需要弹出广告提示
    if gg.GetNativeVersion() < 6 or not (CHANNEL_ID == "201" and IS_SHOWAD) then return end
    local adPopDate = gg.UserData:getConfigByKey("adPopDate")
    local adPopTimes = checkint(gg.UserData:getConfigByKey("adPopTimes"))
    local date = os.date("%Y%m%d", os.time())
    if not adPopDate or adPopDate ~= date then
        device.showAD()
        gg.UserData:SetConfigKV({["adPopDate"] = date})
        gg.UserData:SetConfigKV({["adPopTimes"] = 1})
    elseif (adPopDate == date and adPopTimes < 5) then
        device.showAD()
        gg.UserData:SetConfigKV({["adPopTimes"] = adPopTimes + 1})
    end
end

-- 荣誉系统
function M:onClickHonor()
    gg.AudioManager:playClickEffect()
    self:getScene():createView("honor.HonorMainView"):pushInScene()
end

--地区的选择
function M:onClickDiQu()
    gg.AudioManager:playClickEffect()
    GameApp:CreateSelectAreaView(true)
end

-- 播放免费豆按钮动画
function M:playWelfareBtnAni(isplay)
    if not GameApp:CheckModuleEnable(ModuleTag.FreeWelfare) then
        return
    end
    self.ani_mfd1:setVisible(isplay)
    self.img_mfd2:setVisible(isplay)
    self.img_mfd:setVisible(not isplay)
    if isplay then
        self.nd_bottom.animation:play("ani_mfd", true)
    else
        self.nd_bottom.animation:stop()
    end
end

-- 播放活动按钮动画
function M:playActivityBtnAni(isplay)
    if not GameApp:CheckModuleEnable(ModuleTag.Activity) then
        return
    end
    self.ani_act:setVisible(isplay)
    if isplay then
        local seq = cc.RepeatForever:create(cc.Sequence:create(cc.FadeIn:create(1), cc.FadeOut:create(1)))
        self.ani_act:runAction(seq)
    else
        self.ani_act:stopAllActions()
    end
end

-- 播放月卡领取动画
function M:playMonthCardAni(isplay)
    if not GameApp:CheckModuleEnable(ModuleTag.Privilege) and not GameApp:CheckModuleEnable(ModuleTag.XYMonthCard) then
        return
    end
    self.btn_month_card:getChildByName("img_ljlq"):setVisible(isplay)
    self.btn_month_card:getChildByName("img_zgyk"):setVisible(not isplay)
    if isplay then
        self.ani_card.animation:play("ani_card", true)
    else
        self.ani_card.animation:stop()
    end
end

-- 播放首次分享提示动画
function M:playShareAni(isplay)
    if not GameApp:CheckModuleEnable(ModuleTag.WeixinShare) then
        return
    end
    self.ani_share:getChildByName("particle_ani"):setVisible(isplay)
    if isplay then
        self.ani_share.animation:play("ani_share", true)
    else
        self.ani_share.animation:stop()
    end
end

function M:popGiftView()
    if not hallmanager then return end
    -- 新注册用户不弹出
    local loginTimes = checkint(hallmanager:GetEffortData(0))
    if loginTimes == 1 or (REGION_CODE == 0 and loginTimes <= 2) then
        -- 记录一下第一次登录的弹出时间
        gg.UserData:SetConfigKV({["lastlogindate"] = os.date("%Y%m%d", os.time())})
        return
    end

    -- 用户每天第一次登录不弹出
    local loginDate = gg.UserData:getConfigByKey("lastlogindate")
    if not loginDate or loginDate ~= os.date("%Y%m%d", os.time()) then
        print("用户每天第一次登录不弹出")
        -- 家乡棋牌包选择完地区会再周一次断线重连，所以在第一次登录时先将控制字段设置为“-1”
        local provinceView = self:getChildByName("login/ProvinceMapView")
        if REGION_CODE == 0 and provinceView then
            if loginDate == "-1" then
                gg.UserData:SetConfigKV({["lastlogindate"] = os.date("%Y%m%d", os.time())})
            else
                gg.UserData:SetConfigKV({["lastlogindate"] = "-1"})
            end
        else
            gg.UserData:SetConfigKV({["lastlogindate"] = os.date("%Y%m%d", os.time())})
        end
        return
    end
    local goodsId = gg.PopupGoodsCtrl:getFirstPayOrVIPGoods()
    if not goodsId then return end
    -- 如果上次弹出时间超过3小时或今日还未弹出，则弹出对应礼包界面
    local popTime = gg.PopupGoodsData:getLastPopTS(goodsId)
    -- 在大厅场景且不在 H5 游戏中才能弹出
    local curScene = GameApp:getRunningScene()
    if curScene.name_ == "HallScene" and (not gg.WebGameCtrl:isInWebGame()) and
       (not popTime or checkint(os.time()) >= checkint(popTime) + POP_TIME_LIMIT) then
        local popView = gg.PopupGoodsCtrl:popupGoodsView(goodsId)
        -- 地区包由于没有全国地图作为背景，所以先暂时将礼包界面隐藏
        local areaView = self:getScene():getChildByName("login/AreaMapView")

        if areaView then
            popView:setVisible(false)
        end
    end
end

function M:popSignView()
    -- 苹果审核模式不弹出
    if device.platform == "ios" and IS_REVIEW_MODE then return end

    --显示签到页面
    local signType, IsSign = welfareData:isShowSign()
    if not IsSign then
        if signType == 94 then
            -- 显示新手签到界面
            GameApp:dispatchEvent(gg.Event.SHOW_VIEW, "welfare.WelfareXsqdActive", {push = true, popup = true})
        elseif signType == 96 then
            -- 显示每日签到界面
            GameApp:dispatchEvent(gg.Event.SHOW_VIEW, "welfare.WelfareMrqdActive", {push = true, popup = true})
        end
    end
end

return M
