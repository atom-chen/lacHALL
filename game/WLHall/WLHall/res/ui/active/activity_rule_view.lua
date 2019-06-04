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
img_bg:loadTexture("hall/active/bonuspool/rule/bottom.png",0)
img_bg:setScale9Enabled(true)
img_bg:setCapInsets({x = 43, y = 43, width = 1101, height = 342})
img_bg:setLayoutComponentEnabled(true)
img_bg:setName("img_bg")
img_bg:setTag(1257)
img_bg:setCascadeColorEnabled(true)
img_bg:setCascadeOpacityEnabled(true)
img_bg:setPosition(0.0001, -36.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_bg)
layout:setSize({width = 1138.0000, height = 568.0000})
layout:setLeftMargin(-568.9999)
layout:setRightMargin(-569.0001)
layout:setTopMargin(-248.0000)
layout:setBottomMargin(-320.0000)
Node:addChild(img_bg)

--Create sv_content
local sv_content = ccui.ScrollView:create()
sv_content:setInnerContainerSize({width = 1000, height = 349})
sv_content:ignoreContentAdaptWithSize(false)
sv_content:setClippingEnabled(true)
sv_content:setBackGroundColorOpacity(102)
sv_content:setLayoutComponentEnabled(true)
sv_content:setName("sv_content")
sv_content:setTag(6)
sv_content:setCascadeColorEnabled(true)
sv_content:setCascadeOpacityEnabled(true)
sv_content:setAnchorPoint(0.5000, 0.5000)
sv_content:setPosition(0.0003, -73.5000)
layout = ccui.LayoutComponent:bindLayoutComponent(sv_content)
layout:setSize({width = 1000.0000, height = 349.0000})
layout:setLeftMargin(-499.9997)
layout:setRightMargin(-500.0003)
layout:setTopMargin(-101.0000)
layout:setBottomMargin(-248.0000)
Node:addChild(sv_content)

--Create under_line
local under_line = ccui.ImageView:create()
under_line:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/bonuspool.plist")
under_line:loadTexture("hall/active/bonuspool/rule/underLine.png",1)
under_line:setScale9Enabled(true)
under_line:setCapInsets({x = 19, y = 0, width = 20, height = 2})
under_line:setLayoutComponentEnabled(true)
under_line:setName("under_line")
under_line:setTag(1258)
under_line:setCascadeColorEnabled(true)
under_line:setCascadeOpacityEnabled(true)
under_line:setPosition(0.0000, 132.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(under_line)
layout:setSize({width = 950.0000, height = 2.0000})
layout:setLeftMargin(-475.0000)
layout:setRightMargin(-475.0000)
layout:setTopMargin(-133.0000)
layout:setBottomMargin(131.0000)
Node:addChild(under_line)

--Create btn_close
local btn_close = ccui.Layout:create()
btn_close:ignoreContentAdaptWithSize(false)
btn_close:setClippingEnabled(false)
btn_close:setBackGroundColorOpacity(102)
btn_close:setTouchEnabled(true);
btn_close:setLayoutComponentEnabled(true)
btn_close:setName("btn_close")
btn_close:setTag(1260)
btn_close:setCascadeColorEnabled(true)
btn_close:setCascadeOpacityEnabled(true)
btn_close:setAnchorPoint(0.5000, 0.5000)
btn_close:setPosition(490.0000, 192.0000)
btn_close:setColor({r = 142, g = 30, b = 0})
layout = ccui.LayoutComponent:bindLayoutComponent(btn_close)
layout:setSize({width = 60.0000, height = 60.0000})
layout:setLeftMargin(460.0000)
layout:setRightMargin(-520.0000)
layout:setTopMargin(-222.0000)
layout:setBottomMargin(162.0000)
Node:addChild(btn_close)

--Create Image_4
local Image_4 = ccui.ImageView:create()
Image_4:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
Image_4:loadTexture("hall/common/new_btn_close.png",1)
Image_4:setLayoutComponentEnabled(true)
Image_4:setName("Image_4")
Image_4:setTag(1261)
Image_4:setCascadeColorEnabled(true)
Image_4:setCascadeOpacityEnabled(true)
Image_4:setPosition(30.0000, 30.0000)
Image_4:setColor({r = 142, g = 30, b = 0})
layout = ccui.LayoutComponent:bindLayoutComponent(Image_4)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.4333)
layout:setPercentHeight(0.4333)
layout:setSize({width = 26.0000, height = 26.0000})
layout:setLeftMargin(17.0000)
layout:setRightMargin(17.0000)
layout:setTopMargin(17.0000)
layout:setBottomMargin(17.0000)
btn_close:addChild(Image_4)

--Create txt_title
local txt_title = ccui.Text:create()
txt_title:ignoreContentAdaptWithSize(true)
txt_title:setTextAreaSize({width = 0, height = 0})
txt_title:setFontSize(40)
txt_title:setString([[活动规则]])
txt_title:setLayoutComponentEnabled(true)
txt_title:setName("txt_title")
txt_title:setTag(1262)
txt_title:setCascadeColorEnabled(true)
txt_title:setCascadeOpacityEnabled(true)
txt_title:setPosition(0.0000, 179.0000)
txt_title:setTextColor({r = 142, g = 30, b = 0})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_title)
layout:setSize({width = 160.0000, height = 40.0000})
layout:setLeftMargin(-80.0000)
layout:setRightMargin(-80.0000)
layout:setTopMargin(-199.0000)
layout:setBottomMargin(159.0000)
Node:addChild(txt_title)

--Create Animation
result['animation'] = ccs.ActionTimeline:create()
  
result['animation']:setDuration(0)
result['animation']:setTimeSpeed(1.0000)
--Create Animation List

result['root'] = Node
return result;
end

return Result

