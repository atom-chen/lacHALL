--
-- Author: Zhang Bin
-- Date: 2018-03-03
-- 弹出计费点相关的数据
--
local PopupGoodsData = {}

local localCfgFile = require("common.FileTable").New()

-- 本地配置路径变量
local cachePath = Helper.GetCachePath()
local localConfigPath = cachePath.."goodsconfig.tmp"
-- 读取本地缓存计费点数据
local goodsTb = localCfgFile:Open(localConfigPath)

-- 刷新本地存储
local function flush_()
    localCfgFile:Save(goodsTb, localConfigPath)
end

-- 计费点数据拉取失败后的重试次数
local pullRetryCount = 0

-- 弹出商品信息
-- goods150 开始为弹出计费点
local popupGoodsInfo = {
    -- 对应文档连胜/进阶计费点
    ["goods190"] = { viewName = "popupGoodsView.AceBuyView", name = "连胜礼包", dayPopLimit = 1 },
    ["goods191"] = { viewName = "popupGoodsView.AceBuyView", name = "连胜礼包", dayPopLimit = 1 },
    ["goods192"] = { viewName = "popupGoodsView.AceBuyView", name = "进阶礼包", dayPopLimit = 1 },
    ["goods193"] = { viewName = "popupGoodsView.AceBuyView", name = "进阶礼包", dayPopLimit = 1 },
    ["goods194"] = { viewName = "popupGoodsView.AceBuyView", name = "高手进阶礼包", dayPopLimit = 1 },
    ["goods195"] = { viewName = "popupGoodsView.AceBuyView", name = "高手进阶礼包", dayPopLimit = 1 },

    -- 对应文档当局返还计费点( 158--160 预留给可能的新增档位 )
    ["goods152"] = { viewName = "popupGoodsView.ReturnGoldView", name = "返还礼包" },
    ["goods153"] = { viewName = "popupGoodsView.ReturnGoldView", name = "返还礼包" },
    ["goods154"] = { viewName = "popupGoodsView.ReturnGoldView", name = "返还礼包" },
    ["goods155"] = { viewName = "popupGoodsView.ReturnGoldView", name = "返还礼包" },
    ["goods156"] = { viewName = "popupGoodsView.ReturnGoldView", name = "返还礼包" },
    ["goods157"] = { viewName = "popupGoodsView.ReturnGoldView", name = "返还礼包" },
    ["goods158"] = { viewName = "popupGoodsView.ReturnGoldView", name = "返还礼包" },

    -- 对应文档摇一摇礼包（50万豆 + 记牌器 * 10）
    -- 162-165 预留可能新增的摇一摇礼包
    -- ["goods161"] = { viewName = "popupGoodsView.ShakeView", name = "摇一摇礼包" },

    -- 对应文档新手首充礼包
    ["goods171"] = { viewName = "popupGoodsView.NoviceBuyView", name = "首充礼包" },    -- 渠道包的首充礼包
    ["goods172"] = { viewName = "popupGoodsView.NoviceBuyView", name = "首充礼包" },    -- 非渠道包的首充礼包

    -- 对应文档超值礼包
    ["goods173"] = { viewName = "popupGoodsView.VipBuyView", name = "超值礼包" },
    ["goods174"] = { viewName = "popupGoodsView.VipBuyView", name = "超值礼包" },
    ["goods175"] = { viewName = "popupGoodsView.VipBuyView", name = "超值礼包" },
    ["goods176"] = { viewName = "popupGoodsView.VipBuyView", name = "超值礼包" },
    ["goods177"] = { viewName = "popupGoodsView.VipBuyView", name = "超值礼包" },

    -- 对应文档限时特价礼包 popupGoodsView.TimedGoodsView
    ["goods181"] = { viewName = "", name = "限时特价礼包1" },
    ["goods182"] = { viewName = "", name = "限时特价礼包2" },
    ["goods183"] = { viewName = "", name = "限时特价礼包3" },
    ["goods184"] = { viewName = "", name = "限时特价礼包1" },
    ["goods185"] = { viewName = "", name = "限时特价礼包2" },
    ["goods186"] = { viewName = "", name = "限时特价礼包3" },
}

-- 当局返还计费点相关的配置数据
local BuyBackGoodsInfo = {
    ["goods152"] = { min = 40000, max = 100000 },
    ["goods153"] = { min = 100000, max = 200000 },
    ["goods154"] = { min = 200000, max = 400000 },
    ["goods155"] = { min = 400000, max = 800000 },
    ["goods156"] = { min = 800000, max = 1500000 },
    ["goods157"] = { min = 1500000, max = 3000000 },
    ["goods158"] = { min = 3000000 },
}

-- web 下发数据的字段名
local webDataKeys = { "price", "ori_price", "limit", "prop", "ext_ratio", "name" }

--[[
@brief 合并计费点数据
@param cfg 计费点配置数据
]]
local function mergeCfgData(cfg)
    for k, v in pairs(popupGoodsInfo) do
        -- 这里只刷新指定的配置数据字段
        for i, key in ipairs(webDataKeys) do
            if type(cfg[k]) == "table" then
                if key == "price" or key == "ori_price" then
                    -- 价格和原价需要从分改为元
                    v[key] = cfg[k][key] / 100
                else
                    v[key] = cfg[k][key]
                end
            elseif key ~= "name" then
                -- 这里排除 name 字段，是为了保证远程没有下发 name 字段时，使用本地的 name 字段
                v[key] = nil
            end
        end

        -- 将 goods id 写入数据的 table 中，下单时需要
        v.goods = k
    end
end

-- 将本地配置与弹出窗口配置进行合并
mergeCfgData(goodsTb)

-- 获取弹出商品界面数据
function PopupGoodsData:getPopupGoodsViewInfo( )
    local ret = {}
    for k, v in pairs(popupGoodsInfo) do
        ret[k] = v.viewName
    end

    return ret
end

-- 获取弹出商品信息
function PopupGoodsData:getPopupGoodsData( )
    return clone(popupGoodsInfo)
end

-- 获取某个计费点的数据
function PopupGoodsData:getGoodsDataByID( goodid )
    local ret
    if popupGoodsInfo[goodid] then
        ret = clone(popupGoodsInfo[goodid])
    end

    return ret
end

-- 获取当前计费点配置的版本号
function PopupGoodsData:getPopupGoodsVer( )
    return checkint(checktable(goodsTb).version)
end

-- 合并计费点的剩余购买次数信息
function PopupGoodsData:mergeLeftTimesInfo( timesInfo )
    if not timesInfo then
        return
    end

    for k, v in pairs(popupGoodsInfo) do
        -- 刷新剩余次数信息
        if timesInfo and timesInfo[k] then
            v.leftTime = timesInfo[k]
        else
            v.leftTime = nil
        end
    end
end

-- 扣除某商品剩余次数
function PopupGoodsData:deductPopupGoodsLeftTime( goodid, times )
    if not goodid then
        return false
    end
    times = times and times or 1
    if popupGoodsInfo and popupGoodsInfo[goodid] and popupGoodsInfo[goodid].leftTime then
        popupGoodsInfo[goodid].leftTime = popupGoodsInfo[goodid].leftTime - times
        if popupGoodsInfo[goodid].leftTime < 0 then
            popupGoodsInfo[goodid].leftTime = 0
            Log("error: 商品id为[" .. goodid .. "]扣除" .. times .. "后数量小于0,请检查扣除是否有问题")
        end
        return true
    end

    return false
end

-- 拉取配置数据
function PopupGoodsData:pullData( goods )
    pullRetryCount = 0
    self:_doPullData(goods)
end

function PopupGoodsData:_doPullData( goods )
    if pullRetryCount > 3 then
        -- 只重试3次
        return
    end

    gg.Dapi:LoadGoodsConfig(goods.version, function( x )
        x = checktable( x )
        if x.status == 0 and x.data then
            -- 记录拉取到的配置信息，并更新内存中的数据
            goodsTb = x.data
            goodsTb.version = goods.version
            mergeCfgData(goodsTb)
            flush_()
        else
            -- 如果计费点数据拉取失败，设置定时器再次拉取
            pullRetryCount = pullRetryCount + 1
            gg.CallAfter(2, handler(self, self._doPullData), goods)
        end
    end)
end

-- 获取当局返还计费点相关的配置
function PopupGoodsData:getBuyBackGoodsInfo(  )
    return BuyBackGoodsInfo
end

-- 获取首充计费点 ID
function PopupGoodsData:getFirstPayGoodsID( )
    if gg.IsChannelPack() then
        return "goods171"
    else
        return "goods172"
    end
end

--[[
@brief 获取当前需要弹出的首充或者超值礼包计费点
@return 第一个参数为计费点 id，如果为 nil，表示没有可用的计费点
        第二个参数表示返回的计费点是否首充计费点
]]
function PopupGoodsData:_firstPayOrVIPGoods( )
    -- 可能是断线重连中，不返回任何数据
    if not hallmanager or not hallmanager.userinfo then
        return
    end

    local vipvalue = checkint(hallmanager.userinfo.vipvalue)
    local lv = gg.GetVipLevel(vipvalue)
    local goods
    local isFirstPay = false
    if vipvalue == 0 then
        -- 未付费玩家，返回首充计费点
        isFirstPay = true
        if gg.IsChannelPack() then
            goods = "goods171"
        else
            goods = "goods172"
        end
    else
        -- 已付费玩家，返回相应等级的超值礼包
        if lv < 3 then
            if gg.IsChannelPack() then
                goods = "goods173"
            else
                goods = "goods174"
            end
        elseif lv < 5 then
            goods = "goods175"
        else
            if lv < 7 and gg.PopupGoodsCtrl:canBuyGoods("goods177") then
                -- 7级以下且能购买 goods177，返回 goods177
                goods = "goods177"
            else
                goods = "goods176"
            end
        end
    end

    return goods, isFirstPay
end

--[[
@brief 获取连胜礼包计费点
]]
function PopupGoodsData:_winningGoods()
    if gg.IsChannelPack() then
        return "goods190"
    else
        return "goods191"
    end
end

--[[
@brief 获取进阶礼包计费点
]]
function PopupGoodsData:_advanceGoods()
    if gg.IsChannelPack() then
        return "goods192"
    else
        return "goods193"
    end
end

--[[
@brief 获取高手进阶礼包计费点
]]
function PopupGoodsData:_highAdvanceGoods()
    if gg.IsChannelPack() then
        return "goods194"
    else
        return "goods195"
    end
end

-- 获取限时特价的计费点 ID
function PopupGoodsData:getSpecialGoods()
    if gg.IsChannelPack() then
        return {"goods181", "goods182", "goods183"}
    else
        return {"goods184", "goods185", "goods186"}
    end
end

--限时特价id
-- local GOODS_ID = {"goods181", "goods182", "goods183"}
-- 获取最低限时特价礼包id
-- function PopupGoodsData:getMinBuyid()
--     local startTime = 0  --开始时间
--     local endTime = 0    --结束时间
--     local activeDatas = checktable(gg.UserData:GetWebData("activeswitch"))
--     for k,v in pairs(activeDatas) do
--         if v.active_tag == gg.ActivityPageData.ACTIVE_TAG_TJLB  then--限时活动的tag标识状态
--             startTime = v.start_time
--             endTime = v.end_time
--             break
--         end
--     end
--     local nowTime = os.time()  --当前时间
--     if startTime>0 and endTime>0 and nowTime >= startTime and nowTime < endTime then
--        --获取特价表数据
--        local goodsInfos = {}

--        for i,v in ipairs(checktable(GOODS_ID)) do
--            goodsInfos[i] = gg.PopupGoodsData:getGoodsDataByID(v)
--        end
--        --获取最低购买id
--        for i = 1, #goodsInfos do
--            local goodsInfo = goodsInfos[i]
--            if checkint(goodsInfo.leftTime)>0 then
--                return GOODS_ID[i]
--            end
--        end
--     else
--        return false
--     end
--     return false
-- end

------------------------------------------------------
-- 当日计费点弹出次数的记录文件
local popTimesFilePath = cachePath.."goodspoptimes.tmp"
local popTimesTb = localCfgFile:Open(popTimesFilePath)

-- 刷新本地记录
local function flushPopTimes_(userData)
    local userID = gg.UserData:GetUserId()
    if userID == 0 then return end
    local md5id = Helper.Md5(userID)
    userData = checktable(userData)
    -- 去除其他日期的数据，只保留今日数据
    local curDate = os.date("%Y%m%d")
    for k, v in pairs(userData) do
        if k ~= curDate then
            userData[k] = nil
        end
    end
    popTimesTb["" .. md5id] = userData
    localCfgFile:Save(popTimesTb, popTimesFilePath)
end

-- 获取某个计费点最后一次弹出的时间戳
function PopupGoodsData:getLastPopTS( goodsID )
    if not popTimesTb or not goodsID then
        return
    end

    local userID = gg.UserData:GetUserId()
    if userID == 0 then return 0 end
    local md5id = Helper.Md5(userID)
    local userData = checktable(popTimesTb["" .. md5id])

    local curDate = os.date("%Y%m%d")
    local curDateInfo = userData[curDate]
    if not curDateInfo or not curDateInfo[goodsID] then
        return
    end

    return checkint(curDateInfo[goodsID].popTS)
end

-- 获取某个计费点今天的弹出次数
function PopupGoodsData:getTodayPopTimes( goodsID )
    if not popTimesTb or not goodsID then
        return 0
    end

    local userID = gg.UserData:GetUserId()
    if userID == 0 then return 0 end
    local md5id = Helper.Md5(userID)
    local userData = checktable(popTimesTb["" .. md5id])

    local curDate = os.date("%Y%m%d")
    local curDateInfo = userData[curDate]
    if not curDateInfo or not curDateInfo[goodsID] then
        return 0
    end

    return checkint(curDateInfo[goodsID].popTimes)
end

-- 记录某个计费点弹出次数与最后弹出时间
function PopupGoodsData:goodsPoped( goodsID )
    if not goodsID then
        return
    end

    local userID = gg.UserData:GetUserId()
    if userID == 0 then return end
    local md5id = Helper.Md5(userID)
    local userData = checktable(popTimesTb["" .. md5id])
    -- 刷新数据
    local curDate = os.date("%Y%m%d")
    userData[curDate] = checktable(userData[curDate])
    userData[curDate][goodsID] = checktable(userData[curDate][goodsID])
    userData[curDate][goodsID].popTimes = checkint(userData[curDate][goodsID].popTimes) + 1
    userData[curDate][goodsID].popTS = os.time()

    -- 写入文件
    flushPopTimes_(userData)
end

return PopupGoodsData
