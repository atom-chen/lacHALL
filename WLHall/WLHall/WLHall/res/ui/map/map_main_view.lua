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

--Create sv_map
local sv_map = ccui.ScrollView:create()
sv_map:setDirection(3)
sv_map:setInnerContainerSize({width = 2280, height = 1440})
sv_map:ignoreContentAdaptWithSize(false)
sv_map:setClippingEnabled(true)
sv_map:setBackGroundColorOpacity(102)
sv_map:setLayoutComponentEnabled(true)
sv_map:setName("sv_map")
sv_map:setTag(251)
sv_map:setCascadeColorEnabled(true)
sv_map:setCascadeOpacityEnabled(true)
layout = ccui.LayoutComponent:bindLayoutComponent(sv_map)
layout:setPercentWidthEnabled(true)
layout:setPercentHeightEnabled(true)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(1.0000)
layout:setSize({width = 1280.0000, height = 720.0000})
Layer:addChild(sv_map)

--Create nd_map
innerCSD = require("ui.map.map_china")
innerProject = innerCSD.create(callBackProvider)
local nd_map = innerProject.root
nd_map.animation = innerProject.animation
nd_map:setName("nd_map")
nd_map:setTag(252)
nd_map:setCascadeColorEnabled(true)
nd_map:setCascadeOpacityEnabled(true)
nd_map:setScaleX(1.2000)
nd_map:setScaleY(1.2000)
layout = ccui.LayoutComponent:bindLayoutComponent(nd_map)
layout:setRightMargin(2280.0000)
layout:setTopMargin(1440.0000)
innerProject.animation:setTimeSpeed(1.0000)
nd_map:runAction(innerProject.animation)
sv_map:addChild(nd_map)

--Create btn_back
local btn_back = ccui.Layout:create()
btn_back:ignoreContentAdaptWithSize(false)
btn_back:setClippingEnabled(false)
btn_back:setBackGroundColorOpacity(102)
btn_back:setTouchEnabled(true);
btn_back:setLayoutComponentEnabled(true)
btn_back:setName("btn_back")
btn_back:setTag(578)
btn_back:setCascadeColorEnabled(true)
btn_back:setCascadeOpacityEnabled(true)
btn_back:setAnchorPoint(0.5000, 0.5000)
btn_back:setPosition(60.0000, 660.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_back)
layout:setPositionPercentX(0.0469)
layout:setPositionPercentY(0.9167)
layout:setPercentWidth(0.0859)
layout:setPercentHeight(0.1528)
layout:setSize({width = 110.0000, height = 110.0000})
layout:setHorizontalEdge(1)
layout:setVerticalEdge(2)
layout:setLeftMargin(5.0000)
layout:setRightMargin(1165.0000)
layout:setTopMargin(5.0000)
layout:setBottomMargin(605.0000)
Layer:addChild(btn_back)

--Create img_back
local img_back = ccui.Button:create()
img_back:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/map.plist")
img_back:loadTextureNormal("hall/map/fanhui.png",1)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/map.plist")
img_back:loadTexturePressed("hall/map/fanhui.png",1)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/map.plist")
img_back:loadTextureDisabled("hall/map/fanhui.png",1)
img_back:setTitleFontSize(14)
img_back:setTitleColor({r = 65, g = 65, b = 70})
img_back:setScale9Enabled(true)
img_back:setCapInsets({x = 15, y = 11, width = 23, height = 34})
img_back:setTouchEnabled(false);
img_back:setLayoutComponentEnabled(true)
img_back:setName("img_back")
img_back:setTag(250)
img_back:setCascadeColorEnabled(true)
img_back:setCascadeOpacityEnabled(true)
img_back:setPosition(55.0000, 55.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_back)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.4818)
layout:setPercentHeight(0.5091)
layout:setSize({width = 53.0000, height = 56.0000})
layout:setLeftMargin(28.5000)
layout:setRightMargin(28.5000)
layout:setTopMargin(27.0000)
layout:setBottomMargin(27.0000)
btn_back:addChild(img_back)

--Create img_xzdq
local img_xzdq = ccui.ImageView:create()
img_xzdq:ignoreContentAdaptWithSize(false)
img_xzdq:loadTexture("hall/common/btn_xzwf.png",0)
img_xzdq:setLayoutComponentEnabled(true)
img_xzdq:setName("img_xzdq")
img_xzdq:setTag(249)
img_xzdq:setCascadeColorEnabled(true)
img_xzdq:setCascadeOpacityEnabled(true)
img_xzdq:setPosition(190.0000, 660.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_xzdq)
layout:setPositionPercentX(0.1484)
layout:setPositionPercentY(0.9167)
layout:setPercentWidth(0.1367)
layout:setPercentHeight(0.0639)
layout:setSize({width = 175.0000, height = 46.0000})
layout:setLeftMargin(102.5000)
layout:setRightMargin(1002.5000)
layout:setTopMargin(37.0000)
layout:setBottomMargin(637.0000)
Layer:addChild(img_xzdq)

--Create nd_tips
local nd_tips = ccui.Layout:create()
nd_tips:ignoreContentAdaptWithSize(false)
nd_tips:setClippingEnabled(false)
nd_tips:setBackGroundColorType(1)
nd_tips:setBackGroundColor({r = 0, g = 0, b = 0})
nd_tips:setBackGroundColorOpacity(178)
nd_tips:setTouchEnabled(true);
nd_tips:setLayoutComponentEnabled(true)
nd_tips:setName("nd_tips")
nd_tips:setTag(429)
nd_tips:setCascadeColorEnabled(true)
nd_tips:setCascadeOpacityEnabled(true)
layout = ccui.LayoutComponent:bindLayoutComponent(nd_tips)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(1.0000)
layout:setSize({width = 1280.0000, height = 720.0000})
layout:setHorizontalEdge(3)
layout:setVerticalEdge(3)
layout:setStretchWidthEnabled(true)
layout:setStretchHeightEnabled(true)
Layer:addChild(nd_tips)

--Create img_tips
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/map.plist")
local img_tips = cc.Sprite:createWithSpriteFrameName("hall/map/btn_zuob.png")
img_tips:setName("img_tips")
img_tips:setTag(430)
img_tips:setCascadeColorEnabled(true)
img_tips:setCascadeOpacityEnabled(true)
img_tips:setPosition(640.0000, 429.9840)
layout = ccui.LayoutComponent:bindLayoutComponent(img_tips)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5972)
layout:setPercentWidth(0.4180)
layout:setPercentHeight(0.6486)
layout:setSize({width = 535.0000, height = 467.0000})
layout:setHorizontalEdge(3)
layout:setVerticalEdge(3)
layout:setLeftMargin(372.5000)
layout:setRightMargin(372.5000)
layout:setTopMargin(56.5160)
layout:setBottomMargin(196.4840)
img_tips:setBlendFunc({src = 1, dst = 771})
nd_tips:addChild(img_tips)

--Create btn_ok
local btn_ok = ccui.Button:create()
btn_ok:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/map.plist")
btn_ok:loadTextureNormal("hall/map/btn_anniu.png",1)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/map.plist")
btn_ok:loadTexturePressed("hall/map/btn_anniu.png",1)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/map.plist")
btn_ok:loadTextureDisabled("hall/map/btn_anniu.png",1)
btn_ok:setTitleFontSize(14)
btn_ok:setTitleColor({r = 65, g = 65, b = 70})
btn_ok:setScale9Enabled(true)
btn_ok:setCapInsets({x = 15, y = 11, width = 282, height = 72})
btn_ok:setLayoutComponentEnabled(true)
btn_ok:setName("btn_ok")
btn_ok:setTag(431)
btn_ok:setCascadeColorEnabled(true)
btn_ok:setCascadeOpacityEnabled(true)
btn_ok:setPosition(640.0000, 100.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_ok)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.1389)
layout:setPercentWidth(0.2438)
layout:setPercentHeight(0.1306)
layout:setSize({width = 312.0000, height = 94.0000})
layout:setLeftMargin(484.0000)
layout:setRightMargin(484.0000)
layout:setTopMargin(573.0000)
layout:setBottomMargin(53.0000)
nd_tips:addChild(btn_ok)

--Create nd_cloud
local nd_cloud=cc.Node:create()
nd_cloud:setName("nd_cloud")
nd_cloud:setTag(244)
nd_cloud:setCascadeColorEnabled(true)
nd_cloud:setCascadeOpacityEnabled(true)
nd_cloud:setPosition(640.0000, 360.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(nd_cloud)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setLeftMargin(640.0000)
layout:setRightMargin(640.0000)
layout:setTopMargin(360.0000)
layout:setBottomMargin(360.0000)
Layer:addChild(nd_cloud)

--Create cloud_1
local cloud_1 = ccui.ImageView:create()
cloud_1:ignoreContentAdaptWithSize(false)
cloud_1:loadTexture("hall/map/yun1.png",0)
cloud_1:setLayoutComponentEnabled(true)
cloud_1:setName("cloud_1")
cloud_1:setTag(245)
cloud_1:setCascadeColorEnabled(true)
cloud_1:setCascadeOpacityEnabled(true)
cloud_1:setPosition(-1152.5900, 0.0000)
cloud_1:setOpacity(0)
layout = ccui.LayoutComponent:bindLayoutComponent(cloud_1)
layout:setSize({width = 1038.0000, height = 720.0000})
layout:setLeftMargin(-1671.5900)
layout:setRightMargin(633.5900)
layout:setTopMargin(-360.0000)
layout:setBottomMargin(-360.0000)
nd_cloud:addChild(cloud_1)

--Create cloud_2
local cloud_2 = ccui.ImageView:create()
cloud_2:ignoreContentAdaptWithSize(false)
cloud_2:loadTexture("hall/map/yun2.png",0)
cloud_2:setLayoutComponentEnabled(true)
cloud_2:setName("cloud_2")
cloud_2:setTag(246)
cloud_2:setCascadeColorEnabled(true)
cloud_2:setCascadeOpacityEnabled(true)
cloud_2:setPosition(1164.7700, 0.0000)
cloud_2:setOpacity(0)
layout = ccui.LayoutComponent:bindLayoutComponent(cloud_2)
layout:setSize({width = 1059.0000, height = 720.0000})
layout:setLeftMargin(635.2703)
layout:setRightMargin(-1694.2700)
layout:setTopMargin(-360.0000)
layout:setBottomMargin(-360.0000)
nd_cloud:addChild(cloud_2)

--Create Animation
result['animation'] = ccs.ActionTimeline:create()
  
result['animation']:setDuration(180)
result['animation']:setTimeSpeed(1.0000)

--Create PositionTimeline
local PositionTimeline = ccs.Timeline:create()

localFrame = ccs.PositionFrame:create()
localFrame:setFrameIndex(90)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setX(0.0000)
localFrame:setY(0.0000)
PositionTimeline:addFrame(localFrame)

result['animation']:addTimeline(PositionTimeline)
PositionTimeline:setNode(sv_map)

--Create ScaleTimeline
local ScaleTimeline = ccs.Timeline:create()

localFrame = ccs.ScaleFrame:create()
localFrame:setFrameIndex(90)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setScaleX(1.0000)
localFrame:setScaleY(1.0000)
ScaleTimeline:addFrame(localFrame)

result['animation']:addTimeline(ScaleTimeline)
ScaleTimeline:setNode(sv_map)

--Create RotationSkewTimeline
local RotationSkewTimeline = ccs.Timeline:create()

localFrame = ccs.RotationSkewFrame:create()
localFrame:setFrameIndex(90)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setSkewX(0.0000)
localFrame:setSkewY(0.0000)
RotationSkewTimeline:addFrame(localFrame)

result['animation']:addTimeline(RotationSkewTimeline)
RotationSkewTimeline:setNode(sv_map)

--Create FrameEventTimeline
local FrameEventTimeline = ccs.Timeline:create()

localFrame = ccs.EventFrame:create()
localFrame:setFrameIndex(90)
localFrame:setTween(false)
localFrame:setEvent("svmove")
FrameEventTimeline:addFrame(localFrame)

result['animation']:addTimeline(FrameEventTimeline)
FrameEventTimeline:setNode(sv_map)

--Create PositionTimeline
local PositionTimeline = ccs.Timeline:create()

localFrame = ccs.PositionFrame:create()
localFrame:setFrameIndex(0)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setX(-1152.5900)
localFrame:setY(0.0000)
PositionTimeline:addFrame(localFrame)

localFrame = ccs.PositionFrame:create()
localFrame:setFrameIndex(70)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setX(-122.0000)
localFrame:setY(0.0000)
PositionTimeline:addFrame(localFrame)

localFrame = ccs.PositionFrame:create()
localFrame:setFrameIndex(110)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setX(-122.0000)
localFrame:setY(0.0000)
PositionTimeline:addFrame(localFrame)

localFrame = ccs.PositionFrame:create()
localFrame:setFrameIndex(180)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setX(-1155.3500)
localFrame:setY(0.0000)
PositionTimeline:addFrame(localFrame)

result['animation']:addTimeline(PositionTimeline)
PositionTimeline:setNode(cloud_1)

--Create ScaleTimeline
local ScaleTimeline = ccs.Timeline:create()

localFrame = ccs.ScaleFrame:create()
localFrame:setFrameIndex(0)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setScaleX(1.0000)
localFrame:setScaleY(1.0000)
ScaleTimeline:addFrame(localFrame)

localFrame = ccs.ScaleFrame:create()
localFrame:setFrameIndex(70)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setScaleX(1.0000)
localFrame:setScaleY(1.0000)
ScaleTimeline:addFrame(localFrame)

localFrame = ccs.ScaleFrame:create()
localFrame:setFrameIndex(110)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setScaleX(1.0000)
localFrame:setScaleY(1.0000)
ScaleTimeline:addFrame(localFrame)

localFrame = ccs.ScaleFrame:create()
localFrame:setFrameIndex(180)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setScaleX(1.0000)
localFrame:setScaleY(1.0000)
ScaleTimeline:addFrame(localFrame)

result['animation']:addTimeline(ScaleTimeline)
ScaleTimeline:setNode(cloud_1)

--Create RotationSkewTimeline
local RotationSkewTimeline = ccs.Timeline:create()

localFrame = ccs.RotationSkewFrame:create()
localFrame:setFrameIndex(0)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setSkewX(0.0000)
localFrame:setSkewY(0.0000)
RotationSkewTimeline:addFrame(localFrame)

localFrame = ccs.RotationSkewFrame:create()
localFrame:setFrameIndex(70)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setSkewX(0.0000)
localFrame:setSkewY(0.0000)
RotationSkewTimeline:addFrame(localFrame)

localFrame = ccs.RotationSkewFrame:create()
localFrame:setFrameIndex(110)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setSkewX(0.0000)
localFrame:setSkewY(0.0000)
RotationSkewTimeline:addFrame(localFrame)

localFrame = ccs.RotationSkewFrame:create()
localFrame:setFrameIndex(180)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setSkewX(0.0000)
localFrame:setSkewY(0.0000)
RotationSkewTimeline:addFrame(localFrame)

result['animation']:addTimeline(RotationSkewTimeline)
RotationSkewTimeline:setNode(cloud_1)

--Create AlphaTimeline
local AlphaTimeline = ccs.Timeline:create()

localFrame = ccs.AlphaFrame:create()
localFrame:setFrameIndex(0)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setAlpha(0)
AlphaTimeline:addFrame(localFrame)

localFrame = ccs.AlphaFrame:create()
localFrame:setFrameIndex(70)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setAlpha(255)
AlphaTimeline:addFrame(localFrame)

localFrame = ccs.AlphaFrame:create()
localFrame:setFrameIndex(110)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setAlpha(255)
AlphaTimeline:addFrame(localFrame)

localFrame = ccs.AlphaFrame:create()
localFrame:setFrameIndex(180)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setAlpha(255)
AlphaTimeline:addFrame(localFrame)

result['animation']:addTimeline(AlphaTimeline)
AlphaTimeline:setNode(cloud_1)

--Create PositionTimeline
local PositionTimeline = ccs.Timeline:create()

localFrame = ccs.PositionFrame:create()
localFrame:setFrameIndex(0)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setX(1164.7700)
localFrame:setY(0.0000)
PositionTimeline:addFrame(localFrame)

localFrame = ccs.PositionFrame:create()
localFrame:setFrameIndex(70)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setX(111.0000)
localFrame:setY(0.0000)
PositionTimeline:addFrame(localFrame)

localFrame = ccs.PositionFrame:create()
localFrame:setFrameIndex(110)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setX(110.0000)
localFrame:setY(0.0000)
PositionTimeline:addFrame(localFrame)

localFrame = ccs.PositionFrame:create()
localFrame:setFrameIndex(180)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setX(1163.0690)
localFrame:setY(0.0000)
PositionTimeline:addFrame(localFrame)

result['animation']:addTimeline(PositionTimeline)
PositionTimeline:setNode(cloud_2)

--Create ScaleTimeline
local ScaleTimeline = ccs.Timeline:create()

localFrame = ccs.ScaleFrame:create()
localFrame:setFrameIndex(0)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setScaleX(1.0000)
localFrame:setScaleY(1.0000)
ScaleTimeline:addFrame(localFrame)

localFrame = ccs.ScaleFrame:create()
localFrame:setFrameIndex(70)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setScaleX(1.0000)
localFrame:setScaleY(1.0000)
ScaleTimeline:addFrame(localFrame)

localFrame = ccs.ScaleFrame:create()
localFrame:setFrameIndex(110)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setScaleX(1.0000)
localFrame:setScaleY(1.0000)
ScaleTimeline:addFrame(localFrame)

localFrame = ccs.ScaleFrame:create()
localFrame:setFrameIndex(180)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setScaleX(1.0000)
localFrame:setScaleY(1.0000)
ScaleTimeline:addFrame(localFrame)

result['animation']:addTimeline(ScaleTimeline)
ScaleTimeline:setNode(cloud_2)

--Create RotationSkewTimeline
local RotationSkewTimeline = ccs.Timeline:create()

localFrame = ccs.RotationSkewFrame:create()
localFrame:setFrameIndex(0)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setSkewX(0.0000)
localFrame:setSkewY(0.0000)
RotationSkewTimeline:addFrame(localFrame)

localFrame = ccs.RotationSkewFrame:create()
localFrame:setFrameIndex(70)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setSkewX(0.0000)
localFrame:setSkewY(0.0000)
RotationSkewTimeline:addFrame(localFrame)

localFrame = ccs.RotationSkewFrame:create()
localFrame:setFrameIndex(110)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setSkewX(0.0000)
localFrame:setSkewY(0.0000)
RotationSkewTimeline:addFrame(localFrame)

localFrame = ccs.RotationSkewFrame:create()
localFrame:setFrameIndex(180)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setSkewX(0.0000)
localFrame:setSkewY(0.0000)
RotationSkewTimeline:addFrame(localFrame)

result['animation']:addTimeline(RotationSkewTimeline)
RotationSkewTimeline:setNode(cloud_2)

--Create AlphaTimeline
local AlphaTimeline = ccs.Timeline:create()

localFrame = ccs.AlphaFrame:create()
localFrame:setFrameIndex(0)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setAlpha(0)
AlphaTimeline:addFrame(localFrame)

localFrame = ccs.AlphaFrame:create()
localFrame:setFrameIndex(70)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setAlpha(255)
AlphaTimeline:addFrame(localFrame)

localFrame = ccs.AlphaFrame:create()
localFrame:setFrameIndex(110)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setAlpha(255)
AlphaTimeline:addFrame(localFrame)

localFrame = ccs.AlphaFrame:create()
localFrame:setFrameIndex(180)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setAlpha(255)
AlphaTimeline:addFrame(localFrame)

result['animation']:addTimeline(AlphaTimeline)
AlphaTimeline:setNode(cloud_2)

--Create FrameEventTimeline
local FrameEventTimeline = ccs.Timeline:create()

localFrame = ccs.EventFrame:create()
localFrame:setFrameIndex(0)
localFrame:setTween(false)
localFrame:setEvent("")
FrameEventTimeline:addFrame(localFrame)

localFrame = ccs.EventFrame:create()
localFrame:setFrameIndex(70)
localFrame:setTween(false)
localFrame:setEvent("")
FrameEventTimeline:addFrame(localFrame)

localFrame = ccs.EventFrame:create()
localFrame:setFrameIndex(110)
localFrame:setTween(false)
localFrame:setEvent("")
FrameEventTimeline:addFrame(localFrame)

localFrame = ccs.EventFrame:create()
localFrame:setFrameIndex(180)
localFrame:setTween(false)
localFrame:setEvent("")
FrameEventTimeline:addFrame(localFrame)

result['animation']:addTimeline(FrameEventTimeline)
FrameEventTimeline:setNode(cloud_2)
--Create Animation List
local ani_cloud = {name="ani_cloud", startIndex=0, endIndex=180}
result['animation']:addAnimationInfo(ani_cloud)

result['root'] = Layer
return result;
end

return Result

