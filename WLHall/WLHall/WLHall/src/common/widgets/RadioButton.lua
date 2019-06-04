
-- Author: zhaoxinyu
-- Date: 2016-10-17 19:45:25
-- Describe：单选框

local RadioButton = class("RadioButton", ccui.CheckBox)


local space = 5 -- 文字和图片的间隙
local panelW = 6 -- 点击区域多留出宽度
local panelH = 20 -- 点击区域多留出高度
local DEFAULT_FONTSIZE = 30     -- 默认按钮字体大小，界面改动需要跟着修改下这个值

function RadioButton:ctor()

    -- 默认资源设置
    self:loadTextureBackGround("hall/common/cb_single_nor.png", 1)
    self:loadTextureBackGroundSelected("hall/common/cb_single_nor.png", 1)
    self:loadTextureBackGroundDisabled("hall/common/cb_single_nor.png", 1)
    self:loadTextureFrontCross("hall/common/cb_single_act.png", 1)
    self:loadTextureFrontCrossDisabled("hall/common/cb_single_act.png", 1)
end

--[[
* @brief 资源设置
* @parm  backGround 背景
* @parm  selected 选中
]]
function RadioButton:loadTexture( backGround , selected )

    if backGround then

        self:loadTextureBackGround( backGround, 1)
        self:loadTextureBackGroundSelected( backGround, 1)
        self:loadTextureBackGroundDisabled( backGround, 1)
    end

    if selected then

        self:loadTextureFrontCross(selected, 1)
        self:loadTextureFrontCrossDisabled(selected, 1)
    end
end

--[[
* @brief 设置选择文本
* @parm  txt 文本
* @parm  color 文本颜色
* @parm  fontSize 文本大小
]]
function RadioButton:setText(txt, color, fontSize, fontName)

    -- 避免重复设置文本
    if self.txt_ then
        self.txt_:removeFromParent(true)
        self.txt_ = nil
    end

    if self.panel_ then
        self.panel_:removeFromParent(true)
        self.panel_ = nil
    end

    -- 创建文本控件
    local txt_ = ccui.Text:create()
    txt_:setString(txt or "")
    txt_:setFontSize(fontSize or DEFAULT_FONTSIZE)
    fontName = fontName or SYSTEM_FONT_NAME or ""
    txt_:setFontName( fontName )
    txt_:setTextColor(color or { r = 84, g = 52, b = 14 })
    txt_:setAnchorPoint(cc.p(0, 0.55))
    txt_:setTouchEnabled(true)
    txt_:setName("txt")

    -- 设置文本位置
    local size = self:getContentSize()
    txt_:setPositionY(size.height / 2)
    txt_:setPositionX(size.width + space)
    self:addChild(txt_)

    -- 点击事件
    txt_:addClickEventListener(handler(self, self.onClickEvent))

    -- 记录文本控件
    self.txt_ = txt_

    -- 添加点击层
    local panel = ccui.Layout:create()
    panel:setContentSize(cc.size(size.width + space + txt_:getContentSize().width + panelW, self:getContentSize().height + panelH))
    self:addChild(panel)
    -- panel:setBackGroundColor( { r = 20 ,g = 20 , b = 20 } )
    -- panel:setBackGroundColorType(1)
    -- panel:setBackGroundColorOpacity(200)
    panel:setPosition(0 - panelW / 2, 0 - panelH / 2)
    panel:setTouchEnabled(true)
    panel:addClickEventListener(handler(self, self.onClickEvent))
    panel:setName( "touchPanel" )

    self.panel_ = panel
end

--[[
* @brief 获取设置文本
]]
function RadioButton:getText()

    return self:getChildByName("txt")
end

-- 获取点击层
function RadioButton:getTouchPanel( )
    return self:getChildByName("touchPanel")
end

--[[
* @brief 获取控件大小
]]
function RadioButton:getContentSize_()

    local width = self:getContentSize().width + gg.IIF(self.txt_ == nil, 0, self.txt_:getContentSize().width) + space
    local height = self:getContentSize().height

    return { width = width, height = height }
end

--[[
* @brief 添加选择事件
* @parm callback 事件回调
]]
function RadioButton:addSelectListener(callback)

    assert(self._callback == nil, "can't repeat addSelectListener！")

    -- 赋值回调
    self._callback = callback

    -- 添加事件
    self:addEventListener(handler(self, self.onSelectedEvent))
end

--[[
* @brief 文本点击事件
]]
function RadioButton:onClickEvent(sender, eventType)
    -- 事件回调
    if self._callback then
        self._callback(sender:getParent())
    end
end

--[[
* @brief 选择事件
]]
function RadioButton:onSelectedEvent(sender, eventType)

    -- 设置选择单选
    -- sender:setSelected(true)

    -- 事件回调
    if self._callback then

        self._callback(sender)
    end
end

return RadioButton


