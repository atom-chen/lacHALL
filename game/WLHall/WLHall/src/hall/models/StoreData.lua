-- 商城数据
local M={
    --diamond_rmb_relation_table_={[40]=6,[130]=18,[450]=50,[1000]=98,[2000]=188,[5000]=448} --钻石 人民币 关系表
    --diamond_bean_relation_={[20]=2,[450]=45}, -- 钻石 豆 豆（单位万） 关系表
}

function M:GetGoodsDataById(id)
    id=checkint(id)
    local beantable =self:GetBeanTable()
    for i,v in ipairs(beantable) do
         if v.id==id then
            return clone(v),k
         end
    end
    for i,v in ipairs(self:GetGoodsTable()) do
         if v.id==id then
            return clone(v),k
         end
    end
    for i,v in ipairs(self:GetZuanshiTable()) do
        if v.id==id then
            return clone(v),k
        end
    end
    for i,v in ipairs(self:GetDouTable()) do
        if v.id==id then
            return clone(v),k
        end
    end
    return clone(beantable[1])
end

function M:GetBeanDataById(id)
    id=checkint(id)
    for i,v in ipairs(self:GetBeanTable()) do
         if v.id==id then
            return v,k
         end
    end
end

--豆豆价格表
local BEAN_PRICE_LIST={
    { goods="goods101", id=1, type=PROP_ID_MONEY, ico="hall/store/ico_bean_lv1.png", count=6,  ori_count=6, gift_count=0, price=6 },
    { goods="goods102", id=2, type=PROP_ID_MONEY, ico="hall/store/ico_bean_lv2.png", count=12.5,  ori_count=12, gift_count=0.5, price=12 },
    { goods="goods103", id=3, type=PROP_ID_MONEY, ico="hall/store/ico_bean_lv3.png", count=32,  ori_count=30, gift_count=2, price=30 },
    { goods="goods104", id=4, type=PROP_ID_MONEY, ico="hall/store/ico_bean_lv4.png", count=55,  ori_count=50, gift_count=5, price=50 },
    { goods="goods105", id=5, type=PROP_ID_MONEY, ico="hall/store/ico_bean_lv5.png", count=110, ori_count=98, gift_count=12, price=98 },
    { goods="goods107", id=6, type=PROP_ID_MONEY, ico="hall/store/ico_bean_lv5.png", count=600, ori_count=488, gift_count=112, price=488 },
    { goods="goods106", id=7, type=PROP_ID_MONEY, ico="hall/store/ico_bean_lv5.png", count=230, ori_count=198, gift_count=32, price=198 },
}

-- 旧版本豆豆计费点
local OLD_BEAN_PRICE_LIST = {
    { goods="goods1", id=1, type=PROP_ID_MONEY, ico="hall/store/ico_bean_lv1.png", count=4,  ori_count=4, gift_count=0, price=6 },
    { goods="goods2", id=2, type=PROP_ID_MONEY, ico="hall/store/ico_bean_lv2.png", count=9,  ori_count=9, gift_count=0, price=12 },
    { goods="goods3", id=3, type=PROP_ID_MONEY, ico="hall/store/ico_bean_lv3.png", count=24,  ori_count=24, gift_count=0, price=30 },
    { goods="goods4", id=4, type=PROP_ID_MONEY, ico="hall/store/ico_bean_lv4.png", count=45,  ori_count=45, gift_count=0, price=50 },
    { goods="goods5", id=5, type=PROP_ID_MONEY, ico="hall/store/ico_bean_lv5.png", count=100, ori_count=100, gift_count=0, price=98 },
    { goods="goods7", id=6, type=PROP_ID_MONEY, ico="hall/store/ico_bean_lv5.png", count=500, ori_count=500, gift_count=0, price=488 },
    { goods="goods6", id=7, type=PROP_ID_MONEY, ico="hall/store/ico_bean_lv5.png", count=200, ori_count=200, gift_count=0, price=188 },
}

-- 苹果审核专用计费点
local IOS_REVIEW_BEAN_LIST = {
    { goods="goods108", id=8, type=PROP_ID_MONEY, ico="hall/store/ico_bean_lv1.png", count=1,  ori_count=1, gift_count=0, price=1 },
    { goods="goods109", id=9, type=PROP_ID_MONEY, ico="hall/store/ico_bean_lv1.png", count=3,  ori_count=3, gift_count=0, price=3 },
    { goods="goods110", id=10, type=PROP_ID_MONEY, ico="hall/store/ico_bean_lv5.png", count=150,  ori_count=128, gift_count=22, price=128 },
    { goods="goods111", id=11, type=PROP_ID_MONEY, ico="hall/store/ico_bean_lv5.png", count=360,  ori_count=298, gift_count=62, price=298 },
}

--[[豆豆价格表]]
function M:GetBeanTable(lv)
    -- 非 iOS 平台，直接使用新的配置
    if device.platform ~= "ios" then
        return clone(BEAN_PRICE_LIST)
    end

    -- iOS 平台，根据计费点配置来选择是否使用新的配置
    local ret = clone(BEAN_PRICE_LIST)

    -- 审核模式，加入审核专用计费点
    if IS_REVIEW_MODE then
        for i, v in ipairs(IOS_REVIEW_BEAN_LIST) do
            table.insert( ret, v )
        end
    end

    return ret
end

--[[道具价格表]]
-- goods:商品标识
-- propid:对应的道具ID,如果不是道具则不配置
-- ico:当不是道具的情况,需配置icon图片名称
-- name:当不是道具的情况,需配置道具名称
-- count:商品显示的内含道具数量
-- price:商品价格
-- hldpic:豆豆兑换价格（不配置值能用人民币购买）
-- hot:热卖
-- isDes:默认无简介
function M:GetGoodsTable()
    local cfg = {
        { id=16, goods = "month_card_vip" ,  ico = "hall/store/img_icon_xingyao.png" , name = "星耀月卡", price = 298, isDes = true , origPrice = 1000 },
        { id=17, goods = "month_card_normal" ,  ico = "hall/store/img_icon_guizu.png" , name = "贵族月卡", price = 30, isDes = true , origPrice = 128 },

        { id=18, goods = "goods18" , ico = "common/prop/gift_1.png" , name = "魔法道具包A" , price = 12 , isDes = true },
        { id=19, goods = "goods19" , ico = "common/prop/gift_1.png" , name = "魔法道具包B" , price = 12 , isDes = true },
        { id=20, goods = "goods120" , type= PROP_ID_ROOM_CARD , count = 2 , price = 6 },
        { id=21, goods = "goods121" , type= PROP_ID_CANSAI , count = 20 , price = 6 },
        { id=22, goods = "goods122" , type= PROP_ID_JIPAI , count = 7 , ori_count=6,gift_count=1,  price = 6 },
        { id=23, goods = "goods123" , type= PROP_ID_GAIMING , count = 1 , price = 6 },
        { id=24, goods = "goods124" , type= PROP_ID_HAIDILAOYUE , count = 20 , price = 6 },
        { id=25, goods = "goods125" , type= PROP_ID_HAIDILAOYUE , count = 100 , price = 30 },
        { id=26, goods = "goods126" , type= PROP_ID_HAIDILAOYUE , count = 350 , price = 98 },
    }
    return clone(cfg)
end

------------- 贵族月卡相关 ---------------
-- 获取贵族月卡商品信息
function M:GetPrivilegeGoodsInfo()
    local table = self:GetGoodsTable()
    for k , v in pairs( table ) do
        if v.goods == "month_card_normal" then
            return clone(v)
        end
    end

    return nil
end

-- 获取贵族月卡礼包配置
function M:GetPrivilegeGiftTable()
    local cfg = {
        day = 30 ,
        prop = {{PROP_ID_MONEY, 150000}, {PROP_ID_JIPAI, 15}},
        daily_prop = {
            {PROP_ID_MONEY,    20000},
            {PROP_ID_CANSAI,   2},
            {PROP_ID_LIAN_PEN, 3},
            {PROP_ID_CHUI_ZI,  3},
            {PROP_ID_FAN_QIE,  3},
            {PROP_ID_PEN_QI,   3},
            {PROP_ID_QIANG,    3},
            {PROP_ID_MAO_BI,   3},
            {PROP_ID_HONG_BAO, 3},
            {PROP_ID_ZUI_CHUN, 3},
            {PROP_ID_XO,       3},
            {PROP_ID_KOU_XIANG_TANG, 3},
        },
        leitai_ratio = 0.1,
    }
    return clone(cfg)
end

------------- 星耀月卡相关 ---------------
-- 获取星耀月卡商品信息
function M:GetMonthCardVIPGoodsInfo( )
    local table = self:GetGoodsTable()
    for k , v in pairs( table ) do
        if v.goods == "month_card_vip" then
            return clone(v)
        end
    end

    return nil
end

-- 获取星耀月卡礼包配置
function M:GetMonthCardVIPGiftTable()
    local cfg = {
        day = 30 ,
        prop = {{PROP_ID_MONEY, 2000000}, {PROP_ID_263, 10000}},
        daily_prop = {
            {PROP_ID_MONEY,    200000},
            {PROP_ID_LEITAIKA,  2},
            {PROP_ID_LIAN_PEN, 10},
            {PROP_ID_CHUI_ZI,  10},
            {PROP_ID_FAN_QIE,  10},
            {PROP_ID_PEN_QI,   10},
            {PROP_ID_QIANG,    10},
            {PROP_ID_MAO_BI,   10},
            {PROP_ID_HONG_BAO, 10},
            {PROP_ID_ZUI_CHUN, 10},
            {PROP_ID_XO,       10},
            {PROP_ID_KOU_XIANG_TANG, 10},
        },
        leitai_ratio = 0.3,
    }
	-- 非渠道包100元即时话费卡替换为50荣誉卡
    if not gg.IsChannelPack() then
        cfg.prop = {{PROP_ID_MONEY, 2000000}, {PROP_ID_LEITAIKA, 50}}
    end
    return clone(cfg)
end

-- [[道具兑换豆豆表]]
-- goods:商品标识
-- ico 物品的图片
-- srcprop 用于兑换道具
-- price 价格 单位角
-- targetCount 兑换豆豆的数量
function M:GetDouTable()
    local cfg = {
        -- {id=46, goods = "goods50", type=PROP_ID_MONEY, ico = "hall/store/ico_bean_lv2.png" , srcprop= PROP_ID_261 ,price = 1000, targetCount = 100000 },
        -- {id=47, goods = "goods47", type=PROP_ID_XZMONEY, ico = "hall/store/ico_zuanshi_lv1.png" , srcprop= PROP_ID_261 ,price = 600, count=30 },
        -- {id=48, goods = "DIAMOND_TO_DOU", type=PROP_ID_MONEY, ico = "hall/store/ico_bean_lv2.png", srcprop= PROP_ID_XZMONEY },
    }
    return clone(cfg)
end

-- 最新钻石价格表
function M:GetZuanshiTable()
    local new_cfg = {
        { goods="goods140", id=33, type=PROP_ID_XZMONEY, ico="hall/store/ico_zuanshi_lv1.png", count=60,  price=6},
        { goods="goods141", id=34, type=PROP_ID_XZMONEY, ico="hall/store/ico_zuanshi_lv2.png", count=120, price=12},
        { goods="goods142", id=35, type=PROP_ID_XZMONEY, ico="hall/store/ico_zuanshi_lv3.png", count=300, price=30},
        { goods="goods143", id=36, type=PROP_ID_XZMONEY, ico="hall/store/ico_zuanshi_lv3.png", count=500, price=50},
        { goods="goods144", id=37, type=PROP_ID_XZMONEY, ico="hall/store/ico_zuanshi_lv3.png", count=980, price=98},
        { goods="goods145", id=38, type=PROP_ID_XZMONEY, ico="hall/store/ico_zuanshi_lv3.png", count=1980, price=198},
        { goods="goods146", id=39, type=PROP_ID_XZMONEY, ico="hall/store/ico_zuanshi_lv3.png", count=4880, price=488},
    }

    return clone(new_cfg)
end

-- 通过商品标识 获取对应豆豆表信息
function M:GetDouInfoByGoodsID(goodsID)
    for i,v in ipairs(self:GetDouTable()) do
         if v.goods and v.goods==goodsID then
            return clone(v)
         end
    end
    return nil
end

-- 魔法道具相关的商品
local MAGIC_PROP_GOODS = {
    { id=21, goods = "goods21" , type= PROP_ID_PEN_QI, price = 12 , count = 50 , hldpic = 200000 },
    { id=22, goods = "goods22" , type= PROP_ID_CHUI_ZI, price = 12 , count = 50 , hldpic = 200000 },
    { id=23, goods = "goods23" , type= PROP_ID_MAO_BI , price = 12 , count = 50 , hldpic = 200000 },
    { id=24, goods = "goods24" , type= PROP_ID_HONG_BAO , price = 12 , count = 50 , hldpic = 200000 },
    { id=25, goods = "goods25", type= PROP_ID_FAN_QIE , price = 12 , count = 50 , hldpic = 200000 },
    { id=26, goods = "goods26", type= PROP_ID_KOU_XIANG_TANG , price = 12 , count = 50 , hldpic = 200000 },
    { id=27, goods = "goods27", type= PROP_ID_ZUI_CHUN , price = 12 , count = 50 , hldpic = 200000 },
    { id=28, goods = "goods28", type= PROP_ID_LIAN_PEN , price = 12 , count = 50 , hldpic = 200000 },
    { id=29, goods = "goods29", type= PROP_ID_QIANG , price = 12 , count = 50 , hldpic = 200000 },
    { id=30, goods = "goods30", type= PROP_ID_XO , price = 12 , count = 50 , hldpic = 200000 },
}

-- 通过道具 ID 获取对应的商品信息
function M:GetGoodInfoByPropID(propID)
    -- ios 审核模式下，获取魔法道具礼包商品
    if IS_REVIEW_MODE and device.platform == "ios" then
        local giftTable = self:GetGoodsContainPropTable()

        for k, v in pairs(giftTable) do
            for i, item in ipairs(v) do
                if item[1] == propID then
                    local goodsTB = self:GetGoodsTable()
                    for idx, data in ipairs(goodsTB) do
                        if data.goods == k then
                            return data
                        end
                    end
                end
            end
        end

        return nil
    end

    for i,v in ipairs(MAGIC_PROP_GOODS) do
         if v.type and v.type==propID then
            return clone(v)
         end
    end

    return nil
end

-- 获取兑换表
function M:GetExchangeTable()
    local exchangeTable = {}
    local t = self:GetGoodsTable()
    for k , v in pairs(t) do
        table.insert(exchangeTable , v)
    end

    -- 苹果审核模式下，且钻石模块有开启，道具界面增加使用钻石兑换道具
    if IS_REVIEW_MODE and device.platform == "ios" and GameApp:CheckModuleEnable(ModuleTag.Diamond) then
        local diamondExchangeTb = {
            { id=41, goods = "goods41" , type=PROP_ID_PEN_QI, srcprop=PROP_ID_XZMONEY, price=90, count=50},
            { id=42, goods = "goods42" , type=PROP_ID_CHUI_ZI, srcprop=PROP_ID_XZMONEY, price=90, count=50},
            { id=43, goods = "goods43" , type=PROP_ID_MAO_BI, srcprop=PROP_ID_XZMONEY, price=90, count=50},
            { id=44, goods = "goods44" , type=PROP_ID_HONG_BAO, srcprop=PROP_ID_XZMONEY, price=90, count=50},
            { id=45, goods = "goods45" , type=PROP_ID_FAN_QIE, srcprop=PROP_ID_XZMONEY, price=90, count=50},
        }
        for i,v in ipairs(diamondExchangeTb) do
            table.insert(exchangeTable , v)
        end
    end

    return exchangeTable
end

-- 获取特惠表
function M:GetSaleTable()

    local saleTable = {}
    local t = self:GetGoodsTable()
    for k , v in pairs(t) do

        if v and v.price then

            v.hldpic = nil
            table.insert(saleTable , v)
        end
    end
    return saleTable
end

-- VIP特权商品表
function M:GetVipGoodsTable( lv )
    local cfg = {

        { id = 60, goods = "vip_1_01" , name = "VIP1专属礼包" , price = 6, purchasePrice = 20, contain = { {PROP_ID_MONEY,150000},{PROP_ID_CANSAI,5} } },
        { id = 61, goods = "vip_1_02" , name = "VIP2专属礼包" , price = 12, purchasePrice = 40, contain = { {PROP_ID_MONEY,200000},{PROP_ID_CANSAI,5} } },
        { id = 62, goods = "vip_1_03" , name = "VIP3专属礼包" , price = 30, purchasePrice = 89, contain = { {PROP_ID_MONEY,500000},{PROP_ID_CANSAI,8},{PROP_ID_JIPAI,3} } },
        { id = 63, goods = "vip_1_04" , name = "VIP4专属礼包" , price = 30, purchasePrice = 99, contain = { {PROP_ID_MONEY,700000},{PROP_ID_CANSAI,8},{PROP_ID_JIPAI,3} } },
        { id = 64, goods = "vip_1_05" , name = "VIP5专属礼包" , price = 50, purchasePrice = 188, contain = { {PROP_ID_MONEY,900000},{PROP_ID_CANSAI,10},{PROP_ID_JIPAI,5}} },
        { id = 65, goods = "vip_1_06" , name = "VIP6专属礼包" , price = 50, purchasePrice = 288, contain = { {PROP_ID_MONEY,1000000},{PROP_ID_CANSAI,10},{PROP_ID_JIPAI,5} } },
        { id = 66, goods = "vip_1_07" , name = "VIP7专属礼包" , price = 50, purchasePrice = 388, contain = { {PROP_ID_MONEY,1200000},{PROP_ID_JIPAI,5},{PROP_ID_LEITAIKA,10} } },
        { id = 67, goods = "vip_1_08" , name = "VIP8专属礼包" , price = 98, purchasePrice = 488, contain = { {PROP_ID_MONEY,3000000},{PROP_ID_JIPAI,10},{PROP_ID_LEITAIKA,20} } },
        { id = 68, goods = "vip_1_09" , name = "VIP9专属礼包" , price = 98, purchasePrice = 588, contain = { {PROP_ID_MONEY,4000000},{PROP_ID_JIPAI,10},{PROP_ID_LEITAIKA,20} } },
        { id = 69, goods = "vip_1_10" , name = "VIP10专属礼包" , price = 98, purchasePrice = 688, contain = { {PROP_ID_MONEY,5000000},{PROP_ID_JIPAI,10},{PROP_ID_LEITAIKA,20} } },
        { id = 70, goods = "vip_1_11" , name = "VIP11专属礼包" , price = 198, purchasePrice = 1000, contain = { {PROP_ID_MONEY,6000000},{PROP_ID_JIPAI,15},{PROP_ID_LEITAIKA,40} } },
        { id = 71, goods = "vip_1_12" , name = "VIP12专属礼包" , price = 198, purchasePrice = 1280, contain = { {PROP_ID_MONEY,7000000},{PROP_ID_JIPAI,15},{PROP_ID_LEITAIKA,40} } },
        { id = 72, goods = "vip_1_13" , name = "VIP13专属礼包" , price = 198, purchasePrice = 1480, contain = { {PROP_ID_MONEY,8000000},{PROP_ID_JIPAI,15},{PROP_ID_LEITAIKA,40} } },
        { id = 73, goods = "vip_1_14" , name = "VIP14专属礼包" , price = 488, purchasePrice = 1988, contain = { {PROP_ID_MONEY,12000000},{PROP_ID_JIPAI,20},{PROP_ID_LEITAIKA,60} } },
        { id = 74, goods = "vip_1_15" , name = "VIP15专属礼包" , price = 488, purchasePrice = 2688, contain = { {PROP_ID_MONEY,15000000},{PROP_ID_JIPAI,20},{PROP_ID_LEITAIKA,60} } },
        { id = 75, goods = "vip_1_16" , name = "VIP16专属礼包" , price = 488, purchasePrice = 2988, contain = { {PROP_ID_MONEY,20000000},{PROP_ID_JIPAI,20},{PROP_ID_LEITAIKA,60} } },
    }

    if GameApp:IsCommonGame() then
        local ret = clone(cfg)
        for i, v in pairs(ret) do
            for j, value in pairs(v.contain) do
                if value[1] == PROP_ID_ROOM_CARD then
                    value[1] = PROP_ID_XZMONEY
                end
            end
        end
        return ret[lv]
    else
        return cfg[lv]
    end
end

--[[魔法道具礼包包含道具配置]]
function M:GetGoodsContainPropTable()
    local cfg = {
        [ "goods18" ] = { { PROP_ID_LIAN_PEN , 10 } , { PROP_ID_CHUI_ZI , 10 } , { PROP_ID_FAN_QIE , 10 } , { PROP_ID_KOU_XIANG_TANG , 10 } , { PROP_ID_HONG_BAO , 10 }   } ,
        [ "goods19" ] = { { PROP_ID_QIANG , 10 } , { PROP_ID_MAO_BI , 10 } , { PROP_ID_XO , 10 } , { PROP_ID_ZUI_CHUN , 10 } , { PROP_ID_PEN_QI , 10 }   },
    }
    return clone(cfg)
end

 local fHonorCfg = {
    { id=101, goods="hlv_1_1", name="新手专属礼包", price=6 },
    { id=102, goods="hlv_1_2", name="初段专属礼包", price=12 },
    { id=103, goods="hlv_1_3", name="中段专属礼包", price=30 },
    { id=104, goods="hlv_1_4", name="高段专属礼包", price=98 },
    { id=105, goods="hlv_1_5", name="专家专属礼包", price=198 },
    { id=106, goods="hlv_1_6", name="大师专属礼包", price=488 },
 }

--[[荣誉等级专属礼包价格表]]
function M:GetHonorGoodsTable( hlv )
    return clone(fHonorCfg[hlv])
end

--[[荣誉等级专属礼包道具配置数据]]
function M:GetHonorGiftPropsCfg( hlv )
    local cfg = {
        { { PROP_ID_MONEY, 180000 } },
        { { PROP_ID_GAIMING, 2 }, { PROP_ID_MONEY, 250000 } },
        { { PROP_ID_CANSAI, 10 }, { PROP_ID_MONEY, 360000 } },
        { { PROP_ID_CANSAI, 20 }, { PROP_ID_MONEY, 1500000 } },
        { { PROP_ID_CANSAI, 20 }, { PROP_ID_MONEY, 2400000 } },
        { { PROP_ID_CANSAI, 50 }, { PROP_ID_MONEY, 6000000 } },
    }
    return clone(cfg[hlv])
end

-- 获取超豪大奖池活动计费点数据
function M:getCHDJCGoods()
    local goods_list = {
        {goods="goods200", coin = 12 , name = "12元礼包" ,price = 12 ,gift = "赠2.5万豆" ,image = "lb_1.png", sort = 1},
        {goods="goods201", coin = 30 , name = "30元礼包" ,price = 30 ,gift = "赠8万豆" ,image = "lb_2.png", sort = 2},
        {goods="goods202", coin = 50 , name = "50元礼包" ,price = 50 ,gift = "赠18万豆" ,image = "lb_3.png", sort = 6},
        {goods="goods203", coin = 98 , name = "98元礼包" ,price = 98 ,gift = "赠42万豆" ,image = "lb_4.png", sort = 3},
        {goods="goods206", coin = 488 , name = "488元礼包" ,price = 488 ,gift = "赠280万豆" ,image = "lb_5.png", sort = 5},
    }

    local check_goods_list = {
        {goods="goods204", coin = 198 , name = "198元礼包" ,price = 198 ,gift = "赠102万豆" ,image = "lb_5.png", sort = 4},
        {goods="goods205", coin = 188 , name = "188元礼包" ,price = 188 ,gift = "赠97万豆" ,image = "lb_5.png", sort = 4},
    }

    local ret = {}
    -- 过滤掉不能买的计费点
    for i, v in ipairs(goods_list) do
        local methods = gg.PayHelper:getPayMethods(v.goods)
        if #methods > 0 then
            table.insert( ret, v )
        end
    end

    -- 198 和 188 选择一个可以购买的计费点插入
    for i, v in ipairs(check_goods_list) do
        local methods = gg.PayHelper:getPayMethods(v.goods)
        if #methods > 0 then
            table.insert( ret, v )
            break
        end
    end

    return ret
end

-----------------------------------------------
-- 商城界面显示配置
-----------------------------------------------
-- 获取豆豆商城显示数据
function M:GetBeanShopCfg()
    -- 获取豆豆
    local beanTb = self:GetBeanTable()
    -- 按豆子数量排序计费点
    table.sort(beanTb, function(a, b)
        return checkint(a.count) < checkint(b.count)
    end)
    -- 插入贵族月卡
    if GameApp:CheckModuleEnable(ModuleTag.Privilege) then
        local privilegeData = self:GetPrivilegeGoodsInfo()
        table.insert(beanTb, 1, privilegeData)
    end
    -- 插入星耀月卡
    if GameApp:CheckModuleEnable(ModuleTag.XYMonthCard) then
        local monthCardData = self:GetMonthCardVIPGoodsInfo()
        table.insert(beanTb, 1, monthCardData)
    end

    return beanTb
end

-- 获取钻石商城显示数据
function M:GetDiamondShopCfg()
    if not GameApp:CheckModuleEnable(ModuleTag.Diamond) then return nil end

    local diamondTb = self:GetZuanshiTable()
    -- -- 插入贵族月卡
    -- if GameApp:CheckModuleEnable(ModuleTag.Privilege) then
    --     local privilegeData = self:GetPrivilegeGoodsInfo()
    --     table.insert(diamondTb, 1, privilegeData)
    -- end
    -- -- 插入星耀月卡
    -- if GameApp:CheckModuleEnable(ModuleTag.XYMonthCard) then
    --     local monthCardData = self:GetMonthCardVIPGoodsInfo()
    --     table.insert(diamondTb, 1, monthCardData)
    -- end

    return diamondTb
end

-- 获取道具商城显示数据
function M:GetPropShopCfg()
    local propTb = self:FilterPropShopTable()

    -- 非审核模式下，插入兑换豆的数据
    if not IS_REVIEW_MODE then
        for i, j in pairs(checktable(self:FilterExchangeTable())) do
            table.insert(propTb, j)
        end
    end

    return propTb
end

-- 根据开关筛掉道具商城不可显示的计费点
function M:FilterPropShopTable()
    local tb = self:GetExchangeTable()

    table.filter(tb, function(v, k)
        -- 开关关闭或者微乐平台筛掉房卡(视频劵)
        if not GameApp:CheckModuleEnable(ModuleTag[PROP_ID_ROOM_CARD]) or IS_WEILE then
            if v.type == PROP_ID_ROOM_CARD then
                return false
            end
        end
        -- 贵族月卡筛选
        if not GameApp:CheckModuleEnable(ModuleTag.Privilege) then
            if v.id == 16 then
                return false
            end
        end
        -- 新耀月卡筛选
        if not GameApp:CheckModuleEnable(ModuleTag.XYMonthCard) then
            if v.id == 17 then
                return false
            end
        end
        -- 海底捞月卡筛选
        if not GameApp:CheckModuleEnable(ModuleTag.HaiDiLaoYue) then
            if v.type == PROP_ID_HAIDILAOYUE then
                return false
            end
        end

        return true
    end)

    local propTb = {}
    table.walk(tb, function(v) table.insert(propTb, v) end)

    return propTb
end

-- 根据开关筛掉兑换商品中不可显示的计费点
function M:FilterExchangeTable()
    local tb = self:GetDouTable()
    table.filter(tb, function(v, k)
        -- 钻石相关的商品
        if not GameApp:CheckModuleEnable(ModuleTag.Diamond) then
            if v.type == PROP_ID_XZMONEY or v.srcprop == PROP_ID_XZMONEY then
                return false
            end
        end
        -- 红包券相关
        if not GameApp:CheckModuleEnable(ModuleTag[PROP_ID_261]) then
            if v.srcprop == PROP_ID_261 then
                return false
            end
        end

        return true
    end)

    local exchTb = {}
    table.walk(tb, function(v) table.insert(exchTb, v) end)

    return exchTb
end

return M
