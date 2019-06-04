-- 重写 cc.Label 的 setSystemFontName 接口，修改使用的默认系统字体
cc.Label.setSystemFontNameReal = cc.Label.setSystemFontNameReal or cc.Label.setSystemFontName
cc.Label.setSystemFontName = function(self, name)
    -- 使用指定的系统字体
    self:setSystemFontNameReal(SYSTEM_FONT_NAME or name)
end

-- 重写 cc.Label 的 createWithSystemFont 接口，修改使用的默认系统字体
cc.Label.createWithSystemFontReal = cc.Label.createWithSystemFontReal or cc.Label.createWithSystemFont
cc.Label.createWithSystemFont = function(self, str, fontName, ...)
    -- 使用指定的系统字体
    fontName = SYSTEM_FONT_NAME or fontName
    return cc.Label:createWithSystemFontReal(str, fontName, ...)
end

-- 重写 cc.Label 的 create 接口，修改使用的默认系统字体
cc.Label.createReal = cc.Label.createReal or cc.Label.create
cc.Label.create = function()
    local ret = cc.Label:createReal()

    -- 使用指定的系统字体
    if SYSTEM_FONT_NAME then
        ret:setSystemFontName(SYSTEM_FONT_NAME)
    end

    return ret
end


local M = {}

--[[
    * 描述：创建Label
--]]
function M:create(string, fontName, fontSize)
    fontName = fontName or "Arial"
    fontSize = fontSize or 22
    return cc.Label:createWithSystemFont(string, fontName, fontSize)
end

return M