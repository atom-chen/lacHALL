local TabGroup = class("TabGroup", cc.Node)
local LuaExtend = require "LuaExtend"

--[[
* @brief buttonType, 按钮类型：0-按钮上添加精灵的形式 1-根据传过来的图片设置按钮 2-根据传过来的item对象   
* @brief fn, 回调函数
* @brief isV, 布局方向：true-垂直方向 false-水平方向
* @brief offset, 按钮间距
 ]]--
function TabGroup:ctor(buttonType, fn, isV, offset, ...)
    self:setFunc(fn)                    -- 设置回调函数
    self.isV = isV                      -- 布局方向
    self.offset = offset                -- 按钮间距
    self.index = 1                      -- 被点击的按钮位置,默认点击第一个按钮
    self.buttonType = buttonType        -- 按钮类型
    self.buttonTable = {}               -- 用于存储TabGroup中的所有按钮
    -- 根据按钮类型来创建TabGroup
    if self.buttonType == 0 then
        self:createByNode(...)
    elseif self.buttonType == 1 then
        self:createByImageName(...)
    elseif self.buttonType == 2 then
        self:createByItems(...)
    end
end

-- 传入的数据为图片
function TabGroup:createByImageName(imageTable)
    for i, img in ipairs(imageTable) do
        local btn = require("common.tabgroup.TabGroupItem"):create(img[1], img[2])
        table.insert(self.buttonTable, btn)
        btn:onClick(handler(self, self.onClick), 1)
    end
    self:initView()
end

-- 传入的数据为图片和对象
function TabGroup:createByNode(nor_img, act_img, nodeTable)
    for i, node in ipairs(nodeTable) do
        local btn = require("common.tabgroup.TabGroupItem"):create(nor_img, act_img)
        btn:setSpritNode( node[1], node[2] )
        table.insert(self.buttonTable, btn)
        btn:onClick(handler(self, self.onClick), 1)
    end
    self:initView()
end

-- 传入的数据为已经创建好的button
function TabGroup:createByItems(itemTable)
    for i, item in ipairs(itemTable) do
        table.insert(self.buttonTable, item)
        item:onClick(handler(self, self.onClick), 1)
    end
    self:initView()
end

-- 初始化所有按钮
function TabGroup:initView()
    -- 设置按钮位置
    for i, btn in ipairs(self.buttonTable) do
        local curOffset = self.offset * (i - 1)
        if self.isV then
            btn:setPosition(0, -curOffset)
        else
            btn:setPosition(curOffset, 0)
        end
        self:addChild(btn)
    end
    self:frushView()
end

-- 重置所有按钮位置
function TabGroup:resetBtnPos()
    local curOffset = 0
    for i, btn in ipairs(self.buttonTable) do
        if btn:isVisible() then
            if self.isV then
                btn:setPosition(0, -curOffset)
            else
                btn:setPosition(curOffset, 0)
            end
            curOffset = curOffset + self.offset
        end
    end
    self:frushView()
end

-- 设置回调函数
function TabGroup:setFunc(fn)
    self.fn = fn
end

-- 设置按钮对应二级窗口
function TabGroup:setButtonChildView(index, obj)
    self.buttonTable[index].child_view = obj
end

-- 获取对应index的按钮
function TabGroup:getButton(index)
    return self.buttonTable[index]
end

-- 获取所有按钮
function TabGroup:getButtons()
    return self.buttonTable
end

-- 获取与设置选中的按钮的位置
function TabGroup:getIndex()
    return self.index
end

-- 设置点击按钮
function TabGroup:setIndex(index)
    self.index = index
    self:frushView()
    return self:getButton(self.index)
end

-- 获得当前选中按钮
function TabGroup:getCurButton()
    return self.buttonTable[self.index]
end

-- 获取当前被点击按钮所对应的二级界面
function TabGroup:getCurButtonChildView()
    return self.buttonTable[self.index].child_view
end

-- 设置按钮上添加的对象
function TabGroup:setButtonNode(index, nor_node, act_node)
    if self.buttonType == 1 or self.buttonType == 2 then
        print("这个方法不支持这种tab")
        return
    end
    self.buttonTable[index]:setSpritNode( nor_node, act_node )
end

-- 点击
function TabGroup:onClick(obj)
    for index, btn in ipairs(self.buttonTable) do
        if btn == obj then
            self:setIndex(index)
            if self.fn then self.fn(self,btn) end
            return
        end
    end
end

-- 刷新
function TabGroup:frushView()
    -- 选中按钮
    for i, btn in ipairs(self.buttonTable) do
        local bo = i == self.index
        btn:setAct(bo)
    end
    -- 切换视图
    for index, btn in ipairs(self.buttonTable) do
        -- 初始化,隐藏所有二级界面
        if btn.child_view ~= nil then btn.child_view:setVisible(false) end
        -- 显示对应点击按钮对应的二级界面
        if index == self:getIndex() then
            if btn.child_view ~= nil then btn.child_view:setVisible(true) end
        end
    end
end

return TabGroup