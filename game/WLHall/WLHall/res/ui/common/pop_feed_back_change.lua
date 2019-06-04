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

--Create full_bg
local full_bg = ccui.Layout:create()
full_bg:ignoreContentAdaptWithSize(false)
full_bg:setClippingEnabled(false)
full_bg:setBackGroundColorOpacity(102)
full_bg:setTouchEnabled(true);
full_bg:setLayoutComponentEnabled(true)
full_bg:setName("full_bg")
full_bg:setTag(465)
full_bg:setCascadeColorEnabled(true)
full_bg:setCascadeOpacityEnabled(true)
full_bg:setAnchorPoint(0.5000, 0.5000)
full_bg:setPosition(640.0000, 360.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(full_bg)
layout:setSize({width = 1280.0000, height = 720.0000})
layout:setRightMargin(-1280.0000)
layout:setTopMargin(-720.0000)
Node:addChild(full_bg)

--Create nd_rule
innerCSD = require("ui.common.rule_view")
innerProject = innerCSD.create(callBackProvider)
local nd_rule = innerProject.root
nd_rule.animation = innerProject.animation
nd_rule:setName("nd_rule")
nd_rule:setTag(305)
nd_rule:setCascadeColorEnabled(true)
nd_rule:setCascadeOpacityEnabled(true)
layout = ccui.LayoutComponent:bindLayoutComponent(nd_rule)
layout:setRightMargin(1280.0000)
layout:setTopMargin(720.0000)
innerProject.animation:setTimeSpeed(1.0000)
nd_rule:runAction(innerProject.animation)
full_bg:addChild(nd_rule)

--Create nd_feed
innerCSD = require("ui.common.feedback_view")
innerProject = innerCSD.create(callBackProvider)
local nd_feed = innerProject.root
nd_feed.animation = innerProject.animation
nd_feed:setName("nd_feed")
nd_feed:setTag(307)
nd_feed:setCascadeColorEnabled(true)
nd_feed:setCascadeOpacityEnabled(true)
layout = ccui.LayoutComponent:bindLayoutComponent(nd_feed)
layout:setRightMargin(1280.0000)
layout:setTopMargin(720.0000)
innerProject.animation:setTimeSpeed(1.0000)
nd_feed:runAction(innerProject.animation)
full_bg:addChild(nd_feed)

--Create btn_close
local btn_close = ccui.Button:create()
btn_close:ignoreContentAdaptWithSize(false)
btn_close:setTitleFontSize(14)
btn_close:setTitleColor({r = 65, g = 65, b = 70})
btn_close:setLayoutComponentEnabled(true)
btn_close:setName("btn_close")
btn_close:setTag(73)
btn_close:setCascadeColorEnabled(true)
btn_close:setCascadeOpacityEnabled(true)
btn_close:setPosition(1208.0000, 648.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_close)
layout:setPositionPercentX(0.9438)
layout:setPositionPercentY(0.9000)
layout:setPercentWidth(0.0469)
layout:setPercentHeight(0.0833)
layout:setSize({width = 60.0000, height = 60.0000})
layout:setLeftMargin(1178.0000)
layout:setRightMargin(42.0000)
layout:setTopMargin(42.0000)
layout:setBottomMargin(618.0000)
full_bg:addChild(btn_close)

--Create Image_close
local Image_close = ccui.ImageView:create()
Image_close:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
Image_close:loadTexture("hall/common/new_btn_close.png",1)
Image_close:setLayoutComponentEnabled(true)
Image_close:setName("Image_close")
Image_close:setTag(92)
Image_close:setCascadeColorEnabled(true)
Image_close:setCascadeOpacityEnabled(true)
Image_close:setPosition(29.9994, 34.9997)
layout = ccui.LayoutComponent:bindLayoutComponent(Image_close)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5833)
layout:setPercentWidth(0.4000)
layout:setPercentHeight(0.4167)
layout:setSize({width = 24.0000, height = 25.0000})
layout:setLeftMargin(17.9994)
layout:setRightMargin(18.0006)
layout:setTopMargin(12.5003)
layout:setBottomMargin(22.4997)
btn_close:addChild(Image_close)

--Create title_bg
local title_bg = ccui.ImageView:create()
title_bg:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
title_bg:loadTexture("hall/common/new_pop_left_bg.png",1)
title_bg:setScale9Enabled(true)
title_bg:setCapInsets({x = 40, y = 10, width = 25, height = 4})
title_bg:setTouchEnabled(true);
title_bg:setLayoutComponentEnabled(true)
title_bg:setName("title_bg")
title_bg:setTag(401)
title_bg:setCascadeColorEnabled(true)
title_bg:setCascadeOpacityEnabled(true)
title_bg:setAnchorPoint(1.0000, 0.0000)
title_bg:setPosition(142.0000, 43.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(title_bg)
layout:setPositionPercentX(0.1109)
layout:setPositionPercentY(0.0597)
layout:setPercentWidth(0.0828)
layout:setPercentHeight(0.8958)
layout:setSize({width = 106.0000, height = 645.0000})
layout:setLeftMargin(36.0000)
layout:setRightMargin(1138.0000)
layout:setTopMargin(32.0000)
layout:setBottomMargin(43.0000)
full_bg:addChild(title_bg)

--Create btn_rule
local btn_rule = ccui.Layout:create()
btn_rule:ignoreContentAdaptWithSize(false)
btn_rule:setClippingEnabled(false)
btn_rule:setTouchEnabled(true);
btn_rule:setLayoutComponentEnabled(true)
btn_rule:setName("btn_rule")
btn_rule:setTag(790)
btn_rule:setCascadeColorEnabled(true)
btn_rule:setCascadeOpacityEnabled(true)
btn_rule:setAnchorPoint(0.5000, 0.5000)
btn_rule:setPosition(54.9997, 570.9908)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_rule)
layout:setPositionPercentX(0.5189)
layout:setPositionPercentY(0.8853)
layout:setPercentWidth(0.9434)
layout:setPercentHeight(0.1550)
layout:setSize({width = 100.0000, height = 100.0000})
layout:setLeftMargin(4.9997)
layout:setRightMargin(1.0003)
layout:setTopMargin(24.0092)
layout:setBottomMargin(520.9908)
title_bg:addChild(btn_rule)

--Create btn_bg
local btn_bg = ccui.ImageView:create()
btn_bg:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/feedback.plist")
btn_bg:loadTexture("hall/feedback/icon_guize.png",1)
btn_bg:setLayoutComponentEnabled(true)
btn_bg:setName("btn_bg")
btn_bg:setTag(791)
btn_bg:setCascadeColorEnabled(true)
btn_bg:setCascadeOpacityEnabled(true)
btn_bg:setPosition(50.5623, 66.4869)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_bg)
layout:setPositionPercentX(0.5056)
layout:setPositionPercentY(0.6649)
layout:setPercentWidth(0.4000)
layout:setPercentHeight(0.4900)
layout:setSize({width = 40.0000, height = 49.0000})
layout:setLeftMargin(30.5623)
layout:setRightMargin(29.4377)
layout:setTopMargin(9.0131)
layout:setBottomMargin(41.9869)
btn_rule:addChild(btn_bg)

--Create txt_1
local txt_1 = ccui.Text:create()
txt_1:ignoreContentAdaptWithSize(true)
txt_1:setTextAreaSize({width = 0, height = 0})
txt_1:setFontSize(24)
txt_1:setString([[规则]])
txt_1:setLayoutComponentEnabled(true)
txt_1:setName("txt_1")
txt_1:setTag(466)
txt_1:setCascadeColorEnabled(true)
txt_1:setCascadeOpacityEnabled(true)
txt_1:setPosition(50.0001, 19.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(txt_1)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.1900)
layout:setPercentWidth(0.4800)
layout:setPercentHeight(0.2400)
layout:setSize({width = 48.0000, height = 24.0000})
layout:setLeftMargin(26.0001)
layout:setRightMargin(25.9999)
layout:setTopMargin(69.0000)
layout:setBottomMargin(7.0000)
btn_rule:addChild(txt_1)

--Create btn_feedback
local btn_feedback = ccui.Layout:create()
btn_feedback:ignoreContentAdaptWithSize(false)
btn_feedback:setClippingEnabled(false)
btn_feedback:setBackGroundColorOpacity(102)
btn_feedback:setTouchEnabled(true);
btn_feedback:setLayoutComponentEnabled(true)
btn_feedback:setName("btn_feedback")
btn_feedback:setTag(792)
btn_feedback:setCascadeColorEnabled(true)
btn_feedback:setCascadeOpacityEnabled(true)
btn_feedback:setAnchorPoint(0.5000, 0.5000)
btn_feedback:setPosition(53.1318, 450.7819)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_feedback)
layout:setPositionPercentX(0.5012)
layout:setPositionPercentY(0.6989)
layout:setPercentWidth(0.9434)
layout:setPercentHeight(0.1550)
layout:setSize({width = 100.0000, height = 100.0000})
layout:setLeftMargin(3.1318)
layout:setRightMargin(2.8682)
layout:setTopMargin(144.2181)
layout:setBottomMargin(400.7819)
title_bg:addChild(btn_feedback)

--Create btn_bg2
local btn_bg2 = ccui.ImageView:create()
btn_bg2:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/feedback.plist")
btn_bg2:loadTexture("hall/feedback/icon_yjfk.png",1)
btn_bg2:setLayoutComponentEnabled(true)
btn_bg2:setName("btn_bg2")
btn_bg2:setTag(793)
btn_bg2:setCascadeColorEnabled(true)
btn_bg2:setCascadeOpacityEnabled(true)
btn_bg2:setPosition(50.5623, 66.4869)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_bg2)
layout:setPositionPercentX(0.5056)
layout:setPositionPercentY(0.6649)
layout:setPercentWidth(0.4200)
layout:setPercentHeight(0.4500)
layout:setSize({width = 42.0000, height = 45.0000})
layout:setLeftMargin(29.5623)
layout:setRightMargin(28.4377)
layout:setTopMargin(11.0131)
layout:setBottomMargin(43.9869)
btn_feedback:addChild(btn_bg2)

--Create txt_2
local txt_2 = ccui.Text:create()
txt_2:ignoreContentAdaptWithSize(true)
txt_2:setTextAreaSize({width = 0, height = 0})
txt_2:setFontSize(24)
txt_2:setString([[反馈]])
txt_2:setLayoutComponentEnabled(true)
txt_2:setName("txt_2")
txt_2:setTag(794)
txt_2:setCascadeColorEnabled(true)
txt_2:setCascadeOpacityEnabled(true)
txt_2:setPosition(50.0001, 19.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(txt_2)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.1900)
layout:setPercentWidth(0.4800)
layout:setPercentHeight(0.2400)
layout:setSize({width = 48.0000, height = 24.0000})
layout:setLeftMargin(26.0001)
layout:setRightMargin(25.9999)
layout:setTopMargin(69.0000)
layout:setBottomMargin(7.0000)
btn_feedback:addChild(txt_2)

--Create btn_service
local btn_service = ccui.Layout:create()
btn_service:ignoreContentAdaptWithSize(false)
btn_service:setClippingEnabled(false)
btn_service:setBackGroundColorOpacity(102)
btn_service:setTouchEnabled(true);
btn_service:setLayoutComponentEnabled(true)
btn_service:setName("btn_service")
btn_service:setTag(795)
btn_service:setCascadeColorEnabled(true)
btn_service:setCascadeOpacityEnabled(true)
btn_service:setAnchorPoint(0.5000, 0.5000)
btn_service:setPosition(54.8932, 334.0718)
btn_service:setColor({r = 98, g = 158, b = 226})
layout = ccui.LayoutComponent:bindLayoutComponent(btn_service)
layout:setPositionPercentX(0.5179)
layout:setPositionPercentY(0.5179)
layout:setPercentWidth(0.9434)
layout:setPercentHeight(0.1550)
layout:setSize({width = 100.0000, height = 100.0000})
layout:setLeftMargin(4.8932)
layout:setRightMargin(1.1068)
layout:setTopMargin(260.9282)
layout:setBottomMargin(284.0718)
title_bg:addChild(btn_service)

--Create btn_bg3
local btn_bg3 = ccui.ImageView:create()
btn_bg3:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
btn_bg3:loadTexture("hall/common/new_service.png",1)
btn_bg3:setLayoutComponentEnabled(true)
btn_bg3:setName("btn_bg3")
btn_bg3:setTag(796)
btn_bg3:setCascadeColorEnabled(true)
btn_bg3:setCascadeOpacityEnabled(true)
btn_bg3:setPosition(50.5623, 66.4869)
btn_bg3:setScaleX(0.8700)
btn_bg3:setScaleY(0.8700)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_bg3)
layout:setPositionPercentX(0.5056)
layout:setPositionPercentY(0.6649)
layout:setPercentWidth(0.6400)
layout:setPercentHeight(0.4000)
layout:setSize({width = 64.0000, height = 40.0000})
layout:setLeftMargin(18.5623)
layout:setRightMargin(17.4377)
layout:setTopMargin(13.5131)
layout:setBottomMargin(46.4869)
btn_service:addChild(btn_bg3)

--Create txt_3
local txt_3 = ccui.Text:create()
txt_3:ignoreContentAdaptWithSize(true)
txt_3:setTextAreaSize({width = 0, height = 0})
txt_3:setFontSize(24)
txt_3:setString([[客服]])
txt_3:setLayoutComponentEnabled(true)
txt_3:setName("txt_3")
txt_3:setTag(797)
txt_3:setCascadeColorEnabled(true)
txt_3:setCascadeOpacityEnabled(true)
txt_3:setPosition(49.9999, 29.4764)
layout = ccui.LayoutComponent:bindLayoutComponent(txt_3)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.2948)
layout:setPercentWidth(0.4800)
layout:setPercentHeight(0.2400)
layout:setSize({width = 48.0000, height = 24.0000})
layout:setLeftMargin(25.9999)
layout:setRightMargin(26.0001)
layout:setTopMargin(58.5236)
layout:setBottomMargin(17.4764)
btn_service:addChild(txt_3)

--Create Animation
result['animation'] = ccs.ActionTimeline:create()
  
result['animation']:setDuration(0)
result['animation']:setTimeSpeed(1.0000)
--Create Animation List

result['root'] = Node
return result;
end

return Result

