local JAVA_CLASS_NAME = "com.weile.login.LoginApi"

local SamsungLogin_ANDROID = class("SamsungLogin_ANDROID")
local luaBridge = require("cocos.cocos2d.luaj")

function SamsungLogin_ANDROID:doAuth(args) 
    luaBridge.callStaticMethod(JAVA_CLASS_NAME, "addScriptListener", { handler(self, self.onAuthResp_) })

    local javaMethodName = "doLogin"
    local jsonArgs = json.encode(args)
    local javaParams = {"com.weile.thirdparty.samsung.SamsungLogin", jsonArgs}
    local javaMethodSig = "(Ljava/lang/String;Ljava/lang/String;)V"
    local ok, ret = luaBridge.callStaticMethod(JAVA_CLASS_NAME, javaMethodName, javaParams, javaMethodSig)
    if not ok then
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "头条登录失败,请重试！")
    end
end

function SamsungLogin_ANDROID:onAuthResp(args) end
function SamsungLogin_ANDROID:onAuthResp_(luastr)  

    local ok,argtable = pcall(function()         
        return loadstring(luastr)();
    end)
    argtable = checktable(argtable)
    if not ok then
        argtable.errcode = -1
    end
    gg.InvokeFuncNextFrame(self.onAuthResp, self, argtable)
    printf("SamsungLogin_ANDROID:onAuthResp__ :"..tostring(luastr).." : bok="..tostring(ok))
end
 
return SamsungLogin_ANDROID