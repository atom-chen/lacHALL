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

--Create img_bg
local img_bg = ccui.Layout:create()
img_bg:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/jx_room.plist")
img_bg:setBackGroundImage("hall/room/jxroom/join_bg_1.png",1)
img_bg:setClippingEnabled(false)
img_bg:setBackGroundImageCapInsets({x = 17, y = 17, width = 18, height = 18})
img_bg:setBackGroundColorOpacity(102)
img_bg:setBackGroundImageScale9Enabled(true)
img_bg:setTouchEnabled(true);
img_bg:setLayoutComponentEnabled(true)
img_bg:setName("img_bg")
img_bg:setTag(254)
img_bg:setCascadeColorEnabled(true)
img_bg:setCascadeOpacityEnabled(true)
img_bg:setPosition(-569.0000, -333.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_bg)
layout:setSize({width = 1135.0000, height = 660.0000})
layout:setLeftMargin(-569.0000)
layout:setRightMargin(-566.0000)
layout:setTopMargin(-327.0000)
layout:setBottomMargin(-333.0000)
Node:addChild(img_bg)

--Create img_ditu
local img_ditu = ccui.ImageView:create()
img_ditu:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/jx_room.plist")
img_ditu:loadTexture("hall/room/jxroom/record_bg.png",1)
img_ditu:setScale9Enabled(true)
img_ditu:setCapInsets({x = 15, y = 15, width = 4, height = 4})
img_ditu:setLayoutComponentEnabled(true)
img_ditu:setName("img_ditu")
img_ditu:setTag(42)
img_ditu:setCascadeColorEnabled(true)
img_ditu:setCascadeOpacityEnabled(true)
img_ditu:setAnchorPoint(0.0000, 0.0000)
img_ditu:setPosition(13.0000, 16.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_ditu)
layout:setPositionPercentX(0.0115)
layout:setPositionPercentY(0.0242)
layout:setPercentWidth(0.9771)
layout:setPercentHeight(0.8682)
layout:setSize({width = 1109.0000, height = 573.0000})
layout:setLeftMargin(13.0000)
layout:setRightMargin(13.0000)
layout:setTopMargin(71.0000)
layout:setBottomMargin(16.0000)
img_bg:addChild(img_ditu)

--Create txt_title
local txt_title = ccui.Text:create()
txt_title:ignoreContentAdaptWithSize(true)
txt_title:setTextAreaSize({width = 0, height = 0})
txt_title:setFontName("")
txt_title:setFontSize(32)
txt_title:setString([[我的战绩]])
txt_title:setLayoutComponentEnabled(true)
txt_title:setName("txt_title")
txt_title:setTag(135)
txt_title:setCascadeColorEnabled(true)
txt_title:setCascadeOpacityEnabled(true)
txt_title:setPosition(567.5000, 624.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(txt_title)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.9455)
layout:setPercentWidth(0.1128)
layout:setPercentHeight(0.0500)
layout:setSize({width = 128.0000, height = 33.0000})
layout:setLeftMargin(503.5000)
layout:setRightMargin(503.5000)
layout:setTopMargin(19.5000)
layout:setBottomMargin(607.5000)
img_bg:addChild(txt_title)

--Create lv_record
local lv_record = ccui.ListView:create()
lv_record:setDirection(1)
lv_record:setGravity(0)
lv_record:ignoreContentAdaptWithSize(false)
lv_record:setClippingEnabled(true)
lv_record:setBackGroundImageCapInsets({x = -3, y = -3, width = 6, height = 6})
lv_record:setBackGroundImageScale9Enabled(true)
lv_record:setLayoutComponentEnabled(true)
lv_record:setName("lv_record")
lv_record:setTag(336)
lv_record:setCascadeColorEnabled(true)
lv_record:setCascadeOpacityEnabled(true)
lv_record:setAnchorPoint(0.5000, 0.5000)
lv_record:setPosition(567.5000, 303.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(lv_record)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.4591)
layout:setPercentWidth(0.9780)
layout:setPercentHeight(0.8561)
layout:setSize({width = 1110.0000, height = 565.0000})
layout:setLeftMargin(12.5000)
layout:setRightMargin(12.5000)
layout:setTopMargin(74.5000)
layout:setBottomMargin(20.5000)
img_bg:addChild(lv_record)

--Create txt_tips
local txt_tips = ccui.Text:create()
txt_tips:ignoreContentAdaptWithSize(true)
txt_tips:setTextAreaSize({width = 0, height = 0})
txt_tips:setFontName("")
txt_tips:setFontSize(32)
txt_tips:setString([[暂无战绩]])
txt_tips:setLayoutComponentEnabled(true)
txt_tips:setName("txt_tips")
txt_tips:setTag(41)
txt_tips:setCascadeColorEnabled(true)
txt_tips:setCascadeOpacityEnabled(true)
txt_tips:setVisible(false)
txt_tips:setPosition(567.5000, 330.0000)
txt_tips:setTextColor({r = 34, g = 34, b = 34})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_tips)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.1128)
layout:setPercentHeight(0.0500)
layout:setSize({width = 128.0000, height = 33.0000})
layout:setLeftMargin(503.5000)
layout:setRightMargin(503.5000)
layout:setTopMargin(313.5000)
layout:setBottomMargin(313.5000)
img_bg:addChild(txt_tips)

--Create btn_close
local btn_close = ccui.Layout:create()
btn_close:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/jx_room.plist")
btn_close:setBackGroundImage("hall/room/jxroom/join_close.png",1)
btn_close:setClippingEnabled(false)
btn_close:setBackGroundColorOpacity(102)
btn_close:setTouchEnabled(true);
btn_close:setLayoutComponentEnabled(true)
btn_close:setName("btn_close")
btn_close:setTag(134)
btn_close:setCascadeColorEnabled(true)
btn_close:setCascadeOpacityEnabled(true)
btn_close:setAnchorPoint(0.5000, 0.5000)
btn_close:setPosition(1092.0000, 624.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_close)
layout:setPositionPercentX(0.9621)
layout:setPositionPercentY(0.9455)
layout:setPercentWidth(0.0705)
layout:setPercentHeight(0.1212)
layout:setSize({width = 80.0000, height = 80.0000})
layout:setLeftMargin(1052.0000)
layout:setRightMargin(3.0000)
layout:setTopMargin(-4.0000)
layout:setBottomMargin(584.0000)
img_bg:addChild(btn_close)

--Create btn_search
local btn_search = ccui.Layout:create()
btn_search:ignoreContentAdaptWithSize(false)
btn_search:setClippingEnabled(false)
btn_search:setBackGroundColorOpacity(102)
btn_search:setTouchEnabled(true);
btn_search:setLayoutComponentEnabled(true)
btn_search:setName("btn_search")
btn_search:setTag(93)
btn_search:setCascadeColorEnabled(true)
btn_search:setCascadeOpacityEnabled(true)
btn_search:setAnchorPoint(0.5000, 0.5000)
btn_search:setPosition(890.0000, 624.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_search)
layout:setPositionPercentX(0.7841)
layout:setPositionPercentY(0.9455)
layout:setPercentWidth(0.1762)
layout:setPercentHeight(0.0909)
layout:setSize({width = 200.0000, height = 60.0000})
layout:setLeftMargin(790.0000)
layout:setRightMargin(145.0000)
layout:setTopMargin(6.0000)
layout:setBottomMargin(594.0000)
img_bg:addChild(btn_search)

--Create img_arrow
local img_arrow = ccui.ImageView:create()
img_arrow:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/jx_room.plist")
img_arrow:loadTexture("hall/room/jxroom/search_camera.png",1)
img_arrow:setLayoutComponentEnabled(true)
img_arrow:setName("img_arrow")
img_arrow:setTag(30)
img_arrow:setCascadeColorEnabled(true)
img_arrow:setCascadeOpacityEnabled(true)
img_arrow:setPosition(22.0000, 29.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_arrow)
layout:setPositionPercentX(0.1100)
layout:setPositionPercentY(0.4833)
layout:setPercentWidth(0.1650)
layout:setPercentHeight(0.3333)
layout:setSize({width = 33.0000, height = 20.0000})
layout:setLeftMargin(5.5000)
layout:setRightMargin(161.5000)
layout:setTopMargin(21.0000)
layout:setBottomMargin(19.0000)
btn_search:addChild(img_arrow)

--Create btn_name
local btn_name = ccui.Text:create()
btn_name:ignoreContentAdaptWithSize(true)
btn_name:setTextAreaSize({width = 0, height = 0})
btn_name:setFontName("")
btn_name:setFontSize(25)
btn_name:setString([[查看他人战绩]])
btn_name:setLayoutComponentEnabled(true)
btn_name:setName("btn_name")
btn_name:setTag(31)
btn_name:setCascadeColorEnabled(true)
btn_name:setCascadeOpacityEnabled(true)
btn_name:setPosition(120.0000, 29.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_name)
layout:setPositionPercentX(0.6000)
layout:setPositionPercentY(0.4833)
layout:setPercentWidth(0.7500)
layout:setPercentHeight(0.4167)
layout:setSize({width = 150.0000, height = 25.0000})
layout:setLeftMargin(45.0000)
layout:setRightMargin(5.0000)
layout:setTopMargin(18.5000)
layout:setBottomMargin(16.5000)
btn_search:addChild(btn_name)

--Create nd_search
local nd_search=cc.Node:create()
nd_search:setName("nd_search")
nd_search:setTag(32)
nd_search:setCascadeColorEnabled(true)
nd_search:setCascadeOpacityEnabled(true)
nd_search:setPosition(13.0000, 16.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(nd_search)
layout:setPositionPercentX(0.0115)
layout:setPositionPercentY(0.0242)
layout:setLeftMargin(13.0000)
layout:setRightMargin(1122.0000)
layout:setTopMargin(644.0000)
layout:setBottomMargin(16.0000)
img_bg:addChild(nd_search)

--Create Animation
result['animation'] = ccs.ActionTimeline:create()
  
result['animation']:setDuration(0)
result['animation']:setTimeSpeed(1.0000)
--Create Animation List

result['root'] = Node
return result;
end

return Result

