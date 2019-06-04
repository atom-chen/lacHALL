-- 第三方 SDK 接口
-- Author: zhanghonghui
-- Date: 2017-07-27
--
local ThirdParty = class("ThirdParty")

-- 第三方SDK是否接管了退出游戏
function ThirdParty:thirdPartyHandleQuitGame()
    if device.platform ~= "android" then
        return false
    end

    local _callback = function ()
        if GameApp.Exit then
           GameApp:Exit()
        end
    end

    local ok, ret = luaj.callStaticMethod("com.weile.thirdparty.ThirdPartyHelper", "handleQuitGame", {_callback}, "(I)Z")
    ret = ok and ret or false

    return ret
end

-- 通知第三方 SDK 激活设备
function ThirdParty:activeDevice(accountID)
    if device.platform ~= "android" then
        return
    end

    if CHANNEL_ID ~= "209" and CHANNEL_ID ~= "226" then
        -- TODO 线上已经存在一些 APK 包，JAVA 没有 activeDevice 接口，不能调用此接口
        -- 只有广点通和热云需要调用此接口，而正巧这些包都是有重新打的
        return
    end

    local args = {accountID = accountID}
    local javaParams = {json.encode(args)}
    local ok,ret = luaj.callStaticMethod("com.weile.thirdparty.ThirdPartyHelper", "activeDevice", javaParams)
end

-- 通知第三方 SDK 用户注册
function ThirdParty:registerAccount(accountID)
    if device.platform == "android" then
        local args = {accountID = accountID}
        local javaParams = {json.encode(args)}
        local ok,ret = luaj.callStaticMethod("com.weile.thirdparty.ThirdPartyHelper", "registerAccount", javaParams)
    elseif device.platform == "ios" and gg.GetNativeVersion() >= 3 then
        -- ios 平台在 native 版本为 3 时增加了 registerAccount 接口
        local args = { accountID = ""..accountID }
        local ok,ret = luaoc.callStaticMethod("AppController", "registerAccount", args)
    end
end

-- 通知第三方 SDK 用户登录
function ThirdParty:loginSuccess(accountID)
    if device.platform == "android" then
        local args = {accountID = accountID}
        local javaParams = {json.encode(args)}
        local ok,ret = luaj.callStaticMethod("com.weile.thirdparty.ThirdPartyHelper", "loginSuccess", javaParams)
    elseif device.platform == "ios" and gg.GetNativeVersion() >= 3 then
        -- ios 平台在 native 版本为 3 时增加了 loginSuccess 接口
        local args = { accountID = ""..accountID }
        local ok,ret = luaoc.callStaticMethod("AppController", "loginSuccess", args)
    end
end

-- 通知第三方 SDK 开始支付
function ThirdParty:startPay(args)
    cc.exports.payingArgs = args
    if device.platform == "android" then
        local javaParams = {json.encode(args)}
        local ok,ret = luaj.callStaticMethod("com.weile.thirdparty.ThirdPartyHelper", "startPay", javaParams)
    elseif device.platform == "ios" and gg.GetNativeVersion() >= 3 then
        -- ios 平台在 native 版本为 3 时增加了 startPay 接口
        local ok,ret = luaoc.callStaticMethod("AppController", "startPay", args)
    end
end

-- 通知第三方 SDK 支付成功
function ThirdParty:paySuccess()
    if device.platform ~= "android" then
        return
    end

    if CHANNEL_ID ~= "209" and CHANNEL_ID ~= "226" then
        -- TODO 线上已经存在一些 APK 包，JAVA 没有 paySuccess 接口，不能调用此接口
        -- 只有广点通和热云需要调用此接口，而我们要求已经上线的包必须做一次大版本更新
        return
    end

    local javaParams = {json.encode(checktable(cc.exports.payingArgs))}
    local ok,ret = luaj.callStaticMethod("com.weile.thirdparty.ThirdPartyHelper", "paySuccess", javaParams)
end

return ThirdParty
