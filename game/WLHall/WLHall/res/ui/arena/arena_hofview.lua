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

--Create panel_hof
local panel_hof = ccui.Layout:create()
panel_hof:ignoreContentAdaptWithSize(false)
panel_hof:setClippingEnabled(false)
panel_hof:setTouchEnabled(true);
panel_hof:setLayoutComponentEnabled(true)
panel_hof:setName("panel_hof")
panel_hof:setTag(82)
panel_hof:setCascadeColorEnabled(true)
panel_hof:setCascadeOpacityEnabled(true)
layout = ccui.LayoutComponent:bindLayoutComponent(panel_hof)
layout:setSize({width = 1096.0000, height = 633.0000})
layout:setRightMargin(-1096.0000)
layout:setTopMargin(-633.0000)
Node:addChild(panel_hof)

--Create img_bg
local img_bg = ccui.ImageView:create()
img_bg:ignoreContentAdaptWithSize(false)
img_bg:loadTexture("hall/arena/bg_mrt.png",0)
img_bg:setLayoutComponentEnabled(true)
img_bg:setName("img_bg")
img_bg:setTag(2129)
img_bg:setCascadeColorEnabled(true)
img_bg:setCascadeOpacityEnabled(true)
img_bg:setAnchorPoint(0.0000, 0.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_bg)
layout:setPercentWidth(1.0009)
layout:setPercentHeight(1.0016)
layout:setSize({width = 1097.0000, height = 634.0000})
layout:setRightMargin(-1.0000)
layout:setTopMargin(-1.0000)
panel_hof:addChild(img_bg)

--Create list_hof
local list_hof = ccui.ScrollView:create()
list_hof:setDirection(2)
list_hof:setInnerContainerSize({width = 1010, height = 400})
list_hof:ignoreContentAdaptWithSize(false)
list_hof:setClippingEnabled(true)
list_hof:setBackGroundColorOpacity(102)
list_hof:setLayoutComponentEnabled(true)
list_hof:setName("list_hof")
list_hof:setTag(2130)
list_hof:setCascadeColorEnabled(true)
list_hof:setCascadeOpacityEnabled(true)
list_hof:setPosition(52.1400, 100.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(list_hof)
layout:setPositionPercentX(0.0476)
layout:setPositionPercentY(0.1580)
layout:setPercentWidth(0.9051)
layout:setPercentHeight(0.5845)
layout:setSize({width = 992.0000, height = 370.0000})
layout:setLeftMargin(52.1400)
layout:setRightMargin(51.8600)
layout:setTopMargin(163.0000)
layout:setBottomMargin(100.0000)
panel_hof:addChild(list_hof)

--Create btn_close
local btn_close = ccui.Layout:create()
btn_close:ignoreContentAdaptWithSize(false)
btn_close:setClippingEnabled(false)
btn_close:setTouchEnabled(true);
btn_close:setLayoutComponentEnabled(true)
btn_close:setName("btn_close")
btn_close:setTag(54)
btn_close:setCascadeColorEnabled(true)
btn_close:setCascadeOpacityEnabled(true)
btn_close:setAnchorPoint(0.5000, 0.5000)
btn_close:setPosition(1068.0000, 600.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_close)
layout:setPositionPercentX(0.9745)
layout:setPositionPercentY(0.9479)
layout:setPercentWidth(0.0456)
layout:setPercentHeight(0.0790)
layout:setSize({width = 50.0000, height = 50.0000})
layout:setLeftMargin(1043.0000)
layout:setRightMargin(3.0000)
layout:setTopMargin(8.0000)
layout:setBottomMargin(575.0000)
panel_hof:addChild(btn_close)

--Create btn_bg
local btn_bg = ccui.ImageView:create()
btn_bg:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
btn_bg:loadTexture("hall/common/new_btn_close.png",1)
btn_bg:setLayoutComponentEnabled(true)
btn_bg:setName("btn_bg")
btn_bg:setTag(55)
btn_bg:setCascadeColorEnabled(true)
btn_bg:setCascadeOpacityEnabled(true)
btn_bg:setPosition(25.0000, 25.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_bg)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.4800)
layout:setPercentHeight(0.5000)
layout:setSize({width = 24.0000, height = 25.0000})
layout:setLeftMargin(13.0000)
layout:setRightMargin(13.0000)
layout:setTopMargin(12.5000)
layout:setBottomMargin(12.5000)
btn_close:addChild(btn_bg)

--Create btn_left
local btn_left = ccui.Layout:create()
btn_left:ignoreContentAdaptWithSize(false)
btn_left:setClippingEnabled(false)
btn_left:setBackGroundColorOpacity(102)
btn_left:setTouchEnabled(true);
btn_left:setLayoutComponentEnabled(true)
btn_left:setName("btn_left")
btn_left:setTag(2133)
btn_left:setCascadeColorEnabled(true)
btn_left:setCascadeOpacityEnabled(true)
btn_left:setPosition(8.1380, 294.5900)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_left)
layout:setPositionPercentX(0.0074)
layout:setPositionPercentY(0.4654)
layout:setPercentWidth(0.0456)
layout:setPercentHeight(0.0790)
layout:setSize({width = 50.0000, height = 50.0000})
layout:setLeftMargin(8.1380)
layout:setRightMargin(1037.8620)
layout:setTopMargin(288.4100)
layout:setBottomMargin(294.5900)
panel_hof:addChild(btn_left)

--Create txt_2
local txt_2 = ccui.Text:create()
txt_2:ignoreContentAdaptWithSize(true)
txt_2:setTextAreaSize({width = 0, height = 0})
txt_2:setFontSize(24)
txt_2:setString([[周排位冠军，将会被列入名人堂。]])
txt_2:setLayoutComponentEnabled(true)
txt_2:setName("txt_2")
txt_2:setTag(1892)
txt_2:setCascadeColorEnabled(true)
txt_2:setCascadeOpacityEnabled(true)
txt_2:setPosition(548.0000, 99.0000)
txt_2:setTextColor({r = 193, g = 87, b = 87})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_2)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.1564)
layout:setPercentWidth(0.3285)
layout:setPercentHeight(0.0379)
layout:setSize({width = 360.0000, height = 24.0000})
layout:setLeftMargin(368.0000)
layout:setRightMargin(368.0000)
layout:setTopMargin(522.0000)
layout:setBottomMargin(87.0000)
panel_hof:addChild(txt_2)

--Create Animation
result['animation'] = ccs.ActionTimeline:create()
  
result['animation']:setDuration(0)
result['animation']:setTimeSpeed(1.0000)
--Create Animation List

result['root'] = Node
return result;
end

return Result

