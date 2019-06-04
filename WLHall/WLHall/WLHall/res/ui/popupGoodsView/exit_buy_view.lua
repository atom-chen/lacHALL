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

--Create Panel
local Panel = ccui.Layout:create()
Panel:ignoreContentAdaptWithSize(false)
Panel:setClippingEnabled(false)
Panel:setTouchEnabled(true);
Panel:setLayoutComponentEnabled(true)
Panel:setName("Panel")
Panel:setTag(873)
Panel:setCascadeColorEnabled(true)
Panel:setCascadeOpacityEnabled(true)
Panel:setAnchorPoint(0.5000, 0.5000)
layout = ccui.LayoutComponent:bindLayoutComponent(Panel)
layout:setSize({width = 890.0000, height = 480.0000})
layout:setLeftMargin(-445.0000)
layout:setRightMargin(-445.0000)
layout:setTopMargin(-240.0000)
layout:setBottomMargin(-240.0000)
Node:addChild(Panel)

--Create img_Bg
local img_Bg = ccui.ImageView:create()
img_Bg:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
img_Bg:loadTexture("hall/common/new_pop_bg_3.png",1)
img_Bg:setScale9Enabled(true)
img_Bg:setCapInsets({x = 11, y = 11, width = 4, height = 3})
img_Bg:setLayoutComponentEnabled(true)
img_Bg:setName("img_Bg")
img_Bg:setTag(874)
img_Bg:setCascadeColorEnabled(true)
img_Bg:setCascadeOpacityEnabled(true)
img_Bg:setPosition(445.0000, 239.4240)
layout = ccui.LayoutComponent:bindLayoutComponent(img_Bg)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.4988)
layout:setPercentWidth(1.0112)
layout:setPercentHeight(1.0229)
layout:setSize({width = 900.0000, height = 491.0000})
layout:setLeftMargin(-5.0000)
layout:setRightMargin(-5.0000)
layout:setTopMargin(-4.9240)
layout:setBottomMargin(-6.0760)
Panel:addChild(img_Bg)

--Create img_Bg1
local img_Bg1 = ccui.ImageView:create()
img_Bg1:ignoreContentAdaptWithSize(false)
img_Bg1:loadTexture("hall/popupGoodsView/exitbuyview/bg_hs.png",0)
img_Bg1:setLayoutComponentEnabled(true)
img_Bg1:setName("img_Bg1")
img_Bg1:setTag(350)
img_Bg1:setCascadeColorEnabled(true)
img_Bg1:setCascadeOpacityEnabled(true)
img_Bg1:setPosition(445.0000, 254.4000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_Bg1)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5300)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(0.6500)
layout:setSize({width = 890.0000, height = 312.0000})
layout:setTopMargin(69.6000)
layout:setBottomMargin(98.4000)
Panel:addChild(img_Bg1)

--Create txt_name
local txt_name = ccui.Text:create()
txt_name:ignoreContentAdaptWithSize(true)
txt_name:setTextAreaSize({width = 0, height = 0})
txt_name:setFontName("")
txt_name:setFontSize(34)
txt_name:setString([[确定退出游戏？]])
txt_name:setLayoutComponentEnabled(true)
txt_name:setName("txt_name")
txt_name:setTag(349)
txt_name:setCascadeColorEnabled(true)
txt_name:setCascadeOpacityEnabled(true)
txt_name:setAnchorPoint(0.0000, 0.5000)
txt_name:setPosition(32.4972, 443.7546)
txt_name:setTextColor({r = 34, g = 34, b = 34})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_name)
layout:setPositionPercentX(0.0365)
layout:setPositionPercentY(0.9245)
layout:setPercentWidth(0.2674)
layout:setPercentHeight(0.0708)
layout:setSize({width = 238.0000, height = 34.0000})
layout:setLeftMargin(32.4972)
layout:setRightMargin(619.5028)
layout:setTopMargin(19.2454)
layout:setBottomMargin(426.7546)
Panel:addChild(txt_name)

--Create btn_exit
local btn_exit = ccui.Layout:create()
btn_exit:ignoreContentAdaptWithSize(false)
btn_exit:setClippingEnabled(false)
btn_exit:setTouchEnabled(true);
btn_exit:setLayoutComponentEnabled(true)
btn_exit:setName("btn_exit")
btn_exit:setTag(351)
btn_exit:setCascadeColorEnabled(true)
btn_exit:setCascadeOpacityEnabled(true)
btn_exit:setAnchorPoint(0.5000, 0.5000)
btn_exit:setPosition(541.7524, 47.2508)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_exit)
layout:setPositionPercentX(0.6087)
layout:setPositionPercentY(0.0984)
layout:setPercentWidth(0.2360)
layout:setPercentHeight(0.1375)
layout:setSize({width = 210.0000, height = 66.0000})
layout:setLeftMargin(436.7524)
layout:setRightMargin(243.2476)
layout:setTopMargin(399.7492)
layout:setBottomMargin(14.2508)
Panel:addChild(btn_exit)

--Create img_bg
local img_bg = ccui.ImageView:create()
img_bg:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
img_bg:loadTexture("hall/common/new_btn_noangle.png",1)
img_bg:setScale9Enabled(true)
img_bg:setCapInsets({x = 8, y = 8, width = 2, height = 2})
img_bg:setLayoutComponentEnabled(true)
img_bg:setName("img_bg")
img_bg:setTag(352)
img_bg:setCascadeColorEnabled(true)
img_bg:setCascadeOpacityEnabled(true)
img_bg:setPosition(105.0000, 33.0000)
img_bg:setColor({r = 16, g = 116, b = 233})
layout = ccui.LayoutComponent:bindLayoutComponent(img_bg)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(1.0000)
layout:setSize({width = 210.0000, height = 66.0000})
btn_exit:addChild(img_bg)

--Create txt_name
local txt_name = ccui.Text:create()
txt_name:ignoreContentAdaptWithSize(true)
txt_name:setTextAreaSize({width = 0, height = 0})
txt_name:setFontName("")
txt_name:setFontSize(34)
txt_name:setString([[退出]])
txt_name:setLayoutComponentEnabled(true)
txt_name:setName("txt_name")
txt_name:setTag(353)
txt_name:setCascadeColorEnabled(true)
txt_name:setCascadeOpacityEnabled(true)
txt_name:setPosition(105.0000, 33.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(txt_name)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.3238)
layout:setPercentHeight(0.5152)
layout:setSize({width = 68.0000, height = 34.0000})
layout:setLeftMargin(71.0000)
layout:setRightMargin(71.0000)
layout:setTopMargin(16.0000)
layout:setBottomMargin(16.0000)
btn_exit:addChild(txt_name)

--Create btn_cancel
local btn_cancel = ccui.Layout:create()
btn_cancel:ignoreContentAdaptWithSize(false)
btn_cancel:setClippingEnabled(false)
btn_cancel:setTouchEnabled(true);
btn_cancel:setLayoutComponentEnabled(true)
btn_cancel:setName("btn_cancel")
btn_cancel:setTag(354)
btn_cancel:setCascadeColorEnabled(true)
btn_cancel:setCascadeOpacityEnabled(true)
btn_cancel:setAnchorPoint(0.5000, 0.5000)
btn_cancel:setPosition(768.4987, 48.9100)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_cancel)
layout:setPositionPercentX(0.8635)
layout:setPositionPercentY(0.1019)
layout:setPercentWidth(0.2360)
layout:setPercentHeight(0.1375)
layout:setSize({width = 210.0000, height = 66.0000})
layout:setLeftMargin(663.4987)
layout:setRightMargin(16.5013)
layout:setTopMargin(398.0900)
layout:setBottomMargin(15.9100)
Panel:addChild(btn_cancel)

--Create img_bg
local img_bg = ccui.ImageView:create()
img_bg:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
img_bg:loadTexture("hall/common/new_btn_noangle.png",1)
img_bg:setScale9Enabled(true)
img_bg:setCapInsets({x = 8, y = 8, width = 2, height = 2})
img_bg:setLayoutComponentEnabled(true)
img_bg:setName("img_bg")
img_bg:setTag(355)
img_bg:setCascadeColorEnabled(true)
img_bg:setCascadeOpacityEnabled(true)
img_bg:setPosition(105.0000, 33.0000)
img_bg:setColor({r = 38, g = 155, b = 88})
layout = ccui.LayoutComponent:bindLayoutComponent(img_bg)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(1.0000)
layout:setSize({width = 210.0000, height = 66.0000})
btn_cancel:addChild(img_bg)

--Create txt_name
local txt_name = ccui.Text:create()
txt_name:ignoreContentAdaptWithSize(true)
txt_name:setTextAreaSize({width = 0, height = 0})
txt_name:setFontName("")
txt_name:setFontSize(34)
txt_name:setString([[再玩一会]])
txt_name:setLayoutComponentEnabled(true)
txt_name:setName("txt_name")
txt_name:setTag(356)
txt_name:setCascadeColorEnabled(true)
txt_name:setCascadeOpacityEnabled(true)
txt_name:setPosition(105.0000, 33.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(txt_name)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.6476)
layout:setPercentHeight(0.5152)
layout:setSize({width = 136.0000, height = 34.0000})
layout:setLeftMargin(37.0000)
layout:setRightMargin(37.0000)
layout:setTopMargin(16.0000)
layout:setBottomMargin(16.0000)
btn_cancel:addChild(txt_name)

--Create img_explain
local img_explain = ccui.Layout:create()
img_explain:ignoreContentAdaptWithSize(false)
img_explain:setClippingEnabled(false)
img_explain:setTouchEnabled(true);
img_explain:setLayoutComponentEnabled(true)
img_explain:setName("img_explain")
img_explain:setTag(416)
img_explain:setCascadeColorEnabled(true)
img_explain:setCascadeOpacityEnabled(true)
img_explain:setPosition(370.8117, 95.2729)
layout = ccui.LayoutComponent:bindLayoutComponent(img_explain)
layout:setPositionPercentX(0.4166)
layout:setPositionPercentY(0.1985)
layout:setPercentWidth(0.5618)
layout:setPercentHeight(0.5833)
layout:setSize({width = 500.0000, height = 280.0000})
layout:setLeftMargin(370.8117)
layout:setRightMargin(19.1883)
layout:setTopMargin(104.7271)
layout:setBottomMargin(95.2729)
Panel:addChild(img_explain)

--Create time_atlas
local time_atlas = ccui.Text:create()
time_atlas:ignoreContentAdaptWithSize(true)
time_atlas:setTextAreaSize({width = 0, height = 0})
time_atlas:setFontName("")
time_atlas:setFontSize(28)
time_atlas:setString([[99:11:11]])
time_atlas:setLayoutComponentEnabled(true)
time_atlas:setName("time_atlas")
time_atlas:setTag(2047)
time_atlas:setCascadeColorEnabled(true)
time_atlas:setCascadeOpacityEnabled(true)
time_atlas:setAnchorPoint(0.0000, 0.5000)
time_atlas:setPosition(255.1861, 191.0700)
layout = ccui.LayoutComponent:bindLayoutComponent(time_atlas)
layout:setPositionPercentX(0.5104)
layout:setPositionPercentY(0.6824)
layout:setPercentWidth(0.2240)
layout:setPercentHeight(0.1000)
layout:setSize({width = 112.0000, height = 28.0000})
layout:setLeftMargin(255.1861)
layout:setRightMargin(132.8139)
layout:setTopMargin(74.9300)
layout:setBottomMargin(177.0700)
img_explain:addChild(time_atlas)

--Create txt_link
local txt_link = ccui.Layout:create()
txt_link:ignoreContentAdaptWithSize(false)
txt_link:setClippingEnabled(false)
txt_link:setBackGroundColorType(1)
txt_link:setBackGroundColor({r = 254, g = 254, b = 254})
txt_link:setTouchEnabled(true);
txt_link:setLayoutComponentEnabled(true)
txt_link:setName("txt_link")
txt_link:setTag(3969)
txt_link:setCascadeColorEnabled(true)
txt_link:setCascadeOpacityEnabled(true)
txt_link:setPosition(112.5400, 134.3600)
layout = ccui.LayoutComponent:bindLayoutComponent(txt_link)
layout:setPositionPercentX(0.2251)
layout:setPositionPercentY(0.4799)
layout:setPercentWidth(0.2020)
layout:setPercentHeight(0.0036)
layout:setSize({width = 101.0000, height = 1.0000})
layout:setLeftMargin(112.5400)
layout:setRightMargin(286.4600)
layout:setTopMargin(144.6400)
layout:setBottomMargin(134.3600)
img_explain:addChild(txt_link)

--Create txt_yuanjia
local txt_yuanjia = ccui.Text:create()
txt_yuanjia:ignoreContentAdaptWithSize(true)
txt_yuanjia:setTextAreaSize({width = 0, height = 0})
txt_yuanjia:setFontName("")
txt_yuanjia:setFontSize(26)
txt_yuanjia:setString([[原价68元]])
txt_yuanjia:setTextHorizontalAlignment(1)
txt_yuanjia:setTextVerticalAlignment(1)
txt_yuanjia:setLayoutComponentEnabled(true)
txt_yuanjia:setName("txt_yuanjia")
txt_yuanjia:setTag(410)
txt_yuanjia:setCascadeColorEnabled(true)
txt_yuanjia:setCascadeOpacityEnabled(true)
txt_yuanjia:setAnchorPoint(0.0000, 0.5000)
txt_yuanjia:setPosition(110.1176, 135.2278)
txt_yuanjia:setTextColor({r = 254, g = 254, b = 254})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_yuanjia)
layout:setPositionPercentX(0.2202)
layout:setPositionPercentY(0.4830)
layout:setPercentWidth(0.2080)
layout:setPercentHeight(0.0929)
layout:setSize({width = 104.0000, height = 26.0000})
layout:setLeftMargin(110.1176)
layout:setRightMargin(285.8824)
layout:setTopMargin(131.7722)
layout:setBottomMargin(122.2278)
img_explain:addChild(txt_yuanjia)

--Create txt_tejia
local txt_tejia = ccui.Text:create()
txt_tejia:ignoreContentAdaptWithSize(true)
txt_tejia:setTextAreaSize({width = 0, height = 0})
txt_tejia:setFontName("")
txt_tejia:setFontSize(37)
txt_tejia:setString([[特价9.8元]])
txt_tejia:setTextHorizontalAlignment(1)
txt_tejia:setTextVerticalAlignment(1)
txt_tejia:setLayoutComponentEnabled(true)
txt_tejia:setName("txt_tejia")
txt_tejia:setTag(411)
txt_tejia:setCascadeColorEnabled(true)
txt_tejia:setCascadeOpacityEnabled(true)
txt_tejia:setAnchorPoint(0.0000, 0.5000)
txt_tejia:setPosition(245.4546, 135.2300)
txt_tejia:setTextColor({r = 243, g = 226, b = 64})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_tejia)
layout:setPositionPercentX(0.4909)
layout:setPositionPercentY(0.4830)
layout:setPercentWidth(0.3360)
layout:setPercentHeight(0.1321)
layout:setSize({width = 168.0000, height = 37.0000})
layout:setLeftMargin(245.4546)
layout:setRightMargin(86.5454)
layout:setTopMargin(126.2700)
layout:setBottomMargin(116.7300)
img_explain:addChild(txt_tejia)

--Create btn_buy
local btn_buy = ccui.Layout:create()
btn_buy:ignoreContentAdaptWithSize(false)
btn_buy:setClippingEnabled(false)
btn_buy:setBackGroundColorOpacity(102)
btn_buy:setTouchEnabled(true);
btn_buy:setLayoutComponentEnabled(true)
btn_buy:setName("btn_buy")
btn_buy:setTag(597)
btn_buy:setCascadeColorEnabled(true)
btn_buy:setCascadeOpacityEnabled(true)
btn_buy:setAnchorPoint(0.5000, 0.5000)
btn_buy:setPosition(264.6000, 59.4320)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_buy)
layout:setPositionPercentX(0.5292)
layout:setPositionPercentY(0.2123)
layout:setPercentWidth(0.4400)
layout:setPercentHeight(0.2500)
layout:setSize({width = 220.0000, height = 70.0000})
layout:setLeftMargin(154.6000)
layout:setRightMargin(125.4000)
layout:setTopMargin(185.5680)
layout:setBottomMargin(24.4320)
img_explain:addChild(btn_buy)

--Create img_buy
local img_buy = ccui.ImageView:create()
img_buy:ignoreContentAdaptWithSize(false)
img_buy:loadTexture("hall/popupGoodsView/exitbuyview/btn_ljqg.png",0)
img_buy:setLayoutComponentEnabled(true)
img_buy:setName("img_buy")
img_buy:setTag(598)
img_buy:setCascadeColorEnabled(true)
img_buy:setCascadeOpacityEnabled(true)
img_buy:setPosition(110.0000, 35.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_buy)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(1.0091)
layout:setPercentHeight(0.9714)
layout:setSize({width = 222.0000, height = 68.0000})
layout:setLeftMargin(-1.0000)
layout:setRightMargin(-1.0000)
layout:setTopMargin(1.0000)
layout:setBottomMargin(1.0000)
btn_buy:addChild(img_buy)

--Create txt_buy
local txt_buy = ccui.Text:create()
txt_buy:ignoreContentAdaptWithSize(true)
txt_buy:setTextAreaSize({width = 0, height = 0})
txt_buy:setFontName("")
txt_buy:setFontSize(30)
txt_buy:setString([[立即抢购]])
txt_buy:setTextHorizontalAlignment(1)
txt_buy:setTextVerticalAlignment(1)
txt_buy:setLayoutComponentEnabled(true)
txt_buy:setName("txt_buy")
txt_buy:setTag(414)
txt_buy:setCascadeColorEnabled(true)
txt_buy:setCascadeOpacityEnabled(true)
txt_buy:setPosition(110.0000, 35.0000)
txt_buy:setRotationSkewX(-1.0107)
txt_buy:setRotationSkewY(-1.0118)
txt_buy:setTextColor({r = 164, g = 61, b = 21})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_buy)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.5455)
layout:setPercentHeight(0.4286)
layout:setSize({width = 120.0000, height = 30.0000})
layout:setLeftMargin(50.0000)
layout:setRightMargin(50.0000)
layout:setTopMargin(20.0000)
layout:setBottomMargin(20.0000)
btn_buy:addChild(txt_buy)

--Create txt_title
local txt_title = ccui.Text:create()
txt_title:ignoreContentAdaptWithSize(true)
txt_title:setTextAreaSize({width = 0, height = 0})
txt_title:setFontName("")
txt_title:setFontSize(25)
txt_title:setString([[限时特价]])
txt_title:setLayoutComponentEnabled(true)
txt_title:setName("txt_title")
txt_title:setTag(2046)
txt_title:setCascadeColorEnabled(true)
txt_title:setCascadeOpacityEnabled(true)
txt_title:setPosition(180.9261, 191.0700)
layout = ccui.LayoutComponent:bindLayoutComponent(txt_title)
layout:setPositionPercentX(0.3619)
layout:setPositionPercentY(0.6824)
layout:setPercentWidth(0.2000)
layout:setPercentHeight(0.0893)
layout:setSize({width = 100.0000, height = 25.0000})
layout:setLeftMargin(130.9261)
layout:setRightMargin(269.0739)
layout:setTopMargin(76.4300)
layout:setBottomMargin(178.5700)
img_explain:addChild(txt_title)

--Create Image_good
local Image_good = ccui.Layout:create()
Image_good:ignoreContentAdaptWithSize(false)
Image_good:setClippingEnabled(false)
Image_good:setTouchEnabled(true);
Image_good:setLayoutComponentEnabled(true)
Image_good:setName("Image_good")
Image_good:setTag(2045)
Image_good:setCascadeColorEnabled(true)
Image_good:setCascadeOpacityEnabled(true)
Image_good:setPosition(72.8852, 125.5725)
layout = ccui.LayoutComponent:bindLayoutComponent(Image_good)
layout:setPositionPercentX(0.0819)
layout:setPositionPercentY(0.2616)
layout:setPercentWidth(0.2584)
layout:setPercentHeight(0.4792)
layout:setSize({width = 230.0000, height = 230.0000})
layout:setLeftMargin(72.8852)
layout:setRightMargin(587.1148)
layout:setTopMargin(124.4275)
layout:setBottomMargin(125.5725)
Panel:addChild(Image_good)

--Create img_frame
local img_frame = ccui.Layout:create()
img_frame:ignoreContentAdaptWithSize(false)
img_frame:setClippingEnabled(false)
img_frame:setTouchEnabled(true);
img_frame:setLayoutComponentEnabled(true)
img_frame:setName("img_frame")
img_frame:setTag(635)
img_frame:setCascadeColorEnabled(true)
img_frame:setCascadeOpacityEnabled(true)
img_frame:setPosition(0.4432, 1.8831)
layout = ccui.LayoutComponent:bindLayoutComponent(img_frame)
layout:setPositionPercentX(0.0019)
layout:setPositionPercentY(0.0082)
layout:setPercentWidth(0.9565)
layout:setPercentHeight(0.9565)
layout:setSize({width = 220.0000, height = 220.0000})
layout:setLeftMargin(0.4432)
layout:setRightMargin(9.5568)
layout:setTopMargin(8.1169)
layout:setBottomMargin(1.8831)
Image_good:addChild(img_frame)

--Create img_prop
local img_prop = ccui.ImageView:create()
img_prop:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/activeSpecials.plist")
img_prop:loadTexture("hall/active/activespecials/timed_goods_gold_1.png",1)
img_prop:setLayoutComponentEnabled(true)
img_prop:setName("img_prop")
img_prop:setTag(415)
img_prop:setCascadeColorEnabled(true)
img_prop:setCascadeOpacityEnabled(true)
img_prop:setAnchorPoint(0.5028, 0.0000)
img_prop:setPosition(104.3900, 67.0109)
img_prop:setScaleX(0.8200)
img_prop:setScaleY(0.8200)
layout = ccui.LayoutComponent:bindLayoutComponent(img_prop)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentX(0.4745)
layout:setPositionPercentY(0.3046)
layout:setPercentWidth(0.6000)
layout:setPercentHeight(0.6909)
layout:setSize({width = 132.0000, height = 152.0000})
layout:setLeftMargin(38.0204)
layout:setRightMargin(49.9796)
layout:setTopMargin(0.9891)
layout:setBottomMargin(67.0109)
img_frame:addChild(img_prop)

--Create txt_count
local txt_count = ccui.Text:create()
txt_count:ignoreContentAdaptWithSize(true)
txt_count:setTextAreaSize({width = 0, height = 0})
txt_count:setFontName("")
txt_count:setFontSize(28)
txt_count:setString([[68万豆]])
txt_count:setTextHorizontalAlignment(1)
txt_count:setTextVerticalAlignment(1)
txt_count:setLayoutComponentEnabled(true)
txt_count:setName("txt_count")
txt_count:setTag(412)
txt_count:setCascadeColorEnabled(true)
txt_count:setCascadeOpacityEnabled(true)
txt_count:setPosition(116.8130, 22.0004)
layout = ccui.LayoutComponent:bindLayoutComponent(txt_count)
layout:setPositionPercentX(0.5310)
layout:setPositionPercentY(0.1000)
layout:setPercentWidth(0.3818)
layout:setPercentHeight(0.1273)
layout:setSize({width = 84.0000, height = 28.0000})
layout:setLeftMargin(74.8130)
layout:setRightMargin(61.1870)
layout:setTopMargin(183.9996)
layout:setBottomMargin(8.0004)
img_frame:addChild(txt_count)

--Create Image_icon
local Image_icon = ccui.Layout:create()
Image_icon:ignoreContentAdaptWithSize(false)
Image_icon:setClippingEnabled(false)
Image_icon:setTouchEnabled(true);
Image_icon:setLayoutComponentEnabled(true)
Image_icon:setName("Image_icon")
Image_icon:setTag(2044)
Image_icon:setCascadeColorEnabled(true)
Image_icon:setCascadeOpacityEnabled(true)
Image_icon:setAnchorPoint(0.5000, 0.5000)
Image_icon:setPosition(-5.0005, 205.9971)
layout = ccui.LayoutComponent:bindLayoutComponent(Image_icon)
layout:setPositionPercentX(-0.0217)
layout:setPositionPercentY(0.8956)
layout:setPercentWidth(0.4478)
layout:setPercentHeight(0.4478)
layout:setSize({width = 103.0000, height = 103.0000})
layout:setLeftMargin(-56.5005)
layout:setRightMargin(183.5005)
layout:setTopMargin(-27.4971)
layout:setBottomMargin(154.4971)
Image_good:addChild(Image_icon)

--Create txt_1
local txt_1 = ccui.Text:create()
txt_1:ignoreContentAdaptWithSize(true)
txt_1:setTextAreaSize({width = 0, height = 0})
txt_1:setFontSize(25)
txt_1:setString([[1.4折]])
txt_1:setTextHorizontalAlignment(1)
txt_1:setTextVerticalAlignment(1)
txt_1:setLayoutComponentEnabled(true)
txt_1:setName("txt_1")
txt_1:setTag(407)
txt_1:setCascadeColorEnabled(true)
txt_1:setCascadeOpacityEnabled(true)
txt_1:setAnchorPoint(0.0000, 0.5000)
txt_1:setPosition(19.0000, 65.0000)
txt_1:setRotationSkewX(10.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(txt_1)
layout:setPositionPercentX(0.1845)
layout:setPositionPercentY(0.6311)
layout:setPercentWidth(0.6214)
layout:setPercentHeight(0.2427)
layout:setSize({width = 64.0000, height = 25.0000})
layout:setLeftMargin(19.0000)
layout:setRightMargin(20.0000)
layout:setTopMargin(25.5000)
layout:setBottomMargin(52.5000)
Image_icon:addChild(txt_1)

--Create txt_2
local txt_2 = ccui.Text:create()
txt_2:ignoreContentAdaptWithSize(true)
txt_2:setTextAreaSize({width = 0, height = 0})
txt_2:setFontSize(25)
txt_2:setString([[限3次]])
txt_2:setTextHorizontalAlignment(1)
txt_2:setTextVerticalAlignment(1)
txt_2:setLayoutComponentEnabled(true)
txt_2:setName("txt_2")
txt_2:setTag(408)
txt_2:setCascadeColorEnabled(true)
txt_2:setCascadeOpacityEnabled(true)
txt_2:setAnchorPoint(0.0000, 0.5000)
txt_2:setPosition(17.0000, 35.0000)
txt_2:setRotationSkewX(10.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(txt_2)
layout:setPositionPercentX(0.1650)
layout:setPositionPercentY(0.3398)
layout:setPercentWidth(0.6117)
layout:setPercentHeight(0.2427)
layout:setSize({width = 63.0000, height = 25.0000})
layout:setLeftMargin(17.0000)
layout:setRightMargin(23.0000)
layout:setTopMargin(55.5000)
layout:setBottomMargin(22.5000)
Image_icon:addChild(txt_2)

--Create Animation
result['animation'] = ccs.ActionTimeline:create()
  
result['animation']:setDuration(0)
result['animation']:setTimeSpeed(1.0000)
--Create Animation List

result['root'] = Node
return result;
end

return Result

