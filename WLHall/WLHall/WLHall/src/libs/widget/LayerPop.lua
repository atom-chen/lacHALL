local M = class("libs.widget.LayerPop", cc.Layer)

--[[
    * 描述：弹出框，点击非rect区域内，关闭窗口
    * 参数：rect该范围内不会关闭窗口
    * 使用方法：继承：local M = class("CustomLayer", LayerPop)
--]]
function M:setPopVisibleRect(rect)
    assert(rect)
    self._boundingBox = rect
    Touch:registerTouchOneByOne(self, true)
end

function M:popAnimate()
    self:setScale(0.6)
    Action:newSequence()
        :scaleTo(0.1, 1.1)
        :scaleTo(0.08, 1)
        :run(self)
end

--------------------------- 华丽分割线 ---------------------------

function M:_isInTouch(touch)
    if self._boundingBox==nil then
        return false
    end

    local point = touch:getLocation()
    if cc.rectContainsPoint(self._boundingBox, point) then
        return true 
    end
    return false
end

function M:onTouchBegan(touch, event)
    self._isMoved = false
    return true
end

function M:onTouchMoved(touch, event)
    self._isMoved = true
end

function M:onTouchEnded(touch, event)
    if self._isMoved then
        return
    end

    if not self:_isInTouch(touch) then
        self:removeFromParent()
    end
end

function M:onTouchCancelled(touch, event)
    self:onTouchEnded(touch, event)
end

return M