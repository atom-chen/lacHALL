
-- Author: zhangbin
-- Date: 2017-05-31 21:02:34
-- Describe：绑定手机界面

local BindPhoneView = class("BindPhoneView", cc.load("ViewBase"))
local timer = require("common.utils.Timer").new()

BindPhoneView.RESOURCE_FILENAME="ui/person_info/bind_phone.lua"
BindPhoneView.RESOURCE_BINDING = {
	["btn_bind"]   = { ["varname"] = "btn_bind" ,["events"]={{event="click",method="onClickBind"}} },      -- 绑定按钮
	["txt_phone_phoneid"]   = { ["varname"] = "txt_phone_phoneid" }, -- 手机号输入
    ["txt_phone_code"] = {["varname"]="txt_phone_code"},    -- 验证码输入
    ["btn_act_phone_code"] = {["varname"]="btn_act_phone_code",["events"]={{event="click",method="onClickGetCode"}}}, -- 获取验证码按钮
    ["txt_phone_code_td"] = {["varname"]="txt_phone_code_td"},    -- 验证码倒计时
}

local BTN_ENABLE_COLOR  = {r = 22, g = 146, b = 206}
local BTN_DISABLE_COLOR = {r = 100, g = 100, b = 100}

--[[
* @brief 创建
]]
function BindPhoneView:onCreate( bindCallback )
    self._bindCallback = bindCallback
    self:initWinEditBox("txt_phone_phoneid", false, 11, true)
    self:initWinEditBox("txt_phone_code", false, 4, true)

    self.txt_phone_phoneid:setFontSize(28)
    self.txt_phone_code:setFontSize(28)
end

function BindPhoneView:onCleanup()
	timer:killAll()
end

function BindPhoneView:onClickBind()
    local phoneid = ""
    local callback = function(x)
        if tolua.isnull(self) then return end
        --隐藏等待框
        GameApp:dispatchEvent(gg.Event.SHOW_LOADING)
        if x.status == 0 then
            gg.UserData:BindAttiribute(UserStatus.BindPhone)

            -- 手机绑定通知
            gg.UserData:SetPhoneInfo( phoneid )
            GameApp:dispatchEvent( gg.Event.HALL_BIND_PHONE)
            GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG,"恭喜您，绑定手机成功！")
            GameApp:DoShell(nil, "GetRewardView://", {{PROP_ID_LOTTERY, 50}})
            -- 调用回调
            if self._bindCallback then
                self._bindCallback()
            end
        else
            self:showToast(x.msg)
        end
    end

    phoneid	= self.txt_phone_phoneid:getString()
    local code = self.txt_phone_code:getString()

    -- 验证
    if gg.CheckPhone( phoneid ) and gg.CheckCode( code ) then
        -- 发送绑定请求
        gg.Dapi:BindPhone(phoneid, code, callback)

        --显示等待框
        GameApp:dispatchEvent(gg.Event.SHOW_LOADING , "正在绑定..." )
    end
end

function BindPhoneView:onClickGetCode()
    -- 获取手机号
    local phone = self.txt_phone_phoneid:getString()
    if gg.CheckPhone( phone ) then
        -- 隐藏按钮
        self.btn_act_phone_code:setEnabled(false)
        self.btn_act_phone_code:setColor(BTN_DISABLE_COLOR)
        gg.Dapi:PullCaptchaSms(
            self.txt_phone_phoneid:getString(),
            Helper.GetDeviceCode(),
            "bind",
            self:getCallback(self.txt_phone_code_td, self.btn_act_phone_code))
    end
end

--[[
* @brief 回调
]]
function BindPhoneView:getCallback(txtCodeTd, btnCode)

	local callback=function(x)
        if tolua.isnull(self) then return end
		if x.status == 0 then
			self:VerCodeShow(txtCodeTd, btnCode, x.surplus or 60 )
			self:showToast("验证码已经发送到您的手机！")
		else
  			self:showToast(x.msg)
            -- 发送失败，显示获取验证码按钮
			btnCode:setEnabled(true)
            btnCode:setColor(BTN_ENABLE_COLOR)
		end
	end
	return callback
end

function BindPhoneView:VerCodeShow( txtCodeTd, btnCode, count )

	txtCodeTd:setVisible(true)
	txtCodeTd:setString(count)
	local timerid = timer:addCountdown(function(dt)
		local bo = dt == 0
		txtCodeTd:setVisible(not bo)
        btnCode:setEnabled(bo)
        btnCode:setColor(gg.IIF(bo, BTN_ENABLE_COLOR, BTN_DISABLE_COLOR))
		txtCodeTd:setString(dt)
		end, count, 1)
end

return BindPhoneView
