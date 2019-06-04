
-- Author: zhaoxinyu
-- Date: 2017-02-18 14:07:10
-- Describe：道具详细信息界面

local PropsInfoView = class("PropsInfoView", cc.load("ViewBase"))

PropsInfoView.RESOURCE_FILENAME="ui/store/props_info_view.lua"

PropsInfoView.RESOURCE_BINDING = {

    ["img_bg"]   = { ["varname"] = "img_bg"  },
    ["text_title"]   = { ["varname"] = "text_title"  },
    ["Panel_bg"]   = { ["varname"] = "Panel_bg"  },
	["btn_cancel"]   = { ["varname"] = "btn_cancel" ,["events"]={{event="click",method="onClickClose"}} },                      -- 取消
	["btn_Buy"]   = { ["varname"] = "btn_Buy" ,["events"]={{event="click",method="onClickBuy"}} },           				    -- 购买
	["btn_exchange"]   = { ["varname"] = "btn_exchange" ,["events"]={{event="click",method="onClickExchange"}} },               -- 兑换
	["btn_close"]   = { ["varname"] = "btn_close" ,["events"]={{event="click",method="onClickClose"}} },               		 	-- 点击关闭背景
}

function PropsInfoView:onCreate( goods )

    -- 初始化
    self:init( goods )

    -- 初始化View
    self:initView()

end

function PropsInfoView:init( goods )

	-- 商品
	self._goods = goods

	-- 回调
	self._fun = nil
end

--[[
* @brief 初始化View
]]
function PropsInfoView:initView()

	if not self._goods then

		return
	end

    -- 适配主背景
    self.Panel_bg:setContentSize( cc.size( display.width, display.height ) )

	-- 获取商品对应的道具表
	local props = require("hall.models.StoreData"):GetGoodsContainPropTable()[ self._goods[ "goods" ] ]

	if not props then

		return
	end

	-- 标题
	self.text_title:setString( self._goods.name )

	-- 设置价格
	self:setPrice()

	-- 加载道具包中的道具
	for i = 1 , 5 do
			-- 道具数据
			local propItem = self.img_bg:getChildByName(string.format( "img_props_%d" , i))
		local propConfig = gg.GetPropList()[ props[i][1] ]

			-- 加载道具icon
			propItem:getChildByName( "img_prop" ):ignoreContentAdaptWithSize( true )
			propItem:getChildByName( "img_prop" ):loadTexture( propConfig.icon )

			-- 拼接介绍内容
			local tempUnit = propConfig.unit
			if tempUnit == nil then
					tempUnit = ""
			end
			local contentIntr = props[i][2]..tempUnit

			-- 设置内容介绍
			propItem:getChildByName( "txt_count" ):setString(contentIntr)

	end

end

--[[
* @brief 设置回调
* @param fun 点击回调函数 function( goodsName , price )   end
]]
function PropsInfoView:setFun( fun )

	self._fun = fun
end

--[[
* @brief 设置价格
]]
function PropsInfoView:setPrice()

	if self._goods.price then

		-- 设置价格
		self.btn_exchange:setVisible(false)
		self.btn_Buy:setVisible(true)
		self.btn_Buy:getChildByName("text_price"):setString(string.format( "¥%s" ,self._goods.price))
	else
		-- 显示兑换按钮
		self.btn_exchange:setVisible(true)
		self.btn_Buy:setVisible(false)
	end
end

--[[
* @brief 购买按钮
]]
function PropsInfoView:onClickBuy( sender )

    -- 播放点击音效
    gg.AudioManager:playClickEffect()

	-- 显示支付界面
	local data = self._goods

	-- 商品名称
	local goodsName = data.name or self._profDef[ data.propid ].name
	if data.count ~= nil then
		goodsName = goodsName.."x"..data.count
	end

 	-- 回调
 	if self._fun then

 		self._fun( data )
 	end

 	-- 关闭
 	self:removeSelf()
end

--[[
* @brief 兑换按钮
]]
function PropsInfoView:onClickExchange( sender )

    -- 播放点击音效
    gg.AudioManager:playClickEffect()

	-- 打开兑换界面
	local exchangeView = self:getScene():createView("store.ExchangeView" , self._goods )
	exchangeView:pushInScene()

	self:removeSelf()
end

--[[
* @brief 关闭按钮
]]
function PropsInfoView:onClickClose( sender )

	self:removeSelf()
end

return PropsInfoView