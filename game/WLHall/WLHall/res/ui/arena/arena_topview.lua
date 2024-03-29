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

--Create panel_arena
local panel_arena = ccui.Layout:create()
panel_arena:ignoreContentAdaptWithSize(false)
panel_arena:setClippingEnabled(false)
panel_arena:setTouchEnabled(true);
panel_arena:setLayoutComponentEnabled(true)
panel_arena:setName("panel_arena")
panel_arena:setTag(99)
panel_arena:setCascadeColorEnabled(true)
panel_arena:setCascadeOpacityEnabled(true)
layout = ccui.LayoutComponent:bindLayoutComponent(panel_arena)
layout:setSize({width = 1096.0000, height = 633.0000})
layout:setRightMargin(-1096.0000)
layout:setTopMargin(-633.0000)
Node:addChild(panel_arena)

--Create img_bg
local img_bg = ccui.ImageView:create()
img_bg:ignoreContentAdaptWithSize(false)
img_bg:loadTexture("hall/arena/bg_zlt.png",0)
img_bg:setLayoutComponentEnabled(true)
img_bg:setName("img_bg")
img_bg:setTag(1283)
img_bg:setCascadeColorEnabled(true)
img_bg:setCascadeOpacityEnabled(true)
img_bg:setAnchorPoint(0.0000, 0.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_bg)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(1.0016)
layout:setSize({width = 1096.0000, height = 634.0000})
layout:setTopMargin(-1.0000)
panel_arena:addChild(img_bg)

--Create img_titie
local img_titie = ccui.ImageView:create()
img_titie:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/arena.plist")
img_titie:loadTexture("hall/arena/img_day_arena.png",1)
img_titie:setLayoutComponentEnabled(true)
img_titie:setName("img_titie")
img_titie:setTag(219)
img_titie:setCascadeColorEnabled(true)
img_titie:setCascadeOpacityEnabled(true)
img_titie:setPosition(536.1752, 589.8024)
layout = ccui.LayoutComponent:bindLayoutComponent(img_titie)
layout:setPositionPercentX(0.4892)
layout:setPositionPercentY(0.9318)
layout:setPercentWidth(0.3075)
layout:setPercentHeight(0.0995)
layout:setSize({width = 337.0000, height = 63.0000})
layout:setLeftMargin(367.6752)
layout:setRightMargin(391.3248)
layout:setTopMargin(11.6976)
layout:setBottomMargin(558.3024)
panel_arena:addChild(img_titie)

--Create img_top
local img_top = ccui.ImageView:create()
img_top:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/arena.plist")
img_top:loadTexture("hall/arena/img_fram.png",1)
img_top:setScale9Enabled(true)
img_top:setCapInsets({x = 20, y = 14, width = 26, height = 17})
img_top:setLayoutComponentEnabled(true)
img_top:setName("img_top")
img_top:setTag(220)
img_top:setCascadeColorEnabled(true)
img_top:setCascadeOpacityEnabled(true)
img_top:setAnchorPoint(0.0000, 0.5000)
img_top:setPosition(16.0000, 483.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_top)
layout:setPositionPercentX(0.0146)
layout:setPositionPercentY(0.7630)
layout:setPercentWidth(0.2372)
layout:setPercentHeight(0.0711)
layout:setSize({width = 260.0000, height = 45.0000})
layout:setLeftMargin(16.0000)
layout:setRightMargin(820.0000)
layout:setTopMargin(127.5000)
layout:setBottomMargin(460.5000)
panel_arena:addChild(img_top)

--Create img_arena_type
local img_arena_type = ccui.ImageView:create()
img_arena_type:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/arena.plist")
img_arena_type:loadTexture("hall/arena/img_day.png",1)
img_arena_type:setLayoutComponentEnabled(true)
img_arena_type:setName("img_arena_type")
img_arena_type:setTag(221)
img_arena_type:setCascadeColorEnabled(true)
img_arena_type:setCascadeOpacityEnabled(true)
img_arena_type:setPosition(29.6678, 22.2475)
layout = ccui.LayoutComponent:bindLayoutComponent(img_arena_type)
layout:setPositionPercentX(0.1141)
layout:setPositionPercentY(0.4944)
layout:setPercentWidth(0.1654)
layout:setPercentHeight(0.7778)
layout:setSize({width = 43.0000, height = 35.0000})
layout:setLeftMargin(8.1678)
layout:setRightMargin(208.8322)
layout:setTopMargin(5.2525)
layout:setBottomMargin(4.7475)
img_top:addChild(img_arena_type)

--Create txt_top
local txt_top = ccui.Text:create()
txt_top:ignoreContentAdaptWithSize(true)
txt_top:setTextAreaSize({width = 0, height = 0})
txt_top:setFontName("")
txt_top:setFontSize(26)
txt_top:setString([[未入榜]])
txt_top:setLayoutComponentEnabled(true)
txt_top:setName("txt_top")
txt_top:setTag(1285)
txt_top:setCascadeColorEnabled(true)
txt_top:setCascadeOpacityEnabled(true)
txt_top:setAnchorPoint(0.0000, 0.5000)
txt_top:setPosition(170.4776, 22.5000)
txt_top:setTextColor({r = 180, g = 72, b = 0})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_top)
layout:setPositionPercentX(0.6557)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.3000)
layout:setPercentHeight(0.5778)
layout:setSize({width = 78.0000, height = 26.0000})
layout:setLeftMargin(170.4776)
layout:setRightMargin(11.5224)
layout:setTopMargin(9.5000)
layout:setBottomMargin(9.5000)
img_top:addChild(txt_top)

--Create txt1
local txt1 = ccui.Text:create()
txt1:ignoreContentAdaptWithSize(true)
txt1:setTextAreaSize({width = 0, height = 0})
txt1:setFontName("")
txt1:setFontSize(26)
txt1:setString([[我的排行:]])
txt1:setLayoutComponentEnabled(true)
txt1:setName("txt1")
txt1:setTag(38)
txt1:setCascadeColorEnabled(true)
txt1:setCascadeOpacityEnabled(true)
txt1:setAnchorPoint(0.0000, 0.5000)
txt1:setPosition(53.2812, 22.5000)
txt1:setTextColor({r = 103, g = 37, b = 1})
layout = ccui.LayoutComponent:bindLayoutComponent(txt1)
layout:setPositionPercentX(0.2049)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.4500)
layout:setPercentHeight(0.5778)
layout:setSize({width = 117.0000, height = 26.0000})
layout:setLeftMargin(53.2812)
layout:setRightMargin(89.7188)
layout:setTopMargin(9.5000)
layout:setBottomMargin(9.5000)
img_top:addChild(txt1)

--Create img_title1
local img_title1 = ccui.ImageView:create()
img_title1:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/arena.plist")
img_title1:loadTexture("hall/arena/img_fram.png",1)
img_title1:setScale9Enabled(true)
img_title1:setCapInsets({x = 20, y = 14, width = 26, height = 17})
img_title1:setLayoutComponentEnabled(true)
img_title1:setName("img_title1")
img_title1:setTag(223)
img_title1:setCascadeColorEnabled(true)
img_title1:setCascadeOpacityEnabled(true)
img_title1:setAnchorPoint(0.0000, 0.5000)
img_title1:setPosition(280.5000, 483.0301)
layout = ccui.LayoutComponent:bindLayoutComponent(img_title1)
layout:setPositionPercentX(0.2559)
layout:setPositionPercentY(0.7631)
layout:setPercentWidth(0.2838)
layout:setPercentHeight(0.0711)
layout:setSize({width = 311.0000, height = 45.0000})
layout:setLeftMargin(280.5000)
layout:setRightMargin(504.5000)
layout:setTopMargin(127.4699)
layout:setBottomMargin(460.5301)
panel_arena:addChild(img_title1)

--Create img_bg
local img_bg = ccui.ImageView:create()
img_bg:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/arena.plist")
img_bg:loadTexture("hall/arena/img_1.png",1)
img_bg:setLayoutComponentEnabled(true)
img_bg:setName("img_bg")
img_bg:setTag(224)
img_bg:setCascadeColorEnabled(true)
img_bg:setCascadeOpacityEnabled(true)
img_bg:setPosition(25.9670, 22.2500)
layout = ccui.LayoutComponent:bindLayoutComponent(img_bg)
layout:setPositionPercentX(0.0835)
layout:setPositionPercentY(0.4944)
layout:setPercentWidth(0.1125)
layout:setPercentHeight(0.7556)
layout:setSize({width = 35.0000, height = 34.0000})
layout:setLeftMargin(8.4670)
layout:setRightMargin(267.5330)
layout:setTopMargin(5.7500)
layout:setBottomMargin(5.2500)
img_title1:addChild(img_bg)

--Create txt_time
local txt_time = ccui.Text:create()
txt_time:ignoreContentAdaptWithSize(true)
txt_time:setTextAreaSize({width = 0, height = 0})
txt_time:setFontSize(26)
txt_time:setString([[本日积分:]])
txt_time:setLayoutComponentEnabled(true)
txt_time:setName("txt_time")
txt_time:setTag(40)
txt_time:setCascadeColorEnabled(true)
txt_time:setCascadeOpacityEnabled(true)
txt_time:setAnchorPoint(0.0000, 0.5000)
txt_time:setPosition(48.3100, 22.5000)
txt_time:setTextColor({r = 103, g = 37, b = 1})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_time)
layout:setPositionPercentX(0.1553)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.3762)
layout:setPercentHeight(0.5778)
layout:setSize({width = 117.0000, height = 26.0000})
layout:setLeftMargin(48.3100)
layout:setRightMargin(145.6900)
layout:setTopMargin(9.5000)
layout:setBottomMargin(9.5000)
img_title1:addChild(txt_time)

--Create txt_score
local txt_score = ccui.Text:create()
txt_score:ignoreContentAdaptWithSize(true)
txt_score:setTextAreaSize({width = 0, height = 0})
txt_score:setFontSize(26)
txt_score:setString([[0]])
txt_score:setLayoutComponentEnabled(true)
txt_score:setName("txt_score")
txt_score:setTag(1286)
txt_score:setCascadeColorEnabled(true)
txt_score:setCascadeOpacityEnabled(true)
txt_score:setPosition(233.0700, 22.5000)
txt_score:setTextColor({r = 180, g = 72, b = 0})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_score)
layout:setPositionPercentX(0.7494)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.0418)
layout:setPercentHeight(0.5778)
layout:setSize({width = 13.0000, height = 26.0000})
layout:setLeftMargin(226.5700)
layout:setRightMargin(71.4300)
layout:setTopMargin(9.5000)
layout:setBottomMargin(9.5000)
img_title1:addChild(txt_score)

--Create lv_top
local lv_top = ccui.ScrollView:create()
lv_top:setDirection(2)
lv_top:setInnerContainerSize({width = 1065, height = 422})
lv_top:ignoreContentAdaptWithSize(false)
lv_top:setClippingEnabled(true)
lv_top:setBackGroundColorOpacity(102)
lv_top:setLayoutComponentEnabled(true)
lv_top:setName("lv_top")
lv_top:setTag(225)
lv_top:setCascadeColorEnabled(true)
lv_top:setCascadeOpacityEnabled(true)
lv_top:setAnchorPoint(0.0000, 1.0000)
lv_top:setPosition(15.8900, 444.2724)
layout = ccui.LayoutComponent:bindLayoutComponent(lv_top)
layout:setPositionPercentX(0.0145)
layout:setPositionPercentY(0.7019)
layout:setPercentWidth(0.9717)
layout:setPercentHeight(0.5529)
layout:setSize({width = 1065.0000, height = 350.0000})
layout:setLeftMargin(15.8900)
layout:setRightMargin(15.1100)
layout:setTopMargin(188.7276)
layout:setBottomMargin(94.2724)
panel_arena:addChild(lv_top)

--Create btn_top
local btn_top = ccui.Layout:create()
btn_top:ignoreContentAdaptWithSize(false)
btn_top:setClippingEnabled(false)
btn_top:setTouchEnabled(true);
btn_top:setLayoutComponentEnabled(true)
btn_top:setName("btn_top")
btn_top:setTag(687)
btn_top:setCascadeColorEnabled(true)
btn_top:setCascadeOpacityEnabled(true)
btn_top:setAnchorPoint(0.5000, 0.5000)
btn_top:setPosition(233.8047, 49.2493)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_top)
layout:setPositionPercentX(0.2133)
layout:setPositionPercentY(0.0778)
layout:setPercentWidth(0.1095)
layout:setPercentHeight(0.0790)
layout:setSize({width = 120.0000, height = 50.0000})
layout:setLeftMargin(173.8047)
layout:setRightMargin(802.1953)
layout:setTopMargin(558.7507)
layout:setBottomMargin(24.2493)
panel_arena:addChild(btn_top)

--Create Image_rule2
local Image_rule2 = ccui.ImageView:create()
Image_rule2:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/arena.plist")
Image_rule2:loadTexture("hall/arena/img_ph.png",1)
Image_rule2:setLayoutComponentEnabled(true)
Image_rule2:setName("Image_rule2")
Image_rule2:setTag(690)
Image_rule2:setCascadeColorEnabled(true)
Image_rule2:setCascadeOpacityEnabled(true)
Image_rule2:setPosition(60.0000, 16.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(Image_rule2)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.3200)
layout:setPercentWidth(0.9750)
layout:setPercentHeight(0.9800)
layout:setSize({width = 117.0000, height = 49.0000})
layout:setLeftMargin(1.5000)
layout:setRightMargin(1.5000)
layout:setTopMargin(9.5000)
layout:setBottomMargin(-8.5000)
btn_top:addChild(Image_rule2)

--Create btn_rule
local btn_rule = ccui.Layout:create()
btn_rule:ignoreContentAdaptWithSize(false)
btn_rule:setClippingEnabled(false)
btn_rule:setTouchEnabled(true);
btn_rule:setLayoutComponentEnabled(true)
btn_rule:setName("btn_rule")
btn_rule:setTag(683)
btn_rule:setCascadeColorEnabled(true)
btn_rule:setCascadeOpacityEnabled(true)
btn_rule:setAnchorPoint(0.5000, 0.5000)
btn_rule:setPosition(71.9389, 47.3731)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_rule)
layout:setPositionPercentX(0.0656)
layout:setPositionPercentY(0.0748)
layout:setPercentWidth(0.1004)
layout:setPercentHeight(0.0821)
layout:setSize({width = 110.0000, height = 52.0000})
layout:setLeftMargin(16.9389)
layout:setRightMargin(969.0611)
layout:setTopMargin(559.6269)
layout:setBottomMargin(21.3731)
panel_arena:addChild(btn_rule)

--Create Image_rule2
local Image_rule2 = ccui.ImageView:create()
Image_rule2:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/arena.plist")
Image_rule2:loadTexture("hall/arena/img_js.png",1)
Image_rule2:setLayoutComponentEnabled(true)
Image_rule2:setName("Image_rule2")
Image_rule2:setTag(685)
Image_rule2:setCascadeColorEnabled(true)
Image_rule2:setCascadeOpacityEnabled(true)
Image_rule2:setPosition(55.0000, 17.8204)
layout = ccui.LayoutComponent:bindLayoutComponent(Image_rule2)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.3427)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(1.0000)
layout:setSize({width = 110.0000, height = 52.0000})
layout:setTopMargin(8.1796)
layout:setBottomMargin(-8.1796)
btn_rule:addChild(Image_rule2)

--Create btn_close
local btn_close = ccui.Layout:create()
btn_close:ignoreContentAdaptWithSize(false)
btn_close:setClippingEnabled(false)
btn_close:setTouchEnabled(true);
btn_close:setLayoutComponentEnabled(true)
btn_close:setName("btn_close")
btn_close:setTag(56)
btn_close:setCascadeColorEnabled(true)
btn_close:setCascadeOpacityEnabled(true)
btn_close:setAnchorPoint(0.5000, 0.5000)
btn_close:setPosition(1068.0000, 600.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_close)
layout:setPositionPercentX(0.9745)
layout:setPositionPercentY(0.9479)
layout:setPercentWidth(0.0456)
layout:setPercentHeight(0.0790)
layout:setSize({width = 50.0000, height = 50.0000})
layout:setLeftMargin(1043.0000)
layout:setRightMargin(3.0000)
layout:setTopMargin(8.0000)
layout:setBottomMargin(575.0000)
panel_arena:addChild(btn_close)

--Create btn_bg
local btn_bg = ccui.ImageView:create()
btn_bg:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
btn_bg:loadTexture("hall/common/new_btn_close.png",1)
btn_bg:setLayoutComponentEnabled(true)
btn_bg:setName("btn_bg")
btn_bg:setTag(57)
btn_bg:setCascadeColorEnabled(true)
btn_bg:setCascadeOpacityEnabled(true)
btn_bg:setPosition(25.0000, 28.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_bg)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5600)
layout:setPercentWidth(0.4800)
layout:setPercentHeight(0.5000)
layout:setSize({width = 24.0000, height = 25.0000})
layout:setLeftMargin(13.0000)
layout:setRightMargin(13.0000)
layout:setTopMargin(9.5000)
layout:setBottomMargin(15.5000)
btn_close:addChild(btn_bg)

--Create txt_honor
local txt_honor = ccui.Text:create()
txt_honor:ignoreContentAdaptWithSize(true)
txt_honor:setTextAreaSize({width = 0, height = 0})
txt_honor:setFontName("")
txt_honor:setFontSize(26)
txt_honor:setString([[本周获得的荣誉分进行排行，前500名获奖]])
txt_honor:setLayoutComponentEnabled(true)
txt_honor:setName("txt_honor")
txt_honor:setTag(1290)
txt_honor:setCascadeColorEnabled(true)
txt_honor:setCascadeOpacityEnabled(true)
txt_honor:setPosition(600.7939, 34.1934)
txt_honor:setTextColor({r = 255, g = 223, b = 178})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_honor)
layout:setPositionPercentX(0.5482)
layout:setPositionPercentY(0.0540)
layout:setPercentWidth(0.4389)
layout:setPercentHeight(0.0411)
layout:setSize({width = 481.0000, height = 26.0000})
layout:setLeftMargin(360.2939)
layout:setRightMargin(254.7061)
layout:setTopMargin(585.8066)
layout:setBottomMargin(21.1934)
panel_arena:addChild(txt_honor)

--Create Panel_7
local Panel_7 = ccui.Layout:create()
Panel_7:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/arena.plist")
Panel_7:setBackGroundImage("hall/arena/img_di.png",1)
Panel_7:setClippingEnabled(false)
Panel_7:setBackGroundImageCapInsets({x = 16, y = 0, width = 18, height = 48})
Panel_7:setBackGroundColorOpacity(102)
Panel_7:setBackGroundImageScale9Enabled(true)
Panel_7:setTouchEnabled(true);
Panel_7:setLayoutComponentEnabled(true)
Panel_7:setName("Panel_7")
Panel_7:setTag(401)
Panel_7:setCascadeColorEnabled(true)
Panel_7:setCascadeOpacityEnabled(true)
Panel_7:setAnchorPoint(0.0000, 0.5000)
Panel_7:setPosition(594.5100, 482.2300)
layout = ccui.LayoutComponent:bindLayoutComponent(Panel_7)
layout:setPositionPercentX(0.5424)
layout:setPositionPercentY(0.7618)
layout:setPercentWidth(0.4453)
layout:setPercentHeight(0.0758)
layout:setSize({width = 488.0000, height = 48.0000})
layout:setLeftMargin(594.5100)
layout:setRightMargin(13.4900)
layout:setTopMargin(126.7700)
layout:setBottomMargin(458.2300)
panel_arena:addChild(Panel_7)

--Create txt_2
local txt_2 = ccui.Text:create()
txt_2:ignoreContentAdaptWithSize(true)
txt_2:setTextAreaSize({width = 0, height = 0})
txt_2:setFontSize(23)
txt_2:setString([[参与游戏即可获得,房间级别越高获得越多!]])
txt_2:setLayoutComponentEnabled(true)
txt_2:setName("txt_2")
txt_2:setTag(149)
txt_2:setCascadeColorEnabled(true)
txt_2:setCascadeOpacityEnabled(true)
txt_2:setPosition(244.4127, 24.0000)
txt_2:setTextColor({r = 253, g = 241, b = 175})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_2)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5008)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.8975)
layout:setPercentHeight(0.4792)
layout:setSize({width = 438.0000, height = 23.0000})
layout:setLeftMargin(25.4127)
layout:setRightMargin(24.5873)
layout:setTopMargin(12.5000)
layout:setBottomMargin(12.5000)
Panel_7:addChild(txt_2)

--Create Animation
result['animation'] = ccs.ActionTimeline:create()
  
result['animation']:setDuration(0)
result['animation']:setTimeSpeed(1.0000)
--Create Animation List

result['root'] = Node
return result;
end

return Result

