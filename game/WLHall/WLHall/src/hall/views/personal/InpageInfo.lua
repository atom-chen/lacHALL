--
-- Author: chen weijin
-- Date: 2016-08-29 15:24:25
-- Describe：我的资料

local InpageInfo = class("InpageInfo", cc.load("ViewBase"))

InpageInfo.RESOURCE_FILENAME="ui/person_info/inpage_myinfo.lua"

InpageInfo.RESOURCE_BINDING = {
    ["node_head"]         = {["varname"] = "node_head"},
    ["txt_account"]     = {["varname"] = "txt_account"},
    ["txt_id"]             = {["varname"] = "txt_id"},
    ["info_honor"]      = {["varname"] = "info_honor"},
    ["txt_vip"]         = {["varname"] = "txt_vip"},
    ["img_vip"]         = {["varname"] = "img_vip"},
    ["txt_vip_info"]     = {["varname"] = "txt_vip_info"},
    ["txt_no_vip"]      = {["varname"] = "txt_no_vip"},
    ["txt_nickname"]     = {["varname"] = "txt_nickname"},
    ["txt_phone"]         = {["varname"] = "txt_phone"},
    ["txt_personid"]     = {["varname"] = "txt_personid"},

    ["btn_introduce"]     = {["varname"] = "btn_introduce",["events"]={{event="click",method="onIntroduce"}} },
    ["btn_change"]         = {["varname"] = "btn_change",["events"]={{event="click",method="onChange"}} },
    ["btn_male"]        = {["varname"] = "btn_male",["events"]={{event="click",method="onSexClicked"}} },
    ["btn_female"]      = {["varname"] = "btn_female",["events"]={{event="click",method="onSexClicked"}} },
    ["male_select"]     = {["varname"] = "male_select"},
    ["female_select"]   = {["varname"] = "female_select"},

    ["head_bottom"]     = {["varname"] = "head_bottom",["events"]={{event="click_color",method="onUploadAvatar"}} },
    ["panel_head"]      = {["varname"] = "panel_head",["events"]={{event="click_color",method="onUploadAvatar"}} },

    ["btn_vip"]         = {["varname"] = "btn_vip",["events"]={{event="click",method="onClickVipTq"}} },                -- VIP特权
    ["btn_change_phone"] = {["varname"] = "btn_change_phone",["events"]={{event="click",method="onClickChangePhone"}} },-- 更换手机号
    ["panel_personid"]  = {["varname"] = "panel_personid"},
    ["panel_phone"]     = {["varname"] = "panel_phone"},
    ["nd_honor"]     = {["varname"] = "nd_honor"},

    ["img_vipbg"]         = {["varname"] = "img_vipbg"},
    ["Text_2"]         = {["varname"] = "Text_2"},   --id文本

}

local SEX_MALE = 1      -- 男性为1
local SEX_FEMALE = 0    -- 女性为0

function InpageInfo:onCreate( ... )
    self.headSprite_=nil
    self.isEditBegin = false
    -- if device.platform == "windows" then
    self:initWinEditBox("txt_nickname")
   self.txt_nickname:setFontColor({r=119, g=119, b=119})
    self:changeSex(SEX_MALE)     -- 初始性别为男

    self:updateView()

     local preStr = ""
     local changeNickNameHandle = function (strEventName,pSender )
         if strEventName == "began" then
             preStr = pSender:getString()
             self.isEditBegin = true
         elseif strEventName == "ended" then
             local nickname = pSender:getString()
             gg.CallAfter(0.1,handler(self, self.onReSetEditStatus))
             -- 检查是否可以修改昵称
             if not self:canDoChange(true) then
                pSender:setString(preStr)
                return
             end

             if nickname ~= preStr then
                 if nickname == "" then
                    pSender:setString(preStr)
                 end
                 local callback = function (x)
                     if x.status == 0 then
                         -- 刷新玩家信息
                         GameApp:dispatchEvent(gg.Event.HALL_UPDATE_USER_DATA)
                         GameApp:dispatchEvent(gg.Event.SHOW_TOAST, x.msg or "昵称修改成功！")
                     else
                         if tolua.isnull(self) then return end
                         self.txt_nickname:setString(preStr)
                     end
                 end
                 gg.Dapi:ChangeNickName(nickname,callback)
             end
         end
     end

     self.txt_nickname:registerScriptEditBoxHandler(changeNickNameHandle)

     -- 注册通知
     self:registerEventListener()

    -- 开关检测
    self:checkSwitch()
end

function InpageInfo:onReSetEditStatus(obj)
    if tolua.isnull(self) then return end
    self.isEditBegin = false
end

function InpageInfo:onSexClicked(obj)
    -- 男为 1， 女为 0
    self:changeSex(gg.IIF(obj == self.btn_male, SEX_MALE, SEX_FEMALE), true)
end

function InpageInfo:changeSex(idx, doChange)
    if self.curSex == idx then
        return
    end

    self.curSex = idx
    self.male_select:setVisible(self.curSex == SEX_MALE)
    self.female_select:setVisible(self.curSex ~= SEX_MALE)

    if doChange then
        -- 只有点击按钮的时候，需要通知服务器进行修改
        local callback = function(x)
            if x.status == 0 then
                -- 发送通知
                --GameApp:dispatchEvent( gg.Event.HALL_CHANGE_SEX )
                print( "修改性别成功！" )
            else
                print( "修改性别失败！" )

            end
        end

        -- 发送修改性别请求
        gg.Dapi:ModifySex(gg.IIF(self.curSex == SEX_MALE, SEX_MALE, SEX_FEMALE),callback)
    end
end

--[[
* @brief 开关检测
]]
function InpageInfo:checkSwitch()

    -- 更换手机
    if not GameApp:CheckModuleEnable( ModuleTag.P_ACTIVATE ) then
        self.panel_phone:setVisible(false)
        self.btn_change_phone:setVisible(false)
    end

    -- 实名认证
    if not GameApp:CheckModuleEnable( ModuleTag.P_REALNAME ) then

        self.panel_personid:setVisible(false)
    end

    -- vip
    if not GameApp:CheckModuleEnable( ModuleTag.VIP ) then

        self.img_vip:setVisible(false)
        self.btn_vip:setVisible(false)
    end

    -- 荣誉
    if IS_REVIEW_MODE or not GameApp:CheckModuleEnable(ModuleTag.Honor) then
        self.info_honor:setVisible(false)
        self.btn_introduce:setVisible(false)
        -- 如果荣誉系统隐藏了，vip显示，则调整vip的坐标
        if self.img_vip:isVisible() then
            self.img_vip:setPositionY(self.img_vip:getPositionY() + 88)
            self.btn_vip:setPositionY(self.btn_vip:getPositionY() +88)
            self:findNode("line_4"):setVisible(false)
        end
    end

end

--[[
* @brief 注册消息通知
]]
function InpageInfo:registerEventListener()

    -- 游客账号激活通知
    self:addEventListener(gg.Event.HALL_ACTIVATE_USER, handler(self, self.onEventActivateUser) )

    -- 手机绑定解绑通知
    self:addEventListener(gg.Event.HALL_BIND_PHONE, handler(self, self.onEventBindPhone) )

    -- 手机激活通知
    self:addEventListener(gg.Event.HALL_ACTIVATE_USER_PHONE, handler(self, self.onEventActivateUserPhone) )

     -- 用户数据变化通知
    self:addEventListener(gg.Event.HALL_UPDATE_USER_DATA, handler( self, self.onEventUpdateUserData )  )

    -- 微信激活通知
    self:addEventListener(gg.Event.HALL_ACTIVATE_USER_WX, handler(self, self.onEventActivateUserWx) )
end

--[[
* @brief 账号激活通知
]]
function InpageInfo:onEventActivateUser( event )

    self:updateView()
end

--[[
* @brief 手机绑定解绑通知
* @param phone 绑定手机号 (phone为空的时候为解绑操作)
]]
function InpageInfo:onEventBindPhone( event , phone )
    if phone then
        gg.UserData:UpdateWebDate("phone",string.sub(phone,#phone - 3,#phone))
    end

    self:onUpdateUserData(hallmanager.userinfo)
end

--[[
* @brief 手机激活通知
* @param phone 激活手机号
* @param idCard 身份证号
]]
function InpageInfo:onEventActivateUserPhone( event , phone )

    -- 修改显示手机号
    gg.UserData:UpdateWebDate("phone",string.sub(phone,#phone - 3,#phone))

    -- 刷新账号
    gg.Cookies:GetDefRole().username = phone or ""
    gg.UserData:SetPhoneInfo( phone or "" )

    -- 更改玩家来源
    if hallmanager and hallmanager.userinfo.userfrom then

        hallmanager.userinfo.userfrom = BRAND==0 and USER_FROM_JIXIANG or USER_FROM_PLATFORM
    end

    -- 修改显示身份证号
    self:updateView()
end

--[[
* @brief 微信激活通知
]]
function InpageInfo:onEventActivateUserWx( event )

    self:updateView()
end

--[[
* @brief 手机激活通知
* @param phone 激活手机号
* @param idCard 身份证号
]]
function InpageInfo:onEventUpdateUserData( event )
    self:updateView()
end

function InpageInfo:updateView()
    if hallmanager and hallmanager.userinfo then
         self:onUpdateUserData(hallmanager.userinfo)
     end
end

-- 介绍
function InpageInfo:onIntroduce( ... )
    self:getScene():createView("honor.HonorMainView"):pushInScene()
end

function InpageInfo:onChange( ... )
    if self.isEditBegin then
        return
    end

    -- 检查是否可以修改昵称
    if  not self:canDoChange(true) then
        return
    end

    -- 开始编辑昵称
    self.txt_nickname:touchDownAction(self.txt_nickname, ccui.TouchEventType.ended)
end

--[[
* @brief 更新玩家信息
]]
function InpageInfo:onUpdateUserData(userinfo)

    local hdurl
    if userinfo.avatar == 0xFFFFFFFF then
        hdurl = userinfo.avatarurl
    end
    self:onUpdateHead(hdurl,userinfo.sex)
    self:changeSex(gg.IIF(userinfo.sex == SEX_MALE, SEX_MALE, SEX_FEMALE))

    self.txt_id:setString(string.format("%d",userinfo.id))
    --设置id的位置
    self.Text_2:setPositionX( self.txt_id:getPositionX() - self.txt_id:getSize().width)
    self.txt_nickname:setString(userinfo.nick)

    -- 刷新手机号信息
    self:updatePhone()

    -- 刷新身份证号信息
    self:updateIDCardInfo()

    -- local isActivited = gg.UserData:isActivited()
    -- local aName = gg.IIF(isActivited, checktable(gg.Cookies:GetDefRole()).username,"未激活")
    -- self.txt_account:setString(aName)
    self.txt_account:setString(gg.UserData:GetAccountName())

    -- self.txt_account:setString(userinfo.id)

    -- 设置VIP等级
    local lv , minexp , maxexp = gg.GetVipLevel( userinfo.vipvalue )
    local maxLevel = #(gg.GetVipTable()) - 1
    self.txt_no_vip:setVisible(lv <= 0)
    self.txt_vip:setVisible(lv > 0)
    self.img_vipbg:setVisible(lv > 0)
    self.txt_vip_info:setVisible(lv > 0)
    if lv > 0 then
        self.txt_vip:setString(lv)

        -- 设置VIP经验
        if lv >= maxLevel then
            self.txt_vip_info:setString("(MAX)")
        else
            self.txt_vip_info:setString( string.format( "(%d/%d)" , userinfo.vipvalue - minexp , maxexp - minexp)  )
        end
    end

    local vipNode = self.img_vip:getChildByName("VIP_LEVEL_NODE")
    -- 先移除之前的节点
    if vipNode then
        self.img_vip:removeChild(vipNode)
    end
    -- 重新生成一个节点加入节点树，这样保证是最新的 vip 等级
    -- vipNode = gg.GetVipLevelNode(lv)
    -- vipNode:setName("VIP_LEVEL_NODE")
    -- vipNode:setScale(1.5)
    -- vipNode:setPositionX(self.img_vip_tq:getPositionX()-40)
    -- vipNode:setPositionY(self.img_vip_tq:getPositionY())
    -- self.img_vip:addChild(vipNode)

    --荣誉星星显示
    self:updateHonorNStar()
end

function InpageInfo:onUpdateNick(nickname)

end

function InpageInfo:onUpdateUserId(userid)

end

function InpageInfo:refreshHeadTexture(url)
    local hd_sprite=self.headSprite_
    if hd_sprite then
        hd_sprite:retain()

         local file_uri = gg.ImageDownload:Start(url, function(ret_path,err_msg)
            if ret_path then
                printf("InpageInfo refreshHeadTexture------"..ret_path)
                    hd_sprite:setTexture(ret_path)
                  local spSize= hd_sprite:getContentSize()
                hd_sprite:setScale(248/spSize.width)
            end
            hd_sprite:release()
         end)
    end
end

-- 检查玩家是否可以修改昵称和头像
function InpageInfo:canDoChange(isNick)
    if hallmanager and hallmanager.userinfo then
        if hallmanager.userinfo.userfrom == USER_FROM_UNLOGIN then
            GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG, "请先激活账号！", function(bttype)
                if bttype == gg.MessageDialog.EVENT_TYPE_OK then
                    local view = self:getScene():getChildByName("personal.PersonMainView")
                    if view then
                        -- 跳转到激活账号页面
                        --view:selectPage("bind")
                        view:selectTab("bind")
                    end
                end
            end, { mode=gg.MessageDialog.MODE_OK_CLOSE, ok="激活账号"})
            return false
        end

        if hallmanager.userinfo.userfrom == USER_FROM_WECHAT then
            -- 微信用户不能修改
            local tipStr = gg.IIF(isNick, "昵称", "头像")
            GameApp:dispatchEvent(gg.Event.SHOW_TOAST, string.format("微信用户不能修改%s！", tipStr))
            return false
        end

        if not isNick then
            local from = BRAND==0 and USER_FROM_JIXIANG or USER_FROM_PLATFORM
            if hallmanager.userinfo.userfrom == from then
                if hallmanager.userinfo.avatar == 0xFFFFFFFF then
                    -- 平台用户且已修改过头像，不能再修改
                    GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "您已更换过头像，不能再更换了！")
                    return false
                else
                    -- 提示用户头像只能修改一次
                    GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "请注意：头像只能更换一次！")
                end
            end
        end
    end

    return true
end

function InpageInfo:onUpdateHead(url,sex)

    local  hd_default=gg.IIF(sex==1, "common/hd_male.png","common/hd_female.png")
    local sprite= display.newSprite(hd_default)
    self.headSprite_=sprite

    if  url and string.lower(string.sub(url,1,4))=="http" then
        self:refreshHeadTexture(url)
    end
    sprite:setAnchorPoint(cc.p(0,0))
    sprite:setPosition(1,1)
    local spSize = sprite:getContentSize()
    sprite:setScale(214/spSize.width)
    local drawNode = gg.DrawNodeRoundRect(cc.DrawNode:create(), cc.rect(0,0,214,-(214)), 1, 15, cc.c4b(0,0,0,1),cc.c4f(0,0,0,1))
    local clipNode = cc.ClippingNode:create(drawNode)
    clipNode:setInverted(false)
    --clipNode:setAlphaThreshold(0)
    self.node_head:addChild(clipNode,-1)
    clipNode:addChild(sprite)

end

-- 上传头像点击事件
function InpageInfo:onUploadAvatar(sender)
    -- 检查是否可以修改头像
    if not self:canDoChange(false) then
        return
    end

    GameApp:dispatchEvent(gg.Event.SHOW_VIEW,"personal.UploadAvatar",{ push = true , popup = true  } )
end

--[[
* @brief 打开VIP特权
]]
function InpageInfo:onClickVipTq( sender )

    self:getScene():createView("store.VipDetailed"):pushInScene()
end

-- --[[
-- * @brief 续费按钮
-- ]]
-- function InpageInfo:onClickXF( sender )

--     -- 打开商城
--     -- self:getScene():createView("store.StoreView" , 3):pushInScene()
--     GameApp:DoShell( self:getScene(), "Store://diamond")
-- end

--[[
* @brief 更换手机号
]]
function InpageInfo:onClickChangePhone( sender )

    self:getScene():createView("personal.ChangePhoneView",self):pushInScene()
end

--[[
* @brief 身份认证
]]
function InpageInfo:onClickAuthenticate( sender )

    self:getScene():createView("personal.AuthenticateView",self):pushInScene()
end

--[[
* @brief 刷新身份证信息
]]
function InpageInfo:updateIDCardInfo()
    local idCard, isBindIDCard = gg.UserData:GetIdCardSuffix()
    self.txt_personid:setString(idCard)
    self.txt_personid:setFontSize(gg.IIF(isBindIDCard, 34, 30))
end

--[[
* @brief 刷新手机号
]]
function InpageInfo:updatePhone()
    if not GameApp:CheckModuleEnable( ModuleTag.P_ACTIVATE ) then
        -- 激活功能未开的时候，不更新手机号相关信息
        return
    end

    local p , isBindPhone , phone = gg.UserData:GetPhoneSuffix()
    self.txt_phone:setString(p)
    local from= BRAND==0 and USER_FROM_JIXIANG or USER_FROM_PLATFORM
    --判断是否为原平台或者吉祥平台
    local platform =  hallmanager and hallmanager.userinfo and hallmanager.userinfo.userfrom == from
    self.btn_change_phone:setVisible(platform and gg.Cookies:GetDefRole().username == phone)
    self.txt_phone:setFontSize(gg.IIF(isBindPhone, 34, 30))
    -- self.panel_ghsjh:setVisible( gg.Cookies:GetDefRole().username == phone )
end

--[[
* @brief 刷新账号信息
]]
function InpageInfo:updateUserName( account )

    gg.Cookies:GetDefRole().username = account
    self.txt_account:setString( account or "" )
end

--
-- -- 刷新荣誉等级段位显示
function InpageInfo:updateHonorNStar()
    if not hallmanager or not hallmanager.userinfo then return end
    -- 根据荣誉等级计算出用户所在的等级
    local hlvExp = hallmanager:GetHonorValue()
    local grade, star = gg.GetHonorGradeAndLevel(hlvExp)
    -- 设置等级图标
    cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/cup.plist")
    local img_cup = self.nd_honor:findNode("img_1")
    img_cup:ignoreContentAdaptWithSize(true)
    img_cup:loadTexture(string.format("hall/honor/grade_img_%d.png", grade), 1)
    img_cup:setScale(56 / img_cup:getContentSize().height)
    -- 初始星星数显示
    for i = 1 ,5 do
        self.nd_honor:findNode("star_" .. i):setPercent(0)
    end
    -- 设置星星数显示
    for i=1,star do
        self.nd_honor:findNode("star_" .. i):setPercent(100)
    end
    if star < 5 then
        local lv, minExp, nextExp= gg.GetHonorLevel(hlvExp)
        local percent = (hlvExp - minExp) / (nextExp - minExp) * 100
        self.nd_honor:findNode("star_" .. star + 1):setPercent(percent)
    end
end

return InpageInfo
