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
panel_bg:setBackGroundColorOpacity(128)
panel_bg:setTouchEnabled(true);
panel_bg:setLayoutComponentEnabled(true)
panel_bg:setName("panel_bg")
panel_bg:setTag(303)
panel_bg:setCascadeColorEnabled(true)
panel_bg:setCascadeOpacityEnabled(true)
panel_bg:setAnchorPoint(0.5000, 0.5000)
panel_bg:setScaleX(10.0000)
panel_bg:setScaleY(10.0000)
panel_bg:setOpacity(0)
layout = ccui.LayoutComponent:bindLayoutComponent(panel_bg)
layout:setSize({width = 200.0000, height = 200.0000})
layout:setLeftMargin(-100.0000)
layout:setRightMargin(-100.0000)
layout:setTopMargin(-100.0000)
layout:setBottomMargin(-100.0000)
Node:addChild(panel_bg)

--Create img_bg
local img_bg = ccui.ImageView:create()
img_bg:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/bag.plist")
img_bg:loadTexture("hall/bag/item_info_bg.png",1)
img_bg:setScale9Enabled(true)
img_bg:setCapInsets({x = 14, y = 171, width = 10, height = 1})
img_bg:setTouchEnabled(true);
img_bg:setLayoutComponentEnabled(true)
img_bg:setName("img_bg")
img_bg:setTag(111)
img_bg:setCascadeColorEnabled(true)
img_bg:setCascadeOpacityEnabled(true)
img_bg:setPosition(0.0000, -10.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_bg)
layout:setSize({width = 426.0000, height = 466.0000})
layout:setLeftMargin(-213.0000)
layout:setRightMargin(-213.0000)
layout:setTopMargin(-223.0000)
layout:setBottomMargin(-243.0000)
Node:addChild(img_bg)

--Create img_icon_bg
local img_icon_bg = ccui.ImageView:create()
img_icon_bg:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/bag.plist")
img_icon_bg:loadTexture("hall/bag/item_bg.png",1)
img_icon_bg:setScale9Enabled(true)
img_icon_bg:setCapInsets({x = 7, y = 6, width = 11, height = 12})
img_icon_bg:setLayoutComponentEnabled(true)
img_icon_bg:setName("img_icon_bg")
img_icon_bg:setTag(130)
img_icon_bg:setCascadeColorEnabled(true)
img_icon_bg:setCascadeOpacityEnabled(true)
img_icon_bg:setPosition(79.8599, 384.3500)
layout = ccui.LayoutComponent:bindLayoutComponent(img_icon_bg)
layout:setPositionPercentX(0.1875)
layout:setPositionPercentY(0.8248)
layout:setPercentWidth(0.2629)
layout:setPercentHeight(0.2403)
layout:setSize({width = 112.0000, height = 112.0000})
layout:setLeftMargin(23.8599)
layout:setRightMargin(290.1401)
layout:setTopMargin(25.6500)
layout:setBottomMargin(328.3500)
img_bg:addChild(img_icon_bg)

--Create img_prop_icon
local img_prop_icon = ccui.ImageView:create()
img_prop_icon:ignoreContentAdaptWithSize(false)
img_prop_icon:loadTexture("Default/ImageFile.png",0)
img_prop_icon:setLayoutComponentEnabled(true)
img_prop_icon:setName("img_prop_icon")
img_prop_icon:setTag(112)
img_prop_icon:setCascadeColorEnabled(true)
img_prop_icon:setCascadeOpacityEnabled(true)
img_prop_icon:setPosition(79.8611, 384.3457)
layout = ccui.LayoutComponent:bindLayoutComponent(img_prop_icon)
layout:setPositionPercentX(0.1875)
layout:setPositionPercentY(0.8248)
layout:setPercentWidth(0.2629)
layout:setPercentHeight(0.2403)
layout:setSize({width = 112.0000, height = 112.0000})
layout:setLeftMargin(23.8611)
layout:setRightMargin(290.1389)
layout:setTopMargin(25.6543)
layout:setBottomMargin(328.3457)
img_bg:addChild(img_prop_icon)

--Create txt_title_describe
local txt_title_describe = ccui.Text:create()
txt_title_describe:ignoreContentAdaptWithSize(true)
txt_title_describe:setTextAreaSize({width = 0, height = 0})
txt_title_describe:setFontSize(28)
txt_title_describe:setString([[功能描述]])
txt_title_describe:setLayoutComponentEnabled(true)
txt_title_describe:setName("txt_title_describe")
txt_title_describe:setTag(22)
txt_title_describe:setCascadeColorEnabled(true)
txt_title_describe:setCascadeOpacityEnabled(true)
txt_title_describe:setAnchorPoint(0.0000, 0.5000)
txt_title_describe:setPosition(24.1599, 270.7699)
txt_title_describe:setTextColor({r = 218, g = 148, b = 12})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_title_describe)
layout:setPositionPercentX(0.0567)
layout:setPositionPercentY(0.5811)
layout:setPercentWidth(0.2700)
layout:setPercentHeight(0.0687)
layout:setSize({width = 115.0000, height = 32.0000})
layout:setLeftMargin(24.1599)
layout:setRightMargin(286.8401)
layout:setTopMargin(179.2301)
layout:setBottomMargin(254.7699)
img_bg:addChild(txt_title_describe)

--Create txt_title_source
local txt_title_source = ccui.Text:create()
txt_title_source:ignoreContentAdaptWithSize(true)
txt_title_source:setTextAreaSize({width = 0, height = 0})
txt_title_source:setFontSize(28)
txt_title_source:setString([[物品来源]])
txt_title_source:setLayoutComponentEnabled(true)
txt_title_source:setName("txt_title_source")
txt_title_source:setTag(23)
txt_title_source:setCascadeColorEnabled(true)
txt_title_source:setCascadeOpacityEnabled(true)
txt_title_source:setAnchorPoint(0.0000, 0.5000)
txt_title_source:setPosition(24.1599, 133.4103)
txt_title_source:setTextColor({r = 218, g = 148, b = 12})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_title_source)
layout:setPositionPercentX(0.0567)
layout:setPositionPercentY(0.2863)
layout:setPercentWidth(0.2700)
layout:setPercentHeight(0.0687)
layout:setSize({width = 115.0000, height = 32.0000})
layout:setLeftMargin(24.1599)
layout:setRightMargin(286.8401)
layout:setTopMargin(316.5897)
layout:setBottomMargin(117.4103)
img_bg:addChild(txt_title_source)

--Create txt_name
local txt_name = ccui.Text:create()
txt_name:ignoreContentAdaptWithSize(true)
txt_name:setTextAreaSize({width = 0, height = 0})
txt_name:setFontSize(28)
txt_name:setString([[参赛券]])
txt_name:setLayoutComponentEnabled(true)
txt_name:setName("txt_name")
txt_name:setTag(24)
txt_name:setCascadeColorEnabled(true)
txt_name:setCascadeOpacityEnabled(true)
txt_name:setAnchorPoint(0.0000, 0.5000)
txt_name:setPosition(150.2330, 404.8820)
txt_name:setTextColor({r = 231, g = 223, b = 213})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_name)
layout:setPositionPercentX(0.3527)
layout:setPositionPercentY(0.8688)
layout:setPercentWidth(0.2042)
layout:setPercentHeight(0.0687)
layout:setSize({width = 87.0000, height = 32.0000})
layout:setLeftMargin(150.2330)
layout:setRightMargin(188.7670)
layout:setTopMargin(45.1180)
layout:setBottomMargin(388.8820)
img_bg:addChild(txt_name)

--Create txt_describe
local txt_describe = ccui.Text:create()
txt_describe:ignoreContentAdaptWithSize(true)
txt_describe:setTextAreaSize({width = 0, height = 0})
txt_describe:setFontSize(26)
txt_describe:setString([[用于参加斗地主报名使用]])
txt_describe:setLayoutComponentEnabled(true)
txt_describe:setName("txt_describe")
txt_describe:setTag(25)
txt_describe:setCascadeColorEnabled(true)
txt_describe:setCascadeOpacityEnabled(true)
txt_describe:setAnchorPoint(0.0000, 1.0000)
txt_describe:setPosition(24.1599, 250.9014)
layout = ccui.LayoutComponent:bindLayoutComponent(txt_describe)
layout:setPositionPercentX(0.0567)
layout:setPositionPercentY(0.5384)
layout:setPercentWidth(0.6714)
layout:setPercentHeight(0.0558)
layout:setSize({width = 286.0000, height = 26.0000})
layout:setLeftMargin(24.1599)
layout:setRightMargin(115.8401)
layout:setTopMargin(215.0986)
layout:setBottomMargin(224.9014)
img_bg:addChild(txt_describe)

--Create txt_source
local txt_source = ccui.Text:create()
txt_source:ignoreContentAdaptWithSize(true)
txt_source:setTextAreaSize({width = 0, height = 0})
txt_source:setFontSize(26)
txt_source:setString([[元宝只能通过完成游戏任务活动，
不能参与游戏结算]])
txt_source:setLayoutComponentEnabled(true)
txt_source:setName("txt_source")
txt_source:setTag(26)
txt_source:setCascadeColorEnabled(true)
txt_source:setCascadeOpacityEnabled(true)
txt_source:setAnchorPoint(0.0000, 1.0000)
txt_source:setPosition(24.1599, 114.4656)
layout = ccui.LayoutComponent:bindLayoutComponent(txt_source)
layout:setPositionPercentX(0.0567)
layout:setPositionPercentY(0.2456)
layout:setPercentWidth(0.9155)
layout:setPercentHeight(0.1116)
layout:setSize({width = 390.0000, height = 52.0000})
layout:setLeftMargin(24.1599)
layout:setRightMargin(11.8401)
layout:setTopMargin(351.5344)
layout:setBottomMargin(62.4656)
img_bg:addChild(txt_source)

--Create txt_title_count
local txt_title_count = ccui.Text:create()
txt_title_count:ignoreContentAdaptWithSize(true)
txt_title_count:setTextAreaSize({width = 0, height = 0})
txt_title_count:setFontSize(24)
txt_title_count:setString([[拥有]])
txt_title_count:setLayoutComponentEnabled(true)
txt_title_count:setName("txt_title_count")
txt_title_count:setTag(21)
txt_title_count:setCascadeColorEnabled(true)
txt_title_count:setCascadeOpacityEnabled(true)
txt_title_count:setAnchorPoint(0.0000, 0.5000)
txt_title_count:setPosition(152.8499, 355.4827)
txt_title_count:setTextColor({r = 139, g = 170, b = 191})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_title_count)
layout:setPositionPercentX(0.3588)
layout:setPositionPercentY(0.7628)
layout:setPercentWidth(0.1197)
layout:setPercentHeight(0.0601)
layout:setSize({width = 51.0000, height = 28.0000})
layout:setLeftMargin(152.8499)
layout:setRightMargin(222.1501)
layout:setTopMargin(96.5173)
layout:setBottomMargin(341.4827)
img_bg:addChild(txt_title_count)

--Create txt_count
local txt_count = ccui.Text:create()
txt_count:ignoreContentAdaptWithSize(true)
txt_count:setTextAreaSize({width = 0, height = 0})
txt_count:setFontSize(34)
txt_count:setString([[10]])
txt_count:setLayoutComponentEnabled(true)
txt_count:setName("txt_count")
txt_count:setTag(13)
txt_count:setCascadeColorEnabled(true)
txt_count:setCascadeOpacityEnabled(true)
txt_count:setPosition(240.6698, 355.4816)
txt_count:setTextColor({r = 98, g = 228, b = 72})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_count)
layout:setPositionPercentX(0.5650)
layout:setPositionPercentY(0.7628)
layout:setPercentWidth(0.0798)
layout:setPercentHeight(0.0837)
layout:setSize({width = 34.0000, height = 39.0000})
layout:setLeftMargin(223.6698)
layout:setRightMargin(168.3302)
layout:setTopMargin(91.0184)
layout:setBottomMargin(335.9816)
img_bg:addChild(txt_count)

--Create txt_prop_u
local txt_prop_u = ccui.Text:create()
txt_prop_u:ignoreContentAdaptWithSize(true)
txt_prop_u:setTextAreaSize({width = 0, height = 0})
txt_prop_u:setFontSize(24)
txt_prop_u:setString([[个]])
txt_prop_u:setLayoutComponentEnabled(true)
txt_prop_u:setName("txt_prop_u")
txt_prop_u:setTag(12)
txt_prop_u:setCascadeColorEnabled(true)
txt_prop_u:setCascadeOpacityEnabled(true)
txt_prop_u:setAnchorPoint(0.0000, 0.5000)
txt_prop_u:setPosition(280.6592, 355.4827)
txt_prop_u:setTextColor({r = 139, g = 170, b = 191})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_prop_u)
layout:setPositionPercentX(0.6588)
layout:setPositionPercentY(0.7628)
layout:setPercentWidth(0.0634)
layout:setPercentHeight(0.0601)
layout:setSize({width = 27.0000, height = 28.0000})
layout:setLeftMargin(280.6592)
layout:setRightMargin(118.3408)
layout:setTopMargin(96.5173)
layout:setBottomMargin(341.4827)
img_bg:addChild(txt_prop_u)

--Create Animation
result['animation'] = ccs.ActionTimeline:create()

result['animation']:setDuration(0)
result['animation']:setTimeSpeed(1.0000)
--Create Animation List

result['root'] = Node
return result;
end

return Result

