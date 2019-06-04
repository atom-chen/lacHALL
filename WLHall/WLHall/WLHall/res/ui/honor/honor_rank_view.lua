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

--Create btn_1
local btn_1 = ccui.Layout:create()
btn_1:ignoreContentAdaptWithSize(false)
btn_1:setClippingEnabled(false)
btn_1:setBackGroundColorOpacity(102)
btn_1:setTouchEnabled(true);
btn_1:setLayoutComponentEnabled(true)
btn_1:setName("btn_1")
btn_1:setTag(1095)
btn_1:setCascadeColorEnabled(true)
btn_1:setCascadeOpacityEnabled(true)
btn_1:setAnchorPoint(0.5000, 0.0000)
btn_1:setPosition(57.5000, 574.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_1)
layout:setSize({width = 115.0000, height = 60.0000})
layout:setRightMargin(-115.0000)
layout:setTopMargin(-634.0000)
layout:setBottomMargin(574.0000)
Node:addChild(btn_1)

--Create img_sel
local img_sel = ccui.Layout:create()
img_sel:ignoreContentAdaptWithSize(false)
img_sel:setClippingEnabled(false)
img_sel:setBackGroundColorType(1)
img_sel:setBackGroundColor({r = 255, g = 255, b = 255})
img_sel:setTouchEnabled(true);
img_sel:setLayoutComponentEnabled(true)
img_sel:setName("img_sel")
img_sel:setTag(989)
img_sel:setCascadeColorEnabled(true)
img_sel:setCascadeOpacityEnabled(true)
img_sel:setPosition(0.0000, -1.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_sel)
layout:setPositionPercentY(-0.0167)
layout:setPercentWidthEnabled(true)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(1.0167)
layout:setSize({width = 115.0000, height = 61.0000})
layout:setBottomMargin(-1.0000)
btn_1:addChild(img_sel)

--Create txt_name
local txt_name = ccui.Text:create()
txt_name:ignoreContentAdaptWithSize(true)
txt_name:setTextAreaSize({width = 0, height = 0})
txt_name:setFontName("")
txt_name:setFontSize(28)
txt_name:setString([[省]])
txt_name:setLayoutComponentEnabled(true)
txt_name:setName("txt_name")
txt_name:setTag(55)
txt_name:setCascadeColorEnabled(true)
txt_name:setCascadeOpacityEnabled(true)
txt_name:setPosition(57.5000, 30.0000)
txt_name:setTextColor({r = 49, g = 94, b = 167})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_name)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.2435)
layout:setPercentHeight(0.4667)
layout:setSize({width = 28.0000, height = 28.0000})
layout:setLeftMargin(43.5000)
layout:setRightMargin(43.5000)
layout:setTopMargin(16.0000)
layout:setBottomMargin(16.0000)
btn_1:addChild(txt_name)

--Create btn_2
local btn_2 = ccui.Layout:create()
btn_2:ignoreContentAdaptWithSize(false)
btn_2:setClippingEnabled(false)
btn_2:setBackGroundColorOpacity(102)
btn_2:setTouchEnabled(true);
btn_2:setLayoutComponentEnabled(true)
btn_2:setName("btn_2")
btn_2:setTag(1160)
btn_2:setCascadeColorEnabled(true)
btn_2:setCascadeOpacityEnabled(true)
btn_2:setAnchorPoint(0.5000, 0.0000)
btn_2:setPosition(172.5000, 574.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_2)
layout:setSize({width = 115.0000, height = 60.0000})
layout:setLeftMargin(115.0000)
layout:setRightMargin(-230.0000)
layout:setTopMargin(-634.0000)
layout:setBottomMargin(574.0000)
Node:addChild(btn_2)

--Create img_sel
local img_sel = ccui.Layout:create()
img_sel:ignoreContentAdaptWithSize(false)
img_sel:setClippingEnabled(false)
img_sel:setBackGroundColorType(1)
img_sel:setBackGroundColor({r = 255, g = 255, b = 255})
img_sel:setTouchEnabled(true);
img_sel:setLayoutComponentEnabled(true)
img_sel:setName("img_sel")
img_sel:setTag(991)
img_sel:setCascadeColorEnabled(true)
img_sel:setCascadeOpacityEnabled(true)
img_sel:setVisible(false)
img_sel:setPosition(0.0000, -1.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_sel)
layout:setPositionPercentY(-0.0167)
layout:setPercentWidthEnabled(true)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(1.0167)
layout:setSize({width = 115.0000, height = 61.0000})
layout:setBottomMargin(-1.0000)
btn_2:addChild(img_sel)

--Create txt_name
local txt_name = ccui.Text:create()
txt_name:ignoreContentAdaptWithSize(true)
txt_name:setTextAreaSize({width = 0, height = 0})
txt_name:setFontName("")
txt_name:setFontSize(28)
txt_name:setString([[市]])
txt_name:setLayoutComponentEnabled(true)
txt_name:setName("txt_name")
txt_name:setTag(1162)
txt_name:setCascadeColorEnabled(true)
txt_name:setCascadeOpacityEnabled(true)
txt_name:setPosition(57.5000, 30.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(txt_name)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.2435)
layout:setPercentHeight(0.4667)
layout:setSize({width = 28.0000, height = 28.0000})
layout:setLeftMargin(43.5000)
layout:setRightMargin(43.5000)
layout:setTopMargin(16.0000)
layout:setBottomMargin(16.0000)
btn_2:addChild(txt_name)

--Create btn_3
local btn_3 = ccui.Layout:create()
btn_3:ignoreContentAdaptWithSize(false)
btn_3:setClippingEnabled(false)
btn_3:setBackGroundColorOpacity(102)
btn_3:setTouchEnabled(true);
btn_3:setLayoutComponentEnabled(true)
btn_3:setName("btn_3")
btn_3:setTag(1157)
btn_3:setCascadeColorEnabled(true)
btn_3:setCascadeOpacityEnabled(true)
btn_3:setAnchorPoint(0.5000, 0.0000)
btn_3:setPosition(287.5000, 574.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_3)
layout:setSize({width = 115.0000, height = 60.0000})
layout:setLeftMargin(230.0000)
layout:setRightMargin(-345.0000)
layout:setTopMargin(-634.0000)
layout:setBottomMargin(574.0000)
Node:addChild(btn_3)

--Create img_sel
local img_sel = ccui.Layout:create()
img_sel:ignoreContentAdaptWithSize(false)
img_sel:setClippingEnabled(false)
img_sel:setBackGroundColorType(1)
img_sel:setBackGroundColor({r = 255, g = 255, b = 255})
img_sel:setTouchEnabled(true);
img_sel:setLayoutComponentEnabled(true)
img_sel:setName("img_sel")
img_sel:setTag(990)
img_sel:setCascadeColorEnabled(true)
img_sel:setCascadeOpacityEnabled(true)
img_sel:setVisible(false)
img_sel:setPosition(0.0000, -1.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_sel)
layout:setPositionPercentY(-0.0167)
layout:setPercentWidthEnabled(true)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(1.0167)
layout:setSize({width = 115.0000, height = 61.0000})
layout:setBottomMargin(-1.0000)
btn_3:addChild(img_sel)

--Create txt_name
local txt_name = ccui.Text:create()
txt_name:ignoreContentAdaptWithSize(true)
txt_name:setTextAreaSize({width = 0, height = 0})
txt_name:setFontName("")
txt_name:setFontSize(28)
txt_name:setString([[区]])
txt_name:setLayoutComponentEnabled(true)
txt_name:setName("txt_name")
txt_name:setTag(1159)
txt_name:setCascadeColorEnabled(true)
txt_name:setCascadeOpacityEnabled(true)
txt_name:setPosition(57.5000, 30.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(txt_name)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.2435)
layout:setPercentHeight(0.4667)
layout:setSize({width = 28.0000, height = 28.0000})
layout:setLeftMargin(43.5000)
layout:setRightMargin(43.5000)
layout:setTopMargin(16.0000)
layout:setBottomMargin(16.0000)
btn_3:addChild(txt_name)

--Create lv_rank_1
local lv_rank_1 = ccui.ListView:create()
lv_rank_1:setDirection(1)
lv_rank_1:setGravity(0)
lv_rank_1:ignoreContentAdaptWithSize(false)
lv_rank_1:setClippingEnabled(true)
lv_rank_1:setBackGroundColorOpacity(102)
lv_rank_1:setLayoutComponentEnabled(true)
lv_rank_1:setName("lv_rank_1")
lv_rank_1:setTag(51)
lv_rank_1:setCascadeColorEnabled(true)
lv_rank_1:setCascadeOpacityEnabled(true)
lv_rank_1:setAnchorPoint(0.0000, 1.0000)
lv_rank_1:setPosition(0.0000, 574.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(lv_rank_1)
layout:setSize({width = 1028.0000, height = 574.0000})
layout:setRightMargin(-1028.0000)
layout:setTopMargin(-574.0000)
Node:addChild(lv_rank_1)

--Create lv_rank_2
local lv_rank_2 = ccui.ListView:create()
lv_rank_2:setDirection(1)
lv_rank_2:setGravity(0)
lv_rank_2:ignoreContentAdaptWithSize(false)
lv_rank_2:setClippingEnabled(true)
lv_rank_2:setBackGroundColorOpacity(102)
lv_rank_2:setLayoutComponentEnabled(true)
lv_rank_2:setName("lv_rank_2")
lv_rank_2:setTag(52)
lv_rank_2:setCascadeColorEnabled(true)
lv_rank_2:setCascadeOpacityEnabled(true)
lv_rank_2:setVisible(false)
lv_rank_2:setAnchorPoint(0.0000, 1.0000)
lv_rank_2:setPosition(0.0000, 574.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(lv_rank_2)
layout:setSize({width = 1028.0000, height = 574.0000})
layout:setRightMargin(-1028.0000)
layout:setTopMargin(-574.0000)
Node:addChild(lv_rank_2)

--Create lv_rank_3
local lv_rank_3 = ccui.ListView:create()
lv_rank_3:setDirection(1)
lv_rank_3:setGravity(0)
lv_rank_3:ignoreContentAdaptWithSize(false)
lv_rank_3:setClippingEnabled(true)
lv_rank_3:setBackGroundColorOpacity(102)
lv_rank_3:setLayoutComponentEnabled(true)
lv_rank_3:setName("lv_rank_3")
lv_rank_3:setTag(53)
lv_rank_3:setCascadeColorEnabled(true)
lv_rank_3:setCascadeOpacityEnabled(true)
lv_rank_3:setVisible(false)
lv_rank_3:setAnchorPoint(0.0000, 1.0000)
lv_rank_3:setPosition(0.0000, 574.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(lv_rank_3)
layout:setSize({width = 1028.0000, height = 574.0000})
layout:setRightMargin(-1028.0000)
layout:setTopMargin(-574.0000)
Node:addChild(lv_rank_3)

--Create item_user
local item_user = ccui.Layout:create()
item_user:ignoreContentAdaptWithSize(false)
item_user:setClippingEnabled(false)
item_user:setBackGroundColorType(1)
item_user:setBackGroundColor({r = 255, g = 255, b = 255})
item_user:setTouchEnabled(true);
item_user:setLayoutComponentEnabled(true)
item_user:setName("item_user")
item_user:setTag(61)
item_user:setCascadeColorEnabled(true)
item_user:setCascadeOpacityEnabled(true)
item_user:setVisible(false)
item_user:setPosition(1128.0840, 56.4574)
layout = ccui.LayoutComponent:bindLayoutComponent(item_user)
layout:setSize({width = 1028.0000, height = 100.0000})
layout:setLeftMargin(1128.0840)
layout:setRightMargin(-2156.0840)
layout:setTopMargin(-156.4574)
layout:setBottomMargin(56.4574)
Node:addChild(item_user)

--Create txt_wdpm
local txt_wdpm = ccui.Text:create()
txt_wdpm:ignoreContentAdaptWithSize(true)
txt_wdpm:setTextAreaSize({width = 0, height = 0})
txt_wdpm:setFontName("")
txt_wdpm:setFontSize(18)
txt_wdpm:setString([[我的排名]])
txt_wdpm:setLayoutComponentEnabled(true)
txt_wdpm:setName("txt_wdpm")
txt_wdpm:setTag(1226)
txt_wdpm:setCascadeColorEnabled(true)
txt_wdpm:setCascadeOpacityEnabled(true)
txt_wdpm:setVisible(false)
txt_wdpm:setPosition(57.0000, 68.0000)
txt_wdpm:setTextColor({r = 162, g = 90, b = 20})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_wdpm)
layout:setPositionPercentX(0.0554)
layout:setPositionPercentY(0.6800)
layout:setPercentWidth(0.0700)
layout:setPercentHeight(0.1800)
layout:setSize({width = 72.0000, height = 18.0000})
layout:setLeftMargin(21.0000)
layout:setRightMargin(935.0000)
layout:setTopMargin(23.0000)
layout:setBottomMargin(59.0000)
item_user:addChild(txt_wdpm)

--Create img_rank
local img_rank = ccui.ImageView:create()
img_rank:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/honor.plist")
img_rank:loadTexture("hall/honor/rank_1.png",1)
img_rank:setLayoutComponentEnabled(true)
img_rank:setName("img_rank")
img_rank:setTag(1227)
img_rank:setCascadeColorEnabled(true)
img_rank:setCascadeOpacityEnabled(true)
img_rank:setVisible(false)
img_rank:setPosition(59.0000, 50.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_rank)
layout:setPositionPercentX(0.0574)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.0554)
layout:setPercentHeight(0.4300)
layout:setSize({width = 57.0000, height = 43.0000})
layout:setLeftMargin(30.5000)
layout:setRightMargin(940.5000)
layout:setTopMargin(28.5000)
layout:setBottomMargin(28.5000)
item_user:addChild(img_rank)

--Create txt_rank
local txt_rank = ccui.TextBMFont:create()
txt_rank:setFntFile("fonts/rank2_num.fnt")
txt_rank:setString([[1]])
txt_rank:setLayoutComponentEnabled(true)
txt_rank:setName("txt_rank")
txt_rank:setTag(992)
txt_rank:setCascadeColorEnabled(true)
txt_rank:setCascadeOpacityEnabled(true)
txt_rank:setVisible(false)
txt_rank:setPosition(57.0000, 45.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(txt_rank)
layout:setPositionPercentX(0.0554)
layout:setPositionPercentY(0.4500)
layout:setPercentWidth(0.0146)
layout:setPercentHeight(0.4000)
layout:setSize({width = 15.0000, height = 40.0000})
layout:setLeftMargin(49.5000)
layout:setRightMargin(963.5000)
layout:setTopMargin(35.0000)
layout:setBottomMargin(25.0000)
item_user:addChild(txt_rank)

--Create img_avatar
local img_avatar = ccui.ImageView:create()
img_avatar:ignoreContentAdaptWithSize(false)
img_avatar:loadTexture("common/hd_male.png",0)
img_avatar:setLayoutComponentEnabled(true)
img_avatar:setName("img_avatar")
img_avatar:setTag(1225)
img_avatar:setCascadeColorEnabled(true)
img_avatar:setCascadeOpacityEnabled(true)
img_avatar:setAnchorPoint(0.0000, 0.5000)
img_avatar:setPosition(129.0000, 49.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_avatar)
layout:setPositionPercentX(0.1255)
layout:setPositionPercentY(0.4900)
layout:setPercentWidth(0.0584)
layout:setPercentHeight(0.6000)
layout:setSize({width = 60.0000, height = 60.0000})
layout:setLeftMargin(129.0000)
layout:setRightMargin(839.0000)
layout:setTopMargin(21.0000)
layout:setBottomMargin(19.0000)
item_user:addChild(img_avatar)

--Create txt_nick
local txt_nick = ccui.Text:create()
txt_nick:ignoreContentAdaptWithSize(true)
txt_nick:setTextAreaSize({width = 0, height = 0})
txt_nick:setFontName("")
txt_nick:setFontSize(24)
txt_nick:setString([[用户昵称]])
txt_nick:setLayoutComponentEnabled(true)
txt_nick:setName("txt_nick")
txt_nick:setTag(1229)
txt_nick:setCascadeColorEnabled(true)
txt_nick:setCascadeOpacityEnabled(true)
txt_nick:setAnchorPoint(0.0000, 0.5000)
txt_nick:setPosition(201.0000, 48.0000)
txt_nick:setTextColor({r = 68, g = 69, b = 70})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_nick)
layout:setPositionPercentX(0.1955)
layout:setPositionPercentY(0.4800)
layout:setPercentWidth(0.0934)
layout:setPercentHeight(0.2400)
layout:setSize({width = 96.0000, height = 24.0000})
layout:setLeftMargin(201.0000)
layout:setRightMargin(731.0000)
layout:setTopMargin(40.0000)
layout:setBottomMargin(36.0000)
item_user:addChild(txt_nick)

--Create txt_hexp
local txt_hexp = ccui.Text:create()
txt_hexp:ignoreContentAdaptWithSize(true)
txt_hexp:setTextAreaSize({width = 0, height = 0})
txt_hexp:setFontName("")
txt_hexp:setFontSize(28)
txt_hexp:setString([[100.00万]])
txt_hexp:setLayoutComponentEnabled(true)
txt_hexp:setName("txt_hexp")
txt_hexp:setTag(1230)
txt_hexp:setCascadeColorEnabled(true)
txt_hexp:setCascadeOpacityEnabled(true)
txt_hexp:setAnchorPoint(0.0000, 0.5000)
txt_hexp:setPosition(617.0101, 48.0000)
txt_hexp:setTextColor({r = 68, g = 69, b = 70})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_hexp)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.6002)
layout:setPositionPercentY(0.4800)
layout:setPercentWidth(0.1089)
layout:setPercentHeight(0.2800)
layout:setSize({width = 112.0000, height = 28.0000})
layout:setLeftMargin(617.0101)
layout:setRightMargin(298.9899)
layout:setTopMargin(38.0000)
layout:setBottomMargin(34.0000)
item_user:addChild(txt_hexp)

--Create btn_zan
local btn_zan = ccui.Button:create()
btn_zan:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/honor.plist")
btn_zan:loadTextureNormal("hall/honor/btn_zang_2.png",1)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/honor.plist")
btn_zan:loadTexturePressed("hall/honor/btn_zang_2.png",1)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/honor.plist")
btn_zan:loadTextureDisabled("hall/honor/btn_zang_1.png",1)
btn_zan:setTitleFontSize(18)
btn_zan:setTitleColor({r = 65, g = 65, b = 70})
btn_zan:setScale9Enabled(true)
btn_zan:setCapInsets({x = 15, y = 11, width = 22, height = 30})
btn_zan:setLayoutComponentEnabled(true)
btn_zan:setName("btn_zan")
btn_zan:setTag(62)
btn_zan:setCascadeColorEnabled(true)
btn_zan:setCascadeOpacityEnabled(true)
btn_zan:setPosition(912.0000, 58.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_zan)
layout:setPositionPercentX(0.8872)
layout:setPositionPercentY(0.5800)
layout:setPercentWidth(0.0506)
layout:setPercentHeight(0.5200)
layout:setSize({width = 52.0000, height = 52.0000})
layout:setLeftMargin(886.0000)
layout:setRightMargin(90.0000)
layout:setTopMargin(16.0000)
layout:setBottomMargin(32.0000)
item_user:addChild(btn_zan)

--Create txt_zan
local txt_zan = ccui.Text:create()
txt_zan:ignoreContentAdaptWithSize(true)
txt_zan:setTextAreaSize({width = 0, height = 0})
txt_zan:setFontName("")
txt_zan:setFontSize(18)
txt_zan:setString([[共999赞]])
txt_zan:setLayoutComponentEnabled(true)
txt_zan:setName("txt_zan")
txt_zan:setTag(1224)
txt_zan:setCascadeColorEnabled(true)
txt_zan:setCascadeOpacityEnabled(true)
txt_zan:setPosition(915.0000, 20.0000)
txt_zan:setTextColor({r = 46, g = 153, b = 10})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_zan)
layout:setPositionPercentX(0.8901)
layout:setPositionPercentY(0.2000)
layout:setPercentWidth(0.0613)
layout:setPercentHeight(0.1800)
layout:setSize({width = 63.0000, height = 18.0000})
layout:setLeftMargin(883.5000)
layout:setRightMargin(81.5000)
layout:setTopMargin(71.0000)
layout:setBottomMargin(11.0000)
item_user:addChild(txt_zan)

--Create txt_wsb
local txt_wsb = ccui.Text:create()
txt_wsb:ignoreContentAdaptWithSize(true)
txt_wsb:setTextAreaSize({width = 0, height = 0})
txt_wsb:setFontSize(26)
txt_wsb:setString([[未上榜]])
txt_wsb:setLayoutComponentEnabled(true)
txt_wsb:setName("txt_wsb")
txt_wsb:setTag(993)
txt_wsb:setCascadeColorEnabled(true)
txt_wsb:setCascadeOpacityEnabled(true)
txt_wsb:setVisible(false)
txt_wsb:setPosition(57.0000, 48.0000)
txt_wsb:setTextColor({r = 0, g = 0, b = 0})
layout = ccui.LayoutComponent:bindLayoutComponent(txt_wsb)
layout:setPositionPercentX(0.0554)
layout:setPositionPercentY(0.4800)
layout:setPercentWidth(0.0759)
layout:setPercentHeight(0.2600)
layout:setSize({width = 78.0000, height = 26.0000})
layout:setLeftMargin(18.0000)
layout:setRightMargin(932.0000)
layout:setTopMargin(39.0000)
layout:setBottomMargin(35.0000)
item_user:addChild(txt_wsb)

--Create nd_honor
local nd_honor = ccui.Layout:create()
nd_honor:ignoreContentAdaptWithSize(false)
nd_honor:setClippingEnabled(false)
nd_honor:setBackGroundColorOpacity(102)
nd_honor:setTouchEnabled(true);
nd_honor:setLayoutComponentEnabled(true)
nd_honor:setName("nd_honor")
nd_honor:setTag(308)
nd_honor:setCascadeColorEnabled(true)
nd_honor:setCascadeOpacityEnabled(true)
nd_honor:setPosition(382.6000, 0.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(nd_honor)
layout:setPositionPercentX(0.3722)
layout:setPercentWidth(0.2335)
layout:setPercentHeight(1.0000)
layout:setSize({width = 240.0000, height = 100.0000})
layout:setLeftMargin(382.6000)
layout:setRightMargin(405.4000)
item_user:addChild(nd_honor)

--Create img_0
local img_0 = ccui.ImageView:create()
img_0:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/newhonor.plist")
img_0:loadTexture("hall/newhonor/img_di4.png",1)
img_0:setScale9Enabled(true)
img_0:setCapInsets({x = 19, y = 11, width = 7, height = 13})
img_0:setLayoutComponentEnabled(true)
img_0:setName("img_0")
img_0:setTag(301)
img_0:setCascadeColorEnabled(true)
img_0:setCascadeOpacityEnabled(true)
img_0:setAnchorPoint(0.0000, 0.5000)
img_0:setPosition(35.1000, 46.8808)
layout = ccui.LayoutComponent:bindLayoutComponent(img_0)
layout:setPositionPercentX(0.1463)
layout:setPositionPercentY(0.4688)
layout:setPercentWidth(0.7667)
layout:setPercentHeight(0.3500)
layout:setSize({width = 184.0000, height = 35.0000})
layout:setLeftMargin(35.1000)
layout:setRightMargin(20.9000)
layout:setTopMargin(35.6192)
layout:setBottomMargin(29.3808)
nd_honor:addChild(img_0)

--Create img_1
local img_1 = ccui.ImageView:create()
img_1:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/newhall.plist")
img_1:loadTexture("hall/newhall/btn_jbei.png",1)
img_1:setLayoutComponentEnabled(true)
img_1:setName("img_1")
img_1:setTag(302)
img_1:setCascadeColorEnabled(true)
img_1:setCascadeOpacityEnabled(true)
img_1:setPosition(40.9926, 49.1215)
img_1:setScaleX(0.9400)
img_1:setScaleY(0.9400)
layout = ccui.LayoutComponent:bindLayoutComponent(img_1)
layout:setPositionPercentX(0.1708)
layout:setPositionPercentY(0.4912)
layout:setPercentWidth(0.2583)
layout:setPercentHeight(0.5600)
layout:setSize({width = 62.0000, height = 56.0000})
layout:setLeftMargin(9.9926)
layout:setRightMargin(168.0074)
layout:setTopMargin(22.8785)
layout:setBottomMargin(21.1215)
nd_honor:addChild(img_1)

--Create star_1
local star_1 = ccui.Slider:create()
star_1:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/newhonor.plist")
star_1:loadBarTexture("hall/newhonor/btn_wjx1.png",1)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/newhonor.plist")
star_1:loadProgressBarTexture("hall/newhonor/btn_wjx2.png",1)
star_1:setTouchEnabled(false);
star_1:setLayoutComponentEnabled(true)
star_1:setName("star_1")
star_1:setTag(303)
star_1:setCascadeColorEnabled(true)
star_1:setCascadeOpacityEnabled(true)
star_1:setPosition(84.2700, 48.1216)
layout = ccui.LayoutComponent:bindLayoutComponent(star_1)
layout:setPositionPercentX(0.3511)
layout:setPositionPercentY(0.4812)
layout:setPercentWidth(0.1000)
layout:setPercentHeight(0.2300)
layout:setSize({width = 24.0000, height = 23.0000})
layout:setLeftMargin(72.2700)
layout:setRightMargin(143.7300)
layout:setTopMargin(40.3784)
layout:setBottomMargin(36.6216)
nd_honor:addChild(star_1)

--Create star_2
local star_2 = ccui.Slider:create()
star_2:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/newhonor.plist")
star_2:loadBarTexture("hall/newhonor/btn_wjx1.png",1)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/newhonor.plist")
star_2:loadProgressBarTexture("hall/newhonor/btn_wjx2.png",1)
star_2:setTouchEnabled(false);
star_2:setLayoutComponentEnabled(true)
star_2:setName("star_2")
star_2:setTag(304)
star_2:setCascadeColorEnabled(true)
star_2:setCascadeOpacityEnabled(true)
star_2:setPosition(112.2700, 48.1216)
layout = ccui.LayoutComponent:bindLayoutComponent(star_2)
layout:setPositionPercentX(0.4678)
layout:setPositionPercentY(0.4812)
layout:setPercentWidth(0.1000)
layout:setPercentHeight(0.2300)
layout:setSize({width = 24.0000, height = 23.0000})
layout:setLeftMargin(100.2700)
layout:setRightMargin(115.7300)
layout:setTopMargin(40.3784)
layout:setBottomMargin(36.6216)
nd_honor:addChild(star_2)

--Create star_3
local star_3 = ccui.Slider:create()
star_3:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/newhonor.plist")
star_3:loadBarTexture("hall/newhonor/btn_wjx1.png",1)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/newhonor.plist")
star_3:loadProgressBarTexture("hall/newhonor/btn_wjx2.png",1)
star_3:setTouchEnabled(false);
star_3:setLayoutComponentEnabled(true)
star_3:setName("star_3")
star_3:setTag(305)
star_3:setCascadeColorEnabled(true)
star_3:setCascadeOpacityEnabled(true)
star_3:setPosition(140.2700, 48.1216)
layout = ccui.LayoutComponent:bindLayoutComponent(star_3)
layout:setPositionPercentX(0.5845)
layout:setPositionPercentY(0.4812)
layout:setPercentWidth(0.1000)
layout:setPercentHeight(0.2300)
layout:setSize({width = 24.0000, height = 23.0000})
layout:setLeftMargin(128.2700)
layout:setRightMargin(87.7300)
layout:setTopMargin(40.3784)
layout:setBottomMargin(36.6216)
nd_honor:addChild(star_3)

--Create star_4
local star_4 = ccui.Slider:create()
star_4:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/newhonor.plist")
star_4:loadBarTexture("hall/newhonor/btn_wjx1.png",1)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/newhonor.plist")
star_4:loadProgressBarTexture("hall/newhonor/btn_wjx2.png",1)
star_4:setTouchEnabled(false);
star_4:setLayoutComponentEnabled(true)
star_4:setName("star_4")
star_4:setTag(306)
star_4:setCascadeColorEnabled(true)
star_4:setCascadeOpacityEnabled(true)
star_4:setPosition(167.2700, 48.1216)
layout = ccui.LayoutComponent:bindLayoutComponent(star_4)
layout:setPositionPercentX(0.6970)
layout:setPositionPercentY(0.4812)
layout:setPercentWidth(0.1000)
layout:setPercentHeight(0.2300)
layout:setSize({width = 24.0000, height = 23.0000})
layout:setLeftMargin(155.2700)
layout:setRightMargin(60.7300)
layout:setTopMargin(40.3784)
layout:setBottomMargin(36.6216)
nd_honor:addChild(star_4)

--Create star_5
local star_5 = ccui.Slider:create()
star_5:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/newhonor.plist")
star_5:loadBarTexture("hall/newhonor/btn_wjx1.png",1)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/newhonor.plist")
star_5:loadProgressBarTexture("hall/newhonor/btn_wjx2.png",1)
star_5:setTouchEnabled(false);
star_5:setLayoutComponentEnabled(true)
star_5:setName("star_5")
star_5:setTag(307)
star_5:setCascadeColorEnabled(true)
star_5:setCascadeOpacityEnabled(true)
star_5:setPosition(194.2700, 48.1216)
layout = ccui.LayoutComponent:bindLayoutComponent(star_5)
layout:setPositionPercentX(0.8095)
layout:setPositionPercentY(0.4812)
layout:setPercentWidth(0.1000)
layout:setPercentHeight(0.2300)
layout:setSize({width = 24.0000, height = 23.0000})
layout:setLeftMargin(182.2700)
layout:setRightMargin(33.7300)
layout:setTopMargin(40.3784)
layout:setBottomMargin(36.6216)
nd_honor:addChild(star_5)

--Create Animation
result['animation'] = ccs.ActionTimeline:create()
  
result['animation']:setDuration(0)
result['animation']:setTimeSpeed(1.0000)
--Create Animation List

result['root'] = Node
return result;
end

return Result

