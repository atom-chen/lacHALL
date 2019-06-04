USER_NAME_LEN       = 36 -- //用户名长度
MD5_PSW_LEN         = 16 --//MD5密码长度

UNDER_WRITE_LEN     = 50 --//个性签名长度

GAME_NAME_LEN       = 20 --//游戏名长度

GAME_SHORT_NAME_LEN = 5 --//游戏缩写名长度

GAME_SHELL_FILE_LEN = 32

ROOM_NAME_LEN       =40 --//房间名长度
COMMAND_LEN         = 260 --//附加命令长度

PASS_WORD_LEN       = 20 --//普通密码长度
ROOM_MSG_LEN        = 1024 --//!<房间消息长度
AVATAR_IMG_PATH_LEN = 128 --//!<头像地址长度
MAX_USER_NAME_LEN   = 36 --//!<实际用户名最大长度
MISSION_CONTEXT_LEN = 128 --//!<任务描述长度

EFFORT_DATA_LEN     = 4000 --//!<任务数据最大长度
EFFORT_DATA_COUNT   = 500 --    //!<任务总数据量

SHOP_GOODS_NAME     = 20 --//商店物品名
SHOP_GOODS_DESCRIPTION = 128 --//商店物品信息描述
ID_CARD_LEN         = 18 --//身份证号
FLYSHEET_ID_LEN     = 36 --//传单ID长度
MOBILE_PHONE_LEN    = 16 --//手机号码长度
QUESTION_ANSWER_LEN = 10 --//密码提示问题答案长度

DEVICE_CODE_LEN     = 42 --//设备ID长度
GAME_EXTAND_DATA_LEN = 128 --//游戏附加数据


RELATION_TYPE_ROOT      =0  --//顶级节点
RELATION_TYPE_GAME      =1  --//游戏节点
RELATION_TYPE_ROOM      =2  --//房间节点
RELATION_TYPE_RELATION  =3  --//子节点


GAME_GROUP_UNKOWN       = 0x00000000    --//!<未知类
GAME_GROUP_POKER        = 0x00000001    --//!<扑克类游戏
GAME_GROUP_MAHJONG      = 0x00000002    --//!<麻将类游戏
GAME_GROUP_CHESS        = 0x00000004    --//!<棋类游戏
GAME_GROUP_LEISURE      = 0x00000008    --//!<休闲类游戏
GAME_GROUP_FLASH        = 0x00000010    --//!<Flash游戏(WEB游戏)
GAME_GROUP_ALONE        = 0x00000020    --//!<单机游戏

GAME_GROUP_MASK=0xFFff

MASK_32=0xffffFFFF

GAME_PACKET_LEISURE     = 1             --//!<休闲游戏包,共可使用15种包,值不能超过0x01000000
GAME_PACKET_POKER       = 2             --//!<扑克包
GAME_PACKET_MAHJONG     = 3             --//!<麻将包
GAME_PACKET_COMMON      = 4             --//!<通用包

ROOM_TYPE_MONEY         = 0x0001        --//游戏币房间
ROOM_TYPE_TEMPLATE      = 0x0002        --//临时货币房间,进入房间分配金币,退出回收,不影响身上货币
ROOM_TYPE_TEMPSCORE     = 0x0004        --//临时积分,进入房间分配固定积分
ROOM_TYPE_RATETAX       = 0x0008        --//可变税率,房间的tax属性为百分比。如果没有此属性,则房间的tax属性为固定扣税值
ROOM_TYPE_HIDDEN        = 0x0010        --//房间内玩家信息不可见,并且无法在房间和游戏中聊天。

ROOM_TYPE_BASEMONEY     = 0x0020        --//基础底注房间,房间的BaseMoney属性有效。没有该属性,则房间内允许每桌不同底注
ROOM_TYPE_NO_PROP       = 0x0040        --//房间内禁止使用道具
ROOM_TYPE_VIP           = 0x0080        --//房间为VIP房间,非VIP用户无法进入
ROOM_TYPE_VIDEO         = 0x0100        --//房间为视频房间。
ROOM_TYPE_TEST          = 0x0200        --//房间为测试房间,所有输赢属性均不计算
ROOM_TYPE_GAMING_JOIN   = 0x0400        --//!<房间类型为游戏开始后仍可进入类型
ROOM_TYPE_UPGRADE       = 0x0800        --//!<闯关场
ROOM_TYPE_DESKPK        = 0x1000        --//!<单桌比赛
ROOM_TYPE_GIFTMONEY     = 0x2000        --//!<送豆场
ROOM_TYPE_UPGRADE2      = 0x4000        --//!<闯关场（分场闯关)

--//房间等级类型,共4种,位数22-24位
ROOM_TYPE_LEVEL_MASK = 0x00C00000       --//!<房间类型掩码

ROOM_TYPE_LEVEL_0   = 0         --//新手房间
ROOM_TYPE_LEVEL_1   = 1         --//初级房间
ROOM_TYPE_LEVEL_2   = 2         --//中级房间
ROOM_TYPE_LEVEL_3   = 3         --//高级房间

--//落座模式,共15种,位数24-28位
ROOM_TYPE_SIT_MODE_MASK = 0x0F000000    --//落座模式掩码（共16种）

ROOM_TYPE_FREE_MODE = 0x0000000         --//自由落座模式
ROOM_TYPE_ALLOCSIT  = 0x1000000         --//房间内玩家座位由系统分配,无法自己选择座位
ROOM_TYPE_ALLOCSIT2 = 0x2000000         --//系统分桌模式,随机分配位置
ROOM_TYPE_TEAM      = 0x3000000         --//组队模式房间.
ROOM_TYPE_FRIEND_TEAM=0x4000000         --//朋友场模式房间.

ROOM_TYPE_PK_MODE1  = 0x8000000         --//比赛模式1
ROOM_TYPE_PK_MODE2  = 0x9000000         --//比赛模式2
ROOM_TYPE_PK_MODE3  = 0xa000000         --//比赛模式3

--//开发者自定义,取值范围0~15（或四种组合),位数28-32位
ROOM_TYPE_CUSTOM_MASK = 0xF0000000      --//自定义类型掩码
ROOM_TYPE_CUSTOM1   = 0x10000000        --//给与游戏开发者4种自定义房间类型
ROOM_TYPE_CUSTOM2   = 0x20000000
ROOM_TYPE_CUSTOM3   = 0x40000000
ROOM_TYPE_CUSTOM4   = 0x80000000

PROP_ID_PACKAGE=0  --道具包
PROP_ID_HONOR =-1   ---- 荣誉分
--道具
PROP_ID_SPEAKER     =1          --//!<小喇叭
PROP_ID_PK_TICKET   =2          --      //!<参赛券
PROP_ID_SPREAD_PRESENT=3        --      //!<推广礼盒
PROP_ID_LOTTERY_CARD=4          --//!<抽奖卡
PROP_ID_ACTIVE_CARD=5           --//!<激活卡
PROP_ID_FLEE_CLEAR=6            --  //!<逃跑率清零
PROP_ID_7 = 7               --//!<拖鞋
PROP_ID_8 = 8               --      //!<鸡蛋
PROP_ID_9 = 9               --      //!<发泄
PROP_ID_10 =10              --      //!<玫瑰
PROP_ID_11 =11              --  //!<吻
PROP_ID_12 =12              --  //!<纸巾
PROP_ID_13 = 13             --          //!<表情
PROP_ID_BANK=14             --          //!<别墅

PROP_ID_MONEY =15           --      //!<游戏币
PROP_ID_LOTTERY=16          --      //!<元宝
PROP_ID_XZMONEY=17          --  //!<吉祥币
PROP_ID_RMB=18              --//!<人民币
PROP_ID_VIP=19              --  //!<VIP

PROP_ID_CARD1=20            --          //!<卡片套装1
PROP_ID_CARD2=21            --
PROP_ID_CARD3=22
PROP_ID_CARD4=23
PROP_ID_CARD5=24
PROP_ID_CARD6=25
PROP_ID_CARD7=26
PROP_ID_CARD8=27
PROP_ID_CARD9=28

PROP_ID_10010_PHONE_ZHOU = 245 --       //联通4G手机一部（周赛）
PROP_ID_10010_PHONE_JUE = 246 --        //联通4G手机一部（决赛）
PROP_ID_HUA_FEI_100 = 247 --            //100元话费
PROP_ID_HUA_FEI_50 = 248 --             //50元话费
PROP_ID_HUA_FEI_20 = 249 --             //20元话费

PROP_ID_PHONE_CARD = 251 --             //!< 话费卡

PROP_ID_TYPE_WITH_TIME=256 --           //!<后续道具跟时间相关
PROP_ID_WEEK_PK_CARD = 256 --           //!<周赛参赛券
PROP_ID_MONTH_PK_CARD = 257 --          //!<月赛参赛券

PROP_ID_ROOM_CARD = 258                 -- 开房卡
PROP_ID_261 = 261                       -- 普通红包
PROP_ID_262 = 262                       -- 即时红包
PROP_ID_263 = 263                       -- 即时话费
PROP_ID_264 = 264                       -- 朋友礼券



--魔法道具 --begin
PROP_ID_267 = 267                       -- 道具

PROP_ID_LIAN_PEN = 272                  -- 脸盆
PROP_ID_CHUI_ZI = 273                   -- 锤子
PROP_ID_FAN_QIE = 274                   -- 番茄
PROP_ID_PEN_QI = 275                    -- 喷漆
PROP_ID_QIANG = 276                     -- 枪

PROP_ID_MAO_BI = 277                    -- 毛笔
PROP_ID_HONG_BAO = 278                  -- 红包
PROP_ID_ZUI_CHUN = 279                  -- 嘴唇
PROP_ID_XO = 280                        -- 人头马
PROP_ID_KOU_XIANG_TANG = 281            -- 匹萨
--魔法道具 --end

-- 道具名称
PROPNAME = {}
PROPNAME[PROP_ID_XZMONEY] ="钻石"
PROPNAME[PROP_ID_MONEY] ="开心豆"
PROPNAME[PROP_ID_VIP] ="VIP"
PROPNAME[PROP_ID_ROOM_CARD] ="房间卡"

PROPNAME[PROP_ID_LOTTERY] = "礼品券"  -- 2018.03.13 元宝 改为 礼品券
PROPNAME[PROP_ID_PK_TICKET] = "参赛券"
PROPNAME[PROP_ID_WEEK_PK_CARD] ="周赛券"
PROPNAME[PROP_ID_MONTH_PK_CARD] = "月赛券"
PROPNAME[PROP_ID_LOTTERY_CARD] = "抽奖卡"
PROPNAME[PROP_ID_SPEAKER] ="小喇叭"
PROPNAME[PROP_ID_PHONE_CARD] ="话费券"
PROPNAME[PROP_ID_261] ="红包券"
PROPNAME[PROP_ID_262] ="即时红包"
PROPNAME[PROP_ID_263] ="即时话费卡"

--魔法道具 --begin
PROPNAME[PROP_ID_LIAN_PEN] = "脸盆"                   -- 脸盆
PROPNAME[PROP_ID_CHUI_ZI] = "锤子"                    -- 锤子
PROPNAME[PROP_ID_FAN_QIE] = "番茄"                    -- 番茄
PROPNAME[PROP_ID_QIANG] = "枪"                        -- 枪
PROPNAME[PROP_ID_KOU_XIANG_TANG] = "匹萨"             -- 匹萨

PROPNAME[PROP_ID_MAO_BI] = "毛笔"                     -- 毛笔
PROPNAME[PROP_ID_PEN_QI] = "喷漆"                     -- 喷漆
PROPNAME[PROP_ID_ZUI_CHUN] = "嘴唇"                   -- 嘴唇
PROPNAME[PROP_ID_XO] = "人头马"                       -- xo
PROPNAME[PROP_ID_HONG_BAO] = "红包"                   -- 红包
--魔法道具 --end

---[[
USER_FROM_UNKOWN        =0 --//!<未知来源
USER_FROM_UNLOGIN       =1 --//!<游客身份
USER_FROM_PLATFORM      =2 --//!<帐号来自当前平台
USER_FROM_TENCENT       =3 --//!<帐号来自腾讯
USER_FROM_WEIBO         =4 --//!<帐号来自新浪微博
USER_FROM_JIXIANG       =7 --//!<帐号来自吉祥
USER_FROM_YSDK_QQ       = 8 --//!<帐号来自应用宝QQ
USER_FROM_YSDK_WX       = 9 --//!<帐号来自应用宝微信
USER_FROM_QIHOO         = 10 --//!<账号来自奇虎360
USER_FROM_OPPO          = 11 --//!<账号来自 OPPO
USER_FROM_HUAWEI        = 12 --//!<账号来自华为
USER_FROM_XIAOMI        = 13 --//!<账号来自小米

if not IS_WEILE then
    USER_FROM_WECHAT    =35 --//!吉祥 心悦微信账号平台
else
    USER_FROM_WECHAT    =36 --//!微乐微信账号平台
end
USER_FROM_WECHAT_JIXIANG =35 --//!吉祥 心悦微信账号平台
USER_FROM_WECHAT_WEILE   =36 --//!微乐微信账号平台
--]]

LOGIN_TYPE_NONE         =0 --//!<无任何操作
LOGIN_TYPE_BY_NAME      =1 --//!<根据用户名登陆
LOGIN_TYPE_BY_UNNAME    =2 --//!<匿名登陆
LOGIN_TYPE_GET_ROLE_LIST=3 --//!<拉取用户列表
LOGIN_TYPE_ALLOC_USER   =4 --//!<分配新帐号


MISSION_DAILY_GIFT_MONEY = 1  --任务ID,每人赠送豆

--比赛阶段信息
PK_GROUP_STATE_WAITING  =0  --//等待状态(时间没到)
PK_GROUP_STATE_JOIN     =1      --//加入状态
PK_GROUP_STATE_STEP     =2  --//比赛状态阶段1,大于2的阶段都为比赛状态
--//PK_GROUP_STATE_STEP2,       //阶段2
--//PK_GROUP_STATE_STEP3,       //阶段3
--//PK_GROUP_STATE_FREE,        //空闲状态

INVALID_DESK  = 0xFFff      --无效桌子号
INVALID_CHAIR = 0xFFff      --无效椅子号
POST          =true  --post方式请求
GET           =false --get方式请求
--日常数据
DailyData={
    PALY_COUNT_ROOM_LEVEL0=12, --//新手场玩的局数
    PALY_COUNT_ROOM_LEVLE1=13, --//初级房间玩的局数
    PALY_COUNT_ROOM_LEVEL2=14, --//中级房间玩的局数
    WIN_COUNT_TOTAL=16,        --赢次数统计 16
    CREATE_FRIEND_ROOM_NUM=19, --朋友场创建局数 19
    WIN_ROOM_LEVEL_3=20,       --土豪 至尊 房间 赢20
    WIN_ROOM_LEVEL_2=21,       --精英房间 赢21
    DAILY_EXT_22=22,           -- 任意游戏领取每日奖励
    DAILY_EXT_23=23,           --
}

--成就数据
EffortData={
    TOTAL_GAME_COUNT=2,    -- 游戏总局数
    WIN_ANY_GAME=12,       -- 赢的总局数12
    BOX_ROOM_LEVEL_0=15,   -- 成就数据 开启木宝箱个数15
    BOX_ROOM_LEVEL_1=16,   -- 成就数据 开启铜宝箱个数16
    BOX_ROOM_LEVEL_2=17,   -- 成就数据 开启银宝箱个数17
    BOX_ROOM_LEVEL_3=18,   ---成就数据 开启金宝箱个数18
    BOX_SCORE_TOTAL=19,    -- 成就数据 宝箱分数统计19
}

MSG_HEADER_FLAG_NONE        = 0     -- //!<发送数据不做任何处理
MSG_HEADER_FLAG_PACKET      = 0x1   -- //!<当前为包文件（一个或者多个连续包），每个包都有个包标记@brief msg_Packet 当所有包首发完毕才能处理
MSG_HEADER_FLAG_MASK        = 0x2   -- //!<检查掩码,@ref   msg_Header::byMask 将当前包的校验码，当前包也会重组数据
MSG_HEADER_FLAG_ENCODE      = 0x4   -- //!<重新编码,使用映射表重新编码数据
MSG_HEADER_FLAG_COMPRESS    = 0x8   -- //!<压缩数据,数据将启用zlib压缩，该标记仅推荐，如果数据压缩后更大，将忽略该标记
MSG_HEADER_FLAG_ROUTE       = 0x10  -- //!<路由包,服务器每次中转，@ref    msg_Header::byRouteCount 的值累加1，当到达特定值后，仍然没有到达目标服务器，该包将丢弃
MSG_HEADER_FLAG_DELAYSEND   = 0x20  -- //!<延迟消息，等待下次非延迟消息合并发送（客户端忽略该标记）
MSG_HEADER_FLAG_FILLED      = 0x40  -- //!<已经填充头部（已经进行掩码、编码、压缩处理)，不能重复处理
MSG_HEADER_FLAG_OFFSET      = 0x80  -- //!<指定消息头偏移，掩码、编码、压缩处理将从消息头开始偏移@ref msg_Header::byHeaderOffset 个字节开始

BATTERY_STATE_MASK = 0xFFff0000        --电池电量  0-100
BATTERY_LEVEL_MASK = 0x0000FFff        --电池状态 0 未知状态 1 非充电状态 2 充电状态 3 充电器连接 充满电状态

__LAYOUT_COMPONENT_NAME="__ui_layout"

PLATFORM_CHANNEL_OFFICIAL=1 --官方自自运营
PLATFORM_CHANNEL_QH360   =2 --360渠道
PLATFORM_CHANNEL_BAIDU   =3 --百度
PLATFORM_CHANNEL_OPPO    =4 --oppo

NET_ERR_TAG_LOGIN  ="login"
NET_ERR_TAG_HALL   ="hall"
NET_ERR_TAG_SWITCH ="switch"
NET_ERR_TAG_TIMEOUT="timeout"

--电池状态 0 未知状态 1 非充电状态 2 充电状态 3 充电器连接 充满电状态
BatteryState={
    Unknown=0,
    Unplugged=1,
    Charging=2,
    Full=3
}
CONNECT_TIMEOUT=15

NetworkStatus={
    None = 0, --断网
    WiFi = 1, --wifi
    WWAN = 2  --mobile
}
NETWORK_STATE={
    [NetworkStatus.None]="网络中断,正在连接重新连接...",
    [NetworkStatus.WiFi]="您已切换至 WIFI 网络",
    [NetworkStatus.WWAN]="您已切换至 移动网络",
}

USER_TYPE={
    ROBOT=0,    --!<机器人
    NORMAL=1,   --/!<普通用户
    VIP=2,       --<会员
    GM = 250,-- //!<2B的管理员
    SUPER_GM=251,-- //!<超级管理员
}

SYSTEM_MESSAGE_TYPE={
    PRINT_MSG_TYPE_NONE     = 0,	 -- //!<不附带任何内容，纯文本

    PRINT_MSG_TYPE_P2P      = 0x1,	 -- //!<玩家跟玩家
    PRINT_MSG_TYPE_SYS      = 0x2,	 -- //!<系统消息
    PRINT_MSG_TYPE_FACTION2P= 0x4,	 -- //!<门派内部聊天
    PRINT_MSG_TYPE_FACTION  = 0x8,	 -- //!<门派系统消息
    PRINT_MSG_TYPE_GM2P     = 0x10,	 -- //!<GM跟玩家

    PRINT_MSG_TYPE_SPEAKER  = 0x20,	 -- //!<小喇叭
    PRINT_MSG_TYPE_ROSE     = 0x40,	 -- //!<玫瑰花
    PRINT_MSG_TYPE_PROP     = 0x80,	 -- //!<道具
    PRINT_MSG_TYPE_HALL     = 0x100, -- //!<大厅消息
    PRINT_MSG_TYPE_CMD      = 0x200, -- //!<消息为命令
    PRINT_MSG_TYPE_GIFT     = 0x400, -- //!<奖励（喜报）
    PRINT_MSG_TYPE_SAVE2DB  = 0x80000000,	 -- //!<是否保存（保存到数据库)
}

--0--游客未激活
-- 1
-- 已激活
-- 2
-- 已绑定手机
-- 4
-- 已绑定微信
UserStatus={
    Inactive=0,
    Activited=1,
    BindPhone=2,
    BindWechat=4,
    BindIdcard=8,
}
-- 对齐方式
Alignment={
    BOTTOM=0, --下
    TOP=1, --上
    CENTER=0.5, --中
    LEFT=0, --左
    RIGHT=1 --右
}
-- 返回状态码
API_ERR_CODE=
{
    Ok = 0,
    ShowToast = 99,
    ShowMsg = 100,
    Success = 200,
    WXAuthFailed=351
}
--错误消息
API_ERR_MSG = {
    [-1] = "网络错误,请重试",
    [0] = "成功",
    [99] = "错误提示, 当状态为此值时请将错误信息以吐司方式显示给用户",
    [100] = "错误提示, 当状态为此值时请将错误信息以对话框方式显示给用户",
    [101] = "请求接口时必须使用https协议访问",
    [111] = "接口版本参数错误",
    [112] = "接口语言参数错误",
    [113] = "接口品牌参数错误",
    [119] = "缺少参数,具体缺少哪个参数请在msg中查看",
    [120] = "参数错误,具体哪个参数错误请在msg中查看",
    [121] = "请求的app_id参数错误",
    [122] = "请求的channel_id参数错误",
    [123] = "应用配置不存在",
    [124] = "用户API请求中的data参解密错误",
    [131] = "用户API请求中的token参数为空",
    [132] = "用户API请求中的token无效",
    [301] = "短信验证码发送太快(即:两次的间隔时间太短)",
    [302] = "单位时间内发送的短信验证码数量超限",
    [303] = "手机号码处于黑名单中,无法获取短信验证码",
    [351] = "微信授权过期",
    [500] = "服务器内部错误"
}

-- 新增常量必须采用这样的方式，否则热更会报错
local newConstants = {
    ["TIRE_TIME_LIMIT_1"] = 10800,               -- 在线时长限制1 ： 3小时
    ["TIRE_TIME_LIMIT_2"] = 18000,               -- 在线时长限制2 ： 5小时
    ["PROP_ID_JIPAI"] = 401,                     -- 记牌器
    ["PROP_ID_HAIDILAOYUE"] = 402,               -- 海底捞月卡
    ["PROP_ID_GAIMING"] = 403,                   -- 改名卡
    ["PROP_ID_CANSAI"] = 404,                    -- 参赛券
    ["PROP_ID_LEITAIKA"] = 405,                  -- 荣誉卡
    ["PROP_ID_FANBEIKA"] = 406,                  -- 翻倍卡
    ["PROP_ID_TV_TICKETS"] = 407,                -- 录制资格券
    ["USER_FROM_TOUTIAO"] = 14,                  -- 今日头条渠道用户
    ["USER_FROM_VIVO"] = 15,                     -- VIVO渠道用户
    ["USER_FROM_SAMSUNG"] = 16,                  -- 三星渠道用户
    ["USER_FROM_MEIZU"] = 17,                    -- 魅族渠道用户

    -- 系统字体名称
    ["SYSTEM_FONT_NAME"] = "Helvetica",

    ["ROOM_TYPE_PK_MODE4"]  = 0xb000000         --//比赛模式4
}
local function _createNewConstants( )
    for k, v in pairs(newConstants) do
        if cc.exports then
            cc.exports[k] = v
        else
            _G[k]=v
        end
    end
end
_createNewConstants()
