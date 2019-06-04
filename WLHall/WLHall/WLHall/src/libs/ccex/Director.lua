local M = {}

function M:getRunningScene()
    return cc.Director:getInstance():getRunningScene()
end

function M:createScene(layer)
    assert(layer)
    local scene = cc.Scene:create()
    scene:addChild(layer)
    return scene
end

function M:runSceneWithScene(scene)
    -- collectgarbage("collect")
    local runScene = self:getRunningScene()
    if runScene then
        cc.Director:getInstance():replaceScene(scene) 
    else 
        cc.Director:getInstance():runWithScene(scene)
    end
end

function M:runSceneWithLayer(layer)
    assert(layer)
    local scene = self:createScene(layer)
    self:runSceneWithScene(scene)
end

function M:setAllTouchEnabled(bool)
    local dir = cc.Director:getInstance() 
    local events = dir:getEventDispatcher()
    events:setEnabled(bool)
end

return M

