local M = {}

--[[
    * 描述：这是文件主要针对ipairs的table
--]]

--[[
    * 描述：通过值找key
--]]
function M:findIndex(values, value)
    assert(values)
    assert(value)
    for i, v in ipairs(values) do
        if v == value then
            return i 
        end
    end
    return nil 
end

--[[
    * 描述：values里是否有value这个值
--]]
function M:isValueExist(values, value)
    return self:findIndex(values, value) ~= nil 
end 

--[[
    * 描述：删除values里面所有包含value的值
--]]
function M:removeAllEqualValue(values, value)
    assert(values)
    assert(value)

    for i=#values, 1, -1 do 
        if values[i] == value then 
            table.remove(values, i) 
        end 
    end 
    return values
end

--[[
    * 描述：删除values里第一个值是value
--]]
function M:remove(values, value)
    assert(values)
    assert(value)
    for k,v in ipairs(values) do
        if v==value then
            table.remove(values, k)
            return 
        end
    end
end

--[[
    * 描述：将t的内容加入到s的末尾
--]]
function M:append(s, t)
    assert(s)
    assert(t)
    for _,v in ipairs(t) do
        table.insert(s, v)
    end
    return s
end

--[[
    * 描述：浅拷贝
    * 将t拷贝给r，如果r为空则新建一个
--]]
function M:copy(r, t)
    assert(t)
    r = r or {}
    for k, v in ipairs(t) do
        r[k] = v
    end
    return r
end

--[[
    * 描述：对r进行分类
    * 参数：fun = function(node) end
      参数：node是r的节点
--]]
function M:classify(r, fun)
    assert(r)
    assert(fun)

    if #r < 2 then
        return r
    end

    local trueTable = {}
    local flaseTable = {}
    for _,node in ipairs(r) do
        if fun(node) then
            table.insert(trueTable, node)
        else 
            table.insert(flaseTable, node)
        end
    end

    for k, v in ipairs(trueTable) do
        r[k] = v
    end

    local falseIndex = #trueTable
    for k, v in ipairs(flaseTable) do
        r[k + falseIndex] = v
    end

    return r
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
        local value, key = self:_findValue(t, compareFun) 
        table.insert(newt, value)
        table.remove(t, key)
        count = #t
    end
    iTable:copy(t, newt)
    return newt
end

--[[
    * 描述：查找符合某条件的集合
--]]
function M:findByCondition(t, fun)
    assert(t)
    assert(fun)

    if #t < 2 then
        return t
    end

    local values = {}
    for _,node in ipairs(t) do
        if fun(node) then
            table.insert(values, node)
        end
    end
    return values
end

--------------------------- 华丽分割线 ---------------------------

-- 根据条件找最大或最小值
function M:_findValue(t, compareFun)
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

return M