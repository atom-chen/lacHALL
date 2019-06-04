--
-- Author: lee
-- Date: 2016-08-29 14:26:18
--
local PayMethod = class("PayMethod", cc.load("ViewPop"))
local PropDef  = gg.GetPropList()


PayMethod.RESOURCE_FILENAME="ui/store/pay_method.lua"

PayMethod.RESOURCE_BINDING = {
    ["btn_close"]             = {["varname"] = "btn_close",["events"]={{["event"] = "click",["method"]="onClickClose"}}},
    ["txt_content"]         = {["varname"] = "txt_content"},
    ["txt_price"]             = {["varname"] = "txt_price"},
    ["txt_subject"]         = {["varname"] = "txt_subject"},
    ["txt_line"]            = {["varname"] = "txt_line" },  --线

    ["txt_price_l"]         = {["varname"] = "txt_price_l" },    --价格
    ["txt_subject_l"]       = {["varname"] = "txt_subject_l" },  --商品
    ["img_frame"]           = {["varname"] = "img_frame" },      --边框
    ["img_icon"]            = {["varname"] = "img_icon" },       --道具

}

--{[1]="wechat",[2]="alipay_client",[3]="unionpay_client",[4]="appstore"}
PayMethod.BUTTON={
    {id=4, ico="hall/store/p_ico_2.png",  name="苹果支付",  visible=false },
    {id=2, ico="hall/store/p_ico_1.png", name="支付宝支付",visible=false },
    {id=3, ico="",  name="银联支付",  visible=false },
    {id=1, ico="hall/store/p_ico_4.png",     name="微信零钱",  visible=false },
}

PayMethod.RICHCHARCOLOR ={
    {"万","豆","钻","石","v","i","p","天","月","年"},
}

--[[   price body
  data.type  data.name  data.price  data.count
]]
function PayMethod:onCreate(fn,data,switch,...)
    --处理线

     self.posArr_={}
    for i,v in ipairs(PayMethod.BUTTON) do
        local btn = self:child("btn_pay_"..i)
        local line = btn:getChildByName("line")
        gg.HandleLineV(line)
    end
    self.lableX =0       --富文本标签的开始位置

     --画线
    self.fn_=fn
    if data.type ==PROP_ID_MONEY then
        data.name = data.name or checknumber(data.count) .."万豆"
        -- 豆豆的缩略图
        self.img_frame:setVisible(true)
        self.img_icon:loadTexture( data.ico ,1)

    elseif data.type then
        local propName = PropDef[data.type].name or PROPNAME[data.type]
        data.name =data.name or checkstring(propName).."x".. (data.count or 1)
        --记牌器 显示 记牌器（7天）
        if data.type == PROP_ID_JIPAI then
            local propUnit = PropDef[data.type].unit or ""
            data.name =string.format( "%s(%d%s)" ,checkstring(propName),data.count,propUnit)
        end
        --道具的缩略图
        self.img_frame:setVisible(true)
        self.img_icon:loadTexture( PropDef[ data.type ].icon or "" )

    elseif data.type == PROP_ID_XZMONEY  then
        -- 更新显示
        data.name = data.name or checknumber(data.count) .."钻石"
        -- 钻石的缩略图
        self.img_frame:setVisible(true)
        self.img_icon:loadTexture( data.ico ,1)

    elseif data.type == nil and data.ico then
        -- 月卡及魔法道具的缩略图
        self.img_frame:setVisible(true)
        self.img_icon:loadTexture( data.ico )
    else
        self.img_frame:setVisible(false)
        --没有缩略图 文字左移
        self.txt_subject_l:setPositionX(self.txt_subject_l:getPositionX()-80)
        self.txt_subject:setPositionX(self.txt_subject:getPositionX()-80)
        self.txt_price:setPositionX(self.txt_price:getPositionX()-100)
        self.txt_price_l:setPositionX(self.txt_price_l:getPositionX()-100)
    end

    self.img_icon:ignoreContentAdaptWithSize(true)
    self.img_icon:setScale(112 / math.max(self.img_icon:getContentSize().width, self.img_icon:getContentSize().height))

    self.goodsID = data.goods
    -- 商品名称
    -- self.txt_subject:setString(tostring(data.name)) -- 商品名称
    self.txt_subject:setString( "" )
    local txtName = RichLabel.new({
            fontSize = self.txt_subject:getFontSize(),
            fontColor = self.txt_subject:getTextColor(),
    })
    txtName:setString( tostring( data.name ) )
    txtName:setAnchorPoint( cc.p(0,0.5) )
    txtName:walkElements(function ( node ,index )
        local ss = node:getString()
        if tonumber(ss) then
           node:setFontSize( self.txt_subject:getFontSize() + 6 )
        end
    end)
    self.txt_subject:addChild( txtName )

    self.txt_price:setString("¥"..tostring(data.price)) --商品价格
    self.txt_price:setFontSize( self.txt_price:getFontSize() + 6 )

    self:showTips(data.total or "") --隐藏兑换提示
     for i,v in ipairs(PayMethod.BUTTON) do
         local btn= self:child("btn_pay_"..i)
         btn:setVisible(v.visible)
         btn:setTag(v.id)
         btn:getChildByName("ico"):ignoreContentAdaptWithSize( true )
         btn:getChildByName("ico"):loadTexture(v.ico , 1 )
         btn:getChildByName("btn_content"):setString(v.name)
         btn:onClickDarkEffect(handler(self, self.onClickPayButton))
         table.insert(self.posArr_, cc.p(btn:getPosition()))
    end
    self:refreshButton(switch)

    self:addEventListener( gg.Event.ON_PAY_RESULT, handler( self, self.onPayResultsCallBack ) )

end

function PayMethod:showTips(content)

    if not content then
        self.txt_content:setVisible(false)
        return
    end
    self.txt_content:setString("")
    self.txt_content:setTextColor({r = 160, g = 160, b = 160})      --子体显示灰色
    local test_text = {}
    table.insert( test_text , string.format(  "<div fontColor=#FF0B00>%s</div>",content) )
    for i=1, #test_text do
        --local RichLabel = require("common.richlabel.RichLabel")
        local label = RichLabel.new {
            fontSize = 30,
            fontColor = cc.c3b(255, 11, 0),
            maxWidth=670,
            lineSpace=0,
            charSpace=0,
        }
        label:setAnchorPoint(cc.p(0,1))
        label:setString(test_text[i])
        local labelWidth = label:getSize().width
        local rect = self.txt_content:getBoundingBox()
        label:setPosition(cc.p(self.lableX,rect.height))
        self.lableX=self.lableX+labelWidth

        -- label:walkElements(function ( node ,index )
           --  local ss = node:getString()
           --  if tonumber(ss) then
           --     node:setTextColor(cc.c3b(128,42,42))
           --     node:setFontSize( 26 )
           --  end

           --  for i =1,#PayMethod.RICHCHARCOLOR[1] do
           --      if ss == PayMethod.RICHCHARCOLOR[1][i] then
           --          node:setTextColor(cc.c3b(128,42,42))
           --          node:setFontSize( 26 )
           --      end
           --  end
        -- end)
        self.txt_content:addChild(label)
    end
    self.txt_content:setVisible(true)
end

function PayMethod:refreshButton(switch)
    local apple=gg.TableFindV(switch,function(v) return v.id==4 end)
    if apple and device.platform=="ios" then
        local appStoreCfg = checktable(PAY_CONFIG["appstore"])
        if appStoreCfg[self.goodsID] then
            -- 商品可以使用苹果支付，则根据开关配置来显示苹果支付按钮
            apple.visible = gg.IIF(IS_REVIEW_MODE,true,apple.visible)
        else
            -- 商品不能使用苹果支付，隐藏苹果支付按钮
            apple.visible = false
        end
    else
        apple.visible=false
    end

    local visibleCount = 0
    for i, v in ipairs(PayMethod.BUTTON) do
        local btn= self:child("btn_pay_"..i)
        if v.id == 3 then
            -- 屏蔽银联支付功能
            btn:setVisible(false)
        else
            table.walk(checktable(switch),function(vv)
                if v.id == vv.id then
                    btn:setVisible(vv.visible)
                    if vv.visible then
                        visibleCount = visibleCount + 1
                    end
                end
            end)
        end
    end

    if visibleCount <= 2 then
        -- 对显示的按钮进行位置排序
        local i = 1
        for k=1,4 do
            local btn= self:child("btn_pay_"..k)
            if btn:isVisible() then
                btn:setPosition(self.posArr_[i])
                i=i+1
            end
        end
    end
end


function PayMethod:onClickClose()
    if self.fn_ then
        self.fn_()
    end
    self:removeSelf()
end

function PayMethod:onService()
    -- body
end

function PayMethod:onClickPayButton(sender)
    local curClickTime = socket.gettime()
    local spaceTime = 0.8
    if self._lastClickTime and (curClickTime - self._lastClickTime < spaceTime) then
        -- 快速连续点击，直接返回
        return
    end
    self._lastClickTime = curClickTime

    local id=sender:getTag()
    if self.fn_ then
        self.fn_( gg.PayHelper:getMethodById(id),id)
    end
    -- self:removeSelf()
end

--[[
* @brief 支付结果回调处理
* @pram [in] status    0-成功,1-失败,2-取消,3-结果处理中
]]
function PayMethod:onPayResultsCallBack( event, result )
    -- 支付成功,移除支付界面
    if result.status == 0 then
        self:removeSelf()
    end
end

return PayMethod
