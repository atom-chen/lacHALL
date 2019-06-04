
local SpriteAnimate2 = import(".SpriteAnimate2")
local M = class("libs.widget.SpriteAnimateRepeatForver2", SpriteAnimate2)

--[[
    * 描述：精灵播放类
    * 参数：imagePaths图片完整路径集合
]]
function M:ctor(imageNames)
    assert(imageNames)
    SpriteAnimate2.ctor(self, imageNames)

    self:_startAnimate()
end

--------------------------- 华丽分割线 ---------------------------

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

