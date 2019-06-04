local M = class("libs.widget.ButtonSwitch", cc.Node)
local kDuration = 0.2

--[[
    * 描述：Switch按钮
--]]
function M:createWithSprite(onSprite, offSprite, thumbSprite)
    return M.new():_initWithSprite(onSprite, offSprite, thumbSprite)
end

function M:createWithFile(onFile, offFile, thumbFile)
    local onSprite = cc.Sprite:create(onFile)
    local offSprite = cc.Sprite:create(offFile)
    local thumbSprite = cc.Sprite:create(thumbFile)
    return createWithSprite(onSprite, offSprite, thumbSprite)
end

--[[
    * 描述：设置开关状态
    * 参数：unAnimate默认不传为false
--]]
function M:setOn(isOn, unAnimate)
    self._isOn = isOn
    self:_changeState(unAnimate)
end

function M:isOn()
    return self._isOn
end

--------------------------- 华丽分割线 ---------------------------

function M:_initWithSprite(onSprite, offSprite, thumbSprite)
    assert(onSprite)
    assert(offSprite)
    assert(thumbSprite)
    self._isOn = true

    self._contentSize = onSprite:getContentSize()
    self:addChild(offSprite)
    self:addChild(onSprite)
    self._onSprite = onSprite
    self._offSprite = offSprite

    ButtonEmpty:createWithSize(self._contentSize)
        :addTo(self)
        .onClicked = function()
            self:_onClickAction()
        end

    local spriteFrame = thumbSprite:getSpriteFrame()
    self._thumbBt = Button:createWithSpriteFrame(spriteFrame)
                        :addTo(self)
    self._thumbBt.onClicked = function()
            self:_onClickAction()
        end

    self:setOn(true, false)
    return self
end

function M:_getOnStatePosition()
    local half = self._contentSize.width/2
    local thumbHalf = self._thumbBt:getContentSize().width/3
    return self._isOn and cc.p(half-thumbHalf, 0) 
                            or cc.p(-half+thumbHalf, 0)
end

function M:_onClickAction()
    self:setOn(not self._isOn, true)
    if self.onClicked then
        self.onClicked(self)
    end
end

function M:_changeState(isAnimate)
    if isAnimate then
        self:_animate(kDuration)    
    else 
        self:_unAnimate()
    end 
end

function M:_animate(duration)
    local pos = self:_getOnStatePosition()
    Action:newSequence()
        :moveTo(duration, pos)
        :run(self._thumbBt)

    if self._isOn then
        Action:newSequence()
            :scaleTo(duration, 1)  
            :run(self._onSprite)
    else 
        Action:newSequence()
            :scaleTo(duration, 0)  
            :run(self._onSprite)
    end
end

function M:_unAnimate()
    local pos = self:_getOnStatePosition()
    self._thumbBt:setPosition(pos)

    local scale = self._isOn and 1 or 0
    self._onSprite:setScale(scale)
end

return M