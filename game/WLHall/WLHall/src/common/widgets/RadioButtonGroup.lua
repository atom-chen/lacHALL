-- Author: zhaoxinyu
-- Date: 2016-10-17 19:44:39
-- Describe：单选框面板

local RadioButtonGroup = class("RadioButtonGroup", ccui.Layout)

--[[
* @brief 创建
* @parm txtList 文本集合
* @parm type 单选还是多选,1为单选,2为多选
]]
function RadioButtonGroup:ctor( txtList, type, fontName )

    self:setBackGroundColor({ r = 150, g = 200, b = 255 })
    self:setBackGroundColorOpacity(100)
    self:setBackGroundColorType(1)

    -- 初始化
    self:init(type)

    -- 设置文本
    if txtList then
        self:setText(txtList, fontName)
    end
end


--[[
* @brief 设置图片
* @parm  backGround 初始化图片
* @parm  selected 点击图片
]]
function RadioButtonGroup:setImg( backGround, selected )
    for k, v in pairs(self._checkBoxList) do
        v:loadTexture(backGround, selected)
    end
end

--[[
* @brief 初始化
]]
function RadioButtonGroup:init(type)

    self._checkBoxList = {} -- 单选框集合

    self._spacingH = 150 -- 默认水平间距（不计算控件宽）
    self._spacingV = 80 -- 默认垂直间距（不计算控件高）
    self._elementCountH = -1 -- 水平元素数(-1为默认一行无限显示)

    self._type = type or 1 -- 没有传值即为单选
    self._cb = nil -- 选择回调

    self._isCancelDefaultSelect = false -- 取消默认显示
end

--[[
* @brief 取消默认选择
]]
function RadioButtonGroup:cancelDefaultSelect()

    for k, v in pairs(self._checkBoxList) do
        v:setSelected(false)
    end

    self._isCancelDefaultSelect = true
end

--[[
* @brief 设置文本
* @parm txtList 文本集合
]]
function RadioButtonGroup:setText( txtList, fontName )

    -- 创建单选
    for k, v in pairs(txtList) do

        local checkBox = require("common.widgets.RadioButton"):create()
        checkBox:setText( v, nil, nil, fontName )
        self:addCheckBox(checkBox)
    end
end

--[[
* @brief 设置水平间距（不计算控件宽）
* @parm s 水平间距(像素单位)
]]
function RadioButtonGroup:setSpacingH(s)

    self._spacingH = s or 50
    self:updatePosition()
end

--[[
* @brief 设置垂直间距（不计算控件高）
* @parm s 垂直间距(像素单位)
]]
function RadioButtonGroup:setSpacingV(s)

    self._spacingV = s or 10
    self:updatePosition()
end

--[[
* @brief 设置水平元素数
* @parm c 水平元素个数
]]
function RadioButtonGroup:setElementCountH(c)

    self._elementCountH = c or -1
    self:updatePosition()
end

--[[
* @brief 设置默认选择项
* @parm index 索引
]]
function RadioButtonGroup:setDefaultSelect(index)
    if type(index) == "number" then
        for k, v in pairs(self._checkBoxList) do
            v:setSelected(false)
            if k == index then
                v:setSelected(true)
            end
        end
    elseif type(index) == "table" then
        for k,v in pairs(self._checkBoxList) do
            v:setSelected(false)
        end
        for i,v in ipairs(index) do
            if self._checkBoxList[v] then
                self._checkBoxList[v]:setSelected(true)
            end
        end
    end
end

--[[
* @brief 设置选择回调
* @parm cb 回调
]]
function RadioButtonGroup:setSelectCallBack(cb)

    self._cb = cb
end

--[[
* @brief 设置文字大小和颜色
* @parm fontSize
* @parm fontColr
]]
function RadioButtonGroup:setFontInfo(fontSize, fontColr, fontName)

    for k, v in pairs(self._checkBoxList) do

        local txt = v:getText()

        if txt then
            if fontSize then
                txt:setFontSize(fontSize)
            end
            if fontColr then
                txt:setTextColor(fontColr)
            end
            if fontName then
                txt:setFontName(fontName)
            end
        end
    end
end

-- 调整文本的y坐标
function RadioButtonGroup:changeBtnTitlePosY( addY )
    for k, v in pairs(self._checkBoxList) do
        local txt = v:getText()
        if txt then
            txt:setPositionY( txt:getPositionY() + addY )
        end
    end
end

--[[
* @brief 添加单选框到单选面板
* @parm cb 单选框
]]
function RadioButtonGroup:addCheckBox(cb)

    assert(cb, "cb can't null！")

    -- 插入单选集合
    table.insert(self._checkBoxList, cb)

    -- 默认选择第一个添加的
    if not self._isCancelDefaultSelect then
        local b = #self._checkBoxList <= 1
        cb:setSelected(b)
    end

    -- 添加事件
    cb:addSelectListener(handler(self, self.onSelectedEvent))

    -- 添加到panel上
    self:addChild(cb)

    -- 刷新排列
    self:updatePosition()
end

--[[
* @brief 添加单选框集合
* @parm cbs 单选框集合
]]
function RadioButtonGroup:addCheckBoxs(cbs)

    assert(cbs, "cbs can't null！")
    assert(type(cbs) == "table", "cbs must be table！")

    -- 遍历添加
    for k, v in pairs(cbs) do

        self:addCheckBox(v)
    end
end

--[[
* @brief 获取被选择的单选索引
]]
function RadioButtonGroup:getSelectIndex()
    if self._type == 1 then
        for k, v in pairs(self._checkBoxList) do

            if v:isSelected() then
                return k
            end
        end
    else
        local indexTable = {}

        for k, v in pairs(self._checkBoxList) do

            if v:isSelected() then
                table.insert(indexTable, k)
            end
        end
        return indexTable
    end

end

--[[
* @brief 选择事件
]]
function RadioButtonGroup:onSelectedEvent(sender)
    if self._type == 1 then

        local index = 1
        -- 重置所有单选
        for k, v in pairs(self._checkBoxList) do

            v:setSelected(false)

            if v==sender then
                index = k
            end

        end

        -- 设置选择单选
        sender:setSelected(true)

        if self._cb then
            self._cb(index)
        end

    else

        -- 设置按钮状态
        if sender:isSelected() then
            sender:setSelected(false)
        else
            sender:setSelected(true)
        end

        for k, v in pairs(self._checkBoxList) do

            if self._cb and v == sender then

                self._cb(k)

            end

        end

    end
end

--[[
* @brief 排一行（默认排列）
]]
function RadioButtonGroup:defaultArray()

    if #self._checkBoxList <= 0 then
        return
    end

    local lastW = 0

    for i = 1, #self._checkBoxList do

        local cb = self._checkBoxList[i]
        cb:setPositionX(lastW)
        lastW = lastW + cb:getContentSize_().width + self._spacingH
    end
end

--[[
* @brief 刷新所有单选框位置(根据水平间距、垂直间距、水平元素数 )
]]
function RadioButtonGroup:updatePosition()

    for i = 1, #self._checkBoxList do

        -- 计算应在的列
        local xn = gg.IIF(self._elementCountH == -1, (i - 1), (i - 1) % self._elementCountH)

        -- 应在的行
        local yn = gg.IIF(self._elementCountH == -1, 0, math.floor((i - 1) / self._elementCountH))

        local cb = self._checkBoxList[i]
        cb:setPositionX(xn * self._spacingH)
        cb:setPositionY(0 - yn * self._spacingV)
    end
end

-- 刷新所有可见单选框按钮位置
function RadioButtonGroup:resetVisibleCbPos( )
    local newTb = {}
    for i = 1, #self._checkBoxList do
        local cb = self._checkBoxList[i]
        if cb:isVisible() then
            table.insert( newTb, cb )
        end
    end

    for i,cb in ipairs(newTb) do
        -- 计算应在的列
        local xn = gg.IIF(self._elementCountH == -1, (i - 1), (i - 1) % self._elementCountH)
        -- 应在的行
        local yn = gg.IIF(self._elementCountH == -1, 0, math.floor((i - 1) / self._elementCountH))
        cb:setPositionX(xn * self._spacingH)
        cb:setPositionY(0 - yn * self._spacingV)
    end
end

return RadioButtonGroup