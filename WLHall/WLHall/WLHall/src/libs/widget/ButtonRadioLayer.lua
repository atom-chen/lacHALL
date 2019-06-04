--[[
    * 描述：单选按钮集合
    * 初始化：参考ButtonSetLayer
    * 点击事件：参考ButtonSetLayer
--]]
local M = class("libs.widget.ButtonRadioLayer", function(setInfo)
    return require("libs.widget.ButtonSetLayer").new(setInfo)
end)

function M:ctor()
    self:enableNodeEvents()
end

function M:onEnterTransitionFinish()
    self:setSelectedIndex(0)
end

function M:setSelectedIndex(index)
    assert(self._buttons, "检查ButtonSetLayer成员变量self._buttons名称是否修改了")
    assert(index < #self._buttons, "index超出button数量")

    self:_setButtonEnable(true)
    self._buttons[index + 1]:setEnabled(false)
    if self._buttons[index + 1] then
       local button = self._buttons[index + 1]
        if self.onClicked then 
            self.onClicked(button, index) 
        end
    end
end

--------------------------- 华丽分割线 ---------------------------

-- 重写ButtonSetLayer方法
function M:_onClickedCall(button)
    assert(self._getIndexWithButton, "检查ButtonSetLayer成员函数名称是否修改了")
    local index = self:_getIndexWithButton(button)
    self:setSelectedIndex(index)

    if self.onClicked then 
       self.onClicked(button, index) 
    end
end

function M:_setButtonEnable(enable)
    for _,button in ipairs(self._buttons) do
        button:setEnabled(enable)
    end
end

return M