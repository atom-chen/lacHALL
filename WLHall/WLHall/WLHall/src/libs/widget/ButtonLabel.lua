--[[
    * 描述：纯文字的按钮
    * 点击事件：onClicked(button)
--]]
local M = class("libs.widget.ButtonLabel", function()
    return cc.Node:create()
end)

local m_fontName    = "STHeitiSC-Medium"
local m_textColor   = cc.c4b(255, 255, 255, 255)
local m_strokeColor = cc.c4b(0, 0, 0, 255)
local m_strokeSize  = 3

function M:ctor(string, fontSize)
    local label = cc.Label:create()
    label:setSystemFontName(m_fontName)
    label:setTextColor(m_textColor)
    label:enableOutline(m_strokeColor, m_strokeSize)
    label:setHorizontalAlignment(1)
    label:setSystemFontSize(fontSize)
    self:addChild(label)
    self._label = label
    self:setString(string)

    self:setAnchorPoint(cc.p(0.5, 0.5))
    Touch:registerTouchOneByOne(self, true)
    self._isHighlighted = false
    self._enable = true 
end 

function M:setEnable(enable)
    self._enable = enable
end

function M:setString(text)
    self._label:setString(text)
    self:_layout()
end

function M:setSystemFontSize(size)
    self._label:setSystemFontSize(size)
    self:_layout()
end

function M:setTextColor(color4b)
    self._label:setTextColor(color4b)
end

function M:setStrokeColor(color4b, size)
    assert(color4b and size)
    self._label:enableOutline(color4b, size)
end

function M:setUnderLineColor(color4b)
    if not self._drawNode then 
        self._drawNodeColor = cc.c4f(color4b.r/255, color4b.g/255, color4b.b/255, color4b.a/255)
        self._drawNode = cc.DrawNode:create()
        self:addChild(self._drawNode)
    end

    if nil == color4b then
        self._drawNode:clear()
        return
    end

    self:_layoutDrawLine()
end

--------------------------- 接口分割线 ---------------------------

function M:onTouchBegan(touch, event)
    if not self._enable then 
        return false
    end

    local isHit = Touch:isTouchHitted(self, touch)
    if isHit then
        self:_setHighlighted(true)
    end
    return isHit
end

function M:onTouchEnded(touch, event)
    local isHit = Touch:isTouchHitted(self, touch)
    self:_setHighlighted(false)
    if isHit and self.onClicked then
        self.onClicked(self)
    end
end

function M:onTouchMoved(touch, event)
    local isHit = Touch:isTouchHitted(self, touch)
    self:_setHighlighted(isHit) 
end

function M:onTouchCancelled(touch, event)
    self:onTouchEnded(touch, event)
end

function M:_setHighlighted(value)
    if self._isHighlighted == value then
        return
    end

    self._isHighlighted = value
    if self._isHighlighted then
        self:setScale(1.2)
    else
        self:setScale(1.0)
    end
end

function M:_layout()
    local size = self._label:getContentSize()
    self:setContentSize(size)

    self._label:setPosition(Point:centerBySize(size))
    self:_layoutDrawLine()
end

function M:_layoutDrawLine()
    if self._drawNode then 
        local size = self:getContentSize()
        self._drawNode:drawLine(cc.p(-size.width/2, 0), cc.p(size.width/2, 0), self._drawNodeColor)
        self._drawNode:setPosition(cc.p(size.width/2, size.height*0.1))
    end
end

return M
