local M = class("RechargeSuccessAni", cc.load("ViewBase"))

function M:onCreate()
    local panel_bg = ccui.Layout:create()
    panel_bg:setTouchEnabled(true)
    panel_bg:setContentSize(cc.size(display.width, display.height))
    self:addChild(panel_bg, -1)

    self._aniNode = cc.Node:create()
    self._aniNode:setPosition(cc.p(display.cx, display.cy))
    self:addChild(self._aniNode)
end

function M:playAni()
    --彩带
    for i=1,8 do
        local emitter1 = Particle:create("res/hall/newUserGift/particle_texture.plist", "res/hall/newUserGift/particle_texture0"..i..".png")
        emitter1:setAutoRemoveOnFinish(true)    --设置播放完毕之后自动释放内存
        emitter1:setPosition(cc.p(0, 80))
        self._aniNode:addChild(emitter1,1020)
    end
    -- 豆子掉落
    Action:newDelayCallfun(0.2,function()
        local emitter2 = cc.ParticleSystemQuad:create("res/hall/newUserGift/Particle_diaodoudou.plist")
        emitter2:setAutoRemoveOnFinish(true)    --设置播放完毕之后自动释放内存
        emitter2:setPosition(cc.p(0, display.height / 2))
        self._aniNode:addChild(emitter2)
        gg.AudioManager:playEffect("res/common/audio/gold_move.mp3")
    end)
    -- 豆子弹起
    Action:newDelayCallfun(0.6, function()
        local emitter3 = cc.ParticleSystemQuad:create("res/hall/newUserGift/Particle_shengdoudou.plist")
        emitter3:setAutoRemoveOnFinish(true)    --设置播放完毕之后自动释放内存
        emitter3:setPosition(cc.p(0, -300))
        self._aniNode:addChild(emitter3, 510)
    end)
    -- 动画完成后移除界面
    gg.CallAfter(3, handler(self, self.onAniFinished))
end

function M:onAniFinished()
    self:removeSelf()
end

function M:keyBackClicked()
    return false, false
end

return M