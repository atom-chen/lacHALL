--
-- Author: lee
-- Date: 2017-01-01 14:15:03
local CURRENT_MODULE_NAME=...
local ModuleName="YSDKLogin"

local FROM_WX = "wechat"

local superok,ImplClass= pcall( function() return  import(string.format(".%s_%s",ModuleName,string.upper(device.platform)), CURRENT_MODULE_NAME) end)

if not superok then
    -- printf("YSDKLogin super init failed :"..ImplClass)
    ImplClass=nil
end
local YSDKLogin=class(ModuleName,ImplClass)

local loginFrom = nil

-- 登陆结果提示
YSDKLogin.LoginErrMsg = {
    [1001] = "取消QQ授权",
    [1002] = "登陆QQ失败",
    [1003] = "网络异常，请重试",
    [1004] = "请先安装QQ后再重试",
    [1005] = "请安装新版本QQ后再重试",
    [2000] = "请先安装微信后再重试",
    [2001] = "请安装新版本微信后再重试",
    [2002] = "取消微信授权",
    [2003] = "拒绝微信授权",
}

function YSDKLogin:ctor(onlogincallback)
    self.onlogincallback_=onlogincallback
end

function YSDKLogin:invokeCallback(errcode,...)
    if self.onlogincallback_ then
        self.onlogincallback_(errcode,...)
    end
end

function YSDKLogin:callAuth(args, onauthcallback)
    if not self.doAuth then
         GameApp:dispatchEvent(gg.Event.SHOW_LOADING)
         GameApp:dispatchEvent(gg.Event.SHOW_TOAST,device.platform.." 平台授权未支持")
        return
    end
    self:doAuth(args)
    self.onauthcallback_=onauthcallback
end

--调用登录
function YSDKLogin:doLogin(from, forceAuth)
    loginFrom = from
    local flatformName = gg.IIF(from == FROM_WX, "微信", "QQ")

    GameApp:dispatchEvent(gg.Event.SHOW_LOADING, "正在拉起" .. flatformName .. "...", 5, function ( ... )
        printf("微信、QQ拉起失败或没有回调")
        gg.Cookies:Logout()     -- 清除登录缓存
        self:onAuthResp({errcode = -1})
    end)
    self:callAuth({from = from, forceAuth = forceAuth})
end

function YSDKLogin:onAuthResp(args)
    if self.onauthcallback_ then
        local ok, dt= pcall(self.onauthcallback_, args)
        if not ok then
            printf("onAuthResp err: "..tostring(dt))
            GameApp:dispatchEvent(gg.Event.SHOW_LOADING)
            GameApp:dispatchEvent(gg.Event.SHOW_TOAST,"回调失败,请重试！")
        end
        return
    end
    if args.errcode == 0 then
        if not (GameApp:IsReconnecting()) then
            GameApp:dispatchEvent(gg.Event.SHOW_LOADING, "正在登录中...")
        end

        self.from = args.from
        local data ={from = args.from, type = "ysdk", sex = args.gender, openid = args.openid, nickname = args.nickname, avatar = args.avatar}
        gg.Dapi:loginByThirdParty(data, handler(self, self.onLoginResp))
    else
        GameApp:dispatchEvent(gg.Event.SHOW_LOADING)

        local msg = YSDKLogin.LoginErrMsg[args.errcode]
        msg = msg or "授权失败! (错误码: "..args.errcode..")"

        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, msg)
        printf("YSDKLogin onAuthResp errcode:%s ",tostring(args.errcode))
        if GameApp:IsReconnecting() then
            GameApp:dispatchEvent(gg.Event.NETWORK_ERROR, NET_ERR_TAG_LOGIN, -9)
        end
        self:invokeCallback(-2)
    end
end

function YSDKLogin:checkLoginData(data)
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
                    self:doLogin(loginFrom, true)
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

function YSDKLogin:onLoginResp(data)
    printf("YSDKLogin onLoginResp %s",json.encode(checktable(data)))
    data = checktable(data)
    GameApp:dispatchEvent(gg.Event.SHOW_LOADING)
    if not self:checkLoginData(data) then
        printf("onLoginResp failed")
        self:invokeCallback(-1)
        return
    end
    local userid = data.id
    local role, idx = gg.Cookies:GetRoleById(userid)
    local cookiedata = { id = userid, userfrom = gg.IIF(self.from == FROM_WX, USER_FROM_YSDK_WX, USER_FROM_YSDK_QQ) }
    if idx then
        gg.Cookies:UpdateUserData(cookiedata, idx)
    elseif cookiedata.id then
        gg.Cookies:AddUserData(cookiedata)
    end
    self:invokeCallback(0, data.code, userid, data.url or data.ip, data.port)
end

return YSDKLogin
