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

--Create Layer
local Layer=cc.Node:create()
Layer:setName("Layer")
layout = ccui.LayoutComponent:bindLayoutComponent(Layer)
layout:setSize({width = 125.0000, height = 44.0000})

--Create lay_switch
local lay_switch = ccui.Layout:create()
lay_switch:ignoreContentAdaptWithSize(false)
lay_switch:setClippingEnabled(false)
lay_switch:setBackGroundColorOpacity(102)
lay_switch:setTouchEnabled(true);
lay_switch:setLayoutComponentEnabled(true)
lay_switch:setName("lay_switch")
lay_switch:setTag(76)
lay_switch:setCascadeColorEnabled(true)
lay_switch:setCascadeOpacityEnabled(true)
lay_switch:setAnchorPoint(0.5000, 0.0000)
lay_switch:setPosition(62.5000, 0.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(lay_switch)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(1.0000)
layout:setSize({width = 125.0000, height = 44.0000})
Layer:addChild(lay_switch)

--Create scrop_on
local scrop_on = ccui.Layout:create()
scrop_on:ignoreContentAdaptWithSize(false)
scrop_on:setClippingEnabled(true)
scrop_on:setBackGroundColorOpacity(102)
scrop_on:setLayoutComponentEnabled(true)
scrop_on:setName("scrop_on")
scrop_on:setTag(87)
scrop_on:setCascadeColorEnabled(true)
scrop_on:setCascadeOpacityEnabled(true)
layout = ccui.LayoutComponent:bindLayoutComponent(scrop_on)
layout:setPercentHeight(1.0455)
layout:setSize({width = 0.0000, height = 46.0000})
layout:setRightMargin(125.0000)
layout:setTopMargin(-2.0000)
lay_switch:addChild(scrop_on)

--Create img_on
local img_on = ccui.ImageView:create()
img_on:ignoreContentAdaptWithSize(false)
img_on:loadTexture("common/switch/switch-dark.png",0)
img_on:setScale9Enabled(true)
img_on:setCapInsets({x = 22, y = 15, width = 73, height = 14})
img_on:setLayoutComponentEnabled(true)
img_on:setName("img_on")
img_on:setTag(78)
img_on:setCascadeColorEnabled(true)
img_on:setCascadeOpacityEnabled(true)
img_on:setAnchorPoint(0.0000, 0.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_on)
layout:setPercentHeight(0.9565)
layout:setSize({width = 125.0000, height = 44.0000})
layout:setRightMargin(-125.0000)
layout:setTopMargin(2.0000)
scrop_on:addChild(img_on)

--Create scrop_off
local scrop_off = ccui.Layout:create()
scrop_off:ignoreContentAdaptWithSize(false)
scrop_off:setClippingEnabled(true)
scrop_off:setBackGroundColorOpacity(102)
scrop_off:setLayoutComponentEnabled(true)
scrop_off:setName("scrop_off")
scrop_off:setTag(88)
scrop_off:setCascadeColorEnabled(true)
scrop_off:setCascadeOpacityEnabled(true)
scrop_off:setAnchorPoint(1.0000, 0.0000)
scrop_off:setPosition(125.0000, 0.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(scrop_off)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentX(1.0000)
layout:setPercentWidthEnabled(true)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(1.0000)
layout:setSize({width = 125.0000, height = 44.0000})
lay_switch:addChild(scrop_off)

--Create img_off
local img_off = ccui.ImageView:create()
img_off:ignoreContentAdaptWithSize(false)
img_off:loadTexture("common/switch/switch-mask.png",0)
img_off:setScale9Enabled(true)
img_off:setCapInsets({x = 30, y = 15, width = 65, height = 14})
img_off:setLayoutComponentEnabled(true)
img_off:setName("img_off")
img_off:setTag(79)
img_off:setCascadeColorEnabled(true)
img_off:setCascadeOpacityEnabled(true)
img_off:setAnchorPoint(1.0000, 0.0000)
img_off:setPosition(125.0000, 0.0002)
layout = ccui.LayoutComponent:bindLayoutComponent(img_off)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentX(1.0000)
layout:setPositionPercentY(0.0000)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(1.0000)
layout:setSize({width = 125.0000, height = 44.0000})
layout:setTopMargin(-0.0002)
layout:setBottomMargin(0.0002)
scrop_off:addChild(img_off)

--Create lay_move
local lay_move = ccui.Layout:create()
lay_move:ignoreContentAdaptWithSize(false)
lay_move:setClippingEnabled(true)
lay_move:setBackGroundColorOpacity(102)
lay_move:setLayoutComponentEnabled(true)
lay_move:setName("lay_move")
lay_move:setTag(85)
lay_move:setCascadeColorEnabled(true)
lay_move:setCascadeOpacityEnabled(true)
layout = ccui.LayoutComponent:bindLayoutComponent(lay_move)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(1.0000)
layout:setSize({width = 125.0000, height = 44.0000})
lay_switch:addChild(lay_move)

--Create lay_crop
local lay_crop = ccui.Layout:create()
lay_crop:ignoreContentAdaptWithSize(false)
lay_crop:setClippingEnabled(false)
lay_crop:setBackGroundColorOpacity(102)
lay_crop:setLayoutComponentEnabled(true)
lay_crop:setName("lay_crop")
lay_crop:setTag(86)
lay_crop:setCascadeColorEnabled(true)
lay_crop:setCascadeOpacityEnabled(true)
lay_crop:setPosition(-125.0000, 0.0001)
layout = ccui.LayoutComponent:bindLayoutComponent(lay_crop)
layout:setPositionPercentX(-1.0000)
layout:setPositionPercentY(0.0000)
layout:setPercentWidth(2.0000)
layout:setPercentHeight(1.0000)
layout:setSize({width = 250.0000, height = 44.0000})
layout:setLeftMargin(-125.0000)
layout:setTopMargin(-0.0001)
layout:setBottomMargin(0.0001)
lay_move:addChild(lay_crop)

--Create txt_on
local txt_on = ccui.Text:create()
txt_on:ignoreContentAdaptWithSize(true)
txt_on:setTextAreaSize({width = 0, height = 0})
txt_on:setFontName("")
txt_on:setFontSize(24)
txt_on:setString([[开]])
txt_on:setLayoutComponentEnabled(true)
txt_on:setName("txt_on")
txt_on:setTag(80)
txt_on:setCascadeColorEnabled(true)
txt_on:setCascadeOpacityEnabled(true)
txt_on:setPosition(25.0000, 22.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(txt_on)
layout:setPositionPercentX(0.1000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.0960)
layout:setPercentHeight(0.5455)
layout:setSize({width = 24.0000, height = 24.0000})
layout:setLeftMargin(13.0000)
layout:setRightMargin(213.0000)
layout:setTopMargin(10.0000)
layout:setBottomMargin(10.0000)
lay_crop:addChild(txt_on)

--Create txt_off
local txt_off = ccui.Text:create()
txt_off:ignoreContentAdaptWithSize(true)
txt_off:setTextAreaSize({width = 0, height = 0})
txt_off:setFontName("")
txt_off:setFontSize(24)
txt_off:setString([[关]])
txt_off:setLayoutComponentEnabled(true)
txt_off:setName("txt_off")
txt_off:setTag(81)
txt_off:setCascadeColorEnabled(true)
txt_off:setCascadeOpacityEnabled(true)
txt_off:setPosition(225.0000, 22.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(txt_off)
layout:setPositionPercentX(0.9000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.0960)
layout:setPercentHeight(0.5455)
layout:setSize({width = 24.0000, height = 24.0000})
layout:setLeftMargin(213.0000)
layout:setRightMargin(13.0000)
layout:setTopMargin(10.0000)
layout:setBottomMargin(10.0000)
lay_crop:addChild(txt_off)

--Create img_thumb
local img_thumb = ccui.ImageView:create()
img_thumb:ignoreContentAdaptWithSize(false)
img_thumb:loadTexture("common/switch/switch-thumb.png",0)
img_thumb:setScale9Enabled(true)
img_thumb:setCapInsets({x = 11, y = 11, width = 12, height = 13})
img_thumb:setLayoutComponentEnabled(true)
img_thumb:setName("img_thumb")
img_thumb:setTag(82)
img_thumb:setCascadeColorEnabled(true)
img_thumb:setCascadeOpacityEnabled(true)
img_thumb:setPosition(22.0000, 22.0000)
img_thumb:setScaleX(1.0500)
img_thumb:setScaleY(1.0500)
layout = ccui.LayoutComponent:bindLayoutComponent(img_thumb)
layout:setPositionPercentX(0.1760)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.2720)
layout:setPercentHeight(0.7955)
layout:setSize({width = 34.0000, height = 35.0000})
layout:setLeftMargin(5.0000)
layout:setRightMargin(86.0000)
layout:setTopMargin(4.5000)
layout:setBottomMargin(4.5000)
lay_switch:addChild(img_thumb)

--Create Animation
result['animation'] = ccs.ActionTimeline:create()
  
result['animation']:setDuration(0)
result['animation']:setTimeSpeed(1.0000)
--Create Animation List

result['root'] = Layer
return result;
end

return Result

