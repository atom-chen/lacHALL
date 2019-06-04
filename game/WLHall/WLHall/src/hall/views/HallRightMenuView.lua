
-- Author: zhaoxinyu
-- Date: 2016-09-28 09:58:20
-- Describe：大厅右侧功能

local HallRightMenuView = class("HallRightMenuView", cc.load("ViewBase"))

HallRightMenuView.RESOURCE_FILENAME="ui/common/hall_right.lua"

HallRightMenuView.RESOURCE_BINDING = {
	["btn_explain"]   = { ["varname"] = "btn_explain" ,["events"]={{event="click",method="onClickExplain"}} },					-- 声明
	["btn_sound"]   = { ["varname"] = "btn_sound" ,["events"]={{event="click",method="onClickSound"}} },					    -- 声音设置
	["btn_feeback"]   = { ["varname"] = "btn_feeback" ,["events"]={{event="click",method="onClickFeeback"}} },				    -- 反馈

	["btn_service"]   = { ["varname"] = "btn_service" ,["events"]={{event="click",method="onClickService"}} },					-- 客服
	["btn_switch"]   = { ["varname"] = "btn_switch" ,["events"]={{event="click",method="onClickSwitch"}} },						-- 切换账号
	["panel_menu"]   = { ["varname"] = "panel_menu" },
	["panel_right"]   = { ["varname"] = "panel_right",["events"]={{event="touch",method="onClickPanel"}} },						-- panel背景


	["btn_close"]   = { ["varname"] = "btn_close" ,["events"]={{event="click",method="onClickClose"}} },


	["img_bg"]   = { ["varname"] = "img_bg" },
	["btn_set"]   = { ["varname"] = "btn_set" },
}

local BTN_BEGIN_YPOS = 635
local BTN_PADDING = 100

function HallRightMenuView:onCreate( ... )
    self:initView()
end

--[[
* @brief 初始化View
]]
function HallRightMenuView:initView()

	local offsetX = gg.IIF(gg.isWideScreenPhone, self.panel_menu:getContentSize().width * 0.06, 0)


	-- 适配位置
	self.panel_right:setContentSize(cc.size(  display.width, display.height))

	self.panel_menu:setContentSize( cc.size(self.panel_menu:getContentSize().width  + gg.getPhoneLeft()  +offsetX, display.height ) )
	self.panel_menu:setPosition(cc.p(  display.width , display.height))
	self.img_bg:setContentSize( cc.size(self.img_bg:getContentSize().width  + gg.getPhoneLeft()  +offsetX, display.height ) )
	self.img_bg:setPosition(cc.p(  display.width, display.height))

	local hScale = display.height  / 720

	local btns = {}

	table.insert(btns, self.btn_close)

	-- 设置按钮
	table.insert(btns, self.btn_sound)

	-- 客服按钮
	if GameApp:CheckModuleEnable( ModuleTag.CustomerService ) then
		table.insert(btns, self.btn_service)
	end

	-- 反馈按钮
	table.insert(btns, self.btn_feeback)
	-- 声明按钮
	if not IS_REVIEW_MODE then
		table.insert(btns, self.btn_explain)
	end


	-- 切换帐号按钮
	table.insert(btns, self.btn_switch)

	-- 速度基数
	local bSpeed = 0.17
	-- 速度递增数
	local spike = 0.05

	-- 目标的 X 坐标
	local targetX = self.btn_set:getPositionX()

	-- 设置按钮位置
	for i=1,#btns do
		if i == 1 then
			btns[i]:setVisible(true)
			local posY = (BTN_BEGIN_YPOS ) *hScale
			btns[i]:setPositionY(posY)
			btns[i]:runAction( cc.MoveTo:create( bSpeed + spike * (i-1) , cc.p( targetX+72 , posY)))
		else
			btns[i]:setVisible(true)
			local posY = (BTN_BEGIN_YPOS - (i-1) * BTN_PADDING) *hScale
			btns[i]:setPositionY(posY)
			btns[i]:runAction( cc.MoveTo:create( bSpeed + spike * (i-1) , cc.p( targetX , posY)))
		end
	end

end



--[[
* @brief 反馈点击事件
]]
function HallRightMenuView:onClickFeeback(sender)
    -- 播放点击音效
    gg.AudioManager:playClickEffect()
	self:getScene():createView("FeedBackView", nil, "feedback"):pushInScene()
	self:removeSelf()
end


--[[
* @brief 客服点击事件
]]
function HallRightMenuView:onClickService(sender)
    -- 播放点击音效
    gg.AudioManager:playClickEffect()

 	-- 显示联系客服界面
    -- local url = gg.Dapi:GeServicetUrl( ModuleTag.Hall )
    -- GameApp:dispatchEvent(gg.Event.SHOW_VIEW,"GeneralWebView",{ push = false} , url , "联系客服")

    device.callCustomerServiceApi(ModuleTag.Hall)

	self:removeSelf()
end

--[[
* @brief 切换账号点击事件
]]
function HallRightMenuView:onClickSwitch(sender)
    -- 播放点击音效
    gg.AudioManager:playClickEffect()
	GameApp:Logout()
end


--[[
* @brief 声明点击事件
]]
function HallRightMenuView:onClickExplain(sender)
	-- 播放点击音效
	gg.AudioManager:playClickEffect()
	self:getScene():createView("DeclarationView"):pushInScene()
	self:removeSelf()
end

--[[
* @brief panel点击
]]
function HallRightMenuView:onClickPanel(sender)
	if sender.name == "ended" then
		self:removeSelf()
	end

end
--关闭页面
function HallRightMenuView:onClickClose(sender)
	self:removeSelf()
end

--[[
* @brief 声音点击
]]
function HallRightMenuView:onClickSound(sender)

    -- 播放点击音效
    gg.AudioManager:playClickEffect()
	self:removeSelf()

	local hallSetting = require("common.setting.SettingView"):create( "hall", "res/common/audio/game_bg_01.mp3" ):pushInScene()
	hallSetting:registerWidgetsCb( function( mark , isOn)

		-- 方言开关
		if mark == hallSetting.WIDGETS_MARK.WIDGETS_DIALECT then
			print( "方言开关:")

		-- 单击出牌开关
		elseif mark == hallSetting.WIDGETS_MARK.WIDGETS_CLICK_OUT_CARD then
			print( "单击出牌开关:")

		-- 放大出牌出牌开关
		elseif mark == hallSetting.WIDGETS_MARK.WIDGETS_ENLARGECARD_OUT_CARD then
			print( "放大出牌出牌开关:")

		-- 加注方式开关
		elseif mark == hallSetting.WIDGETS_MARK.WIDGETS_BET_TYPE then
			print( "加注方式:"..tostring(isOn))

		-- 换牌开关
		elseif mark == hallSetting.WIDGETS_MARK.WIDGETS_CARD_BG_STYLE then
			print( "换牌:"..tostring(isOn))
		end
	 end )

	-- 设置方言开关禁用
	hallSetting:setDialectEnabled( false )
	-- 设置单击出牌开关禁用
	hallSetting:setClickOutCardEnabled( false )
	-- 设置放大出牌开关禁用
	hallSetting:setEnlargecardOutCardEnabled( false )

	-- 设置管理器
	local settingMgr = require( "common.setting.SettingManager" )
	-- 获取方言开关状态
	local dialectState = settingMgr:GetDialectState( "hall" )
	-- 获取单击出牌状态
	local clickOutCard = settingMgr:GetClickOutCardState( "hall" )
	-- 获取放大出牌状态
	local enlargeCardState = settingMgr:GetClickEnlargeCardState( "hall" )
end

return HallRightMenuView
