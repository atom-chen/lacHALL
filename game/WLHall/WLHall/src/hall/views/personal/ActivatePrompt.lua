
--
-- Author: zhaoxinyu
-- Date: 2016-11-25 20:23:20
-- Describe：激活提示框

local ActivatePrompt = class("ActivatePrompt", cc.load("ViewPop"))

ActivatePrompt.RESOURCE_FILENAME="ui/person_info/activate_prompt.lua"
ActivatePrompt.RESOURCE_BINDING = {

    ["btn_bind"]     = {["varname"] = "btn_bind",["events"]={{event="click",method="onClickBind"}} },             -- 立即绑定按钮

    ["txt_account"]   = { ["varname"] = "txt_account" },                                                         -- 账号
    ["txt_password"]   = { ["varname"] = "txt_password" },                                                         -- 密码
    ["btn_close"]     = { ["varname"] = "btn_close", ["events"]={{event="click",method="onClickBind"}} },       -- 关闭按钮

}

--[[
* @brief 创建
]]
function ActivatePrompt:onCreate( account , password , cb )

    self:init( account , password , cb )
    self:initView()
end

--[[
* @brief 初始化数据
]]
function ActivatePrompt:init( account , password , cb )

    self._account = account                      -- 账号
    self._password = password                    -- 密码
    self._cb = cb                                  -- 回调
end

--[[
* @brief 初始化View
]]
function ActivatePrompt:initView()

    self.txt_account:setString( self._account )
    self.txt_password:setString( self._password )
end

--[[
* @brief 立即绑定按钮
]]
function ActivatePrompt:onClickBind( sender )
    self:removeSelf()
end

return ActivatePrompt
