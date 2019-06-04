
local SpriteAnimate2 = import(".SpriteAnimate2")
local M = class("libs.widget.SpriteAnimateRepeat2", SpriteAnimate2)

--[[
    * 描述：精灵播放类
    * 参数：imagePaths图片完整路径集合
    * 参数：repeatCount播放repeatCount次后自动删除
]]
function M:ctor(imageNames, repeatCount)
    assert(imageNames and repeatCount)
    assert(SpriteAnimate2._onPlayNextFrame, "重载函数不存在")
    SpriteAnimate2.ctor(self, imageNames)

    self._removeSelf = true 
    self._currentCount = 0
    self._repeatCount = repeatCount
    self:_startAnimate()
end

--[[
    * 描述：设置动画完成后自动删除，默认true 
--]]
function M:setRemoveSelfWhenFinish(isRemove)
    self._removeSelf = isRemove
    return self
end

--------------------------- 华丽分割线 ---------------------------

function M:_onPlayNextFrame()
    local isFinish = self._currentIndex > self._currentAnimateCount and true or false 
    self._currentIndex = isFinish and 1 or self._currentIndex
    self:playFrame(self._currentIndex)    

    if isFinish then
        self._finishDone(self)
    end
end

function M:_finishDone()
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
    self:update(dt)
end

function M:onCleanup()
    self:_stopAnimate()
end

function M:_stopAnimate()
    Timer:removeTimer(self)
end

return M 

