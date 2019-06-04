-- Author: zhaoxinyu
-- Date: 2016-11-18 11:47:20
-- Describe：开关组件

local ControlSwitch = class("ControlSwitch", cc.Node)

--[[
* @brief 创建
]]
function ControlSwitch:ctor()

    self:init()

    self:initView()
end

--[[
* @brief 初始化数据
]]
function ControlSwitch:init()

    self._cb = nil -- 事件回调

    self._switchControl = nil -- 开关
end

--[[
* @brief 初始化界面
]]
function ControlSwitch:initView()

    -- 创建开关
    self:createSwitch()
end

--[[
* @brief 创建开关
* @parm isEnabled 是否可用
]]
function ControlSwitch:createSwitch(isEnabled)

    if self._switchControl then
        self._switchControl:removeFromParent()
        self._switchControl = nil
    end

    local mask = cc.Sprite:create("common/switch/switch-mask.png")
    local thumb = cc.Sprite:create("common/switch/switch-thumb.png")
    local on = cc.Sprite:create("common/switch/switch-on.png")
    local off = cc.Sprite:create("common/switch/switch-off.png")
    local lon = cc.Label:createWithSystemFont("开", "Arial-BoldMT", 20)
    local loff = cc.Label:createWithSystemFont("关", "Arial-BoldMT", 20)

    -- 创建开关
    local pSwitchControl = cc.ControlSwitch:create(mask, on, off, thumb, lon, loff)
    pSwitchControl:registerControlEventHandler(handler(self, self.onSwitchChanged), cc.CONTROL_EVENTTYPE_VALUE_CHANGED)

    -- 设置是否可用
    if isEnabled == false then

        pSwitchControl:setEnabled(false)
        mask:setGray()
        thumb:setGray()
        on:setGray()
        off:setGray()
        lon:setGray()
        loff:setGray()
    end

    self._switchControl = pSwitchControl
    self:addChild(pSwitchControl)
end

--[[
* @brief 滑块事件
]]
function ControlSwitch:onSwitchChanged(sender)

    if self._cb then
        local isOn = sender:isOn()
        self._cb(self, isOn)
    end
end

--[[
* @brief 注册监听
* @parm cb 回调函数   函数原型 function cb( sender , isOn ) end  isOn:true开,false关 sender:控件对象
]]
function ControlSwitch:registerControlEvent(cb)

    self._cb = cb
end

--[[
* @brief 设置开关状态
]]
function ControlSwitch:setOn(isOn)

    self._switchControl:setOn(isOn)
end

--[[
* @brief 获取开关状态
]]
function ControlSwitch:isOn()

    return self._switchControl:isOn()
end

--[[
* @brief 设置可用状态
]]
function ControlSwitch:setEnabled(isEnabled)

    -- 创建新的开关
    local oldIsOn = self:isOn()
    self:createSwitch(isEnabled)
    self:setOn(oldIsOn)
end


return ControlSwitch