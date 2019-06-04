--
-- Author: lee
-- Date: 2017-03-26 15:55:22
--
local M={}

M.loginTypes = {
    ["201"] = {USER_FROM_QIHOO, USER_FROM_QIHOO + 1000},      -- 奇虎360
    ["205"] = {USER_FROM_XIAOMI},                             -- 小米
    ["216"] = {USER_FROM_VIVO},                               -- VIVO
    ["207"] = {USER_FROM_OPPO},                               -- OPPO
    ["210"] = {USER_FROM_YSDK_QQ, USER_FROM_YSDK_WX},         -- 应用宝
    ["224"] = {USER_FROM_HUAWEI},                             -- 华为
    ["228"] = {USER_FROM_TOUTIAO},                            -- 头条
    ["229"] = {USER_FROM_MEIZU},                              -- 魅族
    ["230"] = {USER_FROM_SAMSUNG}                             -- 三星        
}

local function callbackhandler_(callback,onconnectedhallcallback)
	assert( not callback or type(callback)=="function", "检查回调函数")
	return function(errcode,session, userid, serverip, serverport)
		if errcode and checkint(errcode)==0 then
			repeat
				 if not ( session or userid or serverip or serverport) then
				 	 errcode=-3
				 	 break;
				 end
				--连接大厅服务器
			    errcode= gg.IIF(GameApp:CreateHallManager(session, userid, serverip, serverport,onconnectedhallcallback ),0,-2)
		    until true
		end
		if callback and type(callback)=="function" then
			callback(errcode,session, userid, serverip, serverport)
		end
	end
end

function M:IsSupportLogin(type)
    local supportTypes = self.loginTypes[CHANNEL_ID]
    if not supportTypes then
        return false
    end

    for i, v in ipairs(supportTypes) do
        if v == type then
            return true
        end
    end

    return false
end

function M:CanAutoLogin()
    local roleInfo = gg.Cookies:GetDefRole()
    local from= BRAND==0 and USER_FROM_JIXIANG or USER_FROM_PLATFORM
    if roleInfo.userfrom == from or roleInfo.userfrom == USER_FROM_UNLOGIN or roleInfo.userfrom == USER_FROM_WECHAT then
        -- 游客或者自己的用户或者微信用户，可以自动登录
        return true
    end

    return self:IsSupportLogin(roleInfo.userfrom)
end

-- 自动登录
function M:DoAutoLogin(onlogincallback,onconnectedhallcallback)
    local roleInfo = checktable(gg.Cookies:GetDefRole())
    local from= BRAND==0 and USER_FROM_JIXIANG or USER_FROM_PLATFORM
    if roleInfo.userfrom == USER_FROM_UNLOGIN then
        self:LoginByVistor(onlogincallback,onconnectedhallcallback)
    elseif roleInfo.userfrom == USER_FROM_WECHAT then
        self:LoginByWX(false, onlogincallback,onconnectedhallcallback)
    elseif roleInfo.userfrom == USER_FROM_YSDK_WX and self:IsSupportLogin(USER_FROM_YSDK_WX) then
        self:LoginByYSDKWX(false, onlogincallback)
    elseif roleInfo.userfrom == USER_FROM_YSDK_QQ and self:IsSupportLogin(USER_FROM_YSDK_QQ) then
        self:LoginByYSDKQQ(onlogincallback)
    elseif roleInfo.userfrom == USER_FROM_HUAWEI and self:IsSupportLogin(USER_FROM_HUAWEI) then
        self:LoginByHuawei(onlogincallback)
    elseif roleInfo.userfrom == USER_FROM_VIVO and self:IsSupportLogin(USER_FROM_VIVO) then
        self:LoginByVivo(onlogincallback)
    elseif roleInfo.userfrom == USER_FROM_OPPO and self:IsSupportLogin(USER_FROM_OPPO) then
        self:LoginByOppo(onlogincallback)
    elseif roleInfo.userfrom == USER_FROM_XIAOMI and self:IsSupportLogin(USER_FROM_XIAOMI) then
        self:LoginByXiaomi(onlogincallback)
    elseif roleInfo.userfrom == USER_FROM_QIHOO and self:IsSupportLogin(USER_FROM_QIHOO) then
        self:onQihooLogin(onlogincallback)
    elseif roleInfo.userfrom == USER_FROM_TOUTIAO and self:IsSupportLogin(USER_FROM_TOUTIAO) then
        self:onToutiaoLogin(onlogincallback)
    elseif roleInfo.userfrom == USER_FROM_MEIZU and self:IsSupportLogin(USER_FROM_MEIZU) then
        self:onMeizuLogin(onlogincallback)
    elseif roleInfo.userfrom == USER_FROM_SAMSUNG and self:IsSupportLogin(USER_FROM_SAMSUNG) then
        self:onSamsungLogin(onlogincallback)
    elseif roleInfo.userfrom == from then
        self:LoginByName(roleInfo.username, roleInfo.pwd,onlogincallback,onconnectedhallcallback)
    else
        GameApp:dispatchDelayEvent(gg.Event.SHOW_TOAST,0, "不支持上一次记录的登录方式")
    end
end

-- 仅供渠道账号登出使用
function M:DoLogout()
    local roleInfo = gg.Cookies:GetDefRole()
    if roleInfo and roleInfo.userfrom == USER_FROM_TOUTIAO then
        self:onToutiaoLogout()
    end
end

function M:LoginByWX(forceAuth, onlogincallback,onconnectedhallcallback)
	cc.load("WXLogin").new(callbackhandler_(onlogincallback,onconnectedhallcallback)):doLoginByWX(forceAuth)
end

function M:LoginByVistor(onlogincallback,onconnectedhallcallback)
	cc.load("LoginManager"):getInstance(callbackhandler_(onlogincallback,onconnectedhallcallback)):LoginByVistor()
end

function M:LoginByName(username,password,onlogincallback,onconnectedhallcallback)
	cc.load("LoginManager"):getInstance(callbackhandler_(onlogincallback,onconnectedhallcallback)):LoginByName(username,password)
end

-- 应用宝微信登录
function M:LoginByYSDKWX(forceAuth, onlogincallback)
    cc.load("YSDKLogin").new(callbackhandler_(onlogincallback)):doLogin("wechat", forceAuth)
end

-- 应用宝QQ登录
function M:LoginByYSDKQQ(forceAuth, onlogincallback)
    cc.load("YSDKLogin").new(callbackhandler_(onlogincallback)):doLogin("qq", forceAuth)
end

function M:LoginByHuawei(onlogincallback)
    cc.load("HWLogin").new(callbackhandler_(onlogincallback)):doLogin()
end

function M:LoginByVivo(onlogincallback)
    cc.load("VivoLogin").new(callbackhandler_(onlogincallback)):doLogin()
end

function M:LoginByOppo(onlogincallback)
    cc.load("OppoLogin").new(callbackhandler_(onlogincallback)):doLogin()
end

function M:LoginByXiaomi(onlogincallback)
    cc.load("XiaomiLogin").new(callbackhandler_(onlogincallback)):doLogin()
end

-- 奇虎360登陆
function M:onQihooLogin(onlogincallback)
    cc.load("QihooLogin").new(callbackhandler_(onlogincallback)):doLogin(false)
end

-- 奇虎360切换账号
function M:onQihooSwitch(onlogincallback)
    cc.load("QihooLogin").new(callbackhandler_(onlogincallback)):doLogin(true)
end

-- 头条登录
function M:onToutiaoLogin(onlogincallback)
    cc.load("ToutiaoLogin").new(callbackhandler_(onlogincallback)):doLogin()
end

-- 头条登出
function M:onToutiaoLogout()
    cc.load("ToutiaoLogin").new():doLogout()
end

function M:onMeizuLogin()
    cc.load("MeizuLogin").new(callbackhandler_(onlogincallback)):doLogin()
end

-- 三星登录
function M:onSamsungLogin(onlogincallback)
    cc.load("SamsungLogin").new(callbackhandler_(onlogincallback)):doLogin()
end

return M