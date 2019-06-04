
-- Author: chen weijin
-- Date: 2016-08-29 15:24:25
-- Describe：激活界面

local InpageActive = class("InpageActive", cc.load("ViewBase"))

InpageActive.RESOURCE_FILENAME="ui/person_info/inpage_link_account.lua"

local timer = require("common.utils.Timer").new()

InpageActive.RESOURCE_BINDING = {
    ["main_panel"]          = {["varname"] = "main_panel"},
	  ["act_phone"] 			= {["varname"] = "act_phone"},
    ["panel_phone_tips"]    = {["varname"] = "panel_phone_tips"},
    ["panel_activation"]    = {["varname"] = "panel_activation"},


  	["txt_phone_phoneid"] 	= {["varname"] = "txt_phone_phoneid"},
  	["txt_phone_pwd"] 		= {["varname"] = "txt_phone_pwd"},
  	["txt_phone_code"] 		= {["varname"] = "txt_phone_code"},
  	["txt_phone_code_td"] 	= {["varname"] = "txt_phone_code_td"},
  	["btn_act_phone_code"]  = {["varname"] = "btn_act_phone_code",["events"]={{event="click",method="onClickActPhoneCode"}} },

  	-- 新的激活界面
  	["btn_phone_activation"] = {["varname"] = "btn_phone_activation",["events"] = {{event = "click",method = "onClickPhoneActivation"}} },
}

local MAIN_PANEL_EXTEND_H   = 590
local MAIN_PANEL_UNEXTEND_H = 530

local BTN_ENABLE_COLOR  = {r = 22, g = 146, b = 206}
local BTN_DISABLE_COLOR = {r = 100, g = 100, b = 100}

local GOODS_CFG = {
    {PROP_ID_MONEY, 3000}, {PROP_ID_MAO_BI, 5}, {PROP_ID_ZUI_CHUN, 5}, {PROP_ID_KOU_XIANG_TANG, 5}
}

function InpageActive:onCreate( activeCallback )
    self.main_panel:setTouchEnabled(false)
    self.main_panel:setScrollBarEnabled(false)

    -- 屏蔽微信激活功能
    self:setExtend(true)

	  self._activeCallback = activeCallback

    -- 设置输入框的字体颜色
    self:initWinEditBox("txt_phone_phoneid", false, 11, true)
    self:initWinEditBox("txt_phone_pwd")
    self:initWinEditBox("txt_phone_code", false, 4, true)
    self.txt_phone_phoneid:setFontSize(28)
    self.txt_phone_pwd:setFontSize(28)
    self.txt_phone_code:setFontSize(28)
end

function InpageActive:onCleanup()
	timer:killAll()
end

function InpageActive:invokeCallback()
    if self._activeCallback then
        self._activeCallback()
    end
end

function InpageActive:setExtend(value)
    if value == self.extended then
        return
    end

    -- 调整界面布局
    self.extended = value
end

function InpageActive:changeNodeHeight(node, newH)
    if not node then
        return
    end

    node:setContentSize(node:getContentSize().width, newH)
end

function InpageActive:onClickExtend(obj)
    if self.extended then
        self:setExtend(false)
    else
        self:setExtend(true)
    end
end

--[[
* @brief 激活获取验证码事件
]]
function InpageActive:onClickActPhoneCode()

	-- 获取手机号
	local phone = self.txt_phone_phoneid:getString()
	if gg.CheckPhone( phone ) then

        -- 隐藏按钮
		self.btn_act_phone_code:setEnabled(false)
        self.btn_act_phone_code:setColor(BTN_DISABLE_COLOR)
		gg.Dapi:PullCaptchaSms(
			self.txt_phone_phoneid:getString(),
			Helper.GetDeviceCode(),
			"activate",
			self:getCallback(self.txt_phone_code_td, self.btn_act_phone_code))
	end

end

--[[
* @brief 回调
]]
function InpageActive:getCallback(txtCodeTd, btnCode)

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

function InpageActive:VerCodeShow( txtCodeTd, btnCode, count )

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
--[[
* @brief 手机激活点击事件
]]
function InpageActive:onClickPhoneActivation( sender )
    local phoneid = ""
    local pwd = ""
    local callback = function(x)
        if tolua.isnull(self) then return end
        -- 隐藏等待框
        GameApp:dispatchEvent(gg.Event.SHOW_LOADING)

        if x.status == 0 then
            gg.UserData:BindAttiribute(UserStatus.Activited,UserStatus.BindPhone)

            -- 更新本地账号存储信息
            local vistor , idx = gg.Cookies:GetVistorInfo()
            local newFrom = BRAND==0 and USER_FROM_JIXIANG or USER_FROM_PLATFORM
            if vistor then
                vistor.username = phoneid
                vistor.userfrom = newFrom
                vistor.pwd = pwd
                gg.Cookies:UpdateUserData(vistor, idx)
                gg.Cookies:SetAutoLoginRoleByIndex( idx )
            end

            -- 更新玩家数据
            if hallmanager and hallmanager.userinfo then
                local userinfo = hallmanager.userinfo
                userinfo.userfrom = newFrom
                hallmanager:UpdateUserInfo( userinfo )
            end
            -- 发送通知
            GameApp:dispatchEvent( gg.Event.HALL_ACTIVATE_USER_PHONE , phoneid , pwd )

            -- 修改手机激活任务状态
            local status = gg.UserData:GetNewTaskStatusById(75)
            if status ~= 5 then
                -- 激活成功奖励直接发放，不用领取
                gg.UserData:SetNewTaskStatusById(75, 5)
                -- GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "激活成功，奖励已发放！")
                GameApp:DoShell(nil, "GetRewardView://", GOODS_CFG)
                GameApp:dispatchEvent( "event_task_complete_callback", 75, 1 )
            end

            -- 调用回调
            self:invokeCallback()
        else
            self:showToast(x.msg)
        end
    end

    phoneid = self.txt_phone_phoneid:getString()
    local code = self.txt_phone_code:getString()
    pwd = self.txt_phone_pwd:getString()

    -- 验证手机
    if not gg.CheckPhone(phoneid) then
        return
    end

    -- 验证密码
    if not gg.CheckPassword(pwd) then
        return
    end

    -- 检查验证码
    if not gg.CheckCode(code) then
        return
    end

    -- 请求
    gg.Dapi:ActivateMobile(phoneid, code, pwd, Helper.GetDeviceCode(), device.platform, callback)

    --显示等待框
    GameApp:dispatchEvent(gg.Event.SHOW_LOADING , "正在激活..." )
end

return InpageActive
