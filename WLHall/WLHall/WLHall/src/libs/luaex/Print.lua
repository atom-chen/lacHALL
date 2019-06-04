local M = {}
local print = print
local tconcat = table.concat
local tinsert = table.insert
local srep = string.rep
local type = type
local pairs = pairs
local tostring = tostring
local next = next
 
--[[
    * 描述：打印当前堆栈
--]]
function M:currentStack()
    print(debug.traceback("", 2))
end

--[[
    * 描述：打印table
--]]
function M:table(root, ...)
    print("\n")
    print("****************** begin ************************")
    if ... then 
        print(...)
    end
    local cache = {  [root] = "." }
    local function _dump(t,space,name)
        local temp = {}
        for k,v in pairs(t) do
            local key = tostring(k)
            if cache[v] then
                tinsert(temp, key .. " {" .. cache[v].."}")
            elseif type(v) == "table" then
                local new_key = name .. "." .. key
                cache[v] = new_key
                tinsert(temp,"[" .. key .. "]" .. _dump(v,space .. (next(t,k) and "|" or " " ).. srep(" ",#key),new_key))
            else
                tinsert(temp,"[" .. key .. "]" .. "=" .. tostring(v))
            end
        end
        return tconcat(temp,"\n"..space)
    end
    print(_dump(root, "",""))
    print("****************** end ************************")
end

function M:table2(t, ...)
    print("\n")
    print("****************** begin ************************")
    if ... then 
        print(...)
    end
    local has_printed = {}
    local function inner_print(t, head)
        for k, v in pairs(t) do
            print(head .. "" .. tostring(k) .. ": " .. tostring(v))
            if type(v) == "table" and not has_printed[v] then
                inner_print(v, head .. "   ")
            end
            has_printed[v] = true
        end
    end
    inner_print(t, "")
    print("****************** end ************************")
end

return M 

