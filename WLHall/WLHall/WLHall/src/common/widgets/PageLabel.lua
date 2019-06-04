local PageLabel = class("PageLabel", cc.Node)

function PageLabel:ctor(nor_img, act_img, offset, pageNum, pageIndex)
    self.nor_img = nor_img
    self.act_img = act_img
    self.offset = offset
    self.pageSpriteArr = {}
    self:setPageNum(pageNum, pageIndex)
end

function PageLabel:clearView()
    for i, sprite in ipairs(self.pageSpriteArr) do
        sprite:removeFromParent()
    end
    self.pageSpriteArr = {}
end

function PageLabel:setPageNum(pageNum, pageIndex)

    self:clearView()
    self.pageNum = pageNum
    for i = 1, pageNum do
        local sprite = cc.Sprite:create(self.nor_img)
        table.insert(self.pageSpriteArr, sprite)
        self:addChild(sprite)
        local poX = (i - 1) * self.offset - (pageNum - 1) / 2 * self.offset
        sprite:setPositionX(poX)
    end

    self:setIndex(pageIndex)
end

function PageLabel:setIndex(index)
    self.index = index or 0
    self:refreshView()
end

function PageLabel:refreshView()

    for i, sprite in ipairs(self.pageSpriteArr) do
        if i == self.index + 1 then
            sprite:setTexture(self.act_img)
        else
            sprite:setTexture(self.nor_img)
        end
    end
end

return PageLabel