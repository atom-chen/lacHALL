--[[
    * 描述：Flash动画无限循环播放  
    * 参数binName：动画文件名
    * 参数scale：动画缩放大小，默认1.0
--]]
local M = class("libs.flash.FlashAnimateRepeat", function(binName, scale)
    return require("libs.flash.FlashAnimate").new(binName, scale)
end)

function M:ctor(binName, scale)
    Timer:addTimer(self)
    self:enableNodeEvents()
end

function M:onUpdate(dt)
    self:time_update(dt)
end

function M:onCleanup()
    Timer:removeTimer(self)
end

return M