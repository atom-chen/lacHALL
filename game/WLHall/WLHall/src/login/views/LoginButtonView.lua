
-- Author: zhanghonghui
-- Date: 2017-07-03 17:17:20
-- Describe：登录按钮

local LoginButtonView = class("LoginButtonView" , cc.load("ViewLayout"))

LoginButtonView.RESOURCE_FILENAME = "ui/login/login_button.lua"

LoginButtonView.RESOURCE_BINDING = {
    ["btn"] = { ["varname"] = "btn", ["events"] = { { event = "click", method = "onClick" } } },    -- 按钮
    ["img_tips"] = { ["varname"] = "img_tips" },                                                    -- 文本
}

--[[
* @brief 创建
* @param type 登录类型
]]
function LoginButtonView:onCreate(type)

    assert(type , "type is nil")

    self._type = type                     -- 登录类型

    -- 初始化View
    self:initView()

    -- 添加进入退出监听
    self:enableNodeEvents()
end

--[[
* @brief 进入
]]
function LoginButtonView:onEnter()
    if IS_REVIEW_MODE then
        -- 审核模式不显示上次登录
        self.img_tips:setVisible(false)
        return
    end

    local lastRoleFrom = gg.Cookies:getLastRoleFrom()
    self.img_tips:setVisible(lastRoleFrom == self._type)
    -- 2017-12-30 by zhangbin 屏蔽微信注册送豆的提示
    -- if type(lastRoleFrom)=="number" and lastRoleFrom==-1 and self._type== USER_FROM_WECHAT then
    --     -- 还没有任何账号的登录信息时，提示：微信注册送10000豆提
    --     self.img_tips:setVisible(true)
    --     local text_tips= self.img_tips:findNode("text_tips")
    --     self.img_tips:setContentSize(300,64)
    --     if text_tips then
    --         text_tips:setString("微信注册送10000豆")
    --         text_tips:posBy(60)
    --     end
    -- else
    --     self.img_tips:setVisible(lastRoleFrom == self._type)
    -- end
end

--[[
* @brief 初始化View
]]
function LoginButtonView:initView()
    if (self._type == USER_FROM_PLATFORM) then
        cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/login.plist")
        self.btn:loadTextureNormal("hall/login/first/btn_wl.png",1)
        self.btn:loadTexturePressed("hall/login/first/btn_wl.png",1)
    elseif (self._type == USER_FROM_UNLOGIN) then
        cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/login.plist")
        self.btn:loadTextureNormal("hall/login/first/btn_yk.png",1)
        self.btn:loadTexturePressed("hall/login/first/btn_yk.png",1)
    elseif (self._type == USER_FROM_WECHAT) then
        cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/login.plist")
        self.btn:loadTextureNormal("hall/login/first/btn_wx.png",1)
        self.btn:loadTexturePressed("hall/login/first/btn_wx.png",1)
    elseif (self._type == USER_FROM_YSDK_QQ) then
        self.btn:loadTextureNormal("hall/login/first/btn_qq.png",0)
        self.btn:loadTexturePressed("hall/login/first/btn_qq.png",0)
    elseif (self._type == USER_FROM_YSDK_WX) then
        cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/login.plist")
        self.btn:loadTextureNormal("hall/login/first/btn_wx.png",1)
        self.btn:loadTexturePressed("hall/login/first/btn_wx.png",1)
    elseif (self._type == USER_FROM_VIVO) then
        -- VIVO 登录
        cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/login.plist")
        self.btn:loadTextureNormal("hall/login/first/btn_wl.png",1)
        self.btn:loadTexturePressed("hall/login/first/btn_wl.png",1)
    elseif (self._type == USER_FROM_OPPO) then
        -- OPPO 登录
        cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/login.plist")
        self.btn:loadTextureNormal("hall/login/first/btn_wl.png",1)
        self.btn:loadTexturePressed("hall/login/first/btn_wl.png",1)
    elseif (self._type == USER_FROM_XIAOMI) then
        -- 小米登录
        cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/login.plist")
        self.btn:loadTextureNormal("hall/login/first/btn_wl.png",1)
        self.btn:loadTexturePressed("hall/login/first/btn_wl.png",1)
    elseif (self._type == USER_FROM_HUAWEI) then
        cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/login.plist")
        self.btn:loadTextureNormal("hall/login/first/btn_wl.png",1)
        self.btn:loadTexturePressed("hall/login/first/btn_wl.png",1)
    elseif (self._type == USER_FROM_QIHOO) then
        -- 360 登陆
        self.btn:loadTextureNormal("hall/login/first/btn_360dl.png",0)
        self.btn:loadTexturePressed("hall/login/first/btn_360dl.png",0)
    elseif (self._type == USER_FROM_QIHOO + 1000) then
        -- 360 切换
        self.btn:loadTextureNormal("hall/login/first/btn_360qh.png",0)
        self.btn:loadTexturePressed("hall/login/first/btn_360qh.png",0)
    elseif self._type == USER_FROM_JIXIANG then
        -- jx 切换
        self.btn:loadTextureNormal(CUR_PLATFORM.. "/btn_account.png",0)
        self.btn:loadTexturePressed(CUR_PLATFORM.. "/btn_account.png",0)
    elseif self._type == USER_FROM_TOUTIAO then
        -- 头条登录
        cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/login.plist")
        self.btn:loadTextureNormal("hall/login/first/btn_wl.png",1)
        self.btn:loadTexturePressed("hall/login/first/btn_wl.png",1)
    elseif self._type == USER_FROM_MEIZU then
        -- 魅族登录
        cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/login.plist")
        self.btn:loadTextureNormal("hall/login/first/btn_wl.png",1)
        self.btn:loadTexturePressed("hall/login/first/btn_wl.png",1)
    elseif self._type == USER_FROM_SAMSUNG then
        -- 三星登录
        cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/login.plist")
        self.btn:loadTextureNormal("hall/login/first/btn_wl.png",1)
        self.btn:loadTexturePressed("hall/login/first/btn_wl.png",1)
    else
        print("unknown login type :"..tostring(self._type))
    end
end

--[[
* @brief 点击事件
]]
function LoginButtonView:onClick(sender)
    -- 播放点击音效
    gg.AudioManager:playClickEffect()

    if not self:checkCanDoLogin() then
        return
    end

    if (device.platform == "mac" or device.platform == "windows")
        and self._type ~= USER_FROM_PLATFORM
        and self._type ~= USER_FROM_JIXIANG
        and self._type ~= USER_FROM_UNLOGIN then
        -- mac 和 windows 用游客登录替代
        GameApp:dispatchEvent(gg.Event.SHOW_LOADING, device.platform .. " 平台用游客登录替代...")
        gg.LoginHelper:LoginByVistor()
        return
    end

    if (self._type == USER_FROM_PLATFORM) or self._type == USER_FROM_JIXIANG then
        self:onAccount()
    elseif (self._type == USER_FROM_UNLOGIN) then
        self:onTourist()
    elseif (self._type == USER_FROM_WECHAT) then
        self:onWechat()
    elseif (self._type == USER_FROM_YSDK_QQ) then
        self:onYSDKQQ()
    elseif (self._type == USER_FROM_YSDK_WX) then
        self:onYSDKWX()
    elseif (self._type == USER_FROM_VIVO) then
        -- VIVO 登录
        self:onVivoLogin()
    elseif (self._type == USER_FROM_OPPO) then
        -- OPPO 登录
        self:onOppoLogin()
    elseif (self._type == USER_FROM_XIAOMI) then
        -- 小米登录
        self:onXiaomiLogin()
    elseif (self._type == USER_FROM_HUAWEI) then
        -- 华为登录
        self:onHuaweiLogin()
    elseif (self._type == USER_FROM_QIHOO) then
        -- 360 登陆
        self:onQihooLogin()
    elseif (self._type == USER_FROM_QIHOO + 1000) then
        -- 360 切换账号
        self:onQihooSwitch()
    elseif (self._type == USER_FROM_TOUTIAO) then
        self:onToutiaoLogin()
    elseif (self._type == USER_FROM_MEIZU) then
        self:onMeizuLogin()
    elseif (self._type == USER_FROM_SAMSUNG) then
        self:onSamsungLogin()
    else
        print("unknown login type")
    end
end

--[[
* @brief 微信号登录
]]
function LoginButtonView:onWechat(sender)
    if not self:checkCanDoLogin() then
        return
    end

    printf("LoginView:onWechat(sender)")
    gg.LoginHelper:LoginByWX(true)
end

--[[
* @brief 游客登录
]]
function LoginButtonView:onTourist(sender)
    if not self:checkCanDoLogin() then
        return
    end

    -- 显示等待框
    GameApp:dispatchEvent(gg.Event.SHOW_LOADING, "正在登录服务器...")
    gg.LoginHelper:LoginByVistor()
end

--[[
* @brief 账号登录
]]
function LoginButtonView:onAccount(sender)
    if not self:checkCanDoLogin() then
        return
    end

    -- 切换登录框登录
    require("login.views.LoginViewAccount").new(self:getScene(), "LoginViewAccount"):pushInScene(true)
end

function LoginButtonView:onYSDKQQ(sender)
    gg.LoginHelper:LoginByYSDKQQ(true)
end

function LoginButtonView:onYSDKWX(sender)
    gg.LoginHelper:LoginByYSDKWX(true)
end

function LoginButtonView:onVivoLogin(sender)
    gg.LoginHelper:LoginByVivo()
end

function LoginButtonView:onOppoLogin(sender)
    gg.LoginHelper:LoginByOppo()
end

function LoginButtonView:onXiaomiLogin(sender)
    gg.LoginHelper:LoginByXiaomi()
end

function LoginButtonView:onHuaweiLogin(sender)
    gg.LoginHelper:LoginByHuawei()
end

function LoginButtonView:onQihooLogin(sender)
    gg.LoginHelper:onQihooLogin()
end

function LoginButtonView:onQihooSwitch(sender)
    gg.LoginHelper:onQihooSwitch()
end

function LoginButtonView:onToutiaoLogin(sender)
    gg.LoginHelper:onToutiaoLogin()
end

function LoginButtonView:onMeizuLogin(sender)
    gg.LoginHelper:onMeizuLogin()
end

function LoginButtonView:onSamsungLogin(sender)
    gg.LoginHelper:onSamsungLogin()
end

function LoginButtonView:checkCanDoLogin()
    if not cc.exports.IS_AGREE_USER_PROTOCOL then
        GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG, "请阅读并勾选《用户协议》")
        return false
    end

    return true
end

return LoginButtonView