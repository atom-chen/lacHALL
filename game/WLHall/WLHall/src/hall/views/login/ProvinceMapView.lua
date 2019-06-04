
-- Author: Cai
-- Date: 2018-01-02
-- Describe：全国地图

local ProvinceMapView = class("ProvinceMapView", cc.load("ViewBase"))

ProvinceMapView.RESOURCE_FILENAME = "ui/map/map_main_view.lua"
ProvinceMapView.RESOURCE_BINDING = {
    ["sv_map"]   = { ["varname"] = "sv_map"   },
    ["nd_tips"]  = { ["varname"] = "nd_tips"  },
    ["img_tips"] = { ["varname"] = "img_tips" },
    ["nd_cloud"] = { ["varname"] = "nd_cloud" },
    ["map_btns"] = { ["varname"] = "map_btns" },
    ["img_xzdq"] = { ["varname"] = "img_xzdq" },
    ["btn_ok"]   = { ["varname"] = "btn_ok",   ["events"] = { { event = "click", method = "onClickOK"    } } },
    ["btn_back"] = { ["varname"] = "btn_back", ["events"] = { { event = "click", method = "onClickClose" } } },
}

function ProvinceMapView:onCreate(canClose)
    -- 初始化
    self:init(canClose)
    -- 初始化View
    self:initView()
    -- 地图动画
    if self.canClose then
        self:loadChinaMap()
    end
end

function ProvinceMapView:init(canClose)
    -- sv_map触碰事件被关闭，用于阻止向下点击
    local touchPanel = ccui.Layout:create()
    touchPanel:setContentSize(cc.size(display.width, display.height))
    touchPanel:setTouchEnabled(true)
    self:addChild(touchPanel, -1)

    self.canClose = canClose
    -- 包配置地区( 所有地区 )
    self._areaConfig = GameApp:getAreaConfig()
    -- 云动画
    self.animation = self.resourceNode_["animation"]
    self:runAction(self.animation)
    self.sv_map:setTouchEnabled(false)
    self._btnTouchEvent = false
    self.animation:setFrameEventCallFunc(function(frame)
        if not frame then return end
        local event = frame:getEvent()
        if event == "svmove" then
            if self._isAutoSelect then
                self:doAutoSelectAnimation()
                self._isAutoSelect = false
            else
                -- 初始化地图显示至左下角
                self.sv_map:jumpToBottomLeft()
                self.nd_tips:setVisible(false)
                self.sv_map:scrollToPercentBothDirection({x = 70, y = 37}, 4, true)
                gg.CallAfter(1, function()
                    if tolua.isnull(self) then return end
                    self.sv_map:setTouchEnabled(true)
                    self._btnTouchEvent = true
                end)
            end
        end
    end)
    -- 当前选择的省份按钮
    self._selectNode = nil
end

function ProvinceMapView:initView()
    self.sv_map:setContentSize(cc.size(display.width, display.height))
    self.nd_tips:setContentSize(cc.size(display.width, display.height))
    self.img_tips:setPositionX(display.cx)
    self.img_tips:setScale(math.min(display.scaleX, display.scaleY))
    self.btn_ok:setPositionX(display.cx)
    -- 隐藏滚动条
	self.sv_map:setScrollBarEnabled(false)
	-- 初始化地图显示至左下角
    self.sv_map:jumpToPercentBothDirection({x = 70, y = 37})
    -- 设置云节点位置
    self.nd_cloud:setPosition(cc.p(display.cx, display.cy))
    local sx = gg.IIF(gg.isWideScreenPhone, display.width / 1280, display.scaleX)
    self.nd_cloud:setScaleX(sx)
    self.nd_cloud:setScaleY(display.height / 720)
    -- 设置关闭按钮
    self.btn_back:setPositionY(display.height - 60)
    self.btn_back:setVisible(self.canClose)
    -- 根据配置表来显示全国按钮
    self:setBtnsShow()
    -- 初始化省份选择按钮
    self:initBtns()
    -- 地区选择成功通知
    self:addEventListener(gg.Event.HALL_SELECT_AREA, handler(self, self.onClickClose))

    self.img_xzdq:setPositionX(gg.IIF(self.canClose, 190, 120))
    self.img_xzdq:setPositionY(display.height - 60)
end

-- 初始化动画
function ProvinceMapView:loadChinaMap()
    self.nd_tips:setVisible(false)
    -- 播放云动画
    if self.animation then
        self.animation:gotoFrameAndPlay(90, 180, 90, false)
    end
end

function ProvinceMapView:setBtnsShow()
    local provinceTb = {}
    for k,v in pairs(self._areaConfig) do
        if k > 9 and k < 100 then
            table.insert(provinceTb, k)
        end
    end

    local function checkExist(id)
        for k,v in pairs(provinceTb) do
            if v == id then
                return true
            end
        end
        return false
    end

    for k,btn in pairs(self.map_btns:getChildren()) do
        if not checkExist(btn:getTag()) then
            if IS_REVIEW_MODE then
                -- 审核模式下，未开放的地区不显示
                btn:setVisible(false)
            else
                local btn_bg = btn:getChildByName("btn_bg")
                btn_bg:setSpriteFrame("hall/map/btn_anniu_lv.png")
            end
        end
    end
end

function ProvinceMapView:initBtns()
    self.mBtns = self.map_btns:getChildren()
    local function eventFunc(touch, event)
        if not self._btnTouchEvent then return end
        local type = event:getEventCode()
        if type == 0 then
            self._beginTime = socket.gettime()
            self._beginPos = touch:getLocation()
            self:onTouchBegan(touch)
        	return true
        elseif type == 2 then
            self._endTime = socket:gettime()
            self._endPos = touch:getLocation()
            if not self._selectNode then return end
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

function ProvinceMapView:onTouchBegan(touch)
    self._selectNode = nil
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
    self._selectNode = selectNode
    local btn_bg = self._selectNode:getChildByName("btn_bg")
    btn_bg:setScale(1.2)
end

function ProvinceMapView:onTouchEnded(touch)
    if not self._selectNode:isVisible() then
        -- 不可见的按钮不响应事件
        return
    end

    local btn_bg = self._selectNode:getChildByName("btn_bg")
    btn_bg:setScale(1)

    local touchTime = checkint(self._endTime) - checkint(self._beginTime)
    local distance = cc.pGetDistance(self._beginPos, self._endPos)
    if checkint(touchTime) > 1 or checkint(distance) > 50 then
        return
    end

    local provinceID = self._selectNode:getTag()
    local provinceName = self._areaConfig[provinceID]
    if not provinceName then
        printf("按钮的tag值设置错误了或者没有该地区配置：", provinceID)
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "暂未开放，敬请期待！")
        return
    end

    if self._ndBlink then
        self._ndBlink:removeFromParent()
        self._ndBlink = nil
    end
    self._ndBlink = self:createBlinkNode()
    self._selectNode:addChild(self._ndBlink, -10)

    -- 记录玩家选择的省份
    cc.exports.USER_AREA_CODE = provinceID
    -- 打开选择市的界面
    -- 如果配置了对应的省级地图资源，则显示地图版选择地区
    local areaView
    if Helper.IsFileExist(string.format("res/hall/map/map_%d/btn_%d.png", provinceID, provinceID)) then
        areaView = self:getScene():createView("login/AreaMapView", true)
    else
        areaView = self:getScene():createView("login/AreaSelectView", true)
    end
    areaView:setName("login/AreaMapView")
    areaView:pushInScene()
    areaView:setCloseFunc(handler(self, self.onClickClose))
end

-- 关闭按钮点击事件
function ProvinceMapView:onClickClose(sender)
    self:removeSelf()
end

function ProvinceMapView:onClickOK(sender)
    -- 禁用按钮防止反复点击
    self.btn_ok:setEnabled(false)
    if self.animation then
        self.animation:gotoFrameAndPlay(0, 180, 0, false)
    end
end

function ProvinceMapView:createBlinkNode( )
    local ndBlink = cc.Sprite:createWithSpriteFrameName("hall/map/faguang.png")
    ndBlink:setAnchorPoint(cc.p(0.5, 0))
    ndBlink:setPositionY(5)

    local blinkAct = cc.Sequence:create(cc.FadeTo:create(0.8, 0), cc.FadeTo:create(0.8, 255))
    ndBlink:runAction(cc.RepeatForever:create(blinkAct))

    return ndBlink
end

function ProvinceMapView:getViewZOrder()
    return 9210
end

-- 设置自动选地区参数
-- @param region 省码
-- @param city 城市码
-- @param district 地区码
function ProvinceMapView:showAutoSelectAnimation(region, city, district)
    printf("播放自动选区动画")
    self.btn_ok:setVisible(false)
    self.img_tips:setVisible(false)
    self:onClickOK()
    self:setVisible(true)
    self._isAutoSelect = true
    self._region = region
    self._city = city
    self._district = district
end

function ProvinceMapView:setMapButtonEnable(isEnable)
    printf("隐藏选区按钮")
    self.btn_ok:setVisible(isEnable)
    self.img_tips:setVisible(isEnable)
    self.img_xzdq:setVisible(isEnable)
end

-- 播放自动选区动画
function ProvinceMapView:doAutoSelectAnimation()
    self.sv_map:jumpToBottomLeft()
    self.nd_tips:setVisible(false)
    -- 创建一个新的遮罩层
    local selectBtn = self:findNode("btn_"..self._region)
    local maskLayer = cc.LayerColor:create(cc.c4b(0, 0, 0, 127))
    maskLayer:setContentSize(display.width*2, display.height*2)
    selectBtn:getParent():addChild(maskLayer)
    local pos = selectBtn:convertToWorldSpace(cc.p(0, 0))
    local x = pos.x;
    local y = pos.y;
    local actionTime = 1.2
    local scale = 2
    self.sv_map:getInnerContainer():setIgnoreAnchorPointForPosition(false)
    self.sv_map:getInnerContainer():setAnchorPoint(0, 0)
    local animMove = cc.MoveTo:create(actionTime, cc.p(-x * scale + display.width/2, -y * scale + display.height/2))
    local animScale = cc.ScaleTo:create(actionTime, scale)

    scale = 5
    actionTime = 0.4
    local stopTime = 1.6
    local fadeEnd = cc.FadeTo:create(actionTime, 0)
    local animMove2 = cc.MoveTo:create(actionTime, cc.p(-x * scale + display.width/2, -y * scale + display.height/2))
    local animScale2 = cc.ScaleTo:create(actionTime, scale)
    local anim = cc.Sequence:create(cc.DelayTime:create(1), cc.Spawn:create(animMove, animScale), cc.CallFunc:create(function()
        if selectBtn then
            selectBtn:setLocalZOrder(999)
            local tmpImg = selectBtn:getChildByName("btn_bg")
            local moveUp = cc.MoveBy:create(0.2, cc.p(0, 20))
            local moveDown = cc.MoveBy:create(0.2, cc.p(0, -20))
            local anim = cc.RepeatForever:create(cc.Sequence:create(moveUp, moveDown))
            tmpImg:runAction(anim)
        end
    end), cc.DelayTime:create(stopTime), cc.CallFunc:create(function ( ... )
        if selectBtn then
            selectBtn:getChildByName("btn_bg"):stopAllActions()
        end
    end), cc.Spawn:create(animMove2, animScale2, fadeEnd), cc.CallFunc:create(function()
        GameApp:doSelectRegionEvent(self._district)
    end))
    self.sv_map:getInnerContainer():runAction(anim)
end

return ProvinceMapView