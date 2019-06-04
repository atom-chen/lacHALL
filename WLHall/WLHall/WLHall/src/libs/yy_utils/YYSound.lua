-- YYSoundLogic
local M = {}

local _loginSuccess = false --登录是否成功
local _recordSuccess = false --录音是否成功
local _curRecord = false --当前是否在录音
local _msgId = nil --消息发送给服务端id
local _curPlaying = false
local recordPath = cc.FileUtils:getInstance():getWritablePath().."self_record.amr"
local _curNickname = nil
local _uid = nil
local loginTimes = 0
local curIsToBackground = false

function M:initYYSDk()
	_curPlaying = false
	_curRecord = false
	curIsToBackground = false
	if yvcc==nil then
	    return
	end

	local yvsdk = yvcc.YVTool:getInstance()
	if not yvcc.YVTool:getInstance():isInitSDK() then
 		yvcc.YVTool:getInstance():initSDK(YY_APP_ID, cc.FileUtils:getInstance():getWritablePath(), false)
 	end
end

--[[
	* 描述：呀呀语音登录
	* 参数：nickname 玩家用户名
	* 参数：uid 玩家uid
--]]
function M:loginYYSDK(nickname, uid)
	if loginTimes== 3 then
		print("语音登录已经达到三次，不再重试登录")
		return
	end
	_curNickname = nickname or _curNickname
	_uid = uid or _uid
	assert(_curNickname, "呀呀登录必须传入用户名")
	assert(_uid, "呀呀登录必须传入用户ID")
	if nil==yvcc then
	    return
	end

	if not YYSDk_LOGIN_SUCCESS and yvcc.YVTool:getInstance():isInitSDK() then
		loginTimes = loginTimes + 1
		yvcc.YVTool:getInstance():cpLogin(_curNickname, _uid)
	end
end

--[[
	* 描述：呀呀语音注销登录
--]]
function M:logoutYYSDK()
	if _loginSuccess then
		yvcc.YVTool:getInstance():cpLogout()
		_loginSuccess = false
	end
	
	YYSDk_LOGIN_SUCCESS = false
	_loginSuccess = false --登录是否成功
 	_recordSuccess = false --录音是否成功
 	_curRecord = false --当前是否在录音
 	_msgId = nil --消息发送给服务端id
	_curPlaying = false
	_curNickname = nil
	_uid = nil
	loginTimes = 0
	curIsToBackground = false
end

--[[
	* 描述：开始录音
--]]
function M:startRecord()
	curIsToBackground = false
	if not _loginSuccess then
		-- GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "录音失败！请稍后再重试")
		-- print("----玩家未登录到YY语音"..tostring(_loginSuccess))
		return
	end

	if nil==GameClient then
		print("未获取到游戏信息")
		return
	end

	--房间号不可为空
	if nil==GameClient.roomkey then
		GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "当前房间不支持语音")
		return
	end
	
	M:stopPlay()
	if not _curRecord then
		gg.AudioManager:stopAllEffects()
		-- NotificationCenter:postNotification("onNotificationFriendPlaySoundFinsih")
		NotificationCenter:postNotification("onNotificationStopTalk")
		gg.AudioManager:pauseBackgroundMusic()
		_curRecord = true
		yvcc.YVTool:getInstance():startRecord(M:_createTempFilePath(), 0, GameClient.roomkey)
	end
end

--[[
	* 描述：录音完成
--]]
function M:compRecord()
	if not _loginSuccess then
		gg.AudioManager:resumeBackgroundMusic()
		return
	end
	_curRecord = false
	yvcc.YVTool:getInstance():stopRecord()
end

--[[
	* 描述：播放录音
	* 参数：url 播放URL地址
	* 参数：chair 视图座位号
--]]
function M:playRecord(url, chair)
	assert(url)
	if chair < 0 then
		assert(false,"chair 座位不对")
	end
	_curPlaying = true
	gg.AudioManager:stopAllEffects()
	NotificationCenter:postNotification("onNotificationStopTalk")
	gg.AudioManager:pauseBackgroundMusic()
	if chair == 0 and cc.FileUtils:getInstance():isFileExist(recordPath) then --自己的座位号
		if not curIsToBackground then
			yvcc.YVTool:getInstance():playRecord(recordPath, "", "")
		end
	else
		yvcc.YVTool:getInstance():playRecord("", url, "")
	end
	curIsToBackground = false
end

--[[
	* 描述：停止播放
--]]
function M:stopPlay()
	if not _loginSuccess then
		gg.AudioManager:resumeBackgroundMusic()
		return
	end
	-- if _curPlaying then
		yvcc.YVTool:getInstance():stopPlay()
	-- end
	_curPlaying = false
end

--[[
	* 描述：上传音频文件
--]]
function M:upLoadFile(path)
	assert(path)
	yvcc.YVTool:getInstance():upLoadFile(path, "");
end

--[[
	* 描述：下载音频文件
--]]
function M:downLoadFile(url, savePath)
	assert(url)
	assert(savePath)
	yvcc.YVTool:getInstance():downLoadFile(url, savePath, "")
end

function M:setLoginSuccess(success)
	assert(success==true or success==false)
	_loginSuccess = success
	loginTimes = 0
end

function M:getLoginSuccess()
	return _loginSuccess
end

function M:setRecordSuccess(success)
	assert(success==true or success==false)
	 if not success then
        gg.AudioManager:resumeBackgroundMusic()
    end
	_recordSuccess = success
end

function M:getRecordSuccess()
	return _recordSuccess
end

function M:setCurRecord(isRecord)
	_curRecord = isRecord
end

--[[
	* 描述：当前是否正在录音或者播放录音
--]]
function M:getCurRecordAndPlaying()
	if _curPlaying or _curRecord then
		return true
	end

	return false
end

function M:setPlaying( isPlay )
	_curPlaying = isPlay
end

--[[
	* 描述：当前是否有语音在播放
--]]
function M:isPlaying()
	return _curPlaying --yvcc.YVTool:getInstance():isPlaying()
end
--[[
	* 描述：跟服务器消息id
--]]
function M:setRecordMsgId(msgId)
	assert(msgId)
	_msgId = msgId
end

--[[
	* 描述：播放结束回调
--]]
function M:finishFunc()
	if not _curRecord then
		gg.AudioManager:resumeBackgroundMusic()
	end
end

--发送音频url到服务端
function M:sendRecord(url, recordTime)
-- BreakPoint()
	assert(_msgId, "请先设置msgId")
	assert(url)
	assert(recordTime)
	if not GameClient then
		return
	end

	local msg = CLuaMsgHeader.New()
	msg.id = _msgId
	msg:WriteInt(recordTime)
	msg:WriteByte(string.len(url))
	for i=1,string.len(url) do
 		msg:WriteByte(string.byte(url, i))
	end
	GameClient:SendData(msg)
end

--当前是否进入过后台
function M:setCurBackground()
	curIsToBackground = true
end

function M:getCurBackground()
	return curIsToBackground
end

--移除自己的短语
function M:removeSelfSound()
	if cc.FileUtils:getInstance():isFileExist(recordPath) then
        cc.FileUtils:getInstance():removeFile(recordPath)
    end
end
---------------------------------------------------------------------------------


--生成保存文件的路径和文件名
function M:_createTempFilePath()
    M:removeSelfSound()
    return recordPath
    
end


--清空缓存数据
function M:removeCache()
	local path = cc.FileUtils:getInstance():getWritablePath().."/yunva_audio/"
	if cc.FileUtils:getInstance():isDirectoryExist(path) then
		cc.FileUtils:getInstance():removeDirectory(path)
		cc.FileUtils:getInstance():createDirectory(path)
	end
end

return M