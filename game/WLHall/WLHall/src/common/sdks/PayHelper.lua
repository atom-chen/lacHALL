-- Author: lee
-- Date: 2016-10-19 17:36:39
local CURRENT_MODULE_NAME = ...
local providerFactoryClass = import(".ProviderFactory", CURRENT_MODULE_NAME)
local PRPP_DESC_ = { [PROP_ID_ROOM_CARD] = "房间卡%d张", [PROP_ID_MONEY] = "%d万豆" }


local PAY_METHOD_MAP={[1]="wechatH5",[2]="alipayH5",[3]="unionpay_client",[4]="appstore",[5]="midas"}

if BRAND==0 then
    PAY_METHOD_MAP[1]="wechat"
end

local moudel = "Pay"
local PayHelper = {
    providers_ = nil
}

PayHelper.payTypes = {
    ["201"] = "360",        -- 奇虎360
    ["202"] = "baidu",      -- 百度
    ["205"] = "mi",         -- 小米
    ["206"] = "vivo",       -- VIVO单机
    ["216"] = "newVivo",    -- VIVO网游
    ["207"] = "oppo",       -- OPPO
    ["210"] = "midas",      -- 应用宝
    ["224"] = "huawei",     -- 华为
    ["228"] = "toutiao",     -- 头条
    ["229"] = "meizu",       -- 魅族
    ["230"] = "samsung"      --三星

}

-- 打开支付的界面
PayHelper.PayStages = {
    HALL = 1,       -- 商城（大厅）
    ROOM = 2,       -- 房间列表
    GAME = 3,       -- 游戏中
    LUCKYBAG = 4,   -- 福袋
}

function PayHelper:lazyInit()
    if not self.providers_ then
        self.providers_ = providerFactoryClass.new(moudel)
    end
end

function PayHelper:reset()
    if self.providers_ then
        self.providers_:removeListener()
        self.providers_ = nil
    end
end

function PayHelper:getIdByString(met)
    return table.indexof(PAY_METHOD_MAP,met)
end

function PayHelper:getMethodById(id)
    id=checkint(id)
    if id>0 and id <=#PAY_METHOD_MAP then
        return PAY_METHOD_MAP[id]
    end
    return PAY_METHOD_MAP[1]
end

--执行支付调起
function PayHelper:doPay(params)
    self:lazyInit()
    assert(checknumber(params.money)>0,"钱数必须大于0")
    assert(params.subject,"标题不能为空")
    assert(params.body,"内容不能为空")
    if self.providers_ then
        params.money=checknumber(params.money)*100 --元转换成分
        GameApp:dispatchEvent(gg.Event.SHOW_LOADING, "正在下单,请稍后。。。")
        self.providers_:doCommand( string.lower(moudel), params )
    end
end

--	todo 使用钻石兑换
local function doexchange_(data, callback)
    gg.Dapi:Exchange(data.type, data.price,function(result)
        printf("----------doexchange_ result")
        callback(resut.status)
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, result.msg)
    end)
end

local function getextbody_(diamond, price)
    local exbody = ""
    if diamond > price then
        exbody = string.format(" (剩余 %d 钻石请去背包查看)", tonumber(diamond - checkint(price)))
    end
    return exbody
end

-- 检查是否只支持苹果内购
function PayHelper:onlySupportIAP()
    if device.platform ~= "ios" then
        return false
    end

    -- 审核模式或者 native 版本 8 以上，iOS 只支持苹果支付
    if IS_REVIEW_MODE or gg.GetNativeVersion() >= 8 then
        return true
    end

    -- 检测是否开启了微信和支付宝支付
    local switch, nums = GameApp:GetPaySwitchTable()
    local hasOther = false
    for i, v in ipairs(switch) do
        -- 1 是微信支付，2 是支付宝支付
        if v.visible and (v.id == 1 or v.id == 2) then
            hasOther = true
            break
        end
    end

    return (not hasOther)
end

--[[
*@brief 显示支付方式
*@param uiObj 父级界面对象
*@param paydata 支付产品的数据
*@param cancelcallback 取消的回调
*@param roomid 房间 ID
*@param ingame 游戏 ID
*@param stage 打开支付的界面类型，需要取 PayHelper.PayStages 中的值
--]]
function PayHelper:showPay(uiObj, paydata, cancelcallback, roomid, ingame, stage)
    ingame=checkint(ingame)
    roomid=checkint(roomid)
    if stage and checkint(stage) > 0 then
        stage = checkint(stage)
    else
        stage = PayHelper.PayStages.HALL
    end
    local switch, nums = GameApp:GetPaySwitchTable()

    local function callpaybymethod(method)
        self:payByMethod(paydata, method, roomid, ingame, stage)
    end

    -- 获取支持的支付方式
    local payMethods = self:getPayMethods(paydata.goods, ingame)
    if #payMethods == 0 then
        -- 没有可用的支付方式
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "该商品暂时无法购买！")
        return
    elseif #payMethods == 1 then
        -- 只有一种支付方式
        callpaybymethod(payMethods[1])
        return
    end

    -- 有多种支付方式，弹出选择界面
    local appscene= gg.IIF(uiObj,uiObj.app_,display.getRunningScene())
    local MethodSelClass = require("hall.views.store.PayMethodPView")

    local methodObj = MethodSelClass.new(appscene, "PayMethodPView", callpaybymethod, clone(paydata), switch)
    if uiObj then
        if  tolua.type(uiObj)=="cc.Scene" and methodObj.pushInScene then
            methodObj:pushInScene()
        else
            methodObj:addTo(uiObj)
        end
    end
    return methodObj
end

-- 获取计费点所支持的支付方式列表
function PayHelper:getPayMethods(goodsID, gameID)
    local methods = {}
    local channelPayMethod = PayHelper.payTypes[CHANNEL_ID]

    -- oppo 渠道下，千炮捕鱼中计费点不走 oppo 支付
    local noChannel = CHANNEL_ID == "207" and gameID and gameID == 226
    if channelPayMethod and (not noChannel) then
        -- 是渠道包的话，只支持渠道支付
        table.insert( methods, channelPayMethod )
    elseif self:onlySupportIAP() then
        -- 只支持苹果支付
        table.insert( methods, "appstore" )
    else
        -- 检查微信和支付宝开关
        local switch, nums = GameApp:GetPaySwitchTable()
        for i, v in ipairs(switch) do
            -- 1 是微信支付，2 是支付宝支付
            if v.visible then
                if v.id == 1 then
                    table.insert( methods, "wechatH5")
                end

                if v.id == 2 then
                    table.insert( methods, "alipayH5")
                end
            end
        end

        -- iOS 固定加入 appstore 支付
        if device.platform == "ios" then
            table.insert( methods, "appstore" )
        end
    end

    -- 过滤掉不能购买的支付方式
    local ret = {}
    for i, v in ipairs(methods) do
        if self:canPayByMethod(goodsID, v) then
            table.insert(ret, v)
        end
    end

    return ret
end

local IOS_DISABLED_GOODS_LIST = {
    -- 对应文档连胜/进阶礼包计费点
    "goods190", "goods191", "goods192", "goods193", "goods194", "goods195",

    -- 对应文档当局返还计费点
    "goods152", "goods153", "goods154", "goods155", "goods156", "goods157", "goods158",

    -- 对应文档超值礼包
    "goods173", "goods174", "goods175", "goods176", "goods177",

    -- 对应文档限时特价礼包
    "goods181", "goods182", "goods183", "goods184", "goods185", "goods186",

    -- 对应超豪大奖池活动计费点
    "goods200", "goods201", "goods202", "goods203", "goods204", "goods205", "goods206",
}

-- 判断一个计费点是否被禁用
-- 目前只用在 iOS 平台，应对苹果审核以及苹果复查
function PayHelper:isGoodsDisabled( goodsID )
    -- 非 iOS，不禁用
    if device.platform ~= "ios" then
        return false
    end

    -- 不是被限制的商品，不禁用
    if not Table:isValueExist(IOS_DISABLED_GOODS_LIST, goodsID) then
        return false
    end

    -- 审核模式。禁用
    if IS_REVIEW_MODE then
        return true
    end

    if not hallmanager then
        return true
    end

    -- 检查玩家游戏局数
    local totalCnt = checkint(hallmanager:GetEffortData(EffortData.TOTAL_GAME_COUNT))
    return totalCnt < 30
end

-- 检查某个计费点是否可以使用指定的支付方式进行支付
function PayHelper:canPayByMethod( goodsID, method )
    -- 百度三星和苹果需要本地有配置的支持才能支付
    if method == "baidu" or method == "appstore" or method == "samsung" then
        local payCfg = checktable(PAY_CONFIG[method])
        if not payCfg[goodsID] then
            return false
        end
    end

    -- iOS 平台下，H5 支付方式需要做单独检测
    if device.platform == "ios" and (method == "wechatH5" or method == "alipayH5") then
        -- 苹果下架包的话，认为是支持 H5 支付的
        return GameApp:CheckModuleEnable(ModuleTag.IOSOffline)
    end

    return true
end

-- 使用指定的支付方式购买计费点
function PayHelper:payByMethod( paydata, method, roomid, ingame, stage )
    if not method or not paydata then
        -- 未指定支付方式或者没有计费点数据
        return
    end

    -- 游客账号限制支付的话，提示激活或者微信登录
    if not GameApp:CheckModuleEnable(ModuleTag.VisitorPay) and
       hallmanager and hallmanager.userinfo.userfrom == USER_FROM_UNLOGIN and
       checkint(hallmanager:GetEffortData(EffortData.TOTAL_GAME_COUNT)) <= 10 then
        hallmanager:tipUnloginUser("根据国家政策要求游客账号不可以充值，请激活账号。",
                                    "根据国家政策要求游客账号不可以充值，请激活账号或者使用微信登录。")
        return
    end

    assert(paydata.goods,"商品标识符 nil")

    if not self:canPayByMethod(paydata.goods, method) then
        -- 不支持此购买方式
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "暂时无法购买此商品")
        return
    end

    local pay_args= { type= method, goods=paydata.goods , money=paydata.price, roomid=roomid, ingame=ingame, pay_stage=stage, autobuy=1}
    pay_args.subject = paydata.name
    pay_args.body = paydata.name or "豆豆"
    pay_args.back_dou = paydata.back_dou    -- 当局返还计费点需要的参数
    if paydata.type then
        local propDef = gg.GetPropList()
        local propName = propDef[paydata.type].name or PROPNAME[paydata.type]

        -- body 为【道具名称】x【数量】
        pay_args.body=propName.."x"..paydata.count
        if paydata.type == PROP_ID_MONEY then
            pay_args.body = pay_args.body .. "万"
        end
        -- 如果没有 subject，那么 subject 与 body 一致
        pay_args.subject=pay_args.subject or pay_args.body
    end
    assert(pay_args.subject, "商品标题空")
    Log(paydata)

    pay_args.ext = checktable(pay_args.ext)
    pay_args.ext.ico = paydata.ico

    -- 三星支付需要添加appid
    if method == "samsung" then
        pay_args.appid = SAMSUNG_APPID
        pay_args.waresid = PAY_CONFIG[method][pay_args.goods]
    end

    pay_args.version_grade = 1

    self:doPay(pay_args)
    -- if method == PAY_METHOD_MAP[1] then
    --     -- 微信 H5 支付，需要先获取客户端 IP 地址
    --     gg.Dapi:GetClientIP(function(clientip)
    --         if clientip then
    --             pay_args.clientip = clientip
    --             self:doPay(pay_args)
    --         elseif cancelcallback then
    --             cancelcallback(0)
    --         end
    --     end)
    -- else
    --     self:doPay(pay_args)
    -- end
end

-- 检查是否包含 H5 SDK
function PayHelper:checkHasH5SDK()
    if device.platform == "ios" then
        return (not gg.GetNativeCfg("ios_no_h5", false))
    end

    if gg.PayHelper.payTypes[CHANNEL_ID] then
        -- android 渠道包不包含 H5 SDK
        return false
    end

    return true
end

return PayHelper
