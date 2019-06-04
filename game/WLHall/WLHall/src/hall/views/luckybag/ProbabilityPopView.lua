
local ProbabilityPopView = class("ProbabilityPopView", cc.load("ViewBase"))
ProbabilityPopView.RESOURCE_FILENAME="ui/luckybag/probability_pop_view.lua"
ProbabilityPopView.RESOURCE_BINDING = {
    ["panel_bg"] = { ["varname"] = "panel_bg" },
    ["img_bg"]   = { ["varname"] = "img_bg"   },
	["lv_items"] = { ["varname"] = "lv_items" },
}

function ProbabilityPopView:onCreate(rateTb)
    self:initView(rateTb)
end

function ProbabilityPopView:initView(rateTb)
    self:setPosition(cc.p(display.cx, display.cy))

	-- 点击空白处的时候移除当前view
    local function onClickBg(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            -- 销毁自己
            self:removeSelf()
        end
    end
    self.panel_bg:setContentSize(cc.size(display.width, display.height))
    self.panel_bg:addTouchEventListener(onClickBg)

    self.img_bg:setPosition(cc.p(300, -20))
    -- 隐藏listView滚动条
	self.lv_items:setScrollBarEnabled(false)

    for i,v in ipairs(checktable(rateTb)) do
        if v.award and checkint(v.award[1]) ~= 9999 and checkint(v.award[1]) ~= 9998 then
            local item = self:createItem(v)
            item:setVisible(true)
            self.lv_items:pushBackCustomItem(item)
        end
    end
end

function ProbabilityPopView:createItem(data)
    local item = self:findNode("panel_item"):clone()

    local award = data.award
    local propDef = require("def.PropDef")[checkint(award[1])]
    if not propDef then return end
    -- 奖励物品数量
    local count = checkint(award[2]) * (propDef.proportion or 1)
    local aname = propDef.name or ""
    if checkint(award[1]) == PROP_ID_PHONE_CARD or checkint(award[1]) == PROP_ID_261 then
        if math.floor(count) == count then
            count = string.format("%d", count)
        else
            count = string.format("%.2f", count)
        end
    end

    if checkint(award[1]) == PROP_ID_MONEY then aname = "豆" end
    local txt_award = item:getChildByName("txt_award")
    txt_award:setString(string.format("%s x%s", aname, tostring(count)))

    local img_award = item:getChildByName("img_award")
    img_award:loadTexture(propDef.icon)

    local txt_rate = item:getChildByName("txt_rate")
    txt_rate:setString(string.format("%d%%", data.rate))

    return item
end

return ProbabilityPopView
