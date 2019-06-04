--
-- Author: Cai
-- Date: 2018-03-10
-- Describe：好友房菜单

local M = class("HallRoomMenu", cc.load("ViewBase"))
M.RESOURCE_FILENAME = "ui/newhall/hall_room_menu.lua"
M.RESOURCE_BINDING = {
    ["img_bg"]     = {["varname"] = "img_bg"    },
    ["img_shadow"] = {["varname"] = "img_shadow"},
    ["img_green"]  = {["varname"] = "img_green" },
    ["img_arrow"]  = {["varname"] = "img_arrow" },
    ["img_line"]   = {["varname"] = "img_line"  },
    ["sv_mini" ]   = {["varname"] = "sv_mini"   },
    ["nd_btns_1"]  = {["varname"] = "nd_btns_1" },
    ["nd_btns_2"]  = {["varname"] = "nd_btns_2" },
    ["btn_room"]   = {["varname"] = "btn_room", ["events"] = {{event = "click", method = "onClickRoom"}}},
    ["btn_join"]   = {["varname"] = "btn_join", ["events"] = {{event = "click", method = "onClickJoin"}}},
    ["btn_club"]   = {["varname"] = "btn_club", ["events"] = {{event = "click", method = "onClickClub"}}},
    ["btn_zj"]     = {["varname"] = "btn_zj",   ["events"] = {{event = "click", method = "onClickZj"  }}},
    ["btn_room_1"] = {["varname"] = "btn_room_1", ["events"] = {{event = "click", method = "onClickRoom"}}},
    ["btn_join_1"] = {["varname"] = "btn_join_1", ["events"] = {{event = "click", method = "onClickJoin"}}},
    ["btn_zj_1"]   = {["varname"] = "btn_zj_1",   ["events"] = {{event = "click", method = "onClickZj"  }}},
    ["panel_bg"]   = {["varname"] = "panel_bg", ["events"] = {{event = "click_color", method = "onClickClose"}}},
}

local HotItem = import("hall.views.room.HotItem")

function M:onCreate(game)
    self._game = checktable(game)
    self:resetLayout()
    if hallmanager and hallmanager:HasMiniGames() then
        local miniGames = hallmanager:GetLeisureGame()
        self:createMiniIcons(miniGames)
    end
    -- 设置俱乐部按钮的显示
    if GameApp:CheckModuleEnable(ModuleTag.DaiKaiRoom) then
        -- 判断是否有俱乐部功能
        local ok, file = pcall(function()
            return require("hall.views.friends.FriendsGroupView")
        end)
        self.nd_btns_1:setVisible(not ok)
        self.nd_btns_2:setVisible(ok)
    else
        self.nd_btns_1:setVisible(true)
        self.nd_btns_2:setVisible(false)
    end

    if not GameApp:CheckModuleEnable(ModuleTag.Room) then
        self.nd_btns_1:setVisible(true)
        self.nd_btns_2:setVisible(false)
        self.btn_zj_1:setVisible(false)
    end

    -- 进入动画
    self.panel_bg:setOpacity(0)
    self.panel_bg:runAction(cc.FadeIn:create(0.1))
    self.img_bg:setPositionX(display.width + self.img_bg:getContentSize().width + 70)
    self.img_bg:runAction(cc.MoveTo:create(0.2, cc.p(display.width, 0)))
end

function M:createMiniIcons(miniGames)
    local fishTb = {}
    if hallmanager then
        fishTb = hallmanager:GetFishGames()
        if #fishTb > 0 then
            local tb = {}
            local fishgames = {id = HotItem.SPECIAL_TAG.FISH_GAMES}
            table.insert(tb, fishgames)
            -- 将捕鱼和捕鱼达人筛掉
            for _,v in pairs(checktable(miniGames)) do
                if v.id ~= 226 and v.id ~= 550 then
                    table.insert(tb, v)
                end
            end
            miniGames = tb
        end
    end

    -- 不显示配置为srl的游戏
    for i=#miniGames, 1, -1 do
        local game = miniGames[i]
        if game and game.cmd and checkint(game.cmd.srl) == 1 then
            table.remove(miniGames, i)
        end
    end

    local disX = 205
    local svW = math.max(self.img_bg:getContentSize().width - 40, #miniGames * disX + 38)
    self.sv_mini:setInnerContainerSize(cc.size(svW, self.sv_mini:getContentSize().height))

    for i,game in ipairs(miniGames) do
        local icon = HotItem.new("HotItem", game)
        icon:setPosition(cc.p(121 + (i-1) * disX, self.sv_mini:getContentSize().height / 2 - 7))
        self.sv_mini:addChild(icon)
        icon:setCallFun(function()
            self:removeSelf()
        end)
    end
end

function M:resetLayout()
    self.nd_btns_1:setScale(display.scaleY)
    self.nd_btns_2:setScale(display.scaleY)
    self.panel_bg:setContentSize(cc.size(display.width, display.height))
    self.img_bg:setContentSize(cc.size(self.img_bg:getContentSize().width, display.height))
    self.img_shadow:setContentSize(cc.size(self.img_shadow:getContentSize().width, display.height))
    self.img_green:setContentSize(cc.size(self.img_green:getContentSize().width, display.height))
    self.img_arrow:setPositionY(self.img_bg:getContentSize().height / 2)
    self.sv_mini:setScrollBarEnabled(false)

    if hallmanager and hallmanager:HasMiniGames() then
        self.img_line:setVisible(true)
        self.sv_mini:setVisible(true)
        self.sv_mini:setPositionY(display.height)
        self.nd_btns_1:setPositionY(display.height)
        self.nd_btns_2:setPositionY(display.height)
        self.img_line:setPositionY(display.height -self.sv_mini:getContentSize().height )
    else
        self.img_line:setVisible(false)
        self.sv_mini:setVisible(false)
        self.nd_btns_1:setPositionY(display.height + 130)
        self.nd_btns_2:setPositionY(display.height + 130)
    end
end

-- 创建房间
function M:onClickRoom()
    gg.AudioManager:playClickEffect()
    if hallmanager and not hallmanager:IsInFriendRoom() then
        self:getScene():createView("room.FriendRoomMainView", "room", self._game):pushInScene()
    end
end

-- 加入房间
function M:onClickJoin()
    gg.AudioManager:playClickEffect()
    if hallmanager and not hallmanager:IsInFriendRoom() then
        self:getScene():createView("room.FriendRoomMainView", "join"):pushInScene()
    end
end

-- 俱乐部
function M:onClickClub()
    local ok, file = pcall(function()
        return require("hall.views.friends.FriendsGroupView")
    end)
    if ok then
        gg.AudioManager:playClickEffect()
        self:getScene():createView("room.FriendRoomMainView", "club"):pushInScene()
    end
end

-- 战绩
function M:onClickZj()
    gg.AudioManager:playClickEffect()
    self:getScene():createView("room.FriendRoomMainView", "record"):pushInScene()
end

function M:onClickClose()
    self.img_bg:runAction(cc.Sequence:create(
        cc.MoveBy:create(0.1, cc.p(display.width + self.img_bg:getContentSize().width + 70, 0)),
        cc.CallFunc:create(function() self:removeSelf() end)
    ))
end

return M