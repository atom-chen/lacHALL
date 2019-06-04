
local M = {}

--[[
    * 描述：创建9宫格精灵
    * 参数：filePath文件路径
--]]
function M:create(filePath)
	assert(filePath)
    return ccui.Scale9Sprite:create(filePath)
end

--[[
    * 描述：创建9宫格精灵，以指定像素拉伸
    * 参数：filePath文件路径
    * 参数：percentX  x轴百分位置，值在0-1 
    * 参数：percentY  y轴百分位置，值在0-1 
--]]
function M:createWithCapInsert(filePath, percentX, percentY)
	assert(filePath)
	assert(percentX<=1 and percentX>=0)
	assert(percentY<=1 and percentY>=0)
    local sprite = self:create(filePath)
    self:_setStretchPos(sprite, percentX, percentY)
    return sprite
end

function M:createWithSpriteFrame(spriteFrame)
    assert(spriteFrame)
    return ccui.Scale9Sprite:createWithSpriteFrame(spriteFrame)
end

function M:createWithSpriteFrameCapInsert(spriteFrame, percentX, percentY)
    assert(spriteFrame)
	assert(percentX<=1 and percentX>=0)
	assert(percentY<=1 and percentY>=0)
	local sprite = self:createWithSpriteFrame(spriteFrame)
    self:_setStretchPos(sprite, percentX, percentY)
    return sprite
end

--------------------------- 华丽分割线 ---------------------------

function M:_setStretchPos(sprite, percentX, percentY)
    local size = sprite:getContentSize()
    local capX = (1 - percentX) * size.width
    local capY = (1 - percentY) * size.height
    sprite:setCapInsets(cc.rect(capX, capY, 2, 2))
end

return M
