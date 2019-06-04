local NotificationHelper = {}

--通知消息类型，由具体逻辑维护
NotificationHelper.notifyType = {
    TEST_N1 = 1,
    TEST_N2 = 2,
    MATCH_START = 3,
}

--[[
注册本地通知
*@param _notifyId 必填 NotificationHelper.notifyType 通知类型，id相同会覆盖上一个通知，取消通知需要id  
*@param _title 必填 string 通知标题
*@param _content 必填 string 通知内容
*@param _delayTime 必填 int 通知延迟时间，单位秒
*@param _notifyClickMsg 选填 string 点击通知后传入消息内容
*@param _repeatTime 选填 默认=0 不重复 单位秒 （android端这个参数时间不准确，根据设备空闲时间来重复  iso的重复时间固定、每分钟、每小时、每天、每周、每月、每年）
*@param _type int 选填 仅android用 0=唤醒休眠状态 1=不唤醒休眠状态 默认0
*@param _ticker string 选填 仅android用
*@param _activityName string 仅android使用，activity包名和文件名，默认为weile.games.AppActivity
]]
function NotificationHelper:registLocalNotification(_notifyId, _title, _content, _delayTime, _notifyClickMsg, _repeatTime, _type, _ticker, _activityName)
    local params = {
        notifyId = _notifyId,
        title = _title,
        content = _content,
        delayTime = _delayTime,
        repeatTime = _repeatTime,
        type = _type,
        ticker = _ticker,
        activityName = _activityName,
        notifyMsg = _notifyClickMsg
    }
    if nil == _repeatTime then params.repeatTime = 0 end
    local jsonStr = json.encode(params)
    device.registLocalNotification(jsonStr)
end

--取消本地通知
--@param notifyId NotificationHelper.notifyType 
function NotificationHelper:cancelLocalNotification(notifyId)
    device.cancelLocalNotification(notifyId)
end

function NotificationHelper:cancelAllLocalNotification()
    if device.platform == "ios" then
        device.cancelAllNotification()
    elseif device.platform == "android" then
        for k, v in pairs(NotificationHelper.notifyType) do
            device.cancelLocalNotification(v)
        end
    end
end



--个推SDK函数接口
local CLASS_NAME =
{
    android = "com.weile.thirdparty.push.PushHelper",
    ios = "GetuiPushHelper",
    windows = "",
}

local function getclassname_()
    return CLASS_NAME[device.platform]
end

function NotificationHelper:cleanBadge()
    if gg.GetNativeVersion() < 5 then return false end;
    if device.platform == "ios" then
        local ok, ret = luaoc.callStaticMethod(getclassname_(), "resetBadge");
        if ok then
            return true;
        end
    end
end

--绑定个推别名，指定用户推送需要事先绑定 _username = 用户唯一标识 账号 登录时调用
function NotificationHelper:bindUserName(_username, _callback)
    if gg.GetNativeVersion() < 5 then return false end;

    if device.platform == "android" then
        local args = {_username}
        local sig = "(Ljava/lang/String;)Z"
        local ok, ret = luaj.callStaticMethod(getclassname_(), "login", args, sig)
        if ok then
            local result = "error"
            if ret == true then result = "success" end
            if nil ~= _callback then _callback(result) end
            return true
        end
    elseif device.platform == "ios" then
        local args = {username = _username, callback = _callback};
        local ok, ret = luaoc.callStaticMethod(getclassname_(), "login", args, nil);
        if ok then
            return true;
        end
    end
    return false
end

--解绑个推别名 _username = 用户唯一标识 账号 登出时调用
function NotificationHelper:unBindUserName(_username, _callback)
    if gg.GetNativeVersion() < 5 then return false end;

    if device.platform == "android" then
        local args = {_username}
        local sig = "(Ljava/lang/String;)Z"
        local ok, ret = luaj.callStaticMethod(getclassname_(), "logout", args, sig)
        if ok  then
            local result = "error"
            if ret == true then result = "success" end
            if nil ~= _callback then _callback(result) end
            return true
        end
    elseif device.platform == "ios" then
        local args = {username = _username, callback = _callback};
        local ok, ret = luaoc.callStaticMethod(getclassname_(), "logout", args, nil);
        if ok and ret then
            return true;
        end
    end
    return false
end

--设置tag标签用户分组，可传多个标签 tag之间用 | 隔开   "tag1|tag2|tag3|tag4"
function NotificationHelper:setTag(_tags)
    if gg.GetNativeVersion() < 5 then return false end;

    if device.platform == "android" then
        local args = {_tags}
        local sig = "(Ljava/lang/String;)Z"
        local ok, ret = luaj.callStaticMethod(getclassname_(), "setTag", args, sig)
        if ok and ret then
            return true
        end
    elseif device.platform == "ios" then
        local args = {tags = _tags};
        local ok, ret = luaoc.callStaticMethod(getclassname_(), "setTag", args, nil);
        if ok and ret then
            return true;
        end
    end
    return false
end

--获得点击远程通知的参数
function NotificationHelper:getClickRemoteNotifyMsg()
    if gg.GetNativeVersion() < 5 then return "" end;

    if device.platform == "android" then
        local args = {}
        local sig = "()Ljava/lang/String;"
        local ok, ret = luaj.callStaticMethod(getclassname_(), "getClickRemoteNotifyMsg", args, sig)
        if ok then
            return ret
        end
    elseif device.platform == "ios" then
        local ok, ret = luaoc.callStaticMethod(getclassname_(), "getClickRemoteNotifyMsg", nil, nil);
        if ok then
            return ret
        end
    end
    return ""
end

--获取离线通知参数内容json
function NotificationHelper:getOfflineNotifyMsg()
    if gg.GetNativeVersion() < 5 then return "" end;

    if device.platform == "android" then
        local args = {}
        local sig = "()Ljava/lang/String;"
        local ok, ret = luaj.callStaticMethod(getclassname_(), "getOfflineNotifyMsg", args, sig)
        if ok then
            return ret
        end
    elseif device.platform == "ios" then
        local ok, ret = luaoc.callStaticMethod(getclassname_(), "getOfflineNotifyMsg", nil, nil);
        if ok then
            return ret
        end
    end
    return ""
end

--获取点击本地通知获得的json
function NotificationHelper:getLocalNotifyClickMsg()
    if gg.GetNativeVersion() < 5 then return "" end

    if device.platform == "android" then
        local args = {}
        local sig = "()Ljava/lang/String;"
        local ok, ret = luaj.callStaticMethod("com.weile.api.NativeHelper", "getLocalNotifyMsg",args,sig)
        if ok then
            return ret
        end
    elseif device.platform == "ios" then
        local ok, ret = luaoc.callStaticMethod(getclassname_(), "getLocalNotifyMsg", nil, nil);
        if ok then
            return ret
        end
    end

    return ""
end

--检测是否打开通知
function NotificationHelper:checkCanNotification()
    return device.checkCanNotification()
end

--跳转到系统通知设置界面
function NotificationHelper:gotoNotificationSetting()
    device.gotoNotificationSetting()
end

return NotificationHelper