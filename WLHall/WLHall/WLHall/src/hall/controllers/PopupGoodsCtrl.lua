--
-- Author: Zhang Bin
-- Date: 2018-03-03
-- 弹出计费点相关的 controller
--
local PopupGoodsCtrl = {}

-- 检查是否已有弹出计费点界面
function PopupGoodsCtrl:hasPopupGoodsView( )
    local scene = GameApp:getRunningScene()
    if not scene then
        return false
    end

    -- 获取商品与弹出界面的映射关系
    local info = gg.PopupGoodsData:getPopupGoodsViewInfo()
    if not info then
        return false
    end

    -- 查找是否已有弹出计费点界面
    for k, v in pairs(info) do
        if v and v ~= "" then
            local view = scene:getChildByName(v)
            if view then
                return true
            end
        end
    end

    return false
end

-- 是否可以购买某个商品
function PopupGoodsCtrl:canBuyGoods( goodid )
    if gg.PayHelper:isGoodsDisabled(goodid) then
        -- 计费点被禁用了，不能购买
        return false
    end

    local methods = gg.PayHelper:getPayMethods(goodid)
    if not methods or table.getn(methods) == 0 then
        -- 没有可用的支付方式
        return false
    end

    -- 检查是否有下发完整的计费点信息
    local goodsInfo = gg.PopupGoodsData:getGoodsDataByID(goodid)
    if not goodsInfo or not goodsInfo.price then
        return false
    end

    -- 获取计费点的剩余可购买次数
    local leftTime = checkint(checktable(goodsInfo).leftTime)

    return leftTime > 0
end

--[[
@brief 获取当前需要弹出的首充或者超值礼包计费点
@return 第一个参数为计费点 id，如果为 nil，表示没有可用的计费点
        第二个参数表示返回的计费点是否首充计费点
]]
function PopupGoodsCtrl:getFirstPayOrVIPGoods( )
    local goods, isFirstPay = gg.PopupGoodsData:_firstPayOrVIPGoods()
    if goods and not self:canBuyGoods(goods) then
        -- 获取到的商品不能购买，返回空数据
        return
    end
    return goods, isFirstPay
end

--[[
@brief 获取连胜礼包计费点
]]
function PopupGoodsCtrl:getWinningGoods( )
    local goods = gg.PopupGoodsData:_winningGoods()
    if not self:canBuyGoods(goods) then
        return
    end
    return goods
end

--[[
@brief 获取进阶礼包计费点
]]
function PopupGoodsCtrl:getAdvanceGoods( )
    local goods = gg.PopupGoodsData:_advanceGoods()
    if not self:canBuyGoods(goods) then
        return
    end
    return goods
end

--[[
@brief 获取高手进阶礼包计费点
]]
function PopupGoodsCtrl:getHighAdvanceGoods( )
    local goods = gg.PopupGoodsData:_highAdvanceGoods()
    if not self:canBuyGoods(goods) then
        return
    end
    return goods
end

--[[
@brief 检查计费点的弹出次数是否被限制了
@param goodid 商品 ID
@return 如果被限制了，返回 true；否则返回 false
]]
function PopupGoodsCtrl:popLimited( goodid )
    local goodsInfo = gg.PopupGoodsData:getGoodsDataByID(goodid)
    if not goodsInfo then
        return true
    end

    -- 有限制每天弹出次数
    if goodsInfo.dayPopLimit and goodsInfo.dayPopLimit > 0 then
        local popTimes = gg.PopupGoodsData:getTodayPopTimes(goodid)
        if checkint(popTimes) >= goodsInfo.dayPopLimit then
            return true
        end
    end

    return false
end

--[[
@brief 弹出指定商品的界面
@param goodid 商品 ID
@param delayTime 延迟弹出时间
@return 返回弹出窗口对象，如果不满足弹出条件或者指定了延时弹出，则返回 nil。
]]
function PopupGoodsCtrl:popupGoodsView( goodid, delayTime, ... )
    if delayTime and delayTime > 0 then
        -- 设置定时器进行弹出
        gg.CallAfter(delayTime, handler(self, self._doPopupGoodsView), goodid, ...)
    else
        -- 不需要延迟，直接弹出
        return self:_doPopupGoodsView(goodid, ...)
    end

    return nil
end

--[[
@brief 弹出指定商品的界面
@param goodid 商品 ID
]]
function PopupGoodsCtrl:_doPopupGoodsView( goodid, ... )
    -- 如果已经有弹出计费点界面或者不能购买该商品，不再弹出
    if self:hasPopupGoodsView() or not self:canBuyGoods(goodid) or self:popLimited(goodid) then
        return nil
    end

    -- 获取商品与弹出界面的映射关系
    local info = gg.PopupGoodsData:getPopupGoodsViewInfo()
    if not info then
        return nil
    end

    -- 查找弹出界面名称
    local viewName = info[goodid]
    if not viewName or viewName == "" then
        return nil
    end

    -- 加载界面并弹出
    local view = GameApp:getRunningScene():createView(viewName, goodid, ...)
    if view then
        view:pushInScene()

        -- 记录计费点的弹出次数
        gg.PopupGoodsData:goodsPoped(goodid)
        return view
    end

    return nil
end

-- 根据豆豆数量获取对应的当局返还计费点 ID
function PopupGoodsCtrl:getBuyBackGoodsID( beanCount )
    local info = gg.PopupGoodsData:getBuyBackGoodsInfo()
    local ret
    for k, v in pairs(info) do
        if beanCount >= checkint(v.min) and (not v.max or beanCount < checkint(v.max)) then
            -- 获取符合条件的计费点 ID
            ret = k
            break
        end
    end

    return ret
end

return PopupGoodsCtrl
