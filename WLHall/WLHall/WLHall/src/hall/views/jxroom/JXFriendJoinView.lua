--
-- Author: Cai
-- Date: 2018-08-23
-- Describe：吉祥朋友场加入房间输入界面

local M = class("JXFriendJoinView", cc.load("ViewPop"))

M.RESOURCE_FILENAME = "ui/room/friendroom/jx_join_room_view.lua"
M.RESOURCE_BINDING = {
    ["panel_input_bg"] = {["varname"] = "panel_input_bg"},        -- 输入数字父节点(用于获取输入文本)
    ["panel_key_bg"]   = {["varname"] = "panel_key_bg"  },        -- 键盘按键父节点（用于获取按键）
    ["img_bg"]         = {["varname"] = "img_bg"        },        -- 弹出框
	["btn_close"]      = {["varname"] = "btn_close", ["events"] = {{["event"] = "click_color", ["method"] = "onClickClose"}}},
}
M.AUTO_RESOLUTION = true
M.LAYER_ALPHA = 25
M.INPUT_CNT = 6            -- 输入位数

function M:onCreate()
    self:init()
    self:initView()
    self:registerEventListener()
end

function M:onCleanup()
    self:closeUpdateLoading()
end

function M:init()
    self._inputPosition = 1             -- 当前应该输入的位置
    self._inputViewTable = {}           -- 显示输入View集合
    self._result = ""
end

function M:initView()
    self.img_bg:setScale(math.min(display.scaleX, display.scaleY))
    -- 找到显示输入的View
    for i = 1, M.INPUT_CNT do
        local txt_input = self.panel_input_bg:getChildByName(string.format("txt_input_%d", i))
        txt_input:setVisible(false)
        table.insert(self._inputViewTable, txt_input)
    end
    -- 找到输入键盘
    for i = 0, 11 do
        local panel_key = self.panel_key_bg:getChildByName(string.format("btn_key_%d", i))
        panel_key:onClickScaleEffect(handler(self, self.onClickKey))
    end
end

-- 键盘点击事件
function M:onClickKey(sender)
    gg.AudioManager:playClickEffect() --播放点击声音
    local tag = sender:getTag()

    -- 按下数字
    if tag < 10 and self._inputPosition <= M.INPUT_CNT then
        -- 设置显示输入文本并显示
        local txt_input = self._inputViewTable[self._inputPosition]
        txt_input:setString(tag)
        txt_input:setVisible(true)
        -- 输入位置 +1
        self._inputPosition = self._inputPosition + 1
        -- 输入完成
        if self._inputPosition > M.INPUT_CNT then
            -- 回调输入完成函数
            self:onIputFinish()
        end
    end

    -- 按下重输
    if tag == 10 then
        self:clearInput()
    end

    -- 按下删除
    if tag == 11 then
        -- 判断输入位置进行删除
        if self._inputPosition - 1 > 0 then
            self._inputPosition = self._inputPosition - 1
            self._inputViewTable[self._inputPosition]:setVisible(false)
        end
    end
end

-- 清空输入
function M:clearInput()
    -- 重置输入位置
    self._inputPosition = 1
    -- 隐藏所有输输入显示View
    for i = 1 , #self._inputViewTable do
        self._inputViewTable[i]:setVisible(false)
    end
end

-- 输入完成回调
function M:onIputFinish()
    -- 获取输入结果
    local result = ""
    for i = 1 , M.INPUT_CNT do
        result = result..self._inputViewTable[i]:getString()
    end

    self._result = result
    if hallmanager and hallmanager:IsConnected() then
        hallmanager:JoinFriendRoomByRoomKey(self._result )
    end
end

-- 返回键回调
function M:keyBackClicked()
    local ret,remove = M.super.keyBackClicked(self)
    if ret and remove then
        if hallmanager and hallmanager:IsConnected() then
            hallmanager:ExitRoom()
        end
    end
    return ret,remove
end

-- 关闭事件
function M:onClickClose()
    self:removeSelf()
end

function M:registerEventListener()
    -- 落座失败通知
    self:addEventListener(gg.Event.ROOM_SIT_DOWN_FAIL, handler(self, self.onEventSitDownFail))
    self:addEventListener(gg.Event.HALL_QUERY_ROOMKEY_FAILED, handler(self, self.onEventSitDownFail))
    -- 加入房间成功通知
    self:addEventListener(gg.Event.ROOM_JOIN_NOTIFY, handler(self, self.onEventRoomJoinNotify))
    -- 游戏需要更新通知
    self:addEventListener("event_game_update_progress_changed", handler(self, self.onEventGameUpdateProgress))
    -- 游戏更新完毕通知
    self:addEventListener("event_game_update_finish", handler(self, self.onEventGameUpdateFinish))
end

-- 落座失败通知
function M:onEventSitDownFail(obj)
    self:clearInput()
end

-- 加入房间成功通知
function M:onEventRoomJoinNotify()
    self:clearInput()
    self:removeSelf()
end

-- 游戏更新进度通知
function M:onEventGameUpdateProgress(event, percent, shortname)
    if not self._updateView then
        self._updateView = gg.ShowLoading(self:getScene(), string.format("正在更新...%d%%", percent)):disableTimeout(true)
        -- 这里将 loading 界面 retain 是因为在下载过程中，loading 界面可能会被其他逻辑代码关闭。从而导致后面的更新进度逻辑无法正常工作
        self._updateView:retain()
    else
        self._updateView:setMsgText(string.format("正在更新...%d%%", percent))
    end
end

function M:closeUpdateLoading()
    if self._updateView then
        gg.ShowLoading(self:getScene())
        self._updateView:release()
        self._updateView = nil
    end
end

-- 游戏更新完毕通知
function M:onEventGameUpdateFinish(event, shortname, err)
    -- 移除等待界面
    self:closeUpdateLoading()
    if err then
        self:showToast(err)
        return
    end
    -- 重新加入房间
    if checkstring(self._result) ~= "" and hallmanager and hallmanager:IsConnected() then
        hallmanager:JoinFriendRoomByRoomKey(self._result)
    end
end

return M