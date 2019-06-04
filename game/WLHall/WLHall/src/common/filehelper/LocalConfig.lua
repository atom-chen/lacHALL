--
-- Author: lee
-- Date: 2016-09-10 16:42:06
local LocalConfig = {}
-- 游戏偏好配置
local localCfgFile = require("common.FileTable").New();
local writablePath = cc.FileUtils:getInstance():getWritablePath()

-- 本地配置路径变量
local localConfigPath = writablePath .. "localcfg.dat"

local localCfgObj = localCfgFile:Open(localConfigPath)

local function flush_()
    localCfgFile:Save(localCfgObj, localConfigPath)
end

-- lua 文件转 json 的过程中需要做一些特殊处理
-- 比如：记录的已添加游戏，需要更改格式
local function updateCfgFile()
    -- 已经更新过了，不再处理
    if not localCfgObj.CustomGame then
        return
    end

    -- 生成新的配置数据
    localCfgObj.NewCustomGame = {}
    for k, v in pairs(localCfgObj.CustomGame) do
        local newK = ""..k
        localCfgObj.NewCustomGame[newK] = v
    end

    -- 删除旧的配置数据
    localCfgObj.CustomGame = nil

    -- 保存一下
    flush_()
end

updateCfgFile()

--添加 数据表 k v
function LocalConfig:SetConfigKV(tb)
    assert(type(tb)=="table","SetConfigKV params tb error")
    if tb and type(tb)=="table" then
        table.merge(localCfgObj,checktable(tb))
        flush_()
    end
end
--根据键值获取 配置
function LocalConfig:getConfigByKey(key)
    return clone(localCfgObj[key])
end
--根据键值删除 配置
function LocalConfig:delConfigByKey(key)
    if key then
       localCfgObj[key]=nil
    end
end

--获取最后登录服务器索引
function LocalConfig:GetLastLoginServerIdx()
    return localCfgObj.LastServerIdx or 1
end

--设置最后登录服务器索引
function LocalConfig:SetLastLoginServerIdx(idx)
    if idx then
        localCfgObj.LastServerIdx=checkint(idx)
        flush_()
    end
end

--设置版号备案信息
function LocalConfig:SetCopyRightInfo(banhao,beian)
    if banhao then
        localCfgObj.banhao=checkstring(banhao)
    end
    if beian then
       localCfgObj.beian=checkstring(beian)
    end
    flush_()
end

--设置版号备案信息
function LocalConfig:GetCopyRightInfo()
    return localCfgObj.banhao,localCfgObj.beian
end

--设置地区码
function LocalConfig:SetRegionCode(code)
    if code then
        assert(code>0 ,"region code error "..tostring(code))
        -- localCfgObj.RegionCode=checkint(code)
        cc.UserDefault:getInstance():setIntegerForKey("SeleteArea",checkint(code))
    end
    if hallmanager and hallmanager:IsConnected() then
        hallmanager:UpdateGameList()
    end
end

-- 获取地区码
function LocalConfig:GetRegionCode()
    local code = 0
    -- if checkint(localCfgObj.RegionCode ) >0 then
    --     code = localCfgObj.RegionCode
    -- end
    code=cc.UserDefault:getInstance():getIntegerForKey("SeleteArea",0)
    return code
end

-- 获取游戏打开次数
function LocalConfig:GetOpenAppCount()
    return checkint(localCfgObj.OpenAppCount)
end

--游戏打开次数  默认 加 1
function LocalConfig:AddOpenAppCount(num)
    num=num or 1
    localCfgObj.OpenAppCount = checkint(localCfgObj.OpenAppCount) + num
    flush_()
    return localCfgObj.OpenAppCount
end

--游戏自定义游戏
function LocalConfig:SetCustomGame(gameid,added)
    if gameid then
        localCfgObj.NewCustomGame = checktable(localCfgObj.NewCustomGame)
        localCfgObj.NewCustomGame[""..gameid]=added
        flush_()
    end
end

--设置客服代理信息
function LocalConfig:SetServiceInfo(table)
    if table then
        localCfgObj.ServiceInfo=checktable(table)
        flush_()
    end
end

-- 获取 客服代理信息
function LocalConfig:GetServiceInfo()
    return  checktable( localCfgObj.ServiceInfo)
end

--获取游戏自定义游戏
function LocalConfig:GetCustomGameTable()
    return checktable(localCfgObj.NewCustomGame)
end

-- 清除已添加的游戏数据
function LocalConfig:ClearCustomGameTable()
    localCfgObj.NewCustomGame = {}
    flush_()
end

-- 记录大厅版本更新的时间戳
function LocalConfig:SetHallUpdateTime(ver)
    if ver then
        localCfgObj.AppUpdateTimes = checktable(localCfgObj.AppUpdateTimes)
        -- 已经存在的不再记录
        if localCfgObj.AppUpdateTimes["" .. ver] then
            return
        end
        localCfgObj.AppUpdateTimes["" .. ver] = os.time()
        flush_()
    end
end

-- 获取某个大版本更新的时间戳，如果未找到则找到比这个版本高的最低版本时间戳
function LocalConfig:GetHallUpdateTime(ver)
    if ver then
        localCfgObj.AppUpdateTimes = checktable(localCfgObj.AppUpdateTimes)
        -- 存在当前版本时间戳直接返回
        if localCfgObj.AppUpdateTimes["" .. ver] then
            return localCfgObj.AppUpdateTimes["" .. ver]
        end
        -- 未找到，则遍历所有记录时间，找到比当前版本高的最低版本时间戳
        local minVer = nil
        for k,v in pairs(localCfgObj.AppUpdateTimes) do
            if tonumber(k) > tonumber(ver) then
                if minVer then
                    minVer = math.min(tonumber(k), tonumber(minVer))
                else
                    minVer = k
                end
            end
        end

        if minVer then
            return localCfgObj.AppUpdateTimes["" .. minVer]
        end
    end
end

function LocalConfig:Flush()
    return flush_()
end

return LocalConfig