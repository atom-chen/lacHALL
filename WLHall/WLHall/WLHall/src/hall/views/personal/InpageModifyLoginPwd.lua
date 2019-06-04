--
-- Author: chen weijin
-- Date: 2016-08-29 15:24:25
--
local InpageModifyLoginPwd = class("InpageModifyLoginPwd", cc.load("ViewBase"))

InpageModifyLoginPwd.RESOURCE_FILENAME="ui/person_info/inpage_change_pwd.lua"

InpageModifyLoginPwd.RESOURCE_BINDING = {
	["txt_old_pwd"] 	= {["varname"] = "txt_old_pwd"},
	["txt_new_pwd"] 	= {["varname"] = "txt_new_pwd"},
	["txt_new_pwd2"] 	= {["varname"] = "txt_new_pwd2"},

	["btn_commit"] 		= {["varname"] = "btn_commit",["events"]={{event="click",method="onClickCommit"}} },
}
function InpageModifyLoginPwd:onCreate( ... )
	-- if device.platform == "windows" then
		self:initWinEditBox("txt_old_pwd",true)
		self:initWinEditBox("txt_new_pwd",true , 16)
		self:initWinEditBox("txt_new_pwd2",true , 16)
	-- end

end
function InpageModifyLoginPwd:onClickCommit()

	local new = ""
	local callback=function(x)

		--隐藏等待框
		GameApp:dispatchEvent(gg.Event.SHOW_LOADING)

		if x.status == 0 then
			--self:showToast("修改密码成功")

			-- 修改密码成功
			GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG,"密码已修改，请您牢记！")

			-- 刷新本地密码密码存储
			local isFail = gg.Cookies:UpdateUserData({pwd=new})

			-- if not isFail then
			-- 	GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG,"修改本地存储密码失败，请重新登录！")
			-- end

			-- GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG,"修改本地存储密码失败，请重新登录！")


			-- 清空输入框
			self.txt_old_pwd:setString("")
			self.txt_new_pwd2:setString("")
			self.txt_new_pwd:setString("")
		else
  			self:showToast(x.msg)
		end
	end


	local old	= self.txt_old_pwd:getString()
	new	= self.txt_new_pwd:getString()
	local new2	= self.txt_new_pwd2:getString()

	if #old <=0 then

		self:showToast("请输入您的原密码！")
		return
	end

	-- 密码验证
	if new ~= new2 then
		self:showToast("两次输入的新密码不同，请确认后重新输入！")
		return
	end

	-- 检查新密码是否符合规范
	if self:checkPassword( new ) then

		gg.Dapi:ModifyPassword(old,new,callback)

		--显示等待框
		GameApp:dispatchEvent(gg.Event.SHOW_LOADING , "正在修改密码..." )
	end
end

--[[
* @brief 密码格式检查
* @param password 身份证号
* @return false:不合法
]]
function InpageModifyLoginPwd:checkPassword( password )

	-- 验空
	if password == nil then

		self:showToast("请输入您的新密码！")
		return false
	end

	if #password <= 0 then

		self:showToast("请输入您的新密码！")
		return false
	end

	if #password <6 or #password >16 then
		self:showToast("您输入的新密码不规范，请输入6-16位字母+数字！")
		return false
	end
    -- 验证密码
    return gg.CheckPassword(password)
end

return InpageModifyLoginPwd