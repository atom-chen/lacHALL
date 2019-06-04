
-- Author: Cai
-- Date: 2018-01-02
-- Describe：地区选择界面

local AreaMapView = class("AreaMapView", cc.load("ViewBase"))
AreaMapView.RESOURCE_FILENAME = "ui/map/map_area_view.lua"
AreaMapView.RESOURCE_BINDING = {
    ["panel_bg"] = {["varname"] = "panel_bg" },
    ["nd_area"]  = {["varname"] = "nd_area"  },
    ["btn_join"] = {["varname"] = "btn_join", ["events"] = {{event = "click", method = "onClickJoin" }}},
    ["btn_back"] = {["varname"] = "btn_back", ["events"] = {{event = "click", method = "onClickClose"}}},
    ["txt_province"] = {["varname"] = "txt_province"},

    ["btn_bg"] = {["varname"] = "btn_bg"},
    ["img_xzdq"] = {["varname"] = "img_xzdq"}

}

local MapsData = require("hall.views.login.MapsData")
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/map.plist")

function AreaMapView:onCreate(canClose)
    self:init(canClose)
    self:initView()
end

function AreaMapView:init(canClose)
    self.canClose = canClose
    -- 按钮节点
    self.map_btns = nil
    -- 包配置所属地区码
    if REGION_CODE == 0 then
        -- 家乡棋牌，显示玩家所选省的地级市
        self._belongsArea = checkint(USER_AREA_CODE)
    else
        -- 其他产品，显示 REGION_CODE 对应的地级市
        self._belongsArea = REGION_CODE
    end
    -- 当前所选的地区码
    self._currentSelectArea = nil
    -- 包配置地区( 所有地区 )
    self._areaConfig = GameApp:getAreaConfig()
    -- 创建有序的地区表
    self._hasOrderArea = {}
    for k, v in pairs(self._areaConfig) do
        table.insert(self._hasOrderArea, {k, v})
    end

    table.sort(self._hasOrderArea, function(a, b)
        return a[1] < b[1]
    end)

    local plistPath = string.format("hall/map/map_%d/map_font_%d.plist", self._belongsArea, self._belongsArea)
    cc.SpriteFrameCache:getInstance():addSpriteFrames(plistPath)
end

function AreaMapView:initView()
    self.panel_bg:setContentSize(cc.size(display.width, display.height))
    self.nd_area:setPosition(cc.p(display.cx, display.cy))
    -- 设置关闭按钮
    self.btn_back:setPositionY(display.height - 60)
    self.btn_back:setVisible(self.canClose)

    self.btn_bg:setPositionX(display.cx)
    self.btn_join:setOpacity(0)
    self.btn_join:setSwallowTouches(true)
    self.btn_join:setVisible(false)
    self:createNodeAreaMap()

    self.txt_province:setPositionX(gg.IIF(self.canClose, 100, 40))
    self.txt_province:setPositionY(display.height - 60)
    self.txt_province:setString(self._areaConfig[self._belongsArea])
end

function AreaMapView:createNodeAreaMap()
    local mapCfg = MapsData[self._belongsArea]
    if not mapCfg then return end

    local scaleCnt = 1
    local mapSize = mapCfg.map_size
    if mapSize then
        -- 先以高度来计算出缩放比例
        scaleCnt = (display.height * 0.95) / mapSize.height
        -- 根据计算出的比例计算是否宽度会超出屏幕，如果超出改为以宽度来计算比例
        if display.width * 0.95 < mapSize.width * scaleCnt then
            scaleCnt = (display.width * 0.95) / mapSize.width
        end
    end
    self.nd_area:setScale(scaleCnt)

    if mapCfg.offsetY then
        self.nd_area:setPositionY(display.cy + checkint(mapCfg.offsetY))
    end

    if mapCfg.offsetX then
        self.nd_area:setPositionX(display.cx + checkint(mapCfg.offsetX))
    end

    -- 省地图图片
    local mapPath = string.format("hall/map/map_%d/btn_%d.png", self._belongsArea, self._belongsArea)
    local mapImg = cc.Sprite:create(mapPath)
    if mapCfg.point then
        mapImg:setPosition(mapCfg.point)
    end
    self.nd_area:addChild(mapImg)

    self.map_btns = cc.Node:create()
    self.nd_area:addChild(self.map_btns)

    for k,cfg in pairs(checktable(mapCfg.btns)) do
        local btn = require("ui/map/map_btn").create().root:getChildByName("btn")
        btn:removeFromParent(true)
        btn:setScale(1.1/scaleCnt)
        btn:setTag(k)
        btn:setPosition(cfg.pos)
        btn:getChildByName("btn_bg"):getChildByName("btn_txt"):setSpriteFrame(cfg.txt_name)
        self.map_btns:addChild(btn)
    end

    if #checktable(self.map_btns:getChildren()) > 0 then
        self:initBtns()
    else
        local countyTb = self:getSubordinateArea(self._belongsArea)
        if not countyTb or #countyTb <= 0 then
            self._currentSelectArea = self._belongsArea
            self:showCountyView()
        else
            self:showCountyView(countyTb, true)
        end
    end
end

function AreaMapView:initBtns()
    self.mBtns = self.map_btns:getChildren()
    local function eventFunc(touch, event)
        if self._isNotCanTouch then
            return
        end
        if event:getEventCode() == 0 then
            self:onTouchBegan(touch)
        	return true
        elseif event:getEventCode() == 2 then
            if not self._selectAreaNode then
                self:hideCountyView()
                return
            end
            self:onTouchEnded(touch)
        end
    end

    local listener = cc.EventListenerTouchOneByOne:create();
    listener:registerScriptHandler(eventFunc, cc.Handler.EVENT_TOUCH_BEGAN);
    listener:registerScriptHandler(eventFunc, cc.Handler.EVENT_TOUCH_MOVED);
    listener:registerScriptHandler(eventFunc, cc.Handler.EVENT_TOUCH_ENDED);
    listener:registerScriptHandler(eventFunc, cc.Handler.EVENT_TOUCH_CANCELLED);
    local eventDispatcher = self.map_btns:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self.map_btns)

    -- 计算出每个按钮的触摸区域
    for _, node in ipairs(self.mBtns) do
        local bg = node:getChildByName("btn_bg")
        local pos = bg:convertToWorldSpace(cc.p(0, 0))
        pos = self.map_btns:convertToNodeSpace(pos)
        local size = bg:getContentSize()
        node.rect = cc.rect(pos.x, pos.y, size.width, size.height)
        node.centerPos = cc.p(pos.x + size.width / 2, pos.y + size.height / 2)
    end
end

function AreaMapView:setCloseFunc(func)
    self._closeFunc = func
end

-----------------------------------------------
-- 点击事件
-----------------------------------------------
function AreaMapView:onTouchBegan(touch)
    self._selectAreaNode = nil

    local touchPos = touch:getLocation()
    touchPos = self.map_btns:convertToNodeSpace(touchPos)
    local tb = {}
    for _, node in ipairs(self.mBtns) do
        if cc.rectContainsPoint(node.rect, touchPos) then
            table.insert(tb, node)
        end
    end
    local selectNode = nil
    if #tb == 1 then
        selectNode = tb[1]
    else
        local distance = 9999999
        for _, node in ipairs(tb) do
            local tmp = cc.pGetDistance(touchPos, node.centerPos)
            if tmp < distance then
                distance = tmp
                selectNode = node
            end
        end
    end
    if selectNode == nil then return end
    self._selectAreaNode = selectNode
end

function AreaMapView:onTouchEnded(touch)
    -- 用户手指移出按钮时，取消点击
    local touchPos = touch:getLocation()
    touchPos = self.map_btns:convertToNodeSpace(touchPos)
    if not cc.rectContainsPoint(self._selectAreaNode.rect, touchPos) then
        return
    end

    local areaID = self._selectAreaNode:getTag()
    local areaName = self._areaConfig[areaID]
    if not areaName then
        printf("按钮的tag值设置错误了：%d", areaID)
        return
    end

    if self._ndBlink then
        self._ndBlink:removeFromParent()
        self._ndBlink = nil
    end
    self._ndBlink = self:createBlinkNode()
    self._selectAreaNode:addChild(self._ndBlink, -10)

    local countyTb = self:getSubordinateArea(areaID)
    if not countyTb or #countyTb <= 0 then
        self._currentSelectArea = areaID
        self:showCountyView()
    else
        self:showCountyView(countyTb)
    end
end

-- 关闭按钮点击事件
function AreaMapView:onClickClose(sender)
    self:removeSelf()
end

function AreaMapView:selectCountyCallback(countyId)
    if countyId then
        self._currentSelectArea = countyId
        self:onClickJoin()
    else
        self._countyView = nil
    end
end

function AreaMapView:onClickJoin()
    local function joinGame()
        local curRegion = gg.LocalConfig:GetRegionCode()
        -- 选择地区没有变化，直接关闭界面即可
        if curRegion == self._currentSelectArea then
            if self._closeFunc then self._closeFunc() end
            if self._countyView then
                self._countyView:removeSelf()
            end
            self:removeSelf()
            return
        end
        GameApp:doSelectRegionEvent(self._currentSelectArea)
        -- 关闭当前界面
        if self._countyView then
            self._countyView:removeSelf()
        end
        self:removeSelf()
    end

    if REGION_CODE == 0 then
        local dialogTitle = string.format("确定选择 [%s] 吗？", self._areaConfig[self._currentSelectArea])
        local msg = string.format("系统将为您推荐 [%s] 的特色游戏。", self._areaConfig[self._currentSelectArea])
        GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG, msg, function(bttype)
            if bttype == gg.MessageDialog.EVENT_TYPE_OK then
                joinGame()
            end
        end, {mode = gg.MessageDialog.MODE_OK_CANCEL_CLOSE, cancel = "重新选择", ok = "确定", title = dialogTitle})
    else
        joinGame()
    end
end

function AreaMapView:showCountyView(countyTb, hideBtn)
    if countyTb and #countyTb > 0 then
        self.btn_join:setTouchEnabled(false)
        self.btn_join:setAllGray(true)
        self.btn_join:setVisible(false)
        local countyView = self:getScene():createView("login.CountyMapView", countyTb, hideBtn)
        countyView:setCallback(handler(self, self.selectCountyCallback))
        if hideBtn then
            if countyView.getViewZOrder then
                countyView:setLocalZOrder(countyView:getViewZOrder())
            end
            countyView:addTo(self)
        else
            countyView:pushInScene()
        end
        self._countyView = countyView
    else
        self.btn_join:setTouchEnabled(true)
        self.btn_join:setAllGray(false)
        self.btn_join:setVisible(true)
        self.btn_join:runAction(cc.FadeIn:create(0.3))
    end
end

function AreaMapView:hideCountyView()
    self.btn_join:setVisible(false)
    self.btn_join:setOpacity(0)
end

function AreaMapView:createBlinkNode( )
    local ndBlink = cc.Sprite:createWithSpriteFrameName("hall/map/faguang.png")
    ndBlink:setAnchorPoint(cc.p(0.5, 0))
    ndBlink:setPositionY(5)

    local blinkAct = cc.Sequence:create(cc.FadeTo:create(0.8, 0), cc.FadeTo:create(0.8, 255))
    ndBlink:runAction(cc.RepeatForever:create(blinkAct))

    return ndBlink
end

function AreaMapView:getViewZOrder()
    return 9220
end

------------------------------------------------
-- 获取地区配置
------------------------------------------------
function AreaMapView:getSubordinateArea(areaID)
    if not areaID then return nil end
    -- 配置的所有区域
    local areaConfig = self._hasOrderArea
    -- 所有下级区域
    local subordinateArea = {}
    -- 找到所有下级区域
    for i = 1, #areaConfig do
        if self:isContain(areaConfig[i][1], areaID) then
            if areaID == 0 then
                table.insert(subordinateArea, areaConfig[i])
            end
            -- 常规地区
            if self:getNumBits(areaID) + 2 == self:getNumBits(areaConfig[i][1]) then
                table.insert(subordinateArea, areaConfig[i])
            end
            -- 省直辖县级市
            if self:getNumBits(areaID) == 2 and self:isContain(areaConfig[i][1], 90, 3) and self:getNumBits(areaConfig[i][1]) == 6 then
                table.insert(subordinateArea, areaConfig[i])
            end
            -- 直辖市直接对应区(天津、北京、上海、重庆)
            if areaID == 12 or areaID == 11 or areaID == 31 or areaID == 50 then
                if self:getNumBits(areaConfig[i][1]) == 6 then
                    table.insert(subordinateArea, areaConfig[i])
                end
            end
        end
    end

    return subordinateArea
end

--[[
* @brief 判断 数字a 是否包含 数字b
* @parm a 源数字
* @parm b 被包含
* @parm pos 包含的位置（默认1）
]]
function AreaMapView:isContain(a, b, pos)
    if b == 0 then
        return self:getNumBits(a) == 2
    end
    pos = pos or 1
    local strA = string.format("%d", a)
    local strB = string.format("%d", b)
    local r = string.find(strA, strB)
    return r ~= nil and r == pos
end

--[[
* @brief 获取数字位数
* @parm num 数字
]]
function AreaMapView:getNumBits(num)
    return #(num.."")
end

-- 设置自动选地区参数
-- @param region 省码
-- @param city 城市码
-- @param district 地区码
function AreaMapView:showAutoSelectAnimation(region, city, district)
    printf("播放自动选区动画")
    self._region = region
    self._city = city
    self._district = district

    local selectBtn = self.map_btns:getChildByTag(self._city) --self:findNode("btn_"..self._region)
    selectBtn:setLocalZOrder(999)
    local tmpImg = selectBtn:getChildByName("btn_bg")
    local moveUp = cc.MoveBy:create(0.2, cc.p(0, 20))
    local moveDown = cc.MoveBy:create(0.2, cc.p(0, -20))
    local anim = cc.RepeatForever:create(cc.Sequence:create(moveUp, moveDown))
    tmpImg:runAction(anim)

    local showInTime = 1.2
    gg.CallAfter(showInTime, function ( ... )
        -- 播放动画
        local x, y = selectBtn:getPosition()
        local actionTime = 0.4
        local scale = 10
        self.nd_area:setAnchorPoint(0, 0)
        local animMove = cc.MoveTo:create(actionTime, cc.p(-x * scale + display.width/2, -y * scale + display.height/2))
        local animScale = cc.ScaleTo:create(actionTime, scale)
        local fadeOut = cc.FadeTo:create(actionTime, 0)
        self.nd_area:setCascadeOpacityEnabled(true) -- 设置影响子节点透明度（好像没什么卵用）
        selectBtn:setVisible(false)
        self.nd_area:runAction(cc.Sequence:create(cc.Spawn:create(animMove, animScale, fadeOut), cc.CallFunc:create(function()
            GameApp:doSelectRegionEvent(self._district)
            self:removeSelf()
        end)))
    end)
end

function AreaMapView:setMapButtonEnable(isEnable)
    self.img_xzdq:setVisible(isEnable)
    if isEnable then
        self._isNotCanTouch = false
        if not tolua.isnull(self._maskLayer) then
            self._maskLayer:removeSelf()
        end
    else
        -- 创建一个新的遮罩层
        self._isNotCanTouch = true
        if tolua.isnull(self._maskLayer) then
            local maskLayer = cc.LayerColor:create(cc.c4b(0, 0, 0, 127))
            maskLayer:setContentSize(display.width*2, display.height*2)
            maskLayer:setPosition(cc.p(-display.width, -display.height))
            self.map_btns:addChild(maskLayer)
            self._maskLayer = maskLayer
        end
    end
end

return AreaMapView
