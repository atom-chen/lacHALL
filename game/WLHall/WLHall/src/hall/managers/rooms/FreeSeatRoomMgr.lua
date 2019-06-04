--[[
自由落座房间
* 房间属性
name 字符串,房间名
gamename 字符串,游戏名
playerself CLuaPlayer对象,玩家自己,可能为nil
deskcount WORD 房间内桌子数量
playerperdesk WORD 每桌椅子数量
gameclient CBaseGameClient对象 也可以用全局变量GameClient
roomsetting table 房间设置表
   {
		pintlimit DWORD 限制玩家网络延迟,默认0xFFFFffff
		freeratelimit BYTE(0-100) 限制玩家的逃跑率,默认100
		scoreminlimit int 限制玩家的最小积分,默认Helper.INT_MIN
		scoremaxlimit int 限制玩家的最大几份,默认Helper.INT_MAX,
		moneylimit DWORD 限制玩家的最小金钱数,默认0
		allowsameip bool 是否允许相同IP玩家同桌,默认false
		allowlookon bool 是否允许其他玩家旁观,默认true
		password string 桌子设置的密码,为""则没有密码,默认""
   }

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
	玩家坐下(桌子ID,椅子ID,桌子密码)[返回是否成功]\[失败原因,如果失败]
	bool,const char* Sitdown(WORD wDeskID,WORD wChairID,const char* password=NULL);
	查找座位()[返回桌子ID]\[椅子ID],如果桌子ID为nil,则没有符合条件的座位
	WORD,WORD FindSit()
	根据ID查找房间内用户(用户ID)返回玩家对象,返回nil则没有这个用户
	CLuaPlayer* FindPlayer(DWORD dwID);
	用户设置roomsetting发生改变
	void OnRoomSettingChanged();
	获得指定桌子(桌子ID)返回桌子对象或者nil
	CRoomDesk* GetDesk(WORD);

*桌子对象
	*属性
		basemoney DWORD 桌子底注
		id WORD 桌子ID
		state BYTE 桌子状态
		pkdesk bool 是否是PK桌
		locked bool 是否有密码
		gaming bool 是否已经开始游戏
		players WORD 桌子上玩家数量(不包括旁观玩家)
	*方法
		设置指定玩家(玩家对象,座位号) --玩家对象可以为nil
		void SetPlayer(CLuaPlayer* player,WORD wChairID);
		获得指定座位玩家(座位号)玩家对象
		CLuaPlayer* GetPlayer(WORD wChairID);
	*事件表 N/A
]]

local MSG_ID = import(".RoomMsgDef")

--事件表
local e = {};

local FreeSeatRoomMgr = ClassEx("FreeSeatRoomMgr",function()
	local obj =  CFreeSitdownRoomManager.New()
	obj.event = e;
	return obj;
end);

local function RoomJoinGame( room )
	local playerself = room.playerself;
	room:StartGame();
	room:OnNotifyGamePlayerJoin(room:GamePlayerFromRoomPlayer(playerself),true);
	local desk = room:GetDesk(playerself.deskid);
	for i=0,room.playerperdesk do
		local player = desk:GetPlayer(i);
		if player and player ~= playerself and not player.lookon then
			room:OnNotifyGamePlayerJoin(room:GamePlayerFromRoomPlayer(player),false);
		end
	end
end

function e.Initialize(room)

	room._deskList = {}				-- 桌子列表

	local roomSetting = room.roomsetting

	-- 房间初始化通知
	--GameApp:dispatchEvent(gg.Event.ROOM_INITIALIZE , room )

	return true
end

function e.Shutdown(room)

	-- 房间销毁通知
	GameApp:dispatchEvent(gg.Event.ROOM_SHUTDOWN , room )
end

--进入房间成功
function e.OnMsgJoinRoom(room)

	-- 房间初始化通知
	GameApp:dispatchEvent(gg.Event.ROOM_JOIN_ROOM_REPLY , room )
end

--其他玩家进入房间
--player 玩家对象
function e.OnMsgPlayerJoin( room,player)
	printf("Freeseat OnMsgPlayerJoin ")



end

--[[
* @brief 快速开始
]]
function FreeSeatRoomMgr:QuickStart()

	-- 查找椅子号
	local deskid , chairid = self:FindSit()

	if deskid and chairid then

		-- 发起坐下
		self:SitDown( deskid , chairid )
	else
		-- 失败提示
		GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG,"没有找到空座位,请稍后再试！")

		return false
	end
end

--[[
* @brief 选择指定桌子
* @parm id 桌子ID
]]
function FreeSeatRoomMgr:SitDown_( id )

	local desk = self:GetDesk( id )

	for i = 0 , self.playerperdesk - 1 do

		if not desk:GetPlayer( i ) then

			-- 发起坐下
			self:SitDown( id , i )

			return
		end
	end

	-- 坐下失败
	GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG,"该桌子玩家已满,请选择其他桌子进行游戏！")
end

--玩家坐下
function e.OnMsgSitDown( room,player )

	if player.lookon then --旁观
		return;
	end

	if player == room.playerself then --自己坐下

		-- 开始游戏
		if not room:IsClientRunning() then
			room:StartGame()
		end

	elseif player.deskid == room.playerself.deskid then --同一桌
		room:OnNotifyGamePlayerJoin(room:GamePlayerFromRoomPlayer(player),false);
	end

	-- 更新桌子人数
	GameApp:dispatchEvent(gg.Event.ROOM_UPDATE_DESK_PLAYERS , room )
end

--[[
* @brief 坐下失败
* @param result 坐下失败原因
* @param limit 当自己豆豆太少时,limit为最小要求值
]]
function e.OnMsgSitDownFailed( room,result,limit )

	local msgs =
		{
			"游戏已经开始",
			"该座位上已经有其他玩家",
			"密码不正确,请重新输入！",
			"游戏没有开始,不允许旁观！",
			"本桌有玩家豆豆太少,与您的设置不符合",
			"您的积分太少,有玩家不愿与您同桌",
			"本桌有玩家积分太高,与您的设置不符合",
			"您的积分太高,有玩家不愿与您同桌",
			"您的豆豆少于"..tostring(limit)..",与桌上其他玩家设置不符",
			"本桌有玩家网络延迟太高,与您的设置不符合",
			"您的网络延迟太高,有玩家不愿与您同桌",
			"本桌有玩家逃跑率太高,与您的设置不符合",
			"您的逃跑率太高,有玩家不愿与您同桌",
			"当前桌有相同IP的玩家!",
			"您的豆豆太少,不符合房间要求",
			"您的豆豆高于房间最大限制!",
		};
	if Helper.And(room:GetRoomType(),ROOM_TYPE_MONEY) == 0 then --积分房间
		msgs[16] = "您的积分太少,不符合房间要求";
		msgs[17] = "您的积分高于房间最大限制!";
	end
end

--玩家起立
function e.OnMsgStandUp( room,player )

	if not player.lookon then --旁观
		room:GetDesk(player.deskid):SetPlayer(nil,player.chairid);
	end

	if player == room.playerself then
		room:StopGame();
	elseif player.deskid == room.playerself.deskid and not player.lookon then --跟自己一桌的并且不是旁观的
		--room:OnNotifyGamePlayerLeave(GameFindPlayer(player.id));
	end

	player.deskid=INVALID_DESK;
	player.chairid = INVALID_CHAIR;
	player.lookon=false;

	-- 更新桌子人数
	GameApp:dispatchEvent(gg.Event.ROOM_UPDATE_DESK_PLAYERS , room )
end
--玩家准备
function e.OnMsgReady( room,player,bready )
	player.ready=bready;
	-- printf("Freeseat OnMsgReady ")
end

--玩家离开房间
function e.OnMsgPlayerLeave( room,player )
	-- printf("Freeseat OnMsgPlayerLeave ")
end
--桌子状态变化
function e.OnMsgDeskState( room,desk,state )
	desk.state = state;

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

--[[
* @brief 用户更新数据
* @param player 数据发生变化的玩家
]]
function e.OnMsgUpdate( room,player )
	-- printf("Freeseat OnMsgUpdate ")
end

--[[
* @brief 桌子底注发生变化
]]
function e.OnMsgBaseMoneyChange( room,desk,basemoney )
	desk.basemoney=basemoney;
	roomlayer:updateDeskInfo(desk)
	printf("Freeseat OnMsgBaseMoneyChange "..tostring(basemoney))
end



--以下函数可选择实现
--[[系统消息
function e.OnSystemMessage( room,msgtype,msg )

end
]]

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

return FreeSeatRoomMgr;