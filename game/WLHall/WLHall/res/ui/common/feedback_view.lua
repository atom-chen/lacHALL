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

--Create container
local container = ccui.Layout:create()
container:ignoreContentAdaptWithSize(false)
container:setClippingEnabled(false)
container:setBackGroundImageCapInsets({x = -5, y = -5, width = 10, height = 10})
container:setBackGroundColorOpacity(102)
container:setBackGroundImageScale9Enabled(true)
container:setTouchEnabled(true);
container:setLayoutComponentEnabled(true)
container:setName("container")
container:setTag(87)
container:setCascadeColorEnabled(true)
container:setCascadeOpacityEnabled(true)
container:setPosition(142.0000, 47.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(container)
layout:setSize({width = 1096.0000, height = 645.0000})
layout:setLeftMargin(142.0000)
layout:setRightMargin(-1238.0000)
layout:setTopMargin(-692.0000)
layout:setBottomMargin(47.0000)
Node:addChild(container)

--Create img_feed_bg
local img_feed_bg = ccui.ImageView:create()
img_feed_bg:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
img_feed_bg:loadTexture("hall/common/new_pop_bg.png",1)
img_feed_bg:setScale9Enabled(true)
img_feed_bg:setCapInsets({x = 8, y = 68, width = 3, height = 2})
img_feed_bg:setLayoutComponentEnabled(true)
img_feed_bg:setName("img_feed_bg")
img_feed_bg:setTag(1624)
img_feed_bg:setCascadeColorEnabled(true)
img_feed_bg:setCascadeOpacityEnabled(true)
img_feed_bg:setAnchorPoint(0.5000, 0.0000)
img_feed_bg:setPosition(548.0000, -4.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_feed_bg)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(-0.0062)
layout:setPercentWidth(1.0082)
layout:setPercentHeight(1.0000)
layout:setSize({width = 1105.0000, height = 645.0000})
layout:setLeftMargin(-4.5000)
layout:setRightMargin(-4.5000)
layout:setTopMargin(4.0000)
layout:setBottomMargin(-4.0000)
container:addChild(img_feed_bg)

--Create feed_title_img
local feed_title_img = ccui.Layout:create()
feed_title_img:ignoreContentAdaptWithSize(false)
feed_title_img:setClippingEnabled(false)
feed_title_img:setBackGroundColorOpacity(102)
feed_title_img:setTouchEnabled(true);
feed_title_img:setLayoutComponentEnabled(true)
feed_title_img:setName("feed_title_img")
feed_title_img:setTag(691)
feed_title_img:setCascadeColorEnabled(true)
feed_title_img:setCascadeOpacityEnabled(true)
feed_title_img:setAnchorPoint(0.0000, 1.0000)
feed_title_img:setPosition(0.0000, 636.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(feed_title_img)
layout:setPositionPercentY(0.9860)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(0.0930)
layout:setSize({width = 1096.0000, height = 60.0000})
layout:setTopMargin(9.0000)
layout:setBottomMargin(576.0000)
container:addChild(feed_title_img)

--Create feed_txt_name
local feed_txt_name = ccui.Text:create()
feed_txt_name:ignoreContentAdaptWithSize(true)
feed_txt_name:setTextAreaSize({width = 0, height = 0})
feed_txt_name:setFontSize(28)
feed_txt_name:setString([[反馈]])
feed_txt_name:setLayoutComponentEnabled(true)
feed_txt_name:setName("feed_txt_name")
feed_txt_name:setTag(740)
feed_txt_name:setCascadeColorEnabled(true)
feed_txt_name:setCascadeOpacityEnabled(true)
feed_txt_name:setPosition(58.0000, 30.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(feed_txt_name)
layout:setPositionPercentX(0.0529)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.0511)
layout:setPercentHeight(0.4667)
layout:setSize({width = 56.0000, height = 28.0000})
layout:setLeftMargin(30.0000)
layout:setRightMargin(1010.0000)
layout:setTopMargin(16.0000)
layout:setBottomMargin(16.0000)
feed_title_img:addChild(feed_txt_name)

--Create btn_add_img
local btn_add_img = ccui.Button:create()
btn_add_img:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/feedback.plist")
btn_add_img:loadTextureNormal("hall/feedback/shape_waik.png",1)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/feedback.plist")
btn_add_img:loadTexturePressed("hall/feedback/shape_waik.png",1)
btn_add_img:loadTextureDisabled("Default/Button_Disable.png",0)
btn_add_img:setTitleFontSize(14)
btn_add_img:setTitleColor({r = 65, g = 65, b = 70})
btn_add_img:setScale9Enabled(true)
btn_add_img:setCapInsets({x = 15, y = 11, width = 2, height = 10})
btn_add_img:setLayoutComponentEnabled(true)
btn_add_img:setName("btn_add_img")
btn_add_img:setTag(55)
btn_add_img:setCascadeColorEnabled(true)
btn_add_img:setCascadeOpacityEnabled(true)
btn_add_img:setPosition(91.2295, 479.7424)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_add_img)
layout:setPositionPercentX(0.0832)
layout:setPositionPercentY(0.7438)
layout:setPercentWidth(0.1113)
layout:setPercentHeight(0.1891)
layout:setSize({width = 122.0000, height = 122.0000})
layout:setLeftMargin(30.2295)
layout:setRightMargin(943.7705)
layout:setTopMargin(104.2576)
layout:setBottomMargin(418.7424)
container:addChild(btn_add_img)

--Create Image_1
local Image_1 = ccui.ImageView:create()
Image_1:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/feedback.plist")
Image_1:loadTexture("hall/feedback/art_add.png",1)
Image_1:setLayoutComponentEnabled(true)
Image_1:setName("Image_1")
Image_1:setTag(56)
Image_1:setCascadeColorEnabled(true)
Image_1:setCascadeOpacityEnabled(true)
Image_1:setAnchorPoint(0.5000, 1.0000)
Image_1:setPosition(61.0000, 105.0000)
Image_1:setScaleY(0.9227)
layout = ccui.LayoutComponent:bindLayoutComponent(Image_1)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.8607)
layout:setPercentWidth(0.5000)
layout:setPercentHeight(0.5000)
layout:setSize({width = 61.0000, height = 61.0000})
layout:setLeftMargin(30.5000)
layout:setRightMargin(30.5000)
layout:setTopMargin(17.0000)
layout:setBottomMargin(44.0000)
btn_add_img:addChild(Image_1)

--Create Text_1
local Text_1 = ccui.Text:create()
Text_1:ignoreContentAdaptWithSize(true)
Text_1:setTextAreaSize({width = 0, height = 0})
Text_1:setFontSize(24)
Text_1:setString([[上传截图]])
Text_1:setLayoutComponentEnabled(true)
Text_1:setName("Text_1")
Text_1:setTag(57)
Text_1:setCascadeColorEnabled(true)
Text_1:setCascadeOpacityEnabled(true)
Text_1:setPosition(61.0000, 25.0000)
Text_1:setTextColor({r = 211, g = 131, b = 31})
layout = ccui.LayoutComponent:bindLayoutComponent(Text_1)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.2049)
layout:setPercentWidth(0.8033)
layout:setPercentHeight(0.2295)
layout:setSize({width = 98.0000, height = 28.0000})
layout:setLeftMargin(12.0000)
layout:setRightMargin(12.0000)
layout:setTopMargin(83.0000)
layout:setBottomMargin(11.0000)
btn_add_img:addChild(Text_1)

--Create shape_img
local shape_img = ccui.ImageView:create()
shape_img:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/feedback.plist")
shape_img:loadTexture("hall/feedback/shape_b_1.png",1)
shape_img:setLayoutComponentEnabled(true)
shape_img:setName("shape_img")
shape_img:setTag(170)
shape_img:setCascadeColorEnabled(true)
shape_img:setCascadeOpacityEnabled(true)
shape_img:setPosition(61.0000, 61.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(shape_img)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.9836)
layout:setPercentHeight(0.9836)
layout:setSize({width = 120.0000, height = 120.0000})
layout:setLeftMargin(1.0000)
layout:setRightMargin(1.0000)
layout:setTopMargin(1.0000)
layout:setBottomMargin(1.0000)
btn_add_img:addChild(shape_img)

--Create img_input
local img_input = ccui.ImageView:create()
img_input:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/feedback.plist")
img_input:loadTexture("hall/feedback/img_kuan.png",1)
img_input:setScale9Enabled(true)
img_input:setCapInsets({x = 10, y = 9, width = 4, height = 3})
img_input:setLayoutComponentEnabled(true)
img_input:setName("img_input")
img_input:setTag(58)
img_input:setCascadeColorEnabled(true)
img_input:setCascadeOpacityEnabled(true)
img_input:setAnchorPoint(0.0000, 0.0000)
img_input:setPosition(336.8216, 118.9877)
img_input:setColor({r = 234, g = 234, b = 234})
layout = ccui.LayoutComponent:bindLayoutComponent(img_input)
layout:setPositionPercentX(0.3073)
layout:setPositionPercentY(0.1845)
layout:setPercentWidth(0.6752)
layout:setPercentHeight(0.6589)
layout:setSize({width = 740.0000, height = 425.0000})
layout:setLeftMargin(336.8216)
layout:setRightMargin(19.1785)
layout:setTopMargin(101.0123)
layout:setBottomMargin(118.9877)
container:addChild(img_input)

--Create sv_feed
local sv_feed = ccui.ScrollView:create()
sv_feed:setInnerContainerSize({width = 840, height = 440})
sv_feed:ignoreContentAdaptWithSize(false)
sv_feed:setClippingEnabled(true)
sv_feed:setBackGroundColorOpacity(102)
sv_feed:setTouchEnabled(false);
sv_feed:setLayoutComponentEnabled(true)
sv_feed:setName("sv_feed")
sv_feed:setTag(59)
sv_feed:setCascadeColorEnabled(true)
sv_feed:setCascadeOpacityEnabled(true)
layout = ccui.LayoutComponent:bindLayoutComponent(sv_feed)
layout:setPercentWidthEnabled(true)
layout:setPercentHeightEnabled(true)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(1.0000)
layout:setSize({width = 740.0000, height = 425.0000})
img_input:addChild(sv_feed)

--Create img_phone
local img_phone = ccui.ImageView:create()
img_phone:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/feedback.plist")
img_phone:loadTexture("hall/feedback/img_kuan.png",1)
img_phone:setScale9Enabled(true)
img_phone:setCapInsets({x = 10, y = 8, width = 2, height = 2})
img_phone:setLayoutComponentEnabled(true)
img_phone:setName("img_phone")
img_phone:setTag(60)
img_phone:setCascadeColorEnabled(true)
img_phone:setCascadeOpacityEnabled(true)
img_phone:setAnchorPoint(0.0000, 0.0000)
img_phone:setPosition(336.0005, 27.8988)
img_phone:setColor({r = 234, g = 234, b = 234})
layout = ccui.LayoutComponent:bindLayoutComponent(img_phone)
layout:setPositionPercentX(0.3066)
layout:setPositionPercentY(0.0433)
layout:setPercentWidth(0.4973)
layout:setPercentHeight(0.0946)
layout:setSize({width = 545.0000, height = 61.0000})
layout:setLeftMargin(336.0005)
layout:setRightMargin(214.9995)
layout:setTopMargin(556.1012)
layout:setBottomMargin(27.8988)
container:addChild(img_phone)

--Create btn_commit
local btn_commit = ccui.Button:create()
btn_commit:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
btn_commit:loadTextureNormal("hall/common/new_btn_noangle.png",1)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
btn_commit:loadTexturePressed("hall/common/new_btn_noangle.png",1)
btn_commit:loadTextureDisabled("Default/Button_Disable.png",0)
btn_commit:setTitleFontSize(32)
btn_commit:setScale9Enabled(true)
btn_commit:setCapInsets({x = 4, y = 4, width = 10, height = 10})
btn_commit:setLayoutComponentEnabled(true)
btn_commit:setName("btn_commit")
btn_commit:setTag(61)
btn_commit:setCascadeColorEnabled(true)
btn_commit:setCascadeOpacityEnabled(true)
btn_commit:setPosition(985.6375, 58.1600)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_commit)
layout:setPositionPercentX(0.8993)
layout:setPositionPercentY(0.0902)
layout:setPercentWidth(0.1642)
layout:setPercentHeight(0.0930)
layout:setSize({width = 180.0000, height = 60.0000})
layout:setLeftMargin(895.6375)
layout:setRightMargin(20.3626)
layout:setTopMargin(556.8400)
layout:setBottomMargin(28.1600)
container:addChild(btn_commit)

--Create img_bg
local img_bg = ccui.ImageView:create()
img_bg:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
img_bg:loadTexture("hall/common/new_btn_noangle.png",1)
img_bg:setScale9Enabled(true)
img_bg:setCapInsets({x = 8, y = 8, width = 2, height = 2})
img_bg:setLayoutComponentEnabled(true)
img_bg:setName("img_bg")
img_bg:setTag(741)
img_bg:setCascadeColorEnabled(true)
img_bg:setCascadeOpacityEnabled(true)
img_bg:setPosition(90.0000, 30.0000)
img_bg:setColor({r = 38, g = 155, b = 88})
layout = ccui.LayoutComponent:bindLayoutComponent(img_bg)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(1.0000)
layout:setSize({width = 180.0000, height = 60.0000})
btn_commit:addChild(img_bg)

--Create text_commit
local text_commit = ccui.Text:create()
text_commit:ignoreContentAdaptWithSize(true)
text_commit:setTextAreaSize({width = 0, height = 0})
text_commit:setFontName("")
text_commit:setFontSize(32)
text_commit:setString([[提交]])
text_commit:setTextHorizontalAlignment(1)
text_commit:setLayoutComponentEnabled(true)
text_commit:setName("text_commit")
text_commit:setTag(13)
text_commit:setCascadeColorEnabled(true)
text_commit:setCascadeOpacityEnabled(true)
text_commit:setPosition(94.2155, 28.9307)
layout = ccui.LayoutComponent:bindLayoutComponent(text_commit)
layout:setPositionPercentX(0.5234)
layout:setPositionPercentY(0.4822)
layout:setPercentWidth(0.3556)
layout:setPercentHeight(0.5500)
layout:setSize({width = 64.0000, height = 33.0000})
layout:setLeftMargin(62.2155)
layout:setRightMargin(53.7845)
layout:setTopMargin(14.5693)
layout:setBottomMargin(12.4307)
btn_commit:addChild(text_commit)

--Create Animation
result['animation'] = ccs.ActionTimeline:create()

result['animation']:setDuration(0)
result['animation']:setTimeSpeed(1.0000)
--Create Animation List

result['root'] = Node
return result;
end

return Result

