-- 封装 Agora SDK 相关的接口以及回调
-- Author : ZhangBin
-- Added Date: 2017-11-03

local M = {}

local hasInited = false
local nativeVersion = nil
local nativeNoAgora = nil

local channelName = nil
local userid = nil

function M:isNativeSupportAgora()
    if device.platform ~= "ios" and device.platform ~= "android" then
        -- 只有 iOS 和 Android 支持视频
        return false
    end

    if nativeVersion < 2 or nativeNoAgora then
        print("Native Client can not support agora!")
        return false
    end
    return true
end

-- 初始化
function M:initAgora()
    -- 只做一次初始化
    if hasInited then
        return
    end
    hasInited = true

    print("---- do agora init")
    nativeVersion = gg.GetNativeVersion()
    nativeNoAgora = gg.GetNativeCfg("no_agora", false)
    if not self:isNativeSupportAgora() then
        return
    end

    -- 注册各种事件回调
    Agora.setCallback("onJoinChannelSuccess", handler(self, self._onJoinChannelSuccess))
    Agora.setCallback("onFirstRemoteVideoDecoded", handler(self, self._onFirstRemoteVideoDecoded))
    Agora.setCallback("onLeaveChannel", handler(self, self._onLeaveChannel))
    Agora.setCallback("onUserOffline", handler(self, self._onUserOffline))
    Agora.setCallback("onUserEnableVideo", handler(self, self._onUserEnableVideo))
    Agora.setCallback("onUserMuteVideo", handler(self, self._onUserMuteVideo))
    Agora.setCallback("onRequestChannelKey", handler(self, self._onRequestChannelKey))
    Agora.setCallback("onError", handler(self, self._onError))

    Agora.setCallback("onUserJoined", handler(self, self._onUserJoined ))
    Agora.setCallback("onAudioRouteChanged", handler(self, self._onAudioRouteChanged ))
    Agora.setCallback("onRemoteVideoStats", handler(self, self._onRemoteVideoStats ))
    Agora.setCallback("onLocalVideoStats", handler(self, self._onLocalVideoStats ))
    Agora.setCallback("onFirstRemoteVideoFrame", handler(self, self._onFirstRemoteVideoFrame ))
    Agora.setCallback("onFirstLocalVideoFrame", handler(self, self._onFirstLocalVideoFrame ))
    Agora.setCallback("onVideoSizeChanged", handler(self, self._onVideoSizeChanged ))
    Agora.setCallback("onCameraReady", handler(self, self._onCameraReady ))
    Agora.setCallback("onVideoStopped", handler(self, self._onVideoStopped ))

    Agora.setParameters("{\"che.audio.mixable.option\":true,\"che.audio.keep.audiosession\": true}")
end

-- 加入实时视频/音频房间
function M:joinChannel(roomid, deskid, uid, video_enabled)
    if not self:isNativeSupportAgora() then
        return
    end

    if type(uid) == "number" and math.floor(uid) == uid then
        local channel = tostring(roomid) .. "-" .. tostring(deskid)
        local support_video = false
        if video_enabled then
            support_video = true
        end

        gg.Dapi:GetAgoraChannelKey(BRAND==1 and "weile" or "jixiang", channel, uid, function(result)
            local channelKey = checktable(result).data
            if not channelKey or type(channelKey) ~= "string" then
                return
            end

            -- 20 表示 VIDEOPROFILE_240P，200kbps
            Agora:joinChannelByKey(channelKey, channel, uid, support_video, 20, channel)
            if not support_video then
                -- 语音聊天模式需要手动切换到播放器播放
                Agora:setDefaultAudioRouteToSpeakerphone(true)
            end
        end)
    else
        print("非法 uid " .. tostring(uid) .. " 必须传入整数")
    end
end

-- 离开房间
function M:leaveChannel()
    if not self:isNativeSupportAgora() then
        return
    end

    Agora:leaveChannel()
end

-- 切换摄像头
function M:switchCamera()
    if not self:isNativeSupportAgora() then
        return
    end

    Agora.switchCamera()
end

function M:setSpriteSize(width, height)
    if not self:isNativeSupportAgora() then
        return
    end

    Agora.setSize(width, height)
end

-- 获取自己的视频头像
function M:getLocalSprite()
    if not self:isNativeSupportAgora() then
        return nil
    end

    return Agora.getLocalSprite()
end

-- 获取房间其他人的视频头像
function M:getRemoteSprite(uid)
    if not self:isNativeSupportAgora() then
        return nil
    end

    return Agora.getRemoteSprite(uid)
end

--[[
*@brief 关闭/开启某个玩家的语音
*@param uid 用户ID
*@param mute true表示关闭，false表示开启
]]
function M:muteRemoteAudio(uid, mute)
    if not self:isNativeSupportAgora() then
        return -1
    end

    return Agora.muteRemoteAudioStream(uid, mute)
end

--[[
*@brief 关闭/开启所有其他玩家的语音
*@param mute true表示关闭，false表示开启
]]
function M:muteAllRemoteAudio(mute)
    if not self:isNativeSupportAgora() then
        return -1
    end

    return Agora.muteAllRemoteAudio(mute)
end

--[[
*@brief 关闭/开启某个玩家的视频
*@param uid 用户ID
*@param mute true表示关闭，false表示开启
]]
function M:muteRemoteVideo(uid, mute)
    if not self:isNativeSupportAgora() then
        return -1
    end

    return Agora.muteRemoteVideoStream(uid, mute)
end

--[[
*@brief 关闭/开启所有其他玩家的视频
*@param mute true表示关闭，false表示开启
]]
function M:muteAllRemoteVideo(mute)
    if not self:isNativeSupportAgora() then
        return -1
    end

    return Agora.muteAllRemoteVideoStreams(mute)
end

--[[
*@brief 关闭/开启自己的语音
*@param mute true表示关闭，false表示开启
]]
function M:muteLocalAudio(mute)
    if not self:isNativeSupportAgora() then
        return -1
    end

    return Agora.muteLocalAudio(mute)
end

--[[
*@brief 关闭/开启自己的视频
*@param mute true表示关闭，false表示开启
]]
function M:muteLocalVideo(mute)
    if not self:isNativeSupportAgora() then
        return -1
    end

    return Agora.muteLocalVideoStream(mute)
end

function M:_onJoinChannelSuccess(channel, uid, elapsed)
    print("Agora onJoinChannelSuccess ChannelID:" .. channel .. " ,uid:" .. uid)
    channelName = channel
    userid = uid
    GameApp:dispatchEvent(gg.Event.AGORA_JOIN_CHANNEL_SUCCESS, channel, uid, elapsed)
end

function M:_onFirstRemoteVideoDecoded(uid, width, height, elapsed)
    print("Agora onFirstRemoteVideoDecoded uid:" .. uid)
    GameApp:dispatchEvent(gg.Event.AGORA_FIRST_REMOTE_VIDEO_DECODED, uid, width, height, elapsed)
end

function M:_onLeaveChannel(stats)
    print("Agora onLeaveChannel Success")
    channelName = nil
    userid = nil
    GameApp:dispatchEvent(gg.Event.AGORA_LEAVE_CHANNEL, stats)
end

function M:_onUserOffline(uid, reason)
    print("Agora onUserOffline uid:" .. uid .. " reason: " .. tostring(reason))
    GameApp:dispatchEvent(gg.Event.AGORA_USER_OFFLINE, uid, reason)
end

function M:_onUserEnableVideo(uid, enabled)
    print("Agora onUserEnableVideo uid:" .. uid .. " enabled: " .. tostring(enabled))
    GameApp:dispatchEvent(gg.Event.AGORA_USER_ENABLE_VIDEO, uid, enabled)
end

function M:_onUserMuteVideo(uid, enabled)
    print("Agora onUserMuteVideo uid:" .. uid .. " enabled: " .. tostring(enabled))
    GameApp:dispatchEvent(gg.Event.AGORA_USER_MUTE_VIDEO, uid, enabled)
end

function M:_onRequestChannelKey()
    print("Agora onRequestChannelKey")

    if channelName and userid then
        -- ChannelKey 到期，重新申请一个
        gg.Dapi:GetAgoraChannelKey(BRAND==1 and "weile" or "jixiang", channelName, userid, function(result)
            local channelKey = checktable(result).data
            if not channelKey or type(channelKey) ~= "string" then
                return
            end

            Agora.renewChannelKey(channelKey)
        end)
    end
end

function M:_onError(errCode, msg)
    printf("Agora onError errCode: %s, msg: %s ", tostring(errCode), tostring(msg))
    GameApp:dispatchEvent(gg.Event.AGORA_ERROR, errCode, msg)
end

function M:_onUserJoined(uid, elapsed)
    printf("Agora Event user_joined uid : %s, elapsed : %s", tostring(uid), tostring(elapsed))
    GameApp:dispatchEvent(gg.Event.AGORA_USER_JOINED, uid, elapsed)
end

function M:_onAudioRouteChanged(routing)
    printf("Agora Event audio_route_changed routing :"..routing)
    GameApp:dispatchEvent(gg.Event.AGORA_AUDIO_ROUTE_CHANGED, routing)
end

function M:_onRemoteVideoStats(stats)
    printf("Agora Event remote_video_stats")
    GameApp:dispatchEvent(gg.Event.AGORA_REMOTE_VIDEO_STATS, stats)
end

function M:_onLocalVideoStats(stats)
    printf("Agora Event local_video_stats")
    GameApp:dispatchEvent(gg.Event.AGORA_LOCAL_VIDEO_STATS, stats)
end

function M:_onFirstRemoteVideoFrame(uid, width, height, elapsed)
    printf("Agora Event first_remote_video_frame uid : %s, width : %s, height: %s, elapsed: %s", tostring(uid), tostring(width), tostring(height), tostring(elapsed))
    GameApp:dispatchEvent(gg.Event.AGORA_FIRST_REMOTE_VIDEO_FRAME, uid, width, height, elapsed)
end

function M:_onFirstLocalVideoFrame(width, height, elapsed)
    printf("Agora Event first_local_video_frame width : %s, height: %s, elapsed: %s", tostring(width), tostring(height), tostring(elapsed))
    GameApp:dispatchEvent(gg.Event.AGORA_FIRST_LOCAL_VIDEO_FRAME, width, height, elapsed)
end

function M:_onVideoSizeChanged(uid, width, height, rotation)
    printf("Agora Event video_size_changed uid : %s, width : %s, height: %s, rotation: %s", tostring(uid), tostring(width), tostring(height), tostring(rotation))
    GameApp:dispatchEvent(gg.Event.AGORA_VIDEO_SIZE_CHANGED, uid, width, height, rotation)
end

function M:_onCameraReady()
    printf("Agora Event camera_ready")
    GameApp:dispatchEvent(gg.Event.AGORA_CAMERA_READY)
end

function M:_onVideoStopped()
    printf("Agora Event video_stopped")
    GameApp:dispatchEvent(gg.Event.AGORA_VIDEO_STOPPED)
end

return M
