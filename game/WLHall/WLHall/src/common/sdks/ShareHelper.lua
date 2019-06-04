-- Author: lee
-- Date: 2016-10-19 17:36:39


local CURRENT_MODULE_NAME = ...
local providerFactoryClass = import(".ProviderFactory", CURRENT_MODULE_NAME)
local moudel = "WXShare"
local ShareHelper = {
    providers_ = nil
}

function ShareHelper:lazyInit()
    if not self.providers_ then
        self.providers_ = providerFactoryClass.new(moudel,self)
    end
end

function ShareHelper:reset()
    if self.providers_ then
        self.providers_:removeListener()
        self.providers_ = nil
    end
end

--执行分享调起
function ShareHelper:doShare(params,callback,needRetry)
    self:lazyInit()
    params=checktable(params)
    assert(params.sharetype,"sharetype is nil")
    if self.providers_ then
        if needRetry then
            -- 失败时需要重试，那么需要把此次分享的参数和回调记录下来
            cc.exports.SHARE_RETRY_PARAMS = {args=params, cb=callback}
        end
        self.providers_:setListener(callback)
        self.providers_:doCommand( string.lower(moudel),  params )
    end
end

-- sharetype [web appweb text image]
-- appid
-- wxscene
-- title imgurl weburl desc text imgpath
--  WXScene={
--     Session  = 0,       -- /**< 聊天界面    */
--     Timeline = 1,       -- /**< 朋友圈      */
--     Favorite = 2,       -- /**< 收藏       */
-- }
--执行分享调起 wxscene 枚举 WXScene.Session 默认朋友圈 appid[可空] 默认读取配置
function ShareHelper:doShareWebType(title,imgurl,weburl,wxscene,callback,desc,appid)
    local args ={}
    args.sharetype="web"
    assert(title,"title is nil")
    assert(imgurl,"imgurl is nil")
    assert(weburl,"weburl is nil")

    args.title=title
    args.imgurl=imgurl
    args.desc=desc or title
    args.weburl=weburl
    args.wxscene=wxscene
    args.appid=appid
    -- 如果是分享到朋友圈，对于特定的失败情况（错误码为2，未知错误），需要重试一次
    self:doShare(args, callback, checkint(args.wxscene) == 1)
end

--执行分享调起 wxscene 默认朋友圈 appid[可空] 默认读取配置 默认缩略图为应用图标
function ShareHelper:doShareAppWebType(title,desc,weburl,wxscene,callback,appid)
    assert(desc,"desc is nil")
    assert(desc,"desc is nil")
    assert(weburl,"weburl is nil")
    local args ={}
    args.sharetype="appweb"
    args.title=title
    args.desc=desc
    args.weburl=weburl
    args.wxscene=wxscene
    args.appid=appid
    -- 如果是分享到朋友圈，对于特定的失败情况（错误码为2，未知错误），需要重试一次
    self:doShare(args, callback, checkint(args.wxscene) == 1)
end

--执行分享调起 wxscene 默认朋友圈 appid[可空] 默认读取配置
function ShareHelper:doShareImageType(imgpath,wxscene,callback,appid)
    local args ={}
    args.sharetype="image"
    assert(imgpath,"imgpath is nil")
    args.imgpath=imgpath
    args.wxscene=wxscene
    args.appid=appid
    -- 如果是分享到朋友圈，对于特定的失败情况（错误码为2，未知错误），需要重试一次
    self:doShare(args, callback, checkint(args.wxscene) == 1)
end

--执行分享调起 wxscene 默认朋友圈 appid[可空] 默认读取配置
function ShareHelper:doShareTextType(text,wxscene,callback,appid)
    local args ={}
    args.sharetype="text"
    assert(text,"text is nil")
    args.text=text
    args.wxscene=wxscene
    args.appid=appid
    -- 如果是分享到朋友圈，对于特定的失败情况（错误码为2，未知错误），需要重试一次
    self:doShare(args, callback, checkint(args.wxscene) == 1)
end

--显示分享方式选择界面 wxscene 默认朋友圈 appid[可空] 默认读取配置
function ShareHelper:showShareMethod(node)
    -- body
end

--[[
--目前只支持 wxscene = 1(仅支持朋友圈) 类型0: 图片+链接+文字 类型1:图片+文字  类型2: 图片

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
]]
function ShareHelper:doShareBySystem( wxscene, shareType, params, callback, appid )
    assert(wxscene == 1, "系统分享仅支持朋友圈分享")
    assert(params.imgUrl and params.imgUrl ~= "", "系统分享朋友圈必须带图片")
    self:lazyInit()
    local content = params.content;
    local imgUrl = params.imgUrl;
    local url = params.url;

    local tmpCallback = function (result)
        result.msg = self.providers_:_getShareErrMsg(result.status)
        result.msg = result.msg or ""
        if result.msg ~= "" then
            GameApp:dispatchDelayEvent(gg.Event.SHOW_TOAST,0, result.msg)
        end
        GameApp:dispatchDelayEvent(gg.Event.ON_SHARE_RESULT,0,result)

        if nil ~= callback then
            gg.InvokeFuncNextFrame(callback, result)
        end
    end

    local iosCallback = function (errcode, type, msg) 
        local result = {status=errcode,type=type,msg=msg}
        printf("ios share callback errcode=%d type=%s msg=%s", errcode, type, msg)
        tmpCallback(result)
    end

    local androidCallback = function (luastr)
        local ok,argtable = pcall(function()
            return loadstring(luastr)();
        end)
        if ok then
            tmpCallback(argtable)
        end
    end

    local curCallback = nil
    if device.platform == "ios" then
        curCallback = iosCallback
    elseif device.platform == "android" then
        curCallback = androidCallback
    end
    if nil == curCallback then
        return
    end

    if shareType == 0 then
        --图片+链接+文字
        if gg.GetNativeVersion() < 5 then
            printf("share type=0 native版本 < 5 切换SDK分享");
            self:doShareWebType(content, "file://"..imgUrl, url, wxscene, callback, "", appid);
            return
        end
        assert(url and url ~= "", "shareType = 0 url = nil")
        assert(content and content ~= "", "shareType = 0 content = nil")
        if device.platform == "android" then
            content = content.."\n"..url
            url = ""
        end
        device.shareBySystemPlatform(wxscene, content, self:convertImgPathToJsonStr(imgUrl), url, curCallback);
    elseif shareType == 1 then
        --图片+文字
        if gg.GetNativeVersion() < 5 then
            printf("share type=1 native版本 < 5 SDK不支持图片+文字 改成只发图片");
            self:doShareImageType(imgUrl,wxscene,callback,appid);
            return
        end
        assert(content and content ~= "", "shareType = 1 content = nil")
        device.shareBySystemPlatform(wxscene, content, self:convertImgPathToJsonStr(imgUrl), "", curCallback);
    elseif shareType == 2 then
        --图片
        if gg.GetNativeVersion() < 5 then
            self:doShareImageType(imgUrl,wxscene,callback,appid);
            return
        end
        device.shareBySystemPlatform(wxscene, "", self:convertImgPathToJsonStr(imgUrl), "", curCallback);
    end

--[[
    if shareType == 0 then
        --图文链接文字 (微信朋友圈仅支持图文)
        if gg.GetNativeVersion() < 5 then
            printf("android 微信分享不支持图文链接和文字 切换SDK分享");
            self:doShareWebType(content, imgUrl, url, wxscene, callback, "", appid);
            return
        end
        if device.platform == "android" and (nil ~= url and "" ~= url) then
            content = content.."\n"..url
            url = ""
        end
        device.shareBySystemPlatform(wxscene, content, self:convertImgPathToJsonStr(imgUrl), url, curCallback);
    elseif shareType == 1 then
        --链接+文字
        if gg.GetNativeVersion() < 5 or device.platform == "android" then
            printf("android 微信分享不支持链接和文字 切换SDK分享");
            self:doShareAppWebType(content, "", url, wxscene, callback, appid);
            return
        end
        device.shareBySystemPlatform(wxscene, content, "", url, curCallback);
    elseif shareType == 2 then
        --图片
        if gg.GetNativeVersion() < 5 then
            self:doShareImageType(imgUrl,wxscene,callback,appid);
            return
        end
        device.shareBySystemPlatform(wxscene, "", self:convertImgPathToJsonStr(imgUrl), "", curCallback);
    elseif shareType == 3 then
        --文字
        if gg.GetNativeVersion() < 5 or wxscene == 1 or device.platform == "ios" then    --android朋友圈和ios不支持纯文字分享
            self:doShareTextType(content, wxscene, callback, appid)
            return
        end
        device.shareBySystemPlatform(wxscene, content, "", "", curCallback);
    end
]]
end

function ShareHelper:convertImgPathToJsonStr(imgPath)
    local jsonTmp = {
        imgPath
    }
    local jsonStr = json.encode(jsonTmp);
    return jsonStr
end

-- params.appIcon       游戏图标地址
-- params.appName       游戏名称
-- params.title         分享标题
-- params.content       分享内容
-- params.imagePath     分享图片地址
-- params.returnContent 点击分享内容跳转链接
-- params.downloadPath  下载地址
-- params.extra         额外参数
function ShareHelper:doShareByYouqu(_params, _callback)
    if gg.GetNativeVersion() < 6 then return end
    assert(type(_params) == "table", "分享参数必须是table")
    GameApp:dispatchEvent(gg.Event.DISABLE_APPENTER)
    if device.platform == "android" then
        local javaMethodName = "doShareByParams"
        local javaParams = {json.encode(_params), _callback}
        local javaMethodSig = "(Ljava/lang/String;I)V"
        local ok,ret = luaj.callStaticMethod("com.weile.thirdparty.youqushare.YouQuShareHelper", javaMethodName, javaParams, javaMethodSig)
        if not ok then
            return true
        end
    elseif device.platform == "ios" then
        _params.callback = _callback
        local ok, ret = luaoc.callStaticMethod("AppController", "shareByYouqu", _params)
        if ok then
            return true;
        end
    end
end

return ShareHelper