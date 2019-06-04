-- Author: pengxunsheng
-- Date:2018.3.19
-- Describe：礼品商店
local GiftGoodConfirm = class("GiftGoodConfirm", cc.load("ViewPop"))

GiftGoodConfirm.RESOURCE_FILENAME = "ui/gift/giftGoodConfirm.lua"

GiftGoodConfirm.RESOURCE_BINDING  =
{
    ["img_name"]        = { ["varname"] = "img_name"},
    ["Image_phone"]    = { ["varname"] = "Image_phone"},
    ["img_SeclectBg"]   = { ["varname"] = "img_SeclectBg"},

    ["select_Text"]    = { ["varname"] = "select_Text"},
    ["goodNum"]        = { ["varname"] = "goodNum"},

    ["kefu_btn"]        = { ["varname"] = "kefu_btn" , ["events"]={{event="click",method="onClickKefu"}} },
    ["btn_sucess_kefu"]  = { ["varname"] = "btn_sucess_kefu" , ["events"]={{event="click",method="onClickKefu"}} },

    ["bt_close_panel"]         = { ["varname"] = "bt_close_panel" , ["events"]={{event="click",method="onClickClose"}} },
    ["bt_sucess_panel_close"]  = { ["varname"] = "bt_sucess_panel_close" , ["events"]={{event="click",method="onClickClose"}} },

    ["confirm_btn"]     = { ["varname"] = "confirm_btn"   , ["events"]={{event="click",method="onClickconfirm"}} },--兑换按钮
    ["chcek_btn"]     = { ["varname"] = "chcek_btn"   , ["events"]={{event="click",method="onClickcheck"}} },--查看订单按钮


    ["jian_btn"]   = { ["varname"] = "jian_btn"  , ["events"]={{event="click",method="onClickjian"}} },
    ["add_btn"]    = { ["varname"] = "add_btn"   , ["events"]={{event="click",method="onClickadd"}} },

    ["icon"]        = { ["varname"] = "icon"},
    ["name_Text"]   = { ["varname"] = "name_Text"},
    ["youfei_Text"]   = { ["varname"] = "youfei_Text"},
    ["prince_Text"]   = { ["varname"] = "prince_Text"},


    ["Panel_Buy"]                  = { ["varname"]   = "Panel_Buy"},  --购买的界面
    ["Panel_Buy_Sucess"]           = { ["varname"]   = "Panel_Buy_Sucess"},--购买成功提交的界面
    ["dingdanhao_text"]            = { ["varname"]   = "dingdanhao_text"},  --订单号码
    ["txt_jd"]                     = { ["varname"]   = "txt_jd"},  --京东E卡的提示

    ["lianxiren_Text"]               = { ["varname"]   = "lianxiren_Text"},  --联系人
    ["lianxiPhone_Text"]             = { ["varname"]   = "lianxiPhone_Text"},  --电话
    ["select_Text"]                  = { ["varname"]   = "select_Text"},  --联系人


    ["text_kucun"]               = { ["varname"]   = "text_kucun"},  --库存

}

function GiftGoodConfirm:onCreate(info)
   self._goodBuyNum = 1

   self._goodInfo  = info["data"]

    --联系客服开关
   if not GameApp:CheckModuleEnable( ModuleTag.CustomerService ) then
        self.kefu_btn:setVisible(false)
        self.btn_sucess_kefu:setVisible(false)
   end
   self:initData()
   self:initEditBox()
end

function GiftGoodConfirm:initData()
    gg.ImageDownload:LoadHttpImageAsyn(self._goodInfo.pic,self.icon)

    self.name_Text:setString(self._goodInfo.name);

    self.youfei_Text:setString(string.format( "邮费:%d豆" , checkint(self._goodInfo.postage)));

    self.prince_Text:setString(string.format( "价格:%d礼品券" , self._goodInfo.price));

    --加个判断价格不显示的时候
    if checkint(self._goodInfo.postage) == 0 or self._goodInfo.postage == nil then
        self.youfei_Text:setVisible(false)
        self.prince_Text:setPositionX(self.youfei_Text:getPositionX())
    end

    if checkint(self._goodInfo.total) <= 0 or self._goodInfo.total == nil then
        self.confirm_btn:setAllGray(true)
        self.confirm_btn:setTouchEnabled(false)
    else
        self.text_kucun:setString(string.format("库存数量：%s", self._goodInfo.total))
    end
end

function GiftGoodConfirm:initEditBox()

    --创建名字的EditBox
    local NameSize = cc.size(self.img_name:getContentSize().width, self.lianxiren_Text:getContentSize().height)
    self._NameText = self:creatText(NameSize,"请输入联系人",cc.EDITBOX_INPUT_MODE_ANY)
    if self._NameText then
        self._NameText:setPosition(cc.p(-5,2));
        self.img_name:addChild(self._NameText)
    end

    --创建电话的EditBox
    local PhoneSize = cc.size(self.Image_phone:getContentSize().width, self.lianxiPhone_Text:getContentSize().height)
    self._PhoneText = self:creatText(PhoneSize,"请输入联系人电话",cc.EDITBOX_INPUT_MODE_NUMERIC)
    if self._PhoneText then
        self._PhoneText:setPosition(cc.p(-5,2));
        self._PhoneText:setMaxLength(11);
        self.Image_phone:addChild(self._PhoneText)
    end
    --
    --创建不同的EditBox
    local SelectSize = cc.size(self.img_SeclectBg:getContentSize().width, self.select_Text:getContentSize().height)
    local Text = (self._goodInfo.type  == "0") and "请输入收货地址" or "请确定电话号码"
    local EDITBOX = (self._goodInfo.type  == "0") and cc.EDITBOX_INPUT_MODE_ANY or cc.EDITBOX_INPUT_MODE_NUMERIC
    local SetString = (self._goodInfo.type  == "0") and "收货地址:" or "确认号码:"

    self._SelectChangeText  = self:creatText(SelectSize,Text,EDITBOX)
    if self._SelectChangeText then
        self.select_Text:setString(SetString)
        self._SelectChangeText:setPosition(cc.p(-5,2));
        self.img_SeclectBg:addChild(self._SelectChangeText)
        if (self._goodInfo.type  ~= "0") then
            self._SelectChangeText:setMaxLength(11);
        end
    end
end


function GiftGoodConfirm:creatText(size,placeholder,inputMode)
    local tEditBox = ccui.EditBox:create(size, "_")  --输入框尺寸，背景图片
    tEditBox:setPosition(cc.p(size.width, size.height) )
    tEditBox:setAnchorPoint(cc.p(0, 0) )
    tEditBox:setPlaceHolder(placeholder or "" ) --设置预制提示文本
    tEditBox:setInputMode(inputMode)--输入模型，如整数类型，URL，电话号码等，会检测是否符合
    tEditBox:setInputFlag(cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_ALL_CHARACTERS )
    tEditBox:setPlaceholderFontColor(cc.c3b(169, 169, 169))
    tEditBox:setPlaceholderFontSize(26)--设置默认内容的字体大小
    tEditBox:setFontColor(cc.c3b(169, 169, 169))
    tEditBox:setFontSize(26)--设置输入内容的字体大小
    return tEditBox
end
--兑换客服
function GiftGoodConfirm:onClickKefu(sende)
  -- 播放点击音效
   gg.AudioManager:playClickEffect()
   device.callCustomerServiceApi(ModuleTag.Exchange)
   return
end

function GiftGoodConfirm:onClickClose(sende)
    self:removeSelf()
end

function GiftGoodConfirm:onClickjian()
    self._goodBuyNum = self._goodBuyNum - 1
    if self._goodBuyNum <=0 then
        self._goodBuyNum = 1
    end
    self.goodNum:setString(self._goodBuyNum);

    self.prince_Text:setString(string.format("价格:%d礼品券" , (self._goodInfo.price*self._goodBuyNum)));
end

function GiftGoodConfirm:onClickadd()
   self._goodBuyNum = self._goodBuyNum + 1
   self.goodNum:setString(self._goodBuyNum);

   self.prince_Text:setString(string.format("价格:%d礼品券" , (self._goodInfo.price*self._goodBuyNum)));
end

function GiftGoodConfirm:onClickconfirm(sende)
    -- 播放点击音效
    gg.AudioManager:playClickEffect()
    if (gg.IsFastClick(sende)) then return end
    local goodID = self._goodInfo.id
    local goodType = self._goodInfo.type

    local goodBuyNumber = checkint(self._goodBuyNum)
    local BuyName = self._NameText:getText()
    local BuyPhone = self._PhoneText:getText()
    local diqu  = gg.LocalConfig:GetRegionCode()
    local select = self._SelectChangeText:getText()

    GameApp:dispatchEvent(gg.Event.SHOW_LOADING, "正在兑换中...")
    local callback = function(result)
        GameApp:dispatchEvent(gg.Event.SHOW_LOADING)
        local info = result.msg
        if result.status == 0 then
            self:DuiHuanSucessView(result["data"])
        else
            self:showToast(info)
        end
    end
    gg.Dapi:SendBuyGiftGood(goodID,goodType,goodBuyNumber,BuyName,BuyPhone,diqu,select,callback)
end

--查看订单
function GiftGoodConfirm:onClickcheck(send)
    --查看订单的功能
    self:removeSelf()
    --跳转到兑换记录
    GameApp:dispatchEvent(gg.Event.GIFT_CHECK_RECORD)
end

--切换兑奖成功
function GiftGoodConfirm:DuiHuanSucessView(dingdanhao)
    self.Panel_Buy_Sucess:setVisible(true)
    self.Panel_Buy:setVisible(false)
    self.dingdanhao_text:setString(dingdanhao)
    self.txt_jd:setVisible(checkint(self._goodInfo.type) == 1 and true or false)
end

return  GiftGoodConfirm
