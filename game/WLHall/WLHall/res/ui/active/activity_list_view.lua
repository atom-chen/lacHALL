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

--Create Panel_bg
local Panel_bg = ccui.Layout:create()
Panel_bg:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
Panel_bg:setBackGroundImage("hall/common/new_pop_right_bg.png",1)
Panel_bg:setClippingEnabled(false)
Panel_bg:setBackGroundImageCapInsets({x = 4, y = 8, width = 3, height = 4})
Panel_bg:setBackGroundColorOpacity(102)
Panel_bg:setBackGroundImageScale9Enabled(true)
Panel_bg:setTouchEnabled(true);
Panel_bg:setLayoutComponentEnabled(true)
Panel_bg:setName("Panel_bg")
Panel_bg:setTag(816)
Panel_bg:setCascadeColorEnabled(true)
Panel_bg:setCascadeOpacityEnabled(true)
Panel_bg:setPosition(-0.7191, -5.3400)
layout = ccui.LayoutComponent:bindLayoutComponent(Panel_bg)
layout:setSize({width = 279.5000, height = 645.0000})
layout:setLeftMargin(-0.7191)
layout:setRightMargin(-278.7809)
layout:setTopMargin(-639.6600)
layout:setBottomMargin(-5.3400)
Node:addChild(Panel_bg)

--Create lv_tab
local lv_tab = ccui.ListView:create()
lv_tab:setDirection(1)
lv_tab:setGravity(0)
lv_tab:ignoreContentAdaptWithSize(false)
lv_tab:setClippingEnabled(true)
lv_tab:setBackGroundImageCapInsets({x = -3, y = -3, width = 6, height = 6})
lv_tab:setBackGroundColorOpacity(193)
lv_tab:setBackGroundImageScale9Enabled(true)
lv_tab:setLayoutComponentEnabled(true)
lv_tab:setName("lv_tab")
lv_tab:setTag(92)
lv_tab:setCascadeColorEnabled(true)
lv_tab:setCascadeOpacityEnabled(true)
layout = ccui.LayoutComponent:bindLayoutComponent(lv_tab)
layout:setSize({width = 274.0000, height = 634.0000})
layout:setRightMargin(-274.0000)
layout:setTopMargin(-634.0000)
Node:addChild(lv_tab)

--Create nd_subview
local nd_subview=cc.Node:create()
nd_subview:setName("nd_subview")
nd_subview:setTag(93)
nd_subview:setCascadeColorEnabled(true)
nd_subview:setCascadeOpacityEnabled(true)
nd_subview:setPosition(280.0000, 0.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(nd_subview)
layout:setLeftMargin(280.0000)
layout:setRightMargin(-280.0000)
Node:addChild(nd_subview)

--Create subview_bg
local subview_bg = ccui.ImageView:create()
subview_bg:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
subview_bg:loadTexture("hall/common/new_pop_bg_4.png",1)
subview_bg:setScale9Enabled(true)
subview_bg:setCapInsets({x = 11, y = 12, width = 1, height = 2})
subview_bg:setLayoutComponentEnabled(true)
subview_bg:setName("subview_bg")
subview_bg:setTag(201)
subview_bg:setCascadeColorEnabled(true)
subview_bg:setCascadeOpacityEnabled(true)
subview_bg:setAnchorPoint(0.0000, 0.0000)
subview_bg:setPosition(-5.0000, -5.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(subview_bg)
layout:setSize({width = 829.0000, height = 645.0000})
layout:setLeftMargin(-5.0000)
layout:setRightMargin(-824.0000)
layout:setTopMargin(-640.0000)
layout:setBottomMargin(-5.0000)
nd_subview:addChild(subview_bg)

--Create img_hint_bg
local img_hint_bg = ccui.ImageView:create()
img_hint_bg:ignoreContentAdaptWithSize(false)
img_hint_bg:loadTexture("hall/common/tanhao.png",0)
img_hint_bg:setLayoutComponentEnabled(true)
img_hint_bg:setName("img_hint_bg")
img_hint_bg:setTag(202)
img_hint_bg:setCascadeColorEnabled(true)
img_hint_bg:setCascadeOpacityEnabled(true)
img_hint_bg:setAnchorPoint(1.0000, 0.5000)
img_hint_bg:setPosition(360.0000, 316.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_hint_bg)
layout:setPositionPercentX(0.4343)
layout:setPositionPercentY(0.4899)
layout:setPercentWidth(0.0495)
layout:setPercentHeight(0.0512)
layout:setSize({width = 41.0000, height = 33.0000})
layout:setLeftMargin(319.0000)
layout:setRightMargin(469.0000)
layout:setTopMargin(312.5000)
layout:setBottomMargin(299.5000)
subview_bg:addChild(img_hint_bg)

--Create txt_hint
local txt_hint = ccui.Text:create()
txt_hint:ignoreContentAdaptWithSize(true)
txt_hint:setTextAreaSize({width = 0, height = 0})
txt_hint:setFontSize(34)
txt_hint:setString([[暂无活动]])
txt_hint:setLayoutComponentEnabled(true)
txt_hint:setName("txt_hint")
txt_hint:setTag(203)
txt_hint:setCascadeColorEnabled(true)
txt_hint:setCascadeOpacityEnabled(true)
txt_hint:setAnchorPoint(0.0000, 0.5000)
txt_hint:setPosition(370.0000, 317.0000)
txt_hint:setTextColor({r = 173, g = 173, b = 173})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_hint)
layout:setPositionPercentX(0.4463)
layout:setPositionPercentY(0.4915)
layout:setPercentWidth(0.1641)
layout:setPercentHeight(0.0605)
layout:setSize({width = 136.0000, height = 39.0000})
layout:setLeftMargin(370.0000)
layout:setRightMargin(323.0000)
layout:setTopMargin(308.5000)
layout:setBottomMargin(297.5000)
subview_bg:addChild(txt_hint)

--Create txt_loading
local txt_loading = ccui.Text:create()
txt_loading:ignoreContentAdaptWithSize(true)
txt_loading:setTextAreaSize({width = 0, height = 0})
txt_loading:setFontSize(34)
txt_loading:setString([[数据加载中...]])
txt_loading:setLayoutComponentEnabled(true)
txt_loading:setName("txt_loading")
txt_loading:setTag(204)
txt_loading:setCascadeColorEnabled(true)
txt_loading:setCascadeOpacityEnabled(true)
txt_loading:setPosition(414.5000, 322.5000)
txt_loading:setTextColor({r = 127, g = 127, b = 127})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_loading)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.2400)
layout:setPercentHeight(0.0605)
layout:setSize({width = 199.0000, height = 39.0000})
layout:setLeftMargin(315.0000)
layout:setRightMargin(315.0000)
layout:setTopMargin(303.0000)
layout:setBottomMargin(303.0000)
subview_bg:addChild(txt_loading)

--Create Animation
result['animation'] = ccs.ActionTimeline:create()
  
result['animation']:setDuration(0)
result['animation']:setTimeSpeed(1.0000)
--Create Animation List

result['root'] = Node
return result;
end

return Result

