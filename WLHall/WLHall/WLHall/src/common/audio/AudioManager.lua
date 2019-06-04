-- Author: zhaoxinyu
-- Date: 2016-11-02 16:37:29
-- Describe：声音管理器
local YYSound = require("src.libs.yy_utils.YYSound")

local AudioManager = {}

-- 点击音效资源路径
AudioManager.EFFECT_CLICK = "res/common/audio/button_click.mp3"

-- 游戏短名
local _ShortName = nil
local _effectMuted = false
local _musicMuted  = false

--[[
* @brief 初始化游戏Audio
* @parm shortname 游戏短名
]]
function AudioManager:initGameAudio(shortname)
    _ShortName = shortname
end

--[[
* @brief 初始化
]]
function AudioManager:init()
    ccexp.AudioEngine:setMaxAudioInstance(24)
    -- 音效预加载
    ccexp.AudioEngine:preloadEffect(AudioManager.EFFECT_CLICK, function(isSuccess)
        print("preload effect " .. AudioManager.EFFECT_CLICK .. gg.IIF(isSuccess, " success", " failed"))
    end)
end

--[[
* @brief 播放点击音效
]]
function AudioManager:playClickEffect()
    self:playEffect(AudioManager.EFFECT_CLICK)
end

--[[
*@brief 设置音效的静音状态
*@param value true为静音，false为取消静音
]]
function AudioManager:setEffectMuted(value)
    _effectMuted = value
end

--[[
*@brief 获取音效的静音状态
*@return true 表示音效静音，false 表示非静音
]]
function AudioManager:getEffectMuted()
    return _effectMuted
end

--[[
*@brief 设置背景音乐的静音状态
*@param value true为静音，false为取消静音
]]
function AudioManager:setMusicMuted(value)
    _musicMuted = value
end

--[[
*@brief 获取背景音乐的静音状态
*@return true 表示背景音乐静音，false 表示非静音
]]
function AudioManager:getMusicMuted()
    return _musicMuted
end

--[[
* @brief 判断是否可以播放音效
]]
function AudioManager:isCanPlayEffect()
    -- 如果音效被设置静音，那么直接返回
    if _effectMuted then
        return false
    end
    if YYSound:getCurRecordAndPlaying() then --在录音和播放的时候不进行播放音效 ---20170410 jita 1026339788@qq.com
        return false
    end
    -- 获取音效状态
    local settingManager = require("common.setting.SettingManager")
    if settingManager:GetMuteState() then
        return false
    end
    if not settingManager:GetEffectState() then
        return false
    end

    return true
end

--[[
* @brief 音效预加载（游戏调用）
* @parm effectList 音效列表
]]
function AudioManager:preloadEffect(effectList)

    -- 验证表
    if not checktable(effectList) then

        print("预加载音效必需是音效列表！")
        return
    end

    -- 遍历
    for k, v in pairs(effectList) do

        -- 验证文件是否存在
        if Helper.IsFileExist(v) then
            ccexp.AudioEngine:preloadEffect(v, function(isSuccess)
                print("preload effect " .. v .. gg.IIF(isSuccess, " success", " failed"))
            end)
        else
            print("AudioManager:preloadEffect 音效" .. v .. "文件不存在！")
        end
    end
end

--[[
* @brief 背景音乐预加载（游戏调用）
* @parm filename 背景音乐路径
]]
function AudioManager:preloadBackgroundMusic(filename)

    -- 验证文件是否存在
    if Helper.IsFileExist(filename) then
        ccexp.AudioEngine:preloadBackgroundMusic(filename, function(isSuccess)
            print("preload music " .. filename .. gg.IIF(isSuccess, " success", " failed"))
        end)
    else
        print("AudioManager:preloadBackgroundMusic 背景音乐" .. filename .. "文件不存在！")
    end
end

local backgroundMusicID = -1
local musicVolume = 1   --音乐音量的数值
local effectVolume = 1  --音效音量的数值

--[[
* @brief 播放背景音乐（游戏调用） 注：播放音乐开关不需要游戏考虑,无脑播放
* @parm shortname 游戏短名字
* @parm filename 背景音乐路径
]]
function AudioManager:playBackgroundMusic( filename , shortname )
    -- 如果背景音乐被设置静音，那么直接返回
    if _musicMuted then
        return
    end

    self:stopBackgroundMusic()

    print("AudioManager:playBackgroundMusic 打开背景音乐")
    -- 判断filename是否为空
    if not filename then
        print( "AudioManager:playBackgroundMusic filename nil " )
        return
    end

    -- 判断静音状态
    local settingManager = require("common.setting.SettingManager")
    if settingManager:GetMuteState() then
        print("静音状态无法播放背景音乐！")
        return
    end

    -- 验证文件是否存在
    if Helper.IsFileExist(filename) then
        -- 判断背景音乐是否是播放状态
        -- 判断游戏背景音乐开关状态
        if not settingManager:GetMusicState( shortname or "hall" ) then
            return
        end
        backgroundMusicID = ccexp.AudioEngine:playBackgroundMusic(filename, true)
        ccexp.AudioEngine:setVolume(backgroundMusicID,musicVolume)--设置音乐的值
    else
        print("AudioManager:playBackgroundMusic 背景音乐" .. filename .. "文件不存在！")
        assert( "filename文件不存在" )
    end
end

--[[
* @brief 播放音效（游戏调用）  注：播放音效开关不需要游戏考虑,无脑播放
* @parm filename 音效路径
]]
function AudioManager:playEffect( filename, loop )

    -- 判断音效文件是否存在
    if self:isCanPlayEffect() then
        if Helper.IsFileExist(filename) then
            ccexp.AudioEngine:preloadEffect(filename, function(isSuccess)
                if isSuccess then
                    if loop == nil then
                        loop = false
                    end
                    local playEffectID = ccexp.AudioEngine:playEffect(filename, loop)
                    ccexp.AudioEngine:setVolume(playEffectID,effectVolume)  --设置音效的值
                else
                    print("AudioManager:playEffect 音效" .. filename .. "加载失败")
                end
            end)
        else
            print("AudioManager:playEffect 音效" .. filename .. "文件不存在")
        end
    else
        -- print("音效开关处于关闭状态,或者静音已开启！")
    end
end

--[[
* @brief 停止播放背景音乐（游戏调用）
]]
function AudioManager:stopBackgroundMusic()
    print("AudioManager:stopBackgroundMusic 关闭背景音乐")
    if backgroundMusicID ~= -1 then
        ccexp.AudioEngine:stop(backgroundMusicID)
        backgroundMusicID = -1
    end
end

function AudioManager:stopAllEffects()
    print("AudioManager:stopAllEffects")
    ccexp.AudioEngine:stopAll(backgroundMusicID)
end

function AudioManager:pauseBackgroundMusic()
    print("AudioManager:pauseBackgroundMusic 暂停背景音乐")
    if backgroundMusicID ~= -1 then
        ccexp.AudioEngine:pause(backgroundMusicID)
    end
end

function AudioManager:resumeBackgroundMusic()
    print("AudioManager:resumeBackgroundMusic 恢复背景音乐")
    if backgroundMusicID ~= -1 then
        ccexp.AudioEngine:resume(backgroundMusicID)
    end
end

-- 设置音效音量
function AudioManager:setEffectVolume(effect)
    print("AudioManager:setEffectVolume 设置音效音量")
    if effectVolume == effect then
        return
    else
        effectVolume = effect
    end
end

-- 设置声音音量
function AudioManager:setMusicVolume(music)
    print("AudioManager:setMusicVolume 设置音乐音量")
    if musicVolume == music then
        return
    else
        musicVolume = music
    end

    if backgroundMusicID ~= -1 then
        ccexp.AudioEngine:setVolume(backgroundMusicID,music)
    end
end

return AudioManager