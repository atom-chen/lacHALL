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

--Create img_tm_h_bg
local img_tm_h_bg = ccui.Layout:create()
img_tm_h_bg:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
img_tm_h_bg:setBackGroundImage("hall/common/new_pop_bg_2.png",1)
img_tm_h_bg:setClippingEnabled(false)
img_tm_h_bg:setBackGroundImageCapInsets({x = 10, y = 71, width = 4, height = 2})
img_tm_h_bg:setBackGroundColorOpacity(102)
img_tm_h_bg:setBackGroundImageScale9Enabled(true)
img_tm_h_bg:setTouchEnabled(true);
img_tm_h_bg:setLayoutComponentEnabled(true)
img_tm_h_bg:setName("img_tm_h_bg")
img_tm_h_bg:setTag(346)
img_tm_h_bg:setCascadeColorEnabled(true)
img_tm_h_bg:setCascadeOpacityEnabled(true)
img_tm_h_bg:setAnchorPoint(0.5000, 0.5000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_tm_h_bg)
layout:setSize({width = 664.0000, height = 381.0000})
layout:setLeftMargin(-332.0000)
layout:setRightMargin(-332.0000)
layout:setTopMargin(-190.5000)
layout:setBottomMargin(-190.5000)
Node:addChild(img_tm_h_bg)

--Create Node_content
local Node_content=cc.Node:create()
Node_content:setName("Node_content")
Node_content:setTag(130)
Node_content:setCascadeColorEnabled(true)
Node_content:setCascadeOpacityEnabled(true)
Node_content:setPosition(21.0000, 303.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(Node_content)
layout:setPositionPercentX(0.0316)
layout:setPositionPercentY(0.7953)
layout:setLeftMargin(21.0000)
layout:setRightMargin(643.0000)
layout:setTopMargin(78.0000)
layout:setBottomMargin(303.0000)
img_tm_h_bg:addChild(Node_content)

--Create img_props_t
local img_props_t = ccui.ImageView:create()
img_props_t:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/store.plist")
img_props_t:loadTexture("hall/store/Bottomframe_3.png",1)
img_props_t:setScale9Enabled(true)
img_props_t:setCapInsets({x = 8, y = 8, width = 10, height = 10})
img_props_t:setLayoutComponentEnabled(true)
img_props_t:setName("img_props_t")
img_props_t:setTag(175)
img_props_t:setCascadeColorEnabled(true)
img_props_t:setCascadeOpacityEnabled(true)
img_props_t:setPosition(462.0000, 188.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_props_t)
layout:setPositionPercentX(0.6958)
layout:setPositionPercentY(0.4934)
layout:setPercentWidth(0.1596)
layout:setPercentHeight(0.2782)
layout:setSize({width = 106.0000, height = 106.0000})
layout:setLeftMargin(409.0000)
layout:setRightMargin(149.0000)
layout:setTopMargin(140.0000)
layout:setBottomMargin(135.0000)
img_tm_h_bg:addChild(img_props_t)

--Create img_prop
local img_prop = ccui.ImageView:create()
img_prop:ignoreContentAdaptWithSize(false)
img_prop:loadTexture("common/prop/jindou_1.png",0)
img_prop:setLayoutComponentEnabled(true)
img_prop:setName("img_prop")
img_prop:setTag(176)
img_prop:setCascadeColorEnabled(true)
img_prop:setCascadeOpacityEnabled(true)
img_prop:setPosition(52.0000, 52.0000)
img_prop:setScaleX(0.7500)
img_prop:setScaleY(0.7500)
layout = ccui.LayoutComponent:bindLayoutComponent(img_prop)
layout:setPositionPercentX(0.4906)
layout:setPositionPercentY(0.4906)
layout:setPercentWidth(1.0566)
layout:setPercentHeight(1.0566)
layout:setSize({width = 112.0000, height = 112.0000})
layout:setLeftMargin(-4.0000)
layout:setRightMargin(-2.0000)
layout:setTopMargin(-2.0000)
layout:setBottomMargin(-4.0000)
img_props_t:addChild(img_prop)

--Create txt_count
local txt_count = ccui.Text:create()
txt_count:ignoreContentAdaptWithSize(true)
txt_count:setTextAreaSize({width = 0, height = 0})
txt_count:setFontName("")
txt_count:setFontSize(23)
txt_count:setString([[10万豆]])
txt_count:setLayoutComponentEnabled(true)
txt_count:setName("txt_count")
txt_count:setTag(177)
txt_count:setCascadeColorEnabled(true)
txt_count:setCascadeOpacityEnabled(true)
txt_count:setAnchorPoint(1.0000, 0.5000)
txt_count:setPosition(94.0000, 12.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(txt_count)
layout:setPositionPercentX(0.8868)
layout:setPositionPercentY(0.1132)
layout:setPercentWidth(0.6604)
layout:setPercentHeight(0.2170)
layout:setSize({width = 70.0000, height = 23.0000})
layout:setLeftMargin(24.0000)
layout:setRightMargin(12.0000)
layout:setTopMargin(82.5000)
layout:setBottomMargin(0.5000)
img_props_t:addChild(txt_count)

--Create img_props_f
local img_props_f = ccui.ImageView:create()
img_props_f:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/store.plist")
img_props_f:loadTexture("hall/store/Bottomframe_3.png",1)
img_props_f:setScale9Enabled(true)
img_props_f:setCapInsets({x = 8, y = 8, width = 10, height = 10})
img_props_f:setLayoutComponentEnabled(true)
img_props_f:setName("img_props_f")
img_props_f:setTag(178)
img_props_f:setCascadeColorEnabled(true)
img_props_f:setCascadeOpacityEnabled(true)
img_props_f:setPosition(200.0000, 188.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_props_f)
layout:setPositionPercentX(0.3012)
layout:setPositionPercentY(0.4934)
layout:setPercentWidth(0.1596)
layout:setPercentHeight(0.2782)
layout:setSize({width = 106.0000, height = 106.0000})
layout:setLeftMargin(147.0000)
layout:setRightMargin(411.0000)
layout:setTopMargin(140.0000)
layout:setBottomMargin(135.0000)
img_tm_h_bg:addChild(img_props_f)

--Create img_prop
local img_prop = ccui.ImageView:create()
img_prop:ignoreContentAdaptWithSize(false)
img_prop:loadTexture("common/prop/jindou_1.png",0)
img_prop:setLayoutComponentEnabled(true)
img_prop:setName("img_prop")
img_prop:setTag(179)
img_prop:setCascadeColorEnabled(true)
img_prop:setCascadeOpacityEnabled(true)
img_prop:setPosition(52.0000, 52.0000)
img_prop:setScaleX(0.7500)
img_prop:setScaleY(0.7500)
layout = ccui.LayoutComponent:bindLayoutComponent(img_prop)
layout:setPositionPercentX(0.4906)
layout:setPositionPercentY(0.4906)
layout:setPercentWidth(1.0566)
layout:setPercentHeight(1.0566)
layout:setSize({width = 112.0000, height = 112.0000})
layout:setLeftMargin(-4.0000)
layout:setRightMargin(-2.0000)
layout:setTopMargin(-2.0000)
layout:setBottomMargin(-4.0000)
img_props_f:addChild(img_prop)

--Create txt_count
local txt_count = ccui.Text:create()
txt_count:ignoreContentAdaptWithSize(true)
txt_count:setTextAreaSize({width = 0, height = 0})
txt_count:setFontName("")
txt_count:setFontSize(23)
txt_count:setString([[20万豆]])
txt_count:setLayoutComponentEnabled(true)
txt_count:setName("txt_count")
txt_count:setTag(180)
txt_count:setCascadeColorEnabled(true)
txt_count:setCascadeOpacityEnabled(true)
txt_count:setAnchorPoint(1.0000, 0.4968)
txt_count:setPosition(93.9960, 12.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(txt_count)
layout:setPositionPercentX(0.8868)
layout:setPositionPercentY(0.1132)
layout:setPercentWidth(0.6604)
layout:setPercentHeight(0.2170)
layout:setSize({width = 70.0000, height = 23.0000})
layout:setLeftMargin(23.9960)
layout:setRightMargin(12.0040)
layout:setTopMargin(82.4264)
layout:setBottomMargin(0.5736)
img_props_f:addChild(txt_count)

--Create Image_jiantou
local Image_jiantou = ccui.ImageView:create()
Image_jiantou:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/store.plist")
Image_jiantou:loadTexture("hall/store/Pop-ups_jiantou.png",1)
Image_jiantou:setLayoutComponentEnabled(true)
Image_jiantou:setName("Image_jiantou")
Image_jiantou:setTag(182)
Image_jiantou:setCascadeColorEnabled(true)
Image_jiantou:setCascadeOpacityEnabled(true)
Image_jiantou:setPosition(332.0000, 188.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(Image_jiantou)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.4934)
layout:setPercentWidth(0.1175)
layout:setPercentHeight(0.1470)
layout:setSize({width = 78.0000, height = 56.0000})
layout:setLeftMargin(293.0000)
layout:setRightMargin(293.0000)
layout:setTopMargin(165.0000)
layout:setBottomMargin(160.0000)
img_tm_h_bg:addChild(Image_jiantou)

--Create txt_title
local txt_title = ccui.Text:create()
txt_title:ignoreContentAdaptWithSize(true)
txt_title:setTextAreaSize({width = 0, height = 0})
txt_title:setFontSize(28)
txt_title:setString([[兑换]])
txt_title:setLayoutComponentEnabled(true)
txt_title:setName("txt_title")
txt_title:setTag(125)
txt_title:setCascadeColorEnabled(true)
txt_title:setCascadeOpacityEnabled(true)
txt_title:setAnchorPoint(0.0000, 0.5000)
txt_title:setPosition(30.0000, 350.5200)
layout = ccui.LayoutComponent:bindLayoutComponent(txt_title)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.0452)
layout:setPositionPercentY(0.9200)
layout:setPercentWidth(0.0843)
layout:setPercentHeight(0.0735)
layout:setSize({width = 56.0000, height = 28.0000})
layout:setLeftMargin(30.0000)
layout:setRightMargin(578.0000)
layout:setTopMargin(16.4800)
layout:setBottomMargin(336.5200)
img_tm_h_bg:addChild(txt_title)

--Create btn_close
local btn_close = ccui.Layout:create()
btn_close:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
btn_close:setBackGroundImage("hall/common/new_btn_close.png",1)
btn_close:setClippingEnabled(false)
btn_close:setBackGroundColorOpacity(102)
btn_close:setTouchEnabled(true);
btn_close:setLayoutComponentEnabled(true)
btn_close:setName("btn_close")
btn_close:setTag(142)
btn_close:setCascadeColorEnabled(true)
btn_close:setCascadeOpacityEnabled(true)
btn_close:setAnchorPoint(0.5000, 0.5000)
btn_close:setPosition(298.9900, 158.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_close)
layout:setSize({width = 60.0000, height = 60.0000})
layout:setLeftMargin(268.9900)
layout:setRightMargin(-328.9900)
layout:setTopMargin(-188.0000)
layout:setBottomMargin(128.0000)
Node:addChild(btn_close)

--Create btn_cancel
local btn_cancel = ccui.Layout:create()
btn_cancel:ignoreContentAdaptWithSize(false)
btn_cancel:setClippingEnabled(false)
btn_cancel:setBackGroundImageCapInsets({x = -3, y = -3, width = 6, height = 6})
btn_cancel:setBackGroundImageScale9Enabled(true)
btn_cancel:setTouchEnabled(true);
btn_cancel:setLayoutComponentEnabled(true)
btn_cancel:setName("btn_cancel")
btn_cancel:setTag(347)
btn_cancel:setCascadeColorEnabled(true)
btn_cancel:setCascadeOpacityEnabled(true)
btn_cancel:setAnchorPoint(0.5000, 0.5000)
btn_cancel:setPosition(-6.0000, -142.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_cancel)
layout:setSize({width = 180.0000, height = 60.0000})
layout:setLeftMargin(-96.0000)
layout:setRightMargin(-84.0000)
layout:setTopMargin(112.0000)
layout:setBottomMargin(-172.0000)
Node:addChild(btn_cancel)

--Create btn_cancel_bg
local btn_cancel_bg = ccui.Layout:create()
btn_cancel_bg:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
btn_cancel_bg:setBackGroundImage("hall/common/new_btn_noangle.png",1)
btn_cancel_bg:setClippingEnabled(false)
btn_cancel_bg:setBackGroundImageCapInsets({x = 8, y = 8, width = 2, height = 2})
btn_cancel_bg:setBackGroundImageScale9Enabled(true)
btn_cancel_bg:setLayoutComponentEnabled(true)
btn_cancel_bg:setName("btn_cancel_bg")
btn_cancel_bg:setTag(338)
btn_cancel_bg:setCascadeColorEnabled(true)
btn_cancel_bg:setCascadeOpacityEnabled(true)
btn_cancel_bg:setAnchorPoint(0.5000, 0.5000)
btn_cancel_bg:setPosition(90.0000, 30.0000)
btn_cancel_bg:setColor({r = 16, g = 116, b = 233})
layout = ccui.LayoutComponent:bindLayoutComponent(btn_cancel_bg)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(1.0000)
layout:setSize({width = 180.0000, height = 60.0000})
btn_cancel:addChild(btn_cancel_bg)

--Create txt_canel
local txt_canel = ccui.Text:create()
txt_canel:ignoreContentAdaptWithSize(true)
txt_canel:setTextAreaSize({width = 0, height = 0})
txt_canel:setFontSize(28)
txt_canel:setString([[取消]])
txt_canel:setLayoutComponentEnabled(true)
txt_canel:setName("txt_canel")
txt_canel:setTag(348)
txt_canel:setCascadeColorEnabled(true)
txt_canel:setCascadeOpacityEnabled(true)
txt_canel:setPosition(90.0000, 30.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(txt_canel)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.3111)
layout:setPercentHeight(0.4667)
layout:setSize({width = 56.0000, height = 28.0000})
layout:setLeftMargin(62.0000)
layout:setRightMargin(62.0000)
layout:setTopMargin(16.0000)
layout:setBottomMargin(16.0000)
btn_cancel:addChild(txt_canel)

--Create btn_exchange
local btn_exchange = ccui.Layout:create()
btn_exchange:ignoreContentAdaptWithSize(false)
btn_exchange:setClippingEnabled(false)
btn_exchange:setBackGroundImageCapInsets({x = -3, y = -3, width = 6, height = 6})
btn_exchange:setBackGroundImageScale9Enabled(true)
btn_exchange:setTouchEnabled(true);
btn_exchange:setLayoutComponentEnabled(true)
btn_exchange:setName("btn_exchange")
btn_exchange:setTag(349)
btn_exchange:setCascadeColorEnabled(true)
btn_exchange:setCascadeOpacityEnabled(true)
btn_exchange:setAnchorPoint(0.5000, 0.5000)
btn_exchange:setPosition(216.0000, -142.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_exchange)
layout:setSize({width = 180.0000, height = 60.0000})
layout:setLeftMargin(126.0000)
layout:setRightMargin(-306.0000)
layout:setTopMargin(112.0000)
layout:setBottomMargin(-172.0000)
Node:addChild(btn_exchange)

--Create btn_exchange_bg
local btn_exchange_bg = ccui.Layout:create()
btn_exchange_bg:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
btn_exchange_bg:setBackGroundImage("hall/common/new_btn_noangle.png",1)
btn_exchange_bg:setClippingEnabled(false)
btn_exchange_bg:setBackGroundImageCapInsets({x = 8, y = 8, width = 2, height = 2})
btn_exchange_bg:setBackGroundColorOpacity(102)
btn_exchange_bg:setBackGroundImageScale9Enabled(true)
btn_exchange_bg:setLayoutComponentEnabled(true)
btn_exchange_bg:setName("btn_exchange_bg")
btn_exchange_bg:setTag(339)
btn_exchange_bg:setCascadeColorEnabled(true)
btn_exchange_bg:setCascadeOpacityEnabled(true)
btn_exchange_bg:setAnchorPoint(0.5000, 0.5000)
btn_exchange_bg:setPosition(90.0000, 30.0000)
btn_exchange_bg:setColor({r = 38, g = 155, b = 88})
layout = ccui.LayoutComponent:bindLayoutComponent(btn_exchange_bg)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(1.0000)
layout:setSize({width = 180.0000, height = 60.0000})
btn_exchange:addChild(btn_exchange_bg)

--Create txt_duihuan
local txt_duihuan = ccui.Text:create()
txt_duihuan:ignoreContentAdaptWithSize(true)
txt_duihuan:setTextAreaSize({width = 0, height = 0})
txt_duihuan:setFontSize(28)
txt_duihuan:setString([[兑换]])
txt_duihuan:setLayoutComponentEnabled(true)
txt_duihuan:setName("txt_duihuan")
txt_duihuan:setTag(350)
txt_duihuan:setCascadeColorEnabled(true)
txt_duihuan:setCascadeOpacityEnabled(true)
txt_duihuan:setPosition(90.0000, 30.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(txt_duihuan)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.3111)
layout:setPercentHeight(0.4667)
layout:setSize({width = 56.0000, height = 28.0000})
layout:setLeftMargin(62.0000)
layout:setRightMargin(62.0000)
layout:setTopMargin(16.0000)
layout:setBottomMargin(16.0000)
btn_exchange:addChild(txt_duihuan)

--Create Panel_link
local Panel_link = ccui.Layout:create()
Panel_link:ignoreContentAdaptWithSize(false)
Panel_link:setClippingEnabled(false)
Panel_link:setBackGroundColorType(1)
Panel_link:setBackGroundColor({r = 26, g = 26, b = 26})
Panel_link:setTouchEnabled(true);
Panel_link:setLayoutComponentEnabled(true)
Panel_link:setName("Panel_link")
Panel_link:setTag(337)
Panel_link:setCascadeColorEnabled(true)
Panel_link:setCascadeOpacityEnabled(true)
Panel_link:setPosition(-326.0900, -91.3900)
layout = ccui.LayoutComponent:bindLayoutComponent(Panel_link)
layout:setSize({width = 655.0000, height = 1.0000})
layout:setLeftMargin(-326.0900)
layout:setRightMargin(-328.9100)
layout:setTopMargin(90.3900)
layout:setBottomMargin(-91.3900)
Node:addChild(Panel_link)

--Create Animation
result['animation'] = ccs.ActionTimeline:create()
  
result['animation']:setDuration(0)
result['animation']:setTimeSpeed(1.0000)
--Create Animation List

result['root'] = Node
return result;
end

return Result

