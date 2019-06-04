--
-- Author: Your Name
-- Date: 2016-09-13 20:29:19
--
local Widget = ccui.Widget

local function onclick_(obj, callback,soundpath)
    obj:addTouchEventListener(function(sender, state)
        if state == 2 then
            callback(sender, state)
        end
    end)
    return obj
end

-- 无效果点击事件  1变暗 2 缩放 0 or nil 无效果
function Widget:onClick(callback, effect,soundpath)
    assert(callback,"onClick callback is nil")
    if 1 == effect then
        return self:onClickDarkEffect(callback,soundpath)
    elseif 2 == effect then
        return self:onClickScaleEffect(callback,soundpath)
    else
        return onclick_(self, callback,soundpath)
    end
end

-- 按钮缩放效果点击事件
function Widget:onClickScaleEffect(callback,soundpath)
    assert(callback,"onClickScaleEffect callback is nil")
    self:addTouchEventListener(function(sender, state)
        if state == 0 then --began
            sender.scale_ = sender.scale_ or sender:getScale()
            sender:setScale(sender.scale_ * 0.95)
        elseif state == 1 then --moved

        elseif state == 2 then --end
            sender:setScale(sender.scale_ * 1.0)
            callback(sender, state)
            -- 播放点击音效
            if soundpath then
                gg.AudioManager:playEffect( soundpath )
            end
        else --cancel
            sender:setScale(sender.scale_ * 1.0)
        end
    end)
    return self
end

-- 变暗效果点击事件
function Widget:onClickDarkEffect(callback,soundpath)
    assert(callback,"onClickDarkEffect callback is nil")
    self:addTouchEventListener(function(sender, state)
        local event = { x = 0, y = 0 }
        if state == 0 then
            sender:setColor({ r = 200, g = 200, b = 200 })
        elseif state == 1 then
        elseif state == 2 then
            sender:setColor({ r = 255, g = 255, b = 255 })
            callback(sender, state)
        else
            sender:setColor({ r = 255, g = 255, b = 255 })
        end
    end)
    return self
end


