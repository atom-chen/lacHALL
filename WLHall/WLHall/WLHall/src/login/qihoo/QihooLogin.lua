--
-- Author: lee
-- Date: 2017-01-01 14:15:03
local CURRENT_MODULE_NAME=...
local ModuleName="QihooLogin"

local superok,ImplClass= pcall( function() return  import(string.format(".%s_%s",ModuleName,string.upper(device.platform)), CURRENT_MODULE_NAME) end)

if not superok then
    -- printf("QihooLogin super init failed :"..ImplClass)
    ImplClass=nil
end
local QihooLogin=class(ModuleName,ImplClass)

function QihooLogin:ctor(onlogincallback)
    self.onlogincallback_=onlogincallback
end

function QihooLogin:invokeCallback(errcode,...)
    if self.onlogincallback_ then
        self.onlogincallback_(errcode,...)
    end
end

function QihooLogin:callAuth(args, onauthcallback)
    if not self.doAuth then
         GameApp:dispatchEvent(gg.Event.SHOW_LOADING)
         GameApp:dispatchEvent(gg.Event.SHOW_TOAST,device.platform.." 平台授权未支持")
        return
    end
    self:doAuth(args)
    self.onauthcallback_=onauthcallback
end

--调用登录
function QihooLogin:doLogin(switch)
    GameApp:dispatchEvent(gg.Event.SHOW_LOADING, "正在拉起 360 登录...", 3)
    self:callAuth({switch = switch})
end

function QihooLogin:onAuthResp(args)
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

        local data ={type = "Login360", access_token=args.access_token}
        gg.Dapi:loginByThirdParty(data, handler(self, self.onLoginResp))
    else
        GameApp:dispatchEvent(gg.Event.SHOW_LOADING)
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST,"授权失败!")
        printf("QihooLogin onAuthResp errcode:%s ",tostring(args.errcode))
        if GameApp:IsReconnecting() then
            GameApp:dispatchEvent(gg.Event.NETWORK_ERROR, NET_ERR_TAG_LOGIN, -9)
        end
        self:invokeCallback(-2)
    end
end

function QihooLogin:checkLoginData(data)
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
                    self:doLogin(true)
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

function QihooLogin:onLoginResp(data)
    printf("QihooLogin onLoginResp %s",json.encode(checktable(data)))
    data = checktable(data)
    GameApp:dispatchEvent(gg.Event.SHOW_LOADING)
    if not self:checkLoginData(data) then
        printf("onLoginResp failed")
        self:invokeCallback(-1)
        return
    end
    local userid = data.id
    local role, idx = gg.Cookies:GetRoleById(userid)
    local cookiedata = { id = userid, userfrom = USER_FROM_QIHOO }
    if idx then
        gg.Cookies:UpdateUserData(cookiedata, idx)
    elseif cookiedata.id then
        gg.Cookies:AddUserData(cookiedata)
    end
    self:invokeCallback(0, data.code, userid, data.url or data.ip, data.port)
end

return QihooLogin
