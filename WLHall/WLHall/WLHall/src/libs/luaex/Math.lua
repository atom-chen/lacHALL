local M = {}

--[[
    * 描述：取min到max之间的随机数浮点数
--]]
function M:randomFloat(min, max)
    return (min + (max - min) * math.random())
end

--[[
    * 描述：取min到max之间的随机数整数，包含min和max
--]]
function M:randomInt(min, max)
    return min + math.random(max - min + 1) - 1
end

--[[
    * 描述：返回 minValue <= currentValue <= maxValue
--]]
function M:inRange(currentValue, maxValue, minValue)
    assert(currentValue and maxValue and minValue)
    assert(maxValue >= minValue)
    local tmp = math.min(currentValue, maxValue)
    return math.max(tmp, minValue)
end

--[[
    * 描述：已知总数和每行数量，求共有多少行
    * 参数：curIndex当前数量
    * 参数：rowCount每行数量
    * 返回值：索引从1开始
--]]
function M:getLineIndex(curIndex, rowCount)
    assert(curIndex > 0)
    assert(rowCount > 0)

    local index = (curIndex-1) / rowCount
    return math.floor(index) + 1
end

--[[
    * 描述：已知当前索引和每行显示个数，求竖行索引
    * 参数：同上
    * 返回值：同上
--]]
function M:getRowIndex(curIndex, rowCount)
    return (curIndex-1)%rowCount + 1
end

--[[
* 描述：获取position位置
丨------------- width ----------------丨
丨                                    丨
丨space          space          space 丨
丨----丨position丨----丨position丨---- 丨
丨                                    丨
* 参数：posIndex索引从0开始
]]
function M:positionWithSpace(positionCount, space, width, posIndex)
    assert(positionCount)
    assert(space)
    assert(width)
    assert(posIndex)
    local spaceWidth = (positionCount + 1) * space
    local widthCell = (width- spaceWidth) / positionCount
    local radiusWidth = widthCell / 2

    return space*(posIndex+1) + radiusWidth*(posIndex*2 + 1)
end

--[[
* 描述：获取node位置
丨------------------------------------丨
丨                                    丨
丨half  width    space            half丨
丨---丨  node  丨------丨  node  丨----丨
丨                                    丨
* 参数：posIndex索引从0开始
--]]
function M:positionWithIndex(posIndex, width, space)
    assert(posIndex)
    assert(width > 0)
    assert(space)

    local spaceWidth = (posIndex + 0.5) * space
    local nodeWidth = (posIndex + 0.5) * width
    return spaceWidth + nodeWidth
end

--[[
    * 描述：上面方法获取长度
--]]
function M:sizeWithCount(count, width, space)
    assert(count)
    assert(width)
    assert(space)
    local spaceWidth = count * space
    local nodeWidth = count * width
    return spaceWidth + nodeWidth
end

--[[
    * 描述：通过偏移位置，获取当前在第几个Page Index
--]]
function M:pageIndexAtOffset(viewWidth, offset)
    local pageIndex = (viewWidth/2 - offset) / viewWidth
    return math.floor(pageIndex) 
end

--[[
    * 描述：获取向量角度
--]]
function M:getAngleByVector(vec1, vec2)
    local axb = (vec1.x*vec2.x+vec1.y*vec2.y)
    local absa = math.sqrt(vec1.x*vec1.x + vec1.y*vec1.y)
    local absb = math.sqrt(vec2.x*vec2.x + vec2.y*vec2.y)
    local cos = axb / (absa * absb) 
    return math.deg(math.acos(cos))
end

return M