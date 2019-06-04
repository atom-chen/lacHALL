--[[
    * 描述：创建一个空的Button，但是有大小
    * 点击事件：onClicked(button)
--]]

local M = class("libs.widget.ButtonEmpty", function(parameter)
    assert(nil==parameter, "错误：请使用createWithSize创建")
	return cc.ControlButton:create()
end)

function M:createWithSize(size)
    assert(size)
    return M.new():_initWithSize(size)
end

--------------------------- 华丽分割线 ---------------------------

function M:_initWithSize(size)
    self:setPreferredSize(size)
    self:setContentSize(size)
    self:registerControlEventHandler(function()
        if self.onClicked then
            self.onClicked(self)
        end
    end, cc.CONTROL_EVENTTYPE_TOUCH_UP_INSIDE)
        
    return self
end

return M


