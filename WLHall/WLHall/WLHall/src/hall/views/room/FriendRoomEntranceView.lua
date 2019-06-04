--
-- Author: Cai
-- Date: 2018-08-21
-- Describe：好友房入口

local M = class("FriendRoomEntranceView", cc.load("ViewBase"))
M.RESOURCE_FILENAME = "ui/room/friend_room_entrance.lua"
M.RESOURCE_BINDING = {
    ["nd_btns"]    = {["varname"] = "nd_btns"    },
    ["img_back_bg"]= {["varname"] = "img_back_bg"},
    ["btn_close"]  = {["varname"] = "btn_close",  ["events"] = {{event = "click", method = "onClickClose" }}},	 --关闭按钮
    ["btn_create"] = {["varname"] = "btn_create", ["events"] = {{event = "click", method = "onClickRoom"  }}},
    ["btn_join"]   = {["varname"] = "btn_join",   ["events"] = {{event = "click", method = "onClickJoin"  }}},
    ["btn_club"]   = {["varname"] = "btn_club",   ["events"] = {{event = "click", method = "onClickClub"  }}},
    ["btn_arena"]  = {["varname"] = "btn_arena",  ["events"] = {{event = "click", method = "onClickArena" }}},    
    ["btn_record"] = {["varname"] = "btn_record", ["events"] = {{event = "click", method = "onClickRecord"}}},
}

function M:onCreate()
    self:resetLayout()
    -- 设置俱乐部按钮的显示
    if not GameApp:CheckModuleEnable(ModuleTag.DaiKaiRoom) then
        self.btn_club:setVisible(false)
        self.arena:setPositionX(self.btn_club:getPositionX())
    end
end

function M:resetLayout()
    self.nd_btns:setPosition(cc.p(display.cx, display.cy))
    self.nd_btns:setScale(math.min(display.scaleX, display.scaleY))
    --返回按钮背景
    self.img_back_bg:setPosition(cc.p(0, display.height))
end

-- 创建房间
function M:onClickRoom()
    gg.AudioManager:playClickEffect()
    if hallmanager and not hallmanager:IsInFriendRoom() then
        self:getScene():createView("jxroom.JXFriendCreateFrame"):pushInScene()
    end
end

-- 加入房间
function M:onClickJoin()
    gg.AudioManager:playClickEffect()
    if hallmanager and not hallmanager:IsInFriendRoom() then
        self:getScene():createView("jxroom.JXFriendJoinView"):pushInScene()
    end
end

-- 俱乐部
function M:onClickClub()
    local ok, file = pcall(function()
        return require("hall.views.friends.FriendsGroupView")
    end)
    if ok then
        gg.AudioManager:playClickEffect()
        self:getScene():createView("friends.FriendsGroupView"):pushInScene()
    end
end

-- 战绩
function M:onClickRecord()
    gg.AudioManager:playClickEffect()
    self:getScene():createView("jxroom.JXGameRecordView"):pushInScene()
end

-- 擂台
function M:onClickArena()
    gg.AudioManager:playClickEffect()
    GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "即将开放，敬请期待！")
end

function M:onClickClose()
    self:removeSelf()
end

function M:removeSelf()
    M.super.removeSelf(self)
    GameApp:dispatchEvent(gg.Event.GAME_ROOM_BACK_TO_HALL)
end

return M