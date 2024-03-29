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
layout:setSize({width = 1280.0000, height = 720.0000})

--Create nd_btns
local nd_btns=cc.Node:create()
nd_btns:setName("nd_btns")
nd_btns:setTag(133)
nd_btns:setCascadeColorEnabled(true)
nd_btns:setCascadeOpacityEnabled(true)
nd_btns:setPosition(640.0000, 360.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(nd_btns)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setHorizontalEdge(3)
layout:setVerticalEdge(3)
layout:setLeftMargin(640.0000)
layout:setRightMargin(640.0000)
layout:setTopMargin(360.0000)
layout:setBottomMargin(360.0000)
Layer:addChild(nd_btns)

--Create btn_arena
local btn_arena = ccui.Button:create()
btn_arena:ignoreContentAdaptWithSize(false)
btn_arena:loadTextureNormal("hall/room/entrance/btn_hyflt.png",0)
btn_arena:loadTexturePressed("hall/room/entrance/btn_hyflt.png",0)
btn_arena:loadTextureDisabled("hall/room/entrance/btn_hyflt.png",0)
btn_arena:setTitleFontSize(14)
btn_arena:setTitleColor({r = 65, g = 65, b = 70})
btn_arena:setScale9Enabled(true)
btn_arena:setCapInsets({x = 15, y = 11, width = 345, height = 421})
btn_arena:setLayoutComponentEnabled(true)
btn_arena:setName("btn_arena")
btn_arena:setTag(129)
btn_arena:setCascadeColorEnabled(true)
btn_arena:setCascadeOpacityEnabled(true)
btn_arena:setPosition(-364.0000, 10.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_arena)
layout:setSize({width = 375.0000, height = 443.0000})
layout:setLeftMargin(-551.5000)
layout:setRightMargin(176.5000)
layout:setTopMargin(-231.5000)
layout:setBottomMargin(-211.5000)
nd_btns:addChild(btn_arena)

--Create btn_club
local btn_club = ccui.Button:create()
btn_club:ignoreContentAdaptWithSize(false)
btn_club:loadTextureNormal("hall/room/entrance/btn_jlb.png",0)
btn_club:loadTexturePressed("hall/room/entrance/btn_jlb.png",0)
btn_club:loadTextureDisabled("hall/room/entrance/btn_jlb.png",0)
btn_club:setTitleFontSize(14)
btn_club:setTitleColor({r = 65, g = 65, b = 70})
btn_club:setScale9Enabled(true)
btn_club:setCapInsets({x = 15, y = 11, width = 345, height = 421})
btn_club:setLayoutComponentEnabled(true)
btn_club:setName("btn_club")
btn_club:setTag(130)
btn_club:setCascadeColorEnabled(true)
btn_club:setCascadeOpacityEnabled(true)
btn_club:setPosition(30.0000, 10.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_club)
layout:setSize({width = 375.0000, height = 443.0000})
layout:setLeftMargin(-157.5000)
layout:setRightMargin(-217.5000)
layout:setTopMargin(-231.5000)
layout:setBottomMargin(-211.5000)
nd_btns:addChild(btn_club)

--Create btn_join
local btn_join = ccui.Button:create()
btn_join:ignoreContentAdaptWithSize(false)
btn_join:loadTextureNormal("hall/room/entrance/btn_jrfj.png",0)
btn_join:loadTexturePressed("hall/room/entrance/btn_jrfj.png",0)
btn_join:loadTextureDisabled("hall/room/entrance/btn_jrfj.png",0)
btn_join:setTitleFontSize(14)
btn_join:setTitleColor({r = 65, g = 65, b = 70})
btn_join:setScale9Enabled(true)
btn_join:setCapInsets({x = 15, y = 11, width = 285, height = 190})
btn_join:setLayoutComponentEnabled(true)
btn_join:setName("btn_join")
btn_join:setTag(132)
btn_join:setCascadeColorEnabled(true)
btn_join:setCascadeOpacityEnabled(true)
btn_join:setPosition(395.0000, 126.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_join)
layout:setSize({width = 315.0000, height = 212.0000})
layout:setLeftMargin(237.5000)
layout:setRightMargin(-552.5000)
layout:setTopMargin(-232.0000)
layout:setBottomMargin(20.0000)
nd_btns:addChild(btn_join)

--Create btn_create
local btn_create = ccui.Button:create()
btn_create:ignoreContentAdaptWithSize(false)
btn_create:loadTextureNormal("hall/room/entrance/btn_cjfj.png",0)
btn_create:loadTexturePressed("hall/room/entrance/btn_cjfj.png",0)
btn_create:loadTextureDisabled("hall/room/entrance/btn_cjfj.png",0)
btn_create:setTitleFontSize(14)
btn_create:setTitleColor({r = 65, g = 65, b = 70})
btn_create:setScale9Enabled(true)
btn_create:setCapInsets({x = 15, y = 11, width = 285, height = 189})
btn_create:setLayoutComponentEnabled(true)
btn_create:setName("btn_create")
btn_create:setTag(131)
btn_create:setCascadeColorEnabled(true)
btn_create:setCascadeOpacityEnabled(true)
btn_create:setPosition(396.0000, -105.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_create)
layout:setSize({width = 315.0000, height = 211.0000})
layout:setLeftMargin(238.5000)
layout:setRightMargin(-553.5000)
layout:setTopMargin(-0.5000)
layout:setBottomMargin(-210.5000)
nd_btns:addChild(btn_create)

--Create btn_record
local btn_record = ccui.Button:create()
btn_record:ignoreContentAdaptWithSize(false)
btn_record:loadTextureNormal("hall/room/entrance/btn_zj.png",0)
btn_record:loadTexturePressed("hall/room/entrance/btn_zj.png",0)
btn_record:loadTextureDisabled("hall/room/entrance/btn_zj.png",0)
btn_record:setTitleFontSize(14)
btn_record:setTitleColor({r = 65, g = 65, b = 70})
btn_record:setScale9Enabled(true)
btn_record:setCapInsets({x = 15, y = 11, width = 285, height = 74})
btn_record:setLayoutComponentEnabled(true)
btn_record:setName("btn_record")
btn_record:setTag(259)
btn_record:setCascadeColorEnabled(true)
btn_record:setCascadeOpacityEnabled(true)
btn_record:setPosition(396.0000, -279.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_record)
layout:setSize({width = 315.0000, height = 96.0000})
layout:setLeftMargin(238.5000)
layout:setRightMargin(-553.5000)
layout:setTopMargin(231.0000)
layout:setBottomMargin(-327.0000)
nd_btns:addChild(btn_record)

--Create img_back_bg
local img_back_bg = ccui.ImageView:create()
img_back_bg:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/gmaelist.plist")
img_back_bg:loadTexture("hall/newgamelist/img_bg1.png",1)
img_back_bg:setLayoutComponentEnabled(true)
img_back_bg:setName("img_back_bg")
img_back_bg:setTag(285)
img_back_bg:setCascadeColorEnabled(true)
img_back_bg:setCascadeOpacityEnabled(true)
img_back_bg:setAnchorPoint(0.0000, 1.0000)
img_back_bg:setPosition(0.0000, 720.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_back_bg)
layout:setPositionPercentY(1.0000)
layout:setPercentWidth(0.1930)
layout:setPercentHeight(0.1181)
layout:setSize({width = 247.0000, height = 85.0000})
layout:setRightMargin(1033.0000)
layout:setBottomMargin(635.0000)
Layer:addChild(img_back_bg)

--Create btn_close
local btn_close = ccui.Layout:create()
btn_close:ignoreContentAdaptWithSize(false)
btn_close:setClippingEnabled(false)
btn_close:setBackGroundColorOpacity(102)
btn_close:setTouchEnabled(true);
btn_close:setLayoutComponentEnabled(true)
btn_close:setName("btn_close")
btn_close:setTag(286)
btn_close:setCascadeColorEnabled(true)
btn_close:setCascadeOpacityEnabled(true)
btn_close:setAnchorPoint(0.5000, 0.5000)
btn_close:setPosition(101.2700, 45.0500)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_close)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.4100)
layout:setPositionPercentY(0.5300)
layout:setPercentWidth(0.6073)
layout:setPercentHeight(0.8235)
layout:setSize({width = 150.0000, height = 70.0000})
layout:setLeftMargin(26.2700)
layout:setRightMargin(70.7300)
layout:setTopMargin(4.9500)
layout:setBottomMargin(10.0500)
img_back_bg:addChild(btn_close)

--Create img_fh
local img_fh = ccui.ImageView:create()
img_fh:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/gmaelist.plist")
img_fh:loadTexture("hall/newgamelist/cbtnlose.png",1)
img_fh:setLayoutComponentEnabled(true)
img_fh:setName("img_fh")
img_fh:setTag(287)
img_fh:setCascadeColorEnabled(true)
img_fh:setCascadeOpacityEnabled(true)
img_fh:setPosition(75.0000, 35.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_fh)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.7733)
layout:setPercentHeight(0.6143)
layout:setSize({width = 116.0000, height = 43.0000})
layout:setLeftMargin(17.0000)
layout:setRightMargin(17.0000)
layout:setTopMargin(13.5000)
layout:setBottomMargin(13.5000)
btn_close:addChild(img_fh)

--Create Animation
result['animation'] = ccs.ActionTimeline:create()
  
result['animation']:setDuration(0)
result['animation']:setTimeSpeed(1.0000)
--Create Animation List
local btnani = {name="btnani", startIndex=0, endIndex=240}
result['animation']:addAnimationInfo(btnani)

result['root'] = Layer
return result;
end

return Result

