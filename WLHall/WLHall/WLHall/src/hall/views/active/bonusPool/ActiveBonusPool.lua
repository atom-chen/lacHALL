--[[
    create by John 2018-04-19
    五一奖金池活动界面
]]
local ActiveBonusPool = class("ActiveBonusPool", cc.load("ViewBase"))

ActiveBonusPool.RESOURCE_FILENAME = "ui/active/bonus_pool/activity_chdjc.lua"

ActiveBonusPool.RESOURCE_BINDING =
{
    ["btn_rank"] = { ["varname"] = "btn_rank", ["events"] = { { ["event"] = "click", ["method"] = "onClickRank" } } },
    ["btn_rule"] = { ["varname"] = "btn_rule", ["events"] = { { ["event"] = "click", ["method"] = "onClickRule" } } },
    ["node_goods_list"] = { ["varname"] = "node_goods_list"},
    ["scrollview_goods"] = { ["varname"] = "scrollview_goods"},
    ["item_model"] = { ["varname"] = "item_model"},
    ["text_cur_coin"] = { ["varname"] = "text_cur_coin"},
    ["img_coin_unit"] = { ["varname"] = "img_coin_unit"},
    ["text_time"] = { ["varname"] = "text_time" },
    ["img_bottom"] = { ["varname"] = "img_bottom"},
    ["node"] = { ["varname"] = "node"},
    ["text_des"] = { ["varname"] = "text_des"},
    ["img_coin_unit"] = { ["varname"] = "img_coin_unit"},

}

local GOODS_COUNT_IN_VIEW = 5

function ActiveBonusPool:onCreate(actInfo)
    self.node:setVisible(false)

    -- 显示活动的时间
    self.actInfo = actInfo
    local startTime = os.date("%Y.%m.%d %H:%M", actInfo.start_time)
    local endTime = os.date("%m.%d %H:%M", actInfo.end_time)
    local strTime = string.format("活动时间：%s-%s", startTime, endTime)
    self.text_time:setString(strTime)

    self:initGoods(self:checkTimedGoodsStatus(actInfo.start_time,actInfo.end_time))
    -- 关注支付成功的事件
    self:addEventListener( gg.Event.ON_PAY_RESULT, handler( self, self.onPayResultsCallBack ) )
end

--时间轴
function ActiveBonusPool:checkTimedGoodsStatus(strTime,endTime)
    local nowTime = os.time()
    if strTime>0 and endTime>0 and nowTime>=strTime and nowTime<endTime then
        return true
    end

    return false
end

function ActiveBonusPool:requestCurCoins( ... )
    gg.Dapi:BonusPoolCoinNum(gg.ActivityPageData.ACTIVE_TAG_CHDJC,function(cb)
        if tolua.isnull(self) then return end
        cb = checktable(cb)

        if not cb.status or checkint(cb.status) ~= 0 then
            GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "网络错误，请关闭界面重试！")
            return
        end

        self.text_cur_coin:setString(tostring(cb.data))
        local  nodeWidth = self.text_cur_coin:getContentSize().width + 20 + self.text_des:getContentSize().width + self.img_coin_unit:getContentSize().width

        self.text_cur_coin:setPositionX(self.text_des:getPositionX() + 10)
        self.img_coin_unit:setPositionX(self.text_cur_coin:getPositionX() + self.text_cur_coin:getContentSize().width + 10)

        self.node:setPositionX(self.img_bottom:getContentSize().width/2 - nodeWidth/2  )
        self.node:setVisible(true)
    end)
end

function ActiveBonusPool:initGoods( isclick )
    self.goods = self:getGoodsInfo()
    self.scrollview_goods:removeAllChildren()
    self.scrollview_goods:setScrollBarEnabled( false )    -- 隐藏滚动条
    local itemWidth = self.item_model:getContentSize().width
    local good_info_count = #(self.goods)
    self.scrollview_goods:setInnerContainerSize(cc.size(good_info_count*(itemWidth + 13) + 10, self.scrollview_goods:getContentSize().height))
    self.item_model:setVisible(false)

    for i, v in ipairs(self.goods) do
        local itemNode = self.item_model:clone()
        local itemData = v
        local title = itemNode:getChildByName("item_text_title")
        local btnBuy = itemNode:getChildByName("buy_panel")
        local icon = itemNode:getChildByName("item_image_icon")
        local txt_dou = itemNode:getChildByName("txt_dou")
        local gift = itemNode:getChildByName("item_gift_dou")
        local img_price = itemNode:getChildByName("img_price")
        local panel_price = img_price:getChildByName("panel_price")
        local img_RMB = panel_price:getChildByName("img_RMB")
        local ori_price = panel_price:getChildByName("txt_price")
        local Image_buy1 = itemNode:getChildByName("Image_buy1")

        ori_price:setString(itemData.price.."元")
        panel_price:setPositionX((img_price:getContentSize().width - img_RMB:getContentSize().width - ori_price:getContentSize().width)/2)
        gift:setString(itemData.gift)
        title:setString(itemData.coin)
        icon:loadTexture("hall/active/bonuspool/"..itemData.image,1)
        txt_dou:setPositionX(title:getContentSize().width/2 + title:getPositionX())
        itemNode.id = i
        btnBuy.id = i
        local posX = self.item_model:getPositionX() + (i-1)*159
        local posY = self.item_model:getPositionY()
        itemNode:setPosition(cc.p(posX, posY))
        itemNode:setVisible(true)
        self.scrollview_goods:addChild(itemNode)
       -- itemNode:setTouchEnabled(true)
        itemNode:setTouchEnabled(isclick)
        Image_buy1:setAllGray(not isclick)

        btnBuy:addClickEventListener(handler(self, self.onClickBuy))

        itemNode:onClickScaleEffect(handler(self, self.onClickBuy))
    end
end

function ActiveBonusPool:getGoodsInfo()
    local StoreData = require("hall.models.StoreData")
    local ret = StoreData:getCHDJCGoods()
    if #ret > GOODS_COUNT_IN_VIEW then
        -- 超过屏幕显示数量，按照 sort 值排序
        table.sort(ret, function( v1, v2 )
            return v1.sort < v2.sort
        end)
    else
        -- 没有超过屏幕显示数量，按照价格排序
        table.sort(ret, function( v1, v2 )
            return v1.price < v2.price
        end)
    end

    return ret
end

function ActiveBonusPool:onClickBuy(sender)
    local curTime = os.time()
    if os.time() > self.actInfo.end_time then
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "活动已结束，不能再购买了！")
        return
    end

    local goodsData = self.goods[sender.id]
    local payType = gg.PayHelper:getPayMethods(goodsData.goods)
    if payType and #payType>0 and goodsData then
        if #payType == 1 then
            gg.PayHelper:payByMethod(goodsData , payType[1])
        else
            gg.PayHelper:showPay(GameApp:getRunningScene(), goodsData)
        end
    end
end

function ActiveBonusPool:onClickRank()
    gg.AudioManager:playClickEffect()
    self:getScene():createView("active.bonusPool.PopRankBonusPool",gg.ActivityPageData.ACTIVE_TAG_CHDJC):pushInScene()
end

function ActiveBonusPool:onClickRule()
    gg.AudioManager:playClickEffect()
    self:getScene():createView("active.bonusPool.PopRuleBonusPool",gg.ActivityPageData.ACTIVE_TAG_CHDJC):pushInScene()
end

function ActiveBonusPool:onPageShown( )
    self:requestCurCoins()
end

function ActiveBonusPool:onPayResultsCallBack(event, result)
    -- 支付成功刷新数据
    if result and result.status == 0 then
        self:requestCurCoins()
    end
end

return ActiveBonusPool
