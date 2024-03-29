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

--Create parent_node
local parent_node=cc.Node:create()
parent_node:setName("parent_node")
parent_node:setTag(171)
parent_node:setCascadeColorEnabled(true)
parent_node:setCascadeOpacityEnabled(true)
layout = ccui.LayoutComponent:bindLayoutComponent(parent_node)
Node:addChild(parent_node)

--Create img_bg
local img_bg = ccui.ImageView:create()
img_bg:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
img_bg:loadTexture("hall/common/new_pop_bg.png",1)
img_bg:setScale9Enabled(true)
img_bg:setCapInsets({x = 9, y = 69, width = 1, height = 2})
img_bg:setLayoutComponentEnabled(true)
img_bg:setName("img_bg")
img_bg:setTag(411)
img_bg:setCascadeColorEnabled(true)
img_bg:setCascadeOpacityEnabled(true)
img_bg:setAnchorPoint(0.0000, 0.0000)
img_bg:setPosition(-5.0000, -5.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_bg)
layout:setSize({width = 1106.0000, height = 644.0000})
layout:setLeftMargin(-5.0000)
layout:setRightMargin(-1101.0000)
layout:setTopMargin(-639.0000)
layout:setBottomMargin(-5.0000)
parent_node:addChild(img_bg)

--Create listview_bg
local listview_bg = ccui.Layout:create()
listview_bg:ignoreContentAdaptWithSize(false)
listview_bg:setClippingEnabled(false)
listview_bg:setTouchEnabled(true);
listview_bg:setLayoutComponentEnabled(true)
listview_bg:setName("listview_bg")
listview_bg:setTag(3736)
listview_bg:setCascadeColorEnabled(true)
listview_bg:setCascadeOpacityEnabled(true)
layout = ccui.LayoutComponent:bindLayoutComponent(listview_bg)
layout:setSize({width = 1096.0000, height = 574.0000})
layout:setRightMargin(-1096.0000)
layout:setTopMargin(-574.0000)
parent_node:addChild(listview_bg)

--Create shape_dbk_1
local shape_dbk_1 = ccui.Layout:create()
shape_dbk_1:ignoreContentAdaptWithSize(false)
shape_dbk_1:setClippingEnabled(false)
shape_dbk_1:setBackGroundColorOpacity(102)
shape_dbk_1:setTouchEnabled(true);
shape_dbk_1:setLayoutComponentEnabled(true)
shape_dbk_1:setName("shape_dbk_1")
shape_dbk_1:setTag(412)
shape_dbk_1:setCascadeColorEnabled(true)
shape_dbk_1:setCascadeOpacityEnabled(true)
shape_dbk_1:setAnchorPoint(0.0000, 1.0000)
shape_dbk_1:setPosition(0.0000, 634.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(shape_dbk_1)
layout:setSize({width = 1096.0000, height = 60.0000})
layout:setRightMargin(-1096.0000)
layout:setTopMargin(-634.0000)
layout:setBottomMargin(574.0000)
parent_node:addChild(shape_dbk_1)

--Create btn_look_other_statistic
local btn_look_other_statistic = ccui.Button:create()
btn_look_other_statistic:ignoreContentAdaptWithSize(false)
btn_look_other_statistic:setTitleFontSize(26)
btn_look_other_statistic:setScale9Enabled(true)
btn_look_other_statistic:setCapInsets({x = -15, y = -11, width = 30, height = 22})
btn_look_other_statistic:setLayoutComponentEnabled(true)
btn_look_other_statistic:setName("btn_look_other_statistic")
btn_look_other_statistic:setTag(180)
btn_look_other_statistic:setCascadeColorEnabled(true)
btn_look_other_statistic:setCascadeOpacityEnabled(true)
btn_look_other_statistic:setPosition(865.0000, 30.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_look_other_statistic)
layout:setPositionPercentX(0.7892)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.2007)
layout:setPercentHeight(1.0000)
layout:setSize({width = 220.0000, height = 60.0000})
layout:setLeftMargin(755.0000)
layout:setRightMargin(121.0000)
shape_dbk_1:addChild(btn_look_other_statistic)

--Create shape_xhx
local shape_xhx = ccui.ImageView:create()
shape_xhx:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/recordstatistics.plist")
shape_xhx:loadTexture("hall/recordstatistics/icon_zhanji.png",1)
shape_xhx:setLayoutComponentEnabled(true)
shape_xhx:setName("shape_xhx")
shape_xhx:setTag(181)
shape_xhx:setCascadeColorEnabled(true)
shape_xhx:setCascadeOpacityEnabled(true)
shape_xhx:setPosition(200.0000, 28.2600)
layout = ccui.LayoutComponent:bindLayoutComponent(shape_xhx)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.9091)
layout:setPositionPercentY(0.4710)
layout:setPercentWidth(0.1000)
layout:setPercentHeight(0.4333)
layout:setSize({width = 22.0000, height = 26.0000})
layout:setLeftMargin(189.0000)
layout:setRightMargin(9.0000)
layout:setTopMargin(18.7400)
layout:setBottomMargin(15.2600)
btn_look_other_statistic:addChild(shape_xhx)

--Create btn_name
local btn_name = ccui.Text:create()
btn_name:ignoreContentAdaptWithSize(true)
btn_name:setTextAreaSize({width = 0, height = 0})
btn_name:setFontName("")
btn_name:setFontSize(28)
btn_name:setString([[查看他人战绩]])
btn_name:setLayoutComponentEnabled(true)
btn_name:setName("btn_name")
btn_name:setTag(36)
btn_name:setCascadeColorEnabled(true)
btn_name:setCascadeOpacityEnabled(true)
btn_name:setPosition(96.9000, 27.9660)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_name)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.4405)
layout:setPositionPercentY(0.4661)
layout:setPercentWidth(0.7636)
layout:setPercentHeight(0.4667)
layout:setSize({width = 168.0000, height = 28.0000})
layout:setLeftMargin(12.9000)
layout:setRightMargin(39.1000)
layout:setTopMargin(18.0340)
layout:setBottomMargin(13.9660)
btn_look_other_statistic:addChild(btn_name)

--Create Animation
result['animation'] = ccs.ActionTimeline:create()

result['animation']:setDuration(0)
result['animation']:setTimeSpeed(1.0000)
--Create Animation List

result['root'] = Node
return result;
end

return Result

