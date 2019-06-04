local M = class("libs.ccex.Action")

local cls_table = {
    moveTo      = cc.MoveTo,
    moveBy      = cc.MoveBy,
    scaleTo     = cc.ScaleTo,
    scaleBy     = cc.ScaleBy,
    rotateTo    = cc.RotateTo,
    rotateBy    = cc.RotateBy,
    tintTo      = cc.TintTo,
    tintBy      = cc.TintBy,
    fadeIn      = cc.FadeIn,
    fadeTo      = cc.FadeTo,
    fadeOut     = cc.FadeOut,
    delayTime   = cc.DelayTime,
    jumpBy      = cc.JumpBy,
    jumpTo      = cc.JumpTo,
    callFunc    = cc.CallFunc,
    bezierTo    = cc.BezierTo,
    spawn       = cc.Spawn,
    orbitCamera = cc.OrbitCamera,
    sequence    = cc.Sequence,
}

local sigle_table = 
{
    RepeatForever       = cc.RepeatForever, 
    EaseExponentialOut  = cc.EaseExponentialOut, 
    EaseBackIn          = cc.EaseBackIn,
    EaseBackInOut       = cc.EaseBackInOut,
    EaseBackOut         = cc.EaseBackOut,
    EaseElasticOut      = cc.EaseElasticOut,
    EaseElasticIn       = cc.EaseElasticIn,
    EaseElasticInOut    = cc.EaseElasticInOut, 
    EaseExponentialIn   = cc.EaseExponentialIn,
    EaseExponentialInOut = cc.EaseExponentialInOut,
}

--[[
    * 描述：newSequence和newSpawn是可以组合的动画
    * 示例：Action:newSequence()
                :moveTo(...)
                :scaleTo(...)
                :run(node)
--]]
function M:newSequence()
    return M.new("sequence")
end

function M:newSpawn()
    return M.new("spawn")
end

--[[
    * 描述：以下是依托其他动画的action
    * 参数：actionType只能是"seq"(按顺序)或"spa"(联合动画)
--]]
function M:newRepeatForever(actionType)
    return M.new("RepeatForever", actionType)
end

-- 向后再向前，类似拉弹弓
function M:newEaseBackIn(actionType)
    return M.new("EaseBackIn", actionType)
end

function M:newEaseBackInOut(actionType)
    return M.new("EaseBackInOut", actionType)
end

function M:newEaseBackOut(actionType)
    return M.new("EaseBackOut", actionType)
end

-- 橡皮筋功能，来回弹
function M:newEaseElasticOut(actionType)
    return M.new("EaseElasticOut", actionType)
end

function M:newEaseElasticIn(actionType)
    return M.new("EaseElasticIn", actionType)
end

function M:newEaseElasticInOut(actionType)
    return M.new("EaseElasticInOut", actionType)
end

-- 慢到快，类似自由落体
function M:newEaseExponentialIn(actionType)
    return M.new("EaseExponentialIn", actionType)
end

function M:newEaseExponentialOut(actionType)
    return M.new("EaseExponentialOut", actionType)
end

function M:newEaseExponentialInOut(actionType)
    return M.new("EaseExponentialInOut", actionType)
end

--[[
    * 描述：延迟时间回调
--]]
function M:newDelayCallfun(delayTime, callfun)
    -- 延迟一帧进行，以确保 runningScene 是正确的
    gg.InvokeFuncNextFrame(function() M:newDelayCallfunWithNode(Director:getRunningScene(), delayTime, callfun) end)
end

--[[
    * 描述：延迟时间回调
--]]
function M:newDelayCallfunWithNode(node, delayTime, callfun)
    assert(delayTime)
    assert(callfun)
    assert(node)

    M:newSequence()
        :delayTime(delayTime)
        :callFunc(callfun)
        :run(node)
end

-- 添加自定义action类
function M:addAction(action)
    assert(action)
    table.insert(self._actions, action)
    return self
end

-- 转换成原始action动画
function M:toAction()
    assert(#self._actions~=0, "你未设置任何动作事件")
    local funClass = cls_table[self._actionName]
    if funClass then
        return funClass:create(self._actions)
    end

    -- 这类动画只取第一个
    if #self._actions < 2 then
        return sigle_table[self._actionName]:create( self._actions[1] )
    end

    local action = self._actionType=="seq" and 
        cc.Sequence:create(self._actions) or 
        cc.Spawn:create(self._actions)
    return sigle_table[self._actionName]:create(action)
end

function M:run(node)
    assert(node)
    local action = self:toAction()
    node:runAction(action)
    return self
end

function M:moveTo(duration, pos)
    assert(duration)
    assert(pos)
    self:_addAction("moveTo", duration, pos)
    return self
end

function M:moveBy(duration, pos)
    assert(duration)
    assert(pos)
   self:_addAction("moveBy", duration, pos) 
   return self
end

function M:scaleTo(duration, scalex, scaley)
    assert(duration)
    assert(scalex)
    scaley = scaley==nil and scalex or scaley
   self:_addAction("scaleTo", duration, scalex, scaley) 
   return self
end

function M:scaleBy(duration, scale)
    assert(duration)
    assert(scale)
   self:_addAction("scaleBy", duration, scale) 
   return self
end

function M:rotateTo(duration, rotate)
    assert(duration)
    assert(rotate)
    self:_addAction("rotateTo", duration, rotate) 
    return self
end

function M:rotateBy(duration, rotate)
    assert(duration)
    assert(rotate)
    self:_addAction("rotateBy", duration, rotate) 
    return self
end

function M:tintTo(duration, r, g, b)
    assert(duration)
    assert(r)
    assert(g)
    assert(b)
    self:_addAction("tintTo", duration,  r, g, b) 
    return self
end

function M:tintBy(duration, r, g, b)
    assert(duration)
    assert(r)
    assert(g)
    assert(b)
    self:_addAction("tintBy", duration,  r, g, b) 
    return self
end

function M:fadeIn(duration)
    assert(duration)
    self:_addAction("fadeIn", duration) 
    return self
end

function M:fadeOut(duration)
    assert(duration)
    self:_addAction("fadeOut", duration) 
    return self
end

function M:fadeTo(duration, opacity)
    assert(duration)
    assert(opacity)
    self:_addAction("fadeTo", duration, opacity) 
    return self
end

function M:delayTime(duration)
    assert(duration)
    self:_addAction("delayTime", duration) 
    return self
end

function M:jumpBy(duration, position, height, jumps)
    assert(duration)
    assert(position)
    assert(height)
    assert(jumps)
    self:_addAction("jumpBy", duration, position, height, jumps) 
    return self
end

function M:jumpTo(duration, position, height, jumps)
    assert(duration)
    assert(position)
    assert(height)
    assert(jumps)
    self:_addAction("jumpTo", duration, position, height, jumps) 
    return self
end
   
--[[
    * 描述：水平翻转
--]]
function M:orbitCamera(duration, radius, deltaRadius, angleZ, deltaAngleZ, angleX, deltaAngleX)
    assert(duration)
    assert(radius)
    assert(deltaRadius)
    assert(angleZ)
    assert(deltaAngleZ)
    assert(angleX)
    assert(deltaAngleX)
    self:_addAction("orbitCamera", duration, radius, deltaRadius, angleZ, deltaAngleZ, angleX, deltaAngleX) 
    return self
end

--[[
    * 描述：贝塞尔曲线
    * 参数：posArray示例 = { cc.p(0, 0), cc.p(100, 100), cc.p(200, 200) }
--]]
function M:bezierTo(duration, posArray)
    assert(duration)
    assert(#posArray==3)
    self:_addAction("bezierTo", duration, posArray) 
    return self
end

function M:callFunc(func)
    assert(func)
    self:_addAction("callFunc", func) 
    return self
end
     
function M:spawn(actions)
    assert(actions)
    self:_addAction("spawn", actions) 
    return self
end
    
function M:sequence(actions)
    assert(actions)
    self:_addAction("sequence", actions) 
    return self
end

--------------------------- 华丽分割线 ---------------------------

function M:ctor(actionName, actionType)
    self._actionName = actionName
    self._actions = {}
    self._actionType = actionType==nil and "seq" or actionType
    assert(self._actionType=="seq" or self._actionType=="spa", "你传入的参数错误，必须是seq或spa")
end

function M:_addAction(actionName, ...)
    local funClass = cls_table[actionName]
    local action = funClass:create(...)
    self:addAction(action)
end

return M

