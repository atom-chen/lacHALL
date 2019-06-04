local M = {}
local _observers = {}
setmetatable(_observers, {__mode="kv"})

function M.addObserver(obs)
	assert(obs.onSocketClientDidCallback, "请实现onSocketClientDidCallback成员函数")
	_observers[obs] = true
end

function M.removeObserver(obs)
	_observers[obs] = nil
end

function M.postMessage(cmd, msgTable, key)	
	for obs, _ in pairs(_observers) do
		if obs.onSocketClientDidCallback then 
			obs:onSocketClientDidCallback(cmd, msgTable, key)
		end  
	end
end

return M 
