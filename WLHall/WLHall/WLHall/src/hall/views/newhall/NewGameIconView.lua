-- Author: Cai
-- Date: 2018-03-15
-- Describe：游戏图标

local M = class("NewGameIconView", cc.load("ViewLayout"))
M.RESOURCE_FILENAME = "ui/hall/game_list_item_node.lua"
M.RESOURCE_BINDING = {
    ["txt_name"]    = {["varname"] = "txt_name"   },       -- 名字
    ["nd_limit"]    = {["varname"] = "nd_limit"   },       -- 豆豆限制节点
    ["txt_limit"]   = {["varname"] = "txt_limit"  },       -- 豆豆限制文本
    ["txt"]         = {["varname"] = "txt"        },
    ["panel"]       = {["varname"] = "panel"      },       -- 背景层
    ["txt_person"]  = {["varname"] = "txt_person" },
    ["img_bj"]      = {["varname"] = "img_bj"     },       -- 背景
    ["action_node"] = {["varname"] = "action_node"},
    ["img_head"]    = {["varname"] = "img_head"   },
    ["img_bk"]      = {["varname"] = "img_bk", ["events"] = {{event = "click_color", method = "onClick"}}},
}
-- 标识
M.IconTag = {
    T_ADD_GAME = -1,    -- 添加游戏
    T_FISH_GAME = -2,   -- 捕鱼合集
}

function M:onCreate(tag, data, uicon)
    -- 注册消息通知
    self:registerEventListener()
    self._clicked = nil
    self._uicon = uicon

    self.img_bj:loadTexture(CUR_PLATFORM .. "/new_icon_default.png", 0)
    self:init(tag, data)
    self:initView()
    -- 添加进入退出监听
    self:enableNodeEvents()

    if(not self._clicked) and self._ishot then
        self:startIcoAction()
    end
end

function M:onEnter()
    local GameDownloader = require("update.GameDownloader")
    -- 默认隐藏下载进度
    self.panel:setVisible((GameDownloader:IsInDownloadQueue(self._shortname)))
end

function M:onExit()
    if CLICKED_GAME_ICON and CLICKED_GAME_ICON == self then
        CLICKED_GAME_ICON = nil
    end
end

function M:init(tag, data)
    self._tag = tag
    self._data = data
    self._shortname = data.shortname
    self._ishot = checkint(checktable(data.cmd).hot) == 1
    self._progress = nil
end

function M:initView()
    self.img_bk:retain()
    self.img_bk:removeFromParent(true)
    self:addChild(self.img_bk)
    self.img_bk:release()
    self:setContentSize(cc.size(245, 193))

    -- 隐藏动画节点
    self.action_node:setVisible(false)
    self.animation = self.resourceNode_["animation"]
    self:runAction(self.animation)

    -- 设置游戏图标
    self:setGameIcon()
    if self._tag ~= M.IconTag.T_ADD_GAME and self._tag ~= M.IconTag.T_FISH_GAME then
        if Helper.And(self._data.type, GAME_GROUP_LEISURE) ~= 0 then
            self.img_head:setVisible(false)
            self.txt_person:setVisible(false)
        else
            --设置房间人数
            self:getGameNumber()
        end
    end
    -- 添加进度条
    self:addProgress()
end

--获取游戏人数
function M:getGameNumber()
    if tolua.isnull(self) then return end

    local roomlist = {}
    --添获取游戏的房间
    for k, v in pairs(hallmanager.rooms) do
        local gameInfo = hallmanager.games[checkint(v.gameid)]
        if gameInfo and gameInfo.id and gameInfo.id == self._tag then
            local data = clone(v)
            table.insert(roomlist, data)
        end
    end

    roomlist = self:setMapRoomPlayerNum(roomlist)

    local number = 0
    for k, v in pairs(roomlist) do
        local roomData = v
        local needShow = true
        if roomData.cmd.cn then
            -- 房间限制指定的渠道才能显示，判断渠道
            local cnList = string.split(roomData.cmd.cn, ",")
            needShow = Table:isValueExist(cnList, CHANNEL_ID)
        elseif roomData.cmd.ncn then
            -- 房间限制指定的渠道不显示，判断渠道
            local ncnList = string.split(roomData.cmd.ncn, ",")
            needShow = (not Table:isValueExist(ncnList, CHANNEL_ID))
        end

        local level = gg.GetRoomLevel(roomData.type)
        local LVIndex = level
        if level == ROOM_TYPE_LEVEL_3 and Helper.And(roomData.type, 0x8000) ~= 0 then
            -- 至尊场
            LVIndex = 4
        end

        -- 判断是否是防作弊房间和自由落座房间(cmd 中有 awardType 的是比赛房间，需要排除)
        -- cmd 中 hide 不为 0，不显示在房间列表
        -- 如果hide不为0，但是是混房间的，仍要将房间人数计算在内
        local roomType = gg.GetRoomMode(roomData.type)
        if needShow and checkint(roomData.cmd.hide) == 0 and
        (roomType == ROOM_TYPE_ALLOCSIT or roomType == ROOM_TYPE_ALLOCSIT2 or roomType == ROOM_TYPE_FREE_MODE) then
            local playersNum = checkint(roomData.players)

            if roomData.mixplayers then
                -- 根据房间级别模拟计算房间人数
                local rate = (100 - LVIndex * 15) / 100
                playersNum = checkint(roomData.mixplayers * rate)
            end

            if playersNum < 100 then
                math.randomseed(socket:gettime())
                playersNum = math.random(100, 200)
            end
            number =  number + playersNum
        end
    end

    if number < 100 then
        math.randomseed(socket:gettime())
        number = math.random(100, 200)
    end

    --设置房间人数
    self.txt_person:setString(number)

    local txt_count_half = self.txt_person:getContentSize().width/2
    self.img_head:setPosition(cc.p(self.img_bk:getContentSize().width/2 - txt_count_half - 4 , 32))
    self.txt_person:setPosition(cc.p(self.img_head:getPositionX()+self.img_head:getContentSize().width/2 + 8 ,32 ))
end

-- 将混房间的人数记录到映射房间
function M:setMapRoomPlayerNum(roomList)
    local mixedRoomTb = {}
    -- 移除混房间，获取混房间数据
    for i = #checktable(roomList), 1, -1 do
        local mrl = checktable(roomList[i].cmd).mrl
        if mrl then
            mixedRoomTb[roomList[i].id] = roomList[i]
            table.remove(roomList, i)
        end
    end
    
    if mixedRoomTb and table.nums(mixedRoomTb) > 0 then
        for k,v in pairs(checktable(roomList)) do
            local mixedRoomId = checktable(v.cmd).mr
            if mixedRoomId then
                if not mixedRoomTb[tonumber(mixedRoomId)] then
                    print("映射的混房间出错，请检查房间配置，房间id：" .. checkint(v.id))
                else
                    v.mixplayers = checktable(mixedRoomTb[tonumber(mixedRoomId)]).players
                end                
            end
        end
    end

    return roomList
end

-- 显示动画节点并播放动画
function M:startIcoAction()
    self.action_node:setVisible(true)
    if self.animation then
        self.animation:play("icon_anim", true)
    end
end

-- 隐藏动画节点，并停止动画
function M:endIcoAction()
    self.action_node:setVisible(false)
    if self.animation then
        self.animation:stop()
    end
end

-- 添加进度条
function M:addProgress()
    local progress = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("hall/newgamelist/loading_circle_1.png"))
    progress:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
    self.panel:addChild(progress)
    local ps = self.panel:getContentSize()
    progress:setPosition(cc.p(ps.width / 2, ps.height / 2))
    self._progress = progress
    -- 设置进度
    self:setSchedule(0)
end

-- 设置进度条进度
function M:setSchedule(p)
    if self._progress then
        self._progress:setPercentage(p)
    end
    local str = gg.IIF(p == 0, "等待", string.format("%d%%", p))
    self.txt:setString(str)
end

-- 设置游戏图标
function M:setGameIcon()
    -- 设置游戏图标
    local iconPath = nil
    local gameName = nil
    if self._tag == M.IconTag.T_ADD_GAME then
        iconPath = "hall/newgamelist/img_add.png"
        self.txt_name:setVisible(false)
        self.txt_person:setVisible(false)
        self.img_head:setVisible(false)
    end

    if self._tag == M.IconTag.T_FISH_GAME then
        iconPath = "hall/newgamelist/img_fish.png"
        self.txt_name:setVisible(false)
        self.txt_person:setVisible(false)
        self.img_head:setVisible(false)
    end

    if self._uicon then
        iconPath = self._uicon
        self.txt_name:setVisible(false)
        self.txt_person:setVisible(false)
        self.img_head:setVisible(false)
    end

    if iconPath then
        self.img_bj:loadTexture(iconPath, 1)
    else
        -- 如果存在lico字段，则直接读取lico设置的图片
        if self._data.cmd and self._data.cmd.lico then
            iconPath = APP_ICON_PATH .. self._data.cmd.lico .. ".png"
        elseif self._data.shell then
            -- 文字显示类型游戏icon在原icon的图片名字上追加后缀“_l”
            iconPath = APP_ICON_PATH .. self._data.shell .. "_l.png"
        end

        if iconPath then
            gg.ImageDownload:LoadHttpImageAsyn(iconPath, self.img_bj, function()
                if tolua.isnull(self) then return end
                self.txt_name:setVisible(false)
            end)
        end
    end

    if self._data.name then
        gameName = self._data.name
    end
    if gameName then
        local zz = #gameName
        if #gameName >= 18 then
            self.txt_name:setFontSize(39)
        end
        self.txt_name:setString(gameName)
    end

    -- 欢乐馆游戏且不是H5游戏，显示多少豆入
    -- 2018-09-26 增加命令行配置srl类游戏不显示多少豆入
    if self._data.type and Helper.And(self._data.type, GAME_GROUP_LEISURE) ~= 0 and checkint(checktable(self._data.cmd).h5) ~= 1
    and checkint(checktable(self._data.cmd).srl) ~= 1 then
        local roomid = hallmanager:GetLeisureRoomByGameId(self._data.id)
        if roomid then
            local room = hallmanager.rooms[roomid]
            if room and room.minmoney and room.minmoney > 0 then
                local tipStr = String:numToZn(room.minmoney, 4, 0) .. "豆入"
                self.txt_limit:setString(tipStr)
                self.nd_limit:setVisible(true)
                self.nd_limit:getChildByName("img_line_2"):setPositionX(self.txt_limit:getPositionX() - self.txt_limit:getContentSize().width - 5)

                -- 2018-8-10 图标替换，文本修改为居中处理
                local dis = self.txt_limit:getContentSize().width / 2 + 34
                self.nd_limit:setPositionX(self:getContentSize().width / 2 + dis)
                self.nd_limit:setPositionY(self.nd_limit:getPositionY() - 5)
            end
        end
    end
end

-- 点击事件
function M:onClick()
    gg.AudioManager:playClickEffect()
    self:doIconClick()
end

function M:doIconClick()
    -- 清除之前记录的点击对象
    cc.exports.CLICKED_GAME_ICON = nil

    if self._ishot then
        -- 非活动图标，点击后停止动画
        self._clicked = true
        self:endIcoAction()
    end

    if self._tag == M.IconTag.T_ADD_GAME then
        local idx = tonumber(self._data.etype)
        self:getScene():createView("AddGameView", idx):pushInScene()
        return
    end

    if self._tag == M.IconTag.T_FISH_GAME then
        self:getScene():createView("newhall.HallFishGamesView"):pushInScene()
        return
    end

    if hallmanager and hallmanager.games then
        -- 检测游戏的命令行参数限制参数
        local cmdmsg = hallmanager:CheckGameCmdLimit(self._data)
        if cmdmsg then
            GameApp:dispatchEvent(gg.Event.SHOW_TOAST, cmdmsg)
            return
        end

        -- h5小游戏
        if self._data.cmd and checkint(self._data.cmd.h5) == 1 and self._data.cmd.appid then
            gg.WebGameCtrl:openGameWebView(self._data.cmd.appid, self._data.id)
            if self._clickCallback then
                self._clickCallback()
            end
            return
        end

        -- 检查游戏是否需要更新
        local isNeedUpdate, msg = hallmanager:CheckGameNeedUpdate(self._data)
        local serverVer = checkint(self._data.version)
        if isNeedUpdate and serverVer == 0 then
            -- 需要更新，但是服务器并没有游戏版本
            local theUrl = self._data.cmd.openurl
            if theUrl and #theUrl then
                -- 如果游戏的 cmd 中配置了 openurl，那么直接打开相应的网页
                -- 用于为其他游戏倒量，比如：捕鱼
                device.openURL(Url:addParams(theUrl, {channel_id=CHANNEL_ID}))
                return
            else
                -- 提示游戏在开发中
                GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "攻城狮正在加班加点开发,敬请期待")
                print("游戏的最新版本是 0，无法下载")
                return
            end
        end

        if isNeedUpdate then
            -- 需要更新的时候再记录点击的游戏图标对象
            cc.exports.CLICKED_GAME_ICON = self
            -- 显示更新
            self.panel:setVisible(true)
            hallmanager:DoUpdateGame(self._data)
            return
        end
        -- 如果游戏有自定义入口文件，调用之
        local customEntrance = hallmanager:getGameCustomEntrance(self._data)
        if customEntrance then
            dofile(customEntrance)
        else
            if Helper.And(self._data.type, GAME_GROUP_LEISURE) ~= 0  then
                --显示房间列表
                if self._data.cmd and checkint(self._data.cmd.srl) == 1 then
                    hallmanager:JoinGame(self._data.id)
                else
                    -- 休闲类小游戏根据游戏找到对应的房间直接加入，如果没有则提示敬请期待
                    local roomid = hallmanager:GetLeisureRoomByGameId(self._data.id)
                    if not roomid then
                        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "攻城狮正在加班加点开发,敬请期待")
                        print("游戏服务器没有启动，没有房间。。。")
                        return
                    end
                    self:joinGameRoom(roomid)
                end
            else
                hallmanager:JoinGame(self._data.id)
            end
        end

        if self._clickCallback then
            self._clickCallback()
        end
    end
end

function M:joinGameRoom(roomid)
    if hallmanager and hallmanager:IsConnected() then
        if hallmanager:IsInFriendRoom() then return end
        hallmanager:JoinRoom(roomid, false)
    end
end

function M:setClickCallback(callback)
    self._clickCallback = callback
end

----------------------------------------------
-- 注册通知
----------------------------------------------
function M:registerEventListener()
    -- 更新完成
    GameApp:addEventListener("event_game_update_finish", handler(self,self.onEventUpdateFinish), self)
    -- 更新进度
    GameApp:addEventListener("event_game_update_progress_changed", handler(self, self.onEventUpdateChanged), self)
    -- 更新房间人数
    GameApp:addEventListener(gg.Event.HALL_UPDATE_UPDATE_ROOM_PLAYERS, handler(self, self.getGameNumber), self)
end

-- 更新完成
function M:onEventUpdateFinish(event, shortname, error_)
    if self._shortname == shortname then
        -- 隐藏并且重置进度
        self.panel:setVisible(false)
        self:setSchedule(0)
        -- 如果是准备进入的游戏短名，则下载完成后需要再模拟一次点击事件
        if CLICKED_GAME_ICON and CLICKED_GAME_ICON == self and not error_ then
            self:doIconClick()
        end
    end
end

-- 更新进度
function M:onEventUpdateChanged(event, p, shortname)
    if self._shortname == shortname then
        self:setSchedule(p)
        self.panel:setVisible(true)
    end
end

return M