-- Author: chenjita
-- Date: 2018-03-17 14:00:00
-- Describe：购买海底捞月 卡
local HaiDiLaoYueView = class("HaiDiLaoYueView", cc.load("ViewPop"))

HaiDiLaoYueView.RESOURCE_FILENAME="ui/popupGoodsView/haidilaoyueka_buy_view.lua"

HaiDiLaoYueView.RESOURCE_BINDING = {
	 ["btn_close"]   = { ["varname"] = "btn_close" ,["events"]={{event="click",method="onClickClose"}} },        -- 关闭按钮
	 ["btn_buy"]   = { ["varname"] = "btn_buy" ,["events"]={{event="click",method="onClickBuy"}} },        -- 立即购买
	 ["btn_get_xyyh"]   = { ["varname"] = "btn_get_xyyh" ,["events"]={{event="click",method="onClickXYYH"}} },        -- 立即获得星耀用户
	 ["btn_get_gzyh"]   = { ["varname"] = "btn_get_gzyh" ,["events"]={{event="click",method="onClickZZYH"}} },        -- 立即获得贵族用户

	 ["txt_info"]	= {["varname"] = "txt_info" },  --【海底捞月卡】x500
	 ["txt_hdlyk_price"] = { ["varname"] = "txt_hdlyk_price" }, --价格 : 200元
}

--[[
* @brief 创建海底捞月界面
* @param cardNum 还需要多少张海底捞月卡
]]
function HaiDiLaoYueView:onCreate( cardNum )
	assert(cardNum)
	self:init(cardNum)

	self:addEventListener( gg.Event.ON_PAY_RESULT, handler( self, self.onPayResultsCallBack ) )
end

function HaiDiLaoYueView:init( cardNum )
	assert(cardNum)
	self.goodsData = self:_getCurGoodsData( cardNum )
	self.payMethods = gg.PayHelper:getPayMethods( self.goodsData.goods )
	assert(#self.payMethods>0, "海底捞月无有效的支付方法")
	self:initView(self.goodsData)
end

function HaiDiLaoYueView:initView( goodsData )
	assert(goodsData)
	self.txt_info:setString("【海底捞月卡】x"..goodsData.count)
	self.txt_hdlyk_price:setString("价格 : "..goodsData.price.."元")
end

--关闭按钮点击事件
function HaiDiLaoYueView:onClickClose( sender )
	self:removeSelf()
end

--购买按钮点击事件
function HaiDiLaoYueView:onClickBuy( sender )
	gg.AudioManager:playClickEffect()
	gg.PayHelper:showPay(GameApp:getRunningScene(), self.goodsData)
	-- gg.PayHelper:payByMethod( self.goodsData, self.payMethods[1])
end


function HaiDiLaoYueView:onPayResultsCallBack(event, result)
	if result.status==0 then
		self:removeSelf()
	end
end

--立即获得“星耀用户”
function HaiDiLaoYueView:onClickXYYH( sender )
	gg.AudioManager:playClickEffect()
	self:getScene():createView("active.ActivityView", {first_but_tag = 2}):pushInScene()
	self:removeSelf()
end

--立即获得“贵族用户”
function HaiDiLaoYueView:onClickZZYH( sender )
	gg.AudioManager:playClickEffect()
	self:getScene():createView("active.ActivityView", {first_but_tag=2}):pushInScene()
	self:removeSelf()
end

----------------------------------------------
--获取当前不足的海底捞月卡的计费点
function HaiDiLaoYueView:_getCurGoodsData(cardNum)
    assert(cardNum > 0)
    local StoreData = require("src.hall.models.StoreData")
    local tab = StoreData:GetGoodsTable()
    for i, v in ipairs(tab) do
        if v.type == PROP_ID_HAIDILAOYUE then
            if v.count >= cardNum then
                return v
            end
        end
    end

    return nil
end

return HaiDiLaoYueView
