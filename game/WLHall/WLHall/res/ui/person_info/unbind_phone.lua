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

--Create whole_panel
local whole_panel = ccui.Layout:create()
whole_panel:ignoreContentAdaptWithSize(false)
whole_panel:setClippingEnabled(false)
whole_panel:setBackGroundColorOpacity(102)
whole_panel:setTouchEnabled(true);
whole_panel:setLayoutComponentEnabled(true)
whole_panel:setName("whole_panel")
whole_panel:setTag(795)
whole_panel:setCascadeColorEnabled(true)
whole_panel:setCascadeOpacityEnabled(true)
whole_panel:setPosition(-0.0001, 1.1624)
layout = ccui.LayoutComponent:bindLayoutComponent(whole_panel)
layout:setSize({width = 816.0000, height = 634.0000})
layout:setLeftMargin(-0.0001)
layout:setRightMargin(-815.9999)
layout:setTopMargin(-635.1624)
layout:setBottomMargin(1.1624)
Node:addChild(whole_panel)

--Create title_panel
local title_panel = ccui.Layout:create()
title_panel:ignoreContentAdaptWithSize(false)
title_panel:setClippingEnabled(false)
title_panel:setBackGroundColorOpacity(102)
title_panel:setTouchEnabled(true);
title_panel:setLayoutComponentEnabled(true)
title_panel:setName("title_panel")
title_panel:setTag(796)
title_panel:setCascadeColorEnabled(true)
title_panel:setCascadeOpacityEnabled(true)
title_panel:setAnchorPoint(0.5000, 0.5000)
title_panel:setPosition(408.0000, 536.0001)
layout = ccui.LayoutComponent:bindLayoutComponent(title_panel)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.8454)
layout:setPercentWidthEnabled(true)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(0.0505)
layout:setSize({width = 816.0000, height = 32.0000})
layout:setTopMargin(81.9999)
layout:setBottomMargin(520.0001)
whole_panel:addChild(title_panel)

--Create Text_1_1_0
local Text_1_1_0 = ccui.Text:create()
Text_1_1_0:ignoreContentAdaptWithSize(true)
Text_1_1_0:setTextAreaSize({width = 0, height = 0})
Text_1_1_0:setFontName("")
Text_1_1_0:setFontSize(30)
Text_1_1_0:setString([[如该账号再绑定手机，将不能获得奖励]])
Text_1_1_0:setLayoutComponentEnabled(true)
Text_1_1_0:setName("Text_1_1_0")
Text_1_1_0:setTag(797)
Text_1_1_0:setCascadeColorEnabled(true)
Text_1_1_0:setCascadeOpacityEnabled(true)
Text_1_1_0:setPosition(403.9996, -35.9990)
Text_1_1_0:setTextColor({r = 238, g = 140, b = 0})
layout = ccui.LayoutComponent:bindLayoutComponent(Text_1_1_0)
layout:setPositionPercentX(0.4951)
layout:setPositionPercentY(-1.1250)
layout:setPercentWidth(0.6250)
layout:setPercentHeight(0.9375)
layout:setSize({width = 510.0000, height = 30.0000})
layout:setLeftMargin(148.9996)
layout:setRightMargin(157.0004)
layout:setTopMargin(52.9990)
layout:setBottomMargin(-50.9990)
title_panel:addChild(Text_1_1_0)

--Create pic_top_l_3
local pic_top_l_3 = ccui.ImageView:create()
pic_top_l_3:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/person_info.plist")
pic_top_l_3:loadTexture("hall/person_info/img_zs.png",1)
pic_top_l_3:setFlippedX(true)
pic_top_l_3:setLayoutComponentEnabled(true)
pic_top_l_3:setName("pic_top_l_3")
pic_top_l_3:setTag(470)
pic_top_l_3:setCascadeColorEnabled(true)
pic_top_l_3:setCascadeOpacityEnabled(true)
pic_top_l_3:setPosition(100.3159, -36.0000)
pic_top_l_3:setRotationSkewX(180.0000)
pic_top_l_3:setRotationSkewY(180.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(pic_top_l_3)
layout:setPositionPercentX(0.1229)
layout:setPositionPercentY(-1.1250)
layout:setPercentWidth(0.0993)
layout:setPercentHeight(0.3438)
layout:setSize({width = 81.0000, height = 11.0000})
layout:setLeftMargin(59.8159)
layout:setRightMargin(675.1841)
layout:setTopMargin(62.5000)
layout:setBottomMargin(-41.5000)
title_panel:addChild(pic_top_l_3)

--Create pic_top_r_4
local pic_top_r_4 = ccui.ImageView:create()
pic_top_r_4:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/person_info.plist")
pic_top_r_4:loadTexture("hall/person_info/img_zs.png",1)
pic_top_r_4:setFlippedX(true)
pic_top_r_4:setLayoutComponentEnabled(true)
pic_top_r_4:setName("pic_top_r_4")
pic_top_r_4:setTag(472)
pic_top_r_4:setCascadeColorEnabled(true)
pic_top_r_4:setCascadeOpacityEnabled(true)
pic_top_r_4:setPosition(708.4503, -36.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(pic_top_r_4)
layout:setPositionPercentX(0.8682)
layout:setPositionPercentY(-1.1250)
layout:setPercentWidth(0.0993)
layout:setPercentHeight(0.3438)
layout:setSize({width = 81.0000, height = 11.0000})
layout:setLeftMargin(667.9503)
layout:setRightMargin(67.0497)
layout:setTopMargin(62.5000)
layout:setBottomMargin(-41.5000)
title_panel:addChild(pic_top_r_4)

--Create Text_90
local Text_90 = ccui.Text:create()
Text_90:ignoreContentAdaptWithSize(true)
Text_90:setTextAreaSize({width = 0, height = 0})
Text_90:setFontName("")
Text_90:setFontSize(32)
Text_90:setString([[手机号码]])
Text_90:setLayoutComponentEnabled(true)
Text_90:setName("Text_90")
Text_90:setTag(867)
Text_90:setCascadeColorEnabled(true)
Text_90:setCascadeOpacityEnabled(true)
Text_90:setAnchorPoint(0.0000, 0.5000)
Text_90:setPosition(87.0012, 386.9989)
Text_90:setTextColor({r = 51, g = 51, b = 51})
layout = ccui.LayoutComponent:bindLayoutComponent(Text_90)
layout:setPositionPercentX(0.1066)
layout:setPositionPercentY(0.6104)
layout:setPercentWidth(0.1569)
layout:setPercentHeight(0.0521)
layout:setSize({width = 128.0000, height = 33.0000})
layout:setLeftMargin(87.0012)
layout:setRightMargin(600.9988)
layout:setTopMargin(230.5011)
layout:setBottomMargin(370.4989)
whole_panel:addChild(Text_90)

--Create txt_phone_phoneid
local txt_phone_phoneid = ccui.TextField:create()
txt_phone_phoneid:ignoreContentAdaptWithSize(false)
tolua.cast(txt_phone_phoneid:getVirtualRenderer(), "cc.Label"):setLineBreakWithoutSpace(true)
txt_phone_phoneid:setFontSize(28)
txt_phone_phoneid:setPlaceHolder("请输入您的手机号")
txt_phone_phoneid:setString([[]])
txt_phone_phoneid:setMaxLength(10)
txt_phone_phoneid:setLayoutComponentEnabled(true)
txt_phone_phoneid:setName("txt_phone_phoneid")
txt_phone_phoneid:setTag(866)
txt_phone_phoneid:setCascadeColorEnabled(true)
txt_phone_phoneid:setCascadeOpacityEnabled(true)
txt_phone_phoneid:setAnchorPoint(0.0000, 0.5000)
txt_phone_phoneid:setPosition(263.0008, 390.9997)
txt_phone_phoneid:setColor({r = 184, g = 184, b = 184})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_phone_phoneid)
layout:setPositionPercentX(0.3223)
layout:setPositionPercentY(0.6167)
layout:setPercentWidth(0.4902)
layout:setPercentHeight(0.0536)
layout:setSize({width = 400.0000, height = 34.0000})
layout:setLeftMargin(263.0008)
layout:setRightMargin(152.9992)
layout:setTopMargin(226.0003)
layout:setBottomMargin(373.9997)
whole_panel:addChild(txt_phone_phoneid)

--Create line_1
local line_1 = ccui.ImageView:create()
line_1:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
line_1:loadTexture("hall/common/new_line.png",1)
line_1:setScale9Enabled(true)
line_1:setCapInsets({x = 2, y = 0, width = 1, height = 1})
line_1:setLayoutComponentEnabled(true)
line_1:setName("line_1")
line_1:setTag(865)
line_1:setCascadeColorEnabled(true)
line_1:setCascadeOpacityEnabled(true)
line_1:setPosition(472.0000, 371.0000)
line_1:setColor({r = 184, g = 184, b = 184})
layout = ccui.LayoutComponent:bindLayoutComponent(line_1)
layout:setPositionPercentX(0.5784)
layout:setPositionPercentY(0.5852)
layout:setPercentWidth(0.6299)
layout:setPercentHeight(0.0032)
layout:setSize({width = 514.0000, height = 2.0000})
layout:setLeftMargin(215.0000)
layout:setRightMargin(87.0000)
layout:setTopMargin(262.0000)
layout:setBottomMargin(370.0000)
whole_panel:addChild(line_1)

--Create Text_92
local Text_92 = ccui.Text:create()
Text_92:ignoreContentAdaptWithSize(true)
Text_92:setTextAreaSize({width = 0, height = 0})
Text_92:setFontName("")
Text_92:setFontSize(32)
Text_92:setString([[验  证  码]])
Text_92:setLayoutComponentEnabled(true)
Text_92:setName("Text_92")
Text_92:setTag(864)
Text_92:setCascadeColorEnabled(true)
Text_92:setCascadeOpacityEnabled(true)
Text_92:setAnchorPoint(0.0000, 0.5000)
Text_92:setPosition(87.0000, 292.0006)
Text_92:setTextColor({r = 51, g = 51, b = 51})
layout = ccui.LayoutComponent:bindLayoutComponent(Text_92)
layout:setPositionPercentX(0.1066)
layout:setPositionPercentY(0.4606)
layout:setPercentWidth(0.1961)
layout:setPercentHeight(0.0521)
layout:setSize({width = 160.0000, height = 33.0000})
layout:setLeftMargin(87.0000)
layout:setRightMargin(569.0000)
layout:setTopMargin(325.4994)
layout:setBottomMargin(275.5006)
whole_panel:addChild(Text_92)

--Create txt_phone_code
local txt_phone_code = ccui.TextField:create()
txt_phone_code:ignoreContentAdaptWithSize(false)
tolua.cast(txt_phone_code:getVirtualRenderer(), "cc.Label"):setLineBreakWithoutSpace(true)
txt_phone_code:setFontSize(28)
txt_phone_code:setPlaceHolder("4位数字")
txt_phone_code:setString([[]])
txt_phone_code:setMaxLength(10)
txt_phone_code:setLayoutComponentEnabled(true)
txt_phone_code:setName("txt_phone_code")
txt_phone_code:setTag(863)
txt_phone_code:setCascadeColorEnabled(true)
txt_phone_code:setCascadeOpacityEnabled(true)
txt_phone_code:setAnchorPoint(0.0000, 0.5000)
txt_phone_code:setPosition(262.1578, 292.0006)
txt_phone_code:setColor({r = 184, g = 184, b = 184})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_phone_code)
layout:setPositionPercentX(0.3213)
layout:setPositionPercentY(0.4606)
layout:setPercentWidth(0.1716)
layout:setPercentHeight(0.0536)
layout:setSize({width = 140.0000, height = 34.0000})
layout:setLeftMargin(262.1578)
layout:setRightMargin(413.8422)
layout:setTopMargin(324.9994)
layout:setBottomMargin(275.0006)
whole_panel:addChild(txt_phone_code)

--Create btn_act_phone_code
local btn_act_phone_code = ccui.Layout:create()
btn_act_phone_code:ignoreContentAdaptWithSize(false)
btn_act_phone_code:setClippingEnabled(false)
btn_act_phone_code:setBackGroundColorOpacity(102)
btn_act_phone_code:setTouchEnabled(true);
btn_act_phone_code:setLayoutComponentEnabled(true)
btn_act_phone_code:setName("btn_act_phone_code")
btn_act_phone_code:setTag(860)
btn_act_phone_code:setCascadeColorEnabled(true)
btn_act_phone_code:setCascadeOpacityEnabled(true)
btn_act_phone_code:setAnchorPoint(0.5000, 0.5000)
btn_act_phone_code:setPosition(658.2942, 292.6194)
btn_act_phone_code:setColor({r = 22, g = 146, b = 206})
layout = ccui.LayoutComponent:bindLayoutComponent(btn_act_phone_code)
layout:setPositionPercentX(0.8067)
layout:setPositionPercentY(0.4615)
layout:setPercentWidth(0.3064)
layout:setPercentHeight(0.1420)
layout:setSize({width = 250.0000, height = 90.0000})
layout:setLeftMargin(533.2942)
layout:setRightMargin(32.7058)
layout:setTopMargin(296.3806)
layout:setBottomMargin(247.6194)
whole_panel:addChild(btn_act_phone_code)

--Create Text_7
local Text_7 = ccui.Text:create()
Text_7:ignoreContentAdaptWithSize(true)
Text_7:setTextAreaSize({width = 0, height = 0})
Text_7:setFontName("")
Text_7:setFontSize(30)
Text_7:setString([[获取验证码]])
Text_7:setTextHorizontalAlignment(1)
Text_7:setTextVerticalAlignment(1)
Text_7:setLayoutComponentEnabled(true)
Text_7:setName("Text_7")
Text_7:setTag(861)
Text_7:setCascadeColorEnabled(true)
Text_7:setCascadeOpacityEnabled(true)
Text_7:setPosition(75.0000, 45.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(Text_7)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.3000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.6000)
layout:setPercentHeight(0.3333)
layout:setSize({width = 150.0000, height = 30.0000})
layout:setRightMargin(100.0000)
layout:setTopMargin(30.0000)
layout:setBottomMargin(30.0000)
btn_act_phone_code:addChild(Text_7)

--Create txt_phone_code_td
local txt_phone_code_td = ccui.Text:create()
txt_phone_code_td:ignoreContentAdaptWithSize(true)
txt_phone_code_td:setTextAreaSize({width = 0, height = 0})
txt_phone_code_td:setFontName("")
txt_phone_code_td:setFontSize(28)
txt_phone_code_td:setString([[60]])
txt_phone_code_td:setLayoutComponentEnabled(true)
txt_phone_code_td:setName("txt_phone_code_td")
txt_phone_code_td:setTag(859)
txt_phone_code_td:setCascadeColorEnabled(true)
txt_phone_code_td:setCascadeOpacityEnabled(true)
txt_phone_code_td:setVisible(false)
txt_phone_code_td:setAnchorPoint(0.0000, 0.5000)
txt_phone_code_td:setPosition(695.0000, 293.0000)
txt_phone_code_td:setTextColor({r = 141, g = 141, b = 141})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_phone_code_td)
layout:setPositionPercentX(0.8517)
layout:setPositionPercentY(0.4621)
layout:setPercentWidth(0.0343)
layout:setPercentHeight(0.0442)
layout:setSize({width = 28.0000, height = 28.0000})
layout:setLeftMargin(695.0000)
layout:setRightMargin(93.0000)
layout:setTopMargin(327.0000)
layout:setBottomMargin(279.0000)
whole_panel:addChild(txt_phone_code_td)

--Create line_3
local line_3 = ccui.ImageView:create()
line_3:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
line_3:loadTexture("hall/common/new_line.png",1)
line_3:setScale9Enabled(true)
line_3:setCapInsets({x = 2, y = 0, width = 1, height = 1})
line_3:setLayoutComponentEnabled(true)
line_3:setName("line_3")
line_3:setTag(858)
line_3:setCascadeColorEnabled(true)
line_3:setCascadeOpacityEnabled(true)
line_3:setPosition(473.0000, 272.0000)
line_3:setColor({r = 184, g = 184, b = 184})
layout = ccui.LayoutComponent:bindLayoutComponent(line_3)
layout:setPositionPercentX(0.5797)
layout:setPositionPercentY(0.4290)
layout:setPercentWidth(0.6299)
layout:setPercentHeight(0.0032)
layout:setSize({width = 514.0000, height = 2.0000})
layout:setLeftMargin(216.0000)
layout:setRightMargin(86.0000)
layout:setTopMargin(361.0000)
layout:setBottomMargin(271.0000)
whole_panel:addChild(line_3)

--Create btn_unbind
local btn_unbind = ccui.Layout:create()
btn_unbind:ignoreContentAdaptWithSize(false)
btn_unbind:setClippingEnabled(false)
btn_unbind:setBackGroundImageCapInsets({x = -4, y = -3, width = 10, height = 6})
btn_unbind:setBackGroundColorOpacity(102)
btn_unbind:setBackGroundImageScale9Enabled(true)
btn_unbind:setTouchEnabled(true);
btn_unbind:setLayoutComponentEnabled(true)
btn_unbind:setName("btn_unbind")
btn_unbind:setTag(2279)
btn_unbind:setCascadeColorEnabled(true)
btn_unbind:setCascadeOpacityEnabled(true)
btn_unbind:setAnchorPoint(0.5000, 0.5000)
btn_unbind:setPosition(408.0000, 168.2700)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_unbind)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.2654)
layout:setPercentWidth(0.3064)
layout:setPercentHeight(0.0946)
layout:setSize({width = 250.0000, height = 60.0000})
layout:setLeftMargin(283.0000)
layout:setRightMargin(283.0000)
layout:setTopMargin(435.7300)
layout:setBottomMargin(138.2700)
whole_panel:addChild(btn_unbind)

--Create img_bg
local img_bg = ccui.ImageView:create()
img_bg:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
img_bg:loadTexture("hall/common/new_btn_noangle.png",1)
img_bg:setScale9Enabled(true)
img_bg:setCapInsets({x = 8, y = 8, width = 2, height = 2})
img_bg:setLayoutComponentEnabled(true)
img_bg:setName("img_bg")
img_bg:setTag(370)
img_bg:setCascadeColorEnabled(true)
img_bg:setCascadeOpacityEnabled(true)
img_bg:setPosition(125.0000, 30.0000)
img_bg:setColor({r = 38, g = 155, b = 88})
layout = ccui.LayoutComponent:bindLayoutComponent(img_bg)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(1.0000)
layout:setSize({width = 250.0000, height = 60.0000})
btn_unbind:addChild(img_bg)

--Create txt_commit
local txt_commit = ccui.Text:create()
txt_commit:ignoreContentAdaptWithSize(true)
txt_commit:setTextAreaSize({width = 0, height = 0})
txt_commit:setFontName("")
txt_commit:setFontSize(32)
txt_commit:setString([[提交]])
txt_commit:setLayoutComponentEnabled(true)
txt_commit:setName("txt_commit")
txt_commit:setTag(2280)
txt_commit:setCascadeColorEnabled(true)
txt_commit:setCascadeOpacityEnabled(true)
txt_commit:setPosition(125.0000, 30.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(txt_commit)
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
btn_unbind:addChild(txt_commit)

--Create Text_8
local Text_8 = ccui.Text:create()
Text_8:ignoreContentAdaptWithSize(true)
Text_8:setTextAreaSize({width = 0, height = 0})
Text_8:setFontName("")
Text_8:setFontSize(24)
Text_8:setString([[注：解绑后将降低您的账号安全。]])
Text_8:setLayoutComponentEnabled(true)
Text_8:setName("Text_8")
Text_8:setTag(868)
Text_8:setCascadeColorEnabled(true)
Text_8:setCascadeOpacityEnabled(true)
Text_8:setAnchorPoint(0.5027, 0.5000)
Text_8:setPosition(415.1808, 93.4670)
Text_8:setTextColor({r = 146, g = 146, b = 146})
layout = ccui.LayoutComponent:bindLayoutComponent(Text_8)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentX(0.5088)
layout:setPositionPercentY(0.1474)
layout:setPercentWidth(0.4412)
layout:setPercentHeight(0.0379)
layout:setSize({width = 360.0000, height = 24.0000})
layout:setLeftMargin(234.2088)
layout:setRightMargin(221.7911)
layout:setTopMargin(528.5330)
layout:setBottomMargin(81.4670)
whole_panel:addChild(Text_8)

--Create Animation
result['animation'] = ccs.ActionTimeline:create()
  
result['animation']:setDuration(0)
result['animation']:setTimeSpeed(1.0000)
--Create Animation List

result['root'] = Node
return result;
end

return Result

