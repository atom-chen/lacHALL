local M = class("ccex.ui.TrackbackLayer", function(parameter)
    assert(nil==parameter, "错误：请使用showErrorMsg创建")
    return cc.LayerColor:create(cc.c4b(0, 0, 0, 150))
end)

local ___hadShowErrorMsg = false
function M:createWithErrorMsg(msg, traceback)
    Director:setAllTouchEnabled(true)
    if not ___hadShowErrorMsg then
        local scene = Director:getRunningScene()
        if not scene then 
            return
        end

        ___hadShowErrorMsg = true
        local layer = M:create()
        layer:_init(msg, traceback)
        scene:addChild(layer, 1000000)
    end
end

--------------------------- 华丽分割线 ---------------------------

function M:_init(msg, traceback)
    local text = msg .. "\n" .. traceback
    local messageLabel = cc.Label:createWithSystemFont(text, "STHeitiSC-Medium", 20)
    self:addChild(messageLabel)
    messageLabel:setAlignment(1)
    messageLabel:setHorizontalAlignment(0)
    messageLabel:setPosition(display.center)

    if display.width < display.height then 
        messageLabel:setRotation(90)    
    end

    ButtonLabel:create("关闭消息框", 34)
        :addTo(self)
        :move(100, display.height - 40)
        .onClicked = function()
            ___hadShowErrorMsg = false
            self:removeFromParent()
        end
end

return M


