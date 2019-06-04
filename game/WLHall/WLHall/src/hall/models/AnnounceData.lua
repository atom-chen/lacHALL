--
-- Author: lee
-- Date: 2016-09-10 16:42:06
-- Describe:公告数据

local AnnounceData = {}

local localCfgFile = require("common.FileTable").New();

-- 本地配置路径变量
local cachePath = Helper.GetCachePath()
local localConfigPath = cachePath.."announce.tmp"

-- 读取本地缓存公告
local announceData = localCfgFile:Open(localConfigPath)

-- 刷新本地存储
local function flush_()
	localCfgFile:Save(announceData,localConfigPath)
end

-- 排序（同状态按照ID排序,不同状态未读优先）
local sortList = function (a,b)
	local bo = nil
	local read = a.status ~= b.status
	if read then
		bo = a.status < b.status
	else
		bo = checkint(a.id) > checkint(b.id)
	end
	return bo
end

-- 删除指定 ID 的公告消息
local RemoveIDs = { 253, 256 }
local function deleteSpecifiedIDs()
    -- 遍历所有玩家数据
    local isChanged = false
    for k, v in pairs(announceData) do
        for i=#v, 1, -1 do
            local data = v[i]
            if Table:isValueExist(RemoveIDs, checkint(data.id)) then
                data.isDelete = true
                table.remove(v, i)	-- 删除该条数据的本地缓存
                announceData[k] = v
                isChanged = true
            end
        end
    end

    -- 写文件
    if isChanged then
        flush_()
    end
end

deleteSpecifiedIDs()

--[[
* @brief 插入数据
* @parm id ID
* @parm title 标题
* @parm body 内容
* @parm time 发布时间
* @parm status 状态 0：未读取,1：已读取
]]
function AnnounceData:InsertData(id,title,body,time,status)
    if Table:isValueExist(RemoveIDs, checkint(id)) then
        -- 是需要删除的 id，不进行处理
        return
    end

    local userID = gg.UserData:GetUserId()
    if userID == 0 then
        return
    end
    local md5id=Helper.Md5(userID)
    local userData = checktable(announceData[md5id])
	for i, data in ipairs(userData) do
		if checkint(data.id) == checkint(id) then
			-- table.remove(announceData,i)
			-- break
			return
		end
	end
	table.insert(userData,{id=id,title=title,body=body,time=time,status=status})
	table.sort(userData,sortList)
    announceData[md5id] = userData
	flush_()
end

--[[
* @brief 删除数据
* @parm id ID
]]
function AnnounceData:DeleteData(id)
    local userID = gg.UserData:GetUserId()
    if userID == 0 then
        return
    end
    local md5id=Helper.Md5(userID)
    local userData = checktable(announceData[md5id])
	for i,data in ipairs(userData) do
		if checkint(data.id) == checkint(id) then
			data.isDelete = true
			table.remove(userData,i)	-- 删除该条数据的本地缓存
			table.sort(userData,sortList)
            announceData[md5id] = userData
			flush_()
			return
		end
	end
end

--[[
* @brief 获取所有数据
]]
function AnnounceData:GetAllData()
    local userID = gg.UserData:GetUserId()
    if userID == 0 then
        return {}
    end
    local md5id=Helper.Md5(userID)
    return checktable(announceData[md5id])
end

--[[
* @brief 获取数据数量
]]
function AnnounceData:GetLen()
    local userData = self:GetAllData()
	return #userData
end

--[[
* @brief 获取已读公告数量
]]
function AnnounceData:getHaveReadNum()
	local num = 0
    local userData = self:GetAllData()
	for i,v in ipairs(userData) do

		-- 如果不存在v.isDelete字段生成,默认false
		if not v.isDelete then
			v.isDelete = false
		end

		if v.status == 1 and v.isDelete == false then
			num = num+1
		end
	end
	return num
end

--[[
* @brief 获取未读公告数
]]
function AnnounceData:getNotReadNum()
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

--[[
* @brief 刷新数据指定字段
* @parm field 字段名
* @parm value 新值
]]
function AnnounceData:UpdataData(id,field,value)
    if not id then
        return
    end

    local userID = gg.UserData:GetUserId()
    if userID == 0 then
        return
    end
    local md5id=Helper.Md5(userID)
    local userData = checktable(announceData[md5id])
    for i,data in ipairs(userData) do
        if checkint(data.id) == checkint(id) then
            data[field] = value
            table.sort(userData, sortList)
            announceData[md5id] = userData
            flush_()
            break
        end
    end

	for i,v in ipairs(userData) do
		print("$$:"..i..":"..v.status..","..v.id)
	end
end

--[[
* @brief 获取数据通过ID
* @parm id ID
]]
function AnnounceData:GetDataById(id)
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

--[[
* @brief 获取最后一条数据
]]
function AnnounceData:getLastId()
	local lastId = 0
    local userData = self:GetAllData()
	for i,data in ipairs(userData) do
		lastId = math.max( checkint(data.id),lastId)
	end
	return lastId
end

--[[
* @brief 刷新本地数据
]]
function AnnounceData:Flush()
	return flush_()
end

--[[
* @brief 拉取数据
]]
function AnnounceData:pullData(onpullcallback)
	-- 拉取数据回调
	local callback = function(x)
		x = checktable(x)
		for i,v in pairs( checktable(x.list)) do
			v.status = 0
			self:InsertData(v.id,v.title,v.body,v.time,v.status)
		end
        gg.UserData:UpdateWebDate("notice",0)
        GameApp:dispatchEvent(gg.Event.HALL_UPDATE_NOTICE_UNREAD_COUNT)
		if onpullcallback then
			onpullcallback(x)
		end
	end
	-- 如果有数据拉取数据
	gg.Dapi:NoticeList(self:getLastId(), callback)
end

return AnnounceData
