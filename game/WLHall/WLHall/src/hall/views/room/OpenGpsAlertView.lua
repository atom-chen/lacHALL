-- Author: Cai
-- Date: 2017-03-23
-- Describe：开启GPS提示

local OpenGpsAlertView = class("OpenGpsAlertView", cc.load("ViewPop"))

OpenGpsAlertView.RESOURCE_FILENAME="ui/common/open_gps_alertview.lua"
OpenGpsAlertView.RESOURCE_BINDING = {
 	["btn_open"]    = { ["varname"] = "btn_open",  ["events"] = { { ["event"] = "click",       ["method"] = "onClickOpenGps" } } },
	["btn_close"]   = { ["varname"] = "btn_close", ["events"] = { { ["event"] = "click_color", ["method"] = "onClickClose"   } } },
}

-- 前往开启GPS
function OpenGpsAlertView:onClickOpenGps( sender )
	device.openGpsSetting()
	self:removeSelf()
	printf( "onClickOpenGps 前往开启GPS" )
end

-- 关闭
function OpenGpsAlertView:onClickClose()
	self:removeSelf()
end

return OpenGpsAlertView