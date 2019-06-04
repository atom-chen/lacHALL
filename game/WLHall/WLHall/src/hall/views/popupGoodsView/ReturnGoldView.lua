
-- Author: zhaoxinyu
-- Date: 2018-03-07 16:00:00
-- Describe：金币返还购买界面

local ReturnGoldView = class("ReturnGoldView", cc.load("ViewPop"))

ReturnGoldView.RESOURCE_FILENAME="ui/popupGoodsView/return_gold_node.lua"

ReturnGoldView.RESOURCE_BINDING = {

	["btn_close"]   = { ["varname"] = "btn_close" ,["events"]={{event="click",method="onClickClose"}} },                        -- 关闭按钮

	["btn_buy"]   = { ["varname"] = "btn_buy" ,["events"]={{event="click",method="onClickBuy"}} },                        	    -- 购买
    ["btn_buy_wx"]   = { ["varname"] = "btn_buy_wx" ,["events"]={{event="click",method="onClickBuy"}} },                        -- 微信支付
    ["btn_buy_zfb"]   = { ["varname"] = "btn_buy_zfb" ,["events"]={{event="click",method="onClickBuy"}} },                      -- 支付宝支付
    ["btn_buy_apple"]   = { ["varname"] = "btn_buy_apple" ,["events"]={{event="click",method="onClickBuy"}} },                  -- 支付宝支付
    ["btn_buy_apple_1"]   = { ["varname"] = "btn_buy_apple_1" ,["events"]={{event="click",method="onClickBuy"}} },                  -- 支付宝支付
    
    ["btn_buy_wx_1"]   = { ["varname"] = "btn_buy_wx_1" ,["events"]={{event="click",method="onClickBuy"}} },                    -- 支付宝支付
    ["btn_buy_zfb_1"]   = { ["varname"] = "btn_buy_zfb_1" ,["events"]={{event="click",method="onClickBuy"}} },                  -- 支付宝支付

    ["txt_return_gold_num"]     = { ["varname"] = "txt_return_gold_num" },                                                      -- 返还金币数
    ["txt_give_gold_num"]     = { ["varname"] = "txt_give_gold_num" },                                                          -- 加赠金币数

	["txt_need_price"]   = { ["varname"] = "txt_need_price"  },                        										    -- 现价
	["txt_ori_price"]   = { ["varname"] = "txt_ori_price"  },                        											-- 原价
    ["img_line"]   = { ["varname"] = "img_line"  },                                                                             -- 原价划线

    ["btn_pay_channel_node"]   = { ["varname"] = "btn_pay_channel_node"  },                                                     -- 购买
    ["btn_pay_trilateral_node"]   = { ["varname"] = "btn_pay_trilateral_node"  },                                               -- 第三方支付
    ["btn_pay_apple_node"]   = { ["varname"] = "btn_pay_apple_node"  },                                                         -- 苹果支付

    ["img_bk"]   = { ["varname"] = "img_bk"  },
}

local BuyTypeTag = {

    CHANNEL = 1,        -- 渠道
    WX = 2,             -- 微信
    ZFB = 3,            -- 支付宝
    APPLE = 4           -- 苹果
}

function ReturnGoldView:onCreate( goods , consumeGold , cb )
    self.img_bk:setScale(math.min(display.scaleX, display.scaleY))

    if consumeGold == nil or consumeGold <= 0 or goods == nil then
        return
    end

    self._consumeGold = consumeGold
    self._goods = goods
    self._cb = cb
    self._goodsInfo = gg.PopupGoodsData:getGoodsDataByID(goods)

    -- 验证是否满足返还条件
    self._giveGold = self:getGiveGold()
     
    if self._giveGold <= consumeGold then
        return
    end

    -- 初始化View
    self:initView()

    -- 支付通知
    self:addEventListener( gg.Event.ON_PAY_RESULT, handler( self, self.onPayResultsCallBack ) )
end

--[[
* @brief 初始化View
]]
function ReturnGoldView:initView()

    -- 设置返还金币数
    self.txt_return_gold_num:setString( string.format("%s豆", gg.MoneyUnit(self._consumeGold)) )

    -- 设置加赠金币数
    self.txt_give_gold_num:setString( string.format("%s豆", gg.MoneyUnit(self._giveGold)) )

    -- 设置价格
    local price = checktable( self._goodsInfo ).price
    self.txt_need_price:setString( self:toString( "仅需",price ) )

    -- 设置原价
    self:setOripriceView()

    -- 支付方式显示
    self:showBuyBtn()

    -- 初始化道具
    self:initProp()

end

--[[
* @brief 价格转换
* @price 价格
]]
function ReturnGoldView:toString( str, price )

    local str = string.format("%s%d元", str,price or 1 )
    if math.floor(price) < price then
        str = string.format("%s%0.2f元", str,price or 1 )
    end
    return str
end

--[[
* @brief 支付通知，0成功
]]
function ReturnGoldView:onPayResultsCallBack( result )

    -- 关闭当前界面
    self:removeSelf()
end

--[[
* @brief 初始化道具
]]
function ReturnGoldView:initProp()

    -- 遍历道具
    for k, v in pairs( checktable( self._goodsInfo ).prop ) do

        local prodef = gg.GetPropList()[  checkint(  checktable( v )[1] )  ]

        local propview = self.img_bk:getChildByName( string.format( "img_bb_give_%d" , k + 1 ) )
        if propview then

            -- 设置道具图片
            local imgprop = propview:getChildByName("img_prop_icon")
            imgprop:loadTexture( prodef.icon )

            -- 设置道具数量
            local txtprop = propview:getChildByName("txt_give_num")
            --txtprop:setString( string.format("%s%s",  gg.MoneyUnit( checkint(  checktable( v )[2] ) )  , prodef.unit or ""  ))
            txtprop:setString( string.format("%sx%s", prodef.name , gg.MoneyUnit( checkint(  checktable( v )[2] ) ) ))
        end
    end
end

--[[
* @brief 获取加赠道具数
* @return 加赠金币数、加赠记牌器数、加赠擂台分数
]]
function ReturnGoldView:getGiveGold()

    -- 获取符合条件的计费点 ID
    local ext_ratio = checktable( self._goodsInfo ).ext_ratio
    return math.ceil( ( self._consumeGold + self._consumeGold * ext_ratio )  / 10000 ) * 10000 - self._consumeGold
end

--[[
* @brief 设置原价
]]
function ReturnGoldView:setOripriceView()

    local ori_price = checktable( self._goodsInfo ).ori_price

    if checkint( ori_price ) ~= 0 then

        self.txt_ori_price:setString( self:toString( "原价",ori_price ) )
        self.img_line:setContentSize( {width = self.txt_ori_price:getSize().width + 15 , height = self.img_line:getSize().height} )
        self.img_line:setPosition(self.txt_ori_price:getSize().width /2,self.txt_ori_price:getSize().height/2)
        self.img_line:setScale9Enabled(true)
    else

        self.txt_need_price:setPositionX( 568 )
        self.txt_ori_price:setVisible( false )
    end
end

--[[
* @brief 显示支付按钮
]]
function ReturnGoldView:showBuyBtn()

    -- 获取商品支付类型
    if self._goods then

        local payType = gg.PayHelper:getPayMethods( self._goods )

        self.btn_pay_channel_node:setVisible(#payType == 1)
        self.btn_pay_trilateral_node:setVisible(#payType == 2)
        self.btn_pay_apple_node:setVisible(#payType == 3)

        if #payType == 2 then
            local btnTb = {self.btn_buy_apple_1, self.btn_buy_zfb, self.btn_buy_wx}
            local btnName = {"appstore", "alipayH5", "wechatH5"}
            local cnt = 0
            for i,v in ipairs(btnTb) do
                v:setName(btnName[i])
                if Table:isValueExist(payType, v:getName()) then
                    v:setPositionX(-140 + cnt * 280)
                    v:setVisible(true)
                    cnt = cnt + 1
                else
                    v:setVisible(false)
                end
            end
        end
    end
end

--[[
* @brief 关闭按钮
]]
function ReturnGoldView:onClickClose( sender )

	if self._cb then
	   self._cb(0)
	end
	self:removeSelf()
end

function ReturnGoldView:keyBackClicked()
    self:onClickClose()
    return true, true
end

--[[
* @brief 购买
]]
function ReturnGoldView:onClickBuy( sender )

    if self._goods then

        -- 返还豆豆数
        self._goodsInfo.back_dou = checkint( self._consumeGold + self._giveGold )

        local payType = gg.PayHelper:getPayMethods( self._goods )

        local tag = sender:getTag()
        if tag == BuyTypeTag.CHANNEL then

            gg.PayHelper:payByMethod( self._goodsInfo , payType[1] )
        elseif tag == BuyTypeTag.WX then

            gg.PayHelper:payByMethod( self._goodsInfo , "wechatH5" )
        elseif tag == BuyTypeTag.ZFB then

            gg.PayHelper:payByMethod( self._goodsInfo , "alipayH5" )
        elseif tag == BuyTypeTag.APPLE then

            gg.PayHelper:payByMethod( self._goodsInfo , "appstore" )
        end

        -- 回调游戏
        if self._cb then
            self._cb(1)
        end
    end

end

function ReturnGoldView:onPayResultsCallBack( event, result )
    -- 支付成功,移除界面
	if result.status == 0 then
		self:removeSelf()
	end
end

return ReturnGoldView