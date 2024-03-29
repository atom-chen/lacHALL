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

--Create txt_msg
local txt_msg = ccui.Text:create()
txt_msg:ignoreContentAdaptWithSize(true)
txt_msg:setTextAreaSize({width = 0, height = 0})
txt_msg:setFontSize(26)
txt_msg:setString([[正在努力加载房间,请稍候...]])
txt_msg:setLayoutComponentEnabled(true)
txt_msg:setName("txt_msg")
txt_msg:setTag(166)
txt_msg:setCascadeColorEnabled(true)
txt_msg:setCascadeOpacityEnabled(true)
txt_msg:setPosition(16.8431, -73.9279)
txt_msg:setTextColor({r = 241, g = 226, b = 181})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_msg)
layout:setSize({width = 338.0000, height = 26.0000})
layout:setLeftMargin(-152.1569)
layout:setRightMargin(-185.8431)
layout:setTopMargin(60.9279)
layout:setBottomMargin(-86.9279)
Node:addChild(txt_msg)

--Create nd_img
local nd_img=cc.Node:create()
nd_img:setName("nd_img")
nd_img:setTag(48)
nd_img:setCascadeColorEnabled(true)
nd_img:setCascadeOpacityEnabled(true)
layout = ccui.LayoutComponent:bindLayoutComponent(nd_img)
Node:addChild(nd_img)

--Create img_
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
local img_ = cc.Sprite:createWithSpriteFrameName("hall/common/loading_peach.png")
img_:setName("img_")
img_:setTag(81)
img_:setCascadeColorEnabled(true)
img_:setCascadeOpacityEnabled(true)
img_:setScaleX(0.5050)
layout = ccui.LayoutComponent:bindLayoutComponent(img_)
layout:setSize({width = 46.0000, height = 46.0000})
layout:setLeftMargin(-23.0000)
layout:setRightMargin(-23.0000)
layout:setTopMargin(-23.0000)
layout:setBottomMargin(-23.0000)
img_:setBlendFunc({src = 1, dst = 771})
nd_img:addChild(img_)

--Create img_dialog
local img_dialog = ccui.ImageView:create()
img_dialog:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
img_dialog:loadTexture("hall/common/loading_halo.png",1)
img_dialog:setLayoutComponentEnabled(true)
img_dialog:setName("img_dialog")
img_dialog:setTag(82)
img_dialog:setCascadeColorEnabled(true)
img_dialog:setCascadeOpacityEnabled(true)
img_dialog:setPosition(-0.0055, -0.0248)
img_dialog:setRotationSkewX(224.0000)
img_dialog:setRotationSkewY(224.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_dialog)
layout:setSize({width = 90.0000, height = 90.0000})
layout:setLeftMargin(-45.0055)
layout:setRightMargin(-44.9945)
layout:setTopMargin(-44.9752)
layout:setBottomMargin(-45.0248)
nd_img:addChild(img_dialog)

--Create Animation
result['animation'] = ccs.ActionTimeline:create()
  
result['animation']:setDuration(90)
result['animation']:setTimeSpeed(1.0000)

--Create PositionTimeline
local PositionTimeline = ccs.Timeline:create()

localFrame = ccs.PositionFrame:create()
localFrame:setFrameIndex(0)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setX(-0.0178)
localFrame:setY(-0.0661)
PositionTimeline:addFrame(localFrame)

localFrame = ccs.PositionFrame:create()
localFrame:setFrameIndex(22)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setX(0.0000)
localFrame:setY(0.0000)
PositionTimeline:addFrame(localFrame)

localFrame = ccs.PositionFrame:create()
localFrame:setFrameIndex(45)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setX(0.0000)
localFrame:setY(0.0000)
PositionTimeline:addFrame(localFrame)

localFrame = ccs.PositionFrame:create()
localFrame:setFrameIndex(67)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setX(0.0000)
localFrame:setY(0.0000)
PositionTimeline:addFrame(localFrame)

localFrame = ccs.PositionFrame:create()
localFrame:setFrameIndex(90)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setX(0.0000)
localFrame:setY(0.0000)
PositionTimeline:addFrame(localFrame)

result['animation']:addTimeline(PositionTimeline)
PositionTimeline:setNode(img_)

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
localFrame:setFrameIndex(22)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setScaleX(0.0100)
localFrame:setScaleY(1.0000)
ScaleTimeline:addFrame(localFrame)

localFrame = ccs.ScaleFrame:create()
localFrame:setFrameIndex(45)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setScaleX(1.0000)
localFrame:setScaleY(1.0000)
ScaleTimeline:addFrame(localFrame)

localFrame = ccs.ScaleFrame:create()
localFrame:setFrameIndex(67)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setScaleX(0.0100)
localFrame:setScaleY(1.0000)
ScaleTimeline:addFrame(localFrame)

localFrame = ccs.ScaleFrame:create()
localFrame:setFrameIndex(90)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setScaleX(1.0000)
localFrame:setScaleY(1.0000)
ScaleTimeline:addFrame(localFrame)

result['animation']:addTimeline(ScaleTimeline)
ScaleTimeline:setNode(img_)

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
localFrame:setFrameIndex(22)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setSkewX(0.0000)
localFrame:setSkewY(0.0000)
RotationSkewTimeline:addFrame(localFrame)

localFrame = ccs.RotationSkewFrame:create()
localFrame:setFrameIndex(45)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setSkewX(0.0000)
localFrame:setSkewY(0.0000)
RotationSkewTimeline:addFrame(localFrame)

localFrame = ccs.RotationSkewFrame:create()
localFrame:setFrameIndex(67)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setSkewX(0.0000)
localFrame:setSkewY(0.0000)
RotationSkewTimeline:addFrame(localFrame)

localFrame = ccs.RotationSkewFrame:create()
localFrame:setFrameIndex(90)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setSkewX(0.0000)
localFrame:setSkewY(0.0000)
RotationSkewTimeline:addFrame(localFrame)

result['animation']:addTimeline(RotationSkewTimeline)
RotationSkewTimeline:setNode(img_)

--Create PositionTimeline
local PositionTimeline = ccs.Timeline:create()

localFrame = ccs.PositionFrame:create()
localFrame:setFrameIndex(0)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setX(-0.0145)
localFrame:setY(-0.0656)
PositionTimeline:addFrame(localFrame)

localFrame = ccs.PositionFrame:create()
localFrame:setFrameIndex(90)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setX(0.0000)
localFrame:setY(0.0000)
PositionTimeline:addFrame(localFrame)

result['animation']:addTimeline(PositionTimeline)
PositionTimeline:setNode(img_dialog)

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
localFrame:setFrameIndex(90)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setScaleX(1.0000)
localFrame:setScaleY(1.0000)
ScaleTimeline:addFrame(localFrame)

result['animation']:addTimeline(ScaleTimeline)
ScaleTimeline:setNode(img_dialog)

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
localFrame:setFrameIndex(90)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setSkewX(360.0000)
localFrame:setSkewY(360.0000)
RotationSkewTimeline:addFrame(localFrame)

result['animation']:addTimeline(RotationSkewTimeline)
RotationSkewTimeline:setNode(img_dialog)
--Create Animation List

result['root'] = Node
return result;
end

return Result

