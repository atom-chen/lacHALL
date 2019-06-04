--[[
    * 描述：Flash动画，播放几次后自动消失
    * 参数repeatCount：播放次数
    * 参数binName：动画文件名
    * 参数scale：动画缩放大小，默认1.0
--]]
local M = class("libs.flash.FlashAnimateRepeat", function(repeatCount, binName, scale)
    return require("libs.flash.FlashAnimate").new(binName, scale)
end)

function M:ctor(repeatCount, binName, scale)
    self._currentCount = 0
    self._repeatCount = repeatCount
    
    Timer:addTimer(self)
    self:enableNodeEvents()
    self:registerMovieEventHandlers()
end

function M:onFlashAnimaeDidFinish()
    self._currentCount = self._currentCount + 1
    if self._currentCount >= self._repeatCount then 
        self:removeFromParent()
    end
end

function M:onUpdate(dt)
    self:time_update(dt)
end

function M:onCleanup()
    Timer:removeTimer(self)
end

return M