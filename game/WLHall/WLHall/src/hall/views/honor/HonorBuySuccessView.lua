--
-- Author: Cai
-- Date: 2017-03-30
-- Describe：荣誉礼包购买成功界面

local M = class("HonorBuySuccessView", cc.load("ViewPop"))

M.RESOURCE_FILENAME = "ui/honor/honor_buy_success_view.lua"
M.RESOURCE_BINDING = {
    ["panel_bg"]  = {["varname"] = "panel_bg"},
    ["nd_items"]  = {["varname"] = "nd_items"},      
    ["btn_share"] = {["varname"] = "btn_share", ["events"] = {{["event"] = "click", ["method"] = "onClickShare"}}},
    ["btn_close"] = {["varname"] = "btn_close", ["events"] = {{["event"] = "click", ["method"] = "onClickClose"}}},
}

function M:onCreate(grade)
    self:setScale(math.min(display.scaleX, display.scaleY))
    self._awardCfg = require("hall.models.StoreData"):GetHonorGiftPropsCfg(grade)
    self:createAwardItems(self._awardCfg)
    -- 2018-04-02 暂时隐藏礼包的分享
    self.btn_share:setVisible(false)
    self.btn_close:setPosition(self.btn_share:getPosition())
end

function M:createAwardItems(awardCfg)
    for i,v in ipairs(awardCfg) do
        local item = self:findNode("item_award"):clone()
        item:setVisible(true)
        item:setPositionX((i - 1) * 265)
        self.nd_items:addChild(item)

        -- 奖励图片
        local prop = gg.GetPropList()[v[1]]
        item:getChildByName("img_award"):loadTexture(prop.icon)
        -- 奖励数量
        local cnt = v[2] * (prop.proportion or 1)
        if v[1] == PROP_ID_MONEY then
            cnt = gg.MoneyUnit(v[2])
        end
        local cntStr = prop.name .. "x" .. cnt
        item:getChildByName("txt_award"):setString(cntStr)
    end
    self.nd_items:setPositionX(self.panel_bg:getContentSize().width / 2 - 265 * #awardCfg / 2 + 20)
end

function M:onClickShare()
    Log("分享！！！")
    gg.AudioManager:playClickEffect()
    self:removeSelf()
end

function M:onClickClose()
    gg.AudioManager:playClickEffect()
    self:removeSelf()
end

return M