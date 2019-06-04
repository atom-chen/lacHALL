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

--Create panel_bg
local panel_bg = ccui.Layout:create()
panel_bg:ignoreContentAdaptWithSize(false)
panel_bg:setClippingEnabled(false)
panel_bg:setBackGroundColorOpacity(102)
panel_bg:setLayoutComponentEnabled(true)
panel_bg:setName("panel_bg")
panel_bg:setTag(208)
panel_bg:setCascadeColorEnabled(true)
panel_bg:setCascadeOpacityEnabled(true)
panel_bg:setAnchorPoint(0.5000, 0.5000)
layout = ccui.LayoutComponent:bindLayoutComponent(panel_bg)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setSize({width = 628.0000, height = 565.0000})
layout:setLeftMargin(-314.0000)
layout:setRightMargin(-314.0000)
layout:setTopMargin(-282.5000)
layout:setBottomMargin(-282.5000)
Node:addChild(panel_bg)

--Create img_bg
local img_bg = ccui.ImageView:create()
img_bg:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/match_tv_view.plist")
img_bg:loadTexture("hall/room/match/match_apply/bg.png",1)
img_bg:setScale9Enabled(true)
img_bg:setCapInsets({x = 11, y = 63, width = 11, height = 15})
img_bg:setLayoutComponentEnabled(true)
img_bg:setName("img_bg")
img_bg:setTag(209)
img_bg:setCascadeColorEnabled(true)
img_bg:setCascadeOpacityEnabled(true)
img_bg:setPosition(314.0000, 282.5000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_bg)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(1.0000)
layout:setSize({width = 628.0000, height = 565.0000})
panel_bg:addChild(img_bg)

--Create txt_title
local txt_title = ccui.Text:create()
txt_title:ignoreContentAdaptWithSize(true)
txt_title:setTextAreaSize({width = 0, height = 0})
txt_title:setFontSize(28)
txt_title:setString([[完善报名资料]])
txt_title:setLayoutComponentEnabled(true)
txt_title:setName("txt_title")
txt_title:setTag(210)
txt_title:setCascadeColorEnabled(true)
txt_title:setCascadeOpacityEnabled(true)
txt_title:setPosition(314.0964, 533.1630)
layout = ccui.LayoutComponent:bindLayoutComponent(txt_title)
layout:setPositionPercentX(0.5002)
layout:setPositionPercentY(0.9437)
layout:setPercentWidth(0.2675)
layout:setPercentHeight(0.0496)
layout:setSize({width = 168.0000, height = 28.0000})
layout:setLeftMargin(230.0964)
layout:setRightMargin(229.9036)
layout:setTopMargin(17.8370)
layout:setBottomMargin(519.1630)
panel_bg:addChild(txt_title)

--Create btn_close
local btn_close = ccui.Layout:create()
btn_close:ignoreContentAdaptWithSize(false)
btn_close:setClippingEnabled(false)
btn_close:setBackGroundColorOpacity(102)
btn_close:setTouchEnabled(true);
btn_close:setLayoutComponentEnabled(true)
btn_close:setName("btn_close")
btn_close:setTag(211)
btn_close:setCascadeColorEnabled(true)
btn_close:setCascadeOpacityEnabled(true)
btn_close:setAnchorPoint(0.5000, 0.5000)
btn_close:setPosition(598.2626, 532.2736)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_close)
layout:setPositionPercentX(0.9526)
layout:setPositionPercentY(0.9421)
layout:setPercentWidth(0.0796)
layout:setPercentHeight(0.0885)
layout:setSize({width = 50.0000, height = 50.0000})
layout:setLeftMargin(573.2626)
layout:setRightMargin(4.7374)
layout:setTopMargin(7.7264)
layout:setBottomMargin(507.2736)
panel_bg:addChild(btn_close)

--Create img_close
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
local img_close = cc.Sprite:createWithSpriteFrameName("hall/common/new_btn_close.png")
img_close:setName("img_close")
img_close:setTag(212)
img_close:setCascadeColorEnabled(true)
img_close:setCascadeOpacityEnabled(true)
img_close:setPosition(25.0000, 25.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_close)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.9200)
layout:setPercentHeight(0.9200)
layout:setSize({width = 24.0000, height = 25.0000})
layout:setLeftMargin(2.0000)
layout:setRightMargin(2.0000)
layout:setTopMargin(2.0000)
layout:setBottomMargin(2.0000)
img_close:setBlendFunc({src = 1, dst = 771})
btn_close:addChild(img_close)

--Create input_name
local input_name = ccui.Layout:create()
input_name:ignoreContentAdaptWithSize(false)
input_name:setClippingEnabled(false)
input_name:setTouchEnabled(true);
input_name:setLayoutComponentEnabled(true)
input_name:setName("input_name")
input_name:setTag(254)
input_name:setCascadeColorEnabled(true)
input_name:setCascadeOpacityEnabled(true)
input_name:setPosition(28.0000, 430.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(input_name)
layout:setPositionPercentX(0.0446)
layout:setPositionPercentY(0.7611)
layout:setPercentWidth(0.9554)
layout:setPercentHeight(0.0885)
layout:setSize({width = 600.0000, height = 50.0000})
layout:setLeftMargin(28.0000)
layout:setTopMargin(85.0000)
layout:setBottomMargin(430.0000)
panel_bg:addChild(input_name)

--Create txt_name
local txt_name = ccui.Text:create()
txt_name:ignoreContentAdaptWithSize(true)
txt_name:setTextAreaSize({width = 0, height = 0})
txt_name:setFontSize(32)
txt_name:setString([[姓  名:]])
txt_name:setLayoutComponentEnabled(true)
txt_name:setName("txt_name")
txt_name:setTag(262)
txt_name:setCascadeColorEnabled(true)
txt_name:setCascadeOpacityEnabled(true)
txt_name:setAnchorPoint(0.0000, 0.5000)
txt_name:setPosition(33.2000, 22.6050)
txt_name:setTextColor({r = 34, g = 34, b = 34})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_name)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.0553)
layout:setPositionPercentY(0.4521)
layout:setPercentWidth(0.1867)
layout:setPercentHeight(0.6600)
layout:setSize({width = 112.0000, height = 33.0000})
layout:setLeftMargin(33.2000)
layout:setRightMargin(454.8000)
layout:setTopMargin(10.8950)
layout:setBottomMargin(6.1050)
input_name:addChild(txt_name)

--Create img_line
local img_line = ccui.ImageView:create()
img_line:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/match_tv_view.plist")
img_line:loadTexture("hall/room/match/match_apply/line.png",1)
img_line:setScale9Enabled(true)
img_line:setCapInsets({x = 4, y = 0, width = 1, height = 1})
img_line:setLayoutComponentEnabled(true)
img_line:setName("img_line")
img_line:setTag(263)
img_line:setCascadeColorEnabled(true)
img_line:setCascadeOpacityEnabled(true)
img_line:setAnchorPoint(1.0000, 0.5000)
img_line:setPosition(529.0000, 7.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_line)
layout:setPositionPercentX(0.8817)
layout:setPositionPercentY(0.1400)
layout:setPercentWidth(0.6167)
layout:setPercentHeight(0.0200)
layout:setSize({width = 370.0000, height = 1.0000})
layout:setLeftMargin(159.0000)
layout:setRightMargin(71.0000)
layout:setTopMargin(42.5000)
layout:setBottomMargin(6.5000)
input_name:addChild(img_line)

--Create field_name
local field_name = ccui.TextField:create()
field_name:ignoreContentAdaptWithSize(false)
tolua.cast(field_name:getVirtualRenderer(), "cc.Label"):setLineBreakWithoutSpace(true)
field_name:setFontSize(32)
field_name:setPlaceHolder("")
field_name:setString([[]])
field_name:setMaxLength(10)
field_name:setLayoutComponentEnabled(true)
field_name:setName("field_name")
field_name:setTag(264)
field_name:setCascadeColorEnabled(true)
field_name:setCascadeOpacityEnabled(true)
field_name:setAnchorPoint(0.0000, 0.5000)
field_name:setPosition(169.9200, 26.0722)
field_name:setColor({r = 34, g = 34, b = 34})
layout = ccui.LayoutComponent:bindLayoutComponent(field_name)
layout:setPositionPercentX(0.2832)
layout:setPositionPercentY(0.5214)
layout:setPercentWidth(0.5833)
layout:setPercentHeight(0.6400)
layout:setSize({width = 350.0000, height = 32.0000})
layout:setLeftMargin(169.9200)
layout:setRightMargin(80.0800)
layout:setTopMargin(7.9278)
layout:setBottomMargin(10.0722)
input_name:addChild(field_name)

--Create img_right
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/match_tv_view.plist")
local img_right = cc.Sprite:createWithSpriteFrameName("hall/room/match/match_apply/right.png")
img_right:setName("img_right")
img_right:setTag(265)
img_right:setCascadeColorEnabled(true)
img_right:setCascadeOpacityEnabled(true)
img_right:setVisible(false)
img_right:setPosition(551.0000, 24.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_right)
layout:setPositionPercentX(0.9183)
layout:setPositionPercentY(0.4800)
layout:setPercentWidth(0.0433)
layout:setPercentHeight(0.5200)
layout:setSize({width = 26.0000, height = 26.0000})
layout:setLeftMargin(538.0000)
layout:setRightMargin(36.0000)
layout:setTopMargin(13.0000)
layout:setBottomMargin(11.0000)
img_right:setBlendFunc({src = 1, dst = 771})
input_name:addChild(img_right)

--Create img_wrong
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/match_tv_view.plist")
local img_wrong = cc.Sprite:createWithSpriteFrameName("hall/room/match/match_apply/wrong.png")
img_wrong:setName("img_wrong")
img_wrong:setTag(266)
img_wrong:setCascadeColorEnabled(true)
img_wrong:setCascadeOpacityEnabled(true)
img_wrong:setVisible(false)
img_wrong:setPosition(551.0000, 24.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_wrong)
layout:setPositionPercentX(0.9183)
layout:setPositionPercentY(0.4800)
layout:setPercentWidth(0.0433)
layout:setPercentHeight(0.5200)
layout:setSize({width = 26.0000, height = 26.0000})
layout:setLeftMargin(538.0000)
layout:setRightMargin(36.0000)
layout:setTopMargin(13.0000)
layout:setBottomMargin(11.0000)
img_wrong:setBlendFunc({src = 1, dst = 771})
input_name:addChild(img_wrong)

--Create input_phone
local input_phone = ccui.Layout:create()
input_phone:ignoreContentAdaptWithSize(false)
input_phone:setClippingEnabled(false)
input_phone:setTouchEnabled(true);
input_phone:setLayoutComponentEnabled(true)
input_phone:setName("input_phone")
input_phone:setTag(267)
input_phone:setCascadeColorEnabled(true)
input_phone:setCascadeOpacityEnabled(true)
input_phone:setPosition(28.0005, 367.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(input_phone)
layout:setPositionPercentX(0.0446)
layout:setPositionPercentY(0.6496)
layout:setPercentWidth(0.9554)
layout:setPercentHeight(0.0885)
layout:setSize({width = 600.0000, height = 50.0000})
layout:setLeftMargin(28.0005)
layout:setRightMargin(-0.0005)
layout:setTopMargin(148.0000)
layout:setBottomMargin(367.0000)
panel_bg:addChild(input_phone)

--Create txt_phone
local txt_phone = ccui.Text:create()
txt_phone:ignoreContentAdaptWithSize(true)
txt_phone:setTextAreaSize({width = 0, height = 0})
txt_phone:setFontSize(32)
txt_phone:setString([[手机号:]])
txt_phone:setLayoutComponentEnabled(true)
txt_phone:setName("txt_phone")
txt_phone:setTag(268)
txt_phone:setCascadeColorEnabled(true)
txt_phone:setCascadeOpacityEnabled(true)
txt_phone:setAnchorPoint(0.0000, 0.5000)
txt_phone:setPosition(33.2000, 22.6050)
txt_phone:setTextColor({r = 34, g = 34, b = 34})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_phone)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.0553)
layout:setPositionPercentY(0.4521)
layout:setPercentWidth(0.1867)
layout:setPercentHeight(0.6600)
layout:setSize({width = 112.0000, height = 33.0000})
layout:setLeftMargin(33.2000)
layout:setRightMargin(454.8000)
layout:setTopMargin(10.8950)
layout:setBottomMargin(6.1050)
input_phone:addChild(txt_phone)

--Create img_line
local img_line = ccui.ImageView:create()
img_line:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/match_tv_view.plist")
img_line:loadTexture("hall/room/match/match_apply/line.png",1)
img_line:setScale9Enabled(true)
img_line:setCapInsets({x = 4, y = 0, width = 1, height = 1})
img_line:setLayoutComponentEnabled(true)
img_line:setName("img_line")
img_line:setTag(269)
img_line:setCascadeColorEnabled(true)
img_line:setCascadeOpacityEnabled(true)
img_line:setAnchorPoint(1.0000, 0.5000)
img_line:setPosition(529.0000, 7.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_line)
layout:setPositionPercentX(0.8817)
layout:setPositionPercentY(0.1400)
layout:setPercentWidth(0.6167)
layout:setPercentHeight(0.0200)
layout:setSize({width = 370.0000, height = 1.0000})
layout:setLeftMargin(159.0000)
layout:setRightMargin(71.0000)
layout:setTopMargin(42.5000)
layout:setBottomMargin(6.5000)
input_phone:addChild(img_line)

--Create field_phone
local field_phone = ccui.TextField:create()
field_phone:ignoreContentAdaptWithSize(false)
tolua.cast(field_phone:getVirtualRenderer(), "cc.Label"):setLineBreakWithoutSpace(true)
field_phone:setFontSize(32)
field_phone:setPlaceHolder("")
field_phone:setString([[]])
field_phone:setMaxLength(10)
field_phone:setLayoutComponentEnabled(true)
field_phone:setName("field_phone")
field_phone:setTag(270)
field_phone:setCascadeColorEnabled(true)
field_phone:setCascadeOpacityEnabled(true)
field_phone:setAnchorPoint(0.0000, 0.5000)
field_phone:setPosition(169.9200, 26.0722)
field_phone:setColor({r = 34, g = 34, b = 34})
layout = ccui.LayoutComponent:bindLayoutComponent(field_phone)
layout:setPositionPercentX(0.2832)
layout:setPositionPercentY(0.5214)
layout:setPercentWidth(0.5833)
layout:setPercentHeight(0.6400)
layout:setSize({width = 350.0000, height = 32.0000})
layout:setLeftMargin(169.9200)
layout:setRightMargin(80.0800)
layout:setTopMargin(7.9278)
layout:setBottomMargin(10.0722)
input_phone:addChild(field_phone)

--Create img_right
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/match_tv_view.plist")
local img_right = cc.Sprite:createWithSpriteFrameName("hall/room/match/match_apply/right.png")
img_right:setName("img_right")
img_right:setTag(271)
img_right:setCascadeColorEnabled(true)
img_right:setCascadeOpacityEnabled(true)
img_right:setVisible(false)
img_right:setPosition(551.0000, 24.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_right)
layout:setPositionPercentX(0.9183)
layout:setPositionPercentY(0.4800)
layout:setPercentWidth(0.0433)
layout:setPercentHeight(0.5200)
layout:setSize({width = 26.0000, height = 26.0000})
layout:setLeftMargin(538.0000)
layout:setRightMargin(36.0000)
layout:setTopMargin(13.0000)
layout:setBottomMargin(11.0000)
img_right:setBlendFunc({src = 1, dst = 771})
input_phone:addChild(img_right)

--Create img_wrong
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/match_tv_view.plist")
local img_wrong = cc.Sprite:createWithSpriteFrameName("hall/room/match/match_apply/wrong.png")
img_wrong:setName("img_wrong")
img_wrong:setTag(272)
img_wrong:setCascadeColorEnabled(true)
img_wrong:setCascadeOpacityEnabled(true)
img_wrong:setVisible(false)
img_wrong:setPosition(551.0000, 24.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_wrong)
layout:setPositionPercentX(0.9183)
layout:setPositionPercentY(0.4800)
layout:setPercentWidth(0.0433)
layout:setPercentHeight(0.5200)
layout:setSize({width = 26.0000, height = 26.0000})
layout:setLeftMargin(538.0000)
layout:setRightMargin(36.0000)
layout:setTopMargin(13.0000)
layout:setBottomMargin(11.0000)
img_wrong:setBlendFunc({src = 1, dst = 771})
input_phone:addChild(img_wrong)

--Create input_identity
local input_identity = ccui.Layout:create()
input_identity:ignoreContentAdaptWithSize(false)
input_identity:setClippingEnabled(false)
input_identity:setTouchEnabled(true);
input_identity:setLayoutComponentEnabled(true)
input_identity:setName("input_identity")
input_identity:setTag(273)
input_identity:setCascadeColorEnabled(true)
input_identity:setCascadeOpacityEnabled(true)
input_identity:setPosition(28.0000, 304.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(input_identity)
layout:setPositionPercentX(0.0446)
layout:setPositionPercentY(0.5381)
layout:setPercentWidth(0.9554)
layout:setPercentHeight(0.0885)
layout:setSize({width = 600.0000, height = 50.0000})
layout:setLeftMargin(28.0000)
layout:setTopMargin(211.0000)
layout:setBottomMargin(304.0000)
panel_bg:addChild(input_identity)

--Create txt_identity
local txt_identity = ccui.Text:create()
txt_identity:ignoreContentAdaptWithSize(true)
txt_identity:setTextAreaSize({width = 0, height = 0})
txt_identity:setFontSize(32)
txt_identity:setString([[身份证:]])
txt_identity:setLayoutComponentEnabled(true)
txt_identity:setName("txt_identity")
txt_identity:setTag(274)
txt_identity:setCascadeColorEnabled(true)
txt_identity:setCascadeOpacityEnabled(true)
txt_identity:setAnchorPoint(0.0000, 0.5000)
txt_identity:setPosition(33.2000, 22.6050)
txt_identity:setTextColor({r = 34, g = 34, b = 34})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_identity)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.0553)
layout:setPositionPercentY(0.4521)
layout:setPercentWidth(0.1867)
layout:setPercentHeight(0.6600)
layout:setSize({width = 112.0000, height = 33.0000})
layout:setLeftMargin(33.2000)
layout:setRightMargin(454.8000)
layout:setTopMargin(10.8950)
layout:setBottomMargin(6.1050)
input_identity:addChild(txt_identity)

--Create img_line
local img_line = ccui.ImageView:create()
img_line:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/match_tv_view.plist")
img_line:loadTexture("hall/room/match/match_apply/line.png",1)
img_line:setScale9Enabled(true)
img_line:setCapInsets({x = 4, y = 0, width = 1, height = 1})
img_line:setLayoutComponentEnabled(true)
img_line:setName("img_line")
img_line:setTag(275)
img_line:setCascadeColorEnabled(true)
img_line:setCascadeOpacityEnabled(true)
img_line:setAnchorPoint(1.0000, 0.5000)
img_line:setPosition(529.0000, 7.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_line)
layout:setPositionPercentX(0.8817)
layout:setPositionPercentY(0.1400)
layout:setPercentWidth(0.6167)
layout:setPercentHeight(0.0200)
layout:setSize({width = 370.0000, height = 1.0000})
layout:setLeftMargin(159.0000)
layout:setRightMargin(71.0000)
layout:setTopMargin(42.5000)
layout:setBottomMargin(6.5000)
input_identity:addChild(img_line)

--Create field_identity
local field_identity = ccui.TextField:create()
field_identity:ignoreContentAdaptWithSize(false)
tolua.cast(field_identity:getVirtualRenderer(), "cc.Label"):setLineBreakWithoutSpace(true)
field_identity:setFontSize(32)
field_identity:setPlaceHolder("")
field_identity:setString([[]])
field_identity:setMaxLength(10)
field_identity:setLayoutComponentEnabled(true)
field_identity:setName("field_identity")
field_identity:setTag(276)
field_identity:setCascadeColorEnabled(true)
field_identity:setCascadeOpacityEnabled(true)
field_identity:setAnchorPoint(0.0000, 0.5000)
field_identity:setPosition(169.9200, 26.0722)
field_identity:setColor({r = 34, g = 34, b = 34})
layout = ccui.LayoutComponent:bindLayoutComponent(field_identity)
layout:setPositionPercentX(0.2832)
layout:setPositionPercentY(0.5214)
layout:setPercentWidth(0.5833)
layout:setPercentHeight(0.6400)
layout:setSize({width = 350.0000, height = 32.0000})
layout:setLeftMargin(169.9200)
layout:setRightMargin(80.0800)
layout:setTopMargin(7.9278)
layout:setBottomMargin(10.0722)
input_identity:addChild(field_identity)

--Create img_right
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/match_tv_view.plist")
local img_right = cc.Sprite:createWithSpriteFrameName("hall/room/match/match_apply/right.png")
img_right:setName("img_right")
img_right:setTag(277)
img_right:setCascadeColorEnabled(true)
img_right:setCascadeOpacityEnabled(true)
img_right:setVisible(false)
img_right:setPosition(551.0000, 24.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_right)
layout:setPositionPercentX(0.9183)
layout:setPositionPercentY(0.4800)
layout:setPercentWidth(0.0433)
layout:setPercentHeight(0.5200)
layout:setSize({width = 26.0000, height = 26.0000})
layout:setLeftMargin(538.0000)
layout:setRightMargin(36.0000)
layout:setTopMargin(13.0000)
layout:setBottomMargin(11.0000)
img_right:setBlendFunc({src = 1, dst = 771})
input_identity:addChild(img_right)

--Create img_wrong
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/match_tv_view.plist")
local img_wrong = cc.Sprite:createWithSpriteFrameName("hall/room/match/match_apply/wrong.png")
img_wrong:setName("img_wrong")
img_wrong:setTag(278)
img_wrong:setCascadeColorEnabled(true)
img_wrong:setCascadeOpacityEnabled(true)
img_wrong:setVisible(false)
img_wrong:setPosition(551.0000, 24.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_wrong)
layout:setPositionPercentX(0.9183)
layout:setPositionPercentY(0.4800)
layout:setPercentWidth(0.0433)
layout:setPercentHeight(0.5200)
layout:setSize({width = 26.0000, height = 26.0000})
layout:setLeftMargin(538.0000)
layout:setRightMargin(36.0000)
layout:setTopMargin(13.0000)
layout:setBottomMargin(11.0000)
img_wrong:setBlendFunc({src = 1, dst = 771})
input_identity:addChild(img_wrong)

--Create input_province
local input_province = ccui.Layout:create()
input_province:ignoreContentAdaptWithSize(false)
input_province:setClippingEnabled(false)
input_province:setTouchEnabled(true);
input_province:setLayoutComponentEnabled(true)
input_province:setName("input_province")
input_province:setTag(279)
input_province:setCascadeColorEnabled(true)
input_province:setCascadeOpacityEnabled(true)
input_province:setAnchorPoint(0.5000, 0.5000)
input_province:setPosition(328.0000, 268.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(input_province)
layout:setPositionPercentX(0.5223)
layout:setPositionPercentY(0.4743)
layout:setPercentWidth(0.9554)
layout:setPercentHeight(0.0885)
layout:setSize({width = 600.0000, height = 50.0000})
layout:setLeftMargin(28.0000)
layout:setTopMargin(272.0000)
layout:setBottomMargin(243.0000)
panel_bg:addChild(input_province)

--Create txt_province
local txt_province = ccui.Text:create()
txt_province:ignoreContentAdaptWithSize(true)
txt_province:setTextAreaSize({width = 0, height = 0})
txt_province:setFontSize(32)
txt_province:setString([[省  份:]])
txt_province:setLayoutComponentEnabled(true)
txt_province:setName("txt_province")
txt_province:setTag(280)
txt_province:setCascadeColorEnabled(true)
txt_province:setCascadeOpacityEnabled(true)
txt_province:setAnchorPoint(0.0000, 0.5000)
txt_province:setPosition(33.2000, 22.6050)
txt_province:setTextColor({r = 34, g = 34, b = 34})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_province)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.0553)
layout:setPositionPercentY(0.4521)
layout:setPercentWidth(0.1867)
layout:setPercentHeight(0.6600)
layout:setSize({width = 112.0000, height = 33.0000})
layout:setLeftMargin(33.2000)
layout:setRightMargin(454.8000)
layout:setTopMargin(10.8950)
layout:setBottomMargin(6.1050)
input_province:addChild(txt_province)

--Create img_line
local img_line = ccui.ImageView:create()
img_line:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/match_tv_view.plist")
img_line:loadTexture("hall/room/match/match_apply/line.png",1)
img_line:setScale9Enabled(true)
img_line:setCapInsets({x = 4, y = 0, width = 1, height = 1})
img_line:setLayoutComponentEnabled(true)
img_line:setName("img_line")
img_line:setTag(281)
img_line:setCascadeColorEnabled(true)
img_line:setCascadeOpacityEnabled(true)
img_line:setAnchorPoint(1.0000, 0.5000)
img_line:setPosition(529.0000, 7.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_line)
layout:setPositionPercentX(0.8817)
layout:setPositionPercentY(0.1400)
layout:setPercentWidth(0.6167)
layout:setPercentHeight(0.0200)
layout:setSize({width = 370.0000, height = 1.0000})
layout:setLeftMargin(159.0000)
layout:setRightMargin(71.0000)
layout:setTopMargin(42.5000)
layout:setBottomMargin(6.5000)
input_province:addChild(img_line)

--Create txt_sheng
local txt_sheng = ccui.Text:create()
txt_sheng:ignoreContentAdaptWithSize(true)
txt_sheng:setTextAreaSize({width = 0, height = 0})
txt_sheng:setFontSize(32)
txt_sheng:setString([[福建省]])
txt_sheng:setLayoutComponentEnabled(true)
txt_sheng:setName("txt_sheng")
txt_sheng:setTag(2150)
txt_sheng:setCascadeColorEnabled(true)
txt_sheng:setCascadeOpacityEnabled(true)
txt_sheng:setVisible(false)
txt_sheng:setAnchorPoint(0.0000, 0.5000)
txt_sheng:setPosition(169.9200, 26.0700)
txt_sheng:setTextColor({r = 34, g = 34, b = 34})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_sheng)
layout:setPositionPercentX(0.2832)
layout:setPositionPercentY(0.5214)
layout:setPercentWidth(0.1600)
layout:setPercentHeight(0.6600)
layout:setSize({width = 96.0000, height = 33.0000})
layout:setLeftMargin(169.9200)
layout:setRightMargin(334.0800)
layout:setTopMargin(7.4300)
layout:setBottomMargin(9.5700)
input_province:addChild(txt_sheng)

--Create field_province
local field_province = ccui.TextField:create()
field_province:ignoreContentAdaptWithSize(false)
tolua.cast(field_province:getVirtualRenderer(), "cc.Label"):setLineBreakWithoutSpace(true)
field_province:setFontSize(32)
field_province:setPlaceHolder("")
field_province:setString([[]])
field_province:setMaxLength(10)
field_province:setTouchEnabled(false);
field_province:setLayoutComponentEnabled(true)
field_province:setName("field_province")
field_province:setTag(282)
field_province:setCascadeColorEnabled(true)
field_province:setCascadeOpacityEnabled(true)
field_province:setAnchorPoint(0.0000, 0.5000)
field_province:setPosition(169.9200, 26.0722)
field_province:setColor({r = 34, g = 34, b = 34})
layout = ccui.LayoutComponent:bindLayoutComponent(field_province)
layout:setPositionPercentX(0.2832)
layout:setPositionPercentY(0.5214)
layout:setPercentWidth(0.5833)
layout:setPercentHeight(0.6400)
layout:setSize({width = 350.0000, height = 32.0000})
layout:setLeftMargin(169.9200)
layout:setRightMargin(80.0800)
layout:setTopMargin(7.9278)
layout:setBottomMargin(10.0722)
input_province:addChild(field_province)

--Create img_right
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/match_tv_view.plist")
local img_right = cc.Sprite:createWithSpriteFrameName("hall/room/match/match_apply/right.png")
img_right:setName("img_right")
img_right:setTag(283)
img_right:setCascadeColorEnabled(true)
img_right:setCascadeOpacityEnabled(true)
img_right:setVisible(false)
img_right:setPosition(551.0000, 24.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_right)
layout:setPositionPercentX(0.9183)
layout:setPositionPercentY(0.4800)
layout:setPercentWidth(0.0433)
layout:setPercentHeight(0.5200)
layout:setSize({width = 26.0000, height = 26.0000})
layout:setLeftMargin(538.0000)
layout:setRightMargin(36.0000)
layout:setTopMargin(13.0000)
layout:setBottomMargin(11.0000)
img_right:setBlendFunc({src = 1, dst = 771})
input_province:addChild(img_right)

--Create img_wrong
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/match_tv_view.plist")
local img_wrong = cc.Sprite:createWithSpriteFrameName("hall/room/match/match_apply/wrong.png")
img_wrong:setName("img_wrong")
img_wrong:setTag(284)
img_wrong:setCascadeColorEnabled(true)
img_wrong:setCascadeOpacityEnabled(true)
img_wrong:setVisible(false)
img_wrong:setPosition(551.0000, 24.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_wrong)
layout:setPositionPercentX(0.9183)
layout:setPositionPercentY(0.4800)
layout:setPercentWidth(0.0433)
layout:setPercentHeight(0.5200)
layout:setSize({width = 26.0000, height = 26.0000})
layout:setLeftMargin(538.0000)
layout:setRightMargin(36.0000)
layout:setTopMargin(13.0000)
layout:setBottomMargin(11.0000)
img_wrong:setBlendFunc({src = 1, dst = 771})
input_province:addChild(img_wrong)

--Create input_city
local input_city = ccui.Layout:create()
input_city:ignoreContentAdaptWithSize(false)
input_city:setClippingEnabled(false)
input_city:setTouchEnabled(true);
input_city:setLayoutComponentEnabled(true)
input_city:setName("input_city")
input_city:setTag(285)
input_city:setCascadeColorEnabled(true)
input_city:setCascadeOpacityEnabled(true)
input_city:setAnchorPoint(0.5000, 0.5000)
input_city:setPosition(328.0000, 207.2016)
layout = ccui.LayoutComponent:bindLayoutComponent(input_city)
layout:setPositionPercentX(0.5223)
layout:setPositionPercentY(0.3667)
layout:setPercentWidth(0.9554)
layout:setPercentHeight(0.0885)
layout:setSize({width = 600.0000, height = 50.0000})
layout:setLeftMargin(28.0000)
layout:setTopMargin(332.7984)
layout:setBottomMargin(182.2016)
panel_bg:addChild(input_city)

--Create txt_city
local txt_city = ccui.Text:create()
txt_city:ignoreContentAdaptWithSize(true)
txt_city:setTextAreaSize({width = 0, height = 0})
txt_city:setFontSize(32)
txt_city:setString([[城  市:]])
txt_city:setLayoutComponentEnabled(true)
txt_city:setName("txt_city")
txt_city:setTag(286)
txt_city:setCascadeColorEnabled(true)
txt_city:setCascadeOpacityEnabled(true)
txt_city:setAnchorPoint(0.0000, 0.5000)
txt_city:setPosition(33.2000, 22.6050)
txt_city:setTextColor({r = 34, g = 34, b = 34})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_city)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.0553)
layout:setPositionPercentY(0.4521)
layout:setPercentWidth(0.1867)
layout:setPercentHeight(0.6600)
layout:setSize({width = 112.0000, height = 33.0000})
layout:setLeftMargin(33.2000)
layout:setRightMargin(454.8000)
layout:setTopMargin(10.8950)
layout:setBottomMargin(6.1050)
input_city:addChild(txt_city)

--Create img_line
local img_line = ccui.ImageView:create()
img_line:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/match_tv_view.plist")
img_line:loadTexture("hall/room/match/match_apply/line.png",1)
img_line:setScale9Enabled(true)
img_line:setCapInsets({x = 4, y = 0, width = 1, height = 1})
img_line:setLayoutComponentEnabled(true)
img_line:setName("img_line")
img_line:setTag(287)
img_line:setCascadeColorEnabled(true)
img_line:setCascadeOpacityEnabled(true)
img_line:setAnchorPoint(1.0000, 0.5000)
img_line:setPosition(529.0000, 7.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_line)
layout:setPositionPercentX(0.8817)
layout:setPositionPercentY(0.1400)
layout:setPercentWidth(0.6167)
layout:setPercentHeight(0.0200)
layout:setSize({width = 370.0000, height = 1.0000})
layout:setLeftMargin(159.0000)
layout:setRightMargin(71.0000)
layout:setTopMargin(42.5000)
layout:setBottomMargin(6.5000)
input_city:addChild(img_line)

--Create field_city
local field_city = ccui.TextField:create()
field_city:ignoreContentAdaptWithSize(false)
tolua.cast(field_city:getVirtualRenderer(), "cc.Label"):setLineBreakWithoutSpace(true)
field_city:setFontSize(32)
field_city:setPlaceHolder("")
field_city:setString([[]])
field_city:setMaxLength(10)
field_city:setTouchEnabled(false);
field_city:setLayoutComponentEnabled(true)
field_city:setName("field_city")
field_city:setTag(288)
field_city:setCascadeColorEnabled(true)
field_city:setCascadeOpacityEnabled(true)
field_city:setAnchorPoint(0.0000, 0.5000)
field_city:setPosition(169.9200, 26.0722)
field_city:setColor({r = 34, g = 34, b = 34})
layout = ccui.LayoutComponent:bindLayoutComponent(field_city)
layout:setPositionPercentX(0.2832)
layout:setPositionPercentY(0.5214)
layout:setPercentWidth(0.5833)
layout:setPercentHeight(0.6400)
layout:setSize({width = 350.0000, height = 32.0000})
layout:setLeftMargin(169.9200)
layout:setRightMargin(80.0800)
layout:setTopMargin(7.9278)
layout:setBottomMargin(10.0722)
input_city:addChild(field_city)

--Create img_right
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/match_tv_view.plist")
local img_right = cc.Sprite:createWithSpriteFrameName("hall/room/match/match_apply/right.png")
img_right:setName("img_right")
img_right:setTag(289)
img_right:setCascadeColorEnabled(true)
img_right:setCascadeOpacityEnabled(true)
img_right:setVisible(false)
img_right:setPosition(551.0000, 24.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_right)
layout:setPositionPercentX(0.9183)
layout:setPositionPercentY(0.4800)
layout:setPercentWidth(0.0433)
layout:setPercentHeight(0.5200)
layout:setSize({width = 26.0000, height = 26.0000})
layout:setLeftMargin(538.0000)
layout:setRightMargin(36.0000)
layout:setTopMargin(13.0000)
layout:setBottomMargin(11.0000)
img_right:setBlendFunc({src = 1, dst = 771})
input_city:addChild(img_right)

--Create img_wrong
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/match_tv_view.plist")
local img_wrong = cc.Sprite:createWithSpriteFrameName("hall/room/match/match_apply/wrong.png")
img_wrong:setName("img_wrong")
img_wrong:setTag(290)
img_wrong:setCascadeColorEnabled(true)
img_wrong:setCascadeOpacityEnabled(true)
img_wrong:setVisible(false)
img_wrong:setPosition(551.0000, 24.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_wrong)
layout:setPositionPercentX(0.9183)
layout:setPositionPercentY(0.4800)
layout:setPercentWidth(0.0433)
layout:setPercentHeight(0.5200)
layout:setSize({width = 26.0000, height = 26.0000})
layout:setLeftMargin(538.0000)
layout:setRightMargin(36.0000)
layout:setTopMargin(13.0000)
layout:setBottomMargin(11.0000)
img_wrong:setBlendFunc({src = 1, dst = 771})
input_city:addChild(img_wrong)

--Create txt_cs
local txt_cs = ccui.Text:create()
txt_cs:ignoreContentAdaptWithSize(true)
txt_cs:setTextAreaSize({width = 0, height = 0})
txt_cs:setFontSize(32)
txt_cs:setString([[福建省]])
txt_cs:setLayoutComponentEnabled(true)
txt_cs:setName("txt_cs")
txt_cs:setTag(169)
txt_cs:setCascadeColorEnabled(true)
txt_cs:setCascadeOpacityEnabled(true)
txt_cs:setVisible(false)
txt_cs:setAnchorPoint(0.0000, 0.5000)
txt_cs:setPosition(169.9200, 26.0700)
txt_cs:setTextColor({r = 34, g = 34, b = 34})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_cs)
layout:setPositionPercentX(0.2832)
layout:setPositionPercentY(0.5214)
layout:setPercentWidth(0.1600)
layout:setPercentHeight(0.6600)
layout:setSize({width = 96.0000, height = 33.0000})
layout:setLeftMargin(169.9200)
layout:setRightMargin(334.0800)
layout:setTopMargin(7.4300)
layout:setBottomMargin(9.5700)
input_city:addChild(txt_cs)

--Create img_icon
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/match_tv_view.plist")
local img_icon = cc.Sprite:createWithSpriteFrameName("hall/room/match/match_apply/icon_waring.png")
img_icon:setName("img_icon")
img_icon:setTag(291)
img_icon:setCascadeColorEnabled(true)
img_icon:setCascadeOpacityEnabled(true)
img_icon:setPosition(74.0792, 155.8232)
layout = ccui.LayoutComponent:bindLayoutComponent(img_icon)
layout:setPositionPercentX(0.1180)
layout:setPositionPercentY(0.2758)
layout:setPercentWidth(0.0382)
layout:setPercentHeight(0.0425)
layout:setSize({width = 24.0000, height = 24.0000})
layout:setLeftMargin(62.0792)
layout:setRightMargin(541.9208)
layout:setTopMargin(397.1768)
layout:setBottomMargin(143.8232)
img_icon:setBlendFunc({src = 1, dst = 771})
panel_bg:addChild(img_icon)

--Create txt_xx
local txt_xx = ccui.Text:create()
txt_xx:ignoreContentAdaptWithSize(true)
txt_xx:setTextAreaSize({width = 0, height = 0})
txt_xx:setFontSize(20)
txt_xx:setString([[提供资料均保密，仅方便电视台与您取得联系]])
txt_xx:setLayoutComponentEnabled(true)
txt_xx:setName("txt_xx")
txt_xx:setTag(292)
txt_xx:setCascadeColorEnabled(true)
txt_xx:setCascadeOpacityEnabled(true)
txt_xx:setPosition(231.5151, 12.3633)
txt_xx:setTextColor({r = 0, g = 154, b = 19})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_xx)
layout:setPositionPercentX(9.6465)
layout:setPositionPercentY(0.5151)
layout:setPercentWidth(16.6667)
layout:setPercentHeight(0.8333)
layout:setSize({width = 400.0000, height = 20.0000})
layout:setLeftMargin(31.5151)
layout:setRightMargin(-407.5151)
layout:setTopMargin(1.6367)
layout:setBottomMargin(2.3633)
img_icon:addChild(txt_xx)

--Create btn_apply
local btn_apply = ccui.Layout:create()
btn_apply:ignoreContentAdaptWithSize(false)
btn_apply:setClippingEnabled(false)
btn_apply:setBackGroundColorType(1)
btn_apply:setBackGroundColor({r = 150, g = 200, b = 255})
btn_apply:setBackGroundColorOpacity(102)
btn_apply:setTouchEnabled(true);
btn_apply:setLayoutComponentEnabled(true)
btn_apply:setName("btn_apply")
btn_apply:setTag(293)
btn_apply:setCascadeColorEnabled(true)
btn_apply:setCascadeOpacityEnabled(true)
btn_apply:setAnchorPoint(0.5000, 0.5000)
btn_apply:setPosition(314.2238, 77.9617)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_apply)
layout:setPositionPercentX(0.5004)
layout:setPositionPercentY(0.1380)
layout:setPercentWidth(0.8041)
layout:setPercentHeight(0.1416)
layout:setSize({width = 505.0000, height = 80.0000})
layout:setLeftMargin(61.7238)
layout:setRightMargin(61.2763)
layout:setTopMargin(447.0383)
layout:setBottomMargin(37.9617)
panel_bg:addChild(btn_apply)

--Create img_di
local img_di = ccui.ImageView:create()
img_di:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/match_tv_view.plist")
img_di:loadTexture("hall/room/match/match_apply/btn.png",1)
img_di:setScale9Enabled(true)
img_di:setCapInsets({x = 5, y = 5, width = 8, height = 8})
img_di:setLayoutComponentEnabled(true)
img_di:setName("img_di")
img_di:setTag(294)
img_di:setCascadeColorEnabled(true)
img_di:setCascadeOpacityEnabled(true)
img_di:setPosition(252.5000, 40.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_di)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(1.0000)
layout:setSize({width = 505.0000, height = 80.0000})
btn_apply:addChild(img_di)

--Create txt_apply
local txt_apply = ccui.Text:create()
txt_apply:ignoreContentAdaptWithSize(true)
txt_apply:setTextAreaSize({width = 0, height = 0})
txt_apply:setFontSize(38)
txt_apply:setString([[立即报名]])
txt_apply:setLayoutComponentEnabled(true)
txt_apply:setName("txt_apply")
txt_apply:setTag(295)
txt_apply:setCascadeColorEnabled(true)
txt_apply:setCascadeOpacityEnabled(true)
txt_apply:setPosition(252.5000, 40.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(txt_apply)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.3010)
layout:setPercentHeight(0.4750)
layout:setSize({width = 152.0000, height = 38.0000})
layout:setLeftMargin(176.5000)
layout:setRightMargin(176.5000)
layout:setTopMargin(21.0000)
layout:setBottomMargin(21.0000)
btn_apply:addChild(txt_apply)

--Create Animation
result['animation'] = ccs.ActionTimeline:create()
  
result['animation']:setDuration(0)
result['animation']:setTimeSpeed(1.0000)
--Create Animation List

result['root'] = Node
return result;
end

return Result

