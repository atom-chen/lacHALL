local MSG_ID=import(".HallMsg")
local MSG_HALL_LEAVE_GAME=8201
local DEFAULT_SORT_INDEX = 0x80000000  --//应用默认排序值
local CRYPT_MSG= MSG_HEADER_FLAG_COMPRESS+MSG_HEADER_FLAG_ENCODE+MSG_HEADER_FLAG_MASK
local AppList = {}  --//应用列表

local ShortNameIdMap={}--游戏短名id关系表
local AgentRoomLimit = 50

local e = import(".HallEvent")--大厅事件表
--创建大厅管理器类
local HallManager = ClassEx("HallManager", function()
    local  obj = CHallManager.New()
    obj.event= e
    obj.http=require("common.HttpProxyHelper").new():RegisterHttpProxyEvent(obj,true)
    return obj
end )

-- 申请钻石救济金的任务 ID。
-- 因为 constants.lua 热更新的话会报错，所以将这个任务类型定义在这里
HallManager.MISSION_DAILY_GIFT_XZMONEY = 3

--登录管理器创建函数
function HallManager:getInstance()
    if hallmanager ~= nil then
        return hallmanager
    end
    local mgr = HallManager.new()
    if mgr:Initialize() then
        rawset(_G, "hallmanager", mgr)
        return hallmanager
    else
        mgr:dealloc()
    end
end

--销毁大厅管理器
function HallManager:dealloc()
    self.http:Shutdown()
    self:Shutdown()
    rawset(_G, "hallmanager", nil)

    -- 停止计时器
    self:StopMatchTimer()
end

--连接成功回调  失败无回调
function HallManager:Reconnect(onconnectedcallback)
   local data= self:GetConnectInfo()
 --  self:ExitRoom()
   self:dealloc()
   local obj= HallManager:getInstance()
   if obj then
       obj:Connect(data,onconnectedcallback)
   end
end

function HallManager:Connect(data,onconnectedcallback)
    if not( data.session or data.id or data.ip or data.port) then
       return nil
    end
    self.onconnectedcallback_=onconnectedcallback
    if not self:ConnectToHall(data) then
        GameApp:dispatchEvent(gg.Event.NETWORK_ERROR,NET_ERR_TAG_HALL,-3)
        self:dealloc()
        return nil
    end
    return self
end


-- 连接成功初始化操作
function HallManager:init()
    return true
end

function HallManager:IsConnected()
    return self.isConnected_
end

function HallManager:GetConnectInfo()
    return {id=self:GetSelfID(),session=self.session,ip=self.hallserverip,port=self.hallserverport}
end

function HallManager:GetHttp()
    return self.http
end

function HallManager:GameShortName2Id(shotname)

end

-- 检查玩家在线时长，进行防沉迷的相应处理
function HallManager:CheckTireTime()
    local tiretime = checkint(USER_TIRE_TIME)

    -- 防沉迷功能未开启或用户的 tiretime 为 -1，直接返回
    if not GameApp:CheckModuleEnable(ModuleTag.CheckTireTime) or tiretime == -1 then
        return
    end

    -- 未达到防沉迷时间要求，不需要处理
    if tiretime < TIRE_TIME_LIMIT_1 then
        return
    end

    -- 检查玩家是否已实名认证
    gg.UserData:checkLoaded(function()
        local idCard, isBindIDCard = gg.UserData:GetIdCardSuffix()
        if isBindIDCard then
            -- 已实名认证的用户不处理
            return
        end

        local tipMsg
        local tipMode
        if tiretime >= TIRE_TIME_LIMIT_2 then
            local personMainView = GameApp:getRunningScene():getChildByName("personal.PersonMainView")
            if not IS_TIIPING_TIME_LIMIT_2 and not personMainView then
                -- 超过5小时了，提示实名认证或者退出登录
                tipMsg = string.format("根据国家法律法规要求，未实名认证账号每天游戏时间不能超过%s小时。请进行实名认证！", TIRE_TIME_LIMIT_2 / 3600)
                tipMode = gg.MessageDialog.MODE_OK_CANCEL

                -- 记录正在显示防沉迷确认框
                cc.exports.IS_TIIPING_TIME_LIMIT_2 = true
            end
        elseif tiretime >= TIRE_TIME_LIMIT_1 and not TIRE_TIME_TIP_POPED_1 then
            -- 超过3小时了，且3小时提醒还未显示，提示收益减半
            tipMsg = string.format("您今天累计游戏时间已超过%s小时，根据国家法律法规要求，游戏收益将减半。请尽快实名认证！", TIRE_TIME_LIMIT_1 / 3600)
            tipMode = gg.MessageDialog.MODE_OK_CLOSE
            cc.exports.TIRE_TIME_TIP_POPED_1 = true
        end

        if tipMsg then
            GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG, tipMsg, function(bttype)
                if bttype == gg.MessageDialog.EVENT_TYPE_OK then
                    -- 弹出实名认证
                    GameApp:DoShell(nil, "PersonInfo://real_name")
                elseif bttype == gg.MessageDialog.EVENT_TYPE_CANCEL then
                    -- 退出登录
                    GameApp:Logout()
                end

                -- 防沉迷确认框关闭了，取消记录的标记状态
                if IS_TIIPING_TIME_LIMIT_2 then
                    IS_TIIPING_TIME_LIMIT_2 = false
                end
            end, { mode=tipMode, ok="立即认证", cancel="退出游戏", backdisable=true})
        end
    end)
end

--获得所有应用列表
function HallManager:GetAppList()
    return AppList
end

--返回指定ID的游戏是否添加
function HallManager:IsGameAdded(gameid)
    local game = gg.LocalConfig:GetCustomGameTable()[""..gameid]
    return  checkint(game)~=0
end

function HallManager:GetSession()
    return self.session
end

-- 获取玩家荣誉分
function HallManager:GetHonorValue()
    return gg.toSignInt(checktable(self.userinfo).prestige)
end

--[[
* @brief 添加一个游戏应用(或移除)
* @param [in] gameid 添加或者移除的游戏ID
* @param [in] added 是否是添加
]]
function HallManager:AddGameApp(gameid,added)
    gg.LocalConfig:SetCustomGame(gameid, gg.IIF(added,1,nil))
    self:UpdateGameList()
end

--获取房卡消耗基数
function HallManager:GetRoomCardCost(gameidorshot, isVideo)
    if gameidorshot then
        local key = "fknum"
        if isVideo then
            key = "vnum"
        end
        local gameid = checkint(gg.IIF(type(gameidorshot)=="string", ShortNameIdMap[gameidorshot] ,gameidorshot))
        for k,room in pairs(self.rooms) do
            if room.gameid == gameid and room.cmd[key] then
                return checkint(room.cmd[key])
            end
        end
    end
    return 0
end
--获取房卡数
function HallManager:GetRoomCardCount()
    return checkint( checktable(self.proplist)[PROP_ID_ROOM_CARD] )
end

--获取钻石数
function HallManager:GetXZMoneyCount()
    return checkint(checktable(hallmanager.userinfo).xzmoney)
end

--获取道具列表 道具开始id  道具 结束id
function HallManager:GetPropList(beginid,endid)
    beginid= beginid or 0
    endid=endid or 65535
    local prop={}
    for k,v in pairs(checktable(self.proplist)) do
        if k>=beginid and k<=endid then
           prop[k]=v
        end
    end
    return prop
end

-- 获取道具id对应的道具数量
function HallManager:GetPropCountByID(propid)
    return checkint(checktable(self.proplist)[propid])
end

-- 使用道具
function HallManager:DoUseProp(userid, propid, propcnt)
    propcnt = propcnt or 1

    local msg = CLuaMsgHeader.New()
    msg.id = MSG_ID.USE_PROP
    msg:WriteDword(propid)
    msg:WriteDword(propcnt)
    msg:WriteDword(userid)
    self:SendData(msg, CRYPT_MSG)
end

--更新二人斗地主连胜数据
function HallManager:UpdateErdzWinSteak(val)
  local dat= checktable(checktable(self.gamedata)["erdz"])
  dat.cbTaskData[13]=checkint(dat.cbTaskData[13])+checknumber(val,nil,1)
end

--二人斗地主连胜数据
function HallManager:GetErdzWinSteak( )
  local dat= checktable(checktable(self.gamedata)["erdz"])
   return checkint(dat.cbTaskData[13])
end

--获取用户游戏数据
function HallManager:GetUserGameData(shotname)
    if shotname then
        local dat= checktable(checktable(self.gamedata)[shotname])
        return dat
    else
        return checktable(self.gamedata)
    end
end

-- 获取是否有可玩的小游戏
function HallManager:HasMiniGames()
    -- 小游戏开关关闭不显示
    if not GameApp:CheckModuleEnable(ModuleTag.Hot) then
        return false
    end

    -- 游戏局数限制不满足时不显示
    local num_limit = checkint(HOT_MIN_HONOR)
    local totalCnt = checkint(hallmanager:GetEffortData(EffortData.TOTAL_GAME_COUNT))
    if num_limit == -1 or totalCnt < num_limit then
        return false
    end

    -- TODO 筛选可玩的小游戏
    return #self:GetLeisureGame() > 0
end

function HallManager:GetFishGames(data)
    local data = checktable(data)
    local tb = {226, 550}
    local games = gg.IIF(table.nums(data) > 0, data, self:GetLeisureGame())
    local fishGames = {}
    for k,v in pairs(games) do
        if Table:isValueExist(tb, v.id) then
            table.insert(fishGames, v)
        end
    end

    return fishGames
end

--[[加入指定ID的游戏 显示房间列表
    gameid  游戏id
]]
function HallManager:JoinGame(gameid,statuscallback,room)
    assert(gameid and gameid>0 ,"gameid params error")
    printf("HallManager:JoinGame %d ",checkint(gameid))
    local  game = checktable(self.games)[gameid]
    local ok,bupdating
    ok,bupdating= self:CheckCanJoinGame(game,true,statuscallback)
    if ok and not bupdating then
        game.relation_type = RELATION_TYPE_GAME
        if room then
            local roomType = gg.GetRoomMode( room.type )
            if  roomType == ROOM_TYPE_PK_MODE1 or roomType == ROOM_TYPE_PK_MODE2 or roomType == ROOM_TYPE_PK_MODE3 or roomType == ROOM_TYPE_PK_MODE4 then
                return true
            end
        end
        self.roomData_ = require( "hall.models.RoomData" ).new( game )
        local roomList = self.roomData_:getRoomList()
        -- 显示或刷新房间列表
        GameApp:dispatchEvent(gg.Event.SHOW_ROOM_LIST,roomList , game)
        return true
    else
        return false
    end
end

-- 快速开始房间筛选，身上金币数/2进入能进入的最高场次
function HallManager:GetQuickStartRoomID(gameid, money, roomtype)
    local game = self.games[gameid]
    local mdiv = checktable(game.cmd).mdiv or 2
    money = checkint(money / mdiv)
    if money <= 0 then return nil end

    local roomsTb = self:GetRoomsByGameId(gameid)
    local roomMode = Helper.Or(ROOM_TYPE_ALLOCSIT, ROOM_TYPE_ALLOCSIT2, ROOM_TYPE_FREE_MODE)
    -- 筛选出自由落座的房间
    roomsTb = self:FilterRoomsByMode(roomsTb, roomMode)
    -- 筛选不是所选类型的房间
    roomsTb = self:FilterRoomsByType(roomsTb, roomtype)
    -- 筛选掉比赛房间
    roomsTb = self:FilterMatchRooms(roomsTb)
    -- 筛选掉设置为不可点进去的房间
    roomsTb = self:FilterForbiddenRoom(roomsTb)
    -- 筛掉受渠道限制的房间
    roomsTb = self:FilterChannelLimitRoom(roomsTb)
    -- 筛掉混房间
    roomsTb = self:FilterMixedRoom(roomsTb)
    -- 筛掉cmd.tab不是ROOM_TAB_TYPE字段类型房间
    roomsTb = self:FilterTabRoom(roomsTb)

    table.filter(roomsTb, function(v, k)
        if v.cmd.awardType then return false end
        -- 豆豆数不符合房间
        if money < v.minmoney or money > v.maxmoney then
            return false
        end

        local roomLevel = gg.GetRoomLevel(v.type)
        if roomLevel == ROOM_TYPE_LEVEL_0 then
            return false
        end

        return true
    end)

    if table.nums(roomsTb) <= 0 then
        print("没有符合条件的房间，使用玩家的实际钱数找到推荐房间")
        return self:GetRoomIDByMoney(gameid, checkint(money * mdiv), roomtype)
    end

    -- 将筛选出的房间重新插入新表用于排序
    local tb = {}
    for k,v in pairs(roomsTb) do
        table.insert(tb, v)
    end
    -- 按等级从高到低排序，等级相同按显示的先后顺序
    local function sortA(a, b)
        local t1 = gg.GetRoomLevel(a.type)
        local t2 = gg.GetRoomLevel(b.type)
        local v1 = gg.IIF(Helper.And(a.type, 0x8000) ~= 0, 1, 0)
        local v2 = gg.IIF(Helper.And(b.type, 0x8000) ~= 0, 1, 0)
        local s1 = checkint(a.cmd.sort)
        local s2 = checkint(b.cmd.sort)
        if t1 ~= t2 then
            return t1 > t2
        elseif v1 ~= v2 then
            return v1 > v2
        elseif s1 ~= s2 then
            return s1 > s2
        else
            return checkint(a.minmoney) > checkint(b.minmoney)
        end
    end
    table.sort(tb, sortA)

    if tb[1] then
        return tb[1].id
    end

    return nil
end

--[[
* @brief 根据玩家身上携带豆数获取指定游戏推荐进入的房间
* @param gameid 游戏 id
* @param money 豆数
]]
function HallManager:GetRoomIDByMoney(gameid, money, roomTypes)
    local id = nil

    for k, v in pairs(self.rooms) do
        if v and v.gameid == gameid then
            local roomLevel = gg.GetRoomLevel( v.type )
            local roomType = gg.GetRoomMode( v.type )
            local type = true
            --点击房间所保存的类型 只有特殊的房间才有数据 --牛牛 --扎金花
            --房间类型1
            if checkint(roomTypes) == 2  and Helper.And(v.type, ROOM_TYPE_CUSTOM1) == 0 then
                type = false
            --房间类型2 并且不是类型1的
            elseif checkint(roomTypes) == 1  and Helper.And(v.type, ROOM_TYPE_CUSTOM1) ~= 0 then
                type = false
            end
            -- 判断房间是否受渠道限制
            local noLimit = true
            if v.cmd.cn then
                -- 房间限制指定的渠道才能显示，判断渠道
                local cnList = string.split(v.cmd.cn, ",")
                noLimit = Table:isValueExist(cnList, CHANNEL_ID)
            elseif v.cmd.ncn then
                -- 房间限制指定的渠道不显示，判断渠道
                local ncnList = string.split(v.cmd.ncn, ",")
                noLimit = (not Table:isValueExist(ncnList, CHANNEL_ID))
            end
            
            -- 判断房间是否受tab限制，类型不同就排除
            if ROOM_TAB_TYPE and (checktable(v.cmd).tab and checktable(v.cmd).tab ~= ROOM_TAB_TYPE) then
                noLimit = false
            end

            if noLimit and (not v.cmd.awardType) and roomType == ROOM_TYPE_ALLOCSIT or roomType == ROOM_TYPE_ALLOCSIT2 or roomType == ROOM_TYPE_FREE_MODE then
                if v.maxmoney > money                               -- 豆数必须小于房间豆数的上限
                    and money > v.minmoney                          -- 满足条件的情况下，尽量进低级的房间
                    and roomLevel ~= ROOM_TYPE_LEVEL_0              -- 排除掉新手场
                    and (not checktable(v.cmd).mrl)                 -- 排除掉混房间
                    and not type then                               -- 排除不是改类型的房间
                    id = v.id
                    break
                end
            end
        end
    end

    return id
end

--[[
* @brief 进入房间
* @param bReconnect 是否断线重连进来
* @param roommgr 房间管理器(2018-02-27新增参数)，用于传入特殊游戏自带的房间管理器
]]
function HallManager:JoinRoom(roomid,bReconnect,callback,roommgr)
    printf("HallManager:JoinRoom roomid= %d  reconnect=  %s",checkint(roomid),tostring(bReconnect) )
    if self.roommanager then
        printf("JoinRoom Shutdown %s roomid= %d  ",tostring(self.roommanager),checkint(roomid) )
        self.roommanager:ExitRoom()
    end

    local room = checktable(self.rooms)[roomid]
    if not room then
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "房间不存在，错误码:1")
        return
    end

    -- 处理不是该类型的房间
    local clickRoomtype = self:isCustom1Room(room.type)

    -- 处理混房间
    local mappedRoom = nil
    -- 如果房间命令行存在mr字段，则找到对应的混房间
    if (not checktable(room.cmd).mrl) and checktable(room.cmd).mr and checkint(checktable(room.cmd).mr) > 0 then
        mappedRoom = room
        roomid = checkint(room.cmd.mr)
        room = checktable(self.rooms)[roomid]
        if not room then
            GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "房间不存在，错误码:2")
            print("未找到对应的混房间！！！")
            return
        end

        -- 混房间与正式房间游戏是否一致判断
        if checkint(mappedRoom.gameid) ~= checkint(room.gameid) then
            GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "房间不存在，错误码:3")
            print("混房间与映射的正式房间游戏不一致，请检查后台配置！！！")
            return
        end
    end

    if GameApp:CheckModuleEnable(ModuleTag.VIP) then
        -- 金币场中的新手场需要限制 vip3 的玩家进入( cmd 中有 awardType 的是比赛房间，需要排除)
        local roomType = gg.GetRoomMode( room.type )
        if (not room.cmd.awardType) and roomType == ROOM_TYPE_ALLOCSIT or roomType == ROOM_TYPE_ALLOCSIT2 or roomType == ROOM_TYPE_FREE_MODE then
            -- 如果是进入金币场
            local level = gg.GetRoomLevel( room.type )
            if level == ROOM_TYPE_LEVEL_0 then
                -- 是要进入新手场房间，需要检查玩家的 vip 等级是否 >= 3
                local vValue,minexp,maxexp = gg.GetVipLevel(self.userinfo.vipvalue)
                if vValue >= 3 then
                    -- 提示玩家进入更高级的房间
                    GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG, "豪爷，您已经VIP"..vValue.."了，给新手留条生路吧！", function(bttype)
                        if bttype == gg.MessageDialog.EVENT_TYPE_OK then
                            -- 进入推荐房间
                            local newRoomId = self:GetRoomIDByMoney(room.gameid, self.userinfo.money, clickRoomtype)
                            if newRoomId then
                                print("--- 进入推荐房间 : "..newRoomId)
                                self:JoinRoom(newRoomId)
                            end
                        end
                    end, { mode=gg.MessageDialog.MODE_OK_CLOSE, ok="进入推荐房间"})
                    return
                end
            end
        end
    end

    local game = checktable(self.games)[checkint(room.gameid)]
    local ok,bupdating= self:CheckCanJoinGame(game)
    if bupdating ==true then
        GameApp:dispatchEvent(gg.Event.SHOW_LOADING, "正在更新,请稍后！")
    end
    if not ok then
        -- 没有相应的游戏，或者游戏需要更新。不能请求进入房间
        --GameApp:dispatchEvent(gg.Event.SHOW_TOAST , "进入房间失败！" )
        return
    end
    -- self:GiftMoneyInRoom(roomid)
    -- 如果未传入了特定的房间管理器，则根据房间属性来创建对应的房间管理器
    if not roommgr then
        roommgr = GameApp:CreateRoomManager(roomid, room.type, callback)
    end

    if roommgr then
        self.roommanager = roommgr

        -- 如果是混房间模式，需自行判断房间上下限问题
        if mappedRoom then
            local uMoney = checkint(self.userinfo.money)
            if uMoney < mappedRoom.minmoney then
                e.OnMsgJoinRoom(self, 5)
                return
            elseif uMoney > mappedRoom.maxmoney then
                e.OnMsgJoinRoom(self, 6)
                return
            end
        end

        if not bReconnect then
            GameApp:dispatchEvent(gg.Event.SHOW_LOADING , "正在连接游戏...",CONNECT_TIMEOUT,function(...)
                GameApp:dispatchEvent(gg.Event.NETWORK_ERROR,NET_ERR_TAG_HALL,-6)
            end, false, false, true)
        end
        self:SendJoinRoom(roomid)  --发送进入房间消息

        -- 设置混房间映射房间
        if mappedRoom and roommgr.setMappedRoomId and roommgr.setMixedRoomId then
            roommgr:setMappedRoomId(mappedRoom.id)
            roommgr:setMixedRoomId(roomid)
        end

        -- 混房间断线重连
        if mappedRoom == nil and room.cmd.mrl and roommgr.setMixedRoomId and roommgr.setMixedRoomReconnect then
            roommgr:setMixedRoomId(roomid)
            roommgr:setMixedRoomReconnect(true)
        end

        printf("send JoinRoom request %s roomid= %d callbakc=%s",tostring(roommgr),checkint(roomid),tostring(callback) )
        return self.roommanager
    else
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST , "加入房间失败！" )
    end
end

--查询房间号
function HallManager:JoinFriendRoomByRoomKey(roomkey)
    -- 游客登录的玩家提示激活或者微信登录
    if self.userinfo.userfrom == USER_FROM_UNLOGIN then
        self:tipUnloginUser()
        return
    end

    assert(roomkey and #roomkey==6,"请检查房间号"..tostring(roomkey))
   local MSG_ID = require ("hall.managers.HallMsg")
    --  发送消息
    local msg = CLuaMsgHeader.New()
    msg.id = MSG_ID.QUERY_ROOMKEY
    msg:WriteDword( roomkey)
    self:SendData(msg,CRYPT_MSG)
    printf("send query room key message ="..roomkey)
end

function HallManager:CreateFriendRoomById(roomid,ruletable)
    local roommgr
    roommgr=self:JoinRoom(roomid, (GameApp:IsReconnecting()),function ()
        if roommgr then
            roommgr:CreateGroup( ruletable )
        end
    end)
    return roommgr
end

function HallManager:tipUnloginUser(msg1, msg2)
    if not GameApp:CheckModuleEnable(ModuleTag.WeixinLogin) then
        -- 允许有 微乐账号登录，但不允许有微信登录，所以在这里屏蔽掉微信登录
        GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG, msg1 or "请激活账号。", function(bttype)
            if bttype == gg.MessageDialog.EVENT_TYPE_OK then
                GameApp:DoShell(nil, "PersonInfo://bind")
            end
        end, { mode=gg.MessageDialog.MODE_OK_CLOSE, ok="激活账号"})
    else
        GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG, msg2 or "请激活账号或者使用微信登录。", function(bttype)
            if bttype == gg.MessageDialog.EVENT_TYPE_OK then
                GameApp:DoShell(nil, "PersonInfo://bind")
            elseif bttype == gg.MessageDialog.EVENT_TYPE_CANCEL then
                GameApp:Logout()
            end
        end, { mode=gg.MessageDialog.MODE_OK_CANCEL_CLOSE, cancel="微信登录", ok="激活账号"})
    end
end

--创建朋友场房间
function HallManager:CreateFriendRoom(shortname,ruletable,playercount,agent,cardnum,permission,creditUser)
    -- 游客登录的玩家提示激活或者微信登录
    if self.userinfo.userfrom == USER_FROM_UNLOGIN then
        self:tipUnloginUser()
        return
    end

    local  gameid= checkint(ShortNameIdMap[shortname])
    assert(gameid >0,"游戏短名解析错误 :"..tostring(shortname))
    if gameid >0 then
        local room = self:GetRoomByCondition(gameid, nil, ROOM_TYPE_FRIEND_TEAM, playercount)
        if room then
            if checkint(agent) > 0 or checkint(creditUser) > 0 then  --代开房间或者信用好友
                self:DoCreateRoomAgent(room.id,ruletable,cardnum,permission,creditUser,gameid)
            else
                local roommgr= self:CreateFriendRoomById(room.id,ruletable)
                if not roommgr then
                    GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "近期开放,敬请期待！")
                    printf("没有开放" .. tostring(playercount) .. "人朋友场")
                end
            end
        else
             GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "房间不存在！")
             printf("没有开放" .. tostring(playercount) .. "人朋友场，房间不存在")
        end
    end
end

--快速加入推荐房间 --加入指定类型房间
function HallManager:JoinRoomByGameId(gameid, roomlevel, roommode, playercount, callback, roomtype)
    local newroomType = self:isCustom1Room(roomtype)
    local roomid = self:GetQuickStartRoomID(gameid, self.userinfo.money, newroomType)
    if roomid then
        local room = self.rooms[roomid]
        if room then
            playercount = playercount or room.playersperdesk
            if room.playersperdesk == playercount then
                return self:JoinRoom(room.id, (GameApp:IsReconnecting()), callback)
            end
        end
    end
end

-- 获取下一级别的游戏房间id
-- 返回0则代表没有更高级别的游戏房间了
function HallManager:GetNextLevelRoomID(curRoomId)
    local curRoom = self.rooms[curRoomId]
    if not curRoom then return 0 end

    -- 如果是在混房间内，需要通过房间管理器找到对应映射的正式房间id
    if checktable(curRoom.cmd).mrl then
        if self.roommanager and self.roommanager.getMappedRoomId then
            local mapRoomId = self.roommanager:getMappedRoomId()
            curRoom = self.rooms[mapRoomId]
            if not curRoom then return 0 end
        else
            return 0
        end
    end

    local gameid = curRoom.gameid       -- 当前房间的游戏
    local curType = gg.GetRoomLevel(curRoom.type)     -- 当前房间类型
    local newroomType = self:isCustom1Room(curRoom.type) --新的房间类型
    local roomsTb = self:GetRoomsByGameId(gameid)
    local roomMode = Helper.Or(ROOM_TYPE_ALLOCSIT, ROOM_TYPE_ALLOCSIT2)
    -- 筛选出自由落座的房间
    roomsTb = self:FilterRoomsByMode(roomsTb, roomMode)
    -- 筛选掉比赛房间
    roomsTb = self:FilterMatchRooms(roomsTb)
    -- 筛选掉设置为不可点进去的房间
    roomsTb = self:FilterForbiddenRoom(roomsTb)
    -- 筛掉受渠道限制的房间
    roomsTb = self:FilterChannelLimitRoom(roomsTb)
    -- 筛掉混房间
    roomsTb = self:FilterMixedRoom(roomsTb)

    -- 特殊类型的房间推荐进入相同特殊类型的更高级房间
    if Helper.And(curRoom.type, ROOM_TYPE_CUSTOM1) == 0 then
        table.filter(roomsTb, function(v, k)
            return Helper.And(v.type, ROOM_TYPE_CUSTOM1) == 0
        end)
    else
        table.filter(roomsTb, function(v, k)
            return Helper.And(v.type, ROOM_TYPE_CUSTOM1) ~= 0
        end)
    end

    -- 筛选出比当前等级高的房间
    table.filter(roomsTb, function(v, k)
        if gg.GetRoomLevel(v.type) ~= curType then
            return gg.GetRoomLevel(v.type) > curType
        else
            return Helper.And(v.type, 0x8000) ~= 0
        end
    end)

    if table.nums(roomsTb) <= 0 then
        print("没有更高级别的房间了！！！")
        return 0
    end

    -- 将筛选出的房间重新插入新表用于排序
    local tb = {}
    for k,v in pairs(roomsTb) do
        table.insert(tb, v)
    end
    -- 按等级从低到高排序，等级相同按显示的先后顺序
    local function sortA(a, b)
        local t1 = gg.GetRoomLevel(a.type)
        local t2 = gg.GetRoomLevel(b.type)
        local v1 = gg.IIF(Helper.And(a.type, 0x8000) ~= 0, 1, 0)
        local v2 = gg.IIF(Helper.And(b.type, 0x8000) ~= 0, 1, 0)
        if t1 ~= t2 then
            return t1 < t2
        elseif v1 ~= v2 then
            return v1 < v2
        else
            return checkint(a.cmd.sort) < checkint(b.cmd.sort)
        end
    end
    table.sort(tb, sortA)
    -- 找出符合携带金钱数量的高等级房间进入
    local uMoney = checkint(self.userinfo.money)
    for i,room in ipairs(tb) do
        if uMoney >= checkint(room.minmoney) and uMoney <= checkint(room.maxmoney) then
            return checkint(room.id)
        end
    end

    return 0
end

--根据条件 获取即将进入的房间
function HallManager:GetRoomByCondition(gameid,roomlevel,roommode,playercount,roomtype)
    gameid=checkint(gameid)
    local gamerooms= self:GetRoomsByGameId(gameid)
    roommode =roommode or Helper.Or(ROOM_TYPE_ALLOCSIT,ROOM_TYPE_ALLOCSIT2)
    gamerooms=self:FilterRoomsByLevel(gamerooms,roomlevel)
    gamerooms=self:FilterRoomsByMode(gamerooms,roommode)
    gamerooms=self:FilterMatchRooms(gamerooms) -- 过滤掉比赛房间，即比赛房间不能通过推荐自动进入
    -- 过滤掉禁止自动加入的房间
    gamerooms=self:FilterForbiddenRoom(gamerooms)
    -- 过滤不是该类型的房间
    gamerooms=self:FilterRoomsByType(gamerooms,roomtype)
    -- 过滤渠道限制房间
    gamerooms = self:FilterChannelLimitRoom(gamerooms)
    -- 筛掉混房间
    gamerooms = self:FilterMixedRoom(gamerooms)

    local cusor
    for k,v in pairs(checktable(gamerooms)) do
        local bok,reason = self:CheckCanJoinRoom(v)
        if bok and playercount then
            bok= (v.playersperdesk==checkint(playercount))
        end
        if bok then
            cusor= cusor or k
            if self:GetRoomRealPlayers(gamerooms[cusor])>=self:GetRoomRealPlayers(v) then
                cusor=k
            end
        end
    end
    return  gamerooms[cusor]
end

-- 筛选掉渠道限制的房间
function HallManager:FilterChannelLimitRoom(rooms)
    local room =(checktable(rooms))
    table.filter(room, function(v, k)
        local noLimit = true
        if v.cmd.cn then
            -- 房间限制指定的渠道才能显示，判断渠道
            local cnList = string.split(v.cmd.cn, ",")
            noLimit = Table:isValueExist(cnList, CHANNEL_ID)
        elseif v.cmd.ncn then
            -- 房间限制指定的渠道不显示，判断渠道
            local ncnList = string.split(v.cmd.ncn, ",")
            noLimit = (not Table:isValueExist(ncnList, CHANNEL_ID))
        end
        return noLimit
    end)
    return room
end

-- 筛选掉禁止自动加入的房间
function HallManager:FilterForbiddenRoom(rooms)
    local room =(checktable(rooms))
    table.filter(room, function(v, k)
        return Helper.And(v.type, 0x10000) == 0
    end)
    return room
end

-- 筛选掉tab字段房间
function HallManager:FilterTabRoom(rooms)
    if not ROOM_TAB_TYPE then 
        return checktable(rooms)
    end

    local room =(checktable(rooms))
    table.filter(room, function(v, k)
        return (checktable(v.cmd).tab and checktable(v.cmd).tab == ROOM_TAB_TYPE)
    end)
    return room
end

-- 筛选掉混房间
function HallManager:FilterMixedRoom(rooms)
    local room =(checktable(rooms))
    table.filter(room, function(v, k)
        return (not checktable(v.cmd).mrl)
    end)
    return room
end
--是否类型1的房间  1 代表不是 2代表是改类型的房间
function HallManager:isCustom1Room(roomtype)
    local type = 1
    if roomtype and Helper.And(roomtype, ROOM_TYPE_CUSTOM1) == 0 then
        type = 2
    end
    return type
end
--根据房间倍数等级类型筛选房间
function HallManager:FilterRoomsByLevel(rooms,roomlevel)
    local room =(checktable(rooms))
    if roomlevel then
        table.filter(room, function(v,k)
            return roomlevel==gg.GetRoomLevel(v.type)
        end)
    end
    return room
end

--根据房间模式筛选房间
function HallManager:FilterRoomsByMode(rooms,roommode)
    local room =(checktable(rooms))
    if roommode then
        table.filter(room, function(v,k)
             return Helper.And(v.type, roommode)~=0
        end)
    end
    return room
end

-- 根据房间类型筛选房间  0 代表 不需要筛选 1 代表筛选不是ROOM_TYPE_CUSTOM1的类型 2代表筛选ROOM_TYPE_CUSTOM1的类型
function HallManager:FilterRoomsByType(rooms,roomtype)
    if checkint(roomtype) == 0 then return rooms end
    local room =(checktable(rooms))
    table.filter(room, function(v,k)
        if checkint(roomtype) == 2 then
            return Helper.And(v.type, ROOM_TYPE_CUSTOM1)==0
        else
            return Helper.And(v.type, ROOM_TYPE_CUSTOM1)~=0
        end
    end)
    return room
end

-- 过滤掉比赛房间
function HallManager:FilterMatchRooms(rooms)
    local room =(checktable(rooms))
    table.filter(room, function(v,k)
            return not checktable(v.cmd).awardType
    end)
    return room
end

--获取房间实际人数
function HallManager:GetRoomRealPlayers(room)
    -- if  Helper.And(room.type, Helper.Or(ROOM_TYPE_ALLOCSIT,ROOM_TYPE_ALLOCSIT2))~=0 then
    --     return math.floor(room.players/10)
    -- else
        return room.players
  --  end
end
-- 处理房间显示人数 防作弊放大10倍
function HallManager:HandleRoomPlayers(room)
     if  Helper.And(room.type, Helper.Or(ROOM_TYPE_ALLOCSIT,ROOM_TYPE_ALLOCSIT2))~=0 then
        return math.floor(room.players*10)
     else
        return room.players
    end
end

--[[
* @brief 退出房间
]]
function HallManager:ExitRoom()
    if self.roommanager then
        self.roommanager:ExitRoom()
    end
end

--获取游戏房间
function HallManager:GetRoomsByGameId(gameid)
    gameid=checkint(gameid)
    local gamerooms={}
    for _ , v in pairs(checktable(self.rooms)) do
        if v.gameid==gameid then
            table.insert(gamerooms,v)
        end
    end
    return gamerooms
end

-- 获取小游戏的房间
function HallManager:GetLeisureRoomByGameId(gameid)
    local roomsTb = self:GetRoomsByGameId(gameid)
    local roomMode = Helper.Or(ROOM_TYPE_ALLOCSIT, ROOM_TYPE_ALLOCSIT2)
    roomsTb = self:FilterRoomsByMode(roomsTb, roomMode)
    roomsTb = self:FilterMatchRooms(roomsTb)
    for _, room in pairs(roomsTb) do
        if room.cmd and checkint(room.cmd.hall) == 1 then
            -- 命令行中有 hall=1，表示棋牌需要使用的小游戏房间
            return room.id
        end
    end
    return nil
end

--[[
* @brief 获取房间管理器
]]
function HallManager:GetRoomManager()
    return self.roommanager
end

--房间内领取救济金 游戏中GameClient:GiftMoney()
function HallManager:GiftMoneyInRoom(roomid)
    local room = self.rooms[roomid]

    if room == nil then return end
    local userinfo = self.userinfo

    if Helper.And(room.type,ROOM_TYPE_MONEY)~=0 and userinfo.bankmoney<room.minmoney then --游戏币房间
        local gift = room.cmd.gift
        for k,v in pairs(self.relations)do
            if v.objecttype==RELATION_TYPE_ROOM and v.objectid == room.id then
                gift = v.cmd.gift or gift
            end
        end
        if checkint(gift)~=0 then
            self:DoCompleteMission(MISSION_DAILY_GIFT_MONEY)
            return true
        end
    end
end

function HallManager:DoCompleteMission(missinId)
    if missinId == MISSION_DAILY_GIFT_MONEY or missinId == HallManager.MISSION_DAILY_GIFT_XZMONEY then
        -- 是申请送豆，直接发送消息
        local msg = CLuaMsgHeader.New()
        msg.id = MSG_ID.MSG_HALL_MISSION_COMPLETE2
        msg:WriteDword( missinId)
        self:SendData(msg, CRYPT_MSG)
    else
        -- 其他类型的任务，调用 C++ 接口来完成
        self:CompleteMission2(missinId)
    end
end

--检测是否可以加入房间
function HallManager:CheckCanJoinRoom(room)
    local roomType = room.type or 0
    local minmoney = room.minmoney
    local maxmoney = room.maxmoney
    local realplayers= self:GetRoomRealPlayers(room)
    if( minmoney and maxmoney) and Helper.And(roomType,ROOM_TYPE_MONEY) then
        local money=self.userinfo.money
        if minmoney>money and realplayers<room.maxplayers then --您的豆豆不足
            return false,1
        elseif maxmoney<money and realplayers<room.maxplayers then --您的豆豆过多
            return false,2
        elseif realplayers>=room.maxplayers then  --房间人数已满
            return false,3
        end
    elseif realplayers>=room.maxplayers then
        return false,3
    end
    return true,0
end

--检查游戏命令行限制
function HallManager:CheckGameCmdLimit(game)
    assert(game and type(game)=="table","game params error")
    if game.cmd.develop and tonumber(game.cmd.develop)~=0 then --开发模式
        return "攻城狮正在加班加点开发,敬请期待"
    elseif game.cmd.closed and tonumber(game.cmd.closed)~=0 then --关闭状态（维护)
        return "该游戏正在维护中,稍后开放!"
    elseif game.cmd.tipmsg and string.len(game.cmd.tipmsg)>0 then
        return game.cmd.tipmsg
    end
end

--检查是否可以加入游戏 return 第二个参数为true 已启动更新 不显示提示
function HallManager:CheckCanJoinGame( game ,autoupdate, statuscallback,errmsgcallback)
    autoupdate = autoupdate == nil and true or autoupdate
    local function errhandle_(msg)
        if not msg then return; end
        if errmsgcallback then
            errmsgcallback(msg)
        else
            GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG,msg)
        end
    end
    if not game  then
        errhandle_("无法进入房间,或游戏不存在。")
        return false
    elseif type(game)=="number" then
       game=checktable(self.games)[game]
    elseif type(game)=="string" then
       game=checktable(self.games)[checkint(ShortNameIdMap[game])]
    end
    assert(game ,"game is nil error"..tostring(game))
    local function callupdate_(tips)
        if autoupdate then
            self:DoUpdateGame(game,statuscallback)
        else
            GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG,tips,function (bt)
                if bt==gg.MessageDialog.EVENT_TYPE_OK then
                    self:DoUpdateGame(game,statuscallback)
                end
            end)
        end
    end

    local cmdmsg= self:CheckGameCmdLimit(game)
    if cmdmsg then
        errhandle_(cmdmsg)
        return false
    end
    local needupdate,uptips= self:CheckGameNeedUpdate(game)
    if needupdate then
        printf("uptips   "..uptips)
        callupdate_(uptips)
        return false,true
    end
    return true
end

-- 获取游戏需要更新的模块
function HallManager:getGameNeedUpdates(gameinfo)
    local ret = {}

    -- 扑克游戏检查 pk 通用组件是否需要更新
    local isPK = (Helper.And(gameinfo.type, GAME_GROUP_POKER) ~= 0)
    if isPK and gg.VersionHelper:isModuleNeedUpdate(gg.VersionHelper.VER_MODULE_PK_COMMON) then
        printf("%s 模块需要更新...", gg.VersionHelper.VER_MODULE_PK_COMMON)
        local info = {
            shortname = gg.VersionHelper.VER_MODULE_PK_COMMON,
            id = gg.VersionHelper:getModuleID(gg.VersionHelper.VER_MODULE_PK_COMMON),
            client_ver = gg.VersionHelper:getModuleClientVer(gg.VersionHelper.VER_MODULE_PK_COMMON),
            server_ver = gg.VersionHelper:getModuleRemoteVer(gg.VersionHelper.VER_MODULE_PK_COMMON),
        }
        table.insert(ret, info)
    end

    -- 麻将游戏检查 mj 通用组件是否需要更新
    local isMJ = (Helper.And(gameinfo.type, GAME_GROUP_MAHJONG) ~= 0)
    if isMJ and gg.VersionHelper:isModuleNeedUpdate(gg.VersionHelper.VER_MODULE_MJ_COMMON) then
        printf("%s 模块需要更新...", gg.VersionHelper.VER_MODULE_MJ_COMMON)
        local info = {
            shortname = gg.VersionHelper.VER_MODULE_MJ_COMMON,
            id = gg.VersionHelper:getModuleID(gg.VersionHelper.VER_MODULE_MJ_COMMON),
            client_ver = gg.VersionHelper:getModuleClientVer(gg.VersionHelper.VER_MODULE_MJ_COMMON),
            server_ver = gg.VersionHelper:getModuleRemoteVer(gg.VersionHelper.VER_MODULE_MJ_COMMON),
        }
        table.insert(ret, info)
    end

    -- 检查游戏指定的依赖项是否需要更新
    local depends = checktable(gameinfo.cmd).dp
    if depends and gg.VersionHelper:isModuleNeedUpdate(depends) then
        printf("area_%s 模块需要更新...", depends)
        local info = {
            shortname = depends,
            id = gg.VersionHelper:getModuleID(depends),
            client_ver = gg.VersionHelper:getModuleClientVer(depends),
            server_ver = gg.VersionHelper:getModuleRemoteVer(depends),
        }
        table.insert(ret, info)
    end

    -- 检查游戏本身是否需要更新
    local version = checkint(gameinfo.version)
    local ok,manifest_table= self:GetGameManifestTable(gameinfo.shortname)
    if ok then
        local curversion = checkint(manifest_table.version)
        gameinfo.clientversion = curversion
        if curversion < version then
            printf("游戏 %s 服务器版本 %d 客户端版本 %d 需要更新...", gameinfo.name, version, curversion)
            local info = {
                shortname = gameinfo.shortname,
                id = gameinfo.id,
                client_ver = curversion,
                server_ver = version,
            }
            table.insert(ret, info)
        end
    else
        printf("%s 未安装，需要下载。", gameinfo.name)
        local info = {
            shortname = gameinfo.shortname,
            id = gameinfo.id,
            client_ver = 0,
            server_ver = version,
        }
        table.insert(ret, info)
    end

    return ret
end

--检查游戏是否有更新
function HallManager:CheckGameNeedUpdate(game)
    if type(game)=="number" then
        game=checktable(self.games)[game]
    elseif type(game)=="string" then
        game=checktable(self.games)[checkint(ShortNameIdMap[game])]
    end
    game.cmd.lua = game.cmd.lua or 1

    local cmdmsg= self:CheckGameCmdLimit(game)
    if cmdmsg then
        return false,cmdmsg
    end

    if game.cmd.lua and tonumber(game.cmd.lua) ~= 0 then --//lua版游戏
        local upModules = self:getGameNeedUpdates(game)
        if upModules and #upModules > 0 then
            return true, string.format("游戏 %s 需要更新",checkstring(game.name))
        end
    else --//c++版
        printf("c++版本游戏不支持")
        return false, string.format( "%s启动失败，是否重新下载？",checkstring(game.name))
    end
    return false
end

--启动游戏更新 根据类型识别游戏 支持类型 gameid  shortname gametable
function HallManager:DoUpdateGame(game,statuscallback)
    local gameinfo
    if type(game)=="number" then
       gameinfo=checktable(self.games)[game]
    elseif type(game)=="string" then
       gameinfo=checktable(self.games)[checkint(ShortNameIdMap[game])]
    elseif type(game)=="table" then
       gameinfo=game
    end
    assert(gameinfo ,"gameinfo is nil error"..tostring(game))
    printf("todo  update game "..gameinfo.shortname)
    local GameDownloader= require("update.GameDownloader")
    --版本信息
    local verinfo={
        server_ver=checknumber(gameinfo.version,nil,1), --服务器版本
        client_ver=checknumber(gameinfo.clientversion,nil,0), --客户端版本
    }
    local upModules = self:getGameNeedUpdates(gameinfo)
    if GameDownloader:Start(gameinfo.shortname, upModules, statuscallback) then
        printf("启动游戏下载成功 "..tostring(gameinfo.shortname))
        return true
    else
        printf("cancel download "..tostring(gameinfo.shortname))
        --再次点击会取消排队中的游戏
        return false
    end
end

function HallManager:GetGameManifestTable(shortname)
    assert(shortname,"游戏短名错误")
    local manifest_path=string.format("games/%s/manifest",shortname)
    return gg.GetManifestTable(manifest_path)
end

--创建LUA游戏客户端
function HallManager:CreateLuaGameClient(shortname)
    local ok, manifest_table= self:GetGameManifestTable(shortname)
    if ok and checktable(manifest_table).mainfile then
        local gameclient= CLuaGameClient.New()
        if gameclient then
            gameclient:SetClientInfo(self.roommanager,manifest_table.mainfile)
        end
        return gameclient
    else
        printf(tostring(shortname).."游戏启动失败 :"..checkstring(manifest_table))
    end
end

-- 获取游戏 manifest 文件中的 customEntrance 配置
-- 如果未配置，返回 nil
function HallManager:getGameCustomEntrance( game )
    local gameinfo
    if type(game)=="number" then
        gameinfo=checktable(self.games)[game]
    elseif type(game)=="string" then
        gameinfo=checktable(self.games)[checkint(ShortNameIdMap[game])]
    elseif type(game)=="table" then
        gameinfo=game
    end

    if not gameinfo then
        return nil
    end

    local shortname = gameinfo.shortname
    local ok, manifest_table= self:GetGameManifestTable(shortname)
    if ok and checktable(manifest_table).customEntrance then
        return manifest_table.customEntrance
    else
        return nil
    end
end

-- 获取代开房间限制数量
function HallManager:getAgentRoomLimit( )
    return AgentRoomLimit
end

--代开房间
function HallManager:DoCreateRoomAgent(roomid,params,cardnum,permission,creditUser,gameid)
    if creditUser == 0 and table.nums(checktable(self.friendroomlist))>=AgentRoomLimit then
        -- 是代开房间，并且超过最大数量限制
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "创建失败,超过最大创建数量限制")
        return
    end

    local function doCreateRoom(retdata)
        local msg = CLuaMsgHeader.New()
        msg.id = MSG_ID.CREATE_ROOM
        msg:WriteDword(roomid)
        -- web 返回的 retdata.data 可能是 table 或者 字符串
        local uuid = gg.IIF(type(retdata.data) == "table", retdata.data.uuid, retdata.data)
        msg:WriteStringA(tostring(uuid or "session"))
        msg:WriteDword(checkint(retdata.club))
        printf("agent cost cardnum: %d rule : %s  ,session= %s",checkint(cardnum),json.encode(params), tostring(uuid or "error"))
        -- 写入规则
        for _, v in ipairs(params) do
            msg:WriteByte( v )
        end
        self:SendData(msg,CRYPT_MSG)
    end

    GameApp:dispatchEvent(gg.Event.SHOW_LOADING, "创建房间中...")
    gg.Dapi:VerifyAgentRoomCard(self.userinfo.id, cardnum, permission, creditUser, gameid, function(retdata)
        if tonumber(retdata.status) ==0 and retdata.data then
            doCreateRoom(retdata)
        else
            GameApp:dispatchEvent(gg.Event.SHOW_LOADING)
            GameApp:dispatchEvent(gg.Event.SHOW_TOAST,retdata.msg or "创建失败" )
            printf("DoCreateRoomAgent failed")
        end
    end)

end
--代开房间解散
function HallManager:DoDisbandRoom(roomid,deskid)
    local msg = CLuaMsgHeader.New()
    msg.id = MSG_ID.DISBAND_ROOM
    msg:WriteDword(roomid)
    msg:WriteWord(deskid)
    printf("DoDisbandRoom---------------")
    self:SendData(msg,CRYPT_MSG)
end
--查询代开列表
function HallManager:DoQueryUserDeskList()
    local msg = CLuaMsgHeader.New()
    msg.id = MSG_ID.QUERY_USER_DESK
    self:SendData(msg,MSG_HEADER_FLAG_COMPRESS+MSG_HEADER_FLAG_ENCODE+MSG_HEADER_FLAG_MASK)
    printf("DoQueryUserDeskList--msg id : %s",tostring( MSG_ID.QUERY_USER_DESK ))
end
--查询代开信息
function HallManager:DoQueryUserDeskInfo(roomid,deskid)
    local msg = CLuaMsgHeader.New()
    msg.id = MSG_ID.QUERY_DESKINFO

    msg:WriteDword(roomid)
    msg:WriteWord(deskid)
    self:SendData(msg,CRYPT_MSG)

    printf("DoQueryUserDeskInfo---------------msg:%d %d %d",MSG_ID.QUERY_DESKINFO ,roomid,deskid)
end

--代开房主踢人
function HallManager:DoOwnerKickPlayer(kickid,roomid,deskid,limitjoin)
    local msg = CLuaMsgHeader.New()
    msg.id =MSG_ID.KICK_PLAYER_BY_OWNER
    msg:WriteDword(kickid)
    msg:WriteDword(roomid)
    msg:WriteWord(deskid)
    msg:WriteBool(limitjoin)
    self:SendData(msg,CRYPT_MSG)
    printf("DoKickPlayer---------------msg:%d %d %d %d",MSG_ID.KICK_PLAYER_BY_OWNER,kickid ,roomid,deskid)
end

--[[
* @brief 获取指定地区的游戏
]]
function HallManager:GetGameFromArea( areaID )
    -- 筛选出的游戏
    local filterGames = {}
    -- 不为零有效
    if areaID ~= nil and areaID ~= 0 then

        -- 遍历游戏
        for k , v in pairs( checktable(self.games) ) do

            -- 游戏城市信息
            local city = v.cmd.city

            -- ID对比
            if city then

                if string.find( city , tostring(areaID) ) == 1 then

                    filterGames[ v.id ] = v
                end
            end

        end
    end
    return  filterGames
end

--[[
* @brief 获取已经添加的游戏
]]
function HallManager:GetAddedGames()
    local gameConfig = self:GetGameConfig()
    if not gameConfig or not hallmanager then return {} end

    -- 判断游戏是否在本地缓存中记录添加了
    local function isAdded_(id)
        for k, v in pairs(gg.LocalConfig:GetCustomGameTable()) do
            if v == 1 and tonumber(k) == tonumber(id) then
                return true
            end
        end
        return false
    end

    local addedGames = {}
    -- 先筛选出已经添加的扑克类游戏
    local pkAdd = checktable(checktable(gameConfig.pk).add)
    for i,v in ipairs(pkAdd) do
        local gameid = tonumber(v)
        if isAdded_(gameid) then
            addedGames[gameid]= checktable(self.games)[gameid]
        end
    end
    -- 再筛选出已经添加的麻将类游戏
    local mjAdd = checktable(checktable(gameConfig.mj).add)
    for i,v in ipairs(mjAdd) do
        local gameid = tonumber(v)
        if isAdded_(gameid) then
            addedGames[gameid]= checktable(self.games)[gameid]
        end
    end

    return addedGames
end


--[[
* @brief 检查是否在朋友场内
]]
function HallManager:IsInFriendRoom()
    if self.roommanager and gg.GetRoomMode(self.roommanager:GetRoomType()) == ROOM_TYPE_FRIEND_TEAM  then
        return self.roommanager:ReturnGroup()
    end
    return false
end

--[[
* @brief 根据游戏短名获取游戏
]]
function HallManager:GetGameByShortName( shortname )
    if self.games and shortname then
        return self.games[ checkint(ShortNameIdMap[shortname])]
    end
end
--[[
* @brief 判断游戏是否有朋友场
* @param id 游戏ID
]]
function HallManager:IsHasFriendRoom( id )
    if self.rooms then
        for k , v in pairs(self.rooms) do
            if v.gameid == id and gg.GetRoomMode(v.type) == ROOM_TYPE_FRIEND_TEAM then
                return true
            end
        end
    end
    return false
end
--------------------------------platform diff code -----------------------------
--更新游戏列表
function HallManager:UpdateGameList()
    local shotIds = {}
    for k,v in pairs(checktable(self.games)) do
         shotIds[v.shortname] = k
    end
    ShortNameIdMap = shotIds
    local tmp = {}
    local config = checktable(self:GetGameConfig())

    table.walk(checktable(checktable(config.mj).main), function(v) table.insert(tmp, v) end)
    table.walk(checktable(checktable(config.pk).main), function(v) table.insert(tmp, v) end)

    local apps = {}
    for _,v in pairs(tmp) do
        apps[v] = checktable(self.games)[v]
    end
    table.merge(apps, checktable(self:GetAddedGames()))

    -- 过滤掉需要隐藏的游戏
    local filterTb = {}
    for _,v in pairs(apps) do
        if not self:isHideGame(v) then
            filterTb[v.id] = v
        end
    end
    AppList = filterTb

    -- 游戏列表发生变化通知
    GameApp:dispatchEvent(gg.Event.HALL_UPDATE_GAMELIST)
end

--[[
* @brief 根据地区决定添加哪 些游戏
]]
function HallManager:InitAppWithAreadCode( areacode)
    assert(false,"HallManager:InitAppWithAreadCode")
    for k,v in pairs(checktable(self.games)) do
    end
end
--[[
* @brief 获取推荐游戏
]]
function HallManager:GetHotGames()
    -- 推荐的游戏
    local hotGames = {}
    for k , v in pairs( checktable(self.games) ) do
        local added = v.cmd.added
        if added and added == "1" and not self:IsGameAdded(k) then
            hotGames[ k ] = v
        end
    end
    return hotGames
end

-- 根据游戏短名筛选，避免重复添加
local function isRepeatByShortName(tb, shortname)
    for _,v in pairs(tb) do
        if shortname == v then
            return true
        end
    end
    return false
end

-- 根据游戏id筛选，避免重复添加
local function isRepeatById(tb, id)
    for _, v in pairs(tb) do
        if id == v.id then
            return true
        end
    end
    return false
end

--[[
* @brief 获取配置游戏配置表
]]
function HallManager:GetGameConfig()
    return gg.GameCfgData:GetCfgGame()
end

-- 获取休闲类小游戏
function HallManager:GetLeisureGame()
    local gameConfig = self:GetGameConfig()
    if not gameConfig or not hallmanager then return {} end
    local xxGames = {}
    local tb = checktable(checktable(gameConfig.mini).main)
    for i,v in ipairs(tb) do
        local game = checktable(self.games)[v]
        if game then
            table.insert(xxGames, game)
        end
    end

    xxGames = self:filterHideGames(xxGames)
    return xxGames
end
--获取新的小游戏
function HallManager:GetNewMiniGame()
    --小游戏列表
    local miniGameList =  self:GetLeisureGame()
    local newMiniList = {}
    for k, v in pairs(miniGameList) do
        --是否有新的小游戏
        if  checkint(v.cmd.new)== 1  then
            table.insert(newMiniList,v.id)
        end
    end
    local miniGameDate = gg.UserData:getConfigByKey("miniGameCfg")
    --没有数据的返回 不执行下面逻辑
    if not newMiniList or not miniGameDate then
        return newMiniList
    end
    local MiniList = {}
    for i=1,#newMiniList do
        if not Table:isValueExist(miniGameDate, newMiniList[i])then
            table.insert(MiniList,newMiniList[i])
        end
    end
    return MiniList
end

--[[
* @brief 获取扑克馆配置的游戏
]]
function HallManager:GetPuKeGConfigGame()
    local gameConfig = self:GetGameConfig()
    if not gameConfig or not hallmanager then return {} end
    local pkGames = {}
    -- 新版本cfg_game直接获取pkGames里面的main配置
    local tb = checktable(checktable(gameConfig.pk).main)
    for i,v in ipairs(tb) do
        local game = checktable(self.games)[v]
        if game then
            table.insert(pkGames, game)
        end
    end
    -- 加上已添加的扑克游戏
    for _,v in pairs(checktable(self:GetAddedGames())) do
        if Helper.And(v.type, GAME_GROUP_POKER) ~= 0 and not isRepeatById(pkGames, v.id) then
            table.insert(pkGames, v)
        end
    end

    pkGames = self:filterHideGames(pkGames)

    -- 2018-03-26 如果cfg_game的add中配置了添加游戏，则显示扑克馆的添加按钮
    local addTb = {}
    for i,v in ipairs(checktable(checktable(gameConfig.pk).add)) do
        local game = checktable(self.games)[v]
        if game then
            table.insert(addTb, game)
        end
    end
    addTb = self:filterHideGames(addTb)

    return pkGames, (#addTb > 0)
end

--[[
* @brief 获取麻将馆配置的游戏
]]
function HallManager:GetMaJiangGConfigGame()
    local gameConfig = self:GetGameConfig()
    if not gameConfig or not hallmanager then return {} end
    local mjGames = {}
    -- 新版本cfg_game直接获取mjGames里面的main配置
    local tb = checktable(checktable(gameConfig.mj).main)
    for i,v in ipairs(tb) do
        local game = checktable(self.games)[v]
        if game then
            table.insert(mjGames, game)
        end
    end
    -- 加上已添加的麻将游戏
    for _,v in pairs(checktable(self:GetAddedGames())) do
        if Helper.And(v.type, GAME_GROUP_MAHJONG) ~= 0 and not isRepeatById(mjGames, v.id) then
            table.insert(mjGames, v)
        end
    end

    mjGames = self:filterHideGames(mjGames)

    -- 如果cfg_game的add中配置了添加游戏，则显示添加按钮
    local addTb = {}
    for i,v in ipairs(checktable(checktable(gameConfig.mj).add)) do
        local game = checktable(self.games)[v]
        if game then
            table.insert(addTb, game)
        end
    end
    addTb = self:filterHideGames(addTb)

    -- 默认情况下，有可添加的游戏才显示添加按钮
    -- 全国包在非审核模式下，为了保留切换地区功能。也要显示添加按钮
    local showAdd = (not IS_REVIEW_MODE and REGION_CODE == 0) or (#addTb > 0)
    return mjGames, showAdd
end

-- 判断游戏是否需要隐藏
function HallManager:isHideGame(game)
    local hideItem = checkint(checktable(game.cmd).hide) == 1
    local numEnough = self:isNumOfGamesEnough(game.id)
    if not hideItem and numEnough then
        return false
    end
    return true
end

-- 过滤掉隐藏的游戏
function HallManager:filterHideGames(srcData)
    local retData = {}
    for i, v in ipairs(srcData) do
        if not self:isHideGame(v) then
            -- 非隐藏的游戏，且玩家荣誉等级足够显示该游戏
            table.insert(retData, v)
        end
    end

    return retData
end

-- 判断玩家游戏局数是否足够显示游戏/房间
function HallManager:isNumOfGamesEnough(gameID)
    local limitGames = checktable(LIMIT_GAMES)
    local idx = Table:findKey(limitGames, gameID)
    if not idx then
        -- 此游戏不被限制
        return true
    end

    -- 默认限制的游戏局数为 20
    local limitCounts = checktable(GAME_LIMIT_COUNTS)
    local limitCnt = gg.IIF(limitCounts[idx], checkint(limitCounts[idx]), 20)
    if limitCnt == -1 then
        -- 配置为 -1，完全屏蔽不能显示
        return false
    end

    local totalCnt = checkint(hallmanager:GetEffortData(EffortData.TOTAL_GAME_COUNT))
    return totalCnt >= checkint(limitCnt)
end

--[[
* @brief 获取所有朋友场游戏
]]
function HallManager:GetAllFrientRoomGames()
    local gamesTb = {}
    -- 获取扑克馆的游戏
    local pkGames = self:GetPuKeGConfigGame()
    -- 获取麻将馆的游戏
    local mjGames = self:GetMaJiangGConfigGame()
    local homeTb = {pkGames, mjGames}
    for i,tb in ipairs(homeTb) do
        for _,v in pairs(checktable(tb)) do
            if self:IsHasFriendRoom(v.id) and not isRepeatById(gamesTb, v.id) then
                table.insert(gamesTb, v)
            end
        end
    end

    return gamesTb
end

--[[
* @brief 获取是否需要动画提示比赛
目前的需求是：免费赢奖比赛开始报名前 10 分钟 --- 比赛报名开始后 10 分钟，需要动画引导玩家报名。
比赛开始的时间暂时为客户端写死：
1. 午间赛：12：08
2. 晚间赛：21：08
3. 周赛，月赛：20：08
]]
function HallManager:CanShowMatchAction()
    local matchTimes = { "12:08", "21:08" }
    local curTime = os.date("*t")

    if curTime.wday == 1 or
       (curTime.month == 2 and curTime.day == 28) or
       (curTime.month ~= 2 and curTime.day == 30) then
        -- 周赛或者月赛日
        table.insert(matchTimes, "20:08")
    end

    local curTimeStamp = os.time(curTime)
    for i, t in ipairs(matchTimes) do
        local bTimeArr = string.split(t, ":")
        local bTime = clone(curTime)
        bTime.hour = bTimeArr[1]
        bTime.min = bTimeArr[2]
        bTime.sec = 0
        local bTimeStamp = os.time(bTime)

        -- 获取开始动画的时间点
        local beginTimeStamp = bTimeStamp - 600 -- 报名前 10 分钟开始提醒

        -- 获取结束动画的时间点
        local endTimeStamp = bTimeStamp + 120 -- 报名后 2 分钟结束提醒

        if curTimeStamp >= beginTimeStamp and curTimeStamp <= endTimeStamp then
            return true
        end
    end

    return false
end

--[[
* @brief 获取可添加游戏的配置
]]
function HallManager:GetCanAddGameConfigGame()
    local gameConfig = self:GetGameConfig()
    if not gameConfig or not hallmanager then return {} end
    local canAddGame = {}
    -- 读取扑克类可添加的配置
    local pkAdd = checktable(checktable(gameConfig.pk).add)
    for i,v in ipairs(pkAdd) do
        local game = checktable(self.games)[v]
        if game then
            table.insert(canAddGame, game)
        end
    end
    -- 读取麻将类可添加的配置
    local mjAdd = checktable(checktable(gameConfig.mj).add)
    for i,v in ipairs(mjAdd) do
        local game = checktable(self.games)[v]
        if game then
            table.insert(canAddGame, game)
        end
    end

    return canAddGame
end

local isPkLoaded_ = false
local pkLoadedCallbacks_ = {}

-- 拉取预报名房间信息
function HallManager:PullPk3RoomInfo()
    -- 重新拉取数据时初始化状态
    isPkLoaded_ = false
    pkLoadedCallbacks_ = {}

    local msg = CLuaMsgHeader.New()
    msg.id = MSG_ID.MSG_HALL_QUERY_CONFIG_INFO
    self:SendData(msg, CRYPT_MSG)
end

function HallManager:CheckPkInfoLoaded(callback)
    if isPkLoaded_ then
        if callback then callback() end
        return true
    else
        table.insert(pkLoadedCallbacks_, callback)
        return false
    end
end

function HallManager:PkInfoLoadedSuccess()
    isPkLoaded_ = true
    if pkLoadedCallbacks_ and #pkLoadedCallbacks_ > 0 then
        for i, v in ipairs(pkLoadedCallbacks_) do
            if v then
                v()
            end
        end
        pkLoadedCallbacks_ = {}
    end
end

--[[
* @brief 保存预报名房间信息
* @param roomid 房间id
* @param groupid 分组id
* @param signUpType 报名方式
* @param playersCnt 报名人数
* @param state 报名房间当前分组状态 0正常 1无法开赛
]]
function HallManager:SetPk3SingUp(roomid, groupid, signUpType, playersCnt, state)
    self.signupinfo = checktable(self.signupinfo)
    local info = {}
    info.roomid = roomid
    info.groupid = groupid
    info.signUpType = signUpType
    info.players = playersCnt
    info.state = checkint(state)
    table.insert(self.signupinfo, info)

    if info.state == 1 then
        cc.exports.PK_ROOM_FAILED_GROUPID = {rid = roomid, gid = groupid}
        self:EmptySingUpInfo(roomid, groupid)
    end
end

function HallManager:GetAllSignUpInfo()
    return self.signupinfo
end

-- 获取预报名的房间、分组信息
function HallManager:GetSignUpInfo(roomid, groupid)
    roomid = checkint(roomid)
    groupid = checkint(groupid)
    for i,v in pairs(checktable(self.signupinfo)) do
        if v.roomid == roomid and v.groupid == groupid then
            return v
        end
    end
end

-- 获取某个房间的某个报名分组信息
function HallManager:GetGroupById(roomid, groupid)
    local roomInfo = checktable(self.rooms)[roomid]
    if roomInfo then
        for k,v in pairs(checktable(roomInfo.group)) do
            if v.id == groupid then
                return v
            end
        end
    end
end

-- 获取某房间最近开始报名的分组
function HallManager:GetLatelyGroup(roomid)
    local roomInfo = checktable(self.rooms)[roomid]
    if roomInfo and roomInfo.group then
        local latelyGroup = nil
        local gType = nil
        for i=1, #checktable(roomInfo.group) do
            local group = roomInfo.group[i]
            gType = group.type
            if group.startTime - os.time() > 0 then
                if latelyGroup == nil or group.startTime < latelyGroup.startTime then
                    latelyGroup = group
                end
            end
        end

        -- 每日赛找不到分组，则表明今日比赛已全部结束，讲分组信息时间戳修改为第二天
        if not latelyGroup and gType and gType == 0 then
            for k,g in pairs(roomInfo.group) do
                g.startTime = g.startTime + 24 * 60 * 60
                g.downTime = g.startTime - os.time()
                g.timeDiff = 0
                g.isNextDay = true
            end

            for j=1, #checktable(roomInfo.group) do
                local group = roomInfo.group[j]
                if group.startTime - os.time() > 0 then
                    if latelyGroup == nil or group.startTime < latelyGroup.startTime then
                        latelyGroup = group
                    end
                end
            end
        end

        return latelyGroup
    end
end

-- 获取某房间下一场开始报名的分组
function HallManager:GetNextGroup(roomid, groupid)
    local latelyGroup = self:GetGroupById(roomid, groupid)
    local time = latelyGroup.startTime
    local roomInfo = checktable(self.rooms)[roomid]
    if roomInfo and roomInfo.group and latelyGroup then
        local nextGroup = nil
        for i=1, #checktable(roomInfo.group) do
            local group = roomInfo.group[i]
            if group.startTime > latelyGroup.startTime then
                if nextGroup == nil or group.startTime < nextGroup.startTime then
                    nextGroup = group
                end
            end
        end

        -- 每日赛找不到分组，则表明今日比赛已全部结束，讲分组信息时间戳修改为第二天
        if latelyGroup.type == 0 and not nextGroup then
            for k,g in pairs(roomInfo.group) do
                g.startTime = g.startTime + 24 * 60 * 60
                g.downTime = g.startTime - os.time()
                g.timeDiff = 0
                g.isNextDay = true
            end

            for j=1, #checktable(roomInfo.group) do
                local newgroup = roomInfo.group[j]
                if newgroup.startTime > time then
                    if nextGroup == nil or newgroup.startTime < nextGroup.startTime then
                        nextGroup = newgroup
                    end
                end
            end
        end

        return nextGroup
    end
end

-- 获取某房间上一场开始报名的分组
function HallManager:GetPreGroup(roomid, groupid)
    local curGroup = self:GetGroupById(roomid, groupid)
    local roomInfo = checktable(self.rooms)[roomid]
    if roomInfo and roomInfo.group and curGroup then
        local preGroup = nil
        for i=1, #checktable(roomInfo.group) do
            local group = roomInfo.group[i]
            if group.startTime < curGroup.startTime then
                if preGroup == nil or group.startTime > preGroup.startTime then
                    preGroup = group
                end
            end
        end
        return preGroup
    end
end

-- 设置预报名房间信息
function HallManager:SetPk3RoomInfo(roominfo)
    if not roominfo then
        return
    end
    local room = self.rooms[roominfo.id]
    if room then
        roominfo.players = checkint(room.players)
    end
    self.rooms[roominfo.id] = roominfo
end

-- 清空报名信息
function HallManager:EmptySingUpInfo(roomid, groupid)
    for i,v in pairs(checktable(self.signupinfo)) do
        if v.roomid == roomid and v.groupid == groupid then
            self.signupinfo[i] = nil
        end
    end
end

-- 清空所有报名信息
function HallManager:EmptyAllSingUpInfo()
    self.signupinfo = {}
end

--[[
* @brief 预报名
* @param roomid 房间id
* @param groupid 分组id
* @param giniUptype 报名方式
]]
function HallManager:Pk3SignUp(roomid, groupid, giniUptype)
    local latelyGroup = self:GetLatelyGroup(roomid)
    if latelyGroup and (latelyGroup.startTime - os.time() < 0) then
        print("报名已经过了.")
        return
    end

    -- 发送报名消息
    local msg = CLuaMsgHeader.New()
    msg.id = MSG_ID.MSG_HALL_SIGNUP
    msg:WriteDword(checkint(roomid))
    msg:WriteDword(checkint(groupid))
    msg:WriteDword(checkint(giniUptype))
    self:SendData(msg,CRYPT_MSG)
    -- 添加报名信息
    self:SetPk3SingUp(roomid, groupid, giniUptype)
end

--[[
* @brief 取消报名
* @param roomid 房间id
* @param groupid 分组id
]]
function HallManager:Pk3UnSignUp(roomid, groupid)
    local msg = CLuaMsgHeader.New()
    msg.id = MSG_ID.MSG_HALL_UNSIGNUP
    msg:WriteDword(checkint(roomid))
    msg:WriteDword(checkint(groupid))
    self:SendData(msg,CRYPT_MSG)
end

-- 定时赛计时器事件
function HallManager:onMatchTimer()
    for i,signinfo in ipairs(checktable(self.signupinfo)) do
        local roomid = checkint(signinfo.roomid)
        local groupid = checkint(signinfo.groupid)
        local group = self:GetGroupById(roomid, groupid)
        if group then
            local cd = checkint(group.startTime) - os.time() - checkint(group.timeDiff)
            -- 设置发送提醒通知
            local sptime = 300
            local roominfo = checktable(self.rooms)[roomid]
            if roominfo and roominfo.tipsTime and checkint(roominfo.tipsTime) > 0 then
                sptime = checkint(roominfo.tipsTime)
            end

            if cd == sptime then
                GameApp:dispatchEvent(gg.Event.HALL_MATCH_SOON_START_NOTIC, roomid, groupid, sptime)
            end

            -- 游戏开始前60秒检测到用户尚未加入房间，则每10秒请求一次加入比赛房间
            if checkint(signinfo.state) ~= 1 and cd < 60 and cd > 0 and (cd % 10 == 0) then
                local roomMgr = self:GetRoomManager()
                if not roomMgr or (not roomMgr:IsClientRunning()) then
                    -- 记录下当前用户加入比赛的分组ID，防止用户时间戳的问题导致用户进入错误分组
                    cc.exports.PK4_JOIN_GROUPID = groupid
                    self:JoinRoom(roomid, false)
                end
            end
        end
    end

    -- 发送时间刷新通知
    GameApp:dispatchEvent(gg.Event.HALL_MATCH_TIME_UPDATE_NOTIC)
end

-- 开启定时赛计时器
function HallManager:StartMatchTimer()
    if not self._matchTimer then
        self._matchTimer = require("common.utils.Timer").new()
        self._matchTimer:start(handler(self,self.onMatchTimer), 1)
    end
end

-- 关闭定时赛计时器
function HallManager:StopMatchTimer()
    if self._matchTimer then
        self._matchTimer:killAll()
        self._matchTimer = nil
    end
end

return HallManager