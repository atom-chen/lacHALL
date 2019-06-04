local M = {}

local HttpParams= require("common.utils.HttpParams")

--[[
    * 描述：编码
--]]
function M:encodeURI(url)
    local newUrl = string.gsub(url, "([^%w%.%- ])", function(c) return string.format("%%%02X", string.byte(c)) end)
    return string.gsub(newUrl, " ", "+")
end

--[[
    * 描述：解码
--]]
function M:decodeURI(url)
    local newUrl = string.gsub(url, '%%(%x%x)', function(h) return string.char(tonumber(h, 16)) end)
    return newUrl
end

--[[
    * 为 url 增加参数
]]
function M:addParams(url, params)
    local newUrl = url
    local paramStr = HttpParams:BuildQuery(params)
    if paramStr ~= "" then
        if string.find(newUrl, "?") then
            newUrl = newUrl.."&"..paramStr
        else
            newUrl = newUrl.."?"..paramStr
        end
    end

    return newUrl
end

return M