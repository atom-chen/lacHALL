local M = {}

--[[
    * 描述：延迟回调定时器
    * 参数delayTime：延迟时间
    * 参数callFun：回调函数
--]]
function M:addTimer(target, delayTime, callFun)
    assert(target and delayTime and callFun)
    self._timers[target] = { elapseTime = 0, delayTime = delayTime, callFun = callFun }
end

function M:removeTimer(target)
    self._timers[target] = nil 
end

---------------------------- 接口分割线 ----------------------------

function M:onTimerUpdate(dt)
    for target,data in pairs(self._timers) do
        data.elapseTime = data.elapseTime + dt 
        if data.elapseTime > data.delayTime then 
            self._timers[target] = nil
            data.callFun(target)
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