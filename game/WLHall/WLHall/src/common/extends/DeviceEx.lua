--  android  ios  通用接口
-- Author: lee
-- Date: 2016-09-12 11:12:06
--
local CLASS_NAME =
{
    android = "com.weile.api.NativeHelper",
    ios = "AppController",
    windows = "",
}
local DeviceEx = device
if device.platform=="ios" then
    cc.exports.luaoc = require("cocos.cocos2d.luaoc")
elseif device.platform=="android" then
    cc.exports.luaj = require("cocos.cocos2d.luaj")
end

--pickertype camera album library

local function getclassname_()
    return CLASS_NAME[device.platform]
end

-- 返回相机状态，0 表示不可用，1 表示可用，2 表示用户还未确定
function DeviceEx.getCameraState()
    if device.platform == "android" then
       return 1
    elseif device.platform == "ios" then
        if IS_REVIEW_MODE then
            -- 审核模式不能调用底层的接口
            return 1
        end

        if gg.GetNativeVersion() < 2 then
            -- Native 版本尚未提供接口，认为可用
            return 1
        end

        local ok, ret = luaoc.callStaticMethod(getclassname_(), "getCameraState", nil)
        return ok and ret or 0
    else
        return 1
    end
end

function DeviceEx.openCameraSetting()
    if device.platform == "android" then
        -- Android 不需要
    elseif device.platform == "ios" then
        local ok, ret = luaoc.callStaticMethod(getclassname_(), "openCameraSetting", nil)
        if ok then
        end
    else

    end
end

-- 返回麦克风状态，0 表示不可用，1 表示可用，2 表示用户还未确定
function DeviceEx.getMicrophoneState()
    if device.platform == "android" then
       return 1
    elseif device.platform == "ios" then
        if IS_REVIEW_MODE then
            -- 审核模式不能调用底层的接口
            return 1
        end

        if gg.GetNativeVersion() < 2 then
            -- Native 版本尚未提供接口，认为可用
            return 1
        end

        local ok, ret = luaoc.callStaticMethod(getclassname_(), "getMicrophoneState", nil)
        return ok and ret or 0
    else
        return 1
    end
end

function DeviceEx.openMicrophoneSetting()
    if device.platform == "android" then
        -- Android 不需要
    elseif device.platform == "ios" then
        local ok, ret = luaoc.callStaticMethod(getclassname_(), "openMicrophoneSetting", nil)
        if ok then
        end
    else

    end
end

function DeviceEx.callImagePicker(type, callback, allowedit)
    GameApp:dispatchEvent(gg.Event.DISABLE_APPENTER)
    if device.platform == "android" then
        local javaParams = { type, callback, allowedit }
       local ok,ret=  luaj.callStaticMethod(getclassname_(), "callImagePicker", javaParams)
    elseif device.platform == "ios" then
        local args = { pickertype = type, listener = callback, allowedit = allowedit }
        local ok, ret = luaoc.callStaticMethod(getclassname_(), "callImagePicker", args)
        if ok then

        end
    end
end

---保存到相册
function DeviceEx.savedToPhotosAlbum(imagePath,callback)
    printf("savedToPhotosAlbum path:"..tostring(imagePath))
    if imagePath and #imagePath>0 then
        if device.platform == "android" then
            local javaParams = { imagePath,callback}
            local ok,ret=  luaj.callStaticMethod(getclassname_(), "saveImageToPhotosAlbum", javaParams)
            return ok
        elseif device.platform == "ios" then
            local args = { imagepath=imagePath,listener=callback}
            local ok, ret = luaoc.callStaticMethod(getclassname_(), "saveImageToPhotosAlbum", args)
            if ok then

            end
        end
    else
        return false
    end

end

--客服系统调用
function DeviceEx.callCustomerServiceApi(param,gameid,roomid)
    GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG, "即将为您接通人工客服...", function(bttype)
        if bttype == gg.MessageDialog.EVENT_TYPE_OK then
            device.doCallCustomerServiceApi(param,gameid,roomid)
        end
    end, { mode=gg.MessageDialog.MODE_OK_CANCEL_CLOSE, cancel="取消", ok="确定"})
end

function DeviceEx.doCallCustomerServiceApi(param, gameid, roomid)
    GameApp:dispatchEvent(gg.Event.DISABLE_APPENTER)
    local args={}
    if type(param)=="table" then
       args= param
    else
       args.ui=param
    end
    args.app_id=args.app_id or APP_ID
    args.channel_id= args.channel_id or CHANNEL_ID
    local region= gg.LocalConfig:GetRegionCode()
    if  checkint(region)==0 then
       region = REGION_CODE
    end
    args.region = args.region or region

    -- 未指定版本号，获取版本号字符串
    if not args.client_version then
        local common_ver = gg.VersionHelper:getModuleClientVer(gg.VersionHelper.VER_MODULE_GAME_COMMON)
        local hall_ver= gg.VersionHelper:getModuleClientVer(gg.VersionHelper.VER_MODULE_HALL)
        args.client_version = string.format("%s.%s.%s", table.concat(HALL_WEB_VERSION,"."), common_ver, hall_ver)
    end

    args.game_id = args.game_id or checkint(gameid)
    args.room_id = args.room_id  or checkint(roomid)
    if hallmanager and hallmanager:IsConnected() then
        args.user_id=hallmanager.userinfo.id
    else
        args.user_id=checkint(checktable(gg.Cookies:GetDefRole()).id)
    end
    args.device_code=Helper.GetDeviceCode()
    args.domain=WEB_DOMAIN
    args.url_vc= "http://"..table.concat(UPDATE_URL_PREFIX, "."..WEB_DOMAIN..",http://").."."..WEB_DOMAIN
    args.url_login=checktable(LOGIN_SERVER_LIST[1]).url or ""
    local jsonArgs = json.encode(args)
    if device.platform == "android" then
        local javaMethodName = "start"
        local javaParams = {jsonArgs}
        printf("function DeviceEx.callCustomerServiceApi(table) " ..jsonArgs)
        local javaMethodSig = "(Ljava/lang/String;)V"
        luaj.callStaticMethod("com.weile.api.CustomerServiceApi", javaMethodName, javaParams, javaMethodSig)
    elseif device.platform == "ios" then
        -- 在 iOS 平台 user_id 以整数传递到 OC 代码中值会出现问题，所以这里转成字符串进行传递
        args.user_id = tostring(args.user_id)
        local ok, ret = luaoc.callStaticMethod(getclassname_(), "callCustomerServiceApi", args)
        if ok then
        end
    else
        GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG, device.platform.." 暂未开放此功能 tag:"..param )
    end

end
-- 设备电量  0-100
function DeviceEx.getBatteryLevel()
    return Helper.GetDeviceBatteryLevel()
end

function DeviceEx.getUrlScheme()
    if device.platform == "android" then
        local javaMethodName = "getUrlScheme"
        local javaMethodSig = "()Ljava/lang/String;"
        local ok,ret= luaj.callStaticMethod(getclassname_(), javaMethodName, {}, javaMethodSig)
        ret = ok and ret or ""
        return ret
    elseif device.platform == "ios" then
        local ok, ret = luaoc.callStaticMethod(getclassname_(), "getUrlScheme", nil)
        printf("getUrlScheme %s %s " ,tostring(ok),tostring(ret))
        ret = ok and ret or ""
       return ret
    else
        return ""
    end
end

function DeviceEx.getGpsEnable()
     if device.platform == "android" then
        local javaMethodName = "getDeviceGpsEnable"
        local javaMethodSig = "()I"
        local ok,ret= luaj.callStaticMethod(getclassname_(), javaMethodName, {}, javaMethodSig)
        ret = ok and ret or 0
        return ret
    elseif device.platform == "ios" then
        if IS_REVIEW_MODE then
            -- 审核模式不能调用底层的接口
            return 0
        end

        local ok, ret = luaoc.callStaticMethod(getclassname_(), "getDeviceGpsEnable", nil)
        return gg.IIF(ok and ret, 1, 0)
    else
        return 1
    end
end

function DeviceEx.openGpsSetting()
    if device.platform == "android" then
        local javaMethodName = "openGpsSetting"
        local javaMethodSig = "()V"
        local ok,ret = luaj.callStaticMethod(getclassname_(), javaMethodName, {}, javaMethodSig)
        if ok then

        end
    elseif device.platform == "ios" then
        local ok, ret = luaoc.callStaticMethod(getclassname_(), "openGpsSetting", nil)
        if ok then
        end
    else

    end
end

-- 开启位置定位
local _timers = require("common.utils.Timer").new()
local updatingLocation = false
function DeviceEx.startUpdatingLocation()
    if updatingLocation == true then
        return
    end

    updatingLocation = true
    if device.platform == "android" then
        local javaMethodSig = "()V"
        local ok,ret = luaj.callStaticMethod(getclassname_(), "startUpdatingLocation" , {}, javaMethodSig)
        if ok then

        end
    elseif device.platform == "ios" then
        local ok, ret = luaoc.callStaticMethod(getclassname_(), "startUpdatingLocation", nil)
        if ok then
        end
    else

    end

    if _timers then
        _timers:killAll()
    end

    -- 添加定时器，每两分钟让游戏客户端刷新一次 GPS
    _timers:start(function ()
        local gpsInfo = device.getGpsInfo()
        GameApp:dispatchEvent(gg.Event.GPS_POSITION_UPDATE, gpsInfo)
    end, 120)
end

function DeviceEx.requestReGeocode(callback)
    if gg.GetNativeVersion() < 5 then return end

    if device.platform ~= "android" and device.platform ~= "ios" then return end
    
    local isReStartUpdateing = false
    if updatingLocation and device.platform == "ios" then
        device.stopUpdatingLocation() 
        isReStartUpdateing = true
    end

    local callbackFunc = function (geocodeInfo)
        print("geocodeinfo===="..geocodeInfo)
        if isReStartUpdateing then
            device.startUpdatingLocation()
        end
        local ok,ret = pcall(function() return loadstring(geocodeInfo)()  end)
        ret = ok and ret or {}
        print("geocodeinfo ret===="..json.encode(checktable(ret)))
        if callback then
            callback(ret)
        end
    end

    if device.platform == "android" then
        local javaParams = {callbackFunc}
        local ok,ret = luaj.callStaticMethod(getclassname_(), "requestReGeocode", javaParams, "(I)V")
        return ok
    elseif device.platform == "ios" then
        local args = { listener = callbackFunc }
        local ok, ret = luaoc.callStaticMethod(getclassname_(), "requestReGeocode", args)
        return ok
    end
end

function DeviceEx.stopUpdatingLocation()
    if updatingLocation == false then
        return
    end

    updatingLocation = false
    if device.platform == "android" then
        local javaMethodSig = "()V"
        local ok,ret = luaj.callStaticMethod(getclassname_(), "stopUpdatingLocation" , {}, javaMethodSig)
        if ok then

        end
    elseif device.platform == "ios" then
        local ok, ret = luaoc.callStaticMethod(getclassname_(), "stopUpdatingLocation", nil)
        if ok then
        end
    else

    end

    -- 关闭计时器
    if _timers then
        _timers:killAll()
    end
end

function DeviceEx.isUpdatingLocation()
    return updatingLocation
end

-- 设备gps 经纬度
--ret: { enable=1,latitude=111.02201 ,longitude=2222.1222, status=0 }
-- status 的意义（0:正常，获得正常值 1: 正在定位 2: 未获取到正确值）
function DeviceEx.getGpsInfo()
    local gps
    if device.platform == "android" then
        local javaMethodName = "getDeviceGpsInfo"
        local javaMethodSig = "()Ljava/lang/String;"
        local ok,ret = luaj.callStaticMethod(getclassname_(), javaMethodName, {}, javaMethodSig)
        if ok then
            ok,gps=pcall(function() return loadstring(ret)()  end)
        end

    elseif device.platform == "ios" then
        if IS_REVIEW_MODE then
            return {enable = false, latitude = 24.0, longitude = 118.0, status = 2}
        end
        local ok, ret = luaoc.callStaticMethod(getclassname_(), "getDeviceGpsInfo", nil)
        gps = ret
    else
        -- PC 和 MAC 没有 GPS，当做打开了 GPS，而又获取不到的情况
        gps = {enable = true, latitude = 24.0, longitude = 118.0, status = 0}
    end

    gps = checktable(gps)

    if (not gps.longitude or not gps.latitude) or
        string.format("%.1f", gps.longitude) == "0.0" and string.format("%.1f", gps.latitude) == "0.0" then
        -- 无法获取到正确值
        gps.enable = true
        gps.longitude = 0.0
        gps.latitude = 0.0
        gps.status = 2
    else
        gps.status = 0
    end

    printf("getGpsInfo %s",json.encode(checktable(gps)))
    return gps
end

-- 异步的方式获取 GPS 信息，需要提供一个获取后的回调函数
function DeviceEx.getGpsInfoAsync(callback)
    local _callback = function (gpsInfoStr)
        local ok,ret = pcall(function() return loadstring(gpsInfoStr)()  end)
        ret = ok and ret or {}

        if (not ret or not ret.longitude or not ret.latitude) or
            string.format("%.1f", ret.longitude) == "0.0" and string.format("%.1f", ret.latitude) == "0.0" then
            -- 无法获取到正确值
            ret.status = 2
        else
            ret.status = 0
        end

        printf("getGpsInfoAsync %s",json.encode(checktable(ret)))
        callback(ret)
    end

    if device.platform == "android" then
        local javaParams = {_callback}
        local ok,ret = luaj.callStaticMethod(getclassname_(), "getDeviceGpsInfoAsync", javaParams)
        return ok
    elseif device.platform == "ios" then
        if IS_REVIEW_MODE then
            callback({enable = false, latitude = 24.0, longitude = 118.0, status = 2})
            return true
        end

        local args = { listener = _callback }
        local ok, ret = luaoc.callStaticMethod(getclassname_(), "getDeviceGpsInfoAsync", args)

        return ok
    else
        -- PC 和 MAC 没有 GPS，当做打开了 GPS，而又获取不到的情况
        callback({enable = true, latitude = 24.0, longitude = 118.0, status = 0})
        return true
    end
end

function DeviceEx.addBatteryChangeEvent(node,listener)
    assert(node,"node  must be not nil")
    assert(listener,"listener  must be not nil")
    local batterylistener = cc.EventListenerCustom:create("BATTERY_STATE_CHANGED_EVENT", listener)
    node:getEventDispatcher():addEventListenerWithSceneGraphPriority(batterylistener, node)
end

function DeviceEx.removeBatteryChangeEvent(node)
    assert(node,"node  must be not nil")
    if device.platform == "ios" then

        local ok, ret = luaoc.callStaticMethod(getclassname_(), "removeBatteryChangeEvent",{})
    end
    node:getEventDispatcher():removeCustomEventListeners("BATTERY_STATE_CHANGED_EVENT")
end

function DeviceEx.addPhoneStateChangeEvent(node,listener)
    assert(node,"node  must be not nil")
    assert(listener,"listener  must be not nil")
    local phonelistener = cc.EventListenerCustom:create("PHONE_STATE_CHANGED_EVENT", listener)
    node:getEventDispatcher():addEventListenerWithSceneGraphPriority(phonelistener, node)
end

function DeviceEx.removePhoneStateChangeEvent(node)
    assert(node,"node  must be not nil")
    node:getEventDispatcher():removeCustomEventListeners("PHONE_STATE_CHANGED_EVENT")
end

--  打开微信
function DeviceEx.openWechat(appid)
    GameApp:dispatchEvent(gg.Event.DISABLE_APPENTER)
    appid = appid or WX_APP_ID_LOGIN
     if device.platform == "android" then
        local javaParams = {appid}
       local ok,ret=  luaj.callStaticMethod("com.weile.thirdparty.weixin.WXShareHelper", "doOpenWX", javaParams)
    elseif device.platform == "ios" then
        local args = {appid=appid}
        local ok, ret = luaoc.callStaticMethod(getclassname_(), "doOpenWX", args)
        if ok then
        end
    end
end

--  打开竖版 WebView
function DeviceEx.openPortraitWebView(url, title)
     if device.platform == "android" then
        -- local javaParams = {appid}
        local javaParams = {url, title}
        local ok,ret = luaj.callStaticMethod(getclassname_(), "openPortraitWebView", javaParams)
    elseif device.platform == "ios" then
        local args = {url=url, title=title}
        local ok, ret = luaoc.callStaticMethod(getclassname_(), "openPortraitWebView", args)
        if ok then
        end
    else
        GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG, device.platform.." 暂未开放此功能")
    end
end

function DeviceEx.closeWebView()
    if gg.GetNativeVersion() < 5 then return end
    if device.platform == "ios" then
        local ok, ret = luaoc.callStaticMethod(getclassname_(), "closePortraitWebView", nil)
        if ok then
        end
    elseif device.platform == "android" then
        local javaParams = {}
        local ok,ret = luaj.callStaticMethod(getclassname_(), "closePortraitWebView", javaParams)
    end
end

-- 应用名字
function DeviceEx.getAppName()
end

-- 应用图标
function DeviceEx.getAppIcon()
end

-- 应用签名信息
function DeviceEx.getAppSign()
end

-- 应用包名
function DeviceEx.getAppPackageName()
end

-- 获取设备名字

function DeviceEx.getDeviceName()
end


--[[
 屏幕方向
 @ return 0 横屏 1 竖屏
  gg.SCREEN_ORIENTATION_LANDSCAPE=0
 gg.SCREEN_ORIENTATION_PORTRAIT=1
]]
function DeviceEx.getScreenOrientation()
end

--[[--

返回设备的 OpenUDID 值
OpenUDID 是为设备仿造的 UDID（唯一设备识别码）,可以用来识别用户的设备。
但 OpenUDID 存在下列问题：
-   如果删除了应用再重新安装,获得的 OpenUDID 会发生变化
-   iOS 7 不支持 OpenUDID
@return string 设备的 OpenUDID 值

]]
function DeviceEx.getOpenUDID()
end

--[[--
震动
@param int millisecond 震动时长(毫秒) (设置震动时长仅对android有效,默认200ms)

android 需要添加震动服务权限
<uses-permission android:name="android.permission.VIBRATE" />
]]

function DeviceEx.vibrate(millisecond)
end

--[[--
用浏览器打开指定的网址
-- 打开网页
device.openURL("http://xxx.ccc.w/")
-- 打开设备上的拨号程序
device.openURL("tel:123-456-7890")
@param string 网址,邮件,拨号等的字符串
]]
function DeviceEx.openURL(url)
    cc.Application:getInstance():openURL(url)
end

function DeviceEx.showAlert(title, message, buttonLabels, listener)
end

-- 安装apk包
function DeviceEx.installApk(path)
    if device.platform == "android" then
       local ok,ret=  luaj.callStaticMethod(getclassname_(), "installApk", {path})
    end
end

--[[--
取消正在显示的对话框。
提示：取消对话框,不会执行显示对话框时指定的回调函数。
]]
function DeviceEx.cancelAlert()
    if DEBUG > 1 then
        printInfo("device.cancelAlert()")
    end
end

--[[--
获取系统版本，目前只支持获取 Android 系统的 API Level
因为 android 4.4 系统中微信下单有问题， web 的下单接口需要针对此版本做特殊处理
]]
function DeviceEx.getSystemVersion()
    if device.platform == "android" then
        local ok, apiLevel = luaj.callStaticMethod("org.cocos2dx.lib.Cocos2dxHelper", "getSDKVersion", {}, "()I")
        if ok then
            return apiLevel
        end
    end

    return nil
end

function DeviceEx.getAvmpSignString(inputstr)
    if device.platform == "android" and gg.GetNativeVersion() >= 4 then
        local ok, sign = luaj.callStaticMethod(getclassname_(), "getAvmpSignString", {inputstr},"(Ljava/lang/String;)Ljava/lang/String;")
        if ok then
            return sign
        end
    end
    return nil
end

function DeviceEx.getPasteboardString(callback)
    if gg.GetNativeVersion() < 5 then return "error" end;

    if device.platform == "android" then
        local ok, ret = luaj.callStaticMethod(getclassname_(),"getPasteboardString", {callback}, "(I)V")
        if ok then
            return true
        end
    elseif device.platform == "ios" then
        local ok, ret = luaoc.callStaticMethod(getclassname_(), "getPasteboardString", nil)
        if ok then
            if callback then callback(ret); end
            return true;
        end
    end
    return false;
end

--[[
--@_msg 推送内容
--@_time 添加消息之后延迟推送时间，单位秒
function DeviceEx.addLocalNotification(_msg, _time)
    if gg.GetNativeVersion() < 5 then return false end;

    if device.platform == "ios" then
        local args = { msg = _msg, time = _time};
        local ok, ret = luaoc.callStaticMethod(getclassname_(), "addLocalNotification", args);
        if ok then
            return true
        end
    end
    return false;
end
--]]

--@_shareType 分享类型(仅android有效) 1:图文（直接打开微信朋友圈）2:图片 3:文字
--@_context 分享文本内容
--@_url 分享链接
--@_imgUrl 分享图片地址
--@_callback 分享成功和失败返回值，成功="success"
function DeviceEx.shareBySystemPlatform(_shareType, _content, _imgPathJson, _url, _callback)
    if gg.GetNativeVersion() < 5 then return false end;

    GameApp:dispatchEvent(gg.Event.DISABLE_APPENTER)

    if device.platform == "ios" then
        local args = { shareType = _shareType, content = _content, imgPathJson = _imgPathJson, url = _url, callback = _callback};
        local ok, ret = luaoc.callStaticMethod(getclassname_(), "shareBySystemPlatform", args, "()V");
        if ok then
            return true;
        end
    elseif device.platform == "android" then
        local args = {_shareType, _content, _imgPathJson, _callback};
        local sig = "(ILjava/lang/String;Ljava/lang/String;I)V";
        local ok, ret = luaj.callStaticMethod(getclassname_(), "shareBySystemPlatform", args, sig);
        if ok then
            return true;
        end
    end
    return false;
end

function DeviceEx.checkCanNotification()
    if gg.GetNativeVersion() < 5 then return false end
    if device.platform == "android" then
        local args = {}
        local sig = "()Z"
        local ok, ret = luaj.callStaticMethod(getclassname_(), "checkCanNotification", args, sig)
        if ok then
            return ret
        end
    elseif device.platform == "ios" then
        local ok, ret = luaoc.callStaticMethod(getclassname_(), "checkCanNotification", nil);
        if ok then
            return ret;
        end
    end
    return false
end

function DeviceEx.gotoNotificationSetting()
    if gg.GetNativeVersion() < 5 then return false end
    if device.platform == "android" then
        local args = {}
        local sig = "()V"
        local ok, ret = luaj.callStaticMethod(getclassname_(), "gotoNotificationSetting", args, sig)
        if ok then
            return true
        end
    elseif device.platform == "ios" then
        local ok, ret = luaoc.callStaticMethod(getclassname_(), "gotoNotificationSetting", nil);
        if ok then
            return true;
        end
    end
    return false
end

--[[
*@param notifyId int 唯一标示，用于取消通知，id相同会覆盖上一个通知。
*@param title string 通知标题
*@param content string 通知
*@param delayTime 多少秒之后开始弹出通知
*@param paramJsonStr string 参数json
{
    type = 1,                                     //通知类型 1:不唤醒睡眠状态  0:唤醒睡眠状态
    isRepeat = false,                             //是否重复推送
    repeatTime = 0;                               //设置重复推送时间间隔
}
]]
function DeviceEx.registLocalNotification(paramJsonStr)
    if gg.GetNativeVersion() < 5 then return false end;

    if device.platform == "android" then
        local args = {paramJsonStr}
        local sig = "(Ljava/lang/String;)V"
        local ok, ret = luaj.callStaticMethod(getclassname_(), "registLocalNotification", args, sig)
        if ok then
            return true
        end
    elseif device.platform == "ios" then
        local args = {_paramJsonStr = paramJsonStr};
        local ok, ret = luaoc.callStaticMethod(getclassname_(), "registLocalNotification", args, nil);
        if ok then
            return true;
        end
    end
    return false
end

function DeviceEx.cancelLocalNotification(_notifyId)
    if gg.GetNativeVersion() < 5 then return false end

    if device.platform == "android" then
        local args = {_notifyId}
        local sig = "(I)V"
        local ok, ret = luaj.callStaticMethod(getclassname_(), "cancelLocalNotification", args, sig)
        if ok then
            return true
        end
    elseif device.platform == "ios" then
        local args = {notifyId = _notifyId}
        local ok, ret = luaoc.callStaticMethod(getclassname_(), "cancelLocalNotification", args, nil);
        if ok then
            return true;
        end
    end
    return false
end

--取消所有本地推送 仅支持ios android需要根据notifyId逐个取消
function DeviceEx.cancelAllNotification()
    if gg.GetNativeVersion() < 5 then return false end

    if device.platform == "ios" then
        local args = {}
        local ok, ret = luaoc.callStaticMethod(getclassname_(), "cancelAllNotification", nil, nil);
        if ok then
            return true;
        end
    end
    return false
end

--根据应用商店包名打开评论界面
local marketPackages = {
    ["201"] = "com.qihoo.appstore",
    ["202"] = "com.baidu.appsearch",
    ["205"] = "com.xiaomi.market",
    ["206"] = "com.vivo.market",
    ["207"] = "com.oppo.market",
    ["210"] = "com.tencent.android.qqdownloader",
    ["224"] = "com.huawei.appmarket"
}
function DeviceEx.openAppDetailByMarket()
    if gg.GetNativeVersion() < 5 then return end
    if device.platform == "android" then
        local marketPackage = marketPackages[CHANNEL_ID]
        if not marketPackage then 
            device.openAppDetail() 
            return 
        end
        local args = {marketPackage}
        local sig = "(Ljava/lang/String;)V"
        local ok, ret = luaj.callStaticMethod(getclassname_(), "openAppDetailByMarket", args, sig)
        if ok then
            return true
        end
    elseif device.platform == "ios" then
        device.openURL("itms-apps://itunes.apple.com/app/viewContentsUserReviews?id="..APPLE_ID);
    end
end

--打开系统评论界面列表，某些系统如小米直接跳转至商店
function DeviceEx.openAppDetail()
    if gg.GetNativeVersion() < 5 then return end
    if device.platform == "android" then
        local args = {}
        local sig = "()V"
        local ok, ret = luaj.callStaticMethod(getclassname_(), "openAppDetail", args, sig)
        if ok then
            return true
        end
    elseif device.platform == "ios" then
        device.openURL("itms-apps://itunes.apple.com/app/viewContentsUserReviews?id="..APPLE_ID);
    end
end

function DeviceEx.showAD()
    if gg.GetNativeVersion() < 6 or not (CHANNEL_ID == "201" and IS_SHOWAD) then return end
    if device.platform == "android" then
        local args = {}
        local sig = "()V"
        local ok, ret = luaj.callStaticMethod("com.weile.thirdparty.qihoo.QihooAdHelper", "showAd", args, sig)
        if ok then
            return true
        end
    end
end

function DeviceEx.setIsAutoRotation(isAutoRotation)
    if gg.GetNativeVersion() < 7 then return end
    if device.platform == "ios" then
        local args = {isAuto = isAutoRotation}
        local ok, ret = luaoc.callStaticMethod(getclassname_(), "setIsAutoRotation", args);
    elseif device.platform == "android" then
        local javaParams = { isAutoRotation }
        local ok,ret=  luaj.callStaticMethod(getclassname_(), "setIsAutoRotation", javaParams)
    end
end

function DeviceEx.setIsLandscape(isLandscape)
    if gg.GetNativeVersion() < 7 then return end
    -- 主动翻转时才改变屏幕分辨率大小,修复支付后toast位置错误的问题
    local checkScreenChange = function ()
        local view = cc.Director:getInstance():getOpenGLView()
        local width, height = view:getFrameSize().width, view:getFrameSize().height
        if (isLandscape and height > width) or (not isLandscape and width > height) then
            return true
        end
        return false
    end
    if device.platform == "ios" then
        local args = {isLandscape = isLandscape}
        if checkScreenChange() then
            local ok, ret = luaoc.callStaticMethod(getclassname_(), "setIsLandscape", args);
            if ok then
                cc.exports.SCREEN_SIZE_CHANGE_TAG = true
            end
        end
    elseif device.platform == "android" then
        local javaParams = { isLandscape }
        if checkScreenChange() then
            local ok,ret=  luaj.callStaticMethod(getclassname_(), "setIsLandscape", javaParams)
            if ok then
                print("DeviceEx.setIsLandscape change screen size=========")
                cc.exports.SCREEN_SIZE_CHANGE_TAG = true
            end
        end
    end
end