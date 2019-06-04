
local M = {}

--[[
    * 描述：栈，先进先出
--]]
function M:new()
    local o = {}  
    setmetatable(o, self)  
    self.__index = self  
    return o
end

function M:push(value)
    table.insert(self, value)
end

function M:pop()
    local count = #self
    if count==0 then
        return nil
    end

    local value = self[count]
    self[count] = nil 
    return value     
end

return M
 

