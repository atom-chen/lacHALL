-- Author: pengxunsheng
-- Date:2018.3.19
-- Describe：礼品商店

local GiftView = class("GiftView", cc.load("ViewPop"))

local GiftGood = import(".GiftGood")

local ComBtn = require("common.tabgroup.TabGroupItem")

GiftView.RESOURCE_FILENAME = "ui/gift/giftView.lua"

GiftView.RESOURCE_BINDING  =
{

    ["ViewNode"] = { ["varname"] = "ViewNode"},

    ["lipin_btn"]    = { ["varname"] = "lipin_btn" , ["events"]={{event="click",method="onGiftViewbtn"}} },
    ["hongbao_btn"]   = { ["varname"] = "hongbao_btn"   , ["events"]={{event="click",method="onGiftViewbtn"}}},
    ["huafei_btn"]   = { ["varname"] = "huafei_btn"  , ["events"]={{event="click",method="onGiftViewbtn"}} },
    ["duihuan_btn"]    = { ["varname"] = "duihuan_btn"   , ["events"]={{event="click",method="onGiftViewbtn"}}},

    ["bt_close_panel"]  = { ["varname"] = "bt_close_panel" ,["events"]={{event="click",method="onClickClose"}}},
}

GiftView.ADD_BLUR_BG = true

--一级的按钮颜色
local GIFT_NOT_SELECT_COLOR = cc.c3b(98, 158, 226)
local GIFT_SELECT_COLOR = cc.c3b(246,230,155)

local GIFT_TABLE =
{
  "lipin","hongbao","huafei","duihuan"
}

local GIFT_VIEW =
{
  ["lipin"] = {"gift.GiftViewShop"},
  ["hongbao"] = {"gift.GiftViewRedPackage"},
  ["huafei"] = {"gift.GiftViewCallCost"},
  ["duihuan"] = {"gift.GiftViewRecord"},
}

--ViewNodeID--唯一标识 礼品卷 "lipin"，话费标签：huafei，红包标签："hongbao" 兑换记录："duihuan"
function GiftView:onCreate(ViewNodeID,propID)
    self._propID = propID
    --右边的界面节点tab
    self._GiftViewNode = {}
    --左边的按钮节点tab
    self._BtnTabNode = {};
    --适配
    self:resetLayout()
    --初始化整个界面按钮
    self:initLayout();
    --
    self:initView(ViewNodeID)
    --查看订单跳转到兑换记录
    self:addEventListener(gg.Event.GIFT_CHECK_RECORD, handler(self, self.OpenRecordNode))
end

function GiftView:initView(ViewNodeID)
    --判断要是不存在的Key值，就默认是第一个,
    local bNode = self:ViewBtnNode(ViewNodeID)
    if  bNode == nil or not bNode:isVisible() then
        for i = 1 ,#GIFT_TABLE do
            local btn = self._BtnTabNode[GIFT_TABLE[i]]
            if btn and  btn:isVisible() then
                ViewNodeID = GIFT_TABLE[i]
                break;
            end
        end
    end

    self:switchViewNode(ViewNodeID)
end

function GiftView:resetLayout()
    self:setScale(math.min(display.scaleX, display.scaleY))
end

--确定选定的界面的，界面的切换
function GiftView:switchViewNode(ViewNodeID)
    --其他的界面
    self:onGiftViewbtn(self:ViewBtnNode(ViewNodeID))
    self.giftid = ViewNodeID
end

function GiftView:initLayout()
    --按钮的节点存起来
    self._BtnTabNode[GIFT_TABLE[1]] = self.lipin_btn
    self._BtnTabNode[GIFT_TABLE[2]] = self.hongbao_btn
    self._BtnTabNode[GIFT_TABLE[3]] = self.huafei_btn
    self._BtnTabNode[GIFT_TABLE[4]] = self.duihuan_btn

    self.lipin_btn:setName("lipin")
    self.hongbao_btn:setName("hongbao")
    self.huafei_btn:setName("huafei")
    self.duihuan_btn:setName("duihuan")
    --红包的开关
    if not GameApp:CheckModuleEnable(ModuleTag[PROP_ID_261]) then
        self.hongbao_btn:setVisible(false)
    end
    --话费的开关
    if not GameApp:CheckModuleEnable(ModuleTag[PROP_ID_PHONE_CARD])  then
       self.huafei_btn:setVisible(false)
    end
    --礼品卷的开关
    if not GameApp:CheckModuleEnable(ModuleTag[PROP_ID_LOTTERY])  then
        self.lipin_btn:setVisible(false)
        self.duihuan_btn:setVisible(false)
    end
    --礼品卷的按钮排序
    local firstPost = self._BtnTabNode[GIFT_TABLE[1]]:getPositionY();

    for i = 1 ,#GIFT_TABLE do
        local btn = self._BtnTabNode[GIFT_TABLE[i]]
        if btn and btn:isVisible() then
            btn:setPositionY(firstPost)
            firstPost = firstPost - btn:getContentSize().height/2 - 40 - self:NextBtnHeight(i)
        end
    end
end
--计算下个按钮的高度
function GiftView:NextBtnHeight(index)
    local btn = self._BtnTabNode[GIFT_TABLE[index]]
    if btn and btn:isVisible() then
        return btn:getContentSize().height/2
    else
        self:NextBtnHeight(index+1)
    end
end
--获取按钮的节点
function GiftView:ViewBtnNode(NodeID)
    return  self._BtnTabNode[NodeID]
end

function GiftView:onGiftViewbtn(send)
    gg.AudioManager:playClickEffect()
    local CurID = send:getName();

    if self.giftid ~= CurID then
        --选择按钮
        self:slectBtnBg(CurID)
        --选择切换界面
        self:slectTabView(CurID);
        if self._GiftViewNode[CurID] == nil then
            self:createViewNode(CurID)
        else
            if CurID == GIFT_TABLE[4] then
                local callback = function(result)
                   if result.status == 0 and #(result["data"])>0 then  --要是有兑换的记录
                      self._GiftViewNode[CurID]:upDataNode(result["data"])
                   end
                end
                gg.Dapi:SendGoodOrders(callback)
            end
        end
        self.giftid = CurID;
    end
end

function GiftView:slectBtnBg(CurID)
    self._BtnTabNode[CurID]:setColor(GIFT_SELECT_COLOR)
    if self.giftid ~= nil then
        self._BtnTabNode[self.giftid]:setColor(GIFT_NOT_SELECT_COLOR)
    end

end

--左边的按钮选择右边的界面处理
function GiftView:slectTabView(id)
    if self.giftid ~= nil then
        if self.ViewNode:getChildByName(self.giftid) then
            self.ViewNode:getChildByName(self.giftid):setVisible(false)
        end
    end
    if id ~= nil then
        if self.ViewNode:getChildByName(id) then
            self.ViewNode:getChildByName(id):setVisible(true)
        end
    end
end

function GiftView:createViewNode(id)
     local data = nil
     if  id == GIFT_TABLE[2]  then
         data = self._propID  and self._propID or PROP_ID_261
     elseif  id == GIFT_TABLE[3]  then
         data = self._propID  and self._propID or PROP_ID_PHONE_CARD
     end
     self:CreateRightScene(id,data)
end

--创建右边的节点
function GiftView:CreateRightScene(NodeId,data)
    local Node = self:getScene():createView(GIFT_VIEW[NodeId][1],data);
    if Node == nil then return  ; end
    Node:setName(NodeId)
    self._GiftViewNode[NodeId] = Node
    self.ViewNode:addChild(Node)
end

--打开兑换记录
function GiftView:OpenRecordNode()
    self:onGiftViewbtn(self._BtnTabNode[GIFT_TABLE[4]])
end

function GiftView:onClickClose()
    self:removeSelf()
end

return GiftView
