--
-- Author: Cai
-- Date: 2018-05-09
-- Describe：创建、加入、俱乐部、战绩弹出界面

local M = class("FriendRoomMainView", cc.load("ViewPop"))
M.RESOURCE_FILENAME = "ui/room/friend_room_main_view.lua"
M.ADD_BLUR_BG = true
M.RESOURCE_BINDING = {
    ["tab_panel"]   = {["varname"] = "tab_panel"},
    ["nd_view"]     = {["varname"] = "nd_view"  },
    ["btn_room"]    = {["varname"] = "btn_room",    ["events"] = {{event = "click", method = "onClickTab"}}},
    ["btn_join"]    = {["varname"] = "btn_join",    ["events"] = {{event = "click", method = "onClickTab"}}},
    ["btn_club"]    = {["varname"] = "btn_club",    ["events"] = {{event = "click", method = "onClickTab"}}},
    ["btn_record"]  = {["varname"] = "btn_record",  ["events"] = {{event = "click", method = "onClickTab"}}},
    ["btn_service"] = {["varname"] = "btn_service", ["events"] = {{event = "click", method = "onClickService"}}},
    ["btn_close"]   = {["varname"] = "btn_close",   ["events"] = {{event = "click_color", method = "onClickClose"}}},
}

local SERVICE_TAG = ModuleTag.FriendRooms
local TAB_BTN_NOR_COLOR = cc.c3b(98, 158, 226)
local TAB_BTN_SEL_COLOR = cc.c3b(246, 230, 155)

-- idxTag:创建房间："room"；加入房间："join"；俱乐部："club"；战绩："record"
function M:onCreate(idxTag, game)
    self:setScale(math.min(display.scaleX, display.scaleY))
    self._game = checktable(game)
    self._tabTb = {self.btn_room, self.btn_join, self.btn_club, self.btn_record}
    self._curView = nil
    self:checkSwitch()
    self:registerEventListener()

    if not idxTag then
        self:doJumpTab(self.btn_room)
    else
        self:selectTab(idxTag)
    end
end

function M:selectTab(idxTag)
    local tab = "btn_" .. idxTag
    if self[tab] then
        self:doJumpTab(self[tab])
    else
        self:doJumpTab(self.btn_room)
    end
end

function M:onClickTab(sender)
    gg.AudioManager:playClickEffect()
    self:doJumpTab(sender)
end

function M:doJumpTab(sender)
    for i,btn in ipairs(self._tabTb) do
        local color = gg.IIF(btn == sender, TAB_BTN_SEL_COLOR, TAB_BTN_NOR_COLOR)
        btn:setColor(color)
        btn:setTouchEnabled(not (btn == sender))
        if btn.subView then
            btn.subView:setVisible(btn == sender)
        end
    end
    -- 根据不同界面显示设置关闭按钮颜色
    local cColor = gg.IIF(self.btn_room == sender, cc.c3b(34,34,34), cc.c3b(255,255,255))
    self.btn_close:getChildByName("img_x"):setColor(cColor)

    if sender.subView then 
        self._curView = sender.subView    
        return 
    end
    if sender == self.btn_room then
        sender.subView = self:getScene():createView("room.FriendCreateFrame", self._game.shortname)
    elseif sender == self.btn_join then
        sender.subView = self:getScene():createView("room.FriendJoinView")
    elseif sender == self.btn_record then
        sender.subView = self:getScene():createView("room.GameRecordStatisticsView")
    elseif sender == self.btn_club then
        -- sender.subView = self:getScene():createView("friends.FriendsGroupView")
    end
    if sender.subView then
        self.nd_view:addChild(sender.subView)
        self._curView = sender.subView
    end
end

function M:checkSwitch()
    -- 设置俱乐部按钮的显示
    if GameApp:CheckModuleEnable(ModuleTag.DaiKaiRoom) then
        -- 判断是否有俱乐部功能
        local ok, file = pcall(function()
            return require("hall.views.friends.FriendsGroupView")
        end)
        if not ok then
            self.btn_club:setVisible(false)
        end
    else
        self.btn_club:setVisible(false)
    end
    -- 客服按钮
    self.btn_service:setVisible(GameApp:CheckModuleEnable(ModuleTag.CustomerService))
    -- 重新设置tab按钮位置
    local cnt = 0
    local btnH = 0
    local height = self.tab_panel:getContentSize().height
    for i,v in ipairs(self.tab_panel:getChildren()) do
        if v:isVisible() then
            v:setPositionY(height - 40 - btnH - v:getContentSize().height / 2 - 40 * cnt)
            btnH = btnH + v:getContentSize().height
            cnt = cnt + 1
        end
    end
end

-- 联系客服
function M:onClickService()
    gg.AudioManager:playClickEffect()
    device.callCustomerServiceApi(SERVICE_TAG)
end

function M:onClickClose()
    self:removeSelf()
end

function M:registerEventListener()
    self:addEventListener(gg.Event.ROOM_JOIN_NOTIFY, handler(self, self.onEventRoomJoinNotify))
    -- 游戏需要更新通知
    self:addEventListener("event_game_update_progress_changed", handler(self, self.onEventGameUpdateProgress))
    -- 游戏更新完毕通知
    self:addEventListener("event_game_update_finish", handler(self, self.onEventGameUpdateFinish))
end

function M:onEventGameUpdateProgress(event, percent, shortname)
    if self._curView and self._curView.doUpdateProgress then
        self._curView:doUpdateProgress(percent, shortname)
    end
end

function M:onEventGameUpdateFinish(event, shortname, err)
    if self._curView and self._curView.doUpdateFinish then
        self._curView:doUpdateFinish(shortname, err)
    end
end

-- 加入房间成功通知
function M:onEventRoomJoinNotify()
    self:removeSelf()
end

return M