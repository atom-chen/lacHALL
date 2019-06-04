
-- Author:pengxunsheng
-- Date:3.21
-- Describe：新手的1 7元充值
local NoviceBuyView = class("NoviceBuyView", cc.load("ViewPop"))

NoviceBuyView.RESOURCE_FILENAME="ui/popupGoodsView/novice_buy_view.lua"

NoviceBuyView.RESOURCE_BINDING =
{
    ["Panel"]   = { ["varname"] = "Panel" },

    ["btn_close"]= {["varname"] = "btn_close" ,["events"]={{event="click",method="onClickClose"}}},                      -- 关闭按钮

    ["btn_gobuy"]   = {["varname"] = "btn_gobuy",["events"]={{event="click",method="onBuyGood"}}},                         -- 第三方支付

    ["txt_xianjiaprice"]   = { ["varname"] = "txt_xianjiaprice" },
    ["txt_yuanjia"]   = { ["varname"] = "txt_yuanjia" },


    --支付方式
    ["btn_pay_1"]   = {["varname"] = "btn_pay_1",["events"]={{event="click",method="onBuyGood"}}},
    ["btn_pay_2"]   = {["varname"] = "btn_pay_2",["events"]={{event="click",method="onBuyGood"}}},
    ["btn_pay_3"]   = {["varname"] = "btn_pay_3",["events"]={{event="click",method="onBuyGood"}}},

    ["alipayH5"]   = {["varname"] = "alipayH5",["events"]={{event="click",method="onBuyGood"}}},
    ["wechatH5"]   = {["varname"] = "wechatH5",["events"]={{event="click",method="onBuyGood"}}},
    ["appstore"]   = {["varname"] = "appstore",["events"]={{event="click",method="onBuyGood"}}},

}

--[[
    gg.PayHelper:getPayMethods(商品ID)
   用于获取某个商品的可用的支付方式，返回值为支付方式的字符串数组（wechatH5 表示微信，alipayH5 表示支付宝， appstore 表示苹果，其他表示渠道支付）
]]--
function NoviceBuyView:onCreate(goodid, doGift)
    self.Panel:setScale(math.min(display.scaleX, display.scaleY))

    self.doGift = doGift
    -- 获取商品可以获得哪几种支付的方式
    local payMethods = gg.PayHelper:getPayMethods(goodid)

    -- 获取当前商品属性
    self._propdata = gg.PopupGoodsData:getGoodsDataByID(goodid)
    --Log(self._propdata)
    if not self._propdata then return end

    self._profDef  = gg.GetPropList()
    --商品的价格设置
    self:initViewMoney();
    --商品的支付方式的设置
    self:initViewBtn(payMethods)

    self:addEventListener( gg.Event.ON_PAY_RESULT, handler( self, self.onPayResultsCallBack ) )

end

    --支付成功关闭页面
function NoviceBuyView:onPayResultsCallBack(event, result)
    if result.status==0 then
        self:removeSelf()
    end
end

-- 根据渠道显示 支付按妞
function NoviceBuyView:initViewBtn(payMethods)
    local payCount = #payMethods
    local PayBtnNode = self.Panel:getChildByName("pay_"..payCount)
    if payCount == 1 then
        self.btn_gobuy:setName(payMethods[payCount])
    elseif payCount == 2 then
        local btnName = {"wechatH5", "alipayH5", "appstore"}
        local cnt = 0
        for i=1,3 do
            local btn = PayBtnNode:getChildByName("btn_pay_" .. i)
            btn:setName(btnName[i])
            if Table:isValueExist(payMethods, btn:getName()) then
                btn:setVisible(true)
                btn:setPositionX(590 - cnt * 270)
                cnt = cnt + 1
            else
                btn:setVisible(false)
            end
        end
    end
    PayBtnNode:setVisible(true)
end

--商品的价格
function NoviceBuyView:initViewMoney()
    local price = string.format( "%s元" , self._propdata.price)
    local formerPrice = string.format( "原价：%s元" , self._propdata.ori_price)
    -- 原价的价格
    self.txt_yuanjia:setString(formerPrice);
    if IS_REVIEW_MODE then
        self.txt_yuanjia:setVisible(false)
    end

    -- 现价的价格
    self.txt_xianjiaprice:setString(price);
    --获取魔法道具数量
    local mofacount = 0
    for i ,v in pairs(self._propdata.prop) do
        local propType = v[1]  --id
        local propCount = v[2]  --数量
        if gg.IsMagicProp(propType) then
            mofacount = mofacount +propCount
        end
    end

    for i,value in ipairs(checktable(self._propdata.prop)) do
        if i > 3 then break end
        local giftProps = self:findNode("img_dibg" .. i)
        local img_prop = giftProps:getChildByName("img_icon")
        local txt_count = giftProps:getChildByName("txt_number")

        local propType = tonumber(value[1])
        local propCount = tonumber(value[2])
        local prop = self._profDef[propType]
        if prop then
            -- 设置物品icon
            img_prop:setTexture(prop.icon)
            -- 设置物品名称
            local nameStr = ""
            if propType == PROP_ID_MONEY then
                nameStr = string.format("x%s豆", gg.MoneyUnit(propCount))
            elseif gg.IsMagicProp(propType) then
                nameStr = string.format("魔法道具x%d", mofacount)
                img_prop:setTexture("common/prop/gift_1.png")
            elseif propType == PROP_ID_263 then
                nameStr = string.format( "x%s%s",  propCount * (prop.proportion or 1),prop.unit or "")
            elseif propType == PROP_ID_JIPAI then
                nameStr = string.format("%sx%d", prop.name, propCount)
            else
                nameStr = string.format("x%d%s", propCount * (prop.proportion or 1), prop.unit or "")
            end
            txt_count:setString(nameStr)

            img_prop:setScale((giftProps:getContentSize().width - 60) / img_prop:getContentSize().width)
        else
            giftProps:setVisible(false)
        end
    end
end

-- gg.PayHelper:payByMethod()使用指定的支付方式购买某商品，前两个参数必传。后面的参数可以先不传，是统计用的
function NoviceBuyView:onBuyGood(sender)
    --Log(sender:getName())
    local payName = sender:getName()
    gg.PayHelper:payByMethod(self._propdata,payName)

    if self._cb then
        self._cb(1)
    end
end

function NoviceBuyView:onClickClose(sender)
    if self.doGift and hallmanager then
        -- 如果是直接关闭了，且指定需要申请救济金
        hallmanager:DoCompleteMission(MISSION_DAILY_GIFT_MONEY)
    end

    if self._cb then
        self._cb(0)
    end

    self:removeSelf()
end

--[[
* @brief 设置关闭回调
]]
function NoviceBuyView:setCloseCallBack( cb )
	self._cb = cb
end

return NoviceBuyView
