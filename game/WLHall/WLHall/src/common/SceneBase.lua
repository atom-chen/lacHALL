--
-- Author: 场景基类
-- Date: 2016-09-19 16:51:45

local SceneBase = class("SceneBase", cc.Scene)
local director = cc.Director:getInstance()
local payLoadingMsgFmt = "支付结果确认中，请稍候(%d)..."
local payLoadingTimeout = 5
local YYSound = require("src.libs.yy_utils.YYSound")

local BROADCAST_MSG = "健康游戏，严禁赌博！严禁私下交易道具或任何赌博行为！一经发现永久封号！"

function SceneBase:ctor(sceneName, sceneBgImg, viewrootpath, context)
    if GameApp and GameApp.setRuningScene then
        GameApp:setRuningScene(self)
    end
    self.name_ = sceneName
    self.packageRoot = viewrootpath or "hall.views"
    self.viewStack_ = gg.Stack.new()
    self:enableNodeEvents()
    gg.RegisterKeyBackEvent(self, handler(self, self.onKeyBackClicked_))
    self.bg_ = nil
    self:setSceneBackground(sceneBgImg)
    -- 测试用 设备电池电量变化事件 如需要 重写此函数 enableBatteryChangeEvent 开启电量监听
    -- self:enableBatteryChangeEvent()
    -- self:disableBatteryChangeEvent()

    -- PhoneState 变化事件 如需要 重写此函数 enableBatteryChangeEvent 开启状态变化通知
    self:enablePhoneStateChangeEvent()

    self:enableNetworkChangeEvent()

    -- 用于记录界面弹出的吐司提示个数
    self._toastCount = 0
    -- 用于存储存在着的吐司个数
    self._toast = {}

    self._rootCnt = rawget(self.class, "SCENE_ROOT_COUNT")
end

function SceneBase:disableNetworkChangeEvent()
     self:getEventDispatcher():removeCustomEventListeners("NETWORK_STATE_CHANGED_EVENT")
end

function SceneBase:enableNetworkChangeEvent()
    local networklistener = cc.EventListenerCustom:create("NETWORK_STATE_CHANGED_EVENT", handler(self,self.onNetworkChanged_))
    self:getEventDispatcher():addEventListenerWithSceneGraphPriority(networklistener, self)
end

--网络状态变化通知 -1 socket 错误, 0 无网络。1 wifi 网络。2 移动网络
function SceneBase:onNetworkChanged_(event)

    local nstate=  checkint(event:getUserData())
    if nstate~=self.last_netstate_ then
        if nstate~=NetworkStatus.None then --显示网络切换吐司提示
            self:callAfter(0, function() self:showToast(NETWORK_STATE[nstate]) end)
        end
        GameApp:dispatchEvent(gg.Event.NETWORK_ERROR,NET_ERR_TAG_SWITCH,nstate)
    end
    self.last_netstate_=nstate
end

-- 设备电池电量变化事件 如需要 重写此函数
-- enableBatteryChangeEvent 开启电量监听
-- disableBatteryChangeEvent 关闭监听
function SceneBase:onBatteryChanged(level,state)
    -- printf( Helper.GetDeviceBatteryLevel())
    printf("SceneBase:onBatteryChanged 电池电量。 %s  电池等级 %s",level,state)
end

function SceneBase:onPhoneStateChanged(state)
    if state == 1 then
        -- 回到游戏，检查是否在支付中。如果是，需要弹出提示
        if cc.exports.isPaying then
            GameApp:dispatchEvent(gg.Event.SHOW_PAY_LOADING, string.format( payLoadingMsgFmt, payLoadingTimeout ), payLoadingTimeout)
        end
        cc.exports.isPaying = false
    end
end

--app 进入后台事件回调 如需要 重写此函数
function SceneBase:onAppEnterBackground()
    printf("-----SceneBase onAppEnterBackground------ " ..tostring(self.name_)..", "..tostring(self))
end

function SceneBase:onAppEnterBackground_()
    cc.Node.onAppEnterBackground_(self)
    if device.platform ~= "mac" and yvcc then
        YYSound:setCurBackground()
        -- 停止语音播放
        yvcc.YVTool:getInstance():stopPlay()
    end
end

--app 从后台进入前台事件回调 如需要 重写此函数  difftime 程序在后台等待时间差
function SceneBase:onAppEnterForeground(difftime)
    printf("-----SceneBase onAppEnterForeground------ %s %s %s" ,tostring(self.name_),tostring(self),tostring(difftime))
    -- 清除 app 右上角的角标
    gg.NotificationHelper:cleanBadge()
end

--设置场景背景
function SceneBase:setSceneBackground(impath)
    if not impath then
        return
    end
    if self.bg_ and not tolua.isnull(self.bg_) then
        self.bg_:removeFromParent();
        self.bg_ = nil
    end
    self.bg_ = cc.Sprite:create(impath):addTo(self):move(display.cx, display.cy)
    local scalex = display.width / self.bg_:getContentSize().width
    local scaley = display.height / self.bg_:getContentSize().height
    self.bg_:setScale(math.max(scalex, scaley))
end

-- 参数 调用目录基于views 目录下  1 视图名字,2 popview是否模糊背景 3,
function SceneBase:createView(viewName, ...)
    assert(self.packageRoot, "packageRoot is nil");
    assert(viewName, "viewName is nil")
    local viewPackageName = string.format("%s.%s", self.packageRoot, viewName)
    local status, viewClass = xpcall(function()
        return require(viewPackageName)
    end, function(msg)
        if not string.find(msg, string.format("'%s' not found:", viewPackageName)) then
            printf("load package error:", msg)
        end
    end)
    if status then
        return viewClass.new(self, viewName, ...)
    end
end

-- 弹出当前场景
function SceneBase:popSelf()
    director:popScene()
end

-- 压入场景
function SceneBase:pushSelf()
    director:pushScene(self)
    return self
end

function SceneBase:run(onEnterCallback, transitionType, time, more)
        -- printf("SceneBase run scene----------- ".. self.name_)
    self.viewStack_:clear()
    if onEnterCallback then
        self:onNodeEvent("enter", onEnterCallback)
    end
    if self.onRun then  self:onRun()    end
    display.runScene(self, transitionType, time, more)
    return self
end

--viewObj  ,压栈 ,invisiblePre 是否隐藏前一个窗口
function SceneBase:pushViewInScene(viewObj, invisiblePre)
    return self:addViewInScene(viewObj, true, invisiblePre)
end

-- 当前场景 显示视图对象  viewObj  ,isPush  是否压栈 ,invisiblePre 是否隐藏前一个窗口
function SceneBase:addViewInScene(viewObj, isPush, invisiblePre)
    if viewObj then
        if isPush then
            if invisiblePre then
                local pView = self.viewStack_:peek()
                if pView then pView:setVisible(false) end
            end
            viewObj:addRemoveListener(function()
                self.viewStack_:delete(viewObj)
                local v = self.viewStack_:peek()
                if v then v:setVisible(true) end
              end)

            if not viewObj.getViewZOrder or self.viewStack_:size() == 0 then
                -- 界面未指定 zorder 或者栈为空，直接 push
                self.viewStack_:push(viewObj)
            else
                -- 界面指定了 zorder，找到合适的位置插入
                local viewZOrder = viewObj:getViewZOrder()
                local theIdx
                self.viewStack_:rloop(function(obj, idx)
                    local checkZ = obj:getLocalZOrder()
                    if not theIdx and viewZOrder >= checkZ then
                        theIdx = idx + 1
                    end
                end)
                theIdx = gg.IIF(theIdx, theIdx, 1)
                if theIdx > self.viewStack_:size() then
                    self.viewStack_:push(viewObj)
                else
                    self.viewStack_:insert(viewObj, theIdx)
                end
            end
            printf("视图 %s 进栈,当前数量 %d", viewObj:getName(), self.viewStack_:size())
        end
        self:addChild(viewObj)
        if viewObj.getViewZOrder then
            viewObj:setLocalZOrder(viewObj:getViewZOrder())
        end
        return viewObj
    else
        printf("SceneBase addViewInScene viewobj  nil ")
    end
end

function SceneBase:removeAllPopViews()
    while( self.viewStack_:size()>1 )
    do
        local pop = self.viewStack_:peek()
        if pop then
            pop:removeSelf()
        end
    end
    return self
end

-- 返回是否有弹出界面
function SceneBase:hasPopView()
    return self.viewStack_:size() > 1
end

-- 从当前场景中删除视图层
function SceneBase:removeViewFromCurScene(viewName)
    local view = self:getChildByName(viewName)
    if view then
        view:removeSelf()
    end
end

--[[
* @brief 设置 Toast 背景图片
* @pram img 图片字符串，以 # 开头表示为 plist 中的图片，否则表示单独的图片
]]
function SceneBase:setToastImg(img)
    self.toastImg = img
end

--[[
* @brief 显示吐司 自动消失
* @pram node 所需添加的场景
* @pram params 参数
        params.type 显示的类型 不传或者0为队列型模式,1为常规模式
        params.location 吐司初始显示的位置
        params.img 吐司提示的背景图片
        params.useSystemFont bool 值，true 表示使用系统字体
]]
function SceneBase:showToast( text, params ,node )
    params = params or {}
    local tType = params.type or 0
    params.img = params.img or self.toastImg
    node = node or self
    if tType ~= 1 then
        self:showListToast( node, text, params )
    else
        local Toast = require("common.widgets.Toast")
        Toast.new( node, text, 10, 10, params ):show()
    end
end

function SceneBase:showListToast( parent, txt, params )
    if self._toastCount > 8 then
        printf("吐司提示过多，不再提示！！！")
        return
    end

    local Toast = require("common.widgets.Toast")

    local pDirector = cc.Director:getInstance()
    local actionManager = pDirector:getActionManager()

    local callback = function( toast )
        self._toastCount = self._toastCount-1

        for i,v in ipairs(self._toast) do
            if v==toast then
                table.remove(self._toast, i)
            end
        end

        for i,v in ipairs(self._toast) do
            if i<=3 then
                v:runAction(cc.EaseSineOut:create(cc.MoveBy:create(1, cc.p(0, 50))))
                actionManager:resumeTarget( v:getChildByName( "toast_txt" ) )
                actionManager:resumeTarget( v:getChildByName( "toast_bg" ) )
            end
        end

    end

    params = checktable(params)
    params.img = params.img or self.toastImg
    local item = Toast.new(parent, txt, 10, 10, params):showListToast( callback, self._toastCount )
    table.insert( self._toast, item )
    self._toastCount = self._toastCount+1
    actionManager:pauseTarget( item:getChildByName( "toast_txt" ) )
    actionManager:pauseTarget( item:getChildByName( "toast_bg" ) )
    if self._toastCount<4 then
        actionManager:resumeTarget( item:getChildByName( "toast_txt" ) )
        actionManager:resumeTarget( item:getChildByName( "toast_bg" ) )
    end

end

function SceneBase:showMsgDialog( text, fnCallback, args)
    printf("-----------onShowMsgDialog---------")
    args = args or {}
    local params = {}
    table.merge(params, args)
    local msgView = require("common.widgets.MessageDialog"):create(self, params.name , text, fnCallback, params):show()
    return msgView
end

-- 显示页面加载动画效果
function SceneBase:showLoading(msg, timeout,removecallback, disabletimeout, cancelEnable, swallowBack)
    if (not msg) or (string.len(msg) == 0) then
        -- 是要隐藏 loading 界面，需要将所有的 loading 隐藏
        gg.ShowLoading(self)
        self.viewStack_:loop(function(viewObj)
            if not tolua.isnull(viewObj) then
                viewObj:showLoading()
            end
        end)
    else
        local viewObj = self.viewStack_:peek()
        if not tolua.isnull(viewObj) then
            return viewObj:showLoading(msg, timeout,removecallback, disabletimeout, cancelEnable, swallowBack)
        else
            return gg.ShowLoading(self,msg, timeout,removecallback, disabletimeout, cancelEnable, swallowBack)
        end
    end
end

-- 显示支付结果确认中的加载界面
function SceneBase:showPayLoading(msg, timeout)
    if (not msg) or (string.len(msg) == 0) then
        -- 移除 loading 界面
        if self._payLoadingNode then
            self._payLoadingNode:removeSelf()
            self._payLoadingNode = nil
        end

        if self._payLoadingTimer then
            self._payLoadingTimer:killAll()
            self._payLoadingTimer = nil
        end
    else
        timeout = timeout or payLoadingTimeout
        -- 设置一个定时器
        if self._payLoadingTimer then
            self._payLoadingTimer:killAll()
        else
            self._payLoadingTimer = require("common.utils.Timer").new()
        end
        self._payLoadingTimer:addCountdown(handler(self,self.updatePayLoading), timeout, 1)

        -- loading 移除的回调
        local onRemoveCallBack = function(...)
            self._payLoadingNode = nil
        end

        -- 显示 loading 界面
        local parent = self.viewStack_:peek()
        if not parent then
            print("---- no view in stack ----")
            parent = self
        end
        if self._payLoadingNode then
            self._payLoadingNode:show(msg, timeout, onRemoveCallBack, false, false, true)
        else
            self._payLoadingNode = require("common.widgets.WaitingDialog"):create(msg, timeout, onRemoveCallBack, 0, false, false, true)
            self._payLoadingNode:setName("PayLoading")
            parent:addChild(self._payLoadingNode)
        end
    end
end

function SceneBase:updatePayLoading(cusor, dt, data, timerId)
    if cusor <= 0 then
        self:showPayLoading()
    else
        self:showPayLoading(string.format( payLoadingMsgFmt, cusor ), cusor)
    end
end

-- 播放充值成功动画
function SceneBase:playRechargeSuccessAni(event, result)
    if result.status ~= 0 then return end
    local rechargeAni = require("common.widgets.RechargeSuccessAni"):create()
    rechargeAni:pushInScene()
    rechargeAni:setName("RechargeAni")
    rechargeAni:playAni()
end

function SceneBase:addEventListener(eventName, listener)
    if GameApp and GameApp.addEventListener then
       return  GameApp:addEventListener(eventName, listener, self)
    end
end

--返回按键处理函数  游戏中退出提示需要重写此函数实现
function SceneBase:onKeyBackClicked()
    GameApp:onKeyBackClicked()
end


function SceneBase:removeChildrenByName(...)
    local children={...}
    for _,v in ipairs(children) do
        if v and #v>0 then
            local child= self:getChildByName(v)
            if child then
                child:removeSelf()
            end
        end
    end
end

function SceneBase:onKeyBackClicked_(rootCount)
    rootCount = rootCount or self._rootCnt or 1

    local stack = self.viewStack_
    local pView = stack:peek()
    if pView and (not tolua.isnull(pView) )and stack:size() > rootCount then
        local ret, removed = pView:keyBackClicked_()
        if ret and removed then
            stack:delete(pView)
            local v = stack:peek()
            if v then v:setVisible(true) end
        end
    else
        self:onKeyBackClicked()
    end
end

-- 场景管理器启动
function SceneBase:onEnter_()
    if GameApp and GameApp.setRuningScene then
        GameApp:setRuningScene(self)
    end

    -- 非登录界面与更新界面，开启广播定时器
    if self.name_ ~= "LoginScene" and self.name_ ~= "LaunchScene" then
        self:startBroadcastTimer()
    end

    -- printf("-----------------SceneBase:onEnter--------" .. self.name_..", "..tostring(self))
    self:addEventListener(gg.Event.BROADCAST_SYSTEM_MESSAGE, handler(self, self.onSystemBoadcastMsg_))
    self:addEventListener(gg.Event.SHOW_MESSAGE_DIALOG, handler(self, self.onShowMsgDialog_))
    self:addEventListener(gg.Event.SHOW_VIEW, handler(self, self.onShowView_))
    self:addEventListener(gg.Event.SHOW_TOAST, function(_, ...) self:showToast(...) end)
    self:addEventListener(gg.Event.SHOW_LOADING, function(_, ...)  if tolua.isnull(self) then return end self:showLoading( ...)  end)
    self:addEventListener(gg.Event.SHOW_PAY_LOADING, function(_, ...)  self:showPayLoading( ...)  end)
    self:addEventListener(gg.Event.DISABLE_APPENTER, function(_, ...)  self.isdisableswitch_=true end)
    -- 定时赛提醒通知
    self:addEventListener(gg.Event.HALL_MATCH_SOON_START_NOTIC,   handler(self, self.onEventMatchStartNotic))
    -- 播放充值成功动画
    self:addEventListener(gg.Event.ON_PAY_RESULT, handler(self, self.playRechargeSuccessAni))
    self:enableAppEvents()
    cc.Node.onEnter_(self)
end

-- 场景管理器退出
function SceneBase:onExit_()
    -- printf("-----------------SceneBase:onExit-------- " ..tostring(self.name_)..", "..tostring(self))
    if GameApp and GameApp.removeEventListenersByTag then
        GameApp:removeEventListenersByTag(self)
    end
    if GameApp and GameApp.setRuningScene then
        GameApp:setRuningScene(nil)
    end

    -- 停掉广播定时器
    self:endBroadcastTimer()

    self:disableAppeEvents()
    cc.Node.onExit_(self)
end

-- 进行广播
function SceneBase:doGambleBroadcast()
    if not IS_REVIEW_MODE then
        -- 审核模式不显示广播
        self:_doShowBroadcastMsg(BROADCAST_MSG)
    end

    if hallmanager and hallmanager.userinfo and checkint(USER_TIRE_TIME) ~= -1 then
        -- 刷新玩家的在线时间
        cc.exports.USER_TIRE_TIME = checkint(USER_TIRE_TIME) + (os.time() - checkint(LAST_RECORD_TIRETIME_STAMP))
        cc.exports.LAST_RECORD_TIRETIME_STAMP = os.time()

        -- 如果是在大厅场景，进行防沉迷检查
        if "HallScene" == self.name_ then
            hallmanager:CheckTireTime()
        end
    end
end

-- 设置定时器进行广播
function SceneBase:startBroadcastTimer()
    -- 先停掉之前的定时器
    self:endBroadcastTimer()

    self._broadcastTimer = require("common.utils.Timer").new()
    -- 10分钟广播一次
    self._broadcastTimer:start(handler(self, self.doGambleBroadcast), 600)
end

-- 停止广播定时器
function SceneBase:endBroadcastTimer()
    if self._broadcastTimer then
        self._broadcastTimer:killAll()
        self._broadcastTimer = nil
    end
end

function SceneBase:onCleanup_()
    self:disablePhoneStateChangeEvent()
    self:disableNetworkChangeEvent()
    if self._payLoadingTimer then
        self._payLoadingTimer:killAll()
        self._payLoadingTimer = nil
    end
    self.viewStack_:clear()
    -- printf("------------SceneBase:onCleanup " .. self.name_..", "..tostring(self))
    cc.Node.onCleanup_(self)
end

--- args table {push 是否压栈 popup 是否是弹出模式}
function SceneBase:onShowView_(event, viewName, args, ...)
    -- printf("onShowView_----------------------------" .. self.name_ .. " , " .. viewName)
    args = checktable(args)
    if self:getChildByName(viewName) then
        printf("%s 界面已存在，不再创建新的界面！", viewName)
        return
    end

    local view = self:createView(viewName, ...)
    if view then
        view:setName(viewName)
        local invisiblePre = not args.popup
        return self:addViewInScene(view, args.push, invisiblePre)
    end
end

-- 播放广播消息
function SceneBase:showSystemBroadcastMsg(text, type, speed)
    self:onSystemBoadcastMsg_(nil, text, type, speed)
end

--显示广播消息
function SceneBase:onSystemBoadcastMsg_(event,text,type,speed)
    text = string.gsub(tostring(text), "元宝", "礼品券")
    -- printf("[广播消息]--- "..text..checkstring(type))
    if SYSTEM_MESSAGE_TYPE.PRINT_MSG_TYPE_HALL == type then
        -- 大厅类型，弹出确认框
        GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG, text, nil, {title="系统消息"})
    else
        -- 如果滚动通知关闭了，直接返回
        if not GameApp:CheckModuleEnable( ModuleTag.SysMessage ) then
            return
        end

        self:_doShowBroadcastMsg(text,type,speed)
    end
end

function SceneBase:_doShowBroadcastMsg(text, type, speed)
    if not self.broadcastMsg_ then
        local BroadcastMsg = require("common.widgets.BroadcastMsg")
        self.broadcastMsg_ = BroadcastMsg.create()
        self:addChild( self.broadcastMsg_ , 1000 )
        self.broadcastMsg_:setPositionY( display.height )
    end
    self.broadcastMsg_:showMessage( text , type, speed)
end

function SceneBase:onShowMsgDialog_(event, text, fnCallback, args)
    self:showMsgDialog(text, fnCallback, args)
end

--[[
* @brief 比赛开始通知
]]
function SceneBase:onEventMatchStartNotic(event, roomid, groupid, sptime)
    local titletxt = ""
    if hallmanager then
        local roomname = hallmanager.rooms[roomid].name
        titletxt = string.format("您报名的【%s】还有%d分钟就要开赛了，请前往\n游戏大厅内等待比赛", roomname, checkint(sptime) / 60)
    end

    -- 判断是否在游戏场景中
    if tostring(self.name_) == "HallScene" then
        -- 存在不处理
        if self.quitDialog then 
            return 
        end
        -- 直接弹出Dialog
        self.quitDialog = self:showMsgDialog(titletxt, function(bttype)
            if not tolua.isnull(self) then
                self.quitDialog = nil
            end
        end, {mode = gg.MessageDialog.MODE_OK_CANCEL_CLOSE, ok = "知道了"})
    else
        -- 存在不处理
        if self:getChildByName("MatchProt") then
            return
        end

        -- 游戏中使用下滑界面
        local propNode = require("ui/room/match/match_prompt_node.lua").create().root
        local img_bg = propNode:getChildByName("img_bg")
        local winSize = director:getWinSize()
        propNode:setPosition(cc.p(winSize.width / 2, winSize.height))
        propNode:setName("MatchProt")
        self:addChild(propNode)
        
        -- 下滑动画
        img_bg:runAction(cc.EaseSineOut:create(cc.MoveBy:create(0.7, cc.p(0, - img_bg:getSize().height))))

        -- 描述文本
        local txt_title = img_bg:getChildByName("txt_title")
        txt_title:setString(titletxt)

        -- 知道了按钮
        local btn_in = img_bg:getChildByName("btn_in")
        btn_in:setTag(10)

        -- 销毁动画
        local function removeAni()
            local action = cc.Sequence:create(cc.EaseSineOut:create(
                cc.MoveBy:create(0.7, cc.p(0, img_bg:getSize().height))),
                cc.CallFunc:create(function()
                    propNode:removeFromParent()
                    btn_in = nil
                end))
            img_bg:runAction(action)
        end
            
        -- 退赛
        local btn_exit = img_bg:getChildByName("btn_exit")
        btn_exit:addClickEventListener(function(sender, eventType)
            -- 发送取消报名消息
            if hallmanager then
                hallmanager:Pk3UnSignUp(roomid, groupid)
            end
            -- 销毁
            removeAni()
        end)

        -- 知道了按钮事件
        btn_in:addClickEventListener(function(sender, eventType)
            removeAni()
        end)

        -- 注册定时器通知
        self:addEventListener(gg.Event.HALL_MATCH_TIME_UPDATE_NOTIC, function()
            if btn_in then
                local time = btn_in:getTag()
                local txt = btn_in:getChildByName("txt")
                txt:setString(string.format("知道了(%ds)", time))
                btn_in:setTag(time - 1)

                if time <= 0 then
                    removeAni()
                end
            end
        end)
    end
end

function SceneBase:onAppScreenSizeChanged(isLandscape)
    local view = cc.Director:getInstance():getOpenGLView()
    -- printf("view width===%d height==%d", view:getFrameSize().width, view:getFrameSize().height)
    local width, height = view:getFrameSize().width, view:getFrameSize().height
    -- 上下翻转不改变屏幕朝向
    if (isLandscape ~= 0 and height > width) or (isLandscape == 0 and width > height) then
        view:setFrameSize(height, width)
        -- 屏幕大小改变需要重新加载display
        package.loaded["cocos.framework.display"] = nil
        display    = require("cocos.framework.display")
        GameApp:dispatchEvent(gg.Event.SCREEN_SIZE_CHANGE)
    end
end

return SceneBase
