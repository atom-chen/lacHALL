--
-- Author: lee
-- Date: 2017-01-01 14:15:03
local CURRENT_MODULE_NAME=...
local ModuleName="WXLogin"

local superok,ImplClass= pcall( function() return  import(string.format(".%s_%s",ModuleName,string.upper(device.platform)), CURRENT_MODULE_NAME) end)

if not superok then
   -- printf("WXLogin super init failed :"..ImplClass)
    ImplClass=nil
end
local WXLogin=class(ModuleName,ImplClass)

function WXLogin:ctor(onlogincallback)
    self.providers_=nil
    self.onlogincallback_=onlogincallback
end

function WXLogin:invokeCallback(errcode,...)
    if  self.onlogincallback_ then
        self.onlogincallback_(errcode,...)
    end
end

function WXLogin:callWXAuth(onauthcallback)
    local args={appid=WX_APP_ID_LOGIN,state="wxlogin"}
    if not self.doAuthByWX then
         printf(device.platform.." 平台未支持。")
         GameApp:dispatchEvent(gg.Event.SHOW_LOADING)
         GameApp:dispatchEvent(gg.Event.SHOW_TOAST,device.platform.." 平台授权未支持")
        return
    end
    self:doAuthByWX(args)
    self.onauthcallback_=onauthcallback
end

--调用微信登录
function WXLogin:doLoginByWX(forceAuth)
    if device.platform=="windows" or device.platform=="mac"  then
        -- warming:windows 暂时利用游客登录功能
        -- gg.LoginHelper:LoginByVistor()
        -- return
    end
    local roleInfo,idx = gg.Cookies:GetDefRole(USER_FROM_WECHAT)
    if not forceAuth and roleInfo and roleInfo.username then
        if not (GameApp:IsReconnecting()) then
            GameApp:dispatchEvent(gg.Event.SHOW_LOADING, "正在登录...")
        end
        printf("openid=== ".. checkstring(tostring(roleInfo.username)))
        gg.Dapi:LoginByWechat(WX_APP_ID_LOGIN,nil,roleInfo.username,handler(self, self.onLoginResp))
    else
       GameApp:dispatchEvent(gg.Event.SHOW_LOADING, "正在拉起微信...",3)
       self:callWXAuth()
    end
end

function WXLogin:onWXAuthResp(errcode,authcode,type)
    if self.onauthcallback_ then
        printf(" WXLogin:onWXAuthResp_"..json.encode({errcode,authcode,type}))
        local ok,dt= pcall(self.onauthcallback_,errcode,authcode,type)
        if not ok then
            printf("onWXAuthResp err: "..tostring(dt))
            GameApp:dispatchEvent(gg.Event.SHOW_TOAST,"回调失败,请重试！")
        end
        return
    end
    if errcode == 0 then
        printf("wxcode= "..authcode)
        if not (GameApp:IsReconnecting()) then
            GameApp:dispatchEvent(gg.Event.SHOW_LOADING, "正在登录中...")
        end
        gg.Dapi:LoginByWechat(WX_APP_ID_LOGIN,authcode,nil,handler(self, self.onLoginResp))
    else
        GameApp:dispatchEvent(gg.Event.SHOW_LOADING)
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, string.format("微信授权失败（错误码：%s）", tostring(errcode)))
        printf("WXLogin onWXAuthResp  errcode:%s ",tostring(errcode))
        if GameApp:IsReconnecting() then
            GameApp:dispatchEvent(gg.Event.NETWORK_ERROR,NET_ERR_TAG_LOGIN,-9)
        end
        self:invokeCallback(-2)
    end
end

function WXLogin:checkLoginData(data)
    data.status= checknumber(data.status,nil,-1)
    if data.status ~=0 then --微信授权失败或过期
        if  data.status == 1 or data.status==API_ERR_CODE.WXAuthFailed  then
            -- status 为 1 表示账号不存在了
            self:callWXAuth()
        elseif not GameApp:IsReconnecting() then
            local msg = data.msg or GameApp:getLoginFailedMsg(data.status)
            GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG, msg or string.format("连接到登录服务器失败(错误码:%d)", data.status), function(bt)
                if gg.MessageDialog.EVENT_TYPE_OK == bt then
                    self:doLoginByWX() --GameApp:CreateLoginManager(true)
                elseif gg.MessageDialog.EVENT_TYPE_CANCEL==bt then
                    GameApp:CreateLoginManager()
                end
            end,{ mode=gg.MessageDialog.MODE_OK_CANCEL, name="connect_failed_dialog", backdisable=true,  cancel="返回登录", ok="重试" })
        else
            GameApp:dispatchEvent(gg.Event.NETWORK_ERROR,NET_ERR_TAG_LOGIN,-8)
        end
        return false
    end
   return true
end

-- result (int)-- 游戏第三方登录服务器返回的状态码
-- msg (string)-- 游戏第三方登录服务器的提示信息
-- id (int)-- 用户ID
-- hallid (int)-- 登录的大厅ID
-- ip (int)-- 整形IP地址
-- port (int)-- 端口
-- code (string)-- 游戏第三方登录服务器返回的session
-- openid (string)-- 微信用户与当前包对应的openid,需在二次登录时传给web接口

function WXLogin:onLoginResp(data)
    data = checktable(data)
    GameApp:dispatchEvent(gg.Event.SHOW_LOADING)
    if not self:checkLoginData(data) then
        printf("onLoginResp failed")
        self:invokeCallback(-1)
        return
    end
    local userid = data.id
    local role, idx = gg.Cookies:GetRoleById(userid)
    local cookiedata = { id = userid, username = data.openid, pwd = "", userfrom = USER_FROM_WECHAT }
    if idx then
        gg.Cookies:UpdateUserData(cookiedata, idx)
    elseif cookiedata.id and cookiedata.username then
        gg.Cookies:AddUserData(cookiedata)
    end
    self:invokeCallback(0, data.code, userid, data.url or data.ip, data.port)
end

return WXLogin
