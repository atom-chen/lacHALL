local M = {}

function M:centerBySize(size)
    return cc.p(size.width*0.5, size.height*0.5)
end

return M