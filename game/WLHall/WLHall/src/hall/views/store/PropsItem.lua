
-- Author: zhaoxinyu
-- Date: 2017-02-17 14:16:20
-- Describe：商城中的道具

local PropsItem = class("PropsItem", cc.load("ViewLayout"))

PropsItem.RESOURCE_FILENAME="ui/store/item_props.lua"

PropsItem.RESOURCE_BINDING = {

    ["img_give_bg"]   = { ["varname"] = "img_give_bg"  },
    ["img_icon"]   = { ["varname"] = "img_icon"  },
    ["img_shadow"]   = { ["varname"] = "img_shadow"  },                                                                         -- 道具图标
    ["txt_money"]   = { ["varname"] = "txt_money"  },                                                                       -- 价格
    ["btn_bg"]   = { ["varname"] = "btn_bg" ,["events"]={{event="click_color",method="onClick"}}  },                        -- 背景
    ["txt_name"]   = { ["varname"] = "txt_name"  },                                                                         -- 道具名字
    ["btn_servise"]   = { ["varname"] = "btn_servise" ,["events"]={{event="click",method="onClickPropInfo"}}   },           -- 道具详细信息
    ["text_unit"]   = { ["varname"] = "text_unit"  },                                                                       --
    ["img_money_ico"]   = { ["varname"] = "img_money_ico"  },                                                               --
}

local storeData=require("hall.models.StoreData")
function PropsItem:onCreate()

    -- 初始化
    self:init()

    -- 初始化View
    self:initView()

end

function PropsItem:init()

    self._propsData = nil

    self._fun = nil

    self._profDef  = gg.GetPropList()
end

--[[
* @brief 初始化View
]]
function PropsItem:initView()

    self.btn_bg:retain()
    self.btn_bg:removeFromParent( true )
    self:addChild( self.btn_bg )
    self.btn_bg:release()
end

--[[
* @brief 设置数据
* @param propsData 商品数据
]]
function PropsItem:setData( propsData )

    if not propsData then
        return
    end

    -- 道具数据
    self._propsData = propsData

    -- 新耀月卡和贵族月卡要显示阴影
    if propsData.id == 16 or propsData.id == 17 then
        self.img_shadow:setVisible(true)
    end

    -- 关联道具
    local nameStr = ""
    if propsData.goods == "DIAMOND_TO_DOU" then
        -- 钻石兑换豆
        nameStr = BEAN_NAME
        self.img_icon:setSpriteFrame( propsData.ico or "" )
    elseif propsData.type == nil then
        self.img_icon:setTexture( propsData.ico )

        -- 设置名字数量
        nameStr = propsData.name ..  gg.IIF( propsData.count , " x" , "" )  .. ( propsData.count or "" )
    --兑换类型是豆且需要道具
    elseif propsData.type == PROP_ID_MONEY and propsData.srcprop then
        nameStr = gg.MoneyUnit( propsData.targetCount ) .. "豆"
        self.img_icon:setSpriteFrame( propsData.ico or ""  )
    --兑换类型是钻石且需要道具
    elseif propsData.type == PROP_ID_XZMONEY and propsData.srcprop then
        nameStr = propsData.count .. "钻石"
        self.img_icon:setSpriteFrame( propsData.ico or "" )
    elseif propsData.type == PROP_ID_MONEY  then
        nameStr = self:isBeanAllVisible(propsData) .. "万豆"
        self.img_icon:setSpriteFrame( propsData.ico or "" )
    elseif propsData.type == PROP_ID_XZMONEY  then
        nameStr = self:isDiamondAllVisible(propsData) .. "钻石"
        self.img_icon:setSpriteFrame( propsData.ico or "" )
    else
        local count = propsData.count
        if propsData.ori_count and not IS_REVIEW_MODE then
            count = propsData.ori_count
        end
        local prop = self._profDef[ propsData.type ]
        local prob_icon = prop.icon_l or prop.icon
        self.img_icon:setTexture(prob_icon or "" )

        nameStr = prop.name .. gg.IIF( count, " x" , "" ) .. count or ""
        if self._propsData.type == PROP_ID_JIPAI then
            nameStr = string.format( "%s(%d%s)" ,prop.name,count,prop.unit)
        end
    end


    if self.richName then
        self.updateRichName(self.richName, nameStr)
    else
        self.richName = self:createRichName(nameStr)
        self.richName:setAnchorPoint(cc.p(0, 0.5))
        self.richName:setPosition( self.txt_name:getPosition())
        self.txt_name:getParent():addChild( self.richName )
        self.txt_name:removeFromParent()
    end

    -- 设置钱数
    self.txt_money:setString( string.format( "¥%s" , propsData.price or 0 ) )

    -- 是否赠送 (设置赠送数据)
    if checkint(propsData.gift_count) > 0 and not IS_REVIEW_MODE then
        -- 设置赠送数量
        self.img_give_bg:setVisible( true )
        if propsData.type == PROP_ID_MONEY or propsData.type == PROP_ID_JIPAI then
            local grant =   self.img_give_bg:getChildByName("prop_num")
            local strtxt = ""
            if propsData.type == PROP_ID_MONEY then
                strtxt = string.format( "%s%s", self:GetMoneyUnit(propsData.gift_count*10000))
            else
                local prop = self._profDef[ propsData.type ]
                strtxt = string.format( "%s%s",propsData.gift_count, prop.unit)
            end
            local function _updateRichNode(node, txt)
                node:setString(txt)
                node:walkElements(function(node, index)
                    local ss = node:getString()
                    if not tonumber(ss) then
                        node:setFontSize(22)
                    end
                end)
            end
            -- 处理数字比汉子大的问题
            if grant then
                local RichLabel = require("common.richlabel.RichLabel")
                local richLb = RichLabel.new{
                    fontSize = 28,
                    fontColor = cc.c3b(255, 255, 255),
                }
                _updateRichNode(richLb, strtxt)
                richLb:setAnchorPoint(cc.p(0.5, 0.5))
                richLb:setPosition(cc.p(grant:getPositionX(), grant:getPositionY()))
                richLb:setName("give_num_rich")
                self.img_give_bg:addChild(richLb)
                grant:removeFromParent()
            else
                local richNode = self.img_give_bg:getChildByName("give_num_rich")
                if richNode then
                    _updateRichNode(richNode, strtxt)
                end
            end
        else
            self.img_give_bg:getChildByName("prop_num"):setString(string.format( "%s", propsData.gift_count));
        end
    end

    if propsData.srcprop then

        local propPrice
        if propsData.price then
            propPrice = propsData.price * (self._profDef[propsData.srcprop].proportion or 1)
        end
        if propsData.goods == "DIAMOND_TO_DOU" then
            -- 钻石兑换豆
            self.txt_money:setString(self._profDef[propsData.srcprop].name)
        elseif propsData.srcprop == PROP_ID_MONEY then
            self.txt_money:setString(gg.MoneyUnit( propPrice ) .. "豆")
        elseif propsData.srcprop == PROP_ID_XZMONEY then
            self.txt_money:setString(string.format( "%d%s", propPrice, self._profDef[propsData.srcprop].name))
        else
            --判断金额是否有小数
            if math.floor(propPrice) < propPrice or propsData.srcprop == PROP_ID_261 then
                -- 设置购买类型
                self.txt_money:setString( string.format( "%.2f%s" , propPrice, self._profDef[ propsData.srcprop ].name or "" ) )
            else
                -- 设置购买类型
                self.txt_money:setString( string.format( "%d%s%s" , propPrice,  self._profDef[ propsData.srcprop ].unit or ""  , self._profDef[ propsData.srcprop ].name or ""  ) )
            end
        end
    end

    -- 设置购买类型
    if propsData.hldpic then
        local txtMoney,txtUnit = self:GetMoneyUnit(propsData.hldpic)
        self.txt_money:setString(txtMoney)
        self.text_unit:setString(txtUnit .."豆")
    end

    local unitWigth = self.text_unit:getContentSize().width/2
    local moneyWigth = self.txt_money:getContentSize().width/2
    self.txt_money:setPositionX(self.txt_money:getPositionX()-unitWigth)
    self.text_unit:setPositionX(self.text_unit:getPositionX()+moneyWigth)

    -- 详细信息
    self.btn_servise:setVisible( propsData.isDes or false )
end

function PropsItem:createRichName(txt)
    if not txt then
        return
    end

    local RichLabel = require("common.richlabel.RichLabel")
    local label = RichLabel.new {
        fontSize = 28,
        fontColor = cc.c3b(51, 51, 51),
        maxWidth = 670,
        lineSpace = 0,
        charSpace = 0,
    }

    self:updateRichName(label, txt)
    return label
end

function PropsItem:updateRichName(node, txt)
    if not node then
        return
    end

    node:setString(txt)
    node:walkElements(function ( node ,index )
        local ss = node:getString()
        if tonumber(ss) then
            node:setFontSize( 31 )
        end
    end)
end

--[[
* @brief 设置回调
* @param fun 点击回调函数 function( goodsName , price )   end
]]
function PropsItem:setFun( fun )

    self._fun = fun
end

--[[
* @brief 获取大小
]]
function PropsItem:getSize()

    return self.btn_bg:getContentSize()
end

--[[
* @brief 支付
]]
function PropsItem:onClick( sender )

    -- 商品信息
    local data = self._propsData

    -- 是否有详情界面
    if self._propsData.isDes then

        self:onClickPropInfo( self.btn_servise )
        return
    end

    if self._propsData.hldpic or self._propsData.srcprop then
        if self._propsData.goods == "DIAMOND_TO_DOU" then
            local diamondcount = hallmanager and hallmanager:GetXZMoneyCount()
            if diamondcount < 25 then
                -- 钻石换豆的话，玩家钻石不足 25 提示不能兑换
                GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "钻石不足25个，不能进行兑换。")
            else
                local data = clone(self._propsData)
                data.price = diamondcount
                data.targetCount = diamondcount * 1000

                local exchangeView = self:getScene():createView("store.ExchangeView" , data )
                exchangeView:pushInScene()
            end
        else
            -- 打开兑换界面
            local exchangeView = self:getScene():createView("store.ExchangeView" , self._propsData )
            exchangeView:pushInScene()
        end
    else
        --用户身上要是有记牌器就一定要他先使用才让购买
        if data.type == PROP_ID_JIPAI then
            local cnt = 0
            if hallmanager and hallmanager:IsConnected() then
                cnt = hallmanager:GetPropCountByID(PROP_ID_JIPAI)
            end
            if cnt > 0 then
                GameApp:DoShell(self:getScene(), "UseJiPaiQi://")
                return
            end
        end
        
        if self._fun then
            self._fun(data)
        end
    end
end

--[[
* @brief 详细信息
]]
function PropsItem:onClickPropInfo( sender )


    -- 播放点击音效
    gg.AudioManager:playClickEffect()

    if self._propsData.goods == "month_card_normal" then
        self:getScene():createView("active.ActivityView", {first_but_tag = 2}):pushInScene()
    elseif self._propsData.goods == "month_card_vip" then
        self:getScene():createView("active.ActivityView", {first_but_tag = 2}):pushInScene()
    else
        -- 弹出道具礼包界面
        local propsInfoView = self:getScene():createView("store.PropsInfoView" , self._propsData )
        propsInfoView:pushInScene()
        propsInfoView:setFun( function( goodsName , price , count )

            if self._fun then
                self._fun( self._propsData )
            end
         end )

        local pv = self:getParent():getParent()
        local pvSize = pv:getContentSize()

        -- 本地坐标转世界坐标
        local wordP = pv:convertToWorldSpace( cc.p( pvSize.width / 2 , pvSize.height / 2 + 25 ) )
        propsInfoView:setPosition( cc.p( display.width / 2 , display.height / 2 ) )
    end
end

--[[
* @brief 审核状态 显示全部钻石
]]
function PropsItem:isDiamondAllVisible(propsData)
    if IS_REVIEW_MODE then
        return propsData.count
    else
        return propsData.ori_count or propsData.count
    end
end

--[[
* @brief 审核状态 显示全部金豆
]]
function PropsItem:isBeanAllVisible(propsData)
    if IS_REVIEW_MODE then
        return propsData.count
    else
        return propsData.ori_count
    end
end

--[[
* @brief 获取单位
]]
function PropsItem:GetMoneyUnit(money)
    local function fn(m, b)
        return tostring(math.ceil(m / b))
    end

    if money >= 100000000 then
        return fn(money, 100000000), "亿"
    elseif money >= 10000000 then
        return fn(money, 10000000), "千万"
    elseif money >= 10000 then
        return fn(money, 10000), "万"
    elseif money >= 1000 then
        return fn(money, 1000), "千"
    else
        return tostring(money), ""
    end
end

return PropsItem
