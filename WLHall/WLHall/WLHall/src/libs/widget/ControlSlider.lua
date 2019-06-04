local M = class("libs.widget.ControlSlider", function(backgroundImage, progressImage, thumbImage)
	return cc.ControlSlider:create(backgroundImage, progressImage, thumbImage)
end)

--[[
    * 描述：拖拉进度条控件
    * 参数backgroundImage：背景图片
    * 参数progressImage：进度图片
    * 参数thumbImage：拖拉图片
    * 回调事件：.onValueChanged(sender, currentValue)
    * 默认回调值为：0-1
--]]
function M:ctor(backgroundImage, progressImage, thumbImage)
    self._currentValue = 0
    self:registerControlEventHandler(function(sender)
        if self.onValueChanged then 
            local curValue = sender:getValue()
            if self._currentValue == curValue then 
                return
            end
            
            self._currentValue = curValue
            self.onValueChanged(sender, self._currentValue)
        end
    end, cc.CONTROL_EVENTTYPE_VALUE_CHANGED)
    self:enableNodeEvents()
    self:setMaximumValue(1)
end

function M:setSwallowTouches(swallow)
    Touch:removeTouchOneByOne(self)
    Touch:registerTouchOneByOne(self, swallow)
end

function M:onTouchBegan(touch, event)
    local isHitted = Touch:isTouchHitted(self, touch)
    if isHitted then
        self:_setValue(touch)
    end
    return isHitted
end

function M:onTouchMoved(touch, event)
    self:_setValue(touch)
end

function M:_setValue(touch)
    local visible = self:isVisible()
    if not visible then
        return
    end
    local touchLocation = touch:getLocation()
    local x, y = self:getPosition()
    local contentSize = self:getContentSize()
    local maxValue = self:getMaximumValue()
    local minValue = self:getMinimumValue()
    local percentage = (touchLocation.x - (x - contentSize.width / 2)) / contentSize.width
    if percentage < 0 then
        percentage = 0
    elseif percentage > 1 then
        percentage = 1
    end
    local value = percentage * (maxValue - minValue) + minValue
    self:setValue(value)
    if self.onValueChanged then
        self.onValueChanged(self, value)
    end
end

return M

