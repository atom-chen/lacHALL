
-- Author: zhaoxinyu
-- Date: 2016-09-09 16:50:56
-- Describe：加入比赛房间

local M = class("MatchJoinView", cc.load("ViewPop"))

M.RESOURCE_FILENAME = "ui/room/match/match_join_node.lua"
M.RESOURCE_BINDING = {
    ["txt_title"]   = {["varname"] = "txt_title"  },
    ["txt_gz"]      = {["varname"] = "txt_gz"     },    -- 规则描述
    ["txt_sj"]      = {["varname"] = "txt_sj"     },
    ["txt_gdsrcy"]  = {["varname"] = "txt_gdsrcy" },
    ["txt_bmrs"]    = {["varname"] = "txt_bmrs"   },    -- 已有报名人数
    ["txt_hxrs"]    = {["varname"] = "txt_hxrs"   },
    ["lv_mc"]       = {["varname"] = "lv_mc"      },    -- 奖励列表
    ["txt_bmf"]     = {["varname"] = "txt_bmf"    },
    ["txt_need_s"]  = {["varname"] = "txt_need_s" },    -- 还需人数文本
    ["txt_need_e"]  = {["varname"] = "txt_need_e" },
    ["txt_t_bmf"]   = {["varname"] = "txt_t_bmf"  },    -- 报名费文本
    ["txt_t_djs"]   = {["varname"] = "txt_t_djs"  },    -- 倒计时文本
    ["txt_t_kssj"]  = {["varname"] = "txt_t_kssj" },    -- 开赛倒计时时间
    ["txt_t_time"]  = {["varname"] = "txt_t_time" },    -- 开赛时间文本
    ["list_match1"] = {["varname"] = "list_match1"},
    ["txt_ybm_str"] = {["varname"] = "txt_ybm_str"},
    ["txt_ybm_cnt"] = {["varname"] = "txt_ybm_cnt"},
    ["nd_jf_tips"]  = {["varname"] = "nd_jf_tips" },
    ["btn_rank"]    = {["varname"] = "btn_rank",  ["events"] = {{event = "click", method = "onClickRank" }}},   -- 排行按钮
    ["btn_close"]   = {["varname"] = "btn_close", ["events"] = {{event = "click", method = "onClickClose"}}},   -- 关闭按钮
    ["btn_ts"]      = {["varname"] = "btn_ts",    ["events"] = {{event = "click", method = "onClickOut"  }}},   -- 退赛按钮
    ["btn_bm"]      = {["varname"] = "btn_bm",    ["events"] = {{event = "click", method = "onClickJoin" }}},   -- 加入按钮
}

local DEFAULT_TIME_STR = "全天24小时开赛"

local MATCH_STATE_END = -1          -- 比赛报名已结束
local MATCH_STATE_CAN_JOIN = 0      -- 可以报名
local MATCH_STATE_NOT_BEGIN = 1     -- 报名未开始
local MATCH_STATE_OTHER_DATE = 2    -- 还有几天开始报名

local SIGNUP_MATCH_TYPE_D = 0      -- 日赛
local SIGNUP_MATCH_TYPE_W = 1      -- 周赛
local SIGNUP_MATCH_TYPE_M = 2      -- 月赛

local TV_SCORE_ID = 999     -- 电视赛积分id

function M:onCreate(roomid, gameid)
    self:setScale(math.min(display.scaleX, display.scaleY))
    if hallmanager and hallmanager.rooms then
        local function loadView_()
            -- 初始化
            self:init(roomid, gameid)
            -- 初始化View
            self:initView()
            -- 注册消息通知
            self:registerEventListener()
        end

        -- 房间信息
        self._roomInfo = hallmanager.rooms[roomid]
        -- 是否为预报名模式
        if self._roomInfo then
            local roomType = gg.GetRoomMode(self._roomInfo.type)
            self._isPk4Type = (roomType == ROOM_TYPE_PK_MODE3 or roomType == ROOM_TYPE_PK_MODE4)
        else
            print("error: 请检查游戏服务器是否开启，或有报错挂了！！！")
        end

        if self._isPk4Type then
            hallmanager:CheckPkInfoLoaded(function()
                if tolua.isnull(self) then return end
                loadView_()
            end)
        else
            loadView_()
        end
    else
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "网络错误，请关闭界面重试！")
    end
end

function M:onCleanup()
    if self._updateTimer then
        -- 有定时器，需要停止
        self._updateTimer:killAll()
        self._updateTimer = nil
    end

    -- 没有任何报名场次了关闭比赛定时器
    if hallmanager then
        local allInfo = hallmanager:GetAllSignUpInfo()
        if not allInfo or #allInfo == 0 then
            hallmanager:StopMatchTimer()
        end
    end
end

function M:init(roomid, gameid)
    self._roomid = roomid
    self._gameid = gameid
    -- 用户是否已经加入房间标记
    self._hasJoinRoom = false
    if hallmanager and hallmanager:IsConnected() then
        -- 当前房间即将开赛的分组
        self._latelyGroup = checktable(hallmanager:GetLatelyGroup(roomid))
        if PK_ROOM_FAILED_GROUPID and PK_ROOM_FAILED_GROUPID.rid == roomid then
            if PK_ROOM_FAILED_GROUPID.gid == self._latelyGroup.id and not self._latelyGroup.isNextDay then
                self._latelyGroup = checktable(hallmanager:GetNextGroup(roomid, self._latelyGroup.id))
            else
                PK_ROOM_FAILED_GROUPID = nil
            end
        end
    end
    -- 隐藏listView滚动条
    self.lv_mc:setScrollBarEnabled(false)
end

function M:initView()
    if not self._roomInfo then
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "房间信息未初始化")
        return
    end

    local roomInfo = checktable(self._roomInfo)
    -- 设置房间标题
    self.txt_title:setString(roomInfo.name or "比赛")
    self.nd_jf_tips:setVisible(checkint(checktable(roomInfo.cmd).tv) > 0)
    if checkint(checktable(roomInfo.cmd).tv) > 0 then
        self.lv_mc:setContentSize(cc.size(self.lv_mc:getContentSize().width, self.lv_mc:getContentSize().height - 36))
    end

    -- 设置比赛时间、规则、奖励相关数据
    if self._isPk4Type then
        self:setMatchData(roomInfo.rank)
        self:updateRule(roomInfo.matchrule)
        if hallmanager:GetSignUpInfo(self._roomid, self._latelyGroup.id) then
            self.btn_bm:setVisible(false)
            self.btn_ts:setVisible(true)
        else
            self.btn_bm:setVisible(true)
            self.btn_ts:setVisible(false)
        end
    else
        if roomInfo.webCfg then
            self:setMatchData(roomInfo.webCfg)
        else
            gg.Dapi:GetMatchAwards(self._gameid, self._roomid, function(cb)
                if tolua.isnull(self) then return end
                cb = checktable(cb)
                if table.nums(cb) <= 0 then return end
                -- 将拉取下来的配置数据保存在房间信息中
                roomInfo.webCfg = cb
                -- 计算客户端时间和服务端的时间差
                if cb.server_time then
                    roomData.time_difference = checkint(cb.server_time) - os.time()
                end
                self:setMatchData(cb)
            end)
        end
    end
    -- 设置房间人数
    self:updatePlayers(roomInfo.players or 6774)
    -- 设置报名费
    self:setSignUpCost(roomInfo)
    -- 设置参数人数
    self:setSignUpPlayersCnt(roomInfo)
end

-- 设置比赛时间相关数据
function M:setMatchData(data)
    if not data or table.nums(data) == 0 then
        return
    end

    local awardinfo = data.awardinfo
    local rule = data.rule
    local time = data.time

    if self._isPk4Type then
        local daystr = gg.IIF(self._latelyGroup.isNextDay, "明日%H:%M", "今日%H:%M")
        local ds = gg.IIF(self._latelyGroup.type ~= SIGNUP_MATCH_TYPE_D, "%d日%H:%M", daystr)
        time = os.date(ds, checkint(self._latelyGroup.startTime))

        self.txt_t_djs:setVisible(true)
        self.txt_t_kssj:setVisible(true)
        if hallmanager then
            hallmanager:StartMatchTimer()
        end
        self:onEventMatchTimeUpdate()
    end
    -- 设置比赛时间的显示
    self.txt_sj:setString(gg.IIF(time and #time > 0, time, DEFAULT_TIME_STR))

    -- 设置规则的显示
    if rule and #rule > 0 then
        if self._gzLabel then
            self._gzLabel:removeFromParent()
            self._gzLabel = nil
        end

        local gzLabel = self:createRichLable({
            fontSize = 28,
            maxWidth = 750,
            fontColor = cc.c3b(113, 59, 22),
        }, rule, 32, cc.c3b(234, 88, 0))
        self.txt_gz:getParent():addChild(gzLabel)
        gzLabel:setPosition(self.txt_gz:getPosition())
        gzLabel:setAnchorPoint(cc.p(0, 0.5))
        self.txt_gz:setVisible(false)

        self._gzLabel = gzLabel
    end

    -- 设置奖励
    self.lv_mc:removeAllChildren()
    for i = 1, #awardinfo do
        local awardInfoItem = self:createAwardInfoItem(awardinfo[i])
        self.lv_mc:pushBackCustomItem(awardInfoItem)
    end

    -- 记录报名时间信息
    if data.timeinfo then
        self.timeinfo = data.timeinfo

        -- 有报名时间信息时，设置定时器刷新按钮显示
        if self._updateTimer then
            self._updateTimer:killAll()
            self._updateTimer = nil
        end
        self._updateTimer = require("common.utils.Timer").new()
        self._updateTimer:start(handler(self,self.updateJoinBtnState), 1)

        -- 立即刷新一次按钮状态
        self:updateJoinBtnState()
    end
    -- 记录是否已开赛
    self.matching = data.matching
    -- 记录最大报名人数
    self._maxCnt = data.maxcount
end

--[[
* @brief 创建获奖信息列表Item
* @parm awardInfoData 获奖信息 -- awardinfo：排名信息  rks：开始名次  rke：结束名次 、reward：奖励、id:奖励的物品id、 count：奖励数量
                               -- rule：规则
                               -- time：时间
]]
function M:createAwardInfoItem(awardInfoData)
    if not awardInfoData then return end

    local awardInfoItem = require("ui/room/match/join_award_info_item.lua").create()
    local root = awardInfoItem.root:getChildByName("panel_bg")
    root:removeFromParent(true)

    local txt_mc = root:getChildByName("txt_mc")                -- 设置排名信息
    local img_jb = root:getChildByName("img_jb")
    local str_mc_1 = "第  %d  名:"
    local str_mc_2 = "%d-%d 名:"
    local r_mc = nil

    local rks = awardInfoData.rks                         -- 开始名次
    local rke = awardInfoData.rke                         -- 结束名次
    if rks and not rke and checkint(rks) <= 3 and checkint(rks) > 0 then
        img_jb:loadTexture(string.format("hall/honor/rank_%d.png", rks), 1)
        img_jb:setVisible(true)
        txt_mc:setVisible(false)
    end

    -- 拼接字符串
    if rks then
        if rke then
            r_mc = string.format(str_mc_2, rks, rke)
        else
            r_mc = string.format(str_mc_1, rks)
        end
    end

    -- 设置名次内容
    if r_mc then
        txt_mc:setString(r_mc)
    end

    local txt_count = root:getChildByName("txt_count")        -- 奖励数量1
    local rewardTb = checktable(awardInfoData.reward)
    local rewardStr = ""
    for i,v in ipairs(rewardTb) do
        if v.desc and v.desc ~= "" then
            rewardStr = v.desc
        else
            local propDef = gg.GetPropList()[v.id]
            local addSign = gg.IIF(i == #rewardTb, "", " + ")
            if propDef then
                local count = checkint(v.count) * (propDef.proportion or 1)
                if v.id == PROP_ID_261 or v.id == PROP_ID_262 or v.id == PROP_ID_263 or v.id == PROP_ID_PHONE_CARD then
                    local str = string.format("%.2f%s ", count, propDef.name)
                    rewardStr = rewardStr .. str .. addSign
                elseif v.id == PROP_ID_MONEY then
                    rewardStr = rewardStr .. count .. "豆" .. addSign
                elseif v.id == PROP_ID_LOTTERY and IS_REVIEW_MODE then
                    rewardStr = rewardStr .. count .. "钻石" .. addSign
                else
                    rewardStr = rewardStr .. count .. propDef.name .. addSign
                end
            elseif v.id == TV_SCORE_ID then
                rewardStr = rewardStr .. checkint(v.count) .. "积分" .. addSign
            end
        end
    end
    txt_count:setString(rewardStr)

    return root
end

-- 设置参赛人数
function M:setSignUpPlayersCnt(roomInfo)
    self.txt_bmrs:setString("-")
    self.txt_hxrs:setString("-")
    self.txt_ybm_cnt:setString("--")

    if self._isPk4Type then
        self.txt_gdsrcy:setVisible(false)
        self.list_match1:setVisible(false)
        self.txt_ybm_str:setVisible(true)
        self.txt_ybm_cnt:setVisible(true)
    end

    -- 新版每日赛参赛人数假数据
    -- 2018-10-09 晋级赛模式的电视赛人数假数据
    local isNewTvMode = checkint(roomInfo.cmd.rot) >= 2 and checkint(roomInfo.cmd.tv) > 0 and not self._isPk4Type
    if (checkint(roomInfo.cmd.rot) == 0 and checkint(roomInfo.cmd.awardType) >= 100) or isNewTvMode then
        if self._maxCnt then
            local maxcnt = checkint(self._maxCnt)
            local p1 = math.random(maxcnt - 5, maxcnt - 1)
            local p2 = maxcnt - p1
            self.txt_bmrs:setString(p1)
            self.txt_hxrs:setString(p2)

            if roomInfo.players < self._maxCnt then
                self:updatePlayers(p1)
            end
        end
    end

    -- 设置报名人数
    if hallmanager then
        local info = hallmanager:GetSignUpInfo(self._roomid, self._latelyGroup.id)
        if info then
            self.txt_bmrs:setString(checkint(info.players))
            self.txt_ybm_cnt:setString(checkint(info.players))
        end
    end
end

-- 设置报名费显示
function M:setSignUpCost(roomInfo)
    local strName = "豆"
    local bmfCnt = 0
    -- 预报名模式报名费数据从大厅服务器下发获得
    if self._isPk4Type then
        local idx = self._latelyGroup.curSignUpType or 1
        local bmfTb = checktable(checktable(checktable(self._latelyGroup.gignUpTypeList)[idx]).pl)[1]
        if bmfTb then
            if bmfTb.id and checkint(bmfTb.id) ~= PROP_ID_MONEY then
                local propInfo = gg.GetPropList()[checkint(bmfTb.id)]
                if propInfo and propInfo.name then
                    strName = propInfo.name
                end
            end
            bmfCnt = checkint(bmfTb.count)
        end
    else
        local bmlx = tonumber(roomInfo.cmd.bmlx)
        if bmlx and bmlx ~= PROP_ID_MONEY then
            local propInfo = gg.GetPropList()[bmlx]
            if propInfo and propInfo.name then
                strName = propInfo.name
            end
        end
        bmfCnt = tonumber(roomInfo.cmd.bmf)
    end

    if checkint(bmfCnt) <= 0 then
        self.txt_bmf:setString("免费")
    else
        self.txt_bmf:setString(string.format("%d%s", bmfCnt, strName))
    end
end

-- 更新房间人数
function M:updatePlayers(players)
    if not players then return end
    self.txt_gdsrcy:setString(string.format("（当前共有 %d 人参与）", players))
end

-- 预报名比赛规则
function M:updateRule(ruleTb)
    for i,v in ipairs(checktable(ruleTb)) do
        local nd = self:findNode("nd_rule_" .. i)
        if nd then
            nd:getChildByName("txt_rule_title"):setString(tostring(v.title))
            nd:getChildByName("txt_rule"):setString(tostring(v.content))
            nd:setVisible(true)
        end
    end
end

-- 有报名时间要求时，更新报名按钮的状态
function M:updateJoinBtnState()
    -- 没有时间信息或者报名按钮隐藏了或者正在报名中，不需要处理
    if not self.timeinfo or not self.btn_bm:isVisible() or self.isDoingJoin then
        return
    end

    local canJoin, btnStr = self:isInTime(true)
    self.btn_bm:setEnabled(canJoin)
    self.btn_bm:setAllGray(not canJoin)

    -- 设置不可用状态使用灰色图片
    -- self.btn_bm:loadTextureDisabled("hall/common/btn_grey.png",1)
    -- 设置按钮的可用状态以及按钮文字
    -- self.btn_bm:setEnabled(canJoin)
    -- if canJoin then
    --     self.btn_bm:getChildByName("txt"):setString("立即参赛")
    -- else
    --     self.btn_bm:getChildByName("txt"):setString(btnStr)
    -- end
end

------------------------------------------------
--
------------------------------------------------
-- 创建富文本
function M:createRichLable(params, string, numFontSize, numColor)
    local lable = RichLabel.new(params)
    lable:setString(string)
    lable:walkElements(function (node, index)
        local ss = node:getString()
        if tonumber(ss) then
            node:setFontSize(numFontSize)
            node:setColor(numColor)
        end
    end)
    return lable
end

--[[
* @brief 检查是否是可以报名的时间
* @param isForBtn true 则返回按钮字符串，false 则返回报名提示字符串
* @return 返回两个值：第一个值为 true 或者 false，表示是否可以报名;
          当不可以报名时，第二个值为相应的字符串
]]
function M:isInTime(isForBtn)
    if not self.timeinfo.type or not self.timeinfo.begin_time then
        -- 没有指定的数据，直接认为可以报名
        return true
    end

    local bTimeArr = string.split(self.timeinfo.begin_time, ":")
    if #bTimeArr ~= 2 then
        -- 开始时间格式错误，直接可以报名
        return true
    end

    local curTime = os.date("*t")
    local matchState
    local endTip
    local timeTip
    if self.timeinfo.type == "day" then
        -- 是日赛
        matchState, timeTip = self:canJoinDayMatch(curTime)
    elseif self.timeinfo.type == "week" then
        -- 是周赛
        matchState, timeTip = self:canJoinWeekMatch(curTime)
    elseif self.timeinfo.type == "month" then
        -- 是月赛
        matchState, timeTip = self:canJoinMonthMatch(curTime)
    else
        -- 不是约定的类型，直接认为可以报名
        return true
    end

    local tipStr
    if matchState == MATCH_STATE_END then
        -- 是比赛已结束时，timeTip 就是结束提示语
        tipStr = gg.IIF(isForBtn, "报名已结束", timeTip)
    elseif matchState == MATCH_STATE_OTHER_DATE then
        -- 比赛还有几天
        tipStr = string.format(gg.IIF(isForBtn, "还有%d天报名", "距离比赛开始报名还有 %d 天。"), timeTip)
    elseif matchState == MATCH_STATE_NOT_BEGIN then
        -- 比赛未开始
        tipStr = string.format(gg.IIF(isForBtn, "还剩%s报名", "还有%s开始报名！"), timeTip)
    else
        -- 可以报名
        return true
    end

    if not isForBtn then
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, tipStr)
    end
    return false, tipStr
end

--[[
* @brief 获取比赛日信息
* @param cfgDate date 配置信息
* @param maxDate 日期的最大值
* @param curDate 当前日期值
* @return 返回下一个比赛日和最后一个比赛日
]]
function M:getMatchDate(cfgDate, maxDate, curDate)
    if not cfgDate then
        -- 没有配置信息，默认最后一天为比赛日
        return maxDate, maxDate
    end

    local nextMatchDay
    local maxMatchDay
    if type(cfgDate) == "table" then
        -- 如果 date 是一个数组，查找最近的下一个比赛日和最后一个比赛日
        for i, v in ipairs(cfgDate) do
            local dateValue = gg.IIF(v > 0, v, maxDate + 1 + v)
            if dateValue >= curDate and (not nextMatchDay or dateValue < nextMatchDay) then
                -- 记录下一个比赛日
                nextMatchDay = dateValue
            end

            if not maxMatchDay or maxMatchDay < dateValue then
                -- 记录最后的比赛日
                maxMatchDay = dateValue
            end
        end
    else
        -- 是一个整数
        cfgDate = gg.IIF(cfgDate > 0, cfgDate, maxDate + 1 + cfgDate)
        if cfgDate >= curDate then
            nextMatchDay = cfgDate
        end
        maxMatchDay = nextMatchDay
    end

    return nextMatchDay, maxMatchDay
end

--[[
* @brief 今日有比赛时，检查当前是否是在可报名的时间内
* @param curTime 当前时间数据
* @param beginTime 报名开始时间字符串，格式为 20:08
* @param endTime 报名结束时间字符串，格式为 21:08，可以为空
* @param matching 是否已开赛
* @return 返回两个参数，报名状态 和 提示字符串
          如果可以报名返回 0,nil ；
          如果已过报名时间，返回 -1,nil；
          如果未到报名时间，返回 1 和 相应的距离报名时间字符串
]]
function M:checkJoinTime(curTime, beginTime, endTime, matching)
    -- 获取开始时间
    local beginTimeData = clone(curTime)
    local bTimeArr = string.split(beginTime, ":")
    beginTimeData.hour = bTimeArr[1]
    beginTimeData.min = bTimeArr[2]
    beginTimeData.sec = 0
    local beginTimeStamp = os.time(beginTimeData)

    -- 获取当前时间戳
    local curTimeStamp = os.time(curTime)
    if curTimeStamp >= beginTimeStamp and matching and checkint(matching) == 1 then
        -- 已经开赛了，认为报名已结束
        print("---- 已经开赛了 ----")
        return MATCH_STATE_END
    end

    if curTimeStamp < beginTimeStamp then
        -- 未开始报名
        local timeDis = beginTimeStamp - curTimeStamp
        local tipStr
        if timeDis < 60 then
            -- 小于 1 分钟
            tipStr = string.format("%d秒", timeDis)
        elseif timeDis < 3600 then
            -- 小于 1 小时
            tipStr = string.format("%d分%d秒", math.floor(timeDis / 60), timeDis % 60)
        else
            -- 大于 1 小时
            local hourValue = math.floor(timeDis / 3600)
            local minValue = math.floor((timeDis % 3600) / 60)
            tipStr = string.format("%d小时%d分", hourValue, minValue)
        end
        return MATCH_STATE_NOT_BEGIN, tipStr
    end

    if not endTime or #endTime == 0 then
        -- 没有配置结束报名时间，认为可以报名
        return MATCH_STATE_CAN_JOIN
    end

    local endTimeData = clone(curTime)
    local eTimeArr = string.split(endTime, ":")
    endTimeData.hour = eTimeArr[1]
    endTimeData.min = eTimeArr[2]
    endTimeData.sec = 0
    local endTimeStamp = os.time(endTimeData)

    if curTimeStamp > endTimeStamp then
        -- 报名已结束
        return MATCH_STATE_END
    end

    -- 可以报名
    print("---- 可以报名 ----")
    return MATCH_STATE_CAN_JOIN
end

--[[
* @brief 判断是否可以报名当日的比赛
* @param curTime 当前时间的数据
* @param endTip 报名结束时的提示语，默认为日赛提示语
* @return 返回两个参数，报名状态 和 提示字符串
          如果可以报名返回 0,nil ；
          如果已过报名时间，返回 -1, endTip；
          如果未到报名时间，返回 1 和 相应的距离报名时间字符串
]]
function M:canJoinDayMatch(curTime, endTip)
    local joinState, tipStr = self:checkJoinTime(curTime, self.timeinfo.begin_time, self.timeinfo.end_time, self.matching)
    if joinState == MATCH_STATE_END then
        tipStr = endTip or "今日报名已结束，明天再来吧！"
    end
    return joinState, tipStr
end

--[[
* @brief 判断是否可以报名本周的比赛
* @param curTime 当前时间的数据
* @return 返回两个参数，报名状态 和 提示字符串
          如果可以报名返回 0,nil ；
          如果已过报名时间，返回 -1, endTip；
          如果未到报名时间，返回 1 和 相应的距离报名时间字符串
          如果未到报名日，返回 2 和距离报名日期的天数
]]
function M:canJoinWeekMatch(curTime)
    -- 获取当前是周几
    local curWDay =(curTime.wday-1) % 7
    curWDay = gg.IIF(curWDay == 0, 7, curWDay)

    -- 是周赛，获取下一个比赛日和最后一个比赛日
    local nextMatchDay, maxMatchDay = self:getMatchDate(self.timeinfo.date, 7, curWDay)
    if not nextMatchDay then
        -- 本周没有比赛日了，比赛已结束
        return MATCH_STATE_END, "本周比赛报名已结束，下周再来吧！"
    end

    -- 本周还有比赛日，那么 nextMatchDay 一定大于等于 curWDay
    if curWDay == nextMatchDay then
        -- 今天有比赛
        local endTip = gg.IIF(nextMatchDay == maxMatchDay, "本周比赛报名已结束，下周再来吧！", "今日比赛报名已结束！")
        return self:canJoinDayMatch(curTime, endTip)
    else
        -- 比赛之前的某天
        return MATCH_STATE_OTHER_DATE, nextMatchDay - curWDay
    end
end

--[[
* @brief 判断是否可以报名本月的比赛
* @param curTime 当前时间的数据
* @return 返回两个参数，报名状态 和 提示字符串
          如果可以报名返回 0,nil ；
          如果已过报名时间，返回 -1, endTip；
          如果未到报名时间，返回 1 和 相应的距离报名时间字符串
          如果未到报名日，返回 2 和距离报名日期的天数
]]
function M:canJoinMonthMatch(curTime)
    local function getMonthMaxDay(year, month)
        local defaultDays = {
            31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
        }

        -- 判断是否闰年
        local isLeapYear = false
        if (year % 4) == 0 and (year % 100) ~= 0 or (year % 400) == 0 then
            isLeapYear = true
        else
            isLeapYear = false
        end

        if isLeapYear and month == 2 then
            -- 闰年二月份返回 29
            return 29
        else
            -- 不是闰年，返回默认天数
            return defaultDays[month]
        end
    end

    -- 月赛默认为每个月最后一天比赛
    local maxDate = getMonthMaxDay(curTime.year, curTime.month)
    local nextMatchDay, maxMatchDay = self:getMatchDate(self.timeinfo.date, maxDate, curTime.day)
    if not nextMatchDay then
        -- 本月没有比赛日了，比赛已结束
        return MATCH_STATE_END, "本月比赛报名已结束，下个月再来吧！"
    end

    -- 本月还有比赛日，那么 nextMatchDay 一定大于等于 curTime.day
    if curTime.day == nextMatchDay then
        -- 今天有比赛
        local endTip = gg.IIF(nextMatchDay == maxMatchDay, "本月比赛报名已结束，下个月再来吧！", "今日比赛报名已结束！")
        return self:canJoinDayMatch(curTime, endTip)
    else
        -- 比赛之前的某天
        return MATCH_STATE_OTHER_DATE, nextMatchDay - curTime.day
    end
end

-- 是否有参数时间限制
function M:isTimeLimit()
    if self._roomInfo and checktable(self._roomInfo.cmd).gt then
        local params = checktable(self._roomInfo.cmd).gt
        local args = string.split(params, "#")
        local startTime = checkint(args[1]) * 60
        local endTime = gg.IIF(args[2], checkint(args[2]) * 60, 24 * 3600)
        local userTime = os.time() + checkint(self._roomInfo.time_difference)        
        local date = os.date("*t", userTime)
        local time = date.hour * 3600 + date.min * 60 + date.sec
        if time < startTime or time > endTime then
            return true
        end
    end
    return false
end

---------------------------------------------
-- 点击事件
---------------------------------------------
-- 报名
function M:onClickJoin(sender)
    if not hallmanager or not self._roomInfo then
        return
    end

    -- 指定了报名时间，且不在报名时间内，直接返回
    if self.timeinfo and not self:isInTime() then
        return
    end

    -- 电视赛需校验用户资料是否填写提交
    local isTvRoom = checkint(self._roomInfo.cmd.awardType) >= 100 and checkint(self._roomInfo.cmd.rot) >= 2 and checkint(self._roomInfo.cmd.tv) > 0
    if isTvRoom and (not gg.UserData:isTvMatchDataIntegrity()) then
        self:getScene():createView("match.MatchApplyView", checkint(self._roomInfo.cmd.tv)):pushInScene()
        return
    end

    -- 判断是否有报名时间限制
    if self:isTimeLimit() then
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "未到报名时间，请稍后再来！")
        return
    end

    if self._isPk4Type then
        if self._latelyGroup then
            -- 判断是否已经报过了
            if hallmanager:GetSignUpInfo(self._roomid, self._latelyGroup.id) then
                return
            end
            hallmanager:Pk3SignUp(self._roomid, checkint(self._latelyGroup.id), self._latelyGroup.curSignUpType)
        else
            print("error:没有任何报名分组数据，请检查报名服务器是否开启！！！")
        end
    else
        if not self._hasJoinRoom then
            hallmanager:JoinRoom(self._roomid)
        else
            local roomMgr = hallmanager:GetRoomManager()
            if roomMgr then
                -- 已经加入房间，直接参赛
                roomMgr:SendPKPlayerJoin(true)
                -- 禁用按钮，防止反复频繁点击
                self.btn_bm:setEnabled(false)
                self.btn_ts:setEnabled(false)
                -- 记录正在报名中
                self.isDoingJoin = true
            end
        end
    end
end

-- 退赛
function M:onClickOut()
    self.quitDialog = self:getScene():showMsgDialog("是否确定退出比赛...", function(bttype)
        if not tolua.isnull(self) then
            self.quitDialog = nil
        end

        if bttype == gg.MessageDialog.EVENT_TYPE_OK then
            if self._isPk4Type then
                local sign = hallmanager:GetSignUpInfo(self._roomid, self._latelyGroup.id)
                if sign then
                    hallmanager:Pk3UnSignUp(sign.roomid, sign.groupid)
                end
            else
                local roomMgr = hallmanager:GetRoomManager()
                if roomMgr then
                    roomMgr:SendPKPlayerJoin(false)
                end
            end
            -- 禁用按钮，防止反复频繁点击
            self.btn_bm:setEnabled(false)
            self.btn_ts:setEnabled(false)
        end
    end, {mode = gg.MessageDialog.MODE_OK_CANCEL_CLOSE, cancel = "取消", ok = "确定"})
end

function M:onClickClose()
    if hallmanager then
        hallmanager:ExitRoom()
    end
    self._hasJoinRoom = false
    self:removeSelf()
end

function M:onClickRank()
    self:getScene():createView("match.MatchTvRank"):pushInScene()
end

---------------------------------------------
-- 通知
---------------------------------------------
function M:registerEventListener()
    -- 房间人数变化
    self:addEventListener(gg.Event.HALL_UPDATE_UPDATE_ROOM_PLAYERS, handler(self, self.onEventUpdateRoomPlayers))
    -- 加入比赛结果应答
    self:addEventListener(gg.Event.ROOM_JOIN_PK1_REPLY, handler(self, self.onEventJoinPkReply))
    -- 更新比赛人数
    self:addEventListener(gg.Event.ROOM_UPDATE_PK_PLAYERS, handler(self, self.onEventUpdatePkPlayers))
    -- 回到大厅的事件
    self:addEventListener(gg.Event.HALL_ON_JOIN_HALL, handler(self, self.onEventCloseMatchJoin))
    -- 关闭界面
    self:addEventListener("gg.Event.ROOM_CLOSE_MATCH_JOIN", handler(self, self.onEventCloseMatchJoin))
    -- 加入房间
    self:addEventListener(gg.Event.ROOM_JOIN_ROOM_REPLY, handler(self, self.onEventJoinRoomReply))
    -- 更新预报名人数
    self:addEventListener(gg.Event.ROOM_UPDATE_SIGNUP_PLAYERS, handler(self, self.onEventUpdateSignUpPlayers))
    -- 比赛时间刷新
    self:addEventListener(gg.Event.HALL_MATCH_TIME_UPDATE_NOTIC, handler(self, self.onEventMatchTimeUpdate))
    -- 开赛失败通知
    self:addEventListener(gg.Event.HALL_MATCH_START_FAILED_NOTIC, handler(self, self.onEventMatchStartFailed))
end

-- 比赛开赛失败刷新报名界面
function M:onEventMatchStartFailed(obj, roomid, groupid, errmsg)
    if checkint(roomid) ~= self._roomid then return end
    GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG, errmsg or "因报名人数不足，本次赛事取消")
    -- 当前房间即将开赛的分组
    if hallmanager then
        self._latelyGroup = checktable(hallmanager:GetNextGroup(roomid, groupid))
        self:initView()
    end
end

--[[
* @brief 房间人数变化通知
* @param [in] lst 房间玩家表,key=房间ID,value=玩家数量
]]
function M:onEventUpdateRoomPlayers(obj, lst)
    if not lst then return end
    for k, v in pairs(lst) do
        if k == self._roomInfo.id then
            -- 刷新房间数据中的玩家人数
            self._roomInfo.players = v
            -- 更新房间人数
            self:updatePlayers(v)
        end
    end
end

--[[
* @brief 加入、退出比赛应答通知
* @param result 应答结果
* @param bJoin true 加入  、 false 退出
]]
function M:onEventJoinPkReply(obj, result, bJoin)
    -- 启用按钮，防止反复频繁点击
    self.btn_bm:setEnabled(true)
    self.btn_ts:setEnabled(true)
    -- 取消正在处理报名的状态
    self.isDoingJoin = false

    if result == nil or bJoin == nil then
        return
    end

    if result == 0 then
        if bJoin then
            GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "比赛报名成功！")
            -- 加入比赛成功
            self.btn_bm:setVisible(false)
            self.btn_ts:setVisible(true)
        else
            -- 退出比赛成功
            self.btn_bm:setVisible(true)
            self.btn_ts:setVisible(false)
            -- 更新报名按钮状态
            self:updateJoinBtnState()
        end
    end
end

-- 更新比赛人数
function M:onEventUpdatePkPlayers(obj, room)
    if not room then return end
    -- 需要根据 room 状态调整按钮状态
    self.btn_bm:setVisible(room.selfgroup == 0)
    self.btn_ts:setVisible(room.selfgroup ~= 0)

    local roomManager = room
    local groupplayer = roomManager.groupplayer     -- 当前报名人数
    local maxplayer = roomManager.maxplayer         -- 开赛需要人数
    local roomplayer = roomManager.roomplayer       -- 房间总人数
    self.txt_bmrs:setString(string.format("%d", groupplayer))
    self.txt_ybm_cnt:setString(string.format("%d", groupplayer))
    self.txt_hxrs:setString(string.format("%d", maxplayer - groupplayer))
    self.txt_gdsrcy:setString(string.format("（当前共有 %d 人参与）", roomplayer))
    -- 刷新房间数据中的玩家人数
    self._roomInfo.players = roomplayer
end

function M:onEventCloseMatchJoin(obj)
    if self.quitDialog then
        self.quitDialog:removeSelf()
        self.quitDialog = nil
    end
    self:removeSelf()
end

function M:onEventJoinRoomReply(obj, room)
    if not room.selfgroup or (room.selfgroup > 0 and room.groupstate >= 2) then
        -- 通过 selfgroup 判断玩家是否进入了非比赛场
        -- 玩家在游戏中，不需要进行报名
        return
    end
    self._hasJoinRoom = true
    -- 进行报名
    room:SendPKPlayerJoin(true)
end

-- 预报名人数更新
function M:onEventUpdateSignUpPlayers(event, roomid, groupid, players)
    if checkint(roomid) == self._roomid then
        self.txt_bmrs:setString(string.format("%d", players))
        self.txt_ybm_cnt:setString(string.format("%d", players))
    end
end

-- 比赛时间刷新
function M:onEventMatchTimeUpdate(event)
    --计算剩余时间
    if not self._latelyGroup or table.nums(self._latelyGroup) == 0 then
        return
    end

    local cd = self._latelyGroup.startTime - os.time()
    cd = cd - self._latelyGroup.timeDiff
    if cd <= 0 then
        -- 停止报名
        if self.btn_bm:isVisible() then
            self.txt_t_kssj:setString("报名已截止")
            self.btn_bm:setEnabled(false)
            self.btn_bm:setAllGray(true)
        end
        return
    end

    -- 刷新文本
    if self.txt_t_kssj then
        self.txt_t_kssj:setString(self:timeTf(cd))
    end
end

-- 获取剩余时间
function M:timeTf(time)
    local h = time / 3600
    local m = (time % 3600) / 60
    local s = time % 60
    return string.format("%d:%s:%s", math.floor(h), self:repair0(math.floor(m)), self:repair0(s))
end

-- 时间补0
function M:repair0(t)
    local rt = ""
    if t < 10 or t == 0 then
        rt = string.format("0%d", t)
    else
        rt = string.format("%d", t)
    end
    return rt
end

return M