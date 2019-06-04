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

--Create Panel_1
local Panel_1 = ccui.Layout:create()
Panel_1:ignoreContentAdaptWithSize(false)
Panel_1:setClippingEnabled(false)
Panel_1:setTouchEnabled(true);
Panel_1:setLayoutComponentEnabled(true)
Panel_1:setName("Panel_1")
Panel_1:setTag(681)
Panel_1:setCascadeColorEnabled(true)
Panel_1:setCascadeOpacityEnabled(true)
Panel_1:setAnchorPoint(0.5000, 0.5000)
Panel_1:setPosition(107.0000, 133.5000)
layout = ccui.LayoutComponent:bindLayoutComponent(Panel_1)
layout:setSize({width = 214.0000, height = 267.0000})
layout:setRightMargin(-214.0000)
layout:setTopMargin(-267.0000)
Node:addChild(Panel_1)

--Create img_bg
local img_bg = ccui.ImageView:create()
img_bg:ignoreContentAdaptWithSize(false)
img_bg:loadTexture("hall/welfare/sign/img_xsqd_item.png",0)
img_bg:setLayoutComponentEnabled(true)
img_bg:setName("img_bg")
img_bg:setTag(803)
img_bg:setCascadeColorEnabled(true)
img_bg:setCascadeOpacityEnabled(true)
img_bg:setPosition(107.0000, 133.5000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_bg)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(1.0000)
layout:setSize({width = 214.0000, height = 267.0000})
Panel_1:addChild(img_bg)

--Create txt_number
local txt_number = ccui.Text:create()
txt_number:ignoreContentAdaptWithSize(true)
txt_number:setTextAreaSize({width = 0, height = 0})
txt_number:setFontSize(36)
txt_number:setString([[5]])
txt_number:setLayoutComponentEnabled(true)
txt_number:setName("txt_number")
txt_number:setTag(804)
txt_number:setCascadeColorEnabled(true)
txt_number:setCascadeOpacityEnabled(true)
txt_number:setPosition(107.0000, 225.0000)
txt_number:setTextColor({r = 132, g = 67, b = 24})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_number)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.8427)
layout:setPercentWidth(0.0841)
layout:setPercentHeight(0.1348)
layout:setSize({width = 18.0000, height = 36.0000})
layout:setLeftMargin(98.0000)
layout:setRightMargin(98.0000)
layout:setTopMargin(24.0000)
layout:setBottomMargin(207.0000)
Panel_1:addChild(txt_number)

--Create txt_1
local txt_1 = ccui.Text:create()
txt_1:ignoreContentAdaptWithSize(true)
txt_1:setTextAreaSize({width = 0, height = 0})
txt_1:setFontSize(24)
txt_1:setString([[第    天]])
txt_1:setLayoutComponentEnabled(true)
txt_1:setName("txt_1")
txt_1:setTag(137)
txt_1:setCascadeColorEnabled(true)
txt_1:setCascadeOpacityEnabled(true)
txt_1:setPosition(107.0000, 224.0000)
txt_1:setTextColor({r = 132, g = 67, b = 24})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_1)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.8390)
layout:setPercentWidth(0.4486)
layout:setPercentHeight(0.0899)
layout:setSize({width = 96.0000, height = 24.0000})
layout:setLeftMargin(59.0000)
layout:setRightMargin(59.0000)
layout:setTopMargin(31.0000)
layout:setBottomMargin(212.0000)
Panel_1:addChild(txt_1)

--Create award_panel
local award_panel = ccui.Layout:create()
award_panel:ignoreContentAdaptWithSize(false)
award_panel:setClippingEnabled(false)
award_panel:setBackGroundColorOpacity(102)
award_panel:setLayoutComponentEnabled(true)
award_panel:setName("award_panel")
award_panel:setTag(197)
award_panel:setCascadeColorEnabled(true)
award_panel:setCascadeOpacityEnabled(true)
award_panel:setAnchorPoint(0.5000, 0.5000)
award_panel:setPosition(107.0000, 115.0770)
layout = ccui.LayoutComponent:bindLayoutComponent(award_panel)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.4310)
layout:setPercentWidth(0.8411)
layout:setPercentHeight(0.6742)
layout:setSize({width = 180.0000, height = 180.0000})
layout:setLeftMargin(17.0000)
layout:setRightMargin(17.0000)
layout:setTopMargin(61.9230)
layout:setBottomMargin(25.0770)
Panel_1:addChild(award_panel)

--Create img_award1
local img_award1 = ccui.ImageView:create()
img_award1:ignoreContentAdaptWithSize(false)
img_award1:loadTexture("Default/ImageFile.png",0)
img_award1:setLayoutComponentEnabled(true)
img_award1:setName("img_award1")
img_award1:setTag(138)
img_award1:setCascadeColorEnabled(true)
img_award1:setCascadeOpacityEnabled(true)
img_award1:setVisible(false)
img_award1:setPosition(54.0000, 126.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_award1)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.3000)
layout:setPositionPercentY(0.7000)
layout:setPercentWidth(0.4444)
layout:setPercentHeight(0.4444)
layout:setSize({width = 80.0000, height = 80.0000})
layout:setLeftMargin(14.0000)
layout:setRightMargin(86.0000)
layout:setTopMargin(14.0000)
layout:setBottomMargin(86.0000)
award_panel:addChild(img_award1)

--Create txt_count1
local txt_count1 = ccui.Text:create()
txt_count1:ignoreContentAdaptWithSize(true)
txt_count1:setTextAreaSize({width = 0, height = 0})
txt_count1:setFontSize(24)
txt_count1:setString([[微乐豆x2000]])
txt_count1:setLayoutComponentEnabled(true)
txt_count1:setName("txt_count1")
txt_count1:setTag(139)
txt_count1:setCascadeColorEnabled(true)
txt_count1:setCascadeOpacityEnabled(true)
txt_count1:setVisible(false)
txt_count1:setPosition(90.0000, 58.8744)
txt_count1:setTextColor({r = 158, g = 83, b = 34})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_count1)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.3271)
layout:setPercentWidth(0.7333)
layout:setPercentHeight(0.1333)
layout:setSize({width = 132.0000, height = 24.0000})
layout:setLeftMargin(24.0000)
layout:setRightMargin(24.0000)
layout:setTopMargin(109.1256)
layout:setBottomMargin(46.8744)
award_panel:addChild(txt_count1)

--Create img_award2
local img_award2 = ccui.ImageView:create()
img_award2:ignoreContentAdaptWithSize(false)
img_award2:loadTexture("Default/ImageFile.png",0)
img_award2:setLayoutComponentEnabled(true)
img_award2:setName("img_award2")
img_award2:setTag(198)
img_award2:setCascadeColorEnabled(true)
img_award2:setCascadeOpacityEnabled(true)
img_award2:setVisible(false)
img_award2:setPosition(126.0000, 126.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_award2)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.7000)
layout:setPositionPercentY(0.7000)
layout:setPercentWidth(0.4444)
layout:setPercentHeight(0.4444)
layout:setSize({width = 80.0000, height = 80.0000})
layout:setLeftMargin(86.0000)
layout:setRightMargin(14.0000)
layout:setTopMargin(14.0000)
layout:setBottomMargin(86.0000)
award_panel:addChild(img_award2)

--Create txt_count2
local txt_count2 = ccui.Text:create()
txt_count2:ignoreContentAdaptWithSize(true)
txt_count2:setTextAreaSize({width = 0, height = 0})
txt_count2:setFontSize(24)
txt_count2:setString([[记牌器x2]])
txt_count2:setLayoutComponentEnabled(true)
txt_count2:setName("txt_count2")
txt_count2:setTag(199)
txt_count2:setCascadeColorEnabled(true)
txt_count2:setCascadeOpacityEnabled(true)
txt_count2:setVisible(false)
txt_count2:setPosition(90.0000, 27.1679)
txt_count2:setTextColor({r = 158, g = 83, b = 34})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_count2)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.1509)
layout:setPercentWidth(0.5333)
layout:setPercentHeight(0.1333)
layout:setSize({width = 96.0000, height = 24.0000})
layout:setLeftMargin(42.0000)
layout:setRightMargin(42.0000)
layout:setTopMargin(140.8321)
layout:setBottomMargin(15.1679)
award_panel:addChild(txt_count2)

--Create xsqd_1
local xsqd_1 = cc.Sprite:create("hall/welfare/sign/xsqd.png")
xsqd_1:setName("xsqd_1")
xsqd_1:setTag(1031)
xsqd_1:setCascadeColorEnabled(true)
xsqd_1:setCascadeOpacityEnabled(true)
xsqd_1:setVisible(false)
xsqd_1:setPosition(107.5875, 133.0898)
layout = ccui.LayoutComponent:bindLayoutComponent(xsqd_1)
layout:setPositionPercentX(0.5027)
layout:setPositionPercentY(0.4985)
layout:setPercentWidth(1.0374)
layout:setPercentHeight(1.0300)
layout:setSize({width = 222.0000, height = 275.0000})
layout:setLeftMargin(-3.4125)
layout:setRightMargin(-4.5875)
layout:setTopMargin(-3.5898)
layout:setBottomMargin(-4.4102)
xsqd_1:setBlendFunc({src = 1, dst = 771})
Panel_1:addChild(xsqd_1)

--Create glow_1
local glow_1 = cc.Sprite:create("hall/welfare/sign/xsqdzg_05.png")
glow_1:setName("glow_1")
glow_1:setTag(1032)
glow_1:setCascadeColorEnabled(true)
glow_1:setCascadeOpacityEnabled(true)
glow_1:setVisible(false)
glow_1:setPosition(107.5900, 133.0900)
layout = ccui.LayoutComponent:bindLayoutComponent(glow_1)
layout:setPositionPercentX(0.5028)
layout:setPositionPercentY(0.4985)
layout:setPercentWidth(1.1682)
layout:setPercentHeight(1.1236)
layout:setSize({width = 250.0000, height = 300.0000})
layout:setLeftMargin(-17.4100)
layout:setRightMargin(-18.5900)
layout:setTopMargin(-16.0900)
layout:setBottomMargin(-16.9100)
glow_1:setBlendFunc({src = 770, dst = 1})
Panel_1:addChild(glow_1)

--Create img_bei
local img_bei = ccui.ImageView:create()
img_bei:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/sign.plist")
img_bei:loadTexture("hall/welfare/sign/img_bei.png",1)
img_bei:setLayoutComponentEnabled(true)
img_bei:setName("img_bei")
img_bei:setTag(805)
img_bei:setCascadeColorEnabled(true)
img_bei:setCascadeOpacityEnabled(true)
img_bei:setVisible(false)
img_bei:setPosition(52.1300, 210.3300)
layout = ccui.LayoutComponent:bindLayoutComponent(img_bei)
layout:setPositionPercentX(0.2436)
layout:setPositionPercentY(0.7878)
layout:setPercentWidth(0.4626)
layout:setPercentHeight(0.4007)
layout:setSize({width = 99.0000, height = 107.0000})
layout:setLeftMargin(2.6300)
layout:setRightMargin(112.3700)
layout:setTopMargin(3.1700)
layout:setBottomMargin(156.8300)
Panel_1:addChild(img_bei)

--Create lq_panel
local lq_panel = ccui.Layout:create()
lq_panel:ignoreContentAdaptWithSize(false)
lq_panel:setClippingEnabled(false)
lq_panel:setBackGroundColorOpacity(102)
lq_panel:setLayoutComponentEnabled(true)
lq_panel:setName("lq_panel")
lq_panel:setTag(807)
lq_panel:setCascadeColorEnabled(true)
lq_panel:setCascadeOpacityEnabled(true)
lq_panel:setVisible(false)
layout = ccui.LayoutComponent:bindLayoutComponent(lq_panel)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(1.0000)
layout:setSize({width = 214.0000, height = 267.0000})
Panel_1:addChild(lq_panel)

--Create img_kuan
local img_kuan = ccui.ImageView:create()
img_kuan:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/sign.plist")
img_kuan:loadTexture("hall/welfare/sign/img_5.png",1)
img_kuan:setScale9Enabled(true)
img_kuan:setCapInsets({x = 14, y = 15, width = 1, height = 1})
img_kuan:setLayoutComponentEnabled(true)
img_kuan:setName("img_kuan")
img_kuan:setTag(1297)
img_kuan:setCascadeColorEnabled(true)
img_kuan:setCascadeOpacityEnabled(true)
img_kuan:setAnchorPoint(0.0000, 0.0000)
img_kuan:setPosition(10.4169, 11.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_kuan)
layout:setPositionPercentX(0.0487)
layout:setPositionPercentY(0.0412)
layout:setPercentWidth(0.8972)
layout:setPercentHeight(0.9176)
layout:setSize({width = 192.0000, height = 245.0000})
layout:setLeftMargin(10.4169)
layout:setRightMargin(11.5831)
layout:setTopMargin(11.0000)
layout:setBottomMargin(11.0000)
lq_panel:addChild(img_kuan)

--Create img_kuan1
local img_kuan1 = ccui.ImageView:create()
img_kuan1:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/sign.plist")
img_kuan1:loadTexture("hall/welfare/sign/img_ylq.png",1)
img_kuan1:setLayoutComponentEnabled(true)
img_kuan1:setName("img_kuan1")
img_kuan1:setTag(808)
img_kuan1:setCascadeColorEnabled(true)
img_kuan1:setCascadeOpacityEnabled(true)
img_kuan1:setPosition(107.0000, 133.5000)
img_kuan1:setScaleX(1.5000)
img_kuan1:setScaleY(1.5000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_kuan1)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.2243)
layout:setPercentHeight(0.1573)
layout:setSize({width = 48.0000, height = 42.0000})
layout:setLeftMargin(83.0000)
layout:setRightMargin(83.0000)
layout:setTopMargin(112.5000)
layout:setBottomMargin(112.5000)
lq_panel:addChild(img_kuan1)

--Create Animation
result['animation'] = ccs.ActionTimeline:create()
  
result['animation']:setDuration(56)
result['animation']:setTimeSpeed(1.0000)

--Create PositionTimeline
local PositionTimeline = ccs.Timeline:create()

localFrame = ccs.PositionFrame:create()
localFrame:setFrameIndex(0)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setX(107.5900)
localFrame:setY(133.0900)
PositionTimeline:addFrame(localFrame)

localFrame = ccs.PositionFrame:create()
localFrame:setFrameIndex(7)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setX(107.5900)
localFrame:setY(133.0900)
PositionTimeline:addFrame(localFrame)

localFrame = ccs.PositionFrame:create()
localFrame:setFrameIndex(14)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setX(107.5900)
localFrame:setY(133.0900)
PositionTimeline:addFrame(localFrame)

localFrame = ccs.PositionFrame:create()
localFrame:setFrameIndex(21)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setX(107.5900)
localFrame:setY(133.0900)
PositionTimeline:addFrame(localFrame)

localFrame = ccs.PositionFrame:create()
localFrame:setFrameIndex(28)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setX(107.5900)
localFrame:setY(133.0900)
PositionTimeline:addFrame(localFrame)

localFrame = ccs.PositionFrame:create()
localFrame:setFrameIndex(35)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setX(107.5900)
localFrame:setY(133.0900)
PositionTimeline:addFrame(localFrame)

localFrame = ccs.PositionFrame:create()
localFrame:setFrameIndex(42)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setX(107.5900)
localFrame:setY(133.0900)
PositionTimeline:addFrame(localFrame)

localFrame = ccs.PositionFrame:create()
localFrame:setFrameIndex(49)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setX(107.5900)
localFrame:setY(133.0900)
PositionTimeline:addFrame(localFrame)

localFrame = ccs.PositionFrame:create()
localFrame:setFrameIndex(56)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setX(107.5900)
localFrame:setY(133.0900)
PositionTimeline:addFrame(localFrame)

result['animation']:addTimeline(PositionTimeline)
PositionTimeline:setNode(glow_1)

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
localFrame:setFrameIndex(7)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setScaleX(1.0000)
localFrame:setScaleY(1.0000)
ScaleTimeline:addFrame(localFrame)

localFrame = ccs.ScaleFrame:create()
localFrame:setFrameIndex(14)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setScaleX(1.0000)
localFrame:setScaleY(1.0000)
ScaleTimeline:addFrame(localFrame)

localFrame = ccs.ScaleFrame:create()
localFrame:setFrameIndex(21)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setScaleX(1.0000)
localFrame:setScaleY(1.0000)
ScaleTimeline:addFrame(localFrame)

localFrame = ccs.ScaleFrame:create()
localFrame:setFrameIndex(28)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setScaleX(1.0000)
localFrame:setScaleY(1.0000)
ScaleTimeline:addFrame(localFrame)

localFrame = ccs.ScaleFrame:create()
localFrame:setFrameIndex(35)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setScaleX(1.0000)
localFrame:setScaleY(1.0000)
ScaleTimeline:addFrame(localFrame)

localFrame = ccs.ScaleFrame:create()
localFrame:setFrameIndex(42)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setScaleX(1.0000)
localFrame:setScaleY(1.0000)
ScaleTimeline:addFrame(localFrame)

localFrame = ccs.ScaleFrame:create()
localFrame:setFrameIndex(49)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setScaleX(1.0000)
localFrame:setScaleY(1.0000)
ScaleTimeline:addFrame(localFrame)

localFrame = ccs.ScaleFrame:create()
localFrame:setFrameIndex(56)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setScaleX(1.0000)
localFrame:setScaleY(1.0000)
ScaleTimeline:addFrame(localFrame)

result['animation']:addTimeline(ScaleTimeline)
ScaleTimeline:setNode(glow_1)

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
localFrame:setFrameIndex(7)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setSkewX(0.0000)
localFrame:setSkewY(0.0000)
RotationSkewTimeline:addFrame(localFrame)

localFrame = ccs.RotationSkewFrame:create()
localFrame:setFrameIndex(14)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setSkewX(0.0000)
localFrame:setSkewY(0.0000)
RotationSkewTimeline:addFrame(localFrame)

localFrame = ccs.RotationSkewFrame:create()
localFrame:setFrameIndex(21)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setSkewX(0.0000)
localFrame:setSkewY(0.0000)
RotationSkewTimeline:addFrame(localFrame)

localFrame = ccs.RotationSkewFrame:create()
localFrame:setFrameIndex(28)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setSkewX(0.0000)
localFrame:setSkewY(0.0000)
RotationSkewTimeline:addFrame(localFrame)

localFrame = ccs.RotationSkewFrame:create()
localFrame:setFrameIndex(35)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setSkewX(0.0000)
localFrame:setSkewY(0.0000)
RotationSkewTimeline:addFrame(localFrame)

localFrame = ccs.RotationSkewFrame:create()
localFrame:setFrameIndex(42)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setSkewX(0.0000)
localFrame:setSkewY(0.0000)
RotationSkewTimeline:addFrame(localFrame)

localFrame = ccs.RotationSkewFrame:create()
localFrame:setFrameIndex(49)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setSkewX(0.0000)
localFrame:setSkewY(0.0000)
RotationSkewTimeline:addFrame(localFrame)

localFrame = ccs.RotationSkewFrame:create()
localFrame:setFrameIndex(56)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setSkewX(0.0000)
localFrame:setSkewY(0.0000)
RotationSkewTimeline:addFrame(localFrame)

result['animation']:addTimeline(RotationSkewTimeline)
RotationSkewTimeline:setNode(glow_1)

--Create FileDataTimeline
local FileDataTimeline = ccs.Timeline:create()

localFrame = ccs.TextureFrame:create()
localFrame:setFrameIndex(0)
localFrame:setTween(false)
localFrame:setTextureName("hall/welfare/sign/xsqdzg_00.png")
FileDataTimeline:addFrame(localFrame)

localFrame = ccs.TextureFrame:create()
localFrame:setFrameIndex(7)
localFrame:setTween(false)
localFrame:setTextureName("hall/welfare/sign/xsqdzg_01.png")
FileDataTimeline:addFrame(localFrame)

localFrame = ccs.TextureFrame:create()
localFrame:setFrameIndex(14)
localFrame:setTween(false)
localFrame:setTextureName("hall/welfare/sign/xsqdzg_02.png")
FileDataTimeline:addFrame(localFrame)

localFrame = ccs.TextureFrame:create()
localFrame:setFrameIndex(21)
localFrame:setTween(false)
localFrame:setTextureName("hall/welfare/sign/xsqdzg_03.png")
FileDataTimeline:addFrame(localFrame)

localFrame = ccs.TextureFrame:create()
localFrame:setFrameIndex(28)
localFrame:setTween(false)
localFrame:setTextureName("hall/welfare/sign/xsqdzg_04.png")
FileDataTimeline:addFrame(localFrame)

localFrame = ccs.TextureFrame:create()
localFrame:setFrameIndex(35)
localFrame:setTween(false)
localFrame:setTextureName("hall/welfare/sign/xsqdzg_05.png")
FileDataTimeline:addFrame(localFrame)

localFrame = ccs.TextureFrame:create()
localFrame:setFrameIndex(42)
localFrame:setTween(false)
localFrame:setTextureName("hall/welfare/sign/xsqdzg_06.png")
FileDataTimeline:addFrame(localFrame)

localFrame = ccs.TextureFrame:create()
localFrame:setFrameIndex(49)
localFrame:setTween(false)
localFrame:setTextureName("hall/welfare/sign/xsqdzg_07.png")
FileDataTimeline:addFrame(localFrame)

localFrame = ccs.TextureFrame:create()
localFrame:setFrameIndex(56)
localFrame:setTween(false)
localFrame:setTextureName("hall/welfare/sign/xsqdzg_00.png")
FileDataTimeline:addFrame(localFrame)

result['animation']:addTimeline(FileDataTimeline)
FileDataTimeline:setNode(glow_1)

--Create BlendFuncTimeline
local BlendFuncTimeline = ccs.Timeline:create()

result['animation']:addTimeline(BlendFuncTimeline)
BlendFuncTimeline:setNode(glow_1)
--Create Animation List
local animasign = {name="animasign", startIndex=0, endIndex=56}
result['animation']:addAnimationInfo(animasign)

result['root'] = Node
return result;
end

return Result

