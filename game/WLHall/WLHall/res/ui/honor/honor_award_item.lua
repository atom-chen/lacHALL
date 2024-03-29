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

--Create panel_1
local panel_1 = ccui.Layout:create()
panel_1:ignoreContentAdaptWithSize(false)
panel_1:setClippingEnabled(false)
panel_1:setBackGroundColorOpacity(102)
panel_1:setTouchEnabled(true);
panel_1:setLayoutComponentEnabled(true)
panel_1:setName("panel_1")
panel_1:setTag(1332)
panel_1:setCascadeColorEnabled(true)
panel_1:setCascadeOpacityEnabled(true)
panel_1:setAnchorPoint(0.5000, 0.5000)
layout = ccui.LayoutComponent:bindLayoutComponent(panel_1)
layout:setSize({width = 233.0000, height = 167.0000})
layout:setLeftMargin(-116.5000)
layout:setRightMargin(-116.5000)
layout:setTopMargin(-83.5000)
layout:setBottomMargin(-83.5000)
Node:addChild(panel_1)

--Create img_bg
local img_bg = ccui.ImageView:create()
img_bg:ignoreContentAdaptWithSize(false)
img_bg:loadTexture("hall/newhonor/img_awardbg.png",0)
img_bg:setLayoutComponentEnabled(true)
img_bg:setName("img_bg")
img_bg:setTag(229)
img_bg:setCascadeColorEnabled(true)
img_bg:setCascadeOpacityEnabled(true)
img_bg:setPosition(116.5000, 83.5000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_bg)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(1.0000)
layout:setSize({width = 233.0000, height = 167.0000})
panel_1:addChild(img_bg)

--Create img_txt
local img_txt = ccui.ImageView:create()
img_txt:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/newhonor.plist")
img_txt:loadTexture("hall/newhonor/img_award.png",1)
img_txt:setLayoutComponentEnabled(true)
img_txt:setName("img_txt")
img_txt:setTag(232)
img_txt:setCascadeColorEnabled(true)
img_txt:setCascadeOpacityEnabled(true)
img_txt:setPosition(112.4993, 144.7800)
layout = ccui.LayoutComponent:bindLayoutComponent(img_txt)
layout:setPositionPercentX(0.4828)
layout:setPositionPercentY(0.8669)
layout:setPercentWidth(0.4163)
layout:setPercentHeight(0.1497)
layout:setSize({width = 97.0000, height = 25.0000})
layout:setLeftMargin(63.9993)
layout:setRightMargin(72.0007)
layout:setTopMargin(9.7200)
layout:setBottomMargin(132.2800)
panel_1:addChild(img_txt)

--Create txt1
local txt1 = ccui.Text:create()
txt1:ignoreContentAdaptWithSize(true)
txt1:setTextAreaSize({width = 0, height = 0})
txt1:setFontSize(25)
txt1:setString([[奖励数据获取失败]])
txt1:setLayoutComponentEnabled(true)
txt1:setName("txt1")
txt1:setTag(734)
txt1:setCascadeColorEnabled(true)
txt1:setCascadeOpacityEnabled(true)
txt1:setVisible(false)
txt1:setPosition(116.5000, 75.1500)
layout = ccui.LayoutComponent:bindLayoutComponent(txt1)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.4500)
layout:setPercentWidth(0.8584)
layout:setPercentHeight(0.1497)
layout:setSize({width = 200.0000, height = 25.0000})
layout:setLeftMargin(16.5000)
layout:setRightMargin(16.5000)
layout:setTopMargin(79.3500)
layout:setBottomMargin(62.6500)
panel_1:addChild(txt1)

--Create award
local award = ccui.Layout:create()
award:ignoreContentAdaptWithSize(false)
award:setClippingEnabled(false)
award:setBackGroundColorOpacity(102)
award:setTouchEnabled(true);
award:setLayoutComponentEnabled(true)
award:setName("award")
award:setTag(1340)
award:setCascadeColorEnabled(true)
award:setCascadeOpacityEnabled(true)
award:setAnchorPoint(0.5000, 0.0000)
award:setPosition(116.5000, 13.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(award)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.0778)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(0.8982)
layout:setSize({width = 233.0000, height = 150.0000})
layout:setTopMargin(4.0000)
layout:setBottomMargin(13.0000)
panel_1:addChild(award)

--Create award_1
local award_1 = ccui.ImageView:create()
award_1:ignoreContentAdaptWithSize(false)
award_1:loadTexture("hall/common/prop_bean_s.png",0)
award_1:setLayoutComponentEnabled(true)
award_1:setName("award_1")
award_1:setTag(1341)
award_1:setCascadeColorEnabled(true)
award_1:setCascadeOpacityEnabled(true)
award_1:setPosition(59.4344, 74.0000)
award_1:setScaleX(1.1000)
award_1:setScaleY(1.1000)
layout = ccui.LayoutComponent:bindLayoutComponent(award_1)
layout:setPositionPercentX(0.2551)
layout:setPositionPercentY(0.4933)
layout:setPercentWidth(0.3004)
layout:setPercentHeight(0.4667)
layout:setSize({width = 70.0000, height = 70.0000})
layout:setLeftMargin(24.4344)
layout:setRightMargin(138.5656)
layout:setTopMargin(41.0000)
layout:setBottomMargin(39.0000)
award:addChild(award_1)

--Create award_2
local award_2 = ccui.ImageView:create()
award_2:ignoreContentAdaptWithSize(false)
award_2:loadTexture("hall/common/prop_lpq_s.png",0)
award_2:setLayoutComponentEnabled(true)
award_2:setName("award_2")
award_2:setTag(1342)
award_2:setCascadeColorEnabled(true)
award_2:setCascadeOpacityEnabled(true)
award_2:setPosition(174.8554, 74.0000)
award_2:setScaleX(1.1000)
award_2:setScaleY(1.1000)
layout = ccui.LayoutComponent:bindLayoutComponent(award_2)
layout:setPositionPercentX(0.7505)
layout:setPositionPercentY(0.4933)
layout:setPercentWidth(0.3004)
layout:setPercentHeight(0.4667)
layout:setSize({width = 70.0000, height = 70.0000})
layout:setLeftMargin(139.8554)
layout:setRightMargin(23.1446)
layout:setTopMargin(41.0000)
layout:setBottomMargin(39.0000)
award:addChild(award_2)

--Create award_count1
local award_count1 = ccui.Text:create()
award_count1:ignoreContentAdaptWithSize(true)
award_count1:setTextAreaSize({width = 0, height = 0})
award_count1:setFontSize(22)
award_count1:setString([[1000]])
award_count1:setLayoutComponentEnabled(true)
award_count1:setName("award_count1")
award_count1:setTag(1343)
award_count1:setCascadeColorEnabled(true)
award_count1:setCascadeOpacityEnabled(true)
award_count1:setPosition(57.2948, 30.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(award_count1)
layout:setPositionPercentX(0.2459)
layout:setPositionPercentY(0.2000)
layout:setPercentWidth(0.1888)
layout:setPercentHeight(0.1467)
layout:setSize({width = 44.0000, height = 22.0000})
layout:setLeftMargin(35.2948)
layout:setRightMargin(153.7052)
layout:setTopMargin(109.0000)
layout:setBottomMargin(19.0000)
award:addChild(award_count1)

--Create award_count2
local award_count2 = ccui.Text:create()
award_count2:ignoreContentAdaptWithSize(true)
award_count2:setTextAreaSize({width = 0, height = 0})
award_count2:setFontSize(22)
award_count2:setString([[1000]])
award_count2:setLayoutComponentEnabled(true)
award_count2:setName("award_count2")
award_count2:setTag(1344)
award_count2:setCascadeColorEnabled(true)
award_count2:setCascadeOpacityEnabled(true)
award_count2:setPosition(175.1992, 30.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(award_count2)
layout:setPositionPercentX(0.7519)
layout:setPositionPercentY(0.2000)
layout:setPercentWidth(0.1888)
layout:setPercentHeight(0.1467)
layout:setSize({width = 44.0000, height = 22.0000})
layout:setLeftMargin(153.1992)
layout:setRightMargin(35.8008)
layout:setTopMargin(109.0000)
layout:setBottomMargin(19.0000)
award:addChild(award_count2)

--Create img_line
local img_line = ccui.ImageView:create()
img_line:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/newhonor.plist")
img_line:loadTexture("hall/newhonor/img_line.png",1)
img_line:setLayoutComponentEnabled(true)
img_line:setName("img_line")
img_line:setTag(231)
img_line:setCascadeColorEnabled(true)
img_line:setCascadeOpacityEnabled(true)
img_line:setPosition(116.0000, 58.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_line)
layout:setPositionPercentX(0.4979)
layout:setPositionPercentY(0.3867)
layout:setPercentWidth(0.0086)
layout:setPercentHeight(0.6400)
layout:setSize({width = 2.0000, height = 96.0000})
layout:setLeftMargin(115.0000)
layout:setRightMargin(116.0000)
layout:setTopMargin(44.0000)
layout:setBottomMargin(10.0000)
award:addChild(img_line)

--Create Animation
result['animation'] = ccs.ActionTimeline:create()
  
result['animation']:setDuration(0)
result['animation']:setTimeSpeed(1.0000)
--Create Animation List

result['root'] = Node
return result;
end

return Result

