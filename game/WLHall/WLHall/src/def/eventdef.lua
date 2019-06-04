--
-- Author: Your Name
-- Date: 2016-08-23 21:11:53
--
local Event = gg.Event

--Event.KEY_BACK_CLICKED="event_key_back_cilcked" --返回事件

Event.SHOW_MESSAGE_DIALOG="event_show_message_dialog" --显示弹出对话框提示
Event.SHOW_TOAST="event_show_toast" --显示土司提示
Event.SHOW_LOADING="event_show_loading" --显示等待提示
Event.SHOW_PAY_LOADING="event_show_pay_loading" --显示支付结果确认中的提示（H5支付相关）
Event.SHOW_VIEW="event_show_view" --显示层
Event.RECONNECT_SUCCESS="event_reconnect_success"  --重新连接成功
Event.RECONNECT_BEGIN="event_reconnect_begin" -- 开始断线重连
Event.DISABLE_APPENTER="event_disable_appenter" --支付时禁止app前后台切换事件

Event.ON_PAY_RESULT="event_on_pay_result" --支付结果
Event.ON_SHARE_RESULT="event_on_share_result" --分享结果
Event.ON_POP_PAY = "event_on_pop_pay" --弹出计费点支付成功回包

Event.SHOW_ROOM_LIST="event_show_room_list" --显示房间列表

Event.NETWORK_ERROR = "event_socket_error"     							--//断线通知

Event.ROOM_MONEY_LIMIT 	= "event_room_money_limit";					--//游戏中发出的 金钱条件

Event.HALL_UPDATE_USER_DATA 	= "event_hall_update_user_data";					--//更新用户数据
Event.HALL_ON_JOIN_HALL = "event_hall_on_join_hall"     						    ---//加入大厅成功

Event.HALL_JOIN_HALL_SUCCESS = "EVENT_HALL_JOIN_HALL_SUCCESS"     						    		---//加入大厅成功

Event.HALL_UPDATE_UPDATE_ROOM_PLAYERS = "event_hall_update_update_room_players"     --//更新房间人数

Event.ROOM_JOIN_PK1_REPLY = "event_room_join_pk1_reply"     						--//加入比赛应答
Event.ROOM_JOIN_ROOM_REPLY = "event_room_join_room_reply"     						--//加入房间应答

Event.ROOM_JOIN_NOTIFY = "event.room_join_notify"									--//进入朋友场房间成功
Event.CLOSE_SELECT_SEAT_NOTIFY = "event.close_select_seat_notify"					--//关闭选座界面

Event.ROOM_INITIALIZE = "event_room_initialize"     						        --//房间初始化

Event.ROOM_SHUTDOWN = "event_room_shutdown"     						            --//房间销毁
Event.ROOM_UPDATE_DESK_PLAYERS = "event_room_update_desk_players"     		        --//更新桌子人数

Event.ROOM_SIT_DOWN_FAIL = "event_room_sit_down_fail"     							--//落座失败

Event.ROOM_ALLOC_SIT_DESK_INFO = "event_room_alloc_sit_desk_info"                   --//分配桌子信息

Event.ROOM_UPDATE_PK_PLAYERS = "event_room_update_pk_players"						--//更新比赛人数

Event.ROOM_UPDATE_SIGNUP_PLAYERS = "event_room_update_signup_players"				--//更新预报名人数

-- 预报名比赛比赛积分调整
Event.ROOM_PK_SCORE_RECLAC = "event_room_pk_score_reclac"

Event.GPS_POSITION_UPDATE = "event_gps_position_update"                             --//地理位置变化的消息

Event.BROADCAST_SYSTEM_MESSAGE = "event_broadcast_system_message"  					--//广播系统消息

Event.HALL_WEB_INIT = "event_hall_web_init"  										--//Web接口初始化成功
Event.HALL_UPDATE_NOTICE_UNREAD_COUNT = "event_hall_update_notice_unread_count"     --//刷新公告未读取数量

Event.HALL_ACTIVATE_USER = "EVENT_HALL_ACTIVATE_USER"     							--//激活账号通知
Event.HALL_ACTIVATE_USER_PHONE = "EVENT_HALL_ACTIVATE_USER_PHONE"     				--//手机激活通知
Event.HALL_ACTIVATE_USER_WX = "EVENT_HALL_ACTIVATE_USER_WX"     					--//微信激活通知

Event.HALL_BIND_PHONE = "EVENT_HALL_BIND_PHONE"     								--//手机绑定通知

Event.HALL_CHANGE_SEX = "EVENT_HALL_CHANGE_SEX"     								--//修改性别

Event.HALL_SELECT_AREA = "EVENT_HALL_SELECT_AREA"									--//选择地区通知

Event.HALL_UPDATE_GAMELIST = "EVENT_HALL_UPDATE_GAMELIST"							--//游戏列表更新通知

Event.HALL_GAME_CFG_CHANGED = "event_hall_game_cfg_changed"                         --//游戏显示配置数据变化了

Event.HALL_QUERY_USER_DESK_REPLY="event_hall_query_user_desk_reply"				--//查询用户房间ID列表应答
Event.HALL_CREATE_ROOM_REPLY="event_hall_create_room_reply"						--//用户创建房间应答
Event.HALL_DISBAND_ROOM_REPLY="event_hall_disband_room_reply"					--//用户解散房间应答
Event.HALL_QUERY_DESKINFO_REPLY="event_hall_query_deskinfo_reply"				--//查询桌子状态应答
Event.HALL_KICK_PLAYER_BY_OWNER_REPLY="event_hall_kick_player_by_owner_reply"	--//代开房主踢人应答
Event.HALL_QUERY_ROOMKEY_FAILED="event_hall_query_roomkey_failed"               --//查询房间失败

Event.HALL_MATCH_SOON_START_NOTIC = "event_hall_match_soon_start_notic"			--//比赛要开始的通知
Event.HALL_MATCH_TIME_UPDATE_NOTIC = "event_hall_match_time_update_notic"		--//比赛时间刷新通知
Event.HALL_MATCH_START_FAILED_NOTIC = "event_hall_match_start_failde_notic"     --//比赛开赛失败通知

--Event.LOGIN_CHECK_VERSION_REPLY = "event_login_check_version_reply"

--Event.LOGIN_BY_NAME_REPLY = "event_login_by_name_reply"

--Event.LOGIN_GET_PIC_MASK = "event_LOGIN_GET_PIC_MASK"

--Event.LOGIN_GET_PIC_MASK = "event_login_get_pic_mask"

--Event.LOGIN_REGISTER_USER = "event_login_register_user"						--//注册用户
--Event.LOGIN_REGISTER_USER_REPLY = "event_login_register_user_reply"			--//注册用户应答

--Event.LOGIN_BY_UNNAME = "event_login_by_unname"								--//匿名登陆
--Event.LOGIN_BY_UNNAME_FAILED = "event_login_by_unname_failed"					--//匿名登陆失败
--Event.LOGIN_BY_UNNAME_REPLY = "event_login_by_unname_reply"					--//匿名登陆应答

--Event.LOGIN_GET_ROLE_LIST = "event_login_get_role_list"  						--//获取用户列表
--Event.LOGIN_GET_ROLE_LIST_REPLY = "event_login_get_role_list_reply"  			--//获取用户列表应答

--Event.LOGIN_ALLOC_ROLE = "event_login_alloc_role"  							--//分配用户名
--Event.LOGIN_ALLOC_ROLE_REPLY = "event_login_alloc_role_reply"  				--//分配用户应答

Event.LOGIN_SYSTEM_MESSAGE = "event_login_system_message"  					    --//系统消息

--Event.LOGIN_BY_NAME2 = "event_login_by_name2";									--//用户登录

--Event.LOGIN_ALLOC_ROLE2 = "event_login_alloc_role2";							--//分配用户名（带用户平台来源)


--Event.HALL_USER_JOIN_REPLY	= "event_hall_user_join_reply";						--//进入大厅应答
--Event.HALL_SYSTEM_MESSAGE		= "event_hall_system_message";					--//系统消息
--Event.HALL_ADD_ROOM			= "event_hall_add_room";						--//新房间加入
--Event.HALL_REMOVE_ROOM		= "event_hall_remove_room";							--//房间移除
--Event.HALL_UPDATE_VERSION		= "event_hall_update_version";					--//更新版本

--Event.HALL_JOIN_GAME 			= "event_hall_join_game";						--//加入游戏
--Event.HALL_JOIN_GAME_REPLY	= "event_hall_join_game_reply";						--//加入房间失败
--Event.HALL_LEAVE_GAME 		= "event_hall_leave_game";							--//离开游戏
--Event.HALL_LEAVE_GAME_REPLY	= "event_hall_leave_game_reply";				--//离开游戏应答
Event.LEAVE_NORMAL_ROOM = "event_leave_normal_room";                            --//离开普通场房间

Event.HALL_EXCHANGE_MONEY 	= "event_hall_exchange_money";						--//游戏币兑换,8203
Event.HALL_EXCHANGE_MONEY_REPLY = "event_hall_exchange_money_reply";			--//游戏币兑换应答,8204
--Event.HALL_CHANGE_USER_INFO   = "event_hall_change_user_info";					--//更改用户信息,8205
--Event.HALL_CHANGE_USER_INFO_REPLY="event_hall_change_user_info_reply";			--//更改用户信息应答,8206

--Event.HALL_USE_PROP = "event_hall_use_prop";									--//使用道具,8207
--Event.HALL_USE_PROP_REPLY = "event_hall_use_prop_reply";						--//使用道具应答,8208
--Event.HALL_PROP_LIST = "event_hall_prop_list";								    --//道具列表(服务器发送)		8209
--Event.HALL_MSGS_LIST = "event_hall_msgs_list";									--//*离线消息列表	8210
--Event.HALL_MISSION_LIST = "event_hall_mission_list";							--//任务列表		8211

--Event.HALL_GET_RANK_LIST      = "event_hall_get_rank_list";					--//排行榜			8212
--Event.HALL_GET_RANK_LIST_REPLY= "event_hall_get_rank_list_reply";				--//排行榜应答		8213

--Event.HALL_MISSION_COMPLETE 	= "event_hall_mission_complete";				--//任务完成		8214
--Event.HALL_MISSION_COMPLETE_REPLY = "event_hall_mission_complete_reply";		--//任务完成应答	8215


--Event.HALL_USER_REPORT_REPLY	= "event_hall_user_report_reply";				--//用户签到应答	8217


--Event.HALL_GET_SHOPINFO_REPLY	= "event_hall_get_shopinfo_reply";				--//获得商店信息应答8219


--Event.HALL_BUY_PROP_REPLY		= "event_hall_buy_prop_reply";					--//购买道具应答	8221


--Event.HALL_LOAD_EFFORT_DATA_REPLY="event_hall_load_effort_data_reply";			--//获得成就数据应答8223


--Event.HALL_CHANGE_PASSWORD_REPLY = "event_hall_change_password_reply";			--//修改密码应答


--Event.HALL_SET_SECOND_PASSWORD_REPLY= "event_hall_set_second_password_reply";		--//设置二级密码应答
--Event.HALL_CHECK_SECOND_PASSWORD_REPLY = "event_hall_check_second_password_reply";	--//检测二级密码应答


--Event.HALL_BIND_MACHINE_REPLY = "event_hall_bind_machine_reply";

--Event.HALL_MISSION_COMPLETE_LIST = "event_hall_mission_complete_list";				--//完成任务列表



--Event.HALL_CHANGE_USER_INFO_MOBILE = "event_hall_change_user_info_mobile";			--//移动平台更改用户信息


--Event.HALL_EXCHANGE_LOTTERY_REPLY = "event_hall_exchange_lottery_reply";


--Event.HALL_EXCHANGE_PROP_CARD_REPLY = "event_hall_exchange_prop_card_reply";		--//兑换道具卡片应答


--Event.HALL_GET_GAME_MISSION_LIST_REPLY = "event_hall_get_game_mission_list_reply";	--//获得游戏关卡任务应答


--Event.HALL_GAME_MISSION_COMPLETE_REPLY = "event_hall_game_mission_complete_reply";	--//游戏任务提交应答


--Event.HALL_SET_USER_IDCARD_REPLY = "event_hall_set_user_idcard_reply";				--//设置身份证应答


--Event.HALL_GET_USER_GAMEDATA_REPLY = "event_hall_get_user_gamedata_reply";			--//拉取用户游戏数据应答

Event.BUG_MONTHCARD_SUCCESS = "event_buy_monthcard_success";       --//用户购买了贵族月卡
Event.BUG_MONTHCARD_VIP_SUCCESS = "event_buy_monthcard_vip_success";       --//用户购买了星耀月卡
Event.GOT_PRIVILEGE_REWARD = "event_got_privilege_reward";          --//用户领取了贵族特权奖励
Event.GAME_STOP = "event_game_stop";                                --//用户从游戏退出

Event.UPDATE_MESSAGE_STATUS = "event_update_message_status"  -- 刷新个人消息的状态
Event.ADDED_GAME_CHANGED = "event_added_game_changed"   --刷新游戏列表

Event.RETRY_LOGIN = "event_retry_login"   --重试登录

-- 视频 SDK Agora 相关的事件
Event.AGORA_JOIN_CHANNEL_SUCCESS = "event_agora_join_channel_success"
Event.AGORA_FIRST_REMOTE_VIDEO_DECODED = "event_agora_first_remote_video_decoded"
Event.AGORA_LEAVE_CHANNEL = "event_agora_leave_channel"
Event.AGORA_USER_OFFLINE = "event_agora_user_offline"
Event.AGORA_USER_ENABLE_VIDEO = "event_agora_user_enable_video"
Event.AGORA_USER_MUTE_VIDEO = "event_agora_user_mute_video"
Event.AGORA_USER_JOINED = "event_agora_user_joined"
Event.AGORA_AUDIO_ROUTE_CHANGED = "event_agora_audio_route_changed"
Event.AGORA_REMOTE_VIDEO_STATS = "event_agora_remote_video_stats"
Event.AGORA_LOCAL_VIDEO_STATS = "event_agora_local_video_stats"
Event.AGORA_FIRST_REMOTE_VIDEO_FRAME = "event_agora_first_remote_video_frame"
Event.AGORA_FIRST_LOCAL_VIDEO_FRAME = "event_agora_first_local_video_frame"
Event.AGORA_VIDEO_SIZE_CHANGED = "event_agora_video_size_changed"
Event.AGORA_CAMERA_READY = "event_agora_camera_ready"
Event.AGORA_VIDEO_STOPPED = "event_agora_video_stopped"
Event.AGORA_ERROR = "event_agora_error"
--兑换商城的事件
Event.GIFT_CHECK_RECORD = "event_gift_check_record"  --查看订单
-- 活动状态变为已读
Event.UPDATE_ACTIVITY_READED = "event_update_activity_readed"
--小游戏下载
Event.MINIGAMES_DOWNLOAD = "event_minigames_download"
-- 每日分享首次分享成功
Event.FIRST_DAILY_SHARE_SUCCESS = "event_first_daily_share_success"
-- 游戏房间退回大厅主界面
Event.GAME_ROOM_BACK_TO_HALL = "event_game_room_back_to_hall"

Event.STORE_VIEW_CLOSE = "event_store_view_close"
Event.STORE_VIEW_OPEN = "event_store_view_open"
Event.CLOSE_WEB_GAME = "event_close_web_game"

--免费福利的事件
Event.WELFARE_ACTIVITY = "event_welfare_activity"

-- 屏幕翻转的事件
Event.SCREEN_SIZE_CHANGE = "event_screen_size_change"

Event.NEW_MINIGAME_WARN = "event_new_minigame_warn"			--//新的小游戏提醒通知

-- 购买记牌器成功通知
Event.BUY_JIPAIQI_SUCCESS = "event_buy_jipaiqi_success"


Event.ON_BFBFL_PAY = "event_on_bfbfl_pay" --活动返利支付成功回包
return Event
