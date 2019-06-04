--[[
    * 描述：按指定顺序播放
    * 参数：plistPath：碎图纹理plist路径
    * 参数：sequeue：指定序列组，如"0,0,1,1,2,2,2"，第一二帧播放两次，第三帧播放3次
    * 参数：repeatTimes：重复次数
]]
local M = class("libs.widget.SpriteAnimateSequeue", cc.Node)

function M:ctor(plistPath, sequeue, repeatTimes)
    assert(plistPath)
    assert("string" == type(sequeue))
    
    self._removeSelf = true 
    self._sequeueArray = String:split(sequeue, ",")
    self._repeatTimes = repeatTimes and repeatTimes or 1

    self._animateSpirte = SpriteAnimate:create(plistPath)
                            :addTo(self)
    
    local size = self._animateSpirte:getContentSize()
    self:setContentSize(size)
    self._animateSpirte:setPosition(cc.p(size.width/2, size.height/2))
    self:setAnchorPoint(cc.p(0.5, 0.5))

    self:_resetData()
    self:_startAnimate()
end

--[[
    * 描述：设置动画结束回调
--]]
function M:setFinishCallback(callback)
    self._finishCallfun = callback
    return self
end

--[[
    * 描述：设置动画帧率
    * 参数：frameRate默认为1.0/24.0
--]]
function M:setFrameRate(frameRate)
    self._frameRate = frameRate
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

function M:_resetData()
    self._curRepeatTimes = 1
    self._curSequeueIndex = 1
    self._frameRate = 1.0 / 24.0
    self._elapsedTime = 0
end

function M:_startAnimate()
    self:_playFrame()
    Timer:addTimer(self)
    self:enableNodeEvents()
end

function M:onCleanup()
    self:_stopAnimate()
end

function M:onTimerUpdate(dt)
    self._elapsedTime = self._elapsedTime + dt
    if self._elapsedTime > self._frameRate then
        self._elapsedTime = self._elapsedTime - self._frameRate
        self:_playNextAction()
    end
end

function M:_playNextAction()
    self._curSequeueIndex = self._curSequeueIndex + 1

    -- 是否结束
    if self:_isFinish() then
        self:_finishDone()
        return        
    end

    -- 是否下一个循环
    if self:_isRoopDone() then
        self:_nextRoop()
        return
    end

    -- 播放下一帧
    self:_playFrame()
end

function M:_isFinish()
    return self._curSequeueIndex>#self._sequeueArray 
            and self._curRepeatTimes>=self._repeatTimes
end

function M:_finishDone()
    if self._finishCallfun then
        self._finishCallfun(self)
    end 

    if self._removeSelf then
        self:removeFromParent() 
    end
end

function M:_isRoopDone()
    return self._curSequeueIndex>#self._sequeueArray 
end

function M:_nextRoop()
    self._curSequeueIndex = 1 
    self._curRepeatTimes = self._curRepeatTimes + 1
    self:_playFrame()
end

function M:_playFrame()
    local index = self._sequeueArray[self._curSequeueIndex]
    self._animateSpirte:playFrame(index)
end

function M:_stopAnimate()
    Timer:removeTimer(self)
end

return M 

