local M = {}

--[[
    * 描述：写入信息到文件
    * 参数：text文件内容
    * 参数：fullPath完整路径名 /root/Document/test.txt
--]]
function M:writeToFile(text, fullPath)
    assert(text)
    assert(fullPath)
	local handle = io.open(fullPath, 'w')
    if not handle then
        return false
    end

    handle:write(text)
    handle:close()
    return true
end

function M:readToFile(fullPath)
    assert(fullPath)
    local file = io.open(fullPath, "r");
    if not file then
        return nil
    end
    
    local data = file:read("*a")
    file:close()
    
    return data
end

--[[
    * 描述：文件是否存在
--]]
function M:isFileExist(fullPath)
    assert(fullPath)
    local handle = io.open(fullPath, 'r')
    if handle then
        handle:close()
    end
    return handle ~= nil 
end

--[[
    * 描述：获取文件名
    * 示例：name.png -> name
--]]
function M:getFileName(str)
    assert(str)
    local idx = str:match(".+()%.%w+$")
    if(idx) then
        return str:sub(1, idx-1)
    else
        return str
    end
end

--[[
    * 描述：获取扩展名
    * 示例：name.png -> png
--]]
function M:getExtension(str)
    assert(str)
    return str:match(".+%.(%w+)$")
end

return M