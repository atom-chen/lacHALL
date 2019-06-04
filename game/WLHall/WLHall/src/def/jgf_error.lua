--
-- Author: Your Name
-- Date: 2016-09-14 10:55:27
--
local JGF_ERROR=
{
	OK	=0,					--//忽略（）
	IN_MONEY_ROOM=1,	--//已经在金币房间
	PLAYERS_CRITICAL=2,	--//玩家数临界
	PLAYERS_MAX=3,		--//玩家数达到最大
	RIGHT=4,			--//没有权限
	MONEY_LIMIT=5,		--//金钱或者积分限制
	MONEY_MAX_LIMIT=6,	--//金钱或者积分上限限制
	JOIN_LIMIT=7,		--//房间不允许进入
	ROOMID=8,			--//房间不存在或者已关闭
	IN_ROOM=9,			--//已经在房间
	CANCEL=10,			--//!<取消加入房间
	NEED_DATA=11,		--//!<报名条件限制（报名费)
	LIMIT_WIN_MONEY=12,	--//!<输赢总数受限
}

return JGFError
