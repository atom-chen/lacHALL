--
-- Author: Zhang Bin
-- Date: 2018-06-25
-- Web Game 相关的 controller
--
local WebGameCtrl = {}

-- 获取 token 的 url
if IS_LOCAL_TEST then
    -- 内网测试IP
    WebGameCtrl.REQ_TOKEN_IP = "http://192.168.69.62:5061"
else
    if IS_WEILE then
        WebGameCtrl.REQ_TOKEN_IP = "http://h5api.weile.com"
    else
        WebGameCtrl.REQ_TOKEN_IP = "http://h5api.jixiang.cn"
    end
end

WebGameCtrl.REQ_PARAM_FMTS = {
    TOKEN_FMT = "/auth/v1/login?appId=%s&channelId=%s&sessionId=%s&targetAppId=%s",
    PAY_IN_RMB_FMT = "/trade/v1/pay?appId=%s&channelId=%s&orderId=%s&redirectUrl=%s",
    PAY_IN_DIAMOND_FMT = "/trade/v1/pay?orderId=%s",
    CONFIRM_PAY_RESULT_FMT = "/trade/v1/orderstatus?orderId=%s",
    PAY_IN_APPLE_FMT = "/trade/v1/pay_in_iap",
}

-- 获取 token 需要使用的 appid 和 secret
local GET_TOKEN_APPID = "100000000001"
local GET_TOKEN_SECRET = "c8a4ff16e33b3842f0ddcdc3c581a080"

-- 域名白名单
local ALLOWED_HOSTS = {
    "weile.com",
    "jiaxianghudong.com",
    "jixiang.cn",
    "xinyueyouxi.com",
}

local H5PayType = {
    wechat = 1,
    alipay = 2,
}

-- 本地测试的 host
local LOCAL_TEST_HOST = "192.168.69.62"

-- 与 sdk 约定的协议头
local PROTOCOL_HEADER = "WLWG://?"

WebGameCtrl.SUPPORT_CMDS = {
    SHOW_DIAMOND_STORE = "showDiamondStore",
    PAY_IN_APPLE = "payInApple",
    GET_DIAMOND_NUMBER = "getDiamondNumber",
    GET_PLATFORM = "getPlatform",
    REGISTER_EVENTS = "registerEvents",
    PAY_IN_RMB = "payInRMB",
    PAY_IN_DIAMOND = "payInDiamond",
    CONFIRM_PAY_RESULT = "confirmPayResult",
    GET_CONFIG = "getConfig",
}

WebGameCtrl.DISPATCHER_FUNC = {}

WebGameCtrl.EVENT_HANDLER_PARAMS = nil
WebGameCtrl.EVENT_NAMES = {
    ENTER_BACKGROUND = "WLWGbackground",
    ENTER_FOREGROUND = "WLWGforeground",
    DIAMOND_CHANGED  = "WLWGdiamondChanged",
}

WebGameCtrl.WEB_GAME_ID = nil

--处理json 数据
local function handlerjson_(callback)
    assert(callback,"callback args is nil")
    return function(state, data)
        if type(data) == "table" then
            callback(data)
            return
        end

        local ok, datatable = pcall(function() return json.decode(data) end)
        if ok and callback then
            callback(datatable)
        else
            callback()
        end
    end
end

function WebGameCtrl:getUserToken( cpid, callback )
    if not hallmanager or not cpid then
        if callback then
            callback()
        end
        return
    end

    local userSession = string.upper(hallmanager:GetSession())
    -- 请求的url
    local reqParamStr = string.format(WebGameCtrl.REQ_PARAM_FMTS.TOKEN_FMT, APP_ID, CHANNEL_ID, userSession, cpid)
    local url = WebGameCtrl.REQ_TOKEN_IP .. reqParamStr
    -- http请求Header
    local reqHeader = self:_getReqHeader("GET", reqParamStr)

    return gg.Http:Get(url, handlerjson_(callback), nil, nil, reqHeader)
end

function WebGameCtrl:_getReqHeader(HTTPMethod, reqParamStr)
    if not hallmanager then return end
    -- 传入的时间戳以毫秒为单位
    local ts = string.format("%.0f", tonumber(socket.gettime()) * 1000)
    -- 唯一串码，32位以内且30分钟不可重复
    -- 生成方式：使用用户session值拼接上当前时间戳进行一次md5加密
    local nonce = Helper.Md5(string.upper(hallmanager:GetSession()) .. ts)
    -- 签名
    -- String strToSign = HTTPMethod + Headers + URL + Secret
    local Headers = string.format("X-QP-AppId:%s\nX-QP-Nonce:%s\nX-QP-Timestamp:%s", GET_TOKEN_APPID, nonce, ts)
    local strToSign = HTTPMethod .. string.gsub(Headers, "\n", "") .. reqParamStr .. GET_TOKEN_SECRET
    -- http请求Header
    local reqHeader = string.format("%s\nX-QP-Signature:%s", Headers, string.upper(Helper.Md5(strToSign)))

    return reqHeader
end

-- 是否在 H5 游戏中
function WebGameCtrl:isInWebGame( )
    print("---- is in web game : "..tostring(self._isGaming))
    return self._isGaming
end

-- 是否在竖屏 H5 游戏中
function WebGameCtrl:isInPortoaitWebGame()
    return self._isPortoait and self:isInWebGame()
end

-- 打开游戏的web界面
function WebGameCtrl:openGameWebView(appid, gameid)
    assert(appid, "appid is nil")
    GameApp:dispatchEvent(gg.Event.SHOW_LOADING, "数据加载中...")
    gg.WebGameCtrl:getUserToken(appid, function(cb)
        GameApp:dispatchEvent(gg.Event.SHOW_LOADING)
        cb = checktable(cb)
        if cb.code and tonumber(cb.code) == 0 then
            local data = checktable(cb.data)
            local url
            -- 检测到存在gameUrl字段时，直接使用gameUrl
            if data.gameUrl then
                url = gg.base64Decode(data.gameUrl)
            else
                local openId = data.openId
                local nonceStr = data.nonceStr
                local sign = data.sign
                local timestamp = data.timestamp
                local accessToken = data.accessToken
                local urlFmt = data.appServer .. "?openId=%s&nonceStr=%s&sign=%s&timestamp=%s&accessToken=%s"
                url = string.format(urlFmt, openId, nonceStr, sign, timestamp, accessToken)
            end

            -- 记录配置信息
            self._serverCfg = data.cfg
            if device.platform ~= "ios" and device.platform ~= "android" then
                device.openURL(url)
            else
                local isPortoait = checkint(data.rotate) == 1 --true=竖屏 false=横屏
                gg.WebGameCtrl._isPortoait = isPortoait
                GameApp:dispatchEvent(gg.Event.SHOW_VIEW, "GeneralWebView", {push = true}, url, nil, true, isPortoait)
            end

            -- 启动游戏成功记录下进入的h5游戏id
            self.WEB_GAME_ID = gameid
            self._isGaming = true
        else
            GameApp:dispatchEvent(gg.Event.SHOW_TOAST, cb.msg or "获取用户登录数据失败")
        end
    end)
end

-- 处理网页游戏跳转的 url
function WebGameCtrl:handleUrl(webview, url)
    if not webview then
        return
    end

    -- 需要处理的协议
    if string.find(string.upper(url), PROTOCOL_HEADER) == 1 then
        local paramStr = Url:decodeURI(string.sub(url, #PROTOCOL_HEADER + 1))
        print("paramStr : " .. paramStr)
        local params = json.decode(paramStr)
        if params then
            self:handleProtocol(webview, params)
        end

        return false
    end

    -- 允许访问的 url 才能打开，防止 cp 私自跳转
    return self:isAllowedUrl(url)
end

-- 判断 url 是否可以进行访问
function WebGameCtrl:isAllowedUrl( url )
    local host = string.gsub(url, "^http[s]*://(.-)/.-$", "%1") -- 有协议头的话，过滤协议
    host = string.gsub(host, "^(.-)/.-$", "%1") -- 无协议头的话，直接过滤路径
    host = string.gsub(host, "^(.-):.-$", "%1") -- 过滤端口

    -- 内部测试，允许内部测试的域名
    if IS_LOCAL_TEST and host == LOCAL_TEST_HOST then
        return true
    end

    local segs = Table:reverse(string.split(host, "."))
    for _, allowedHost in ipairs(ALLOWED_HOSTS) do
        local allowedSegs = Table:reverse(string.split(allowedHost, "."))
        local isAllowed = true
        for i = 1, #allowedSegs do
            if not segs[i] or segs[i] ~= allowedSegs[i] then
                isAllowed = false
                break
            end
        end

        if isAllowed then
            return true
        end
    end

    return false
end

-- 派发事件
function WebGameCtrl:dispatchEvent(webview, eventName, ...)
    if not webview or not self.EVENT_HANDLER_PARAMS then
        return
    end

    local funcName = self.EVENT_HANDLER_PARAMS.params.eventDispatcher
    local jsStr = string.format("%s(%s)", funcName, self:_genJSParams(eventName, ...))
    webview:evaluateJS(jsStr)
end

-- 处理协议相关命令
function WebGameCtrl:handleProtocol( webview, params )
    if not params.cmd then return end

    -- 需要记录回调参数
    if params.cbDispatcher then
        WebGameCtrl.DISPATCHER_FUNC[params.cmd] = params
    end

    if WebGameCtrl[params.cmd] then
        WebGameCtrl[params.cmd](WebGameCtrl, webview, params)
    else
        print("unsupport cmd : "..params.cmd)
    end
end

-- 回调到 js sdk 的相关处理
function WebGameCtrl:callbackToJS( webview, cmd, ... )
    if not webview then
        return
    end

    local params = WebGameCtrl.DISPATCHER_FUNC[cmd]
    if not params then
        return
    end

    local jsStr = string.format("%s(%s)", params.cbDispatcher, self:_genJSParams(params.callbackId, ...))
    webview:evaluateJS(jsStr)
    WebGameCtrl.DISPATCHER_FUNC[cmd] = nil
end

function WebGameCtrl:_genJSParams( callbackId, ... )
    local paramList = {...}
    local ret = "\"" .. callbackId .. "\""
    for i, v in ipairs(paramList) do
        if type(v) == "string" then
            ret = ret .. ", \"" .. v .. "\""
        elseif type(v) == "number" then
            ret = ret .. ", " .. v
        elseif type(v) == "table" then
            local vStr = string.gsub(json.encode(v), "\"", "'")
            ret = ret .. ", \"" .. vStr .. "\""
        end
    end

    return ret
end

function WebGameCtrl:_doH5Pay(url, payType)
    -- 默认是微信支付
    payType = payType or H5PayType.wechat
    if payType ~= H5PayType.wechat and payType ~= H5PayType.alipay then
        return "不支持的支付方式"
    end

    if device.platform == "android" then
        -- android 通过系统浏览器打开 url 跳转支付
        device.openURL(url)
        return
    end

    if payType == H5PayType.wechat then
        -- ios 微信支付直接使用内置的 webview
        device.openPortraitWebView(url, "开启支付")
    elseif payType == H5PayType.alipay then
        -- ios 支付宝支付只有新版本的内置 webview 才支持拉起支付宝
        if gg.GetNativeVersion() >= 6 then
            device.openPortraitWebView(url, "开启支付")
        else
            device.openURL(url)
        end
    end
end

--[[
web 协议的处理函数
函数名与协议中的 cmd 参数一致
]]

-- 显示钻石商城
function WebGameCtrl:showDiamondStore(webview, params)
    GameApp:dispatchEvent(gg.Event.STORE_VIEW_OPEN)
end

-- 关闭网页游戏
function WebGameCtrl:close(webview, params)
    -- 清理记录的数据
    self.DISPATCHER_FUNC = {}
    self.EVENT_HANDLER_PARAMS = nil
    self.WEB_GAME_ID = nil
    self._isGaming = false
    self._serverCfg = nil

    GameApp:dispatchEvent(gg.Event.CLOSE_WEB_GAME)
end

-- 获取钻石数量
function WebGameCtrl:getDiamondNumber(webview, params)
    if hallmanager and hallmanager.userinfo then
        local diamondCnt = checkint(hallmanager.userinfo.xzmoney)
        self:callbackToJS(webview, params.cmd, diamondCnt)
    end
end

-- 获取平台
function WebGameCtrl:getPlatform(webview, params)
    self:callbackToJS(webview, params.cmd, device.platform)
end

-- 获取配置信息
function WebGameCtrl:getConfig(webview, params)
    local retCfg = ""
    if self._serverCfg then
        retCfg = string.gsub(self._serverCfg, "\"", "'")
    end
    self:callbackToJS(webview, params.cmd, self._serverCfg)
end

-- 注册事件
function WebGameCtrl:registerEvents(webview, params)
    -- 记录事件回调相关的参数
    self.EVENT_HANDLER_PARAMS = params
    -- 回调通知
    self:callbackToJS(webview, params.cmd)
end

-- 微信/支付宝支付
function WebGameCtrl:payInRMB(webview, params)
    if device.platform == "ios" and gg.GetNativeVersion() >= 8 then
        local ret = {}
        ret.code = 1000000
        ret.msg = "iOS平台请在商城购买钻石进行兑换！"
        self:callbackToJS(webview, params.cmd, ret)
        return
    end

    -- 请求的url
    local returnurl = string.format("https://pay.jiaxianghudong.com/open/%s/?n=%s", Helper.packagescheme, Helper.packagescheme)
    local reqParamStr = string.format(WebGameCtrl.REQ_PARAM_FMTS.PAY_IN_RMB_FMT, APP_ID, CHANNEL_ID, params.params.orderId, Url:encodeURI(returnurl))
    local url = WebGameCtrl.REQ_TOKEN_IP .. reqParamStr
    -- http请求Header
    local reqHeader = self:_getReqHeader("GET", reqParamStr)
    -- 请求的回调方法
    local callback = function(cb)
        cb = checktable(cb)
        local data = {}
        if cb.code and tonumber(cb.code) == 0 then
            local payUrl = gg.base64Decode(cb.data.redirectUrl)
            if payUrl and payUrl ~= "" then
                local msg = self:_doH5Pay(payUrl)
                data.msg = msg or cb.msg
                data.code = gg.IIF(msg, 1000000, 0)
            else
                data.code = 1000000
                data.msg = "获取支付链接失败"
            end
        else
            data.code = gg.IIF(cb.code, tonumber(cb.code), 1000000)
            data.msg = cb.msg or "支付请求拉取的数据错误！！！"
        end

        -- 通过 log 输出错误信息
        if data.msg then
            print("H5 游戏拉起 RMB 支付："..data.msg)
        end
        self:callbackToJS(webview, params.cmd, data)
    end

    return gg.Http:Get(url, handlerjson_(callback), nil, nil, reqHeader)
end

-- 钻石支付
function WebGameCtrl:payInDiamond(webview, params)
    -- 请求的url
    local reqParamStr = string.format(WebGameCtrl.REQ_PARAM_FMTS.PAY_IN_DIAMOND_FMT, params.params.orderId)
    local url = WebGameCtrl.REQ_TOKEN_IP .. reqParamStr
    -- http请求Header
    local reqHeader = self:_getReqHeader("GET", reqParamStr)
    -- 请求的回调方法
    local callback = function(cb)
        cb = checktable(cb)
        self:callbackToJS(webview, params.cmd, cb)
    end

    return gg.Http:Get(url, handlerjson_(callback), nil, nil, reqHeader)
end

-- 确认支付状态
function WebGameCtrl:confirmPayResult(webview, params)
    -- 请求的url
    local reqParamStr = string.format(WebGameCtrl.REQ_PARAM_FMTS.CONFIRM_PAY_RESULT_FMT, params.params.orderId)
    local url = WebGameCtrl.REQ_TOKEN_IP .. reqParamStr
    -- http请求Header
    local reqHeader = self:_getReqHeader("GET", reqParamStr)
    -- 请求的回调方法
    local callback = function(cb)
        self:callbackToJS(webview, params.cmd, cb)
    end

    return gg.Http:Get(url, handlerjson_(callback), nil, nil, reqHeader)
end

--------------------------------------
-- IAP支付
--------------------------------------
local IAP_MAP = {
    ["1"]  = "goods140",
    ["6"]  = "goods140",
    ["12"] = "goods141",
    ["30"] = "goods142",
    ["50"] = "goods143",
    ["98"] = "goods144",
}
-- 苹果支付
function WebGameCtrl:payInApple(webview, params)
    self._iosPayWebview = webview
    if device.platform ~= "ios" then
        self:_notifyIAPResult(false, nil, "非苹果设备无法使用苹果支付")
        return
    end

    local args = {}
    args.type = "appstore"
    args.money = tonumber(params.params.fee)
    args.goods = IAP_MAP[tostring(params.params.fee)]
    args.listener = handler(self, self.doIosPayCallback)

    local cfgTable = checktable(PAY_CONFIG[args.type])
    local productids = table.values(cfgTable)
    -- 去除重复的 item
    local tableTemp = {}
    for i,v in ipairs(productids) do
        tableTemp[v] = true
    end
    args.productidarray = json.encode(table.keys(tableTemp))
    args.productid = cfgTable[args.goods]
    if not args.productid then
        self:_notifyIAPResult(false, nil, string.format("苹果支付不支持 %s元的商品", params.params.fee))
        return
    end

    local payArgs = {}
    -- 需要把 json 字符串中的 \' 转换为 '，否则 OC 解析会出问题
    payArgs.data = string.gsub(json.encode(args), "\\'", "'")
    payArgs.listener = args.listener
    local ok, ret = luaoc.callStaticMethod("AppController", "doPay", payArgs)
    if not ok then
        self:_notifyIAPResult(false, nil, "调用oc支付失败！")
    end
end

function WebGameCtrl:doIosPayCallback(status, paytype, msg)
    local params = WebGameCtrl.DISPATCHER_FUNC[WebGameCtrl.SUPPORT_CMDS.PAY_IN_APPLE]
    if not params then return end

    if paytype == "appstore" and status == 0 then
        -- 支付成功
        local ok, args = pcall(function()
            return loadstring(msg)()
        end)

        if ok then
            -- 请求的url
            local url = WebGameCtrl.REQ_TOKEN_IP .. WebGameCtrl.REQ_PARAM_FMTS.PAY_IN_APPLE_FMT
            -- http请求Header
            local reqHeader = self:_getReqHeader("POST", WebGameCtrl.REQ_PARAM_FMTS.PAY_IN_APPLE_FMT)

            local reqParams = {}
            reqParams.orderId = params.params.orderId
            reqParams.receiptData = args.receipt
            Log(reqParams)
            -- 请求的回调方法
            local callback = function(cb)
                cb = checktable(cb)
                Log(cb)
                if cb.code and cb.code == 0 then
                    -- 支付验证成功
                    self:_notifyIAPResult(true, cb)
                else
                    -- 支付验证失败
                    self:_notifyIAPResult(false, nil, cb.msg or "苹果支付校验失败")
                end
            end

            return gg.Http:Post(url, handlerjson_(callback), reqParams, nil, nil, nil, reqHeader)
        else
            self:_notifyIAPResult(false, nil, string.format("解析 IAP 参数失败: %s %s", tostring(args), tostring(msg)))
        end
    elseif status == 3 then
        -- 支付请求中
        print("正在请求支付...")
    else
        if msg == "用户禁止IOS支付" then
            msg = "请在访问限制中开启App内购买项目功能"
        end

        -- 支付失败
        self:_notifyIAPResult(false, {payStatus = status}, msg or "苹果支付失败")
    end
end

-- 通知 IAP 支付结果给 JS
function WebGameCtrl:_notifyIAPResult(isSuccess, data, errMsg)
    if tolua.isnull(self._iosPayWebview) then
        print("ios pay web view is null")
        return
    end

    if isSuccess then
        -- 支付成功，将数据直接返回给 JS
        self:callbackToJS(self._iosPayWebview, WebGameCtrl.SUPPORT_CMDS.PAY_IN_APPLE, data)
    else
        -- 支付失败
        local ret = {}
        ret.code = 1000000
        ret.msg = errMsg
        ret.data = data or {}
        self:callbackToJS(self._iosPayWebview, WebGameCtrl.SUPPORT_CMDS.PAY_IN_APPLE, ret)
    end
end

return WebGameCtrl
