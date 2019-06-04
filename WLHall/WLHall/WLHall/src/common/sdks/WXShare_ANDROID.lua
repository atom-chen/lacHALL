--
-- Author: Your Name
-- Date: 2016-10-17 20:33:00
--
local luaBridge = require("cocos.cocos2d.luaj")

local JAVA_CLASS_NAME = "com.weile.thirdparty.weixin.WXShareHelper"

local ProviderBase = import(".ProviderBase")
local ShareAndroid = class("ShareAndroid", ProviderBase)

function ShareAndroid:addListener()
    luaBridge.callStaticMethod(JAVA_CLASS_NAME, "addScriptListener", { handler(self, self.onShareCallback_) })
    return self
end

function ShareAndroid:removeListener()
     luaBridge.callStaticMethod(JAVA_CLASS_NAME, "removeScriptListener")
end

function ShareAndroid:onShareCallback_(luastr)
    local ok,argtable = pcall(function()
        return loadstring(luastr)();
    end)
    if ok then
        ok,argtable= pcall(self.onShareCallback,self,argtable)
        if not ok then
          printf("call ProviderBase:callback_"..tostring(argtable))
        end
    else
        printf("ProviderBase:callback_"..tostring(luastr))
    end
end

function ShareAndroid:doWXShareReq(args)
    self:addListener()
    args.appid = args.appid or gg.UserData:GetWXShareAppId()
    args.wxscene=args.wxscene or WXScene.Timeline
    local javaMethodName = "doShareToWX"
    local jsonArgs = json.encode(args)
    local javaParams = {jsonArgs}
    local javaMethodSig = "(Ljava/lang/String;)V"
    luaBridge.callStaticMethod(JAVA_CLASS_NAME, javaMethodName, javaParams, javaMethodSig)
end

return ShareAndroid


