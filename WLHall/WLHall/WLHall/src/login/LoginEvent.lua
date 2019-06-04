local e = {}
local userdefault = cc.UserDefault:getInstance()

local nFirstTryServerIndex = 1; --//开始尝试登陆的第一个服务器索引

--//当前角色保存文件
local strRoleFile = device.writablePath .. "role.dat";
--//登陆管理器事件

--管理器初始化,返回true成功,否则失败
function e.Initialize(loginobj)
    local bret= loginobj:init()
    nFirstTryServerIndex = loginobj.lastServerIdx_ or 1;
    return bret;
end

function e.Shutdown(obj)
    if obj.http then
        obj.http:Shutdown()
    end
    obj.onlogincallback_=nil
end

--[[
* @brief 连接到登陆服务器结果
* @param [in] obj 产生事件的对象,这里是CLoginManager的对象
* @param [in] connected 是否连接成功
* @note 如果连接成功,则底层主动发送版本检测消息
]]
function e.OnConnect(obj, connected)
    if connected then
        printf("连接到服务器" .. tostring(obj.lastServerIdx_) .. "成功");
        gg.LocalConfig:SetLastLoginServerIdx(obj.lastServerIdx_)
        nFirstTryServerIndex = obj.lastServerIdx_;
    else
        GameApp:dispatchEvent(gg.Event.SHOW_LOADING)
        obj.lastServerIdx_ = obj.lastServerIdx_ + 1;
        if obj.lastServerIdx_ > #LOGIN_SERVER_LIST then
            obj.lastServerIdx_ = 1;
        end
        if nFirstTryServerIndex == obj.lastServerIdx_ then --//所有服务器全部尝试一遍
            obj:OnLoginError("连接到登录服务器失败！",-4);
        else
            local strp = string.format("正在连接服务器[%d],请稍后...", obj.lastServerIdx_)
            GameApp:dispatchEvent(gg.Event.SHOW_LOADING, strp)
            printf("连接到服务器" .. tostring(obj.lastServerIdx_ - 3) .. "失败,尝试下一组");
            local serverInfo = LOGIN_SERVER_LIST[obj.lastServerIdx_];
            obj:Reconnect(serverInfo.url, serverInfo.port);
        end
    end
end

--登陆服务器连接断开
function e.OnSocketClose(obj, nErrorCode)
    printf("OnSocketClose serverip= %s errcode: %s",tostring(LOGIN_SERVER_LIST[obj.lastServerIdx_].url ) ,tostring(nErrorCode))
    obj:OnLoginError("连接登录服务器失败,请检查网络状态!",checkint(nErrorCode));
end

--登陆服务器检测版本应答 发送登录请求
function e.OnCheckVersion(obj, bOK)
     obj:OnConnectReply(bOK,-7)
end

--[[
* @brief 登陆成功应答
* @param [in] obj 产生事件的对象,这里是CLoginManager的对象
* @param [in] session 连接大厅放服务器的会话ID
* @param [in] userid 用户ID
* @param [in] serverip 大厅服务器IP地址（整型）
* @param [in] serverport 大厅服务器端口
]]
function e.OnMsgLoginReply(obj, session, userid, serverip, serverport)
    local data = checktable(obj.loginData_)
    if data.logintype == LOGIN_TYPE_BY_NAME then
        local role, idx = gg.Cookies:GetRoleById(userid)
        if not idx then
            -- 因为旧版本升级时，没有 userid 数据。
            -- 所以通过 userid 无法找到数据的话，尝试使用 username 查找
            role, idx = gg.Cookies:GetRoleByUserName(data.username)
        end

        local cookiedata = { id = userid, username = data.username, pwd = data.pwd, userfrom = userfrom }
        if idx then
            gg.Cookies:UpdateUserData(cookiedata, idx)
        else
            local from= BRAND==0 and USER_FROM_JIXIANG or USER_FROM_PLATFORM
            cookiedata.userfrom = from
            gg.Cookies:AddUserData(cookiedata)
        end
    else
        gg.Cookies:SetAutoLoginRole(data.username)
    end
    obj:invokeCallback(0,session, userid, serverip, serverport)
end

--[[
* @brief 登陆失败
* @param [in] obj 产生事件的对象,这里是CLoginManager的对象
* @param [in] result 登陆失败原因
]]
function e.OnMsgLoginFailed(obj, result)
    local errMsg = GameApp:getLoginFailedMsg(result)
    if result == 1 and obj.loginData_.logintype == LOGIN_TYPE_BY_UNNAME then
        -- 如果游客登录遇到账号不存在，那么需要删除缓存的游客账号信息，并提示重试
        errMsg = "连接服务器失败，请重试！"
        local vistor, idx = gg.Cookies:GetVistorInfo()
        gg.Cookies:RemoveRole(idx)
    end

    -- 默认情况下，可以进行重试。而密码错误或者账号不存在时，不能重试
    local noRetry = false
    if result == 1 or result == 2 then
        noRetry = true
    end
    obj:OnLoginError(errMsg or "登录失败,未知错误,请与管理员联系", -6, noRetry)
end

--[[
* @brief 请求分配游客帐号应答
* @param [in] obj 产生事件的对象,这里是CLoginManager的对象
* @param [in] result 分配结果,为０为成功
* @param [in] session 游客会话id
]]
function e.OnMsgAllocRoleReply(obj, result, session)
    if result and result > 0 then
        GameApp:dispatchEvent(gg.Event.SHOW_LOADING)
        GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG, "游客登录失败,请稍后重试!（错误码："..result.."）")
    else
        gg.Cookies:AddVistorInfo(session, USER_FROM_UNLOGIN);
        obj:LoginByVistor();
    end
end

--[[
* @breif 登陆服务器附带消息
* @param [in] obj 产生事件的对象,这里是CLoginManager的对象
* @param [in] bUrl 消息内容是否是url
* @param [in] msg 如果bUrl是true,则msg为网址,应该用浏览器打开,否则是消息内容
]]
function e.OnMsgLoginMessage(obj, bUrl, msg)
    if bUrl then
        Helper.OpenBrowser(msg);
    else
        GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG, msg)
    end
end

return e