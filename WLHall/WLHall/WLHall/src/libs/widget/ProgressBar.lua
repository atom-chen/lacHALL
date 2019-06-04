local M = class("libs.widget.ProgressBar", function(par1)
	assert(par1==nil, "请使用createWithXXX创建精灵")
	return cc.Node:create()
end)

--[[
    * 描述：从左往右类型进度条
    * 参数bgImage：背景图片
    * 参数progressImage：进度图片

    * 其他：进度采用百分比0~100
--]]
function M:createWithSprite(bgSprite, progressSprite)
    local bar = M.new()
    bar:_initWithSprite(bgSprite, progressSprite)
    return bar
end

function M:createWithFileName(bgFilePath, progressFilePath)
    local bgSprite = cc.Sprite:create(bgFilePath)
    local progressSprite = cc.Sprite:create(progressFilePath)
    return M:createWithSprite(bgSprite, progressSprite)
end

function M:setPercentage(percentage)
	percentage = math.min(percentage, 100)
	percentage = math.max(percentage, 0)
	
	if self._currentProgress==percentage then 
		return
	end

	self._currentProgress = percentage
	self._progressTimer:setPercentage(percentage)
	return self
end

function M:getPercentage()
	return self._currentProgress
end

--------------------------- 华丽分割线 ---------------------------
function M:_initWithSprite(bgSprite, progressSprite)
	self:addChild(bgSprite)

	local size = bgSprite:getContentSize()
	self:setContentSize(size)

	self._progressTimer = cc.ProgressTimer:create(progressSprite)
    self._progressTimer:setBarChangeRate(cc.p(1,0))
    self._progressTimer:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self._progressTimer:setMidpoint(cc.p(0, 1))
    self:addChild(self._progressTimer)

    self._currentProgress = 0
end

return M

