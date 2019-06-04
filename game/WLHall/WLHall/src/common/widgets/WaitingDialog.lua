-- Author: lee
-- Date: 2016-08-29 14:35:59
--

local WaitingDialog = class("WaitingDialog", function()
    return display.newLayer(cc.c4b(0, 0, 0, 100))
    -- return display.newLayer()
end)

local scheduler = cc.Director:getInstance():getScheduler()

--disabletimeout  关闭超时计时器
function WaitingDialog:ctor( msg, timeout, fn, delayshow, disabletimeout, cancelEnable, swallowBack )
    self.disabletimeout_=disabletimeout or false
    self.cancelEnable = cancelEnable or false
    self.swallowBack = swallowBack or false
    self.msgTxt = nil
    self.fn = nil
    self.schedulerID = nil
    self:enableNodeEvents()
    self.delayshow = checkint(delayshow)
    -- gg.RegisterKeyBackEvent( self, handler(self,self.keyBackClicked) )
    -- 延迟显示
    self:initView()
    self:initTouchEvent()
    self:show(msg, timeout, fn, disabletimeout, cancelEnable, swallowBack)
end

function WaitingDialog:initView(...)   
    local loading = require("ui/common/loading.lua").create() 
    self._loadingNode = loading.root    
    self:addChild(loading.root) 
    self:doLayout()
    loading.root:runAction(loading.animation)
    loading.animation:gotoFrameAndPlay(1)
    self.msgTxt = loading.root:getChildByName("txt_msg")

    -- 延迟创建
    self:setVisible( false )
    self:runAction( cc.Sequence:create( cc.DelayTime:create( self.delayshow ),  
                                        cc.CallFunc:create( function() self:setVisible( true ) end ) 
                                      ) )
end

function WaitingDialog:doLayout(rootNode)
    rootNode= rootNode or self:getScene() 
    local size
    if rootNode then
        size = rootNode:getContentSize()  
    else
        size = cc.Director:getInstance():getVisibleSize()
    end   
    if size then
        self:setContentSize(size)
        self._loadingNode:setPosition(size.width / 2, size.height / 2+20)
    end
    return self
end

function WaitingDialog:initTouchEvent()
    self:setTouchEnabled(true)
    local listener = cc.EventListenerTouchOneByOne:create();
    listener:setSwallowTouches(true)
    local onTouchBegin = function(...)
        print("WaitingDialog onTouchBegin")
        return true
    end
    listener:registerScriptHandler(onTouchBegin, cc.Handler.EVENT_TOUCH_BEGAN);
    local eventDispatcher = self:getEventDispatcher() -- 得到事件派发器
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self) -- 将监听器注册到派发器中
end

function WaitingDialog:keyBackClicked()
    if self.cancelEnable then
        self:removeSelf()
    end
    return self.swallowBack, self.cancelEnable
end

function WaitingDialog:onTimeout_()
    self:removeSelf(true)
end

function WaitingDialog:removeSelf(timeout)
    if self.fn and timeout then self.fn(timeout) end
    if not tolua.isnull(self) then
        self:removeFromParent()
    end
end

function WaitingDialog:onCleanup()
    self:releaseScheduler()
end

-- 显示加载 无参数 隐藏
-- msg 提示消息
-- timeout超时时间
-- fn 超时 、 取消回调
function WaitingDialog:show(msg, timeout, fn, disabletimeout, cancelEnable, swallowBack)
    self.fn = fn
    self.disabletimeout_=disabletimeout or false
    self.cancelEnable = cancelEnable or false
    self.swallowBack = swallowBack or false
    timeout = timeout or 30
    self:setMsgText(msg)
    if not self.disabletimeout_ then
        self:releaseScheduler()
        self.schedulerID = scheduler:scheduleScriptFunc(handler(self, self.onTimeout_), timeout, false)
    end
    return self
end

function WaitingDialog:disableTimeout(disable)
    self.disabletimeout_=disable
    if disable then
        self:releaseScheduler()
    end    
    return self
end

function WaitingDialog:releaseScheduler()
    if self.schedulerID ~= nil then
        scheduler:unscheduleScriptEntry(self.schedulerID)
        self.schedulerID = nil
    end
    return self
end

-- 设置是否可取消 true  false
function WaitingDialog:setCancelEnable(enable)
    self.cancelEnable = enable
end

-- 获取载入动画节点
function WaitingDialog:getLoadingNode(  )
    if self._loadingNode then
        return self._loadingNode
    end
end

-- 设置文本
function WaitingDialog:setMsgText( str )
    if self.msgTxt then
        self.msgTxt:setString( str )
    end
    return self
end

-- 隐藏背景
function WaitingDialog:hideLoadingBg( )
    self:setOpacity( 0 )
    return self
end

-- 设置动画图标的缩放
function WaitingDialog:scale( num )
    self:getChildByName( "nd_img" ):setScale( num )
    return self
end

-- 设置载入动画和提示显示位置
function WaitingDialog:setNodePos( point )
    if self._loadingNode then
        self._loadingNode:setPosition( point )
    end
    return self
end

return WaitingDialog