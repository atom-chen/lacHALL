--[[
    * 描述：精灵无限循环播放类
    * 参数plistPath：碎图纹理plist路径
]]
local M = class("libs.widget.SpriteAnimateRepeatForver", cc.Node)

function M:ctor(plistPath)
    assert(plistPath)
    self._animateSpirte = SpriteAnimate:create(plistPath)
                            :addTo(self)
    
    local size = self._animateSpirte:getContentSize()
    self:setContentSize(size)
    self._animateSpirte:setPosition(cc.p(size.width/2, size.height/2))

    self:_startAnimate()
    self:setAnchorPoint(cc.p(0.5, 0.5))
end

function M:setFrameRate(frameRate)
    self._animateSpirte:setFrameRate(frameRate)
end

--------------------------- 华丽分割线 ---------------------------

function M:_startAnimate()
    Timer:addTimer(self)

    self:enableNodeEvents()
end

function M:onCleanup()
    self:_stopAnimate()
end

function M:onTimerUpdate(dt)
    self._animateSpirte:update(dt)
end

function M:_stopAnimate()
    Timer:removeTimer(self)
end

return M 

