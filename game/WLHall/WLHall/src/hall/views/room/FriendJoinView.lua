--
-- Author: zhaoxinyu
-- Date: 2016-09-05 15:19:47
-- Describe：朋友场加入房间输入界面


local FriendJoinView = class("FriendJoinView", cc.load("ViewBase"))

FriendJoinView.RESOURCE_FILENAME = "ui/room/friendroom/join_room_layer.lua"
FriendJoinView.RESOURCE_BINDING = {
    ["panel_input_bg"] = {["varname"] = "panel_input_bg"},        -- 输入数字父节点(用于获取输入文本)
    ["panel_key_bg"]   = {["varname"] = "panel_key_bg"  },        -- 键盘按键父节点（用于获取按键）
    ["img_bg"]         = {["varname"] = "img_bg"        },        -- 弹出框
}
FriendJoinView.p = 6            -- 输入位数
FriendJoinView.AUTO_RESOLUTION = true

function FriendJoinView:onCreate( ... )
    -- 初始化
    self:init()
    -- 初始化View
    self:initView()
    -- 注册消息通知
    self:registerEventListener()
end

function FriendJoinView:onCleanup()
    self:closeUpdateLoading()
end

--[[
* @brief 初始化
]]
function FriendJoinView:init()
    self._inputPosition = 1             -- 当前应该输入的位置
    self._inputViewTable = {}           -- 显示输入View集合
    self._result = ""
end

--[[
* @brief 初始化View
]]
function FriendJoinView:initView()
    -- 找到显示输入的View
    for i = 1, FriendJoinView.p do
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

--[[
* @brief 初始化View
]]
function FriendJoinView:registerEventListener()
    -- 落座失败通知
    self:addEventListener( gg.Event.ROOM_SIT_DOWN_FAIL, handler( self, self.onEventSitDownFail ) )
    self:addEventListener( gg.Event.HALL_QUERY_ROOMKEY_FAILED, handler( self, self.onEventSitDownFail ) )
    -- 加入房间成功通知
    self:addEventListener( gg.Event.ROOM_JOIN_NOTIFY, handler( self, self.onEventRoomJoinNotify ) )
end

--[[
* @brief 键盘点击事件
]]
function FriendJoinView:onClickKey( sender )
    gg.AudioManager:playClickEffect() --播放点击声音
    local tag = sender:getTag()

    -- 按下数字
    if tag < 10 and self._inputPosition <= FriendJoinView.p then
        -- 设置显示输入文本并显示
        local txt_input = self._inputViewTable[self._inputPosition]
        txt_input:setString(tag)
        txt_input:setVisible(true)
        -- 输入位置 +1
        self._inputPosition = self._inputPosition + 1
        -- 输入完成
        if self._inputPosition > FriendJoinView.p then
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
            self._inputViewTable[ self._inputPosition ]:setVisible(false)
        end
    end
end

--[[
* @brief 清空输入
]]
function FriendJoinView:clearInput()
    -- 重置输入位置
    self._inputPosition = 1
    -- 隐藏所有输输入显示View
    for i = 1 , #self._inputViewTable do
        self._inputViewTable[i]:setVisible(false)
    end
end

--[[
* @brief 输入完成回调
]]
function FriendJoinView:onIputFinish()
    -- 获取输入结果
    local result = ""
    for i = 1 , FriendJoinView.p do
        result = result..self._inputViewTable[i]:getString()
    end

    self._result = result
    if hallmanager and hallmanager:IsConnected() then
        hallmanager:JoinFriendRoomByRoomKey(self._result )
    end
end

--[[
* @brief 返回键回调
]]
function FriendJoinView:keyBackClicked()
    local ret,remove = FriendJoinView.super.keyBackClicked(self)
    if ret and remove then
        if hallmanager and hallmanager:IsConnected() then
            hallmanager:ExitRoom()
        end
    end
    return ret,remove
end

--[[
* @brief 落座失败通知
]]
function FriendJoinView:onEventSitDownFail( obj )
    -- 清空输入
    self:clearInput()
end

--[[
* @brief 加入房间成功通知
]]
function FriendJoinView:onEventRoomJoinNotify()
    -- 清空输入
    self:clearInput()
end

-- 游戏更新进度通知
function FriendJoinView:doUpdateProgress(percent, shortname)
    if not self._updateView then
        self._updateView = gg.ShowLoading(self:getScene(), string.format("正在更新...%d%%", percent)):disableTimeout(true)
        -- 这里将 loading 界面 retain 是因为在下载过程中，loading 界面可能会被其他逻辑代码关闭。从而导致后面的更新进度逻辑无法正常工作
        self._updateView:retain()
    else
        self._updateView:setMsgText( string.format("正在更新...%d%%", percent) )
    end
end

function FriendJoinView:closeUpdateLoading()
    if self._updateView then
        gg.ShowLoading(self:getScene())
        self._updateView:release()
        self._updateView = nil
    end
end

-- 游戏更新完毕通知
function FriendJoinView:doUpdateFinish(shortname, err)
    -- 移除等待界面
    self:closeUpdateLoading()
    if err then
        self:showToast( err )
        return
    end
    -- 重新加入房间
    if checkstring(self._result) ~= "" and hallmanager and hallmanager:IsConnected() then
        hallmanager:JoinFriendRoomByRoomKey(self._result )
    end
end

return FriendJoinView