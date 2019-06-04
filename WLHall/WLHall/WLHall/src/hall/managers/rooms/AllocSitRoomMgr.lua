--[[
防作弊房间

* 房间属性
    name 字符串,房间名
    gamename 字符串,游戏名
    playerself CLuaPlayer对象,玩家自己,可能为nil
    deskcount WORD 房间内桌子数量
    playerperdesk WORD 每桌椅子数量
    gameclient CBaseGameClient对象 也可以用全局变量GameClient

* 方法:
    获得房间ID
    DWORD GetID();
    获得房间类型
    DWORD GetRoomType();
    领取救济金通知(玩家身上钱,领取的钱,领取次数,剩余次数)
    void OnGiftMoneyReply(long long,long long,int,int);
    游戏客户端是否打开
    bool IsClientRunning()
    创建一个游戏玩家,返回类型为C++类型的CBasePlayer*,该函数只为了兼容C++游戏
    设置大厅信息(大厅对象,房间ID)
    void SetRoomInfo(CHallManager*,DWORD);
    userdata CreateGamePlayer();
    根据CLuaPlayer创建一个CBasePlayer*对象,功能类似CreateGamePlayer
    userdata GamePlayerFromRoomPlayer(CLuaPlayer*);
    根据玩家ID查找游戏中的玩家
    userdata GameFindPlayer(DWORD);
    通知游戏客户端玩家进入(CBasePlayer指针,是否自己),第一个参数必须是CreateGamePlayer/GamePlayerFromRoomPlayer/GameFindPlayer的返回结果
    void OnNotifyGamePlayerJoin(userdata,bool);
    通知游戏客户端玩家离开(CBasePlayer指针),参数必须是CreateGamePlayer/GamePlayerFromRoomPlayer/GameFindPlayer的返回结果
    void OnNotifyGamePlayerLeave(userdata);
    通知游戏客户端重置游戏
    void OnNotifyResetGame();
    通知游戏客户端玩家数据发生改变
    void OnNotifyGamePlayerDataChange(CLuaPlayer*);
]]
local MSG_ID = import(".RoomMsgDef")

--事件表

local e={};
local AllocSitRoomMgr = ClassEx("AllocSitRoomMgr",function()
    local obj =  CAllocSitRoomManager.New()
    obj.event = e;
    printf("AllocSitRoomMgr ctor %s",tostring(obj))
    return obj;
end);

-- 设置混房间映射房间
function AllocSitRoomMgr:setMappedRoomId(id)
    self._mappedRoomId = id
end

-- 获取混房间映射房间
function AllocSitRoomMgr:getMappedRoomId()
    return self._mappedRoomId
end

-- 设置混房间id
function AllocSitRoomMgr:setMixedRoomId(id)
    self._mixedRoomId = id
end

-- 获得混房间id
function AllocSitRoomMgr:getMixedRoomId()
    return self._mixedRoomId
end

-- 重置成映射房间
function AllocSitRoomMgr:resetMappedRoom()
    if self.SetRoomInfo and self._mappedRoomId then
        self:SetRoomInfo(hallmanager, self._mappedRoomId)
    end
end

-- 重置成混房间
function AllocSitRoomMgr:resetMixedRoom()
    if self.SetRoomInfo and self._mixedRoomId then
        if GameClient and GameClient.roominfo and GameClient.roominfo.id ~= self:getMixedRoomId() then
            GameClient.roominfo = clone(GameClient.roominfo)
            GameClient.roominfo.id = self:getMixedRoomId()
        end
        self:SetRoomInfo(hallmanager, self._mixedRoomId)
    end
end

-- 设置混房间断线重连
function AllocSitRoomMgr:setMixedRoomReconnect(bReconnect)
    self._bReconnect = bReconnect
end

-- 执行游戏开始
function AllocSitRoomMgr:doGameStart(room)
    self:resetMappedRoom()
    if not room:StartGame() then
        self:resetMixedRoom()
        room:doFailGameStart(room)
    else
        GameApp:dispatchEvent(gg.Event.ROOM_JOIN_ROOM_REPLY, room)
    end
end

-- 执行游戏启动失败
function AllocSitRoomMgr:doFailGameStart(room, re)
    printf("e.启动游戏失败");
    if not re then
        room:ExitRoom()
        return
    end

    room:StopGame()
    local str = string.format("启动游戏失败（错误码：%s）", re)
    if re == 1 then
        str = "您的豆豆不足无法进入房间！"
    elseif re == 2 then
        str = "您的豆豆足够到高级的房间游戏啦！"
    elseif re == 3 then
        GameApp:dispatchEvent(gg.Event.HALL_ON_JOIN_HALL)
        return
    end

    GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG, str)
end

-- 发送混房间映射房间id给服务端
function AllocSitRoomMgr:sendMappedRoom(roomId)
    assert(roomId)
    local msg = CLuaMsgHeader.New()
    msg.id = MSG_ID.MIXED_ROOM_INFO
    msg:WriteDword(roomId)
    self:SendData(msg)
end

function e.Shutdown(room)
    printf("AllocSitRoomMgr Shutdown %s", tostring(self))
end

--进入房间成功
function e.OnMsgJoinRoom(room)
    printf(" AllocSitRoomMgr e.OnMsgJoinRoom id=%d %s", room:GetID(), tostring(room))
    if room._mixedRoomId == nil then
        room:doGameStart(room)
    end
    -- if not room._bReconnect then
    --     room:doGameStart(room)
    -- end
end

--[[
* @brief 用户被踢出桌子
* @param reason 踢出原因,如果为空,则解散或者无条件起立
]]
function e.OnMsgDeskKickPlayer(room, reason)
    room:StopGame();
    if reason and reason ~="" then
        -- 提示
        GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG,reason)
    end
    room:ExitRoom()
end

-- 收到混房间消息回包
e[MSG_ID.MIXED_ROOM_INFO_REPLY] = function(room , msg)
    local re = msg:ReadByte()
    if re == 0 then
        room:doGameStart(room)
    else
        room:doFailGameStart(room, re)
    end

end

-- 服务器请求混房间消息
e[MSG_ID.MIXED_ROOM_INFO_REQUEST] = function(room , msg)
    local mappedRoomId = room:getMappedRoomId()
    if mappedRoomId then
        room:sendMappedRoom(mappedRoomId)
    else
        room:sendMappedRoom(0)
    end
end

-- 服务器请求混房间消息
e[MSG_ID.MIXED_ROOM_RECONNECT] = function(room , msg)
    if room.setMixedRoomReconnect then
        room:setMixedRoomReconnect(nil)
    end
    local mappedRoomId = msg:ReadDword()
    if mappedRoomId > 0 and room.setMappedRoomId then
        room:setMappedRoomId(mappedRoomId)
    elseif room.setMixedRoomId then
        room:setMixedRoomId(nil)
    end

    if room.doGameStart then
        room:doGameStart(room)
    end
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

--以下函数可选择实现
--[[系统消息
function e.OnSystemMessage( room,msgtype,msg )

end
]]

return AllocSitRoomMgr