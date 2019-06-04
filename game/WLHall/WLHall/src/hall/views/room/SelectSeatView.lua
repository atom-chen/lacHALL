
-- Author: zhangbin
-- Date: 2017-12-13
-- Describe：朋友场选择座位

local SelectSeatView = class("SelectSeatView", cc.load("ViewBase"))

SelectSeatView.AUTO_RESOLUTION = true
SelectSeatView.RESOURCE_FILENAME = "ui/room/friendroom/select_seat_layer.lua"
SelectSeatView.RESOURCE_BINDING = {

    ["layer_touch"] = { ["varname"] = "layer_touch" },
    ["img_desk"]  = { ["varname"] = "img_desk" },
    ["title"]    = { ["varname"] = "title" },
    ["main_bg"]    = { ["varname"] = "main_bg" },
    ["img_bg"]    = { ["varname"] = "img_bg" },                                                                          -- 背景
    ["img_shadow"] = {["varname"] = "img_shadow"},
    ["img_green"]  = {["varname"] = "img_green" },
    ["img_arrow"]  = {["varname"] = "img_arrow" },
}

--[[
* @brief 创建
]]
function SelectSeatView:onCreate( ... )

    -- 初始化
    self:init(...)

    -- 初始化View
    self:initView()

    -- 初始化 UI 事件
    self:initTouchEvent()

    -- 注册消息通知
    self:registerEventListener()

end

--[[
* @brief 返回键回调
]]
function SelectSeatView:keyBackClicked()

    local ret,remove=SelectSeatView.super.keyBackClicked(self)
    if ret and remove then
        if hallmanager and hallmanager:IsConnected() then
            hallmanager:ExitRoom()
        end
    end
    return ret,remove
end

--[[
* @brief 初始化
* @param playerInfos 玩家信息
* @param players 玩家数
]]
function SelectSeatView:init( playerInfos , players , roomKey, isPuKe )

    self._playerCount = players      -- 玩家数
    self._roomKey = roomKey          -- 房间号
    self._isPuKe = isPuKe            -- 是否扑克游戏

    self._playerInfos = checktable(playerInfos)  -- 玩家信息表
end

--[[
* @brief 初始化View
]]
function SelectSeatView:initView()
    -- 分辨率适配    
    self.layer_touch:setContentSize(cc.size(display.width, display.height))
    local offsetX = gg.IIF(gg.isWideScreenPhone, display.width * 0.035, 0)
    self.img_bg:setContentSize(cc.size(self.img_bg:getContentSize().width + offsetX, display.height))
    self.img_shadow:setContentSize(cc.size(self.img_shadow:getContentSize().width, display.height))
    self.img_green:setContentSize(cc.size(self.img_green:getContentSize().width, display.height))
    self.img_arrow:setPositionY(self.img_bg:getContentSize().height / 2)
    self.title:setPositionY(display.height - 66)
    self.title:setPositionX(self.img_bg:getContentSize().width / 2 - offsetX)
    self.main_bg:setPositionY(display.cy)
    self.main_bg:setPositionX(self.img_bg:getContentSize().width / 2 - offsetX)

    -- 如果是扑克游戏，需要更换桌子图片
    if self._isPuKe then
        self.img_desk:loadTexture("hall/room/friend/desk_puke.png", 1)
    end

    -- 先隐藏所有的玩家名字和头像边框
    for i=1,4 do
        local nameNode = self.main_bg:getChildByName("name_"..i)
        nameNode:setVisible(false)
        local frameNode = self.main_bg:getChildByName("avatar_frame_"..i)
        frameNode:setVisible(false)
    end

    -- 如果是 3 人的话，调整座位按钮的位置，并隐藏第4个座位
    local mainBGPosY = 0
    if self._playerCount == 3 then
        local seat4 = self.main_bg:getChildByName("seat_4")
        local seat3 = self.main_bg:getChildByName("seat_3")
        seat3:setPosition(seat4:getPosition())
        seat4:setVisible(false)

        local frame3 = self.main_bg:getChildByName("avatar_frame_3")
        local frame4 = self.main_bg:getChildByName("avatar_frame_4")
        frame3:setPosition(frame4:getPosition())

        local name4 = self.main_bg:getChildByName("name_4")
        local name3 = self.main_bg:getChildByName("name_3")
        name3:setPosition(name4:getPosition())
        mainBGPosY = 50
    end

    -- 刷新玩家信息
    self:updatePlayers(self._playerInfos)

    -- 弹出动画
    local moveTime = 0.3
    self.img_bg:setPositionX(display.width + self.img_bg:getContentSize().width)
    local move = cc.EaseSineOut:create( cc.MoveTo:create( moveTime , cc.p(  display.width , self.img_bg:getPositionY())) )
    self.img_bg:runAction(  move  )
end

--[[
* @brief 初始化 UI 事件
]]
function SelectSeatView:initTouchEvent()
    self.layer_touch:setTouchEnabled(true)
    self.layer_touch:onClick( function()
        self:keyBackClicked()
    end)

    for i=1,4 do
        local seatNode = self.main_bg:getChildByName("seat_"..i)
        seatNode:setTag(i-1)
        seatNode:onClickDarkEffect(handler(self, self.onClickSelect))
    end
end

--[[
* @brief 注册消息
]]
function SelectSeatView:registerEventListener()
    self:addEventListener(gg.Event.CLOSE_SELECT_SEAT_NOTIFY, handler(self, self.doCloseView) )
end

function SelectSeatView:doCloseView(event, exitRoom)
    if exitRoom then
        self:keyBackClicked()
    else
        self:removeSelf()
    end
end

function SelectSeatView:getChairInfo(chairID)
    for k, v in pairs( self._playerInfos ) do
        if chairID == v.chairID + 1 then
            return v
        end
    end

    return nil
end

--[[
* @brief 更新玩家数据
]]
function SelectSeatView:updatePlayers(playerInfos)
    self._playerInfos = playerInfos
    for i=1, self._playerCount do
        local info = self:getChairInfo(i)
        self:updateSeatInfo(i, info )
    end
end

--[[
* @brief 刷新座位数据
* @param playerInfo 玩家信息
]]
function SelectSeatView:updateSeatInfo(idx, playerInfo)
    playerInfo = checktable(playerInfo)

    local avatarNode = self.main_bg:getChildByName("seat_"..idx)
    local nameNode = self.main_bg:getChildByName("name_"..idx)
    local frameNode = self.main_bg:getChildByName("avatar_frame_"..idx)
    if Table:length(playerInfo) == 0 then
        -- 座位是空的，隐藏玩家名字和头像
        nameNode:setVisible(false)
        frameNode:setVisible(false)
        local clipNode = avatarNode:getChildByName("ClipNode")
        if clipNode then
            clipNode:setVisible(false)
        end
        return
    end

    -- 显示玩家名字
    nameNode:setVisible(true)
    local str = gg.SubUTF8StringByWidth(playerInfo.nickName, 160, 26 )
    nameNode:setString(str or "")

    -- 显示玩家头像
    avatarNode:setTouchEnabled(false)
    local clipNode = avatarNode:getChildByName("ClipNode")
    local img_avatar
    if clipNode then
        img_avatar = clipNode:getChildByName("user_avatar")
    else
        img_avatar = gg.createAvatarUI(avatarNode, "hall/room/friend/avatar_bg.png")
        clipNode = img_avatar:getParent()
        clipNode:setName("ClipNode")
        local oldPosY = clipNode:getPositionY()
        clipNode:setPositionY(oldPosY + 3)
    end

    frameNode:setVisible(true)
    clipNode:setVisible(true)
    local avatarPath = gg.IIF(checkint(playerInfo.sex) == 1, "common/hd_male.png", "common/hd_female.png")
    img_avatar:loadTexture(avatarPath)
    if playerInfo.avatarUrl and playerInfo.avatarUrl ~= "" then
        gg.ImageDownload:LoadUserAvaterImage({url=playerInfo.avatarUrl,ismine=false,image=img_avatar})
    end
end

--[[
* @brief 关闭按钮
]]
function SelectSeatView:onClickClose( sender )
    self:keyBackClicked()
end

--[[
* @brief 选择座位
]]
function SelectSeatView:onClickSelect( sender )
    if hallmanager and hallmanager:IsConnected() then
        local roomManager = hallmanager:GetRoomManager()
        if roomManager then
            roomManager:JoinGroup( self._roomKey , nil , sender:getTag() )
            GameApp:dispatchEvent(gg.Event.SHOW_LOADING, "正在连接游戏...")
        end
    end
end

return SelectSeatView
