local protobuf = require("libs.socket.protobuf")

local M = {}
local registers = {}

local function loadProtoBufData(cmd)
	local path = string.format("res/protocol/%s.pb", cmd)
    return ccex.loadData(path)
end

local function register_protobuf(cmd, info, key)
	if not registers[cmd] then
		local data = loadProtoBufData(cmd)
		if #data > 0 then
			protobuf.register(data)
			registers[cmd] = true
		end
	end
end

function M.encode(cmd, info)
	register_protobuf(cmd)
	if registers[cmd] then 
		local encodeCmd = cmd .. "_request"
		return protobuf.encode(encodeCmd, info)
	end  
end

function M.decode(cmd, info)
	register_protobuf(cmd)
	if registers[cmd] then 
		local decodeCmd = cmd
		return protobuf.decode(decodeCmd, info)
	end 
end

return M
