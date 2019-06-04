--[[
    * 描述：精灵plist数据缓存类
]]
local M = {}
local m_animateKeysTable = {}
local function _addPlistData(plistPath)
    if m_animateKeysTable[plistPath] then 
        return 
    end

    local animateKeys = {}
    local tmpPlistData = cc.FileUtils:getInstance():getValueMapFromFile(plistPath)
    local frameData = tmpPlistData["frames"]

    for animateKey,_ in pairs(frameData) do
        animateKeys[animateKey] = true
    end
    m_animateKeysTable[plistPath] = animateKeys
end

function M:getAnimateKeys(plistPath)
    _addPlistData(plistPath) 

    return m_animateKeysTable[plistPath]
end

return M