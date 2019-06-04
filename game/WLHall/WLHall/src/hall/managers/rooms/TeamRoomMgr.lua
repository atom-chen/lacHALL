--[[
队伍模式房间

* 房间属性
	name 字符串,房间名
	gamename 字符串,游戏名
	playerself CLuaPlayer对象,玩家自己,可能为nil
	deskcount WORD 房间内桌子数量
	playerperdesk WORD 每桌椅子数量
	gameclient CBaseGameClient对象 也可以用全局变量GameClient
	autojoin bool 是否快速开始

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
	创建队伍(限制最小积分,队伍密码)[返回是否成功]\[如果失败,则返回失败原因字符串]
	bool,const char* CreateTeam(longlong llScoreLimit = 0,const char* strPassword=NULL);
	加入队伍(队伍索引,队伍密码)[返回是否成功]\[如果失败,则返回失败原因字符串]
	bool,const char* JoinTeam(int index,const char* strPassword = NULL);
	自动加入队伍(是否匹配队伍)
	void AutoStartGame(bool bMatchTeam = false);
	获得指定的队伍分组(分组索引)
	CTeamGroupManager* GetTeamGroup(int);

	*CTeamGroupManager 对象
		* 属性
			index int[只读] 分组索引(id)
			score longlong 积分限制
			locked bool 是否设置有密码
			owner CLuaPlayer* 队伍所有者（队长)
		* 方法
			初始化
			bool Initialze();
			关闭
			void Shutdown();
			设置房间管理器(队伍模式房间管理器,默认索引)
			void SetRoomManager(CTeamGroupManager*,int);
		* 事件 N/A

]]

local TeamRoomMgr = ClassEx("TeamRoomMgr",function()
	local obj =  CTeamRoomManager.New()
	obj.event = e
	return obj
end)

local MSG_ID = import(".RoomMsgDef")

local roomlayer
local  e = {}

function e.Initialize(room)
	printf("teamroom Initialize Success")

	-- local LayerClass =require ("script.hallmanager.roommanager.view.teamlayer")
	-- roomlayer= LayerClass.new(room)
	-- hallmanager._scene:pushLayer(roomlayer,(function() roomlayer =nil  room:ExitRoom() end))
	return true
end
function e.Shutdown()
	if roomlayer then
		roomlayer:keyBackClicked()
	end
end


--进入房间成功
function e.OnMsgJoinRoom( room,teamCount)
	if playerself and playerself.deskid~=INVALID_DESK then
		room:StartGame();
	end
	roomlayer:initTeamItems(room,teamCount)
end

--创建战队通知
--index 战队索引
function e.OnMsgCreateTeam( room,index)
	printf("create  team "..tostring(index))
	roomlayer:addTeamByIndex(room,index)

end
--创建战队失败
function e.OnMsgCreateTeamFailed( room,result )
	local  msgs = {
		"您的豆豆数不符合房间设置,无法创建队伍!",
		"您已经正在游戏,无法创建队伍",
		"您设置的胜率不符合要求,胜率不能超过您自己的胜率值!",
		"本房间队伍已满,无法创建队伍！"
	};
end

--加入战队失败
function e.OnMsgJoinTeamFailed( room,result )
	local msgs = {
		"您已经正在游戏,无法加入队伍!",
		"队伍不存在",
		"您的豆豆太少,无法加入队伍！",
		"队伍已经解散,无法加入",
		"您的胜率太低,不符合对方设置!",
		"密码错误,请重新输入!";
	}
	GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG, msgs[result] or "未知错误");
end

--加入队伍成功
--该消息队长和加入者都会收到
--index 队伍索引
--player 加入者
function e.OnMsgJoinTeamSuccessed( room, index,player )

end

--队伍解散
function e.OnMsgTeamDisband( room,index )
	-- body
	printf("队伍已解散 index= "..tostring(index))
	local team = room:GetTeamGroup(index);
	if team then
		team.owner=nil;
	end
	if roomlayer then
		roomlayer:removeTeamByTag(index)
	else
		printf("roomlayer  is  nil ")
	end
end

--队友离开队伍(已经组队成功,但是没有分桌之前,队友离开)
function e.OnMsgTeamLeave( room)
	GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG, "您的队友离开了队伍！");
end

--快速加入应答
--result 应答结果
--index 如果成功,则为队伍索引
function e.OnMsgAutoStartResult( room, result,index)
	if result == 0 then
		if not room:StartGame() then
			printf("启动游戏失败!");
		end
		return;
	end

	local msgs = {
		"您的豆豆数不符合房间设置,无法游戏!",
		"当前没有合适您的队伍",
		"当前没有合适您的队伍"
	}

	GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG, msgs[result] or "未知错误");
end

--[[
* @brief 用户被踢出桌子
* @param reason 踢出原因,如果为空,则解散或者无条件起立
]]
function e.OnMsgDeskKickPlayer( room,reason )
	room:StopGame();
	if reason and reason ~="" then
		GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG, reason);
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

return TeamRoomMgr