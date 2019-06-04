if not json then
    require "cocos.cocos2d.json"
end

local M = class("libs.hot-updater.HotUpdater")
local kResourceVersion = "resource_version"
local function _getStartDownloadVersion(currentVersion, lastVersion) 
	local curBigV = string.match(currentVersion, "[^.]+")
	local lastBigV = string.match(lastVersion, "[^.]+")
	if lastBigV == curBigV then 
		return currentVersion
	end 
	return lastBigV .. ".0" 
end

local function _getStartVersionIndex(list, version) 
	local listCount = #list 
	for i = 1, listCount do 
		if list[i]["version"] == version then 
			return i 
		end 
	end 

	return 0 
end

local function _deleteDownloadResource()
	local resPath = cc.FileUtils:getInstance():getWritablePath() .. "Resources/"
    cc.FileUtils:getInstance():removeDirectory(resPath)
end

local function _getDownloadList(list)
	local currentVersion = cc.UserDefault:getInstance():getStringForKey(kResourceVersion)
	currentVersion = #currentVersion > 0 and currentVersion or "1.0" 
	
	local lastVersion = list[#list]["version"] 
	if lastVersion == currentVersion then 
		return {}
	end 

	-- 本地版本>服务器版本，则重置为1.0版本，删除本地下载资源，应用于客户端更新版本
	if String:compareVersion(currentVersion, lastVersion, ".") == 1 then 
		print(string.format("提醒：本地记录版本(%s)>服务器资源列表的最高版本(%s)，请检查版本是否正确，已帮您重置为1.0版本了", 
				currentVersion, lastVersion))
		cc.UserDefault:getInstance():setStringForKey(kResourceVersion, "1.0")
		cc.UserDefault:getInstance():flush()

		_deleteDownloadResource()
		currentVersion = "1.0"
	end

	-- 跨版本，从最高版本的初始版本开始下载，比如客户端版本1.1，服务端版本有1.0、1.1、1.2、2.0、2.1
	-- 则下载2.0、2.1
	local startVersion = _getStartDownloadVersion(currentVersion, lastVersion) 
	local index = _getStartVersionIndex(list, startVersion) 
	local nextIndex = (startVersion == currentVersion) and index + 1 or index 
	
	local downloadList = {}
	for i = nextIndex, #list do 
		table.insert(downloadList, list[i]) 
	end

	return downloadList
end

local function _pathJoin(path1, path2) 
	if string.find(path1, "/$") then 
		return path1 .. path2 
	end 
	return path1 .. "/" .. path2 
end

local function _download(downloadList, successFun, failedFun, progressFun, idx) 
	local info = downloadList[idx] 
	local downloadUrl = info["url"]
	local downloadVersion = info["version"]
	assert(downloadUrl and downloadVersion)
	
	local writePath = cc.FileUtils:getInstance():getWritablePath()
	local assetsManager = cc.AssetsManager:new(downloadUrl, downloadVersion, writePath) 
	if info["remove"] == true then 
		local resourcePath = _pathJoin(writePath, "Resources/") 
		assetsManager:setNeedRemovePath(resourcePath) 
	end 

	assetsManager:setDelegate(function(percent) 
		progressFun(percent)
	end, cc.ASSETSMANAGER_PROTOCOL_PROGRESS) 
	
	assetsManager:setDelegate(function(code)
		failedFun(code)
		assetsManager:release() 
	end, cc.ASSETSMANAGER_PROTOCOL_ERROR)

	assetsManager:setDelegate(function()
		cc.UserDefault:getInstance():setStringForKey(kResourceVersion, downloadVersion) 
		cc.UserDefault:getInstance():flush()
		successFun(idx, #downloadList)

		if idx < #downloadList then 
			_download(downloadList, successFun, failedFun, progressFun, idx + 1)
		end 
		assetsManager:release()
	end, cc.ASSETSMANAGER_PROTOCOL_SUCCESS) 

	assetsManager:setConnectionTimeout(30)
	assetsManager:update()
	assetsManager:retain() 
end

------------------------- 以下是接口函数 -------------------------

--[[
	* 描述：检测是否有新资源需要下载
	* 参数versionListUrl：请求验证配置表url地址
	* 参数successFun(downloadList)：验证成功回调函数, downloadList需要下载的资源列表
	* 参数failedFun(errorCode)：验证失败回调函数

	* 备注：需要注册C接口network.http
]]
function M:check(versionListUrl, successFun, failedFun) 
	assert(versionListUrl and successFun and failedFun)

	network.http.get({
		url = versionListUrl, 
	}, function(info, result)
		if result ~= "finish" then 
			local const_version_list_failed = 1
			failedFun(const_version_list_failed)
			return
		end

		local list = json.decode(info.data) 
		if #list == 0 then 
			local const_decode_version_list_failed = 2
			failedFun(const_decode_version_list_failed)
			return 
		end 

		local downloadList = _getDownloadList(list)
		successFun(downloadList)
	end)
end

--[[
	* 描述：按执行下载资源文件
	* 参数downloadList：由check函数成功返回
	* 参数successFun(currentIndex, allIndex)：下载成功返回
	* 参数failedFun(errorCode)：下载失败
	* 参数progressFun(percent)：下载进行中
]]
function M:downloadPackage(downloadList, successFun, failedFun, progressFun)
	assert(downloadList and successFun and failedFun and progressFun)

	_download(downloadList, successFun, failedFun, progressFun, 1) 
end

--[[
	* 描述：返回需要下载资源文件的大小
]]
function M:getPackageSizeKB(downloadList)
	if #downloadList==0 then 
		return 0
	end
	
	local size = 0
	for _,dic in pairs(downloadList) do
		size = size + dic["size_kb"]
	end
	return size
end

return M 


