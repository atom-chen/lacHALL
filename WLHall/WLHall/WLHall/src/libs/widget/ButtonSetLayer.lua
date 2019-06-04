--[[
    * 描述：按钮集合
    * 参数setInfo：{ { normalImageName, highlightImageName, disableImageName, text, fontSize}, ... }
    * 按钮事件：onClicked(button,  atIndex)，atIndex索引从0开始
--]]

local M = class("libs.widget.ButtonSetLayer", function(setInfo)
	return cc.Layer:create()
end)

M.LayoutType = 
{
    FromTopToBottom = 1, 
    FromBottomToTop = 2,
}

function M:ctor(setInfo)
    assert(setInfo)
    self._buttons = {}
    local ButtonText = require("libs.widget.ButtonText")
    for index,value in ipairs(setInfo) do
        local button = ButtonText:createWithFileName(value[1], value[2], value[3])
        self:addChild(button)
        
        if value[4] then 
            button:setString(value[4], value[5]) 
        end
        
        button.onClicked = function(bt)
            self:_onClickedCall(bt)
        end
        table.insert(self._buttons, button)
    end
end

function M:getButtonByIndex(idx)
    local buttonCount = table.getn(self._buttons)
    assert(buttonCount >= idx, "index out of range")
    return self._buttons[idx]
end

--[[
    * 描述：排列方式，如果按钮排成一行则只传inSize即可，如setLayout(cc.size(display.width, 100))
    * 参数inSize：layer大小
    * 参数layoutType：从下往上排还是从上往下排，默认前者
    * 参数lineCount：每行放几个按钮，默认button count
    * 参数rowHeight：行与行之间的高度，默认inSize.height
    丨----------- size.width -------------丨
    丨                                    丨
    丨------------- lineCount ------------丨
    丨 button1  button2  button3  button4 丨 --> rowHeight
    丨 button5  ...                       丨
--]]
function M:setLayout(inSize, layoutType, lineCount, rowHeight)
    self:setContentSize(inSize)
    local layoutType2 = layoutType and layoutType or M.LayoutType.FromTopToBottom
    local lineCount2 = lineCount and lineCount or #self._buttons
    local rowHeight2 = rowHeight and rowHeight or inSize.height

    for index,button in ipairs(self._buttons) do
        local pos = self:_getPosition(index - 1, layoutType2, inSize, lineCount2, rowHeight2)
        button:setPosition(pos)
    end 
end

--[[
    * 描述：默认Layer的锚点在左下，这个是以锚点在中心的情况设置layer的位置，比如
           setPositionAtCenterAnchor(Screnn.width/2, Screnn.height/2)表示将layer位置移到屏幕中心点
    * 参数position：新的坐标点
--]]
function M:setPositionAtCenterAnchor(position)
    local size = self:getContentSize()
    local x, y = self:getPosition()
    local currentCenterPoint = cc.p(x+size.width/2, y+size.height/2)
    local sub = cc.pSub(position, currentCenterPoint)

    local newCenterPoint = cc.pAdd(cc.p(x, y), sub)
    self:setPosition(newCenterPoint)
end

-------------------------------- 接口分割线 --------------------------------

function M:_getPosition(index, layoutType, inSize, lineCount, rowHeight)
    local tb = {
        [M.LayoutType.FromTopToBottom] = function(index, inSize, lineCount, rowHeight)
            return self:_getPositionFromTopToBottom(index, inSize, lineCount, rowHeight)
        end, 
        [M.LayoutType.FromBottomToTop] = function(index, inSize, lineCount, rowHeight)
            return self:_getPositionFromBottomToTop(index, inSize, lineCount, rowHeight)
        end
    }

    return Function:safeCall(tb, layoutType, index, inSize, lineCount, rowHeight)
end

function M:_getPositionFromTopToBottom(index, inSize, lineCount, rowHeight)
    local pos = self:_getPositionFromBottomToTop(index, inSize, lineCount, rowHeight)
    return cc.p(pos.x, inSize.height - pos.y)
end

function M:_getPositionFromBottomToTop(index, inSize, lineCount, rowHeight)
    -- 等间距模式
    local buttonSize = self._buttons[1]:getContentSize()
    local space = (inSize.width-lineCount*buttonSize.width) / (lineCount + 1)
    local halfLen = buttonSize.width / 2
    local tmpIndex = index % lineCount
    local posx = space*(tmpIndex+1) + halfLen * (1 + 2*tmpIndex)

    local yIndex = math.floor(index / lineCount)
    local posy = rowHeight * yIndex + rowHeight/2

    return cc.p(posx, posy)
end

function M:_onClickedCall(button)
    if self.onClicked then 
       self.onClicked(button, self:_getIndexWithButton(button)) 
    end
end

function M:_getIndexWithButton(button)
    for i,v in ipairs(self._buttons) do
        if button == v then 
            return i - 1
        end
    end
end

return M


