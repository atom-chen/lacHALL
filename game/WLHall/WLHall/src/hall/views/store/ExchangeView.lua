
-- Author: zhaoxinyu
-- Date: 2017-03-16 13:36:20
-- Describe：兑换界面

local ExchangeView = class("ExchangeView", cc.load("ViewPop"))

ExchangeView.RESOURCE_FILENAME="ui/store/exchange_view.lua"

ExchangeView.RESOURCE_BINDING = {

    ["btn_close"]   = { ["varname"] = "btn_close" ,["events"]={{event="click",method="onClickClose"}} },                        -- 关闭按钮
    ["btn_exchange"]   = { ["varname"] = "btn_exchange" ,["events"]={{event="click",method="onClickExchange"}} },               -- 兑换
    ["btn_cancel"]   = { ["varname"] = "btn_cancel" ,["events"]={{event="click",method="onClickClose"}} },                      -- 取消按钮

    ["img_props_f"]   = { ["varname"] = "img_props_f" },                                                                        -- 兑换道具froma
    ["img_props_t"]   = { ["varname"] = "img_props_t" },                                                                        -- 兑换道具to

    ["Node_content"]   = { ["varname"] = "Node_content" },

}

-- 兑换提示
local _exchangePrompt = nil

local HongBaoContent =  "<div><div fontcolor=#222222>(当前拥有</div> %s:%.2f <div fontcolor=#222222>)</div></div>"


local Content1 = "<div><div fontcolor=#222222>您将用 </div> %s%s <div fontcolor=#222222>兑换</div> %d%s%s <div fontcolor=#222222>？</div></div>"
local Content2 = "<div><div fontcolor=#222222>您将用 </div> %s%s <div fontcolor=#222222>兑换</div> %s <div fontcolor=#222222>？</div></div>"

--道具兑换微乐豆
local Content3 = "<div><div fontcolor=#222222>您将用 </div> %0.2f%s <div fontcolor=#222222>兑换</div> %s豆 <div fontcolor=#222222>？</div></div>"
local Content4 = "<div><div fontcolor=#222222>您将用 </div> %d%s%s <div fontcolor=#222222>兑换</div> %s豆  <div fontcolor=#222222>？</div></div>"

--[[
* @brief 创建函数
]]
function ExchangeView:onCreate( goods )

    if not goods then
        return
    end

    -- 初始化
    self:init( goods )

    -- 初始化View
    self:initView()
end

--[[
* @brief 初始化
]]
function ExchangeView:init( goods )

    self._goods = goods

    self._profDef  = gg.GetPropList()
end

--[[
*@brief 道具兑换微乐豆
]]
function ExchangeView:exchangeDou()

    --道具金额
    local goodsPrice = self._goods.price
    local srcUnit = ""

    if self._profDef[self._goods.srcprop] then
        goodsPrice = self._goods.price * (self._profDef[self._goods.srcprop].proportion or 1)
        srcUnit = self._profDef[self._goods.srcprop].unit or ""
    end

    -- 设置道具的数量
    self.img_props_f:getChildByName("txt_count"):setString(goodsPrice )

    -- 设置道具图片
    local img_props = self.img_props_f:getChildByName("img_prop")
    img_props:loadTexture( self._profDef[self._goods.srcprop].icon )
    img_props:ignoreContentAdaptWithSize( true )

    -- 设置豆豆图片
    local img_prop = self.img_props_t:getChildByName("img_prop")
    img_prop:loadTexture(self._goods.ico , 1 )
    img_prop:ignoreContentAdaptWithSize( true )

    -- 设置豆数
    self.img_props_t:getChildByName("txt_count"):setString( gg.MoneyUnit( self._goods.targetCount ))

    local RichLabel = require("common.richlabel.RichLabel")
    local label = RichLabel.new({
      fontSize = 27,
      fontColor = cc.c3b(255, 153, 0),
    })
    if math.floor(goodsPrice)<goodsPrice or self._goods.srcprop == PROP_ID_261  then
        --判断是小数
        label:setString(string.format(Content3,goodsPrice, self._profDef[ self._goods.srcprop ].name,gg.MoneyUnit( self._goods.targetCount) ))
        self.img_props_f:getChildByName("txt_count"):setString(string.format("%.2f", goodsPrice))
    else
       --判断是整数
       label:setString(string.format(Content4,goodsPrice, srcUnit, self._profDef[ self._goods.srcprop ].name,gg.MoneyUnit(self._goods.targetCount)))
       self.img_props_f:getChildByName("txt_count"):setString(string.format("%.2f", goodsPrice))
    end
    self.Node_content:addChild(label)

end

--[[
* @brief 初始化View
]]
function ExchangeView:initView()

    --兑换豆豆
    if self._goods.type == PROP_ID_MONEY and self._goods.srcprop then
        self:exchangeDou()
        return
    end

    local propFTxt = ""
    local fromName = "豆"
    if self._goods.srcprop and self._goods.srcprop ~= PROP_ID_MONEY then
        -- 使用指定的道具兑换其他道具
        if self._goods.srcprop == PROP_ID_261 then
            propFTxt = string.format("%.2f", self._goods.price * self._profDef[PROP_ID_261].proportion)
        else
            propFTxt = ""..(self._goods.price or 0)
        end
        fromName = self._profDef[self._goods.srcprop].name
        local src_img_prop = self.img_props_f:getChildByName("img_prop")
        src_img_prop:loadTexture( self._profDef[self._goods.srcprop].icon )
    elseif self._goods.hldpic then
        propFTxt = gg.MoneyUnit( self._goods.hldpic )..fromName
    else
        propFTxt = gg.MoneyUnit( self._goods.price )..fromName
    end

    -- 设置豆数
    self.img_props_f:getChildByName("txt_count"):setString( propFTxt )

    local img_prop = self.img_props_t:getChildByName("img_prop")

    -- 设置兑换道具
    if self._goods.ico then
        if self._goods.goods == "goods18" or self._goods.goods == "goods19" then
            -- 魔法道具礼包的图片不是合图
            img_prop:loadTexture(self._goods.ico)
        else
            img_prop:loadTexture(self._goods.ico, 1)
        end
    else
        img_prop:loadTexture( self._profDef[self._goods.type or PROP_ID_ROOM_CARD ].icon )
    end

    -- 设置数量
    local t = nil
    if self._goods.count then
        t = string.format( "%d%s" , self._goods.count, self._profDef[self._goods.type].unit or "")
        self.img_props_t:getChildByName("txt_count"):setString( t )
    else

        self.img_props_t:getChildByName("txt_count"):setVisible(false)
    end

    local RichLabel = require("common.richlabel.RichLabel")
    local label = RichLabel.new({
      fontSize = 27,
      fontColor = cc.c3b(255, 153, 0),
    })

    if  self._goods.type  then
        --判断是小数
        label:setString(string.format(Content1,propFTxt,fromName,self._goods.count or 1 , self._profDef[ self._goods.type ].unit or "个" , self._profDef[ self._goods.type ].name))
    else
        --判断是整数
        label:setString(string.format(Content2,propFTxt,fromName,self._goods.name))
    end

    self.Node_content:addChild(label)

    if self._goods.srcprop == PROP_ID_261 then
        -- 红包兑换其他道具，显示玩家红包数量
        local propList = checktable(hallmanager.proplist)
        local userPropCount = checkint(propList[self._goods.srcprop])
        local RichLabel = require("common.richlabel.RichLabel")
        local hongbaolabel = RichLabel.new({
          fontSize = 27,
          fontColor = cc.c3b(255, 153, 0),
        })
        hongbaolabel:setString(string.format(HongBaoContent,self._profDef[PROP_ID_261].name, userPropCount * self._profDef[PROP_ID_261].proportion))
        hongbaolabel:setPositionY(-27)
        self.Node_content:addChild(hongbaolabel)
    end
end

--[[
* @brief 关闭按钮
]]
function ExchangeView:onClickClose( sender )

    self:removeSelf()
end

--[[
* @brief 兑换按钮
]]
function ExchangeView:onClickExchange( sender )

    -- 播放点击音效
    gg.AudioManager:playClickEffect()
    
    -- 设置兑换提示
    if not self._goods.type then
        _exchangePrompt = string.format( "成功兑换%s" , self._goods.name )
    elseif self._goods.type== PROP_ID_MONEY then
        _exchangePrompt = string.format( "成功兑换%s豆" ,  gg.MoneyUnit( self._goods.targetCount ) )
    else
        _exchangePrompt = string.format( "成功兑换%s%d%s" , self._goods.name or self._profDef[ checkint( self._goods.type ) ].name or "" , self._goods.count , self._profDef[ checkint( self._goods.type )  ].unit or "个"  )
    end

    local function callback(a)
        if a and a.status == 0 and _exchangePrompt then
            GameApp:dispatchEvent(gg.Event.SHOW_TOAST, _exchangePrompt)
            _exchangePrompt = nil
        elseif a.status ~= 100 and a.status ~= 99 then
            GameApp:dispatchEvent(gg.Event.SHOW_TOAST, a.msg)
        end
    end

    if self._goods.goods == "DIAMOND_TO_DOU" then
        gg.Dapi:DiamondToDou(callback)
    else
        -- 请求服务器兑换
        gg.Dapi:Exchange( self._goods.goods , 1 , callback)
    end

end

return ExchangeView