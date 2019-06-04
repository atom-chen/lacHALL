if CC_DISABLE_GLOBAL then
    setmetatable(_G, nil)
end

--[[
    * 描述：请在main函数入口require该接口
]]

-- Lua 扩展
require("libs.luaex.Init")
require("libs.ccex.CommonFuncOnekes")

-- cocos2d-x 扩展
require("libs.ccex.Init")

-- cocos2d-x 控件封装
require("libs.widget.Init")

-- c注册接口
require("libs.c_interface.Init")

require("libs.yy_utils.Cpp2LuaGlobalFunc")

-- flash 封装
-- require("libs.flash.Init")

local Log = function(...)
    print(string.format(...))
end

-- 打印堆栈信息
Traceback = function()
    Log(debug.traceback())
end

__G__TRACKBACK__ = function(msg)
    local version ="App v"..tostring(table.concat(HALL_WEB_VERSION or {},"."))
    local tracebackInfo = debug.traceback()
    local errorMsg =  string.format("[%s,%s,%s]-%s",version,tostring(APP_ID),tostring(CHANNEL_ID),tostring(msg))

    release_print("-----------------begin-----------------------")
    release_print("LUA ERROR:" .. errorMsg .. "\n")
    release_print(tracebackInfo)
    release_print("------------------end------------------------")

    if device.platform == "android" then
        if buglySetAppVersion then
            buglySetAppVersion(tostring(version))
        end
        if buglySetAppChannel then
            buglySetAppChannel(tostring(CHANNEL_ID))
        end
        if hallmanager and hallmanager:IsConnected() then
            local userid = checktable(hallmanager.userinfo).id
            buglySetUserId(checkstring(userid))
        end
        buglyReportLuaException(errorMsg, tracebackInfo)
    end
    if DEBUG and DEBUG >0 then
        require("libs.TrackbackLayer"):createWithErrorMsg(errorMsg, tracebackInfo)
    end
    return msg
end


if CC_DISABLE_GLOBAL then
    cc.disable_global()
end

