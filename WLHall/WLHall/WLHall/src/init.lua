require "config"
function reload()
    require ("hallmain")
end
function ClassEx(clsname, fncreate)
    local cls;
    local function _create()
        local obj = fncreate();
        for k, v in pairs(cls) do
            obj[k] = v;
        end
        return obj;
    end

    cls = class(clsname, _create)
    return cls;
end

-------------- 全局对象---------------
-- 自定义全局变量
-- 游戏大厅入口 全局对象
-- GameApp = {}
-- 常量定义
require "def.constants"
--------------------------------
-- 输出值的内容
-- @基础函数库 [parent=#global] gg
gg = require "common.Function"
gg.LocalConfig = require "common.filehelper.LocalConfig"
gg.UserData = require "common.filehelper.UserData"
gg.PopupGoodsData = require "hall.models.PopupGoodsData"
gg.ActivityPageData = require "hall.models.ActivityPageData"
gg.GameCfgData = require "hall.models.GameCfgData"
-- 网络请求
gg.Http = require "common.HttpHelper"
gg.Dapi = gg.Dapi or {}

-- 版本检查
gg.VersionHelper = require ("update.VersionHelper")

require "socket"
require "cocos.init"
require "common.init"
require "hall.controllers.init"
require "login.init"
-- 声音管理器初始化
if device.platform == "ios" or (device.platform == "android" and gg.GetNativeVersion() > 0) then
    -- iOS 平台固定使用 AudioEngine
    -- Android 平台，如果 native 版本大于 0，则使用 AudioEngine
    gg.AudioManager = require("common.audio.AudioManager")
    print("---- Using AudioEngine ----")
else
    -- 其他情况使用 SimpleAudioEngine
    gg.AudioManager = require("common.audio.SimpleAudioManager")
    print("---- Using SimpleAudioEngine ----")
end
gg.AudioManager:init()
require "def.switch"

-- Agora SDK 相关的初始化
gg.AgoraManager = require("libs.agora.AgoraManager")
gg.AgoraManager:initAgora()
