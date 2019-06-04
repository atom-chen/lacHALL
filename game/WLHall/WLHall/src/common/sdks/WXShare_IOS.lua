--
-- Author: lee
-- Date: 2016-10-19 16:38:00
local luaoc = require("cocos.cocos2d.luaoc")
local IOS_CLASS_NAME = "AppController"
local ProviderBase = import(".ProviderBase")
local ShareIOS = class("ShareIOS", ProviderBase)


function ShareIOS:addListener()
   -- luaBridge.callStaticMethod(IOS_CLASS_NAME, "addScriptListener", { listener = handler(self, self.callback_) })
 return self 
end

function ShareIOS:removeListener()
   -- luaBridge.callStaticMethod(IOS_CLASS_NAME, "removeScriptListener")
end

function ShareIOS:onShareCallback_(errcode, type, msg)
    self:onShareCallback({status=errcode,type=type,msg=msg})
end

-- sharetype [web appweb text image]
-- appid
-- wxscene
-- title imgurl weburl desc text imgpath 
--分享到微信
function ShareIOS:doWXShareReq(args)
	args.appid = args.appid or gg.UserData:GetWXShareAppId()
	args.wxscene=args.wxscene or WXScene.Timeline
    args.listener = handler(self, self.onShareCallback_)
    if args.sharetype == "web" then  --网页类型分享

    elseif args.sharetype == "appweb" then
 
    elseif args.sharetype == "image" then

    elseif args.sharetype == "text" then
    
    else
 
    end
    local ok, ret = luaoc.callStaticMethod(IOS_CLASS_NAME, "doShareToWX", args)

    if ok then
       
    else
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "微信分享失败！")
    end
end

return ShareIOS