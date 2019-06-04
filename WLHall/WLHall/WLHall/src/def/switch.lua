--gameid  显示指定游戏跳转  用于单款游戏包


--模块标识  room ,game  需附带id 标识
local MTAG =
{

    AddGame             = "tag_addgame",                                       -- 添加游戏
    Update              = "tag_update",                                        --更新界面
    Login               = "tag_login",                                         --登录界面
    Hall                = "tag_hall",                                          --大厅界面
    Room                = "tag_room",                                          --房间界面
    Game                = "tag_game",                                          --游戏界面
    Notice              = "tag_notice",                                        -- 公告
    Honor               = "tag_honor",                                         -- 荣誉系统
    Exchange            = "tag_exchange",                                      -- 兑换
    ScoreRecord         = "tag_record",                                        --App战绩界面
    FriendJoinRoom      = "tag_friend_joinroom",                               --加入朋友场
    FriendRule          = "tag_friendrule",                                    --朋友场规则
    FeedBack            = "tag_feedback",                                      --意见反馈
    CustomerService     = "tag_customer_service",                              -- 客服
    VIP                 = "tag_vip",                                           -- vip
    Privilege           = "tag_privilege",                                     -- 特权
    IOSOffline          = "tag_ios_offline",                                   -- iOS 下架包

    -- 个人资料
    PersonInfo          = "tag_person",                                        -- 个人资料主页
    P_ACTIVATE          = "tag_persion_activate",                              -- 激活
    P_BIND              = "tag_persion_bind",                                  -- 绑定
    P_REALNAME          = "tag_persion_realname",                              -- 实名认证

    -- 商城
    S_PROP              = "tag_store_prop",                                    -- 道具
    Store               = "tag_store",                                         -- 商城
    -- 道具
    [PROP_ID_LOTTERY]   = "PROP_ID_LOTTERY",                                   -- 元宝
    [PROP_ID_PHONE_CARD]= "PROP_ID_PHONE_CARD",                                -- 话费卡
    [PROP_ID_261]       = "PROP_ID_261",                                       -- 红包卡
    [PROP_ID_ROOM_CARD] = "PROP_ID_ROOM_CARD",                                 -- 房卡
    [PROP_ID_FANBEIKA]  = "PROP_ID_FANBEIKA",                                  -- 翻倍卡

    -- 背包
    Bag                 = "bag",                                               -- 背包

    -- 消息
    SysMessage          = "SysMessage",                                        -- 系统消息
    -- 微信分享
    WeixinShare         = "WeixinShare",
    -- 抢红包比赛
    DDZHMatch           = "DDZHMatch",
    -- 荣誉礼包开关
    HonorGift        = "HonorGift",
    -- 朋友场
    FriendRooms         = "FriendRooms",
    -- 游客登录
    GuestLogin          = "GuestLogin",
    -- 微信登录
    WeixinLogin         = "WeixinLogin",

    -- 暂未实现功能
    Unimplemented       = "Unimplemented",

    --代开房间
    DaiKaiRoom          = "DaiKaiRoom",

    -- 信用好友
    CreditUser          = "CreditUser",

    --海底捞月道具开关
    HaiDiLaoYue        = "HaiDiLaoYue",

    --关闭注册
    CloseRregister      = "CloseRregister",

    --小刺激
    Hot                =  "Hot",

    -- 关闭背包整存整取
    CloseLumpSum        = "CloseLumpSum",

    -- 开启视频功能
    Video               = "Video",

    -- 星耀月卡
    XYMonthCard         = "XYMonthCard",

    -- 钻石
    Diamond             = "Diamond",

    --抽奖
    Lottery             = "Lottery",

    --活动
    Activity            = "Activity",

    --游客可支付
    VisitorPay          = "VisitorPay",

    -- 声明
    Declaration         = "Declaration",

    -- 免费福利
    FreeWelfare         = "FreeWelfare",

    --擂台赛
    Arena               = "Arena",

    -- 防沉迷系统
    CheckTireTime       = "CheckTireTime",

    -- 友趣分享
    YouQuShare          = "YouQuShare",

    -- 关注有礼
    Attention           = "Attention",

    -- 评价有礼
    Evaluate            = "Evaluate",

    -- JS小程序分享奖励开关
    -- ShareAward          = "ShareAward",

    -- JS小程序麻将包带扑克开关
    -- Poker               = "Poker",
}
--模块  modulelocation 模块的位置 《1代表模块在1的这张表里》 moduledata 模块的数据

local MTABLE =
{
    [MTAG.AddGame]=
    {
        modulelocation = 1,
        moduledata = bit.lshift(1, 0),
    },
    [MTAG.Honor]=
    {
        modulelocation = 1,
        moduledata = bit.lshift(1, 1),
    },
    [MTAG.PersonInfo]=
    {
        modulelocation = 1,
        moduledata = bit.lshift(1, 2),
    },
    [MTAG.Notice]=
    {
        modulelocation = 1,
        moduledata = bit.lshift(1, 3),
    },
    [MTAG.Privilege]=
    {
        modulelocation = 1,
        moduledata =  bit.lshift(1, 4),
    },
    [MTAG.Exchange]=
    {
        modulelocation = 1,
        moduledata = bit.lshift(1, 5),
    },
    [MTAG.CustomerService]=
    {
        modulelocation = 1,
        moduledata = bit.lshift(1, 6),
    },
    [MTAG[PROP_ID_LOTTERY]]=
    {
        modulelocation = 1,
        moduledata = bit.lshift(1, 7),
    },
    [MTAG[PROP_ID_PHONE_CARD]]=
    {
        modulelocation = 1,
        moduledata = bit.lshift(1, 8),
    },
    [MTAG[PROP_ID_261]]=
    {
        modulelocation = 1,
        moduledata = bit.lshift(1, 9),
    },
    [MTAG[PROP_ID_ROOM_CARD]]=
    {
        modulelocation = 1,
        moduledata = bit.lshift(1, 10),
    },
    [MTAG.VIP]=
    {
        modulelocation = 1,
        moduledata = bit.lshift(1, 11),
    },
    [MTAG.P_ACTIVATE]=
    {
        modulelocation = 1,
        moduledata = bit.lshift(1, 12),
    },
    [MTAG.P_REALNAME]=
    {
        modulelocation = 1,
        moduledata = bit.lshift(1, 13),
    },
    [MTAG.Bag] =
    {
        modulelocation = 1,
        moduledata = bit.lshift(1, 14),
    },
    [MTAG.Store] =
    {
        modulelocation = 1,
        moduledata = bit.lshift(1, 15),
    },
    [MTAG.Arena]=
    {
        modulelocation = 1,
        moduledata = bit.lshift(1, 16),
    },
    [MTAG.S_PROP]=
    {
        modulelocation = 1,
        moduledata = bit.lshift(1, 17),
    },
    [MTAG.Room]=
    {
        modulelocation = 1,
        moduledata = bit.lshift(1, 18),
    },
    [MTAG.SysMessage] =
    {
        modulelocation = 1,
        moduledata = bit.lshift(1, 19),
    },
    [MTAG.WeixinShare] =
    {
        modulelocation = 1,
        moduledata = bit.lshift(1, 20),
    },
    [MTAG.IOSOffline] =
    {
        modulelocation = 1,
        moduledata = bit.lshift(1, 21),
    },
    [MTAG.DDZHMatch] =
    {
        modulelocation = 1,
        moduledata = bit.lshift(1, 22),
    },
    [MTAG.HonorGift] =
    {
        modulelocation = 1,
        moduledata = bit.lshift(1, 23),
    },
    [MTAG.FriendRooms] =
    {
        modulelocation = 1,
        moduledata = bit.lshift(1, 24),
    },
    [MTAG.GuestLogin] =
    {
        modulelocation = 1,
        moduledata = bit.lshift(1, 25),
    },
    [MTAG.WeixinLogin] =
    {
        modulelocation = 1,
        moduledata = bit.lshift(1, 26),
    },
    [MTAG.Unimplemented] =
    {
        modulelocation = 1,
        moduledata = bit.lshift(1, 27),
    },
    [MTAG.DaiKaiRoom] =
    {
        modulelocation = 1,
        moduledata = bit.lshift(1, 28),
    },
    [MTAG.CreditUser] =
    {
        modulelocation = 1,
        moduledata = bit.lshift(1, 29),
    },
    [MTAG.HaiDiLaoYue] =
    {
        modulelocation = 1,
        moduledata = bit.lshift(1, 30),
    },
    [MTAG.CloseRregister] =
    {
        modulelocation = 1,
        moduledata = 2147483648, -- bit.lshift(1, 31) 会变为负数，然后调用 C++ 接口进行位操作会有问题
    },
    [MTAG.Hot] =
    {
        modulelocation = 2,
        moduledata = bit.lshift(1, 0),
    },
    [MTAG.CloseLumpSum] = {
        modulelocation = 2,
        moduledata = bit.lshift(1, 1),
    },
    [MTAG.Video] = {
        modulelocation = 2,
        moduledata = bit.lshift(1, 2),
    },

    [MTAG.XYMonthCard] = {
        modulelocation = 2,
        moduledata = bit.lshift(1, 3),
    },

    [MTAG.Diamond] = {
        modulelocation = 2,
        moduledata = bit.lshift(1, 4),
    },

    [MTAG.Lottery] = {
        modulelocation = 2,
        moduledata = bit.lshift(1, 5),
    },

    [MTAG.Activity] = {
        modulelocation = 2,
        moduledata = bit.lshift(1, 6),
    },

    [MTAG.VisitorPay] = {
        modulelocation = 2,
        moduledata = bit.lshift(1, 7),
    },
    [MTAG.FreeWelfare] = {
        modulelocation = 2,
        moduledata = bit.lshift(1, 8),
    },

    [MTAG.CheckTireTime] = {
        modulelocation = 2,
        moduledata = bit.lshift(1, 9),
    },

    [MTAG.YouQuShare] = {
        modulelocation = 2,
        moduledata = bit.lshift(1, 10),
    },

    [MTAG[PROP_ID_FANBEIKA]]=
    {
        modulelocation = 2,
        moduledata = bit.lshift(1, 11),
    },

    [MTAG.Attention] = {
        modulelocation = 2,
        moduledata = bit.lshift(1, 12),
    },

    [MTAG.Evaluate] = {
        modulelocation = 2,
        moduledata = bit.lshift(1, 13),
    },

    -- JS小程序分享奖励开关
    -- [MTAG.ShareAward] = {
    --     modulelocation = 2,
    --     moduledata = bit.lshift(1, 14),
    -- },
    
    -- JS小程序麻将包带扑克开关
    -- [MTAG.Poker] = {
    --     modulelocation = 2,
    --     moduledata = bit.lshift(1, 15),
    -- },
}

cc.exports.ModuleTag=MTAG
cc.exports.MODULE_SWITCH_TABLE=MTABLE
