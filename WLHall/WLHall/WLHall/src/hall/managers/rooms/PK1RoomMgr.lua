--[[
比赛房间

* 房间属性
    gameid 游戏id
	name 字符串,房间名
	gamename 字符串,游戏名
	playerself CLuaPlayer对象,玩家自己,可能为nil
	deskcount WORD 房间内桌子数量
	playerperdesk WORD 每桌椅子数量
	gameclient CBaseGameClient对象 也可以用全局变量GameClient
	starttime 整型,自1970年1月1日 00：00：00开始到现在所过去的秒数
	currentgroupid 整型,当前正在报名中的分组ID
	selfgroup 整型,用户已经报名的分组ID,如果为0,则用户没报名
	roomplayer 整型,房间内玩家数量（所有分组）
	maxplayer 整型,每组最大玩家数量(报名截至玩家数量)
	groupplayer 整型,当前分组内玩家数量（或者已报名玩家数量）
	groupstate 整型,当前分组状态,参看common.lua中的“比赛状态”常量

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
	发送报名/退赛 参数为true则报名
	void SendPKPlayerJoin(bool);

]]

local MSG_ID = import(".RoomMsgDef")

--事件表
local e = {}

local	PK_GROUP_STATE_WAITING=0--//等待状态(时间没到)
local	PK_GROUP_STATE_JOIN=1	--	//加入状态
local	PK_GROUP_STATE_STEP=2	--	//阶段1

local PK1RoomMgr = ClassEx("PK1RoomMgr",function()
	local obj =  CPK1RoomManager.New()
	obj.event = e;
	return obj;
end);

local roomlayer

--[[
* @brief 初始化
* @parameter room 房间对象
]]
function e.Initialize( room )

	print("pk1 e.Initialize")

	return true;
end

--[[
* @brief 销毁
* @parameter room 房间对象
]]
function e.Shutdown( room )

	print("e.Shutdown")
	--return true;
end

--进入房间成功
function e.OnMsgJoinRoom( room,groupstate)
	printf("--------------OnMsgJoinRoom :%d",groupstate)
    GameApp:UpdateReconnectState(false,true)

    -- 关闭 loading 界面
    GameApp:dispatchEvent(gg.Event.SHOW_LOADING)
	-- 发送通知
	GameApp:dispatchEvent( gg.Event.ROOM_JOIN_ROOM_REPLY , room )
	if groupstate >= PK_GROUP_STATE_STEP then
		if not room:StartGame() then
			printf("OnMsgJoinRoom 启动失败")
			return
		end
		if GameClient then
			GameClient.starttime=room.starttime
		end
    else
        -- 没在游戏中了，需要清掉 GameClient 这个全局对象
        -- 同时发送回到大厅的通知
        if GameClient then
            rawset(_G, "GameClient", nil)
            GameApp:dispatchEvent(gg.Event.HALL_ON_JOIN_HALL,2)
        end
	end
end


--[[
* @brief 用户被踢出桌子
* @param reason 踢出原因,如果为空,则解散或者无条件起立
]]
function e.OnMsgDeskKickPlayer( room,reason )
	printf("--------------OnMsgDeskKickPlayer")
	--room:StopGame();
	if reason and reason ~="" then
		printf(" OnMsgDeskKickPlayer reason ".. tostring(reason))
	end
end


--[[
* @breif 玩家报名比赛结果
* @param result 报名结果 0 为成功
* @param bJoin 报名为true,退赛为false
]]
function e.OnMsgPKJoin( room,result,bJoin )
	printf("------------OnMsgPKJoin")
	if result == 0 then
		-- 报名成功通知
		GameApp:dispatchEvent(gg.Event.ROOM_JOIN_PK1_REPLY , result,bJoin )
		return;
	end

    if room.selfgroup > 0 and room.groupstate >= 2 then
        -- 玩家在游戏中，不需要处理
        return
    end

	local msg={
        "已报名成功，不能重复报名!",
		"房间无效",
		"报名已经截至,请关注下次比赛报名时间。",
		"比赛已经开始,不能报名！",
		"您的豆豆不够,无法参与比赛",
		"您的参赛券不够,无法参与比赛",
		"报名失败,玩家已满!"
	}

	if room:IsClientRunning() then
		printf("客户端正在运行， 关闭room:StopGame();")
		room:StopGame();
	end

	msg = msg[result];
	if msg then
		GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG,msg)
	end
end

--[[
* @brief 通知更新玩家数量
]]
function e.OnMsgUpdatePlayers( room, roomplayer,maxplayer, groupplayers )

	-- 同步本地数据
    --local groupplayer = room.groupplayer 				-- 当前报名人数
	--local maxplayer  = room.maxplayer  					-- 开赛需要人数
	--local roomplayer  = room.roomplayer  				-- 房间总人数

	GameApp:dispatchEvent(gg.Event.ROOM_UPDATE_PK_PLAYERS , room )

	printf(string.format( "报名人数：%d 还需人数：%d 房间人数：%d" , groupplayers,maxplayer - groupplayers,roomplayer))

	if groupplayers >= maxplayer then
		printf("todo 进入比赛  OnMsgUpdatePlayers")
		GameApp:dispatchEvent(gg.Event.SHOW_LOADING , "正在进入比赛..." )
	end
end

--[[比赛阶段发生变化]]
function e.OnMsgChangeState( room,state )
	printf("function e.OnMsgChangeState( room,state )")

end

--关闭报名界面
function e.OnMsgAllocSitDeskInfo(room)
	printf("function e.OnMsgAllocSitDeskInfo(room)")

	GameApp:dispatchEvent( gg.Event.SHOW_LOADING )
	GameApp:dispatchEvent( "gg.Event.ROOM_CLOSE_MATCH_JOIN" , room )
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

return PK1RoomMgr