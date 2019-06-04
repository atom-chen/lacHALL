--[[
    * 描述：Flash动画播放基础类
    * 参数binName：动画文件名
    * 参数scale：动画缩放大小，默认1.0
--]]
local M = class("libs.flash.FlashAnimate", function(binName, scale)
    scale = scale and scale or 1.0
    local collection = fla.ex.getCollection(binName)
    local definition = collection:rootDefinition()
    return fla.TimeMovieNode:createWithDefinition(definition, scale)
end)


--[[
    * 描述：注册回调通知，包括开始动画、动画结束、动画跳到下一帧
    * 回调：onFlashAnimaeStart、onFlashAnimaeFinish、onFlashAnimaeStep
--]]
function M:registerMovieEventHandlers()
    local eventNames = {
        start  = "onFlashAnimaeDidStart",
        finish = "onFlashAnimaeDidFinish",
        step   = "onFlashAnimaeDidStep",
    }

    for event, name in pairs(eventNames) do 
        self:handleMovieEvent(event, function()
            if self[name] then
                self[name](self)
            end
        end)
    end
end

return M