local YYSound = require("src.libs.yy_utils.YYSound")

YYSDk_LOGIN_SUCCESS = false
--cp登录返回
function cpLoginCallBack(result, msg, name, iconUrl , thirdUserId , thirdUserName ,uid )
    if 0~=result then
        YYSound:loginYYSDK()
    else
        YYSound:setLoginSuccess(true)
        yvcc.YVTool:getInstance():setRecord(30, true)
        YYSDk_LOGIN_SUCCESS = true       
    end
end

---录音返回 
function gLuaRecordCallBack(time, strfilepath, ext, result)
    if result~= 0 then
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "录音失败")
        NotificationCenter:postNotification("onNotificationFriendRecordSoundFail")
        return
    end

    if time<1000 then
        print("录音失败 ---time ="..time)
        NotificationCenter:postNotification("onNotificationFriendRecordSoundFail")
        return
    end


    if nil==GameClient then
        print("为获取到游戏信息，拒绝上传第三方sdk")
        NotificationCenter:postNotification("onNotificationFriendRecordSoundFail")
        return
    end

    if nil==GameClient.roomkey then
         print("获取不到房间号，拒绝上传第三方sdk")
         NotificationCenter:postNotification("onNotificationFriendRecordSoundFail")
        return
    end

    if ext~=GameClient.roomkey then
        print("开始录音和结束房间号不对，拒绝上传第三方sdk")
        NotificationCenter:postNotification("onNotificationFriendRecordSoundFail")
        return
    end

    if YYSound:getRecordSuccess() and not YYSound:getCurBackground() then --录音成功才上传语音
        NotificationCenter:postNotification("onNotificationFriendPlaySelfSound", math.ceil(time/1000))
        yvcc.YVTool:getInstance():upLoadFile(strfilepath, tostring(time).."/"..ext)
    end
end


----识别返回
-- function gLuaSpeechCallBack(ext, url, result)
--     yvcc.YVTool:getInstance():playRecord(LocalVoiceFilePath,url)
-- end

--播放语音结束回调
function  gLuaFinishPlayCallBack(result, describe, ext)
    if result ~=0 then
         GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "播放失败")
        print("录音播放失败")     
    end
    print("gLuaFinishPlayCallBack--语音播放结束"..ext)
    YYSound:setPlaying(false)
    -- gg.AudioManager:resumeBackgroundMusic()
    NotificationCenter:postNotification("onNotificationFriendPlaySoundFinsih")
    YYSound:finishFunc()
end

--语音上传文件回调
function  gLuaUpLoadFileCallBack(result, msg, fileid, fileurl, percent)
    if result ~= 0 then
        print("---音频上传失败")
        return
    end
    local strTab = lua_string_split(fileid, "/")

    if nil==GameClient then
        print("为获取到游戏信息，拒绝上传服务器")
        return
    end

    if nil==GameClient.roomkey then
         print("获取不到房间号，拒绝上传服务器")
        return
    end

    if strTab[2]~=GameClient.roomkey then
        print("房间号错误，拒绝上传服务器")
        return
    end

    YYSound:sendRecord(fileurl, math.ceil(strTab[1]/1000))
end

function  gLuaDownLoadFileCallBack(result, msg, filename, fileid ,percent)
    if result ~= 0 then
        NotificationCenter:postNotification("onNotificationFriendPlaySoundFinsih")
    end
   
    yvcc.YVTool:getInstance():playRecord(filename, "", "")
    -- print("gLuaDownLoadFileCallBack")
end

function  gLuaNetWorkStateCallBack(state)
    
    -- print("gLuaNetWorkStateCallBack-----"..state)
end


function  gLuaRecordVoiceCallBack(ext, volume)
    
    -- print("gLuaRecordVoiceCallBack..")
end

--字符串分割
function lua_string_split(str, split_char)
    local sub_str_tab = {}
    while (true) do
        local pos = string.find(str, split_char)
        if (not pos) then
            sub_str_tab[#sub_str_tab + 1] = str
            break
        end
        local sub_str = string.sub(str, 1, pos - 1)
        sub_str_tab[#sub_str_tab + 1] = sub_str
        str = string.sub(str, pos + 1, #str)
    end

    return sub_str_tab;
end