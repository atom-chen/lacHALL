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
panel_bg:setTag(507)
panel_bg:setCascadeColorEnabled(true)
panel_bg:setCascadeOpacityEnabled(true)
panel_bg:setAnchorPoint(0.5000, 0.5000)
panel_bg:setPosition(0.0000, -20.0000)
panel_bg:setScaleX(10.0000)
panel_bg:setScaleY(10.0000)
panel_bg:setOpacity(0)
layout = ccui.LayoutComponent:bindLayoutComponent(panel_bg)
layout:setSize({width = 200.0000, height = 200.0000})
layout:setLeftMargin(-100.0000)
layout:setRightMargin(-100.0000)
layout:setTopMargin(-80.0000)
layout:setBottomMargin(-120.0000)
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
img_bg:setTag(494)
img_bg:setCascadeColorEnabled(true)
img_bg:setCascadeOpacityEnabled(true)
img_bg:setPosition(0.0000, -20.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_bg)
layout:setSize({width = 426.0000, height = 545.0000})
layout:setLeftMargin(-213.0000)
layout:setRightMargin(-213.0000)
layout:setTopMargin(-252.5000)
layout:setBottomMargin(-292.5000)
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
img_icon_bg:setTag(495)
img_icon_bg:setCascadeColorEnabled(true)
img_icon_bg:setCascadeOpacityEnabled(true)
img_icon_bg:setPosition(80.8599, 463.3400)
layout = ccui.LayoutComponent:bindLayoutComponent(img_icon_bg)
layout:setPositionPercentX(0.1898)
layout:setPositionPercentY(0.8502)
layout:setPercentWidth(0.2629)
layout:setPercentHeight(0.2055)
layout:setSize({width = 112.0000, height = 112.0000})
layout:setLeftMargin(24.8599)
layout:setRightMargin(289.1401)
layout:setTopMargin(25.6600)
layout:setBottomMargin(407.3400)
img_bg:addChild(img_icon_bg)

--Create img_prop_icon
local img_prop_icon = ccui.ImageView:create()
img_prop_icon:ignoreContentAdaptWithSize(false)
img_prop_icon:loadTexture("Default/ImageFile.png",0)
img_prop_icon:setLayoutComponentEnabled(true)
img_prop_icon:setName("img_prop_icon")
img_prop_icon:setTag(496)
img_prop_icon:setCascadeColorEnabled(true)
img_prop_icon:setCascadeOpacityEnabled(true)
img_prop_icon:setPosition(80.8615, 463.3448)
layout = ccui.LayoutComponent:bindLayoutComponent(img_prop_icon)
layout:setPositionPercentX(0.1898)
layout:setPositionPercentY(0.8502)
layout:setPercentWidth(0.2629)
layout:setPercentHeight(0.2055)
layout:setSize({width = 112.0000, height = 112.0000})
layout:setLeftMargin(24.8615)
layout:setRightMargin(289.1385)
layout:setTopMargin(25.6552)
layout:setBottomMargin(407.3448)
img_bg:addChild(img_prop_icon)

--Create txt_title_describe
local txt_title_describe = ccui.Text:create()
txt_title_describe:ignoreContentAdaptWithSize(true)
txt_title_describe:setTextAreaSize({width = 0, height = 0})
txt_title_describe:setFontSize(28)
txt_title_describe:setString([[功能描述]])
txt_title_describe:setLayoutComponentEnabled(true)
txt_title_describe:setName("txt_title_describe")
txt_title_describe:setTag(497)
txt_title_describe:setCascadeColorEnabled(true)
txt_title_describe:setCascadeOpacityEnabled(true)
txt_title_describe:setAnchorPoint(0.0000, 0.5000)
txt_title_describe:setPosition(25.1597, 354.7698)
txt_title_describe:setTextColor({r = 218, g = 148, b = 12})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_title_describe)
layout:setPositionPercentX(0.0591)
layout:setPositionPercentY(0.6510)
layout:setPercentWidth(0.2700)
layout:setPercentHeight(0.0587)
layout:setSize({width = 115.0000, height = 32.0000})
layout:setLeftMargin(25.1597)
layout:setRightMargin(285.8403)
layout:setTopMargin(174.2302)
layout:setBottomMargin(338.7698)
img_bg:addChild(txt_title_describe)

--Create txt_title_source
local txt_title_source = ccui.Text:create()
txt_title_source:ignoreContentAdaptWithSize(true)
txt_title_source:setTextAreaSize({width = 0, height = 0})
txt_title_source:setFontSize(28)
txt_title_source:setString([[物品来源]])
txt_title_source:setLayoutComponentEnabled(true)
txt_title_source:setName("txt_title_source")
txt_title_source:setTag(498)
txt_title_source:setCascadeColorEnabled(true)
txt_title_source:setCascadeOpacityEnabled(true)
txt_title_source:setAnchorPoint(0.0000, 0.5000)
txt_title_source:setPosition(25.1599, 233.4101)
txt_title_source:setTextColor({r = 218, g = 148, b = 12})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_title_source)
layout:setPositionPercentX(0.0591)
layout:setPositionPercentY(0.4283)
layout:setPercentWidth(0.2700)
layout:setPercentHeight(0.0587)
layout:setSize({width = 115.0000, height = 32.0000})
layout:setLeftMargin(25.1599)
layout:setRightMargin(285.8401)
layout:setTopMargin(295.5899)
layout:setBottomMargin(217.4101)
img_bg:addChild(txt_title_source)

--Create txt_name
local txt_name = ccui.Text:create()
txt_name:ignoreContentAdaptWithSize(true)
txt_name:setTextAreaSize({width = 0, height = 0})
txt_name:setFontSize(28)
txt_name:setString([[参赛券]])
txt_name:setLayoutComponentEnabled(true)
txt_name:setName("txt_name")
txt_name:setTag(499)
txt_name:setCascadeColorEnabled(true)
txt_name:setCascadeOpacityEnabled(true)
txt_name:setAnchorPoint(0.0000, 0.5000)
txt_name:setPosition(150.2329, 483.8812)
txt_name:setTextColor({r = 231, g = 223, b = 213})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_name)
layout:setPositionPercentX(0.3527)
layout:setPositionPercentY(0.8879)
layout:setPercentWidth(0.2042)
layout:setPercentHeight(0.0587)
layout:setSize({width = 87.0000, height = 32.0000})
layout:setLeftMargin(150.2329)
layout:setRightMargin(188.7671)
layout:setTopMargin(45.1188)
layout:setBottomMargin(467.8812)
img_bg:addChild(txt_name)

--Create txt_describe
local txt_describe = ccui.Text:create()
txt_describe:ignoreContentAdaptWithSize(true)
txt_describe:setTextAreaSize({width = 0, height = 0})
txt_describe:setFontSize(26)
txt_describe:setString([[用于参加斗地主报名使用]])
txt_describe:setLayoutComponentEnabled(true)
txt_describe:setName("txt_describe")
txt_describe:setTag(500)
txt_describe:setCascadeColorEnabled(true)
txt_describe:setCascadeOpacityEnabled(true)
txt_describe:setAnchorPoint(0.0000, 1.0000)
txt_describe:setPosition(25.1597, 335.7699)
layout = ccui.LayoutComponent:bindLayoutComponent(txt_describe)
layout:setPositionPercentX(0.0591)
layout:setPositionPercentY(0.6161)
layout:setPercentWidth(0.6714)
layout:setPercentHeight(0.0477)
layout:setSize({width = 286.0000, height = 26.0000})
layout:setLeftMargin(25.1597)
layout:setRightMargin(114.8403)
layout:setTopMargin(209.2301)
layout:setBottomMargin(309.7699)
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
txt_source:setTag(501)
txt_source:setCascadeColorEnabled(true)
txt_source:setCascadeOpacityEnabled(true)
txt_source:setAnchorPoint(0.0000, 1.0000)
txt_source:setPosition(25.1599, 216.4658)
layout = ccui.LayoutComponent:bindLayoutComponent(txt_source)
layout:setPositionPercentX(0.0591)
layout:setPositionPercentY(0.3972)
layout:setPercentWidth(0.9155)
layout:setPercentHeight(0.0954)
layout:setSize({width = 390.0000, height = 52.0000})
layout:setLeftMargin(25.1599)
layout:setRightMargin(10.8401)
layout:setTopMargin(328.5342)
layout:setBottomMargin(164.4658)
img_bg:addChild(txt_source)

--Create txt_title_count
local txt_title_count = ccui.Text:create()
txt_title_count:ignoreContentAdaptWithSize(true)
txt_title_count:setTextAreaSize({width = 0, height = 0})
txt_title_count:setFontSize(24)
txt_title_count:setString([[拥有]])
txt_title_count:setLayoutComponentEnabled(true)
txt_title_count:setName("txt_title_count")
txt_title_count:setTag(502)
txt_title_count:setCascadeColorEnabled(true)
txt_title_count:setCascadeOpacityEnabled(true)
txt_title_count:setAnchorPoint(0.0000, 0.5000)
txt_title_count:setPosition(152.8502, 434.4801)
txt_title_count:setTextColor({r = 139, g = 170, b = 191})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_title_count)
layout:setPositionPercentX(0.3588)
layout:setPositionPercentY(0.7972)
layout:setPercentWidth(0.1197)
layout:setPercentHeight(0.0514)
layout:setSize({width = 51.0000, height = 28.0000})
layout:setLeftMargin(152.8502)
layout:setRightMargin(222.1498)
layout:setTopMargin(96.5199)
layout:setBottomMargin(420.4801)
img_bg:addChild(txt_title_count)

--Create txt_count
local txt_count = ccui.Text:create()
txt_count:ignoreContentAdaptWithSize(true)
txt_count:setTextAreaSize({width = 0, height = 0})
txt_count:setFontSize(34)
txt_count:setString([[10]])
txt_count:setLayoutComponentEnabled(true)
txt_count:setName("txt_count")
txt_count:setTag(503)
txt_count:setCascadeColorEnabled(true)
txt_count:setCascadeOpacityEnabled(true)
txt_count:setPosition(241.6695, 434.4811)
txt_count:setTextColor({r = 98, g = 228, b = 72})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_count)
layout:setPositionPercentX(0.5673)
layout:setPositionPercentY(0.7972)
layout:setPercentWidth(0.0798)
layout:setPercentHeight(0.0716)
layout:setSize({width = 34.0000, height = 39.0000})
layout:setLeftMargin(224.6695)
layout:setRightMargin(167.3305)
layout:setTopMargin(91.0189)
layout:setBottomMargin(414.9811)
img_bg:addChild(txt_count)

--Create txt_prop_u
local txt_prop_u = ccui.Text:create()
txt_prop_u:ignoreContentAdaptWithSize(true)
txt_prop_u:setTextAreaSize({width = 0, height = 0})
txt_prop_u:setFontSize(24)
txt_prop_u:setString([[个]])
txt_prop_u:setLayoutComponentEnabled(true)
txt_prop_u:setName("txt_prop_u")
txt_prop_u:setTag(504)
txt_prop_u:setCascadeColorEnabled(true)
txt_prop_u:setCascadeOpacityEnabled(true)
txt_prop_u:setAnchorPoint(0.0000, 0.5000)
txt_prop_u:setPosition(281.6599, 434.4801)
txt_prop_u:setTextColor({r = 139, g = 170, b = 191})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_prop_u)
layout:setPositionPercentX(0.6612)
layout:setPositionPercentY(0.7972)
layout:setPercentWidth(0.0634)
layout:setPercentHeight(0.0514)
layout:setSize({width = 27.0000, height = 28.0000})
layout:setLeftMargin(281.6599)
layout:setRightMargin(117.3401)
layout:setTopMargin(96.5199)
layout:setBottomMargin(420.4801)
img_bg:addChild(txt_prop_u)

--Create btn_lqdwx
local btn_lqdwx = ccui.Button:create()
btn_lqdwx:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
btn_lqdwx:loadTextureNormal("hall/common/btn_green.png",1)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
btn_lqdwx:loadTexturePressed("hall/common/btn_green.png",1)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
btn_lqdwx:loadTextureDisabled("hall/common/btn_green.png",1)
btn_lqdwx:setTitleFontSize(14)
btn_lqdwx:setTitleColor({r = 65, g = 65, b = 70})
btn_lqdwx:setScale9Enabled(true)
btn_lqdwx:setCapInsets({x = 5, y = 5, width = 8, height = 8})
btn_lqdwx:setLayoutComponentEnabled(true)
btn_lqdwx:setName("btn_lqdwx")
btn_lqdwx:setTag(1000)
btn_lqdwx:setCascadeColorEnabled(true)
btn_lqdwx:setCascadeOpacityEnabled(true)
btn_lqdwx:setPosition(208.4500, 57.7300)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_lqdwx)
layout:setPositionPercentX(0.4893)
layout:setPositionPercentY(0.1059)
layout:setPercentWidth(0.6103)
layout:setPercentHeight(0.1211)
layout:setSize({width = 260.0000, height = 66.0000})
layout:setLeftMargin(78.4500)
layout:setRightMargin(87.5500)
layout:setTopMargin(454.2700)
layout:setBottomMargin(24.7300)
img_bg:addChild(btn_lqdwx)

--Create txt
local txt = ccui.Text:create()
txt:ignoreContentAdaptWithSize(true)
txt:setTextAreaSize({width = 0, height = 0})
txt:setFontSize(30)
txt:setString([[兑换房间卡]])
txt:setLayoutComponentEnabled(true)
txt:setName("txt")
txt:setTag(1000)
txt:setCascadeColorEnabled(true)
txt:setCascadeOpacityEnabled(true)
txt:setPosition(127.9998, 32.0002)
layout = ccui.LayoutComponent:bindLayoutComponent(txt)
layout:setPositionPercentX(0.4923)
layout:setPositionPercentY(0.4849)
layout:setPercentWidth(0.5885)
layout:setPercentHeight(0.5152)
layout:setSize({width = 153.0000, height = 34.0000})
layout:setLeftMargin(51.4998)
layout:setRightMargin(55.5002)
layout:setTopMargin(16.9998)
layout:setBottomMargin(15.0002)
btn_lqdwx:addChild(txt)

--Create Animation
result['animation'] = ccs.ActionTimeline:create()

result['animation']:setDuration(0)
result['animation']:setTimeSpeed(1.0000)
--Create Animation List

result['root'] = Node
return result;
end

return Result

