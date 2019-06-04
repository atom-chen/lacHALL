
local M = {}

local function compute_point_offset(node, anchor)
    local size = node:getContentSize()
    local nodeAnchor = node:isIgnoreAnchorPointForPosition() and cc.p(0, 0) or node:getAnchorPoint() 
    local tmp = cc.pSub(anchor, nodeAnchor) 
    local x = size.width * node:getScaleX() * tmp.x
    local y = size.height * node:getScaleY() * tmp.y
    return cc.p(x, y)
end

function M:getLocation(node, anchor)
    local offset = compute_point_offset(node, anchor)
    return cc.pAdd(cc.p(node:getPosition()), offset)
end

function M:getFrame(node)
    local pos = M:getLocation(node, cc.p(0, 0))
    local size = node:getContentSize()
    size.width = size.width * node:getScaleX()
    size.height = size.height * node:getScaleY()

    if size.width < 0 then 
        pos.x = pos.x + size.width
        size.width = -size.width 
    end 
    if size.height < 0 then 
        pos.y = pos.y + size.height 
        size.height = -size.height 
    end 
    
    return cc.rect(pos.x, pos.y, size.width, size.height)
end

--[[
    * 描述：子节点相对父节点位置
    * 参数：node子节点
    * 参数：anchor子节点相对父节点百分比位置，值如cc.p(0.1, 0.1)
           如值为M.center，表示居中位置
    * 参数：offset偏移量，如值为cc.p(-100,50),向左偏移100、向上偏移50个像素
--]]
M.left_top      = cc.p(0.0, 1.0)
M.left_center   = cc.p(0.0, 0.5)
M.left_bottom   = cc.p(0.0, 0.0)
M.center_bottom = cc.p(0.5, 0.0)
M.center_top    = cc.p(0.5, 1.0)
M.right_top     = cc.p(1.0, 1.0)
M.right_center  = cc.p(1.0, 0.5)
M.right_bottom  = cc.p(1.0, 0.0)
M.center        = cc.p(0.5, 0.5)
function M:layout(node, anchor, offset)
    local parent = node:getParent()
    assert(parent, "错误：parent不能为空")
    offset = nil==offset and cc.p(0, 0) or offset
    local size = parent:getContentSize()
    local pos = cc.p(size.width*anchor.x, size.height*anchor.y)
    pos = cc.pAdd(pos, offset)
    node:setPosition(pos)
end

--[[
    * 描述：将sNode缩放至tNode一样大小
    * 参数：sNode源精灵
    * 参数：tNode目标精灵
    * 参数：mode模式：0等高，1等宽
--]]
M.equal_mode_height = 0
M.equal_mode_width = 1
function M:equalMode(sNode, tNode, mode)
    local sSize = sNode:getContentSize()
    local tSize = tNode:getContentSize()
    local scale = 1
    if M.equal_mode_height == mode then
        scale = tSize.height / sSize.height
    elseif M.equal_mode_width == mode then
        scale = tSize.width / sSize.width
    end

    sNode:setScale(scale)
end

return M
