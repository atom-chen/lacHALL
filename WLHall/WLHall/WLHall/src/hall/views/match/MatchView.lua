
-- Author: zhaoxinyu
-- Date: 2016-09-06 11:45:56
-- Describe：比赛房间

local MatchView = class("MatchView", cc.load("ViewBase"))

MatchView.AUTO_RESOLUTION = true
MatchView.RESOURCE_FILENAME = "ui/room/match/match_layer.lua"
MatchView.RESOURCE_BINDING = {
    ["img_tab_bg"]  = {["varname"] = "img_tab_bg" },
    ["img_back_bg"] = {["varname"] = "img_back_bg"},
    ["nd_tab"]      = {["varname"] = "nd_tab"     },
    ["lv_items"]    = {["varname"] = "lv_items"   },
    ["sv_tv_items"] = {["varname"] = "sv_tv_items"},   --电视比赛item
    ["btn_back"] = {["varname"] = "btn_back", ["events"] = {{event = "click", method = "onClickBack"}}},
    ["tab_tv"]   = {["varname"] = "tab_tv",   ["events"] = {{event = "click_color", method = "onClickTab"}}},
    ["tab_yb"]   = {["varname"] = "tab_yb",   ["events"] = {{event = "click_color", method = "onClickTab"}}},
    ["tab_fl"]   = {["varname"] = "tab_fl",   ["events"] = {{event = "click_color", method = "onClickTab"}}},
}

-- item的1行数量
local ROOM_ITEM_RANK = 4
local ROOM_ITEY_PAGE = 8

local MatchItemNode = import(".MatchItemNode")  --每日赛 item
local MatchTvItemView = import(".MatchTvItemView")  --电视赛 item

-- tabIdx: 电视海选赛-"tv"，元宝争夺赛-"yb", 福利赛-"fl"
function MatchView:onCreate(tabIdx)
    self:init()
    self:initView()
    if not tabIdx then
        self:doSelectTab(self.tab_yb)
    else
        self:selectTabByIndex(tabIdx)
    end
end

function MatchView:init()
    self._preTab = nil
    self._tabsTb = {self.tab_yb, self.tab_tv, self.tab_fl}
    --暂未开发 关闭时隐藏电视海选
    if not GameApp:CheckModuleEnable(ModuleTag.Unimplemented) then
        self.tab_tv:setVisible(false)
        self.tab_fl:setVisible(false)
    end
end

function MatchView:initView()
    self.nd_tab:setContentSize(self.nd_tab:getContentSize().width , display.height - 80)
    self.nd_tab:setPositionX(gg.getPhoneLeft())
    self.img_tab_bg:setPositionY(self.nd_tab:getContentSize().height)
    self.img_back_bg:setPosition(cc.p(0, display.height))
    self.lv_items:setBounceEnabled(true)
    self.lv_items:setScrollBarEnabled(false)
    self.lv_items:setPositionX(self.lv_items:getPositionX() + gg.getPhoneLeft())
    self.lv_items:setContentSize(cc.size(display.width - 230 - 2 * gg.getPhoneLeft(), display.height - 105))

    self.sv_tv_items:setBounceEnabled(true)
    self.sv_tv_items:setScrollBarEnabled(false)
    self.sv_tv_items:setPositionX(self.sv_tv_items:getPositionX() + gg.getPhoneLeft())
    self.sv_tv_items:setContentSize(cc.size(display.width - 210 - 2 * gg.getPhoneLeft(), display.height - 105))

    local posY = display.height - 210
    local idx = 0
    for i,v in ipairs(self._tabsTb) do
        if v:isVisible() then
            v:setPositionY(posY)
            posY = posY - 142
            idx = idx + 1
        end
    end
    -- 隐藏最后一个按钮的分割线
    if self._tabsTb[idx] then
        self._tabsTb[idx]:getChildByName("img_line"):setVisible(false)
    end
end

function MatchView:selectTabByIndex(tabIdx)
    if self["tab_" .. tabIdx] then
        self:doSelectTab(self["tab_" .. tabIdx])
    else
        self:doSelectTab(self.tab_tv)
    end
end

function MatchView:onClickTab(sender)
    if self._preTab and self._preTab == sender then
        return
    end
    gg.AudioManager:playClickEffect()
    self:doSelectTab(sender)
end

function MatchView:doSelectTab(sender)
    self._preTab = sender
    for i,v in ipairs(self._tabsTb) do
        v:getChildByName("img_sel"):setVisible(v == sender)
        v:getChildByName("tab_icon_s"):setVisible(v == sender)
    end

    -- 筛选比赛房间
    if not hallmanager or not hallmanager.rooms then
        print("获取房间信息失败.")
        return
    end

    local roomList = {}
    for k, v in pairs(hallmanager.rooms) do
        if v.cmd and v.cmd.awardType then
            local needShow = true
            -- ios审核模式筛掉报名费为元宝的房间
            if device.platform == "ios" and IS_REVIEW_MODE and v.cmd.bmlx and checkint(v.cmd.bmlx) == PROP_ID_LOTTERY then
                needShow = false
            end

            if needShow then
                -- rType:比赛房间类型, 0-每日赛;1-福利赛;2-电视赛
                local rType = checkint(v.cmd.rot)
                -- isTv:
                local isTv = checkint(v.cmd.tv) > 0
                if sender == self.tab_yb and rType == 0 and not isTv then
                    table.insert(roomList, v)
                elseif sender == self.tab_fl and rType == 1 and not isTv then
                    table.insert(roomList, v)
                elseif sender == self.tab_tv and rType >= 2 and isTv then
                    table.insert(roomList, v)
                end
            end
        end
    end
    -- 清除界面
    self.lv_items:removeAllChildren()
    self.lv_items:setVisible(false)
    self.sv_tv_items:removeAllChildren()
    self.sv_tv_items:setVisible(false)

    if #roomList == 0 then
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "即将开放，敬请期待！")
        return
    end
    -- 排序
    table.sort(roomList, function(a, b) return checkint(a.cmd.sort) < checkint(b.cmd.sort) end)

    if sender == self.tab_tv then
        local tvRoomTb = self:createTvRoomTb(roomList)
        self:updateTvListView(tvRoomTb)
    else
        self:updateRoomListView(roomList)
    end
end

-- 重构比赛房间数据表
function MatchView:createTvRoomTb(roomlist)
    local tvTb = {}
    local curRegion = gg.LocalConfig:GetRegionCode()
    for i,v in ipairs(checktable(roomlist)) do
        local tvId = checktable(v.cmd).tv
        if tvId then
            tvTb[tvId] = checktable(tvTb[tvId])
            table.insert(tvTb[tvId], v)
        end
    end

    local code = REGION_CODE
    if REGION_CODE == 0 and curRegion ~= 0 then
        code = checkint(string.sub(curRegion, 1, 2))
    end

    local newTvTb = {}
    for p,v in pairs(tvTb) do
        if p == code then
            -- 电视台id与地区码匹配时，将item放在第一位
            table.insert(newTvTb, 1, v)
        else
            table.insert(newTvTb, v)
        end
    end

    return newTvTb
end

--电视赛
function MatchView:updateTvListView(roomList)
    self.sv_tv_items:setVisible(true)

    local tage = ROOM_ITEM_RANK    --默认一页 3个item 的长度
    if #roomList > ROOM_ITEY_PAGE then    --获取tage
        local idx = #roomList / ROOM_ITEY_PAGE
        local yeshu = math.floor(idx)   --取页数下线
        local count =  #roomList % ROOM_ITEM_RANK --该页的第几个
        local dataSize = #roomList - ROOM_ITEY_PAGE * yeshu  --获取值大小
        if dataSize < ROOM_ITEM_RANK and dataSize ~= 0 then  --小于3值 不等于0 代表 改页没有满
            tage = yeshu * ROOM_ITEM_RANK + count
        elseif dataSize >= ROOM_ITEM_RANK and dataSize ~= 0 then --大于等于3值 不等于0 代表 改页已经满了
            tage = yeshu * ROOM_ITEM_RANK + ROOM_ITEM_RANK
        else  -- 不等于0 代表 已经是下一页了
            tage = yeshu * ROOM_ITEM_RANK
        end
    end

    local scaleX = (self.sv_tv_items:getContentSize().width - 2 * gg.getPhoneLeft()) / 1070
    local svWidth = math.max(self.sv_tv_items:getContentSize().height, 267 * scaleX * tage)
    self.sv_tv_items:setInnerContainerSize({width = svWidth, height = self.sv_tv_items:getContentSize().height})

    local pagecount = 1 --页数  1-8
    local rank = 0   --第几行
    local roomcount = #roomList

    for i,roomTb in ipairs(roomList) do
        -- 创建试图
        local item = MatchTvItemView.new("MatchTvItemView", roomTb)
        item:setScale(scaleX)

        self:createRoomPage(item, pagecount, rank, roomcount)
        self.sv_tv_items:addChild(item)
        if pagecount == ROOM_ITEY_PAGE then  --每页 8个item
            pagecount = 0
            rank = rank + 1  --是否已经一页了
        end
        pagecount = pagecount + 1
    end
end

-- 刷新房间Item位置
function MatchView:createRoomPage(item, pagecount, ranksize, roomcount)
    if not item then
        return
    end
    local scaleX = (self.sv_tv_items:getContentSize().width - gg.IIF(gg.isWideScreenPhone, 95, 0)) / 1070
    local scaleY = self.sv_tv_items:getContentSize().height / 615
    -- 设置位置
    local row = math.ceil(pagecount / 4) - 1
    local rank = math.fmod(pagecount - 1, 4)
    item:setPositionX((140 * scaleX + 263 * scaleX * rank + ranksize * 263 * scaleX * ROOM_ITEM_RANK))
    item:setPositionY(608 * scaleY - (255 / 2 + 285 * scaleY * row))
end

--每日赛
function MatchView:updateRoomListView(roomList)
    self.lv_items:setVisible(true)

    local i = 1
    for k, v in pairs(roomList) do
        if v.cmd.awardType == "2" then
            -- 话费赛
            v.cmd.order = string.format("%d", i)
            i = i + 1
        end
    end

    for i,v in ipairs(roomList) do
        local roomItem = self:createRoomItem(v)
        roomItem:setScale(self.lv_items:getContentSize().width / 1050)
        self.lv_items:pushBackCustomItem(roomItem)
    end
end

--[[
* @brief 创建房间View
* @brief roomData 房间数据
]]
function MatchView:createRoomItem(roomData)
    if not roomData then return end
    local roomView = MatchItemNode.new("MatchItemNode", roomData)
    return roomView
end

function MatchView:onClickBack()
    self:removeSelf()
end

function MatchView:removeSelf()
    GameApp:dispatchEvent(gg.Event.GAME_ROOM_BACK_TO_HALL)
    MatchView.super.removeSelf(self)
end

return MatchView
