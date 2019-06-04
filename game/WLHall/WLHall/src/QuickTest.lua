local LoginManager = cc.load("LoginManager")
local M = {}

function M:canQuickTest()
    if not SystemArgc:hasArgc() then
        return false
    end

    local data = SystemArgc:getCustomData()
    return data and data.username and data.password
end

function M:quickLogin()
    if not self:canQuickTest() then
        return false
    end

    local loginmgr =LoginManager:getInstance()
    if nil==loginmgr then  
        return false
    end 

    local data = SystemArgc:getCustomData()
    -- printf("---Quick Login  %s  %s ",data.username, data.password)
    loginmgr:LoginByName(data.username, data.password)
    return true
end 

--[[
    * 描述：进入普通场快捷方式
--]]
function M:getRoomId()
    if not self:canQuickTest() then
        return nil
    end

    local data = SystemArgc:getCustomData()
    if nil==data.roomid then
        return nil
    end

    return tonumber(data.roomid)
end

--[[
    * 描述：用于进入创建或加入朋友场界面
--]]
function M:getGameId()
    if not self:canQuickTest() then
        return nil
    end

    local data = SystemArgc:getCustomData()
    if nil==data.gameid then
        return nil
    end
    
    return tonumber(data.gameid)
end

--------------------------- 华丽分割线 ---------------------------

return M

