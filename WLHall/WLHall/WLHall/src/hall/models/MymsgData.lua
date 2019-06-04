--
-- Author: lee
-- Date: 2016-09-10 16:42:06
-- Describe:玩家消息数据

local MymsgData = {}

local localCfgFile = require("common.FileTable").New();

-- 本地配置路径变量
local cachePath = Helper.GetCachePath()
local localConfigPath = cachePath.."mymsg.tmp"

-- 读取本地缓存消息
local mymsgData = localCfgFile:Open(localConfigPath)

-- 刷新本地存储
local function flush_()
	localCfgFile:Save(mymsgData,localConfigPath)
end

-- 排序（同状态按照ID排序,不同状态未读优先）
local sortList = function (a,b)
	local bo = nil
	local read = a.status ~= b.status
	if read then
		bo = a.status < b.status
	else
		bo = a.id > b.id
	end
	return bo
end

-- 插入数据
function MymsgData:InsertData(newData)
    local userID = gg.UserData:GetUserId()
    if userID == 0 or not newData then
        return
    end
    local md5id=Helper.Md5(userID)
    local userData = checktable(mymsgData[md5id])
	for i,data in ipairs(userData) do
		if checkint(data.id) == checkint(newData.id) then
			-- table.remove(mymsgData,i)
			-- break
			return
		end
	end
	table.insert(userData, newData)
	table.sort(userData,sortList)
    mymsgData[md5id] = userData
	flush_()
end

-- 删除数据
function MymsgData:DeleteData(id)
    local userID = gg.UserData:GetUserId()
    if userID == 0 then
        return
    end
    local md5id=Helper.Md5(userID)
    local userData = checktable(mymsgData[md5id])
	for i,data in ipairs(userData) do
		if checkint(data.id) == checkint(id) then
			data.isDelete = true
			table.remove(userData,i)	-- 删除该条数据的本地缓存
			table.sort(userData,sortList)
            mymsgData[md5id] = userData
			flush_()
			return
		end
	end

end

-- 获取所有数据
function MymsgData:GetAllData()
	local userID = gg.UserData:GetUserId()
    if userID == 0 then
        return {}
    end
    local md5id=Helper.Md5(userID)
    return checktable(mymsgData[md5id])
end

-- 获取数据数量
function MymsgData:GetLen()
	local userData = self:GetAllData()
	return #userData
end

-- 获取已读消息数量
function MymsgData:getHaveReadNum()
	local num = 0
	local userData = self:GetAllData()
	for i,v in ipairs(userData) do

		-- 如果不存在v.isDelete字段生成,默认false
		if not v.isDelete then
			v.isDelete = false
		end

		if v.status == 1 and v.isDelete == false  then
			num = num + 1
		end
	end
	return num
end

-- 获取未读消息数量
function MymsgData:getNotReadNum()
	local num = 0
	local userData = self:GetAllData()
	for i,v in ipairs(userData) do

		-- 如果不存在v.isDelete字段生成,默认false
		if not v.isDelete then
			v.isDelete = false
		end

		if v.status == 0 and v.isDelete == false then
			num = num+1
		end
	end
	return num
end

-- 刷新指定字段数据
function MymsgData:UpdataData(id,field,value)
    if not id then
        return
    end

    local userID = gg.UserData:GetUserId()
    if userID == 0 then
        return
    end
    local md5id=Helper.Md5(userID)
    local userData = checktable(mymsgData[md5id])
    for i,data in ipairs(userData) do
        if checkint(data.id) == checkint(id) then
            data[field] = value
            table.sort(userData, sortList)
            mymsgData[md5id] = userData
            flush_()
            break
        end
    end

	for i,v in ipairs(userData) do
		print("$$:"..i..":"..v.status..","..v.id)
	end
end

-- 获取特定id数据
function MymsgData:GetDataById(id)
    if id then
        local userData = self:GetAllData()
		for i,data in ipairs(userData) do
			if checkint(data.id) == checkint(id) then
				return data
			end
		end
	end

    return nil
end

-- 刷新本地数据
function MymsgData:Flush()
	return flush_()
end

-- 获取最后一条数据
function MymsgData:getLastId()
	local lastId = 0
    local userData = self:GetAllData()
	for i,data in ipairs(userData) do
		lastId = math.max( checkint(data.id),lastId)
	end
	return lastId
end

--[[
* @brief 拉取数据
]]
function MymsgData:pullData(onpullcallback)
	-- 拉取数据回调
	local callback = function(x)
		x = checktable(x)
		for i,v in pairs( checktable(x.list)) do
			v.status = 0
			self:InsertData(v)
		end
        gg.UserData:UpdateWebDate("usermsg",0)
        GameApp:dispatchEvent(gg.Event.HALL_UPDATE_NOTICE_UNREAD_COUNT)
		if onpullcallback then
			onpullcallback(x)
		end
	end
	-- 如果有数据拉取数据
	gg.Dapi:MsgList(self:getLastId(), callback)
end

return MymsgData
