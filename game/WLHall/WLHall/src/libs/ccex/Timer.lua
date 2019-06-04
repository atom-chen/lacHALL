local M = {}

function M:addTimer(target)
    assert(target.onTimerUpdate, "target必须实现onTimerUpdate方法")
    self._timers[target] = true 
end

function M:removeTimer(target)
    self._timers[target] = nil 
end

---------------------------- 接口分割线 ----------------------------

function M:_onTimer(dt)
    for timer,_ in pairs(self._timers) do
        timer:onTimerUpdate(dt)
    end
end

function M:__unload()
    if self._timerHandler then 
        self._timers = {}
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._timerHandler)
        self._timerHandler = nil 
    end
end

function M:__init()
    if self._timerHandler then 
        return
    end

    self._timers = {}
    setmetatable(self._timers, {__mode="kv"})
    self._timerHandler = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function(dt)
            self:_onTimer(dt)
        end, 1.0/42.0, false)
end

M:__init()

return M