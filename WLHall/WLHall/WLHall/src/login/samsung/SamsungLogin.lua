local CURRENT_MODULE_NAME=...
local ModuleName="SamsungLogin"

local superok,ImplClass= pcall( function() return  import(string.format(".%s_%s",ModuleName,string.upper(device.platform)), CURRENT_MODULE_NAME) end)

if not superok then
    -- printf("SamsungLogin super init failed :"..ImplClass)
    ImplClass=nil
end
local SamsungLogin=class(ModuleName,ImplClass)

function SamsungLogin:ctor(onlogincallback)
    self.onlogincallback_= onlogincallback
end

function SamsungLogin:invokeCallback(errcode,...)
    if self.onlogincallback_ then
        -- print("SamsungLogin login callback ======errcode ===="..errcode)
        self.onlogincallback_(errcode,...)
    end
end

function SamsungLogin:callAuth(args, onauthcallback)
    if not self.doAuth then
         GameApp:dispatchEvent(gg.Event.SHOW_LOADING)
         GameApp:dispatchEvent(gg.Event.SHOW_TOAST,device.platform.." 平台授权未支持")
        return
    end

    -- 从服务器获取私钥
    local ret = gg.Dapi:getSamsungPrivateKey(function ( code, data )
        if code and checkint(code) ~= 200 then
            printf("Get samsung private key err: %s  %s", tostring(code), tostring(data))
            return
        end

        local ok, datatable = pcall(function() return loadstring(data)(); end)
        if ok and checkint(datatable.status) == 0 and datatable.data then
            local params = checktable(args)
            params.privatekey = datatable.data
            self:doAuth(params)
            self.onauthcallback_=onauthcallback
        else
            printf("samsung private key callback data error==="..tostring(data))
        end
    end)

    
end

--调用登录
function SamsungLogin:doLogin()
    GameApp:dispatchEvent(gg.Event.SHOW_LOADING, "正在拉起登录...", 3)
    self:callAuth()
end

function SamsungLogin:onAuthResp(args)
    if self.onauthcallback_ then
        local ok, dt= pcall(self.onauthcallback_, args)
        if not ok then
            printf("onAuthResp err: "..tostring(dt))
            GameApp:dispatchEvent(gg.Event.SHOW_TOAST,"回调失败,请重试！")
        end
        return
    end
    if args.errcode == 0 then
        if not (GameApp:IsReconnecting()) then
            GameApp:dispatchEvent(gg.Event.SHOW_LOADING, "正在登录中...")
        end
        local data = {type = "samsung", is_newsx = 1, token = args.signValue}
        gg.Dapi:loginByThirdParty(data, handler(self, self.onLoginResp))
    else
        GameApp:dispatchEvent(gg.Event.SHOW_LOADING)
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST,"登录失败!")
        printf("SamsungLogin onAuthResp errcode:%s ",tostring(args.errcode))
        if GameApp:IsReconnecting() then
            GameApp:dispatchEvent(gg.Event.NETWORK_ERROR, NET_ERR_TAG_LOGIN, -9)
        end
        self:invokeCallback(-2)
    end
end

function SamsungLogin:checkLoginData(data)
    data.status = checknumber(data.status, nil, -1)
    if data.status ~= 0 then
        if not GameApp:IsReconnecting() then
            local tipStr
            if data.msg and #(data.msg) > 0 then
                -- 有错误信息，显示之
                tipStr = data.msg
            else
                tipStr = GameApp:getLoginFailedMsg(data.status) or string.format("连接到登录服务器失败(错误码:%d)", data.status)
            end
            GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG, tipStr, function(bt)
                if gg.MessageDialog.EVENT_TYPE_OK == bt then
                    self:doLogin()
                elseif gg.MessageDialog.EVENT_TYPE_CANCEL == bt then
                    GameApp:CreateLoginManager()
                end
            end,{ mode=gg.MessageDialog.MODE_OK_CANCEL, name="connect_failed_dialog", backdisable=true,  cancel="返回登录", ok="重试" })
        else
            GameApp:dispatchEvent(gg.Event.NETWORK_ERROR,NET_ERR_TAG_LOGIN, -8)
        end
        return false
    end
    return true
end

-- id (int)-- 用户ID
-- hallid (int)-- 登录的大厅ID
-- ip (int)-- 整形IP地址
-- port (int)-- 端口
-- code (string)-- 游戏第三方登录服务器返回的session
-- openid (string)-- 微信用户与当前包对应的openid,需在二次登录时传给web接口

function SamsungLogin:onLoginResp(data)
    printf("SamsungLogin onLoginResp %s",json.encode(checktable(data)))
    data = checktable(data)
    GameApp:dispatchEvent(gg.Event.SHOW_LOADING)
    if not self:checkLoginData(data) then
        printf("onLoginResp failed")
        self:invokeCallback(-1)
        return
    end
    local userid = data.id
    local role, idx = gg.Cookies:GetRoleById(userid)
    local cookiedata = { id = userid, userfrom = USER_FROM_SAMSUNG }
    if idx then
        gg.Cookies:UpdateUserData(cookiedata, idx)
    elseif cookiedata.id then
        gg.Cookies:AddUserData(cookiedata)
    end
    self:invokeCallback(0, data.code, userid, data.url or data.ip, data.port)
end

return SamsungLogin
