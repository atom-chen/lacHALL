--[[
层级关系说明
ShockView 摇一摇主界面
]]


local ShakeView = class("ShakeView",  cc.load("ViewPop"))
ShakeView.RESOURCE_FILENAME = "ui/popupGoodsView/shake_node.lua"
ShakeView.RESOURCE_BINDING = {
    ["full_bg"]     = { ["varname"] = "full_bg"     },    -- 背景,要添加 现价和原价的字符串
    ["xj_content"]     = { ["varname"] = "xj_content"     },
    ["yj_content"]     = { ["varname"] = "yj_content"     },
    ["del_line"]     = { ["varname"] = "del_line"     },
    ["btn_ljgm"]   = { ["varname"] = "btn_ljgm" , ["events"]={{event="click",method="onClickPay"}}   },
    ["btn_wx"]   = { ["varname"] = "btn_wx" , ["events"]={{event="click",method="onClickPay"}}   },
    ["btn_ali"]   = { ["varname"] = "btn_ali" , ["events"]={{event="click",method="onClickPay"}}   },
    ["btn_apple"]   = { ["varname"] = "btn_apple" , ["events"]={{event="click",method="onClickPay"}}   },
    ["btn_wx_1"]   = { ["varname"] = "btn_wx_1" , ["events"]={{event="click",method="onClickPay"}}   },
    ["btn_ali_1"]   = { ["varname"] = "btn_ali_1" , ["events"]={{event="click",method="onClickPay"}}   },
    ["btn_close"]   = { ["varname"] = "btn_close" , ["events"]={{event="click",method="OnClose"}}   },

    ["yuan_l"]   = { ["varname"] = "yuan_l" , ["events"]={{event="touch",method="OnShake"}}   },
    ["yuan_r"]   = { ["varname"] = "yuan_r" , ["events"]={{event="touch",method="OnShake"}}   },
    ["btn_y"]   = { ["varname"] = "btn_y" , ["events"]={{event="touch",method="OnShake"}}   },
}

function ShakeView:onCreate()

    --适配分辨率
    self:setScale(display.scaleX)
    local paymethod = gg.PayHelper:getPayMethods("goods161")
    self:initPay( paymethod )
    self.animation = self.resourceNode_["animation"]
    self.animation:setFrameEventCallFunc(function(frame)
        if not frame then return end
        local event = frame:getEvent()
        if event == "shake_end" then
            gg.AudioManager:playEffect("res/common/audio/shakeover.mp3")
            self.animation:play("mov_ani", false)
        elseif event == "move_end" then
            if self.PaySet then
                self.PaySet:setVisible(true)
            end
        end
    end)

    self:runAction(self.animation)

    local goodsdata = gg.PopupGoodsData:getGoodsDataByID("goods161")
    if not goodsdata then
        return
    end
    self._propDef = gg.GetPropList()
    self:setProps(goodsdata["prop"])
    if goodsdata["price"] then
        self.xj_content:setString("现价："..tostring(goodsdata["price"]).."元")
    end

    if goodsdata["ori_price"] then
        self.yj_content:setString("原价："..tostring(goodsdata["ori_price"]).."元")
    end

    self:addEventListener( gg.Event.ON_PAY_RESULT, handler( self, self.onPayResultsCallBack ) )

    if IS_REVIEW_MODE then
        self.yj_content:setVisible(false)
        self.del_line:setVisible(false)
        self.xj_content:setPositionY(self.xj_content:getPositionY() + 35)
    end
end

--支付成功关闭页面
function ShakeView:onPayResultsCallBack(event, result)
    if result.status==0 then
        self:removeSelf()
    end
end

function ShakeView:initPay( payMethods )
    local payCount = #payMethods
    self.PaySet = self.full_bg:getChildByName("PaySet_"..payCount)

    -- 根据渠道显示 支付按妞
    if self.PaySet then
        if payCount == 1 then
            self.btn_ljgm:setName(payMethods[payCount])
        elseif payCount == 2 then
            local wechatH5 = self.PaySet:getChildByName("btn_wx")
            local alipayH5 = self.PaySet:getChildByName("btn_ali")
            wechatH5:setName(payMethods[1])
            alipayH5:setName(payMethods[2])
        elseif payCount == 3 then
            local wechatH5 = self.PaySet:getChildByName("btn_wx_1")
            local alipayH5 = self.PaySet:getChildByName("btn_ali_1")
            local apple = self.PaySet:getChildByName("btn_apple")
            wechatH5:setName(payMethods[1])
            alipayH5:setName(payMethods[2])
            apple:setName(payMethods[3])
        end
    end
end

-- 设置摇一摇礼包
function ShakeView:setProps( data )
    local cfg={[15]="金豆"}
    for i,v in ipairs( checktable(data) ) do
        local propDef = self._propDef[ checkint(v[1]) ]
        if not propDef then return end

        -- local item = self:findNode( "item_"..i )
        -- local img = item:getChildByName( "img_prop" )
        local enditem = self:findNode( "enditem_"..i )
        local endimg = enditem:getChildByName( "img_prop_"..i )
        local endnum = enditem:getChildByName( "num_content_"..i )
        local endunit = enditem:getChildByName( "unit_content_"..i )
        local endname = enditem:getChildByName( "name_content_"..i )

        if checkint(v[1])~=15 then
            -- img:setTexture( propDef.icon )
            endimg:setTexture( propDef.icon )
        end

        -- 设置图片
        local unit=propDef.unit or cfg[v[1]]
        --img:setScale( (item:getContentSize().width-30) / img:getContentSize().width )
        endunit:setString(tostring(unit))
        if endname~=nil then
           endname:setString( tostring(propDef.name).."X")
        end

       -- 设置数量
        if checkint(v[1]) == PROP_ID_MONEY and checkint(v[2]) >= 10000 then
            local count = gg.MoneyUnit( checkint(v[2]) )
            endnum:setString( checkint(v[2]) )
        else
            endnum:setString( checkint(v[2]) )
        end
        -- item:show()
        enditem:show()
    end
end

function ShakeView:onClickPay(sender)
    -- 播放点击音效
    gg.AudioManager:playClickEffect()

    local payName = sender:getName()
    gg.PayHelper:payByMethod(gg.PopupGoodsData:getGoodsDataByID("goods161") ,payName)
end

function ShakeView:OnClose()
    self:removeSelf()
end

function ShakeView:OnShake(event)
    if event.name == "began" then
        if self.animation then
            gg.AudioManager:playEffect("res/common/audio/shaking.mp3")
            self.animation:play("shake_ani", false)
            --self.middle_bg:setVisible(true)
        end
    end
end


return ShakeView