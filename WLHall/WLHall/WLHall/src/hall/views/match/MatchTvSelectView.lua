-- Author: LiAchen
-- Date: 2018-09-19
-- Describe：电视赛主界面

local MatchTvSelectView = class("MatchTvSelectView", cc.load("ViewPop"))

MatchTvSelectView.RESOURCE_FILENAME = "ui/room/match/match_select_view.lua"
MatchTvSelectView.RESOURCE_BINDING = {
    ["txt_title"] = {["varname"] = "txt_title"},
    ["btn_close"] = {["varname"] = "btn_close", ["events"] = {{event = "click", method = "onClickClose"}}},
    ["btn_rule"]  = {["varname"] = "btn_rule",  ["events"] = {{event = "click", method = "onClickRule" }}},
    ["btn_rank"]  = {["varname"] = "btn_rank",  ["events"] = {{event = "click", method = "onClickRank" }}},
}
MatchTvSelectView.LAYER_ALPHA = 25

function MatchTvSelectView:onCreate(roomTb)
    self:setScale(math.min(display.scaleX, display.scaleY))
    self._roomTb = roomTb
    self:initView(roomTb)
    self:startUpdateTimer()
end

function MatchTvSelectView:initView(roomTb)
    if not roomTb then return end
    -- 标题
    local str_title = checktable(roomTb[1]).name
    self.txt_title:setString(str_title)

    for k,room in pairs(checktable(roomTb)) do
        local tvType = room.cmd.rot 
        local item = self:findNode("panel_" .. (tvType - 1))
        if item then
            self:updateTvItem(item, room)
        end
    end
end

local weekMap = {"周日", "周一", "周二", "周三", "周四", "周五", "周六"}
function MatchTvSelectView:updateTvItem(item, room)
    local function setTimeStr_(str)
        local txt_time = item:getChildByName("txt_time")
        txt_time:setString(tostring(str))
        txt_time:setVisible(true)
    end

    -- 隐藏敬请期待按钮
    local btn_unopen = item:getChildByName("btn_unopen")
    btn_unopen:setVisible(false)
    -- 添加点击事件
    item:onClickScaleEffect(function()
        gg.AudioManager:playClickEffect()
        self:MatchJoinView(room)
    end)

    local roomType = gg.GetRoomMode(room.type)
    if roomType == ROOM_TYPE_PK_MODE3 or roomType == ROOM_TYPE_PK_MODE4 then
        if hallmanager then
            local info = hallmanager:GetLatelyGroup(room.id)
            if info then
                local time = checkint(checktable(info).startTime)
                local timeStr = ""
                -- 日赛
                if checkint(checktable(info).type) == 0 then
                    timeStr = os.date("%H:%M", time) .. "开赛"
                -- 周赛
                elseif checkint(checktable(info).type) == 1 then
                    timeStr = weekMap[checkint(os.date("%w", time)) + 1]
                    timeStr = timeStr .. os.date(" %H:%M", time) .. "开赛"
                else
                    timeStr = os.date("%d日 %H:%M", time) .. "开赛"
                end

                setTimeStr_(timeStr)
            end
        end
    else
        if room.webCfg then
            setTimeStr_(tostring(checktable(room.webCfg).time))
        else
            gg.Dapi:GetMatchAwards(room.gameid, room.id, function(cb)
                if tolua.isnull(self) then return end
                cb = checktable(cb)
                if table.nums(cb) <= 0 then return end
                -- 将拉取下来的配置数据保存在房间信息中
                room.webCfg = cb
                -- 计算客户端时间和服务端的时间差
                if cb.server_time then
                    room.time_difference = checkint(cb.server_time) - os.time()
                end
                setTimeStr_(tostring(checktable(room.webCfg).time))
            end)
        end
    end
end

-- 进入报名界面
function MatchTvSelectView:MatchJoinView(room)
    -- 已经在朋友场中，不能参与比赛，直接拉回朋友场
    if hallmanager and hallmanager:IsInFriendRoom() then
        return
    end

    local roomType = gg.GetRoomMode(room.type)
    local roomRot = checkint(checktable(room.cmd).rot)
    local roomAwareType = checkint(checktable(room.cmd).awardType)

    if (roomType == ROOM_TYPE_ALLOCSIT or roomType == ROOM_TYPE_ALLOCSIT2) and roomRot == 0 and roomAwareType < 100 then
        -- 是普通防作弊场的话，直接进入房间
        hallmanager:JoinRoom(room.id)
    else
        -- 其他情况，显示房间信息
        local joinView = self:getScene():getChildByName("match.MatchJoinView")
        if not joinView then
            -- 之前没有显示加入界面，创建一个加入界面
            self:getScene():createView("match.MatchJoinView", room.id, room.gameid):pushInScene()
        end
    end
end

function MatchTvSelectView:onClickClose()
    self:removeSelf()
end

--电视赛排行
function MatchTvSelectView:onClickRank()
   gg.AudioManager:playClickEffect()
   self:getScene():createView("match.MatchTvRank"):pushInScene()
end

--电视赛规则
function MatchTvSelectView:onClickRule()
    gg.AudioManager:playClickEffect()
    local tvId = checktable(self._roomTb[1].cmd).tv
    self:getScene():createView("match.MatchTvRuleView", tvId):pushInScene()
end

-- 定时器，每分钟刷新一次界面的时间显示
function MatchTvSelectView:startUpdateTimer()
    if not self._timer then
        self._timer = require("common.utils.Timer").new()
        self._timer:start(handler(self, self.updateMatchTime), 60)
    end
end

function MatchTvSelectView:updateMatchTime()
    self:initView(self._roomTb)
end

function MatchTvSelectView:onExit()
    if self._timer then
        self._timer:killAll()
        self._timer = nil
    end
end

return MatchTvSelectView