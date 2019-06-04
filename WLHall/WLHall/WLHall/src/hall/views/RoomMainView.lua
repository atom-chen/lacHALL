
-- Author: 李阿城
-- Date: 2018-3-16

local M = class("RoomMainView", cc.load("ViewBase"))

M.RESOURCE_FILENAME = "ui/room/room_layer.lua"
M.RESOURCE_BINDING = {
    ["img_bg"]       = {["varname"] = "img_bg"     },
    ["scroll_view"]  = {["varname"] = "scroll_view"},
    ["txt_name"]     = {["varname"] = "txt_name"   },    -- 游戏名字
    ["panel_bg1"]    = {["varname"] = "panel_bg1"  },
    ["img_svbg"]    = {["varname"] = "img_svbg"  },
    ["img_guan"]    = {["varname"] = "img_guan"  },

    ["btn_rule"]     = {["varname"] = "btn_rule",     ["events"] = {{event = "click_color", method = "onClickGameRule"  }}},
    ["btn_game"]     = {["varname"] = "btn_game",     ["events"] = {{event = "click_color", method = "onClickQuickStart"}}},
    ["panel_bg"]     = {["varname"] = "panel_bg",     ["events"] = {{event = "click_color", method = "onClickClose"     }}},
    ["btn_special1"] = {["varname"] = "btn_special1", ["events"] = {{event = "click_color", method = "onClickSpecial"   }}},
    ["btn_special2"] = {["varname"] = "btn_special2", ["events"] = {{event = "click_color", method = "onClickSpecial"   }}},
    ["btn_bag"]      = {["varname"] = "btn_bag",      ["events"] = {{event = "click_color", method = "onClickBag"       }}},
    ["btn_close"]    = {["varname"] = "btn_close",    ["events"] = {{event = "click_color", method = "onClickClose"     }}},
}
M.AUTO_RESOLUTION = true

-- item的1行数量
local ROOM_ITEM_RANK = 3
local ROOM_ITEY_PAGE = 6
--房间列表大于6需要增加的宽度
local BG_WIDTH = 50
local RoomItem = import("hall.views.RoomItem")

function M:onCreate(roomList, game)
    self.roomtype = nil
    self:init(roomList, game)
    self:initView()
    self:resetLayout()
    -- 添加版本号显示
    gg.AddVersionTo(self,gg.GetGameVersionStr(game))

    self:addEventListener(gg.Event.ROOM_JOIN_ROOM_REPLY, handler(self, self.onEventRoomJoinNotify))
end

--获取特殊房间配置
function M:getRoomTabData(shortname)
    local ok, manifest_table= hallmanager:GetGameManifestTable(shortname)
    if ok and checktable(manifest_table).roomtabs then
        return manifest_table.roomtabs
    end
end
function M:onEventRoomJoinNotify( ... )
    -- 进入游戏成功移除房间列表界面
    self:removeSelf()
end

-- 初始化
function M:init(roomList, game)
    self._roomList = clone(roomList)
    self:buildMixedRoom()
    self.game = game
    cc.exports.ROOM_TAB_TYPE = nil

    --房间数量
    self.RoomCount = nil
    self._pagegameCount = 6     -- 每页房间数
    self._pageLabel = nil       -- 页码控件
    self.txt_name:setString(game.name)
    self._roomListView = {}            -- 房间试图列表
end

-- 构建混房间
function M:buildMixedRoom()
    local mixedRoomTb = {}
    -- 移除混房间，获取混房间数据
    for i = #checktable(self._roomList), 1, -1 do
        local mrl = checktable(self._roomList[i].cmd).mrl
        if mrl then
            print("----------混房间模式-----------")
            mixedRoomTb[self._roomList[i].id] = self._roomList[i]
            table.remove(self._roomList, i)
        end
    end

    if mixedRoomTb and table.nums(mixedRoomTb) > 0 then
        print("---------将混房间数据存入映射的正式房间-----------")
        -- 将混房间数据存入映射的正式房间
        for k,v in pairs(checktable(self._roomList)) do
            local mixedRoomId = checktable(v.cmd).mr
            if mixedRoomId then
                if v.mixedRoom then
                    print("[error] : 混房间映射房间id(" .. checkint(v.id) .. ")被重复映射")
                else
                    v.mixedRoom = mixedRoomTb[tonumber(mixedRoomId)]
                end
            end
        end
    end
end

function M:resetLayout()
    if not GameApp:CheckModuleEnable(ModuleTag.Bag) then
        self.btn_bag:setVisible(false)
        self.btn_rule:setPositionX(self.btn_bag:getPositionX())
    end
    self.panel_bg1:setScale(math.min(display.scaleX, display.scaleY))
    self.panel_bg:setContentSize(cc.size(display.width, display.height))
    self.svWidth = self.panel_bg1:getContentSize().width + gg.IIF(gg.isWideScreenPhone, 95, 0)

    if self.RoomCount and self.RoomCount > 6 then
        --按钮右移 关闭 ，快速开始 和背景框
        self.img_guan:setPositionX(self.img_guan:getPositionX() + BG_WIDTH)
        self.btn_close:setPositionX(self.btn_close:getPositionX() + BG_WIDTH)
        self.btn_game:setPositionX(self.btn_game:getPositionX() + BG_WIDTH)

        self.img_svbg:setContentSize(cc.size(self.img_svbg:getContentSize().width+BG_WIDTH, self.img_svbg:getContentSize().height))
        self.panel_bg1:setContentSize(self.svWidth + BG_WIDTH ,self.panel_bg1:getContentSize().height)
        self.scroll_view:setContentSize(cc.size(self.scroll_view:getContentSize().width+BG_WIDTH, self.scroll_view:getContentSize().height))
    else
        self.panel_bg1:setContentSize(self.svWidth ,self.panel_bg1:getContentSize().height)
        self.scroll_view:setContentSize(cc.size(self.scroll_view:getContentSize().width, self.scroll_view:getContentSize().height))
    end

    self.img_bg:setContentSize(cc.size(display.width, display.height))
    self.img_bg:setPosition(display.width, display.height / 2)
    self.scroll_view:setScrollBarEnabled(false)
end

-- 进入动画
function M:roomAnim()
    self.panel_bg:setOpacity(0)
    self.panel_bg:runAction(cc.FadeIn:create(0.1))
    self.panel_bg1:setPosition(display.width + self.img_bg:getContentSize().width + 70, display.cy)
    self.panel_bg1:runAction(cc.MoveTo:create(0.2, cc.p(display.width, display.cy)))
end

function M:initView()
    --房间动画
    self:roomAnim()
    --游戏配置是否添加TAB字段
    local tabDAta = self:getRoomTabData(self.game.shortname)

    if self.game.shortname == "doun" or self.game.shortname == "dzjs" or self.game.shortname == "dzpk" then
        self.btn_special1:setVisible(true)
        self.btn_special2:setVisible(true)
        local roomname1 = self.btn_special1:getChildByName("txt_name")
        local roomname2 = self.btn_special2:getChildByName("txt_name")
        if self.game.shortname == "doun" then
            roomname1:setString("抢庄场")
            roomname2:setString("诈十场")
        else
            roomname1:setString("常规场")
            roomname2:setString("贵宾厅")
        end
        -- 保存每个用户显示的房间状态，
        local roomTypeDate = gg.UserData:getConfigByKey("roomtype_" .. self.game.shortname)
        if not roomTypeDate then
            gg.UserData:SetConfigKV({["roomtype_" .. self.game.shortname] = 1})
        end

        --设置点击的房间类型
        local click_room_type = roomTypeDate or 1
        self:setBtnState(click_room_type)
        --获取房间类型的
        local roomType1, roomType2 = self:getSpecialRomView(ROOM_TYPE_CUSTOM1)

        self:updateRoomList(click_room_type == 1 and roomType1 or roomType2, self._roomListView)
    elseif tabDAta then
        self:updateTABRoomList(tabDAta,self:RoomListScreen(self._roomList))
    else
        self:updateRoomList(self._roomList, self._roomListView)
    end
end

--设置按钮状态
function M:setBtnState(btntype)
    --保存房间类型
    gg.UserData:SetConfigKV({["roomtype_" .. self.game.shortname] = btntype})

    --self.roomtype = btntype == 1 and ROOM_TYPE_CUSTOM1 or nil
    local img_diji_1_1 = self.btn_special1:getChildByName("img_1")
    local img_diji_1_2 = self.btn_special1:getChildByName("img_2")

    local img_diji_2_1 = self.btn_special2:getChildByName("img_1")
    local img_diji_2_2 = self.btn_special2:getChildByName("img_2")

    local roomname1 = self.btn_special1:getChildByName("txt_name")
    local roomname2 = self.btn_special2:getChildByName("txt_name")

    -- roomname1:setColor(gg.IIF(btntype == 1, {r = 51, g = 51, b = 51}, {r = 253, g = 253, b = 253}))
    -- roomname2:setColor(gg.IIF(btntype == 2, {r = 51, g = 51, b = 51}, {r = 253, g = 253, b = 253}))

    img_diji_1_1:setVisible(btntype == 1)
    img_diji_1_2:setVisible(btntype == 2)

    img_diji_2_1:setVisible(btntype == 2)
    img_diji_2_2:setVisible(btntype == 1)
end

--获取数据
function M:getSpecialRomView(roomtype)
    -- 筛选特殊房间
    local roomType1 = {}
    local roomType2 = {}
    local roomlist = self:getAllocSitRoom()
    for k,v in pairs(roomlist) do
        if Helper.And(v.type, roomtype) == 0 then
            table.insert(roomType1, v)
        else
            table.insert(roomType2, v)
        end
    end
    return roomType1, roomType2
end

-- 获取防作弊场
function M:getAllocSitRoom()
    if not self._roomList then
        return
    end

    local allocSitRoomList = {}
    for k, v in pairs(self._roomList) do
        local roomType = gg.GetRoomMode(v.type)
        -- 判断是否是防作弊房间和自由落座房间( cmd 中有 awardType 的是比赛房间，需要排除)
        -- cmd 中 hide 不为 0，不显示在房间列表
        if checkint(v.cmd.hide) == 0 and
        (roomType == ROOM_TYPE_ALLOCSIT or roomType == ROOM_TYPE_ALLOCSIT2 or roomType == ROOM_TYPE_FREE_MODE) then
            table.insert(allocSitRoomList, v)
        end
    end
    return allocSitRoomList
end

--更新tab字段的房间显示
function M:updateTABRoomList(tabData,roomList)
    if table.nums(checktable(roomList)) <= 0 then
        return
    end
    local roomData = {}
    --筛选tab字段的游戏
    for k, v in pairs(roomList) do
        if v.cmd.tab then
            if not roomData[v.cmd.tab] then
                roomData[v.cmd.tab] = {}
            end
            table.insert(  roomData[v.cmd.tab], v  )
        else
            printf("游戏没有配置tab字段")
            if not roomData["default"] then
                roomData["default"] = {}
            end
            table.insert( roomData["default"],v )
        end
    end
    if table.nums(checktable(roomData)) <= 0 then
        return
    end

    local count = 1
    --按钮item数据
    self._btnTb = {}
    local curBtnName = nil
    --默认值
    local default = nil
    --创建按钮
    for k, v in pairs(roomData) do
        local item = self.btn_special2:clone()
        item:setPositionX(736 - 146 * (count - 1))
        item:setName(k)
        item:setVisible(true)
        --点击
        item:onClick( function(sender)
            local touchTag = sender:getName()
            if  curBtnName ~= touchTag then
                curBtnName = touchTag
                self._roomListView = {}
                self.scroll_view:removeAllChildren()
                self:onClickBtn(sender,v)
            end
        end )
        self.panel_bg1:addChild(item)

        local name  = checktable(tabData[k]).name
        if not name then
            printf("游戏没有配置该字段")
        end
        item:getChildByName("txt_name"):setString(name or "经典场")
        --按钮数据
        if not self._btnTb[k] then
            self._btnTb[k] = {}
            self._btnTb[k] = item
        end
        --设置默认值
        if count == 1 then
            default = k
        end
        count = count + 1
    end


    -- 保存每个用户显示的房间状态，
    local roomTypeDate = gg.UserData:getConfigByKey("roomtype_" .. self.game.shortname)
    if not roomTypeDate then
        gg.UserData:SetConfigKV({["roomtype_" .. self.game.shortname] = self._btnTb[default]:getName() })
    end
    --判断按钮是否存在
    if not self._btnTb[roomTypeDate] then
        roomTypeDate = self._btnTb[default]:getName()
    end
    --当前按钮 短名
    curBtnName = self._btnTb[roomTypeDate]:getName()
    --更新按钮状态  --参数1 按钮 参数2 房间数据
    self:onClickBtn(self._btnTb[roomTypeDate],roomData[roomTypeDate])
end
--  roomListData 房间列表数据
function M:onClickBtn(sender,roomListData)
    --getName
    cc.exports.ROOM_TAB_TYPE = sender:getName()
    --保存房间类型
    gg.UserData:SetConfigKV({["roomtype_" .. self.game.shortname] = sender:getName()})
    --更新按钮的显示
    for i,btn in pairs(self._btnTb) do
        local btnName = btn:getName()
        btn:setLocalZOrder( gg.IIF(sender:getName() == btnName, 1, 0) )

        local img_1 = btn:getChildByName("img_1")
        local img_2 = btn:getChildByName("img_2")
        img_1:setVisible(sender:getName() == btnName)
        img_2:setVisible(sender:getName() ~= btnName)

    end
    --创建房间item
    self:updateRoomList(roomListData ,self._roomListView)
end
--筛选房间列表
function M:RoomListScreen(roomList)
    local roomitem = {}
    if not roomList or table.nums(checktable(roomList)) <= 0 then
        return roomitem
    end
    for k, v in pairs(roomList) do
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

        -- 判断是否是防作弊房间和自由落座房间(cmd 中有 awardType 的是比赛房间，需要排除)
        -- cmd 中 hide 不为 0，不显示在房间列表
        local roomType = gg.GetRoomMode(roomData.type)
        if needShow and checkint(roomData.cmd.hide) == 0 and
        (roomType == ROOM_TYPE_ALLOCSIT or roomType == ROOM_TYPE_ALLOCSIT2 or roomType == ROOM_TYPE_FREE_MODE) then
            table.insert(roomitem, roomData)
        end
    end
    return roomitem
end
--[[
* @brief 更新房间列表
* @param view 更新的房间列表界面
* @param roomList 房间列表
* @param roomListView 房间试图列表
]]
function M:updateRoomList(roomList, roomListView)

    local roomitem = self:RoomListScreen(roomList)
    if table.nums(checktable(roomitem)) <= 0 then
        return
    end
    if hallmanager then
        --获取点击的房间类型
        self.roomtype = hallmanager:isCustom1Room(roomList[1].type)
    end
    -- 房间试图排序
    table.sort(roomitem, function(a,b) return (a.sort or 0 ) < (b.sort or 0) end)
    self.RoomCount =  #roomitem
    local tage = ROOM_ITEM_RANK    --默认一页 3个item 的长度
    if #roomitem > ROOM_ITEY_PAGE then    --获取tage
        local idx = #roomitem / ROOM_ITEY_PAGE
        local yeshu = math.floor(idx)   --取页数下线
        local count =  #roomitem % ROOM_ITEM_RANK --该页的第几个
        local dataSize = #roomitem - ROOM_ITEY_PAGE * yeshu  --获取值大小
        if dataSize < ROOM_ITEM_RANK and dataSize ~= 0 then  --小于3值 不等于0 代表 改页没有满
            tage = yeshu * ROOM_ITEM_RANK + count
        elseif dataSize >= ROOM_ITEM_RANK and dataSize ~= 0 then --大于等于3值 不等于0 代表 改页已经满了
            tage = yeshu * ROOM_ITEM_RANK + ROOM_ITEM_RANK
        else  -- 不等于0 代表 已经是下一页了
            tage = yeshu * ROOM_ITEM_RANK
        end
    end

    local svWidth = math.max(self.scroll_view:getContentSize().height, 274 * tage)
    self.scroll_view:setInnerContainerSize({width = svWidth, height = self.scroll_view:getContentSize().height })

    local pagecount = 1 --页数  1- 6
    local rank = 0   --第几行
    local roomcount = #roomitem

    for i,game in ipairs(roomitem) do
        -- 创建试图
        local item = RoomItem.new("RoomItem", game, self.game.shortname)
        self:createRoomPage(item, pagecount, rank,roomcount)
        self.scroll_view:addChild(item)

        if pagecount == ROOM_ITEY_PAGE then  --每页 6个item
            pagecount = 0
            rank = rank + 1  --是否已经一页了
        end
        pagecount = pagecount + 1
    end

end

-- 刷新房间Item位置
function M:createRoomPage(roomViews, pagecount, ranksize,roomcount)
    if not roomViews then
        return
    end

    local item_width = 145

    -- 设置位置
    local row = math.ceil(pagecount / 3) - 1
    local rank = math.fmod(pagecount - 1, 3)
    roomViews:setPositionX((item_width + 271 * rank + ranksize * 271 * ROOM_ITEM_RANK))
    roomViews:setPositionY(428- (270 / 2 + 195 * row))
end


--特殊场的点击
function M:onClickSpecial( sender )
    if self._preSpecialBtn and self._preSpecialBtn == sender then
        return
    end
    self._preSpecialBtn = sender

    self._roomListView = {}
    self.scroll_view:removeAllChildren()

    --获取房间类型的
    local roomType1, roomType2 = self:getSpecialRomView(ROOM_TYPE_CUSTOM1)
    if sender == self.btn_special1 then
        self:setBtnState(1)
        self:updateRoomList(roomType1, self._roomListView)
        self.btn_special1:setLocalZOrder(1)
        self.btn_special2:setLocalZOrder(0)
    elseif sender == self.btn_special2 then
        self:setBtnState(2)
        self:updateRoomList(roomType2, self._roomListView)
        self.btn_special1:setLocalZOrder(0)
        self.btn_special2:setLocalZOrder(1)
    end
end

function M:onExit()
    if ROOM_TAB_TYPE then
        cc.exports.ROOM_TAB_TYPE = nil
    end
end

function M:onClickClose( sender )
    self:removeSelf()
end

-- 背包
function M:onClickBag()
    gg.AudioManager:playClickEffect()
    self:getScene():createView("BagMainView", true):pushInScene()
end

-- 点击规则
function M:onClickGameRule()
    gg.AudioManager:playClickEffect()
    self:getScene():createView("FeedBackView", checktable(self.game).id, "rule"):pushInScene()
end

-- 快速开始
function M:onClickQuickStart()
    gg.AudioManager:playClickEffect()
    if not self.game then return end
    if hallmanager and hallmanager.userinfo then
        local newRoomId = hallmanager:GetQuickStartRoomID(self.game.id, hallmanager.userinfo.money,self.roomtype)
        if newRoomId then
            hallmanager:JoinRoom(newRoomId)
        else
            -- 快速开始金币数不够时弹出充值提示
            GameApp:DoShell(nil, string.format("PayTips://%d", 1))
        end
    end
end

return M
