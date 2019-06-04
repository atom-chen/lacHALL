--
-- Author: lee
-- Date: 2016-10-19 16:38:00
local luaoc = require("cocos.cocos2d.luaoc")
local ProviderBase = import(".ProviderBase")
local PayIOS = class("PayIOS", ProviderBase)
local IOS_CLASS_NAME = "AppController"

local localCfgFile = require("common.FileTable").New();
local writablePath = cc.FileUtils:getInstance():getWritablePath()
-- 获取本地配置路径变量
local function getIosReceipt()
    return writablePath .. string.format("ios_receipt_%s", tostring(gg.UserData:GetUserId()))
end

function PayIOS:addVerifyTransactionListener(node)
    -- local function callback(event)

    -- end
    -- local listener = cc.EventListenerCustom:create("IOS_VERIFY_TRANSACTION_EVENT", callback)
    -- eventDispatcher:addEventListenerWithSceneGraphPriority(listener, node)
end

function PayIOS:addListener()

    -- local ok, ret =  luaoc.callStaticMethod("AppController", "registerScriptHandler", {listener = handler(self, self.callback_)})
    --   local ok, ret =  luaoc.callStaticMethod(IOS_CLASS_NAME, "registerScriptHandler", {listener = handler(self, self.callback_)})
    -- printf("add listerer   ".. tostring(ok))
    return self
end

function PayIOS:removeListener()
    luaoc.callStaticMethod(IOS_CLASS_NAME, "removeScriptListener")
end

-- 保存支付成功的数据
local function savereceipt_(receipt_obj)
    localCfgFile:Save(receipt_obj, getIosReceipt())
end

-- 读取缓存的数据
local function readreceipt_()
    return localCfgFile:Open(getIosReceipt())
end

local function delreceipt_()
    printf("del receipt file")
    savereceipt_({})
    gg.UserData:SetConfigKV({["receipt_times"] = 0})
end

--恢复购买
function PayIOS:checkFailOrder()
    local receipt = readreceipt_()
    local times = checkint(gg.UserData:getConfigByKey("receipt_times"))
    -- 恢复购买设置3次上限
    if times >= 3 then
        delreceipt_()
        return false
    end

    if receipt and Table:length(receipt) > 0 then
        GameApp:dispatchEvent(gg.Event.SHOW_LOADING, "正在为您恢复购买..")
        self:verifyIosReceipt_(receipt, "appstore")
        local newV = times + 1
        gg.UserData:SetConfigKV({["receipt_times"] = newV})
        return true
    end
    return false
 end

--添加验证订单
function PayIOS:verifyIosReceipt_(receipt, paytype)
    if receipt and Table:length(receipt) > 0 then
        gg.Dapi:VerifyIosReceipt(receipt, function(msg)
            msg = checktable(msg)
            if msg.status then
                delreceipt_()
            end
            if checkint(msg.status) == 0 then
                local ret_tab = {status = msg.status, paytype = paytype, msg = "支付成功！"}
                self:onPayCallback(ret_tab)
            else
                GameApp:dispatchEvent(gg.Event.SHOW_LOADING)
                GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG, "校验失败！")
            end
            printf("-----VerifyIosReceipt")
        end)
    else
        GameApp:dispatchEvent(gg.Event.SHOW_LOADING)
        delreceipt_()
        printf("解析ios参数失败 %s  %s ", tostring(args), tostring(luastr))
    end
end

function PayIOS:payIosCallback_(status, paytype, msg)
    printf("-----payIosCallback_ ---- " .. tostring(status) .. " , " .. tostring(paytype) .. " , " .. tostring(msg))
    local Enum = checktable(PayIOS.Enum)
    if paytype == "appstore" and status == Enum.STATE_SUCCESS then
        GameApp:dispatchEvent(gg.Event.SHOW_LOADING)
        GameApp:dispatchEvent(gg.Event.SHOW_LOADING, "购买成功,正在处理中...")

        local ok, args = pcall(function() return loadstring(msg)(); end)
        savereceipt_(args)
        self:verifyIosReceipt_(args, paytype)
    else
        -- 优化提示语
        if msg == "用户禁止IOS支付" then
            msg = "请在访问限制中开启App内购买项目功能"
        end
        local ret_tab = { status = status, paytype = paytype, msg = msg }
        self:onPayCallback(ret_tab)
    end
end

function PayIOS:doPayReq(args)
    args.type = args.type or ""
    args.money = tonumber(args.money) / 100 --分转换成元
    args.listener = handler(self, self.payIosCallback_)
    local cfgTable = checktable(PAY_CONFIG[args.type])
    if args.type == "appstore" then --苹果商店追加参数
        local productids = table.values(cfgTable)

        -- 去除重复的 item
        local tableTemp = {}
        for i,v in ipairs(productids) do
            tableTemp[v] = true
        end
        args.productidarray = json.encode(table.keys(tableTemp))
        args.productid = cfgTable[args.goods]
        if cfgTable[args.productid] then
            -- 如果是替代计费点，用替代计费点购买
            args.productid = cfgTable[args.productid];
        end
        if not args.productid then
            printf("不支持的支付金额,请检查 ios ProductId 配置！")
            return
        end
        GameApp:dispatchEvent(gg.Event.SHOW_LOADING, "正在获取商品信息...")
    elseif args.type == "alipayH5" then
        args.rsa_private = cfgTable.rsa_private
    else
        table.merge(args, cfgTable)
    end

    if args.type == "wechatH5" or args.type == "alipayH5" then
        -- H5 支付需要指定 app_url 参数用于支付后调起游戏
        args.app_url = Helper.packagescheme
        if not gg.PayHelper:checkHasH5SDK() then
            -- 没有 H5 SDK 的话，使用网页方式拉起 H5 支付
            local url = args.callbackurl
            print("pay url==="..url)
            self:doH5Pay(url, args.type)
            return
        end
    end

    -- 因为 luaoc 传的参数必须是 table。
    -- 而且当table中某个 key 的值也是 table 的话，在调用到 OC 代码时会被丢弃
    -- 所以这里为了保留 args 参数的数据结构，先将 args 转为 json 字符串。
    -- 然后放到一个 table 中进行传递
    local payArgs = {}
    -- 需要把 json 字符串中的 \' 转换为 '，否则 OC 解析会出问题
    payArgs.data = string.gsub(json.encode(args), "\\'", "'")
    payArgs.listener = args.listener
    local ok, ret = luaoc.callStaticMethod(IOS_CLASS_NAME, "doPay", payArgs)
    printf("-------- doPay return status " .. tostring(ok))
    if ok then
        if args.type == "wechatH5" or args.type == "alipayH5" then
            -- H5 支付，需要标记是支付中。以便游戏回到前台时弹出提示信息
            cc.exports.isPaying = true
        end
    else
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "调用oc支付失败！")
    end
end

function PayIOS:doH5Pay(url, payType)
    if payType ~= "wechatH5" and payType ~= "alipayH5" then
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "不支持的支付方式")
        return
    end

    if payType == "wechatH5" then
        -- ios 微信支付直接使用内置的 webview
        device.openPortraitWebView(url, "开启支付")
        device.closeWebView()
    elseif payType == "alipayH5" then
        -- ios 支付宝支付只有新版本的内置 webview 才支持拉起支付宝
        if gg.GetNativeVersion() >= 6 then
            device.openPortraitWebView(url, "开启支付")
            device.closeWebView()
        else
            device.openURL(url)
        end
    end
end

return PayIOS