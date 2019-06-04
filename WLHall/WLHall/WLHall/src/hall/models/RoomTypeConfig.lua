local RoomManagerConfig={
	[ROOM_TYPE_FREE_MODE]="hall.managers.rooms.FreeSeatRoomMgr",   --//自由落座模式
	[ROOM_TYPE_ALLOCSIT]="hall.managers.rooms.AllocSitRoomMgr",    --//房间内玩家座位由系统分配,无法自己选择座位
	[ROOM_TYPE_ALLOCSIT2]="hall.managers.rooms.AllocSitRoomMgr",	 --//系统分桌模式,随机分配位置
	[ROOM_TYPE_TEAM]="hall.managers.rooms.TeamRoomMgr",			 --//组队模式房间
	[ROOM_TYPE_FRIEND_TEAM]="hall.managers.rooms.CustomRoomManager",	 --//朋友场模式房间
	[ROOM_TYPE_PK_MODE1]="hall.managers.rooms.PK1RoomMgr",		 --//比赛模式1房间
	[ROOM_TYPE_PK_MODE2]="",										 --//比赛模式2房间
	[ROOM_TYPE_PK_MODE3]="hall.managers.rooms.PK3RoomMgr",
	[ROOM_TYPE_PK_MODE4]="hall.managers.rooms.PK4RoomMgr",
}
return RoomManagerConfig
