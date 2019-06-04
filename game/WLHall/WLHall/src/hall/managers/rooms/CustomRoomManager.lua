local MSG_ID = import(".RoomMsgDef")
local YYSound = require("libs.yy_utils.YYSound")
local e = {}
--命令行参数
-- wxdl 微信登录 0 1 room.cmd
-- fknum 房卡数

-- voiceswitch 语音开关

local CustomRoomManager = ClassEx("CustomRoomManager",function ()
    local obj = CCustomRoomManager.New();
    obj.event= e;
    return obj;
end)

function CustomRoomManager:ctor(callback)
    if callback then
        assert(type(callback)=="function"," type: "..type(callback))
        self.onjoinroomrelay_=callback
    end
end

--返回房间
function CustomRoomManager:ReturnGroup(gpsenable)
    local selfp = self.playerself
    if selfp and selfp.chairid ~= INVALID_CHAIR then
        gpsenable=checkint(gpsenable)
        self:JoinGroup(self.roomkey_ ,gpsenable, selfp.chairid)

        GameApp:dispatchEvent(gg.Event.ROOM_JOIN_NOTIFY )
        return true
    end

    return false
end

-- 解散房间
function CustomRoomManager:DisbandGroup()
    local msg = CLuaMsgHeader.New()
    msg.id = MSG_ID.TEAM_DISBAND
    self:SendData(msg)
end

--[[
* @brief 创建朋友场
* @parm rule 规则表
*语音开关
]]
function CustomRoomManager:CreateGroup( ruletable )

    local selfp = self.playerself
    if not selfp then
        printf( "玩家信息空！" )
        return
    end
    if self:ReturnGroup() then
        return
    end
    ruletable = checktable(ruletable)
    if table.nums(ruletable)==0 then
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST , " 选择规则错误" )
        return
    end
    -- 发送消息
    local msg = CLuaMsgHeader.New()
    msg.id = MSG_ID.TEAM_CREATE
    -- 写入规则
    for _, v in ipairs(ruletable) do
        msg:WriteByte( v )
    end
    printf("create rule：%s",json.encode(ruletable))
    --  发送消息
    self:SendData( msg)
end

--[[
* @brief 加入朋友场
* @parm key 房间号
]]
function CustomRoomManager:JoinGroup( roomkey,gpsenable,chairid)
    chairid =chairid or INVALID_CHAIR
    assert( not gpsenable or type(gpsenable)=="number","请检查 gpsenable 参数"..tostring(gpsenable))
    gpsenable= gpsenable or checkint(device.getGpsEnable())
    roomkey =checkstring(roomkey)
    if string.len(roomkey)~=6 then
        return
    end

    self.roomkey_=roomkey
    --  发送消息
    local msg = CLuaMsgHeader.New()
    msg.id = MSG_ID.SIT_DOWN
    msg:WriteWord( chairid )
    msg:WriteStringA(roomkey)
    msg:WriteByte(gpsenable)
    --追加好友圈id
    local circles= gg.UserData:GetFricedsCircles()
    local count =checkint(#circles)
    printf("circlelist ---count %d  data %s",count,json.encode(circles))
    msg:WriteWord(checkint(#circles))
    for _,v in ipairs(circles) do
        msg:WriteDword(v)
    end
    self:SendData(msg)
    printf("发送消息加入房间 JoinGroup:"..roomkey)
end

function CustomRoomManager:SetRoomKey(roomkey)
    self.roomkey_=roomkey
end

--[[
* @brief 初始化
* @parameter room 房间对象
]]
function e.Initialize( room )
    printf(" CustomRoomManager Initialize");
    return true
end

--[[
* @brief 销毁
* @parameter room 房间对象
]]
function e.Shutdown( room )
    room.onjoinroomrelay_=nil

    printf("-------e.Shutdown------------ %s gps  %d",tostring(room.roomkey_ ),checkint(room.gpsenable_) )
    printf(" CustomRoomManager Shutdown");
end

-- 游戏启动前预处理事件
function e.OnGamePreInitialize(room)
    printf("--------OnGamePreInitialize room ".. json.encode(checktable(room)))
    if not room.roomkey_  then
     --   BreakPoint()
    end

    GameClient.roomkey=room.roomkey_
    GameClient.roomownerid= room.roomownerid_

    -- 进入朋友场房间成功
    GameApp:dispatchEvent(gg.Event.ROOM_JOIN_NOTIFY )

    if device.platform ~= "mac" then
        if not YYSDk_LOGIN_SUCCESS then
            -- 初始化 & 登录 YY 语音 SDK
            YYSound:initYYSDk()
            local playerself = room.playerself
            YYSound:loginYYSDK(playerself.nickname, playerself.id)
        end
    end
end

--进入房间成功
function e.OnMsgJoinRoom( room, dwOwnerId, strRoomKey, bGaming,gpsenable)
    local playerSelf = room.playerself
    room.roomkey_ = gg.IIF(strRoomKey and #strRoomKey>0 ,strRoomKey,room.roomkey_)
    room.roomownerid_= dwOwnerId
    room.isGaming_= bGaming
    room.gpsenable_=gpsenable
    printf("--CustomRoomManager OnMsgJoinRoom roomkey "..tostring(room.roomkey_).. " id: ".. tostring(room.roomownerid_ ).." gps: "..tostring(room.gpsenable_))
    if room.onjoinroomrelay_ then
        room.onjoinroomrelay_(playerSelf,dwOwnerId,room.roomkey_,bGaming)
    end
    if room.roomkey_ and not bGaming then
        room:ReturnGroup()
    else
        if string.len(checkstring(room.roomkey_)) ==0 and GameApp:IsReconnecting() then
            GameApp:dispatchEvent(gg.Event.HALL_ON_JOIN_HALL,2)
            GameApp:UpdateReconnectState(false, true)
            room:ExitRoom()
        else
            -- 房间初始化通知
            GameApp:dispatchEvent(gg.Event.ROOM_JOIN_ROOM_REPLY , room , room.roomkey_ )
        end
    end
end

--玩家起立  解散时候会调用
function e.OnMsgStandup(room,userid,isself)
    if isself and string.len(checkstring(room.roomkey_))>0 then
        room.roomkey_=nil
        room.roomownerid_=0
        room:ExitRoom()
     --   GameApp:dispatchEvent(gg.Event.SHOW_TOAST , "解散成功,您可以进入其他房间了！" )
        GameApp:dispatchEvent(gg.Event.ROOM_JOIN_NOTIFY )
    end
end

function e.OnMsgUpdatePlayerData(room,userid)

end

function e.OnMsgAllocSitDeskInfo(room,msg)
    if room.gpsenable_==1 then
        -- 开启位置定位
        device.startUpdatingLocation()
    end
    printf("------------------------------OnMsgAllocSitDeskInfo------------ %s gps  %d",tostring(room.roomkey_ ),checkint(room.gpsenable_) )
    GameApp:dispatchEvent(gg.Event.ROOM_ALLOC_SIT_DESK_INFO, room)
end

e[ MSG_ID.DESK_KICK_PLAYER ] = function( room , msg )
    if msg.len~=msg.position then
        local amsg=msg:ReadStringW()
        GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG , amsg )
    end
    room:ExitRoom()
end


--落座成功
e[ MSG_ID.SIT_DOWN_NOTIFY ] = function( room , msg )
    -- 桌子玩家数量
    room.roomownerid_ = msg:ReadDword()
    local roomid = room.roomownerid_
    local playerCount = checkint(msg:ReadWord())
    local enable = msg:ReadByte()
    room.gpsenable_ = enable
    printf(" SIT_DOWN_NOTIFY gps : %d ",enable)

    if playerCount > 0 then
        -- 发送消息通知，关闭加入房间界面
        GameApp:dispatchEvent(gg.Event.ROOM_JOIN_NOTIFY )
        GameApp:dispatchEvent(gg.Event.SHOW_LOADING)
        local playerInfos = {}
        for i = 1 , playerCount do
            local chairID  = msg:ReadWord()         -- 椅子号
            local playerID = msg:ReadDword()        -- 玩家ID
            local sex = msg:ReadInt()               -- 玩家性别
            local nickName = msg:ReadStringW()      -- 玩家昵称
            local avatar = msg:ReadDword()          -- 玩家头像
            local avatarUrl = ""
            if avatar == 0xFFFFFFFF then
                avatarUrl = msg:ReadStringA()       -- 玩家头像地址
            end

            local playerInfo = {}
            playerInfo.nickName = nickName
            playerInfo.chairID = chairID
            playerInfo.avatar = avatar
            playerInfo.avatarUrl = avatarUrl
            playerInfo.sex = sex
            table.insert( playerInfos , playerInfo )
        end

        -- 显示选座界面
        local selectSeatView = GameApp:getRunningScene():getChildByName("room.SelectSeatView")
        if selectSeatView then
            selectSeatView:updatePlayers(playerInfos)
        else
            -- 获取游戏类型
            local isPuKe = true
            if hallmanager and hallmanager.games then
                local gameInfo = checktable(hallmanager.games[room.gameid])
                if gameInfo.type and Helper.And( gameInfo.type , GAME_GROUP_MAHJONG ) ~= 0 then
                    isPuKe = false
                end
            end
            GameApp:dispatchEvent(gg.Event.SHOW_VIEW, "room.SelectSeatView", { push = true , popup = true} , playerInfos, room.playerperdesk, room.roomkey_, isPuKe)
        end
    else
        GameApp:dispatchEvent(gg.Event.CLOSE_SELECT_SEAT_NOTIFY, false)
    end
end

--落座失败
e[ MSG_ID.SIT_DOWN_FAILED ] = function( room , msg )
    local wmsg= msg:ReadStringW()
    printf("SIT_DOWN_FAILED "..wmsg)
    GameApp:dispatchEvent(gg.Event.SHOW_LOADING)
    local ok,msgtip= pcall (loadstring("return"..tostring(wmsg)))
    if ok and checkint(msgtip.code)==1 then
        GameApp:dispatchEvent(gg.Event.SHOW_VIEW,"room.OpenGpsAlertView",{ push = true , popup = true})
    else
        GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG,msgtip.msg or wmsg)
    end
    -- 离开房间
    room:ExitRoom()
    -- 关闭选座界面
    GameApp:dispatchEvent(gg.Event.CLOSE_SELECT_SEAT_NOTIFY, true)
end

--[[
* @brief 创建分组成功
]]
e[ MSG_ID.TEAM_CREATE_NOTIFY ] = function( room , msg )
    room.roomkey_ = msg:ReadStringA()
    room.gpsenable_=msg:ReadByte()
    if room.playerself then
       room.roomownerid_= room.playerself.id
    end
end

--[[
* @brief 创建分组失败
]]
e[ MSG_ID.TEAM_CREATE_FAILED ] = function( room , msg )

    local wmsg = msg:ReadStringW()
    GameApp:dispatchEvent(gg.Event.SHOW_LOADING)
    GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG,wmsg)
    -- 离开房间
    room:ExitRoom()
end

-- 房间中使用道具
e[MSG_ID.USE_PROP_REPLY] = function(room, msg)
    local fromUserID = msg:ReadDword()
    local toUserID = msg:ReadDword()
    local propID = msg:ReadDword()
    local count = 1
    if msg.position < msg.len then
        -- 消息未读完，还有道具数量的数据
        count = msg:ReadDword()
    end

    -- 通知游戏客户端 OnUserProp 这个事件
    if GameClient and GameClient.event and GameClient.event.OnUserProp then
        local fromUser = GameClient:FindPlayerByID(fromUserID)
        local toUser = GameClient:FindPlayerByID(toUserID)
        GameClient.event.OnUserProp(GameClient, fromUser, toUser, propID, count)
    end
end

return CustomRoomManager