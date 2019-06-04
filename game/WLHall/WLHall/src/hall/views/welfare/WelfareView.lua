

local M = class("WelfareView", cc.load("ViewPop"))
M.RESOURCE_FILENAME = "ui/welfare/welfareView.lua"
M.RESOURCE_BINDING =
{
    ["panel"] = { ["varname"] = "panel"},
    ["nd_view"] = { ["varname"] = "nd_view"},

    ["btn_close"]  = {["varname"] = "btn_close",  ["events"] = {{event = "click", method = "onClickClose" }}},
    ["btn_kefu"]  = {["varname"] = "btn_kefu",  ["events"] = {{event = "click", method = "onClickKefu" }}},
}

local WelfareActive = import(".WelfareActive")
local WelfareViewData   = require("hall.models.WelfareData")

--  参数：infoTab {"活动id", "活动id"}
--  例如：infoTab = {"share", "bind"}
function M:onCreate(infoTab)
    self._gameInfo = infoTab
    self._activeNodeTab = {}
    --适配
    self:resetLayout()
    --注册事件
    self:registerCommonEventListener()
end

function M:onEnter()
    gg.UserData:checkLoaded(function()
        if tolua.isnull(self) then return end
        WelfareViewData:initDataInfo(self._gameInfo)
        --拉取本地数据,--只有游戏里面调用才有传参
        self._welfareDataTb = checktable(WelfareViewData:GetWelfareTable())
        --初始化动画
        self:initAnite()
        --初始化活动的界面
        self:initView()
    end)
end

--动画的初始化
function M:initAnite()
    local node = require("ui.welfare.welfareAnimate").create()
    self.root = node.root
    self.root:removeFromParent()
    self.animation = node.animation
    self:runAction(self.animation)
    self.nd_view:addChild(self.root,1)

    local FrameEventTimeline = ccs.Timeline:create()
    local localFrame = ccs.EventFrame:create()
    localFrame:setFrameIndex(85)
    localFrame:setTween(false)
    localFrame:setEvent("aniEnd")
    FrameEventTimeline:addFrame(localFrame)

    self.animation:addTimeline(FrameEventTimeline)
    FrameEventTimeline:setNode(self.root:getChildByName("Panel_bg"))
    self.root:setVisible(false)
end

function M:registerCommonEventListener()
    --福利活动开启的通知，实名
    self:addEventListener(gg.Event.WELFARE_ACTIVITY, handler(self, self.updateActiveNode))
    -- 手机激活通知
    self:addEventListener(gg.Event.HALL_ACTIVATE_USER_PHONE, handler(self, self.updateActiveNode))
    -- 首充通知
    self:addEventListener(gg.Event.ON_POP_PAY, handler(self, self.updateActiveNode))
end

function M:resetLayout()
    self:setScale(math.min(display.scaleX, display.scaleY))
end

--更新数据
function M:updateActiveNode(Object, activeId)
    --更新的开关
    WelfareViewData:initActiveSwitch()
    --游戏进来的要取需要的活动
    if self._gameInfo then
        WelfareViewData:filtrateGameData()
    end
    --更新活动的数据
    self._welfareDataTb = checktable(WelfareViewData:GetWelfareTable())

    --更新节点数据
    self:updateViewNode()
    --
    local info = WelfareViewData:getWelfareAcitveInfo(activeId)
    --解锁的活动完成
    if activeId and WelfareViewData:isActiveSatue(info.desc.unlocakContentId) then
        --动画标题
        self.root:findNode("txt_name"):setString(info.desc.statusHints)
        --播放动画
        gg.InvokeFuncNextFrame(function()
            local winPos = self._activeNodeTab[activeId]:getParent():convertToWorldSpace(cc.p(self._activeNodeTab[activeId]:getPositionX(),self._activeNodeTab[activeId]:getPositionY()))
            local pos = self.nd_view:convertToNodeSpace(winPos)
            local x = pos.x -1
            local y = pos.y
            self.root:setPosition(cc.p(x,y))
            self:startIcoAction()
        end)
     end
end

function M:updateViewNode()
    local nCol = 4;                              -- 列数
    local itemCnt = self:getTabCount()

    local Row = math.ceil(itemCnt / nCol )       -- 行数
    local innerContainerSize = Row * 214
    -- 设置滚动层滑动区域
    local sizeView = cc.size(self._pScrollView:getContentSize().width, innerContainerSize)
    self._pScrollView:setInnerContainerSize(sizeView)
    local Index = 0
    --
    for i ,v in ipairs (self._welfareDataTb) do
        if v.desc.isOpen then
           Index = Index + 1
           local item = self._activeNodeTab[v.activeId]
           if item then
                item:setInfo(v)
                item:setPosition(cc.p((Index-1) % 4 * (item:getNodeSize().width - 11), (self._pScrollView:getInnerContainerSize().height) - math.floor((Index-1)/4) * (item:getNodeSize().height-5)))
                self._activeNodeTab[v.activeId] = item
           end
        end
    end
    --签到的提示
    self:showAni()
end

function M:showAni()
    gg.UserData:checkLoaded(function()
        if tolua.isnull(self) then return end

        --分享有礼提示
        if gg.UserData:GetShareGiftStatus() == 3 then
            self._activeNodeTab["share"]:showAnite()
        else
            self._activeNodeTab["share"]:stopAnite()
        end
    end)
    local taskid,statue = WelfareViewData:isShowSign()
    if taskid == 94 then
       if not statue then
           self._activeNodeTab["xsqd"]:showAnite()
       else
          self._activeNodeTab["xsqd"]:stopAnite()
       end
    else
        if not statue then
            self._activeNodeTab["mrqd"]:showAnite()
        else
            self._activeNodeTab["mrqd"]:stopAnite()
        end
    end
end

function M:initView()
    self._pScrollView = self:createScrollView()
    self._pScrollView:setPosition(cc.p(19, 25))
    self.nd_view:addChild(self._pScrollView)

    self:addWelfare(self._pScrollView)
end

function M:addWelfare(pScrollViewNode)
    pScrollViewNode:removeAllChildren()
    local nCol = 4;                              -- 列数
    local itemCnt = self:getTabCount()

    local Row = math.ceil(itemCnt / nCol )       -- 行数
    local innerContainerSize = Row * 214

    -- 设置滚动层滑动区域
    local sizeView = cc.size(pScrollViewNode:getContentSize().width, innerContainerSize)
    pScrollViewNode:setInnerContainerSize(sizeView)
    local Index = 0
    for i ,v in ipairs (self._welfareDataTb) do
        if v.desc.isOpen then
            Index = Index + 1
            local item = WelfareActive.new();
            item:setInfo(v)
            item:setPosition(cc.p((Index-1) % 4 * (item:getNodeSize().width - 11), (pScrollViewNode:getInnerContainerSize().height) - math.floor((Index-1)/4) * (item:getNodeSize().height -5)))
            pScrollViewNode:addChild(item);
            self._activeNodeTab[v.activeId] = item
        end
    end
    --签到的提示
    self:showAni()
end

function M:createScrollView()
    local pScrollView = ccui.ScrollView:create()
    pScrollView:setClippingEnabled(true)
    pScrollView:setBackGroundColorType(1)
    pScrollView:setBackGroundColor({r = 0, g = 0, b = 0})
    pScrollView:setBackGroundColorOpacity(0)
    pScrollView:setAnchorPoint(0,0)
    pScrollView:setContentSize(cc.size(931, 430))
    -- 开启回弹效果---item的数量大于8才开启
    pScrollView:setBounceEnabled(self:getTabCount() > 8 and true or false)
    -- 隐藏滚动条
    pScrollView:setScrollBarEnabled(false)
    return pScrollView
end

function M:getTabCount()
    local count = 0
    for i,v in ipairs(self._welfareDataTb) do
        if v.desc.isOpen then
            count = count + 1
        end
    end
    return count
end

function M:onClickClose()
    self:removeSelf()
end

function M:onClickKefu()
    gg.AudioManager:playClickEffect()
    device.callCustomerServiceApi(ModuleTag.FreeWelfare)
    return
end

-- 显示动画节点并播放动画
function M:startIcoAction()
    if self.animation and self.root then
        self.root:setVisible(true)
        --帧事件结束回调
        self.animation:setFrameEventCallFunc(function(frame)
            if not frame then return end
            local event = frame:getEvent()
            if event == "aniEnd" then
                self:endIcoAction()
            end
        end)
        self.animation:play("welfareAni", false)
    end
end

-- 隐藏动画节点
function M:endIcoAction()
    if self.root then
        self.root:setVisible(false)
    end
end

return M
