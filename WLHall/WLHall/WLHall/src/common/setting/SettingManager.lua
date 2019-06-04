-- Author: zhaoxinyu
-- Date: 2016-11-18 17:01:20
-- Describe：设置管理者

local SettingManager = {}

local localCfgFile = require("common.FileTable").New();
local writablePath = cc.FileUtils:getInstance():getWritablePath()

-- 本地配置路径变量
local localConfigPath = writablePath .. "settingcfg.dat"
--
-- 读取本地缓存消息
local settingData = localCfgFile:Open(localConfigPath)

-- 功能标识
SettingManager.FUN_MARK = {
    MUSIC = 1,                  -- 音乐
    EFFECT = 2,                 -- 音效
    DIALECT = 3,                -- 方言语音
    CLICK_OUT_CARD = 4,         -- 单击出牌
    ENLARGECARD_OUT_CARD = 5,   -- 放大出牌
    MUTE = 6,                   -- 静音
    BET_TYPE = 7,               -- 加注方式
    CARD_BG_STYLE = 8,          -- 牌背面图案
    HALL_BG_STYLE = 9,          -- 大厅背景图案
}

--[[
* @brief 申请默认设置
* @parm id 标识（游戏使用短名）
]]
function SettingManager:ApplyDefaultSettings(id)
    if not id then return end

    -- 申请默认设置
    local setting = {}
    setting.id = id
    setting.music = true
    setting.dialect = true
    setting.djcp = false
    setting.fdcp = false
    setting.jzfs = 2    -- 加注方式
    setting.kpbj = 1    -- 卡牌背面图案
    setting.hlbj = 1    -- 大厅背面图案
    settingData[id] = setting

    self:flush()
end

--[[
* @brief 设置关闭音乐默认开启状态
* @parm id 标识
]]
function SettingManager:SetMusicDefClose( id )

    if not settingData[id] then
        self:ApplyDefaultSettings(id)
        settingData[id].music = false
        self:flush()
    end
end

--[[
* @brief 设置音乐开启状态
* @parm id 标识
]]
function SettingManager:SetMusicState(id, isOn)

    if not settingData[id] then
        self:ApplyDefaultSettings(id)
    end

    settingData[id].music = isOn

    self:flush()
end

--[[
* @brief 设置音效状态（全局）
]]
function SettingManager:SetEffectState(isOn)

    settingData.effect = isOn
    self:flush()
end

--[[
* @brief 设置静音状态（全局）
]]
function SettingManager:SetMuteState(isOn)

    settingData.mute = isOn
    self:flush()
end

--[[
* @brief 设置方言语音状态
* @parm id 标识
]]
function SettingManager:SetDialectState(id, isOn)

    if not settingData[id] then
        self:ApplyDefaultSettings(id)
    end

    settingData[id].dialect = isOn

    self:flush()
end

--[[
* @brief 设置单击出牌状态
* @parm id 标识
]]
function SettingManager:SetClickOutCardState(id, isOn)

    if not settingData[id] then
        self:ApplyDefaultSettings(id)
    end

    settingData[id].djcp = isOn

    self:flush()
end

--[[
* @brief 设置放大出牌状态
* @parm id 标识
]]
function SettingManager:SetEnlargeOutCardState(id, isOn)

    if not settingData[id] then
        self:ApplyDefaultSettings(id)
    end

    settingData[id].fdcp = isOn

    self:flush()
end

--[[
* @brief 设置加注方式
* @parm id 标识
]]
function SettingManager:SetBetTypeState( id, tag )
    if not settingData[id] then
        self:ApplyDefaultSettings(id)
    end
    settingData[id].jzfs = tag
    self:flush()
end

--[[
* @brief 设置加注方式
* @parm id 标识
]]
function SettingManager:SetCardBgStyleState( id, tag )
    if not settingData[id] then
        self:ApplyDefaultSettings(id)
    end
    settingData[id].kpbj = tag
    self:flush()
end

--[[
* @brief 设置大厅图片背景状态
* @parm id 标识
]]
function SettingManager:SetHallBGState( id, tag )
    if not settingData[id] then
        self:ApplyDefaultSettings(id)
    end
    settingData[id].hlbj = tag
    self:flush()
end


--[[
* @brief 根据功能标识设置状态
* @parm id 游戏标识（游戏使用短名）
* @parm funMark 功能标识,比如音乐开关,音效开关
* @parm isOn 状态
]]
function SettingManager:SetStateByMark(id, funMark, isOn)

    if funMark == SettingManager.FUN_MARK.MUSIC then
        self:SetMusicState(id, isOn)
    elseif funMark == SettingManager.FUN_MARK.EFFECT then
        self:SetEffectState(isOn)
    elseif funMark == SettingManager.FUN_MARK.DIALECT then
        self:SetDialectState(id, isOn)
    elseif funMark == SettingManager.FUN_MARK.CLICK_OUT_CARD then
        self:SetClickOutCardState(id, isOn)
    elseif funMark == SettingManager.FUN_MARK.ENLARGECARD_OUT_CARD then
        self:SetEnlargeOutCardState(id, isOn)
    elseif funMark == SettingManager.FUN_MARK.MUTE then
        self:SetMuteState(isOn)
    elseif funMark == SettingManager.FUN_MARK.BET_TYPE then
        self:SetBetTypeState( id, isOn )
    elseif funMark == SettingManager.FUN_MARK.CARD_BG_STYLE then
        self:SetCardBgStyleState( id, isOn )
    elseif funMark == SettingManager.FUN_MARK.HALL_BG_STYLE then
        self:SetHallBGState( id, isOn )
    end
end

--[[
* @brief 获取音乐状态
* @parm id 标识
]]
function SettingManager:GetMusicState(id)

    local gs = settingData[id]

    if gs ~= nil then

        return gs.music
    else
        self:ApplyDefaultSettings(id)
        return settingData[id].music
    end
end

--[[
* @brief 获取方言状态
* @parm id 标识
* @parm defOpen 是否默认开启
]]
function SettingManager:GetDialectState( id , defOpen )

    local gs = settingData[id]

    if gs ~= nil then

        return gs.dialect
    else
        self:ApplyDefaultSettings(id)
        self:SetDialectState( id , defOpen == true )
        return settingData[id].dialect
    end
end

--[[
* @brief 获取单击出牌状态
* @parm id 标识
]]
function SettingManager:GetClickOutCardState(id)

    local gs = settingData[id]

    if gs ~= nil then

        return gs.djcp
    else
        self:ApplyDefaultSettings(id)
        return settingData[id].djcp
    end
end

--[[
* @brief 获取放大出牌状态
* @parm id 标识
]]
function SettingManager:GetClickEnlargeCardState(id)

    local gs = settingData[id]

    if gs ~= nil then

        return gs.fdcp
    else
        self:ApplyDefaultSettings(id)
        return settingData[id].fdcp
    end
end

--[[
* @brief 获取音效状态（全局）
]]
function SettingManager:GetEffectState()

    local effect = settingData.effect

    if effect ~= nil then
        return effect
    else
        settingData.effect = true
        self:flush()
        return settingData.effect
    end
end

--[[
* @brief 获取静音状态（全局）
]]
function SettingManager:GetMuteState()

    local mute = settingData.mute

    if mute ~= nil then
        return mute
    else
        settingData.mute = false
        self:flush()
        return settingData.mute
    end
end

--[[
* @brief 获取加注方式
]]
function SettingManager:GetBetTypeState( id )
    local gs = settingData[id]

    if gs ~= nil then
        return gs.jzfs
    else
        self:ApplyDefaultSettings(id)
        return settingData[id].jzfs
    end
end

--[[
* @brief 获取卡牌背景花纹
]]
function SettingManager:GetCardBgStyleState( id )
    local gs = settingData[id]

    if gs ~= nil then
        return gs.kpbj
    else
        self:ApplyDefaultSettings(id)
        return settingData[id].kpbj
    end
end

--[[
* @brief 获取大厅背景图片
]]
function SettingManager:GetHallBgState( id )
    local gs = settingData[id]
    if gs ~= nil then
        return gs.hlbj
    else
        self:ApplyDefaultSettings(id)
        return settingData[id].hlbj
    end
end


--[[
* @brief 根据功能标识获取状态
]]
function SettingManager:GetStateByMark(id, funMark)

    if funMark == SettingManager.FUN_MARK.MUSIC then
        return self:GetMusicState(id)
    elseif funMark == SettingManager.FUN_MARK.EFFECT then
        return self:GetEffectState()
    elseif funMark == SettingManager.FUN_MARK.DIALECT then
        return self:GetDialectState(id)
    elseif funMark == SettingManager.FUN_MARK.CLICK_OUT_CARD then
        return self:GetClickOutCardState(id)
    elseif funMark == SettingManager.FUN_MARK.ENLARGECARD_OUT_CARD then
        return self:GetEnlargeOutCardState(id)
    elseif funMark == SettingManager.FUN_MARK.MUTE then
        return self:GetMuteState()
    elseif funMark == SettingManager.FUN_MARK.BET_TYPE then
        return self:GetBetTypeState( id )
    elseif funMark == SettingManager.FUN_MARK.CARD_BG_STYLE then
        return self:GetCardBgStyleState( id )
    elseif funMark == SettingManager.FUN_MARK.HALL_STYLE then
        return self:GetHallBgState( id )

    end
end

--[[
* @brief 获取本地任务的版本号
]]
function SettingManager:GetTaskVersion( )

    return settingData.taskver

end

--[[
* @brief 设置本地任务的版本号
]]
function SettingManager:SetTaskVersion( newver )

    settingData.taskver = newver
    self:flush()

end

--[[
* @brief 记录配置
* @param id 游戏短名，大厅使用 hall；如果此参数为 nil，则记录为全局配置
* @param key 配置的 key
* @param value 配置的值
]]
function SettingManager:SetConfig(id, key, value)
    if id then
        if not settingData[id] then
            self:ApplyDefaultSettings(id)
        end
        settingData[id][key] = value
    else
        settingData[key] = value
    end
    self:flush()
end

--[[
* @brief 获取配置的值
* @param id 游戏短名，大厅使用 hall；如果此参数为 nil，则获取全局配置
* @param key 配置的 key
* @param defaultValue 默认的配置值，当不存在此配置时返回此值
* @return 返回配置的值，当不存在此配置时返回 defaultValue 参数
]]
function SettingManager:GetConfig(id, key, defaultValue)
    local ret
    if id then
        if settingData[id] then
            ret = settingData[id][key]
        end
    else
        ret = settingData[key]
    end

    -- 没有取到值，返回默认值
    if nil == ret  then
        ret = defaultValue
    end

    return ret
end

--[[
* @brief 获取全部的配置数据
]]
function SettingManager:GetAllSettings()
    return settingData
end

--[[
* @brief 刷新
]]
function SettingManager:flush()

    -- 刷新本地存储
    localCfgFile:Save(settingData, localConfigPath)
end

function SettingManager:GetCustomBGImgPath()
    -- 新版大厅不支持自定义背景
    --local cachePath = Helper.GetCachePath()
    -- return cachePath.."custom_bg.png"
    return ""

end

return SettingManager