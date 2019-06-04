--
-- Author: login
-- Date: 2017-01-01 14:15:03
-- 
local JAVA_CLASS_NAME = "com.weile.login.LoginApi"

local MeizuLogin_ANDROID=class("MeizuLogin_ANDROID")
local luaBridge = require("cocos.cocos2d.luaj")

function MeizuLogin_ANDROID:doAuth(args) 
    luaBridge.callStaticMethod(JAVA_CLASS_NAME, "addScriptListener", { handler(self, self.onAuthResp_) })

    local javaMethodName = "doLogin"
    local jsonArgs = json.encode(args)
    local javaParams = {"com.weile.thirdparty.meizu.MeizuLogin", jsonArgs}
    local javaMethodSig = "(Ljava/lang/String;Ljava/lang/String;)V"
    local ok, ret = luaBridge.callStaticMethod(JAVA_CLASS_NAME, javaMethodName, javaParams, javaMethodSig)
    if ok then
         
    else
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "魅族登录失败,请重试！")
    end
end

function MeizuLogin_ANDROID:onAuthResp(args) end
function MeizuLogin_ANDROID:onAuthResp_(luastr)  

    local ok,argtable = pcall(function()         
        return loadstring(luastr)();
    end)
    argtable = checktable(argtable)
    if not ok then
        argtable.errcode = -1
    end
    gg.InvokeFuncNextFrame(self.onAuthResp, self, argtable)
    printf("MeizuLogin_ANDROID:onAuthResp__ :"..tostring(luastr).." : bok="..tostring(ok))
end
 
return MeizuLogin_ANDROID
