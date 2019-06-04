
-- Author: zhaoxinyu
-- Date: 2017-03-23 15:03:20
-- Describe：实名认证界面

local AuthenticateView = class("AuthenticateView", cc.load("ViewBase"))

AuthenticateView.RESOURCE_FILENAME="ui/person_info/authenticate_node.lua"

AuthenticateView.RESOURCE_BINDING = {

	["btn_phone_next"]   = { ["varname"] = "btn_phone_next" ,["events"]={{event="click",method="onClickAuthenticate"}} },      -- 认证按钮
	
	["txt_phone_phoneid"]   = { ["varname"] = "txt_phone_phoneid" },                									       -- 真实姓名输入
	["txt_phone_pwd"]   = { ["varname"] = "txt_phone_pwd" },                											       -- 身份证号输入

	["prop_panel"]   = { ["varname"] = "prop_panel" },                											       				   -- 背景
}

local REWORD_PROPS = {
    { PROP_ID_QIANG , 10 },
    { PROP_ID_LIAN_PEN , 10 },
    { PROP_ID_CHUI_ZI , 10 },
    { PROP_ID_FAN_QIE , 10 },
    { PROP_ID_PEN_QI , 10 }
}

--[[
* @brief 创建
]]
function AuthenticateView:onCreate( authedCallback )

    -- 初始化
    self._authedCallback = authedCallback

    -- 初始化View
    self:initView()
end

--[[
* @brief 初始化View
]]
function AuthenticateView:initView()

    -- -- 适配
    -- self:setScale(display.scaleX)
	
	self:initWinEditBox("txt_phone_phoneid" ,false , 6 , false)
	self:initWinEditBox("txt_phone_pwd" ,false , 18 , false)

	-- 初始化奖励
	self:initReward()
end

--[[
* @brief 初始化奖励
]]
function AuthenticateView:initReward()
	-- 加载道具包中的道具
	for i = 1 , 5 do 

		-- 道具数据
		local propItem = self.prop_panel:getChildByName( string.format( "img_props_%d" , i ) )
		local propConfig = gg.GetPropList()[ REWORD_PROPS[i][1] ]

		-- 加载道具icon
		propItem:getChildByName( "img_prop" ):loadTexture( propConfig.icon )

		-- 设置数量
		propItem:getChildByName( "txt_count" ):setString( ""..REWORD_PROPS[i][2] )
	end
end

--[[
* @brief 身份认证按钮
]]
function AuthenticateView:onClickAuthenticate(sender)
	
	-- 获取身份证号
	local idCard = self.txt_phone_pwd:getString()
	if not gg.CheckIdCard( idCard ) then
		return
	end

	-- 获取姓名
	local name = self.txt_phone_phoneid:getString()
	if #name < 1 then

		GameApp:dispatchEvent(gg.Event.SHOW_TOAST,"请输入您的真实姓名")  
	end

	-- 开启等待框
	GameApp:dispatchEvent(gg.Event.SHOW_LOADING, "正在认证...")

	-- 发送请求
	gg.Dapi:UserCert( idCard , name , function(result) 
            if tolua.isnull(self) then return end
			-- 隐藏等待框
			GameApp:dispatchEvent(gg.Event.SHOW_LOADING)
			if result.status == 0 then
				-- 刷新身份证号显示
				gg.UserData:SetIdCardInfo( idCard )
                if self._authedCallback then
                    self._authedCallback()
                end
				--福利的通知
				GameApp:dispatchEvent(gg.Event.WELFARE_ACTIVITY)
				
				GameApp:dispatchEvent(gg.Event.SHOW_TOAST,"恭喜您，认证成功！")
				GameApp:DoShell(nil, "GetRewardView://", REWORD_PROPS)
			else
			end
		end )
end

return AuthenticateView
