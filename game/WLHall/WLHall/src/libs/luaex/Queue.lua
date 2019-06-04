
local M = {}

--[[
    * 描述：队列，先进先出
--]]
function M:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self  
    return o
end

function M:push(value)
    assert(value)
    table.insert(self, value)
end

function M:pop()
    local count = #self
    if count==0 then
        return nil
    end

    local value = self[1]
    table.remove(self, 1)
    return value
end

return M


