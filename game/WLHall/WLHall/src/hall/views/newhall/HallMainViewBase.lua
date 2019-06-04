--
-- Author: Cai
-- Date: 2018-06-28
-- Describe：大厅主界面基础封装

local M = class("HallMainViewBase", cc.load("ViewBase"))
M.AUTO_RESOLUTION = true

-- 创建骨骼动画
function M:createSpineAni(jsonPath, atlasPath, params)
    if not gg.CanUseSpine() or not Helper.IsFileExist(jsonPath) then
        return nil
    end
    params = checktable(params)
    local ani = sp.SkeletonAnimation:create(jsonPath, atlasPath, 1)
    -- 设置动画位置
    if params.pos then
        ani:setPosition(params.pos)
    end
    --设置动画的名字
    if params.aniName then
        ani:setAnimation(0, params.aniName, true)
    end

    return ani
end

-- 设置按钮图片
function M:setBtnImg(btn, imgpath)
    btn:loadTextureNormal(imgpath, 0)
    btn:loadTexturePressed(imgpath, 0)
    btn:loadTextureDisabled(imgpath, 0)
end

-- 设置大厅背景是否虚化
function M:setHallBlurBg(isBlur)
    local bgv = self:getScene():getChildByName("BackgroundView")
    if bgv and bgv.showBlurBg then
        bgv:showBlurBg(isBlur)
    end
end

-- 服务端是否包含斗地主
function M:haveDDZGame()
    if not hallmanager or not hallmanager.games then return false end
    for k, v in pairs(hallmanager.games) do
        if v.shortname == "ddzh" and hallmanager:isNumOfGamesEnough(v.id) then
            return true
        end
    end
    return false
end

-- 添加进度条
function M:addProgress(node, params)
    params = checktable(params)
    local pos = params.pos or cc.p(node:getContentSize().width / 2, node:getContentSize().height / 2)
    local imgPro = params.img or "hall/common/loading_circle.png"

    local progress = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName(imgPro))
    progress:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
    progress:setPosition(pos)
    progress:setName("progress")
    node:addChild(progress)
    -- 初始化进度条
    self:setDownloadProgress(0, progress)

    return progress
end

-- 设置进度条进度
function M:setDownloadProgress(p, progress)
    if not progress then return end
    progress:setPercentage(p)
    local pro = gg.IIF(p == 0, "等待", string.format("%d%%", p))
    local node = progress:getParent()
    node:getChildByName("txt_progress"):setString(pro)
end

-- 加入比赛房间(未处理更新事件，更新操作请在子界面自行完成)
function M:joinMatchRoom()
    if not hallmanager or not hallmanager.games then return end
    local game = hallmanager:GetGameByShortName("ddzh")
    local isNeedUpdate, msg = hallmanager:CheckGameNeedUpdate(game)
    if isNeedUpdate then return end

    local hfView = self:getScene():getChildByName("HallFrameView")
    if hfView then
        hfView:joinGameRoom()
        hfView:updateNodeShow(2)
    end

    self:enterGameAction()
    self:getScene():createView("match.MatchView"):pushInScene(false)
end

-- 进入单个游戏
function M:joinGameRoom(gameid)
    if not hallmanager or not hallmanager.games then return end
    local game = hallmanager.games[gameid]
    if not game then return end

    -- h5小游戏
    if game.cmd and checkint(game.cmd.h5) == 1 and game.cmd.appid then
        gg.WebGameCtrl:openGameWebView(game.cmd.appid, game.id)
        return
    end

    local isNeedUpdate, msg = hallmanager:CheckGameNeedUpdate(game)
    if isNeedUpdate then return end

    -- 如果游戏有自定义入口文件，调用之
    local customEntrance = hallmanager:getGameCustomEntrance(game)
    if customEntrance then
        dofile(customEntrance)
    else
        if Helper.And(game.type, GAME_GROUP_LEISURE) ~= 0 then
            -- 休闲类小游戏根据游戏找到对应的房间直接加入，如果没有则提示敬请期待
            local roomid = nil
            if Helper.And(game.type, GAME_GROUP_LEISURE) ~= 0 then
                roomid = hallmanager:GetLeisureRoomByGameId(game.id)
                if not roomid then
                    GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "攻城狮正在加班加点开发,敬请期待")
                    print("游戏服务器没有启动，没有房间。。。")
                    return
                end
            end
            if hallmanager:IsInFriendRoom() then return end
            hallmanager:JoinRoom(roomid, false)
        else
            hallmanager:JoinGame(game.id)
        end
    end
end

-- 显示游戏列表界面
function M:showGameListView(vType)
    self:enterGameAction()
    self:getScene():getChildByName("HallFrameView"):joinGameRoom()
    local view = self:getScene():createView("newhall.HallGameListView", vType)
    view:setName("HallGameListView")
    view:pushInScene()
end

------------------------------------
-- 通知
------------------------------------
function M:registerCommonEventListener()
    -- 加入大厅成功消息
    self:addEventListener(gg.Event.HALL_JOIN_HALL_SUCCESS, handler(self, self.onEventUpdateView))
    -- 游戏显示配置数据变化的消息
    self:addEventListener(gg.Event.HALL_GAME_CFG_CHANGED, handler(self, self.onEventUpdateView))
    -- 选择地区通知
    self:addEventListener(gg.Event.HALL_SELECT_AREA, handler(self, self.onEventSelectArea))
    -- 用户数据变化通知
    self:addEventListener(gg.Event.HALL_UPDATE_USER_DATA, handler(self, self.onEventUpdateUserData))
    -- 显示游戏房间列表
    self:addEventListener(gg.Event.SHOW_ROOM_LIST, handler(self, self.onEventShowRoomList))
    -- 更新完成
    self:addEventListener("event_game_update_finish", handler(self, self.onEventUpdateFinish))
    -- 更新进度
    self:addEventListener("event_game_update_progress_changed", handler(self, self.onEventUpdateChanged))
    -- 游戏房间退回到大厅通知
    self:addEventListener(gg.Event.GAME_ROOM_BACK_TO_HALL, handler(self, self.playEnterAni))
    --玩家点击小游戏通知
    self:addEventListener(gg.Event.NEW_MINIGAME_WARN, handler(self, self.onEventMiniGameWarn))
end

function M:onEventMiniGameWarn(event)
    local img_xing = self:findNode("img_xing")
    if img_xing then
        img_xing:setVisible(false)
    end
end
function M:onEventUpdateUserData(event, userinfo)
    if not userinfo or not hallmanager then return end
    local honorcount = checkint(hallmanager:GetHonorValue())

    if self._honorcount and self._honorcount ~= honorcount then
        local curScene = GameApp:getRunningScene()
        if curScene.name_ == "HallScene" and honorcount > self._honorcount then
            -- 荣誉值变化了，检测是否需要播放升星或者升段动画
            local honorLogic = require("hall.views.honor.HonorChangeLogic")
            local honorView = honorLogic:showHonorChangeView(honorcount, self._honorcount)
        end
        self._honorcount = honorcount
    end

    local totalCnt = checkint(hallmanager:GetEffortData(EffortData.TOTAL_GAME_COUNT))
    if self._gameCnt and self._gameCnt ~= totalCnt then
        -- 游戏局数变化了，刷新界面显示
        self:onEventUpdateView()
    end
end

function M:showRewardView(rewardData)
    local grade = gg.GetHonorGradeAndLevel(self._honorcount)
    if rewardData[grade-1] and grade > 1 then
        GameApp:DoShell(nil, "GetRewardView://", rewardData[grade - 1])
    end
end

function M:onEventUpdateView()
    -- 记录玩家的游戏局数，当玩家游戏局数发生变化时，需要刷新游戏列表的显示
    if hallmanager then
        self._gameCnt = checkint(hallmanager:GetEffortData(EffortData.TOTAL_GAME_COUNT))
        self._honorcount = checkint(hallmanager:GetHonorValue())
        local newminigame = hallmanager:GetNewMiniGame()
        --是否显示欢乐馆新游戏图标
        if newminigame and #newminigame ~=0 then
            local img_xing = self:findNode("img_xing")
            if img_xing then
                img_xing:setVisible(true)
            end
        end
    end
    self:updateBtnsShow()
end

-- 选择地区通知
function M:onEventSelectArea(event)
    -- 配置游戏验证
    if hallmanager and not hallmanager.games then
        -- 选择的地区未配置游戏或，配置异常
        GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG , "地区码配置异常，请检查！" , nil )
    end

    local schemeuri = device.getUrlScheme()
    if (#checkstring(schemeuri)) > 0 then
        printf("onEventSelectArea after parse scheme :"..tostring(schemeuri))
        GameApp:HandleUrlScheme(schemeuri)
    end
    -- 刷新界面显示
    self:onEventUpdateView()
end

function M:onEventShowRoomList(event, roomList, game)
    if not game then return end
    local matchView = self:getScene():getChildByName("match.MatchView")
    if matchView then matchView:removeSelf() end
    self:getScene():createView("RoomMainView", roomList, game):pushInScene(false)
end

------------------------------------
-- 重写方法
------------------------------------
-- 刷新界面按钮显示的方法，需要在各自界面重写已响应通知
function M:updateBtnsShow()

end

function M:enterGameAction()

end

-- 返回大厅主界面
function M:playEnterAni()
    -- TODO 2018-06-27 退回大厅主界面，游戏房间界面重叠问题容错处理
    local hallGameListView = self:getScene():getChildByName("HallGameListView")
    if hallGameListView then
        hallGameListView:removeSelf()
    end

    local hfv = self:getScene():getChildByName("HallFrameView")
    if hfv then
        hfv:backToHall()
    end
end

-- 更新完成隐藏并且重置进度
function M:onEventUpdateFinish(event, shortname, err)

end

-- 更新进度
function M:onEventUpdateChanged(event, p, shortname)

end

return M