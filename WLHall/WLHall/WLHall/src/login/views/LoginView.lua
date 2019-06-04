local LoginView = class("LoginView", cc.load("ViewBase"))

-- LoginView.AUTO_RESOLUTION = true
LoginView.RESOURCE_FILENAME = "ui/login/login_layer.lua"
LoginView.RESOURCE_BINDING = {
    ["logo_node"] = { ["varname"] = "logo_node" }, --
    ["btn_contact"] = { ["varname"] = "btn_contact", ["events"] = { { event = "click", method = "onClickCustomService_" } } }, -- 联系客服
    ["btn_repair"] = { ["varname"] = "btn_repair", ["events"] = { { event = "click", method = "onClickFix_" } } }, -- 修复

    ["panel_bg"] = { ["varname"] = "panel_bg" },                                                                     -- 按钮底边
    ["img_logo"] = { ["varname"] = "img_logo" },                                                               -- 点击清除缓存
}

local LoginButtonView = import(".LoginButtonView")

local brand = BRAND == 0 and USER_FROM_JIXIANG or USER_FROM_PLATFORM

function LoginView:onCreate(loginmgr, ...)
    -- 按钮栏适配
    if display.width / display.height == 4/3 then
        self.panel_bg:setScale(display.scaleX)
    else
        self.panel_bg:setContentSize(cc.size(display.width, self.panel_bg:getContentSize().height))
    end

    self:createProtocolNode()

    self.loginmgr_ = loginmgr
    self.avaiable_login_type = gg.LoginHelper.loginTypes[CHANNEL_ID]
    --点击计数
    self._clickCount = 0
    -- 设置版本号的点击
    self.img_logo:onClick( handler( self, self.onTouchVerBg ) )

    if self.avaiable_login_type == nil then
        -- 正常模式
        self.avaiable_login_type = {brand, USER_FROM_UNLOGIN, USER_FROM_WECHAT}
    end

    if not GameApp:CheckModuleEnable(ModuleTag.GuestLogin) then
        -- 指定不能用游客登录
        for i,v in ipairs(self.avaiable_login_type) do
            if v==USER_FROM_UNLOGIN then
                table.remove(self.avaiable_login_type, i)
            end
        end
    end

    if not GameApp:CheckModuleEnable(ModuleTag.WeixinLogin) then
        -- 指定不能用微信登录
        for i,v in ipairs(self.avaiable_login_type) do
            if v==USER_FROM_WECHAT then
                table.remove(self.avaiable_login_type, i)
            end
        end
    end

    if BRAND==0 then
        self.logo_node:findNode("img_logo"):loadTexture(CUR_PLATFORM.."/img_logo.png",0)
    end

    local startPosX, space = 0, 0
    if #self.avaiable_login_type == 1 then
        startPosX, space = 0, 0
    elseif #self.avaiable_login_type == 2 then
        startPosX, space = -212, 120
    elseif #self.avaiable_login_type == 3 then
        startPosX, space = -374, 50
    else
        print("还没有考虑过有四个登录方式的情况，请添加")
    end

    local offsetX = startPosX
    for index = 1, #self.avaiable_login_type do
        local btn = LoginButtonView.new("LoginButtonView", self.avaiable_login_type[index])
        self.panel_bg:addChild(btn)
        btn:setVisible(true)
        btn:setPosition(cc.p(self.panel_bg:getContentSize().width / 2 + offsetX, 65))
        offsetX = offsetX + space + 324
    end

    self.logo_node:posByScreen(cc.p(Alignment.LEFT, Alignment.TOP), 0, -250)
    self.btn_contact:posByScreen(cc.p(Alignment.RIGHT, Alignment.TOP), -121, -57)
    self.btn_repair:posByScreen(cc.p(Alignment.RIGHT, Alignment.TOP), -285, -57)

    gg.AddVersionTo(self) --填加版本号显示
    local banhao,benan=gg.LocalConfig:GetCopyRightInfo()
    self.logo_node:findNode("text_approval1"):setString(banhao or "")
    self.logo_node:findNode("text_approval2"):setString(benan or "")
    
    -- 开关检测
    self:checkSwitch()
end

--[[
* @brief 开关检测
]]
function LoginView:checkSwitch()
    -- 联系客服
    if not GameApp:CheckModuleEnable( ModuleTag.CustomerService ) then
        self.btn_contact:setVisible(false)
        -- 调整修复按钮的位置
        self.btn_repair:posByScreen(cc.p(Alignment.RIGHT, Alignment.TOP), -121, -57)
    end

    if IS_REVIEW_MODE then
        self.btn_repair:setVisible(false)
    end

    if not GameApp:CheckModuleEnable(ModuleTag.Unimplemented) then
        self.btn_repair:setVisible(false)
    end
end

function LoginView:onClickCustomService_(...)
    -- 播放点击音效
    gg.AudioManager:playClickEffect()
    device.callCustomerServiceApi(ModuleTag.Login)
    printf("LoginView:onService")
    -- local url = gg.Dapi:GeServicetUrl( ModuleTag.Login )
    -- GameApp:dispatchEvent(gg.Event.SHOW_VIEW,"GeneralWebView",{ push = false} , url , "联系客服")
end


--[[
* @brief 版本号的点击
]]
function LoginView:onTouchVerBg( sender )
    --获取时间
    local curClickTime = socket.gettime()
    local spaceTime = 1
    --设置第一次点击默认快速点击
    if self._clickCount == 0 then
        sender._lastClickTime = curClickTime
    end
    -- 判断是否快速点击
    if sender._lastClickTime and  (curClickTime - sender._lastClickTime <= spaceTime) then
        self._clickCount  = self._clickCount + 1
        if self._clickCount == 3 then
            DEBUG = 2
            print("---- DEBUG Enabled ----")
            -- add by John 2018/09/25 显示打包文件夹时间戳
            if type(PACKAGE_TIMESTAMP) == "string" then
                self:showPackageTimestamp(PACKAGE_TIMESTAMP)
            end
        end

        if self._clickCount >=5 then
            printf( "清除文件缓存!" )
            gg.ClearHotCache()
            self._clickCount = 0
        end
    else
        self._clickCount = 0
    end
    sender._lastClickTime = curClickTime
end

-- add by John 显示打包时间戳
function LoginView:showPackageTimestamp(str)
    if not self._packageTimestampLab then
        local lab =  cc.Label:createWithSystemFont(str, "Arial", 14)
        lab:setAnchorPoint(cc.p(0.5,1))
        lab:setPosition(cc.p(display.width / 2, display.height-2))
        lab:setColor(cc.c3b(110,110,110))
        self._packageTimestampLab = lab
        self:addChild(lab,1,100)
    elseif not tolua.isnull(self._packageTimestampLab) then
        self._packageTimestampLab:setString(str)
    end
end


function LoginView:onClickFix_(...)
    -- 播放点击音效
    gg.AudioManager:playClickEffect()
    self:showToast("功能暂未开放")
end

-----------------------------------------------
-- 用户协议
-----------------------------------------------
function LoginView:createProtocolNode()
    local root = require("res.ui.login.user_protocol_node").create().root
    local nd_prot = root:getChildByName("img_di")
    nd_prot:removeFromParent(true)
    nd_prot:setPosition(cc.p(self.panel_bg:getContentSize().width / 2, self.panel_bg:getContentSize().height))

    local btn_agree = nd_prot:getChildByName("btn_agree")
    btn_agree:addTouchEventListener(handler(self, self.onClickAgreeBtn))
    -- 默认为勾选状态
    local cb_agree = btn_agree:getChildByName("cb_agree")
    cb_agree:setSelected(true)
    cc.exports.IS_AGREE_USER_PROTOCOL = true

    local btn_prot = nd_prot:getChildByName("btn_prot")
    btn_prot:onClick(handler(self, self.onClickUserProtocol))

    self.nd_prot = nd_prot
    self.panel_bg:addChild(nd_prot)
end

function LoginView:onClickAgreeBtn(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        local cb_agree = self.nd_prot:findNode("cb_agree")
        cb_agree:setSelected(not cb_agree:isSelected())
        cc.exports.IS_AGREE_USER_PROTOCOL = cb_agree:isSelected()
        cc.UserDefault:getInstance():setIntegerForKey("AgreeUserProtocol", gg.IIF(cb_agree:isSelected(), 1, 0))
    end
end

function LoginView:onClickUserProtocol(sender)
    local function getRegion_()
        local region= gg.LocalConfig:GetRegionCode()
        if  checkint(region)==0 then
           region = REGION_CODE
        end
        region = gg.StringAppend(region, 0, 6)
        return region
    end

    local ver_str = gg.GetHallVerison()
    local common_ver = gg.VersionHelper:getModuleClientVer(gg.VersionHelper.VER_MODULE_GAME_COMMON)
    local hall_ver= gg.VersionHelper:getModuleClientVer(gg.VersionHelper.VER_MODULE_HALL)
    local url = string.format("https://u.%s/deal/%s/%s/%s.%s.%s/%s", WEB_DOMAIN, APP_ID, CHANNEL_ID, ver_str, common_ver, hall_ver, getRegion_())
    print("url:", url)
    device.openURL(url)
end

return LoginView


