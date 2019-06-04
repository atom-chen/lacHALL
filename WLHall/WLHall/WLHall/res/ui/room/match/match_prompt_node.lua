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
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
img_bg:loadTexture("hall/common/new_pop_bg_3.png",1)
img_bg:setScale9Enabled(true)
img_bg:setCapInsets({x = 8, y = 8, width = 10, height = 10})
img_bg:setTouchEnabled(true);
img_bg:setLayoutComponentEnabled(true)
img_bg:setName("img_bg")
img_bg:setTag(13)
img_bg:setCascadeColorEnabled(true)
img_bg:setCascadeOpacityEnabled(true)
img_bg:setAnchorPoint(0.5000, 0.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_bg)
layout:setSize({width = 1000.0000, height = 260.0000})
layout:setLeftMargin(-500.0000)
layout:setRightMargin(-500.0000)
layout:setTopMargin(-260.0000)
Node:addChild(img_bg)

--Create txt_title
local txt_title = ccui.Text:create()
txt_title:ignoreContentAdaptWithSize(true)
txt_title:setTextAreaSize({width = 0, height = 0})
txt_title:setFontSize(30)
txt_title:setString([[您报名的斗地主xxxx还有5分钟就要开赛了，请前往大厅内等待比赛]])
txt_title:setLayoutComponentEnabled(true)
txt_title:setName("txt_title")
txt_title:setTag(14)
txt_title:setCascadeColorEnabled(true)
txt_title:setCascadeOpacityEnabled(true)
txt_title:setPosition(500.0000, 175.0000)
txt_title:setTextColor({r = 0, g = 0, b = 0})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_title)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.6731)
layout:setPercentWidth(0.8900)
layout:setPercentHeight(0.1308)
layout:setSize({width = 890.0000, height = 34.0000})
layout:setLeftMargin(55.0000)
layout:setRightMargin(55.0000)
layout:setTopMargin(68.0000)
layout:setBottomMargin(158.0000)
img_bg:addChild(txt_title)

--Create btn_in
local btn_in = ccui.Button:create()
btn_in:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
btn_in:loadTextureNormal("hall/common/new_btn_noangle.png",1)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
btn_in:loadTexturePressed("hall/common/new_btn_noangle.png",1)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
btn_in:loadTextureDisabled("hall/common/new_btn_noangle.png",1)
btn_in:setTitleFontSize(24)
btn_in:setTitleColor({r = 65, g = 65, b = 70})
btn_in:setScale9Enabled(true)
btn_in:setCapInsets({x = 3, y = 3, width = 12, height = 12})
btn_in:setLayoutComponentEnabled(true)
btn_in:setName("btn_in")
btn_in:setTag(15)
btn_in:setCascadeColorEnabled(true)
btn_in:setCascadeOpacityEnabled(true)
btn_in:setPosition(654.1100, 70.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_in)
layout:setPositionPercentX(0.6541)
layout:setPositionPercentY(0.2692)
layout:setPercentWidth(0.2000)
layout:setPercentHeight(0.2692)
layout:setSize({width = 200.0000, height = 70.0000})
layout:setLeftMargin(554.1100)
layout:setRightMargin(245.8900)
layout:setTopMargin(155.0000)
layout:setBottomMargin(35.0000)
img_bg:addChild(btn_in)

--Create btn_bg
local btn_bg = ccui.ImageView:create()
btn_bg:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
btn_bg:loadTexture("hall/common/new_btn_noangle.png",1)
btn_bg:setScale9Enabled(true)
btn_bg:setCapInsets({x = 8, y = 8, width = 2, height = 2})
btn_bg:setLayoutComponentEnabled(true)
btn_bg:setName("btn_bg")
btn_bg:setTag(318)
btn_bg:setCascadeColorEnabled(true)
btn_bg:setCascadeOpacityEnabled(true)
btn_bg:setPosition(100.0000, 35.0000)
btn_bg:setColor({r = 16, g = 116, b = 233})
layout = ccui.LayoutComponent:bindLayoutComponent(btn_bg)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidthEnabled(true)
layout:setPercentHeightEnabled(true)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(1.0000)
layout:setSize({width = 200.0000, height = 70.0000})
btn_in:addChild(btn_bg)

--Create txt
local txt = ccui.Text:create()
txt:ignoreContentAdaptWithSize(true)
txt:setTextAreaSize({width = 0, height = 0})
txt:setFontSize(28)
txt:setString([[知道了（10S）]])
txt:setLayoutComponentEnabled(true)
txt:setName("txt")
txt:setTag(6)
txt:setCascadeColorEnabled(true)
txt:setCascadeOpacityEnabled(true)
txt:setPosition(100.0000, 33.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(txt)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.4714)
layout:setPercentWidth(0.8600)
layout:setPercentHeight(0.4571)
layout:setSize({width = 172.0000, height = 32.0000})
layout:setLeftMargin(14.0000)
layout:setRightMargin(14.0000)
layout:setTopMargin(21.0000)
layout:setBottomMargin(17.0000)
btn_in:addChild(txt)

--Create btn_exit
local btn_exit = ccui.Button:create()
btn_exit:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
btn_exit:loadTextureNormal("hall/common/new_btn_noangle.png",1)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
btn_exit:loadTexturePressed("hall/common/new_btn_noangle.png",1)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
btn_exit:loadTextureDisabled("hall/common/new_btn_noangle.png",1)
btn_exit:setTitleFontName("")
btn_exit:setTitleFontSize(24)
btn_exit:setTitleColor({r = 65, g = 65, b = 70})
btn_exit:setScale9Enabled(true)
btn_exit:setCapInsets({x = 3, y = 3, width = 12, height = 12})
btn_exit:setLayoutComponentEnabled(true)
btn_exit:setName("btn_exit")
btn_exit:setTag(16)
btn_exit:setCascadeColorEnabled(true)
btn_exit:setCascadeOpacityEnabled(true)
btn_exit:setPosition(338.9490, 70.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_exit)
layout:setPositionPercentX(0.3389)
layout:setPositionPercentY(0.2692)
layout:setPercentWidth(0.2000)
layout:setPercentHeight(0.2692)
layout:setSize({width = 200.0000, height = 70.0000})
layout:setLeftMargin(238.9490)
layout:setRightMargin(561.0510)
layout:setTopMargin(155.0000)
layout:setBottomMargin(35.0000)
img_bg:addChild(btn_exit)

--Create btn_bg
local btn_bg = ccui.ImageView:create()
btn_bg:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
btn_bg:loadTexture("hall/common/new_btn_noangle.png",1)
btn_bg:setScale9Enabled(true)
btn_bg:setCapInsets({x = 8, y = 8, width = 2, height = 2})
btn_bg:setLayoutComponentEnabled(true)
btn_bg:setName("btn_bg")
btn_bg:setTag(319)
btn_bg:setCascadeColorEnabled(true)
btn_bg:setCascadeOpacityEnabled(true)
btn_bg:setPosition(100.0000, 35.0000)
btn_bg:setColor({r = 38, g = 155, b = 88})
layout = ccui.LayoutComponent:bindLayoutComponent(btn_bg)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidthEnabled(true)
layout:setPercentHeightEnabled(true)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(1.0000)
layout:setSize({width = 200.0000, height = 70.0000})
btn_exit:addChild(btn_bg)

--Create txt
local txt = ccui.Text:create()
txt:ignoreContentAdaptWithSize(true)
txt:setTextAreaSize({width = 0, height = 0})
txt:setFontSize(28)
txt:setString([[退出]])
txt:setLayoutComponentEnabled(true)
txt:setName("txt")
txt:setTag(320)
txt:setCascadeColorEnabled(true)
txt:setCascadeOpacityEnabled(true)
txt:setPosition(100.0000, 33.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(txt)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.4714)
layout:setPercentWidth(0.2850)
layout:setPercentHeight(0.4571)
layout:setSize({width = 57.0000, height = 32.0000})
layout:setLeftMargin(71.5000)
layout:setRightMargin(71.5000)
layout:setTopMargin(21.0000)
layout:setBottomMargin(17.0000)
btn_exit:addChild(txt)

--Create Animation
result['animation'] = ccs.ActionTimeline:create()

result['animation']:setDuration(0)
result['animation']:setTimeSpeed(1.0000)
--Create Animation List

result['root'] = Node
return result;
end

return Result
