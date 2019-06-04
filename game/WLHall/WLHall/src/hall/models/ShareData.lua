local ShareData = {}

local localCfgFile = require("common.FileTable").New()

-- 本地配置路径变量
local cachePath = Helper.GetCachePath()
local localConfigPath = cachePath.."sharedata.tmp"
-- 读取本地缓存分享任务数据
local shareTb = localCfgFile:Open(localConfigPath)

-- 刷新本地存储
local function flush_()
    localCfgFile:Save(shareTb, localConfigPath)
end

local function initData_()
    local shareTaskInfo = {}
    local infos = shareTb[1]

    if not infos then
        return nil
    end

    for k, v in ipairs(infos["condition"]) do
        shareTaskInfo[k] = {}
        shareTaskInfo[k]["share_count"] = v
    end

    for k2, v2 in ipairs(infos["awards"]) do
        shareTaskInfo[k2]["prob_type"] = v2[1][1]
        shareTaskInfo[k2]["prob_count"] = v2[1][2]
    end

    return shareTaskInfo
end

-- 拉取每日分享任务数据
function ShareData:loadShareTaskInfo()
    shareTb = {}
    
    local callback = function( result )
        if checkint(result.status) ~= 0 or not result[1] or not result[1].ver then
            self.loadCallback(false)
            return
        end

        shareTb = result
        local shareTaskInfo = initData_()
        
        self.loadCallback(true, shareTaskInfo)

        flush_()
    end

    gg.Dapi:GetShareTaskInfo(callback)
end

function ShareData:checkLoaded(callback)
    local curr_ver = gg.UserData:GetShareVer()

    self.loadCallback = callback

    if not shareTb[1] or not shareTb[1].ver or curr_ver ~= shareTb[1].ver then
        self:loadShareTaskInfo()
    else
        local shareTaskInfo = initData_()
        self.loadCallback(true, shareTaskInfo)
    end
end

return ShareData
