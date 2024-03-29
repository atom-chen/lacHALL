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

--Create tab_btn
local tab_btn = ccui.Layout:create()
tab_btn:ignoreContentAdaptWithSize(false)
tab_btn:setClippingEnabled(false)
tab_btn:setBackGroundColorOpacity(102)
tab_btn:setTouchEnabled(true);
tab_btn:setLayoutComponentEnabled(true)
tab_btn:setName("tab_btn")
tab_btn:setTag(56)
tab_btn:setCascadeColorEnabled(true)
tab_btn:setCascadeOpacityEnabled(true)
tab_btn:setAnchorPoint(0.5000, 0.5000)
tab_btn:setPosition(137.0000, 48.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(tab_btn)
layout:setSize({width = 273.0000, height = 96.0000})
layout:setLeftMargin(0.5000)
layout:setRightMargin(-273.5000)
layout:setTopMargin(-96.0000)
Node:addChild(tab_btn)

--Create img_sep
local img_sep = ccui.ImageView:create()
img_sep:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
img_sep:loadTexture("hall/common/new_virtual_line.png",1)
img_sep:setLayoutComponentEnabled(true)
img_sep:setName("img_sep")
img_sep:setTag(57)
img_sep:setCascadeColorEnabled(true)
img_sep:setCascadeOpacityEnabled(true)
img_sep:setAnchorPoint(0.5000, 0.0000)
img_sep:setPosition(136.5000, -2.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_sep)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(-0.0208)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(0.0208)
layout:setSize({width = 273.0000, height = 2.0000})
layout:setTopMargin(96.0000)
layout:setBottomMargin(-2.0000)
tab_btn:addChild(img_sep)

--Create img_sel
local img_sel = ccui.ImageView:create()
img_sel:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
img_sel:loadTexture("hall/common/new_pop_select_bg.png",1)
img_sel:setLayoutComponentEnabled(true)
img_sel:setName("img_sel")
img_sel:setTag(58)
img_sel:setCascadeColorEnabled(true)
img_sel:setCascadeOpacityEnabled(true)
img_sel:setVisible(false)
img_sel:setPosition(136.5000, 48.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_sel)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(1.0037)
layout:setPercentHeight(1.0000)
layout:setSize({width = 274.0000, height = 96.0000})
layout:setLeftMargin(-0.5000)
layout:setRightMargin(-0.5000)
tab_btn:addChild(img_sel)

--Create img_icon
local img_icon = ccui.ImageView:create()
img_icon:ignoreContentAdaptWithSize(false)
img_icon:loadTexture("weile/icon_default.png",0)
img_icon:setLayoutComponentEnabled(true)
img_icon:setName("img_icon")
img_icon:setTag(59)
img_icon:setCascadeColorEnabled(true)
img_icon:setCascadeOpacityEnabled(true)
img_icon:setPosition(62.9978, 48.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_icon)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.2308)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.2198)
layout:setPercentHeight(0.6250)
layout:setSize({width = 60.0000, height = 60.0000})
layout:setLeftMargin(32.9978)
layout:setRightMargin(180.0022)
layout:setTopMargin(18.0000)
layout:setBottomMargin(18.0000)
tab_btn:addChild(img_icon)

--Create txt_title
local txt_title = ccui.Text:create()
txt_title:ignoreContentAdaptWithSize(true)
txt_title:setTextAreaSize({width = 0, height = 0})
txt_title:setFontName("")
txt_title:setFontSize(28)
txt_title:setString([[我的资料]])
txt_title:setLayoutComponentEnabled(true)
txt_title:setName("txt_title")
txt_title:setTag(60)
txt_title:setCascadeColorEnabled(true)
txt_title:setCascadeOpacityEnabled(true)
txt_title:setAnchorPoint(0.0000, 0.5000)
txt_title:setPosition(107.9949, 48.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(txt_title)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.3956)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.4103)
layout:setPercentHeight(0.2917)
layout:setSize({width = 112.0000, height = 28.0000})
layout:setLeftMargin(107.9949)
layout:setRightMargin(53.0051)
layout:setTopMargin(34.0000)
layout:setBottomMargin(34.0000)
tab_btn:addChild(txt_title)

--Create Animation
result['animation'] = ccs.ActionTimeline:create()
  
result['animation']:setDuration(0)
result['animation']:setTimeSpeed(1.0000)
--Create Animation List

result['root'] = Node
return result;
end

return Result

