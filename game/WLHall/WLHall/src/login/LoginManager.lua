local e = import(".LoginEvent")

local LoginManager = ClassEx("LoginManager", function()
    local obj = CLoginManager.New()
    obj.event = e;
    obj.http=require("common.HttpProxyHelper").new():RegisterHttpProxyEvent(obj)
    return obj;
end)

function LoginManager:ctor(onlogincallback)
    self.loginData_ = {}
    self.lastServerIdx_ = 1
    self.onlogincallback_=onlogincallback
end

function LoginManager:invokeCallback(errcode,...)
    if self.onlogincallback_ then
        self.onlogincallback_(errcode,...)
        return true
    elseif errcode ==0 then
        GameApp:CreateHallManager(...)
    end
    return false
end

--登录管理器创建函数
function LoginManager:getInstance(onlogincallback)
    if loginmanager ~= nil then
        loginmanager.onlogincallback_=onlogincallback
        return loginmanager
    end
    local mgr = LoginManager.new(onlogincallback)
    if mgr:Initialize() then
        rawset(_G, "loginmanager", mgr)
        return loginmanager
    else
        mgr:Shutdown()
    end
end
--销毁管理器
function LoginManager:dealloc()
    printf("LoginManager:dealloc()")
    self:Shutdown()
    self.onlogincallback_=nil
    rawset(_G, "loginmanager", nil)
end

function LoginManager:init()
    self.lastServerIdx_ = checkint( gg.LocalConfig:GetLastLoginServerIdx())
    if  self.lastServerIdx_ > #LOGIN_SERVER_LIST then
        self.lastServerIdx_ = 1;
        gg.LocalConfig:SetLastLoginServerIdx(self.lastServerIdx_)
    end
    return true
end

--开始尝试连接到登陆服务器
function LoginManager:StartConnect(connectcallback)
    self.connectcallback=connectcallback
    local serverInfo = LOGIN_SERVER_LIST[self.lastServerIdx_ or 1];
    if serverInfo and serverInfo.url and #(serverInfo.url) > 0 then
        if  not self:Reconnect(serverInfo.url, serverInfo.port) then
            -- self:OnLoginError("连接登录服务器失败,请检查网络连接",-3)
        end
    else
        self:OnLoginError("登录失败（错误码:-5）",-5)
    end
    return self
end

function LoginManager:OnConnectReply(bOK,errcode)
    if self.connectcallback then
        self.connectcallback(self,bOK,errcode)
        return
    end
    if not bOK then
        self:OnLoginError("版本检查失败",errcode);
        return
    end
    local ld = checktable(self.loginData_)
    if ld.logintype == LOGIN_TYPE_BY_NAME then
        self:DispatchLoginByName(IS_WEILE, ld.username, ld.pwd);
    elseif ld.logintype == LOGIN_TYPE_BY_UNNAME then
        self:DispatchLoginByUnName(IS_WEILE, ld.username);
    elseif ld.logintype == LOGIN_TYPE_ALLOC_USER then
        local nickName = ld.nick or Helper.GetDeviceUserName();
        -- ios审核模式下游客登录的名字显示为mobileuser
        if device.platform == "ios" and IS_REVIEW_MODE then
            nickName = "mobileuser" .. math.random(1, 100)
        end
        self:DispatchAllocUser(nickName, 1, IS_WEILE, APP_ID, CHANNEL_ID);
    end
end

function LoginManager:GenLoginData(params)
    self.loginData_ = checktable(self.loginData_)
    table.merge(self.loginData_, params)
end

--[[
* @brief 使用游客账号登陆
]]
function LoginManager:LoginByVistor()
    local vistor, idx = gg.Cookies:GetVistorInfo()
    local data = { pwd = "" }
    --生成游客昵称
    local function getVistorNickName_()
        if IS_REVIEW_MODE then
            return "mobileuser-"..tostring(math.random(100))
        else
            return Helper.GetDeviceUserName()  or "mobile.."
        end
    end
    if vistor then
        data.logintype = LOGIN_TYPE_BY_UNNAME
        data.username = vistor.username
    else
        -- 没游客账号（分配）
        data.logintype = LOGIN_TYPE_ALLOC_USER
        data.nick =  getVistorNickName_()
    end
    self:GenLoginData(data)
    self:StartConnect()
    return self
end

--[[
* @brief 使用用户名登陆
* @param [in] userName 用户名
* @param [in] pwd 密码
* @return 成功返回true
--]]
function LoginManager:LoginByName(userName, pwd)
    local nLen = #checkstring(userName)
     if nLen < 2 or nLen > 16 then
        GameApp:dispatchEvent(gg.Event.SHOW_LOADING )
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST,"用户名验证失败" )
        return false;
    end
    nLen = #checkstring(pwd)
    if nLen == 0 or nLen > 128 then
        GameApp:dispatchEvent(gg.Event.SHOW_LOADING )
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST,"密码长度验证失败" )
        return false;
    end
    local data = { logintype = LOGIN_TYPE_BY_NAME, username = userName, pwd = pwd }
    self:GenLoginData(data)
    self:StartConnect();
    -- 入口2
    return true;
end


--登陆失败提示
function LoginManager:OnLoginError(strMsg,errcode,noRetry)
    if self.connectcallback then
        self.connectcallback(self,false,errcode)
        return
    end
    self:invokeCallback(errcode or -1)
    GameApp:dispatchEvent(gg.Event.SHOW_LOADING)
    if  errcode <-3 and not (GameApp:IsReconnecting())  then
        printf("LoginManager OnLoginError()"..tostring(strMsg)..tostring(errcode))

        local dlgMode = gg.MessageDialog.MODE_OK_CANCEL
        local okStr = "重试"
        if noRetry then
            -- 没有重试的话，只留一个确定按钮
            dlgMode = gg.MessageDialog.MODE_OK_ONLY
            okStr = "确定"
        end

        GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG, strMsg, function(bt)
            if gg.MessageDialog.EVENT_TYPE_OK == bt then
                if not noRetry then
                    -- 需要重试
                    GameApp:dispatchEvent(gg.Event.RETRY_LOGIN)
                end
            elseif gg.MessageDialog.EVENT_TYPE_CANCEL == bt then
                GameApp:CreateLoginManager(false)
            end
        end,{ mode=dlgMode, name="connect_failed_dialog", backdisable=true,  cancel="返回登录", ok=okStr })
    else
        GameApp:dispatchEvent(gg.Event.NETWORK_ERROR,NET_ERR_TAG_LOGIN,checkint(errcode))
    end
end

return LoginManager