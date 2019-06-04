-- Author: pengxunsheng
-- Date:2018.3.19
-- Describe：礼品商店
local GiftViewShop = class("GiftViewShop", cc.load("ViewBase"))

local ComBtn = require("common.tabgroup.TabGroupItem")
local GiftGood = import(".GiftGood")

GiftViewShop.RESOURCE_FILENAME = "ui/gift/giftViewShop.lua"

GiftViewShop.RESOURCE_BINDING  =
{
    ["Panel"] = { ["varname"] = "Panel"},

    ["ViewNode"] = { ["varname"] = "ViewNode"},

    ["img_tishi"] = { ["varname"] = "img_tishi"},

    --红包，话费，礼品卷
    ["lipin_number"] = { ["varname"] = "lipin_number"},
    ["hongbao_number"] = { ["varname"] = "hongbao_number"},
    ["huafei_number"] = { ["varname"] = "huafei_number"},

    --
    ["node_lipin"] = { ["varname"] = "node_lipin"},--礼品卷节点
    ["node_hongbao"] = { ["varname"] = "node_hongbao"},--红包卷节点
    ["node_huafei"] = { ["varname"] = "node_huafei"},--话费卷节点

    ["txt_data"] = { ["varname"] = "txt_data"},--数据

    ["panel_date"] = { ["varname"] = "panel_date"},--暂无数据
}

local PROP_POST =
{
  [1] = 952,
  [2] = 755,
  [3] = 554,
}

function GiftViewShop:onCreate()
   self._proptabel = {}
   --夺宝所需要的礼品卷
   self._lottery = 0
   -- 道具
   self._propDef  = gg.GetPropList()
   --初始化红包数据
   self:initMoneyData();
   --红包卷，礼品卷，话费卷控制
   self:initPropSwitch();
   --请求商品列表
   self:initWeblist()

   --刷新用户数据
   self:addEventListener(gg.Event.HALL_UPDATE_USER_DATA, handler(self, self.initMoneyData))
end

function GiftViewShop:initWeblist()
    local callback = function(result)
        if tolua.isnull(self) then return end
        if not result then return end
        self.txt_data:setVisible(false)
        if result.status == 0 then
            self._goodListGood = result["data"];
            self._lottery = result["lottery"];
            self:addNode()
        else
            self.panel_date:setVisible(true)
        end
    end
    gg.Dapi:SendGiftGoodID(callback)
    self.txt_data:setVisible(true)
end


function GiftViewShop:initPropSwitch()
    -- 礼品卷的开关
    if not GameApp:CheckModuleEnable(ModuleTag[PROP_ID_LOTTERY])  then
       self.node_lipin:setVisible(false)
    end
    --红包的开关
    if not GameApp:CheckModuleEnable(ModuleTag[PROP_ID_261]) then
        self.node_hongbao:setVisible(false)
    end
    --话费的开关
    if not GameApp:CheckModuleEnable(ModuleTag[PROP_ID_PHONE_CARD])  then
       self.node_huafei:setVisible(false)
    end
    self._proptabel[1]=self.node_huafei--话费卷
    self._proptabel[2]=self.node_hongbao--红包卷
    self._proptabel[3]=self.node_lipin--礼品卷
    --
    local Index = 1
    for i = 1,#self._proptabel do
        local btn = self._proptabel[i]
        if btn:isVisible() then
            btn:setPositionX(PROP_POST[Index])
            Index = Index + 1
        end
    end
end

function GiftViewShop:initMoneyData()
    if not hallmanager or not hallmanager.userinfo then
        return
    end
    --元宝
    local userinfo = hallmanager.userinfo
    self.lipin_number:setString(tostring(userinfo.lottery))

    local hfCnt = checkint(checktable(hallmanager:GetPropList())[PROP_ID_PHONE_CARD])
    local hfDef = self._propDef[PROP_ID_PHONE_CARD]
    if hfDef == nil then return ; end
    if hfCnt == 0 then
        self.huafei_number:setString("0")
    else
        self.huafei_number:setString(string.format("%.2f", tonumber(hfCnt *( hfDef.proportion or 1))))
    end

    local hbCnt = checkint(checktable(hallmanager:GetPropList())[PROP_ID_261])
    local hbDef = self._propDef[PROP_ID_261]
    if hbDef == nil then return ; end
    if hbCnt == 0 then
        self.hongbao_number:setString("0")
    else
        self.hongbao_number:setString(string.format("%.2f", tonumber(hbCnt * (hbDef.proportion or 1))))
    end
end

--添加自己的节点要是存在就刷新
function GiftViewShop:addNode()
    local pScrollView = self:createGoodScrollView()
    self.ViewNode:addChild(pScrollView)
    --商品节点
    self:updatGood(pScrollView);
end

function GiftViewShop:createGoodScrollView()
    local pScrollView = ccui.ScrollView:create()
    pScrollView:setClippingEnabled(true)
    pScrollView:setBackGroundColorType(1)
    pScrollView:setBackGroundColor({r = 0, g = 0, b = 0})
    pScrollView:setBackGroundColorOpacity(0)
    pScrollView:setAnchorPoint(0,0)
    pScrollView:setContentSize(cc.size(self.img_tishi:getContentSize().width, 503))
    -- 开启回弹效果
    pScrollView:setBounceEnabled(true)
    -- 隐藏滚动条
    pScrollView:setScrollBarEnabled(false)
    return pScrollView
end

function GiftViewShop:updatGood(pScrollViewNode)
    pScrollViewNode:removeAllChildren()
    local nCol = 4;                                      -- 列数
    local itemCnt = #self._goodListGood
    if GameApp:CheckModuleEnable(ModuleTag.Lottery) then
        itemCnt = itemCnt + 1
    end
    local Row = math.ceil( itemCnt / nCol )       -- 行数
    local innerContainerSize = Row * 253

    -- -- 设置滚动层滑动区域
    local sizeView = cc.size(pScrollViewNode:getContentSize().width, innerContainerSize)
    pScrollViewNode:setInnerContainerSize(sizeView)

    self:addGood(pScrollViewNode)
end


function GiftViewShop:addGood(pScrollViewNode)
    local GoodListdata = self._goodListGood;
    --夺宝的开关
    local LottoActive = true
    if not GameApp:CheckModuleEnable(ModuleTag.Lottery) then
        LottoActive = false
    end
    local Index = 0
    local item = nil
    for i = 0, #GoodListdata do
        if i == 0 and not GoodListdata[i] and  LottoActive then
              item = GiftGood.new("GiftGood");
              item:setInfo(self._lottery)
              item:setFun(function(data)
                  self:getScene():createView("luckybag.LottoView", nil, PROP_ID_LOTTERY):pushInScene()
              end)
              Index = Index + 1
        end
        if GoodListdata[i] then
            item = GiftGood.new("GiftGood");
            item:setInfo(GoodListdata[i])
            item:setFun(function(data )
            GameApp:dispatchEvent(gg.Event.SHOW_LOADING, "数据加载中...")
               --点击商品的购买
               local callback = function(result)
                    GameApp:dispatchEvent(gg.Event.SHOW_LOADING)
                    if tolua.isnull(self) then return end
                    if not result then return end
                    if result.status == 0 then
                        self:getScene():createView("gift.GiftGoodConfirm",result["data"]):pushInScene()
                    end
                end
                gg.Dapi:SendGoodInfo(data.id,data.category_id,callback)
           end )
           Index = Index + 1
        end
        if item then
            item:setPosition(cc.p((Index-1) % 4 * (item:getSize().width+5), (pScrollViewNode:getInnerContainerSize().height) - math.floor((Index-1)/4) * (item:getSize().height + 3)))
            pScrollViewNode:addChild(item);
        end
    end
end

return GiftViewShop
