--
-- Author: Cai
-- Date: 2017-06-28
-- Describe：抽奖界面

local LottoView = class("LottoView", cc.load("ViewPop"))

LottoView.CLOSE_ANIMATION = false
LottoView.RESOURCE_FILENAME = "ui/luckybag/uidialcommon.lua"
LottoView.RESOURCE_CLICK_SOUND = "res/common/audio/button_click.mp3"
LottoView.RESOURCE_BINDING = {
    ["node_bg"]       = { ["varname"] = "node_bg"      },
    ["node_dial"]     = { ["varname"] = "node_dial"    },
    ["node_light_1"]  = { ["varname"] = "node_light_1" },
    ["node_light_2"]  = { ["varname"] = "node_light_2" },
    ["node_front"]    = { ["varname"] = "node_front"   },
    ["spr_cur_award"] = { ["varname"] = "spr_cur_award"},
    ["btn_click"]     = { ["varname"] = "btn_click", ["events"] = { { ["event"]="click", ["method"]="onClickStartUse" } } },
    ["btn_detail"]    = { ["varname"] = "btn_detail",["events"] = { { ["event"]="click", ["method"]="onClickDetail"   } } },
    ["btn_close"]     = { ["varname"] = "btn_close", ["events"] = { { ["event"]="click", ["method"]="onClickClose"    } } },

    ["nd_yb"]   = { ["varname"] = "nd_yb"   },
    ["txt_title"] = { ["varname"] = "txt_title" },
    ["pv_record"] = { ["varname"] = "pv_record" },
    ["panel_record"] = { ["varname"] = "panel_record" },
}

local LottoData = require "hall.models.LottoData"

local NothingID = 9999  -- 谢谢惠顾配置的道具ID，约定回传为 {9999, 0}
local TryAgainID = 9998 -- 再来一次配置的道具ID，约定回传为 {9998, 0}

-- lottoType 抽奖方式(int) 4-抽奖卡 15-元宝 16-微乐豆
function LottoView:onCreate(cbFunc, lottoType, expandIdx)
    self:showLoading( "数据加载中..." )
    self:init(cbFunc, lottoType)
    self:resetLayout()
    self:initView()

    if expandIdx then
        local btn = self.nd_yb:getChildByName("btn_" .. expandIdx)
        if btn then
            self:doSetYbLottoCost(btn)
        end
    end

    LottoData:pullLottoData(self._lottoType, function(awardTb, total, showMsg, rateTb, surplus, errmsg, expendTb)
        if tolua.isnull(self) then return end
        self:showLoading()
        if not awardTb then
            GameApp:dispatchEvent(gg.Event.SHOW_TOAST, errmsg or "抽奖数据获取失败，请关闭页面重试")
            return
        end
        self:setYbTipsStr(showMsg or "")
        self._awardTb = awardTb
        self:initLottoLayer(awardTb)
        if expendTb then
            self:updateBtnExpend(expendTb)
        end

        if rateTb then
            self._rateTb = rateTb
            self.btn_detail:setVisible(true)
        else
            self.btn_detail:setVisible(false)
        end
    end)

    self:showDataLoading()
end

function LottoView:onLoadView()
    gg.Dapi:NewLotteryRecord(self._lottoType, function(cb)
        if tolua.isnull(self) then return end
        if cb.status == 0 then
            self._recordLoaded = true
            self:hideDataLoading()
            self._recordData = checktable(cb.data)
            self:initPageView()
        else
            printf("拉取获奖记录失败！！！")
        end
    end)
end

function LottoView:init( cbFunc, lottoType )
    -- 回调刷新
    self._cbFunc = cbFunc
    -- 道具表
    self._awardTb = {}
    -- 动画状态判断
    self._lottoAniPlaying = false
    -- 角度
    local count = 9
    self._angleCell = 360/count
    -- 计时器
    self._timer = nil
    -- 道具
    self._propDef  = gg.GetPropList()
    -- 分享数据
    self._shareTb = nil
    -- 抽奖方式
    self._lottoType = lottoType or PROP_ID_LOTTERY
    -- 抽奖倍数
    self._expendProp = PROP_ID_LOTTERY
    self._expendCnt = 1

    self._tmpItem = self:findNode("item_record")
    self._recordData = {}
    self._extraItems = {}
    self._curPage = 0

    -- 标记游戏记录界面是否加载成功
    self._recordLoaded = false
end

function LottoView:resetLayout( )
    self:setScale(math.min(display.scaleX, display.scaleY))
    self.nd_yb:setVisible(self._lottoType == PROP_ID_LOTTERY)
end

function LottoView:onExit( )
    if self._timer then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry( self._timer )
    end
    if self._recordTimer then
        self._recordTimer:killAll()
        self._recordTimer = nil
    end
end

function LottoView:initView()
    self.btn_click:setTouchEnabled(false)
    -- 添加领取动画，暂时隐藏动画
    self.spr_cur_award:setVisible(false)
    self.animation = self.resourceNode_["animation"]
    self:runAction(self.animation)
    -- 灯泡闪烁动画
    self:lampBlink( self.node_light_1, 0 )
    self:lampBlink( self.node_light_2, 0.5 )

    if self._lottoType == PROP_ID_LOTTERY then
        self.txt_title:setTextColor(cc.c3b(193, 103, 57))
        self._ybTips = self:createYBTipsRichLabel()
        for i=1,3 do
            local btn = self.nd_yb:getChildByName("btn_"..i)
            if btn then btn:onClick(handler(self, self.onClickSetYbLottoCost), 1) end
            if i == 1 then self:doSetYbLottoCost(btn) end
        end

        -- 开关检查
        local visibleNds = {}
        local nd_yb = self.nd_yb:getChildByName("img_prop_bg_1")
        local nd_hf = self.nd_yb:getChildByName("img_prop_bg_2")
        local nd_hb = self.nd_yb:getChildByName("img_prop_bg_3")

        local visibleBtns = {}
        local btn_yb = self.nd_yb:getChildByName("btn_1")
        local btn_hf = self.nd_yb:getChildByName("btn_2")
        local btn_hb = self.nd_yb:getChildByName("btn_3")
        -- 元宝
        if GameApp:CheckModuleEnable(ModuleTag[PROP_ID_LOTTERY]) then
            table.insert(visibleNds, nd_yb)
            table.insert(visibleBtns, btn_yb)
        else
            nd_yb:setVisible(false)
            btn_yb:setVisible(false)
        end

        -- 话费
        if GameApp:CheckModuleEnable(ModuleTag[PROP_ID_PHONE_CARD]) then
            table.insert(visibleNds, nd_hf)
            table.insert(visibleBtns, btn_hf)
        else
            nd_hf:setVisible(false)
            btn_hf:setVisible(false)
        end

        -- 2018-05-30 暂时关闭红包功能
        nd_hb:setVisible(false)
        btn_hb:setVisible(false)

        local poses_1 = {214, 363, 512}
        local poses_2 = {276, 466, 656}
        if #visibleBtns == 2 then
            visibleBtns[1]:setAnchorPoint(cc.p(0, 0.5))
            poses_2[2] = 212
        end

        if #visibleNds ~= 0 then
            for i, v in ipairs(visibleNds) do
                v:setPositionX(poses_1[i])
            end

            for i, v in ipairs(visibleBtns) do
                v:setPositionX(poses_2[i + 3 - #visibleBtns])
                if i == 1 then self:doSetYbLottoCost(v) end
            end
        end

        if #visibleNds < 3 then
            self.btn_detail:setPositionY(nd_hb:getPositionY() - 1)
        end
    end

    if hallmanager then self:refreshPropCnt() end

    self.pv_record:setDirection(1)
end

function LottoView:createYBTipsRichLabel()
    local rechLb = RichLabel.new {
        fontSize = 19,
        fontColor = cc.c3b(138, 71, 13),
    }
    rechLb:setAnchorPoint(cc.p(1, 0.5))
    rechLb:setPosition(cc.p(650, 60))
    self.nd_yb:addChild(rechLb)
    return rechLb
end

-- 设置上部相关数据
function LottoView:setYbTipsStr(str)
    -- 没有提示文本时，让按钮居中
    local posY = 22
    if not str or str == "" then
        self._ybTips:setVisible(false)
        posY = 37
    else
        str = string.gsub(str, "元宝", "礼品券")
        self._ybTips:setVisible(true)
        self._ybTips:setString(str)
        self._ybTips:walkElements(function(node, index)
            if not node then return end
            local ndstr = node:getString()
            if tonumber(ndstr) then
                node:setColor(cc.c3b(215, 55, 0))
            end
        end)
    end

    for i=1,3 do
        local btn = self.nd_yb:getChildByName("btn_"..i)
        if btn then
            btn:setPositionY(posY)
        end
    end
end

function LottoView:refreshPropCnt()
    local txt_yb = self.nd_yb:findNode("txt_yb_cnt")
    local txt_hf = self.nd_yb:findNode("txt_hf_cnt")
    local txt_hb = self.nd_yb:findNode("txt_hb_cnt")

    if hallmanager and hallmanager.userinfo then
        local userinfo = hallmanager.userinfo

        txt_yb:setString("x" .. tostring(userinfo.lottery))

        local hfCnt = checkint(checktable(hallmanager:GetPropList())[PROP_ID_PHONE_CARD])
        local hfDef = self._propDef[PROP_ID_PHONE_CARD]
        if hfCnt == 0 then
            txt_hf:setString("x0")
        else
            txt_hf:setString(string.format("x%.2f", tonumber(hfCnt * (hfDef.proportion or 1))))
        end

        local hbCnt = checkint(checktable(hallmanager:GetPropList())[PROP_ID_261])
        local hbDef = self._propDef[PROP_ID_261]
        if hbCnt == 0 then
            txt_hb:setString("x0")
        else
            txt_hb:setString(string.format("x%.2f", tonumber(hbCnt * (hbDef.proportion or 1))))
        end
    end
end

function LottoView:initLottoLayer(awardTb)
    -- 设置按钮状态
    self:setClickBtnState(true)
    -- 设置物品
    for i,v in ipairs(checktable(awardTb)) do
        local item = self.node_dial:getChildByName("node_dialitem_"..i)
        if item then
            local fnt_count = item:getChildByName("fnt_count")
            local fnt_name = item:getChildByName("fnt_name")
            local spr_prop = item:getChildByName("spr_prop")
            if checkint(v[1]) == NothingID or checkint(v[1]) == TryAgainID then
                fnt_count:setVisible(false)
                fnt_name:setVisible(false)
                spr_prop:setSpriteFrame(gg.IIF(checkint(v[1]) == NothingID, "hall/lotto/str_xxhg.png", "hall/lotto/str_zlyc.png"))
                spr_prop:setPositionX(spr_prop:getPositionX() + 10)
            else
                local propDef = self._propDef[ checkint(v[1]) ]
                if propDef then
                    -- 奖励物品数量
                    local count = v[2] * (propDef.proportion or 1)
                    local propName = propDef.name or ""
                    if checkint(v[1]) == PROP_ID_PHONE_CARD or checkint(v[1]) == PROP_ID_261 then
                        count = string.format("%.2f",count)
                    end
                    if checkint(v[1]) == PROP_ID_MONEY then propName = BEAN_NAME end

                    fnt_count:setString(tostring(count))
                    fnt_name:setString(propName)

                    -- 奖励的物品
                    spr_prop:setTexture( propDef.icon )
                    spr_prop:setScale( 90/spr_prop:getContentSize().width )
                else
                    printf("没有定义的道具："..v[1])
                end
            end
        end
    end
end

-- 重新设置抽奖界面
function LottoView:resetLottoLayer( )
    -- 刷新道具数量
    if self._cbFunc then
        if hallmanager and hallmanager:IsConnected() then
            self._cbFunc( hallmanager.userinfo )
            printf("抽奖结束,刷新道具数量!!!!!!!!!")
        end
    end
    -- 设置按钮状态
    self:setClickBtnState( true )
end

-- 设置抽奖按钮状态
function LottoView:setClickBtnState( bo )
    self._lottoAniPlaying = (not bo)
    self.btn_close:setVisible( bo )    -- 设置关闭按钮状态，防止开奖情况下界面被关闭
    self.btn_click:setTouchEnabled( bo )
    local spr_word_click_1 = self.btn_click:getChildByName("spr_word_click_1")
    local spr_word_click_2 = self.btn_click:getChildByName("spr_word_click_2")
    spr_word_click_1:setVisible( bo )
    spr_word_click_2:setVisible( not bo )

    if self._lottoType == PROP_ID_LOTTERY then
        for i=1,3 do
            local btn = self.nd_yb:getChildByName("btn_"..i)
            if btn then btn:setTouchEnabled(bo) end
        end
    end
end

-------------------------------------------------------------
-- 动画
-------------------------------------------------------------
-- 转盘动画
function LottoView:startLottoAni( prop, shareTb, tryAgain )
    assert(prop, "prop is nil")

    -- 添加动画音效
    if self._timer ~= nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry( self._timer )
    end
    local curIndex = 0
    local scheduler = cc.Director:getInstance():getScheduler()
    self._timer = scheduler:scheduleScriptFunc(function(dt)
        local rotate = self.node_dial:getRotation()
        local index = math.floor(rotate/self._angleCell)
        if index ~= curIndex then
            gg.AudioManager:playEffect( "res/common/audio/rolling_01.mp3" )
            curIndex = index
        end
    end,0.04,false)

    self.node_dial:stopAllActions()
    -- 计算动画停止的位置
    local endIndex = nil
    for i,v in ipairs(self._awardTb) do
        if tryAgain then
            if checkint(v[1]) == TryAgainID and checkint(v[2]) == 0 then
                endIndex = i
            end
        else
            if checkint(v[1]) == checkint(prop[1]) and checkint(v[2]) == checkint(prop[2]) then
                endIndex = i
            end
        end
    end

    local endRotate = 360 - (endIndex-1)*self._angleCell
    -- 开始动画
    local sp = 680
    local startcount = 3
    local beginAct = cc.RotateBy:create(startcount*360/sp,startcount*360)
    -- 停止动画
    local endcount = 3
    local endAct = cc.EaseExponentialOut:create(cc.RotateTo:create((endcount*360 + endRotate)/(sp-350), (endcount*360 + endRotate)))
    -- 获得道具闪一下
    local blinkAni = cc.CallFunc:create(function()
        if self.animation then
            self.spr_cur_award:setVisible(true)
            self.animation:play( "getaward", false )
        end
    end)
    -- 奖励提示动画
    local awardAni = cc.CallFunc:create(function()
        self:showToastAni( prop, shareTb, tryAgain )
    end)

    self.node_dial:runAction( cc.Sequence:create( beginAct, endAct, blinkAni, cc.DelayTime:create(1.2), awardAni ) )
end

function LottoView:showToastAni( prop, shareTb, tryAgain )
    -- 刷新大厅的用户数据
    local hf = self:getScene():getChildByName("HallFrameView")
    if hf then hf:updateUserinfo() end

    if tryAgain then
        gg.CallAfter(0.5, function( )
            self:startLottoAni(prop, shareTb)
        end)
        return
    end

    if checkint(prop[1]) == NothingID then
        self:showToast("差一点就中奖了，再来一次试试吧")
        self:resetLottoLayer()
        return
    end

    local propDef = self._propDef[ checkint(prop[1]) ]
    if not propDef then return end
    local count = checkint(prop[2]) * (propDef.proportion or 1)

    if shareTb then
        self._shareTb = shareTb
        self:getScene():createView("luckybag.LottoAwardView", {prop[1], checkint(prop[2])}, handler(self, self.popShareView)):pushInScene()
    else
        self:getScene():createView("luckybag.LottoAwardView", {prop[1], checkint(prop[2])}, nil):pushInScene()
    end
    self:resetLottoLayer()
    self:refreshPropCnt()
    self:insertUserRecord({prop[1], checkint(prop[2])})
end

-- 分享
function LottoView:popShareView( shareType )
    shareType = shareType or 1
    local shareTb = self._shareTb or {}

    if not shareTb.content or shareTb.content=="" or not shareTb.pic or shareTb.pic=="" or not shareTb.url or shareTb.url=="" then
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "分享拉取失败！")
    else
        shareTb.content = string.gsub(shareTb.content, "元宝", "礼品券")
        if gg.UserData:GetShareType("lottery") == 1 then
            print("抽奖分享使用系统分享")
            if device.platform == "android" then
                -- 2018-07-21 安卓不支持图文分享格式，直接提示错误，不再调整使用SDK分享
                GameApp:dispatchEvent(gg.Event.SHOW_TOAST, err or "分享拉取失败，错误码：2")
                return
            end
            local params = {}
            params.content = shareTb.content
            params.url = shareTb.url
            local imgurl = shareTb.pic
            gg.ImageDownload:Start(imgurl, function(lpath, err)
                if lpath then
                    params.imgUrl = lpath
                    gg.ShareHelper:doShareBySystem(1, 0, params)
                end
            end, nil, Helper.sdcachepath)
        else
            print("抽奖分享使用SDK分享")
            gg.ShareHelper:doShareWebType(shareTb.content, shareTb.pic, shareTb.url, shareType, nil)
        end
    end
end

-- 灯泡闪烁动画
function LottoView:lampBlink( node, dt )
    node:setOpacity(0)
    local seq = cc.Sequence:create(cc.DelayTime:create(dt), cc.CallFunc:create(function()
        node:stopAllActions()
        local seqAct = cc.Sequence:create(
            cc.FadeTo:create(0.25,255),
            cc.DelayTime:create(0.25),
            cc.FadeTo:create(0.25,0),
            cc.DelayTime:create(0.25))
        node:runAction(cc.RepeatForever:create(seqAct))
    end))
    node:runAction(seq)
end

---------------------------------------------------------------
-- 点击事件
---------------------------------------------------------------
-- 点击抽奖
function LottoView:onClickStartUse( sender )
    if (gg.IsFastClick(sender)) then return end

    local txt_yb = self.nd_yb:findNode("txt_yb_cnt")
    local txt_hf = self.nd_yb:findNode("txt_hf_cnt")
    local txt_hb = self.nd_yb:findNode("txt_hb_cnt")
    if hallmanager and hallmanager.userinfo then
        local userinfo = checktable(hallmanager.userinfo)
        if self._expendProp == PROP_ID_LOTTERY then
            local ybCnt = checkint(userinfo.lottery) - self._expendCnt
            ybCnt = math.max(ybCnt, 0)
            txt_yb:setString("x" .. tostring(ybCnt))
        elseif self._expendProp == PROP_ID_PHONE_CARD then
            local hfCnt = checkint(checktable(hallmanager:GetPropList())[PROP_ID_PHONE_CARD]) - self._expendCnt
            hfCnt = math.max(hfCnt, 0)
            local hfDef = self._propDef[PROP_ID_PHONE_CARD]
            if hfCnt == 0 then
                txt_hf:setString("x0")
            else
                txt_hf:setString(string.format("x%.2f", tonumber(hfCnt * (hfDef.proportion or 1))))
            end
        elseif self._expendProp == PROP_ID_261 then
            local hbCnt = checkint(checktable(hallmanager:GetPropList())[PROP_ID_261]) - self._expendCnt
            hbCnt = math.max(hbCnt, 0)
            local hbDef = self._propDef[PROP_ID_261]
            if hbCnt == 0 then
                txt_hb:setString("x0")
            else
                txt_hb:setString(string.format("x%.2f", tonumber(hbCnt * (hbDef.proportion or 1))))
            end
        end
    end

    LottoData:doLottery(self._lottoType, self._expendProp, self._expendCnt, function(result, showMsg, surplus)
        if tolua.isnull(self) then return end
        if result.status == 0 then
            local tryAgain = false
            local prop = checktable(result.data)[1]
            if #checktable(result.data) == 2 and checkint(prop[1]) == TryAgainID then
                tryAgain = true
                prop = checktable(result.data)[2]
            end
            self:startLottoAni( prop, result.share, tryAgain )
            self:setClickBtnState( false )

            if self._lottoType == PROP_ID_LOTTERY then
                self:setYbTipsStr(showMsg or "")
            end
        else
            local errMsg = result.msg or "抽奖失败"
            errMsg = string.gsub(errMsg, "元宝", "礼品券")
            -- 礼品券不足时抽奖提示过长，故将吐司提示字体缩小一些
            self:showToast(errMsg, {fontSize = 32})
            self:refreshPropCnt()
        end
    end)
end

function LottoView:onClickSetYbLottoCost(sender)
    gg.AudioManager:playClickEffect()
    self:doSetYbLottoCost(sender)
end

function LottoView:doSetYbLottoCost(sender)
    for i=1,3 do
        local btn = self.nd_yb:getChildByName("btn_"..i)
        btn:getChildByName("btn_sel"):setVisible(sender == btn)
    end

    local tag = sender:getTag()
    if tag == 1001 then
        self._expendProp = PROP_ID_LOTTERY
        self._expendCnt = sender.expend or 300
    elseif tag == 1002 then
        self._expendProp = PROP_ID_PHONE_CARD
        self._expendCnt = sender.expend or 100
    elseif tag == 1003 then
        self._expendProp = PROP_ID_261
        self._expendCnt = sender.expend or 100
    end
end

-- 根据下发的消耗表设置按钮上的消耗显示
function LottoView:updateBtnExpend(expendTb)
    expendTb = checktable(expendTb)
    local btn_yb = self.nd_yb:getChildByName("btn_1")
    local btn_hf = self.nd_yb:getChildByName("btn_2")
    local btn_hb = self.nd_yb:getChildByName("btn_3")

    for k,v in pairs(expendTb) do
        local propDef = self._propDef[k]
        local cnt = checkint(v) * (propDef.proportion or 1)
        if k == PROP_ID_LOTTERY then
            btn_yb:getChildByName("txt_1"):setString(string.format("%d礼品券/次", cnt))
            btn_yb.expend = v
        elseif k == PROP_ID_261 then
            btn_hb:getChildByName("txt_1"):setString(string.format("%d元红包/次", cnt))
            btn_hb.expend = v
        elseif k == PROP_ID_PHONE_CARD then
            btn_hf:getChildByName("txt_1"):setString(string.format("%d元话费/次", cnt))
            btn_hf.expend = v
        end
    end

    -- 找到默认设置点击的按钮，重新刷新一次消耗数据
    for i=1,3 do
        local btn = self.nd_yb:getChildByName("btn_"..i)
        if btn:getChildByName("btn_sel"):isVisible() then
            self:doSetYbLottoCost(btn)
            break
        end
    end
end

function LottoView:onClickClose( sender )
    self:removeSelf()
end

function LottoView:keyBackClicked()
    if self._lottoAniPlaying then
        return false, false
    else
        return LottoView.super.keyBackClicked(self)
    end
end

----------------------------------------------------
-- 获奖记录
----------------------------------------------------
-- 字符串转时间
local function string2time( str )
    local Y = string.sub( str, 1, 4 )
    local M = string.sub( str, 6, 7 )
    local D = string.sub( str, 9, 10 )
    local h = string.sub( str, 12, 13 )
    local m = string.sub( str, 15, 16 )
    local s = string.sub( str, 18, 19 )
    local time = os.time( { year=Y, month=M, day=D, hour=h, min=m, sec=s } )
    return time
end

function LottoView:initPageView()
    table.sort(self._recordData, function(a, b)
        return string2time(a.time) > string2time(b.time)
    end)

    if #self._recordData < 5 then
        for i,v in ipairs(self._recordData) do
            local item = self._tmpItem:clone()
            item:setVisible(true)
            self:setRecordItemData(item, v)
            self.pv_record:addPage(item)
        end
        return
    end

    local delay = 0.05
    for i=1,#self._recordData + 4 do
        local index = gg.IIF(i <= #self._recordData, i, i - #self._recordData)
        if i <= 5 then
            self:createRecordItem(self._recordData[index])
        else
            delay = delay + 0.05
            self:callAfter(delay, function()
                if tolua.isnull(self) then return end
                local item = self:createRecordItem(self._recordData[index])
                if i > #self._recordData then
                    table.insert(self._extraItems, item)
                end
                if i == #self._recordData + 4 then
                    if #self._recordData > 4 then self:startTimer() end
                end
            end)
        end
    end
end

function LottoView:createRecordItem(data)
    local item = self._tmpItem:clone()
    item:setVisible(true)
    self:setRecordItemData(item, data)
    self.pv_record:addPage(item)
    return item
end

function LottoView:setRecordItemData(item, data)
    local txt_nick = item:getChildByName("txt_nick")
    local strName = gg.SubUTF8StringByWidth(tostring(data.nickname), 140, 20, "")
    txt_nick:setString(strName)

    local txt_time = item:findNode("txt_time")
    txt_time:setString(string.sub(data.time or "", 1, 16))

    local txt_id = item:findNode("txt_id")
    txt_id:setString(string.format("ID.%d", tonumber(data.userid)))

    local img_avatar = item:findNode("img_avatar")
    local avatarPath = "common/hd_male.png"
    img_avatar:loadTexture( avatarPath )
    if data.avatar and data.avatar ~= "" then
        avatarPath = data.avatar
        gg.ImageDownload:LoadUserAvaterImage({url=avatarPath,ismine=false,image=img_avatar})
    else
        img_avatar:loadTexture( avatarPath )
    end

    local txt_cnt = item:findNode("txt_cnt")
    local propDef = self._propDef[checkint(data.data_id)]
    if not propDef then
        txt_cnt:setVisible(false)
        return
    end
    local count = checkint(data.count) * (propDef.proportion or 1)
    local propName = propDef.name or ""
    if checkint(data.data_id) == PROP_ID_PHONE_CARD or checkint(data.data_id) == PROP_ID_261 then
        count = string.format("%.2f",count)
    end

    if checkint(data.data_id) == PROP_ID_MONEY then propName = "豆" end
    txt_cnt:setString(string.format("%sx%s", propName, count))
end

function LottoView:insertUserRecord(prop)
    if not self._recordLoaded then return end
    if not hallmanager then return end
    local userinfo = checktable(hallmanager.userinfo)
    local newData = {
        data_id = checkint(prop[1]),
        nickname = userinfo.nick,
        count = checkint(prop[2]),
        time = os.date("%Y-%m-%d %H:%M:%S", os.time()),
        userid = userinfo.id,
        avatar = userinfo.avatarurl,
    }
    table.insert(self._recordData, 1, newData)

    local item = self._tmpItem:clone()
    item:setVisible(true)
    self:setRecordItemData(item, newData)
    self.pv_record:insertPage(item, 0)
    self.pv_record:setCurrentPageIndex(self._curPage + 1)

    for i,v in ipairs(self._extraItems) do
        self:setRecordItemData(v, self._recordData[i])
    end
end

function LottoView:startTimer( )
    if self._recordTimer then
        self._recordTimer:killAll()
    else
        local Timer = require("common.utils.Timer")
        self._recordTimer = Timer.new()
    end
    self._recordTimer:start(handler(self, self.autoScrollView), 2)
end

function LottoView:autoScrollView( )
    local index = self.pv_record:getCurrentPageIndex() + 1
    self._curPage = index
    self.pv_record:scrollToPage(index)
    if index >= #self._recordData + 1 then
        self.pv_record:setCurrentPageIndex(0)
    end
end

function LottoView:showDataLoading()
    if not self.loadingNode then
        self.loadingNode = ccui.Text:create()
        self.loadingNode:setFontSize(34)
        self.loadingNode:setTextColor({r = 127, g = 127, b = 127})
        self.loadingNode:setString("数据加载中...")
        self.loadingNode:setPosition(self.panel_record:getContentSize().width / 2, self.panel_record:getContentSize().height / 2)
        self.panel_record:addChild(self.loadingNode)
    end
    self.loadingNode:setVisible(true)
end

function LottoView:hideDataLoading()
    if self.loadingNode then
        self.loadingNode:setVisible(false)
    end
end

------------------------------------------
-- 中奖概率界面
-----------------------------------------
function LottoView:onClickDetail(sender)
    self:getScene():createView("luckybag.ProbabilityPopView", self._rateTb):pushInScene()
end

return LottoView
