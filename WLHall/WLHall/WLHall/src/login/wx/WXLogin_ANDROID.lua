--
-- Author: login
-- Date: 2017-01-01 14:15:03
-- 
local JAVA_CLASS_NAME = "com.weile.login.LoginApi"

local WXLogin_ANDROID=class("WXLogin_ANDROID")
local luaBridge = require("cocos.cocos2d.luaj")

function WXLogin_ANDROID:doAuthByWX(args) 
    luaBridge.callStaticMethod(JAVA_CLASS_NAME, "addScriptListener", { handler(self, self.onWXAuthResp_) })

    args.appid = args.appid or gg.UserData:GetWXShareAppId() 
    local javaMethodName = "doLogin"
    local jsonArgs = json.encode(args)
    local javaParams = {"com.weile.thirdparty.weixin.WXLogin", jsonArgs}
    local javaMethodSig = "(Ljava/lang/String;Ljava/lang/String;)V"
    local ok, ret = luaBridge.callStaticMethod(JAVA_CLASS_NAME, javaMethodName, javaParams, javaMethodSig)
    if ok then
         
    else
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "微信登录失败,请重试！")
    end
end

function WXLogin_ANDROID:onWXAuthResp(errcode,authcode,type) end
function WXLogin_ANDROID:onWXAuthResp_(luastr)  

    local ok,argtable = pcall(function()         
        return loadstring(luastr)();
    end)
    argtable=checktable(argtable)
    if not ok then
        argtable.errcode=-1
    end
    gg.InvokeFuncNextFrame(self.onWXAuthResp,self,argtable.errcode,argtable.authcode,argtable.type)
    -- self:onWXAuthResp(argtable.errcode,argtable.authcode,argtable.type)
    printf("WXLogin_ANDROID:onWXAuthResp__ :"..tostring(luastr).." : bok="..tostring(ok))
end
 
return WXLogin_ANDROID
