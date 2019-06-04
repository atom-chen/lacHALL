## 获取设备剪贴板文本
---------

```
local tmp = device.getPasteboardString(function (str)
    printf("剪贴板内容====="..str);
end);
```

## 系统分享  
---------
```
android:     
不支持URL（可以用文本代替）
朋友圈必须要有图片，朋友圈支持图文
发送给好友只能发送图片或者文本
ios:
wxscene = 1 且 ios版本在11以下 支持直接打开微信分享界面（无法直接分享朋友圈或好友，由用户选择）
ios朋友圈文本无效
*@param wxscene number类型 0:发送给微信好友(android) 1:发送微信朋友圈(android) 直接发起微信分享界面(ios,仅支持ios11以下版本)
*@param shareType number类型 
0:图文链接  doShareWebType(android朋友圈如果传入链接则调用SDK分享) 
1:链接+文字 doShareAppWebType
2:图片    doShareImageType
3:文本    doShareTextType (ios如果传入纯文本则调用SDK分享)
*@param params table类型，可用字段：
{
    content = "文本内容",      -- 
    imgUrl = "图片绝对路径",     -- 分享朋友圈必传   example: cc.FileUtils:getInstance():fullPathForFilename(checkstring(CUR_PLATFORM).."/img_ewm.jpg"
    url = "分享的链接",          -- 
}
*@param callback 回调函数 同SDK分享回调处理
*@param appid 微信appid
```
---------------------------------------------------------------------------
```
local imgPath = cc.FileUtils:getInstance():fullPathForFilename(checkstring(CUR_PLATFORM).."/img_ewm.jpg");
gg.ShareHelper:doShareBySystem(1, 0, {content = "分享测试", imgUrl = imgPath, url = "http://www.baidu.com"}, function ( result )
printf("share callback status=%d type=%s msg=%s", result.status, result.type, result.msg)
    end)
```
---------------------------------------------------------------------------

## 推送 
-----------
```
NotificationHelper.lua

--发起一个标题为local title 内容为local content 延迟5秒之后执行，每60秒重复一次的本地通知
gg.NotificationHelper:registLocalNotification(gg.NotificationHelper.notifyType.TEST_N1, "local title", "local content", 5, 60)

--取消一个id为gg.NotificationHelper.notifyType.TEST_N1的本地通知（包括重复和不重复的）
gg.NotificationHelper:cancelLocalNotification(gg.NotificationHelper.notifyType.TEST_N1)

--取消所有本地通知
gg.NotificationHelper:cancelAllLocalNotification()

--绑定一个用于远程推送的唯一id  用于点对点推送
gg.NotificationHelper:bindUserName("user id", function (ret)
    printf("绑定结果"..ret)
    if ret == "success" then
        printf("绑定别名成功")
    end
end);

--解绑别名
gg.NotificationHelper:unBindUserName("user id", function (ret)
    printf("解绑结果"..ret)
    if ret == "success" then
        printf("解绑别名成功")
    end
end);

--设置一组tag用于分组推送
local tag = "test1|test2|test3"
if gg.NotificationHelper:setTag(tag) then
    printf("设置tag成功"..tag)
else
    printf("设置tag失败"..tag)
end

--获得点击远程通知的参数
local notifyMsgStr = gg.NotificationHelper:getClickRemoteNotifyMsg()
printf(notifyMsgStr)

--获取离线通知参数内容
notifyMsgStr = gg.NotificationHelper:getOfflineNotifyMsg()
printf(notifyMsgStr)

--获取本地通知点击之后传递的参数内容
notifyMsgStr = gg.NotificationHelper:getLocalNotifyClickMsg()
printf(notifyMsgStr)
```
