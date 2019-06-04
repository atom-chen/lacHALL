
----------------------------------------------------------------------
-- 作者：chenjingmin
-- 日期：2017-03-15
-- 描述：创建朋友场主界面
----------------------------------------------------------------------

local WelcomeSevenDay = class("WelcomeSevenDay", cc.load("ViewBase"))
WelcomeSevenDay.RESOURCE_FILENAME = "ui/active/activity_xslb.lua"
WelcomeSevenDay.RESOURCE_BINDING = {
    ["panel_bg"]    = { ["varname"] = "panel_bg" },
    ["panel_red"]    = { ["varname"] = "panel_red" },
    ["exchange"]      = { ["varname"] = "exchange", ["events"] = { { ["event"] = "click", ["method"] = "onClickExchange" } } },
    ["text_current_money"]      = { ["varname"] = "text_current_money"  },
}

function WelcomeSevenDay:onCreate()
    -- 初始当前红包金额
    self.text_current_money:setString("")
    -- 拉取数据
    self:PullData()
end

-- 创建红包
function WelcomeSevenDay:initView(data)
    for i,v in ipairs(data) do
      local item = self:createAddedItem( i,v )
      self.panel_red:addChild( item )
    end
end

function WelcomeSevenDay:createAddedItem(i,v)
    local node = require("ui/active/activity_xslb_item.lua").create()
    local item_record = {}
    local item_text = {}

    if v == 1 then
      item_record = node.root:getChildByName("panel_alread_receive")
      item_record:removeFromParent()
    elseif v == 0 then
      item_record = node.root:getChildByName("panel_miss")
      item_record:removeFromParent()
    elseif v == 2 then
      item_record = node.root:getChildByName("panel_wait")
      item_record:removeFromParent()
      item_text = item_record:getChildByName("text_wait")
      item_text:setString( string.format("%d",i))
    end

    item_record:setContentSize(cc.size(item_record:getContentSize().width, item_record:getContentSize().height))
    if i<4 then
      item_record:setPosition(cc.p((item_record:getContentSize().width + 36) * (i-1) + 8, item_record:getContentSize().height + 18))
    else
      item_record:setPosition(cc.p((item_record:getContentSize().width + 36) * (i-4) + 8, -8))
    end
    return item_record
end

--[[
* @brief 拉取网络数据
]]
function WelcomeSevenDay:PullData()
    -- 拉取数据
    gg.Dapi:AffActivitySevenDayData(function( result )
        if tolua.isnull(self) then return end
        if not result then return end
        local propDef = gg.GetPropList()
        local red_val = result.red_val * (propDef[PROP_ID_261].proportion or 1)
        self.text_current_money:setString(tostring(red_val).."元")
        self:initView(checktable(result.data))
    end )
end

--兑换事件
function WelcomeSevenDay:onClickExchange()
    --礼品卷 "lipin"，话费标签：huafei，红包标签："hongbao" 兑换记录："duihuan"
    self:getScene():createView("gift.GiftView","hongbao"):pushInScene()
end

return WelcomeSevenDay
