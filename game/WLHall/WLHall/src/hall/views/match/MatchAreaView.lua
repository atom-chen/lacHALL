local MatchAreaView = class("MatchAreaView", cc.load("ViewBase"))

MatchAreaView.RESOURCE_FILENAME = "ui/room/match/match_select_area.lua"

MatchAreaView.RESOURCE_BINDING = {
    ["pv_area"]  = {["varname"] = "pv_area" },
    ["panel_bg"] = {["varname"] = "panel_bg"},
    ["panel_pv"] = {["varname"] = "panel_pv"},
    ["img_bg2"]  = {["varname"] = "img_bg2" },
    ["txt_title"]= {["varname"] = "txt_title"},
    ["img_bg"] = {["varname"] = "img_bg", ["events"] = {{event = "click_color", method = "onClickClose"}}},        
    ["btn_confile"] = {["varname"] = "btn_confile", ["events"] = {{event = "click_color", method = "onClickAchieve"}}},
}

local NORMAL_COLOR = cc.c3b(221, 221,221)
local SELECT_COLOR = cc.c3b(0, 0, 0)
local STOP_FRAME = 3
--[[
* @brief 创建
]]
function MatchAreaView:onCreate(btnType,lastBtn,btnData)
    self.btnType = btnType
    self.btnData = checkint(btnData)
    self.lastBtn = checkint(lastBtn)
    -- 标题名称
    if btnType == 2 then
        self.txt_title:setString("请选择城市")
    end
    self.img_bg:setContentSize(cc.size(display.width, display.height))
    self.img_bg:setPosition(cc.size(display.width, display.height))
    self.btn_confile:setPositionX(display.width - 75)
    self.panel_bg:setContentSize(cc.size(display.width, self.panel_bg:getContentSize().height))
    self.img_bg2:setContentSize(cc.size(display.width, self.img_bg2:getContentSize().height))
    self.txt_title:setPositionX(display.cx)

    self.panel_pv:setPositionX(display.cx)
    self._shengItem = self:findNode("panel_sheng")
    self:init()
    self.Area= self:createAreaScrollView()
    self.Area:setSelect(checkint(lastBtn))
end

function MatchAreaView:init()

    self.areaprovincecfg = require "hall.models.areaprovincecfg"
    -- 创建有序的地区表
    self._hasOrderArea = {}
      --直辖市直接对应区(天津、北京、上海、重庆)
     if self.btnData == 12 or self.btnData == 11 or self.btnData == 31 or self.btnData == 50 then
        for k, v in pairs(self.areaprovincecfg) do
            if k == self.btnData then
                table.insert(self._hasOrderArea, {k, v})
            end
        end
     else
        for k, v in pairs(self.areaprovincecfg) do
            --获取数据位数
            local count = self:getNumBits(k)
            if count == 2 and self.btnType == 1 then
                table.insert(self._hasOrderArea, {k, v})
            elseif count == 4 and  self.btnType ==2 then
                if self:isContain(k, self.btnData) then
                    table.insert(self._hasOrderArea, {k, v})
                end
            end
        end

        table.sort(self._hasOrderArea, function(a, b)
            return a[1] > b[1]
        end)
    end
    if #self._hasOrderArea == 0 then return end
    table.insert(self._hasOrderArea, 1,{999, "无地区"})
    table.insert(self._hasOrderArea,2,{999, "无地区"})
    table.insert(self._hasOrderArea,{999, "无地区"})

end
--[[
* @brief 获取数字位数
* @parm num 数字
]]
function MatchAreaView:getNumBits(num)
    return #(num.."")
end


--[[
* @brief 判断 数字a 是否包含 数字b
* @parm a 源数字
* @parm b 被包含
]]
function MatchAreaView:isContain(a, b)
    if b == 0 then
        return self:getNumBits(a) == 2
    end
    local strA = string.format("%d", a)
    local strB = string.format("%d", b)
    local r = string.find(strA, strB)
    return r ~= nil and r == 1
end


function MatchAreaView:setItemData(item, info)
    local img_sheng = item:getChildByName("img_sheng")
    img_sheng:setString(info)
end
function MatchAreaView:onClickAchieve()
    local shengName = self.Area:getSelect()

    self._callback(shengName,shengName[1])
    self:removeSelf()
end

function MatchAreaView:setCallback(callback)
    self._callback = callback
end

function MatchAreaView:onClickClose()

    self:removeSelf()
end


function MatchAreaView:createAreaScrollView()
    local view = ccui.ScrollView:create()
    self.panel_pv:addChild(view, 100)
    local width = 550
    local cellHeight = 80
    local displayCnt = 5
    view:setContentSize(cc.size(width, 295))
    view:setPosition(cc.p(-20, -55))
    view:setScrollBarEnabled(false)
    view._stopCnt = 0
    view._innerY = 0
    view._items = {}
    view._startNumber = 0
    self:startTimer(0.01, function() view:onUpdate() end)

    view._touching = false
    view:addTouchEventListener(function(sender, eventType)
        if eventType == ccui.TouchEventType.began or eventType == ccui.TouchEventType.moved then
            view._touching = true
        else
            view._touching = false
        end
    end)

    -- 重新加载
    function view:reloadData(date)
        self._date = date
        local number = self._startNumber
        local total = date
        local y = 0
        local root = self:getInnerContainer()
        root:removeAllChildren()
        for i, info in pairs(total) do
            local str = string.format("%s", info[2])
            if i<=2 or i>#date-1 then
                str = ""
            end
            local item = ccui.Text:create(str, "", cellHeight)
            item:setAnchorPoint(0.5, 0)
            item:setFontSize(32)
            root:addChild(item)
            item:setPosition(width / 2, y)
            item:setColor(NORMAL_COLOR)
            item._data = info[1]
            table.insert(self._items, item)
            y = y + cellHeight

        end

        self:setInnerContainerSize(cc.size(width, y))
    end
    function view:updateColor()
        local total = math.floor(((displayCnt * cellHeight) / 2 - self:getInnerContainerPosition().y) / cellHeight + 1)
        for _, item in ipairs(self._items) do
            item:setColor(NORMAL_COLOR)
        end
        self._items[total]:setColor(SELECT_COLOR)
    end
    function view:onUpdate()
        self:updateColor()
        if self._touching then return end

        local pos = self:getInnerContainerPosition()
        if self._innerY == pos.y then
            view._stopCnt = view._stopCnt + 1
            if view._stopCnt == STOP_FRAME then
                local yu = self._innerY % cellHeight
                if yu ~= 0 then
                    if yu < cellHeight / 2 then
                        self._innerY = self._innerY - yu
                    else
                        self._innerY = self._innerY - yu + cellHeight
                    end
                    pos.y = self._innerY
                    self:setInnerContainerPosition(pos)
                end
            end
        else
            self._innerY = pos.y
            view._stopCnt = 0
        end
    end

    function view:getSelect()
        local total = math.floor(((displayCnt * cellHeight) / 2 - self:getInnerContainerPosition().y) / cellHeight - 0.5)

        return  self._date[total+1]
    end

    function view:setSelect(idx)
        for _, item in ipairs(self._items) do
            if item._data == idx then
                local y = item:getPositionY()
                y = -y + cellHeight * 2
                local pos = self:getInnerContainerPosition()
                pos.y = y
                self:setInnerContainerPosition(pos)
                break
            end
        end
    end

    view:reloadData(self._hasOrderArea)
    return view
end


return MatchAreaView