--[[
    * 描述：长按按钮
    * 点击事件：onClicked(button)
    * 长按事件：同上
--]]
local SuperClass = require("libs.widget.Button")
local M = class("libs.widget.ButtonLongPress", function(normalImageName)
    assert(nil==normalImageName, "请使用createWithFileName或createWithSpriteFrame替代.new")
    return cc.Node:create()
end)

function M:createWithFileName(normalImageName, highligtedImageName, disabledImageName)
    local buttonText = M.new()

    local button = require("libs.widget.Button"):createWithFileName(normalImageName, highligtedImageName, disabledImageName)
    buttonText:addChild(button)
    buttonText:_initContent(button)

    return buttonText
end

function M:createWithSpriteFrame(normalSpriteFrame, highlightdSpriteFrame, disableSpriteFrame)
    local buttonText = M.new()

    local button = require("libs.widget.Button"):createWithSpriteFrame(normalSpriteFrame, highlightdSpriteFrame, disableSpriteFrame)
    buttonText:addChild(button)
    buttonText:_initContent(button)

    return buttonText
end


--------------------- 接口分割线 ---------------------
function M:_initContent(button)
    local size = button:getContentSize()
    button:setPosition(cc.p(size.width/2, size.height/2))
    self:setContentSize(size)
    self:setAnchorPoint(cc.p(0.5,0.5))

    self:_registerEvent(button)
end

function M:_registerEvent(button)
    button:registerControlEventHandler(function()
        self:_beganTouch()
    end, cc.CONTROL_EVENTTYPE_TOUCH_DOWN)

    button:registerControlEventHandler(function()
        self:_cancelTouch()
    end, cc.CONTROL_EVENTTYPE_TOUCH_CANCEL)

    button:registerControlEventHandler(function()
        self:_cancelTouch()
    end, cc.CONTROL_EVENTTYPE_TOUCH_UP_OUTSIDE)

    button:registerControlEventHandler(function()
        self:_cancelTouch()
        self:_endTouch()
    end, cc.CONTROL_EVENTTYPE_TOUCH_UP_INSIDE)

    self:_reset()
end

function M:onTouchBegan(touch, event)
    if not self:isEnabled() then
        return false
    end
    SuperClass.onTouchBegan(self, touch, event)
    local isInside = Touch:isTouchHitted(self, touch, 0)
    if isInside then
        self:_beganTouch()
    end
    return isInside
end

function M:onTouchCancelled(touch, event)
    SuperClass.onTouchCancelled(self, touch, event)
    self:_cancelTouch()
end

function M:onTouchEnded(touch, event)
    SuperClass.onTouchEnded(self, touch, event)
    local isInside = Touch:isTouchHitted(self, touch, 0)
    self:_cancelTouch()
end

function M:_beganTouch()
    if not self._handle then
        self:_reset()
        Timer:addTimer(self)
        self._handle = true
    end
end

function M:_endTouch()
    if self._handle then
        return
    end
    if self.onClicked then
        self.onClicked(self)
    end
end

function M:_cancelTouch()
    if self._handle then
        Timer:removeTimer(self)
        self._handle = nil
    end
end

function M:_reset()
    self._currentTime = 0
    self._stepTime = 0
end

function M:onTimerUpdate(dt)
    self._currentTime = self._currentTime + dt + self._stepTime
    if self._currentTime > 0.5 then
        self._currentTime = 0
        self._stepTime = self._stepTime + 0.02

        if self.onClicked then
            self.onClicked(self)
        end
    end
end

return M


