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

--Create img_bg
local img_bg = ccui.ImageView:create()
img_bg:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/match_tv_view.plist")
img_bg:loadTexture("hall/room/match/match_apply/bg.png",1)
img_bg:setScale9Enabled(true)
img_bg:setCapInsets({x = 16, y = 61, width = 5, height = 8})
img_bg:setLayoutComponentEnabled(true)
img_bg:setName("img_bg")
img_bg:setTag(580)
img_bg:setCascadeColorEnabled(true)
img_bg:setCascadeOpacityEnabled(true)
layout = ccui.LayoutComponent:bindLayoutComponent(img_bg)
layout:setSize({width = 964.0000, height = 500.0000})
layout:setLeftMargin(-482.0000)
layout:setRightMargin(-482.0000)
layout:setTopMargin(-250.0000)
layout:setBottomMargin(-250.0000)
Node:addChild(img_bg)

--Create txt_title
local txt_title = ccui.Text:create()
txt_title:ignoreContentAdaptWithSize(true)
txt_title:setTextAreaSize({width = 0, height = 0})
txt_title:setFontSize(28)
txt_title:setString([[吉林电视台]])
txt_title:setLayoutComponentEnabled(true)
txt_title:setName("txt_title")
txt_title:setTag(579)
txt_title:setCascadeColorEnabled(true)
txt_title:setCascadeOpacityEnabled(true)
txt_title:setPosition(0.0000, 216.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(txt_title)
layout:setPositionPercentXEnabled(true)
layout:setSize({width = 140.0000, height = 28.0000})
layout:setLeftMargin(-70.0000)
layout:setRightMargin(-70.0000)
layout:setTopMargin(-230.0000)
layout:setBottomMargin(202.0000)
Node:addChild(txt_title)

--Create sv_content
local sv_content = ccui.ScrollView:create()
sv_content:setInnerContainerSize({width = 900, height = 399})
sv_content:ignoreContentAdaptWithSize(false)
sv_content:setClippingEnabled(true)
sv_content:setBackGroundColorOpacity(102)
sv_content:setLayoutComponentEnabled(true)
sv_content:setName("sv_content")
sv_content:setTag(578)
sv_content:setCascadeColorEnabled(true)
sv_content:setCascadeOpacityEnabled(true)
sv_content:setAnchorPoint(0.5000, 0.5000)
sv_content:setPosition(0.0003, -26.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(sv_content)
layout:setSize({width = 900.0000, height = 399.0000})
layout:setLeftMargin(-449.9997)
layout:setRightMargin(-450.0003)
layout:setTopMargin(-173.5000)
layout:setBottomMargin(-225.5000)
Node:addChild(sv_content)

--Create btn_close
local btn_close = ccui.Layout:create()
btn_close:ignoreContentAdaptWithSize(false)
btn_close:setClippingEnabled(false)
btn_close:setBackGroundColorOpacity(102)
btn_close:setTouchEnabled(true);
btn_close:setLayoutComponentEnabled(true)
btn_close:setName("btn_close")
btn_close:setTag(583)
btn_close:setCascadeColorEnabled(true)
btn_close:setCascadeOpacityEnabled(true)
btn_close:setAnchorPoint(0.5000, 0.5000)
btn_close:setPosition(451.6837, 217.5644)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_close)
layout:setSize({width = 50.0000, height = 50.0000})
layout:setLeftMargin(426.6837)
layout:setRightMargin(-476.6837)
layout:setTopMargin(-242.5644)
layout:setBottomMargin(192.5644)
Node:addChild(btn_close)

--Create img_close
local img_close = ccui.ImageView:create()
img_close:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
img_close:loadTexture("hall/common/new_btn_close.png",1)
img_close:setLayoutComponentEnabled(true)
img_close:setName("img_close")
img_close:setTag(584)
img_close:setCascadeColorEnabled(true)
img_close:setCascadeOpacityEnabled(true)
img_close:setPosition(25.0000, 25.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_close)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.4800)
layout:setPercentHeight(0.5000)
layout:setSize({width = 24.0000, height = 25.0000})
layout:setLeftMargin(13.0000)
layout:setRightMargin(13.0000)
layout:setTopMargin(12.5000)
layout:setBottomMargin(12.5000)
btn_close:addChild(img_close)

--Create Animation
result['animation'] = ccs.ActionTimeline:create()
  
result['animation']:setDuration(0)
result['animation']:setTimeSpeed(1.0000)
--Create Animation List

result['root'] = Node
return result;
end

return Result

