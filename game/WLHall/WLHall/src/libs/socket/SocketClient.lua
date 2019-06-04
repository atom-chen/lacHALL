local _prot_encode = require("libs.socket.prot_encode")
local _rpc_core = require("rpc.core")	-- C语言注册函数
local _observers = require("libs.socket.SocketClientObserver")
local M = {}

M.connect = _rpc_core.connect
M.disconnect = _rpc_core.disconnect

local function _onStatus(cmd, errorMsg, key)
	_observers.postMessage(cmd, {message=errorMsg}, key)
end

local function _codeError(errorMsg)
	_onStatus("StatusParseCmdError", errorMsg)
end 

local function _onMessage(cmd, data, key)
	local info = _prot_encode.decode(cmd, data)
	if info then 
		_observers.postMessage(cmd, info, key)
		return
	end 

	_codeError(string.format("can't decode=%s",cmd))
end

_rpc_core.callback(_onMessage, _onStatus)

function M.send(cmd, data, key)
	local code = _prot_encode.encode(cmd, data)
	if code then
		_rpc_core.send(cmd, code, key)
		return
	end

	_codeError(string.format("encode error=%s", cmd))
end 

-- obs需要实现回调函数onSocketClientDidCallback(cmd, msgTable, key)
function M.addObserver(obs)	
	_observers.addObserver(obs)
end

function M.removeObserver(obs)
	_observers.removeObserver(obs)
end

return M
