--
-- Author: Cai
-- Date: 2017-03-24
-- Describe：升级小秘籍

local M = class("HonorCheatsView", cc.load("ViewPop"))

M.RESOURCE_FILENAME = "ui/honor/honor_cheats_view.lua"
M.RESOURCE_BINDING = {
    ["btn_buy"]   = {["varname"] = "btn_buy", ["events"] = {{["event"] = "click", ["method"] = "onClickBuy"}}},
    ["btn_close"] = {["varname"] = "btn_close", ["events"] = {{["event"] = "click_color", ["method"] = "onClickClose"}}},

    ["view_bg"]    = {["varname"] = "view_bg"},
    ["nd_gift"]    = {["varname"] = "nd_gift"},
    ["txt_title"]    = {["varname"] = "txt_title"},
    ["item_3"]    = {["varname"] = "item_3"},

}

local GRADE_STR = gg.HonorHelper:getGradeStrCfg()
local DESC_TB = {
    "天天登录，天天领福利，升级咻咻地。领取各项奖励可以迅速的升级哦。",
    "懂胡牌，胡大牌，赢局越多，获取的荣誉分就越多哦。",
    "从普通场到精英场到土豪场到至尊场，出入越高级的游戏场，越能获得更多的荣誉分。",
    "VIP等级越高，获得的荣誉分加成就越高哦。边享受VIP待遇边轻松升级吧。",
    "成为贵族月卡用户可以在30天内为您的成长加速哦。",
    "成为星耀月卡用户无上的荣耀可以帮助您在30天内飞速成长。",
}

-- 秘籍1,2为随机生成，其中第5条和第6条不可以同时存在
-- switch 当有一些相关开关关闭时，默认只取前两条提示
local function createRandomTipsTb(switch)
    local tb = {}
    local tipsTb = clone(DESC_TB)
    if switch then
        table.insert(tb, tipsTb[1])
        table.insert(tb, tipsTb[2])
    else
        local idx = math.random(1, 6)
        table.insert(tb, tipsTb[idx])
        if idx == 5 or idx == 6 then
            idx = math.random(1, 4)
        else
            table.remove(tipsTb, idx)
            idx = math.random(1, 5)
        end
        table.insert(tb, tipsTb[idx])
    end
    return tb
end

function M:onCreate(grade)
    self._grade = grade
    self._giftCfg = require("hall.models.StoreData"):GetHonorGoodsTable(self._grade)
    -- 每个用户每个段位随机显示两条秘籍，所以将秘籍字段存在用户字段中
    local descTb = gg.UserData:getConfigByKey("honortips_" .. grade)
    if not descTb then
        descTb = createRandomTipsTb()
        gg.UserData:SetConfigKV({["honortips_" .. grade] = descTb})
    end
    -- 当VIP或者月卡开关关闭时，替换提示
    local cardSwtich = not GameApp:CheckModuleEnable(ModuleTag.Privilege) and not GameApp:CheckModuleEnable(ModuleTag.XYMonthCard)
    local vipSwitch = not GameApp:CheckModuleEnable(ModuleTag.VIP)
    if cardSwtich or vipSwitch then
        descTb = createRandomTipsTb(true)
    end
    self:updateTips(descTb)
    --荣誉开关开启时显示购买页面
    if GameApp:CheckModuleEnable(ModuleTag.HonorGift) then
        self:updateGiftNode()
        self.nd_gift:setVisible(true)
    else
        self.view_bg:setContentSize(cc.size(926, 477 - 115))
        --88荣誉礼包的高度 --120秘籍item的高度
        self.btn_close:setPositionY(self.btn_close:getPositionY() - 88 - 120 )
        self.txt_title:setPositionY(self.txt_title:getPositionY() - 88 - 120 )
        self.item_3:setPositionY(self.item_3:getPositionY() - 88 - 120 )
        self.item_3:setVisible(false)
    end
    -- 注册礼包购买成功回调
    self:addEventListener(gg.Event.ON_PAY_RESULT, handler(self, self.onPayResultsCallBack))
end

function M:updateTips(descTb)

    for i=1,2 do
        local item = self:findNode("item_" .. i)
        item:getChildByName("txt_dec"):setString(descTb[i])
        if string.find(descTb[i], "贵族月卡") then
            self:createMonthCardBtn(item, 1)
        elseif string.find(descTb[i], "星耀月卡") then
            self:createMonthCardBtn(item, 2)
        end
        if  not GameApp:CheckModuleEnable(ModuleTag.HonorGift) then
            item:setPositionY(item:getPositionY() - 88 - 120)
        end
    end
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
    local startX = 248
    local dis = 92
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
        img_icon:setScale(70 / math.max(img_icon:getContentSize().width, img_icon:getContentSize().height))
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
        self.btn_buy:setTouchEnabled(false)
        self.btn_buy:setAllGray(true)
        self.btn_buy:getChildByName("txt_ljyy"):setString("已购买")
    end
end

-- ctype 1:贵族月卡 2:星耀月卡
function M:createMonthCardBtn(nd, ctype)
    cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/newhall.plist")
    local imgPath = gg.IIF(ctype == 1, "hall/store/img_icon_guizu.png", "hall/store/img_icon_xingyao.png")
    local btn = ccui.Button:create()
    btn:loadTextureNormal(imgPath, 0)
    btn:loadTexturePressed(imgPath, 0)
    btn:loadTextureDisabled(imgPath, 0)
    btn:setScale(0.8)
    btn:setPosition(nd:getContentSize().width - 80, nd:getContentSize().height / 2 + 15)
    nd:addChild(btn)

    local img_shadow = ccui.ImageView:create()
    img_shadow:loadTexture("hall/store/img_prop_shadow.png", 0)
    img_shadow:setPosition(cc.p(btn:getContentSize().width / 2, 20))
    img_shadow:setScale(0.8)
    btn:addChild(img_shadow, -1)

    btn:onClickScaleEffect(function()
        gg.AudioManager:playClickEffect()
        self:getScene():createView("active.ActivityView", {first_but_tag = 2}):pushInScene()
        self:removeSelf()
    end)
end

function M:onClickBuy()
    gg.AudioManager:playClickEffect()
    gg.PayHelper:showPay(GameApp:getRunningScene(), self._giftCfg)
end

function M:onClickClose()
    self:removeSelf()
end

function M:onPayResultsCallBack(event, result)
    -- 支付成功,移除支付界面
    if result.status == 0 then
        self:removeSelf()
    end
end

return M
