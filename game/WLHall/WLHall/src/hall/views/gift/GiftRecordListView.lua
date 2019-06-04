-- Author: pengxunsheng
-- Date:2018.7.11
-- Describe：京东E卡的提示
local GiftRecordListView = class("GiftRecordListView", cc.load("ViewPop"))

GiftRecordListView.RESOURCE_FILENAME = "ui/gift/giftRecordListView.lua"

local GiftListNode = import(".GiftListNode")

GiftRecordListView.RESOURCE_BINDING  =
{
    ["panel_colse"]  = { ["varname"] = "panel_colse" , ["events"]={{event="click",method="onClickClose"}} },

    ["nd_view"] = { ["varname"] = "nd_view"},
}

function GiftRecordListView:onCreate(info)
    self:initDate (info)
end

function GiftRecordListView:initDate(info)
    if checkint(info.type) == 1 then
        self:switchDate(info.coupon_card_num, info.coupon_card_pass)
    end
end

function GiftRecordListView:switchDate(zhinfo, passinfo)
    self.tabInfo = {}
    local zhtab = Helper.StringSpliter(zhinfo, ",")
    local mmtab = Helper.StringSpliter(passinfo, ",")
    --
    for i=1, #zhtab  do
       if string.len(zhtab[i]) > 0 and string.len(mmtab[i]) > 0 then
           local tab = {zh = zhtab[i], mm =  mmtab[i]}
           table.insert(self.tabInfo, tab)
       end
    end
    self:createNode()
end

function GiftRecordListView:createNode()
    local pScrollView = self:createScrollView()
    pScrollView:setPosition(cc.p(13,5))
    self.nd_view:addChild(pScrollView)

    self:addNode(pScrollView)
end

function GiftRecordListView:addNode(pScrollView)
    pScrollView:removeAllChildren()
    local Row = #self.tabInfo        -- 行数
    local innerContainerSize = (Row)*(111)
    -- -- 设置滚动层滑动区域
    local sizeView = cc.size(pScrollView:getContentSize().width, innerContainerSize)
    pScrollView:setInnerContainerSize(sizeView)
    for i= 1, #self.tabInfo  do
         local item = GiftListNode.new();
         local size = item:getSize()
         item:setInfo(self.tabInfo[i])
         local Height = pScrollView:getInnerContainerSize().height - (math.floor((i-1)) * (size.height))  ;
         item:setPositionY(Height)
         pScrollView:addChild(item);
    end
end

function GiftRecordListView:createScrollView()
    local pScrollView = ccui.ScrollView:create()
    pScrollView:setClippingEnabled(true)
    pScrollView:setBackGroundColorType(1)
    pScrollView:setBackGroundColor({r = 0, g = 0, b = 0})
    pScrollView:setBackGroundColorOpacity(0)
    pScrollView:setAnchorPoint(0,0)
    pScrollView:setContentSize(cc.size(620,450))
    -- 开启回弹效果
    pScrollView:setBounceEnabled(true)
    -- 隐藏滚动条
    pScrollView:setScrollBarEnabled(false)
    return pScrollView
end

function GiftRecordListView:onClickClose(send)
    self:removeSelf()
end

return  GiftRecordListView
