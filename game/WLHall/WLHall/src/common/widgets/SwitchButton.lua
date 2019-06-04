--[[
* @file     SwitchButton.lua
* @brief    提示框
* @date     2016年09月06日
* @author   陈先寅
* @email    420373550@qq.com
--]]

local base_module = require("games.common.client.base_module");
local SwitchButton = class("SwitchButton", function(obj)
  if nil ~= obj then
    return obj;
  end

  return require("res.ui.common.button_switch").create().root;
end );

--[[
* @brief 构造函数
* @param onchange 状态改变回掉
--]]
function SwitchButton:ctor(obj, onchange)
  self.mCallChange = onchange or function() end

  -- 按钮事件
  self.lay_switch = self:getChildByName("lay_switch");
  self.lay_switch:onClick(function()
    self:Invert();
  end)

  -- 滑块左右位置
  self.lay_move = self.lay_switch:getChildByName("lay_move")
  self.lay_crop = self.lay_move:getChildByName("lay_crop")
  self.img_thumb = self.lay_switch:getChildByName("img_thumb")

  self._thumbX = self.img_thumb:getPositionX();
  -- {开, 关}
  self.mThumbM = {self.lay_switch:getContentSize().width, 0};

  self:SetOn(false);

  -- 使能节点创建事件
  self:enableNodeEvents();
end

--[[
* @brief 初始化函数
--]]
function SwitchButton:onEnter()

end

--[[
* @brief 获取开关显示占比
]]
function SwitchButton:OnPanelMov(dx)
  local size = self:getContentSize();
  
  self.scrop_on = self.lay_switch:getChildByName("scrop_on");
  self.scrop_off = self.lay_switch:getChildByName("scrop_off");  
  self.img_off = self.scrop_off:getChildByName("img_off");  

  local on_new = self.scrop_off:getContentSize().width + dx;
  if on_new > self.mThumbM[1] then
    dx = self.mThumbM[1] - self.scrop_off:getContentSize().width;
  elseif on_new < self.mThumbM[2] then
    dx = self.mThumbM[2] - self.scrop_off:getContentSize().width;
  end

  self.scrop_on:setContentSize(cc.size(self.scrop_on:getContentSize().width - dx, self.scrop_on:getContentSize().height))
  self.scrop_off:setContentSize(cc.size(self.scrop_off:getContentSize().width + dx, self.scrop_on:getContentSize().height))
  self.img_off:setPositionX(self.scrop_off:getContentSize().width);
end

--[[
* @brief 设置开关状态
]]
function SwitchButton:Invert()
  local speed = (self:getContentSize().width - self.mThumbM[1]*2)/0.2;

  self.lay_crop:stopAllActions();
  self.img_thumb:stopAllActions();
  self.img_thumb:unscheduleUpdate();

  if self.mIsOn then
    self.lay_crop:runAction(cc.MoveTo:create(0.2, cc.p(self.lay_move:getContentSize().width - self.lay_crop:getContentSize().width, 0)));
    self.img_thumb:runAction(cc.Sequence:create(cc.MoveTo:create(0.2, cc.p(self.mThumbM[2] + self._thumbX, self.img_thumb:getPositionY())), cc.CallFunc:create(function()
      self.img_thumb:unscheduleUpdate();
     end)));
    self.img_thumb:scheduleUpdateWithPriorityLua(function(dt)
      self:OnPanelMov(-speed * dt);
    end, 0);
  else
    self.lay_crop:runAction(cc.MoveTo:create(0.2, cc.p(0, 0)));
    self.img_thumb:runAction(cc.Sequence:create(cc.MoveTo:create(0.2, cc.p(self.mThumbM[1] - self._thumbX, self.img_thumb:getPositionY())), cc.CallFunc:create(function()
      self.img_thumb:unscheduleUpdate();
     end)));
    self.img_thumb:scheduleUpdateWithPriorityLua(function(dt) 
      self:OnPanelMov(speed * dt);
    end, 0);
  end

  self.mIsOn = not self.mIsOn;
  self.mCallChange(self, self.mIsOn);
end

--[[
* @brief 设置开关状态
]]
function SwitchButton:SetOn(isOn)
  self.scrop_on = self.lay_switch:getChildByName("scrop_on");
  self.scrop_off = self.lay_switch:getChildByName("scrop_off");  
  self.img_off = self.scrop_off:getChildByName("img_off");  
  
  if not isOn then
    self.mIsOn = false;
    self.lay_crop:setPositionX(self.lay_move:getContentSize().width - self.lay_crop:getContentSize().width);
    self.img_thumb:setPositionX(self.mThumbM[2] + self._thumbX);

    local size = self:getContentSize();
    self.scrop_on:setContentSize(cc.size(size.width - self.mThumbM[1], self.scrop_on:getContentSize().height))
    self.scrop_off:setContentSize(cc.size(self.mThumbM[1], self.scrop_on:getContentSize().height))
    self.img_off:setPositionX(self.mThumbM[1]);
  else
    self.mIsOn = true;
    self.lay_crop:setPositionX(0);
    self.img_thumb:setPositionX(self.mThumbM[1] - self._thumbX);

    local size = self:getContentSize();
    self.scrop_on:setContentSize(cc.size(self.mThumbM[1], self.scrop_on:getContentSize().height))
    self.scrop_off:setContentSize(cc.size(size.width - self.mThumbM[1], self.scrop_on:getContentSize().height))
    self.img_off:setPositionX(size.width - self.mThumbM[1]);
  end
  self.mCallChange(self.mIsOn);
end

--[[
* @brief 设置开关状态
]]
function SwitchButton:setOn(isOn)
  self:SetOn(isOn);
end

--[[
* @brief 设置可用状态
]]
function SwitchButton:setEnabled(isEnabled)
  self.lay_switch:setTouchEnabled(isEnabled);
  self.img_thumb:setGray(not isEnabled);

  self.scrop_on = self.lay_switch:getChildByName("scrop_on");
  self.scrop_on:setGray(not isEnabled);

  self.img_on = self.scrop_on:getChildByName("img_on");  
  self.img_on:setGray(not isEnabled);

  self.scrop_off = self.lay_switch:getChildByName("scrop_off");  
  self.scrop_off:setGray(not isEnabled);

  self.img_off = self.scrop_off:getChildByName("img_off");  
  self.img_off:setGray(not isEnabled);
end

--[[
* @brief 获取开关状态
]]
function SwitchButton:IsOn()
  return self.mIsOn;
end

return SwitchButton;
