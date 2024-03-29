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
whole_panel:setTag(752)
whole_panel:setCascadeColorEnabled(true)
whole_panel:setCascadeOpacityEnabled(true)
whole_panel:setPosition(-0.0001, 0.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(whole_panel)
layout:setSize({width = 816.0000, height = 572.0000})
layout:setLeftMargin(-0.0001)
layout:setRightMargin(-815.9999)
layout:setTopMargin(-572.0000)
Node:addChild(whole_panel)

--Create title_panel
local title_panel = ccui.Layout:create()
title_panel:ignoreContentAdaptWithSize(false)
title_panel:setClippingEnabled(false)
title_panel:setBackGroundColorOpacity(102)
title_panel:setTouchEnabled(true);
title_panel:setLayoutComponentEnabled(true)
title_panel:setName("title_panel")
title_panel:setTag(789)
title_panel:setCascadeColorEnabled(true)
title_panel:setCascadeOpacityEnabled(true)
title_panel:setAnchorPoint(0.0000, 1.0000)
title_panel:setPosition(0.0000, 490.1078)
layout = ccui.LayoutComponent:bindLayoutComponent(title_panel)
layout:setPositionPercentY(0.8568)
layout:setPercentWidth(1.0049)
layout:setPercentHeight(0.1748)
layout:setSize({width = 820.0000, height = 100.0000})
layout:setRightMargin(-4.0000)
layout:setTopMargin(81.8922)
layout:setBottomMargin(390.1078)
whole_panel:addChild(title_panel)

--Create img_dou
local img_dou = cc.Sprite:create("hall/common/prop_lpq_s.png")
img_dou:setName("img_dou")
img_dou:setTag(794)
img_dou:setCascadeColorEnabled(true)
img_dou:setCascadeOpacityEnabled(true)
img_dou:setPosition(324.6048, 80.0001)
layout = ccui.LayoutComponent:bindLayoutComponent(img_dou)
layout:setPositionPercentX(0.3959)
layout:setPositionPercentY(0.8000)
layout:setPercentWidth(0.0854)
layout:setPercentHeight(0.7000)
layout:setSize({width = 70.0000, height = 70.0000})
layout:setLeftMargin(289.6048)
layout:setRightMargin(460.3952)
layout:setTopMargin(-15.0001)
layout:setBottomMargin(45.0001)
img_dou:setBlendFunc({src = 1, dst = 771})
title_panel:addChild(img_dou)

--Create Text_14
local Text_14 = ccui.Text:create()
Text_14:ignoreContentAdaptWithSize(true)
Text_14:setTextAreaSize({width = 0, height = 0})
Text_14:setFontName("")
Text_14:setFontSize(32)
Text_14:setString([[X50]])
Text_14:setLayoutComponentEnabled(true)
Text_14:setName("Text_14")
Text_14:setTag(793)
Text_14:setCascadeColorEnabled(true)
Text_14:setCascadeOpacityEnabled(true)
Text_14:setAnchorPoint(0.0000, 0.5000)
Text_14:setPosition(362.0005, 80.0003)
Text_14:setTextColor({r = 238, g = 140, b = 0})
layout = ccui.LayoutComponent:bindLayoutComponent(Text_14)
layout:setPositionPercentX(0.4415)
layout:setPositionPercentY(0.8000)
layout:setPercentWidth(0.0585)
layout:setPercentHeight(0.3300)
layout:setSize({width = 48.0000, height = 33.0000})
layout:setLeftMargin(362.0005)
layout:setRightMargin(409.9995)
layout:setTopMargin(3.4997)
layout:setBottomMargin(63.5003)
title_panel:addChild(Text_14)

--Create Text_26
local Text_26 = ccui.Text:create()
Text_26:ignoreContentAdaptWithSize(true)
Text_26:setTextAreaSize({width = 0, height = 0})
Text_26:setFontName("")
Text_26:setFontSize(32)
Text_26:setString([[绑定成功即赠]])
Text_26:setLayoutComponentEnabled(true)
Text_26:setName("Text_26")
Text_26:setTag(859)
Text_26:setCascadeColorEnabled(true)
Text_26:setCascadeOpacityEnabled(true)
Text_26:setAnchorPoint(0.0000, 0.5000)
Text_26:setPosition(85.2800, 80.0000)
Text_26:setTextColor({r = 238, g = 140, b = 0})
layout = ccui.LayoutComponent:bindLayoutComponent(Text_26)
layout:setPositionPercentX(0.1040)
layout:setPositionPercentY(0.8000)
layout:setPercentWidth(0.2341)
layout:setPercentHeight(0.3300)
layout:setSize({width = 192.0000, height = 33.0000})
layout:setLeftMargin(85.2800)
layout:setRightMargin(542.7200)
layout:setTopMargin(3.5000)
layout:setBottomMargin(63.5000)
title_panel:addChild(Text_26)

--Create Text_90
local Text_90 = ccui.Text:create()
Text_90:ignoreContentAdaptWithSize(true)
Text_90:setTextAreaSize({width = 0, height = 0})
Text_90:setFontName("")
Text_90:setFontSize(32)
Text_90:setString([[手机号码]])
Text_90:setLayoutComponentEnabled(true)
Text_90:setName("Text_90")
Text_90:setTag(880)
Text_90:setCascadeColorEnabled(true)
Text_90:setCascadeOpacityEnabled(true)
Text_90:setAnchorPoint(0.0000, 0.5000)
Text_90:setPosition(85.2785, 351.7315)
Text_90:setTextColor({r = 51, g = 51, b = 51})
layout = ccui.LayoutComponent:bindLayoutComponent(Text_90)
layout:setPositionPercentX(0.1045)
layout:setPositionPercentY(0.6149)
layout:setPercentWidth(0.1569)
layout:setPercentHeight(0.0577)
layout:setSize({width = 128.0000, height = 33.0000})
layout:setLeftMargin(85.2785)
layout:setRightMargin(602.7216)
layout:setTopMargin(203.7685)
layout:setBottomMargin(335.2315)
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
txt_phone_phoneid:setTag(879)
txt_phone_phoneid:setCascadeColorEnabled(true)
txt_phone_phoneid:setCascadeOpacityEnabled(true)
txt_phone_phoneid:setAnchorPoint(0.0000, 0.5000)
txt_phone_phoneid:setPosition(250.5358, 353.0006)
txt_phone_phoneid:setColor({r = 184, g = 184, b = 184})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_phone_phoneid)
layout:setPositionPercentX(0.3070)
layout:setPositionPercentY(0.6171)
layout:setPercentWidth(0.5576)
layout:setPercentHeight(0.0594)
layout:setSize({width = 455.0000, height = 34.0000})
layout:setLeftMargin(250.5358)
layout:setRightMargin(110.4642)
layout:setTopMargin(201.9994)
layout:setBottomMargin(336.0006)
whole_panel:addChild(txt_phone_phoneid)

--Create line_3
local line_3 = ccui.ImageView:create()
line_3:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
line_3:loadTexture("hall/common/new_line.png",1)
line_3:setScale9Enabled(true)
line_3:setCapInsets({x = 2, y = 0, width = 1, height = 1})
line_3:setLayoutComponentEnabled(true)
line_3:setName("line_3")
line_3:setTag(871)
line_3:setCascadeColorEnabled(true)
line_3:setCascadeOpacityEnabled(true)
line_3:setPosition(471.9989, 247.9995)
line_3:setColor({r = 184, g = 184, b = 184})
layout = ccui.LayoutComponent:bindLayoutComponent(line_3)
layout:setPositionPercentX(0.5784)
layout:setPositionPercentY(0.4336)
layout:setPercentWidth(0.6299)
layout:setPercentHeight(0.0035)
layout:setSize({width = 514.0000, height = 2.0000})
layout:setLeftMargin(214.9989)
layout:setRightMargin(87.0011)
layout:setTopMargin(323.0005)
layout:setBottomMargin(246.9995)
whole_panel:addChild(line_3)

--Create line_1
local line_1 = ccui.ImageView:create()
line_1:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
line_1:loadTexture("hall/common/new_line.png",1)
line_1:setScale9Enabled(true)
line_1:setCapInsets({x = 2, y = 0, width = 1, height = 1})
line_1:setLayoutComponentEnabled(true)
line_1:setName("line_1")
line_1:setTag(878)
line_1:setCascadeColorEnabled(true)
line_1:setCascadeOpacityEnabled(true)
line_1:setPosition(471.9989, 333.9998)
line_1:setColor({r = 184, g = 184, b = 184})
layout = ccui.LayoutComponent:bindLayoutComponent(line_1)
layout:setPositionPercentX(0.5784)
layout:setPositionPercentY(0.5839)
layout:setPercentWidth(0.6299)
layout:setPercentHeight(0.0035)
layout:setSize({width = 514.0000, height = 2.0000})
layout:setLeftMargin(214.9989)
layout:setRightMargin(87.0011)
layout:setTopMargin(237.0002)
layout:setBottomMargin(332.9998)
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
Text_92:setTag(877)
Text_92:setCascadeColorEnabled(true)
Text_92:setCascadeOpacityEnabled(true)
Text_92:setAnchorPoint(0.0000, 0.5000)
Text_92:setPosition(87.9993, 263.4988)
Text_92:setTextColor({r = 51, g = 51, b = 51})
layout = ccui.LayoutComponent:bindLayoutComponent(Text_92)
layout:setPositionPercentX(0.1078)
layout:setPositionPercentY(0.4607)
layout:setPercentWidth(0.1961)
layout:setPercentHeight(0.0577)
layout:setSize({width = 160.0000, height = 33.0000})
layout:setLeftMargin(87.9993)
layout:setRightMargin(568.0007)
layout:setTopMargin(292.0012)
layout:setBottomMargin(246.9988)
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
txt_phone_code:setTag(876)
txt_phone_code:setCascadeColorEnabled(true)
txt_phone_code:setCascadeOpacityEnabled(true)
txt_phone_code:setAnchorPoint(0.0000, 0.5000)
txt_phone_code:setPosition(251.9069, 266.9999)
txt_phone_code:setColor({r = 184, g = 184, b = 184})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_phone_code)
layout:setPositionPercentX(0.3087)
layout:setPositionPercentY(0.4668)
layout:setPercentWidth(0.1716)
layout:setPercentHeight(0.0594)
layout:setSize({width = 140.0000, height = 34.0000})
layout:setLeftMargin(251.9069)
layout:setRightMargin(424.0931)
layout:setTopMargin(288.0001)
layout:setBottomMargin(249.9999)
whole_panel:addChild(txt_phone_code)

--Create btn_act_phone_code
local btn_act_phone_code = ccui.Layout:create()
btn_act_phone_code:ignoreContentAdaptWithSize(false)
btn_act_phone_code:setClippingEnabled(false)
btn_act_phone_code:setBackGroundColorOpacity(102)
btn_act_phone_code:setTouchEnabled(true);
btn_act_phone_code:setLayoutComponentEnabled(true)
btn_act_phone_code:setName("btn_act_phone_code")
btn_act_phone_code:setTag(873)
btn_act_phone_code:setCascadeColorEnabled(true)
btn_act_phone_code:setCascadeOpacityEnabled(true)
btn_act_phone_code:setAnchorPoint(0.5000, 0.5000)
btn_act_phone_code:setPosition(649.9783, 270.7213)
btn_act_phone_code:setColor({r = 22, g = 146, b = 206})
layout = ccui.LayoutComponent:bindLayoutComponent(btn_act_phone_code)
layout:setPositionPercentX(0.7965)
layout:setPositionPercentY(0.4733)
layout:setPercentWidth(0.3064)
layout:setPercentHeight(0.1573)
layout:setSize({width = 250.0000, height = 90.0000})
layout:setLeftMargin(524.9783)
layout:setRightMargin(41.0217)
layout:setTopMargin(256.2787)
layout:setBottomMargin(225.7213)
whole_panel:addChild(btn_act_phone_code)

--Create Text_7
local Text_7 = ccui.Text:create()
Text_7:ignoreContentAdaptWithSize(true)
Text_7:setTextAreaSize({width = 0, height = 0})
Text_7:setFontName("")
Text_7:setFontSize(30)
Text_7:setString([[获取验证码]])
Text_7:setLayoutComponentEnabled(true)
Text_7:setName("Text_7")
Text_7:setTag(874)
Text_7:setCascadeColorEnabled(true)
Text_7:setCascadeOpacityEnabled(true)
Text_7:setPosition(75.0000, 42.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(Text_7)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentX(0.3000)
layout:setPositionPercentY(0.4667)
layout:setPercentWidth(0.6000)
layout:setPercentHeight(0.3333)
layout:setSize({width = 150.0000, height = 30.0000})
layout:setRightMargin(100.0000)
layout:setTopMargin(33.0000)
layout:setBottomMargin(27.0000)
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
txt_phone_code_td:setTag(872)
txt_phone_code_td:setCascadeColorEnabled(true)
txt_phone_code_td:setCascadeOpacityEnabled(true)
txt_phone_code_td:setVisible(false)
txt_phone_code_td:setAnchorPoint(0.0000, 0.5000)
txt_phone_code_td:setPosition(692.0965, 268.2429)
txt_phone_code_td:setTextColor({r = 184, g = 184, b = 184})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_phone_code_td)
layout:setPositionPercentX(0.8482)
layout:setPositionPercentY(0.4690)
layout:setPercentWidth(0.0343)
layout:setPercentHeight(0.0490)
layout:setSize({width = 28.0000, height = 28.0000})
layout:setLeftMargin(692.0965)
layout:setRightMargin(95.9035)
layout:setTopMargin(289.7571)
layout:setBottomMargin(254.2429)
whole_panel:addChild(txt_phone_code_td)

--Create btn_bind
local btn_bind = ccui.Layout:create()
btn_bind:ignoreContentAdaptWithSize(false)
btn_bind:setClippingEnabled(false)
btn_bind:setBackGroundImageCapInsets({x = -4, y = -3, width = 10, height = 6})
btn_bind:setBackGroundColorOpacity(102)
btn_bind:setBackGroundImageScale9Enabled(true)
btn_bind:setTouchEnabled(true);
btn_bind:setLayoutComponentEnabled(true)
btn_bind:setName("btn_bind")
btn_bind:setTag(2018)
btn_bind:setCascadeColorEnabled(true)
btn_bind:setCascadeOpacityEnabled(true)
btn_bind:setAnchorPoint(0.5000, 0.5000)
btn_bind:setPosition(408.0000, 117.1419)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_bind)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.2048)
layout:setPercentWidth(0.3064)
layout:setPercentHeight(0.1049)
layout:setSize({width = 250.0000, height = 60.0000})
layout:setLeftMargin(283.0000)
layout:setRightMargin(283.0000)
layout:setTopMargin(424.8581)
layout:setBottomMargin(87.1419)
whole_panel:addChild(btn_bind)

--Create img_bg
local img_bg = ccui.ImageView:create()
img_bg:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
img_bg:loadTexture("hall/common/new_btn_noangle.png",1)
img_bg:setScale9Enabled(true)
img_bg:setCapInsets({x = 8, y = 8, width = 2, height = 2})
img_bg:setLayoutComponentEnabled(true)
img_bg:setName("img_bg")
img_bg:setTag(2129)
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
btn_bind:addChild(img_bg)

--Create txt_commit
local txt_commit = ccui.Text:create()
txt_commit:ignoreContentAdaptWithSize(true)
txt_commit:setTextAreaSize({width = 0, height = 0})
txt_commit:setFontName("")
txt_commit:setFontSize(32)
txt_commit:setString([[绑定]])
txt_commit:setLayoutComponentEnabled(true)
txt_commit:setName("txt_commit")
txt_commit:setTag(870)
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
btn_bind:addChild(txt_commit)

--Create Animation
result['animation'] = ccs.ActionTimeline:create()
  
result['animation']:setDuration(0)
result['animation']:setTimeSpeed(1.0000)
--Create Animation List

result['root'] = Node
return result;
end

return Result

