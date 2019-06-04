local M = class("libs.widget.GridViewCell", cc.Node)

function M:ctor(key)
    self._groupKey = key
end

function M:getGroupKey()
    return self._groupKey
end

function M:setIndex(index)
    self._index = index 
end

function M:getIndex(index)
    return self._index
end

function M:isInParent()
    return self._inParent
end

function M:setInParent(value)
    self._inParent = value
end

return M



