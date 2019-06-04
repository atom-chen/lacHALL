local Particle = import(".Particle")
local M = class("libs.widget.ParticleRound", cc.Node)

--[[
    * 描述：创建粒子绕着指定路径走的动画效果
    * 参数：plistPath数据文件路径
    * 参数：imagePath纹理图片路径
--]]
function M:ctor(plistPath, imagePath)
	self._particle = Particle:create(plistPath, imagePath)
		:addTo(self)	
		:position(cc.p(0, 0))
	
	self._timing = false
	self:enableNodeEvents()
end

--[[
    * 描述：设置动画轨迹路径
    * 参数：points轨迹路径点，如：{ cc.p(0,0), cc.p(100, 0), cc.p(0, 0) }
    * 参数：angles轨迹的角度，如： = { 0, 90, 0 }
--]]
function M:setRoundPoints(points)
	assert(points)
    self._points = points
    -- self._angles = angles
    return self 
end

--[[
    * 描述：设置动画轨迹时间
    * 参数：curTime当前时间
    * 参数：allTime总时间
--]]
function M:setRoundTime(curTime, allTime)
	assert(curTime)
	assert(allTime)
	self._curTime = curTime 
	self._allTime = allTime    
	return self 
end

--[[
    * 描述：开始动画
--]]
function M:run()
	assert(self._points, "请设置setRoundPoints接口")
	assert(self._curTime, "请设置setRoundTime接口")
	if self._timing then
	    return self 
	end

	self:_resetData()
	self._timing = true 
    Timer:addTimer(self)
    self:show()
    return self 
end

--[[
    * 描述：定制动画
--]]
function M:stop()
	self._timing = false
    Timer:removeTimer(self)
    self:hide()
    self._particle:setPosition(cc.p(0, 0))
    return self 
end

--------------------------- 华丽分割线 ---------------------------

function M:onTimerUpdate(dt)
    self._curTime = self._curTime + dt 
   	if self._curTime > self._allTime then
   	    self:stop()
   	    return
   	end

   	local percent = self._curTime / self._allTime
   	local arriveLen = self._length * percent
   	local arriveIndex = self:_arriveIndex(arriveLen)
   	local segLen = self:_arriveSegLen(arriveIndex, arriveLen)

   	local arrivePoint = self:_getArrivePoint(arriveIndex, segLen)
   	self._particle:setPosition(arrivePoint)
end

-- 到达每段的距离和总长度
function M:_getSegmentPaths()
	local segment = {}
	local len = 0
    for i=1,#self._points-1 do
    	local curPoint = self._points[i]
    	local nextPoint = self._points[i+1]
    	len = len + cc.pGetDistance(curPoint, nextPoint)
    	table.insert(segment, len)
    end
    return segment, len 
end

-- 当前走距离落在哪个区间段
function M:_arriveIndex(arriveLen)
    for i,len in ipairs(self._segmentPaths) do
    	if len>arriveLen then
    	    return i
    	end
    end
    return #self._segmentPaths
end

-- 当前区间段走的距离
function M:_arriveSegLen(arriveIndex, arriveLen)
   	local len = self._segmentPaths[arriveIndex-1]
   	len = len and len or 0
   	return arriveLen - len 
end

-- 获得到达的坐标点
function M:_getArrivePoint(arriveIndex, arriveSegLen)
    local prePoint = self._points[arriveIndex]
    local nextPoint = self._points[arriveIndex + 1]
    local segLen = cc.pGetDistance(prePoint, nextPoint)
    local percent = arriveSegLen / segLen
    local vec = cc.pSub(nextPoint, prePoint)
    local perVec = cc.p(vec.x*percent, vec.y*percent)
    return cc.pAdd(prePoint, perVec)
end

function M:_resetData()
    local segmentPaths, len = self:_getSegmentPaths()
    self._segmentPaths = segmentPaths
    self._length = len
end

function M:onCleanup()
    Timer:removeTimer(self)
end

return M

