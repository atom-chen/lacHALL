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

--Create Layer
local Layer=cc.Node:create()
Layer:setName("Layer")
layout = ccui.LayoutComponent:bindLayoutComponent(Layer)
layout:setSize({width = 1280.0000, height = 720.0000})

--Create btn_tab_3
local btn_tab_3 = ccui.Button:create()
btn_tab_3:ignoreContentAdaptWithSize(false)
btn_tab_3:loadTextureNormal("hall/room/friend/pic_room_xcj.png",0)
btn_tab_3:loadTexturePressed("hall/room/friend/pic_room_xcj.png",0)
btn_tab_3:loadTextureDisabled("hall/room/friend/pic_room_xcj.png",0)
btn_tab_3:setTitleFontSize(14)
btn_tab_3:setTitleColor({r = 65, g = 65, b = 70})
btn_tab_3:setScale9Enabled(true)
btn_tab_3:setCapInsets({x = 15, y = 11, width = 212, height = 94})
btn_tab_3:setLayoutComponentEnabled(true)
btn_tab_3:setName("btn_tab_3")
btn_tab_3:setTag(483)
btn_tab_3:setCascadeColorEnabled(true)
btn_tab_3:setCascadeOpacityEnabled(true)
btn_tab_3:setPosition(-245.5040, 216.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_tab_3)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(-0.1918)
layout:setPositionPercentY(0.3000)
layout:setPercentWidth(0.1891)
layout:setPercentHeight(0.1611)
layout:setSize({width = 242.0000, height = 116.0000})
layout:setLeftMargin(-366.5040)
layout:setRightMargin(1404.5040)
layout:setTopMargin(446.0000)
layout:setBottomMargin(158.0000)
Layer:addChild(btn_tab_3)

--Create anima_hot
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/hot.plist")
local anima_hot = cc.Sprite:createWithSpriteFrameName("hall/room/hotanimate/hot_1.png")
anima_hot:setName("anima_hot")
anima_hot:setTag(451)
anima_hot:setCascadeColorEnabled(true)
anima_hot:setCascadeOpacityEnabled(true)
anima_hot:setPosition(121.0000, 60.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(anima_hot)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5172)
layout:setPercentWidth(1.0124)
layout:setPercentHeight(0.9914)
layout:setSize({width = 245.0000, height = 115.0000})
layout:setLeftMargin(-1.5000)
layout:setRightMargin(-1.5000)
layout:setTopMargin(-1.5000)
layout:setBottomMargin(2.5000)
anima_hot:setBlendFunc({src = 1, dst = 1})
btn_tab_3:addChild(anima_hot)

--Create btn_tab_2
local btn_tab_2 = ccui.Button:create()
btn_tab_2:ignoreContentAdaptWithSize(false)
btn_tab_2:loadTextureNormal("hall/room/friend/pic_room_qzc.png",0)
btn_tab_2:loadTexturePressed("hall/room/friend/pic_room_qzc.png",0)
btn_tab_2:loadTextureDisabled("hall/room/friend/pic_room_qzc.png",0)
btn_tab_2:setTitleFontSize(14)
btn_tab_2:setTitleColor({r = 65, g = 65, b = 70})
btn_tab_2:setScale9Enabled(true)
btn_tab_2:setCapInsets({x = 15, y = 11, width = 212, height = 94})
btn_tab_2:setLayoutComponentEnabled(true)
btn_tab_2:setName("btn_tab_2")
btn_tab_2:setTag(486)
btn_tab_2:setCascadeColorEnabled(true)
btn_tab_2:setCascadeOpacityEnabled(true)
btn_tab_2:setPosition(-230.9120, 345.6000)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_tab_2)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(-0.1804)
layout:setPositionPercentY(0.4800)
layout:setPercentWidth(0.1891)
layout:setPercentHeight(0.1611)
layout:setSize({width = 242.0000, height = 116.0000})
layout:setLeftMargin(-351.9120)
layout:setRightMargin(1389.9120)
layout:setTopMargin(316.4000)
layout:setBottomMargin(287.6000)
Layer:addChild(btn_tab_2)

--Create select
local select = ccui.ImageView:create()
select:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/room.plist")
select:loadTexture("hall/room/general/room_select.png",1)
select:setScale9Enabled(true)
select:setCapInsets({x = 11, y = 11, width = 14, height = 14})
select:setLayoutComponentEnabled(true)
select:setName("select")
select:setTag(362)
select:setCascadeColorEnabled(true)
select:setCascadeOpacityEnabled(true)
select:setVisible(false)
select:setAnchorPoint(0.0000, 0.0000)
select:setPosition(0.0000, 2.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(select)
layout:setPositionPercentY(0.0172)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(1.0000)
layout:setSize({width = 242.0000, height = 116.0000})
layout:setTopMargin(-2.0000)
layout:setBottomMargin(2.0000)
btn_tab_2:addChild(select)

--Create btn_tab_1
local btn_tab_1 = ccui.Button:create()
btn_tab_1:ignoreContentAdaptWithSize(false)
btn_tab_1:loadTextureNormal("hall/room/friend/pic_room_znc.png",0)
btn_tab_1:loadTexturePressed("hall/room/friend/pic_room_znc.png",0)
btn_tab_1:loadTextureDisabled("hall/room/friend/pic_room_znc.png",0)
btn_tab_1:setTitleFontSize(14)
btn_tab_1:setTitleColor({r = 65, g = 65, b = 70})
btn_tab_1:setScale9Enabled(true)
btn_tab_1:setCapInsets({x = 15, y = 11, width = 212, height = 94})
btn_tab_1:setLayoutComponentEnabled(true)
btn_tab_1:setName("btn_tab_1")
btn_tab_1:setTag(489)
btn_tab_1:setCascadeColorEnabled(true)
btn_tab_1:setCascadeOpacityEnabled(true)
btn_tab_1:setPosition(-219.9040, 475.2000)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_tab_1)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(-0.1718)
layout:setPositionPercentY(0.6600)
layout:setPercentWidth(0.1891)
layout:setPercentHeight(0.1611)
layout:setSize({width = 242.0000, height = 116.0000})
layout:setLeftMargin(-340.9040)
layout:setRightMargin(1378.9040)
layout:setTopMargin(186.8000)
layout:setBottomMargin(417.2000)
Layer:addChild(btn_tab_1)

--Create select
local select = ccui.ImageView:create()
select:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/room.plist")
select:loadTexture("hall/room/general/room_select.png",1)
select:setScale9Enabled(true)
select:setCapInsets({x = 11, y = 11, width = 14, height = 14})
select:setLayoutComponentEnabled(true)
select:setName("select")
select:setTag(363)
select:setCascadeColorEnabled(true)
select:setCascadeOpacityEnabled(true)
select:setVisible(false)
select:setAnchorPoint(0.0000, 0.0000)
select:setPosition(0.0000, 2.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(select)
layout:setPositionPercentY(0.0172)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(1.0000)
layout:setSize({width = 242.0000, height = 116.0000})
layout:setTopMargin(-2.0000)
layout:setBottomMargin(2.0000)
btn_tab_1:addChild(select)

--Create Animation
result['animation'] = ccs.ActionTimeline:create()
  
result['animation']:setDuration(6)
result['animation']:setTimeSpeed(0.1333)

--Create FileDataTimeline
local FileDataTimeline = ccs.Timeline:create()

localFrame = ccs.TextureFrame:create()
localFrame:setFrameIndex(0)
localFrame:setTween(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/hot.plist")
localFrame:setTextureName("hall/room/hotanimate/hot_1.png")
FileDataTimeline:addFrame(localFrame)

localFrame = ccs.TextureFrame:create()
localFrame:setFrameIndex(1)
localFrame:setTween(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/hot.plist")
localFrame:setTextureName("hall/room/hotanimate/hot_2.png")
FileDataTimeline:addFrame(localFrame)

localFrame = ccs.TextureFrame:create()
localFrame:setFrameIndex(2)
localFrame:setTween(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/hot.plist")
localFrame:setTextureName("hall/room/hotanimate/hot_3.png")
FileDataTimeline:addFrame(localFrame)

localFrame = ccs.TextureFrame:create()
localFrame:setFrameIndex(3)
localFrame:setTween(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/hot.plist")
localFrame:setTextureName("hall/room/hotanimate/hot_4.png")
FileDataTimeline:addFrame(localFrame)

localFrame = ccs.TextureFrame:create()
localFrame:setFrameIndex(4)
localFrame:setTween(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/hot.plist")
localFrame:setTextureName("hall/room/hotanimate/hot_5.png")
FileDataTimeline:addFrame(localFrame)

localFrame = ccs.TextureFrame:create()
localFrame:setFrameIndex(5)
localFrame:setTween(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/hot.plist")
localFrame:setTextureName("hall/room/hotanimate/hot_6.png")
FileDataTimeline:addFrame(localFrame)

result['animation']:addTimeline(FileDataTimeline)
FileDataTimeline:setNode(anima_hot)

--Create VisibleForFrameTimeline
local VisibleForFrameTimeline = ccs.Timeline:create()

localFrame = ccs.VisibleFrame:create()
localFrame:setFrameIndex(0)
localFrame:setTween(false)
localFrame:setVisible(true)
VisibleForFrameTimeline:addFrame(localFrame)

localFrame = ccs.VisibleFrame:create()
localFrame:setFrameIndex(6)
localFrame:setTween(false)
localFrame:setVisible(false)
VisibleForFrameTimeline:addFrame(localFrame)

result['animation']:addTimeline(VisibleForFrameTimeline)
VisibleForFrameTimeline:setNode(anima_hot)
--Create Animation List
local hot_action = {name="hot_action", startIndex=0, endIndex=8}
result['animation']:addAnimationInfo(hot_action)

result['root'] = Layer
return result;
end

return Result

