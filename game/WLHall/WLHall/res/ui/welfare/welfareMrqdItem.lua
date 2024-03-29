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
Panel_1:setTag(680)
Panel_1:setCascadeColorEnabled(true)
Panel_1:setCascadeOpacityEnabled(true)
Panel_1:setAnchorPoint(0.5000, 0.5000)
layout = ccui.LayoutComponent:bindLayoutComponent(Panel_1)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setSize({width = 168.0000, height = 202.0000})
layout:setLeftMargin(-84.0000)
layout:setRightMargin(-84.0000)
layout:setTopMargin(-101.0000)
layout:setBottomMargin(-101.0000)
Node:addChild(Panel_1)

--Create mrqd_1
local mrqd_1 = cc.Sprite:create("hall/welfare/sign/mrqddi.png")
mrqd_1:setName("mrqd_1")
mrqd_1:setTag(1063)
mrqd_1:setCascadeColorEnabled(true)
mrqd_1:setCascadeOpacityEnabled(true)
mrqd_1:setVisible(false)
mrqd_1:setPosition(84.0000, 101.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(mrqd_1)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(1.0119)
layout:setPercentHeight(1.0099)
layout:setSize({width = 170.0000, height = 204.0000})
layout:setLeftMargin(-1.0000)
layout:setRightMargin(-1.0000)
layout:setTopMargin(-1.0000)
layout:setBottomMargin(-1.0000)
mrqd_1:setBlendFunc({src = 1, dst = 771})
Panel_1:addChild(mrqd_1)

--Create img_bg
local img_bg = ccui.ImageView:create()
img_bg:ignoreContentAdaptWithSize(false)
img_bg:loadTexture("hall/welfare/sign/img_mrqd_item.png",0)
img_bg:setLayoutComponentEnabled(true)
img_bg:setName("img_bg")
img_bg:setTag(835)
img_bg:setCascadeColorEnabled(true)
img_bg:setCascadeOpacityEnabled(true)
img_bg:setPosition(84.0000, 101.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_bg)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(1.0000)
layout:setSize({width = 168.0000, height = 202.0000})
Panel_1:addChild(img_bg)

--Create txt_1
local txt_1 = ccui.Text:create()
txt_1:ignoreContentAdaptWithSize(true)
txt_1:setTextAreaSize({width = 0, height = 0})
txt_1:setFontSize(20)
txt_1:setString([[第    天]])
txt_1:setLayoutComponentEnabled(true)
txt_1:setName("txt_1")
txt_1:setTag(836)
txt_1:setCascadeColorEnabled(true)
txt_1:setCascadeOpacityEnabled(true)
txt_1:setPosition(84.0000, 169.2400)
txt_1:setTextColor({r = 132, g = 67, b = 24})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_1)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.8378)
layout:setPercentWidth(0.4762)
layout:setPercentHeight(0.0990)
layout:setSize({width = 80.0000, height = 20.0000})
layout:setLeftMargin(44.0000)
layout:setRightMargin(44.0000)
layout:setTopMargin(22.7600)
layout:setBottomMargin(159.2400)
Panel_1:addChild(txt_1)

--Create txt_number
local txt_number = ccui.Text:create()
txt_number:ignoreContentAdaptWithSize(true)
txt_number:setTextAreaSize({width = 0, height = 0})
txt_number:setFontSize(28)
txt_number:setString([[1]])
txt_number:setLayoutComponentEnabled(true)
txt_number:setName("txt_number")
txt_number:setTag(221)
txt_number:setCascadeColorEnabled(true)
txt_number:setCascadeOpacityEnabled(true)
txt_number:setPosition(84.0000, 170.0000)
txt_number:setTextColor({r = 132, g = 67, b = 24})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_number)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.8416)
layout:setPercentWidth(0.0833)
layout:setPercentHeight(0.1386)
layout:setSize({width = 14.0000, height = 28.0000})
layout:setLeftMargin(77.0000)
layout:setRightMargin(77.0000)
layout:setTopMargin(18.0000)
layout:setBottomMargin(156.0000)
Panel_1:addChild(txt_number)

--Create img_tp
local img_tp = ccui.ImageView:create()
img_tp:ignoreContentAdaptWithSize(false)
img_tp:loadTexture("Default/ImageFile.png",0)
img_tp:setLayoutComponentEnabled(true)
img_tp:setName("img_tp")
img_tp:setTag(222)
img_tp:setCascadeColorEnabled(true)
img_tp:setCascadeOpacityEnabled(true)
img_tp:setPosition(84.0000, 100.2300)
layout = ccui.LayoutComponent:bindLayoutComponent(img_tp)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.4962)
layout:setPercentWidth(0.4167)
layout:setPercentHeight(0.3465)
layout:setSize({width = 70.0000, height = 70.0000})
layout:setLeftMargin(49.0000)
layout:setRightMargin(49.0000)
layout:setTopMargin(66.7700)
layout:setBottomMargin(65.2300)
Panel_1:addChild(img_tp)

--Create txt_count
local txt_count = ccui.Text:create()
txt_count:ignoreContentAdaptWithSize(true)
txt_count:setTextAreaSize({width = 0, height = 0})
txt_count:setFontSize(26)
txt_count:setString([[200]])
txt_count:setLayoutComponentEnabled(true)
txt_count:setName("txt_count")
txt_count:setTag(223)
txt_count:setCascadeColorEnabled(true)
txt_count:setCascadeOpacityEnabled(true)
txt_count:setPosition(84.0000, 48.0000)
txt_count:setTextColor({r = 158, g = 83, b = 34})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_count)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.2376)
layout:setPercentWidth(0.2321)
layout:setPercentHeight(0.1287)
layout:setSize({width = 39.0000, height = 26.0000})
layout:setLeftMargin(64.5000)
layout:setRightMargin(64.5000)
layout:setTopMargin(141.0000)
layout:setBottomMargin(35.0000)
Panel_1:addChild(txt_count)

--Create lq_panel
local lq_panel = ccui.Layout:create()
lq_panel:ignoreContentAdaptWithSize(false)
lq_panel:setClippingEnabled(false)
lq_panel:setBackGroundColorOpacity(102)
lq_panel:setTouchEnabled(true);
lq_panel:setLayoutComponentEnabled(true)
lq_panel:setName("lq_panel")
lq_panel:setTag(50)
lq_panel:setCascadeColorEnabled(true)
lq_panel:setCascadeOpacityEnabled(true)
lq_panel:setVisible(false)
lq_panel:setAnchorPoint(0.5000, 0.5000)
lq_panel:setPosition(84.0000, 101.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(lq_panel)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(1.0099)
layout:setSize({width = 168.0000, height = 204.0000})
layout:setTopMargin(-1.0000)
layout:setBottomMargin(-1.0000)
Panel_1:addChild(lq_panel)

--Create Image_4
local Image_4 = ccui.ImageView:create()
Image_4:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/sign.plist")
Image_4:loadTexture("hall/welfare/sign/img_5.png",1)
Image_4:setScale9Enabled(true)
Image_4:setCapInsets({x = 15, y = 14, width = 1, height = 1})
Image_4:setLayoutComponentEnabled(true)
Image_4:setName("Image_4")
Image_4:setTag(1298)
Image_4:setCascadeColorEnabled(true)
Image_4:setCascadeOpacityEnabled(true)
Image_4:setPosition(84.0000, 102.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(Image_4)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.8750)
layout:setPercentHeight(0.8824)
layout:setSize({width = 147.0000, height = 180.0000})
layout:setLeftMargin(10.5000)
layout:setRightMargin(10.5000)
layout:setTopMargin(12.0000)
layout:setBottomMargin(12.0000)
lq_panel:addChild(Image_4)

--Create Image_5
local Image_5 = ccui.ImageView:create()
Image_5:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/sign.plist")
Image_5:loadTexture("hall/welfare/sign/img_ylq.png",1)
Image_5:setLayoutComponentEnabled(true)
Image_5:setName("Image_5")
Image_5:setTag(52)
Image_5:setCascadeColorEnabled(true)
Image_5:setCascadeOpacityEnabled(true)
Image_5:setPosition(84.0000, 102.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(Image_5)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.2857)
layout:setPercentHeight(0.2059)
layout:setSize({width = 48.0000, height = 42.0000})
layout:setLeftMargin(60.0000)
layout:setRightMargin(60.0000)
layout:setTopMargin(81.0000)
layout:setBottomMargin(81.0000)
lq_panel:addChild(Image_5)

--Create glow_1
local glow_1 = cc.Sprite:create("hall/welfare/sign/mrqdlg_00.png")
glow_1:setName("glow_1")
glow_1:setTag(1067)
glow_1:setCascadeColorEnabled(true)
glow_1:setCascadeOpacityEnabled(true)
glow_1:setVisible(false)
glow_1:setPosition(84.0000, 101.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(glow_1)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(1.3095)
layout:setPercentHeight(1.0891)
layout:setSize({width = 220.0000, height = 220.0000})
layout:setLeftMargin(-26.0000)
layout:setRightMargin(-26.0000)
layout:setTopMargin(-9.0000)
layout:setBottomMargin(-9.0000)
glow_1:setBlendFunc({src = 770, dst = 1})
Panel_1:addChild(glow_1)

--Create vip_panel
local vip_panel = ccui.Layout:create()
vip_panel:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/sign.plist")
vip_panel:setBackGroundImage("hall/welfare/sign/vip_bg.png",1)
vip_panel:setClippingEnabled(false)
vip_panel:setBackGroundImageCapInsets({x = 15, y = 11, width = 1, height = 2})
vip_panel:setBackGroundColorOpacity(102)
vip_panel:setBackGroundImageScale9Enabled(true)
vip_panel:setTouchEnabled(true);
vip_panel:setLayoutComponentEnabled(true)
vip_panel:setName("vip_panel")
vip_panel:setTag(97)
vip_panel:setCascadeColorEnabled(true)
vip_panel:setCascadeOpacityEnabled(true)
vip_panel:setAnchorPoint(0.4937, 0.5153)
vip_panel:setPosition(84.0000, 15.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(vip_panel)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.0743)
layout:setPercentWidth(0.2976)
layout:setPercentHeight(0.1238)
layout:setSize({width = 50.0000, height = 25.0000})
layout:setLeftMargin(59.3150)
layout:setRightMargin(58.6850)
layout:setTopMargin(174.8825)
layout:setBottomMargin(2.1175)
Panel_1:addChild(vip_panel)

--Create vip_txt
local vip_txt = ccui.TextBMFont:create()
vip_txt:setFntFile("fonts/privilege_num.fnt")
vip_txt:setString([[t]])
vip_txt:setLayoutComponentEnabled(true)
vip_txt:setName("vip_txt")
vip_txt:setTag(98)
vip_txt:setCascadeColorEnabled(true)
vip_txt:setCascadeOpacityEnabled(true)
vip_txt:setPosition(84.0000, 15.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(vip_txt)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.0743)
layout:setPercentWidth(0.2321)
layout:setPercentHeight(0.1188)
layout:setSize({width = 39.0000, height = 24.0000})
layout:setLeftMargin(64.5000)
layout:setRightMargin(64.5000)
layout:setTopMargin(175.0000)
layout:setBottomMargin(3.0000)
Panel_1:addChild(vip_txt)

--Create vip_panel_zhezhao
local vip_panel_zhezhao = ccui.Layout:create()
vip_panel_zhezhao:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/sign.plist")
vip_panel_zhezhao:setBackGroundImage("hall/welfare/sign/vip_zhezhao.png",1)
vip_panel_zhezhao:setClippingEnabled(false)
vip_panel_zhezhao:setBackGroundImageCapInsets({x = 8, y = 9, width = 10, height = 10})
vip_panel_zhezhao:setBackGroundColorOpacity(102)
vip_panel_zhezhao:setBackGroundImageScale9Enabled(true)
vip_panel_zhezhao:setTouchEnabled(true);
vip_panel_zhezhao:setLayoutComponentEnabled(true)
vip_panel_zhezhao:setName("vip_panel_zhezhao")
vip_panel_zhezhao:setTag(99)
vip_panel_zhezhao:setCascadeColorEnabled(true)
vip_panel_zhezhao:setCascadeOpacityEnabled(true)
vip_panel_zhezhao:setAnchorPoint(0.5000, 0.5000)
vip_panel_zhezhao:setPosition(84.0000, 16.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(vip_panel_zhezhao)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.0792)
layout:setPercentWidth(0.2976)
layout:setPercentHeight(0.1040)
layout:setSize({width = 50.0000, height = 21.0000})
layout:setLeftMargin(59.0000)
layout:setRightMargin(59.0000)
layout:setTopMargin(175.5000)
layout:setBottomMargin(5.5000)
Panel_1:addChild(vip_panel_zhezhao)

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
localFrame:setX(84.0000)
localFrame:setY(101.0000)
PositionTimeline:addFrame(localFrame)

localFrame = ccs.PositionFrame:create()
localFrame:setFrameIndex(7)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setX(84.0000)
localFrame:setY(101.0000)
PositionTimeline:addFrame(localFrame)

localFrame = ccs.PositionFrame:create()
localFrame:setFrameIndex(14)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setX(84.0000)
localFrame:setY(101.0000)
PositionTimeline:addFrame(localFrame)

localFrame = ccs.PositionFrame:create()
localFrame:setFrameIndex(21)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setX(84.0000)
localFrame:setY(101.0000)
PositionTimeline:addFrame(localFrame)

localFrame = ccs.PositionFrame:create()
localFrame:setFrameIndex(28)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setX(84.0000)
localFrame:setY(101.0000)
PositionTimeline:addFrame(localFrame)

localFrame = ccs.PositionFrame:create()
localFrame:setFrameIndex(35)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setX(84.0000)
localFrame:setY(101.0000)
PositionTimeline:addFrame(localFrame)

localFrame = ccs.PositionFrame:create()
localFrame:setFrameIndex(42)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setX(84.0000)
localFrame:setY(101.0000)
PositionTimeline:addFrame(localFrame)

localFrame = ccs.PositionFrame:create()
localFrame:setFrameIndex(49)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setX(84.0000)
localFrame:setY(101.0000)
PositionTimeline:addFrame(localFrame)

localFrame = ccs.PositionFrame:create()
localFrame:setFrameIndex(56)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setX(84.0000)
localFrame:setY(101.0000)
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

--Create BlendFuncTimeline
local BlendFuncTimeline = ccs.Timeline:create()

result['animation']:addTimeline(BlendFuncTimeline)
BlendFuncTimeline:setNode(glow_1)

--Create FileDataTimeline
local FileDataTimeline = ccs.Timeline:create()

localFrame = ccs.TextureFrame:create()
localFrame:setFrameIndex(0)
localFrame:setTween(false)
localFrame:setTextureName("hall/welfare/sign/mrqdlg_00.png")
FileDataTimeline:addFrame(localFrame)

localFrame = ccs.TextureFrame:create()
localFrame:setFrameIndex(7)
localFrame:setTween(false)
localFrame:setTextureName("hall/welfare/sign/mrqdlg_01.png")
FileDataTimeline:addFrame(localFrame)

localFrame = ccs.TextureFrame:create()
localFrame:setFrameIndex(14)
localFrame:setTween(false)
localFrame:setTextureName("hall/welfare/sign/mrqdlg_02.png")
FileDataTimeline:addFrame(localFrame)

localFrame = ccs.TextureFrame:create()
localFrame:setFrameIndex(21)
localFrame:setTween(false)
localFrame:setTextureName("hall/welfare/sign/mrqdlg_03.png")
FileDataTimeline:addFrame(localFrame)

localFrame = ccs.TextureFrame:create()
localFrame:setFrameIndex(28)
localFrame:setTween(false)
localFrame:setTextureName("hall/welfare/sign/mrqdlg_04.png")
FileDataTimeline:addFrame(localFrame)

localFrame = ccs.TextureFrame:create()
localFrame:setFrameIndex(35)
localFrame:setTween(false)
localFrame:setTextureName("hall/welfare/sign/mrqdlg_05.png")
FileDataTimeline:addFrame(localFrame)

localFrame = ccs.TextureFrame:create()
localFrame:setFrameIndex(42)
localFrame:setTween(false)
localFrame:setTextureName("hall/welfare/sign/mrqdlg_06.png")
FileDataTimeline:addFrame(localFrame)

localFrame = ccs.TextureFrame:create()
localFrame:setFrameIndex(49)
localFrame:setTween(false)
localFrame:setTextureName("hall/welfare/sign/mrqdlg_07.png")
FileDataTimeline:addFrame(localFrame)

localFrame = ccs.TextureFrame:create()
localFrame:setFrameIndex(56)
localFrame:setTween(false)
localFrame:setTextureName("hall/welfare/sign/mrqdlg_00.png")
FileDataTimeline:addFrame(localFrame)

result['animation']:addTimeline(FileDataTimeline)
FileDataTimeline:setNode(glow_1)

--Create VisibleForFrameTimeline
local VisibleForFrameTimeline = ccs.Timeline:create()

localFrame = ccs.VisibleFrame:create()
localFrame:setFrameIndex(0)
localFrame:setTween(false)
localFrame:setVisible(true)
VisibleForFrameTimeline:addFrame(localFrame)

localFrame = ccs.VisibleFrame:create()
localFrame:setFrameIndex(21)
localFrame:setTween(false)
localFrame:setVisible(true)
VisibleForFrameTimeline:addFrame(localFrame)

result['animation']:addTimeline(VisibleForFrameTimeline)
VisibleForFrameTimeline:setNode(glow_1)
--Create Animation List
local animasign = {name="animasign", startIndex=0, endIndex=56}
result['animation']:addAnimationInfo(animasign)

result['root'] = Node
return result;
end

return Result

