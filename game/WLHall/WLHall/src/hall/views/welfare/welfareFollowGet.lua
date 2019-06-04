local M = class("welfareFollowGet", cc.load("ViewPop"))
M.RESOURCE_FILENAME = "ui/welfare/welfareFollowGet.lua"
M.RESOURCE_BINDING =
{
    ["img_input"] = { ["varname"] = "img_input" },


    ["btn_lq"] = {["varname"] = "btn_lq",  ["events"] = {{event = "click", method = "onClickLq" }}},
    ["btn_close"] = {["varname"] = "btn_close",  ["events"] = {{event = "click", method = "onClickClose" }}},
}
function M:onCreate()
    self.editVerification = nil
    self:initView()
end
function M:initView()

    local function createEditBox_(size, palceholder, inputflag)

        local edt = ccui.EditBox:create(size, "_")
        edt:setPosition(cc.p(size.width / 2, size.height / 2))
        edt:setAnchorPoint(cc.p(0.5, 0.5))
        edt:setPlaceHolder(palceholder or "")

        --设置弹出键盘,EMAILADDR并不是设置输入文本为邮箱地址,而是键盘类型为方便输入邮箱地址,即英文键盘
        edt:setInputMode(cc.EDITBOX_INPUT_MODE_EMAILADDR)
        edt:setInputFlag(inputflag or cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_ALL_CHARACTERS)
        edt:setPlaceholderFontColor(cc.c3b(170,179,185))
        edt:setFontColor(cc.c3b(170,179,185))
        edt:setFontSize(28)
        edt:setMaxLength(100)
        edt:setPlaceholderFontSize(28)
        return edt
    end

    -- 创建输入框
    local editBoxSize = self.img_input:getContentSize()
    self.editVerification = createEditBox_(cc.size(editBoxSize.width - 50, editBoxSize.height), ""):addTo(self.img_input):posBy(30, -4)

end
function M:onClickLq()

    local editVerifications = self.editVerification:getText()
    if not editVerifications or editVerifications== "" then
        self:showToast("请输入领奖码！")
        return
    end
    self._callback(editVerifications)
end

function M:setCallback(callback)
    self._callback = callback
end


function M:onClickClose()

   self:removeSelf()
end

return M