
-- Author:Cai
-- Date: 2018-08-27
-- Descrlibe:战绩界面

local M = class("JXGameRecordView", cc.load("ViewPop"))

M.RESOURCE_FILENAME="ui/recordstatistics/jx_game_record_view.lua"
M.RESOURCE_BINDING = {
    ["img_bg"]     = {["varname"] = "img_bg"   },  -- 所有root节点
    ["lv_record"]  = {["varname"] = "lv_record"},
    ["txt_tips"]   = {["varname"] = "txt_tips" },
    ["nd_search"]  = {["varname"] = "nd_search"},
    ["btn_close"]  = {["varname"] = "btn_close",  ["events"] = {{["event"] = "click", ["method"] = "onClickClose"} } }, -- 查看他人战绩
    ["btn_search"] = {["varname"] = "btn_search", ["events"] = {{["event"] = "click_color", ["method"] = "onClickLookOtherStatistic"} } }, -- 查看他人战绩
}
M.LAYER_ALPHA = 25

-- 字符串转时间
local function string2time_(str)
    local Y = string.sub(str, 1, 4)
    local M = string.sub(str, 6, 7)
    local D = string.sub(str, 9, 10)
    local h = string.sub(str, 12, 13)
    local m = string.sub(str, 15, 16)
    local s = string.sub(str, 18, 19)
    local time = os.time({year=Y, month=M, day=D, hour=h, min=m, sec=s})
    return time
end

function M:onCreate()
    self:init()
    self.img_bg:setScale(math.min(display.scaleX, display.scaleY))
    -- 隐藏滚动条
    self.lv_record:setScrollBarEnabled(false)
    self:initRecordListView()
    self:registerEventListener()
end

function M:init()
    -- 是否显示回放码界面
    self._isShowView = false
    -- 查找回放码按钮
    self._btnShow = nil
end

function M:onEnter()
    gg.Dapi:RecordFriend(nil, function(result)
        if tolua.isnull(self) then return end
        if not result then return end
        result = checktable(result)
        if result.status and checkint(result.status) ~= 0 then
            self.txt_tips:show()
            print( "战绩数据拉取错误："..result.msg )
            return
        end

        local data = checktable(result.data)
        if table.nums(data) > 0 then
            self.txt_tips:setVisible(false)
        else
            self.txt_tips:show()
        end
        
        table.sort(data, function(a, b)
            return string2time_(a.time) > string2time_(b.time)
        end)
    
        self.lv_record:reloadData(data)
    end)
end

function M:initRecordListView()
    local tbView = require("src.common.TableViewEx").new(self.lv_record)
    tbView._createItemFunc = function() return self:createRecordItem() end
    tbView._updateItemFunc = function(...) return self:updateItem(...) end
    tbView._cellSize = cc.size(1109, 160)
    tbView._cpr = 1
    tbView._needRecreate = true
    tbView:setMargin(0)
    tbView:init()
end

function M:createRecordItem()
    local node = require("res.ui.recordstatistics.jx_record_item").create()
    local item = node.root:getChildByName("item_record")
    item:removeFromParent(true)
    item:setPositionX(0)
    item:setPositionY(0)
    return item
end

--更新排行
function M:updateItem(item, data, idx)
    if not data then return end
    item.data = data

    -- 判断是否有这个游戏
    local game = checktable(hallmanager.games[checkint(data.game_id)])
    -- 游戏名
    local name_bg = item:getChildByName("img_name_bg")
    local txt_game = name_bg:getChildByName("txt_game")
    txt_game:setString(tostring(game.name or "未知游戏"))
    name_bg:setContentSize(cc.size(txt_game:getContentSize().width + 10, name_bg:getContentSize().height))
    txt_game:setPositionX(name_bg:getContentSize().width / 2)
    -- 房号
    local txt_roomid = item:getChildByName("txt_roomid")
    txt_roomid:setString("房号:".. string.format("%06d", data.roomid or 0))
    txt_roomid:setPositionX(name_bg:getPositionX() + name_bg:getContentSize().width + 20)
    -- 时间`
    local txt_time = item:getChildByName("txt_time")
    txt_time:setString(data.time or "0000:00:00 00:00:00")
    txt_time:setPositionX(txt_roomid:getPositionX() + txt_roomid:getContentSize().width + 20)
    -- 回放码
    local txt_record_code = item:findNode("txt_record_code")
    txt_record_code:setString(string.format("回放码:%s", tostring(data.record_id)))
    txt_record_code:setPositionX(txt_time:getPositionX() + txt_time:getSize().width + 20)
    -- 线适配
    gg.LineHandle(item:getChildByName("line_img"))
    -- 玩家数据
    for i,v in ipairs(checktable(data.players)) do
        local ndPlayer = self:createPlayerNode(v, #data.players)
        ndPlayer:setVisible(true)
        ndPlayer:setPosition(12 + (i - 1) * 225, 3)
        item:addChild(ndPlayer)
    end
    --回放按钮
    local btn_hf = item:getChildByName("btn_hf")
    btn_hf:onClickScaleEffect(function()
        self:onClickPlayback(data, game)
    end )
    if #data.players >= 5 then --大于等于5个人的时候，隐藏回放按钮
        btn_hf:setVisible(false)
    end
end

function M:createPlayerNode(playerData, count)
    local item = require("res.ui.recordstatistics.jx_record_item").create()
    local node = item.root:getChildByName("nd_player")
    node:removeFromParent(true)

    -- 玩家名字
    local uname = node:getChildByName("txt_uname")
    local strName = gg.SubUTF8StringByWidth(playerData.nickname, 90, 22, "")
    uname:setString(strName)
    -- 玩家id
    local uid = node:findNode("txt_uid")
    uid:setString(tostring(playerData.user_id))
    -- 得分
    local score = node:getChildByName( "txt_score" )
    if playerData.score then
        if checkint(playerData.score) >= 0 then
            score:setString("+" .. tostring(playerData.score))
            score:setTextColor(cc.c3b(232, 113, 20))
        else
            score:setString(tostring(playerData.score))
            score:setTextColor(cc.c3b(40, 175, 72))
        end
    end
    -- 设置头像
    local nd_avatar = node:getChildByName("img_avatar")
    local avatarPath = gg.IIF(checkint(playerData.sex) == 1, "common/hd_male.png", "common/hd_female.png")
    nd_avatar:loadTexture(avatarPath)
    if playerData.avatar and playerData.avatar ~= "" then
        avatarPath = playerData.avatar
        gg.ImageDownload:LoadUserAvaterImage({url=avatarPath, ismine=false, image=nd_avatar})
    end
    -- 设置房主
    local img_owner = node:getChildByName("img_owner")
    img_owner:setVisible(checkint(playerData.is_owner) == 1)

    return node
end

-- 关闭回放码页面
function M:closeSearchView()
    self._isShowView = false
    self._searchView:closeView()
end

-- 查看他人战绩
function M:onClickLookOtherStatistic()
    gg.AudioManager:playClickEffect()
    if self._isShowView then
        self:closeSearchView()
    else
        self:showSearchView()
    end
end

-- 打开回放码页面
function M:showSearchView()
    if not self._searchView then
        --回放码界面
        self._searchView = self:getScene():createView("jxroom.JXSearchRecordView")
        self.nd_search:addChild(self._searchView)
        self._searchView:setCallback(function()
            self._isShowView = false
        end)
    end
    self._isShowView = true
    self._searchView:setVisible(true)
    self._searchView:showView()
end

-- 回放按钮
function M:onClickPlayback(data, game)
    self.curPlayData = nil
    self.curPlayGame = nil

    if not hallmanager then
        self:showToast("回放功能暂未开放！")
        return
    end

    if not game.shortname then
        self:showToast("找不到相应的游戏。")
        return
    end

    local isNeedUpdate, msg = hallmanager:CheckGameNeedUpdate(game)
    if isNeedUpdate then
        -- 记录回放点击数据，更新完成之后模拟点击，清除该数据
        self.curPlayData = data
        self.curPlayGame = game
        -- 显示更新
        GameApp:dispatchEvent(gg.Event.SHOW_LOADING, "数据加载中...")
        hallmanager:DoUpdateGame(game)
        return
    end

    self:playReplayGame(data, game)
end

function M:playReplayGame(data, game)
    -- 判断是否有回放功能
    local path = string.format("games.%s.replay.config", tostring(game.shortname))
    local ok, file = pcall(function()
        return require(path)
    end)
    local config
    if ok then
        config = file
    else
        gg.ShowLoading(self:getScene()) -- 关闭Loading
        print(ok, file)
        self:showToast("此游戏暂无回放功能！")
        return
    end

    gg.ShowLoading(self:getScene(), "数据读取中...", 15)

    local callback = function(result, url)
        if tolua.isnull(self) then return end
        if result.status ~= 0 then
            gg.ShowLoading(self:getScene())
            print("请求数据失败")
            return
        end

        if result.total and checkint(result.total) == 0 then
            gg.ShowLoading(self:getScene())
            -- self:showToast( "暂无回放数据！" )
            return
        end

        local replayMgrPath = nil
        if Helper.And(game.type, GAME_GROUP_POKER) ~= 0 then
            replayMgrPath = "games.common.pkReplay.ReplayManager"
        elseif Helper.And(game.type , GAME_GROUP_MAHJONG) ~= 0 then
            replayMgrPath = "games.mj_common.replay.ReplayManager"
        else
            self:showToast("该类别游戏暂不支持回放功能!")
            printf("该游戏不属于麻将或者扑克类！！！")
            return
        end

        local existReplayMgr, ReplayManager = pcall(function()
            return require(replayMgrPath)
        end)
        if not existReplayMgr then
            gg.ShowLoading(self) -- 关闭Loading
            self:showToast("该游戏暂不支持回放功能!")
            print(existReplayMgr, ReplayManager)
            return
        end

        local manager = ReplayManager:create()
        local total = result.total -- 总局数
        local token = hallmanager:GetSession()
        local userId = hallmanager.userinfo.id
        manager:setDownPlayerId(userId)

        -- 请求参数
        local postData = {}
        postData.hashcode = data.hashcode
        postData.index = 0

        manager:setConfig(config, total, data, postData)
        local url = gg.Dapi:GetUserApiUrl("/record/download")

        gg.Dapi:SendRequest(gg.Dapi.METHOD_POST, url, function(code, msg)
            print("GameRecordStatisticsView code=", code, msg)
            if tolua.isnull(self) then return end
            if code ~= 200 then
                GameApp:dispatchEvent(gg.Event.SHOW_TOAST, msg or "数据读取失败")
                gg.ShowLoading(self:getScene())
                return
            end

            local isLoad = manager:parseData(msg)
            if isLoad then
                gg.ShowLoading(self:getScene())
                manager:runScene()
            else
                gg.ShowLoading(self:getScene())
                self:showToast( "回放数据加载失败！" )
                print("获取数据失败")
            end
        end, postData, 10, 1)
    end

    local hashcode = data.hashcode
    local index = -1
    gg.Dapi:RecordDownload(hashcode, index, callback)
end

function M:onClickClose()
    self:removeSelf()
end

-- 注册通知
function M:registerEventListener()
    -- 游戏更新完毕通知
    self:addEventListener("event_game_update_finish", handler(self, self.onEventGameUpdateFinish))
end

-- 游戏更新
function M:onEventGameUpdateFinish(event, shortname, err)
    GameApp:dispatchEvent(gg.Event.SHOW_LOADING)
    if not error_ then
        if self.curPlayData and self.curPlayGame then
            self:onClickPlayback(self.curPlayData, self.curPlayGame)
        end
        return
    end
    self:showToast( "游戏数据加载失败！" )
end

return M