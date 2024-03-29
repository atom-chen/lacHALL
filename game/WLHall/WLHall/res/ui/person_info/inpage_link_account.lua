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

--Create main_panel
local main_panel = ccui.ListView:create()
main_panel:setItemsMargin(30)
main_panel:setDirection(1)
main_panel:setGravity(0)
main_panel:ignoreContentAdaptWithSize(false)
main_panel:setClippingEnabled(false)
main_panel:setBackGroundColorOpacity(102)
main_panel:setLayoutComponentEnabled(true)
main_panel:setName("main_panel")
main_panel:setTag(412)
main_panel:setCascadeColorEnabled(true)
main_panel:setCascadeOpacityEnabled(true)
layout = ccui.LayoutComponent:bindLayoutComponent(main_panel)
layout:setSize({width = 816.0000, height = 634.0000})
layout:setRightMargin(-816.0000)
layout:setTopMargin(-634.0000)
Node:addChild(main_panel)

--Create act_phone
local act_phone = ccui.Layout:create()
act_phone:ignoreContentAdaptWithSize(false)
act_phone:setClippingEnabled(false)
act_phone:setBackGroundColorOpacity(102)
act_phone:setTouchEnabled(true);
act_phone:setLayoutComponentEnabled(true)
act_phone:setName("act_phone")
act_phone:setTag(83)
act_phone:setCascadeColorEnabled(true)
act_phone:setCascadeOpacityEnabled(true)
act_phone:setPosition(0.0000, 424.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(act_phone)
layout:setPositionPercentY(0.6688)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(0.3312)
layout:setSize({width = 816.0000, height = 210.0000})
layout:setBottomMargin(424.0000)
main_panel:pushBackCustomItem(act_phone)

--Create panel_phone_tips
local panel_phone_tips = ccui.Layout:create()
panel_phone_tips:ignoreContentAdaptWithSize(false)
panel_phone_tips:setClippingEnabled(false)
panel_phone_tips:setBackGroundColorOpacity(102)
panel_phone_tips:setLayoutComponentEnabled(true)
panel_phone_tips:setName("panel_phone_tips")
panel_phone_tips:setTag(494)
panel_phone_tips:setCascadeColorEnabled(true)
panel_phone_tips:setCascadeOpacityEnabled(true)
layout = ccui.LayoutComponent:bindLayoutComponent(panel_phone_tips)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(1.0000)
layout:setSize({width = 816.0000, height = 210.0000})
act_phone:addChild(panel_phone_tips)

--Create tips_phone
local tips_phone = ccui.Layout:create()
tips_phone:ignoreContentAdaptWithSize(false)
tips_phone:setClippingEnabled(false)
tips_phone:setBackGroundColorOpacity(102)
tips_phone:setLayoutComponentEnabled(true)
tips_phone:setName("tips_phone")
tips_phone:setTag(420)
tips_phone:setCascadeColorEnabled(true)
tips_phone:setCascadeOpacityEnabled(true)
tips_phone:setAnchorPoint(0.0000, 1.0000)
tips_phone:setPosition(0.0000, 207.7189)
layout = ccui.LayoutComponent:bindLayoutComponent(tips_phone)
layout:setPositionPercentY(0.9891)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(0.9524)
layout:setSize({width = 816.0000, height = 200.0000})
layout:setTopMargin(2.2811)
layout:setBottomMargin(7.7189)
panel_phone_tips:addChild(tips_phone)

--Create txt_zeng
local txt_zeng = ccui.Text:create()
txt_zeng:ignoreContentAdaptWithSize(true)
txt_zeng:setTextAreaSize({width = 0, height = 0})
txt_zeng:setFontName("")
txt_zeng:setFontSize(28)
txt_zeng:setString([[激活成功后即送]])
txt_zeng:setLayoutComponentEnabled(true)
txt_zeng:setName("txt_zeng")
txt_zeng:setTag(421)
txt_zeng:setCascadeColorEnabled(true)
txt_zeng:setCascadeOpacityEnabled(true)
txt_zeng:setAnchorPoint(0.0000, 0.5000)
txt_zeng:setPosition(87.9700, 99.1100)
txt_zeng:setTextColor({r = 238, g = 140, b = 0})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_zeng)
layout:setPositionPercentX(0.1078)
layout:setPositionPercentY(0.4956)
layout:setPercentWidth(0.2402)
layout:setPercentHeight(0.1400)
layout:setSize({width = 196.0000, height = 28.0000})
layout:setLeftMargin(87.9700)
layout:setRightMargin(532.0300)
layout:setTopMargin(86.8900)
layout:setBottomMargin(85.1100)
tips_phone:addChild(txt_zeng)

--Create txt_tishi
local txt_tishi = ccui.Text:create()
txt_tishi:ignoreContentAdaptWithSize(true)
txt_tishi:setTextAreaSize({width = 0, height = 0})
txt_tishi:setFontName("")
txt_tishi:setFontSize(28)
txt_tishi:setString([[注:使用手机激活账号，可直接使用手机号登录。]])
txt_tishi:setLayoutComponentEnabled(true)
txt_tishi:setName("txt_tishi")
txt_tishi:setTag(423)
txt_tishi:setCascadeColorEnabled(true)
txt_tishi:setCascadeOpacityEnabled(true)
txt_tishi:setAnchorPoint(0.0000, 0.5000)
txt_tishi:setPosition(113.2300, -391.1400)
txt_tishi:setTextColor({r = 119, g = 119, b = 119})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_tishi)
layout:setPositionPercentX(0.1388)
layout:setPositionPercentY(-1.9557)
layout:setPercentWidth(0.7377)
layout:setPercentHeight(0.1400)
layout:setSize({width = 602.0000, height = 28.0000})
layout:setLeftMargin(113.2300)
layout:setRightMargin(100.7700)
layout:setTopMargin(577.1400)
layout:setBottomMargin(-405.1400)
tips_phone:addChild(txt_tishi)

--Create img_props_1
local img_props_1 = ccui.ImageView:create()
img_props_1:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/person_info.plist")
img_props_1:loadTexture("hall/person_info/tubiaokuang.png",1)
img_props_1:setScale9Enabled(true)
img_props_1:setCapInsets({x = 18, y = 18, width = 58, height = 60})
img_props_1:setLayoutComponentEnabled(true)
img_props_1:setName("img_props_1")
img_props_1:setTag(386)
img_props_1:setCascadeColorEnabled(true)
img_props_1:setCascadeOpacityEnabled(true)
img_props_1:setPosition(142.6600, 16.8100)
img_props_1:setScaleX(1.1000)
img_props_1:setScaleY(1.1000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_props_1)
layout:setPositionPercentX(0.1748)
layout:setPositionPercentY(0.0841)
layout:setPercentWidth(0.1164)
layout:setPercentHeight(0.4750)
layout:setSize({width = 95.0000, height = 95.0000})
layout:setLeftMargin(95.1600)
layout:setRightMargin(625.8400)
layout:setTopMargin(135.6900)
layout:setBottomMargin(-30.6900)
tips_phone:addChild(img_props_1)

--Create img_prop
local img_prop = ccui.ImageView:create()
img_prop:ignoreContentAdaptWithSize(false)
img_prop:loadTexture("common/prop/jindou_2.png",0)
img_prop:setLayoutComponentEnabled(true)
img_prop:setName("img_prop")
img_prop:setTag(387)
img_prop:setCascadeColorEnabled(true)
img_prop:setCascadeOpacityEnabled(true)
img_prop:setPosition(47.5000, 47.5000)
img_prop:setScaleX(0.8200)
img_prop:setScaleY(0.8200)
layout = ccui.LayoutComponent:bindLayoutComponent(img_prop)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(1.1789)
layout:setPercentHeight(1.1789)
layout:setSize({width = 112.0000, height = 112.0000})
layout:setLeftMargin(-8.5000)
layout:setRightMargin(-8.5000)
layout:setTopMargin(-8.5000)
layout:setBottomMargin(-8.5000)
img_props_1:addChild(img_prop)

--Create txt_count
local txt_count = ccui.TextBMFont:create()
txt_count:setFntFile("fonts/bag_props_num.fnt")
txt_count:setString([[3000]])
txt_count:setLayoutComponentEnabled(true)
txt_count:setName("txt_count")
txt_count:setTag(388)
txt_count:setCascadeColorEnabled(true)
txt_count:setCascadeOpacityEnabled(true)
txt_count:setAnchorPoint(1.0000, 0.5000)
txt_count:setPosition(87.3800, 15.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(txt_count)
layout:setPositionPercentX(0.9198)
layout:setPositionPercentY(0.1579)
layout:setPercentWidth(0.6737)
layout:setPercentHeight(0.2632)
layout:setSize({width = 64.0000, height = 25.0000})
layout:setLeftMargin(23.3800)
layout:setRightMargin(7.6200)
layout:setTopMargin(67.5000)
layout:setBottomMargin(2.5000)
img_props_1:addChild(txt_count)

--Create img_props_2
local img_props_2 = ccui.ImageView:create()
img_props_2:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/person_info.plist")
img_props_2:loadTexture("hall/person_info/tubiaokuang.png",1)
img_props_2:setScale9Enabled(true)
img_props_2:setCapInsets({x = 18, y = 18, width = 58, height = 60})
img_props_2:setLayoutComponentEnabled(true)
img_props_2:setName("img_props_2")
img_props_2:setTag(383)
img_props_2:setCascadeColorEnabled(true)
img_props_2:setCascadeOpacityEnabled(true)
img_props_2:setPosition(275.9877, 16.8100)
img_props_2:setScaleX(1.1000)
img_props_2:setScaleY(1.1000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_props_2)
layout:setPositionPercentX(0.3382)
layout:setPositionPercentY(0.0841)
layout:setPercentWidth(0.1164)
layout:setPercentHeight(0.4750)
layout:setSize({width = 95.0000, height = 95.0000})
layout:setLeftMargin(228.4877)
layout:setRightMargin(492.5123)
layout:setTopMargin(135.6900)
layout:setBottomMargin(-30.6900)
tips_phone:addChild(img_props_2)

--Create img_prop
local img_prop = ccui.ImageView:create()
img_prop:ignoreContentAdaptWithSize(false)
img_prop:loadTexture("common/prop/item_11.png",0)
img_prop:setLayoutComponentEnabled(true)
img_prop:setName("img_prop")
img_prop:setTag(384)
img_prop:setCascadeColorEnabled(true)
img_prop:setCascadeOpacityEnabled(true)
img_prop:setPosition(47.5000, 47.5000)
img_prop:setScaleX(0.8200)
img_prop:setScaleY(0.8200)
layout = ccui.LayoutComponent:bindLayoutComponent(img_prop)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(1.1789)
layout:setPercentHeight(1.1789)
layout:setSize({width = 112.0000, height = 112.0000})
layout:setLeftMargin(-8.5000)
layout:setRightMargin(-8.5000)
layout:setTopMargin(-8.5000)
layout:setBottomMargin(-8.5000)
img_props_2:addChild(img_prop)

--Create txt_count
local txt_count = ccui.TextBMFont:create()
txt_count:setFntFile("fonts/bag_props_num.fnt")
txt_count:setString([[5]])
txt_count:setLayoutComponentEnabled(true)
txt_count:setName("txt_count")
txt_count:setTag(385)
txt_count:setCascadeColorEnabled(true)
txt_count:setCascadeOpacityEnabled(true)
txt_count:setAnchorPoint(1.0000, 0.5000)
txt_count:setPosition(87.3800, 15.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(txt_count)
layout:setPositionPercentX(0.9198)
layout:setPositionPercentY(0.1579)
layout:setPercentWidth(0.1684)
layout:setPercentHeight(0.2632)
layout:setSize({width = 16.0000, height = 25.0000})
layout:setLeftMargin(71.3800)
layout:setRightMargin(7.6200)
layout:setTopMargin(67.5000)
layout:setBottomMargin(2.5000)
img_props_2:addChild(txt_count)

--Create img_props_3
local img_props_3 = ccui.ImageView:create()
img_props_3:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/person_info.plist")
img_props_3:loadTexture("hall/person_info/tubiaokuang.png",1)
img_props_3:setScale9Enabled(true)
img_props_3:setCapInsets({x = 18, y = 18, width = 58, height = 60})
img_props_3:setLayoutComponentEnabled(true)
img_props_3:setName("img_props_3")
img_props_3:setTag(380)
img_props_3:setCascadeColorEnabled(true)
img_props_3:setCascadeOpacityEnabled(true)
img_props_3:setPosition(408.7905, 16.8100)
img_props_3:setScaleX(1.1000)
img_props_3:setScaleY(1.1000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_props_3)
layout:setPositionPercentX(0.5010)
layout:setPositionPercentY(0.0841)
layout:setPercentWidth(0.1164)
layout:setPercentHeight(0.4750)
layout:setSize({width = 95.0000, height = 95.0000})
layout:setLeftMargin(361.2905)
layout:setRightMargin(359.7095)
layout:setTopMargin(135.6900)
layout:setBottomMargin(-30.6900)
tips_phone:addChild(img_props_3)

--Create img_prop
local img_prop = ccui.ImageView:create()
img_prop:ignoreContentAdaptWithSize(false)
img_prop:loadTexture("common/prop/item_16.png",0)
img_prop:setLayoutComponentEnabled(true)
img_prop:setName("img_prop")
img_prop:setTag(381)
img_prop:setCascadeColorEnabled(true)
img_prop:setCascadeOpacityEnabled(true)
img_prop:setPosition(47.5000, 47.5000)
img_prop:setScaleX(0.8200)
img_prop:setScaleY(0.8200)
layout = ccui.LayoutComponent:bindLayoutComponent(img_prop)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(1.1789)
layout:setPercentHeight(1.1789)
layout:setSize({width = 112.0000, height = 112.0000})
layout:setLeftMargin(-8.5000)
layout:setRightMargin(-8.5000)
layout:setTopMargin(-8.5000)
layout:setBottomMargin(-8.5000)
img_props_3:addChild(img_prop)

--Create txt_count
local txt_count = ccui.TextBMFont:create()
txt_count:setFntFile("fonts/bag_props_num.fnt")
txt_count:setString([[5]])
txt_count:setLayoutComponentEnabled(true)
txt_count:setName("txt_count")
txt_count:setTag(382)
txt_count:setCascadeColorEnabled(true)
txt_count:setCascadeOpacityEnabled(true)
txt_count:setAnchorPoint(1.0000, 0.5000)
txt_count:setPosition(87.3800, 15.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(txt_count)
layout:setPositionPercentX(0.9198)
layout:setPositionPercentY(0.1579)
layout:setPercentWidth(0.1684)
layout:setPercentHeight(0.2632)
layout:setSize({width = 16.0000, height = 25.0000})
layout:setLeftMargin(71.3800)
layout:setRightMargin(7.6200)
layout:setTopMargin(67.5000)
layout:setBottomMargin(2.5000)
img_props_3:addChild(txt_count)

--Create img_props_4
local img_props_4 = ccui.ImageView:create()
img_props_4:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/person_info.plist")
img_props_4:loadTexture("hall/person_info/tubiaokuang.png",1)
img_props_4:setScale9Enabled(true)
img_props_4:setCapInsets({x = 18, y = 18, width = 58, height = 60})
img_props_4:setLayoutComponentEnabled(true)
img_props_4:setName("img_props_4")
img_props_4:setTag(377)
img_props_4:setCascadeColorEnabled(true)
img_props_4:setCascadeOpacityEnabled(true)
img_props_4:setPosition(542.3408, 16.8100)
img_props_4:setScaleX(1.1000)
img_props_4:setScaleY(1.1000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_props_4)
layout:setPositionPercentX(0.6646)
layout:setPositionPercentY(0.0841)
layout:setPercentWidth(0.1164)
layout:setPercentHeight(0.4750)
layout:setSize({width = 95.0000, height = 95.0000})
layout:setLeftMargin(494.8408)
layout:setRightMargin(226.1592)
layout:setTopMargin(135.6900)
layout:setBottomMargin(-30.6900)
tips_phone:addChild(img_props_4)

--Create img_prop
local img_prop = ccui.ImageView:create()
img_prop:ignoreContentAdaptWithSize(false)
img_prop:loadTexture("common/prop/item_12.png",0)
img_prop:setLayoutComponentEnabled(true)
img_prop:setName("img_prop")
img_prop:setTag(378)
img_prop:setCascadeColorEnabled(true)
img_prop:setCascadeOpacityEnabled(true)
img_prop:setPosition(47.5000, 47.5000)
img_prop:setScaleX(0.8200)
img_prop:setScaleY(0.8200)
layout = ccui.LayoutComponent:bindLayoutComponent(img_prop)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(1.1789)
layout:setPercentHeight(1.1789)
layout:setSize({width = 112.0000, height = 112.0000})
layout:setLeftMargin(-8.5000)
layout:setRightMargin(-8.5000)
layout:setTopMargin(-8.5000)
layout:setBottomMargin(-8.5000)
img_props_4:addChild(img_prop)

--Create txt_count
local txt_count = ccui.TextBMFont:create()
txt_count:setFntFile("fonts/bag_props_num.fnt")
txt_count:setString([[5]])
txt_count:setLayoutComponentEnabled(true)
txt_count:setName("txt_count")
txt_count:setTag(379)
txt_count:setCascadeColorEnabled(true)
txt_count:setCascadeOpacityEnabled(true)
txt_count:setAnchorPoint(1.0000, 0.5000)
txt_count:setPosition(87.3800, 15.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(txt_count)
layout:setPositionPercentX(0.9198)
layout:setPositionPercentY(0.1579)
layout:setPercentWidth(0.1684)
layout:setPercentHeight(0.2632)
layout:setSize({width = 16.0000, height = 25.0000})
layout:setLeftMargin(71.3800)
layout:setRightMargin(7.6200)
layout:setTopMargin(67.5000)
layout:setBottomMargin(2.5000)
img_props_4:addChild(txt_count)

--Create panel_activation
local panel_activation = ccui.Layout:create()
panel_activation:ignoreContentAdaptWithSize(false)
panel_activation:setClippingEnabled(true)
panel_activation:setBackGroundColorOpacity(102)
panel_activation:setTouchEnabled(true);
panel_activation:setLayoutComponentEnabled(true)
panel_activation:setName("panel_activation")
panel_activation:setTag(434)
panel_activation:setCascadeColorEnabled(true)
panel_activation:setCascadeOpacityEnabled(true)
panel_activation:setPosition(0.6720, -424.1237)
layout = ccui.LayoutComponent:bindLayoutComponent(panel_activation)
layout:setPositionPercentX(0.0008)
layout:setPositionPercentY(-2.0196)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(3.0190)
layout:setSize({width = 816.0000, height = 634.0000})
layout:setLeftMargin(0.6720)
layout:setRightMargin(-0.6720)
layout:setTopMargin(0.1237)
layout:setBottomMargin(-424.1237)
act_phone:addChild(panel_activation)

--Create Text_90
local Text_90 = ccui.Text:create()
Text_90:ignoreContentAdaptWithSize(true)
Text_90:setTextAreaSize({width = 0, height = 0})
Text_90:setFontName("")
Text_90:setFontSize(30)
Text_90:setString([[手机号码]])
Text_90:setLayoutComponentEnabled(true)
Text_90:setName("Text_90")
Text_90:setTag(438)
Text_90:setCascadeColorEnabled(true)
Text_90:setCascadeOpacityEnabled(true)
Text_90:setAnchorPoint(0.0000, 0.5000)
Text_90:setPosition(86.4161, 337.9400)
Text_90:setTextColor({r = 51, g = 51, b = 51})
layout = ccui.LayoutComponent:bindLayoutComponent(Text_90)
layout:setPositionPercentX(0.1059)
layout:setPositionPercentY(0.5330)
layout:setPercentWidth(0.1471)
layout:setPercentHeight(0.0473)
layout:setSize({width = 120.0000, height = 30.0000})
layout:setLeftMargin(86.4161)
layout:setRightMargin(609.5839)
layout:setTopMargin(281.0600)
layout:setBottomMargin(322.9400)
panel_activation:addChild(Text_90)

--Create txt_phone_phoneid
local txt_phone_phoneid = ccui.TextField:create()
txt_phone_phoneid:ignoreContentAdaptWithSize(false)
tolua.cast(txt_phone_phoneid:getVirtualRenderer(), "cc.Label"):setLineBreakWithoutSpace(true)
txt_phone_phoneid:setFontSize(26)
txt_phone_phoneid:setPlaceHolder("激活后，该手机号码将作为登录账号")
txt_phone_phoneid:setString([[]])
txt_phone_phoneid:setMaxLength(10)
txt_phone_phoneid:setLayoutComponentEnabled(true)
txt_phone_phoneid:setName("txt_phone_phoneid")
txt_phone_phoneid:setTag(261)
txt_phone_phoneid:setCascadeColorEnabled(true)
txt_phone_phoneid:setCascadeOpacityEnabled(true)
txt_phone_phoneid:setAnchorPoint(0.0000, 0.5000)
txt_phone_phoneid:setPosition(250.6800, 343.9500)
txt_phone_phoneid:setColor({r = 184, g = 184, b = 184})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_phone_phoneid)
layout:setPositionPercentX(0.3072)
layout:setPositionPercentY(0.5425)
layout:setPercentWidth(0.5098)
layout:setPercentHeight(0.0410)
layout:setSize({width = 416.0000, height = 26.0000})
layout:setLeftMargin(250.6800)
layout:setRightMargin(149.3200)
layout:setTopMargin(277.0500)
layout:setBottomMargin(330.9500)
panel_activation:addChild(txt_phone_phoneid)

--Create line_1
local line_1 = ccui.ImageView:create()
line_1:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
line_1:loadTexture("hall/common/new_line.png",1)
line_1:setScale9Enabled(true)
line_1:setCapInsets({x = 2, y = 0, width = 1, height = 1})
line_1:setLayoutComponentEnabled(true)
line_1:setName("line_1")
line_1:setTag(436)
line_1:setCascadeColorEnabled(true)
line_1:setCascadeOpacityEnabled(true)
line_1:setAnchorPoint(0.0000, 0.5000)
line_1:setPosition(219.0000, 325.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(line_1)
layout:setPositionPercentX(0.2684)
layout:setPositionPercentY(0.5126)
layout:setPercentWidth(0.6275)
layout:setPercentHeight(0.0032)
layout:setSize({width = 512.0000, height = 2.0000})
layout:setLeftMargin(219.0000)
layout:setRightMargin(85.0000)
layout:setTopMargin(308.0000)
layout:setBottomMargin(324.0000)
panel_activation:addChild(line_1)

--Create Text_91
local Text_91 = ccui.Text:create()
Text_91:ignoreContentAdaptWithSize(true)
Text_91:setTextAreaSize({width = 0, height = 0})
Text_91:setFontName("")
Text_91:setFontSize(30)
Text_91:setString([[登录密码]])
Text_91:setLayoutComponentEnabled(true)
Text_91:setName("Text_91")
Text_91:setTag(439)
Text_91:setCascadeColorEnabled(true)
Text_91:setCascadeOpacityEnabled(true)
Text_91:setAnchorPoint(0.0000, 0.5000)
Text_91:setPosition(86.4200, 264.6200)
Text_91:setTextColor({r = 51, g = 51, b = 51})
layout = ccui.LayoutComponent:bindLayoutComponent(Text_91)
layout:setPositionPercentX(0.1059)
layout:setPositionPercentY(0.4174)
layout:setPercentWidth(0.1471)
layout:setPercentHeight(0.0473)
layout:setSize({width = 120.0000, height = 30.0000})
layout:setLeftMargin(86.4200)
layout:setRightMargin(609.5800)
layout:setTopMargin(354.3800)
layout:setBottomMargin(249.6200)
panel_activation:addChild(Text_91)

--Create txt_phone_pwd
local txt_phone_pwd = ccui.TextField:create()
txt_phone_pwd:ignoreContentAdaptWithSize(false)
tolua.cast(txt_phone_pwd:getVirtualRenderer(), "cc.Label"):setLineBreakWithoutSpace(true)
txt_phone_pwd:setFontSize(26)
txt_phone_pwd:setPlaceHolder("请正确输入，用于帐号登录")
txt_phone_pwd:setString([[]])
txt_phone_pwd:setMaxLength(10)
txt_phone_pwd:setLayoutComponentEnabled(true)
txt_phone_pwd:setName("txt_phone_pwd")
txt_phone_pwd:setTag(262)
txt_phone_pwd:setCascadeColorEnabled(true)
txt_phone_pwd:setCascadeOpacityEnabled(true)
txt_phone_pwd:setAnchorPoint(0.0000, 0.5000)
txt_phone_pwd:setPosition(250.6800, 265.0000)
txt_phone_pwd:setColor({r = 184, g = 184, b = 184})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_phone_pwd)
layout:setPositionPercentX(0.3072)
layout:setPositionPercentY(0.4180)
layout:setPercentWidth(0.3824)
layout:setPercentHeight(0.0410)
layout:setSize({width = 312.0000, height = 26.0000})
layout:setLeftMargin(250.6800)
layout:setRightMargin(253.3200)
layout:setTopMargin(356.0000)
layout:setBottomMargin(252.0000)
panel_activation:addChild(txt_phone_pwd)

--Create line_2
local line_2 = ccui.ImageView:create()
line_2:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
line_2:loadTexture("hall/common/new_line.png",1)
line_2:setScale9Enabled(true)
line_2:setCapInsets({x = 2, y = 0, width = 1, height = 1})
line_2:setLayoutComponentEnabled(true)
line_2:setName("line_2")
line_2:setTag(435)
line_2:setCascadeColorEnabled(true)
line_2:setCascadeOpacityEnabled(true)
line_2:setPosition(472.0000, 250.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(line_2)
layout:setPositionPercentX(0.5784)
layout:setPositionPercentY(0.3943)
layout:setPercentWidth(0.6275)
layout:setPercentHeight(0.0032)
layout:setSize({width = 512.0000, height = 2.0000})
layout:setLeftMargin(216.0000)
layout:setRightMargin(88.0000)
layout:setTopMargin(383.0000)
layout:setBottomMargin(249.0000)
panel_activation:addChild(line_2)

--Create Text_92
local Text_92 = ccui.Text:create()
Text_92:ignoreContentAdaptWithSize(true)
Text_92:setTextAreaSize({width = 0, height = 0})
Text_92:setFontName("")
Text_92:setFontSize(30)
Text_92:setString([[验  证  码]])
Text_92:setLayoutComponentEnabled(true)
Text_92:setName("Text_92")
Text_92:setTag(440)
Text_92:setCascadeColorEnabled(true)
Text_92:setCascadeOpacityEnabled(true)
Text_92:setAnchorPoint(0.0000, 0.5000)
Text_92:setPosition(86.4200, 189.0000)
Text_92:setTextColor({r = 51, g = 51, b = 51})
layout = ccui.LayoutComponent:bindLayoutComponent(Text_92)
layout:setPositionPercentX(0.1059)
layout:setPositionPercentY(0.2981)
layout:setPercentWidth(0.1838)
layout:setPercentHeight(0.0473)
layout:setSize({width = 150.0000, height = 30.0000})
layout:setLeftMargin(86.4200)
layout:setRightMargin(579.5800)
layout:setTopMargin(430.0000)
layout:setBottomMargin(174.0000)
panel_activation:addChild(Text_92)

--Create txt_phone_code
local txt_phone_code = ccui.TextField:create()
txt_phone_code:ignoreContentAdaptWithSize(false)
tolua.cast(txt_phone_code:getVirtualRenderer(), "cc.Label"):setLineBreakWithoutSpace(true)
txt_phone_code:setFontSize(26)
txt_phone_code:setPlaceHolder("4位数字")
txt_phone_code:setString([[]])
txt_phone_code:setMaxLength(10)
txt_phone_code:setLayoutComponentEnabled(true)
txt_phone_code:setName("txt_phone_code")
txt_phone_code:setTag(264)
txt_phone_code:setCascadeColorEnabled(true)
txt_phone_code:setCascadeOpacityEnabled(true)
txt_phone_code:setAnchorPoint(0.0000, 0.5000)
txt_phone_code:setPosition(250.6800, 190.5000)
txt_phone_code:setColor({r = 184, g = 184, b = 184})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_phone_code)
layout:setPositionPercentX(0.3072)
layout:setPositionPercentY(0.3005)
layout:setPercentWidth(0.1115)
layout:setPercentHeight(0.0410)
layout:setSize({width = 91.0000, height = 26.0000})
layout:setLeftMargin(250.6800)
layout:setRightMargin(474.3200)
layout:setTopMargin(430.5000)
layout:setBottomMargin(177.5000)
panel_activation:addChild(txt_phone_code)

--Create btn_act_phone_code
local btn_act_phone_code = ccui.Layout:create()
btn_act_phone_code:ignoreContentAdaptWithSize(false)
btn_act_phone_code:setClippingEnabled(false)
btn_act_phone_code:setBackGroundColorOpacity(102)
btn_act_phone_code:setTouchEnabled(true);
btn_act_phone_code:setLayoutComponentEnabled(true)
btn_act_phone_code:setName("btn_act_phone_code")
btn_act_phone_code:setTag(487)
btn_act_phone_code:setCascadeColorEnabled(true)
btn_act_phone_code:setCascadeOpacityEnabled(true)
btn_act_phone_code:setAnchorPoint(0.5000, 0.5000)
btn_act_phone_code:setPosition(655.6600, 193.8100)
btn_act_phone_code:setColor({r = 22, g = 146, b = 206})
layout = ccui.LayoutComponent:bindLayoutComponent(btn_act_phone_code)
layout:setPositionPercentX(0.8035)
layout:setPositionPercentY(0.3057)
layout:setPercentWidth(0.3064)
layout:setPercentHeight(0.1420)
layout:setSize({width = 250.0000, height = 90.0000})
layout:setLeftMargin(530.6600)
layout:setRightMargin(35.3400)
layout:setTopMargin(395.1900)
layout:setBottomMargin(148.8100)
panel_activation:addChild(btn_act_phone_code)

--Create Text_7
local Text_7 = ccui.Text:create()
Text_7:ignoreContentAdaptWithSize(true)
Text_7:setTextAreaSize({width = 0, height = 0})
Text_7:setFontName("")
Text_7:setFontSize(28)
Text_7:setString([[获取验证码]])
Text_7:setLayoutComponentEnabled(true)
Text_7:setName("Text_7")
Text_7:setTag(488)
Text_7:setCascadeColorEnabled(true)
Text_7:setCascadeOpacityEnabled(true)
Text_7:setPosition(75.0000, 45.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(Text_7)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.3000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.5600)
layout:setPercentHeight(0.3111)
layout:setSize({width = 140.0000, height = 28.0000})
layout:setLeftMargin(5.0000)
layout:setRightMargin(105.0000)
layout:setTopMargin(31.0000)
layout:setBottomMargin(31.0000)
btn_act_phone_code:addChild(Text_7)

--Create txt_phone_code_td
local txt_phone_code_td = ccui.Text:create()
txt_phone_code_td:ignoreContentAdaptWithSize(true)
txt_phone_code_td:setTextAreaSize({width = 0, height = 0})
txt_phone_code_td:setFontName("")
txt_phone_code_td:setFontSize(26)
txt_phone_code_td:setString([[60]])
txt_phone_code_td:setLayoutComponentEnabled(true)
txt_phone_code_td:setName("txt_phone_code_td")
txt_phone_code_td:setTag(263)
txt_phone_code_td:setCascadeColorEnabled(true)
txt_phone_code_td:setCascadeOpacityEnabled(true)
txt_phone_code_td:setVisible(false)
txt_phone_code_td:setAnchorPoint(0.0000, 0.5000)
txt_phone_code_td:setPosition(695.0019, 193.8100)
txt_phone_code_td:setTextColor({r = 184, g = 184, b = 184})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_phone_code_td)
layout:setPositionPercentX(0.8517)
layout:setPositionPercentY(0.3057)
layout:setPercentWidth(0.0319)
layout:setPercentHeight(0.0410)
layout:setSize({width = 26.0000, height = 26.0000})
layout:setLeftMargin(695.0019)
layout:setRightMargin(94.9981)
layout:setTopMargin(427.1900)
layout:setBottomMargin(180.8100)
panel_activation:addChild(txt_phone_code_td)

--Create line_3
local line_3 = ccui.ImageView:create()
line_3:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
line_3:loadTexture("hall/common/new_line.png",1)
line_3:setScale9Enabled(true)
line_3:setCapInsets({x = 2, y = 0, width = 1, height = 1})
line_3:setLayoutComponentEnabled(true)
line_3:setName("line_3")
line_3:setTag(437)
line_3:setCascadeColorEnabled(true)
line_3:setCascadeOpacityEnabled(true)
line_3:setPosition(471.0000, 173.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(line_3)
layout:setPositionPercentX(0.5772)
layout:setPositionPercentY(0.2729)
layout:setPercentWidth(0.6250)
layout:setPercentHeight(0.0032)
layout:setSize({width = 510.0000, height = 2.0000})
layout:setLeftMargin(216.0000)
layout:setRightMargin(90.0000)
layout:setTopMargin(460.0000)
layout:setBottomMargin(172.0000)
panel_activation:addChild(line_3)

--Create btn_phone_activation
local btn_phone_activation = ccui.Layout:create()
btn_phone_activation:ignoreContentAdaptWithSize(false)
btn_phone_activation:setClippingEnabled(false)
btn_phone_activation:setBackGroundImageCapInsets({x = -4, y = -3, width = 10, height = 6})
btn_phone_activation:setBackGroundColorOpacity(102)
btn_phone_activation:setBackGroundImageScale9Enabled(true)
btn_phone_activation:setTouchEnabled(true);
btn_phone_activation:setLayoutComponentEnabled(true)
btn_phone_activation:setName("btn_phone_activation")
btn_phone_activation:setTag(2225)
btn_phone_activation:setCascadeColorEnabled(true)
btn_phone_activation:setCascadeOpacityEnabled(true)
btn_phone_activation:setAnchorPoint(0.5000, 0.5000)
btn_phone_activation:setPosition(408.0000, 111.8900)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_phone_activation)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.1765)
layout:setPercentWidth(0.3064)
layout:setPercentHeight(0.0946)
layout:setSize({width = 250.0000, height = 60.0000})
layout:setLeftMargin(283.0000)
layout:setRightMargin(283.0000)
layout:setTopMargin(492.1100)
layout:setBottomMargin(81.8900)
panel_activation:addChild(btn_phone_activation)

--Create btn_bg
local btn_bg = ccui.ImageView:create()
btn_bg:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
btn_bg:loadTexture("hall/common/new_btn_noangle.png",1)
btn_bg:setScale9Enabled(true)
btn_bg:setCapInsets({x = 8, y = 8, width = 2, height = 2})
btn_bg:setLayoutComponentEnabled(true)
btn_bg:setName("btn_bg")
btn_bg:setTag(295)
btn_bg:setCascadeColorEnabled(true)
btn_bg:setCascadeOpacityEnabled(true)
btn_bg:setPosition(125.0000, 30.0000)
btn_bg:setColor({r = 38, g = 155, b = 88})
layout = ccui.LayoutComponent:bindLayoutComponent(btn_bg)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(1.0000)
layout:setSize({width = 250.0000, height = 60.0000})
btn_phone_activation:addChild(btn_bg)

--Create Text_21
local Text_21 = ccui.Text:create()
Text_21:ignoreContentAdaptWithSize(true)
Text_21:setTextAreaSize({width = 0, height = 0})
Text_21:setFontName("")
Text_21:setFontSize(32)
Text_21:setString([[激活]])
Text_21:setLayoutComponentEnabled(true)
Text_21:setName("Text_21")
Text_21:setTag(2226)
Text_21:setCascadeColorEnabled(true)
Text_21:setCascadeOpacityEnabled(true)
Text_21:setPosition(125.0000, 30.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(Text_21)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.2560)
layout:setPercentHeight(0.5500)
layout:setSize({width = 64.0000, height = 33.0000})
layout:setLeftMargin(93.0000)
layout:setRightMargin(93.0000)
layout:setTopMargin(13.5000)
layout:setBottomMargin(13.5000)
btn_phone_activation:addChild(Text_21)

--Create Animation
result['animation'] = ccs.ActionTimeline:create()
  
result['animation']:setDuration(0)
result['animation']:setTimeSpeed(1.0000)
--Create Animation List

result['root'] = Node
return result;
end

return Result

