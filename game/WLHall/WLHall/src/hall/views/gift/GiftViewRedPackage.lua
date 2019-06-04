-- Author: pengxunsheng
-- Date:2018.3.19
-- Describe：礼品商店
local GiftViewRedPackage = class("GiftViewRedPackage", cc.load("ViewBase"))
GiftViewRedPackage.RESOURCE_FILENAME = "ui/gift/giftViewRedPackage.lua"
GiftViewRedPackage.RESOURCE_BINDING  =
{
    ["Panel"]  = { ["varname"] = "Panel"},

    ["hongbaoView_Bg"]    = { ["varname"] = "hongbaoView_Bg"},
    ["panel_exc"]  = { ["varname"] = "panel_exc"},

    ["txt_ms"] = { ["varname"] = "txt_ms"},            -- 描述文本

    ["txt_number"] = { ["varname"] = "txt_number"},            -- 领取的人数
    ["txt_lqrs_next"] = { ["varname"] = "txt_lqrs_next"},      -- 领取的人数

    ["txt_xzdhhf"] = { ["varname"] = "txt_xzdhhf"},    --选择领取的金额文本

    ["txt_hbdhm"] = { ["varname"] = "txt_hbdhm"},      -- 二维码的数字
    --兑换的界面
    ["btn_exchange"]  = { ["varname"] = "btn_exchange", ["events"]={{event="click",method="onClickExchange" }} },   -- 兑换按钮
    ["panel_gzgzh"]   = { ["varname"] = "panel_gzgzh",    ["events"]={{event="click",method="onClickGzgzh"    }} },   -- 打开关注公众号界面
    --兑换成功的界面
    ["btn_copy"]      = { ["varname"] = "btn_copy",     ["events"]={{event="click",method="onClickCopy"   }} },   -- 复制按钮
    ["btn_open_wx"]   = { ["varname"] = "btn_open_wx",  ["events"]={{event="click",method="onClicOpenWx"  }} },   -- 打开微信
    --气泡的界面
    ["img_qp"]         = { ["varname"] = "img_qp" },  --气泡图片
    ["btn_save"]         = { ["varname"] = "btn_save",  ["events"]={{event="click",method="onClickSave" }} },   -- 保存二维码按钮
    -- 关闭关注界面
    ["panel_gzqp"]    = { ["varname"] = "panel_gzqp",    ["events"]={{event="touch",method="onClickCloseGz"    }} },

    --红包，话费，礼品卷
    ["lipin_number"] = { ["varname"] = "lipin_number"},
    ["hongbao_number"] = { ["varname"] = "hongbao_number"},
    ["huafei_number"] = { ["varname"] = "huafei_number"},

    ["bt_close_panel"]  = { ["varname"] = "bt_close_panel" ,["events"]={{event="click",method="onClickExcClose"}}},
    --

    ["node_lipin"] = { ["varname"] = "node_lipin"},--礼品卷节点
    ["node_hongbao"] = { ["varname"] = "node_hongbao"},--红包卷节点
    ["node_huafei"] = { ["varname"] = "node_huafei"},--话费卷节点

    ["txt_wlgfgzh"] = { ["varname"] = "txt_wlgfgzh"},       --红包界面的上面的公众号文本
    ["txt_wlgfgzh_0"] = { ["varname"] = "txt_wlgfgzh_0"},   --兑换红包界面成功上面的公众号文本
    ["img_erweima"] = { ["varname"] = "img_erweima"},       --二维码的图片
}

local PROP_POST =
{
  [1] = 340,
  [2] = 545,
  [3] = 751,
}
function GiftViewRedPackage:onCreate(propID)
    self._proptabel = {}
    -- 红包 ID
    self._propID = propID
    -- 道具
    self._propDef  = gg.GetPropList()
    --判断微乐还是吉祥心悦
    self:initFirmName()
    -- 初始化
    self:init()
    -- 初始化View
    self:initView();
    --初始化红包数据
    self:initMoneyData();
    --红包卷，礼品卷，话费卷控制
    self:initPropSwitch();
    --刷新用户数据
    self:addEventListener(gg.Event.HALL_UPDATE_USER_DATA, handler(self, self.initMoneyData))
end

--红包界面判断显示是微乐还是吉祥心悦
function GiftViewRedPackage:initFirmName()
     self.txt_wlgfgzh:setString(string.format("【%s游戏官方公众号 】",PLATFORM_NAME))
     self.txt_wlgfgzh_0:setString(string.format("【%s游戏官方公",PLATFORM_NAME))
     --二维码的图片
     self.img_erweima:loadTexture(CUR_PLATFORM.."/img_ewm.jpg",0)
end

function GiftViewRedPackage:initPropSwitch()
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
    self._proptabel[1]= self.node_hongbao--红包卷
    self._proptabel[2]= self.node_huafei --话费卷
    self._proptabel[3]= self.node_lipin  --礼品卷
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

function GiftViewRedPackage:initMoneyData()
    --元宝
    local userinfo = hallmanager.userinfo
    self.lipin_number:setString(tostring(userinfo.lottery))

    local hfCnt = checkint(checktable(hallmanager:GetPropList())[PROP_ID_PHONE_CARD])
    local hfDef = self._propDef[PROP_ID_PHONE_CARD]
    if hfDef == nil then return ; end
    if hfCnt == 0 then
        self.huafei_number:setString("0")
    else
        self.huafei_number:setString(string.format("%.2f", tonumber(hfCnt * (hfDef.proportion or 1))))
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

--初始化
function GiftViewRedPackage:init()
    -- 兑换码
    self._exchCode = nil
    local hbNum = checkint( checktable(hallmanager.proplist)[self._propID] )
    local propDef = gg.GetPropList()[self._propID]
    if propDef == nil then return ; end
    local hbValue = hbNum * ( propDef.proportion or 1 )
    self._hbValue = hbNum * ( propDef.proportion or 1 )
end


function GiftViewRedPackage:initView()
    -- 设置文字间距
    self.txt_ms:getVirtualRenderer():setLineSpacing(10)
    -- 设置红包领取人数
    self.txt_number:setString(gg.UserData:GetExchangeWXRedPackCount())
    self.txt_lqrs_next:setPositionX(self.txt_number:getPositionX() + self.txt_number:getContentSize().width + 10)

    if self:_isRealTime() then
        -- 即时红包，有多少领多少，一次最多 200
        local txt = nil
        if self._hbValue > 200 then
            self._hbValue = 200
            txt = string.format("领取金额%.2f元(大于200元需分多次领取)", self._hbValue)
        else
            txt = string.format("领取金额%.2f元", self._hbValue)
        end

        self.txt_xzdhhf:setString(txt)
        self.txt_xzdhhf:setPositionX(self.hongbaoView_Bg:getContentSize().width / 2)
    else
        self.txt_xzdhhf:setString("选取领取金额")
        -- 创建单选按钮组
        self:createRadioButtonPanel()
    end
end

-- 关闭公众号
function GiftViewRedPackage:onClickCloseGz(sender)
    -- 播放点击音效
    if self.panel_gzqp:isVisible() then
        gg.AudioManager:playClickEffect()
        self.panel_gzqp:setVisible(false)
    end
end
-- 创建单选按钮
function GiftViewRedPackage:createRadioButtonPanel( )
    local titleTb = { "25元", "50元" }
    cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/room.plist")
    self._cbVale = require("common.widgets.RadioButtonGroup"):create( titleTb, 1 )
    self._cbVale:setElementCountH(2)
    self._cbVale:setSpacingH(180)
    self._cbVale:setFontInfo(36, cc.c3b(  38, 155, 88  ) )
    self._cbVale:setPosition(cc.p( 380, 310 ) )
    self._cbVale:setImg("hall/room/friend/bg_btn_01.png","hall/room/friend/btn_point.png")
    self.hongbaoView_Bg:addChild(self._cbVale)
end

--打开关注公众号
function GiftViewRedPackage:onClickGzgzh(sender)
    -- 播放点击音效
    gg.AudioManager:playClickEffect()
    self.panel_gzqp:setVisible(true)
    -- -- 气泡动画
    self.img_qp:setScale(0)

    -- 播放气泡弹出动画
    local action1 = cc.EaseSineOut:create( cc.ScaleTo:create( 0.2 , 1.2 ) )
    local action2 = cc.EaseSineOut:create( cc.ScaleTo:create( 0.05 , 1.0 ) )
    self.img_qp:runAction( cc.Sequence:create( action1 , action2  ) )
end

-- 兑换按钮
function GiftViewRedPackage:onClickExchange(sender)
    -- 播放点击音效
    gg.AudioManager:playClickEffect()
  --兑换成功的界面切换
    if hallmanager and hallmanager:IsConnected() then
        local excVal = 0
        if self:_isRealTime() then
            -- 即时红包，有多少领多少
            excVal = self._hbValue
        else
            local idx = self._cbVale:getSelectIndex()
            if idx == 1 then
                excVal = 25
            elseif idx == 2 then
                excVal = 50
            end
        end
        if self._hbValue >= excVal then
            self:pullWechatCode(excVal)-- 获取兑换的二维码
        else
            self:showToast("您的红包金额不足！")
        end
    end
end

--复制二维码的功能按钮
function GiftViewRedPackage:onClickCopy()
    -- 播放点击音效
    gg.AudioManager:playClickEffect()
    if self._exchCode then
        Helper.CopyToClipboard(self._exchCode)
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST,"已复制到剪切板")
    end
end

--保存二维码
function GiftViewRedPackage:onClickSave( sender )
    -- 播放点击音效
    gg.AudioManager:playClickEffect()
    -- 保存到相册
    device.savedToPhotosAlbum(cc.FileUtils:getInstance():fullPathForFilename(checkstring(CUR_PLATFORM).."/img_ewm.jpg"), function()
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST,"二维码已保存到相册")
    end )
end

-- 获取兑换的二维码
function GiftViewRedPackage:pullWechatCode( value )
    gg.Dapi:PullWechatCode( gg.IIF(self:_isRealTime(), 1, 0), value, function(data)
        printf("onpullWechatCode :"..json.encode(data))
        if checkint( data.status ) == 0 then
            self._exchCode = data.code
            self.txt_hbdhm:setString(tostring(self._exchCode) )
            --兑换成功的界面切换
            self:showExcSuccessView()
        else
            self:showToast(data.msg)--通用接口
        end
    end)
end

-- 显示兑换成功界面
function GiftViewRedPackage:showExcSuccessView()
    self.panel_exc:setVisible(true)
end

function GiftViewRedPackage:onClickExcClose()
    self.panel_exc:setVisible(false)
end

--打开微信
function GiftViewRedPackage:onClicOpenWx(sender)
    -- 播放点击音效
    gg.AudioManager:playClickEffect()
    device.openWechat()
end

-- 是否是即时红包
function GiftViewRedPackage:_isRealTime()
    return self._propID == PROP_ID_262
end

return GiftViewRedPackage
