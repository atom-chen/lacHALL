--
-- Author: lee
-- Date: 2016-09-10 16:42:06
--
--0--游客未激活
-- 1-- 已激活
-- 2-- 已绑定手机
-- 4-- 已绑定微信
local ATTR_INACTIVE   =0
local ATTR_ACTIVITED  =1
local ATTR_BINDPHONE  =2
local ATTR_BINDWECHAT =4
local ATTR_BINDIDCARD =8


local UserData = {}
local localCfgFile = require("common.FileTable").New();
local writablePath = cc.FileUtils:getInstance():getWritablePath()

-- 本地配置路径变量
local localConfigPath
local localCfgObj={}
local md5userid
local userWebData ={}
local isloaded_=false
local loadedCallbacks = {}
--存储到文件
local function flush_()
    localCfgFile:Save(localCfgObj, localConfigPath)
end
local function setUserCache_(key,value)
    if key then
        localCfgObj[key]=value
        flush_()
    end
end

-- 账号属性,二进制存储,各值含义如下：
-- 1-- 已激活
-- 2-- 已绑定手机
-- 4-- 已绑定微信
-- 8-- 已绑定身份证
-- notice (int)-- 未拉取的公告数量
-- usermsg (int)-- 未拉取的个人消息数量
-- popn (int)-- 强制弹出的公告ID
-- popm (int)-- 强制弹出的个人消息ID
-- popa (int)-- 强制弹出的活动ID
-- idcard (string)-- 身份证尾号后4位,仅在绑定身份证时返回
-- phone (string)-- 手机尾号后4位,仅在绑定手机时返回
-- icon (string)-- 分享图标
-- url (string)-- URL地址
-- taskver (int)-- 任务配置版本号

-- 拉取计费点配置
local function loadGoodsCfg_( goods )
    if not goods then
        return
    end

    -- 将剩余次数的数据记录下来
    gg.PopupGoodsData:mergeLeftTimesInfo(checktable(goods))

    -- 检查本地配置版本是否与服务器版本一致
    local serverVer = checkint(goods.version)
    local localVer = gg.PopupGoodsData:getPopupGoodsVer()
    if serverVer > 0 and serverVer ~= localVer then
        -- 需要拉取新的计费点配置数据
        gg.PopupGoodsData:pullData(goods)
    end
end

-- 初始化活动信息
local function initActiveData( data )
    if not data then
        return
    end
    gg.ActivityPageData:initActiveData(data)
end

local function onuserinit_(data)

    userWebData.status=0x80000000

    if data.status==0 then
        table.merge(userWebData,data)

        -- 去除本地缓存是否代理的逻辑
        -- setUserCache_("agent",checkint(userWebData.rcapc))

        -- 拉取计费点配置
        if userWebData.goods then
            loadGoodsCfg_(userWebData.goods)
        end

        -- 活动开关
        if userWebData.activeswitch then
            initActiveData(userWebData.activeswitch)
        end

        -- Web接口初始化成功
        GameApp:dispatchEvent(gg.Event.HALL_WEB_INIT)
        isloaded_=true
        if loadedCallbacks and #loadedCallbacks > 0 then
            for i, v in ipairs(loadedCallbacks) do
                if v then
                    v()
                end
            end
            loadedCallbacks = {}
        end
    else
        if DEBUG>0 then
             print("Web接口初始化失败！")
        end
    end
end

local function lazyInit_()
    userWebData.status=checkint(userWebData.status)
    if userWebData.status>1 then
        userWebData.status=1
        gg.Dapi:NewUserInit(onuserinit_)
    elseif userWebData.status==1 then
     --todo 拉取数据中。。
        printf("拉取数据中。。。")
    end
end

function UserData:clear()
    userWebData ={}
    localCfgObj={}
    md5userid=nil
    isloaded_=false
end

function UserData:initWithUserId(userid)
    userWebData.id=userid
    local md5id=Helper.Md5(userid)
    if md5userid ~= md5id then
        md5userid=md5id
        localConfigPath = writablePath ..tostring(md5userid)..".dat"
        printf("userdata path "..localConfigPath)
        localCfgObj=localCfgFile:Open(localConfigPath)
    end
end

function UserData:initWebData()
    userWebData.status=0x80000000
    isloaded_=false
    lazyInit_()
end

function UserData:checkLoaded(callback)
    if isloaded_ then
        callback()
        return true
    else
        lazyInit_()
        table.insert(loadedCallbacks, callback)
        return false
    end
end

--更新web 数据
function UserData:UpdateWebDate(key,value)
    lazyInit_()
    if key then
       userWebData[key]=value
    end
end

-- 获取 web 数据
function UserData:GetWebData(key)
    return userWebData[key]
end

--获取当前用户id
function UserData:GetUserId()
    lazyInit_()
    return checkint(userWebData.id)
end

-- 判断活动是否开启
function UserData:ActivityIsOpen()
    local switchTb = self:GetUserActiveSwitch()
    if not switchTb then return false end
    for _,v in pairs(checktable(switchTb)) do
        if checkint(v.status) == 1 then
            return true
        end
    end
    return false
end

-- 判断限时特惠活动是否开启
function UserData:SpecialGiftIsOpen()
    -- 活动开关关闭时关闭
    if not GameApp:CheckModuleEnable(ModuleTag.Activity) then return false end

    local switchTb = self:GetUserActiveSwitch()
    if not switchTb then return false end
    for _,v in pairs(checktable(switchTb)) do
        if v.active_tag == gg.ActivityPageData.ACTIVE_TAG_TJLB and checkint(v.status) == 1 then
            return true
        end
    end
    return false
end

-- 检查广告页数据
function UserData:CheckAds()
    -- 在游戏场景或者H5游戏中不弹出广告页
    local curScene = GameApp:getRunningScene()
    if not curScene.name_ == "HallScene" or gg.WebGameCtrl:isInWebGame() then
        return
    end

    if IS_REVIEW_MODE or not userWebData.ads then
        -- 审核模式或者没有数据直接返回
        return
    end

    -- 传入图片为空字段时不弹广告页数据
    if table.nums(userWebData.ads) == 0 then
        return
    end

    -- 检查上次推送时间
    local lastPopTs = self:getConfigByKey("adsPopTime")
    if lastPopTs then
        local dateStr = os.date("%Y%m%d", lastPopTs)
        local curDateStr = os.date("%Y%m%d")
        if dateStr == curDateStr then
            -- 今天推送过了，不再推送
            return
        end
    end

    -- 记录弹出时间
    self:SetConfigKV({["adsPopTime"] = os.time()})

    -- 显示广告页界面
    GameApp:dispatchEvent(gg.Event.SHOW_VIEW, "AdView", {push = true, popup = true}, userWebData.ads)
end

-- 检查是否有推送的公告或者个人消息
function UserData:CheckPushMsg()
    -- 检查个人消息
    local data = userWebData
    if checkint(data.usermsg )>0 then
        require("hall.models.MymsgData"):pullData(function()
            if data.popm then
                GameApp:dispatchEvent("event_on_show_push_msg",{ type=2, id=checkint(data.popm),new=checkint(data.usermsg)})
            end
        end)
    elseif data.popm then
        GameApp:dispatchEvent("event_on_show_push_msg",{ type=2, id=checkint(data.popm),new=0})
    end

    -- 检查公告
    if checkint(data.notice)>0 then
        require("hall.models.AnnounceData"):pullData(function()
            if data.popn then
                GameApp:dispatchEvent("event_on_show_push_msg",{ type=1, id=checkint(data.popn),new=checkint(data.notice)})
            end
        end)
    elseif data.popn then
        GameApp:dispatchEvent("event_on_show_push_msg",{ type=1, id=checkint(data.popn),new=0})
    end
end

--获取当前用户任务版本号
function UserData:GetTaskVersion()
    lazyInit_()
   return checkint(userWebData.taskver )
end

-- 获取购买过的vip特权产品
function UserData:GetAlreadyBuyVipTable()

    lazyInit_()
    local vipT = {}
    local vrr = data.vrr
    if vrr then
        for k , v in pairs( checktable( data.vrr ) ) do
            local vip = checktable( string.split( v , "_" ) )[2]
            if vip then

                table.insert( vipT , vip )
            end
        end
    end

    return vipT
end

-- 判断该vip等级的商品是否购买过
-- lv vip等级
function UserData:IsBuyVipGoods( lv )

    lazyInit_()
    local vrr = userWebData.vrr
    if vrr then
        for k , v in pairs( checktable( vrr ) ) do
            local vip = checktable( string.split( k , "_" ) )[2]
            if vip then

                if vip == lv.."" then
                    return true
                end
            end
        end
    end

    return false
end

-- 新增购买的VIP特权商品
function UserData:SetAlreadyBuyVipTable( vipGoods )

    if not vipGoods then

        return
    end

    if userWebData.vrr then
         userWebData.vrr[ vipGoods ] = 1
    end
end

--获取任务表
-- id=1, --任务ID
--         val=1, --当前任务进度值(整形), 注意此参数不一定存在
--         status=1, --任务状态, 1:不可用, 2:可用未激活, 3:已激活未完成, 4:已完成未领取, 5:已领取
--         awards={ -- 常规奖励,当任务类型为5时且奖励配置为空才会存在, 示意请参考task/config接口说明,
--             [1]={
--                 {15, 1000}, -- 奖励道具配置, 下标[1]为道具ID,下标[2]是数量
--                 {16, 10},
--                 {-1, 100} -- 奖励道具配置, 下标[1]为-1时, 表示奖励的是荣誉值
--             }
--         },
--         vip={ -- VIP附加奖励,当任务类型为5时且奖励配置为空才会存在, 示意请参考task/config接口说明
--             [1]={
--                 {15, 1000},
--                 {16, 10}
--             },
--             [2]={
--                 {15, 2000},
--                 {16, 20}
--             },
--             [3]={
--                 {15, 4000},
--                 {16, 40}
--             }
--         }
function UserData:GetTaskTable()
    lazyInit_()
   return checktable(userWebData.task )
end

-- 获取任务的状态
function UserData:GetTaskStatusById( id )
    local task = self:GetTaskTable()
    for _,v in pairs(task) do
        if v and v.id == id then
            return v.status
        end
    end
end

-- 修改任务状态
function UserData:SetTaskStatusById( id, status )
    local task = self:GetTaskTable()
    for _,v in pairs(task) do
        if v and v.id == id then
            v.status = status
            GameApp:dispatchEvent( "event_update_task_state", id, status )
        end
    end
end

-- 修改任务进度
function UserData:SetTaskValById( id, val )
    local task = self:GetTaskTable()
    for _,v in pairs(task) do
        if v and v.id == id then
            v.val = val
        end
    end
end

-- 修改任务hlv
function UserData:SetTaskHlvById( id, hlv )
    local task = self:GetTaskTable()
    for _,v in pairs(task) do
        if v and v.id == id then
            v.hlv = hlv
        end
    end
end

-- 修改任务初始值ext
function UserData:SetTaskExtById( id, ext )
    local task = self:GetTaskTable()
    for _,v in pairs(task) do
        if v and v.id == id then
            v.ext = ext
        end
    end
end

-- 修改本地任务数据（不会缓存，下次登录还是同步服务器的数据）
function UserData:UpdateTaskInfo(id, t)
    local task = self:GetTaskTable()
    for _,v in pairs(task) do
        if v and v.id == id then
            table.merge(v, t)
        end
    end
end

-- 获取充值类礼包配置
-- {
--     daily={ --每日礼包
--         {
--             id=1, -- 礼包ID, 3元礼包
--             status=0, -- 状态: 0:本日未购买, 4:本日已购买
--         },
--         {
--             id=2, -- 礼包ID, 12元礼包
--             status=0,
--         },
--         {
--             id=3, -- 礼包ID, vip12元礼包
--             status=0,
--         }
--     },
--     loop={ --一本万利礼包
--         {
--             id=4, -- 礼包ID, 7日礼包
--             status=0, -- 状态: -1:已过期, 0:未购买, 1:已购买, 2:已购买本日未领取, 3:已购买本日已领取, 4:已购买并全部领完
--         },
--         {
--             id=5, -- 礼包ID, 15日礼包
--             status=0,
--         },
--         {
--             id=6, -- 礼包ID, vip15日礼包
--             status=0,
--         }
--     }
-- }
function UserData:GetPackTable()
    lazyInit_()
   return checktable(userWebData.pack )
end

--获取分享数据表分享配置 return
-- id (string)-- 微信分享ID
-- pic (string)-- 仅分享图片时的图片地址,当此值不存在或为空时,按照老版本的链接方式进行分享；否则则使用此参数中的地址进行图片分享
-- text (string)-- 分享内容
-- icon (string)-- 分享图标
-- url (string)-- URL地址
function UserData:GetShareDataTable(stype)
    lazyInit_()
    local shareTb = nil
    local other = checktable(userWebData.other)
    if stype == "honor" then
        shareTb = other.share_honor
    elseif stype == "lottery" then
        shareTb = other.share_lottery
    else
        shareTb = checktable(userWebData.share)
    end
    return shareTb or checktable(userWebData.share)
end

-- 获取所要使用的分享方式，0-使用sdk分享，1-使用系统分享
-- stype 获取相关界面的分享方式
function UserData:GetShareType(stype)
    lazyInit_()
    local shareType = nil
    local other = checktable(userWebData.other)

    if stype == "honor" then
        shareType = tonumber(checktable(other.share_honor).is_system_share)
    elseif stype == "lottery" then
        shareType = tonumber(checktable(other.share_lottery).is_system_share)
    else
        shareType = checkint(checktable(userWebData.share).is_system_share)
    end
    return shareType or checkint(checktable(userWebData.share).is_system_share)
end

--获取荣誉分享二维码
function UserData:GetShareQuickMark(stype)
    lazyInit_()
    local shareQuickMark = nil
    local other = checktable(userWebData.other)
    if stype == "honor" then
        shareQuickMark = checktable(other.share_honor).qrcode_url
    end
    return shareQuickMark

 end

function UserData:GetWXShareAppId()
    lazyInit_()
    return checktable(userWebData.other).wx_id or checktable(userWebData.share).id or WX_APP_ID_SHARE
end

-- 获取免房号的微信分享id
function UserData:GetInviteShareAppId()
    lazyInit_()
    return checktable(userWebData.join).wx_id or checktable(userWebData.share).id or WX_APP_ID_SHARE
end

function UserData:GetInviteIconUrl()
    lazyInit_()
    return checkstring(checktable(userWebData.share).invite_icon)
end

--微信绑定
function UserData:isBindWx()
    lazyInit_()
   return  Helper.And(checkint(userWebData.attr),ATTR_BINDWECHAT)~=0
end

function UserData:isActivited()
    lazyInit_()
   return Helper.And(checkint(userWebData.attr),ATTR_ACTIVITED)~=0
end

--手机激活
function UserData:isBindPhone()
    lazyInit_()
   return  Helper.And(checkint(userWebData.attr),ATTR_BINDPHONE)~=0
end

function UserData:isBindIdCard()
    lazyInit_()
     return  Helper.And(checkint(userWebData.attr),ATTR_BINDIDCARD)~=0
end

-- 绑定属性
function UserData:BindAttiribute(...)
    lazyInit_()
    local attr={...}
    if userWebData.attr and attr then
        for _,v in ipairs(attr) do
            userWebData.attr=Helper.Or(checkint(userWebData.attr),v)
        end
    end
end

--解绑属性
function UserData:unBindAttiribute(attr)
    lazyInit_()
    if userWebData.attr and attr then
        userWebData.attr = Helper.Xor(userWebData.attr,attr)
    end
end

function UserData:GetUserMsgCount()
    lazyInit_()
   return checkint(userWebData.usermsg )  --未读消息数量
end

-- 未拉取的公告数量
-- usermsg (int)
function UserData:GetNoticeCount()
    lazyInit_()
    return checkint( userWebData.notice )        --公告数量
end

--获取身份证尾号-- idcard (string)
-- 身份证尾号后4位,仅在绑定身份证时返回
-- 第二个返回值表示是否已绑定身份证。返回 true 表示已绑定，false 表示未绑定
function UserData:GetIdCardSuffix()
    lazyInit_()
    return gg.IIF(userWebData.idcard == nil,"未认证",( string.sub( userWebData.idcard or "" , 0 , 6 ) ).."************"  ) , userWebData.idcard ~= nil
end

-- 设置身份证号信息
function UserData:SetIdCardInfo( idCard )

    if idCard and ( #idCard == 15 or #idCard == 18)  then
        userWebData.idcard = idCard
    end
end

--获取手机号尾数
function UserData:GetPhoneSuffix()

    lazyInit_()
    return gg.IIF(userWebData.phone  == nil,"—","*******"..( string.sub( userWebData.phone or "" , 8 , 11 )  )) , userWebData.phone ~= nil , userWebData.phone
end

-- 设置手机号
function UserData:SetPhoneInfo( phone )

    if phone and #phone == 11  then
        userWebData.phone = phone
    end
end

-- 清空手机信息
function UserData:clearPhoneInfo()

    userWebData.phone = nil
end

--获取兑换话费人数
function UserData:GetExchangeTelCount()
    lazyInit_()
    return checkint(userWebData.c_tr)
end

--获取兑换微信红包人数
function UserData:GetExchangeWXRedPackCount()
    lazyInit_()
    return checkint(userWebData.c_rp)
end

-- 获取邀请好友分享内容
function UserData:GetShareAff()
    lazyInit_()
    return checktable(userWebData.share_aff)
end

-- 获取用户是否是代理
function UserData:GetIsAgency()
    lazyInit_()
    -- 去除本地缓存是否代理的逻辑
    -- local isagent= self:getConfigByKey("agent") or checkint(userWebData.rcapc)
    local isagent = checkint(userWebData.rcapc)
    printf("GetIsAgency : %d", isagent)
    return isagent
end

-- 获取用户是否信用用户
function UserData:GetIsCreditUser()
    lazyInit_()
    local isCreditUser = checkint(userWebData.rcas)
    printf("GetIsCreditUser : %d", isCreditUser)
    return isCreditUser
end

--获取是否领取新手奖励
function UserData:GetUserGift()
    return checktable(userWebData.isget_package)
end

--是否弹出迎新红包
function UserData:GetRedPacketStatus()
    return checkint(checktable(userWebData.signin).status)
end

-- 用户领取了7天红包的次数
function UserData:GetRedPacketTimes()
    return checkint(checktable(userWebData.signin).sum)
end

--新手注册时间
function UserData:GetUserRegisterTime()
    return checkint(checktable(userWebData.signin).reg_time)
end

-- 判断用户是否为新版本新注册用户
function UserData:IsNewAppVersionUser(baseVer)
    if not baseVer then return end
    local regTime = self:GetUserRegisterTime()
    local updateTime = gg.LocalConfig:GetHallUpdateTime(baseVer)     -- 大版本更新时间
    local hallVer = gg.VersionHelper:getModuleClientVer(gg.VersionHelper.VER_MODULE_HALL)   -- 大厅版本
    printf("regTime = %s, updateTime = %s, hallVer = %d", tostring(regTime), tostring(updateTime), tonumber(hallVer))
    -- 注册时间在当前版本之后，且大厅热更版本大于等于30，则认为是新版本发布后的新用户
    if updateTime and (regTime > tonumber(updateTime)) and hallVer >= baseVer then
        return true
    end

    return false
end

-- 获取活动配置
function UserData:GetActData()
    return userWebData.act
end

--获取好友圈列表
function UserData:GetFricedsCircles()
   return checktable(userWebData.club)
end

function UserData:GetShareDomain()
    lazyInit_()
    if userWebData.od and  #userWebData.od >0 then
        setUserCache_("sharedomain",userWebData.od)
    end
    return self:getConfigByKey("sharedomain")
end

--协议域名
function UserData:GetSchemeDomain()
    lazyInit_()
    local domain = checktable(userWebData.join).domain or userWebData.qd
    if domain and #domain > 0 then
        setUserCache_("schemedomain", domain)
    end
    return self:getConfigByKey("schemedomain")
end

-- 获取贵族月卡状态 task ID:23 为贵族月卡  status: 2 未购买、4 已购买未领取 、 5 已领取
function UserData:GetPrivilegeStatus()

    local taskInfo = self:GetTaskInfo( 23 )

    if taskInfo then

        return taskInfo.status
    end

    return 2
end

-- 获取星耀月卡状态 status: 2 未购买、4 已购买未领取 、 5 已领取
function UserData:GetMonthCardVIPStatus()
    local taskInfo = self:GetTaskInfo( 87 )

    if taskInfo then

        return taskInfo.status
    end

    return 2
end

-- 获取月卡剩余时间
function UserData:GetPrivilegeTime()

    local taskInfo = self:GetTaskInfo( 23 )

    if taskInfo and taskInfo.time then

        local t = 0
        if taskInfo.status ~= 5 then

            t = math.ceil( taskInfo.time / ( 3600 * 24 ) )
        else

            t = math.floor( taskInfo.time / ( 3600 * 24 ) )
        end

        return t
    end

    return 30
end

-- 设置贵族月卡领取状态
function UserData:SetPrivilegeStatus( status )

    local taskInfo = self:GetTaskInfo( 23 )
    if taskInfo then

        taskInfo.status = status
    end
end

-- 获取指定任务信息
-- id
function UserData:GetTaskInfo( taskid )

    local task = self:GetTaskTable()
    for k , v in pairs( task ) do
        if v and v.id == taskid then
            return v
        end
    end
    return nil
end

-- 获取荣誉排名分享任务状态
function UserData:GetHonorShareTaskStatus()
    local taskInfo = self:GetTaskInfo(92)
    if taskInfo then
        return taskInfo.status
    end
    return 2
end

-- 设置荣誉排名分享任务状态
function UserData:SetHonorShareTaskStatus(status)
    local taskInfo = self:GetTaskInfo(92)
    if taskInfo then
        taskInfo.status = status
    end
end

-- 是否可以领取当前段位的荣誉特权奖励
function UserData:CanGetCurGradeHonoAward(grade)
    local data = checktable(userWebData.par)
    if table.nums(data) <= 0 then return true end

    local gradeStr = string.format("paragraph_%d", grade - 1)
    for k,v in pairs(data) do
        if tostring(k) == tostring(gradeStr) and checkint(v) == 1 then
            return false
        end
    end
    return true
end

-- 修改当前段位奖励记录
function UserData:SetCurGradeHonoAward(newgrade,oldgrade)
    local data = checktable(userWebData.par)
    for i=oldgrade,newgrade do
        local gradeStr = string.format("paragraph_%d", i - 1)
        data[gradeStr] = 1
    end
end


-- 是否可以购买当前段位的荣誉特权礼包
function UserData:CanBuyCurGradeHonorGift(grade)
    local data = checktable(userWebData.hrr)
    if table.nums(data) <= 0 then return true end
    -- 根据当前段位获取礼包的goods字段，如果数据中存在则表示已经购买过
    local giftCfg = require("hall.models.StoreData"):GetHonorGoodsTable(grade)
    if giftCfg then
        for k,v in pairs(data) do
            if tostring(k) == tostring(giftCfg.goods) and checkint(v) == 1 then
                return false
            end
        end
    end
    return true
end

-- 修改荣誉特权礼包购买记录
function UserData:SetCurGradeHonorGift(grade)
    local data = checktable(userWebData.hrr)
    local giftCfg = require("hall.models.StoreData"):GetHonorGoodsTable(grade)
    data[giftCfg.goods] = 1
end

------------------------------------------------
-- 新版福袋接口
------------------------------------------------
function UserData:GetNewTaskTable()
    lazyInit_()
    return checktable( userWebData.newtask )
end

-- 获取任务的状态
function UserData:GetNewTaskStatusById( id )
    local task = self:GetNewTaskTable()
    for _,v in pairs(task) do
        if v and v.id == id then
            -- 2017-10-27 新版首充任务只有未完成和已领取两个状态，当任务为4状态时直接返回5状态
            if v.status == 4 and (v.id == 76 or v.id == 77) then
                v.status = 5
            end

            return v.status
        end
    end
end

-- 修改任务状态
function UserData:SetNewTaskStatusById( id, status )
    local task = self:GetNewTaskTable()
    for _,v in pairs(task) do
        if v and v.id == id then
            v.status = status
            -- 2017-10-27 新版首充任务只有未完成和已领取两个状态，当任务被设置为4状态时直接将任务状态变为5状态
            if status==4 and (v.id==76 or v.id==77) then
                v.status = 5
                return
            end
        end
    end
end

-- 获取当前进行的任务等级(以首充任务记录的hlv为准)
function UserData:GetNewTaskHlv( )
    return 1
end

-- 判断用户是否可以进行分享
function UserData:CanDoShare()
    if not GameApp:CheckModuleEnable(ModuleTag.WeixinShare) then
        return false
    end

    -- 玩家荣誉达到3颗星才显示分享有礼
    -- if hallmanager and hallmanager.userinfo then
    --     -- 根据荣誉等级计算出用户所在的等级
    --     local hlvExp = hallmanager:GetHonorValue()
    --     local grade, star = gg.GetHonorGradeAndLevel(hlvExp)
    --     if grade > 1 or star >= 3 then
    --         return true
    --     end
    -- end

    -- 2018-07-21 暂时去掉荣誉等级3颗星的限制
    return true
end

-- 获取用户的账号名字
function UserData:GetAccountName()
    local account = "未激活"
    if hallmanager and hallmanager.userinfo then
        local userfrom = hallmanager.userinfo.userfrom
        local accountType = {
            [22] = "360用户",
            [24] = "OPPO用户",
            [26] = "华为用户",
            [28] = "应用宝QQ用户",
            [30] = "应用宝微信用户",
            [34] = "小米用户",
            [38] = "VIVO用户",
            [40] = "今日头条用户",
            [42] = "三星用户",
            [44] = "魅族用户"
        }

        local from = (BRAND == 0) and USER_FROM_JIXIANG or USER_FROM_PLATFORM
        if userfrom == from then
            account = gg.Cookies:GetDefRole().username
        elseif userfrom == USER_FROM_WECHAT then
            account = "微信用户"
        elseif BRAND == 1 and accountType[userfrom] then
            -- 微乐的第三方用户
            account = accountType[userfrom]
        end
    end
    return account
end
------------本地文件存储数据-----------------

--添加 数据表 k v
function UserData:SetConfigKV(mapval)
    table.merge(checktable(localCfgObj),checktable(mapval))
    flush_()
end
--根据键值获取 配置
function UserData:getConfigByKey(key)
    return localCfgObj[key]
end
--根据键值删除 配置
function UserData:delConfigByKey(key)
    if key then
       localCfgObj[key]=nil
    end
end

function UserData:Flush()
    return flush_()
end

-- 获取上一次分享时间
function UserData:GetShareTime()
    return checkint(userWebData.share_time)
end

-- 设置分享状态
function UserData:SetShareTime(tm)
    userWebData.share_time = tm
end

-- 总分享次数，一天内多次分享算一次
function UserData:GetShareNum()
    return checkint(userWebData.share_num)
end

-- 设置分享次数
function UserData:SetShareNum(num)
    userWebData.share_num = num
end

function UserData:GetShareVer()
    return checkint(userWebData.share_ver)
end

--获取新手签到次数
function UserData:GetNewUserCount()
    return checkint(userWebData.novice_sign_num)
end
--获取每日签到次数
function UserData:GetDailyCount()
    --签到次数取余 每日签到次数 15
    return checkint(userWebData.daily_sign_num %15)
end
--设置新手签到次数
function UserData:SetNewUserCount(num)
    userWebData.novice_sign_num = num
end
--设置每日签到次数
function UserData:SetDailyCount(num)
    userWebData.daily_sign_num = num
end

-- 获取新手签到状态  3 没有领取 5已经领取
function UserData:GetNewUserSignStatus()
    local taskInfo = self:GetTaskInfo(94)
    if taskInfo then
        return taskInfo.status
    end
    return nil
end

-- 获取每日签到状态  3 没有领取 5已经领取
function UserData:GetDailySignStatus()
    local taskInfo = self:GetTaskInfo(96)
    if taskInfo then
        return taskInfo.status
    end
    return nil
end

-- 获取分享有礼状态  3 没有分享 5已经分享
function UserData:GetShareGiftStatus()
    local taskInfo = self:GetTaskInfo(105)
    if taskInfo then
        return taskInfo.status
    end
    return nil
end
-- 设置分享有礼状态 5已经分享
function UserData:SetShareGiftStatus()
    local taskInfo = self:GetTaskInfo(105)
    if taskInfo then
        taskInfo.status = 5
    end
end


-- 设置新手签到已经领取签到状态 5已经领取
function UserData:SetNewUserSignStatus()
    local taskInfo = self:GetTaskInfo(94)
    if taskInfo then
        taskInfo.status = 5
    end

end
-- 设置每日签到已经领取签到状态 5已经领取 3 未签到
function UserData:SetDailySignStatus(type)
    if not type then return end
    local taskInfo = self:GetTaskInfo(96)
    if taskInfo then
        taskInfo.status = type
    end

end

--获取有礼关注的状态
function UserData:getGzylStatus()
    local taskInfo = self:GetTaskInfo(98)
    if taskInfo then
        return taskInfo.status
    end
    return nil
end

--设置有礼关注的状态
function UserData:setGzylStatus()
    local taskInfo = self:GetTaskInfo(98)
    if taskInfo then
        taskInfo.status = 5
    end
end

--获取记牌器到期时间时间戳
function UserData:getCardHolder()
    --获取的时间为到期时间
    local time = checkint(userWebData.memory_card)
    --到期时间时间戳
    return gg.IIF(time > 0, os.time() + time, 0)
end

--设置记牌器的到期时间时间戳
function UserData:setCardHolder(time)
    userWebData.memory_card = time
end

--获取评价有礼的状态
function UserData:getPjylStatus()
    local taskInfo = self:GetTaskInfo(99)
    if taskInfo then
        return taskInfo.status
    end
    return nil
end

--设置评价有礼的状态
function UserData:setPjylStatus()
    local taskInfo = self:GetTaskInfo(99)
    if taskInfo then
        taskInfo.status = 5
    end
end

-- 电视赛所需资料是否已经填写
function UserData:isTvMatchDataIntegrity()
    return checkint(userWebData.tvenroll) == 1
end

-- 设置用户电视赛资料是否填写状态
function UserData:setTvMatchDataIntegrity()
    userWebData.tvenroll = 1
end

return UserData
