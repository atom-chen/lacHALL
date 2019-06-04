
----------------------------------------------------------------------
-- 作者：Cai
-- 日期：2018-08-24
-- 描述：吉祥创建朋友场主界面
----------------------------------------------------------------------

local M = class("JXFriendCreateFrame", cc.load("ViewPop"))

M.RESOURCE_FILENAME = "ui/room/friendroom/jx_create_rule_view.lua"
M.RESOURCE_BINDING = {
    ["img_bg"]     = {["varname"] = "img_bg"    },
    ["img_ditu"]   = {["varname"] = "img_ditu"  },
    ["nd_subview"] = {["varname"] = "nd_subview"},    -- 子界面节点
    ["lv_tab"]     = {["varname"] = "lv_tab"    },
    ["btn_close"]  = {["varname"] = "btn_close", ["events"] = {{["event"] = "click_color", ["method"] = "onClickClose"}}}, -- 关闭按钮
}
M.LAYER_ALPHA = 25

local GAME_TABLE = {}
local DDZHNames = {"ddzh", "erdz"}

function M:onCreate(shortname, enterType, clubId, managerid, clubRule, convenientTag)
    self._initShortName = shortname
    self.gameID = nil
    --是否都有3人斗地主和2人斗地主
    self.istogether = false
    self.img_bg:setScale(math.min(display.scaleX, display.scaleY))
    cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/room.plist")

    self:init(enterType, clubId, managerid, clubRule, convenientTag)
    self:initView(shortname or cc.exports.gRuleGameShortname)
    self:registerEventListener()
end

function M:getDDZHGames()
    local friendGames = hallmanager:GetAllFrientRoomGames()

    -- 检查同时存在的斗地主游戏
    local count = 0
    local ret = {}
    local togetherName = ""
    for k , v in pairs( friendGames ) do
        if Table:isValueExist(DDZHNames, v.shortname) then
            count = count + 1
            -- 先把游戏名字和短名记下来
            table.insert(ret, {name=v.name, shortName=v.shortname})

            -- 记录ddzh的游戏名称
            if v.shortname == "ddzh" then
                togetherName = v.name
            end
        end
    end

    self.istogether = count > 1
    if self.istogether then
        ret = {}
        table.insert(ret, {name=togetherName, shortName="ddzh"})
    end

    return ret
end

--[[
* @brief 获取可以创建朋友场的游戏
]]
function M:getFriendGame()
    if hallmanager and hallmanager:IsConnected() then
        GAME_TABLE = {}

        -- 先把斗地主相关游戏都加进去
        local ddzhGames = self:getDDZHGames()
        if #ddzhGames > 0 then
            for i,v in ipairs(ddzhGames) do
                table.insert(GAME_TABLE, v)
            end
        end

        if self._initShortName then
            -- 如果是从游戏房间列表界面打开创建房间界面的，且此游戏有朋友场，那么需要显示这个游戏
            local initGameInfo = hallmanager:GetGameByShortName(self._initShortName)
            if hallmanager:IsHasFriendRoom(initGameInfo.id)  then
                -- 不是斗地主相关的游戏，需要添加
                if not Table:isValueExist(DDZHNames, self._initShortName) then
                    table.insert( GAME_TABLE, {name=initGameInfo.name, shortName=self._initShortName} )
                end
            end
        end

        local friendGames = hallmanager:GetAllFrientRoomGames()
        for k , v in pairs( friendGames ) do
            if not GameApp:CheckModuleEnable(ModuleTag.Room) and DEFAULT_GAME_ID then
                -- 指定单个游戏时，只显示这么一个
                if v.id == DEFAULT_GAME_ID then
                    GAME_TABLE = {}
                    local gs = {}
                    gs.name = APP_NAME
                    gs.shortName = v.shortname
                    table.insert( GAME_TABLE , gs )
                    break
                end
            else
                -- 列表里没有的游戏且未添加过，需要添加
                if v.shortname ~= self._initShortName and (not Table:isValueExist(DDZHNames, v.shortname)) then
                    local gs = {}
                    gs.name = v.name
                    gs.shortName = v.shortname
                    table.insert( GAME_TABLE , gs )
                end
            end
        end
    end
end

function M:init(enterType, clubId, managerid, clubRule, convenientTag)
    -- 界面类型
    self._enterType = enterType or 1
    -- 好友群ID
    self._clubId = clubId or 0
    -- 群主ID
    self._managerid = managerid
    -- 上一个点击的按钮
    self._preBtn = nil
    -- 隐藏滚动条
    self.lv_tab:setScrollBarEnabled(false)
    -- 用于存储tab上的按钮
    self._tabTable = {}
    -- 用于存储子界面
    self._subViewsTb = {}

    self._clubRule = clubRule or {}

    self._convenientTag = convenientTag
    -- 获取可以创建朋友场的游戏
    self:getFriendGame()
end

function M:initView(shortname)
    self:initTab()
    local shortName = shortname
    -- 选择指定游戏
    for k, v in pairs(GAME_TABLE) do
        if v.shortName == shortName then
            self:onTabBtn(self._tabTable[k])
            self.lv_tab:jumpToItem(self.lv_tab:getIndex(self._tabTable[k]), self._tabTable[k]:getContentSize(), cc.p(0.5, 0))
        end
    end
end

-- 创建左侧按钮
function M:initTab()
    -- 获取最后点击游戏的值默认1
    local clickValue = 1
    -- 创建按钮
    for i,v in ipairs(GAME_TABLE) do
        local root = require("ui/room/friendroom/jx_tab_item.lua").create().root
        local btn = root:getChildByName("tab_btn")
        btn:removeFromParent(true)
        btn:getChildByName("txt_game"):setString(v.name)
        btn.id = v.shortName -- 用于子界面的显示
        btn:onClick(handler(self, self.onClickTabBtn))

        self.lv_tab:pushBackCustomItem(btn)
        table.insert(self._tabTable, btn)
        --获取点击游戏的值
        if self.gameID and v.shortName == self.gameID then
            clickValue = i
        end
    end

    if GameApp:CheckModuleEnable(ModuleTag.AddGame) then
        self:createAddGameBtn()
    end

    self:onTabBtn(self._tabTable[clickValue]) -- 默认点击第一个按钮
end

function M:createAddGameBtn()
    local root = require("ui/room/friendroom/jx_tab_item.lua").create().root
    local btn = root:getChildByName("tab_btn")
    btn:removeFromParent(true)
    btn:getChildByName("txt_game"):setString("添加游戏")
    btn:getChildByName("txt_game"):setTextColor(cc.c3b(136,91,23))
    local img_add = ccui.ImageView:create()
    cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/jx_room.plist")
    img_add:ignoreContentAdaptWithSize(true)
    img_add:loadTexture("hall/room/jxroom/img_add.png", 1)
    img_add:setPosition(btn:getChildByName("txt_game"):getPositionX() - btn:getChildByName("txt_game"):getContentSize().width /2 - 22,
    btn:getChildByName("txt_game"):getPositionY())
    btn:addChild(img_add)

    btn.id = "addgame" -- 用于子界面的显示
    btn:onClick(handler(self, self.onClickTabBtn))
    self.lv_tab:pushBackCustomItem(btn)
end

function M:onClickTabBtn(sender)
    gg.AudioManager:playClickEffect()
    self:onTabBtn(sender)
end

-- 左侧按钮点击事件
function M:onTabBtn(sender)
    if not sender then return end

    if sender == self._preBtn then return end
    if sender.id == "addgame" then
        self:getScene():createView("AddGameView", 3):pushInScene()
        return
    end
    self._preBtn = sender
    --获取最后点击的游戏id
    self.gameID = sender.id
    -- 设置按钮点击状态
    for i,btn in ipairs(self._tabTable) do
        local fontColor = gg.IIF(btn == sender, cc.c3b(107,37,0), cc.c3b(136,91,23))
        btn:getChildByName("txt_game"):setTextColor(fontColor)
        btn:getChildByName("img_sel"):setVisible(btn == sender)
    end

    cc.exports.gRuleGameShortname = sender.id
    -- 判断朋友场创建页面数据表格是否可以读取到
    if not self[ "subV_"..sender.id ] then
        --点击斗地主并且有二斗地主时显示的界面
        if checkstring(sender.id) == "ddzh" and self.istogether then
            self[ "subV_"..sender.id ] = self:getScene():createView("jxroom.JXFriendDdzhNode", self._initShortName, self._enterType, self._clubId, self._managerid,self._clubRule, self._convenientTag)
        else
            self[ "subV_"..sender.id ] = self:getScene():createView("jxroom.JXFriendRuleNode", sender.id, self._enterType, self._clubId, self._managerid,self._clubRule, self._convenientTag)
        end
        self.nd_subview:addChild( self[ "subV_"..sender.id ] )
        table.insert( self._subViewsTb, self[ "subV_"..sender.id ] )
    end

    -- 显示选择的游戏规则子界面,隐藏其他子界面
    for i,v in ipairs(self._subViewsTb) do
        v:setVisible(v == self["subV_"..sender.id])
    end
end

--初始化朋友场游戏列表
function M:initFriendGameList()
    -- 清除数据
    GAME_TABLE=nil
    --用于存储tab上的按钮
    self._tabTable = nil
    self._tabTable = {}
    -- 获取可以创建朋友场的游戏
    self:getFriendGame()
    --清除tab
    self.lv_tab:removeAllChildren()
    --创建左侧按钮
    self:initTab()
end

function M:onClickClose()
    self:removeSelf()
end

-- 注册通知
function M:registerEventListener()
    self:addEventListener(gg.Event.ADDED_GAME_CHANGED, handler(self, self.onEventAddedGameChanged))
    self:addEventListener(gg.Event.HALL_UPDATE_GAMELIST, handler(self, self.onEventAddedGameChanged))
    self:addEventListener(gg.Event.ROOM_JOIN_NOTIFY, handler(self, self.onEventRoomJoinNotify))
    -- 代开房间回调
    self:addEventListener(gg.Event.HALL_CREATE_ROOM_REPLY, handler(self, self.onEventDaiKaiRoom))
    -- 游戏需要更新通知
    self:addEventListener("event_game_update_progress_changed", handler(self, self.onEventGameUpdateProgress))
    -- 游戏更新完毕通知
    self:addEventListener("event_game_update_finish", handler(self, self.onEventGameUpdateFinish))
end

-- 代开房间应答
function M:onEventDaiKaiRoom(event, roomkey, credit_user)
    if checkint(credit_user) ~= 1 then
        printf( "代开房间回调" )
        cc.exports.BISAI_ROOM_ROOMKEY = roomkey
    end
end

-- 加入房间成功通知
function M:onEventRoomJoinNotify()
    self:removeSelf()
end

function M:onEventAddedGameChanged()
    self:initFriendGameList()
end

-- 游戏更新
function M:onEventGameUpdateProgress(event, percent, shortname)
    if self.istogether and (shortname == "ddzh" or shortname == "erdz") then
        if self["subV_ddzh"] and self["subV_ddzh"].doUpdateProgress then
            self["subV_ddzh"]:doUpdateProgress(percent, shortname)
        end
    elseif self["subV_" .. shortname] and self["subV_" .. shortname].doUpdateProgress then
        self["subV_" .. shortname]:doUpdateProgress(percent, shortname)
    end
end

function M:onEventGameUpdateFinish(event, shortname, err)
    if self.istogether and (shortname == "ddzh" or shortname == "erdz") then
        if self["subV_ddzh"] and self["subV_ddzh"].doUpdateProgress then
            self["subV_ddzh"]:doUpdateFinish(shortname, err)
        end
    elseif self["subV_" .. shortname] and self["subV_" .. shortname].doUpdateFinish then
        self["subV_" .. shortname]:doUpdateFinish(shortname, err)
    end
end

return M
