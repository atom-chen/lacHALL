
local M = class("libs.widget.GridView", function(viewSize, delegate, lineCount)
	return cc.ScrollView:create(viewSize)
end)

M.ScrollType = 
{
	Horizontal 		= 1,    -- 水平平滑滚动
	Vertical		= 2,    -- 垂直平滑滚动
	PageHorizontal 	= 3,	-- 水平按页滚动
	PageVertical 	= 4,  	-- 垂直按页滚动
}

M.CellAnchor = 
{
	Center 		= 1,
	LeftDown	= 2,
}

M.ContentLayout = 
{
	Left 	= 1,
	Right 	= 2, 
	Top 	= 3, 
	Bottom 	= 4, 
	Center 	= 5,
}

--[[
	* 描述：格子型视图，支持复用，TableView、PageView都可以用这个代替，使用方法类似TableView
	* 参数viewSize：控件大小
	* 参数delegate：必须实现onGridViewCellCount、onGridViewLineHeight、onGridViewCellAtIndex三个回调
	  onGridViewCellTouched，onGridViewScrollDidStop可选
	* 参数lineCount：每行包含几个cell，值是1相当于TableView

	* 备注：所有索引都是以0开始，ScrollType显示方式可以参考该文件底部
]]
function M:ctor(viewSize, delegate, lineCount)
	assert(viewSize)
	assert(lineCount)
	assert(delegate.onGridViewCellCount and 
			delegate.onGridViewLineHeight and 
			delegate.onGridViewCellAtIndex)

	self:_init(delegate, viewSize, lineCount)

	self:setCellAnchor(M.CellAnchor.Center)
	self:setPageSpace(cc.size(0, 0))
	self:setLineCount(lineCount)
	self:setScrollType(M.ScrollType.Vertical)
	
	-- 注册进入onEnter、退出onEixt事件
	cc.Node.registerScriptHandler(self, function(event)
        local eventName = String:upperFirstChar(event)
        local method = "on" .. eventName
        if self[method] then 
            self[method](self)
        end
    end)
end

function M:setScrollType(scrollType)
	assert(scrollType)
	self._scrollType = scrollType
	
	self:setContentOffset(cc.p(0, 0))
	
	self:_refreshDirection()
end

function M:reloadData()
	self._refreshData = true
	self._cellCount = self._delegate:onGridViewCellCount(self)
	self._cellSpace = self._delegate:onGridViewLineHeight(self)
	assert(self._cellCount and self._cellSpace)

	self:_recoveryLiveCells()
	self:_resetContentSize()
	self:_resetOffset()
	self:_resetExtendLayer()
	self:_updateCurrentCells()
end

function M:dequeueCell(groupKey)
	for i,cell in ipairs(self._cacheCells) do
		if cell:getGroupKey()==groupKey then 
			return table.remove(self._cacheCells, i)
		end
	end
end

function M:setLineCount(lineCount)
	assert(lineCount and lineCount > 0)
	self._lineCount = lineCount

	assert(self._curPageIndex==nil, "必须先设置setLineCount再调用setPageIndex")
end

-- 设置Cell的锚点位置，居中还是左下
function M:setCellAnchor(cellAnchor)
	self._cellCoordiante = cellAnchor
end

-- 设置Page模式，每个Page之间的空隙
function M:setPageSpace(spaceSize)
	assert(spaceSize.width and spaceSize.height)
	self._pageSpace = spaceSize
end

-- 跳到第几页
function M:setPageIndex(pageIndex, animated)
	self._cellCount = self._delegate:onGridViewCellCount(self)
	self._cellSpace = self._delegate:onGridViewLineHeight(self)
	assert(self._scrollType == M.ScrollType.PageHorizontal or 
			self._scrollType == M.ScrollType.PageVertical, 
			string.format("必须是PageHorizontal或PageVertical才能使用该接口"))

	self._curPageIndex = pageIndex
	self:_refreshPageIndex(pageIndex, animated)

	self:_scrollDidStopCallback()
end

-- 获得Cell控件
function M:cellAtIndex(index)
	assert(index)
	for _,cell in pairs(self._liveCells) do
		if cell:getIndex() == index then 
			return cell
		end
	end
end

function M:getPageIndex()
	return self._curPageIndex==nil and 0 or self._curPageIndex
end

function M:setBottomLayer(bottomLayer)
	self._bottomLayer = self:_extendLayer(self._bottomLayer, bottomLayer)
	self._bottomSizeCache = self._bottomLayer:getContentSize()
	assert(self._bottomSizeCache.width~=0 and self._bottomSizeCache.height~=0, "bottomLayer的size不能为空")
end

function M:getBottomLayer()
	return self._bottomLayer
end

function M:setTopLayer(topLayer)
	self._topLayer = self:_extendLayer(self._topLayer, topLayer)
	self._topSizeCache = self._topLayer:getContentSize()
	assert(self._topSizeCache.width~=0 and self._topSizeCache.height~=0, "topLayer的size不能为空")
end

function M:getTopLayer()
	return self._topLayer
end

--[[
	* 描述：当前Content偏移位置，配合onGridViewScrollDidStop可以知道当前是否到达底部或是顶部等
	* 返回值：M.ContentLayout
]]
function M:getContentLayout()
	return self:_getContentLayout()
end

function M:setPosition(position)
	position.x = position.x - self._viewSizeCache.width/2
	position.y = position.y - self._viewSizeCache.height/2
    cc.Node.setPosition(self, position)
end

-------------------------- 以下是私有方法 --------------------------
function M:_isSupportPageMode()
	return self._scrollType == M.ScrollType.PageHorizontal or 
			self._scrollType == M.ScrollType.PageVertical
end

function M:_extendLayer(sourceLayer, targetLayer)
	assert(not self:_isSupportPageMode(), "该接口只支持Horizontal和Vertical两种模式")
	
	if sourceLayer then 
		sourceLayer:removeFromParent()
	end
	
	sourceLayer = targetLayer
	self:addChild(sourceLayer)
	return sourceLayer
end

function M:onEnter()
	Touch:registerTouchOneByOne(self)
	self:reloadData()
end

function M:onCleanup()
    TimerDelay:removeTimer(self)
end

function M:onTouchBegan(touch, event)
	self._moveDelta = 0
	self._isTouchInside = self:_isInside(touch)
	return self._isTouchInside
end

function M:_isMoveing()
	return self._moveDelta>10
end

function M:_scrollDidStopCallback()
	TimerDelay:removeTimer(self)
	TimerDelay:addTimer(self, 0.3, function()
		if not self._delegate.onGridViewScrollDidStop then
			return
		end

		self._delegate:onGridViewScrollDidStop(self)
	end)
end

function M:onTouchMoved(touch, event)
	local delta = touch:getDelta()
	self._moveDelta = self._moveDelta + math.abs(delta.x) + math.abs(delta.y)
	if self._isTouchInside then 
		self:_moveAction(delta)
	end

	if self._isTouchInside then
		self._quickMoveData = self:_quickMove(delta)
	end
end

function M:onTouchEnded(touch, event)
	local isMoving = self:_isMoveing()
	if not isMoving then 
		local location = touch:getLocation()
		self:_touchAction(location)
	end

	if isMoving and self._isTouchInside then 
		self:_scrollPageAction(touch)	
	end
end

function M:_touchAction(location)
	if nil==self._delegate.onGridViewCellTouched then 
		return
	end

	local point = self:_changeLocationToGridPoint(location)
	local cellSize = self:_getCellSize()
	for _,cell in pairs(self._liveCells) do
		local index = cell:getIndex()
		local rect = self:_getCellRectAtIndex(index)
		if cc.rectContainsPoint(rect, point) then 
			self._delegate:onGridViewCellTouched(self, cell:getIndex())
			return
		end
	end
end

function M:_moveAction(delta)
	local subPoint = self:_elasticAction(delta)

	local offset = cc.pAdd(self._offsetCache, subPoint)
	local offsetFunTable = 
	{
		[M.ScrollType.Horizontal] = function(offset) 
			-- self:setContentOffset(cc.p(offset.x, self._offsetCache.y))
		end,
		[M.ScrollType.Vertical]	= function(offset) 
			-- self:setContentOffset(cc.p(self._offsetCache.x, offset.y))
		end,
		[M.ScrollType.PageHorizontal] = function(offset) 
			
			local offx = self._offsetCache.x
			if offx>0 and subPoint.x>0 then
				local factor = math.pow(1-offx/self._viewSizeCache.width, 4) 
				offset.x = offx + factor * subPoint.x 
			end

			self:setContentOffset(cc.p(offset.x, 0))
		end, 
		[M.ScrollType.PageVertical] = function(offset) 
			self:setContentOffset(cc.p(0, offset.y))
		end, 
	}
	local offsetFun = offsetFunTable[self._scrollType]
	assert(offsetFun, string.format("_moveAction，不存在的scroll type=%d", self._scrollType))
	offsetFun(offset)
end

function M:_elasticAction(subPoint)
	local exceedingFactorX = 0
	local exceedingFactorY = 0
	if self._offsetCache.x>0 and subPoint.x>0 then
		exceedingFactorX = self._offsetCache.x/self._viewSizeCache.width
	end

	local moreLen = self._contentSizeCache.width - self._viewSizeCache.width
	if self._offsetCache.x<-moreLen and subPoint.x<0 then 
		exceedingFactorX = (-self._offsetCache.x-moreLen)/self._viewSizeCache.width
	end

	if self._offsetCache.y>0 and subPoint.y>0 then 
		exceedingFactorY = self._offsetCache.y/self._viewSizeCache.height 		
	end

	moreLen = self._contentSizeCache.height - self._viewSizeCache.height
	if self._offsetCache.y<-moreLen and subPoint.y<0 then 
		exceedingFactorY = (-self._offsetCache.y-moreLen)/self._viewSizeCache.height
	end

	local elasticFactor = 2
	subPoint.x = math.pow(1-exceedingFactorX, elasticFactor) * subPoint.x 
	subPoint.y = math.pow(1-exceedingFactorY, elasticFactor) * subPoint.y

	return subPoint
end

function M:_quickMove(delta)
	local subPoint = delta
	local minQuickLen = 30
	local hor = math.abs(subPoint.x) > minQuickLen
	local horDir = subPoint.x<0 and "left" or "right"

	local ver = math.abs(subPoint.y) > minQuickLen
	local verDir = subPoint.y<0 and "down" or "up"
	return {Horizontal=hor, Vertical=ver, HorDirection=horDir, VerDirection=verDir}
end

function M:_isInside(touch)
	local location = touch:getLocation()
	local point = self:convertToNodeSpace(location)
	local rect = cc.rect(0, 0, self._viewSizeCache.width, self._viewSizeCache.height)
	return cc.rectContainsPoint(rect, point)
end

function M:_scrollPageAction(touch)
	if self._scrollType ~= M.ScrollType.PageHorizontal and 
		self._scrollType ~= M.ScrollType.PageVertical then 
		self:_scrollDidStopCallback()
		return
	end

	if M.ScrollType.PageHorizontal==self._scrollType and self._quickMoveData.Horizontal then
		local curPage = self:getPageIndex()
		curPage = self._quickMoveData.HorDirection=="left" and curPage+1 or curPage-1
		curPage = self:_vaildPageIndex(curPage)
		self:setPageIndex(curPage, true)
	elseif M.ScrollType.PageVertical==self._scrollType and self._quickMoveData.Vertical then
	 	local curPage = self:getPageIndex()
	 	local nextPage = self._quickMoveData.VerDirection=="up" and curPage+1 or curPage-1
		nextPage = self:_vaildPageIndex(nextPage)
		self:setPageIndex(nextPage, true)
	else 
		local curPageIndex = self:_getCurrentPageIndex()
		self:setPageIndex(curPageIndex, true)
	end	
end

function M:_vaildPageIndex(pageIndex)
	local pageCount = self:_getPageCount()
	local curPageIndex = math.min(pageCount-1, pageIndex)
	return math.max(0, curPageIndex)
end

function M:_getCurrentPageIndex()
	if M.ScrollType.PageHorizontal == self._scrollType then
		local pageIndex = Math:pageIndexAtOffset(self._viewSizeCache.width, self._offsetCache.x)
		return self:_vaildPageIndex(pageIndex)
	else 
		local pageIndex = Math:pageIndexAtOffset(self._viewSizeCache.height, self._offsetCache.y)
		local pageCount = self:_getPageCount()
		local revPageIndex = pageCount-1-pageIndex
		return self:_vaildPageIndex(revPageIndex)
	end 
end

function M:_changeLocationToGridPoint(location)
	local point = self:convertToNodeSpace(location)

    local x = point.x - self._offsetCache.x 
    local y = point.y - self._offsetCache.y
    return cc.p(x, y)
end

function M:_scrollViewDidScroll()
	self._offsetCache = self:getContentOffset()
	if not self._refreshData then 
		return
	end
	-- 回收
	self:_recoveryCurrentCells()

	-- 新增
	self:_updateCurrentCells()

end

function M:_addCell(cell, index)
	cell:setVisible(true)
	cell:setIndex(index)
	table.insert(self._liveCells, cell)
end

function M:_recoveryCell(key)
	local cell = self._liveCells[key]
	table.insert(self._cacheCells, cell)
	cell:setVisible(false)
	cell:setIndex(nil)
	self._liveCells[key] = nil 
end

function M:_recoveryLiveCells()
	for key,cell in pairs(self._liveCells) do
		self:_recoveryCell(key)
	end
end

function M:_recoveryCurrentCells()
	for key,cell in pairs(self._liveCells) do
		local index = cell:getIndex()
		local rect = self:_getCellRectAtIndex(index)
		if not self:_isRectVisible(rect) then
			self:_recoveryCell(key)
		end
	end
end

function M:_isRectVisible(rect)
	local offset = self._offsetCache
    local size   = self._viewSizeCache

    local viewRect = cc.rect(-offset.x,
    					 -offset.y, 
    					 size.width,
    					  size.height)
 	return cc.rectIntersectsRect(viewRect, rect)   
end

function M:_updateCurrentCells()
	if self._cellCount == 0 then 
		return
	end

	local minIndex, maxIndex = self:_getLiveMinMaxIndex()
	local onePageCount = self:_getOnePageCount()
	if minIndex==0 and maxIndex==0 then 
		local pageIndex = self:_getCurrentPageIndex()
		-- local pageIndex = self:getPageIndex()
		minIndex = pageIndex * onePageCount
		maxIndex = (pageIndex + 1) * onePageCount
	end

	local startIndex = minIndex - onePageCount
	startIndex = math.max(0, startIndex)

	local endIndex = maxIndex + onePageCount
	endIndex = math.min(endIndex, self._cellCount-1)

	for index=startIndex, endIndex do
		self:_updateCell(index)
	end
end

function M:_getLiveMinMaxIndex()
	local minIndex = 0
	local maxIndex = 0
	for _,cell in pairs(self._liveCells) do
		local index = cell:getIndex()
		if minIndex==0 then
			minIndex = index
		end

		if index > maxIndex then 
			maxIndex = index
		end

		if index < minIndex then 
			minIndex = index
		end
	end
	return minIndex, maxIndex
end

function M:_updateCell(index)
	if self:cellAtIndex(index) then 
		return	
	end

	local cellRect = self:_getCellRectAtIndex(index)
	if self:_isRectVisible(cellRect) then
		self:_reloadCellAtIndex(index, cellRect)
	end
end

function M:_reloadCellAtIndex(index, cellRect)
	local cell = self._delegate:onGridViewCellAtIndex(self, index)
	assert(cell, "cell不能为空")

	if not cell:isInParent() then
		cell:setInParent(true)
		self:addChild(cell)
	end

	self:_addCell(cell, index)

	local positionTable = 
	{
		[M.CellAnchor.Center] 	= Rect:centerByRect(cellRect),
		[M.CellAnchor.LeftDown] = cc.p(cellRect.x, cellRect.y),
	}
	local pos = positionTable[self._cellCoordiante]
	cell:setPosition(pos)
end


function M:_resetOffset()
	-- 重置垂直模式初始的offset
	if self._scrollType==M.ScrollType.Horizontal or 
		self._scrollType==M.ScrollType.PageHorizontal then
		return
	end

	if (self._offsetCache.x==0 and self._offsetCache.y==0) then 		
		local y = self._viewSizeCache.height - self._contentSizeCache.height
		self:setContentOffset(cc.p(0, y))
	end
end

----------------------------- _getCellSize -----------------------------
function M:_getCellSize()
	local cellSizeFunTable = 
	{
		[M.ScrollType.Horizontal] = function() 
			return self:_getHorizontalCellSize() 
		end,
		[M.ScrollType.Vertical]	= function() 
			return self:_getVerticalCellSize() 
		end,
		[M.ScrollType.PageHorizontal] = function() 
			return self:_getVerticalCellSize() 
		end, 
		[M.ScrollType.PageVertical] = function() 
			return self:_getVerticalCellSize() 
		end, 
	}

	local cellSizeFun = cellSizeFunTable[self._scrollType]
	assert(cellSizeFun, string.format("_getCellSize，不存在的scroll type=%d", self._scrollType))

	return cellSizeFun()
end

function M:_getHorizontalCellSize()
	local height = self._viewSizeCache.height / self._lineCount
	return cc.size(self._cellSpace, height)
end

function M:_getVerticalCellSize()
	local width = self._viewSizeCache.width / self._lineCount
	return cc.size(width, self._cellSpace)
end
----------------------------- _getCellSize -----------------------------

----------------------------- _getCellRectAtIndex -----------------------------
function M:_getCellRectAtIndex(index)
	local cellRectFunTable = 
	{
		[M.ScrollType.Horizontal] = function(index) 
			return self:_getHorizontalCellRectAtIndex(index) 
		end,
		[M.ScrollType.Vertical]	= function(index) 
			return self:_getVerticalCellRectAtIndex(index) 
		end,
		[M.ScrollType.PageHorizontal] = function(index) 
			return self:_getPageHorizontalCellRectAtIndex(index) 
		end, 
		[M.ScrollType.PageVertical] = function(index) 
			return self:_getPageVerticalCellRectAtIndex(index) 
		end, 
	}

	local cellRectFun = cellRectFunTable[self._scrollType]
	assert(cellRectFun, string.format("_getCellRectAtIndex，不存在的scroll type=%d", self._scrollType))

	return cellRectFun(index)
end

function M:_getHorizontalCellRectAtIndex(index)
	local cellSize = self:_getCellSize()

	local xIndex = math.floor(index / self._lineCount)
	local posx = cellSize.width * xIndex

	local yIndex = index % self._lineCount
	local posy = cellSize.height * (yIndex + 1)

	return cc.rect(posx + self._topSizeCache.width, self._viewSizeCache.height-posy, cellSize.width, cellSize.height)
end

function M:_getVerticalCellRectAtIndex(index)
	local cellSize = self:_getCellSize()

	local xIndex = index % self._lineCount
	local posx = cellSize.width * xIndex

	local yIndex = math.floor(index / self._lineCount)
	local posy = cellSize.height * (yIndex + 1)

	return cc.rect(posx, self._contentSizeCache.height-posy-self._topSizeCache.height, cellSize.width, cellSize.height)
end

function M:_getPageHorizontalCellRectAtIndex(index)
	local firstPagePos = self:_firstPageCellPosition(index)

	local onePageCount = self:_getOnePageCount()
	local pageIndex = math.floor(index / onePageCount)
	local posx = pageIndex*self._viewSizeCache.width + firstPagePos.x 
	local posy = self._viewSizeCache.height - firstPagePos.y
	
	local cellSize = self:_getCellSize()
	local size = cc.size(cellSize.width-self._pageSpace.width, 
				cellSize.height-self._pageSpace.height)
	return Rect:rectByCenter(cc.p(posx, posy), size)
end

function M:_getPageVerticalCellRectAtIndex(index)
	local firstPagePos = self:_firstPageCellPosition(index)

	local posx = firstPagePos.x

	local onePageCount = self:_getOnePageCount()
	local pageIndex = math.floor(index / onePageCount)
	local tmpPosy = pageIndex*self._viewSizeCache.height + firstPagePos.y
	local posy = self._contentSizeCache.height-tmpPosy

	local cellSize = self:_getCellSize()
	local size = cc.size(cellSize.width-self._pageSpace.width, 
				cellSize.height-self._pageSpace.height)
	
	return Rect:rectByCenter(cc.p(posx, posy), size)
end

function M:_firstPageCellPosition(index)
	-- x坐标
	local xIndex = index % self._lineCount
	local posx = Math:positionWithSpace(self._lineCount, self._pageSpace.width, 
							self._viewSizeCache.width, xIndex)

	-- y坐标
	local cellSize = self:_getCellSize()
	local tmpIndex = index % self:_getOnePageCount()
	local yIndex = math.floor(tmpIndex / self._lineCount)
	local rowCount = self:_getRowCount()
	local posy = Math:positionWithSpace(rowCount, self._pageSpace.height, 
							self._viewSizeCache.height, yIndex)
	
	return cc.p(posx, posy)
end

function M:_positionWithPageSpace(lineCount, pageSpace, length, posIndex)
	local spaceWidth = (lineCount + 1) * pageSpace
	local widthCell = (length- spaceWidth) / lineCount
	local radiusWidth = widthCell / 2

	return pageSpace*(posIndex+1) + radiusWidth*(posIndex*2 + 1)
end

----------------------------- _getCellRectAtIndex -----------------------------

----------------------------- resetContentSize -----------------------------
function M:_resetContentSize()
	local contentSizeFunTable = 
	{
		[M.ScrollType.Horizontal] = function() 
			return self:_getHorizontalContentSize() 
		end,
		[M.ScrollType.Vertical]	  = function() 
			return self:_getVerticalContentSize() 
		end,
		[M.ScrollType.PageHorizontal] = function() 
			return self:_getPageHorizontalContentSize() 
		end, 
		[M.ScrollType.PageVertical]	  = function() 
			return self:_getPageVerticalContentSize() 
		end, 
	}

	local getContentSizeFun = contentSizeFunTable[self._scrollType]
	assert(getContentSizeFun, string.format("_resetContentSize，不存在的scroll type=%d", self._scrollType))

	local size = getContentSizeFun()
	assert(size, string.format("未返回正确sizescroll type=%d", self._scrollType))

	local width = self._viewSizeCache.width > size.width and self._viewSizeCache.width or size.width
	local height = self._viewSizeCache.height > size.height and self._viewSizeCache.height or size.height

	self._contentSizeCache = cc.size(width, height)
	self:setContentSize(self._contentSizeCache)
end 

function M:_getContentHeight()
	local row = math.ceil(self._cellCount / self._lineCount)
	return row * self._cellSpace
end

function M:_getHorizontalContentSize()
	local contentWidth = self:_getContentHeight()
	return cc.size(contentWidth + self._bottomSizeCache.width + self._topSizeCache.width, self._viewSizeCache.height)
end

function M:_getVerticalContentSize()
	local contentHeight = self:_getContentHeight()
	return cc.size(self._viewSizeCache.width, contentHeight + self._bottomSizeCache.height + self._topSizeCache.height)
end

function M:_getPageHorizontalContentSize()
	self:_assertPageModeHeight()
	
	local pageCount = self:_getPageCount()
	return cc.size(self._viewSizeCache.width * pageCount, self._viewSizeCache.height)
end

function M:_getPageVerticalContentSize()
	self:_assertPageModeHeight()

	local pageCount = self:_getPageCount()
	return cc.size(self._viewSizeCache.width, self._viewSizeCache.height * pageCount)
end

function M:_assertPageModeHeight()
	local rowNumber = self:_getRowCount()
	local rowNumberFloor = math.floor(rowNumber)
	assert(rowNumber==rowNumberFloor, "PageHorizontal模式，viewSize的高度必须能够整除onGridViewLineHeight")
end

function M:_getPageCount()
	local onePageCount = self:_getOnePageCount()
	return math.ceil(self._cellCount / onePageCount)
end

function M:_getOnePageCount()
	local rowCount = self:_getRowCount()
	return self._lineCount * rowCount
end

function M:_getRowCount()
	local lengthTable = 
	{
		[M.ScrollType.Horizontal] 	  = self._viewSizeCache.width,
		[M.ScrollType.Vertical]		  = self._viewSizeCache.height,
		[M.ScrollType.PageHorizontal] = self._viewSizeCache.height,
		[M.ScrollType.PageVertical]   = self._viewSizeCache.width,
	}

	local length = lengthTable[self._scrollType]
	return math.ceil(length / self._cellSpace)
end

----------------------------- resetContentSize -----------------------------

function M:_resetExtendLayer()
	if self._bottomLayer and self._scrollType==M.ScrollType.Vertical  then 
		self._bottomLayer:setPosition(cc.p(0, 0))
	end

	if self._bottomLayer and self._scrollType==M.ScrollType.Horizontal then 
		local x = self._contentSizeCache.width - self._bottomLayer:getContentSize().width
		self._bottomLayer:setPosition(cc.p(x, 0))
	end

	if self._topLayer and self._scrollType==M.ScrollType.Vertical  then 
		self._topLayer:setPosition(cc.p(0, self._contentSizeCache.height-self._topSizeCache.height))
	end

	if self._topLayer and self._scrollType==M.ScrollType.Horizontal  then 
		self._topLayer:setPosition(cc.p(0, 0))
	end
end

function M:_init(delegate, viewSize, lineCount)
	self._delegate 	= delegate

	self._cacheCells = {}
	self._liveCells	 = {}

	self._offsetCache 		= cc.p(0, 0)
	self._viewSizeCache 	= viewSize
	self._contentSizeCache 	= cc.size(0, 0)
	self._refreshData 		= false
	self._bottomSizeCache 	= cc.size(0, 0)
	self._topSizeCache 		= cc.size(0, 0)

	self:setDelegate()
    self:registerScriptHandler(function()
		self:_scrollViewDidScroll()
	end, cc.SCROLLVIEW_SCRIPT_SCROLL)
end

function M:_refreshDirection()
	local directionFunTable = 
	{
		[M.ScrollType.Horizontal] = function()
			self:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
			self:setTouchEnabled(true)
		end,
		[M.ScrollType.Vertical]	= function()
			self:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
			self:setTouchEnabled(true)
		end,
		[M.ScrollType.PageHorizontal] = function()
			self:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
			self:setTouchEnabled(false)
		end,
		[M.ScrollType.PageVertical] = function()
			self:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
			self:setTouchEnabled(false)
		end,
	}

	local directionFun = directionFunTable[self._scrollType]
	assert(directionFun, string.format("setScrollType，不存在scroll type=%d", self._scrollType))
	directionFun()
end

function M:_refreshPageIndex(pageIndex, animated)
	if self._scrollType == M.ScrollType.PageHorizontal then 
		local offsetx = pageIndex * self._viewSizeCache.width
		self:setContentOffset(cc.p(-offsetx, 0), animated)
	elseif self._scrollType == M.ScrollType.PageVertical then
		local pageCount = self:_getPageCount()
		local offsety = (pageCount-1-pageIndex) * self._viewSizeCache.height
		self:setContentOffset(cc.p(0, -offsety), animated)
	end
end

function M:_getContentLayout()
	if self._scrollType==M.ScrollType.Horizontal or self._scrollType==M.ScrollType.PageHorizontal then 
		if self._offsetCache.x>=0 and self._scrollType==M.ScrollType.Horizontal then
			return M.ContentLayout.Left 
		end

		local moreLen = self._contentSizeCache.width - self._viewSizeCache.width
		if self._offsetCache.x<=-moreLen and self._scrollType==M.ScrollType.Horizontal then 
			return M.ContentLayout.Right
		end
	end

	if self._scrollType==M.ScrollType.Vertical or self._scrollType==M.ScrollType.PageVertical then 
		if self._offsetCache.y>=0 then 
			return M.ContentLayout.Bottom
		end

		moreLen = self._contentSizeCache.height - self._viewSizeCache.height
		if self._offsetCache.y<=-moreLen then 
			return M.ContentLayout.Top
		end
	end 

	return M.ContentLayout.Center	
end

return M

--[[
	* ScrollType模式参考样式
	* Horizontal模式
	丨 0 3 6 9  12 丨
	丨 1 4 7 10 13 丨
	丨 2 5 8 11 14 丨
	
	* Vertical模式
	丨 0  1  2 丨
	丨 3  4  5 丨
	丨 6  7  8 丨
	丨 9  10 11丨
	丨 12 13 14丨

	* PageHorizontal模式
	丨 0  1  2   9  10 11 丨 
	丨 3  4  5   12 13 14 丨
	丨 6  7  8   15 16 17 丨

	* PageVertical模式
	丨 0  1  2 丨
	丨 3  4  5 丨
	丨 6  7  8 丨
	
	丨 9  10 11丨
	丨 12 13 14丨
]] 

