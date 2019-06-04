--
-- Author: login
-- Date: 2017-01-01 14:15:03
--
local IOS_CLASS_NAME = "AppController"
local luaoc = require("cocos.cocos2d.luaoc")
local WXLogin_IOS=class("WXLogin_IOS")

function WXLogin_IOS:doAuthByWX(args)
	args.appid = args.appid or gg.UserData:GetWXShareAppId()
    args.listener = handler(self, self.onWXAuthResp_)

    local ok, ret = luaoc.callStaticMethod(IOS_CLASS_NAME, "doWXAuthReq", args)
    if ok then
         
    else
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "调用微信登录错误！")
    end
end

function WXLogin_IOS:onWXAuthResp(errcode,authcode,type) end
function WXLogin_IOS:onWXAuthResp_(errcode, type, authcode)
    self:onWXAuthResp(errcode,authcode,type)
    -- if self.callback then
    --     self.callback(errcode,authcode,type)
    -- end
end

return WXLogin_IOS
