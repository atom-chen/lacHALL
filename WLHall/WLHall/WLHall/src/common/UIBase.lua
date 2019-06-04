local UIBase = class("UIBase", cc.Node)

function UIBase.getType()
    return UIBase.__cname
end

function UIBase:ctor(name, ...)
    if name and string.len(name) > 0 then
        self:setName(tostring(name))
    end
    self.resourceNode_ = nil
    local res = rawget(self.class, "RESOURCE_FILENAME")
    if res then
        self:createResourceNode(res)
    else
        local luaExtend = require "LuaExtend"
        self.resourceNode_ = {}
        setmetatable(self.resourceNode_, luaExtend)
        self.resourceNode_.root = self
    end

    local binding = rawget(self.class, "RESOURCE_BINDING")
    local soundpath = rawget(self.class, "RESOURCE_CLICK_SOUND")
    if binding then --res and
        self:createResourceBinding(binding,soundpath)
    end 
    if not self.override_create_ and self.onCreate then self:onCreate(...) end
end

-- 根据name获取子节点 包括ui节点 子节点中不可出现重名
function UIBase:child(name)
    local child = self:getChildByName(name)
    local res_ui = self.resourceNode_
    if not child and res_ui then
        return res_ui[name]
    end
    return child
end

function UIBase:runFrameAnimation(startframe)
    startframe=startframe or 1    
    local ani= checktable(self.resourceNode_).animation
    if ani then
        self:runAction(ani)
        ani:gotoFrameAndPlay(startframe)
    end 
    return self
end

function UIBase:createResourceNode(resourceFilename)
    if self.resourceNode_ then
        self.resourceNode_.root:removeSelf()
        self.resourceNode_ = nil
    end

    local lua_ui = require(resourceFilename).create()
    if lua_ui then
        self:addChild(lua_ui.root)
        self.resourceNode_ = lua_ui
        local resolution = rawget(self.class, "AUTO_RESOLUTION") --layer分辨率自适应
        local com = lua_ui.root:getComponent(__LAYOUT_COMPONENT_NAME)
        if com and resolution then
            com:setSize(display.size)
            com:refreshLayout()
        end
    end
end

function UIBase:getRootNode()
    return self.resourceNode_.root
end

function UIBase:createResourceBinding(binding,soundpath)
    local res_node = self.resourceNode_
    for nodeName, nodeBinding in pairs(binding) do
        local node = res_node[nodeName]
        assert(node, "UIBase:createResourceBinding() -资源未找到:" .. nodeBinding.varname)
        if nodeBinding.varname and node then
            self[nodeBinding.varname] = node
        end
        for _, event in pairs(nodeBinding.events or {}) do

            if event.event == "touch" then
                node:onTouch(handler(self, self[event.method]))
            elseif event.event == "click" then
                node:onClickScaleEffect(handler(self, self[event.method]),soundpath)
            elseif event.event == "click_color" then
                node:onClickDarkEffect(handler(self, self[event.method]),soundpath)
            end
        end
    end
end

function UIBase:doLayout(layer)
    --重新布局
    layer:setContentSize(display.size)
    ccui.Helper:doLayout(layer)
end

return UIBase
