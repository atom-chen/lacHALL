local UIBase = import(".UIBase")
local ViewLayout = class("ViewLayout", UIBase, ccui.Layout)
function ViewLayout.getType()
    return ViewLayout.__cname
end

return ViewLayout
