-- Author: pengxunsheng
-- Date:2018.3.19
-- Describe：礼品商店
local GiftViewCallCost = class("GiftViewCallCost", cc.load("ViewBase"))

GiftViewCallCost.RESOURCE_FILENAME = "ui/gift/giftViewCallCost.lua"

GiftViewCallCost.RESOURCE_BINDING  =
{
    ["Panel"] = { ["varname"] = "Panel"},

    -- 兑换人数多少文本
    ["txt_dhhfs"]  = { ["varname"] = "txt_dhhfs" },
    ["txt_number"]  = { ["varname"] = "txt_number" },
    ["txt_dhhfs_next"]  = { ["varname"] = "txt_dhhfs_next" },
    -- 兑换按钮
    ["btn_exchange"]   = { ["varname"] = "btn_exchange" ,["events"]={{event="click",method="onClickExchange"}} },

    --红包，话费，礼品卷文本
    ["huafeiImm_number"] = { ["varname"] = "huafeiImm_number"},
    ["huafei_number"]  = { ["varname"] = "huafei_number"},

    ["number_Iine"]    = { ["varname"] = "number_Iine" },--手机号码的输入
    ["txt_phone_num"]  = { ["varname"] = "txt_phone_num" },--手机号码的输入

    ["txt_xzdhhf"]  = { ["varname"] = "txt_xzdhhf" },--手机号码的输入

    ["node_huafeiImm"] = { ["varname"] = "node_huafeiImm"},--即时话费卷节点
    ["node_huafei"] = { ["varname"] = "node_huafei"},--话费卷节点

}
local PROP_POST =
{
  [1] = 340,
  [2] = 545,
}
function GiftViewCallCost:onCreate(propID)
    self._proptabel = {}

    self._propID = propID
    -- 道具
    self._propDef  = gg.GetPropList()
    --初始化红包数据
    self:initMoneyData();
    --初始化话费的选择
    self:onCheckBoxProp();
    -- 初始化电话的输入框View
    self:initEditView()
    --红包卷，礼品卷，话费卷控制
    self:initPropSwitch();
    --刷新用户数据
    self:addEventListener(gg.Event.HALL_UPDATE_USER_DATA, handler(self, self.initMoneyData))
end

function GiftViewCallCost:initMoneyData()
    --元宝
    local hfCnt = checkint(checktable(hallmanager:GetPropList())[PROP_ID_PHONE_CARD])
    local hfDef = self._propDef[PROP_ID_PHONE_CARD]
    if hfDef == nil then return ; end
    if hfCnt == 0 then
        self.huafei_number:setString("0")
    else
        self.huafei_number:setString(string.format("%.2f", tonumber(hfCnt *( hfDef.proportion or 1))))
    end

    local ImmhfCnt = checkint(checktable(hallmanager:GetPropList())[PROP_ID_263])
    local ImmhfDef = self._propDef[PROP_ID_263]
    if ImmhfDef == nil then return ; end
    if ImmhfCnt == 0 then
        self.huafeiImm_number:setString("0")
    else
        self.huafeiImm_number:setString(string.format("%.2f", tonumber(ImmhfCnt * (ImmhfDef.proportion or 1))))
    end
end

function GiftViewCallCost:initPropSwitch()
    self._proptabel[1]=self.node_huafei--话费卷
    self._proptabel[2]=self.node_huafeiImm--红包卷
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

--初始化View
function GiftViewCallCost:initEditView()
    self._editPhone = nil           -- 电话号码输入框
	  -- 创建电话输入框
    local editPhone = ccui.EditBox:create(cc.size(self.number_Iine:getContentSize().width,self.txt_phone_num:getContentSize().height), "_" )
    editPhone:setPosition(cc.p(self.number_Iine:getContentSize().width /2.5  + 28, 0))
    editPhone:setAnchorPoint(cc.p(0.0, 0.0))
    editPhone:setPlaceHolder("输入要充值的手机号码")
    editPhone:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
    editPhone:setFontSize(35)
    editPhone:setPlaceholderFontSize(30)
    editPhone:setFontColor(cc.c3b(146,62,13))
    self.txt_phone_num:addChild(editPhone)
    self._editPhone = editPhone

    -- 设置兑换人数
    self:setExchangeCount()
end

function GiftViewCallCost:onCheckBoxProp()
    self:initOnCheckBox()

    local proptxts = { "普通话费", "即时话费"}
    cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/room.plist")
    local propCheckPanel = require("common.widgets.RadioButtonGroup"):create()
    propCheckPanel:setText(proptxts)
    propCheckPanel:setSpacingH(700 / #proptxts )
    propCheckPanel:setPosition(cc.p(20, self.txt_xzdhhf:getContentSize().height + 60))
    propCheckPanel:setFontInfo(36, cc.c3b( 38, 155, 88))
    propCheckPanel:setImg("hall/room/friend/bg_btn_01.png","hall/room/friend/btn_point.png")
    self.txt_xzdhhf:addChild(propCheckPanel)

    propCheckPanel:setSelectCallBack(function(index)
        self:onPropType(index)
    end)

    --根据传的值判断是索引到哪个话费，1为普通 2为即时
    local Index = self:_isRealTime() and 2 or 1
    propCheckPanel:setDefaultSelect(Index)
    self:onPropType(Index)
end

function GiftViewCallCost:initOnCheckBox()
    -- 创建普通的红包单选组
    local putonghongbao =  { "50元","100元" }
    cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/room.plist")
    local checkBoxputongPanel = require("common.widgets.RadioButtonGroup"):create()
    checkBoxputongPanel:setText(putonghongbao)
    checkBoxputongPanel:setSpacingH(400 / #putonghongbao )
    checkBoxputongPanel:setPosition(cc.p(self.txt_xzdhhf:getContentSize().width + 50,self.txt_xzdhhf:getContentSize().height / 2))
    checkBoxputongPanel:setFontInfo(36, cc.c3b( 38, 155, 88 ))
    checkBoxputongPanel:setImg("hall/room/friend/bg_btn_01.png","hall/room/friend/btn_point.png")
    checkBoxputongPanel:setName("OrdCall")
    self.txt_xzdhhf:addChild(checkBoxputongPanel)

    -- 创建即时的红包单选组
    local jishihongbao = { "3元", "10元", "50元" }
    cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/room.plist")
    local checkBoxPanel = require("common.widgets.RadioButtonGroup"):create()
    checkBoxPanel:setText(jishihongbao)
    checkBoxPanel:setSpacingH(400 / # jishihongbao )
    checkBoxPanel:setPosition(cc.p(self.txt_xzdhhf:getContentSize().width + 50,self.txt_xzdhhf:getContentSize().height / 2))
    checkBoxPanel:setFontInfo(36, cc.c3b( 38, 155, 88 ))
    checkBoxPanel:setImg("hall/room/friend/bg_btn_01.png","hall/room/friend/btn_point.png")
    checkBoxPanel:setName("ImmCall")
    self.txt_xzdhhf:addChild(checkBoxPanel)
end


function GiftViewCallCost:onPropType(index)
    local tab = {[1] = PROP_ID_PHONE_CARD, [2] = PROP_ID_263}
    self._propID = tab[index]

    self._hfs = self:_isRealTime() and { 3 , 10, 50 } or { 50 , 100 }
    local OrdCall = self.txt_xzdhhf:getChildByName("OrdCall")
    local ImmCall = self.txt_xzdhhf:getChildByName("ImmCall")
    OrdCall:setVisible(not self:_isRealTime())
    ImmCall:setVisible(self:_isRealTime())
end

-- 跳转微信分享
-- data.content      分享内容
-- data.icon         分享图标地址
-- data.url          分享链接地址
-- data.pic          仅分享图片时图片地址
-- 立即兑换
function GiftViewCallCost:onClickExchange(sender)
	    -- 播放点击音效
    gg.AudioManager:playClickEffect()
    -- 电话号码验证
    local phone = self._editPhone:getText()
    if #phone ~= 11 then
        self:showToast( "您输入的手机号不正确" )
        return
    end
    -- 获取单选索引
    local OrdCall = self.txt_xzdhhf:getChildByName("OrdCall")
    local ImmCall = self.txt_xzdhhf:getChildByName("ImmCall")
    local checkBox = self:_isRealTime() and ImmCall or OrdCall
    local checkBoxIndex = checkBox:getSelectIndex()
    printf( " onClickExchange 话费金额："..self._hfs[ checkBoxIndex ] )
    self:showLoading("正在请求兑换...")
    local http = gg.Dapi:ExchangePhoneFee(gg.IIF(self:_isRealTime(), 1, 0), phone, self._hfs[checkBoxIndex], function( data )
        self:showLoading()
        -- 成功
        if checkint( data.status) == 0 then
            local  okc="确定"
            if table.nums(checktable(data.share))>0 then
                okc="分享一下"
            end
            -- 提示
            GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG, data.msg, function(btype)
                if gg.MessageDialog.EVENT_TYPE_OK == btype  and  table.nums(checktable(data.share))>0 then
                    gg.ShareHelper:doShareWebType( checkstring(data.share.content), data.share.icon, data.share.url )

                    --刷新用户数据并且修改红包
                    GameApp:dispatchEvent(gg.Event.HALL_UPDATE_USER_DATA)

                end
            end, {title="兑换成功", ok=okc} )
        elseif checkint(data.status)>100 then
            self:showToast(data.msg or "兑换失败,请检查话费金额或重试！")
        end
    end )
end


--设置已经兑换的人数
function GiftViewCallCost:setExchangeCount()
    self.txt_number:setString(gg.UserData:GetExchangeTelCount())
    self.txt_dhhfs_next:setPositionX(self.txt_number:getPositionX() + self.txt_number:getContentSize().width + 10)
end

-- 是否是即时话费
function GiftViewCallCost:_isRealTime()
    return self._propID == PROP_ID_263
end

return GiftViewCallCost
