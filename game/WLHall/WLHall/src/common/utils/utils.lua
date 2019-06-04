--
-- Author: Your Name
-- Date: 2016-01-07 17:26:39
--
local M = {}

function M.moneyUnit(money)
    local function fn(m, b)
        return tostring(math.ceil(m / b))
    end

    if money >= 100000000 then
        return fn(money, 100000000) .. "亿"
    elseif money >= 10000000 then
        return fn(money, 10000000) .. "千万"
    elseif money >= 1000000 then
        return fn(money, 1000000) .. "百万"
    elseif money >= 10000 then
        return fn(money, 10000) .. "万"
    elseif money >= 1000 then
        return fn(money, 1000) .. "千"
    else
        return tostring(money)
    end
end

return M