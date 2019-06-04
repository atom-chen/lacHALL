
-- Author: zhaoxinyu
-- Date: 2017-03-23 11:03:20
-- Describe：更换手机号界面

local ChangePhoneView = class("ChangePhoneView", cc.load("ViewPop"))

ChangePhoneView.RESOURCE_FILENAME="ui/person_info/change_phone_node.lua"

ChangePhoneView.RESOURCE_BINDING = {

	["panel_1"] = { ["varname"] = "panel_1"  },                                     -- 步骤一界面
	["panel_2"] = { ["varname"] = "panel_2"  },                                     -- 步骤二界面

	["txt_phone"] = { ["varname"] = "txt_phone"  },                                 -- 手机号

	["Panel_close"]   = { ["varname"] = "Panel_close" ,["events"]={{event="click",method="onClickClose"}} },                -- 关闭按钮
	["Panel_service"]   = { ["varname"] = "Panel_service" ,["events"]={{event="click",method="onClickService"}} },          -- 联系客服

	["txt_phone"] = { ["varname"] = "txt_phone"  },                                 -- 手机号

	["txt_phone_code_1"] = { ["varname"] = "txt_phone_code_1"  },                   -- 验证码一输入
	["txt_phone_code_2"] = { ["varname"] = "txt_phone_code_2"  },                   -- 验证码二输入

	["txt_phone_phoneid"] = { ["varname"] = "txt_phone_phoneid"  },                 -- 新手机号码输入
}

function ChangePhoneView:onCreate( inpageInfo )

    -- 初始化
    self:init( inpageInfo )

    -- 初始化View
    self:initView()

    -- 开关检测
    self:checkSwitch()
end

--[[
* @brief 开关检测
]]
function ChangePhoneView:checkSwitch()

    -- 联系客服
    if not GameApp:CheckModuleEnable( ModuleTag.CustomerService ) then

        self.Panel_service:setVisible(false)
    end
end

--[[
* @brief 初始化
]]
function ChangePhoneView:init( inpageInfo )

	self._inpageInfo = inpageInfo
	self._timer = require("common.utils.Timer").new()
end

--[[
* @brief 释放
]]
function ChangePhoneView:onCleanup()

	self._timer:killAll()
end

--[[
* @brief 初始化View
]]
function ChangePhoneView:initView()

	-- 默认显示步骤一，隐藏步骤二
	self.panel_1:setVisible(true)
	self.panel_2:setVisible(false)

	self:initPanel_1()
	self:initPanel_2()

end

--[[
* @brief 初始化panel_1
]]
function ChangePhoneView:initPanel_1()

	-- 回写当前手机号
	local phoneView , isBindPhone , phone = gg.UserData:GetPhoneSuffix()
	self.txt_phone:setString( phoneView )

	-- 初始化验证码输入框
	self:initWinEditBox("txt_phone_code_1" ,false , 4 , true)

	-- 验证码倒计时
	local txt_phone_code_td = self.panel_1:getChildByName( "txt_phone_code_td" )
	txt_phone_code_td:setVisible( false )

	-- 验证码获取按钮
	local btn_act_phone_code = self.panel_1:getChildByName( "btn_act_phone_code" )
	btn_act_phone_code:onClickScaleEffect(function(sender)

			-- 获取验证码操作
			self:getVerCode( btn_act_phone_code , txt_phone_code_td , "unbind" , phone or "" )
		end)

	-- 下一步
	local btn_phone_next = self.panel_1:getChildByName( "btn_phone_next" )
	btn_phone_next:onClickScaleEffect(function(sender)

			local txt_phone_code = self.txt_phone_code_1:getString()

			if not gg.CheckCode( txt_phone_code ) then

				return
			end

			-- 请求
			gg.Dapi:UserChangeMobile( "1" , phone or "" , txt_phone_code , function( result )
                    if tolua.isnull(self) then return end
					if result.status == 0 then

						-- 成功
						self.panel_1:setVisible(false)
						self.panel_2:setVisible(true)
					else

						-- 失败
					end
			 	end )

		end)
end

--[[
* @brief 初始化panel_2
]]
function ChangePhoneView:initPanel_2()

	-- 初始手机号输入框、验证码输入框
	self:initWinEditBox("txt_phone_phoneid" ,false , 11 , true)
	self:initWinEditBox("txt_phone_code_2" ,false , 4 , true)

	-- 验证码倒计时
	local txt_phone_code_td = self.panel_2:getChildByName( "txt_phone_code_td" )
	txt_phone_code_td:setVisible( false )

	local newPhone = nil

	-- 验证码获取按钮
	local btn_act_phone_code = self.panel_2:getChildByName( "btn_act_phone_code" )
	btn_act_phone_code:onClickScaleEffect(function(sender)

			newPhone = self.txt_phone_phoneid:getString()
			if not gg.CheckPhone(newPhone) then
				return
			end

			-- 获取验证码操作
			self:getVerCode( btn_act_phone_code , txt_phone_code_td , "change" , newPhone )
		end)

	-- 确定
	local btn_phone_next = self.panel_2:getChildByName( "btn_phone_next" )
	btn_phone_next:onClickScaleEffect(function(sender)
            newPhone = self.txt_phone_phoneid:getString()
            if not gg.CheckPhone(newPhone) then
				return
			end

			local txt_phone_code = self.txt_phone_code_2:getString()

			if not gg.CheckCode( txt_phone_code ) then

				return
			end

			-- 请求
			gg.Dapi:UserChangeMobile( "2" , newPhone or "" , txt_phone_code , function( result )
                    if tolua.isnull(self) then return end
					if result.status == 0 then

						-- 提示
						GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG, "更换手机号成功，本次下线后需一分钟后登陆！" , function()

							self:removeSelf()
							end )

						-- 更新本地账号存储信息
						local vistor , idx = gg.Cookies:GetVistorInfo()
						if vistor then
							vistor.username = newPhone

							vistor.userfrom = BRAND==0 and USER_FROM_JIXIANG or USER_FROM_PLATFORM
							gg.Cookies:UpdateUserData(vistor, idx)
							gg.Cookies:SetAutoLoginRoleByIndex( idx )
						end

						-- 更新本地Web信息
						gg.UserData:SetPhoneInfo( newPhone )
						self._inpageInfo:updatePhone()
						-- 刷新账号信息
						self._inpageInfo:updateUserName(newPhone)

					else

						-- 失败
					end
			 	end )

		end)
end

--[[
* @brief 获取验证码
]]
function ChangePhoneView:getVerCode( btn , timeNode , purpose , phone )
  --按钮的下滑线

	-- 验证码获取按钮不可操作
	btn:setEnabled(false)
	btn:setTitleColor({r = 100, g = 100, b = 100})

	-- 请求
	gg.Dapi:PullCaptchaSms(phone,Helper.GetDeviceCode(),purpose,function( result )
            if tolua.isnull(self) then return end
			if result.status == 0 then

				timeNode:setVisible(true)
				timeNode:setString( result.surplus or 60 )

				-- 计时器
				self._timer:addCountdown(function(dt)

					local bo = dt == 0
					timeNode:setVisible(not bo)
					btn:setEnabled(bo)
					btn:setTitleColor(gg.IIF(bo,{r = 24, g = 135, b = 204},{r = 100, g = 100, b = 100}))

					timeNode:setString(dt)
				end,result.surplus or 60,1 )

				self:showToast("验证码已经发送到您的手机！")
			else

				self:showToast(result.msg)
				btn:setEnabled(true)
				btn:setTitleColor({r = 24, g = 135, b = 204})
			end
		end )
end

--[[
* @brief 关闭事件
]]
function ChangePhoneView:onClickClose(sender)

	self:removeSelf()
end

--[[
* @brief 联系客服
]]
function ChangePhoneView:onClickService(sender)

	device.callCustomerServiceApi(ModuleTag.PersonInfo)
end

return ChangePhoneView
