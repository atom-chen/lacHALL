local FriendCreateData = {}

local localCfgFile = require("common.FileTable").New()

-- 本地配置路径变量
local cachePath = Helper.GetCachePath()
local localConfigPath = cachePath.."friendcreate.tmp"

-- 读取本地缓存公告
local friendcreateData = localCfgFile:Open(localConfigPath)

-- 刷新本地存储
local function flush_()
	localCfgFile:Save(friendcreateData,localConfigPath)
end

--[[
* @brief 获取所有数据
]]
function FriendCreateData:GetAllData()
	return friendcreateData
end

--[[
* @brief 将规则数据写入本地
* @parm shortname 游戏短名
* @parm ruleTb 规则选择位置表
* @parm chatTb 语音聊天,GPS,代开
]]
function FriendCreateData:WriteRuleToLocal( shortname, ruleTb, btnIdxTb, chatTb, players )
	-- 遍历数据,如果已经存在该游戏的数据直接替换
	for i,v in ipairs(friendcreateData) do
		if v.shortname == shortname then
			v.ruleTb = ruleTb
			v.btnIdxTb = btnIdxTb
			v.chatTb = chatTb
			v.players = players
			flush_()
			return
		end
	end
	table.insert( friendcreateData, { shortname=shortname, ruleTb=ruleTb, btnIdxTb=btnIdxTb, chatTb=chatTb, players=players } )
	flush_()
end

-- 删除游戏的本地缓存
function FriendCreateData:RemoveRuleTableByName( shortname )
	for i,v in ipairs(friendcreateData) do
		if v.shortname == shortname then
			table.remove(friendcreateData, i)
			flush_()
		end
	end
end

-- 获取游戏规则记录表
function FriendCreateData:GetRuleTableByName( shortname )
	for i,v in ipairs(friendcreateData) do
		if v.shortname == shortname then
			return v.ruleTb
		end
	end
end

-- 获取按钮选中位置记录表
function FriendCreateData:GetBtnIndexTableByName( shortname )
	for i,v in ipairs(friendcreateData) do
		if v.shortname == shortname then
			return v.btnIdxTb
		end
	end
end

-- 获取语音,GPS,代开记录表
function FriendCreateData:GetChatTableByName( shortname )
	for i,v in ipairs(friendcreateData) do
		if v.shortname == shortname then
			return v.chatTb
		end
	end
end

-- 几人房
function FriendCreateData:GetPlayersByName( shortname )
	for i,v in ipairs(friendcreateData) do
		if v.shortname == shortname then
			return v.players
		end
	end
end

--[[
* @brief 刷新本地数据
]]
function FriendCreateData:Flush( )
	return flush_()
end

return FriendCreateData