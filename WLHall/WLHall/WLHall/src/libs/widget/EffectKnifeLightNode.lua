local M = class("libs.widget.EffectKnifeLightNode", cc.Node)

--[[
    * 描述：创建具有刀光效果的Node
    * 参数：textImagePath文字图片路径
    * 参数：lightImagePath刀光文件路径
--]]
function M:ctor(textImagePath, lightImagePath)
	assert(textImagePath)
	assert(lightImagePath)
    local sprite = cc.Sprite:create(textImagePath)
    local size = sprite:getContentSize()
    self:setContentSize(size)

    local clipNode = cc.ClippingNode:create(sprite)
        :addTo(self)
    clipNode:setAlphaThreshold(0.5)
    clipNode:addChild(sprite)

    self._lightSprite = cc.Sprite:create(lightImagePath)
    clipNode:addChild(self._lightSprite)
    
    self._duration = 3
    self._delayTime = 0.3
end

--[[
    * 描述：开始播放刀光动画
--]]
function M:startAnimation()
	local contentSize = self:getContentSize()
	local size = self._lightSprite:getContentSize()
	local halfLen = (contentSize.width + size.width)/2
	self._lightSprite:setPosition(cc.p(-halfLen, 0))

    Action:newSequence()
        :moveTo(self._duration, cc.p(halfLen, 0))
        :delayTime(self._delayTime)
        :callFunc(function()
            self:startAnimation()
        end)
        :run(self._lightSprite)
end

--[[
    * 描述：动画时间，默认3秒
--]]
function M:setDuration(duration)
	assert(duration)
    self._duration = duration
    return self 
end

--[[
    * 描述：动画完延迟多长时间在接着播放
--]]
function M:setDelayTime(delayTime)
    assert(delayTime)
    self._delayTime = delayTime
    return self 
end

return M 

