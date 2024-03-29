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

--Create img_bk
local img_bk = ccui.Layout:create()
img_bk:ignoreContentAdaptWithSize(false)
img_bk:setClippingEnabled(false)
img_bk:setTouchEnabled(true);
img_bk:setLayoutComponentEnabled(true)
img_bk:setName("img_bk")
img_bk:setTag(199)
img_bk:setCascadeColorEnabled(true)
img_bk:setCascadeOpacityEnabled(true)
img_bk:setAnchorPoint(0.5000, 0.5000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_bk)
layout:setSize({width = 245.0000, height = 193.0000})
layout:setLeftMargin(-122.5000)
layout:setRightMargin(-122.5000)
layout:setTopMargin(-96.5000)
layout:setBottomMargin(-96.5000)
Node:addChild(img_bk)

--Create img_bj
local img_bj = ccui.ImageView:create()
img_bj:ignoreContentAdaptWithSize(false)
img_bj:loadTexture("weile/new_icon_default.png",0)
img_bj:setLayoutComponentEnabled(true)
img_bj:setName("img_bj")
img_bj:setTag(198)
img_bj:setCascadeColorEnabled(true)
img_bj:setCascadeOpacityEnabled(true)
img_bj:setPosition(122.5000, 96.5000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_bj)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(1.0000)
layout:setSize({width = 245.0000, height = 193.0000})
img_bk:addChild(img_bj)

--Create txt_person
local txt_person = ccui.Text:create()
txt_person:ignoreContentAdaptWithSize(true)
txt_person:setTextAreaSize({width = 0, height = 0})
txt_person:setFontName("")
txt_person:setFontSize(24)
txt_person:setString([[165]])
txt_person:setTextVerticalAlignment(1)
txt_person:setLayoutComponentEnabled(true)
txt_person:setName("txt_person")
txt_person:setTag(73)
txt_person:setCascadeColorEnabled(true)
txt_person:setCascadeOpacityEnabled(true)
txt_person:setAnchorPoint(0.0000, 0.5000)
txt_person:setPosition(128.3700, 35.0000)
txt_person:setRotationSkewX(1.0000)
txt_person:setRotationSkewY(1.0000)
txt_person:setOpacity(76)
txt_person:setTextColor({r = 0, g = 0, b = 0})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_person)
layout:setPositionPercentX(0.5240)
layout:setPositionPercentY(0.1813)
layout:setPercentWidth(0.1469)
layout:setPercentHeight(0.1244)
layout:setSize({width = 36.0000, height = 24.0000})
layout:setLeftMargin(128.3700)
layout:setRightMargin(80.6300)
layout:setTopMargin(146.0000)
layout:setBottomMargin(23.0000)
img_bk:addChild(txt_person)

--Create img_head
local img_head = ccui.ImageView:create()
img_head:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/gmaelist.plist")
img_head:loadTexture("hall/newgamelist/img_award.png",1)
img_head:setLayoutComponentEnabled(true)
img_head:setName("img_head")
img_head:setTag(34)
img_head:setCascadeColorEnabled(true)
img_head:setCascadeOpacityEnabled(true)
img_head:setPosition(107.2900, 35.0000)
img_head:setScaleY(0.9410)
img_head:setOpacity(76)
img_head:setColor({r = 0, g = 0, b = 0})
layout = ccui.LayoutComponent:bindLayoutComponent(img_head)
layout:setPositionPercentX(0.4379)
layout:setPositionPercentY(0.1813)
layout:setPercentWidth(0.0898)
layout:setPercentHeight(0.1140)
layout:setSize({width = 22.0000, height = 22.0000})
layout:setLeftMargin(96.2900)
layout:setRightMargin(126.7100)
layout:setTopMargin(147.0000)
layout:setBottomMargin(24.0000)
img_bk:addChild(img_head)

--Create txt_name
local txt_name = ccui.Text:create()
txt_name:ignoreContentAdaptWithSize(true)
txt_name:setTextAreaSize({width = 0, height = 0})
txt_name:setFontSize(46)
txt_name:setString([[加载中哦]])
txt_name:setLayoutComponentEnabled(true)
txt_name:setName("txt_name")
txt_name:setTag(1429)
txt_name:setCascadeColorEnabled(true)
txt_name:setCascadeOpacityEnabled(true)
txt_name:setPosition(122.5000, 126.8975)
layout = ccui.LayoutComponent:bindLayoutComponent(txt_name)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.6575)
layout:setPercentWidth(0.7510)
layout:setPercentHeight(0.2383)
layout:setSize({width = 184.0000, height = 46.0000})
layout:setLeftMargin(30.5000)
layout:setRightMargin(30.5000)
layout:setTopMargin(43.1025)
layout:setBottomMargin(103.8975)
img_bk:addChild(txt_name)

--Create nd_limit
local nd_limit=cc.Node:create()
nd_limit:setName("nd_limit")
nd_limit:setTag(40)
nd_limit:setCascadeColorEnabled(true)
nd_limit:setCascadeOpacityEnabled(true)
nd_limit:setVisible(false)
nd_limit:setPosition(240.0000, 30.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(nd_limit)
layout:setPositionPercentX(0.9796)
layout:setPositionPercentY(0.1554)
layout:setLeftMargin(240.0000)
layout:setRightMargin(5.0000)
layout:setTopMargin(163.0000)
layout:setBottomMargin(30.0000)
img_bk:addChild(nd_limit)

--Create txt_limit
local txt_limit = ccui.Text:create()
txt_limit:ignoreContentAdaptWithSize(true)
txt_limit:setTextAreaSize({width = 0, height = 0})
txt_limit:setFontSize(20)
txt_limit:setString([[1000豆入]])
txt_limit:setLayoutComponentEnabled(true)
txt_limit:setName("txt_limit")
txt_limit:setTag(38)
txt_limit:setCascadeColorEnabled(true)
txt_limit:setCascadeOpacityEnabled(true)
txt_limit:setAnchorPoint(1.0000, 0.5000)
txt_limit:setPosition(-30.0000, 0.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(txt_limit)
layout:setSize({width = 80.0000, height = 20.0000})
layout:setLeftMargin(-110.0000)
layout:setRightMargin(30.0000)
layout:setTopMargin(-10.0000)
layout:setBottomMargin(-10.0000)
nd_limit:addChild(txt_limit)

--Create img_line_1
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/gmaelist.plist")
local img_line_1 = cc.Sprite:createWithSpriteFrameName("hall/newgamelist/img_item_line.png")
img_line_1:setName("img_line_1")
img_line_1:setTag(42)
img_line_1:setCascadeColorEnabled(true)
img_line_1:setCascadeOpacityEnabled(true)
img_line_1:setAnchorPoint(0.0000, 0.5000)
img_line_1:setPosition(-27.5000, 0.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_line_1)
layout:setSize({width = 19.0000, height = 2.0000})
layout:setLeftMargin(-27.5000)
layout:setRightMargin(8.5000)
layout:setTopMargin(-1.0000)
layout:setBottomMargin(-1.0000)
img_line_1:setFlippedX(true)
img_line_1:setBlendFunc({src = 1, dst = 771})
nd_limit:addChild(img_line_1)

--Create img_line_2
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/gmaelist.plist")
local img_line_2 = cc.Sprite:createWithSpriteFrameName("hall/newgamelist/img_item_line.png")
img_line_2:setName("img_line_2")
img_line_2:setTag(41)
img_line_2:setCascadeColorEnabled(true)
img_line_2:setCascadeOpacityEnabled(true)
img_line_2:setAnchorPoint(1.0000, 0.5000)
img_line_2:setPosition(-114.5000, 0.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_line_2)
layout:setSize({width = 19.0000, height = 2.0000})
layout:setLeftMargin(-133.5000)
layout:setRightMargin(114.5000)
layout:setTopMargin(-1.0000)
layout:setBottomMargin(-1.0000)
img_line_2:setBlendFunc({src = 1, dst = 771})
nd_limit:addChild(img_line_2)

--Create panel
local panel = ccui.Layout:create()
panel:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/gmaelist.plist")
panel:setBackGroundImage("hall/newgamelist/img_circle_bg.png",1)
panel:setClippingEnabled(false)
panel:setBackGroundImageCapInsets({x = 11, y = 11, width = 12, height = 12})
panel:setBackGroundColorType(1)
panel:setBackGroundColor({r = 0, g = 0, b = 0})
panel:setBackGroundColorOpacity(0)
panel:setBackGroundImageScale9Enabled(true)
panel:setTouchEnabled(true);
panel:setLayoutComponentEnabled(true)
panel:setName("panel")
panel:setTag(1535)
panel:setCascadeColorEnabled(true)
panel:setCascadeOpacityEnabled(true)
panel:setVisible(false)
panel:setAnchorPoint(0.5000, 0.5000)
panel:setPosition(122.5000, 99.3950)
layout = ccui.LayoutComponent:bindLayoutComponent(panel)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5150)
layout:setPercentWidth(0.9714)
layout:setPercentHeight(0.9585)
layout:setSize({width = 238.0000, height = 185.0000})
layout:setLeftMargin(3.5000)
layout:setRightMargin(3.5000)
layout:setTopMargin(1.1050)
layout:setBottomMargin(6.8950)
img_bk:addChild(panel)

--Create img_gq
local img_gq = ccui.ImageView:create()
img_gq:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/gmaelist.plist")
img_gq:loadTexture("hall/newgamelist/loading_circle_2.png",1)
img_gq:setLayoutComponentEnabled(true)
img_gq:setName("img_gq")
img_gq:setTag(1536)
img_gq:setCascadeColorEnabled(true)
img_gq:setCascadeOpacityEnabled(true)
img_gq:setPosition(119.0000, 92.5000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_gq)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.3824)
layout:setPercentHeight(0.4919)
layout:setSize({width = 91.0000, height = 91.0000})
layout:setLeftMargin(73.5000)
layout:setRightMargin(73.5000)
layout:setTopMargin(47.0000)
layout:setBottomMargin(47.0000)
panel:addChild(img_gq)

--Create txt
local txt = ccui.Text:create()
txt:ignoreContentAdaptWithSize(true)
txt:setTextAreaSize({width = 0, height = 0})
txt:setFontName("")
txt:setFontSize(24)
txt:setString([[等待]])
txt:setLayoutComponentEnabled(true)
txt:setName("txt")
txt:setTag(1537)
txt:setCascadeColorEnabled(true)
txt:setCascadeOpacityEnabled(true)
txt:setPosition(119.0000, 92.5000)
layout = ccui.LayoutComponent:bindLayoutComponent(txt)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.2017)
layout:setPercentHeight(0.1297)
layout:setSize({width = 48.0000, height = 24.0000})
layout:setLeftMargin(95.0000)
layout:setRightMargin(95.0000)
layout:setTopMargin(80.5000)
layout:setBottomMargin(80.5000)
panel:addChild(txt)

--Create action_node
local action_node = cc.Sprite:create("hall/newgamelist/game_icons_action_1.png")
action_node:setName("action_node")
action_node:setTag(305)
action_node:setCascadeColorEnabled(true)
action_node:setCascadeOpacityEnabled(true)
action_node:setPosition(122.5000, 101.5000)
layout = ccui.LayoutComponent:bindLayoutComponent(action_node)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5259)
layout:setPercentWidth(1.2245)
layout:setPercentHeight(1.1917)
layout:setSize({width = 300.0000, height = 230.0000})
layout:setLeftMargin(-27.5000)
layout:setRightMargin(-27.5000)
layout:setTopMargin(-23.5000)
layout:setBottomMargin(-13.5000)
action_node:setBlendFunc({src = 770, dst = 1})
img_bk:addChild(action_node)

--Create Animation
result['animation'] = ccs.ActionTimeline:create()
  
result['animation']:setDuration(7)
result['animation']:setTimeSpeed(0.1333)

--Create FileDataTimeline
local FileDataTimeline = ccs.Timeline:create()

localFrame = ccs.TextureFrame:create()
localFrame:setFrameIndex(0)
localFrame:setTween(false)
localFrame:setTextureName("hall/newgamelist/game_icons_action_1.png")
FileDataTimeline:addFrame(localFrame)

localFrame = ccs.TextureFrame:create()
localFrame:setFrameIndex(1)
localFrame:setTween(false)
localFrame:setTextureName("hall/newgamelist/game_icons_action_2.png")
FileDataTimeline:addFrame(localFrame)

localFrame = ccs.TextureFrame:create()
localFrame:setFrameIndex(2)
localFrame:setTween(false)
localFrame:setTextureName("hall/newgamelist/game_icons_action_3.png")
FileDataTimeline:addFrame(localFrame)

localFrame = ccs.TextureFrame:create()
localFrame:setFrameIndex(3)
localFrame:setTween(false)
localFrame:setTextureName("hall/newgamelist/game_icons_action_4.png")
FileDataTimeline:addFrame(localFrame)

localFrame = ccs.TextureFrame:create()
localFrame:setFrameIndex(4)
localFrame:setTween(false)
localFrame:setTextureName("hall/newgamelist/game_icons_action_5.png")
FileDataTimeline:addFrame(localFrame)

localFrame = ccs.TextureFrame:create()
localFrame:setFrameIndex(5)
localFrame:setTween(false)
localFrame:setTextureName("hall/newgamelist/game_icons_action_6.png")
FileDataTimeline:addFrame(localFrame)

localFrame = ccs.TextureFrame:create()
localFrame:setFrameIndex(6)
localFrame:setTween(false)
localFrame:setTextureName("hall/newgamelist/game_icons_action_7.png")
FileDataTimeline:addFrame(localFrame)

localFrame = ccs.TextureFrame:create()
localFrame:setFrameIndex(7)
localFrame:setTween(false)
localFrame:setTextureName("hall/newgamelist/game_icons_action_8.png")
FileDataTimeline:addFrame(localFrame)

result['animation']:addTimeline(FileDataTimeline)
FileDataTimeline:setNode(action_node)
--Create Animation List
local icon_anim = {name="icon_anim", startIndex=0, endIndex=7}
result['animation']:addAnimationInfo(icon_anim)

result['root'] = Node
return result;
end

return Result

