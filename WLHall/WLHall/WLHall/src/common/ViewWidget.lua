--[[
* @brief 定义
--]]
-- local ViewBase = require("common.ViewBase");
local UIBase = require("common.UIBase")
local ViewWidget = class("ViewWidget", UIBase, function(root)
    if nil == root then
        root = ccui.Widget:create();
        root:setContentSize(cc.size(1280, 720));
        root:setAnchorPoint(cc.p(0, 0));
    end
    return root;
end)

function ViewWidget:ctor(root)
    UIBase.ctor(self);
end



return ViewWidget;
