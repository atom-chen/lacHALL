-- Author: pengxunsheng
-- Date:2018.3.19
-- Describe：礼品商店
local GiftViewRecord = class("GiftViewRecord", cc.load("ViewBase"))
local GiftRecord = import(".GiftRecord")
GiftViewRecord.RESOURCE_FILENAME = "ui/gift/giftViewRecord.lua"

GiftViewRecord.RESOURCE_BINDING  =
{
    ["Panel"] = { ["varname"] = "Panel"},
    ["ScrollNode"] = { ["varname"] = "ScrollNode"},

    ["content_text"]  = { ["varname"] = "content_text"},

}

function GiftViewRecord:onCreate(RecordData)
    self:initWeb()
    self._scrollNode = self:createScroll()
    self.ScrollNode:addChild(self._scrollNode);
end

function GiftViewRecord:initWeb()
    local callback = function(result)
        if tolua.isnull(self) then return end
        if not result then return end
        if result.status == 0 and #(result["data"])>0 then  --要是有兑换的记录
            self:upDataNode(result["data"])
        end
    end
    gg.Dapi:SendGoodOrders(callback)
end

function GiftViewRecord:upDataNode(RecordData)
     self.content_text:setVisible(false)
     self:creatNode(RecordData)
end

function  GiftViewRecord:creatNode (RecordData)
    self._scrollNode:removeAllChildren()
    local Row = #RecordData        -- 行数
    local innerContainerSize = (Row)*(139)
    -- -- 设置滚动层滑动区域
    local sizeView = cc.size(self._scrollNode:getContentSize().width, innerContainerSize)
    self._scrollNode:setInnerContainerSize(sizeView)
    for i=1,#RecordData do
       local item = GiftRecord.new("GiftRecord");
       item:setRecordInfo(RecordData[i])
       local size = item:getSize()
       local Height = self._scrollNode:getInnerContainerSize().height - (math.floor((i-1)) * (size.height + 5))  ;
       item:setPositionY(Height)
       self._scrollNode:addChild(item);
    end
end

function GiftViewRecord:createScroll()
    local pScrollView = ccui.ScrollView:create()
    pScrollView:setClippingEnabled(true)
    pScrollView:setBackGroundColorType(1)
    pScrollView:setBackGroundColor({r = 0, g = 0, b = 0})
    pScrollView:setBackGroundColorOpacity(0)
    pScrollView:setAnchorPoint(0.5,1)
    pScrollView:setContentSize(cc.size(1104,560))
    -- 开启回弹效果
    pScrollView:setBounceEnabled(true)
    -- 隐藏滚动条
    pScrollView:setScrollBarEnabled(false)
    return pScrollView
end

function GiftViewRecord:ceshijiek(sdsd)
    self.content_text:setString(sdsd)
end

return GiftViewRecord
