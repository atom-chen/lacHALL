local M = class("ccex.ui.XpcallbackLayer", function(msg, traceback)
    return cc.LayerColor:create(cc.c4b(0, 0, 0, 150))
end)

local ___hadShowErrorMsg = false
function M:showErrorMsg(msg, traceback)
    if not ___hadShowErrorMsg then
        local scene = Director:getRunningScene()
        if not scene then 
            return
        end

        ___hadShowErrorMsg = true
        local layer = M.new(msg, traceback)
        scene:addChild(layer, 1000000)
        layer.onCloseMsg = function()
            ___hadShowErrorMsg = false
        end
    end
end

function M:ctor(msg, traceback)
    local text = msg .. "\n" .. traceback
    local messageLabel = cc.Label:createWithSystemFont(text, "STHeitiSC-Medium", 20)
    self:addChild(messageLabel)
    messageLabel:setAlignment(1)
    messageLabel:setHorizontalAlignment(0)
    messageLabel:setPosition(display.center)

    if display.width < display.height then 
        messageLabel:setRotation(90)    
    end

    local exitItem = cc.MenuItemFont:create("关闭消息框")
    exitItem:registerScriptTapHandler(function()
        if self.onCloseMsg then 
            self.onCloseMsg()
        end
        self:removeFromParent()
    end)

    local menu = cc.Menu:create(exitItem)
    self:addChild(menu)
    menu:setPosition(100, display.height - 40)
end

return M


