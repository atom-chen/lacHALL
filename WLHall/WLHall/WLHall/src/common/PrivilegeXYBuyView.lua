
--
--
-- Describe：星耀特权购买界面

local PrivilegeXYBuyView = class("PrivilegeXYBuyView", cc.load("ViewPop"))

PrivilegeXYBuyView.RESOURCE_FILENAME="ui/store/privilege_xy_buy_view.lua"

PrivilegeXYBuyView.RESOURCE_BINDING = {
	["panel"]   = { ["varname"] = "panel" },

	["btn_close"]   = { ["varname"] = "btn_close" ,["events"]={{event="click",method="onClickClose"}} },                        -- 关闭按钮

    ["img_get_1"]   = { ["varname"] = "img_get_1" },
    ["txt_get_1"]   = { ["varname"] = "txt_get_1" },

    ["img_get_2"]   = { ["varname"] = "img_get_2" },
    ["txt_get_2"]   = { ["varname"] = "txt_get_2" },

    ["img_get_daily_1"]   = { ["varname"] = "img_get_daily_1" },
    ["txt_get_daily_1"]   = { ["varname"] = "txt_get_daily_1" },

    ["img_get_daily_2"]   = { ["varname"] = "img_get_daily_2" },
    ["txt_get_daily_2"]   = { ["varname"] = "txt_get_daily_2" },

    ["img_get_daily_3"]   = { ["varname"] = "img_get_daily_3" },
    ["txt_get_daily_3"]   = { ["varname"] = "txt_get_daily_3" },

    ["img_get_daily_4"]   = { ["varname"] = "img_get_daily_4" },
    ["txt_get_daily_4"]   = { ["varname"] = "txt_get_daily_4" },

    ["txt_privilege_brief"]   = { ["varname"] = "txt_privilege_brief" },

    ["txt_ori_price"]   = { ["varname"] = "txt_ori_price" },
    ["txt_price"]   = { ["varname"] = "txt_price" },

    ["btn_third"]   = { ["varname"] = "btn_third" ,["events"]={{event="click",method="onClickPay"}} },            -- 第三方

    ["btn_wechat_2"]   = { ["varname"] = "btn_wechat_2" ,["events"]={{event="click",method="onClickPay"}} },            -- 微信支付按钮
    ["btn_alipay_2"]   = { ["varname"] = "btn_alipay_2" ,["events"]={{event="click",method="onClickPay"}} },            -- 支付宝支付按钮

    ["btn_wechat_3"]   = { ["varname"] = "btn_wechat_3" ,["events"]={{event="click",method="onClickPay"}} },            -- 微信支付按钮
    ["btn_alipay_3"]   = { ["varname"] = "btn_alipay_3" ,["events"]={{event="click",method="onClickPay"}} },            -- 支付宝支付按钮
    ["btn_apple_3"]   = { ["varname"] = "btn_apple_3" ,["events"]={{event="click",method="onClickPay"}} },            -- 苹果支付按钮
}

function PrivilegeXYBuyView:onCreate()
	self.goodid = "month_card_vip"
	-- 获取商品的支付方式
    local pay_methods = gg.PayHelper:getPayMethods(self.goodid)

    -- 初始化
    self:init()

    -- 选择渠道
    self:initPay(pay_methods)

    -- 初始化View
    self:initView()

    -- 购买月卡成功的事件回调
    self:addEventListener(gg.Event.BUG_MONTHCARD_VIP_SUCCESS, handler(self, self.callbackBuySuccess) )
end

function PrivilegeXYBuyView:init()

    self._profDef  = gg.GetPropList()

    self.data = {}
end

function PrivilegeXYBuyView:callbackBuySuccess()
	if tolua.isnull(self) then return end

	self:removeSelf()
end

--[[
* @brief 初始化View
]]
function PrivilegeXYBuyView:initView()

	-- 获取礼包配置
	local storeData = require("hall.models.StoreData")
	local privilegeGiftTable = storeData:GetMonthCardVIPGiftTable()

	-- 获取礼包价格
	local privilegeGoods = storeData:GetMonthCardVIPGoodsInfo()
	assert( privilegeGoods , "礼包商品未配置！" )

	table.merge(self.data, privilegeGoods)

	-- 礼包价格
	local money = privilegeGoods.price or 0

	-- 特权钱数
	local privilegeMoney = money

	-- 设置立即获得的道具
	self:setProps( privilegeGiftTable.prop )

	-- 设置每日获得的道具
	self:setDailyProps( privilegeGiftTable.daily_prop )

	-- 设置钱数
	self:setMoney( privilegeMoney , privilegeGoods.origPrice or 0  )

	self:setPrivilegeAdditional( privilegeGiftTable.leitai_ratio )
end

--[[
* @brief 设置钱数
* @param money
* @param origPrice 原价格
]]
function PrivilegeXYBuyView:setMoney( money , origPrice  )

	self.txt_price:setString( money )
	self.txt_ori_price:setString( origPrice )
end

function PrivilegeXYBuyView:setPrivilegeAdditional( leitai_ratio )

	local leitai_add = leitai_ratio * 100
	self.txt_privilege_brief:setString("星耀特权 : 每日首次登录全服广播\n                 荣誉分 +"..leitai_add.."%")
end

--[[
* @brief 设置立即获得的道具
* @param props 道具列表
]]
function PrivilegeXYBuyView:setProps( props )
	if not props then
		return
	end

	-- 创建道具
	for i = 1 , 2 do

		-- 道具图标
		local img_prop = self["img_get_"..i]
		-- 数量控件
		local txt_prop_count = self["txt_get_"..i]

		-- 道具ID
		local propId = props[ i ][ 1 ]

		-- 道具数量
		local propCount = props[ i ][ 2 ]

		-- 道具数量单位
		local unit = self._profDef[ propId ].unit

		if propId ~= PROP_ID_MONEY then
			-- 道具处理
			img_prop:loadTexture( self._profDef[ propId ].icon )
			txt_prop_count:setString( string.format( "%d%s" , propCount ,  gg.IIF( unit == nil , "个" , unit ) )  )
		else
			-- 豆豆处理
			local minmoneyTr = gg.MoneyUnit(propCount)
			img_prop:loadTexture( self:getDouDouFile(propCount), 1 )
			txt_prop_count:setString( minmoneyTr )
		end
	end
end

-- 根据豆豆数获取豆豆图片
function PrivilegeXYBuyView:getDouDouFile(count)
	local img_path = "hall/common/"
	if count < 100000 then
		img_path = img_path.."dou_1.png"
	elseif count < 150000 then
		img_path = img_path.."dou_2.png"
	elseif count < 1000000 then
		img_path = img_path.."dou_3.png"
	else
		img_path = img_path.."dou_4.png"
	end

	return img_path
end

--[[
* @brief 设置每日领取的道具
* @param props 道具列表
]]
function PrivilegeXYBuyView:setDailyProps( props )
	if not props then
		return
	end

	-- 创建道具
	for i = 1 , 4 do

		-- 道具图标
		local img_prop = self["img_get_daily_"..i]
		-- 数量控件
		local txt_prop_count = self["txt_get_daily_"..i]

		-- 道具ID
		local propId = props[ i ][ 1 ]

		-- 道具数量
		local propCount = props[ i ][ 2 ]

		-- 道具数量单位
		local unit = self._profDef[ propId ].unit

		if propId ~= PROP_ID_MONEY then
			-- 道具处理
			img_prop:loadTexture( self._profDef[ propId ].icon )
			txt_prop_count:setString( string.format( "%d%s" , propCount ,  gg.IIF( unit == nil , "个", unit ) )  )
		else
			-- 豆豆处理
			local minmoneyTr = gg.MoneyUnit(propCount )
			img_prop:loadTexture( self:getDouDouFile(propCount), 1 )
			txt_prop_count:setString( minmoneyTr )
		end
	end
end

--[[
* @brief 关闭按钮
]]
function PrivilegeXYBuyView:onClickClose( sender )
	self:removeSelf()
end

--[[
* @brief 显示支付按钮
* @param payMethods 支付渠道列表
]]
function PrivilegeXYBuyView:initPay( pay_methods )
    local pay_count = #pay_methods
    local btn_pay = self.panel:getChildByName("pay_type_"..pay_count)
    -- 根据渠道显示 支付按妞
    if btn_pay then
        if pay_count == 1 then
            self.btn_third:setName(pay_methods[1])
        elseif pay_count == 2 then
            local btn_wechat = btn_pay:getChildByName("btn_wechat_2")
            local btn_alipay = btn_pay:getChildByName("btn_alipay_2")
            btn_wechat:setName(pay_methods[1])
            btn_alipay:setName(pay_methods[2])
        elseif pay_count == 3 then
        	local btn_wechat = btn_pay:getChildByName("btn_wechat_3")
            local btn_alipay = btn_pay:getChildByName("btn_alipay_3")
            local btn_apple = btn_pay:getChildByName("btn_apple_3")
            btn_wechat:setName(pay_methods[1])
            btn_alipay:setName(pay_methods[2])
            btn_apple:setName(pay_methods[3])
        end
        btn_pay:setVisible(true)
    end
end

--[[
* @brief 支付按钮
]]
function PrivilegeXYBuyView:onClickPay( sender )
	-- 播放点击音效
    gg.AudioManager:playClickEffect()

    local pay_name = sender:getName()

    gg.PayHelper:payByMethod(self.data, pay_name)
end

return PrivilegeXYBuyView
