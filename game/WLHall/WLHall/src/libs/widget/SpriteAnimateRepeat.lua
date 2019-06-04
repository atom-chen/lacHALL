--[[
    * 描述：精灵播放类
    * 参数：plistPath碎图纹理plist路径
    * 参数：repeatCount播放repeatCount次后自动删除
]]
local SpriteAnimate = import(".SpriteAnimate")
local M = class("libs.widget.SpriteAnimateRepeat", cc.Node)

function M:ctor(plistPath, repeatCount)
    assert(plistPath and repeatCount)
    self._animateSpirte = SpriteAnimate:create(plistPath)
                            :addTo(self)
    self._animateSpirte:setFinishCallback(function()
        self:_onFinishCallback()
    end)

    local size = self._animateSpirte:getContentSize()
    self:setContentSize(size)
    self._animateSpirte:setPosition(cc.p(size.width/2, size.height/2))
    self:setAnchorPoint(cc.p(0.5, 0.5))

    self._removeSelf = true 
    self._currentCount = 0
    self._repeatCount = repeatCount
    self:_startAnimate()
end

function M:playFrame(index)
    assert(index)
    self._animateSpirte:playFrame(index)
    return self
end

function M:setFrameRate(frameRate)
    self._animateSpirte:setFrameRate(frameRate)
    return self 
end

function M:setFinishCallback(callback)
    self._finishCallfun = callback
    return self
end

--[[
    * 描述：设置动画完成后自动删除，默认true 
--]]
function M:setRemoveSelfWhenFinish(isRemove)
    self._removeSelf = isRemove
    return self
end

--------------------------- 华丽分割线 ---------------------------

function M:_onFinishCallback()
    self._currentCount = self._currentCount + 1
    if self._currentCount >= self._repeatCount then 
        self:_stopAnimate()

        if self._finishCallfun then
            self._finishCallfun(self)
        end

        if self._removeSelf then
            self:removeFromParent()     
        end
    end
end

function M:_startAnimate()
    Timer:addTimer(self)
    self:enableNodeEvents()
end

function M:onTimerUpdate(dt)
    self._animateSpirte:update(dt)
end

function M:onCleanup()
    self:_stopAnimate()
end

function M:_stopAnimate()
    Timer:removeTimer(self)
end

return M 

