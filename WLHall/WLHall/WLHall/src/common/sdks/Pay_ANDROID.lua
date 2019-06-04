--
-- Author: Your Name
-- Date: 2016-10-17 20:33:00
--
local luaBridge = require("cocos.cocos2d.luaj")

local JAVA_CLASS_NAME = "com.weile.pay.PayApi"

local ProviderBase = import(".ProviderBase")
local PayAndroid = class("PayAndroid", ProviderBase)

--{handler(self, self.callback_)

-- 支付类型，有新增的支付类型直接在这里添加即可
PayAndroid.payClasses = {
    ["wechatH5"] = "com.weile.thirdparty.h5pay.WXPay",
    ["alipayH5"] = "com.weile.thirdparty.h5pay.Alipay",
    ["midas"]    = "com.weile.thirdparty.ysdk.YSDKPay",
    ["baidu"]    = "com.weile.thirdparty.baidu.BaiduPay",
    ["oppo"]     = "com.weile.thirdparty.oppo.OppoPay",
    ["mi"]       = "com.weile.thirdparty.xiaomi.XiaomiPay",
    ["vivo"]     = "com.weile.thirdparty.vivo.VivoPay",
    ["newVivo"]  = "com.weile.thirdparty.vivo.VivoPay",
    ["huawei"]   = "com.weile.thirdparty.huawei.HWPay",
    ["360"]      = "com.weile.thirdparty.qihoo.QihooPay",
    ["wechat"]   = "com.weile.thirdparty.weixin.WXPay",
    ["toutiao"]  = "com.weile.thirdparty.toutiao.ToutiaoPay",
    ["samsung"]  = "com.weile.thirdparty.samsung.SamsungPay",
    ["meizu"] = "com.weile.thirdparty.meizu.MeizuPay"
}

function PayAndroid:addListener()
    luaBridge.callStaticMethod(JAVA_CLASS_NAME, "addScriptListener", { handler(self, self.onCallback_) })
    return self
end

function PayAndroid:removeListener()
    luaBridge.callStaticMethod(JAVA_CLASS_NAME, "removeScriptListener")
end


function PayAndroid:onCallback_(luastr)
    local ok,argtable = pcall(function()
        return loadstring(luastr)();
    end)
     if ok then
        self:onPayCallback(argtable)
     else
        printf("PayAndroid:onCallback_"..tostring(luastr))
     end
end

--[[--------{"roomid":0,"status":120,"money":"500",
"token":"930fa8e2265ade44a6f82cec6e5d07a0",
"udid":"7A739E889D602784D6A2D13D3867153DAFD901C5",
"msg":"商品配置不存在","ingame":0,"debug":0,"autobuy":0,"payType":"wechat"}
]]
function PayAndroid:doPayReq(args)
    self:addListener()
    local javaMethodName = "doPay"
    args.virtual=checkint(args.virtual)

    local payClass = PayAndroid.payClasses[args.type]

    if args.type == "midas" then
        -- 米大师，需要额外的APP_KEY
        args.midasAppKey = MIDAS_APP_KEY
    end

    if args.type == "oppo" or args.type == "360" then
        args.callbackurl = gg.Dapi:GetPayNotifyUrl(args.type)
    end

    if payClass == nil then
        print("不支持的支付类型：" .. tostring(args.type))
        return
    end

    local cfgTable = checktable(PAY_CONFIG[args.type])
    local jsonArgs = json.encode(args)
    local jsonCfg = json.encode(cfgTable)

    if args.type == "baidu" then
        local argsNew = clone(args)
        local cfgNew = clone(cfgTable)

        for k,v in pairs(cfgNew) do
            if type(v) == "table" then
                if k == argsNew.goods then
                    argsNew.body = v.body
                end

                cfgNew[k] = v.id
            end
        end

        jsonArgs = json.encode(argsNew)
        jsonCfg = json.encode(cfgNew)
    end

    if args.type == "toutiao" or args.type == "samsung" then
        -- 头条切支付切换到支付宝微信银联防止断线重连
        GameApp:dispatchEvent(gg.Event.DISABLE_APPENTER)
    end

    print("---------- PayAndroid:doPayReq jsonArgs " .. jsonArgs)
    print("---------- PayAndroid:doPayReq jsonCfg " .. jsonCfg)

    local javaParams = {
        payClass,
        jsonArgs,
        jsonCfg
    }
    local javaMethodSig = "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V"
    luaBridge.callStaticMethod(JAVA_CLASS_NAME, javaMethodName, javaParams, javaMethodSig)
    if args.type == "wechatH5" or args.type == "alipayH5" then
        -- H5 支付，需要标记是支付中。以便游戏回到前台时弹出提示信息
        cc.exports.isPaying = true
    end
end

return PayAndroid


