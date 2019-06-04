--
-- Author: 李阿城
-- Date: 2018-06-29
-- Describe：游戏列表房间

local M = class("HallGameListView", cc.load("ViewBase"))

M.RESOURCE_FILENAME = "ui/newhall/hall_game_list.lua"
M.RESOURCE_BINDING = {
    ["scroll_game"] = {["varname"] = "scroll_game"},
    ["tab_bg"]      = {["varname"] = "tab_bg"   },
    ["nd_tab"]      = {["varname"] = "nd_tab"   },
    ["btn_type"]    = {["varname"] = "btn_type" },
    ["img_back_bg"] = {["varname"] = "img_back_bg"},
    ["img_xing"] = {["varname"] = "img_xing"},

    ["btn_close"]   = {["varname"] = "btn_close",   ["events"] = {{event = "click", method = "onClickClose"}}},	 --关闭按钮
    ["btn_majiang"] = {["varname"] = "btn_majiang", ["events"] = {{event = "click", method = "onClickBtn"  }}},	 --麻将按钮
    ["btn_poker"]   = {["varname"] = "btn_poker",   ["events"] = {{event = "click", method = "onClickBtn"  }}},	 --扑克按钮
    ["btn_xiuxian"] = {["varname"] = "btn_xiuxian", ["events"] = {{event = "click", method = "onClickBtn"  }}},	 --休闲馆按钮
}
M.AUTO_RESOLUTION = true

local PG_LEFT_MARGIN = 200
local PG_RIGHT_MARGIN = 0
local PG_TOP_MARGIN = 100
local PG_BOTTOM_MARGIN = 120

-- 容器1行数量
local GAME_SV_ROW = 4
-- 容器1页数量
local GAME_SV_PAGE = 8
--按钮数据
M.BTN_DATA_TYPES = {
    BTN_DataMaJiang = "majiang",  --麻将馆
    BTN_DataPoKer = "poker",      --扑克馆
    BTN_DataXiuXian = "xiuxian",  --休闲馆
}

local GameItem = import(".NewGameIconView")

-- gameType 初始化点击的tab栏
-- showTypt 单包打包时扑克馆的显示控制：1-显示扑克类游戏，2-显示麻将类游戏，3-显示扑克和麻将游戏
function M:onCreate(gameType, showTypt)
    self._gameType = gameType or M.BTN_DATA_TYPES.BTN_DataPoKer
    self._showTypt = showTypt or 1
    self.isAddGame = false
    self:replaceRes()
    gg.GameCfgData:CheckLoaded(function()
        self:resetLayout()
        self:init()
    end)
    self:addEventListener(gg.Event.ADDED_GAME_CHANGED, handler(self, self.onEventGameListChanged))
    -- 注册断线重连事件，用于解决界面初始化时断线重连造成hallmanager对象为空的问题
    self:addEventListener(gg.Event.RECONNECT_SUCCESS, handler(self, self.onEventReconnect))
end


function M:replaceRes()
    -- 替换tab栏的图片
    if Helper.IsFileExist("hall/newhall/replace/tab_pk_1.png") then
        self.btn_poker:getChildByName("img_1"):ignoreContentAdaptWithSize(true)
        self.btn_poker:getChildByName("img_1"):loadTexture("hall/newhall/replace/tab_pk_1.png", 0)
        self.btn_poker:getChildByName("img_2"):ignoreContentAdaptWithSize(true)
        self.btn_poker:getChildByName("img_2"):loadTexture("hall/newhall/replace/tab_pk_2.png", 0)
    end

    if Helper.IsFileExist("hall/newhall/replace/tab_mj_1.png") then
        self.btn_majiang:getChildByName("img_1"):ignoreContentAdaptWithSize(true)
        self.btn_majiang:getChildByName("img_1"):loadTexture("hall/newhall/replace/tab_mj_1.png", 0)
        self.btn_majiang:getChildByName("img_2"):ignoreContentAdaptWithSize(true)
        self.btn_majiang:getChildByName("img_2"):loadTexture("hall/newhall/replace/tab_mj_2.png", 0)
    end

    if checkint(PACKAGE_TYPE) == 4 then
        self.btn_xiuxian:getChildByName("img_1"):ignoreContentAdaptWithSize(true)
        self.btn_xiuxian:getChildByName("img_1"):loadTexture("hall/newhall/hall_main3/tab_xcj_1.png", 0)
        self.btn_xiuxian:getChildByName("img_2"):ignoreContentAdaptWithSize(true)
        self.btn_xiuxian:getChildByName("img_2"):loadTexture("hall/newhall/hall_main3/tab_xcj_2.png", 0)
    elseif checkint(PACKAGE_TYPE) == 2 then
        self.btn_xiuxian:getChildByName("img_1"):ignoreContentAdaptWithSize(true)
        self.btn_xiuxian:getChildByName("img_1"):loadTexture("hall/newhall/hall_main2/tab_gdwf_1.png", 0)
        self.btn_xiuxian:getChildByName("img_2"):ignoreContentAdaptWithSize(true)
        self.btn_xiuxian:getChildByName("img_2"):loadTexture("hall/newhall/hall_main2/tab_gdwf_2.png", 0)

        self.tab_bg:loadTexture("hall/newgamelist/img_bg_2.png",0)
    end
end

function M:onEventReconnect()
    -- 断线重连回来如果界面因为丢失hallmanager对象而初始化失败，则重新初始化一次
    if self._isLostHallmgr then
        self._isLostHallmgr = false
        gg.GameCfgData:CheckLoaded(function()
            self:resetLayout()
            self:init()
        end)
    end
end

function M:init()
    -- 直接显示房间是左侧按钮面板
    if not GameApp:CheckModuleEnable(ModuleTag.Room) then
        self.nd_tab:setVisible(false)
    end

    self:updateBtn(self._gameType)
end

function M:resetLayout()
    local extW = gg.IIF(gg.isWideScreenPhone, 150, 0)

    self.svWidth = display.width - PG_LEFT_MARGIN - PG_RIGHT_MARGIN - extW
    self.svHeight = display.height - PG_TOP_MARGIN - PG_BOTTOM_MARGIN
    self.svPosX = PG_LEFT_MARGIN + self.svWidth / 2 + extW
    self.svPosY = gg.IIF(checkint(PACKAGE_TYPE) == 2, display.height / 2 - 30, display.height / 2)
    self.scroll_game:setContentSize(self.svWidth, self.svHeight)
    self.scroll_game:setPosition(cc.p(self.svPosX, self.svPosY))
    self.scaleY = math.min(display.scaleX, display.scaleY)
    self.nd_tab:setScale(self.scaleY)
    self.nd_tab:setContentSize(self.nd_tab:getContentSize().width , display.height - 80)
    self.nd_tab:setPositionY(720 - self.scaleY *720 )
    self.tab_bg:setPositionY(display.height - 90)
    if checkint(PACKAGE_TYPE) == 2 then
        self.tab_bg:setContentSize(cc.size(self.tab_bg:getContentSize().width, display.height - 80))
    end

    -- 以 1280 x 720 为标准
    self.wScale = self.svWidth / (1280 - PG_LEFT_MARGIN - PG_RIGHT_MARGIN)
    self.hScale = self.svHeight / (720 - PG_TOP_MARGIN - PG_BOTTOM_MARGIN)
    self.minScale = math.min(self.svHeight / (720 - PG_TOP_MARGIN - PG_BOTTOM_MARGIN), self.wScale)

    self._bgLayerW = self.scroll_game:getParent():getContentSize().width         -- Layer宽
    self.scroll_game:setScrollBarEnabled(false)

    -- 设置左侧按钮
    self:setLeftBtns()
end

-- 入场动画
function M:showConventionalRoom()
    -- 重置所有控件位置
    self.scroll_game:stopAllActions()
    self.scroll_game:setPositionX(self._bgLayerW * 1.65)
    -- 右侧游戏列表
    self.scroll_game:runAction(cc.MoveTo:create(0.25, cc.p(self.svPosX, self.svPosY)))
end

-- 设置左测按钮
function M:setLeftBtns()
    self._btnTb = {}
    --默认隐藏按钮
    self.btn_majiang:setVisible(false)
    self.btn_poker:setVisible(false)
    self.btn_xiuxian:setVisible(false)

    -- 吉祥tab按钮高度需要稍微降低一些
    local offsetH = gg.IIF(PACKAGE_TYPE == 2, 240, 210)
    local btnHeight = display.height - offsetH
    local hScale = display.height / 720
    -- 不同的包判断是否显示
    local isCommonGame = GameApp:IsCommonGame()
    -- 插入扑克
    self.btn_poker.tag = M.BTN_DATA_TYPES.BTN_DataPoKer
    table.insert(self._btnTb, self.btn_poker)
    -- 插入麻将
    if not isCommonGame then
        self.btn_majiang.tag = M.BTN_DATA_TYPES.BTN_DataMaJiang
        table.insert(self._btnTb, self.btn_majiang)
    end

    -- 插入休闲馆
    if (hallmanager and hallmanager:HasMiniGames()) then
        self.btn_xiuxian.tag = M.BTN_DATA_TYPES.BTN_DataXiuXian
        table.insert(self._btnTb, self.btn_xiuxian)
    else
        -- 丢失了hallmanager，造成界面初始化失败，记录标记
        self._isLostHallmgr = true
    end

    for i=1,3 do
        local line = self.nd_tab:getChildByName("img_line" .. i)
        if line then
            line:setVisible(false)
        end
    end
    -- 设置按钮位置
	for i=1,#self._btnTb do
        self._btnTb[i]:setVisible(true)
        local posY = btnHeight - ((i - 1) * 142)
        self._btnTb[i]:setPositionY(posY)

        local line = self.nd_tab:getChildByName("img_line" .. i)
        if line then
            line:setPositionY(posY - 71)
            line:setVisible(true)
        end
    end
    -- 最后一条线改为不显示
    local line = self.nd_tab:getChildByName("img_line3"):setVisible(false)
    --欢乐馆新游戏提醒图片
    if  hallmanager then
        local newminigame = hallmanager:GetNewMiniGame()

        if newminigame and #newminigame ~=0 then
            self.NewMiniGame = true
            self.img_xing:setVisible(true)
        end
    end
    --返回按钮背景
    self.img_back_bg:setPosition(cc.p(0, display.height))
    -- 左侧按钮动画
    self.nd_tab:stopAllActions()
    self.nd_tab:setPositionX(-250)
    self.nd_tab:runAction(cc.MoveTo:create(0, cc.p(0 + gg.getPhoneLeft(), 720 - self.scaleY *720 )))
end

function M:initView(noEnterAni)
    if tolua.isnull(self) then return end
    -- 丢失了hallmanager，造成界面初始化失败，记录标记
    if not hallmanager or not hallmanager:IsConnected() then
        self._isLostHallmgr = true
        return
    end

    -- 入场动画效果
    if not noEnterAni then
        self:showConventionalRoom()
    end

    -- 直接显示房间是左侧按钮面板
    if not GameApp:CheckModuleEnable(ModuleTag.Room) then
        local game = hallmanager.games[DEFAULT_GAME_ID]
        if game then
            self:createGameIcons({game})
        end
        return
    end

    if self._gameType == M.BTN_DATA_TYPES.BTN_DataMaJiang then
        -- 麻将馆游戏
        local mjGames, isNeedAdd = hallmanager:GetMaJiangGConfigGame()
        if isNeedAdd then
            self:createGameIcons(mjGames, 1)
        else
            self:createGameIcons(mjGames)
        end
    elseif self._gameType == M.BTN_DATA_TYPES.BTN_DataPoKer then
        -- 扑克馆游戏
        if GameApp:IsCommonGame() then
            -- 扑克打包显示
            local games = {}
            if self._showTypt == 1 then --扑克
                local pkGames, isPkAdd = hallmanager:GetPuKeGConfigGame()
                table.walk(checktable(pkGames), function(v) table.insert(games, v) end)
                if isPkAdd then
                    self:createGameIcons(games, 2)
                else
                    self:createGameIcons(games)
                end
            elseif self._showTypt == 2 then  --麻将
                local mjGames, isMjAdd = hallmanager:GetMaJiangGConfigGame()
                table.walk(checktable(mjGames), function(v) table.insert(games, v) end)
                if isMjAdd then
                    self:createGameIcons(games, 1)
                else
                    self:createGameIcons(games)
                end
            elseif self._showTypt == 3 then
                local pkGames, isPkAdd = hallmanager:GetPuKeGConfigGame()
                table.walk(checktable(pkGames), function(v) table.insert(games, v) end)
                local mjGames, isMjAdd = hallmanager:GetMaJiangGConfigGame()
                table.walk(checktable(mjGames), function(v) table.insert(games, v) end)
                if isPkAdd or isMjAdd then
                    self:createGameIcons(games, 3)
                else
                    self:createGameIcons(games)
                end
            end
        else
            -- 正常大厅显示
            local pkGames, isNeedAdd = hallmanager:GetPuKeGConfigGame()
            if isNeedAdd then
                self:createGameIcons(pkGames, 2)
            else
                self:createGameIcons(pkGames)
            end
        end
    elseif self._gameType == M.BTN_DATA_TYPES.BTN_DataXiuXian then
        -- 休闲馆游戏
        local miniGames = hallmanager:GetLeisureGame()
        self:createGameIcons(miniGames)

        if self.NewMiniGame then
            --设置新的游戏到本地
            self:setNewMiniGameCfg()
            self.img_xing:setVisible(false)
            GameApp:dispatchEvent(gg.Event.NEW_MINIGAME_WARN)
        end
    end
end
--设置推送的新的小游戏
function M:setNewMiniGameCfg()
    if hallmanager then
        local newlist = hallmanager:GetNewMiniGame()
        if not newlist or #newlist == 0 then
            return
        end
        local MiniGameData = checktable(gg.UserData:getConfigByKey("miniGameCfg"))
        for i=1,#newlist do
            table.insert( MiniGameData,newlist[i])
        end
        gg.UserData:SetConfigKV({["miniGameCfg"] = MiniGameData})
    end
end

-- 左侧按钮点击
function M:onClickBtn(sender)
    gg.AudioManager:playClickEffect()
    if sender == self.btn_majiang then
        self:updateBtn(M.BTN_DATA_TYPES.BTN_DataMaJiang)
    elseif sender == self.btn_poker then
        self:updateBtn(M.BTN_DATA_TYPES.BTN_DataPoKer)
    elseif sender == self.btn_xiuxian then
        self:updateBtn(M.BTN_DATA_TYPES.BTN_DataXiuXian)
    end
end

-- 按钮点击
function M:updateBtn(itype)
    if itype == M.BTN_DATA_TYPES.BTN_DataMaJiang then
        self._gameType = M.BTN_DATA_TYPES.BTN_DataMaJiang
        self.btn_type:setPositionY(self.btn_majiang:getPositionY())
    elseif itype == M.BTN_DATA_TYPES.BTN_DataPoKer then
        self._gameType = M.BTN_DATA_TYPES.BTN_DataPoKer
        self.btn_type:setPositionY(self.btn_poker:getPositionY())
    elseif itype == M.BTN_DATA_TYPES.BTN_DataXiuXian then
        self._gameType = M.BTN_DATA_TYPES.BTN_DataXiuXian
        self.btn_type:setPositionY(self.btn_xiuxian:getPositionY())
    end

    for i,btn in ipairs(self._btnTb) do
        local img_1 = btn:getChildByName("img_1")
        local img_2 = btn:getChildByName("img_2")
        local v =  btn.tag
        if v == itype then
            img_1:setVisible(false)
            img_2:setVisible(true)
        else
            img_1:setVisible(true)
            img_2:setVisible(false)
        end
    end

    gg.GameCfgData:CheckLoaded(function()
        if tolua.isnull(self) then return end
        self:initView()
    end)
end

-- addType表示添加按钮的类型，1：麻将 2：扑克
function M:createGameIcons(gamesTb, addType)
    local tb = {}
    self._gameList = {}
    -- 清除页面
    self.scroll_game:removeAllChildren()

    local fishTb = {}
    if hallmanager then
        fishTb = hallmanager:GetFishGames(checktable(gamesTb))
        if #fishTb > 1 then
            local fishGame = {}
            fishGame.name = "捕鱼合集"
            fishGame.id = GameItem.IconTag.T_FISH_GAME
            table.insert(tb, fishGame)
        end
    end

    for _,v in pairs(checktable(gamesTb)) do
        if #fishTb > 1 and (v.id == 226 or v.id == 550) then

        else
            table.insert(tb, v)
        end
    end
    -- 添加游戏按钮
    if addType and GameApp:CheckModuleEnable(ModuleTag.AddGame) then
        local addGame = {}
        addGame.name = "添加游戏"
        addGame.id = GameItem.IconTag.T_ADD_GAME
        addGame.etype = tonumber(addType)
        table.insert(tb, addGame)
    end

    local tage = GAME_SV_ROW    --默认一页 4个item 的长度
    if #tb > GAME_SV_PAGE then    --获取tage
        local idx = #tb / GAME_SV_PAGE
        local yeshu = math.floor(idx)   --取页数下线
        local count =  #tb % GAME_SV_ROW --该页的第几个
        local dataSize = #tb - GAME_SV_PAGE * yeshu  --获取值大小
        if dataSize < GAME_SV_ROW and dataSize ~= 0 then  --小于4值 不等于0 代表 改页没有满
            tage = yeshu * GAME_SV_ROW + count
        elseif dataSize >= GAME_SV_ROW and dataSize ~= 0 then --大于等于4值 不等于0 代表 改页已经满了
            tage = yeshu * GAME_SV_ROW + GAME_SV_ROW
        else  -- 不等于0 代表 已经是下一页了
            tage = yeshu * GAME_SV_ROW
        end
    end
    local extW = gg.IIF(gg.isWideScreenPhone, 70, 0)
    local svWidth = math.max(self.scroll_game:getContentSize().width, extW + 260 * tage *self.minScale)
    self.scroll_game:setInnerContainerSize({width = svWidth, height = self.scroll_game:getContentSize().height })

    local pagecount = 1 --页数  1- 8
    local rank = 0   --第几行
    local roomcount = #tb
    for i,game in ipairs(tb) do
         -- 创建
        local gameView = self:createGameView(game)
        self:createRoomPage(gameView, pagecount, rank,roomcount)
        self.scroll_game:addChild(gameView)

        if pagecount == GAME_SV_PAGE then  --每页 8个item
            pagecount = 0
            rank = rank + 1  --是否已经一页了
        end
        pagecount = pagecount + 1
    end

    if not self.isAddGame then
        self.scroll_game:jumpToPercentHorizontal(0)
    else
        self.scroll_game:jumpToPercentHorizontal(100)
        self.isAddGame = false
    end
end

-- 刷新房间Item位置
function M:createRoomPage(gameViews, pagecount, ranksize,roomcount)
    if not gameViews then
        return
    end

    -- 设置位置
    local row = math.ceil(pagecount / 4) - 1
    local rank = math.fmod(pagecount - 1, 4)
    local page = ranksize *( ( 255*self.minScale )*GAME_SV_ROW )
    gameViews:setPositionX((142* self.minScale) + (255*self.minScale)*rank + page )
    gameViews:setPositionY((355* self.hScale)-  (210* self.hScale)* row )

    if display.width / display.height == 4/3 then
        gameViews:setPositionX((142 * self.wScale) + (255* self.wScale) *rank + page )
        gameViews:setPositionY((355* self.hScale)-  (210* self.hScale)* row )
    end
end

-- 添加游戏结束重新刷新界面
function M:onEventGameListChanged()
    gg.GameCfgData:CheckLoaded(function()
        if tolua.isnull(self) then return end
        self.isAddGame = true
        self:initView(true)
    end)
end

--[[
* @brief 创建View
* @brief roomData 数据
]]
function M:createGameView(gameData)
    if not gameData then
        return
    end
    -- 创建试图
    local gameView = GameItem.new("GameItem", gameData.id, gameData)
    gameView:setScale(self.minScale)
    return gameView
end


function M:onClickClose(sender)
    self:removeSelf()
end

function M:removeSelf()
    M.super.removeSelf(self)
    GameApp:dispatchEvent(gg.Event.GAME_ROOM_BACK_TO_HALL)
end

return M