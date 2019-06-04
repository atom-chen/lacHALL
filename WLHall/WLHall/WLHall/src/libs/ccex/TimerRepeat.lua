local M = {}

--[[
    * 描述：间隔时间型定时器，重复几次后自动断开定时器
    * 参数target：table数据类型
    * 参数interval：间隔时间触发
    * 参数repeatCount：重复次数
--]]
function M:addTimer(target, interval, repeatCount)
    assert(target.onTimerUpdate, "target必须实现onTimerUpdate(currentRepeat)方法")
    assert(interval and repeatCount)
    self._timers[target] = { elapseTime = 0, interval = interval, 
                             currentRepeat = 0, repeatCount = repeatCount }
end

function M:removeTimer(target)
    self._timers[target] = nil 
end

---------------------------- 接口分割线 ----------------------------

function M:onTimerUpdate(dt)
    for target,data in pairs(self._timers) do
        data.elapseTime = data.elapseTime + dt 
        if data.elapseTime > data.interval then 
            self:_timeAction(target, data)
        end
    end
end

function M:_timeAction(target, data)
    data.elapseTime = data.elapseTime - data.interval

    data.currentRepeat = data.currentRepeat + 1
    target:onTimerUpdate(data.currentRepeat)
    if data.currentRepeat >= data.repeatCount then 
        self._timers[target] = nil 
    end
end

function M:__init()
    assert(Timer, "Timer未被初始化")
    self._timers = {}

    Timer:addTimer(self)
end

M:__init()

return M