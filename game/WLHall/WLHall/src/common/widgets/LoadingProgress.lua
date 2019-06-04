--
-- Author: Your Name
-- Date: 2016-10-05 18:50:46
local ViewBase=require("common.ViewBase")
local LoadingProgress = class("LoadingProgress",ViewBase)

LoadingProgress.RESOURCE_FILENAME = "ui/common/loading_progress.lua"

LoadingProgress.RESOURCE_BINDING = {
    ["img_loadingbg"]= { ["varname"] = "img_loadingbg" },            --
    ["bar_loading"]  = { ["varname"] = "bar_loading" },              --
    ["text_percent"] = { ["varname"] = "text_percent" },             --
    ["node_tips"]  	 = { ["varname"] = "node_tips"  },               --
    ["text_counter"] = { ["varname"] = "text_counter" },             --
    ["text_tips"]    = { ["varname"] = "text_tips" },
}

function LoadingProgress:onCreate()
	self:setPercent(99):setDesc("正在加载中.."):setTotal(1,100)
	self:setTextPrecentVisible(false):setTotalVisible(false)
end

function LoadingProgress:setWidth(width)
	self.img_loadingbg:setContentSize(cc.size(width,self.img_loadingbg:getContentSize().height))
	self.bar_loading:setContentSize(cc.size(width,self.bar_loading:getContentSize().height))
	return self
end

--0-100
function LoadingProgress:setPercent(percent)
	assert(percent>=0 and percent<=100,"percent out of value "..tostring(percent))
	self.bar_loading:setPercent(percent)
	self:setTextPrecentVisible(true)
	self.text_percent:setString(tostring(percent).."%")
	return self
end

function LoadingProgress:setDesc(desc)
	self.text_tips:setString(desc)
	-- 设置位置
	if not self.text_counter:isVisible() then
		self.text_tips:setPositionX( - self.text_tips:getContentSize().width/2 )
	end
	return self
end

function LoadingProgress:setTotal( curnum,total)
	-- 设置位置
	local txt = string.format("%s/%s",tostring(total),tostring(total))
	local label = ccui.Text:create(txt, "Arial", 24)
	local tipsW = self.text_tips:getContentSize().width
	local counterW = label:getContentSize().width
	local width = tipsW + counterW + 4
	self.text_counter:setPositionX( width/2 )
	self.text_tips:setPositionX( - width/2 )

	self:setTotalVisible(true)
	self.text_counter:setString(string.format("%s/%s",tostring(curnum),tostring(total)))

	return self
end

function LoadingProgress:setTextLoadingVisible(visible)
	self.bar_loading:setVisible(visible)
	return self
end

function LoadingProgress:setTextPrecentVisible(visible)
	self.text_percent:setVisible(visible)
	return self
end

function LoadingProgress:setDescVisible(visible)
	self.text_tips:setVisible(visible)
	return self
end

function LoadingProgress:setTotalVisible(visible)
	self.text_counter:setVisible(visible)
	return self
end

return LoadingProgress