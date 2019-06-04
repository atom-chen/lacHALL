----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2015-09-26
-- 描述：list view helper
----------------------------------------------------------------------

local function newFunc(node)
    if node then
        return node
    else
        return ccui.ListView:create()
    end
end

local M = class("TableViewEx", newFunc)

function M:ctor()
    self._createItemFunc = nil
    self._updateItemFunc = nil
    self._cellSize = cc.size(0, 0)
    self._cpr = 1
    self._singleCellSize = nil
    self._needRecreate = false
    self.mDataList = {}
    self.total = 0
    self.load_count = 0
    self.node_list = {}
    self.item_list = {}
    self.interval_load = false  -- 间断填充
    self.next_update_handler = nil
	self:setScrollBarEnabled(false)
end

function M:init()
    self:calcTotal()
    for i = 1, self.total do
        local node = self:addCustomItem()
        table.insert(self.node_list, node)
    end
    self:calcTotal()
    local function update()
        self:onUpdate()
    end
    local node = cc.Node:create()
    self:addChild(node)
    node:scheduleUpdateWithPriorityLua(update, 0.05)
end

function M:setMargin(mar)
    self:setItemsMargin(mar)
    self._margin = mar
end

function M:onUpdate()
    if self.mReloading then
        self.mReloading = false
        return
    end
    if self.next_update_handler then
        self.next_update_handler()
        self.next_update_handler = nil
    end
    self.load_count = 0
    self:updateItems()
end

function M:calcTotal()
    local total = #self.mDataList
    total = math.ceil(total / self._cpr)
    self.total = total
    return total
end

function M:addCustomItem()
    local node = ccui.Layout:create()
    node:setContentSize(self._cellSize)
    node.item = false
    node.dirty = false
    self:pushBackCustomItem(node)
    return node
end

function M:getNode(idx)
    return self.node_list[idx + 1]
end

-- 创建子结点
function M:createItem(node, index)
    if self:getDirection() == ccui.ScrollViewDir.vertical then
        self:createVerticalItem(node, index)
    else
        self:createHorizontalItem(node, index)
    end
end

function M:removeItem(node)
    if not self._needRecreate then return end
    node.item = false
    if node.list == nil then return end
    for _, node in ipairs(node.list) do
        SafeRemoveNode(node)
    end
    node.list = {}
end

function M:createCell(data)
    local item = self._createItemFunc(data)
    return item
end

function M:updateCell(item, data, idx)
    if item == nil then return end
    self._updateItemFunc(item, data, idx)
end

-- 创建水平方向的(垂直多项)
function M:createHorizontalItem(node, index)
    local y = 0
    index = index * self._cpr
    local height = self._cellSize.height / self._cpr
    if self._singleCellSize then
         local offset = (self._cellSize.height - self._singleCellSize.height * self._cpr) / (self._cpr + 1)
         height = self._singleCellSize.height + offset
         y = offset
    end
    y = y + (self._cpr - 1) * height
    node.list = {}
    for i = 1, self._cpr do
        local idx = index + i
        local data = self.mDataList[idx]
        local item = self:createCell(data)
        table.insert(self.item_list, item)
        node:addChild(item)
        item:setPositionY(y)
        item:setVisible(false)
        if data then
            item:setVisible(true)
            self:updateCell(item, data, idx)
        end
        y = y - height
        table.insert(node.list, item)
        self.load_count = self.load_count + 1
    end
    node.item = true
    node.dirty = false
end

-- 创建垂直方向(水平多项)
function M:createVerticalItem(node, index)
    local x = 0
    index = index * self._cpr
    local width = self._cellSize.width / self._cpr
    if self._singleCellSize then
         local offset = (self._cellSize.width - self._singleCellSize.width * self._cpr) / (self._cpr + 1)
         width = self._singleCellSize.width + offset
         x = offset
    end
    node.list = {}
    for i = 1, self._cpr do
        local idx = index + i
        local data = self.mDataList[idx]
        local item = self:createCell(data)
        table.insert(self.item_list, item)
        node:addChild(item)
        item:setPositionX(item:getPositionX() + x)
        item:setVisible(false)
        if data then
            item:setVisible(true)
            self:updateCell(item, data, idx)
        end
        x = x + width
        table.insert(node.list, item)
        self.load_count = self.load_count + 1
    end
    node.item = true
    node.dirty = false
end

function M:refreshItem(node, index)
    local idx = 1
    index = index * self._cpr
    for _, item in pairs(node.list) do
        local data = self.mDataList[index + idx]
        if data then
            item:setVisible(true)
            self:updateCell(item, data, index + idx)
        else
            item:setVisible(false)
        end
        idx = idx + 1
    end
    node.dirty = false
end

-- 重新加载数据
function M:reloadData(list, gotoIdx)
    self.mReloading = true
    local items = self:getItems()
    for _, node in pairs(items) do
        node.dirty = true
    end
    if list == nil then return end
    local old = self.total
    self.mDataList = list
    local new = self:calcTotal()
    local distance = new - old
    if distance == 0 then return end
    if distance > 0 then
        for i = 1, distance do
            local node = self:addCustomItem()
            table.insert(self.node_list, node)
        end
    else
        distance = math.abs(distance)
        for i = 1, distance do
            self:removeLastItem()
            table.remove(self.node_list, #self.node_list)
        end
    end
    -- 回到起引位置
    if gotoIdx then
        self:scrollToCell(gotoIdx, 0.01)
    else
        --self:implScrollToCell(self:getPercent(), 0.01)
    end
end

function M:getPercent()
    local point = self:getInnerContainerPosition()
    local innerSize = self:getInnerContainerSize()
    local percent = 100
    if innerSize.height > self:getContentSize().height then
        percent = 100 - math.abs(point.y) / (innerSize.height - self:getContentSize().height) * 100
    end
    return percent
end

-- 滚动到cell
function M:scrollToCell(idx, duration)
    local percent = 0
    local dir = self:getDirection()
    local margin = self._margin
    if dir == ccui.ScrollViewDir.vertical then
        local distance = (self._cellSize.height + margin) * self.total - self:getContentSize().height
        if distance < 0 then
            return
        end
        local offset = (idx - 1) * (self._cellSize.height + margin)
        percent = offset / distance * 100
    elseif dir == ccui.ScrollViewDir.horizontal then
        local distance = (self._cellSize.width + margin) * self.total - self:getContentSize().width
        if distance < 0 then
            return
        end
        local offset = (idx - 1) * (self._cellSize.width + margin)
        percent = offset / distance * 100
    end
    if percent > 100 then percent = 100 end
    self.next_update_handler = function() self:implScrollToCell(percent, duration) end
end

function M:implScrollToCell(percent, duration)
    local dir = self:getDirection()
    if dir == ccui.ScrollViewDir.vertical then
        self:scrollToPercentVertical(percent, duration, false)
    elseif dir == ccui.ScrollViewDir.horizontal then
        self:scrollToPercentHorizontal(percent, duration, false)
    end
end

function M:backToOriginPos()
    local dir = self:getDirection()
    if dir == ccui.ScrollViewDir.vertical then
        self:scrollToTop(0.01, false)
        -- print("list view jump to top")
    elseif dir == ccui.ScrollViewDir.horizontal then
        self:scrollToLeft(0.01, false)
        -- print("list view jump to left")
    end
end

-- 更新列表
function M:updateItems()
    local pos = cc.p(self:getInnerContainer():getPosition())
    local dir = self:getDirection()
    if dir == ccui.ScrollViewDir.vertical then
        self:loadVertical(pos.y)
    elseif dir == ccui.ScrollViewDir.horizontal then
        self:loadHorizontal(pos.x)
    end
end

-- 填充垂直方向
function M:loadVertical(yOffset)
    local index = 0
    if yOffset < 0 then
        index = math.floor(-yOffset / (self._cellSize.height + self._margin))
    end
    local total = self.total
    index = total - index
    local count = math.ceil(self:getContentSize().height / self._cellSize.height)
    index = index - count
    if index < 1 then
        index = 1
    end

    for i = -1, -1 do
        local idx = index + i - 1
        local node = self:getNode(idx)
        if node then
            self:removeItem(node)
        end
    end
    --count = count
    -- 默认填充1屏
    for i = 0, count do
        local idx = index + i - 1
        local node = self:getNode(idx)
        if node then
            if not node.item then
                self:createItem(node, idx)
                if self.interval_load then break end
            elseif node.dirty then
                self:refreshItem(node, idx)
            end
        end
    end

    for i = count + 1, count + 1 do
        local idx = index + i - 1
        local node = self:getNode(idx)
        if node then
            self:removeItem(node)
        end
    end
end

-- 填充水平方向
function M:loadHorizontal(xOffset)
    local index = 1
    if xOffset < 0 then
        index = math.ceil(-xOffset / (self._cellSize.width + self._margin))
    end
    local count = math.floor(self:getContentSize().width / self._cellSize.width)
    count = count + 2
    -- 默认填充1屏
    for i = 0, count do
        local idx = index + i
        local node = self:getNode(idx)
        if node then
            if not node.item then
                self:createItem(node, idx)
                if self.interval_load then break end
            elseif node.dirty then
                self:refreshItem(node, idx)
            end
        end
    end
end

return M
