local M = class("libs.ccex.ActionSize")

--[[
    * 描述：放大图片大小动画
--]]
function M:ctor(duration, node, targetSize)
    assert(duration)
    assert(node)
    assert(targetSize.width and targetSize.height)

    self._duration = duration
    self._node = node 
    
    local originSize = node:getContentSize()
    self._originSize = originSize
    self._offsetSize = cc.size(targetSize.width-originSize.width, targetSize.height-originSize.height)

    self._elapseTime = 0
    Timer:addTimer(self)
end

--[[
    * 描述：绑定子节点跟node的缩放而缩放
--]]
function M:bindSubNodes(subNodes)
    self._subNodes = subNodes
    return self
end

--------------------------- 华丽分割线 ---------------------------

function M:onTimerUpdate(dt)
    self._elapseTime = self._elapseTime + dt
    local percent = self._elapseTime / self._duration
    if percent >= 1 then
        local size = cc.size(self._offsetSize.width+self._originSize.width, self._offsetSize.height + self._originSize.height)
        self:_setNodeSize(size)
        Timer:removeTimer(self)
        return
    end

    local width = self._offsetSize.width*percent + self._originSize.width
    local height = self._offsetSize.height*percent + self._originSize.height
    self:_setNodeSize(cc.size(width, height))
end

function M:_setNodeSize(size)
    self._node:setContentSize(size)

    if self._subNodes==nil then
        return
    end

    for _,subNode in ipairs(self._subNodes) do
        subNode:setContentSize(size)
        local anchor = subNode:getAnchorPoint()
        subNode:layout(anchor)
    end
end

return M