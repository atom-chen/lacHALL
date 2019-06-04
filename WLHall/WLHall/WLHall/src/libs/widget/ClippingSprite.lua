local M = class("libs.widget.ClippingSprite", cc.ClippingNode)

--[[
    * 描述：剪切后的精灵，比如头像正方形变为圆形
    * 参数：stencilImagePath模板精灵文件路径
	* 参数：clipImagePath需要裁剪精灵文件路径
--]]
function M:ctor(stencilImagePath, clipImagePath)
	assert(stencilImagePath)
	assert(clipImagePath)
    self:setAlphaThreshold(0.5) 

    local stencilSprite = cc.Sprite:create(stencilImagePath)
    self:setStencil(stencilSprite)

    local sprite = cc.Sprite:create(clipImagePath)
    	:addTo(self)

    local size = sprite:getContentSize()
    self:setContentSize(size)
end

return M


