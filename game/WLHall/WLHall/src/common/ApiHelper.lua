--[[
* 网站接口
* 回调函数事件原型
	err:错误原因,如果为nil,则没有错误
	data:数据,只有err为nil,才有效
function(err,data);
]]

local dapi_ = "://dapi." .. WEB_DOMAIN
-- local userapi_ = "://userapi." .. WEB_DOMAIN
local payapi_ = "://payapi2." .. WEB_DOMAIN

local app_id_ = "/" .. APP_ID
local channel_id_ = "/" .. CHANNEL_ID

-- 平台 全局变量 BRAND 索引方式 获取
--请求前缀
local prefix_="https"

--实现接口 url
local Dapi = gg.Dapi

local METHOD_GET="GET"
local METHOD_POST="POST"
local METHOD_UPLOAD="UPLOAD"
Dapi.METHOD_GET=METHOD_GET
Dapi.METHOD_POST=METHOD_POST

Dapi.NO_USER_API_DOMAIN="NO_USER_API_DOMAIN"

local EXCHANGE_TAG={
    [PROP_ID_ROOM_CARD]="room_card"
}

local function getToken_()
    -- assert(hallmanager,"检查网络连接 hallmanager  nil")
    if hallmanager and hallmanager:IsConnected() then
        return { token = hallmanager:GetSession() }
    end
    return {}
end

-- 直接进行 Http 请求（不走代理）
local function directHttpRequest( method, url, callback, ... )
    if METHOD_POST == method then
        -- POST 需要在 data 里面加上 userid
        local data, encrypt, timeout, responseType = ...
        data = checktable(data)
        if USER_INIT_DOMAIN and string.find(url, USER_INIT_DOMAIN) then
            table.merge(data, { userid = gg.UserData:GetUserId() })
            encrypt = false
        elseif USER_API_DOMAIN and string.find(url, USER_API_DOMAIN) then
            table.merge(data, getToken_())
            encrypt = false
        elseif PAY_API_DOMAIN and string.find(url, PAY_API_DOMAIN) then
            table.merge(data, getToken_())
            encrypt = true
        end

        -- 禁用加密
        return gg.Http:Post(url, callback, data, encrypt, timeout, responseType)
    elseif METHOD_UPLOAD == method then
        -- upload
        local filepath, params, encrypt = ...
        table.merge(params, getToken_())
        return gg.Http:UploadFile(url, callback, filepath, params, encrypt)
    elseif METHOD_GET == method then
        local params, encrypt = ...
        -- 禁用加密
        return gg.Http:Get(url, callback, params, false)
    else
        callback(-2,"无效请求调用")
        printf("无效的代理服务器请求 METHOD: %s, url:%s",method,url)
    end
end

local function invoke_(manager,method,url,callback,...)
    assert(manager,"manager is nil error")
    local HttpFunc={
        [METHOD_GET] = checktable(manager.http).Get,
        [METHOD_POST] = checktable(manager.http).Post,
        [METHOD_UPLOAD] = checktable(manager.http).UploadFile,
    }
    if HttpFunc[method] then
        return HttpFunc[method](manager.http,url,callback,...)
    else
        callback(-2,"无效请求调用")
        printf("无效的代理服务器请求 METHOD: %s, url:%s",method,url)
    end
end

local function sendRequest_(method,url,callback,...)
    if string.find(url, Dapi.NO_USER_API_DOMAIN) then
        -- 没有下发 User API 接口的域名，直接返回
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "数据请求失败（错误码:-5）")
        callback(-5,"获取数据失败（错误码:-5）")
        return
    end

    local noProxy = false
    if (USER_INIT_DOMAIN and string.find(url, USER_INIT_DOMAIN)) or
        (USER_API_DOMAIN and string.find(url, USER_API_DOMAIN)) or
        (PAY_API_DOMAIN and string.find(url, PAY_API_DOMAIN)) then
        noProxy = true
    end

    if noProxy then
        -- 不需要使用代理的话，直接进行 Http 请求
        directHttpRequest(method, url, callback, ...)
        return
    end

    if hallmanager then
        return invoke_(hallmanager,method,url,callback,...)
    else
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "请先登录后再操作")
    end
end

local function sendLoginRequest_(method,url,callback,...)
    return invoke_(cc.load("LoginManager"):getInstance(),method,url,callback,...)
end

local function getRegion_()
    local region= gg.LocalConfig:GetRegionCode()
    if  checkint(region)==0 then
       region = REGION_CODE
    end
    region = gg.StringAppend(region, 0, 6)
    return region
end

local function getPayApi_(name)
    local ver_str = gg.GetHallVerison()
    local domain = PAY_API_DOMAIN or Dapi.NO_USER_API_DOMAIN
    return string.format("%s%s%s%s/%s/%s", domain, name,  app_id_, channel_id_, ver_str, getRegion_())
end

-- 获取 User Api 接口的域名
local function getUserApiDomain_( isInit )
    local ret
    if isInit then
        ret = USER_INIT_DOMAIN or Dapi.NO_USER_API_DOMAIN
    else
        ret = USER_API_DOMAIN or Dapi.NO_USER_API_DOMAIN
    end

    return ret
end

local function getUserApi_(name, isInit)
    local ver_str = gg.GetHallVerison()
    local domain_str = getUserApiDomain_(isInit)
    return string.format("%s%s%s%s/%s/%s", domain_str, name, app_id_, channel_id_, ver_str, getRegion_())
end

--获取阿里设备风险识别sdk 签名
local function getAvmpSign_()
    local  signtable = {}
    if device.platform == "android" and gg.GetNativeVersion() >= 4 then
        local deviceid = Helper.GetDeviceCode()
        local sign = device.getAvmpSignString(deviceid)
        signtable.rawdata = deviceid
        signtable.sign = string.urlencode(sign)
    end
    return signtable
end

local function checkvalues_(...)
    local values = { ... }
    for _, v in ipairs(values) do
        if not v or (type(v) == "string" and string.len(v) < 1) then
            printf("[error]参数校验失败,请检查参数。")
            return false
        end
    end
    return true
end
--处理json 数据
local function handlerjson_(callback)
    assert(callback,"callback args is nil")
    return function(state, data)
        if type(data) == "table" then
            callback(data)
            return
        end

        local ok, datatable = pcall(function() return json.decode(data) end)
        if ok and callback then
            callback(datatable)
        else
            callback()
        end
    end
end
local function errorhandler_(callback)
    return function(respcode, data)
        if respcode and respcode~=200 then
            respcode =  iif(checkint(respcode)==0,-1,respcode)
            if callback then
                local errMsg
                if data and type(data) == "string" and #data > 0 then
                    errMsg = data
                else
                    errMsg = API_ERR_MSG[respcode] or "网络错误,请重试！"
                end
                callback({ msg = errMsg, status = respcode })
            end
        else
            printf("errorhandler_ %s", tostring(data))
            local ok, datatable = pcall(function() return loadstring(data)(); end)
            datatable = checktable(datatable)
            if ok and datatable.status == API_ERR_CODE.ShowMsg then
                GameApp:dispatchEvent(gg.Event.SHOW_LOADING)
                GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG, datatable.msg)
            elseif datatable.status == API_ERR_CODE.ShowToast then
                GameApp:dispatchEvent(gg.Event.SHOW_LOADING)
                GameApp:dispatchEvent(gg.Event.SHOW_TOAST, datatable.msg)
            end
            if callback then
                callback(datatable)
            else
                printf("no  callback")
            end
        end
    end
end

function Dapi:ErrorHandler(callback)
    return errorhandler_(callback)
end

-- 返回拼接的url地址
function Dapi:GetUserApiUrl( interface )
    local url = getUserApi_( interface )
    return url
end

-- 获取错误代码提示
function Dapi:GetErrorMsg(err_code)
    return API_ERR_MSG[err_code]
end

--发送代理请求
function Dapi:SendRequest(method,url, callback, params, timeout,responseType)
    return sendRequest_(method,url, callback, params, false,timeout,responseType)
end

-- 接口名称
-- user/MesgReadAfter
-- 请求方式-- POST
-- msgid (int)-- 消息id
-- msgtype (string)-- 消息类型
function Dapi:MsgReadAfter(msgid, msgtype,callback)
    local url = getUserApi_("/notice/readafter")
    local data = { id = msgid, type= msgtype }

    sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
end

-- userapi-- 接口名称
-- task/config
-- https://client.{domain}/task/config/{品牌ID,吉祥:1,微乐:2}/{AppID}/{渠道ID}/{版本号}/{任务版本号}/{地区代码}
function Dapi:TaskConfig(taskver,callback)
    local url = getUserApi_("/task/config")
    url=url.."/"..tostring(taskver)
    sendRequest_(METHOD_GET,url, errorhandler_(callback))
end

function Dapi:TaskCategoryConfig( callback )
    local url = getUserApi_("/task/categoryconfig")
    local data = {}
    sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
end

--新的奖励配置接口
function Dapi:TaskNewConfig(taskid,callback,ver)
    local url = getUserApi_("/task/newconfig")
    local data = {taskid = taskid , ver = ver}
    sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
end

-- exchange/phoneFee 使用话费卡兑换话费
-- POST
-- realtime (integer)-- 是否为即时话费卡,0:否,1:是
-- phone (string)-- 要充值的手机号
-- value (integer)-- 面值,1、2、5、10、30、50、100
--- @return
-- content (string)-- 分享内容
-- icon (string)-- 分享图标或图片地址
-- url (string)-- URL地址
-- pic (string)-- 仅分享图片时的图片地址,当此值不存在或为空时,按照老版本的链接方式进行分享；否则则使用此参数中的地址进行图片分享
function Dapi:ExchangePhoneFee(realtime, phone, value, callback)
    if checkvalues_(phone) then
        local url = getUserApi_("/exchange/phonefee")
        local data = { realtime = realtime, phone = phone, value = value }

        sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
    end
end

-- exchange/redpack 使用红包卡兑换微信红包
-- POST
-- 所需的额外参数
-- value (integer)-- 面值（单位：角）
-- realtime (integer)-- 是否为即时红包,0:否,1:是
-- 额外返回参数
-- content (string)-- 分享内容
-- icon (string)-- 分享图标或图片地址
-- url (string)-- URL地址
-- pic (string)-- 仅分享图片时的图片地址,当此值不存在或为空时,按照老版本的链接方式进行分享；否则则使用此参数中的地址进行图片分享
function Dapi:ExchangeRedpack(value, realtime, callback)

    local url = getUserApi_("/exchange/redpack")
    local data = { realtime = realtime, value = value }

    sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
end

---------------- user-------------------------

-- accounts/activatee 账号激活（普通激活）
-- POST
-- 所需的额外参数
-- realname (string)-- 真实姓名
-- idcard (string)-- 身份证号码
-- username (string)-- 游戏帐号
-- password (string)-- 密码,一次MD5加密
-- udid (string)-- 设备码
function Dapi:ActivateAccount(real_name, id_card, user_name, pwd, uid, callback)
    if checkvalues_(real_name, id_card, user_name, pwd, uid) then
        local url = getUserApi_("/user/activate")
        local data = { realname = real_name, idcard = id_card, username = user_name, password = Helper.Md5(pwd), udid = uid }

        sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
    end
end

-- accounts/activateMobile 账号激活（手机激活）
-- POST
-- 所需的额外参数
-- phone (string)-- 手机号码
-- captcha (string)-- 短信验证码,通过 captcha/sms 获取短信验证码 接口获取
-- realname (string)-- 真实姓名
-- idcard (string)-- 身份证号
-- password (string)-- 密码,一次MD5加密
-- udid (string)-- 设备码
function Dapi:ActivateMobile(phone_num, captcha_str, pwd, uid, regplatform, callback)

    if checkvalues_(phone_num, captcha_str, pwd, uid) then
        local url = getUserApi_("/user/activatemobile")
        pwd = Helper.Md5(pwd)
        local data = { username = phone_num, captcha = captcha_str, password = pwd, udid = uid, regplatform = regplatform }

        sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
    end
end

-- 用户注册功能
function Dapi:RegisterIndex( uname, pwd, udid, captcha, utype, callback )
    local url = getUserApi_("/register/user")
    captcha=iif(#checkstring(captcha)==0,nil,captcha);
    local data = { username = uname, password = Helper.Md5(pwd), udid = udid, captcha = captcha, type = utype }
    sendLoginRequest_(METHOD_POST, url, errorhandler_(callback), data, true )
end

-- phone/captcha 获取短信验证码
-- POST
-- 所需的额外参数
-- phone (string)-- 手机号码
-- udid (string)-- 设备码
-- purpose (string)-- 验证码用途,可以是以下值：
-- activate：账号激活
-- bind：绑定手机
-- unbind：解绑手机
-- 额外返回参数
-- purpose (int)
-- 再次获取的间隔时间（秒）,当status为0时返回
-- surplus (int)
-- 剩余的间隔时间（秒）,当status为301时返回,可将此值直接显示于按钮上用于倒计时
function Dapi:PullCaptchaSms(phone, udid, purpose, callback)
    if checkvalues_(phone, udid, purpose) then
        local url = getUserApi_("/phone/captcha")
        local data = { phone = phone, udid = udid, purpose = purpose }

        sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
    end
end

-- phone/bind 绑定手机
-- POST
-- 所需的额外参数
-- idcard (string) 身份证号码
-- phone (string)-- 手机号码
-- captcha (string)-- 短信验证码,通过 phone/captcha  获取短信验证码 接口获取
function Dapi:BindPhone(phone, captcha, callback)
    if checkvalues_(phone, captcha, idcard) then
        local url = getUserApi_("/phone/bind")
        local data = { phone = phone, captcha = captcha}

        sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
    end
end

-- phone/unbinde 解绑手机
-- POST
-- 所需的额外参数
-- phone (string)-- 手机号码
-- captcha (string)-- 短信验证码,通过 phone/captcha 获取短信验证码 接口获取
function Dapi:UnbindPhone(phone, captcha, callback)
    if checkvalues_(phone, captcha, idcard) then
        local url = getUserApi_("/phone/unbind")
        local data = { phone = phone, captcha = captcha }

        sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
    end
end

-- accounts/nickname 修改昵称
-- POST
-- 所需的额外参数（以下参数不传则不进行修改）
-- nickname (string)-- 昵称
function Dapi:ModifyNickName(nickname, callback)
    if checkvalues_(nickname) then
        local url = getUserApi_("/user/nickname")
        local data = { nickname = nickname }

        sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
    end
end

-- accounts/sex 修改性别
-- POST
-- 所需的额外参数（以下参数不传则不进行修改）
-- sex (int)-- 性别,1：男,0：女
function Dapi:ModifySex(sex, callback)
    if checkvalues_(sex) then
        local url = getUserApi_("/user/sex")
        local data = { sex = sex }

        sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
    end
end

-- user/password
-- POST
-- 所需的额外参数
-- old (string) 原密码
-- new (string) 新密码
function Dapi:ModifyPassword(old, new, callback)
    if checkvalues_(old, new) then
        local url = getUserApi_("/user/password")
        local data = { old = old, new = new }

        sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
    end
end
--[[
* @brief 意见反馈
* @parm gameId 游戏ID
* @parm roomId 房间ID
* @parm content 反馈文本
* @parm img 上传图片链接地址使用||连接两个URL地址
* @parm callback 请求回调
]]
function Dapi:FeedBack(udid, gameId, roomId, content, phone , img, callback)

    local url = getUserApi_("/feedback/add")
    local data = { udid = udid, game_id = gameId or 0, room_id = roomId or 0, phone = phone , content = content or "", img = img or "" }
    data.token=hallmanager:GetSession()
    sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
end

-- user/avatar 上传头像
-- POST
-- 所需的额外参数不加密
-- 不加密-- 图片数据流
function Dapi:UploadAvatar(fullpath, callback)
    local url = getUserApi_("/user/avatar")
    sendRequest_(METHOD_UPLOAD,url, errorhandler_(callback), fullpath, {}, false)
end

--上传图片  此接口不使用http 代理
-- POST
-- 所需的额外参数不加密
-- 不加密-- 图片数据流
function Dapi:UploadCloudimg(fullpath, callback)
    local ver_str = gg.GetHallVerison()
    local url = prefix_.."://cloudimg."..WEB_DOMAIN.."/upload"..app_id_..channel_id_.."/"..ver_str.."/"..getRegion_()
    local params = { token = hallmanager:GetSession() }
    gg.Http:UploadFile(url, errorhandler_(callback), fullpath, params, true)
end


-- userapi
-- 接口名称
-- login/wechat
-- POST
-- 所需的额外参数
-- wechat_id (string)-- 微信ID,请用打包内置的微信ID进行登录
-- code (string)-- 用户换取access_token的code,从微信SDK获得,首次登录或凭证失效必须带有该参数
-- openid (string)-- 微信用户与当前包对应的openid,每次登陆后web接口都将返回该值,二次登录可直接使用openid进行登录,不必再次进行授权
-- 额外返回参数
-- result (int)-- 游戏第三方登录服务器返回的状态码
-- msg (string)-- 游戏第三方登录服务器的提示信息
-- id (int)-- 用户ID
-- hallid (int)-- 登录的大厅ID
-- ip (int)-- 整形IP地址
-- port (int)-- 端口
-- code (string)-- 游戏第三方登录服务器返回的session
-- openid (string)-- 微信用户与当前包对应的openid,需在二次登录时传给web接口
function Dapi:LoginByWechat(wxappid,wxcode,wxopenid,callback)
    local ver_str = gg.GetHallVerison()
    local url = prefix_.."://wechat-login."..WEB_DOMAIN..app_id_..channel_id_.."/"..ver_str.."/"..getRegion_()
    wxappid=wxappid or WX_APP_ID_LOGIN
    local deviceid = Helper.GetDeviceCode();
    local data ={wechat_id=wxappid,code=wxcode,openid=wxopenid,udid=deviceid,v=1}
    table.merge(data,getAvmpSign_()) --追加avmp 签名
    sendLoginRequest_(METHOD_POST, url, errorhandler_(callback), data,true)
end

function Dapi:loginByThirdParty(data, callback)
    local ver_str = gg.GetHallVerison()
    local url = prefix_.."://thirdlogin."..WEB_DOMAIN.."/login"..app_id_..channel_id_.."/"..ver_str.."/"..getRegion_()

    -- 第三方登录也需要上传设备码
    local deviceid = Helper.GetDeviceCode();
    table.merge(data, {udid = deviceid,v=1})
    table.merge(data, getAvmpSign_()) --追加 avmp 签名
    sendLoginRequest_(METHOD_POST, url, errorhandler_(callback), data, true)
end

function Dapi:getSamsungPrivateKey(callback)
    local ver_str = gg.GetHallVerison()
    local url ="http://thirdlogin.weile.com/getSxkey/index"..app_id_..channel_id_.."/"..ver_str.."/"..getRegion_()
    local deviceid = Helper.GetDeviceCode();
    local data = {udid=deviceid, v=1}
    table.merge(data,getAvmpSign_()) --追加avmp 签名
    gg.Http:Post(url, callback, data, true)
end

 --获取比赛奖励数据表 json格式
function Dapi:GetMatchAwards( gameid,roomid, callback )
    local url=string.format("%s/static/data/game_%d/match_awards_%d.json", getUserApiDomain_(), checkint(gameid),checkint(roomid))
    return sendRequest_(METHOD_GET,url,handlerjson_(callback))
end

-- notice/list 获取短信验证码
-- POST
-- 所需的额外参数
-- last (int)-- 上次列表拉取时的最后一条消息的ID,如果是首次拉取请传0
-- 额外返回参数
-- list (array)
-- 消息列表,所含键值如下
-- id (int)
-- 消息ID
-- status (int)
-- 之前是否拉取过该消息,0:未拉取过,1:已拉取过
-- time (string)
-- 消息发布时间
-- title (string)
-- 消息标题
-- body (string)
-- 消息内容

-- count (int)
-- 本次拉取的消息数量
-- last (int)
-- 最后一条消息的ID,请在翻页操作中将此值回传
function Dapi:NoticeList(last, callback)
    local url = getUserApi_("/notice/list")
    local data = { last = last }
    sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
end

-- msg/list 获取短信验证码
-- POST
-- 所需的额外参数
-- last (int)-- 上次列表拉取时的最后一条消息的ID,如果是首次拉取请传0
-- 额外返回参数
-- list (array)
-- 公告列表,所含键值如下
-- id (int)
-- 公告ID
-- time (string)
-- 公告发布时间
-- title (string)
-- 公告标题
-- body (string)
-- 公告内容
-- count (int)
-- 本次拉取的公告数量
function Dapi:MsgList(last, callback)
    if checkvalues_(last) then
        local url = getUserApi_("/msg/list")
        local data = { last = last }
        sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
    end
end

-- msg/reward 信息附件领取
function Dapi:MsgReward( msgid, callback )
    local url = getUserApi_( "/msg/reward" )
    local data = { msgid = msgid }
    sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
end

-- msg/callback 信息回调
function Dapi:MsgCallback(msgid, callback)
    local url = getUserApi_( "/msg/callback" )
    local data = { id = msgid }
    sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
end

-- 活动
function Dapi:GetActivityNotice( callback )
    local url = getUserApi_("/activeNotice/index")
    local data = {}
    sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
end

-- 所属子域-- payapi
-- 接口名称-- order/new
-- 功能描述-- 充值下单
-- 请求方式-- POST
-- 所需的额外参数
-- type (string)-- 充值方式
-- wechatH5 : 微信支付
-- alipayH5 : 支付宝
-- unionpay_client : 银联支付
-- appstore : 苹果AppStore
-- midas : 米大师支付
-- 360 : 奇虎360支付
-- roomid (integer)-- 充值时玩家所在的房间ID, 没有或大厅为0
-- money (integer)-- 充值金额,单位为：分
-- virtual (integer)-- 是否充值为虚拟货币,1:表示充值为吉祥/微乐币,0或不传:表示直接充值为豆
-- autobuy (integer)-- 是否自动使用本次充值的吉祥/微乐币购买等价道具(并赠送豆) 1.自动够买 0.
-- ingame (integer)-- 是否为游戏中充值,0:否,1:是
-- udid (string)-- 唯一标识符
-- debug (integer)-- 是否为调试模式,0否,1是
-- 额外返回参数
-- orderid (string)-- 16位商户订单号
-- ext (array)-- 扩展数据结构
function Dapi:OrderNew(args, callback, debug)
    args["debug"] = checkint(args.debug or debug);

    if GameClient then
        -- 在游戏中，需要获取游戏 id 和 房间 id
        if GameClient.gameinfo and checkint(args.ingame) == 0 then
            args.ingame = checkint(GameClient.gameinfo.id)
        end

        if GameClient.roominfo and checkint(args.roomid) == 0 then
            args.roomid = checkint(GameClient.roominfo.id)
        end

        if GameClient.roominfo and checkint(args.roomtype) == 0 then
            args.roomtype = checkint(GameClient.roominfo.type)
        end
    end

    -- H5游戏调起商城需要传入对应的游戏id
    if gg.WebGameCtrl.WEB_GAME_ID and checkint(gg.WebGameCtrl.WEB_GAME_ID) > 0 then
        print("---H5游戏调起商城需要传入对应的游戏id---")
        args.ingame = gg.WebGameCtrl.WEB_GAME_ID
    end

    args.ingame = checkint(args.ingame)
    args.roomid = checkint(args.roomid)
    args.roomtype = checkint(args.roomtype)
    args.virtual = args.virtual or 0;
    args.autobuy = args.autobuy or 0;
    local deviceid = Helper.GetDeviceCode();
    args.udid = args.udid or deviceid;
    args.type = args.type or ""

    if device.platform == "android" then
        -- android 平台需要上传系统版本信息
        local apilevel = device.getSystemVersion()
        if apilevel then
            args.apilevel = apilevel
        end
    end

    if checkvalues_(args.type, args.money, args.autobuy) then
        local url = getPayApi_("/order/new")

        -- 默认的返回数据类型为 REQUEST_RESPONSE_STRING
        local responseType = 0
        local postCallback = errorhandler_(callback)
        if args.type == "wechatH5" or args.type == "alipayH5" then
            -- H5 支付 url 中需要加上 fromat=json
            url = url.."?format=json"
            responseType = 4
            postCallback = handlerjson_(callback)
        end
        sendRequest_(METHOD_POST,url, postCallback, args, true, nil, responseType)
    end
end

-- payapi-- 接口名称
-- currency/exchange-- 功能描述
-- 使用虚拟货币兑换道具,兑换过程中请显示接口的提示信息给用户
-- 请求方式-- POST
-- 所需的额外参数
-- propid (int)-- 要兑换的道具ID
-- count (int)--  要兑换的道具数量
-- game_id (int)-- 兑换时所处的游戏ID
-- room_id (int)-- 兑换时所处的房间ID
-- udid (string)-- 设备码
-- 额外返回参数-- after (array)
-- 兑换
function Dapi:Exchange(propid, count , callback,game_id, room_id)

    local args = {}
    args.tag = propid
    args.count = checkint(count)
    args.game_id = checkint(game_id)
    args.room_id = checkint(room_id)
    args.udid = Helper.GetDeviceCode();

    local url = getPayApi_("/currency/exchange")

    sendRequest_(METHOD_POST,url, errorhandler_(callback), args, true)
end

-- 玩家的钻石兑换豆
function Dapi:DiamondToDou(callback)
    local url = getUserApi_("/exchange/diamondfee")
    sendRequest_(METHOD_POST,url, errorhandler_(callback), args, true)
end


-- callback/appstore
-- payapi
-- 所属子-- payapi
-- 接口名称-- callback/appstore
-- 功能描述
-- App Store充值回调
-- 请求方式-- POST
-- 所需的额外参数-- orderid (string)
-- 由 order/new 接口返回的订单号-- retry (integer)
-- 重试次数, 订单重试回调请求的次数,从0开始-- receipt (string)
-- 苹果返回的支付凭证-- 额外返回参数
-- dataid (int)
-- 此次充值成功所给予的道具ID
-- value (int)
-- 给予的道具数量
function Dapi:VerifyIosReceipt(args, callback)
    args = checktable(args)
    args.retry = checkint(args.retry)
    local url = getPayApi_("/callback/appstore")
    sendRequest_(METHOD_POST,url, errorhandler_(callback), args, true)
end



--客服地址
--https://chat.jixiang.cn:8080/auth?app_id={APP_ID}&channel_id={渠道ID}&code={加密数据}
--加密密串,密串内容为：id={用户ID}&version={客户端版本号}&region={所选地区代码}&ui={UI界面标识符},拼接后通过AuthCode算法进行加密
function Dapi:GeServicetUrl(code)
    local userid = 0
    if hallmanager and hallmanager:IsConnected() then
        userid = checkint(hallmanager.userinfo.id)
    end
    local region = 0
    local codeparam = string.format("id=%d&version=%s&region=%d&ui=%s", userid, gg.GetHallVerison(), region, code)
  --  print("codeparam = "..codeparam)
    local cryptdata = Helper.CryptStr(codeparam, URLKEY)
    local newcryptdata = Helper.StringReplace(Helper.StringReplace(cryptdata, "/", "-"), "+", ",")
    local url = "://chat." .. WEB_DOMAIN .. ":8080/auth?app_id=" .. APP_ID .. "&channel_id=" .. CHANNEL_ID .. "&code=" .. newcryptdata
    printf("service url =" .. url)
    return url
end


--Novicegift/GetNovicePackage
-- userapi
-- 所属子-- userapi
-- 接口名称-- Novicegift/GetNovicePackage
-- 功能描述
-- 领取新手奖励
function Dapi:getNovicePackage( callback )
    local url = getUserApi_("/Novicegift/getnovicepackage")
    local data = {}
    sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
end
-- task/award
-- userapi
-- 所属子-- userapi
-- 接口名称-- task/award
-- 功能描述
-- 领取任务完成奖励
-- 请求方式-- POST
-- 所需的额外参数-- id (int) 任务ID
--  当前用户荣誉等级 val
-- 额外返回参数-- time (int)
-- 距任务到期所剩的秒数,仅在领取限时类任务奖励时返回（出现这个参数的原因是可能用户本地已完成了,
-- 但却超过了服务器到期时间的临界点,此时服务器会给予错误提示,并为用户重新开启一个新的限时任务）
function Dapi:TaskAward( id, val, index, callback )
    if checkvalues_(id) then
        local url = getUserApi_("/task/award")
        local data = { id = id, index = index, val = val }
        sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
    end
end

-- task/activate
-- userapi
-- 所属子-- userapi
-- 接口名称-- task/activate
-- 功能描述
-- 激活任务
-- 请求方式-- POST
-- 所需的额外参数-- id (int) 任务ID,
-- 初始值,完成条件的前当值,限时类任务必传-- val (int)
-- 额外返回参数-- time (int)
-- 距任务到期所剩的秒数,仅在激活限时类任务时返回
function Dapi:TaskActivate( id, val, callback )

    local url = getUserApi_("/task/activate")
    local data = {}
    data.id = id
    data.val = val
    sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
end

-- 解锁荣誉等级任务包
-- 所属子-- userapi
-- 接口名称-- task/unpackHonor
-- 功能描述
-- 解锁荣誉等级任务包
-- 请求方式-- POST
-- 所需的额外参数-- hlv (int) 用户的当前荣誉等级
function Dapi:TaskUnpackHonor( hlv, callback )

    local url = getUserApi_("/task/unpackhonor")
    local data = { hlv = hlv }
    sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
end

-- pack/buy
-- userapi
-- 所属子-- userapi
-- 接口名称-- pack/buy
-- 功能描述
-- 购买礼包,用于购买每日礼包及一本万利礼包
-- 请求方式-- POST
-- 所需的额外参数-- id (int) 任务ID
function Dapi:PackBuy( id, callback )
    if checkvalues_(id) then
        local url = getUserApi_("/pack/buy")
        local data = { id = id }
        sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
    end
end

-- pack/award
-- userapi
-- 所属子-- userapi
-- 接口名称-- pack/award
-- 功能描述
-- 领取礼包奖励,用于领取一本万利礼包每日的奖励
-- 请求方式-- POST
-- 所需的额外参数-- id (int) 任务ID
function Dapi:PackAward( id, callback )
    if checkvalues_(id) then
        local url = getUserApi_("/pack/award")
        local data = { id = id }
        sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
    end
end

-- 礼品兑换地址
function Dapi:GetShopUrl()
    local encrypt_data = gg.Http:BuildEncryptData(getToken_())

    local shop_url = prefix_.."://mall."..WEB_DOMAIN..app_id_..channel_id_.."/"..getRegion_().."/data/" ..tostring(encrypt_data)
    return shop_url
end

-- 支付通知地址
function Dapi:GetPayNotifyUrl(type)
    local notify_url = prefix_.."://thirdpay1."..WEB_DOMAIN.."/callback".."/"..type..app_id_..channel_id_.."/"..gg.GetHallVerison().."/"..getRegion_()
    return notify_url
end

--获取游戏规则url地址
function Dapi:GetGameRule(gameid, callback)
    if checkint(gameid) <= 0 then
        if callback then
            callback({ msg ="获取数据失败！" , status = -1 })
        end
    else
        local url = "://client." .. WEB_DOMAIN.."/rule"..app_id_..channel_id_.."/"..gameid.."?lua=1"
        sendRequest_(METHOD_GET,url, errorhandler_(callback))
    end
end
--电视赛规则接口 --code 地区码
function Dapi:getTvAuditionRule( code , callback )
    local url = getUserApi_("/tvAudition/rule")
    local data = { code = code }
    sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
end

-- 微信激活
-- 所属子--   userapi
-- 接口名称-- wechat/active
function Dapi:WechatActive( code , callback )

    local url = getUserApi_("/wechat/active")
    local data = { code = code , wechat_id = WX_APP_ID_LOGIN }
    sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
end

-- 微信绑定
-- 所属子--   userapi
-- 接口名称-- wechat/bind
function Dapi:WechatBind( openid )

    local url = getUserApi_("/wechat/bind ")
    local data = { code = openid }
    sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
end

-- 实名认证
-- 所属子--   userapi
-- 接口名称-- user/cert
function Dapi:UserCert( idcard , realname , callback )

    local url = getUserApi_("/user/cert")
    local data = { idcard = idcard , realname = realname }

    sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
end

-- 更换手机号
-- 所属子--   userapi
-- 接口名称-- user/changeMobile
function Dapi:UserChangeMobile( step , phone , captcha , callback )

    local url = getUserApi_("/user/changemobile")
    local data = { step = step , phone = phone , captcha = captcha }

    sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
end

-- 游戏拉取分享二维码  callback( path, errmsg )
function Dapi:PullQRCodeImageAsync( gameid, regioncode, callback )
    local url= GET_QRCODE_URL(gameid)
    local file_uri = gg.ImageDownload:Start(url, callback)
    return file_uri
end

--[[
* @brief 战绩统计
* @parm callback 请求回调
]]
function Dapi:RecordFriend( gameId, callback )
    local url = getUserApi_("/record/friend")
    local data = {}
    if gameId then
        data = { gameid = gameId }
    end

    sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
end

-- 下载朋友场录像
function Dapi:RecordDownload( hashcode, index, callback )
    local url =getUserApi_("/record/download")
    local data = { hashcode = hashcode, index = index }

    sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
end

-- 快速查找回放
function Dapi:FastSearchRecord( record_id, index, callback )
    local url =getUserApi_("/record/download")
    local data = { record_id = record_id, index = index }
    sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
end

-- 创建房间验证推广员房卡
-- type 0 表示代开房间；1 表示信用好友创建房间
function Dapi:VerifyAgentRoomCard( userid, cardnum, permission, type, gameid, callback )
    local url = getUserApi_("/room/create")
    local data = { userid = userid, udid = Helper.GetDeviceCode(), count=checkint(cardnum),switch=checkint(permission),type=checkint(type),game_id=checkint(gameid)}
    sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
end

-- 代开房间记录
function Dapi:RoomIndex( callback )
    local url = getUserApi_("/room/index")
    local data = {}

    sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
end

-- 拉取微信兑换
-- realtime (integer)-- 是否为即时话费卡,0:否,1:是
function Dapi:PullWechatCode( realtime, value, callback )
    assert(callback)

    local valid = value > 0
    if not realtime then
        if value ~= 25 and value ~= 50 then
            -- 普通红包只能有这两种金额
            valid = false
        end
    end

    if not valid then
        printf("红包金额验证失败  value：%d",value)
        callback({status=99, msg="红包金额验证失败"})
        return
    end

    local url = getUserApi_("/wechat/code")
    local params = {token = hallmanager:GetSession()}
    params.value=value
    params.realtime = realtime
    sendRequest_(METHOD_POST, url, errorhandler_(callback), params, true )
end

-- 获取邀请信息
-- 所属子-- userapi
-- 接口名称-- aff/index
-- 功能描述
-- 获取用户邀请列表
-- 请求方式-- POST
function Dapi:GetAffIndex( callback )
    local url = getUserApi_("/aff/index")
    local data = {}

    sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
end

-- 发送邀请领取请求
-- 所属子-- userapi
-- 接口名称-- aff/get
function Dapi:AffGet( affid , callback )
    local url = getUserApi_("/aff/get")
    local data = { affid = affid }

    sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
end

-- 获取邀请奖励信息
function Dapi:AffUserinfo( userid, callback )
    local url = getUserApi_("/aff/userinfo")
    local data = { userid = userid }

    sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
end

-- 邀请领取奖励
-- type 奖励类型，login/task/recharge
-- userid 邀请的用户id
function Dapi:AffAwardGet( userid, type, value, callback )
    local url = getUserApi_("/aff/get2")
    local data = { userid=userid, type=type, value=value }

    sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
end

-- 拉取计费点配置数据
function Dapi:LoadGoodsConfig( version, callback )
    local url = getUserApi_("/goods/load")
    local data = { v=version }

    sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
end

function Dapi:AffActivitySevenDayData(callback)
    local url = getUserApi_("/signin/list")
    local data = { }

    sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
end

-- 加盟广告地址
function Dapi:GetAgentAdUrl( callback )
    local url = getUserApi_("/agent/slide")
    local data = {}
    sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
end

-- 获取荣誉任务数据 task/taskhonor
function Dapi:GetHonorTask( callback )
    local url = getUserApi_("/task/taskhonor")
    local data = {}

    sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
end

-- 获取每日任务数据 task/taskdata
function Dapi:GetDailyTask( callback )
    local url = getUserApi_("/task/taskdata")
    local data = {}

    sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
end

-- 获取客户端的实际 ip
function Dapi:GetClientIP(callback)
    local function getIpCallback(state, data)
        if data then
            local ip = string.match(data, GET_IP_REGEXP or "(%d+%.%d+%.%d+%.%d+)")
            if ip then
                callback(ip)
                return
            end
        end
        callback()
    end

    return gg.Http:Get(GET_IP_URL or "http://2017.ip138.com/ic.asp", getIpCallback)
end

-- 获取的奖品
function Dapi:LotterIndex( expend, callback )
    local url = getUserApi_("/lottery/index")
    local data = { expend=expend }
    sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
end

-- 获取抽奖奖品列表
function Dapi:LotterLoad( callback )
    local url = getUserApi_("/lottery/load")
    local data = {}
    sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
end

-- 新版本获取抽奖的奖品
function Dapi:NewLotterIndex( lottoType, expendProp, expendCnt, callback )
    local url = getUserApi_("/newLottery/index")
    local data = {consume = expendProp, expend = expendCnt, type=lottoType}
    sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
end

-- 新版本获取抽奖奖品列表
function Dapi:NewLotterLoad( lottoType, callback )
    local url = getUserApi_("/newLottery/load")
    local data = {type=lottoType}
    sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
end

-- 获取抽奖记录
function Dapi:NewLotteryRecord(lottoType, callback)
    local url = getUserApi_("/newLottery/roll")
    local data = {type = lottoType}
    sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
end

--使用记牌器
function Dapi:UseMemoryCard(callback)
    local url = getUserApi_("/task/useMemoryCard")
    local data = {}
    sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
end

-- 地区码
function Dapi:UserRegion( regioncode, callback )
    local url = getUserApi_("/user/region")
    local data = { data = regioncode }
    sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
end

--获取电视赛排行  -- 请求参数type  1周排行，2月排行，3年排行
function Dapi:getRankingList(type,  callback)
    local url = getUserApi_("/tvAudition/rankingList")
    local data = { type = type }
    sendRequest_(METHOD_POST, url, errorhandler_(callback), data, true)
end

-- 上传比赛资料  
-- 请求参数 real_name 姓名; real_phone 电话; id_card 身份证; province 省份; address 城市
function Dapi:UploadUserTvData(userInfo, callback)
    local url = getUserApi_("/user/tvEnroll")
    local data = {}
    data.real_name = userInfo[1]
    data.real_phone = userInfo[2]
    data.id_card = userInfo[3]
    data.province = userInfo[4]
    data.address = userInfo[5]
    data.tvid = userInfo[6]
    sendRequest_(METHOD_POST, url, errorhandler_(callback), data, true)
end

-- type (int) 1:英雄榜 2:红包榜 3:话费榜 4:豆榜
-- page (int) 第几页
-- pageSize (int) 分页的大小
function Dapi:RankList(type, page, pageSize, callback)
    local url = getUserApi_("/rank/list")
    local data = { type = type, page = page, pageSize = pageSize }
    sendRequest_(METHOD_POST, url, errorhandler_(callback), data, true)
end

-- type (int) 日擂台赛，周擂台赛，名人堂，
-- tag (int) 时间段 和 日期
function Dapi:Rank2NumList(type, tag,prize_num, callback)
    local url = getUserApi_("/rank2/numlist")
    local data = {type = type, tag = tag,prize_num = prize_num}
    sendRequest_(METHOD_POST, url, errorhandler_(callback), data, true)
end

-- Type (int) 1日擂台，2周擂台
function Dapi:Rank2prize( type, callback)
    local url = getUserApi_("/rank2/prize")
    local data = {type = type }
    sendRequest_(METHOD_POST, url, errorhandler_(callback), data, true)
end
-- 获取奖励道具
function Dapi:Rank2GetReward(callback)
    local url = getUserApi_("/rank2/getreward")
    local data = {}
    sendRequest_(METHOD_POST, url, errorhandler_(callback), data, true)
end
--[[
* @brief 拉取用户初始化数据
]]
function Dapi:NewUserInit(callback)
    local url = getUserApi_("/user/newinit", true)
    local data = {ver = 3}
    if hallmanager then
        -- 上传玩家的游戏总局数
        local gameCount = checkint(hallmanager:GetEffortData(EffortData.TOTAL_GAME_COUNT))
        data.gcount = gameCount
    end
    sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
end

--[[
* @brief 获取 Agora 门禁卡
]]
function Dapi:GetAgoraChannelKey(from, channelName, uid, callback)
    local url = getUserApi_("/channelKey/makechannelkey")

    local data = { from = from, channelName = channelName, uid = uid }
    sendRequest_(METHOD_POST, url, errorhandler_(callback), data, true)
end

function Dapi:refreshAppInfo()
    app_id_ = "/" .. APP_ID
    channel_id_ = "/" .. CHANNEL_ID
end

-- 获取分享信息界面
function Dapi:ShareLoad(callback)
    local url = getUserApi_("/share/load")
    sendRequest_(METHOD_POST, url, errorhandler_(callback), "", true)
end

--[[
* @brief 分享领取接口
* @parm id 领取的任务id
* @parm val 当前进行的任务等级
* @parm index
]]
function Dapi:ShareTaskAward(id, val, index, wx_id, domain, share_id, callback)
    if checkvalues_(id) then
        local url = getUserApi_("/task/award")
        local data = {id = id, index = index, val = val, wx_id = wx_id, domain = domain, share_id = share_id}
        if hallmanager then
            -- 上传玩家的游戏总局数
            local gameCount = checkint(hallmanager:GetEffortData(EffortData.TOTAL_GAME_COUNT))
            data.gcount = gameCount
        end
        sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
    end
end

--[[
* @brief 迎新红包领取签到接口
]]
function Dapi:OpenNewUserGift(callback)
    local url = getUserApi_("/signin/receive")
    local data = {}
    sendRequest_(METHOD_POST, url, errorhandler_(callback), data, true)
end

--礼品分类的兑换
function Dapi:SendGiftGoodID(callback)
    --BreakPoint()
    local url = getUserApi_("/mall/goodlist")
    local data = {}
    sendRequest_(METHOD_POST, url, errorhandler_(callback), data, true)
end

--礼品分类的商品购买详情请求
function Dapi:SendGoodInfo(id,category_id,callback)
    --BreakPoint()
    local url = getUserApi_("/mall/good")
    local data = {id = id,category_id = category_id}
    sendRequest_(METHOD_POST, url, errorhandler_(callback), data, true)
end

--礼品兑换记录
function Dapi:SendGoodOrders(callback)
    --BreakPoint()
    local url = getUserApi_("/mall/orders")
    local data = {}
    sendRequest_(METHOD_POST, url, errorhandler_(callback), data, true)
end

--礼品兑换 goodID,goodType,goodBuyNumber,BuyName,BuyPhone,diqu,select
function Dapi:SendBuyGiftGood(id, type,number,name,phone,region,select,callback)
   local url = getUserApi_("/mall/create")
   local data = {id = id, type = type,number = number,name = name ,phone = phone,region  = region ,addr = select,verify_phone = select}
   sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
end

--[[
* @brief 获取分享任务信息
]]--
function Dapi:GetShareTaskInfo(callback)
    local url = getUserApi_("/task/config")
    local data = { ["ver"] = 1 }
    sendRequest_(METHOD_POST, url, errorhandler_(callback), data, true)
end


--[[
* @brief 修改昵称新接口
* @parm nickname (string)-- 昵称
]]
function Dapi:ChangeNickName(nickname, callback)
    local url = getUserApi_("/user/changename")
    local data = { nickname = nickname }
    sendRequest_(METHOD_POST,url, errorhandler_(callback), data, true)
end

-- 获取用户荣誉值排名
function Dapi:HonorRank(callback)
    local url = getUserApi_("/HonorList/ranking")
    sendRequest_(METHOD_POST, url, errorhandler_(callback), nil, true)
end

-- 获取荣誉排名榜数据
function Dapi:HonorList(region, callback)
    local url = getUserApi_("/HonorList/list")
    local data = {code = region}
    sendRequest_(METHOD_POST, url, errorhandler_(callback), data, true)
end

-- 点赞
function Dapi:HonorLight(userid, callback)
    local url = getUserApi_("/HonorList/light")
    local data = {to_userid = userid}
    sendRequest_(METHOD_POST, url, errorhandler_(callback), data, true)
end

-- 获取用户的省排名
function Dapi:HonorProRank(callback)
    local url = getUserApi_("/HonorList/prorank")
    sendRequest_(METHOD_POST, url, errorhandler_(callback), nil, true)
end

-- 获取往期奖池活动排行榜
function Dapi:BonusPoolPastRankInfoList(tag,callback)
    local url = getUserApi_("/rank/oldrand")
    local data = {type = tag}
    sendRequest_(METHOD_POST, url, errorhandler_(callback), data, true)
end

-- 获取奖池活动排行榜
function Dapi:BonusPoolRankInfoList(tag,callback)
    local url = getUserApi_("/rank/jackpotrank")
    local data = {type = tag}
    sendRequest_(METHOD_POST, url, errorhandler_(callback), data, true)
end

-- 获取活动规则
function Dapi:ActivityRuleInfoList(tag,callback)
    local url = getUserApi_("/rank/getRule")
    local data = {type = tag}
    sendRequest_(METHOD_POST, url, errorhandler_(callback), data, true)
end

-- 获取实时奖池
function Dapi:BonusPoolCoinNum(tag,callback)
    local url = getUserApi_("/rank/jcsum")
    local data = {type = tag}
    sendRequest_(METHOD_POST, url, errorhandler_(callback), data, true)
end

-- 拉取web端的cfg_game配置数据
function Dapi:GetAppGameCfg(callback)
    local ver_str = gg.GetHallVerison()
    local url = string.format("https://region.weile.com/%s/%s/%s?code=%s", APP_ID, CHANNEL_ID, ver_str, getRegion_())
    return gg.Http:Get(url, errorhandler_(callback))
end