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

--Create nd_record
local nd_record=cc.Node:create()
nd_record:setName("nd_record")
nd_record:setTag(129)
nd_record:setCascadeColorEnabled(true)
nd_record:setCascadeOpacityEnabled(true)
layout = ccui.LayoutComponent:bindLayoutComponent(nd_record)
Node:addChild(nd_record)

--Create lv_record
local lv_record = ccui.ListView:create()
lv_record:setDirection(1)
lv_record:setGravity(0)
lv_record:ignoreContentAdaptWithSize(false)
lv_record:setClippingEnabled(true)
lv_record:setBackGroundColorOpacity(102)
lv_record:setLayoutComponentEnabled(true)
lv_record:setName("lv_record")
lv_record:setTag(130)
lv_record:setCascadeColorEnabled(true)
lv_record:setCascadeOpacityEnabled(true)
layout = ccui.LayoutComponent:bindLayoutComponent(lv_record)
layout:setSize({width = 1096.0000, height = 574.0000})
layout:setRightMargin(-1096.0000)
layout:setTopMargin(-574.0000)
nd_record:addChild(lv_record)

--Create txt_record_tips
local txt_record_tips = ccui.Text:create()
txt_record_tips:ignoreContentAdaptWithSize(true)
txt_record_tips:setTextAreaSize({width = 0, height = 0})
txt_record_tips:setFontName("")
txt_record_tips:setFontSize(32)
txt_record_tips:setString([[暂无战绩]])
txt_record_tips:setLayoutComponentEnabled(true)
txt_record_tips:setName("txt_record_tips")
txt_record_tips:setTag(131)
txt_record_tips:setCascadeColorEnabled(true)
txt_record_tips:setCascadeOpacityEnabled(true)
txt_record_tips:setVisible(false)
txt_record_tips:setPosition(548.0000, 290.0000)
txt_record_tips:setTextColor({r = 34, g = 34, b = 34})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_record_tips)
layout:setSize({width = 128.0000, height = 33.0000})
layout:setLeftMargin(484.0000)
layout:setRightMargin(-612.0000)
layout:setTopMargin(-306.5000)
layout:setBottomMargin(273.5000)
nd_record:addChild(txt_record_tips)

--Create Animation
result['animation'] = ccs.ActionTimeline:create()
  
result['animation']:setDuration(0)
result['animation']:setTimeSpeed(1.0000)
--Create Animation List

result['root'] = Node
return result;
end

return Result
