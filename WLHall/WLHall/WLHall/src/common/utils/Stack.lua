-- Date: 2016-01-07 14:20:24
--
local Stack = {}
Stack.__index = Stack

function Stack.new()
    local copy = {}
    setmetatable(copy, Stack)
    return copy
end

function Stack:size()
    return #self
end

function Stack:peek()
    local size = self:size()
    if size == 0 then
        return nil
    end
    return self[size]
end

function Stack:pop()
    --printf("Stack:pop")
    if self:size() > 1 then
        local tmp = self:peek()
        table.remove(self)
        return tmp
    end
    return nil
end

function Stack:push(obj)
    table.insert(self, obj)
    return self:size()
end

function Stack:insert(obj, idx)
    table.insert(self, idx, obj)
    return self:size()
end

function Stack:empty()
    return (self:size() == 0)
end

function Stack:search(object)
    for i, v in ipairs(self) do
        if object == v then
            return i
        end
    end
    return nil
end

function Stack:delete(object)
    for i, v in ipairs(self) do
        if object == v then
            return table.remove(self, i)
        end
    end
end

function Stack:clear()
    for i = 1, self:size() do
        table.remove(self)
    end
end

function Stack:searchWithTag(tag)
    --todo find object
    return nil
end

function Stack:loop(handler)
    if (not handler) or (self:size() == 0) then
        return
    end

    for i = 1, self:size() do
        handler(self[i], i)
    end
end

function Stack:rloop(handler)
    if (not handler) or (self:size() == 0) then
        return
    end

    for i = self:size(), 1, -1 do
        handler(self[i], i)
    end
end

return Stack