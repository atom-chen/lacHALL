
-- Author: zhaoxinyu
-- Date: 2017-02-23 17:00:20
-- Describe：购买提示界面

local BuyPromptView = class("BuyPromptView", cc.load("ViewPop"))

BuyPromptView.RESOURCE_FILENAME="ui/store/buy_prompt_node.lua"

BuyPromptView.RESOURCE_BINDING = {

	["btn_close"]   = { ["varname"] = "btn_close" ,["events"]={{event="click",method="onClickClose"}} },                        -- 关闭按钮

	["img_title"]    	  = { ["varname"] = "img_title" },																		-- 标题
	["img_prop"]    	  = { ["varname"] = "img_prop" },																	    -- 商品Icon
	["txt_price_title"]   = { ["varname"] = "txt_price_title"  },                        										-- 商品规格
	["txt_price"]   	  = { ["varname"] = "txt_price"  },                        											    -- 价格

	["btn_buy"]   		= { ["varname"] = "btn_buy" ,["events"]={{event="click",method="onClickBuy"}} },                        -- 购买
    ["btn_buy_wx"]   	= { ["varname"] = "btn_buy_wx" ,["events"]={{event="click",method="onClickBuy"}} },                     -- 微信支付
    ["btn_buy_zfb"]   	= { ["varname"] = "btn_buy_zfb" ,["events"]={{event="click",method="onClickBuy"}} },                    -- 支付宝支付
    ["btn_buy_apple"]   = { ["varname"] = "btn_buy_apple" ,["events"]={{event="click",method="onClickBuy"}} },                  -- 支付宝支付
    ["btn_buy_apple_1"] = { ["varname"] = "btn_buy_apple_1" ,["events"]={{event="click",method="onClickBuy"}} },                  -- 支付宝支付
    
    ["btn_buy_wx_1"]   	= { ["varname"] = "btn_buy_wx_1" ,["events"]={{event="click",method="onClickBuy"}} },                   -- 支付宝支付
    ["btn_buy_zfb_1"]   = { ["varname"] = "btn_buy_zfb_1" ,["events"]={{event="click",method="onClickBuy"}} },                  -- 支付宝支付


    ["img_gift"]   	  = { ["varname"] = "img_gift"  },
    ["txt_gift"]   	  = { ["varname"] = "txt_gift"  },
	["btn_pay_channel_node"]      = { ["varname"] = "btn_pay_channel_node"  },                                                  -- 购买
    ["btn_pay_trilateral_node"]   = { ["varname"] = "btn_pay_trilateral_node"  },                                               -- 第三方支付
    ["btn_pay_apple_node"]        = { ["varname"] = "btn_pay_apple_node"  },                                                    -- 苹果支付
}

local BuyTypeTag = {

    CHANNEL = 1,        -- 渠道
    WX = 2,             -- 微信
    ZFB = 3,            -- 支付宝
    APPLE = 4           -- 苹果
}

function BuyPromptView:create( doGift, gameid, roomid, stage, giftDiamond )
    return self.new(nil, "BuyPromptView", doGift, gameid, roomid, stage, giftDiamond )
end

function BuyPromptView:onCreate(doGift, gameid, roomid, stage, giftDiamond)
    self.doGift = doGift
    self.gameid = gameid
    self.roomid = roomid
    self.stage  = stage
    self.giftDiamond = giftDiamond

    -- 初始化
    self:init()

    -- 初始化View
    self:initView()

    self:addEventListener( gg.Event.ON_PAY_RESULT, handler( self, self.onPayResultsCallBack ) )
end

function BuyPromptView:init()

	self._goodsdata = nil

	self._cb = nil
end

--[[
* @brief 初始化View
]]
function BuyPromptView:initView()

	self:setScale(display.scaleX)
end

--[[
* @brief 设置商品
* @param id 商品ID
]]
function BuyPromptView:setGoods( goodsdata )
	if goodsdata then
		assert(type(goodsdata)=="table","商品参数类型不正确")
		if goodsdata.type==PROP_ID_MONEY then
            -- 设置标题
			self.img_title:loadTexture("common/buy_prompt/pic_bcdd.png",1)
            if not IS_REVIEW_MODE and goodsdata.gift_count ~=0 then
                self.txt_price_title:setString( string.format( "【%s万豆】" , goodsdata.ori_count ) )
                self.img_gift:setVisible(true)
                -- 设置赠送
                self.txt_gift:setString( string.format( "%s万豆" , goodsdata.gift_count) )
                if goodsdata.gift_count < 1 then
                    local doudou_count = goodsdata.gift_count * 10000
                    self.txt_gift:setString( string.format( "%s豆" , doudou_count) )
                end
                self.txt_price_title:setPositionX(self.txt_price_title:getPositionX() - 30 )
            else
                self.txt_price_title:setString( string.format( "【%s万豆】" , goodsdata.count) )
            end

        elseif goodsdata.type == PROP_ID_XZMONEY then
			-- 设置标题
			self.img_title:loadTexture("common/buy_prompt/pic_hqzs.png",1)

            if not IS_REVIEW_MODE and goodsdata.gift_count ~=0 then
                self.txt_price_title:setString( string.format( "【%d钻石】" , checkint(goodsdata.ori_count) ) )
                self.img_gift:setVisible(true)
                -- 设置赠送
                self.txt_gift:setString( string.format( "%d钻石" , checkint(goodsdata.gift_count ) ) )
                self.txt_price_title:setPositionX(self.txt_price_title:getPositionX() - 30 )
            else
                self.txt_price_title:setString( string.format( "【%d钻石】" , checkint(goodsdata.count) ) )
            end
            -- 更换图片
            self.img_prop:loadTexture("common/buy_prompt/zshi.png")
		end
		-- 设置价格
        self.txt_price:setString( goodsdata.price.."元" )

		--游戏中标题为“转运礼包”
		if GameClient then
			self.img_title:loadTexture("common/buy_prompt/pic_lb.png",1)
		end

		self._goodsdata = goodsdata

		-- 支付方式显示
		self:showBuyBtn()
	end
end

--[[
* @brief 关闭按钮
]]
function BuyPromptView:onClickClose( sender )
    if self.doGift and hallmanager then
        -- 如果是直接关闭了，且指定需要申请救济金
        if self.giftDiamond or (self._goodsdata and self._goodsdata.type and self._goodsdata.type == PROP_ID_XZMONEY) then
            hallmanager:DoCompleteMission(hallmanager.MISSION_DAILY_GIFT_XZMONEY)
        else
            hallmanager:DoCompleteMission(MISSION_DAILY_GIFT_MONEY)
        end
    end

	if self._cb then
		self._cb(0)
	end
	self:removeSelf()
end

function BuyPromptView:keyBackClicked()
    self:onClickClose()
    return true, true
end

--[[
* @brief 购买
]]
function BuyPromptView:onClickBuy( sender )

	-- 播放点击音效
    gg.AudioManager:playClickEffect()

	-- 弹出支付界面
	if self._goodsdata then

		local tag = sender:getTag()
		local payType = gg.PayHelper:getPayMethods( self._goodsdata.goods )
        if tag == BuyTypeTag.CHANNEL then
            gg.PayHelper:payByMethod( self._goodsdata , payType[1] )
        elseif tag == BuyTypeTag.WX then
            gg.PayHelper:payByMethod( self._goodsdata , "wechatH5" )
        elseif tag == BuyTypeTag.ZFB then
            gg.PayHelper:payByMethod( self._goodsdata , "alipayH5" )
        elseif tag == BuyTypeTag.APPLE then
            gg.PayHelper:payByMethod( self._goodsdata , "appstore" )
        end


		if self._cb then
			self._cb(1)
		end
	end
end

--[[
* @brief 设置关闭回调
]]
function BuyPromptView:setCloseCallBack( cb )

	self._cb = cb
end

function BuyPromptView:onPayResultsCallBack( event, result )
    -- 支付成功,移除界面
	if result.status == 0 then
		self:removeSelf()
	end
end

--[[
* @brief 显示支付按钮
]]
function BuyPromptView:showBuyBtn()

    -- 获取商品支付类型
    if self._goodsdata then

        local payType = gg.PayHelper:getPayMethods( self._goodsdata.goods )
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
                    v:setPositionX(20 + cnt * 285)
                    v:setVisible(true)
                    cnt = cnt + 1
                else
                    v:setVisible(false)
                end
            end
        end
    end
end

return BuyPromptView