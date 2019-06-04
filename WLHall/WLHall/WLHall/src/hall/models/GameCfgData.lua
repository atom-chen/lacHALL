--
-- Author: Cai
-- Date: 2018-05-21
-- Describe: 游戏配置

local M = {}

local localCfgFile = require("common.FileTable").New()

local cachePath = Helper.GetCachePath()
local localConfigPath = cachePath .. "gamecfg.tmp"

-- 读取本地缓存公告
local gameCfg = localCfgFile:Open(localConfigPath)

local isLoaded_ = false
local loadedCallbacks = {}

-- 重复请求数据的时间间隔（5分钟）
local TIME_LIMIT = 300

-- 刷新本地存储
local function flush_()
	localCfgFile:Save(gameCfg, localConfigPath)
end

local function getRegion_()
    local region = gg.LocalConfig:GetRegionCode()
    if checkint(region) == 0 then
       region = REGION_CODE
    end
    region = gg.StringAppend(region, 0, 6)
    return tostring(region)
end

local function loadedSuccess_()
    isLoaded_ = true
    if loadedCallbacks and #loadedCallbacks > 0 then
        for i, v in ipairs(loadedCallbacks) do
            if v then
                v()
            end
        end
        loadedCallbacks = {}
    end
    GameApp:dispatchEvent(gg.Event.HALL_GAME_CFG_CHANGED)

    -- 刷新大厅游戏列表
    if hallmanager and hallmanager:IsConnected() then
        hallmanager:UpdateGameList()
    end
end

function M:_pullData(reqTimes)
    isLoaded_ = false
    reqTimes = checkint(reqTimes)
    if reqTimes > 2 then
        print("cfg_game数据多次请求失败！！！")
        loadedSuccess_()
        return
    end

    gg.Dapi:GetAppGameCfg(function(cb)
        cb = checktable(cb)
        if cb.status and checkint(cb.status) == 0 then
            local tb = {}
            tb.time = os.time()
            tb.data = checktable(cb.data)
            local region = getRegion_()
            gameCfg[region] = tb
            flush_()
            loadedSuccess_()
        else
            M:_pullData(reqTimes + 1)
        end
    end)
end

-- 拉取游戏配置
function M:PullGameCfg()
    local region = getRegion_()
    if checkint(region) == 0 then
        -- 全国包未选地区的话，不需要拉取数据
        return
    end

    local tb = gameCfg[region]
    if not tb or table.nums(tb.data) == 0 then
        print("本地没有cfg_game缓存，拉取数据")
        self:_pullData()
        return
    else
        -- 地区码变化或者上一次请求时间超过要求的时间间隔时，再次拉取最新数据
        local times = os.time() - checkint(tb.time)
        if times > TIME_LIMIT then
            printf("距离上次拉取cfg_game超过 %s 小时，再次拉取数据", TIME_LIMIT / 3600)
            self:_pullData()
            return
        end
    end

    loadedSuccess_()
end

-- 获取游戏配置
function M:GetCfgGame()
    -- 判断是否有local_cfg_game文件
    local ok, localGameCfg = pcall(function()
        return require("local_cfg_game")
    end)

    local function checkLocalCfg(key)
        if not ok then
            print("本地没有local_cfg_game.lua文件，或者local_cfg_game.lua文件存在语法错误")
            return nil
        elseif not localGameCfg[key] then
            print(string.format("local_cfg_game文件没有%s配置", tostring(key)))
            return nil
        else
            return localGameCfg[key]
        end
    end

    if IS_REVIEW_MODE then
        local ret
        local curRegion = gg.LocalConfig:GetRegionCode()
        local regionStr = string.format("%d", curRegion)
        if #regionStr >= 2 then
            -- 根据选择地区的前两位获取对应的审核配置
            regionStr = string.sub(regionStr, 1, 2)
            ret = checkLocalCfg(string.format("review_cfg_%s", regionStr))
        end

        -- 未找到合适的配置，使用默认的审核配置
        if not ret then
            ret = checkLocalCfg("review_cfg")
        end
        return ret
    end

    if IS_LOCAL_TEST then
        return checkLocalCfg("default_cfg")
    end

    local region = getRegion_()
    local cfg = checktable(checktable(gameCfg[region]).data)
    -- 如果拉取到的配置为空，尝试使用本地的配置
    if table.nums(cfg) == 0 then
        print("从web端拉取配置失败 ")
        return checkLocalCfg("default_cfg")
    else
        return cfg
    end
end

function M:CheckLoaded(callback)
    if IS_REVIEW_MODE or IS_LOCAL_TEST then
        isLoaded_ = true
        if callback then callback() end
        return true
    end

    if isLoaded_ then
        if callback then callback() end
        return true
    else
        table.insert(loadedCallbacks, callback)
        return false
    end
end

function M:clear()
    isLoaded_ = false
    loadedCallbacks = {}
end

return M