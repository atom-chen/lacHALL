-- http://www.tuicool.com/articles/JRFFviY
-- 必须前置,本地热更
local function _getNativePackageKeys()
    local pakcageKeys = {}
    local loaded = package.loaded
    for k, v in pairs(loaded) do
        pakcageKeys[k] = true
    end
    return pakcageKeys
end

local function _clearPackage(nativeKeys)
    local loaded = package.loaded
    for k, v in pairs(loaded) do
        if nativeKeys[k] == nil then
            loaded[k] = nil
        end
    end
end

--[[
    * 描述：本地热更,清除本地require的文件
--]]
if not __app_loaded then
    __app_loaded = _getNativePackageKeys()

    cc.FileUtils:getInstance():setPopupNotify(false)
    cc.FileUtils:getInstance():addSearchPath("src/")
    cc.FileUtils:getInstance():addSearchPath("res/")
else
    _clearPackage(__app_loaded)
end

--[[
    * 描述：本地热更新通知
--]]
function c_luaWillReload()
end

print("\n------------------------------ reload game ------------------------------\n")

require "config"
require "cocos.init"
require "libs.Init"

local function main()
    Director:setAllTouchEnabled(true)
    local XLCHGameUI = require("games.mj_xlch.ui.XLCHGameUI")
    local scene = XLCHGameUI:GetScene()
    Director:runSceneWithScene(scene)
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
