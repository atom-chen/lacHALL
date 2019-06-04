local M = {}

function M:safeCall(obj, funName, ...)
    if obj and obj[funName] then
        return obj[funName](...)
    end
end

return M