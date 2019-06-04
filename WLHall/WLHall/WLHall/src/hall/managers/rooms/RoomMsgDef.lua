local function CreatEnumTable(tbl, index) 
    local enumtbl = {} 
    local enumindex = index or 0 
    for i, v in ipairs(tbl) do 
        enumtbl[v] = enumindex + i - 1
    end 
    return enumtbl 
end 
--4096开始
local RoomMsg =
{
	--/进入房间广播",服务器发送
	--/@see msg_room_join_notify
	"JOIN_NOTIFY",
	--!<房间信息", 服务器发送 @see msg_room_roominfo_reply
	"ROOMINFO_REPLY",			
	--!<更新玩家数据 服务器发送 @see msg_room_update_player_data_notify
	"UPDATE_PLAYER_DATA_NOTIFY",	
	--!<更新玩家状态广播 服务器发送 @see msg_room_player_state_notify
	"PLAYER_STATE_NOTIFY",
	--!<玩家请求坐下 大厅发送 @see msg_room_sit_down
	"SIT_DOWN",	
	--!<玩家坐下广播 服务器发送 @see msg_room_sit_down_notify
	"SIT_DOWN_NOTIFY",
	--!<玩家坐下失败 服务器发送 @see msg_room_sit_down_failed
	"SIT_DOWN_FAILED",	
	--!<玩家起立 大厅发送 @see msg_room_stand_up
	"STAND_UP",	
	--!<玩家起立广播 服务器发送 @see msg_room_stand_up_notify
	"STAND_UP_NOTIFY",
	--!<玩家准备广播 服务器发送 @see msg_room_ready_notify
	"READY_NOTIFY",		
	--!<玩家离开广播 服务器发送 @see msg_room_player_leave_notify
	"PLAYER_LEAVE_NOTIFY",	
	--!<桌子状态改变广播 服务器发送 @see msg_room_desk_state_notify
	"DESK_STATE_NOTIFY",	
	--!<玩家设置 大厅发送 @see msg_room_usersetting
	"USERSETTING",	
	--!<房间聊天 大厅发送
	"CHAT",		
	--!<房间聊天广播 服务器发送
	"CHAT_NOTIFY",				
	--!<玩家使用道具 大厅发送
	"USE_PROP",	
	--!<玩家使用道具广播 服务器发送
	"USE_PROP_REPLY",	
	--!<服务器桌子踢人 （调用 @ref _BaseGameServer::CBaseDesk::KickPlayer 时发送)
	"DESK_KICK_PLAYER",	
	--!<玩家踢人 大厅发送
	"PLAYER_KICK_PLAYER",
	--!<玩家踢人转发 服务器发送
	"PLAYER_KICK_PLAYER_REPLY",	
	--!<邀请玩家 大厅发送
	"INVITE",	
	--!<服务器转发邀请请求 服务器发送
	"INVITE_REPLY",	
	--!<房间内系统消息（临时
	"SYSTEM_MSG_NOTIFY",	
	--!<GM命令
	"GM_COMMAND",	
	--比赛消息
	--!<比赛玩家信息列表@see msg_room_pk_player_join
	"PK_PLAYER_JOIN",
	--!<回合结束
	"PK_ROUND_OVER",		
	--!<比赛淘汰信息 
	"PK_ELIMINATE",	
	--!<更新桌子底注
	"UPDATE_BASE_MONEY_NOTIFY",
	--!<系统分桌
	"ALLOC_SIT",
	--!<系统分桌桌子信息
	"ALLOC_SIT_DESK_INFO",
	--!<请求匹配
	"TEAM_CREATE",		--创建队伍
	"TEAM_CREATE_FAILED",--创建队伍失败
	"TEAM_CREATE_NOTIFY",--创建队伍应答
	"TEAM_JOIN",			--加入队伍
	"TEAM_JOIN_FAILED",	--加入队伍失败
	"TEAM_JOIN_REPLY",	--加入队伍应答
	"TEAM_DISBAND",		--队伍解散
	"TEAM_LEAVE",		--离开分组
	"TEAM_START_QUICKLY",--快速开始
	"TEAM_START_QUICKLY_REPLY",--快速开始应答
	"PK_UPDATE_PLAYERS",	--更新玩家数量
	"PK_ADD_GROUP",		--创建分组
	"PK_REMOVE_GROUP",	--移除分组
	"PK_UPDATE_GROUP",	--更新分组信息
	"PK_PLAYER_AWARD",	--比赛奖励
	"PK_PLAYER_JOIN_REPLY",--加入比赛结果
	"SAVE_MONEY",		--存钱
	"SAVE_MONEY_REPLY",	--存钱应答
	"PK_GROUP_CHANGE_STATE",--更改分组状态
	"PK_RANK_LIST",		--比赛排名
	"PK_WAIT_DESK_GAME_OVER",	--!<等待其他比赛桌游戏结束
	"PK_MESSAGE",		--!<比赛消息通知
	"JOIN_LIMIT",		--!<不符合进入条件(报名费不够)
	"USE_PROP_FAILED",	--!<使用道具失败
	"REPORT",			--!<举报
	"REPORT_REPLY",		--!<举报应答
	"TASK_LIST",			--!<任务列表
	"TASK_COMPLETE",		--!<任务提交
	"TASK_COMPLETE_REPLY",--!<任务提交应答
	"TASK_GIVEUP",		--!<任务放弃
	"TASK_GIVEUP_REPLY",	--!<任务放弃应答
	"TASK_GOT_NEW",		--!<发送一个新任务
	"PK_SCORE_RECLAC",    --!<比赛积分调整(4158)	
	"PK_ROOM_INFO_REPLY",    --!,
	"PK_ROOM_RANK",
	"MIXED_ROOM_INFO",       -- 混房间房间消息(4161)
	"MIXED_ROOM_INFO_REPLY", -- 混房间房间消息回包(4162)
	"MIXED_ROOM_INFO_REQUEST", -- 混房间房间消息回包(4163)
	"MIXED_ROOM_RECONNECT",		-- 混房间断线重连(4164)
	"PK_ROOM_ERROR",		-- 预报名比赛开赛失败(4165)
}

return CreatEnumTable(RoomMsg,4096)