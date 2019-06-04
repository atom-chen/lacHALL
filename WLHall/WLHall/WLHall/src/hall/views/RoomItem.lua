
-- Author: liacheng
-- Date:2017-03-08
-- 房间单项

local M = class("RoomItem", cc.load("ViewLayout"))
M.RESOURCE_FILENAME = "ui/room/item_room.lua"
M.RESOURCE_BINDING = {
    ["img_bk"]     = {["varname"] = "img_bk"    },        -- 背景
    ["img_bg"]     = {["varname"] = "img_bg"    },
    ["txt_title"]  = {["varname"] = "txt_title" },        -- 标题名字
    ["txt_min"]    = {["varname"] = "txt_min"   },        -- 入场钱数
    ["txt_difen"]  = {["varname"] = "txt_difen" },        -- 低分
    ["txt_person"] = {["varname"] = "txt_person"},        -- 人数
    ["img_head"] = {["varname"] = "img_head"},            --头像

    ["img_dizhu"]  = {["varname"] = "img_dizhu" },
    ["honor"]      = {["varname"] = "honor"     },        -- 荣誉值
}
--[[
*@brief 创建
*@param data 单项数据
]]
function M:onCreate(data, shortname)
    if not data then
        return
    end

    self._data = data
    self._gameshortname = shortname

    --点击item不能翻页的解决方法
    self.img_bk:retain()
    self.img_bk:removeFromParent( true )
    self:addChild(self.img_bk)
    self.img_bk:release()

    self.img_bk:onClickScaleEffect(handler(self, self.onClickJoinListRoom))
    self.img_bk:setTag(data.id)

    self.honor:setVisible(false)
    self:initView(data)
    self:setContentSize(cc.size(200, 200))

    GameApp:addEventListener(gg.Event.HALL_UPDATE_UPDATE_ROOM_PLAYERS, handler(self, self.onUpdateRoomPlayersCnt), self)
end

function M:onUpdateRoomPlayersCnt(event, list)
    if tolua.isnull(self) then return end
    if not self._data then return end

    for k,v in pairs(checktable(list)) do
        if self._data.id == k then
            self._data.players = v
            break
        end
    end
    self:setRoomPlayersCnt(self._data)
end

function M:setRoomPlayersCnt(data)
    if not data then return end

    local level = gg.GetRoomLevel(data.type)
    local LVIndex = level
    if level == ROOM_TYPE_LEVEL_3 and Helper.And(data.type, 0x8000) ~= 0 then
        -- 至尊场
        LVIndex = 4
    end

    -- 人数
    local playersNum = checkint(data.players)
    -- 混房间存在，重置人数
    if data.mixedRoom then
        -- 根据房间级别模拟计算房间人数
        local rate = (100 - LVIndex * 15) / 100
        local mpCnt = data.mixedRoom.players
        -- 防止数据过时，重新查找对应的混房间真实人数
        if hallmanager and hallmanager.rooms then
            local mixroom = hallmanager.rooms[data.mixedRoom.id]
            if mixroom then
                mpCnt = mixroom.players
            end
        end
        playersNum = checkint(mpCnt * rate)
    end
    if playersNum < 100 then
        math.randomseed(socket:gettime())
        playersNum = math.random(100, 200)
    end
    self.txt_person:setString(string.format("%d", playersNum))
end

function M:initView(data)
    -- 标题
    self.txt_title:setString( data.name or "普通场" )

    -- 底分显示为
    local function changeNum(count)
        if count >= 1000000 then
            return gg.MoneyBaseUnit(count, 1000000) .. "b"
        elseif count >= 10000 then
            return  gg.MoneyBaseUnit(count, 10000) .. "w"
        elseif count >= 1000 then
            return gg.MoneyBaseUnit(count, 1000) .. "q"
        else
            return tostring(count)
        end
    end
    -- 底分
    if data.basemoney <10000 then
        self.txt_difen:setString(string.format( "%d",data.basemoney))
    else
        self.txt_difen:setString(changeNum(data.basemoney))
    end

    -- 根据房间等级设置房间样式
    local level = gg.GetRoomLevel( data.type )

    local LVIndex = level
    if level == ROOM_TYPE_LEVEL_3 and Helper.And(data.type, 0x8000) ~= 0 then
        -- 至尊场
        LVIndex = 4
    end

    --背景图片
    self.img_bg:loadTexture(string.format("hall/room/newroom/img_bg%d.png", LVIndex))

    -- 荣誉开关开启时,显示荣誉分倍数
    if GameApp:CheckModuleEnable(ModuleTag.Honor) and data.cmd and data.cmd.hs then
        self.honor:setVisible(true)
        local txt_beishu = self.honor:getChildByName("txt_bei")
        txt_beishu:setString("x" .. data.cmd.hs)
    end

    -- 人数
    self:setRoomPlayersCnt(data)
    --设置头像位置
    self.img_head:setPositionX(self.txt_person:getPositionX() - self.txt_person:getSize().width -3)
    -- 最小钱数
    local minmoney = data.minmoney
    local minmoneyTr = gg.MoneyUnit(minmoney)

    -- 设置最小金额
    if minmoney >= 1000 and minmoney < 10000 then
        minmoneyTr = gg.MoneyBaseUnit(minmoney, 1000) .. "千"
    end

    -- 最大钱数
    local maxmoney = data.maxmoney
    local maxmoneyTr = gg.MoneyUnit(maxmoney)

    -- 设置最大金额
    if maxmoney >= 1000 and maxmoney < 10000 then
        maxmoneyTr = gg.MoneyBaseUnit(maxmoney, 1000) .. "千"
    end

    -- 大于一亿不显示
    local str = ""
    if maxmoney < 100000000 then
        str =  minmoneyTr.."-"..maxmoneyTr
    else
        str =  minmoneyTr
    end

    self.txt_min:setString( str )
    local scaling = 1
    -- 德州扑克特殊处理
    if self._gameshortname == "dzpk" or self._gameshortname == "dzjs" then
        --前注
        if data.cmd.qianzhu then
            local  txt_qianzhu = ccui.Text:create()
            txt_qianzhu:setFontSize(24)
            txt_qianzhu:setString("前注:")
            txt_qianzhu:setTextColor({r = 77, g = 77, b = 77})      --字体显示灰色
            txt_qianzhu:setAnchorPoint(cc.p(0.5,0.5))
            --txt_qianzhu:setRotationSkewX(10)
            txt_qianzhu:setPosition(cc.p(self.img_bk:getContentSize().width/2, 65))
            self.img_bk:addChild(txt_qianzhu)

            local  txt_count = ccui.Text:create()
            txt_count:setFontSize(26)
            txt_count:setString(data.cmd.qianzhu)
            txt_count:setTextColor({r = 77, g = 77, b = 77})      --字体显示灰色
            --txt_count:setRotationSkewX(10)
            txt_count:setAnchorPoint(cc.p(0,0.5))
            self.img_bk:addChild(txt_count)

            local txt_count_half = txt_count:getContentSize().width/2
            txt_qianzhu:setPosition(cc.p(self.img_bk:getContentSize().width/2 - txt_count_half, 60))
            txt_count:setPosition(cc.p(txt_qianzhu:getPositionX()+txt_qianzhu:getContentSize().width/2, 60))
        end

        -- 替换底分标志，改为显示盲注
        self.img_dizhu:loadTexture("hall/room/newroom/img_mz.png",1)
        self.txt_difen:setString(string.format("%s&%s", changeNum(data.basemoney), changeNum(data.basemoney * 2)))
        local txt_size = self.txt_difen:getContentSize().width
        if txt_size > 180 then
            scaling = 180 / txt_size
        end
        self.txt_difen:setScale(scaling)

    end
    local txt_count_half = (self.txt_difen:getContentSize().width*scaling )/ 2
    self.img_dizhu:setPosition(cc.p(self.img_bk:getContentSize().width / 2 - txt_count_half - 4, 98))
    self.txt_difen:setPosition(cc.p(self.img_dizhu:getPositionX() + self.img_dizhu:getContentSize().width / 2 + 8, 98))
end

--[[
* @brief 房间列表点击事件
]]
function M:onClickJoinListRoom(sender, eventType)
    local tag = sender:getTag()
    print( string.format( "房间ID：%d",tag ) )

    -- 加入房间
    if tag and hallmanager then
        if hallmanager:IsInFriendRoom() then
            return
        end

        hallmanager:JoinRoom(tag, false)
    else
        printf(string.format( "加入房间失败, 房间ID：%d",tag ))
    end
end

return M