local JAVA_CLASS_NAME = "com.weile.login.LoginApi"

local ToutiaoLogin_ANDROID = class("ToutiaoLogin_ANDROID")
local luaBridge = require("cocos.cocos2d.luaj")

function ToutiaoLogin_ANDROID:doAuth(args) 
    luaBridge.callStaticMethod(JAVA_CLASS_NAME, "addScriptListener", { handler(self, self.onAuthResp_) })

    local javaMethodName = "doLogin"
    local jsonArgs = json.encode(args)
    local javaParams = {"com.weile.thirdparty.toutiao.ToutiaoLogin", jsonArgs}
    local javaMethodSig = "(Ljava/lang/String;Ljava/lang/String;)V"
    local ok, ret = luaBridge.callStaticMethod(JAVA_CLASS_NAME, javaMethodName, javaParams, javaMethodSig)
    if not ok then
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "头条登录失败,请重试！")
    end
end

function ToutiaoLogin_ANDROID:callLogout(args)
    -- luaBridge.callStaticMethod(JAVA_CLASS_NAME, "addScriptListener", { handler(self, self.onAuthResp_) })
    local javaMethodName = "doLogout"
    local jsonArgs = json.encode(args)
    local javaParams = {"com.weile.thirdparty.toutiao.ToutiaoLogin", jsonArgs}
    local javaMethodSig = "(Ljava/lang/String;Ljava/lang/String;)V"
    local ok, ret = luaBridge.callStaticMethod(JAVA_CLASS_NAME, javaMethodName, javaParams, javaMethodSig)
    if not ok then
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "头条登出失败,请重试！")
    end
end

function ToutiaoLogin_ANDROID:onAuthResp(args) end
function ToutiaoLogin_ANDROID:onAuthResp_(luastr)  

    local ok,argtable = pcall(function()         
        return loadstring(luastr)();
    end)
    argtable = checktable(argtable)
    if not ok then
        argtable.errcode = -1
    end
    gg.InvokeFuncNextFrame(self.onAuthResp, self, argtable)
    printf("ToutiaoLogin_ANDROID:onAuthResp__ :"..tostring(luastr).." : bok="..tostring(ok))
end
 
return ToutiaoLogin_ANDROID