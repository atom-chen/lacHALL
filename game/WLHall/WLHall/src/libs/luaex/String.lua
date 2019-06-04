local M = {}

--[[
    * 描述：格式化为时间格式
    * 参数：time总时间
    * 示例：foramtTime(3600) -> 01:00:00
--]]
function M:foramtTime(time)
    assert(time >= 0)
    local targetS = math.floor(time % 60)
    local targetM = math.floor(time / 60 % 60)
    local targetH = math.floor(time / 60 / 60)
    return string.format(__Localized("%02d:%02d:%02d"), targetH, targetM, targetS)
end

--[[
    * 描述：反向查找存在char的字符
    * 参数：char是单个字符，不是字符串哦！！如："/"
--]]
function M:rfindIndex(text, char)
    assert(text and char)
    local numChar = string.byte(char, 1)
    for i=#text,1,-1 do
        local num = string.byte(text, i)
        if num == numChar then
            return i
        end
    end
    return nil 
end

--[[
    * 描述：找到字符串索引集合
    * 示例：findIndexs("12/34/5", "/") -> { 3, 6 }
    ***** 备注：searchText不能为 "." 
           string.find("234.56", ".") 返回是1，应该是string的bug
--]]
function M:findIndexs(text, searchText)
    assert(text and string.len(text)>0)
    
    local indexs = {}
    local begin = 1
    while true do
        local start, last  = string.find(text, searchText, begin)
        if nil == start then
            break
        end

        table.insert(indexs, start)
        begin = last + 1
    end

    return indexs
end

--[[
    * 描述：分割字符串
    * 参数：split_char：分隔符
    * 例子：split("1:2:a", ":") = { "1", "2", "a" }
--]]
function M:split(str, split_char)
    local t = {}
    local str_len = #str
    local i = 1
    while true do
        local a, b = string.find(str, split_char, i, true)
        if a == nil then
            if i < str_len + 1 then
                t[#t + 1] = string.sub(str, i, str_len)
            end
            break
        end

        if i < a then
            t[#t + 1] = string.sub(str, i, a - 1)
        end
        i = b + 1
    end
    return t
end

function M:has(str, sub_str)
    return string.find(str, sub_str, 1, true) ~= nil
end

--[[
    * 描述：将字符串转为table类型
    * 参数：firstChar第一个解析字段
    * 参数：secondChar第二个解析字段
    * 示例：splitToTable("username:name,password:mini", ",", ":") 
           -> { username=name, password=mini }
    * 备注：不做嵌套判断
--]]
function M:splitToTable(str, firstChar, secondChar)
    assert(str)
    assert(firstChar)
    assert(secondChar)
    local data = self:split(str, firstChar)
    local resTable = {}
    for _,v in ipairs(data) do
        local sp2 = String:split(v, secondChar)
        assert(#sp2==2, "解析错误")
        resTable[sp2[1]] = sp2[2]
    end
    return resTable
end

--[[
    * 描述：替换
    * 参数：sourceStr将要替换的字符串
    * 参数：targetStr替换后的字符串
--]]
function M:replace(str, sourceStr, targetStr)
    return string.gsub(str, sourceStr, targetStr)
end

--[[
    * 描述：首字母大写
    * 例子：upperFirstChar("exit") = "Exit"
--]]
function M:upperFirstChar(string)
    return string.upper(string.sub(string, 1, 1)) .. string.sub(string, 2, -1)
end

--[[
    * 描述：比较版本号大小
    * 参数：split_char：分隔符
    * 返回值：0等于，1大于，-1小于
    * 例子：compareVersion("1.9", "1.10", ".")     = -1
           compareVersion("10:0:1", "9:0:1", ":") = 1
--]]
function M:compareVersion(value1, value2, split_char)
    if value1==value2 then 
        return 0
    end

    local a1 = String:split(value1, split_char)
    local a2 = String:split(value2, split_char)
    assert(#a1 == #a2)

    for index=1,#a1 do
        self:_checkVersion(a1[index])
        self:_checkVersion(a2[index])
        local v1 = tonumber(a1[index])
        local v2 = tonumber(a2[index])        
        if v1 > v2 then 
            return 1 
        end

        if v1 < v2 then 
            return -1
        end
    end
    assert(false, "如果调用到这句说明有错了")
end

--[[
    * 描述：查找字符串包含key的所有索引
    * 例子：findSubIndexs("1<p>2<p>3", <p>) = { {2, 4}, {6, 8} }
--]]
function M:findSubIndexs(string, findKey)
    assert(string, findKey)
    local res = {}
    local index = 1
    while true do
        local beginIndex, endIndex = string.find(string, findKey, index)
        if nil==beginIndex then 
            break
        end

        index = endIndex + 1
        table.insert(res, { beginIndex, endIndex } )
    end
    return res
end

--[[
    * 描述：通过beginKey和endKey解析string
    * 例子：parseSubs("first<p>middle</p>last", "<p>", "</p>") = { {"first", false}, {"middle", true}, {"last"， false} }
    * 格式：{{解析字符串, 是否属于beginKey和endKey之间}}
--]]
function M:parseSubs(string, beginKey, endKey)
    assert(string and beginKey and endKey)
    local res = {}
    local index = 1
    while true do
        local beginIndex, endIndex = string.find(string, beginKey, index)
        if nil==beginIndex then
            local stringLen = string.len(string)
            if index>=stringLen then 
                break
            end

            local subString = string.sub(string, index, stringLen)
            table.insert(res, {subString, false})
            break
        end

        if index ~= beginIndex then 
            local subString = string.sub(string, index, beginIndex-1)
            table.insert(res, {subString, false})
        end

        index = endIndex + 1
        local beginInex2, endIndex2 = string.find(string, endKey, index)
        if nil==beginInex2 then 
            local subString = string.sub(string, index, stringLen)
            table.insert(res, {subString, false})
            break
        end

        local subString = string.sub(string, endIndex+1, beginInex2-1)
        table.insert(res, {subString, true})
        index = endIndex2 + 1
    end

    return res 
end

--[[
    * 描述：返回匹配beginKey和endKey之间内的所有数据
    * 例子1：find("<pro.1>对敌人造成<action.1.5>当前兵力的伤害", "<", ">") = {"pro.1", "action.1.5"}
    * 例子2：find("<p>你好</p>,<p>你好2</p>", "<p>", "</p>") = {"你好", "你好2"}
--]]
function M:findSubs(string, beginKey, endKey)
    assert(string and beginKey and endKey)

    local res = {}
    local index = 1
    while true do
        local beginIndex, endIndex = string.find(string, beginKey, index)
        if nil==beginIndex then
            break
        end

        index = endIndex + 1
        local beginInex2, endIndex2 = string.find(string, endKey, index)
        if nil==beginInex2 then 
            break
        end

        local subString = string.sub(string, endIndex+1, beginInex2-1)
        table.insert(res, subString)
        index = endIndex2 + 1
    end

    return res
end

--[[
	例子 string.numToZn(100000,4,3) -->  10.000万
	例子 string.numToZn(1000,4,3) -->  1000
	digit 超过几位数转换
	retain_digit 保留小数点后面几位
]]
function M:numToZn(num, digit, retain_digit)
	assert(num and digit and retain_digit)
	local tb = {[3]="千",[4]="万",[8]="亿"}
	local strDigit = assert(tb[digit], "digit:"..digit)
	local strNum = nil
	if num >= math.pow(10, digit) then
		local format = string.format("%%0.%df%s", retain_digit, strDigit)
		--print("format:"..format)
		strNum = string.format(format,num/math.pow(10, digit))
	else
		strNum = tostring(num)
	end
	return strNum
end

-- 按指定长度插入分隔符
-- 返回列表
-- 例子: local s = "abc123ABC"
--       Log(s:insertPerLen(3, ",")) -- "abc,123,ABC,"
function M:insertPerLen(str, len, insertStr)
	local arr = {}
    local length = str:len() % len
	while str:len() >= len do
        table.insert(arr, str:sub(1, length))
		str = string.sub(str, length + 1)
        length = len
	end
    if str:len() > 0 then
	    table.insert(arr, str)
    end
	return table.concat(arr, insertStr)
end

function M:toTb(str)
    local arr = {}
    local s = nil
    local len = 1
    local lenMax = str:len()
	while true do
		if len > lenMax then
			break
		end
        s = str:sub(len, len)
        table.insert(arr, s)
        len = len + 1
	end
    return arr
end

--------------------------- 华丽分割线 ---------------------------

function M:_checkVersion(value)
    if "0"==string.sub(value, 1, 1) and 1~=string.len(value) then
        assert(false, "版本类型比较不支持0开头，比如1.01") 
    end
end

return M
