local M = class("MultipleSort")

--[[
    * 描述：多级排序类，比如优先排胡牌玩家，然后排分数最高，最后排座位号靠近
--]]
function M:ctor(data)
	assert("table"==type(data))

	self._multipleData = { data }
end

--[[
    * 描述：排序分类
    * 参数：fun = function(value)由外部判断是否分类，比如胡牌玩家排最前 
--]]
function M:sortClassify(fun)
    assert(fun)

    local isData = {}
    local notData = {}
    for _,data in ipairs(self._multipleData) do
    	for _,value in ipairs(data) do
    		local res = fun(value)
    		local tmpData = res and isData or notData
    		table.insert(tmpData, value)
    	end
    end

    self._multipleData = {}
    if #isData>0 then
    	table.insert(self._multipleData, isData)    
    end

    if #notData>0 then
    	table.insert(self._multipleData, notData)    
    end
    return self
end

--[[
    * 描述：排序大小
    * 参数：fun = function(value1, value2)排序规则由外部决定，比如排分数
--]]
function M:sortSize(fun)
    assert(fun)

    for _,data in ipairs(self._multipleData) do
    	table.sort(data, fun)
    end
    return self
end

--[[
    * 描述：转换成排序后的数据，格式同原来一样
--]]
function M:toData()
    local newData = {}
   	for _,datas in ipairs(self._multipleData) do
   		for _,data in ipairs(datas) do
   			table.insert(newData, data)
   		end
   	end
    return newData
end

return M
