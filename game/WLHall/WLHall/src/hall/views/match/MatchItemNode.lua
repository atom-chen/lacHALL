
-- Author: zhanghonghui
-- Date: 2017-09-22 11:19:00
-- Describe：比赛单项

local M = class("MatchItemNode" , cc.load("ViewLayout"))

M.RESOURCE_FILENAME = "ui/room/match/match_item_node.lua"
M.RESOURCE_BINDING = {
    ["img_bg"] = { ["varname"] = "img_bg" },
    ["txt_players"] = { ["varname"] = "txt_players" },
    ["txt_title"] = { ["varname"] = "txt_title" },
    ["txt_tip_right"] = { ["varname"] = "txt_tip_right" },
    ["img_icon"] = { ["varname"] = "img_icon" },
    ["txt_date"] = { ["varname"] = "txt_date" },
    ["txt_time"] = { ["varname"] = "txt_time" },
}

--[[
* @brief 创建
* @param roomData 比赛房间数据
]]
function M:onCreate(roomData)
    assert(roomData , "roomData is nil")

    local scale = (display.width - 230 - 2 * gg.getPhoneLeft()) / 1050
    self:setContentSize(cc.size(1050 * scale, 140 * scale))
    self.img_bg:retain()
    self.img_bg:removeFromParent(true)
    self:addChild(self.img_bg)
    self.img_bg:release()

    self.img_bg:onClick(handler(self, self.onClickJoinRoom))
    self:updateRoomData(roomData)
end

function M:updateRoomData(roomData)
    if not roomData then return end
    self._roomData = roomData
    self:setTag(roomData.id)

    local isTvRoom = roomData.cmd and checkint(roomData.cmd.awardType) >= 100 and checkint(roomData.cmd.rot) >= 2
    -- ios审核模式下直接显示比赛名字，不带奖励
    if device.platform == "ios" and IS_REVIEW_MODE then
        if string.find(roomData.name, "免费赛") then
            roomData.name = "免费赛"
        elseif string.find(roomData.name, "快速赛") then
            roomData.name = "快速赛"
        end
    else
        -- 设置房间标题文本(如果出现元宝字样，替换为礼品券)
        roomData.name = string.gsub(roomData.name, "元宝", "礼品券")
    end
    self.txt_title:setString(roomData.name)
    -- 设置右边提示语
    local strTips = string.format("%s", gg.IIF(roomData.cmd.rt, roomData.cmd.rt, ""))
    self.txt_tip_right:setString(strTips)

    -- todo 电视海选赛房间房间人数和时间暂时设置为-
    if isTvRoom then
        self.txt_players:setString("-")
        self.txt_date:setString("--")
        self.txt_time:setString("--:--:--")
        self.img_icon:loadTexture("hall/room/match/match_item_icon.png", 1)
        return
    end

    -- 设置房间人数
    self.txt_players:setString(checkint(roomData.players))
    -- 更新时间
    local roomType = gg.GetRoomMode(roomData.type)
    -- 预报名房间的时间设置
    if roomType == ROOM_TYPE_PK_MODE3 or roomType == ROOM_TYPE_PK_MODE4 then
        if hallmanager then
            local info = hallmanager:GetLatelyGroup(roomData.id)
            if info then
                local time = checkint(checktable(info).startTime)
                -- 日赛
                if checkint(checktable(info).type) == 0 then
                    self.txt_date:setString(gg.IIF(checktable(info).isNextDay, "明日", "今日"))
                    self.txt_time:setString(os.date("%H:%M", time))
                else
                    self.txt_date:setString(os.date("%d日", time))
                    self.txt_time:setString(os.date("%H:%M", time))
                end

                local reward = checktable(checktable(checktable(roomData.rank).awardinfo)[1]).reward
                if reward and checktable(reward[1]).id then
                    self:setRewardIcon(roomData, checktable(reward[1]).id)
                end
            else
                self.txt_date:setString("--")
                self.txt_time:setString("--:--")
            end
        end
    else
        local function setAwardAndTime_(cfg)
            if checktable(cfg).time then
                local time = checktable(cfg).time or "24小时开赛"
                time = string.gsub(time, "全天", "")
                self.txt_time:setString(time)
            else
                self.txt_time:setString("24小时开赛")
            end

            local reward = checktable(checktable(cfg.awardinfo)[1]).reward
            if reward and checktable(reward[1]).id then
                self:setRewardIcon(roomData, checktable(reward[1]).id)
            end

            -- 新版每日赛参赛人数假数据
            if checkint(roomData.cmd.rot) == 0 and checkint(roomData.cmd.awardType) >= 100 then
                if cfg.maxcount and checkint(roomData.players) < checkint(cfg.maxcount) then
                    self.txt_players:setString(math.random(checkint(cfg.maxcount) - 5, checkint(cfg.maxcount) - 1))
                end
            end
        end

        self.txt_date:setString("全天")
        if roomData.webCfg then
            setAwardAndTime_(roomData.webCfg)
        else
            gg.Dapi:GetMatchAwards(roomData.gameid, roomData.id, function(t)
                if tolua.isnull(self) then return end
                t = checktable(t)
                if table.nums(t) <= 0 then return end
                -- 将拉取下来的配置数据保存在房间信息中
                roomData.webCfg = t
                -- 计算客户端时间和服务端的时间差
                if t.server_time then
                    roomData.time_difference = checkint(t.server_time) - os.time()
                end
                setAwardAndTime_(t)
            end)
        end
    end
end

function M:setRewardIcon(roomData, rewardId)
    -- 苹果审核模式直接使用默认图标
    if device.platform == "ios" and IS_REVIEW_MODE then return end

    local propDef = gg.GetPropList()
    -- 如果有指定图片，下载并显示图片
    self.img_icon:ignoreContentAdaptWithSize(true)
    if roomData.cmd.nicon and roomData.cmd.nicon ~= "" then
        local url = APP_ICON_PATH .. roomData.cmd.nicon .. ".png"
        gg.ImageDownload:LoadHttpImageAsyn(url , self.img_icon, function()
            self.img_icon:setScale(112 / self.img_icon:getContentSize().width)
        end)
    elseif rewardId and propDef[rewardId] then
        if checkint(rewardId) == PROP_ID_XZMONEY then
            self.img_icon:loadTexture("hall/store/img_icon_17.png", 0)
        elseif checkint(rewardId) == PROP_ID_MONEY then
            cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/store.plist")
            self.img_icon:loadTexture("hall/store/ico_bean_lv4.png", 1)
        else
            local iconPath = gg.IIF(propDef[rewardId].icon_l, propDef[rewardId].icon_l, propDef[rewardId].icon)
            self.img_icon:loadTexture(iconPath, 0)
        end
        self.img_icon:setScale(112 / self.img_icon:getContentSize().width)
    end
end

--[[
* @brief 点击事件
]]
function M:onClickJoinRoom(sender)
    -- 播放点击音效
    gg.AudioManager:playClickEffect()
    -- 房间ID
    if not self._roomData or not self._roomData.type then
        return
    end

    -- 已经在朋友场中，不能参与比赛，直接拉回朋友场
    if hallmanager and hallmanager:IsInFriendRoom() then
        return
    end

    local roomType = gg.GetRoomMode(self._roomData.type)
    local roomRot = checkint(checktable(self._roomData.cmd).rot)
    local roomAwareType = checkint(checktable(self._roomData.cmd).awardType)

    -- todo 电视海选赛房间点击提示暂未开放
    if roomRot >= 2 then
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "即将开放，敬请期待！")
        print("error:电视赛相关房间配置错误，房间id为 " .. checkint(self._roomData.id))
        return
    end

    if (roomType == ROOM_TYPE_ALLOCSIT or roomType == ROOM_TYPE_ALLOCSIT2) and roomRot == 0 and roomAwareType < 100 then
        -- 是普通防作弊场的话，直接进入房间
        hallmanager:JoinRoom(self._roomData.id)
    else
        -- 其他情况，显示房间信息
        local joinView = self:getScene():getChildByName("match.MatchJoinView")
        if not joinView then
            -- 之前没有显示加入界面，创建一个加入界面
            self:getScene():createView("match.MatchJoinView", self._roomData.id, self._roomData.gameid):pushInScene()
        end
    end
end

return M