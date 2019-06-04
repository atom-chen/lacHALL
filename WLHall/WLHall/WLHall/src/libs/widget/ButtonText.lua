--[[
    * 描述：带文字显示按钮
    * 其他：参考Button
--]]
local M = class("libs.widget.ButtonText", function(normalImageName)
    assert(nil==normalImageName, "请使用createWithFileName或createWithSpriteFrame替代.new")
	return cc.Node:create()
end)

function M:createWithFileName(normalImageName, highligtedImageName, disabledImageName)
    local buttonText = M.new()

    local button = require("libs.widget.Button"):createWithFileName(normalImageName, highligtedImageName, disabledImageName)
    buttonText:addChild(button)
    buttonText:_initContent(button)

    return buttonText
end

function M:createWithSpriteFrame(normalSpriteFrame, highlightdSpriteFrame, disableSpriteFrame)
    local buttonText = M.new()

    local button = require("libs.widget.Button"):createWithSpriteFrame(normalSpriteFrame, highlightdSpriteFrame, disableSpriteFrame)
    buttonText:addChild(button)
    buttonText:_initContent(button)

    return buttonText
end

--[[
    * 描述：统一创建文字按钮的默认参数配置，设置一次即可
    * 参数strokeColor：描边颜色
    * 参数strokeSize：描边大小，int类型
--]]
local m_fontName    = "STHeitiSC-Medium"
local m_textColor   = cc.c4b(255, 255, 255, 255)
local m_strokeColor = cc.c4b(0, 0, 0, 255)
local m_strokeSize  = 3
function M:setDefalutConfig(fontName, textColor, strokeColor, strokeSize)
    assert(fontName and textColor and strokeColor and strokeSize)
    m_fontName      = fontName
    m_textColor     = textColor
    m_strokeColor   = strokeColor
    m_strokeSize    = strokeSize
end

function M:setString(text, fontSize)
    self._textLabel:setString(text)
    self._textLabel:setSystemFontSize(fontSize and fontSize or 30)
end

function M:getLabel()
    return self._textLabel
end

function M:getText()
    return self._textLabel:getString()
end

function M:setText(text)
    self._textLabel:setString(text)
end

function M:setTextColor(color)
    self._textLabel:setTextColor(color)
end

function M:setSystemFontSize(size)
    self._textLabel:setSystemFontSize(size)
end

--------------------------------- 接口分割线 ---------------------------------
function M:_initContent(button)
    button.onClicked = function()
        if self.onClicked then
            self.onClicked(self)
        end
    end

    local size = button:getContentSize()
    button:setPosition(cc.p(size.width/2, size.height/2))
    self:setContentSize(size)
    self:setAnchorPoint(cc.p(0.5,0.5))

    local label = cc.Label:create()
    label:setSystemFontName(m_fontName)
    label:setTextColor(m_textColor)
    label:enableOutline(m_strokeColor, m_strokeSize)
    label:setHorizontalAlignment(1)
    local size = self:getContentSize()
    label:setPosition(cc.p(size.width/2, size.height/2))
    self:addChild(label)
    self._textLabel = label
    self._textLabel:setLocalZOrder(1)
end 

return M


