--
-- Author: zhangbin
-- Date: 2017-05-26
-- Describe： 此类返回一个节点，此节点使用指定的图片以 Tiled 方式铺满

local TiledImage = class("TiledImage", cc.load("ViewLayout"))
local BATCH_MAX_COUNT = 16384  -- 一次批处理渲染只能处理 128 * 128 个 tile

-- imgPath 指定图片路径
-- imgType 指定图片类型，0 表示原始图片；1 表示 SpriteFrame
-- width   指定宽度
-- height  指定高度
function TiledImage:onCreate(imgPath, imgType, width, height)
    self:setContentSize(width, height)
    self:setClippingEnabled(true)

    local spFrame = nil
    local texture = nil
    if imgType == 0 then
        texture = cc.Director:getInstance():getTextureCache():addImage(imgPath)
        spFrame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, texture:getContentSize().width, texture:getContentSize().height))
    else
        spFrame = cc.SpriteFrameCache:getInstance():getSpriteFrame(imgPath)
        texture = spFrame:getTexture()
    end

    assert(spFrame, "TiledImage: SpriteFrame "..imgPath.." is not found.")
    local batchNode = cc.SpriteBatchNode:createWithTexture(texture)
    self:addChild(batchNode)

    local tileW = spFrame:getOriginalSize().width
    local tileH = spFrame:getOriginalSize().height
    assert(tileW > 0 and tileH > 0, "TiledImage: tile image width and(or) height is 0")
    local wCount = math.ceil(width / tileW)
    local hCount = math.ceil(height / tileH)

    local tileCount = 0
    for i = 1, wCount do
        for j = 1, hCount do
            if tileCount >= BATCH_MAX_COUNT then
                -- 超出顶点数限制，需要再新建一个 SpriteBatchNode
                batchNode = cc.SpriteBatchNode:createWithTexture(texture)
                self:addChild(batchNode)
                tileCount = 0
            end

            local sp = cc.Sprite:createWithSpriteFrame(spFrame)
            sp:setAnchorPoint(cc.p(0, 0))
            local posX = tileW * (i - 1)
            local posY = tileH * (j - 1)
            sp:setPosition(cc.p(posX, posY))
            batchNode:addChild(sp)

            tileCount = tileCount + 1
        end
    end
end

return TiledImage
