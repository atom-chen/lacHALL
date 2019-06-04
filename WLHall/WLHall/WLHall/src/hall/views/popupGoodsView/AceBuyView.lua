
-- Author: 陈洪沭
-- Date: 2018-03-6 11:03:20
-- Describe：游戏计费点 连赢4局弹窗界面
local AceBuyView = class("AceBuyView", cc.load("ViewPop"))

AceBuyView.RESOURCE_FILENAME="ui/popupGoodsView/ace_buy_view.lua"

AceBuyView.RESOURCE_BINDING = {

    ["btn_close"]   = { ["varname"] = "btn_close" ,["events"]={{event="click",method="onClickClose"}} },        -- 关闭按钮
    ["wechatH5"]   = { ["varname"] = "wechatH5" ,["events"]={{event="click",method="onClickPay"}} },            -- 微信支付按钮
    ["alipayH5"]   = { ["varname"] = "alipayH5" ,["events"]={{event="click",method="onClickPay"}} },            -- 支付宝支付按钮
    ["appstore"]   = { ["varname"] = "appstore" ,["events"]={{event="click",method="onClickPay"}} },            -- 苹果支付按钮
    ["midas_btn"]   = { ["varname"] = "midas_btn" ,["events"]={{event="click",method="onClickPay"}} },          -- 第三方支付按钮
    ["appstorebtn"]   = { ["varname"] = "appstorebtn" ,["events"]={{event="click",method="onClickPay"}} },            -- 苹果支付按钮    
    ["wechatH5btn"]   = { ["varname"] = "wechatH5btn" ,["events"]={{event="click",method="onClickPay"}} },          -- 第三方支付按钮
    ["alipayH5btn"]   = { ["varname"] = "alipayH5btn" ,["events"]={{event="click",method="onClickPay"}} },          -- 第三方支付按钮

    ["Panel"]   = { ["varname"] = "Panel" },
    ["content_text_price"]   = { ["varname"] = "content_text_price" },                                          -- 现价格文本

    ["content_text_originalprice"]   = { ["varname"] = "content_text_originalprice" },                          -- 原价格


}

--[[
* @brief 创建函数
]]
function AceBuyView:onCreate( goodid, paycallback, ... )
    self.Panel:setScale(math.min(display.scaleX, display.scaleY))
    
    -- 获取商品与弹出界面的映射关系
    local payMethods = gg.PayHelper:getPayMethods(goodid)
    self.data = gg.PopupGoodsData:getGoodsDataByID(goodid)
    if not self.data then
        return
    end

    -- 初始化
    self:init()

    -- 选择渠道
    self:initPay(payMethods)

    -- 设置道具
    self:setProps()

    -- 设置价格
    self:setPrice()

    -- 支付回调
    self.payCallback = paycallback

    self:addEventListener( gg.Event.ON_PAY_RESULT, handler( self, self.onPayResultsCallBack ) )
end

--[[
* @brief 初始化
]]
function AceBuyView:init()

    self._profDef  = gg.GetPropList()

    self.content_text_price:setString("")
    self.content_text_originalprice:setString("")

end

--[[
* @brief 设置道具
* @param props 道具列表
]]
function AceBuyView:setProps()
    local  propimg = 1

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
    for propid,value in pairs(self.data.prop) do
        -- 界面仅支持显示3个item，取配置的前3个，超出的直接跳出循环
        if propid > 3 then break end
        --加载道具图标
        local giftProps = self.Panel:getChildByName( string.format( "img_frame%d" , propimg ) )

        local img_prop = giftProps:getChildByName( "prop_icon" )
        -- 数量显示控件
        local txt_count = giftProps:getChildByName( "prop_count" )
        -- 道具ID
        local propId = propid

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
        elseif gg.IsMagicProp(propType) then
            img_prop:loadTexture("common/prop/gift_1.png")
            local nameStr = string.format("魔法道具x%d",mofacount)
            txt_count:setString(nameStr)
            txt_count:setFontSize(22)
        else

            -- 道具处理
            img_prop:loadTexture( prop.icon )
            if propType == PROP_ID_MONEY then
                nameStr = string.format( "%s豆", gg.MoneyUnit(propCount))
            else
                local countStr = propCount
                if propType == PROP_ID_263 then
                    countStr = string.format( "%s",propCount*0.01)
                end
                nameStr = string.format( "%s%s", countStr,tempUnit)
            end

            -- 设置物品名称
            txt_count:setString( nameStr )
        end
        propimg = propimg + 1

    end

end

--[[
* @brief 设置价格
* @param props 道具列表
]]
function AceBuyView:setPrice()
    local price = string.format( "现价：%s元" , self.data.price)
    local formerPrice = string.format( "原价：%s元" , self.data.ori_price)

    self.content_text_price:setString(price)
    self.content_text_originalprice:setString(formerPrice)

    if checkint(self.data.ori_price) == 0 then
        self.content_text_originalprice:setVisible(false)
    end
end

--[[
* @brief 显示支付按钮 (默认苹果渠道)
* @param payMethods 支付渠道列表
]]
function AceBuyView:initPay( payMethods )

    local payCount = #payMethods
    local PayBtn = self.Panel:getChildByName("Pay_Type"..payCount)

    -- 根据渠道显示 支付按妞
    if PayBtn then
        if payCount == 1 then
            self.midas_btn:setName(payMethods[payCount])
        elseif payCount == 2 then
            local btnName = {"appstore", "alipayH5", "wechatH5"}
            local btnTb = {self.appstorebtn, self.alipayH5btn, self.wechatH5btn}
            local cnt = 0
            for i,v in ipairs(btnTb) do
                v:setName(btnName[i])
                if Table:isValueExist(payMethods, v:getName()) then
                    v:setPositionX(293 + cnt * 495)
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


--支付成功关闭页面
function AceBuyView:onPayResultsCallBack(event, result)
    if result.status==0 then
        self:removeSelf()
    end
end


--[[
* @brief 关闭按钮
]]
function AceBuyView:onClickClose( sender )

    self:removeSelf()
end

--[[
* @brief 支付按钮
]]
function AceBuyView:onClickPay( sender )
    -- 播放点击音效
    gg.AudioManager:playClickEffect()

    local payName = sender:getName()

    if self.payCallback then
        self.payCallback()
    end

    gg.PayHelper:payByMethod(self.data,payName)
end

return AceBuyView