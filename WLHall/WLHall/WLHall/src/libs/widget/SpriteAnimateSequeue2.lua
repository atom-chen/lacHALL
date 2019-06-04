
local SpriteAnimate2 = import(".SpriteAnimate2")
local M = class("libs.widget.SpriteAnimateSequeue2", SpriteAnimate2)

--[[
    * 描述：按指定顺序播放
    * 参数：imagePaths图片完整路径集合
    * 参数：sequeue：指定序列组，如"1,1,2,2,2"，第一二帧播放两次，第三帧播放3次
           序列帧从1开始起算
    * 参数：repeatTimes：重复次数
]]
function M:ctor(imagePaths, sequeue, repeatTimes)
    assert(imagePaths)
    assert(SpriteAnimate2._onPlayNextFrame, "重载函数不存在")
    assert("string" == type(sequeue))
    SpriteAnimate2.ctor(self, imagePaths)
    
    self._removeSelf = true 
    self._frameRate = 1.0 / 24.0
    self._curRepeatTimes = 1
    self._curSequeueIndex = 1
    self._elapsedTime = 0

    self._sequeueArray = {}
    local sequeue = String:split(sequeue, ",")
    for i,seq in ipairs(sequeue) do
        self._sequeueArray[i] = tonumber(seq)
    end

    self._repeatTimes = repeatTimes and repeatTimes or 1

    self:_playFrame()
    Timer:addTimer(self)
    self:enableNodeEvents()
end

--[[
    * 描述：设置动画完成后自动删除，默认true 
--]]
function M:setRemoveSelfWhenFinish(isRemove)
    self._removeSelf = isRemove
    return self
end

--------------------------- 华丽分割线 ---------------------------

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
    self:playFrame(index)
end

function M:_stopAnimate()
    Timer:removeTimer(self)
end

return M 

