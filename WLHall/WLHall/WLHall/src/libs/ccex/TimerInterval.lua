local M = {}

--[[
    * 描述：间隔时间型定时器
    * 参数target：table数据类型
    * 参数interval：间隔时间触发
    * 参数initTime：初始已经跑了时间，默认空为0秒
--]]
function M:addTimer(target, interval, initTime)
    assert(target.onTimerUpdate, "target必须实现onTimerUpdate方法")
    assert(interval)
    local elapseTime = initTime or 0
    self._timers[target] = { elapseTime = elapseTime, interval = interval }
end

function M:removeTimer(target)
    self._timers[target] = nil 
end

---------------------------- 接口分割线 ----------------------------

function M:onTimerUpdate(dt)
    for target,data in pairs(self._timers) do
        data.elapseTime = data.elapseTime + dt 
        if data.elapseTime > data.interval then
            if target and target.onTimerUpdate then
                target:onTimerUpdate(dt)
            end
            data.elapseTime = data.elapseTime - data.interval
        end
    end
end


function M:__init()
    assert(Timer, "Timer未被初始化")
    self._timers = {}

    Timer:addTimer(self)
end

M:__init()

return M