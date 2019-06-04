--
-- Author: Cai
-- Date: 2017-03-06
-- Describe：荣誉界面

local M = class("HonorMainView", cc.load("ViewPop"))

M.RESOURCE_FILENAME = "ui/honor/honor_main_view.lua"
M.RESOURCE_BINDING = {
    ["nd_subv"]    = {["varname"] = "nd_subv"},

    ["btn_gift"]   = {["varname"] = "btn_gift",    ["events"] = {{["event"] = "click", ["method"] = "onClickGift"  }}},
	["btn_close"]  = {["varname"] = "btn_close",   ["events"] = {{["event"] = "click_color", ["method"] = "onClickClose"  }}},
    ["tab_level"]  = {["varname"] = "tab_level",   ["events"] = {{["event"] = "click", ["method"] = "onClickLevel"  }}},
    ["tab_rank"]   = {["varname"] = "tab_rank",    ["events"] = {{["event"] = "click", ["method"] = "onClickRank"   }}},
    ["tab_service"]= {["varname"] = "tab_service", ["events"] = {{["event"] = "click", ["method"] = "onClickService"}}},

    ["nd_gift"]    = {["varname"] = "nd_gift"},

}
M.ADD_BLUR_BG = true

local SERVICE_TAG = ModuleTag.PersonInfo
local GRADE_STR = gg.HonorHelper:getGradeStrCfg()

function M:onCreate(btnTabData)
    self:setScale(math.min(display.scaleX, display.scaleY))
    -- 客服开关显示
    self.tab_service:setVisible(GameApp:CheckModuleEnable(ModuleTag.CustomerService))
    -- 审核模式不显示排行
    if IS_REVIEW_MODE then
        self.tab_rank:setVisible(false)
        self.tab_service:setPositionY(self.tab_rank:getPositionY())

    end

    self.btnTabData = checkstring(btnTabData)
    self._preTab = nil
    self._grade = 1
    self._star = 0
    self._maxexp = 0
    if hallmanager and hallmanager.userinfo then
        self._hlvExp = hallmanager:GetHonorValue()
        self._grade, self._star, self._maxexp = gg.GetHonorGradeAndLevel(self._hlvExp)
    end
    self._giftCfg = require("hall.models.StoreData"):GetHonorGoodsTable(self._grade)
    self:addEventListener(gg.Event.ON_PAY_RESULT, handler(self, self.onPayResultsCallBack))
end

function M:onEnter()
    GameApp:dispatchEvent(gg.Event.SHOW_LOADING, "数据加载中...")
    -- 请求web数据
    gg.HonorHelper:getUserHonorRanking(function(data, errMsg)
        if tolua.isnull(self) then return end
        if errMsg then
            GameApp:dispatchEvent(gg.Event.SHOW_TOAST, errMsg)
        else
            self._uRank = data

            if self.btnTabData == "rank" then
                self.tab_level:setColor(cc.c3b(98, 158, 226))
                self:onClickRank(self.tab_rank)
            else
                self:showLevelSubView(self.tab_level)
            end
        end
        GameApp:dispatchEvent(gg.Event.SHOW_LOADING)
    end)

end


-- 礼包信息
function M:updateGiftNode()
    local nd = self:findNode("nd_gift")
    -- 段位图片
    local img = nd:findNode("gift_grade")
    img:loadTexture("hall/honor/grade_img_" .. self._grade .. ".png", 1)
    -- 礼包名字
    nd:getChildByName("txt_gift"):setString(tostring(GRADE_STR[self._grade]))
    -- 价格
    local txt_ori = nd:getChildByName("txt_ori")
    local txt_price = nd:getChildByName("txt_price")
    if IS_REVIEW_MODE then
        txt_ori:setVisible(false)
        txt_price:setPositionY(43)
        txt_price:setString("现价:¥" .. self._giftCfg.price)
    else
        txt_ori:setString(string.format("原价:¥%d", self._giftCfg.price * 2))
        txt_price:setString("特价:¥" .. self._giftCfg.price)
    end

    local propCfg = checktable(require("hall.models.StoreData"):GetHonorGiftPropsCfg(self._grade))
    -- 计算item的位置排布
    local startX = 220
    local dis = 79
    for i,v in ipairs(propCfg) do
        local item = nd:getChildByName("gift_item"):clone()
        item:setVisible(true)
        item:setPosition(cc.p(startX + dis * (i - 1), 42))
        nd:addChild(item)
        -- 奖励图片
        local prop = gg.GetPropList()[v[1]]
        local img_icon = item:getChildByName("img_prop")
        img_icon:loadTexture(prop.icon)
        img_icon:ignoreContentAdaptWithSize(true)
        img_icon:setScale(65 / math.max(img_icon:getContentSize().width, img_icon:getContentSize().height))
        -- 奖励数量
        local cnt = v[2] * (prop.proportion or 1)
        if v[1] == PROP_ID_MONEY then
            cnt = gg.MoneyUnit(v[2])
        end
        local cntStr = "x" .. cnt
        item:getChildByName("txt_cnt"):setString(cntStr)
    end

    -- 每个段位的荣誉礼包只能购买一次
    if not gg.UserData:CanBuyCurGradeHonorGift(self._grade) then
        self.btn_gift:setTouchEnabled(false)
        self.btn_gift:setAllGray(true)
        self.btn_gift:getChildByName("txt_ljyy"):setString("已购买")
    end
end

function M:setBtnState(btn, isSelect)
    if not btn then return end
    local color = gg.IIF(isSelect, cc.c3b(246, 230, 155), cc.c3b(98, 158, 226))
    btn:setColor(color)
end

-- 荣誉等级
function M:onClickLevel(sender)
    gg.AudioManager:playClickEffect()
    self.nd_gift:setVisible(false)
    self:showLevelSubView(sender)
end

function M:showLevelSubView(sender)
    if self._preTab and self._preTab == sender then return end
    self:setBtnState(self._preTab, false)
    self:setBtnState(sender, true)
    self._preTab = sender
    if self._rankSubV then self._rankSubV:setVisible(false) end
    if self._levelSubV then
        self._levelSubV:setVisible(true)
    else
        self._levelSubV = self:getScene():createView("honor.HonorLevelSubView", self._grade,self._uRank)
        self.nd_subv:addChild(self._levelSubV)
    end
end

-- 排行
function M:onClickRank(sender)
    gg.AudioManager:playClickEffect()
    --开启荣誉开关时显示购买
    if GameApp:CheckModuleEnable(ModuleTag.HonorGift) then
        self.nd_gift:setVisible(true)
        self:updateGiftNode()
    end

    if self._preTab and self._preTab == sender then return end
    self:setBtnState(self._preTab, false)
    self:setBtnState(sender, true)
    self._preTab = sender
    if self._levelSubV then self._levelSubV:setVisible(false) end
    if self._rankSubV then
        self._rankSubV:setVisible(true)
    else
        self._rankSubV = self:getScene():createView("honor.HonorRankSubView", self._uRank)
        self.nd_subv:addChild(self._rankSubV)
    end
end

-- 联系客服
function M:onClickService()
    gg.AudioManager:playClickEffect()
    device.callCustomerServiceApi(SERVICE_TAG)
end

-- 立即拥有
function M:onClickGift()
    gg.AudioManager:playClickEffect()
    gg.PayHelper:showPay(GameApp:getRunningScene(), self._giftCfg)
end

function M:onClickClose()
    self:removeSelf()
end

-- 支付成功,刷新荣誉等级礼包购买按钮
function M:onPayResultsCallBack(event, result)
    if result.status == 0 then
        self.btn_gift:setTouchEnabled(false)
        self.btn_gift:setAllGray(true)
        self.btn_gift:getChildByName("txt_ljyy"):setString("已购买")
        -- 购买成功，修改礼包状态
        gg.UserData:SetCurGradeHonorGift(self._grade)
        self:getScene():createView("honor.HonorBuySuccessView", self._grade):pushInScene()
    end
end

return M