-- Author: pengxunsheng
-- Date:2018.3.19
-- Describe：礼品商店
local GiftRecord = class("GiftRecord", cc.load("ViewLayout"))

GiftRecord.RESOURCE_FILENAME = "ui/gift/giftRecord.lua"

GiftRecord.RESOURCE_BINDING  =
{
    ["Panel"]  = { ["varname"] = "Panel"},
    ["icon"]   = { ["varname"] = "icon"},
    ["number"] = { ["varname"] = "number"},
    ["name"] = { ["varname"] = "name"},
    ["timer"] = { ["varname"] = "timer"},
    ["dingdan"] = { ["varname"] = "dingdan"},
    --快递名称那栏
    ["kuaidiname"] = { ["varname"] = "kuaidiname"},
    ["kuaidihao"] = { ["varname"] = "kuaidihao"},
    --审核
    ["shenhe"] = { ["varname"] = "shenhe"},
    --发货
    ["fahuo_text"] = { ["varname"] = "fahuo_text"},
    --邮费
    ["youfei_text"] = { ["varname"] = "youfei_text"},

    ["price_text"]   = { ["varname"] = "price_text"},

    ["Panel_fuzhi"]    = { ["varname"] = "Panel_fuzhi",  ["events"]={{event="click",method="onClickCopy" }}},

    ["btn_jdCard"]    = { ["varname"] = "btn_jdCard",  ["events"]={{event="click",method="onClickJD" }}},
}

function GiftRecord:onCreate()
     self._dingdanhao = nil
     self:initView()
end

function GiftRecord:initView()
    self.Panel:retain()
    self.Panel:removeFromParent( true )
    self:addChild( self.Panel )
    self.Panel:release()

    self.Panel_fuzhi:setLocalZOrder(10)
end

function GiftRecord:setRecordInfo(RecordRecord)
    self._RecordRecord = RecordRecord

    --京东卡类型是1的，并且审核状态是通过的
    local isVisible = ((checkint(RecordRecord.type) == 1) and (checkint(RecordRecord.status) == 1)) and true or false
    self.btn_jdCard:setVisible(isVisible)
    self.fahuo_text:setVisible(not isVisible)

    gg.ImageDownload:LoadHttpImageAsyn(RecordRecord.file_path,self.icon)
    self.number:setString(string.format("X %d ", checkint(RecordRecord.number)));
    self.number:setPositionY(self.Panel:getContentSize().height /2 - self.number:getContentSize().height)

    self.name:setString(RecordRecord.goods_name);
    self.timer:setString(RecordRecord.create_time);
    self.dingdan:setString(string.format("订单号：%s", RecordRecord.order_id));
    self.timer:setPosition(cc.p(self.dingdan:getContentSize().width + 100, self.timer:getPositionY() - 1))
    if RecordRecord.status == "1" then
        self.shenhe:setString("审核通过");
    elseif RecordRecord.status == "-1" then
        self.shenhe:setString("审核失败");
    else
        self.shenhe:setString("等待审核");
    end
    --发货的状态
    if RecordRecord.deliver_status == "1" then
        self.fahuo_text:setString("发货成功");
    elseif RecordRecord.deliver_status == "0" then
        self.fahuo_text:setString("待发货");
    end
    --物品类型的分类
    if RecordRecord.type == "0" then  --实物
        self:setInfoType0(RecordRecord)
    else--if RecordRecord.type == "2" then --手机号
        self:setInfoType2(RecordRecord)

    end

end
--type = "0 " 实物的价格邮费快递，订单号
function GiftRecord:setInfoType0(RecordRecord)
    self.price_text:setString(string.format("价格:  %d礼品券", RecordRecord.price));
    self.youfei_text:setString(string.format("邮费:  %d豆", RecordRecord.postage));

    if checkint(RecordRecord.postage) == 0 or RecordRecord.postage == nil then
        self.youfei_text:setVisible(false)
        self.price_text:setPositionY(self.Panel:getContentSize().height /2 - self.price_text:getContentSize().height)
    end

    if RecordRecord.pxpress_number ~= "" then
        self.kuaidiname:setString(string.format("%s", RecordRecord.express));
    else
        self.Panel_fuzhi:setVisible(false)
        self.kuaidiname:setString("暂无快递信息");
        self.kuaidiname:setPosition(cc.p(self.kuaidiname:getPositionX(),self.Panel:getContentSize().height /2 - self.kuaidiname:getContentSize().height))
    end
    self.kuaidihao:setString(RecordRecord.pxpress_number);
    self._dingdanhao = RecordRecord.pxpress_number
end
--type = "2" 虚拟手机号的价格邮费快递，订单号
function GiftRecord:setInfoType2(RecordRecord)
    self.price_text:setString(string.format("价格:  %d礼品券", RecordRecord.price));
    self.youfei_text:setString(string.format("邮费:  %d豆", RecordRecord.postage));

    if checkint(RecordRecord.postage) == 0 or RecordRecord.postage == nil then
        self.youfei_text:setVisible(false)
    end

    self.kuaidiname:setString("联系电话");
    self.kuaidihao:setString(RecordRecord.phone);
    self.youfei_text:setVisible(false)
    self.price_text:setPositionY(self.Panel:getContentSize().height /2 - self.price_text:getContentSize().height)
    self._dingdanhao = RecordRecord.phone
end

function GiftRecord:onClickJD(send)
    -- 播放点击音效
    gg.AudioManager:playClickEffect()
    if checkint(self._RecordRecord.type) == 1 then
        self:getScene():createView("gift.GiftRecordListView", self._RecordRecord):pushInScene()
    end
end

function GiftRecord:onClickCopy (send)
    -- 播放点击音效
    gg.AudioManager:playClickEffect()
    if  self._dingdanhao then
        Helper.CopyToClipboard(self._dingdanhao)
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST,"已复制到剪切板")
    end

end

function GiftRecord:getSize()
    return  self.Panel:getContentSize();
end

return GiftRecord
