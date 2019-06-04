
local M = class("libs.widget.SpriteAnimate2", cc.Node)
local kDefaultFrameRate = 1.0 / 24.0

--[[
    * 描述：精灵播放基础类，根据项目需求扩展，使用一个个文件加载
    * 参数：imagePaths图片完整路径集合
]]
function M:ctor(imagePaths)
    assert(#imagePaths > 0)
    self._elapsedTime   = 0
    self._currentIndex  = 1
    self._frameRate     = kDefaultFrameRate
    self._currentAnimateCount = #imagePaths

    self._curPlayIndex = 1
    self._spriteMgr = {}
    for _,imagePath in ipairs(imagePaths) do
        local sprite = cc.Sprite:create(imagePath)
            :addTo(self)
            :hide()
            :anchor(cc.p(0, 0))
        table.insert(self._spriteMgr, sprite)
    end
    local firstSprite = self._spriteMgr[1]
    firstSprite:show()
    local size = firstSprite:getContentSize()
    self:setContentSize(size)
    self:setAnchorPoint(cc.p(0.5, 0.5))
end

function M:update(dt)
    self._elapsedTime = self._elapsedTime + dt
    if self._elapsedTime > self._frameRate then
        self._elapsedTime = self._elapsedTime - self._frameRate
        self._currentIndex = self._currentIndex + 1

        self:_onPlayNextFrame()
    end
end

function M:setFrameRate(frameRate)
    self._frameRate = frameRate
    return self 
end

function M:setFinishCallback(callback)
    self._finishCallfun = callback
    return self 
end

function M:getCurrentIndex()
    return self._currentIndex
end

--[[
    * 描述：播放第几帧
    * 参数：index从1开始
    * 温馨提示：SpriteAnimate是从0开始
--]]
function M:playFrame(index)
    assert(#self._spriteMgr>=index)
    assert(index>0)
    self._spriteMgr[self._curPlayIndex]:hide()
    self._curPlayIndex = index
    self._spriteMgr[self._curPlayIndex]:show()
    return self 
end

--------------------------- 华丽分割线 ---------------------------

function M:_onPlayNextFrame()
    local isFinish = self._currentIndex > self._currentAnimateCount and true or false 
    self._currentIndex = isFinish and 1 or self._currentIndex
    self:playFrame(self._currentIndex)    

    if isFinish and self._finishCallfun then
        self._finishCallfun(self)
    end
end

return M