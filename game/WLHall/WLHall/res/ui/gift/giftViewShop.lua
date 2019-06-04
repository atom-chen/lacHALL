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
result['Node']=cc.Node:create()
result['Node']:setName("Node")

--Create Panel
result['Panel'] = ccui.Layout:create()
result['Panel']:ignoreContentAdaptWithSize(false)
result['Panel']:setClippingEnabled(false)
result['Panel']:setBackGroundColorOpacity(102)
result['Panel']:setTouchEnabled(true);
result['Panel']:setLayoutComponentEnabled(true)
result['Panel']:setName("Panel")
result['Panel']:setTag(257)
result['Panel']:setCascadeColorEnabled(true)
result['Panel']:setCascadeOpacityEnabled(true)
result['Panel']:setPosition(-0.0005, -0.0002)
layout = ccui.LayoutComponent:bindLayoutComponent(result['Panel'])
layout:setSize({width = 1094.0000, height = 634.0000})
layout:setLeftMargin(-0.0005)
layout:setRightMargin(-1094.0000)
layout:setTopMargin(-633.9998)
layout:setBottomMargin(-0.0002)
result['Node']:addChild(result['Panel'])

--Create Panel_bg
result['Panel_bg'] = ccui.Layout:create()
result['Panel_bg']:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/giftNodeVeiw.plist")
result['Panel_bg']:setBackGroundImage("hall/gift/frame_1.png",1)
result['Panel_bg']:setClippingEnabled(false)
result['Panel_bg']:setBackGroundImageCapInsets({x = 3, y = 3, width = 4, height = 4})
result['Panel_bg']:setBackGroundColorOpacity(102)
result['Panel_bg']:setBackGroundImageScale9Enabled(true)
result['Panel_bg']:setTouchEnabled(true);
result['Panel_bg']:setLayoutComponentEnabled(true)
result['Panel_bg']:setName("Panel_bg")
result['Panel_bg']:setTag(424)
result['Panel_bg']:setCascadeColorEnabled(true)
result['Panel_bg']:setCascadeOpacityEnabled(true)
layout = ccui.LayoutComponent:bindLayoutComponent(result['Panel_bg'])
layout:setPercentWidth(1.0018)
layout:setPercentHeight(0.8028)
layout:setSize({width = 1096.0000, height = 509.0000})
layout:setRightMargin(-2.0000)
layout:setTopMargin(125.0000)
result['Panel']:addChild(result['Panel_bg'])

--Create panel_date
result['panel_date'] = ccui.Layout:create()
result['panel_date']:ignoreContentAdaptWithSize(false)
result['panel_date']:setClippingEnabled(false)
result['panel_date']:setBackGroundColorOpacity(102)
result['panel_date']:setTouchEnabled(true);
result['panel_date']:setLayoutComponentEnabled(true)
result['panel_date']:setName("panel_date")
result['panel_date']:setTag(249)
result['panel_date']:setCascadeColorEnabled(true)
result['panel_date']:setCascadeOpacityEnabled(true)
result['panel_date']:setVisible(false)
result['panel_date']:setAnchorPoint(0.5000, 0.5000)
result['panel_date']:setPosition(548.0000, 260.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(result['panel_date'])
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5108)
layout:setPercentWidth(0.1825)
layout:setPercentHeight(0.0668)
layout:setSize({width = 200.0000, height = 34.0000})
layout:setLeftMargin(448.0000)
layout:setRightMargin(448.0000)
layout:setTopMargin(232.0000)
layout:setBottomMargin(243.0000)
result['Panel_bg']:addChild(result['panel_date'])

--Create txt_nodate
result['txt_nodate'] = ccui.Text:create()
result['txt_nodate']:ignoreContentAdaptWithSize(true)
result['txt_nodate']:setTextAreaSize({width = 0, height = 0})
result['txt_nodate']:setFontSize(34)
result['txt_nodate']:setString([[暂无数据]])
result['txt_nodate']:setLayoutComponentEnabled(true)
result['txt_nodate']:setName("txt_nodate")
result['txt_nodate']:setTag(248)
result['txt_nodate']:setCascadeColorEnabled(true)
result['txt_nodate']:setCascadeOpacityEnabled(true)
result['txt_nodate']:setPosition(121.1147, 17.8184)
result['txt_nodate']:setTextColor({r = 127, g = 127, b = 127})
layout = ccui.LayoutComponent:bindLayoutComponent(result['txt_nodate'])
layout:setPositionPercentX(0.6056)
layout:setPositionPercentY(0.5241)
layout:setPercentWidth(0.6800)
layout:setPercentHeight(1.0000)
layout:setSize({width = 136.0000, height = 34.0000})
layout:setLeftMargin(53.1147)
layout:setRightMargin(10.8853)
layout:setTopMargin(-0.8184)
layout:setBottomMargin(0.8184)
result['panel_date']:addChild(result['txt_nodate'])

--Create img_title
result['img_title'] = ccui.ImageView:create()
result['img_title']:ignoreContentAdaptWithSize(false)
result['img_title']:loadTexture("hall/common/tanhao.png",0)
result['img_title']:setLayoutComponentEnabled(true)
result['img_title']:setName("img_title")
result['img_title']:setTag(247)
result['img_title']:setCascadeColorEnabled(true)
result['img_title']:setCascadeOpacityEnabled(true)
result['img_title']:setPosition(25.9044, 17.8816)
layout = ccui.LayoutComponent:bindLayoutComponent(result['img_title'])
layout:setPositionPercentX(0.1295)
layout:setPositionPercentY(0.5259)
layout:setPercentWidth(0.2050)
layout:setPercentHeight(0.9706)
layout:setSize({width = 41.0000, height = 33.0000})
layout:setLeftMargin(5.4044)
layout:setRightMargin(153.5956)
layout:setTopMargin(-0.3816)
layout:setBottomMargin(1.3816)
result['panel_date']:addChild(result['img_title'])

--Create txt_data
result['txt_data'] = ccui.Text:create()
result['txt_data']:ignoreContentAdaptWithSize(true)
result['txt_data']:setTextAreaSize({width = 0, height = 0})
result['txt_data']:setFontSize(34)
result['txt_data']:setString([[数据加载中...]])
result['txt_data']:setLayoutComponentEnabled(true)
result['txt_data']:setName("txt_data")
result['txt_data']:setTag(246)
result['txt_data']:setCascadeColorEnabled(true)
result['txt_data']:setCascadeOpacityEnabled(true)
result['txt_data']:setVisible(false)
result['txt_data']:setPosition(548.0000, 260.0000)
result['txt_data']:setTextColor({r = 127, g = 127, b = 127})
layout = ccui.LayoutComponent:bindLayoutComponent(result['txt_data'])
layout:setPositionPercentX(0.5009)
layout:setPositionPercentY(0.4101)
layout:setPercentWidth(0.2020)
layout:setPercentHeight(0.0536)
layout:setSize({width = 221.0000, height = 34.0000})
layout:setLeftMargin(437.5000)
layout:setRightMargin(435.5000)
layout:setTopMargin(357.0000)
layout:setBottomMargin(243.0000)
result['Panel']:addChild(result['txt_data'])

--Create ViewNode
result['ViewNode']=cc.Node:create()
result['ViewNode']:setName("ViewNode")
result['ViewNode']:setTag(261)
result['ViewNode']:setCascadeColorEnabled(true)
result['ViewNode']:setCascadeOpacityEnabled(true)
result['ViewNode']:setPosition(0.0004, 0.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(result['ViewNode'])
layout:setPositionPercentX(0.0000)
layout:setLeftMargin(0.0004)
layout:setRightMargin(1094.0000)
layout:setTopMargin(634.0000)
result['Panel']:addChild(result['ViewNode'])

--Create img_tishi
result['img_tishi'] = ccui.ImageView:create()
result['img_tishi']:ignoreContentAdaptWithSize(false)
result['img_tishi']:loadTexture("hall/gift/banner_photo.png",0)
result['img_tishi']:setLayoutComponentEnabled(true)
result['img_tishi']:setName("img_tishi")
result['img_tishi']:setTag(490)
result['img_tishi']:setCascadeColorEnabled(true)
result['img_tishi']:setCascadeOpacityEnabled(true)
result['img_tishi']:setAnchorPoint(0.0000, 1.0000)
result['img_tishi']:setPosition(-0.3736, 662.0023)
layout = ccui.LayoutComponent:bindLayoutComponent(result['img_tishi'])
layout:setPositionPercentX(-0.0003)
layout:setPositionPercentY(1.0442)
layout:setPercentWidth(1.0018)
layout:setPercentHeight(0.2413)
layout:setSize({width = 1096.0000, height = 153.0000})
layout:setLeftMargin(-0.3736)
layout:setRightMargin(-1.6263)
layout:setTopMargin(-28.0023)
layout:setBottomMargin(509.0023)
result['Panel']:addChild(result['img_tishi'])

--Create node_lipin
result['node_lipin']=cc.Node:create()
result['node_lipin']:setName("node_lipin")
result['node_lipin']:setTag(333)
result['node_lipin']:setCascadeColorEnabled(true)
result['node_lipin']:setCascadeOpacityEnabled(true)
result['node_lipin']:setPosition(553.9979, 29.0001)
layout = ccui.LayoutComponent:bindLayoutComponent(result['node_lipin'])
layout:setPositionPercentX(0.5055)
layout:setPositionPercentY(0.1895)
layout:setLeftMargin(553.9979)
layout:setRightMargin(542.0021)
layout:setTopMargin(123.9999)
layout:setBottomMargin(29.0001)
result['img_tishi']:addChild(result['node_lipin'])

--Create Panel_bg
result['Panel_bg'] = ccui.Layout:create()
result['Panel_bg']:ignoreContentAdaptWithSize(false)
result['Panel_bg']:setBackGroundImage("hall/newhall/bg_cur.png",0)
result['Panel_bg']:setClippingEnabled(false)
result['Panel_bg']:setBackGroundImageCapInsets({x = 4, y = 4, width = 5, height = 5})
result['Panel_bg']:setBackGroundColorOpacity(102)
result['Panel_bg']:setBackGroundImageScale9Enabled(true)
result['Panel_bg']:setTouchEnabled(true);
result['Panel_bg']:setLayoutComponentEnabled(true)
result['Panel_bg']:setName("Panel_bg")
result['Panel_bg']:setTag(334)
result['Panel_bg']:setCascadeColorEnabled(true)
result['Panel_bg']:setCascadeOpacityEnabled(true)
result['Panel_bg']:setAnchorPoint(0.0000, 0.5000)
result['Panel_bg']:setPosition(-30.0000, 1.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(result['Panel_bg'])
layout:setSize({width = 156.0000, height = 40.0000})
layout:setLeftMargin(-30.0000)
layout:setRightMargin(-126.0000)
layout:setTopMargin(-21.0000)
layout:setBottomMargin(-19.0000)
result['node_lipin']:addChild(result['Panel_bg'])

--Create img_lipin
result['img_lipin'] = ccui.ImageView:create()
result['img_lipin']:ignoreContentAdaptWithSize(false)
result['img_lipin']:loadTexture("hall/common/prop_lpq_s.png",0)
result['img_lipin']:setScale9Enabled(true)
result['img_lipin']:setCapInsets({x = 16, y = 9, width = 38, height = 52})
result['img_lipin']:setLayoutComponentEnabled(true)
result['img_lipin']:setName("img_lipin")
result['img_lipin']:setTag(491)
result['img_lipin']:setCascadeColorEnabled(true)
result['img_lipin']:setCascadeOpacityEnabled(true)
result['img_lipin']:setAnchorPoint(1.0000, 0.5000)
result['img_lipin']:setPosition(6.0000, 0.5000)
layout = ccui.LayoutComponent:bindLayoutComponent(result['img_lipin'])
layout:setSize({width = 70.0000, height = 70.0000})
layout:setLeftMargin(-64.0000)
layout:setRightMargin(-6.0000)
layout:setTopMargin(-35.5000)
layout:setBottomMargin(-34.5000)
result['node_lipin']:addChild(result['img_lipin'])

--Create lipin_number
result['lipin_number'] = ccui.Text:create()
result['lipin_number']:ignoreContentAdaptWithSize(true)
result['lipin_number']:setTextAreaSize({width = 0, height = 0})
result['lipin_number']:setFontName("")
result['lipin_number']:setFontSize(32)
result['lipin_number']:setString([[0]])
result['lipin_number']:setLayoutComponentEnabled(true)
result['lipin_number']:setName("lipin_number")
result['lipin_number']:setTag(494)
result['lipin_number']:setCascadeColorEnabled(true)
result['lipin_number']:setCascadeOpacityEnabled(true)
result['lipin_number']:setAnchorPoint(0.0000, 0.5000)
result['lipin_number']:setPosition(70.0000, 35.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(result['lipin_number'])
layout:setPositionPercentX(1.0000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.2286)
layout:setPercentHeight(0.4714)
layout:setSize({width = 16.0000, height = 33.0000})
layout:setLeftMargin(70.0000)
layout:setRightMargin(-16.0000)
layout:setTopMargin(18.5000)
layout:setBottomMargin(18.5000)
result['img_lipin']:addChild(result['lipin_number'])

--Create node_hongbao
result['node_hongbao']=cc.Node:create()
result['node_hongbao']:setName("node_hongbao")
result['node_hongbao']:setTag(336)
result['node_hongbao']:setCascadeColorEnabled(true)
result['node_hongbao']:setCascadeOpacityEnabled(true)
result['node_hongbao']:setPosition(755.0014, 29.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(result['node_hongbao'])
layout:setPositionPercentX(0.6889)
layout:setPositionPercentY(0.1895)
layout:setLeftMargin(755.0014)
layout:setRightMargin(340.9986)
layout:setTopMargin(124.0000)
layout:setBottomMargin(29.0000)
result['img_tishi']:addChild(result['node_hongbao'])

--Create Panel_bg
result['Panel_bg'] = ccui.Layout:create()
result['Panel_bg']:ignoreContentAdaptWithSize(false)
result['Panel_bg']:setBackGroundImage("hall/newhall/bg_cur.png",0)
result['Panel_bg']:setClippingEnabled(false)
result['Panel_bg']:setBackGroundImageCapInsets({x = 4, y = 4, width = 5, height = 5})
result['Panel_bg']:setBackGroundColorOpacity(102)
result['Panel_bg']:setBackGroundImageScale9Enabled(true)
result['Panel_bg']:setTouchEnabled(true);
result['Panel_bg']:setLayoutComponentEnabled(true)
result['Panel_bg']:setName("Panel_bg")
result['Panel_bg']:setTag(339)
result['Panel_bg']:setCascadeColorEnabled(true)
result['Panel_bg']:setCascadeOpacityEnabled(true)
result['Panel_bg']:setAnchorPoint(0.0000, 0.5000)
result['Panel_bg']:setPosition(-30.0000, 1.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(result['Panel_bg'])
layout:setSize({width = 156.0000, height = 40.0000})
layout:setLeftMargin(-30.0000)
layout:setRightMargin(-126.0000)
layout:setTopMargin(-21.0000)
layout:setBottomMargin(-19.0000)
result['node_hongbao']:addChild(result['Panel_bg'])

--Create img_hongbao
result['img_hongbao'] = ccui.ImageView:create()
result['img_hongbao']:ignoreContentAdaptWithSize(false)
result['img_hongbao']:loadTexture("hall/common/prop_hbq_s.png",0)
result['img_hongbao']:setLayoutComponentEnabled(true)
result['img_hongbao']:setName("img_hongbao")
result['img_hongbao']:setTag(492)
result['img_hongbao']:setCascadeColorEnabled(true)
result['img_hongbao']:setCascadeOpacityEnabled(true)
result['img_hongbao']:setAnchorPoint(1.0000, 0.5000)
result['img_hongbao']:setPosition(6.0000, 0.5000)
layout = ccui.LayoutComponent:bindLayoutComponent(result['img_hongbao'])
layout:setSize({width = 70.0000, height = 70.0000})
layout:setLeftMargin(-64.0000)
layout:setRightMargin(-6.0000)
layout:setTopMargin(-35.5000)
layout:setBottomMargin(-34.5000)
result['node_hongbao']:addChild(result['img_hongbao'])

--Create hongbao_number
result['hongbao_number'] = ccui.Text:create()
result['hongbao_number']:ignoreContentAdaptWithSize(true)
result['hongbao_number']:setTextAreaSize({width = 0, height = 0})
result['hongbao_number']:setFontName("")
result['hongbao_number']:setFontSize(32)
result['hongbao_number']:setString([[0]])
result['hongbao_number']:setLayoutComponentEnabled(true)
result['hongbao_number']:setName("hongbao_number")
result['hongbao_number']:setTag(496)
result['hongbao_number']:setCascadeColorEnabled(true)
result['hongbao_number']:setCascadeOpacityEnabled(true)
result['hongbao_number']:setAnchorPoint(0.0000, 0.5000)
result['hongbao_number']:setPosition(70.0000, 35.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(result['hongbao_number'])
layout:setPositionPercentX(1.0000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.2286)
layout:setPercentHeight(0.4714)
layout:setSize({width = 16.0000, height = 33.0000})
layout:setLeftMargin(70.0000)
layout:setRightMargin(-16.0000)
layout:setTopMargin(18.5000)
layout:setBottomMargin(18.5000)
result['img_hongbao']:addChild(result['hongbao_number'])

--Create node_huafei
result['node_huafei']=cc.Node:create()
result['node_huafei']:setName("node_huafei")
result['node_huafei']:setTag(338)
result['node_huafei']:setCascadeColorEnabled(true)
result['node_huafei']:setCascadeOpacityEnabled(true)
result['node_huafei']:setPosition(952.0002, 29.0032)
layout = ccui.LayoutComponent:bindLayoutComponent(result['node_huafei'])
layout:setPositionPercentX(0.8686)
layout:setPositionPercentY(0.1896)
layout:setLeftMargin(952.0002)
layout:setRightMargin(143.9998)
layout:setTopMargin(123.9968)
layout:setBottomMargin(29.0032)
result['img_tishi']:addChild(result['node_huafei'])

--Create Panel_bg
result['Panel_bg'] = ccui.Layout:create()
result['Panel_bg']:ignoreContentAdaptWithSize(false)
result['Panel_bg']:setBackGroundImage("hall/newhall/bg_cur.png",0)
result['Panel_bg']:setClippingEnabled(false)
result['Panel_bg']:setBackGroundImageCapInsets({x = 4, y = 4, width = 5, height = 5})
result['Panel_bg']:setBackGroundColorOpacity(102)
result['Panel_bg']:setBackGroundImageScale9Enabled(true)
result['Panel_bg']:setTouchEnabled(true);
result['Panel_bg']:setLayoutComponentEnabled(true)
result['Panel_bg']:setName("Panel_bg")
result['Panel_bg']:setTag(340)
result['Panel_bg']:setCascadeColorEnabled(true)
result['Panel_bg']:setCascadeOpacityEnabled(true)
result['Panel_bg']:setAnchorPoint(0.0000, 0.5000)
result['Panel_bg']:setPosition(-30.0000, 1.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(result['Panel_bg'])
layout:setSize({width = 156.0000, height = 40.0000})
layout:setLeftMargin(-30.0000)
layout:setRightMargin(-126.0000)
layout:setTopMargin(-21.0000)
layout:setBottomMargin(-19.0000)
result['node_huafei']:addChild(result['Panel_bg'])

--Create img_huafei
result['img_huafei'] = ccui.ImageView:create()
result['img_huafei']:ignoreContentAdaptWithSize(false)
result['img_huafei']:loadTexture("hall/common/prop_hfq_s.png",0)
result['img_huafei']:setLayoutComponentEnabled(true)
result['img_huafei']:setName("img_huafei")
result['img_huafei']:setTag(493)
result['img_huafei']:setCascadeColorEnabled(true)
result['img_huafei']:setCascadeOpacityEnabled(true)
result['img_huafei']:setAnchorPoint(1.0000, 0.5000)
result['img_huafei']:setPosition(6.0000, 0.5000)
layout = ccui.LayoutComponent:bindLayoutComponent(result['img_huafei'])
layout:setSize({width = 70.0000, height = 70.0000})
layout:setLeftMargin(-64.0000)
layout:setRightMargin(-6.0000)
layout:setTopMargin(-35.5000)
layout:setBottomMargin(-34.5000)
result['node_huafei']:addChild(result['img_huafei'])

--Create huafei_number
result['huafei_number'] = ccui.Text:create()
result['huafei_number']:ignoreContentAdaptWithSize(true)
result['huafei_number']:setTextAreaSize({width = 0, height = 0})
result['huafei_number']:setFontName("")
result['huafei_number']:setFontSize(32)
result['huafei_number']:setString([[0]])
result['huafei_number']:setLayoutComponentEnabled(true)
result['huafei_number']:setName("huafei_number")
result['huafei_number']:setTag(497)
result['huafei_number']:setCascadeColorEnabled(true)
result['huafei_number']:setCascadeOpacityEnabled(true)
result['huafei_number']:setAnchorPoint(0.0000, 0.5000)
result['huafei_number']:setPosition(70.0000, 35.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(result['huafei_number'])
layout:setPositionPercentX(1.0000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.2286)
layout:setPercentHeight(0.4714)
layout:setSize({width = 16.0000, height = 33.0000})
layout:setLeftMargin(70.0000)
layout:setRightMargin(-16.0000)
layout:setTopMargin(18.5000)
layout:setBottomMargin(18.5000)
result['img_huafei']:addChild(result['huafei_number'])

--Create Animation
result['animation'] = ccs.ActionTimeline:create()
  
result['animation']:setDuration(0)
result['animation']:setTimeSpeed(1.0000)
--Create Animation List

result['root'] = result['Node']
return result;
end

return Result

