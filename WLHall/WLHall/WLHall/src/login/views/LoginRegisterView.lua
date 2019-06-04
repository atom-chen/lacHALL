-- Author: zhangbin
-- Date: 2017-08-16
-- Describe：注册界面

local LoginRegisterView = class("LoginRegisterView", cc.load("ViewPop"))

LoginRegisterView.RESOURCE_FILENAME = "ui/login/register_node.lua"
LoginRegisterView.RESOURCE_BINDING = {
    ["btn_register"] = { ["varname"] = "btn_register", ["events"] = { { event = "click", method = "onRegisterClicked" } } }, -- 找回密码
    ["btn_close"] = { ["varname"] = "btn_close", ["events"] = { { event = "click", method = "onClickClose" } } }, -- 关闭按钮

    ["txt_user_name"] = { ["varname"] = "txt_user_name" },
    ["txt_pwd"] = { ["varname"] = "txt_pwd" },
    ["txt_pwd2"] = { ["varname"] = "txt_pwd2" }
}

function LoginRegisterView:onCreate(loginmgr, ...)
    -- 初始化View
    self:initView()
end

--[[
* @brief 初始化View
]]
function LoginRegisterView:initView()
    self:initWinEditBox("txt_user_name" ,false , 16)
    self:initWinEditBox("txt_pwd" , true , 16)
    self:initWinEditBox("txt_pwd2" , true , 16)
end

function LoginRegisterView:onRegisterClicked(sender)
    -- 注册功能
    local strId = self.txt_user_name:getText()
    local strPsw = self.txt_pwd:getText()
    local strCfrPsw = self.txt_pwd2:getText()

    -- 字符长度
    local lenId = string.len( strId )
    local lenPsw = string.len( strPsw )
    -- 判断长度
    if lenId < 6 or lenId > 16 or lenPsw < 6 or lenPsw > 16 then
        -- GameApp:dispatchEvent( gg.Event.SHOW_MESSAGE_DIALOG, "账号或密码长度不正确（6-16位）" )
        self:showToast( "账号或密码长度不正确（6-16位）" )
        return
    end
    -- 判断两次输入的密码是否正确
    if strPsw ~= strCfrPsw then
        -- GameApp:dispatchEvent( gg.Event.SHOW_MESSAGE_DIALOG, "两次输入的密码不一致,请重新" )
        self:showToast( "两次输入的密码不一致,请确认您的密码" )
        return
    end

    local function checkStr( str )
        return string.match(str, "^[A-Za-z0-9]+$")
    end 
    local isAccount = checkStr( strId )
    if not isAccount  then
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "账号只能包含字母和数字。") 
        return
    end
    if not gg.CheckPassword(strPsw)  then
        return 
    end
    -- 注册
    local callback = function( result )
        if  tolua.isnull(self) then
            return
        end
        if checkint( result.status ) == 0 then
            self:showToast( "注册成功" )
            self:keyBackClicked()
        elseif checkint( result.status ) ~= 100 then
            self:showToast( result.msg )
        end
    end
    local udid = Helper.GetDeviceCode()
    -- 目前注册功能只提供给审核模式使用，所以 utype 参数固定为 username
    gg.Dapi:RegisterIndex( strId, strPsw, udid, "", "username", callback )
end

--[[    
* @brief 关闭按钮点击事件
]]
function LoginRegisterView:onClickClose(sender)

    self:postKeyBackClick()
end

return LoginRegisterView
