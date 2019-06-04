--
-- Author: liacheng
-- Date: 2017-04-16 20:30


local ExitBuyView = class("ExitBuyView", cc.load("ViewPop"))

ExitBuyView.RESOURCE_FILENAME="ui/popupGoodsView/exit_buy_view.lua"

ExitBuyView.RESOURCE_BINDING =
{
    ["Panel"]  = { ["varname"] = "Panel" },
    ["time_atlas"]  = { ["varname"] = "time_atlas" },

    ["btn_buy"]   = { ["varname"] = "btn_buy" ,["events"]={{event="click",method="onClickBuyBtn"}} },   --支付

    ["btn_exit"]   = { ["varname"] = "btn_exit" ,["events"]={{event="click",method="onClickExit"}} },   --确认退出

    ["btn_cancel"]   = { ["varname"] = "btn_cancel" ,["events"]={{event="click",method="onClickCancel"}} },  --返回大厅

}

function ExitBuyView:create( data )
    return self.new(nil, "ExitBuyView", data)
end

function ExitBuyView:onCreate( data )

    self.goodsid = data or "goods181"
    --开始时间
    self._startTime = 0
    --结束时间
    self._endTime = 0
    --是否开始活动的标识
    self._timedGoodsStatus = 0
    --限时时间是否开始的状态判断
    self:updateActiveData()

    --限时时间
    self:startUpdateTimed()

    --设置商品的内容
    self:getGoodsItem()
    -- 支付通知
    self:addEventListener( gg.Event.ON_PAY_RESULT, handler( self, self.onPayCallBack ) )

end
--获取数据
function ExitBuyView:getGoodsItem()
    self.propid = 1
    if self.goodsid == "goods181" then
        self.propid = 1
    elseif self.goodsid == "goods182" then
        self.propid = 2
    elseif self.goodsid == "goods183" then
        self.propid = 3
    end

    --商品数据
    local goodsdata = gg.PopupGoodsData:getGoodsDataByID(self.goodsid)
    if not goodsdata then
        return
    end
    self:updateGoodsItem(goodsdata)
end
--设置商品的内容
function ExitBuyView:updateGoodsItem(data)
    if not data and  not data.prop  then
        return
    end
    local goodsdata = data
    local good = self.Panel:getChildByName("Image_good")
    local img_count_bg = good:getChildByName("Image_icon")

    --设置几折 和限制购买次数
    if img_count_bg then
        local txt_discount = img_count_bg:getChildByName("txt_1")
        if txt_discount then
            local disNum = 0
            if checkint(goodsdata.ori_price)>0 then
                disNum = string.format("%.1f",checkint(goodsdata.price)*10/checkint(goodsdata.ori_price))
            end
            txt_discount:setString(tostring(disNum) .. "折")
        end
        local txt_limited_count = img_count_bg:getChildByName("txt_2")
        if txt_limited_count then
            txt_limited_count:setString(string.format("限%s次", checkint(goodsdata.leftTime)))
        end
    end
    --原价 特价
    local explain = self.Panel:getChildByName("img_explain")
    local txt_ori_price_num = explain:getChildByName("txt_yuanjia")
    if txt_ori_price_num then
        txt_ori_price_num:setString(string.format("原价%s元", goodsdata.ori_price))
    end
    local txt_price_num = explain:getChildByName("txt_tejia")
    if txt_price_num then
        txt_price_num:setString(string.format("特价%s元", goodsdata.price))
    end
    --立即抢购
    local btn_buy = explain:getChildByName("btn_buy")
    if btn_buy then
        local txt_buy = btn_buy:getChildByName("txt_buy")
        if checkint(goodsdata.leftTime)>0 and self._timedGoodsStatus == 1 then
            btn_buy:setTouchEnabled(true)
            if txt_buy then
                txt_buy:setTextColor({r = 164, g = 61, b = 21})
                txt_buy:setString("立即抢购")
            end
        else
            btn_buy:setTouchEnabled(false)
            if txt_buy then
                txt_buy:setTextColor({r = 46, g = 49, b = 50})
                txt_buy:setString("已售罄")
            end
        end
    end
    --加载道具
    local giftProps = good:getChildByName("img_frame")
    -- 数量显示控件
    local txt_count = giftProps:getChildByName( "txt_count" )
    local img_prop = giftProps:getChildByName( "img_prop" )  --道具图片
    img_prop:ignoreContentAdaptWithSize(true)
    img_prop:loadTexture("hall/active/activespecials/timed_goods_gold_"..self.propid..".png",1)

    if txt_count then
        txt_count:setString(string.format("%s豆", gg.MoneyUnit(goodsdata.prop[1][2])))
    end
end

--限时时间
function ExitBuyView:startUpdateTimed()
    self:stopUpdateTimed()
    self:updateTimedAtlas()
    self.time_atlas:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(1), cc.CallFunc:create(handler(self, self.updateTimed)))))
end
function ExitBuyView:stopUpdateTimed()
    self.time_atlas:stopAllActions()
end
--支付成功关闭页面
function ExitBuyView:onPayCallBack()
    -- 支付成功,移除界面
    if result.status == 0 then
        self:removeSelf()
    end
end

function ExitBuyView:updateTimed()
    if self._timedGoodsStatus == 1 then
        self:updateTimedAtlas()--倒计时
    end
    local timedGoodsStatus = self._timedGoodsStatus
    self:updateTimedGoodsStatus()
    if timedGoodsStatus~=self._timedGoodsStatus then
        self:getGoodsItem()
    end
end

--倒计时
function ExitBuyView:updateTimedAtlas()

    local timeStr = "00:00:00"
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
--时间轴
function ExitBuyView:checkTimedGoodsStatus()
    local nowTime = os.time()
    if self._startTime>0 and self._endTime>0 and nowTime>=self._startTime and nowTime<self._endTime then
        return true
    end

    return false
end
--获取特价礼包的时间
function ExitBuyView:updateActiveData()
    local activeDatas = checktable(gg.UserData:GetWebData("activeswitch"))
    for k,v in pairs(activeDatas) do
        if v.active_tag == gg.ActivityPageData.ACTIVE_TAG_TJLB  then--限时活动的tag标识状态
            self._startTime = v.start_time or 0
            self._endTime = v.end_time or 0
            self:updateTimedGoodsStatus()
            break
        end
    end
end

--判断时间是否开始倒计时状态
function ExitBuyView:updateTimedGoodsStatus()
    if self:checkTimedGoodsStatus() then
        self._timedGoodsStatus = 1
    else
        self._timedGoodsStatus = 0
    end
end

--支付按钮
function ExitBuyView:onClickBuyBtn(sender)
    if self.goodsid then
        local payType = gg.PayHelper:getPayMethods(self.goodsid)
        local goodsData = gg.PopupGoodsData:getGoodsDataByID(self.goodsid)
        if payType and #payType>0 and goodsData then
            if #payType == 1 then
                gg.PayHelper:payByMethod(goodsData , payType[1])
            else
                gg.PayHelper:showPay(GameApp:getRunningScene(), goodsData)
            end
        end
    end
end
--退出游戏
function ExitBuyView:onClickExit(sender)
     if GameApp.Exit then
        GameApp:Exit()
     end
end
--返回游戏
function ExitBuyView:onClickCancel(sender)
    self:removeSelf()
end


return ExitBuyView