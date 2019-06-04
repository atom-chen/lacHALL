
-- 重写 ccui.Text.setFontName 接口，修改使用的默认系统字体
ccui.Text.setFontNameReal = ccui.Text.setFontNameReal or ccui.Text.setFontName
ccui.Text.setFontName = function(self, name)
    if not name or name == "" then
        -- 使用指定的系统字体
        self:setFontNameReal(SYSTEM_FONT_NAME or "")
    else
        self:setFontNameReal(name)
    end
end

-- 重写 cccui.Text.create 接口，修改使用的默认系统字体
ccui.Text.createReal = ccui.Text.createReal or ccui.Text.create
ccui.Text.create = function (self, str, fontName, fontSize)
    local ret = ccui.Text:createReal()
    ret:setFontName(fontName)
    if fontSize then
        ret:setFontSize(fontSize)
    end
    if str then
        ret:setString(str)
    end
    return ret
end
