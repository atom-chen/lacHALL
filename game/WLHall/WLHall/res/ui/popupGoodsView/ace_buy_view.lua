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
Panel:setBackGroundColorType(1)
Panel:setBackGroundColor({r = 150, g = 200, b = 255})
Panel:setBackGroundColorOpacity(0)
Panel:setTouchEnabled(true);
Panel:setLayoutComponentEnabled(true)
Panel:setName("Panel")
Panel:setTag(873)
Panel:setCascadeColorEnabled(true)
Panel:setCascadeOpacityEnabled(true)
Panel:setAnchorPoint(0.5000, 0.5000)
layout = ccui.LayoutComponent:bindLayoutComponent(Panel)
layout:setSize({width = 1064.0000, height = 627.0000})
layout:setLeftMargin(-532.0000)
layout:setRightMargin(-532.0000)
layout:setTopMargin(-313.5000)
layout:setBottomMargin(-313.5000)
Node:addChild(Panel)

--Create img_Bg
local img_Bg = ccui.ImageView:create()
img_Bg:ignoreContentAdaptWithSize(false)
img_Bg:loadTexture("hall/popupGoodsView/aceBuyView/bg.png",0)
img_Bg:setLayoutComponentEnabled(true)
img_Bg:setName("img_Bg")
img_Bg:setTag(874)
img_Bg:setCascadeColorEnabled(true)
img_Bg:setCascadeOpacityEnabled(true)
img_Bg:setPosition(533.6075, 314.4759)
layout = ccui.LayoutComponent:bindLayoutComponent(img_Bg)
layout:setPositionPercentX(0.5015)
layout:setPositionPercentY(0.5016)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(1.0000)
layout:setSize({width = 1064.0000, height = 627.0000})
layout:setLeftMargin(1.6075)
layout:setRightMargin(-1.6074)
layout:setTopMargin(-0.9759)
layout:setBottomMargin(0.9759)
Panel:addChild(img_Bg)

--Create img_frame1
local img_frame1 = ccui.ImageView:create()
img_frame1:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/acebuy.plist")
img_frame1:loadTexture("hall/popupGoodsView/aceBuyView/frame.png",1)
img_frame1:setScale9Enabled(true)
img_frame1:setCapInsets({x = 10, y = 10, width = 10, height = 10})
img_frame1:setLayoutComponentEnabled(true)
img_frame1:setName("img_frame1")
img_frame1:setTag(875)
img_frame1:setCascadeColorEnabled(true)
img_frame1:setCascadeOpacityEnabled(true)
img_frame1:setPosition(289.8116, 205.1479)
layout = ccui.LayoutComponent:bindLayoutComponent(img_frame1)
layout:setPositionPercentX(0.2724)
layout:setPositionPercentY(0.3272)
layout:setPercentWidth(0.1250)
layout:setPercentHeight(0.2121)
layout:setSize({width = 133.0000, height = 133.0000})
layout:setLeftMargin(223.3116)
layout:setRightMargin(707.6884)
layout:setTopMargin(355.3521)
layout:setBottomMargin(138.6479)
Panel:addChild(img_frame1)

--Create prop_icon
local prop_icon = ccui.ImageView:create()
prop_icon:ignoreContentAdaptWithSize(false)
prop_icon:loadTexture("common/prop/jindou_1.png",0)
prop_icon:setLayoutComponentEnabled(true)
prop_icon:setName("prop_icon")
prop_icon:setTag(889)
prop_icon:setCascadeColorEnabled(true)
prop_icon:setCascadeOpacityEnabled(true)
prop_icon:setPosition(66.2778, 82.1980)
layout = ccui.LayoutComponent:bindLayoutComponent(prop_icon)
layout:setPositionPercentX(0.4983)
layout:setPositionPercentY(0.6180)
layout:setPercentWidth(0.8421)
layout:setPercentHeight(0.8421)
layout:setSize({width = 112.0000, height = 112.0000})
layout:setLeftMargin(10.2778)
layout:setRightMargin(10.7222)
layout:setTopMargin(-5.1980)
layout:setBottomMargin(26.1980)
img_frame1:addChild(prop_icon)

--Create prop_count
local prop_count = ccui.Text:create()
prop_count:ignoreContentAdaptWithSize(true)
prop_count:setTextAreaSize({width = 0, height = 0})
prop_count:setFontSize(27)
prop_count:setString([[256万豆]])
prop_count:setLayoutComponentEnabled(true)
prop_count:setName("prop_count")
prop_count:setTag(892)
prop_count:setCascadeColorEnabled(true)
prop_count:setCascadeOpacityEnabled(true)
prop_count:setPosition(66.6308, 19.2615)
prop_count:setTextColor({r = 213, g = 70, b = 0})
layout = ccui.LayoutComponent:bindLayoutComponent(prop_count)
layout:setPositionPercentX(0.5010)
layout:setPositionPercentY(0.1448)
layout:setPercentWidth(0.7218)
layout:setPercentHeight(0.2030)
layout:setSize({width = 96.0000, height = 27.0000})
layout:setLeftMargin(18.6308)
layout:setRightMargin(18.3692)
layout:setTopMargin(100.2385)
layout:setBottomMargin(5.7615)
img_frame1:addChild(prop_count)

--Create img_frame2
local img_frame2 = ccui.ImageView:create()
img_frame2:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/acebuy.plist")
img_frame2:loadTexture("hall/popupGoodsView/aceBuyView/frame.png",1)
img_frame2:setScale9Enabled(true)
img_frame2:setCapInsets({x = 10, y = 10, width = 10, height = 10})
img_frame2:setLayoutComponentEnabled(true)
img_frame2:setName("img_frame2")
img_frame2:setTag(876)
img_frame2:setCascadeColorEnabled(true)
img_frame2:setCascadeOpacityEnabled(true)
img_frame2:setPosition(432.7614, 204.3367)
layout = ccui.LayoutComponent:bindLayoutComponent(img_frame2)
layout:setPositionPercentX(0.4067)
layout:setPositionPercentY(0.3259)
layout:setPercentWidth(0.1250)
layout:setPercentHeight(0.2121)
layout:setSize({width = 133.0000, height = 133.0000})
layout:setLeftMargin(366.2614)
layout:setRightMargin(564.7386)
layout:setTopMargin(356.1633)
layout:setBottomMargin(137.8367)
Panel:addChild(img_frame2)

--Create prop_icon
local prop_icon = ccui.ImageView:create()
prop_icon:ignoreContentAdaptWithSize(false)
prop_icon:loadTexture("common/prop/jindou_1.png",0)
prop_icon:setLayoutComponentEnabled(true)
prop_icon:setName("prop_icon")
prop_icon:setTag(890)
prop_icon:setCascadeColorEnabled(true)
prop_icon:setCascadeOpacityEnabled(true)
prop_icon:setPosition(66.8459, 83.0507)
layout = ccui.LayoutComponent:bindLayoutComponent(prop_icon)
layout:setPositionPercentX(0.5026)
layout:setPositionPercentY(0.6244)
layout:setPercentWidth(0.8421)
layout:setPercentHeight(0.8421)
layout:setSize({width = 112.0000, height = 112.0000})
layout:setLeftMargin(10.8459)
layout:setRightMargin(10.1541)
layout:setTopMargin(-6.0507)
layout:setBottomMargin(27.0507)
img_frame2:addChild(prop_icon)

--Create prop_count
local prop_count = ccui.Text:create()
prop_count:ignoreContentAdaptWithSize(true)
prop_count:setTextAreaSize({width = 0, height = 0})
prop_count:setFontSize(30)
prop_count:setString([[10张]])
prop_count:setLayoutComponentEnabled(true)
prop_count:setName("prop_count")
prop_count:setTag(893)
prop_count:setCascadeColorEnabled(true)
prop_count:setCascadeOpacityEnabled(true)
prop_count:setPosition(66.3456, 20.5464)
prop_count:setTextColor({r = 213, g = 70, b = 0})
layout = ccui.LayoutComponent:bindLayoutComponent(prop_count)
layout:setPositionPercentX(0.4988)
layout:setPositionPercentY(0.1545)
layout:setPercentWidth(0.4511)
layout:setPercentHeight(0.2256)
layout:setSize({width = 60.0000, height = 30.0000})
layout:setLeftMargin(36.3456)
layout:setRightMargin(36.6544)
layout:setTopMargin(97.4536)
layout:setBottomMargin(5.5464)
img_frame2:addChild(prop_count)

--Create img_frame3
local img_frame3 = ccui.ImageView:create()
img_frame3:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/acebuy.plist")
img_frame3:loadTexture("hall/popupGoodsView/aceBuyView/frame.png",1)
img_frame3:setScale9Enabled(true)
img_frame3:setCapInsets({x = 10, y = 10, width = 10, height = 10})
img_frame3:setLayoutComponentEnabled(true)
img_frame3:setName("img_frame3")
img_frame3:setTag(877)
img_frame3:setCascadeColorEnabled(true)
img_frame3:setCascadeOpacityEnabled(true)
img_frame3:setPosition(575.5791, 204.1803)
layout = ccui.LayoutComponent:bindLayoutComponent(img_frame3)
layout:setPositionPercentX(0.5410)
layout:setPositionPercentY(0.3256)
layout:setPercentWidth(0.1250)
layout:setPercentHeight(0.2121)
layout:setSize({width = 133.0000, height = 133.0000})
layout:setLeftMargin(509.0791)
layout:setRightMargin(421.9209)
layout:setTopMargin(356.3197)
layout:setBottomMargin(137.6803)
Panel:addChild(img_frame3)

--Create prop_icon
local prop_icon = ccui.ImageView:create()
prop_icon:ignoreContentAdaptWithSize(false)
prop_icon:loadTexture("common/prop/jindou_1.png",0)
prop_icon:setLayoutComponentEnabled(true)
prop_icon:setName("prop_icon")
prop_icon:setTag(891)
prop_icon:setCascadeColorEnabled(true)
prop_icon:setCascadeOpacityEnabled(true)
prop_icon:setPosition(65.4075, 83.9028)
layout = ccui.LayoutComponent:bindLayoutComponent(prop_icon)
layout:setPositionPercentX(0.4918)
layout:setPositionPercentY(0.6308)
layout:setPercentWidth(0.8421)
layout:setPercentHeight(0.8421)
layout:setSize({width = 112.0000, height = 112.0000})
layout:setLeftMargin(9.4075)
layout:setRightMargin(11.5925)
layout:setTopMargin(-6.9028)
layout:setBottomMargin(27.9028)
img_frame3:addChild(prop_icon)

--Create prop_count
local prop_count = ccui.Text:create()
prop_count:ignoreContentAdaptWithSize(true)
prop_count:setTextAreaSize({width = 0, height = 0})
prop_count:setFontSize(30)
prop_count:setString([[10张]])
prop_count:setLayoutComponentEnabled(true)
prop_count:setName("prop_count")
prop_count:setTag(894)
prop_count:setCascadeColorEnabled(true)
prop_count:setCascadeOpacityEnabled(true)
prop_count:setPosition(66.3546, 19.2515)
prop_count:setTextColor({r = 213, g = 70, b = 0})
layout = ccui.LayoutComponent:bindLayoutComponent(prop_count)
layout:setPositionPercentX(0.4989)
layout:setPositionPercentY(0.1447)
layout:setPercentWidth(0.4511)
layout:setPercentHeight(0.2256)
layout:setSize({width = 60.0000, height = 30.0000})
layout:setLeftMargin(36.3546)
layout:setRightMargin(36.6454)
layout:setTopMargin(98.7485)
layout:setBottomMargin(4.2515)
img_frame3:addChild(prop_count)

--Create buy_button
local buy_button = ccui.Button:create()
buy_button:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/acebuy.plist")
buy_button:loadTextureNormal("hall/popupGoodsView/aceBuyView/buy_btn.png",1)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/acebuy.plist")
buy_button:loadTexturePressed("hall/popupGoodsView/aceBuyView/buy_btn.png",1)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/acebuy.plist")
buy_button:loadTextureDisabled("hall/popupGoodsView/aceBuyView/buy_btn.png",1)
buy_button:setTitleFontSize(14)
buy_button:setTitleColor({r = 65, g = 65, b = 70})
buy_button:setScale9Enabled(true)
buy_button:setCapInsets({x = 15, y = 11, width = 310, height = 64})
buy_button:setLayoutComponentEnabled(true)
buy_button:setName("buy_button")
buy_button:setTag(5)
buy_button:setCascadeColorEnabled(true)
buy_button:setCascadeOpacityEnabled(true)
buy_button:setVisible(false)
buy_button:setPosition(543.0002, 47.2956)
layout = ccui.LayoutComponent:bindLayoutComponent(buy_button)
layout:setPositionPercentX(0.5103)
layout:setPositionPercentY(0.0754)
layout:setPercentWidth(0.3195)
layout:setPercentHeight(0.1372)
layout:setSize({width = 340.0000, height = 86.0000})
layout:setLeftMargin(373.0002)
layout:setRightMargin(350.9998)
layout:setTopMargin(536.7044)
layout:setBottomMargin(4.2956)
Panel:addChild(buy_button)

--Create btn_close
local btn_close = ccui.Button:create()
btn_close:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/acebuy.plist")
btn_close:loadTextureNormal("hall/popupGoodsView/aceBuyView/close.png",1)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/acebuy.plist")
btn_close:loadTexturePressed("hall/popupGoodsView/aceBuyView/close.png",1)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/acebuy.plist")
btn_close:loadTextureDisabled("hall/popupGoodsView/aceBuyView/close.png",1)
btn_close:setTitleFontSize(14)
btn_close:setTitleColor({r = 65, g = 65, b = 70})
btn_close:setScale9Enabled(true)
btn_close:setCapInsets({x = 15, y = 11, width = 20, height = 28})
btn_close:setLayoutComponentEnabled(true)
btn_close:setName("btn_close")
btn_close:setTag(881)
btn_close:setCascadeColorEnabled(true)
btn_close:setCascadeOpacityEnabled(true)
btn_close:setAnchorPoint(0.5161, 0.4923)
btn_close:setPosition(1013.6360, 575.0370)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_close)
layout:setPositionPercentX(0.9527)
layout:setPositionPercentY(0.9171)
layout:setPercentWidth(0.0470)
layout:setPercentHeight(0.0797)
layout:setSize({width = 50.0000, height = 50.0000})
layout:setLeftMargin(987.8314)
layout:setRightMargin(26.1686)
layout:setTopMargin(26.5780)
layout:setBottomMargin(550.4220)
Panel:addChild(btn_close)

--Create content_text_1
local content_text_1 = ccui.Text:create()
content_text_1:ignoreContentAdaptWithSize(true)
content_text_1:setTextAreaSize({width = 0, height = 0})
content_text_1:setFontSize(35)
content_text_1:setString([[全国仅7%人可获得！]])
content_text_1:setLayoutComponentEnabled(true)
content_text_1:setName("content_text_1")
content_text_1:setTag(895)
content_text_1:setCascadeColorEnabled(true)
content_text_1:setCascadeOpacityEnabled(true)
content_text_1:setPosition(420.0909, 343.8102)
content_text_1:setTextColor({r = 213, g = 70, b = 0})
layout = ccui.LayoutComponent:bindLayoutComponent(content_text_1)
layout:setPositionPercentX(0.3948)
layout:setPositionPercentY(0.5483)
layout:setPercentWidth(0.2970)
layout:setPercentHeight(0.0558)
layout:setSize({width = 316.0000, height = 35.0000})
layout:setLeftMargin(262.0909)
layout:setRightMargin(485.9091)
layout:setTopMargin(265.6898)
layout:setBottomMargin(326.3102)
Panel:addChild(content_text_1)

--Create content_text_2
local content_text_2 = ccui.Text:create()
content_text_2:ignoreContentAdaptWithSize(true)
content_text_2:setTextAreaSize({width = 0, height = 0})
content_text_2:setFontSize(23)
content_text_2:setString([[送您一次专享礼包购买机会]])
content_text_2:setLayoutComponentEnabled(true)
content_text_2:setName("content_text_2")
content_text_2:setTag(896)
content_text_2:setCascadeColorEnabled(true)
content_text_2:setCascadeOpacityEnabled(true)
content_text_2:setPosition(429.7736, 301.7082)
content_text_2:setTextColor({r = 103, g = 34, b = 0})
layout = ccui.LayoutComponent:bindLayoutComponent(content_text_2)
layout:setPositionPercentX(0.4039)
layout:setPositionPercentY(0.4812)
layout:setPercentWidth(0.2594)
layout:setPercentHeight(0.0367)
layout:setSize({width = 276.0000, height = 23.0000})
layout:setLeftMargin(291.7736)
layout:setRightMargin(496.2264)
layout:setTopMargin(313.7918)
layout:setBottomMargin(290.2082)
Panel:addChild(content_text_2)

--Create content_text_price
local content_text_price = ccui.Text:create()
content_text_price:ignoreContentAdaptWithSize(true)
content_text_price:setTextAreaSize({width = 0, height = 0})
content_text_price:setFontSize(33)
content_text_price:setString([[现价：128元]])
content_text_price:setLayoutComponentEnabled(true)
content_text_price:setName("content_text_price")
content_text_price:setTag(897)
content_text_price:setCascadeColorEnabled(true)
content_text_price:setCascadeOpacityEnabled(true)
content_text_price:setPosition(790.4700, 230.3600)
content_text_price:setTextColor({r = 103, g = 34, b = 0})
layout = ccui.LayoutComponent:bindLayoutComponent(content_text_price)
layout:setPositionPercentX(0.7429)
layout:setPositionPercentY(0.3674)
layout:setPercentWidth(0.1720)
layout:setPercentHeight(0.0526)
layout:setSize({width = 183.0000, height = 33.0000})
layout:setLeftMargin(698.9700)
layout:setRightMargin(182.0300)
layout:setTopMargin(380.1400)
layout:setBottomMargin(213.8600)
Panel:addChild(content_text_price)

--Create content_text_originalprice
local content_text_originalprice = ccui.Text:create()
content_text_originalprice:ignoreContentAdaptWithSize(true)
content_text_originalprice:setTextAreaSize({width = 0, height = 0})
content_text_originalprice:setFontSize(33)
content_text_originalprice:setString([[原价：500元]])
content_text_originalprice:setLayoutComponentEnabled(true)
content_text_originalprice:setName("content_text_originalprice")
content_text_originalprice:setTag(898)
content_text_originalprice:setCascadeColorEnabled(true)
content_text_originalprice:setCascadeOpacityEnabled(true)
content_text_originalprice:setPosition(790.9300, 281.5800)
content_text_originalprice:setTextColor({r = 103, g = 34, b = 0})
layout = ccui.LayoutComponent:bindLayoutComponent(content_text_originalprice)
layout:setPositionPercentX(0.7434)
layout:setPositionPercentY(0.4491)
layout:setPercentWidth(0.1720)
layout:setPercentHeight(0.0526)
layout:setSize({width = 183.0000, height = 33.0000})
layout:setLeftMargin(699.4300)
layout:setRightMargin(181.5700)
layout:setTopMargin(328.9200)
layout:setBottomMargin(265.0800)
Panel:addChild(content_text_originalprice)

--Create img_line
local img_line = ccui.ImageView:create()
img_line:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/acebuy.plist")
img_line:loadTexture("hall/popupGoodsView/aceBuyView/line_red.png",1)
img_line:setScale9Enabled(true)
img_line:setCapInsets({x = 3, y = 1, width = 4, height = 2})
img_line:setLayoutComponentEnabled(true)
img_line:setName("img_line")
img_line:setTag(36)
img_line:setCascadeColorEnabled(true)
img_line:setCascadeOpacityEnabled(true)
img_line:setPosition(95.8102, 18.1294)
img_line:setColor({r = 103, g = 34, b = 0})
layout = ccui.LayoutComponent:bindLayoutComponent(img_line)
layout:setPositionPercentX(0.5236)
layout:setPositionPercentY(0.5494)
layout:setPercentWidth(1.0437)
layout:setPercentHeight(0.1212)
layout:setSize({width = 191.0000, height = 4.0000})
layout:setLeftMargin(0.3102)
layout:setRightMargin(-8.3102)
layout:setTopMargin(12.8706)
layout:setBottomMargin(16.1294)
content_text_originalprice:addChild(img_line)

--Create Pay_Type1
local Pay_Type1=cc.Node:create()
Pay_Type1:setName("Pay_Type1")
Pay_Type1:setTag(101)
Pay_Type1:setCascadeColorEnabled(true)
Pay_Type1:setCascadeOpacityEnabled(true)
Pay_Type1:setVisible(false)
layout = ccui.LayoutComponent:bindLayoutComponent(Pay_Type1)
layout:setRightMargin(1064.0000)
layout:setTopMargin(627.0000)
Panel:addChild(Pay_Type1)

--Create midas_btn
local midas_btn = ccui.Button:create()
midas_btn:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/acebuy.plist")
midas_btn:loadTextureNormal("hall/popupGoodsView/aceBuyView/buy_btn.png",1)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/acebuy.plist")
midas_btn:loadTexturePressed("hall/popupGoodsView/aceBuyView/buy_btn.png",1)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/acebuy.plist")
midas_btn:loadTextureDisabled("hall/popupGoodsView/aceBuyView/buy_btn.png",1)
midas_btn:setTitleFontSize(14)
midas_btn:setTitleColor({r = 65, g = 65, b = 70})
midas_btn:setScale9Enabled(true)
midas_btn:setCapInsets({x = 15, y = 11, width = 310, height = 64})
midas_btn:setLayoutComponentEnabled(true)
midas_btn:setName("midas_btn")
midas_btn:setTag(105)
midas_btn:setCascadeColorEnabled(true)
midas_btn:setCascadeOpacityEnabled(true)
midas_btn:setPosition(536.0839, 47.7624)
layout = ccui.LayoutComponent:bindLayoutComponent(midas_btn)
layout:setSize({width = 340.0000, height = 86.0000})
layout:setLeftMargin(366.0839)
layout:setRightMargin(-706.0839)
layout:setTopMargin(-90.7624)
layout:setBottomMargin(4.7624)
Pay_Type1:addChild(midas_btn)

--Create Pay_Type2
local Pay_Type2=cc.Node:create()
Pay_Type2:setName("Pay_Type2")
Pay_Type2:setTag(102)
Pay_Type2:setCascadeColorEnabled(true)
Pay_Type2:setCascadeOpacityEnabled(true)
Pay_Type2:setVisible(false)
layout = ccui.LayoutComponent:bindLayoutComponent(Pay_Type2)
layout:setRightMargin(1064.0000)
layout:setTopMargin(627.0000)
Panel:addChild(Pay_Type2)

--Create wechatH5btn
local wechatH5btn = ccui.Layout:create()
wechatH5btn:ignoreContentAdaptWithSize(false)
wechatH5btn:setClippingEnabled(false)
wechatH5btn:setBackGroundColorOpacity(102)
wechatH5btn:setTouchEnabled(true);
wechatH5btn:setLayoutComponentEnabled(true)
wechatH5btn:setName("wechatH5btn")
wechatH5btn:setTag(38)
wechatH5btn:setCascadeColorEnabled(true)
wechatH5btn:setCascadeOpacityEnabled(true)
wechatH5btn:setAnchorPoint(0.5000, 0.5000)
wechatH5btn:setPosition(788.3000, 44.2724)
layout = ccui.LayoutComponent:bindLayoutComponent(wechatH5btn)
layout:setSize({width = 485.0000, height = 90.0000})
layout:setLeftMargin(545.8000)
layout:setRightMargin(-1030.8000)
layout:setTopMargin(-89.2724)
layout:setBottomMargin(-0.7276)
Pay_Type2:addChild(wechatH5btn)

--Create Image_Pay_Name
local Image_Pay_Name = ccui.ImageView:create()
Image_Pay_Name:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/acebuy.plist")
Image_Pay_Name:loadTexture("hall/popupGoodsView/aceBuyView/wxPay.png",1)
Image_Pay_Name:setLayoutComponentEnabled(true)
Image_Pay_Name:setName("Image_Pay_Name")
Image_Pay_Name:setTag(1422)
Image_Pay_Name:setCascadeColorEnabled(true)
Image_Pay_Name:setCascadeOpacityEnabled(true)
Image_Pay_Name:setPosition(242.3800, 42.9685)
layout = ccui.LayoutComponent:bindLayoutComponent(Image_Pay_Name)
layout:setPositionPercentX(0.4998)
layout:setPositionPercentY(0.4774)
layout:setPercentWidth(0.3711)
layout:setPercentHeight(0.5778)
layout:setSize({width = 180.0000, height = 52.0000})
layout:setLeftMargin(152.3800)
layout:setRightMargin(152.6200)
layout:setTopMargin(21.0315)
layout:setBottomMargin(16.9685)
wechatH5btn:addChild(Image_Pay_Name)

--Create alipayH5btn
local alipayH5btn = ccui.Layout:create()
alipayH5btn:ignoreContentAdaptWithSize(false)
alipayH5btn:setClippingEnabled(false)
alipayH5btn:setBackGroundColorOpacity(102)
alipayH5btn:setTouchEnabled(true);
alipayH5btn:setLayoutComponentEnabled(true)
alipayH5btn:setName("alipayH5btn")
alipayH5btn:setTag(42)
alipayH5btn:setCascadeColorEnabled(true)
alipayH5btn:setCascadeOpacityEnabled(true)
alipayH5btn:setAnchorPoint(0.5000, 0.5000)
alipayH5btn:setPosition(293.3400, 46.2795)
layout = ccui.LayoutComponent:bindLayoutComponent(alipayH5btn)
layout:setSize({width = 485.0000, height = 90.0000})
layout:setLeftMargin(50.8400)
layout:setRightMargin(-535.8400)
layout:setTopMargin(-91.2795)
layout:setBottomMargin(1.2795)
Pay_Type2:addChild(alipayH5btn)

--Create Image_Pay_Name
local Image_Pay_Name = ccui.ImageView:create()
Image_Pay_Name:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/acebuy.plist")
Image_Pay_Name:loadTexture("hall/popupGoodsView/aceBuyView/alPay.png",1)
Image_Pay_Name:setLayoutComponentEnabled(true)
Image_Pay_Name:setName("Image_Pay_Name")
Image_Pay_Name:setTag(1423)
Image_Pay_Name:setCascadeColorEnabled(true)
Image_Pay_Name:setCascadeOpacityEnabled(true)
Image_Pay_Name:setPosition(242.1400, 41.9999)
layout = ccui.LayoutComponent:bindLayoutComponent(Image_Pay_Name)
layout:setPositionPercentX(0.4993)
layout:setPositionPercentY(0.4667)
layout:setPercentWidth(0.3711)
layout:setPercentHeight(0.5778)
layout:setSize({width = 180.0000, height = 52.0000})
layout:setLeftMargin(152.1400)
layout:setRightMargin(152.8600)
layout:setTopMargin(22.0001)
layout:setBottomMargin(15.9999)
alipayH5btn:addChild(Image_Pay_Name)

--Create appstorebtn
local appstorebtn = ccui.Layout:create()
appstorebtn:ignoreContentAdaptWithSize(false)
appstorebtn:setClippingEnabled(false)
appstorebtn:setBackGroundColorOpacity(102)
appstorebtn:setTouchEnabled(true);
appstorebtn:setLayoutComponentEnabled(true)
appstorebtn:setName("appstorebtn")
appstorebtn:setTag(352)
appstorebtn:setCascadeColorEnabled(true)
appstorebtn:setCascadeOpacityEnabled(true)
appstorebtn:setVisible(false)
appstorebtn:setAnchorPoint(0.5000, 0.5000)
appstorebtn:setPosition(293.3400, 46.2800)
layout = ccui.LayoutComponent:bindLayoutComponent(appstorebtn)
layout:setSize({width = 485.0000, height = 90.0000})
layout:setLeftMargin(50.8400)
layout:setRightMargin(-535.8400)
layout:setTopMargin(-91.2800)
layout:setBottomMargin(1.2800)
Pay_Type2:addChild(appstorebtn)

--Create Image_Pay_Name
local Image_Pay_Name = ccui.ImageView:create()
Image_Pay_Name:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/acebuy.plist")
Image_Pay_Name:loadTexture("hall/popupGoodsView/aceBuyView/appPay.png",1)
Image_Pay_Name:setLayoutComponentEnabled(true)
Image_Pay_Name:setName("Image_Pay_Name")
Image_Pay_Name:setTag(353)
Image_Pay_Name:setCascadeColorEnabled(true)
Image_Pay_Name:setCascadeOpacityEnabled(true)
Image_Pay_Name:setPosition(242.1400, 41.9999)
layout = ccui.LayoutComponent:bindLayoutComponent(Image_Pay_Name)
layout:setPositionPercentX(0.4993)
layout:setPositionPercentY(0.4667)
layout:setPercentWidth(0.3711)
layout:setPercentHeight(0.5778)
layout:setSize({width = 180.0000, height = 52.0000})
layout:setLeftMargin(152.1400)
layout:setRightMargin(152.8600)
layout:setTopMargin(22.0001)
layout:setBottomMargin(15.9999)
appstorebtn:addChild(Image_Pay_Name)

--Create img_erect
local img_erect = ccui.ImageView:create()
img_erect:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/acebuy.plist")
img_erect:loadTexture("hall/popupGoodsView/aceBuyView/erect.png",1)
img_erect:setLayoutComponentEnabled(true)
img_erect:setName("img_erect")
img_erect:setTag(144)
img_erect:setCascadeColorEnabled(true)
img_erect:setCascadeOpacityEnabled(true)
img_erect:setPosition(540.6400, 49.4057)
layout = ccui.LayoutComponent:bindLayoutComponent(img_erect)
layout:setSize({width = 3.0000, height = 87.0000})
layout:setLeftMargin(539.1400)
layout:setRightMargin(-542.1400)
layout:setTopMargin(-92.9057)
layout:setBottomMargin(5.9057)
Pay_Type2:addChild(img_erect)

--Create Pay_Type3
local Pay_Type3=cc.Node:create()
Pay_Type3:setName("Pay_Type3")
Pay_Type3:setTag(100)
Pay_Type3:setCascadeColorEnabled(true)
Pay_Type3:setCascadeOpacityEnabled(true)
Pay_Type3:setVisible(false)
layout = ccui.LayoutComponent:bindLayoutComponent(Pay_Type3)
layout:setRightMargin(1064.0000)
layout:setTopMargin(627.0000)
Panel:addChild(Pay_Type3)

--Create wechatH5
local wechatH5 = ccui.Layout:create()
wechatH5:ignoreContentAdaptWithSize(false)
wechatH5:setClippingEnabled(false)
wechatH5:setBackGroundColorOpacity(102)
wechatH5:setTouchEnabled(true);
wechatH5:setLayoutComponentEnabled(true)
wechatH5:setName("wechatH5")
wechatH5:setTag(1)
wechatH5:setCascadeColorEnabled(true)
wechatH5:setCascadeOpacityEnabled(true)
wechatH5:setAnchorPoint(0.5000, 0.5000)
wechatH5:setPosition(870.5600, 49.3000)
layout = ccui.LayoutComponent:bindLayoutComponent(wechatH5)
layout:setSize({width = 310.0000, height = 90.0000})
layout:setLeftMargin(715.5600)
layout:setRightMargin(-1025.5600)
layout:setTopMargin(-94.3000)
layout:setBottomMargin(4.3000)
Pay_Type3:addChild(wechatH5)

--Create Image_Pay_Name
local Image_Pay_Name = ccui.ImageView:create()
Image_Pay_Name:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/acebuy.plist")
Image_Pay_Name:loadTexture("hall/popupGoodsView/aceBuyView/wxPay.png",1)
Image_Pay_Name:setLayoutComponentEnabled(true)
Image_Pay_Name:setName("Image_Pay_Name")
Image_Pay_Name:setTag(114)
Image_Pay_Name:setCascadeColorEnabled(true)
Image_Pay_Name:setCascadeOpacityEnabled(true)
Image_Pay_Name:setPosition(155.3777, 42.9688)
layout = ccui.LayoutComponent:bindLayoutComponent(Image_Pay_Name)
layout:setPositionPercentX(0.5012)
layout:setPositionPercentY(0.4774)
layout:setPercentWidth(0.5806)
layout:setPercentHeight(0.5778)
layout:setSize({width = 180.0000, height = 52.0000})
layout:setLeftMargin(65.3777)
layout:setRightMargin(64.6223)
layout:setTopMargin(21.0312)
layout:setBottomMargin(16.9688)
wechatH5:addChild(Image_Pay_Name)

--Create alipayH5
local alipayH5 = ccui.Layout:create()
alipayH5:ignoreContentAdaptWithSize(false)
alipayH5:setClippingEnabled(false)
alipayH5:setBackGroundColorOpacity(102)
alipayH5:setTouchEnabled(true);
alipayH5:setLayoutComponentEnabled(true)
alipayH5:setName("alipayH5")
alipayH5:setTag(2)
alipayH5:setCascadeColorEnabled(true)
alipayH5:setCascadeOpacityEnabled(true)
alipayH5:setAnchorPoint(0.5000, 0.5000)
alipayH5:setPosition(539.4000, 49.3000)
layout = ccui.LayoutComponent:bindLayoutComponent(alipayH5)
layout:setSize({width = 310.0000, height = 90.0000})
layout:setLeftMargin(384.4000)
layout:setRightMargin(-694.4000)
layout:setTopMargin(-94.3000)
layout:setBottomMargin(4.3000)
Pay_Type3:addChild(alipayH5)

--Create Image_Pay_Name
local Image_Pay_Name = ccui.ImageView:create()
Image_Pay_Name:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/acebuy.plist")
Image_Pay_Name:loadTexture("hall/popupGoodsView/aceBuyView/alPay.png",1)
Image_Pay_Name:setLayoutComponentEnabled(true)
Image_Pay_Name:setName("Image_Pay_Name")
Image_Pay_Name:setTag(110)
Image_Pay_Name:setCascadeColorEnabled(true)
Image_Pay_Name:setCascadeOpacityEnabled(true)
Image_Pay_Name:setPosition(156.1403, 42.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(Image_Pay_Name)
layout:setPositionPercentX(0.5037)
layout:setPositionPercentY(0.4667)
layout:setPercentWidth(0.5806)
layout:setPercentHeight(0.5778)
layout:setSize({width = 180.0000, height = 52.0000})
layout:setLeftMargin(66.1403)
layout:setRightMargin(63.8597)
layout:setTopMargin(22.0000)
layout:setBottomMargin(16.0000)
alipayH5:addChild(Image_Pay_Name)

--Create appstore
local appstore = ccui.Layout:create()
appstore:ignoreContentAdaptWithSize(false)
appstore:setClippingEnabled(false)
appstore:setBackGroundColorOpacity(102)
appstore:setTouchEnabled(true);
appstore:setLayoutComponentEnabled(true)
appstore:setName("appstore")
appstore:setTag(40)
appstore:setCascadeColorEnabled(true)
appstore:setCascadeOpacityEnabled(true)
appstore:setAnchorPoint(0.5000, 0.5000)
appstore:setPosition(210.0000, 49.3000)
layout = ccui.LayoutComponent:bindLayoutComponent(appstore)
layout:setSize({width = 310.0000, height = 90.0000})
layout:setLeftMargin(55.0000)
layout:setRightMargin(-365.0000)
layout:setTopMargin(-94.3000)
layout:setBottomMargin(4.3000)
Pay_Type3:addChild(appstore)

--Create Image_Pay_Name
local Image_Pay_Name = ccui.ImageView:create()
Image_Pay_Name:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/acebuy.plist")
Image_Pay_Name:loadTexture("hall/popupGoodsView/aceBuyView/appPay.png",1)
Image_Pay_Name:setLayoutComponentEnabled(true)
Image_Pay_Name:setName("Image_Pay_Name")
Image_Pay_Name:setTag(112)
Image_Pay_Name:setCascadeColorEnabled(true)
Image_Pay_Name:setCascadeOpacityEnabled(true)
Image_Pay_Name:setPosition(155.9400, 42.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(Image_Pay_Name)
layout:setPositionPercentX(0.5030)
layout:setPositionPercentY(0.4667)
layout:setPercentWidth(0.5806)
layout:setPercentHeight(0.5778)
layout:setSize({width = 180.0000, height = 52.0000})
layout:setLeftMargin(65.9400)
layout:setRightMargin(64.0600)
layout:setTopMargin(22.0000)
layout:setBottomMargin(16.0000)
appstore:addChild(Image_Pay_Name)

--Create img_erect_l
local img_erect_l = ccui.ImageView:create()
img_erect_l:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/acebuy.plist")
img_erect_l:loadTexture("hall/popupGoodsView/aceBuyView/erect.png",1)
img_erect_l:setLayoutComponentEnabled(true)
img_erect_l:setName("img_erect_l")
img_erect_l:setTag(174)
img_erect_l:setCascadeColorEnabled(true)
img_erect_l:setCascadeOpacityEnabled(true)
img_erect_l:setPosition(374.7128, 49.8680)
layout = ccui.LayoutComponent:bindLayoutComponent(img_erect_l)
layout:setSize({width = 3.0000, height = 87.0000})
layout:setLeftMargin(373.2128)
layout:setRightMargin(-376.2128)
layout:setTopMargin(-93.3680)
layout:setBottomMargin(6.3680)
Pay_Type3:addChild(img_erect_l)

--Create img_erect_r
local img_erect_r = ccui.ImageView:create()
img_erect_r:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/acebuy.plist")
img_erect_r:loadTexture("hall/popupGoodsView/aceBuyView/erect.png",1)
img_erect_r:setLayoutComponentEnabled(true)
img_erect_r:setName("img_erect_r")
img_erect_r:setTag(175)
img_erect_r:setCascadeColorEnabled(true)
img_erect_r:setCascadeOpacityEnabled(true)
img_erect_r:setPosition(705.4302, 49.9984)
layout = ccui.LayoutComponent:bindLayoutComponent(img_erect_r)
layout:setSize({width = 3.0000, height = 87.0000})
layout:setLeftMargin(703.9302)
layout:setRightMargin(-706.9302)
layout:setTopMargin(-93.4984)
layout:setBottomMargin(6.4984)
Pay_Type3:addChild(img_erect_r)

--Create Animation
result['animation'] = ccs.ActionTimeline:create()
  
result['animation']:setDuration(0)
result['animation']:setTimeSpeed(1.0000)
--Create Animation List

result['root'] = Node
return result;
end

return Result

