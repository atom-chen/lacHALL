--游戏下载器
-- Author: lee
-- Date: 2017-04-02 19:10:00
local UpdateGamesInfo={}    -- 记录正在更新的游戏信息
local DownloadQueue={}      -- 下载队列
local GameDownloader={
	isdownloading_=false
}
GameDownloader.CANCEL=-1
GameDownloader.WATTING=0
GameDownloader.DOWNLOADING=1
GameDownloader.FINISH=2

local AssetDownloader =require("update.AssetDownloader")

-- https://client.{domain}/update/game/{AppID}/{渠道ID}/{游戏ID}/{客户端游戏版本号}
local function GET_GAME_UPDATE_URL( gameid,newver,curver )
    local region = gg.LocalConfig:GetRegionCode()
    region = gg.IIF(region ~= 0, region, REGION_CODE)
    local test = cc.exports.IS_TEST_SERVER and 1 or 0

    local a_id = "/" .. APP_ID
    local c_id = "/" .. CHANNEL_ID
    local  url = "://"..UPDATE_URL_PREFIX[1].."." .. WEB_DOMAIN .. "/update/game"..a_id..c_id.."/"..gameid.."/"..curver
    url = url .."/" .. gg.GetHallVerison() .."/"..gg.StringAppend(region,0,6).."/"..tostring(test)
    return url
end

local function PULL_MANIFEST_FILE_URL(url,func)
 	assert(func,"PULL_MANIFEST_FILE_URL nil err")
	gg.Http:Get(url,function(code,data)
		if code and checkint(code) ~= 200 then
			printf("PULL_MANIFEST_FILE_URL err: %s  %s",code,data)
			code = iif(checkint(code)==0,-1,code)
			func(nil, API_ERR_MSG[err] or "网络错误,请重试！" )
			return
		end
		local ok, datatable = pcall(function() return loadstring(data)(); end)
		if ok and checkint(datatable.status)==0 and datatable.url then
			func(datatable.url)
		else
			func(nil,datatable.msg or "更新失败,暂未开放")
			printf("PULL_MANIFEST_FILE_URL address url failed, %s ",json.encode(data))
		end
	end)
end

local function safecall_(callback,...)
	if callback then callback(...) return true	end
	return false
end

--开始下载
function GameDownloader:Start(shortname, upModules, statuscallback)
    safecall_(statuscallback, GameDownloader.WATTING, shortname)

    -- 游戏不是正在更新中，开始更新
    if not UpdateGamesInfo[shortname] then
        UpdateGamesInfo[shortname] = { modules = {}, statuscallbacks = {statuscallback}, state = GameDownloader.WATTING }
        for i, v in ipairs(upModules) do
            -- 遍历所有需要下载的模块，添加下载任务
            self:AddDownloadTask(v)
            table.insert( UpdateGamesInfo[shortname].modules, v.shortname )
        end
    elseif statuscallback then
        -- 记录状态回调函数
        local info = UpdateGamesInfo[shortname]
        info.statuscallbacks = checktable(info.statuscallbacks)
        if not Table:isValueExist(info.statuscallbacks, statuscallback) then
            table.insert(info.statuscallbacks, statuscallback)
        end
    end
    return true
end

function GameDownloader:Execute(task)
 	assert(task,"task params is nil error ")
	local url= task.url
	assert(url,"url params is nil error ")
	self.isdownloading_=true
    self:onTaskStatusUpdate(task.shortname, GameDownloader.DOWNLOADING)
	local down= AssetDownloader.new(url,function(err,cancontinue)
		self:onTaskFinished(task.shortname, err, DownloadQueue[1])
		table.remove(DownloadQueue,1)
		printf("%s 游戏下载完成,剩余  %d 个待下载游戏",tostring(task.shortname),#DownloadQueue)
		local t=DownloadQueue[1]
		if t then
			self:Execute(t)
		else
			printf(" 所有游戏下载完成")
			self.isdownloading_=false
		end
    end):Execute(url,task.serverver)
    down:AddProgressChangeListener(handler(self, self.onTaskProgressChanged))
    return self
end

-- 获取包含某个模块的游戏列表
function GameDownloader:getContainTaskGames(taskName)
    local ret = {}
    for k, v in pairs(UpdateGamesInfo) do
        for i, item in ipairs(v.modules) do
            if taskName == item then
                table.insert(ret, k)
            end
        end
    end

    return ret
end

--[[
*****************************************
Download Task 相关的内部函数
*****************************************
]]

-- 检查某个模块是否正在下载
function GameDownloader:IsDownloading(shortname)
    if shortname then
        return checktable(DownloadQueue[1]).shortname == shortname
    end
end

--是否在下载队列 不包括正在下载中
function GameDownloader:IsInDownloadQueue(shortname)
    if shortname then
        for i,v in ipairs(DownloadQueue) do
            if v.shortname == shortname then
                return true,i
            end
        end
    end
    return false
end

--获取正在下载的模块
function GameDownloader:GetDownloadingTask()
    return checktable(DownloadQueue[1]).shortname
end

--添加下载任务
function GameDownloader:AddDownloadTask(info)
    local shortname = info.shortname
    assert(shortname,"shortname nil err")

    local exist, idx = self:IsInDownloadQueue(shortname)
    if exist or self:IsDownloading(shortname) then
        -- 游戏已经在队列中或者正在下载，不需要再添加下载任务了
        return
    end

    local url = GET_GAME_UPDATE_URL( info.id, info.server_ver, info.client_ver)
    PULL_MANIFEST_FILE_URL(url, function(mani_url,err)
        local task={ url=mani_url, shortname=shortname, serverver=info.server_ver, clientver=info.client_ver }
        if not mani_url then
            self:onTaskFinished(shortname, err, task)
            return
        end
        if not (self:IsInDownloadQueue(task.shortname)) then
            table.insert(DownloadQueue,task)
        end
        if not self.isdownloading_ then
            self:Execute(DownloadQueue[1])
        end
    end)
end

-- 某个模块下载状态更新了
function GameDownloader:onTaskStatusUpdate(shortname, status)
    -- 获取相关的游戏列表
    local games = self:getContainTaskGames(shortname)
    for i, v in ipairs(games) do
        local info = UpdateGamesInfo[v]
        -- 通知相应的游戏状态变化了
        if not info.state or info.state ~= status then
            info.state = status
            local cbs = checktable(info.statuscallbacks)
            for i, cb in ipairs(cbs) do
                safecall_(cb, status, v)
            end
        end
    end
end

-- 某个模块下载进度变化了
function GameDownloader:onTaskProgressChanged(filesize, downloadsize, speed, percent)
    local shortname = self:GetDownloadingTask()
    if not shortname then
        return
    end

    -- 获取相关的游戏列表
    local games = self:getContainTaskGames(shortname)
    for i, v in ipairs(games) do
        local info = UpdateGamesInfo[v]
        local basePercent = checkint(info.finishCount) / (#(info.modules))
        local newPercent = basePercent * 100 + percent / (#(info.modules))
        -- 通知相应的游戏进度更新
        GameApp:dispatchEvent("event_game_update_progress_changed", newPercent, v)
        GameApp:dispatchEvent("event_game_update_progress_changed"..v, newPercent, v)
    end
end

-- 某个模块下载完成了
function GameDownloader:onTaskFinished(shortname, err, task)
    printf("Task Finish shortname: %s %s",tostring(shortname),tostring(err))
    self:clearModule(shortname)
    local games = self:getContainTaskGames(shortname)
    for i, v in ipairs(games) do
        local info = UpdateGamesInfo[v]
        if err then
            -- 下载出错了
            info.failedCount = checkint(info.failedCount) + 1
            info.errMsg = err
        else
            -- 下载正常完成了
            info.finishCount = checkint(info.finishCount) + 1
        end

        if checkint(info.failedCount) + checkint(info.finishCount) == #(info.modules) then
            -- 全部下载完成了
            local cbs = checktable(info.statuscallbacks)
            for i, cb in ipairs(cbs) do
                safecall_(cb, GameDownloader.FINISH, v, info.errMsg)
            end
            GameApp:dispatchEvent("event_game_update_finish", v, info.errMsg)

            -- 从下载游戏数据中清除游戏
            UpdateGamesInfo[v] = nil
        else
            -- 未全部下载完成，更新进度
            local percent = checkint(info.finishCount) / (#(info.modules)) * 100
            -- 通知相应的游戏进度更新
            GameApp:dispatchEvent("event_game_update_progress_changed", percent, v)
            GameApp:dispatchEvent("event_game_update_progress_changed"..v, percent, v)
        end
    end
end

-- 清除某个模块对应的内存
function GameDownloader:clearModule(moduleName)
    if not moduleName or moduleName == "" then
        return
    end

    local srcPath = gg.VersionHelper:getModuleSrcPath(moduleName)
    local clearPaths = {}
    if not srcPath then
        -- 没有对应的模块源码路径，应该是游戏，直接清除
        table.insert( clearPaths, moduleName )
    elseif type(srcPath)=="table" then
        -- 对应的源码路径是 table
        clearPaths = srcPath
    elseif type(srcPath)=="string" then
        -- 只有一个路径
        table.insert( clearPaths, srcPath )
    end

    if #clearPaths > 0 then
        for i, v in ipairs(clearPaths) do
            gg.ClearGameRequire(v)
        end
    end
end

-- 取消某个模块的下载
function GameDownloader:cancelTask(shortname)
    local exist,idx= self:IsInDownloadQueue(shortname)
    -- 正在下载的不能取消
    if exist and idx ~= 1 then
        table.remove(DownloadQueue,idx)
    end
    return exist,idx
end

-- 取消所有模块的下载
function GameDownloader:cancelAllTask()
    DownloadQueue[{}]=nil
    DownloadQueue={}
end

return GameDownloader
