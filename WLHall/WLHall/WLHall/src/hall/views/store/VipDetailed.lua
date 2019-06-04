local VipDetailed = class("VipDetailed", cc.load("ViewPop"))

VipDetailed.RESOURCE_FILENAME="ui/store/vip_detailed.lua"

VipDetailed.RESOURCE_BINDING = {
    ["btn_close"]            = {["varname"] = "btn_close", ["events"]={{["event"] = "click",  ["method"]="onClickClose"}}},
    ["pnl_close"]            = {["varname"] = "pnl_close", ["events"]={{["event"] = "click",  ["method"]="onClickClose"}}},
    ["btn_buy"]              = {["varname"] = "btn_buy",   ["events"]={{["event"] = "click",  ["method"]="onClickGift"}}},
    ["btn_recharge"]         = {["varname"] = "btn_recharge",   ["events"]={{["event"] = "click",  ["method"]="onClickRecharge"}}},
    ["atlas_cur_Lv"]         = {["varname"] = "atlas_cur_Lv"},
    ["txt_next_desc"]        = {["varname"] = "txt_next_desc"},
    ["slv_vip_detail"]       = {["varname"] = "slv_vip_detail"},
    ["ldb_exp"]              = {["varname"] = "ldb_exp"} ,              --经验滑动条
    ["txt_sell_price"]       = {["varname"] = "txt_sell_price"},       --现价控件组合
    ["img_boy"]              = {["varname"] = "img_boy"},
    ["txt_name"]             = {["varname"] = "txt_name"},
    ["txt_id"]               = {["varname"] = "txt_id"},
    ["img_vip_lower_num"]    = {["varname"] = "img_vip_lower_num"},
    ["img_next_desc_icon"]   = {["varname"] = "img_next_desc_icon"},
    ["txt_purchasePrice_price"] = {["varname"] = "txt_purchasePrice_price"},--原价的文本
    ["Panel_link"] = {["varname"] = "Panel_link"},--原价的线

}

--vip2 - 16 的table 坐标
local vipPos3 = {
    [1] = {240,270},
    [2] = {240,221},
    [3] = {209,168},
    [4] = {245,116},
    [5] = {295,57},
}

--vip2 - 16 的table 坐标
local vipPos2 = {
    [1] = {240,243},
    [2] = {240,193},
    [3] = {255,166},
    [4] = {255,143},
    [5] = {295,83},
}

--vip1 的table 坐标
local vipPos1 =
{
    [1] = {205,290},
    [2] = {205,240},
    [3] = {208,229},
    [4] = {255,197},
    [5] = {295,127},
}
local VipDetailData = require("hall.models.VIPDetailData")
local StoreData = require("hall.models.StoreData")

local BTN_TXT = gg.IIF(IS_REVIEW_MODE, "立即购买", "立即领取")

local function c2time_(ctime)
    if ctime then
        return os.time({year=ctime.Year, month=ctime.Month, day=ctime.Day, hour=ctime.Hour,min=ctime.Minute,sec=ctime.Second})
    else
        return os.time()
    end
end

function VipDetailed:onCreate(isFromStore , isGmaeing)

    self._selectedImg = {}
    -- 适配
    self:setScale(math.min(display.scaleX, display.scaleY))

    self:init(isFromStore , isGmaeing)

    self:registerEventListener()

    self:initView()
    self:initHead()

    self:updateUserInfo(true)

end

-- function VipDetailed:aniEnd()
    -- self:updateDesc()
-- end

--[[
* @brief 注册消息通知
]]
function VipDetailed:registerEventListener()

    -- 注册消息
    self:addEventListener("event_buy_vip_goods_success" , handler(self,self.onEventBuyVipGoods))

    -- 注册玩家数据更新的消息
    self:addEventListener(gg.Event.HALL_UPDATE_USER_DATA,handler(self, self.onEventUpdateUserInfo))
end

function VipDetailed:init(isFromStore , isGmaeing)
    self.curBtnTag = 0 --当前选中的按钮tag

    self._propDef  = gg.GetPropList()  -- 用于获取道具信息来设置单位

    self._selectVip = 1  -- 当前选择VIP等级

    self._desRichTxt = {}

    self._isFromStore = isFromStore     -- 是否在商城打开此界面

    self._isGmaeing = _isGmaeing        -- 是否游戏中

end

function VipDetailed:initHead()
    -- 创建头像
    local clipNode = cc.ClippingNode:create(cc.Sprite:createWithSpriteFrameName("hall/common/bk_head_ico.png"))
    self._imgAvatar = ccui.ImageView:create("")
    clipNode:addChild(self._imgAvatar)
    clipNode:setAlphaThreshold(0)
    clipNode:setPosition(self.img_boy:getContentSize().width / 2, self.img_boy:getContentSize().height / 2)
    clipNode:setScale(0.95)
    self.img_boy:addChild(clipNode)

    -- 添加头像边框
    local avatarFram = ccui.ImageView:create()
    avatarFram:loadTexture("hall/common/player_head_bg.png",0)
    --self.img_boy:addChild(avatarFram)
    avatarFram:setPosition(self.img_boy:getContentSize().width / 2 , self.img_boy:getContentSize().height / 2)

end

function VipDetailed:initView()
    -- 审核模式下隐藏原价显示
    if IS_REVIEW_MODE then
        self.txt_purchasePrice_price:setVisible(false)
        self.Panel_link:setVisible(false)
        self.txt_sell_price:setPositionY(self.btn_buy:getPositionY())
    end

    --添加滑动条上的VIP等级按钮
    self.slv_vip_detail:setScrollBarEnabled(false)
    self.slv_vip_detail:setSwallowTouches(false)

    local DESC_BG_COLOR = {
        cc.c3b(21, 184, 155), cc.c3b(0, 156, 170), cc.c3b(0, 144, 132), cc.c3b(16, 141, 193),
        cc.c3b(0, 90, 226), cc.c3b(89, 72, 216), cc.c3b(157, 72, 216), cc.c3b(144, 40, 109),
        cc.c3b(190, 24, 94), cc.c3b(168, 36, 36), cc.c3b(199, 75, 0), cc.c3b(220, 145, 0),
        cc.c3b(80, 147, 0), cc.c3b(0, 113, 35), cc.c3b(0, 69, 155), cc.c3b(59, 0, 132),
    }

    -- local ttttt = socket.gettime()*10000
    local tb = gg.GetVipTable()
    self.slv_vip_detail:setInnerContainerSize({width = (448 *(#tb-1) + -6*2), height = 434})


    local descInfo = checktable(VipDetailData:GetVipDescTable()) -- 获取描述信息表

    self._pnlTable = {}

    for i=1,(#tb-1) do
        local node = require("res/ui/store/vip_button_normal.lua").create()
        local pnl = node.root:getChildByName("pnl_content")
        if pnl == nil then
            break
        end
        pnl:retain()
        pnl:removeFromParent(false)
        self.slv_vip_detail:addChild(pnl)
        pnl:release()
        pnl:setAnchorPoint(cc.p(0,0))
        pnl:setPosition(cc.p(-6+(i-1)*448,0))
        pnl:setTag(i)
        self._pnlTable[i] = pnl
        local img_selected = pnl:getChildByName("img_selected")
        if self._selectedImg and img_selected then
            self._selectedImg[i] = img_selected
            img_selected:setVisible(false)
        end
        local img_mid = pnl:getChildByName("img_mid")
        if img_mid then
            if i == 1 then
                img_mid:loadTexture("hall/vip_detailed/vip1_desc_mid.png", 0)
            elseif i == 2 then
                img_mid:loadTexture("hall/vip_detailed/vip2_desc_mid.png", 0)
            else
                img_mid:loadTexture("hall/vip_detailed/vip3_desc_mid.png", 0)
            end

            local atlas_vip_num = img_mid:getChildByName("atlas_vip_num")
            if atlas_vip_num then
                atlas_vip_num:setString(tostring(i))
            end
            if DESC_BG_COLOR[i] then
                local img_top = img_mid:getChildByName("img_top")
                if img_top then
                    img_top:setColor(DESC_BG_COLOR[i])
                end

                local img_lowner = img_mid:getChildByName("img_lowner")
                if img_lowner then
                    img_lowner:setColor(DESC_BG_COLOR[i])
                end
            end

            if descInfo[i] and descInfo[i].desc and descInfo[i].desc[1] and descInfo[i].desc[2] and descInfo[i].desc[3] and descInfo[i].desc[4] then
                local txstsize = 40
                for j=1,5 do
                    if j ==5 then
                        txstsize = 26
                    end
                    local pos =  vipPos3[j]
                    if i == 1 then
                        pos = vipPos1[j]
                    elseif i == 2 then
                        pos = vipPos2[j]    
                    end
                    local lbl  =  self:setText(descInfo[i].desc[j],j,txstsize,pos)
                    img_mid:addChild(lbl)
                end
            end
        end

        -- 按钮添加触摸事件
        pnl:addTouchEventListener(function(sender, state)
            local touchTag = sender:getTag()
            -- 判断是否是已经点击的按钮
            if touchTag ~= self.curBtnTag then
                if state ==  ccui.TouchEventType.ended then
                    gg.AudioManager:playClickEffect()
                    self:changeVipDetail(touchTag, true)
                end
            end
        end)
    end
    -- print(socket.gettime()*10000 - ttttt)
end

-- 设置文本txtdata数据 --textsize大小 -textPos位置 
function VipDetailed:setText(txtdata,i,textsize,textPos)
    local lbl = cc.Label:createWithSystemFont(txtdata, "Arial", textsize)
    lbl:setAnchorPoint(0.5,0.5)
    lbl:setTextColor(cc.c3b(202, 76, 0))
    lbl:setPosition(cc.p(textPos[1], textPos[2]))
    return lbl

end

-- 关闭
function VipDetailed:onClickClose(sender)

    self:removeSelf()


end

-- 点击购买按钮
function VipDetailed:onClickGift(sender)
    gg.AudioManager:playClickEffect()
    -- 游戏中提示
    if self._isGmaeing then

        GameApp:dispatchEvent(gg.Event.SHOW_TOAST,"请游戏结束后进行购买，给您带来的不变请谅解！")
        return
    end

    -- 拉起支付
    gg.PayHelper:showPay(GameApp:getRunningScene() , StoreData:GetVipGoodsTable(self._selectVip), nil, 0, 0, gg.PayHelper.PayStages.HALL)
end

function VipDetailed:onEventUpdateUserInfo()

    self:updateUserInfo(false)
end

-- 根据传入的用户经验
function VipDetailed:updateUserInfo(gotoLV)

    if not hallmanager or not hallmanager.userinfo then
        return
    end
    local userinfo = hallmanager.userinfo
    self._vipexp = userinfo.vipvalue
    -- 获取数据

    --self._vipexp= 10
    --根据经验值获取VIP等级,达到该等级所需经验和升至下一等级所需经验
    local lv , minExp , nextExp = gg.GetVipLevel(self._vipexp)
    local maxLevel = #(gg.GetVipTable()) - 1
       printf("---vip %d %d %d",lv,minExp,nextExp)
     self.atlas_cur_Lv:setString(tostring(lv))

    -- self.txt_next_desc:setVisible(false)
    -- 设置经验值bar
    local strXp = string.format("%d/%d", self._vipexp-minExp, nextExp-minExp)
    -- local richText = self.txt_next_desc:getParent():getChildByTag(50)
    if lv >= maxLevel then
        self.ldb_exp:setPercent(100)
        self.img_next_desc_icon:setVisible(false)
        -- self.atlas_next_lv:setVisible(false)
        -- richText:setVisible(false)
    else
        self.txt_next_desc:setVisible(true)
        local per = (math.abs(self._vipexp-minExp) / (nextExp-minExp))
        self.ldb_exp:setPercent(per*100)

        self.txt_next_desc:setString(string.format("再充%s元即可达到VIP%s", nextExp-self._vipexp, lv+1))

    end

    -- 用户数据刷新，强制更新界面数据显示时，不刷新滚动容器的位置
    if gotoLV then
        if lv > 0 then
            self:changeVipDetail(lv, false)
        else
            self:changeVipDetail(1, false)
        end
    end

    local avatarPath = gg.IIF(userinfo.sex == 1,"common/hd_male.png","common/hd_female.png")

    if userinfo.avatar == 0xFFFFFFFF then
        -- 自定义头像
        avatarPath = userinfo.avatarurl

        gg.ImageDownload:LoadUserAvaterImage({url = avatarPath, ismine = true, image = self._imgAvatar}, function()
                self._imgAvatar:setScale(84 / self._imgAvatar:getContentSize().width)
            end)
    else
        self._imgAvatar:loadTexture(avatarPath)
        self._imgAvatar:setScale(84 / self._imgAvatar:getContentSize().width)
    end
    local str = gg.SubUTF8StringByWidth(userinfo.nick, 120, 30)
    self.txt_name:setString(str)
    -- 设置玩家ID
    self.txt_id:setString(string.format("ID:%d" , userinfo.id))
end

-- 切换不同的VIP等级更改显示信息
function VipDetailed:changeVipDetail(lv , isClick)
    self.curBtnTag = lv

    -- 设置滚动位置
    local maxLv = #gg.GetVipTable() - 1

    local innerPosX = self.slv_vip_detail:getInnerContainerPosition().x
    local slvWidth = self.slv_vip_detail:getContentSize().width
    if innerPosX < - (lv-1)*448 or innerPosX > - (lv-3)*448 - 100 then
        if isClick then
            self.slv_vip_detail:scrollToPercentHorizontal((lv - 1) / (maxLv - 1) * 100, 0.3, false)
        else
            self.slv_vip_detail:jumpToPercentHorizontal((lv - 1) / (maxLv - 1) * 100)
        end
    end

    local giftInfo = StoreData:GetVipGoodsTable(lv)
    if giftInfo then
        -- 原价
        self.txt_purchasePrice_price:setString("原价:".. tostring(giftInfo.purchasePrice) .. "元")
        self.Panel_link:setContentSize(self.txt_purchasePrice_price:getContentSize().width,2)
        -- 现价
        self.txt_sell_price:setString("尊享价:" .. tostring(giftInfo.price) .. "元")
        self:setGoods(giftInfo.contain)
    end

    -- 判断是否满足购买条件
    local clv , minExp , nextExp = gg.GetVipLevel(self._vipexp)
    local isBuy = gg.UserData:IsBuyVipGoods(lv)

    if lv > clv or isBuy then
        self.btn_buy:setEnabled(false)
        self.btn_buy:setAllGray(true)
        local btn_buy_title = self.btn_buy:getChildByName("btn_buy_title")
        if btn_buy_title then
            btn_buy_title:setTextColor(cc.c3b(230,230,255))
            if isBuy then
                btn_buy_title:setString("已购买")
            else
                btn_buy_title:setString(BTN_TXT)
            end
        end
    else
        self.btn_buy:setEnabled(true)
        self.btn_buy:setAllGray(false)
        local btn_buy_title = self.btn_buy:getChildByName("btn_buy_title")
        if btn_buy_title then
            btn_buy_title:setTextColor(cc.c3b(85,46,0))
            btn_buy_title:setString(BTN_TXT)
        end
    end

    if self._selectedImg then
        if self._selectedImg[self._selectVip] then
            self._selectedImg[self._selectVip]:setVisible(false)
        end

        if self._selectedImg[lv] then
            self._selectedImg[lv]:setVisible(true)
        end
    end

    if self.img_vip_lower_num then
        if lv <= 16 then
            self.img_vip_lower_num:loadTexture("hall/vip_detailed/vip_num_"..lv..".png", 1)
        end
    end
    self._selectVip = lv
end

function VipDetailed:setGoods(goodsInfo)

    --更新道具列表
    for i = 1 , 6 do
        local gift = self:child("img_goods_"..tostring(i))
        gift:setVisible(false)
    end

    local si = 6-#checktable(goodsInfo)+1
    for i,v in ipairs(checktable(goodsInfo)) do

        local propDef = self._propDef[v[1]]
        if not propDef then return end

        local gift = self:child("img_goods_"..tostring(si))
        si = si + 1
        gift:setVisible(true)
        local img_goods = gift:getChildByName("img_goods")
        if img_goods then
            img_goods:loadTexture(propDef.icon)
            img_goods:ignoreContentAdaptWithSize(true)
            img_goods:setScale(70 / math.max(img_goods:getContentSize().width, img_goods:getContentSize().height))
        end

        local txt = gift:getChildByName("txt_goods_num")
        -- 显示单位
        txt:setString("x" .. v[2] * (propDef.proportion or 1) .. (propDef.unit or ""))
        -- 金豆时的显示
        if PROP_ID_MONEY==v[1] then
            txt:setString("x" .. gg.MoneyUnit(v[2]) .. "豆")
        end
    end

end

-- 购买VIP特权商品应答
function VipDetailed:onEventBuyVipGoods(event , lv)
    gg.AudioManager:playClickEffect()
    -- 刷新当前购买按钮
    if lv and tonumber(lv) == tonumber(self._selectVip) then
        self.btn_buy:setEnabled(false)
        self.btn_buy:setAllGray(true)
    end
    -- 购买成功提示
    GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "购买成功,请注意查收！")
end

-- 充值
function VipDetailed:onClickRecharge(sender)

    -- 游戏中提示
    if self._isGmaeing then

        GameApp:dispatchEvent(gg.Event.SHOW_TOAST,"请游戏结束后进行充值，给您带来的不变请谅解！")
        return
    end

    if self._isFromStore and self._isFromStore == true then

        -- 直接关闭此界面
        self:removeSelf()
    else

        -- 打开商城
        gg.AudioManager:playClickEffect()
        GameApp:DoShell(self:getScene(), "Store://bean")
    end

end

return VipDetailed
