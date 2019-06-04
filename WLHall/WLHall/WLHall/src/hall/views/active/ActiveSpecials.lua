--[[
    活动里面限时礼包
]]

local ActiveSpecials = class("ActiveSpecials", cc.load("ViewBase"))

ActiveSpecials.RESOURCE_FILENAME="ui/active/activity_tjlb.lua"

ActiveSpecials.RESOURCE_BINDING =
{
    ["imgbg"]  = { ["varname"] = "imgbg" },
    ["time_atlas"]  = { ["varname"] = "time_atlas" }, -- 倒计时文本
    ["img_title"]  = { ["varname"] = "img_title" },

    ["Panel_1"] = { ["varname"] = "Panel_1" , ["events"] = {{["event"] = "click", ["method"] = "onClickBuyBtn" }}},
    ["Panel_2"] = { ["varname"] = "Panel_2" , ["events"] = {{["event"] = "click", ["method"] = "onClickBuyBtn" }}},
    ["Panel_3"] = { ["varname"] = "Panel_3" , ["events"] = {{["event"] = "click", ["method"] = "onClickBuyBtn" }}},
}

function ActiveSpecials:onCreate()

    self.ActiveTime = nil
    -- 获取计费点数据
    self._goods = gg.PopupGoodsData:getSpecialGoods()
    --存按钮的节点
    self._imgGiftTable ={}
    --初始化购买按钮
    self:initBtn()
    --开始时间
    self._startTime = 0
    --结束时间
    self._endTime = 0
    --是否开始活动的标识
    self._timedGoodsStatus = 0
    --限时时间是否开始的状态判断
    self:updateActiveData()
    --获取商品信息
    self:updateGoodsData()
    --设置商品的内容
    self:updateAllGoodsItems()

    --代表活动没有开启
    if self._timedGoodsStatus == 0 then
        self.img_title:setSpriteFrame("hall/active/activespecials/img_qgsj.png")
    end

    --限时时间
    self:startUpdateTimed()
    -- -- 支付通知
    self:addEventListener( gg.Event.ON_POP_PAY, handler( self, self.onPayCallBack ) )
end

--获取商品的信息
function ActiveSpecials:updateGoodsData()
    self._goodsInfos = {}
    for i,v in ipairs(self._goods) do
        self._goodsInfos[i] = gg.PopupGoodsData:getGoodsDataByID(v)
    end
end


function ActiveSpecials:updateAllGoodsItems()
    for i,_ in ipairs(self._goods) do
        self:updateGoodsItem(i)
    end
end
--设置商品的内容
function ActiveSpecials:updateGoodsItem(i)
    if not i or not self._imgGiftTable or not self._imgGiftTable[i] then
        return
    end
    local imgGift = self._imgGiftTable[i]
    if self._goodsInfos and self._goodsInfos[i] then
        local goodsInfo = self._goodsInfos[i]
        imgGift:setVisible(true)
        local img_count_bg = imgGift:getChildByName("Image_icon")
        if img_count_bg then
            local txt_discount = img_count_bg:getChildByName("txt_1")
            if txt_discount then
                local disNum = 0
                if checkint(goodsInfo.ori_price)>0 then
                    disNum = string.format("%.1f",checkint(goodsInfo.price)*10/checkint(goodsInfo.ori_price))
                end
                txt_discount:setString(tostring(disNum) .. "折")
            end
            local txt_limited_count = img_count_bg:getChildByName("txt_2")
            if txt_limited_count then
                txt_limited_count:setString(string.format("限%s次", checkint(goodsInfo.leftTime)))
            end
        end
        --道具
        local txt_gold_dju = imgGift:getChildByName("txt_dju")

        --设置背景图
        local img_bg = imgGift:getChildByName("Image_good")
        if goodsInfo.prop[2][1] == PROP_ID_263 then
            local countStr = string.format( "即时话费劵x%.2f", goodsInfo.prop[2][2]*0.01)
            txt_gold_dju:setString(countStr)
        else
            local mofacount = 0
            for i ,v in pairs(goodsInfo.prop) do
                local propType = v[1]  --id
                local propCount = v[2]  --数量
                if gg.IsMagicProp(propType) then
                    mofacount = mofacount +propCount
                end
            end
            img_bg:loadTexture("hall/active/activespecials/timed_goods_"..i..".png",1)
            if txt_gold_dju then
                txt_gold_dju:setString(string.format("魔法道具x%d",mofacount))
            end
        end
        local txt_gold_num = imgGift:getChildByName("txt_jiage")
        if txt_gold_num then
            txt_gold_num:setString(string.format("%s豆", gg.MoneyUnit(goodsInfo.prop[1][2])))
        end
        local txt_ori_price_num = imgGift:getChildByName("txt_yuanjia")
        if txt_ori_price_num then
            txt_ori_price_num:setString(string.format("原价%s元", goodsInfo.ori_price))
        end
        local link_width = txt_ori_price_num:getSize().width
        local txt_link = imgGift:getChildByName("txt_link")
        txt_link:setContentSize(link_width+3,2)

        local txt_price_num = imgGift:getChildByName("txt_tejia")
        if txt_price_num then
            txt_price_num:setString(string.format("特价%s元", goodsInfo.price))
        end

        local img_buy = imgGift:getChildByName("Image_buy".. tostring(i))
        if img_buy then
            if checkint(goodsInfo.leftTime)>0 and self._timedGoodsStatus == 1 then
                img_buy:setAllGray(false)
                self.imgbg:getChildByName("Panel_".. tostring(i)):setTouchEnabled(true)
            else
                img_buy:setAllGray(true)
                txt_link:setBackGroundColor({ r = 119, g =  119, b =  119 }) --线
                txt_ori_price_num:setTextColor({ r = 119, g =  119, b =  119 }) --原价
                txt_price_num:setTextColor({ r = 34, g =  34, b =  34 }) ----特价
                self.imgbg:getChildByName("Panel_".. tostring(i)):setTouchEnabled(false)
            end
        end
    else
        imgGift:setVisible(false)
    end
end

--支付后刷新数据
function ActiveSpecials:onPayCallBack()
    self:updateGoodsData()
    self:updateAllGoodsItems()
end



--限时时间
function ActiveSpecials:startUpdateTimed()
    self:stopUpdateTimed()
    self:updateTimedAtlas()
    self.time_atlas:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(1), cc.CallFunc:create(handler(self, self.updateTimed)))))
end

function ActiveSpecials:stopUpdateTimed()
    self.time_atlas:stopAllActions()
end

function ActiveSpecials:updateTimed()
    if self._timedGoodsStatus == 1 then
        self:updateTimedAtlas()--倒计时
    end
    local timedGoodsStatus = self._timedGoodsStatus
    self:updateTimedGoodsStatus()
    if timedGoodsStatus~=self._timedGoodsStatus then
        self:updateAllGoodsItems()
    end
end

--倒计时
function ActiveSpecials:updateTimedAtlas()
    if not self.ActiveTime then
        self.ActiveTime = "00:00:00"
    end
    local timeStr = self.ActiveTime
    if self:checkTimedGoodsStatus() then
        local dt = self._endTime - os.time()
        local hours = math.floor(dt / 3600)
        local minutes = math.floor((dt % 3600) / 60)
        local seconds = math.floor(dt % 60)
        if(hours < 10) then hours = "0"..hours end
        if(minutes < 10) then  minutes = "0"..minutes end
        if(seconds < 10) then seconds = "0"..seconds end
        timeStr = ""..hours..":"..minutes..":"..seconds
    end
    self.time_atlas:setString(timeStr)
end

-- -- test data
-- self._startTime = 1522482625
-- self._endTime = 1522492625
function ActiveSpecials:updateActiveData()
    -- dump(os.time(), "os.time()")
    local activeDatas = checktable(gg.UserData:GetWebData("activeswitch"))
    for k,v in pairs(activeDatas) do
        if v.active_tag == gg.ActivityPageData.ACTIVE_TAG_TJLB  then--限时活动的tag标识状态
            self._startTime = (v.start_time and v.start_time) or 0
            self._endTime = (v.end_time and v.end_time) or 0
            -- 显示活动的时间
            self.ActiveTime = os.date("%H:%M:%S",  self._startTime)
            self:updateTimedGoodsStatus()
            break
        end
    end
end
--判断时间是否开始倒计时状态
function ActiveSpecials:updateTimedGoodsStatus()
    if self:checkTimedGoodsStatus() then
        self._timedGoodsStatus = 1
    else
        self._timedGoodsStatus = 0
    end
end
--时间轴
function ActiveSpecials:checkTimedGoodsStatus()
    local nowTime = os.time()
    -- Log(nowTime)
    if self._startTime>0 and self._endTime>0 and nowTime>=self._startTime and nowTime<self._endTime then
        return true
    end

    return false
end


function ActiveSpecials:initBtn()
    for i=1,3 do
        local panel =  self.imgbg:getChildByName("Panel_" .. tostring(i))
        local imgGift = panel:getChildByName("Image_good" .. tostring(i))
        if imgGift then
            self._imgGiftTable[i] = imgGift
        end
    end
end

function ActiveSpecials:onClickBuyBtn(sender)
    local tag = sender:getTag()
    local goodsID = self._goods[tag]
    if goodsID then
        local payType = gg.PayHelper:getPayMethods(goodsID)
        local goodsData = gg.PopupGoodsData:getGoodsDataByID(goodsID)
        if payType and #payType>0 and goodsData then
            if #payType == 1 then
                gg.PayHelper:payByMethod(goodsData , payType[1])
            else
                gg.PayHelper:showPay(GameApp:getRunningScene(), goodsData)
            end
        end
    end
end


return ActiveSpecials
