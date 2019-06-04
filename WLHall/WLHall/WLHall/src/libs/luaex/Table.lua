
local M = {}

function M:isValueExist(t, value)
    for i, v in pairs(t) do
        if v == value then
            return true 
        end
    end
    return false 
end 

function M:length(t)
    local count = 0
    for _,_ in pairs(t) do
        count = count + 1
    end
    return count
end

function M:remove(t, value)
    assert(t)
    assert(value)
    for k,v in pairs(t) do
        if v==value then
            table.remove(t, k)
            return 
        end
    end
end

--[[
    * 描述：将s的数据连接到t的尾部
--]]
function M:concat(t, s)
    assert(t)
    assert(s)
    for _,value in ipairs(s) do
        table.insert(t, value)
    end
end

function M:findKey(t, value)
    assert(t)
    assert(value)
    for k,v in pairs(t) do
        if v==value then
            return k
        end
    end
end

--[[
    * 描述：初始化具有count个值为value的table
--]]
function M:init(count, value)
    value = value and value or 0
    local tb = {}
    for i=1,count do
        table.insert(tb, value)
    end
    return tb
end

--[[
    * 描述：根据条件找最大或最小值
    * 返回值：value, key
--]]
function M:findValue(t, compareFun)
    local count = #t
    assert(count>0 and compareFun)
    if count == 1 then
        return t[1], 1
    end

    local tmpKey = 1
    local tmpValue = t[tmpKey]
    for i=2,count do
        local nextValue = t[i]
        if not compareFun(tmpValue, nextValue) then
            tmpKey = i
            tmpValue = t[tmpKey]
        end
    end
    return tmpValue, tmpKey
end

--[[
    * 描述：table.sort有个bug不能比较>=和<=的情况
    * 参数：同table.sort一样
--]]
function M:sort(t, compareFun)
    assert(t and compareFun) 
    local count = #t
    if count == 0 then
        return
    end

    local newt = {}
    while count>0 do
        local value, key = self:findValue(t, compareFun) 
        table.insert(newt, value)
        table.remove(t, key)
        count = #t
    end
    Table:copy(t, newt)
    return newt
end

--[[
    * 描述：倒序
    * 示例：{1, 2, 3} -> {3, 2, 1}
--]]
function M:reverse(tb)
    assert(tb)
    if #tb==0 then
        return {}
    end
    
    local revTb = {}
    for i=#tb,1,-1 do
        table.insert(revTb, tb[i])
    end
    return revTb
end

--[[
    * 描述：source替换为target值，数量会少一
--]]
function M:replace(t, source, target)
    assert(t and source and target)
    assert(source ~= target)
    local sourceKey = self:findKey(t, source)
    local targetKey = self:findKey(t, target)
    t[sourceKey] = target
    table.remove(t, targetKey)
end

--[[
    * 描述：把只能pairs遍历装换成ipairs遍历
--]]
function M:changeToIpairs(t)
    local newData = {}
    for k,v in pairs(t) do
        newData[#newData + 1] = v
    end
    return newData
end

-- 浅拷贝
function M:copy(r, t)
    r = r or {}
    for k, v in pairs(t) do
        r[k] = v
    end
    return r
end

-- 深拷贝
function M:deepCopy(r, t)
    r = r or {}
    for k, v in pairs(t) do
        if type(v) == "table" then
            r[k] = self:deepCopy({}, v)
        else
            r[k] = v
        end
    end
    return r
end

-- 序列化
function M:serialize(t)
    local mark = {}
    local value = {}
    
    local function ser_table(tbl,parent)
        mark[tbl]=parent
        local tmp={}
        for k,v in pairs(tbl) do
            local key= type(k)=="number" and "["..k.."]" or k
            if type(v)=="table" then
                local dotkey= parent..(type(k)=="number" and key or "."..key)
                if mark[v] then
                    table.insert(value,dotkey.."="..mark[v])
                else
                    table.insert(tmp, key.."="..ser_table(v,dotkey))
                end
            else
                local s = type(v) == "string" and '"'..v..'"' or tostring(v)
                table.insert(tmp, key.."="..s)
            end
        end
        return "{"..table.concat(tmp,",").."}"
    end
 
    return "do local ret="..ser_table(t,"ret")..table.concat(value," ").." return ret end"
end

return M
 

