--
-- Author: Your Name
-- Date: 2016-09-14 14:35:48
--
local Node = cc.Node

-- 设置缩放
function Node:scale(scale)
	self:setScale(scale)
	return self
end

-- 设置父容器中相对位置 依赖父容器先调用@addTo添加  父容器需要设置大小
function Node:posByParent(anchor,x,y) 
   	x=x or 0
   	y=y or 0
	local  parent = self:getParent()
   	assert(parent,"parent is nil ")  
   	local size=parent:getContentSize()  
    local pos = cc.p(size.width*anchor.x, size.height*anchor.y)
    pos = cc.pAdd(pos, cc.p(x,y))
    self:setPosition(pos)
    return self
end

-- 位置移动到父节点中间位置
function Node:posToMid()
    self:posByParentX(0.5)
    self:posByParentY(0.5)
end

-- 设置相对屏幕位置 
function Node:posByScreen(anchor,x,y) 
    x=x or 0
    y=y or 0
    local pos = cc.p(display.width*anchor.x, display.height*anchor.y)
    pos = cc.pAdd(pos, cc.p(x,y))
    self:setPosition(pos)
    return self
end

-- 设置父容器中相对位置 依赖父容器先调用@addTo 父容器需要设置大小
function Node:posByParentX(anchorx,x) 
   	x=x or 0
	local  parent = self:getParent()
   	assert(parent,"parent is nil ")  
   	local size=parent:getContentSize()    
	local xp= size.width*anchorx 
    self:setPositionX(xp+x)
    return self
end

-- 设置父容器中相对位置 依赖父容器先调用@addTo  父容器需要设置大小
function Node:posByParentY(anchory,y) 
   	y=y or 0
	local  parent = self:getParent()
   	assert(parent,"parent is nil ")  
   	local size=parent:getContentSize()
	local yp= size.height*anchory
    self:setPositionY(yp+y)
    return self
end

--  设置相对当前位置偏移坐标
function Node:posBy(x,y)
	local posx,posy= self:getPosition()
    if y then
        self:setPosition(posx+x, posy+y)
    else
        self:setPositionX(posx+x)
    end
    return self  
end

-- 设置控件在父容器位置百分比 父容器大小不能为0 依赖父容器先调用@addTo
function Node:posPercent(x,y) 
	local  parent = self:getParent()
   	assert(parent,"parent is nil ")  
   	local size=parent:getContentSize()   	
    if y then
        self:setPosition(size.width*x, size.height*y)
    else
        self:setPositionX(size.width*x)
    end
    return self
end

-- call only once
function Node:setGray(isOn) 
  if isOn == false then
    local glProgramState = cc.GLProgramState:getOrCreateWithGLProgramName("ShaderPositionTextureColor_noMVP");
    self:setGLProgramState(glProgramState)
  else
    local glProgramState = cc.GLProgramState:getOrCreateWithGLProgramName("ShaderUIGrayScale");
    self:setGLProgramState(glProgramState)
  end
end

-- 功能：开始节点定时器
-- 参数fnTimer: 要做的事情
-- 参数bSkipFirst: 不立即执行
-- 例子：node:startTimer(function() print(os.time()) end, 2)
-- 返回 "stop" 停止定时器
function Node:startTimer(seconds, fnTimer, bSkipFirst)
	--self:stopAllActions()
	
	local action = nil
	
	local function fnWrap() -- 出错时关闭定时器
		--return TryCatch(fnTimer, function() self:stopAllActions() end)
		local arg = fnTimer()
		if arg == "stop" then
			assert(action)
			self:stopAction(action)
		end
	end

	local acList = {}
	if bSkipFirst then -- 跳过第一次
		table.insert(acList, cc.DelayTime:create(seconds))
		table.insert(acList, cc.CallFunc:create(fnWrap))
	else
		table.insert(acList, cc.CallFunc:create(fnWrap))
		table.insert(acList, cc.DelayTime:create(seconds))
	end
	
	action = cc.RepeatForever:create(cc.Sequence:create(acList))
	self:runAction(action)
	return self
end

function Node:callAfter(seconds, fn)
	local arr = {cc.DelayTime:create(seconds),
					cc.CallFunc:create(fn)}
	self:runAction(cc.Sequence:create(arr))
	return self
end


-- 遍历所有子控件
function Node:visitAll(fn)
	local function fnVisitAll(nd, fn)
		for k, child in pairs(nd:getChildren()) do
			local bStop = fn(child)
			if bStop then
				return bStop
			end

			bStop = fnVisitAll(child, fn)
			if bStop then
				return bStop
			end
		end
	end

	return fnVisitAll(self, fn)
end


-- 深层遍历子节点
function Node:findNode(node_name)
    --print(string.format("======= find %s ========",node_name))
	local function fnVisitAll(nd)
		for k, child in pairs(nd:getChildren()) do
            if child:getName() == node_name then
			    return child
            else
                local node = fnVisitAll(child)
                if node then
                    return node
                end
            end
		end
	end
	
	local node = fnVisitAll(self, node_name)
	-- assert(node, "no find node:"..node_name)
	return node
end

-- 设置所有节点变灰
function Node:setAllGray(bGray)
    local function fnVisitAll(nd)
        if nd.getVirtualRenderer and nd:getVirtualRenderer().setState then
            nd:getVirtualRenderer():setState(bGray and 1 or 0)
        elseif tolua.iskindof(nd, "cc.Sprite") then
            nd:setGray(bGray)
        end
    end
    fnVisitAll(self)
    self:visitAll(fnVisitAll)
end

-- 改变所有子节点的color
function Node:setAllDark(color)
    color = color or cc.c3b(255, 255, 255)
    local function fnVisitAll(nd)
        if tolua.iskindof(nd, "cc.Sprite") then
            nd:setColor(color)
        end
    end
    fnVisitAll(self)
    self:visitAll(fnVisitAll)
end

--app 进入后台事件回调 如需要 重写此函数
function Node:onAppEnterBackground() 
 
end

--app 从后台进入前台事件回调 如需要 重写此函数/
function Node:onAppEnterForeground()
 
end

--app 屏幕大小改变事件回调 如需要 重写此函数
function Node:onAppScreenSizeChanged(isLandscape)

end

function Node:onAppEvent(eventName, callback)
    if "applicationWillEnterForeground" == eventName then
        self.onAppEnterForegroundCallback_ = callback
    elseif "applicationDidEnterBackground" == eventName then
        self.onAppEnterBackgroundCallback_ = callback
    end
    
    self:enableAppEvents()
end

function Node:enableAppEvents()
    if self.isAppEventEnabled_ then
        return self
    end
    local eventDispatcher = self:getEventDispatcher()
    local forelistener = cc.EventListenerCustom:create("applicationWillEnterForeground", handler(self, self.onAppEnterForeground_))
    eventDispatcher:addEventListenerWithSceneGraphPriority(forelistener, self)
    local backlistener = cc.EventListenerCustom:create("applicationDidEnterBackground", handler(self,self.onAppEnterBackground_))
    eventDispatcher:addEventListenerWithSceneGraphPriority(backlistener, self)

    -- add by John 添加监听屏幕大小改变事件
    local screenSizelistener = cc.EventListenerCustom:create("applicationScreenSizeChanged", handler(self, self.onAppScreenSizeChanged_))
    eventDispatcher:addEventListenerWithSceneGraphPriority(screenSizelistener, self)

    self.isAppEventEnabled_ = true
    self.clock_=os.time() 
    return self
end

function Node:disableAppeEvents()
    self:getEventDispatcher():removeCustomEventListeners("applicationWillEnterForeground")
    self:getEventDispatcher():removeCustomEventListeners("applicationDidEnterBackground")
    self:getEventDispatcher():removeCustomEventListeners("applicationScreenSizeChanged")
    self.isAppEventEnabled_ = false
    return self
end

-- add by John 监听屏幕大小改变事件
function Node:onAppScreenSizeChanged_(event)
    local isLandscape = event:getUserData()
    -- 主动翻转才触发回调事件
    if cc.exports.SCREEN_SIZE_CHANGE_TAG or gg.WebGameCtrl:isInPortoaitWebGame() then
        printf("Node:onAppScreenSizeChange ==========")
        self:onAppScreenSizeChanged(isLandscape)
        cc.exports.SCREEN_SIZE_CHANGE_TAG = false
    end
end

--进入后台
function Node:onAppEnterBackground_(event)
    self.clock_=os.time()
    self.isbackground_=true    
    self:onAppEnterBackground()
    if self.onAppEnterBackgroundCallback_ then
        self:onAppEnterBackgroundCallback_()
    end 
end

--进入前台
function Node:onAppEnterForeground_(event)   
    local clock=os.time()      
    local diff=  tonumber(string.format("%.2f", clock - checknumber(self.clock_)))
    self.clock_=clock
    if self.isbackground_ and not self.isdisableswitch_ then
        self:callAfter(0,function() self:onAppEnterForeground(diff) end)
    end
    if self.onAppEnterForegroundCallback_ then
        self:onAppEnterForegroundCallback_(diff)        
    end  
    self.isdisableswitch_=false
    self.isbackground_=false
end
-- 设备电池电量变化事件 如需要 重写此函数 enableBatteryChangeEvent 开启电量监听
function Node:onBatteryChanged(level,state)
    
end

function Node:onBatteryChanged_(event)
    local data=event:getUserData()  
    local level=Helper.And(data,BATTERY_LEVEL_MASK)
    local state =Helper.RShift(data,16)
    self:onBatteryChanged(level,state) 
end

function Node:enableBatteryChangeEvent()
    if self.isBatteryEventEnabled_ then
        return self
    end
    self.isBatteryEventEnabled_ = true
    device.addBatteryChangeEvent(self,handler(self,self.onBatteryChanged_))
    return self
end

function Node:disableBatteryChangeEvent()
    device.removeBatteryChangeEvent(self)
    self.isBatteryEventEnabled_ = false
    return self
end

-- 设备通话状态变化事件 如需要 重写此函数 onPhoneStateChanged 开启状态变化通知
function Node:onPhoneStateChanged(state)
    
end

function Node:onPhoneStateChanged_(event)
    local data=event:getUserData()
    self:onPhoneStateChanged(data)
end

function Node:enablePhoneStateChangeEvent()
    if self.isPhoneStateEventEnabled_ then
        return self
    end
    self.isPhoneStateEventEnabled_ = true
    device.addPhoneStateChangeEvent(self,handler(self,self.onPhoneStateChanged_))
    return self
end

function Node:disablePhoneStateChangeEvent()
    device.removePhoneStateChangeEvent(self)
    self.isPhoneStateEventEnabled_ = false
    return self
end
