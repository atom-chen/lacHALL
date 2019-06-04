--
-- Author: Cai
-- Date: 2018-08-21
-- Describe：救济金界面

local M = class("HallAlmsView", cc.load("ViewPop"))
M.RESOURCE_FILENAME = "ui/common/alms_view.lua"
M.LAYER_ALPHA = 25
M.RESOURCE_BINDING = {
    ["txt_tips"]  = {["varname"] = "txt_tips"},
    ["txt_vip"]   = {["varname"] = "txt_vip" },
    ["img_line"]  = {["varname"] = "img_line"},
    ["btn_vip"]   = {["varname"] = "btn_vip",   ["events"] = {{event = "click_color", method = "onClickVIP"  }}},
    ["btn_get"]   = {["varname"] = "btn_get",   ["events"] = {{event = "click", method = "onClickClose"}}},
}

function M:onCreate(beanCnt, leftCnt)
    self:setScale(math.min(display.scaleX, display.scaleY))
    self.txt_tips:setString(string.format("免费领取%d豆，今日还可领%d次", checkint(beanCnt), checkint(leftCnt)))

    local vipTips = "VIP可领取更多哦"
    if hallmanager and hallmanager.userinfo then
        local vipvalue = checkint(hallmanager.userinfo.vipvalue)
        local lv = gg.GetVipLevel(vipvalue)
        if lv >= 1 then
            vipTips = string.format("已享受VIP%d加成", lv)
        end
    end
    self.txt_vip:setString(vipTips)
    self.btn_vip:setContentSize(cc.size(self.txt_vip:getContentSize().width + 10, self.btn_vip:getContentSize().height))
    self.txt_vip:setPositionX(self.btn_vip:getContentSize().width / 2)
    self.img_line:setContentSize(cc.size(self.txt_vip:getContentSize().width, 2))
    self.img_line:setPositionX(self.btn_vip:getContentSize().width / 2)

    -- VIP开关
    if not GameApp:CheckModuleEnable(ModuleTag.VIP) then
        self.btn_vip:setVisible(false)
    end
end

function M:onClickVIP()
    self:getScene():createView("store.VipDetailed"):pushInScene()
end

function M:onClickClose()
    self:removeSelf()
end

return M