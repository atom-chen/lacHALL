--------------------------------------------------------------
-- This file was automatically generated by Cocos Studio.
-- Do not make changes to this file.
-- All changes will be lost.
--------------------------------------------------------------

local luaExtend = require "LuaExtend"

-- using for layout to decrease count of local variables
local layout = nil
local localLuaFile = nil
local innerCSD = nil
local innerProject = nil
local localFrame = nil

local Result = {}
------------------------------------------------------------
-- function call description
-- create function caller should provide a function to
-- get a callback function in creating scene process.
-- the returned callback function will be registered to
-- the callback event of the control.
-- the function provider is as below :
-- Callback callBackProvider(luaFileName, node, callbackName)
-- parameter description:
-- luaFileName  : a string, lua file name
-- node         : a Node, event source
-- callbackName : a string, callback function name
-- the return value is a callback function
------------------------------------------------------------
function Result.create(callBackProvider)

local result={}
setmetatable(result, luaExtend)

--Create Node
local Node=cc.Node:create()
Node:setName("Node")

--Create txt
local txt = ccui.Text:create()
txt:ignoreContentAdaptWithSize(true)
txt:setTextAreaSize({width = 0, height = 0})
txt:setFontSize(26)
txt:setString([[手机绑定]])
txt:setLayoutComponentEnabled(true)
txt:setName("txt")
txt:setTag(480)
txt:setCascadeColorEnabled(true)
txt:setCascadeOpacityEnabled(true)
txt:setPosition(0.6021, 10.1469)
layout = ccui.LayoutComponent:bindLayoutComponent(txt)
layout:setSize({width = 106.0000, height = 30.0000})
layout:setLeftMargin(-52.3979)
layout:setRightMargin(-53.6021)
layout:setTopMargin(-25.1469)
layout:setBottomMargin(-4.8531)
Node:addChild(txt)

--Create txt2
local txt2 = ccui.Text:create()
txt2:ignoreContentAdaptWithSize(true)
txt2:setTextAreaSize({width = 0, height = 0})
txt2:setFontSize(18)
txt2:setString([[首次绑定送5000豆]])
txt2:setLayoutComponentEnabled(true)
txt2:setName("txt2")
txt2:setTag(483)
txt2:setCascadeColorEnabled(true)
txt2:setCascadeOpacityEnabled(true)
txt2:setPosition(-0.0632, -15.3813)
layout = ccui.LayoutComponent:bindLayoutComponent(txt2)
layout:setSize({width = 151.0000, height = 21.0000})
layout:setLeftMargin(-75.5632)
layout:setRightMargin(-75.4368)
layout:setTopMargin(4.8813)
layout:setBottomMargin(-25.8813)
Node:addChild(txt2)

--Create Animation
result['animation'] = ccs.ActionTimeline:create()

result['animation']:setDuration(0)
result['animation']:setTimeSpeed(1.0000)
--Create Animation List

result['root'] = Node
return result;
end

return Result

