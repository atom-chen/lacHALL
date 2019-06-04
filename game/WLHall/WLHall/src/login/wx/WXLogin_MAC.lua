--
-- Author: login
-- Date: 2017-01-01 14:15:03
--
local luaoc = require("cocos.cocos2d.luaoc")
local WXLogin_MAC=class("WXLogin_MAC")

function WXLogin_MAC:doAuthByWX(args)
end

function WXLogin_MAC:onWXAuthResp(errcode,authcode,type) end
function WXLogin_MAC:onWXAuthResp_(errcode, type, authcode)
end

return WXLogin_MAC
