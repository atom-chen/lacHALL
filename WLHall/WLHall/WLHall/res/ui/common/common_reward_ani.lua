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
panel_bg:setBackGroundColorType(1)
panel_bg:setBackGroundColor({r = 0, g = 0, b = 0})
panel_bg:setBackGroundColorOpacity(229)
panel_bg:setTouchEnabled(true);
panel_bg:setLayoutComponentEnabled(true)
panel_bg:setName("panel_bg")
panel_bg:setTag(60)
panel_bg:setCascadeColorEnabled(true)
panel_bg:setCascadeOpacityEnabled(true)
panel_bg:setAnchorPoint(0.5000, 0.5000)
layout = ccui.LayoutComponent:bindLayoutComponent(panel_bg)
layout:setSize({width = 1280.0000, height = 720.0000})
layout:setLeftMargin(-640.0000)
layout:setRightMargin(-640.0000)
layout:setTopMargin(-360.0000)
layout:setBottomMargin(-360.0000)
Node:addChild(panel_bg)

--Create nd_ani
local nd_ani=cc.Node:create()
nd_ani:setName("nd_ani")
nd_ani:setTag(27)
nd_ani:setCascadeColorEnabled(true)
nd_ani:setCascadeOpacityEnabled(true)
layout = ccui.LayoutComponent:bindLayoutComponent(nd_ani)
Node:addChild(nd_ani)

--Create bjglow
local bjglow=cc.Node:create()
bjglow:setName("bjglow")
bjglow:setTag(32)
bjglow:setCascadeColorEnabled(true)
bjglow:setCascadeOpacityEnabled(true)
bjglow:setOpacity(0)
layout = ccui.LayoutComponent:bindLayoutComponent(bjglow)
nd_ani:addChild(bjglow)

--Create glow1_4
local glow1_4 = cc.Sprite:create("hall/common/glow1.png")
glow1_4:setName("glow1_4")
glow1_4:setTag(33)
glow1_4:setCascadeColorEnabled(true)
glow1_4:setCascadeOpacityEnabled(true)
layout = ccui.LayoutComponent:bindLayoutComponent(glow1_4)
layout:setSize({width = 516.0000, height = 504.0000})
layout:setLeftMargin(-258.0000)
layout:setRightMargin(-258.0000)
layout:setTopMargin(-252.0000)
layout:setBottomMargin(-252.0000)
glow1_4:setBlendFunc({src = 1, dst = 771})
bjglow:addChild(glow1_4)

--Create glow2_5
local glow2_5 = cc.Sprite:create("hall/common/glow2.png")
glow2_5:setName("glow2_5")
glow2_5:setTag(34)
glow2_5:setCascadeColorEnabled(true)
glow2_5:setCascadeOpacityEnabled(true)
layout = ccui.LayoutComponent:bindLayoutComponent(glow2_5)
layout:setSize({width = 1272.0000, height = 712.0000})
layout:setLeftMargin(-636.0000)
layout:setRightMargin(-636.0000)
layout:setTopMargin(-356.0000)
layout:setBottomMargin(-356.0000)
glow2_5:setBlendFunc({src = 1, dst = 771})
bjglow:addChild(glow2_5)

--Create glow3_6
local glow3_6 = cc.Sprite:create("hall/common/glow3.png")
glow3_6:setName("glow3_6")
glow3_6:setTag(35)
glow3_6:setCascadeColorEnabled(true)
glow3_6:setCascadeOpacityEnabled(true)
layout = ccui.LayoutComponent:bindLayoutComponent(glow3_6)
layout:setSize({width = 319.0000, height = 319.0000})
layout:setLeftMargin(-159.5000)
layout:setRightMargin(-159.5000)
layout:setTopMargin(-159.5000)
layout:setBottomMargin(-159.5000)
glow3_6:setBlendFunc({src = 1, dst = 771})
bjglow:addChild(glow3_6)

--Create nd_award
local nd_award=cc.Node:create()
nd_award:setName("nd_award")
nd_award:setTag(36)
nd_award:setCascadeColorEnabled(true)
nd_award:setCascadeOpacityEnabled(true)
nd_award:setScaleX(0.0010)
nd_award:setScaleY(0.0010)
layout = ccui.LayoutComponent:bindLayoutComponent(nd_award)
nd_ani:addChild(nd_award)

--Create nd_items
local nd_items = ccui.Layout:create()
nd_items:ignoreContentAdaptWithSize(false)
nd_items:setClippingEnabled(false)
nd_items:setBackGroundColorOpacity(102)
nd_items:setTouchEnabled(true);
nd_items:setLayoutComponentEnabled(true)
nd_items:setName("nd_items")
nd_items:setTag(63)
nd_items:setCascadeColorEnabled(true)
nd_items:setCascadeOpacityEnabled(true)
nd_items:setPosition(0.0000, 20.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(nd_items)
layout:setTopMargin(-20.0000)
layout:setBottomMargin(20.0000)
nd_award:addChild(nd_items)

--Create icon_title
local icon_title = ccui.ImageView:create()
icon_title:ignoreContentAdaptWithSize(false)
icon_title:loadTexture("hall/common/img_gxhd.png",0)
icon_title:setLayoutComponentEnabled(true)
icon_title:setName("icon_title")
icon_title:setTag(38)
icon_title:setCascadeColorEnabled(true)
icon_title:setCascadeOpacityEnabled(true)
icon_title:setPosition(0.0001, 185.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(icon_title)
layout:setSize({width = 469.0000, height = 93.0000})
layout:setLeftMargin(-234.4999)
layout:setRightMargin(-234.5001)
layout:setTopMargin(-231.5000)
layout:setBottomMargin(138.5000)
nd_award:addChild(icon_title)

--Create txt_more_tips
local txt_more_tips = ccui.Text:create()
txt_more_tips:ignoreContentAdaptWithSize(true)
txt_more_tips:setTextAreaSize({width = 0, height = 0})
txt_more_tips:setFontSize(26)
txt_more_tips:setString([[本日还可获得 0 次]])
txt_more_tips:setLayoutComponentEnabled(true)
txt_more_tips:setName("txt_more_tips")
txt_more_tips:setTag(26)
txt_more_tips:setCascadeColorEnabled(true)
txt_more_tips:setCascadeOpacityEnabled(true)
txt_more_tips:setVisible(false)
txt_more_tips:setPosition(0.0000, 109.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(txt_more_tips)
layout:setSize({width = 221.0000, height = 26.0000})
layout:setLeftMargin(-110.5000)
layout:setRightMargin(-110.5000)
layout:setTopMargin(-122.0000)
layout:setBottomMargin(96.0000)
nd_award:addChild(txt_more_tips)

--Create btn_vip_tips
local btn_vip_tips = ccui.Layout:create()
btn_vip_tips:ignoreContentAdaptWithSize(false)
btn_vip_tips:setClippingEnabled(false)
btn_vip_tips:setTouchEnabled(true);
btn_vip_tips:setLayoutComponentEnabled(true)
btn_vip_tips:setName("btn_vip_tips")
btn_vip_tips:setTag(21)
btn_vip_tips:setCascadeColorEnabled(true)
btn_vip_tips:setCascadeOpacityEnabled(true)
btn_vip_tips:setAnchorPoint(0.5000, 0.5000)
btn_vip_tips:setPosition(0.0000, -175.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_vip_tips)
layout:setSize({width = 195.0000, height = 50.0000})
layout:setLeftMargin(-97.5000)
layout:setRightMargin(-97.5000)
layout:setTopMargin(150.0000)
layout:setBottomMargin(-200.0000)
nd_award:addChild(btn_vip_tips)

--Create txt_vip_tips
local txt_vip_tips = ccui.Text:create()
txt_vip_tips:ignoreContentAdaptWithSize(true)
txt_vip_tips:setTextAreaSize({width = 0, height = 0})
txt_vip_tips:setFontSize(24)
txt_vip_tips:setString([[VIP可获得更多]])
txt_vip_tips:setLayoutComponentEnabled(true)
txt_vip_tips:setName("txt_vip_tips")
txt_vip_tips:setTag(41)
txt_vip_tips:setCascadeColorEnabled(true)
txt_vip_tips:setCascadeOpacityEnabled(true)
txt_vip_tips:setPosition(97.5000, 25.0000)
txt_vip_tips:setTextColor({r = 255, g = 239, b = 182})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_vip_tips)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.8000)
layout:setPercentHeight(0.4800)
layout:setSize({width = 156.0000, height = 24.0000})
layout:setLeftMargin(19.5000)
layout:setRightMargin(19.5000)
layout:setTopMargin(13.0000)
layout:setBottomMargin(13.0000)
btn_vip_tips:addChild(txt_vip_tips)

--Create img_line
local img_line = ccui.Layout:create()
img_line:ignoreContentAdaptWithSize(false)
img_line:setClippingEnabled(false)
img_line:setBackGroundColorType(1)
img_line:setBackGroundColor({r = 255, g = 239, b = 182})
img_line:setTouchEnabled(true);
img_line:setLayoutComponentEnabled(true)
img_line:setName("img_line")
img_line:setTag(42)
img_line:setCascadeColorEnabled(true)
img_line:setCascadeOpacityEnabled(true)
img_line:setAnchorPoint(0.5000, 0.5000)
img_line:setPosition(97.5000, 11.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_line)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.2200)
layout:setPercentWidth(0.8359)
layout:setPercentHeight(0.0200)
layout:setSize({width = 163.0000, height = 1.0000})
layout:setLeftMargin(16.0000)
layout:setRightMargin(16.0000)
layout:setTopMargin(38.5000)
layout:setBottomMargin(10.5000)
btn_vip_tips:addChild(img_line)

--Create btn_share
local btn_share = ccui.Button:create()
btn_share:ignoreContentAdaptWithSize(false)
btn_share:loadTextureNormal("hall/common/common_reward_btn.png",0)
btn_share:loadTexturePressed("hall/common/common_reward_btn.png",0)
btn_share:loadTextureDisabled("hall/common/common_reward_btn.png",0)
btn_share:setTitleFontSize(14)
btn_share:setTitleColor({r = 65, g = 65, b = 70})
btn_share:setScale9Enabled(true)
btn_share:setCapInsets({x = 100, y = 35, width = 70, height = 1})
btn_share:setLayoutComponentEnabled(true)
btn_share:setName("btn_share")
btn_share:setTag(27)
btn_share:setCascadeColorEnabled(true)
btn_share:setCascadeOpacityEnabled(true)
btn_share:setVisible(false)
btn_share:setPosition(0.0000, -198.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_share)
layout:setSize({width = 276.0000, height = 71.0000})
layout:setLeftMargin(-138.0000)
layout:setRightMargin(-138.0000)
layout:setTopMargin(162.5000)
layout:setBottomMargin(-233.5000)
nd_award:addChild(btn_share)

--Create txt_share_title
local txt_share_title = ccui.Text:create()
txt_share_title:ignoreContentAdaptWithSize(true)
txt_share_title:setTextAreaSize({width = 0, height = 0})
txt_share_title:setFontSize(32)
txt_share_title:setString([[分享一下]])
txt_share_title:enableShadow({r = 252, g = 206, b = 57, a = 255}, {width = 1, height = -1}, 0)
txt_share_title:setLayoutComponentEnabled(true)
txt_share_title:setName("txt_share_title")
txt_share_title:setTag(29)
txt_share_title:setCascadeColorEnabled(true)
txt_share_title:setCascadeOpacityEnabled(true)
txt_share_title:setPosition(138.0000, 35.5000)
txt_share_title:setTextColor({r = 172, g = 77, b = 28})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_share_title)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.4638)
layout:setPercentHeight(0.4648)
layout:setSize({width = 128.0000, height = 33.0000})
layout:setLeftMargin(74.0000)
layout:setRightMargin(74.0000)
layout:setTopMargin(19.0000)
layout:setBottomMargin(19.0000)
btn_share:addChild(txt_share_title)

--Create btn_common
local btn_common = ccui.Button:create()
btn_common:ignoreContentAdaptWithSize(false)
btn_common:loadTextureNormal("hall/common/common_reward_btn.png",0)
btn_common:loadTexturePressed("hall/common/common_reward_btn.png",0)
btn_common:loadTextureDisabled("hall/common/common_reward_btn.png",0)
btn_common:setTitleFontSize(14)
btn_common:setTitleColor({r = 65, g = 65, b = 70})
btn_common:setScale9Enabled(true)
btn_common:setCapInsets({x = 30, y = 15, width = 216, height = 41})
btn_common:setLayoutComponentEnabled(true)
btn_common:setName("btn_common")
btn_common:setTag(89)
btn_common:setCascadeColorEnabled(true)
btn_common:setCascadeOpacityEnabled(true)
btn_common:setVisible(false)
btn_common:setPosition(0.0000, -200.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_common)
layout:setSize({width = 276.0000, height = 71.0000})
layout:setLeftMargin(-138.0000)
layout:setRightMargin(-138.0000)
layout:setTopMargin(164.5000)
layout:setBottomMargin(-235.5000)
nd_award:addChild(btn_common)

--Create txt_close_tips
local txt_close_tips = ccui.Text:create()
txt_close_tips:ignoreContentAdaptWithSize(true)
txt_close_tips:setTextAreaSize({width = 0, height = 0})
txt_close_tips:setFontSize(20)
txt_close_tips:setString([[点击屏幕关闭]])
txt_close_tips:setLayoutComponentEnabled(true)
txt_close_tips:setName("txt_close_tips")
txt_close_tips:setTag(65)
txt_close_tips:setCascadeColorEnabled(true)
txt_close_tips:setCascadeOpacityEnabled(true)
txt_close_tips:setVisible(false)
txt_close_tips:setPosition(0.0000, -260.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(txt_close_tips)
layout:setSize({width = 120.0000, height = 20.0000})
layout:setLeftMargin(-60.0000)
layout:setRightMargin(-60.0000)
layout:setTopMargin(250.0000)
layout:setBottomMargin(-270.0000)
nd_award:addChild(txt_close_tips)

--Create glow1
local glow1 = cc.Sprite:create("hall/common/glow4.png")
glow1:setName("glow1")
glow1:setTag(28)
glow1:setCascadeColorEnabled(true)
glow1:setCascadeOpacityEnabled(true)
glow1:setScaleX(0.0010)
glow1:setScaleY(0.0010)
layout = ccui.LayoutComponent:bindLayoutComponent(glow1)
layout:setSize({width = 101.0000, height = 102.0000})
layout:setLeftMargin(-50.5000)
layout:setRightMargin(-50.5000)
layout:setTopMargin(-51.0000)
layout:setBottomMargin(-51.0000)
glow1:setBlendFunc({src = 770, dst = 1})
nd_ani:addChild(glow1)

--Create glow2_1
local glow2_1 = cc.Sprite:create("hall/common/glow5.png")
glow2_1:setName("glow2_1")
glow2_1:setTag(29)
glow2_1:setCascadeColorEnabled(true)
glow2_1:setCascadeOpacityEnabled(true)
glow2_1:setScaleX(0.0010)
glow2_1:setScaleY(0.0010)
layout = ccui.LayoutComponent:bindLayoutComponent(glow2_1)
layout:setSize({width = 84.0000, height = 84.0000})
layout:setLeftMargin(-42.0000)
layout:setRightMargin(-42.0000)
layout:setTopMargin(-42.0000)
layout:setBottomMargin(-42.0000)
glow2_1:setBlendFunc({src = 770, dst = 1})
nd_ani:addChild(glow2_1)

--Create glow2_2
local glow2_2 = cc.Sprite:create("hall/common/glow5.png")
glow2_2:setName("glow2_2")
glow2_2:setTag(30)
glow2_2:setCascadeColorEnabled(true)
glow2_2:setCascadeOpacityEnabled(true)
glow2_2:setScaleX(0.0010)
glow2_2:setScaleY(0.0010)
layout = ccui.LayoutComponent:bindLayoutComponent(glow2_2)
layout:setSize({width = 84.0000, height = 84.0000})
layout:setLeftMargin(-42.0000)
layout:setRightMargin(-42.0000)
layout:setTopMargin(-42.0000)
layout:setBottomMargin(-42.0000)
glow2_2:setBlendFunc({src = 770, dst = 1})
nd_ani:addChild(glow2_2)

--Create Particle_1
local Particle_1 = cc.ParticleSystemQuad:create("hall/newhall/particle/gxhdxx.plist")
Particle_1:setName("Particle_1")
Particle_1:setTag(31)
Particle_1:setCascadeColorEnabled(true)
Particle_1:setCascadeOpacityEnabled(true)
layout = ccui.LayoutComponent:bindLayoutComponent(Particle_1)
Particle_1:setBlendFunc({src = 770, dst = 1})
nd_ani:addChild(Particle_1)

--Create btn_close
local btn_close = ccui.Layout:create()
btn_close:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/evaluation.plist")
btn_close:setBackGroundImage("hall/welfare/pjyl/img_close.png",1)
btn_close:setClippingEnabled(false)
btn_close:setBackGroundColorOpacity(0)
btn_close:setTouchEnabled(true);
btn_close:setLayoutComponentEnabled(true)
btn_close:setName("btn_close")
btn_close:setTag(58)
btn_close:setCascadeColorEnabled(true)
btn_close:setCascadeOpacityEnabled(true)
btn_close:setAnchorPoint(0.5000, 0.5000)
btn_close:setPosition(580.0000, 300.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_close)
layout:setSize({width = 60.0000, height = 60.0000})
layout:setLeftMargin(550.0000)
layout:setRightMargin(-610.0000)
layout:setTopMargin(-330.0000)
layout:setBottomMargin(270.0000)
nd_ani:addChild(btn_close)

--Create nd_prop
local nd_prop = ccui.ImageView:create()
nd_prop:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
nd_prop:loadTexture("hall/common/img_gxhd_bg.png",1)
nd_prop:setLayoutComponentEnabled(true)
nd_prop:setName("nd_prop")
nd_prop:setTag(61)
nd_prop:setCascadeColorEnabled(true)
nd_prop:setCascadeOpacityEnabled(true)
nd_prop:setVisible(false)
nd_prop:setPosition(0.0000, -500.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(nd_prop)
layout:setSize({width = 116.0000, height = 116.0000})
layout:setLeftMargin(-58.0000)
layout:setRightMargin(-58.0000)
layout:setTopMargin(442.0000)
layout:setBottomMargin(-558.0000)
Node:addChild(nd_prop)

--Create img_icon
local img_icon = ccui.ImageView:create()
img_icon:ignoreContentAdaptWithSize(false)
img_icon:loadTexture("common/prop/jindou_1.png",0)
img_icon:setLayoutComponentEnabled(true)
img_icon:setName("img_icon")
img_icon:setTag(39)
img_icon:setCascadeColorEnabled(true)
img_icon:setCascadeOpacityEnabled(true)
img_icon:setPosition(58.0000, 58.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_icon)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.9655)
layout:setPercentHeight(0.9655)
layout:setSize({width = 112.0000, height = 112.0000})
layout:setLeftMargin(2.0000)
layout:setRightMargin(2.0000)
layout:setTopMargin(2.0000)
layout:setBottomMargin(2.0000)
nd_prop:addChild(img_icon)

--Create img_lizi
local img_lizi = ccui.ImageView:create()
img_lizi:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
img_lizi:loadTexture("hall/common/img_gxhd_lz.png",1)
img_lizi:setLayoutComponentEnabled(true)
img_lizi:setName("img_lizi")
img_lizi:setTag(62)
img_lizi:setCascadeColorEnabled(true)
img_lizi:setCascadeOpacityEnabled(true)
img_lizi:setPosition(58.0000, 58.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_lizi)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(1.2155)
layout:setPercentHeight(0.4741)
layout:setSize({width = 141.0000, height = 55.0000})
layout:setLeftMargin(-12.5000)
layout:setRightMargin(-12.5000)
layout:setTopMargin(30.5000)
layout:setBottomMargin(30.5000)
nd_prop:addChild(img_lizi)

--Create txt_cnt
local txt_cnt = ccui.TextBMFont:create()
txt_cnt:setFntFile("fonts/reward_num.fnt")
txt_cnt:setString([[x12]])
txt_cnt:setLayoutComponentEnabled(true)
txt_cnt:setName("txt_cnt")
txt_cnt:setTag(43)
txt_cnt:setCascadeColorEnabled(true)
txt_cnt:setCascadeOpacityEnabled(true)
txt_cnt:setPosition(58.0000, 0.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(txt_cnt)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPercentWidth(0.5000)
layout:setPercentHeight(0.3017)
layout:setSize({width = 58.0000, height = 35.0000})
layout:setLeftMargin(29.0000)
layout:setRightMargin(29.0000)
layout:setTopMargin(98.5000)
layout:setBottomMargin(-17.5000)
nd_prop:addChild(txt_cnt)

--Create txt_prop
local txt_prop = ccui.Text:create()
txt_prop:ignoreContentAdaptWithSize(true)
txt_prop:setTextAreaSize({width = 0, height = 0})
txt_prop:setFontSize(26)
txt_prop:setString([[豆豆]])
txt_prop:setLayoutComponentEnabled(true)
txt_prop:setName("txt_prop")
txt_prop:setTag(40)
txt_prop:setCascadeColorEnabled(true)
txt_prop:setCascadeOpacityEnabled(true)
txt_prop:setPosition(58.0000, -40.0000)
txt_prop:setTextColor({r = 255, g = 248, b = 222})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_prop)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(-0.3448)
layout:setPercentWidth(0.4483)
layout:setPercentHeight(0.2241)
layout:setSize({width = 52.0000, height = 26.0000})
layout:setLeftMargin(32.0000)
layout:setRightMargin(32.0000)
layout:setTopMargin(143.0000)
layout:setBottomMargin(-53.0000)
nd_prop:addChild(txt_prop)

--Create Animation
result['animation'] = ccs.ActionTimeline:create()
  
result['animation']:setDuration(25)
result['animation']:setTimeSpeed(0.5000)

--Create PositionTimeline
local PositionTimeline = ccs.Timeline:create()

localFrame = ccs.PositionFrame:create()
localFrame:setFrameIndex(0)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setX(0.0000)
localFrame:setY(0.0000)
PositionTimeline:addFrame(localFrame)

localFrame = ccs.PositionFrame:create()
localFrame:setFrameIndex(10)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setX(0.0000)
localFrame:setY(0.0000)
PositionTimeline:addFrame(localFrame)

result['animation']:addTimeline(PositionTimeline)
PositionTimeline:setNode(bjglow)

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
localFrame:setFrameIndex(10)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setScaleX(1.0000)
localFrame:setScaleY(1.0000)
ScaleTimeline:addFrame(localFrame)

result['animation']:addTimeline(ScaleTimeline)
ScaleTimeline:setNode(bjglow)

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
localFrame:setFrameIndex(10)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setSkewX(0.0000)
localFrame:setSkewY(0.0000)
RotationSkewTimeline:addFrame(localFrame)

result['animation']:addTimeline(RotationSkewTimeline)
RotationSkewTimeline:setNode(bjglow)

--Create AlphaTimeline
local AlphaTimeline = ccs.Timeline:create()

localFrame = ccs.AlphaFrame:create()
localFrame:setFrameIndex(0)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setAlpha(0)
AlphaTimeline:addFrame(localFrame)

localFrame = ccs.AlphaFrame:create()
localFrame:setFrameIndex(10)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setAlpha(255)
AlphaTimeline:addFrame(localFrame)

result['animation']:addTimeline(AlphaTimeline)
AlphaTimeline:setNode(bjglow)

--Create PositionTimeline
local PositionTimeline = ccs.Timeline:create()

localFrame = ccs.PositionFrame:create()
localFrame:setFrameIndex(0)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setX(0.0000)
localFrame:setY(0.0000)
PositionTimeline:addFrame(localFrame)

localFrame = ccs.PositionFrame:create()
localFrame:setFrameIndex(5)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setX(0.0000)
localFrame:setY(0.0000)
PositionTimeline:addFrame(localFrame)

localFrame = ccs.PositionFrame:create()
localFrame:setFrameIndex(10)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setX(0.0000)
localFrame:setY(0.0000)
PositionTimeline:addFrame(localFrame)

localFrame = ccs.PositionFrame:create()
localFrame:setFrameIndex(15)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setX(0.0000)
localFrame:setY(0.0000)
PositionTimeline:addFrame(localFrame)

result['animation']:addTimeline(PositionTimeline)
PositionTimeline:setNode(nd_award)

--Create ScaleTimeline
local ScaleTimeline = ccs.Timeline:create()

localFrame = ccs.ScaleFrame:create()
localFrame:setFrameIndex(0)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setScaleX(0.0010)
localFrame:setScaleY(0.0010)
ScaleTimeline:addFrame(localFrame)

localFrame = ccs.ScaleFrame:create()
localFrame:setFrameIndex(5)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setScaleX(1.1000)
localFrame:setScaleY(1.1000)
ScaleTimeline:addFrame(localFrame)

localFrame = ccs.ScaleFrame:create()
localFrame:setFrameIndex(10)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setScaleX(0.9000)
localFrame:setScaleY(0.9000)
ScaleTimeline:addFrame(localFrame)

localFrame = ccs.ScaleFrame:create()
localFrame:setFrameIndex(15)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setScaleX(1.0000)
localFrame:setScaleY(1.0000)
ScaleTimeline:addFrame(localFrame)

result['animation']:addTimeline(ScaleTimeline)
ScaleTimeline:setNode(nd_award)

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
localFrame:setFrameIndex(5)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setSkewX(0.0000)
localFrame:setSkewY(0.0000)
RotationSkewTimeline:addFrame(localFrame)

localFrame = ccs.RotationSkewFrame:create()
localFrame:setFrameIndex(10)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setSkewX(0.0000)
localFrame:setSkewY(0.0000)
RotationSkewTimeline:addFrame(localFrame)

localFrame = ccs.RotationSkewFrame:create()
localFrame:setFrameIndex(15)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setSkewX(0.0000)
localFrame:setSkewY(0.0000)
RotationSkewTimeline:addFrame(localFrame)

result['animation']:addTimeline(RotationSkewTimeline)
RotationSkewTimeline:setNode(nd_award)

--Create PositionTimeline
local PositionTimeline = ccs.Timeline:create()

localFrame = ccs.PositionFrame:create()
localFrame:setFrameIndex(0)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setX(0.0000)
localFrame:setY(0.0000)
PositionTimeline:addFrame(localFrame)

localFrame = ccs.PositionFrame:create()
localFrame:setFrameIndex(5)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setX(0.0000)
localFrame:setY(0.0000)
PositionTimeline:addFrame(localFrame)

localFrame = ccs.PositionFrame:create()
localFrame:setFrameIndex(15)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setX(0.0000)
localFrame:setY(0.0000)
PositionTimeline:addFrame(localFrame)

localFrame = ccs.PositionFrame:create()
localFrame:setFrameIndex(25)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setX(0.0000)
localFrame:setY(0.0000)
PositionTimeline:addFrame(localFrame)

result['animation']:addTimeline(PositionTimeline)
PositionTimeline:setNode(glow1)

--Create ScaleTimeline
local ScaleTimeline = ccs.Timeline:create()

localFrame = ccs.ScaleFrame:create()
localFrame:setFrameIndex(0)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setScaleX(0.0010)
localFrame:setScaleY(0.0010)
ScaleTimeline:addFrame(localFrame)

localFrame = ccs.ScaleFrame:create()
localFrame:setFrameIndex(5)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setScaleX(7.0000)
localFrame:setScaleY(7.0000)
ScaleTimeline:addFrame(localFrame)

localFrame = ccs.ScaleFrame:create()
localFrame:setFrameIndex(15)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setScaleX(9.5000)
localFrame:setScaleY(9.5000)
ScaleTimeline:addFrame(localFrame)

localFrame = ccs.ScaleFrame:create()
localFrame:setFrameIndex(25)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setScaleX(12.0000)
localFrame:setScaleY(12.0000)
ScaleTimeline:addFrame(localFrame)

result['animation']:addTimeline(ScaleTimeline)
ScaleTimeline:setNode(glow1)

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
localFrame:setFrameIndex(5)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setSkewX(0.0000)
localFrame:setSkewY(0.0000)
RotationSkewTimeline:addFrame(localFrame)

localFrame = ccs.RotationSkewFrame:create()
localFrame:setFrameIndex(15)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setSkewX(0.0000)
localFrame:setSkewY(0.0000)
RotationSkewTimeline:addFrame(localFrame)

localFrame = ccs.RotationSkewFrame:create()
localFrame:setFrameIndex(25)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setSkewX(0.0000)
localFrame:setSkewY(0.0000)
RotationSkewTimeline:addFrame(localFrame)

result['animation']:addTimeline(RotationSkewTimeline)
RotationSkewTimeline:setNode(glow1)

--Create AlphaTimeline
local AlphaTimeline = ccs.Timeline:create()

localFrame = ccs.AlphaFrame:create()
localFrame:setFrameIndex(0)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setAlpha(255)
AlphaTimeline:addFrame(localFrame)

localFrame = ccs.AlphaFrame:create()
localFrame:setFrameIndex(5)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setAlpha(255)
AlphaTimeline:addFrame(localFrame)

localFrame = ccs.AlphaFrame:create()
localFrame:setFrameIndex(15)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setAlpha(204)
AlphaTimeline:addFrame(localFrame)

localFrame = ccs.AlphaFrame:create()
localFrame:setFrameIndex(25)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setAlpha(0)
AlphaTimeline:addFrame(localFrame)

result['animation']:addTimeline(AlphaTimeline)
AlphaTimeline:setNode(glow1)

--Create PositionTimeline
local PositionTimeline = ccs.Timeline:create()

localFrame = ccs.PositionFrame:create()
localFrame:setFrameIndex(0)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setX(0.0000)
localFrame:setY(0.0000)
PositionTimeline:addFrame(localFrame)

localFrame = ccs.PositionFrame:create()
localFrame:setFrameIndex(10)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setX(0.0000)
localFrame:setY(0.0000)
PositionTimeline:addFrame(localFrame)

localFrame = ccs.PositionFrame:create()
localFrame:setFrameIndex(15)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setX(0.0000)
localFrame:setY(0.0000)
PositionTimeline:addFrame(localFrame)

result['animation']:addTimeline(PositionTimeline)
PositionTimeline:setNode(glow2_1)

--Create ScaleTimeline
local ScaleTimeline = ccs.Timeline:create()

localFrame = ccs.ScaleFrame:create()
localFrame:setFrameIndex(0)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setScaleX(0.0010)
localFrame:setScaleY(0.0010)
ScaleTimeline:addFrame(localFrame)

localFrame = ccs.ScaleFrame:create()
localFrame:setFrameIndex(10)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setScaleX(5.0005)
localFrame:setScaleY(5.0005)
ScaleTimeline:addFrame(localFrame)

localFrame = ccs.ScaleFrame:create()
localFrame:setFrameIndex(15)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setScaleX(8.0000)
localFrame:setScaleY(8.0000)
ScaleTimeline:addFrame(localFrame)

result['animation']:addTimeline(ScaleTimeline)
ScaleTimeline:setNode(glow2_1)

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
localFrame:setFrameIndex(10)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setSkewX(0.0000)
localFrame:setSkewY(0.0000)
RotationSkewTimeline:addFrame(localFrame)

localFrame = ccs.RotationSkewFrame:create()
localFrame:setFrameIndex(15)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setSkewX(0.0000)
localFrame:setSkewY(0.0000)
RotationSkewTimeline:addFrame(localFrame)

result['animation']:addTimeline(RotationSkewTimeline)
RotationSkewTimeline:setNode(glow2_1)

--Create AlphaTimeline
local AlphaTimeline = ccs.Timeline:create()

localFrame = ccs.AlphaFrame:create()
localFrame:setFrameIndex(10)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setAlpha(255)
AlphaTimeline:addFrame(localFrame)

localFrame = ccs.AlphaFrame:create()
localFrame:setFrameIndex(15)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setAlpha(0)
AlphaTimeline:addFrame(localFrame)

result['animation']:addTimeline(AlphaTimeline)
AlphaTimeline:setNode(glow2_1)

--Create PositionTimeline
local PositionTimeline = ccs.Timeline:create()

localFrame = ccs.PositionFrame:create()
localFrame:setFrameIndex(5)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setX(0.0000)
localFrame:setY(0.0000)
PositionTimeline:addFrame(localFrame)

localFrame = ccs.PositionFrame:create()
localFrame:setFrameIndex(15)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setX(0.0000)
localFrame:setY(0.0000)
PositionTimeline:addFrame(localFrame)

localFrame = ccs.PositionFrame:create()
localFrame:setFrameIndex(20)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setX(0.0000)
localFrame:setY(0.0000)
PositionTimeline:addFrame(localFrame)

result['animation']:addTimeline(PositionTimeline)
PositionTimeline:setNode(glow2_2)

--Create ScaleTimeline
local ScaleTimeline = ccs.Timeline:create()

localFrame = ccs.ScaleFrame:create()
localFrame:setFrameIndex(5)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setScaleX(0.0010)
localFrame:setScaleY(0.0010)
ScaleTimeline:addFrame(localFrame)

localFrame = ccs.ScaleFrame:create()
localFrame:setFrameIndex(15)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setScaleX(5.0005)
localFrame:setScaleY(5.0005)
ScaleTimeline:addFrame(localFrame)

localFrame = ccs.ScaleFrame:create()
localFrame:setFrameIndex(20)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setScaleX(8.0000)
localFrame:setScaleY(8.0000)
ScaleTimeline:addFrame(localFrame)

result['animation']:addTimeline(ScaleTimeline)
ScaleTimeline:setNode(glow2_2)

--Create RotationSkewTimeline
local RotationSkewTimeline = ccs.Timeline:create()

localFrame = ccs.RotationSkewFrame:create()
localFrame:setFrameIndex(5)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setSkewX(0.0000)
localFrame:setSkewY(0.0000)
RotationSkewTimeline:addFrame(localFrame)

localFrame = ccs.RotationSkewFrame:create()
localFrame:setFrameIndex(15)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setSkewX(0.0000)
localFrame:setSkewY(0.0000)
RotationSkewTimeline:addFrame(localFrame)

localFrame = ccs.RotationSkewFrame:create()
localFrame:setFrameIndex(20)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setSkewX(0.0000)
localFrame:setSkewY(0.0000)
RotationSkewTimeline:addFrame(localFrame)

result['animation']:addTimeline(RotationSkewTimeline)
RotationSkewTimeline:setNode(glow2_2)

--Create AlphaTimeline
local AlphaTimeline = ccs.Timeline:create()

localFrame = ccs.AlphaFrame:create()
localFrame:setFrameIndex(5)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setAlpha(255)
AlphaTimeline:addFrame(localFrame)

localFrame = ccs.AlphaFrame:create()
localFrame:setFrameIndex(15)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setAlpha(255)
AlphaTimeline:addFrame(localFrame)

localFrame = ccs.AlphaFrame:create()
localFrame:setFrameIndex(20)
localFrame:setTween(true)
localFrame:setTweenType(0)
localFrame:setAlpha(0)
AlphaTimeline:addFrame(localFrame)

result['animation']:addTimeline(AlphaTimeline)
AlphaTimeline:setNode(glow2_2)
--Create Animation List
local popAni = {name="popAni", startIndex=0, endIndex=25}
result['animation']:addAnimationInfo(popAni)

result['root'] = Node
return result;
end

return Result

