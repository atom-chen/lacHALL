
-- Author: Cai
-- Date: 2017-06-23
-- Describe：游戏商城

local M = class("StoreView", cc.load("ViewPop"))
M.RESOURCE_FILENAME="ui/store/view_store.lua"
M.RESOURCE_BINDING = {
    ["con_node"]     = {["varname"] = "con_node"     },
    ["title_bg"]     = {["varname"] = "title_bg"     },                                  --标题背景
    ["menu_node"]    = {["varname"] = "menu_node"    },                                  --标题背景
    ["node_bean"]    = {["varname"] = "node_bean"    },                                  -- 豆豆
    ["txt_bean"]     = {["varname"] = "txt_bean"     },                                  -- 豆豆数
    ["node_has_vip"] = {["varname"] = "node_has_vip" },                                  -- 无Vip
    ["txt_vip_cur"]  = {["varname"] = "txt_vip_cur"  },                                  -- 等级描述
    ["txt_vip_next"] = {["varname"] = "txt_vip_next" },                                  -- 等级描述
    ["txt_vip_vn"]   = {["varname"] = "txt_vip_vn"   },
    ["pro_bar_vip"]  = {["varname"] = "pro_bar_vip"  },                                  -- VIP进度
    ["close_btn"]    = {["varname"] = "close_btn",    ["events"] = {{["event"] = "click", ["method"] = "onClickClose"}}},             -- 关闭按钮
    ["btn_more_vip"] = {["varname"] = "btn_more_vip", ["events"] = {{["event"] = "click", ["method"] = "onClickMore"}}},        -- 特权更多按钮
    ["btn_bean"]     = {["varname"] = "btn_bean",     ["events"] = {{["event"] = "click", ["method"] = "onTabClicked"}}},
    ["btn_prop"]     = {["varname"] = "btn_prop",     ["events"] = {{["event"] = "click", ["method"] = "onTabClicked"}}},
    ["btn_diamond"]  = {["varname"] = "btn_diamond",  ["events"] = {{["event"] = "click", ["method"] = "onTabClicked"}}},
    ["btn_kefu"]     = {["varname"] = "btn_kefu",     ["events"] = {{["event"] = "click", ["method"] = "onClickService"}}},
}
M.ADD_BLUR_BG = true

local TAB_BTN_WIDTH = 200
local TAB_STR_TAG = 102
local TITLE_HEIGHT = 80
local MENU_BTN_X = 0
local MENU_BTN_HEIGHT = 130
local TAB_SELECT_COLOR = cc.c3b(246, 230, 155)
local TAB_UNSELECT_COLOR = cc.c3b(98, 158, 226)

local PropsItem = import(".PropsItem")
-- 商品信息
local StoreData = require("hall.models.StoreData")

-- tabidx:"prop"-道具 "bean"-微乐豆 "diamond"-钻石
function M:onCreate(tabidx)
    self._tabidx = tabidx
    self:setScale(math.min(display.scaleX, display.scaleY))
    self:addEventListener(gg.Event.HALL_UPDATE_USER_DATA, handler(self, self.onEventUpdateUserData_))

    self:initTab()
    self:initView()
end

function M:onEnter()
    if not self._tabidx then
        self:onTab(self.btn_bean)
    else
        self:onSelectTab(self._tabidx)
    end
end

function M:initTab()
    -- 微乐显示微乐豆
    local text = self.btn_bean:getChildByName("txt_name")
    text:setString(BEAN_NAME)

    for _,v in pairs(self.menu_node:getChildren()) do
        v:setVisible(false)
    end

    self._BtnTabNode = {self.btn_bean}
    self.btn_bean:setVisible(true)
    self.btn_bean.childname = "bean_subv"
    -- 道具
    if GameApp:CheckModuleEnable(ModuleTag.S_PROP) then
        self.btn_prop:setVisible(true)
        table.insert(self._BtnTabNode, self.btn_prop)
        self.btn_prop.childname = "prop_subv"
    end
    -- 钻石
    if GameApp:CheckModuleEnable(ModuleTag.Diamond) then
        table.insert(self._BtnTabNode, self.btn_diamond)
        self.btn_diamond:setVisible(true)
        self.btn_diamond.childname = "diamond_subv"
    end
    -- 客服
    if GameApp:CheckModuleEnable( ModuleTag.CustomerService ) then
        table.insert(self._BtnTabNode, self.btn_kefu)
        self.btn_kefu:setVisible(true)
    end

    -- 设置tab按钮的位置
    local firstPost = self._BtnTabNode[1]:getPositionY()
    for i,btn in ipairs(self._BtnTabNode) do
        btn:setPositionY(firstPost)
        firstPost = firstPost - btn:getContentSize().height/2 - 40 - self:NextBtnHeight(i)
    end
end

function M:initView()
    if not GameApp:CheckModuleEnable(ModuleTag.VIP) then
        self:hideVipNode()
    end
    -- 刷新VIP节点显示
    self:onEventUpdateUserData_()
end

function M:updateShopSubview(vname, cfg)
    assert(cfg, "stroe data is nil")
    if not self[vname] then
        self[vname] = self:createTabPage()
        self.con_node:addChild(self[vname])
    end
    self:updatePropData(self[vname], cfg)
    self[vname]:setVisible(true)
end

function M:updatePropData(tab_node, data)
    -- 先清除之前的子节点
    tab_node:removeAllChildren()
    -- 创建可显示的item
    local itemsTb = {}
    for i,v in ipairs(checktable(data)) do
        local hideItem = false
        local payMethods = gg.PayHelper:getPayMethods(v.goods)
        -- 开关
        if v.srcprop or (#payMethods > 0 and (not gg.PayHelper:isGoodsDisabled(v.goods))) then
            local item = PropsItem.new("PropsItem")
            item:setData(v)
            item:setFun(function(data)
                -- goodsName 商品名称(包含数量), price 价格, count 数量
                gg.PayHelper:showPay(GameApp:getRunningScene(), data, nil, 0, 0, gg.PayHelper.PayStages.HALL)
            end)
            tab_node:addChild(item)
            table.insert(itemsTb, item)
        end
    end

    -- 设置创建出的item的位置
    local vNum = 4                               -- 列数
    local hNum = math.ceil(#itemsTb / vNum)      -- 行数
    local innerH = math.max(hNum * 254, tab_node:getContentSize().height)
    tab_node:setInnerContainerSize(cc.size(tab_node:getContentSize().height, innerH))
    for i,item in ipairs(itemsTb) do
        local size = item:getSize()
        item:setPosition(cc.p((i-1) % vNum * (size.width+4), tab_node:getInnerContainerSize().height - math.floor((i-1) / vNum) * (size.height+6)))
    end
end

--==============================--
-- 点击事件
--==============================--
function M:onTabClicked(sender)
    gg.AudioManager:playClickEffect()
    self:onTab(sender)
end

function M:onTab(sender)
    if self._preTab and self._preTab == sender then return end
    self._preTab = sender
    for i,btn in ipairs(self._BtnTabNode) do
        local tabColor = gg.IIF(btn == sender, TAB_SELECT_COLOR, TAB_UNSELECT_COLOR)
        btn:color(tabColor)
        if self[btn.childname] then
            self[btn.childname]:setVisible(btn == sender)
        end
    end

    if self[sender.childname] then return end

    local cfg = nil
    if sender == self.btn_bean then
        cfg = StoreData:GetBeanShopCfg()
    elseif sender == self.btn_diamond then
        cfg = StoreData:GetDiamondShopCfg()
    elseif sender == self.btn_prop then
        cfg = StoreData:GetPropShopCfg()
    end
    self:updateShopSubview(sender.childname, cfg)
end

function M:onSelectTab(idx)
    local tab = self["btn_" .. idx]
    if tab and Table:isValueExist(self._BtnTabNode, tab) then
        self:onTab(tab)
    else
        self:onTab(self.btn_bean)
    end
end

-- 客服按钮回调按钮
function M:onClickService(obj)
    gg.AudioManager:playClickEffect()
    device.callCustomerServiceApi(ModuleTag.Store)
end

-- 打开特权界面回调
function M:onClickMore()
    gg.AudioManager:playClickEffect()
    self:getScene():createView("store.VipDetailed", true):pushInScene()
end

-- 关闭界面按钮
function M:onClickClose()
    self:removeSelf()
end

--==============================--
-- 显示控制
--==============================--
function M:onEventUpdateUserData_(event, userinfo, propid, propvalue)
    if not hallmanager or not hallmanager.userinfo then
        return
    end

    local hallUserinfo = hallmanager.userinfo
    self.vipexp_ = hallUserinfo.vipvalue
    local lv, minExp, nextExp = gg.GetVipLevel(self.vipexp_)
    self.isvipuser_ = lv > 0
    self.xzmoney_= checkint(hallUserinfo.xzmoney)
    local jinDou = hallUserinfo.money or 0
    self.txt_bean:setString(String:numToZn(jinDou, 4, 2))

    self:showVipNode()
end

-- 显示Vip
function M:showVipNode()
    if not GameApp:CheckModuleEnable(ModuleTag.VIP) then
        self:hideVipNode()
        return
    end

    -- 设置Vip值
    if self.isvipuser_ then
        -- 等级
        local lv,minexp,maxexp = gg.GetVipLevel(self.vipexp_)
        local maxLevel = #(gg.GetVipTable()) - 1
        local isMax = (lv >= maxLevel)

        local cur = self.vipexp_
        local per = (math.abs( self.vipexp_-minexp) / (maxexp-minexp ) )
        if isMax then
            self.txt_vip_next:setVisible(false)
            self.txt_vip_vn:setVisible(false)
            per = 1
        else
            self.txt_vip_next:setString((tonumber(lv) + 1))
        end
        -- 等级描述
        self.pro_bar_vip:setPercent(per * 100)
        self.txt_vip_cur:setString(tostring(lv))
    end
end

-- 隐藏Vip
function M:hideVipNode()
    self.node_has_vip:setVisible(false)
    self.btn_more_vip:setVisible(false)
end

--计算下个按钮的高度
function M:NextBtnHeight(index)
    local btn = self._BtnTabNode[index]
    if btn and btn:isVisible() then
        return btn:getContentSize().height/2
    else
        return self:NextBtnHeight(index+1)
    end
end

function M:createTabPage()
    local sv_props = ccui.ScrollView:create()
    sv_props:setContentSize( cc.size(1096, 504))
    sv_props:setBounceEnabled(true)
    sv_props:setScrollBarEnabled(false)
    return sv_props
end

function M:removeSelf()
    GameApp:dispatchEvent(gg.Event.STORE_VIEW_CLOSE)
    M.super.removeSelf(self)
end

return M
