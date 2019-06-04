local M = {}

--[[
    * 描述：创建半黑背景
--]]
function M:createDarkLayer(opacity)
	local o = opacity and opacity or 180
    return cc.LayerColor:create(cc.c4b(0, 0, 0, o))
end

return M