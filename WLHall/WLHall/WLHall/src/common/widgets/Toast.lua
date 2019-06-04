--
-- Author: lee
-- Date: 2016-01-12 10:23:27
local Toast = class("Toast", cc.Node)

Toast.GRAVITY_TOP = 2
Toast.GRAVITY_CENTER = 1
Toast.GRAVITY_BOTTOM = 0

Toast.LENGTH_LONG = 1
Toast.LENGTH_SHORT = 0

local BG = "common/toast_bg.png"
-- 吴总要求：Toast 提示的背景使用固定宽度与高度，遇到显示不下的情况，调整文字内容来解决
local BG_WIDTH = 665
local BG_HEIGHT = 65

function Toast:ctor(parent, text, duration, gravity, params)
    params = params or {}
    self.gravity_ = gravity or Toast.GRAVITY_BOTTOM
    self.duration_ = duration or Toast.LENGTH_LONG
    self.parent_ = parent or display.getRunningScene()
    self.text_ = text or "text is nil"
    self._imgBg = params.img or BG
    self._useSystemFont = params.useSystemFont or false
    self._fontSize = params.fontSize or 35
    self:setPosition(display.cx, display.height * (params.location or 0.6) )
end

function Toast:makeToast(msg, duration, gravity)
    return Toast.new(nil, msg, duration, gravity)
end

function Toast:createToast_(msg, img, time)
    local sprite = display.newSprite(img, { scale9 = true })
    local label = nil
    -- 默认也使用系统字体
    if self._useSystemFont then
        label = cc.Label:createWithSystemFont(msg, "Arial", self._fontSize)
    else
        label = cc.Label:createWithSystemFont(msg, "Arial", self._fontSize)
    end
    local size = label:getContentSize()
    sprite:setContentSize(cc.size(BG_WIDTH, BG_HEIGHT))
    sprite:setAnchorPoint(0.5, 0.5)
    self:addChild(sprite)
    self:addChild(label, 1)
    local seq1 = cc.Sequence:create(cc.FadeIn:create(time / 5), cc.DelayTime:create(time / 5 * 1.5), cc.FadeOut:create(time / 5 * 2.5));
    local seq2 = cc.Sequence:create(cc.EaseSineIn:create(cc.MoveBy:create(time / 5, cc.p(0, 50))),
        cc.DelayTime:create(time / 5 * 2),
        cc.EaseSineOut:create(cc.MoveBy:create(time / 3, cc.p(0, -50))), cc.CallFunc:create(function() self:cancel() end));
    local spawn = cc.Spawn:create(seq1, seq2);
    local action = cc.Repeat:create(spawn, 1);
    local action2 = action:clone()
    --背景sprite,文字label运行action   先向上缓动移动100,在向下缓动移动50,并结合淡入淡出,最后消失
    sprite:runAction(action2);
    label:runAction(action);
    return self
end

function Toast:show()
    self:createToast_(self.text_, self._imgBg, 3)
    self:setVisible(true)
    self.parent_:addChild(self, 9910)
    return self
end

function Toast:cancel()
    self:removeSelf()
end

function Toast:showListToast( callback, count )
    self._callback = callback
    self:createListToast( self.text_, self._imgBg, 3, count )
    self.parent_:addChild(self, 9910)
    return self
end

function Toast:createListToast( txt, img, time, count )

    if count >= 3 then
        count = 3
    end

    local bg = display.newSprite(img, { scale9 = true })
    bg:setAnchorPoint(0.5, 0.5)
    bg:setOpacity(0)
    bg:setName( "toast_bg" )
    self:addChild(bg)

    local label = nil
    -- 默认也使用系统字体
    if self._useSystemFont then
        label = ccui.Text:create(txt, "Arial", self._fontSize)
    else
        label = ccui.Text:create(txt, "Arial", self._fontSize)
    end
    label:setColor( {r=255,g=255,b=255} )
    label:setOpacity(0)
    label:setName( "toast_txt" )
    local size = label:getContentSize()
    bg:setContentSize(cc.size(BG_WIDTH, BG_HEIGHT))
    self:addChild(label, 1)

    local seq1 = cc.Sequence:create(
                                    cc.FadeIn:create( 0.2 ),
                                    cc.DelayTime:create( 2 ),
                                    cc.FadeOut:create( 0.2 )
                                    )
    local seq2 = cc.Sequence:create(
                                    cc.EaseSineIn:create( cc.MoveBy:create( 0.8, cc.p(0, display.height * 0.1 - (count-1) * 50 ))),
                                    cc.DelayTime:create( 1.8 ),
                                    cc.CallFunc:create(function() self:changeCount() end)
                                    )
    local spawn = cc.Spawn:create( seq1, seq2 )
    local bg_action = cc.Repeat:create(spawn, 1)
    local lb_action = bg_action:clone()

    bg:runAction(bg_action);
    label:runAction(lb_action);

    return self

end

function Toast:changeCount( )

    if not self._alreadyCall then
        if self._callback then self._callback( self ) end
        self._alreadyCall = true -- 用于控制,只调用一次方法
        self:removeFromParent()
    end

end

function Toast:removeToast()
    self:removeSelf()
end

return Toast