--[[
定时赛房间

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

local PK_GROUP_STATE_WAITING = 0    --//等待状态(时间没到)
local PK_GROUP_STATE_JOIN = 1	    --//加入状态
local PK_GROUP_STATE_STEP = 2	    --//阶段1

local PK4RoomMgr = ClassEx("PK4RoomMgr", function()
	local obj = CPK1RoomManager.New()
	obj.event = e
	return obj
end)

local roomlayer

--[[
* @brief 初始化
* @parameter room 房间对象
]]
function e.Initialize(room)
	print("pk4 e.Initialize")
	return true;
end

--[[
* @brief 销毁
* @parameter room 房间对象
]]
function e.Shutdown(room)
	print("e.Shutdown")
end

local function DoJoinRoom_(room, groupstate)
	if not room._baseRoomMsg or not room._extRoomMsg then
		print("pk4房间数据没有完全获取到！！！！")
		return
	end

	local groupid = 0
	if hallmanager then
		-- 收到进入等待或游戏开始所记录的分组数据，则使用该groupid
		if PK4_JOIN_GROUPID then
			groupid = PK4_JOIN_GROUPID
			PK4_JOIN_GROUPID = nil
		-- 如果用户已经进入房间，存在当前分组信息，则使用该groupid
		elseif room.pk4Info and checkint(checktable(room.pk4Info).playerGroupId) ~= 0 then
			groupid = checkint(checktable(room.pk4Info).playerGroupId)
		-- 如果上述数据都为获得，则判断当前比赛分组用户是否有报名数据，如果有，则使用该groupid
		else
			local curGroupid = checkint(checktable(hallmanager:GetLatelyGroup(room:GetID())).id)
			-- 判断即将加入的分组是否已经可以进入等待界面，如果没有，可能由于用户的时间戳造成请求分组错误，尝试改为使用上一个报名分组
			local curGroup = hallmanager:GetGroupById(room:GetID(), curGroupid)
			if curGroup then
				local cd = curGroup.startTime - os.time() - curGroup.timeDiff
				if cd >= 60 then
					curGroupid = checkint(checktable(hallmanager:GetPreGroup(room:GetID(), curGroupid)).id)
				end
			end

			local sign = hallmanager:GetSignUpInfo(room:GetID(), curGroupid)
			if sign then
				groupid = curGroupid
			end
		end
		
		-- 如果请求加入的用户桌子数已经结束，则清除报名数据，不再加入
		if room.pk4Info and room.pk4Info.isInDesk == 2 and groupid ~= 0 then
			hallmanager:EmptySingUpInfo(room:GetID(), groupid)
			-- 关闭 loading 界面
			GameApp:dispatchEvent(gg.Event.SHOW_LOADING)
			-- 记录当前分组开赛失败，用于重新创建报名界面
			cc.exports.PK_ROOM_FAILED_GROUPID = {rid = room:GetID(), gid = groupid}
			GameApp:dispatchEvent(gg.Event.HALL_MATCH_START_FAILED_NOTIC, room:GetID(), groupid)
			return
		end	

		-- 已经加入房间，直接参赛
		if groupid ~= 0 then
			local msg = CLuaMsgHeader.New()
			msg.id = 4120
			msg:WriteDword(groupid)
			msg:WriteByte(1)
			room:SendData(msg, CRYPT_MSG)

			-- 关闭比赛定时器
			local allInfo = hallmanager:GetAllSignUpInfo()
			if not allInfo or #allInfo == 0 then
				hallmanager:StopMatchTimer()
			end
		end
	end

    -- 解除通知
    gg.NotificationHelper:cancelLocalNotification(gg.NotificationHelper.notifyType.MATCH_START)

	GameApp:UpdateReconnectState(false, true)
    -- 关闭 loading 界面
    GameApp:dispatchEvent(gg.Event.SHOW_LOADING)
	-- 发送通知
	GameApp:dispatchEvent(gg.Event.ROOM_JOIN_ROOM_REPLY, room)
	-- 关闭比赛界面
	GameApp:dispatchEvent("gg.Event.ROOM_CLOSE_MATCH_JOIN", room)

	if groupstate >= PK_GROUP_STATE_JOIN then
		if not room:StartGame() then
			printf("OnMsgJoinRoom 启动失败")
			return
		end

		if GameClient then
			if groupid == 0 then
				-- 游戏已经结束或未成赛，断线重连需要关闭游戏客户端
				GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "本次赛事取消或已结束")
				room:StopGame();
				return
			end
			GameClient.starttime = room.starttime
			GameClient.roominfo = checktable(GameClient.roominfo)
			GameClient.roominfo.pk4Info = room.pk4Info
		end
	else
        -- 没在游戏中了，需要清掉 GameClient 这个全局对象
        -- 同时发送回到大厅的通知
        if GameClient then
            rawset(_G, "GameClient", nil)
            GameApp:dispatchEvent(gg.Event.HALL_ON_JOIN_HALL, 2)
        end
	end
end

--进入房间成功
function e.OnMsgJoinRoom(room, groupstate)
	room._baseRoomMsg = true
	DoJoinRoom_(room, groupstate)
end

--[[
* @brief 用户被踢出桌子
* @param reason 踢出原因,如果为空,则解散或者无条件起立
]]
function e.OnMsgDeskKickPlayer(room, reason)

end

--[[
* @breif 玩家报名比赛结果
* @param result 报名结果 0 为成功
* @param bJoin 报名为true,退赛为false
]]
function e.OnMsgPKJoin(room, result, bJoin)
	if result == 0 then
		-- 报名成功通知
		GameApp:dispatchEvent(gg.Event.ROOM_JOIN_PK1_REPLY, result,bJoin)
		return;
	end

    if room.selfgroup > 0 and room.groupstate >= 2 then
        -- 玩家在游戏中，不需要处理
        return
    end
end

--[[
* @brief 通知更新玩家数量
]]
function e.OnMsgUpdatePlayers(room, roomplayer, maxplayer, groupplayers)

end

--[[比赛阶段发生变化]]
function e.OnMsgChangeState(room, state)

end

--关闭报名界面
function e.OnMsgAllocSitDeskInfo(room)

end

e[MSG_ID.PK_ROOM_INFO_REPLY] = function(room, msg)
	local pk4Info = {}
	pk4Info.maxPlayers = checkint(msg:ReadWord())	-- 最大玩家人数
	pk4Info.playerGroupId = msg:ReadDword()			-- 玩家groupid
	pk4Info.curGroupId = msg:ReadDword()			-- 当前groupid
	pk4Info.totolPlayers = msg:ReadWord()			-- 总玩家数量
	pk4Info.curStatus = msg:ReadWord()				-- 场次状态值
	pk4Info.isInDesk = msg:ReadWord()				-- 玩家是否在桌子上
	local cnt = checkint(msg:ReadWord())
	pk4Info.danInfo = {}	-- 段位信息
	for i=1,cnt do
		local tb = {}
		tb.section = msg:ReadWord()			-- 1预赛 2晋级 3决赛
		tb.joinCnt = msg:ReadWord()			-- 参赛人数
		tb.cutOffCnt = msg:ReadWord()		-- 截止人数
		tb.promotedCnt = msg:ReadWord()		-- 晋级人数
		tb.curExtMatch = msg:ReadWord()		-- 加赛第几局
		tb.totolExtMatch = msg:ReadWord()	-- 共加赛几局
		pk4Info.danInfo[i] = tb
	end

	pk4Info.pk4time = 0
	pk4Info.sectionInfo = nil	-- 阶段文本信息
	pk4Info.countDown = 0
	-- 场次状态值 >= 第一阶段
	if pk4Info.curStatus >= PK_GROUP_STATE_STEP then
		pk4Info.pk4time = msg:ReadDword()	-- 时间
	else
		pk4Info.sectionInfo = {}
		local sectionCnt = msg:ReadWord()
		for i=1,sectionCnt do
			pk4Info.sectionInfo[i] = msg:ReadStringW()	-- 文本信息
		end
		pk4Info.countDown = msg:ReadWord()	-- 剩余倒计时
	end

	room.pk4Info = pk4Info
	room._extRoomMsg = true
	
	DoJoinRoom_(room, pk4Info.curStatus)
end

-- 比赛积分调整通知
e[MSG_ID.PK_SCORE_RECLAC] = function(room, msg)
	-- 调整的百分比，805表示80.5%
	local dwRate = msg:ReadDword()
	-- 调整后的积分
	local dwScore = msg:ReadDword()
	GameApp:dispatchEvent(gg.Event.ROOM_PK_SCORE_RECLAC, dwRate, dwScore)
end

-- 比赛开赛失败
e[MSG_ID.PK_ROOM_ERROR] = function(room, msg)
	GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "因报名人数不足，本次赛事取消")
	if room:IsClientRunning() then
		printf("客户端正在运行,关闭room:StopGame()")
		room:StopGame();
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

return PK4RoomMgr