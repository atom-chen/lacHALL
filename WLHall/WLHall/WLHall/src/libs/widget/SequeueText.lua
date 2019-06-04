local M = class("libs.widget.SequeueText", cc.Node)

--[[
    * 描述：混合精灵组，按横排顺序排列
    * 备注：添加的精灵默认将瞄点设为cc.p(0, 0)
--]]
function M:ctor(fileNames)
    self._nodeMgr = {}
    self._space = 4
    if fileNames then
       self:addWithFileNames(fileNames) 
    end
end

--[[
    * 描述：获得指定精灵
--]]
function M:getNode(index)
    assert(index)
    return self._nodeMgr[index]
end

--[[
    * 描述：精灵与精灵之间的间距
--]]
function M:setSpace(space)
    assert(space)
    self._space = space
    return self 
end

--[[
    * 描述：添加精灵
    * 参数：fileNames图片文件名集合
--]]
function M:addWithFileNames(fileNames)
    assert(#fileNames > 0)
    for _,fileName in ipairs(fileNames) do
        self:addWithFileName(fileName)
    end
    return self 
end

--[[
    * 描述：添加精灵
    * 参数：fileName图片文件路径
--]]
function M:addWithFileName(fileName)
    assert(fileName)
    local sprite = cc.Sprite:create(fileName)
        :addTo(self)
        :anchor(cc.p(0, 0))
    table.insert(self._nodeMgr, sprite)
    return self 
end

--[[
    * 描述：添加自定义node
--]]
function M:addWithNode(node)
    assert(node)
    self:addChild(node)
    node:setAnchorPoint(cc.p(0, 0))
    table.insert(self._nodeMgr, node)
    return self 
end

--[[
    * 描述：跳跃动画
    * 参数：index从第几个开始动画，默认为1
--]]
function M:jumpAnimate(index)
    self:_resetPosition()
    index = index and index or 1
    assert(index <= #self._nodeMgr)

    local delayTime = 0.3
    for i=index,#self._nodeMgr do
        Action:newSequence()
            :delayTime( (i-index)*delayTime )
            :moveBy(0.3, cc.p(0, 16))
            :moveBy(0.4, cc.p(0, -20))
            :moveBy(0.1, cc.p(0, 4))
            :run(self._nodeMgr[i])
    end

    local count = #self._nodeMgr - index
    Action:newSequence()
        :delayTime(count*delayTime + 1.5)
        :callFunc(function()
            self:jumpAnimate(index)
        end)
        :run(self)
    return self 
end

--------------------------- 华丽分割线 ---------------------------   

function M:_resetPosition()
    local startx = 0
    for _,node in ipairs(self._nodeMgr) do
        node:setPosition(startx, 0)

        local size = node:getContentSize()
        startx = startx + size.width +  self._space
    end

    self:_resetContentSize()
    self:_showInCenter()
end

function M:_resetContentSize()
    local lastNode = self._nodeMgr[#self._nodeMgr]
    local pos = lastNode:getPos()
    local size = lastNode:getContentSize()
    local width = pos.x + size.width
    self:setContentSize(cc.size(width, size.height))
end

-- 居中显示
function M:_showInCenter()
    local size = self:getContentSize()
    for _,node in ipairs(self._nodeMgr) do
        local pos = node:getPos()
        pos.x = pos.x - size.width/2
        pos.y = pos.y - size.height/2
        node:setPosition(pos)
    end
end

return M 


