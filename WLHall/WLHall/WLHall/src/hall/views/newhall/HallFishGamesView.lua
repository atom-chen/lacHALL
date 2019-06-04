--
-- Author: Cai
-- Date: 2017-08-07
-- Describe：捕鱼合集界面

local M = class("HallFishGamesView", cc.load("ViewPop"))

M.RESOURCE_FILENAME = "ui/newhall/hall_fish_games_view.lua"
M.RESOURCE_BINDING = {
    ["img_bg"]    = {["varname"] = "img_bg"},    
	["btn_close"] = {["varname"] = "btn_close", ["events"] = {{["event"] = "click_color", ["method"] = "onClickClose"}}},
}
M.LAYER_ALPHA = 25

local GameItem = import(".NewGameIconView")

function M:onCreate()
    local tb = {}
    if hallmanager then
        tb = hallmanager:GetFishGames()
    end

    for i,v in ipairs(tb) do
        local item = GameItem.new("GameItem", v.id, v)
        item:setPosition(cc.p(182 + (i - 1) * 295, 150))
        item:setScale(1.12)
        self.img_bg:addChild(item)

        item:setClickCallback(handler(self, self.onClickClose))
    end
end

function M:onClickClose()
    self:removeSelf()
end

return M