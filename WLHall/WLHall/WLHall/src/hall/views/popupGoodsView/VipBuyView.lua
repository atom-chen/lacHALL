
-- Author: chenjingmin
-- Date: 2018-03-6 11:03:20
-- Describe：游戏计费点 每日三次游戲結束弹窗界面
local VipBuyView = class("VipBuyView", cc.load("ViewPop"))

VipBuyView.RESOURCE_FILENAME="ui/popupGoodsView/vip_buy_view.lua"

VipBuyView.RESOURCE_BINDING = {

    ["panel_close"]   = { ["varname"] = "panel_close" ,["events"]={{event="click",method="onClickClose"}} },        -- 关闭按钮
    ["wechatH5"]   = { ["varname"] = "wechatH5" ,["events"]={{event="click",method="onClickPay"}} },            -- 微信支付按钮
    ["alipayH5"]   = { ["varname"] = "alipayH5" ,["events"]={{event="click",method="onClickPay"}} },                  -- 支付宝支付按钮
    ["appstore"]   = { ["varname"] = "appstore" ,["events"]={{event="click",method="onClickPay"}} },                 -- 苹果支付按钮
    ["right_now_pay"]   = { ["varname"] = "right_now_pay" ,["events"]={{event="click",method="onClickPay"}} },      -- 第三方支付按钮

    ["alipay2"]   = { ["varname"] = "alipay2" ,["events"]={{event="click",method="onClickPay"}} },                  -- 第三方支付按钮
    ["wechatpay2"]   = { ["varname"] = "wechatpay2" ,["events"]={{event="click",method="onClickPay"}} },            -- 第三方支付按钮
    ["appstore2"]   = { ["varname"] = "appstore2" ,["events"]={{event="click",method="onClickPay"}} },            -- 第三方支付按钮
    ["panel_props"]      = { ["varname"] = "panel_props"     },
    ["bg"]   = { ["varname"] = "bg" },
    ["Node_price"]   = { ["varname"] = "Node_price" },

}
local Content =  "<div><div fontcolor=#FFFFFF>原价%s,现仅需</div> %d <div fontcolor=#FFFFFF>元即得</div></div>"
--[[
* @brief 创建函数
]]
function VipBuyView:onCreate( goodid, paycallback, ... )
    self.bg:setScale(math.min(display.scaleX, display.scaleY))
    
    -- 获取商品与弹出界面的映射关系
    local payMethods = gg.PayHelper:getPayMethods(goodid)
    self.data = gg.PopupGoodsData:getGoodsDataByID(goodid)
    if not self.data then
        return
    end

    -- 初始化
    self:init()
    self:addEventListener( gg.Event.ON_PAY_RESULT, handler( self, self.onGoodsPayResultsCallBack ) )

    -- 选择渠道
    self:initPay(payMethods)

    -- 设置道具
    self:setProps()

    -- 设置价格
    self:setPrice()

    -- 支付回调
    self.payCallback = paycallback
end

--[[
* @brief 初始化
]]
function VipBuyView:init()
    self._profDef  = gg.GetPropList()
end

-- 支付回调
function VipBuyView:onGoodsPayResultsCallBack(event, result)
    if result.status==0 then
        self:removeSelf()
    end
end

--[[
* @brief 设置道具
* @param props 道具列表
]]
function VipBuyView:setProps()
    if self.data.prop == nil then
        return
    end
    local mofacount = 0
    for i ,v in pairs(self.data.prop) do
        local propType = v[1]  --id
        local propCount = v[2]  --数量
        if gg.IsMagicProp(propType) then
            mofacount = mofacount +propCount
        end
    end

    for propid,value in ipairs(self.data.prop) do
        -- 界面仅支持显示3个item，取配置的前3个，超出的直接跳出循环
        if propid > 3 then break end

        --加载道具图标
        local giftProps = self.panel_props:getChildByName( string.format( "white_%d" , propid ) )
        local txt_count = giftProps:getChildByName("txt_count")
        local img_prop  = giftProps:getChildByName("img_prop")

        -- 道具数量
        local propType = value[1]
        local propCount = value[2]
        local nameStr = ""
        local prop = self._profDef[ propType ]

        local tempUnit = prop.unit
        if tempUnit == nil then
            tempUnit = ""
        end

        if prop == nil then
            giftProps:setVisible(false)
        else
            if gg.IsMagicProp(propType) then
                nameStr = string.format("魔法道具x%d",mofacount)
                img_prop:loadTexture("common/prop/gift_1.png")
            elseif propType == PROP_ID_MONEY then
                nameStr = string.format( "x%s豆", gg.MoneyUnit(propCount))
                img_prop:loadTexture("hall/common/dou_3.png",1)
            elseif propType == PROP_ID_263 then
                nameStr = string.format( "x%s%s", propCount*0.01,prop.unit or "")
                img_prop:loadTexture( prop.icon )
            elseif propType == cc.exports.PROP_ID_XZMONEY then
                nameStr = string.format( "%sx%d",prop.name, propCount)
            else
                nameStr = string.format( "%sx%d", prop.name,propCount)
                img_prop:loadTexture( prop.icon )
            end

            -- 设置物品名称
            txt_count:setString( nameStr )
        end
    end

end

--[[
* @brief 设置价格
* @param props 道具列表
]]
function VipBuyView:setPrice()
    local RichLabel = require("common.richlabel.RichLabel")
    local label = RichLabel.new({
      fontSize = 42,
      fontColor = cc.c3b(255, 210, 0),
    })

    label:setString(string.format(Content,self.data.ori_price,self.data.price))
    self.Node_price:addChild(label)
end

--[[
* @brief 显示支付按钮 (默认苹果渠道)
* @param payMethods 支付渠道列表
]]
function VipBuyView:initPay( payMethods )

    local payCount = #payMethods
    local PayBtn = self.bg:getChildByName("panel_pay"..payCount)

    -- 根据渠道显示 支付按妞
    if PayBtn then
        if payCount == 1 then
            self.right_now_pay:setName(payMethods[payCount])
        elseif payCount == 2 then
            local btnName = {"appstore", "alipayH5", "wechatH5"}
            local btnTb = {self.appstore2, self.alipay2, self.wechatpay2}
            local cnt = 0
            for i,v in ipairs(btnTb) do
                v:setName(btnName[i])
                if Table:isValueExist(payMethods, v:getName()) then
                    v:setPositionX(335 + cnt * 260)
                    v:setVisible(true)
                    cnt = cnt + 1
                else
                    v:setVisible(false)
                end
            end
        end
        PayBtn:setVisible(true)
    end
end

--[[
* @brief 关闭按钮
]]
function VipBuyView:onClickClose( sender )
    self:removeSelf()
end

--[[
* @brief 支付按钮
]]
function VipBuyView:onClickPay( sender )
    -- 播放点击音效
    gg.AudioManager:playClickEffect()

    local payName = sender:getName()

    if self.payCallback then
        self.payCallback()
    end

    gg.PayHelper:payByMethod(self.data,payName)
end

function VipBuyView:getViewZOrder()
    return 9100
end

return VipBuyView
