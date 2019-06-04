--[[
    * 描述：统一按钮入口
    * 参数normalImageName：文件名
    * 参数：highligtedImageName和disabledImageName可以为空，为空时使用normalImageName加shader方式表现高亮和灰色
    * 点击事件：onClicked(button)
--]]
local GLProgram = require("libs.widget.GLProgram")
local M = class("libs.widget.Button", function(normalImageName)
    assert(nil==normalImageName, "请使用createWithFileName或createWithSpriteFrame替代.new")
	return cc.ControlButton:create()
end)

function M:createWithFileName(normalImageName, highligtedImageName, disabledImageName)
    return M.new():_initWithFileName(normalImageName, highligtedImageName, disabledImageName)
end

function M:createWithSpriteFrame(normalSpriteFrame, highlightdSpriteFrame, disableSpriteFrame)
    return M.new():_initWithSpriteFrame(normalSpriteFrame, highlightdSpriteFrame, disableSpriteFrame)
end

function M:setContentSize(size)
    self:getBackgroundSpriteForState(cc.CONTROL_STATE_NORMAL):setScale9Enabled(true)
    self:getBackgroundSpriteForState(cc.CONTROL_STATE_HIGH_LIGHTED):setScale9Enabled(true)
    self:getBackgroundSpriteForState(cc.CONTROL_STATE_DISABLED):setScale9Enabled(true)
    
    self:setPreferredSize(size) 
end

--[[
    * 描述：触发点击事件后是否截住事件，true事件不会往下传递，false事件往下传递
           主要用于滚动视图，点击按钮后还可以拖动视图
--]]
function M:setSwallowTouches(enable)
    local dispatcher = cc.Director:getInstance():getEventDispatcher()
    dispatcher:removeEventListenersForTarget(self)
    self._isHightlight = false 
    Touch:registerTouchOneByOne(self, enable)
    return self
end

-------------------------------- 接口分割线 --------------------------------
function M:_initWithFileName(normalImageName, highligtedImageName, disabledImageName)
    assert(normalImageName)
    local normalSprite = ccui.Scale9Sprite:create(normalImageName)
    self:_setNormalSprite(normalSprite)
    
    local highlightImage = highligtedImageName and highligtedImageName or normalImageName
    local highlightSprite = ccui.Scale9Sprite:create(highlightImage)
    self:_setHighlightedSprite(highlightSprite, nil==highligtedImageName)

    local disabledImage = disabledImageName and disabledImageName or normalImageName
    local disabledSprite = ccui.Scale9Sprite:create(disabledImage)
    self:_setDisalbeSprite(disabledSprite, nil==disabledImageName)

    self:_registerControlEvent()
    return self
end

function M:_initWithSpriteFrame(normalSpriteFrame, highlightdSpriteFrame, disableSpriteFrame)
    assert(normalSpriteFrame)
    local normalSprite = ccui.Scale9Sprite:createWithSpriteFrame(normalSpriteFrame)
    self:_setNormalSprite(normalSprite)

    local highlightImage = highlightdSpriteFrame and highlightdSpriteFrame or normalSpriteFrame
    local highlightSprite = ccui.Scale9Sprite:createWithSpriteFrame(highlightImage)
    self:_setHighlightedSprite(highlightSprite, nil==highlightdSpriteFrame)

    local disabledImage = disableSpriteFrame and disableSpriteFrame or normalSpriteFrame
    local disabledSprite = ccui.Scale9Sprite:createWithSpriteFrame(disabledImage)
    self:_setDisalbeSprite(disabledSprite, nil==disableSpriteFrame)

    self:_registerControlEvent()
    return self
end

function M:_registerControlEvent()
    self:registerControlEventHandler(function()
        if self.onClicked then
            self.onClicked(self)
        end
    end, cc.CONTROL_EVENTTYPE_TOUCH_UP_INSIDE)
end

function M:_setNormalSprite(normalSprite)
    normalSprite:setScale9Enabled(false)
    self:setPreferredSize(normalSprite:getContentSize())
    self:setBackgroundSpriteForState(normalSprite, cc.CONTROL_STATE_NORMAL)
end

function M:_setHighlightedSprite(highlightSprite, useGLProgram)
    self:setBackgroundSpriteForState(highlightSprite, cc.CONTROL_STATE_HIGH_LIGHTED)
    if useGLProgram then 
        highlightSprite:setScale9Enabled(false)
        local sprite = highlightSprite:getSprite()
        assert(sprite, "错误提示：初始化的文件不存在")
        sprite:setGLProgramState(GLProgram:getHighlightButtonState())
    end
end

function M:_setDisalbeSprite(disabledSprite, useGLProgram)
    self:setBackgroundSpriteForState(disabledSprite, cc.CONTROL_STATE_DISABLED)
    if useGLProgram then 
        disabledSprite:setScale9Enabled(false)
        disabledSprite:getSprite():setGLProgramState(GLProgram:getGray())
    end
end

function M:onTouchBegan(touch, event)
    local hidden = self:_findParent(self, function(parent)
        return not parent:isVisible()
    end, true)

    if hidden then 
        return false
    end

    if not self:isEnabled() then 
        return false
    end

    if Touch:isTouchHitted(self, touch) then 
        self._isHightlight = true 
        self:setHighlighted(true)
        return true
    end
    
    return false
end

function M:onTouchMoved(touch, event)
    local hitTest = Touch:isTouchHitted(self, touch)
    if hitTest ~= self._isHightlight then
        self._isHightlight = hitTest
        self:setHighlighted(hitTest)
    end
end 

function M:onTouchEnded(touch, event)
    self._isHightlight = false
    self:setHighlighted(false)
    if Touch:isTouchHitted(self, touch) then
        if self.onClicked then
            self.onClicked(self)
        end
    end
end

function M:onTouchCancelled(touch, event)
    self:onTouchEnded(touch, event)
end

function M:_findParent(node, func, includeSelf)
    local parent = includeSelf and node or node:getParent()
    while parent do
        if func(parent) then
            break
        end
        parent = parent:getParent()
    end
    return parent
end

return M


