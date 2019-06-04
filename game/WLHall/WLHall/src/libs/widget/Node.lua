
local Node = cc.Node


------------------ 新增接口begin ------------------
function Node:scaleX(scale)
    self:setScaleX(scale)
    return self
end

function Node:scaleY(scale)
    self:setScaleY(scale)
    return self
end

function Node:scale(value)
    self:setScale(value)
    return self
end

function Node:rotation(rotation)
    self:setRotation(rotation)
    return self
end

function Node:skewX(value)
    self:setSkewX(value)
    return self
end

function Node:anchor(value)
    self:setAnchorPoint(value)
    return self
end

function Node:contentSize(size)
    self:setContentSize(size)
    return self
end

function Node:position(pos)
    self:setPosition(pos)
    return self
end

function Node:tag(tag)
    self:setTag(tag)
    return self
end

function Node:color(color)
    assert(self.setColor, "错误提示：不支持setColor接口")
    self:setColor(color)
    return self
end

function Node:layout(anchor, offset)
    Layout:layout(self, anchor, offset)
    return self
end

-- value = 0~255
function Node:opacity(opacity)
    self:setOpacity(opacity)
    return self    
end

function Node:getSize()
    local size = self:getContentSize()
    local scale = self:getScaleX()
    return cc.size(size.width*scale, size.height*scale)
end

-- 包含锚点计算位置
function Node:getCenter()
    local x,y = self:getPosition()
    local anchor = self:getAnchorPoint()
    local size = self:getSize()
    return cc.p(x + (0.5-anchor.x)*size.width, y + (0.5-anchor.y)*size.height )
end

function Node:getPos()
    local x,y = self:getPosition()
    return cc.p(x, y)
end

function Node:delayRemoveSelf(delayTime)
    assert(delayTime > 0)
    Action:newDelayCallfunWithNode(self, delayTime, function()
        self:removeFromParent()
    end)
    return self
end

------------------ 新增接口end ------------------