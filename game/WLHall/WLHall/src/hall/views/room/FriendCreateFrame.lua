
----------------------------------------------------------------------
-- 作者：Cai
-- 日期：2017-03-15
-- 描述：创建朋友场主界面
----------------------------------------------------------------------

local FriendCreateFrame = class("FriendCreateFrame", cc.load("ViewBase"))

FriendCreateFrame.RESOURCE_FILENAME = "ui/room/friendroom/create_rule_hallview.lua"

FriendCreateFrame.RESOURCE_BINDING = {
    ["img_bg"]      = { ["varname"] = "img_bg"     },
    ["img_ditu"]    = { ["varname"] = "img_ditu"   },
    ["nd_subview"]  = { ["varname"] = "nd_subview" },    -- 子界面节点
    ["lv_tab"]      = { ["varname"] = "lv_tab"     },
}

local GAME_TABLE = {}
local DDZHNames = { "ddzh", "erdz" }

function FriendCreateFrame:onCreate( shortname )
    self._initShortName = shortname
    self.gameID = nil
    --是否都有3人斗地主和2人斗地主
    self.istogether = false
    
    self:init()
    self:initView( shortname or cc.exports.gRuleGameShortname )
    self:registerEventListener()
end

-- 注册通知
function FriendCreateFrame:registerEventListener()
    self:addEventListener( gg.Event.ADDED_GAME_CHANGED, handler( self, self.onEventAddedGameChanged ) )
    self:addEventListener(gg.Event.HALL_UPDATE_GAMELIST, handler(self, self.onEventAddedGameChanged))
end

function FriendCreateFrame:onEventAddedGameChanged()
    self:initFriendGameList()
end

function FriendCreateFrame:getDDZHGames()
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
function FriendCreateFrame:getFriendGame()
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

function FriendCreateFrame:init()
    -- 上一个点击的按钮
    self._preBtn = nil
    -- 隐藏滚动条
    self.lv_tab:setScrollBarEnabled(false)
    -- 用于存储tab上的按钮
    self._tabTable = {}
    -- 用于存储子界面
    self._subViewsTb = {}
    -- 获取可以创建朋友场的游戏
    self:getFriendGame()
end

function FriendCreateFrame:initView( shortname )
    self:initTab()
    local shortName = shortname
    -- 选择指定游戏
    for k , v in pairs( GAME_TABLE ) do
        if v.shortName == shortName then
            self:onTabBtn(self._tabTable[k])
            self.lv_tab:jumpToItem( self.lv_tab:getIndex(self._tabTable[k]) , self._tabTable[k]:getContentSize() , cc.p( 0.5 , 0  ) )
        end
    end
end

-- 创建左侧按钮
function FriendCreateFrame:initTab()
    -- 获取最后点击游戏的值默认1
    local clickValue = 1
    -- 创建按钮
    for i,v in ipairs(GAME_TABLE) do
        local root = require("ui/room/friendroom/item_game_tab.lua").create().root 
        local btn = root:getChildByName("tab_btn")
        btn:removeFromParent(true)
        btn:getChildByName("txt_game"):setString(v.name)
        btn.id = v.shortName -- 用于子界面的显示
        btn:onClick(handler(self, self.onClickTabBtn))
        if hallmanager and hallmanager:IsConnected() then
            local game = hallmanager:GetGameByShortName(v.shortName)
            if game and game.shell then
                local img_icon = btn:getChildByName("img_icon")
                local url = APP_ICON_PATH .. game.shell .. ".png"
                gg.ImageDownload:LoadHttpImageAsyn(url, img_icon)
            end
        end

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

function FriendCreateFrame:createAddGameBtn()
    local root = require("ui/room/friendroom/item_game_tab.lua").create().root 
    local btn = root:getChildByName("tab_btn")
    btn:removeFromParent(true)
    btn:getChildByName("txt_game"):setString("添加游戏")
    btn:getChildByName("txt_game"):setTextColor(cc.c3b(255 ,255 ,255))
    cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/room.plist")
    btn:getChildByName("img_icon"):ignoreContentAdaptWithSize(true)
    btn:getChildByName("img_icon"):loadTexture("hall/room/friend/img_venue_add.png", 1)
    btn.id = "addgame" -- 用于子界面的显示
    btn:onClick(handler(self, self.onClickTabBtn))
    self.lv_tab:pushBackCustomItem(btn)
end

function FriendCreateFrame:onClickTabBtn(sender)
    gg.AudioManager:playClickEffect()
    self:onTabBtn(sender)
end

-- 左侧按钮点击事件
function FriendCreateFrame:onTabBtn(sender)
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
        local fontColor = gg.IIF(btn == sender, cc.c3b(119,51,51), cc.c3b(255,255,255))
        btn:getChildByName("txt_game"):setTextColor(fontColor)
        btn:getChildByName("img_sel"):setVisible(btn == sender)
    end

    cc.exports.gRuleGameShortname = sender.id
    -- 判断朋友场创建页面数据表格是否可以读取到
    if not self[ "subV_"..sender.id ] then
        --点击斗地主并且有二斗地主时显示的界面
        if checkstring(sender.id) == "ddzh" and self.istogether then
            self[ "subV_"..sender.id ] = self:getScene():createView("room.FriendDdzhNode", self._initShortName )
        else
            self[ "subV_"..sender.id ] = self:getScene():createView("room.FriendRuleNode", sender.id )
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
function FriendCreateFrame:initFriendGameList()
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

-- 游戏更新
function FriendCreateFrame:doUpdateProgress(percent, shortname)
    if self.istogether and (shortname == "ddzh" or shortname == "erdz") then
        if self["subV_ddzh"] and self["subV_ddzh"].doUpdateProgress then
            self["subV_ddzh"]:doUpdateProgress(percent, shortname)
        end
    elseif self["subV_" .. shortname] and self["subV_" .. shortname].doUpdateProgress then
        self["subV_" .. shortname]:doUpdateProgress(percent, shortname)
    end
end

function FriendCreateFrame:doUpdateFinish(shortname, err)
    if self.istogether and (shortname == "ddzh" or shortname == "erdz") then
        if self["subV_ddzh"] and self["subV_ddzh"].doUpdateProgress then
            self["subV_ddzh"]:doUpdateFinish(shortname, err)
        end
    elseif self["subV_" .. shortname] and self["subV_" .. shortname].doUpdateFinish then
        self["subV_" .. shortname]:doUpdateFinish(shortname, err)
    end
end

return FriendCreateFrame
