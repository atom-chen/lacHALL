local M = class("libs.widget.EffectFadeOutNode", cc.Node)

--[[
    * 描述：创建具有扩散效果的精灵动画，通常用于游戏开始，升级等
    * 参数：fileName精灵文件地址
--]]
function M:ctor(fileName)
    assert(fileName)
    self._sourceFileName 	= fileName
    self._fadeFileName 		= fileName

    self._fadeOutDuration 	= 1.4
    self._fadeOutCount 		= 3
    self._fadeOutInterval 	= 0.2

    self._fadeOutToScale 	= 2
    self._fadeOutToScaleInterval = 0.3
end

--[[
    * 描述：开始播放动画
--]]
function M:startAnimation()
	for i=1,self._fadeOutCount do
		local fadeOutSprite = cc.Sprite:create(self._fadeFileName )
	        :addTo(self)
        
        local offsetDuration = (self._fadeOutCount - i) * self._fadeOutInterval
        local duration = self._fadeOutDuration - offsetDuration

        local scale = self._fadeOutToScale - (i-1)*self._fadeOutToScaleInterval

	    local action = Action:newSpawn()
	        :scaleTo(duration, scale)
	        :fadeOut(duration)
	        :toAction()
	    Action:newEaseExponentialOut()
	        :addAction(action)
	        :run(fadeOutSprite)
	end

    local sprite = cc.Sprite:create(self._sourceFileName)
        :addTo(self)
        :scale(0.3)
    Action:newSequence()
        :scaleTo(0.2, 1.2)
        :scaleTo(0.1, 1)
        :run(sprite)

   	Action:newSequence()
   		:delayTime(self._fadeOutDuration-0.2)
   		:callFunc(function()
   		    if self._callback then
   		        self._callback(self)
   		    end
   		    self:removeFromParent()
   		end)
   		:run(self)

   	return self 
end

--[[
    * 描述：设置动画结束回调 
--]]
function M:setAnimateFinishCallback(callback)
    self._callback = callback
    return self 
end

--[[
    * 描述：设置动画扩散效果的背景图，默认为创建精灵的文件
--]]
function M:setFadeOutFileName(fadeOutFileName)
    assert(fadeOutFileName)
    self._fadeFileName = fadeOutFileName
    return self 
end

--[[
    * 描述：设置扩散的层次，默认3层
--]]
function M:setFadeOutCount(count)
    assert(count)
    self._fadeOutCount = count
    return self 
end

--[[
    * 描述：设置扩散的间隔，默认0.2
--]]
function M:setFadeOutInterval(interval)
	assert(interval)
    self._fadeOutInterval = interval
    return self
end

--[[
    * 描述：设置动画总时间，默认1
--]]
function M:setFadeOutDuration(duration)
	assert(duration)
    self._fadeOutDuration = duration
    return self 
end

--[[
    * 描述：设置扩散放大倍数
--]]
function M:setFadeOutToScale(scale)
    assert(scale)
    self._fadeOutToScale = scale
    return self 
end

--[[
    * 描述：设置扩散间隔放大倍数，类似波纹，第二个比第一个小多少
--]]
function M:setFadeOutToScaleInterval(interval)
	assert(interval)
	self._fadeOutToScaleInterval = interval
	return self 
end

return M
