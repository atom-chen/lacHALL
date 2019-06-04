local M = class("WelfareMrqdActive", cc.load("ViewPop"))
M.RESOURCE_FILENAME = "ui/welfare/welfareMrqdActive.lua"
M.RESOURCE_BINDING =
{
    ["Panel_bg"] = { ["varname"] = "Panel_bg"},

    ["sv_mrqd"] = { ["varname"] = "sv_mrqd"},


    ["btn_close"] = {["varname"] = "btn_close",  ["events"] = {{["event"] = "click", ["method"] = "onClickClose"}}},

    ["txt_hint"] = { ["varname"] = "txt_hint"},
    ["txt_data"] = { ["varname"] = "txt_data"},

    ["img_base"] = { ["varname"] = "img_base"},

    ["img_top"] = { ["varname"] = "img_top"},

    ["vip_btn"] = {["varname"] = "vip_btn",  ["events"] = {{["event"] = "click", ["method"] = "onClickVIP"}}},

}
M.LAYER_ALPHA = 25

local vipAdditionDate =
{
    {min = 0, max = 2, count = 1},
    {min = 3, max = 6, count = 1.5},
    {min = 7, max = 10, count = 2},
    {min = 11, max = 13, count = 2.5},
    {min = 14, max = 16, count = 3},
}

local welfareData   = require("hall.models.WelfareData")
local SV_ITEM_RANK = 5  --容器一排的个数

function M:onCreate()
    self:init()
    --适配
    self:resetLayout()
end

function M:init()
    self.awardData = nil
    gg.UserData:checkLoaded(function()
        if tolua.isnull(self) then return end

        --设置奖励视图
        welfareData:getDailySignCfg(handler(self, self.setMrqdView))
        --获取每日分享奖励数据
        welfareData:getDayShareAward(handler(self, self.setDaySharecfg))
    end)

    -- 添加滚动事件，控制提示阴影图片的显示
    self.sv_mrqd:addEventListener(function(sender, eventType)
        if eventType == ccui.ScrollviewEventType.bounceBottom then
            self.img_base:setVisible(false)
            self.img_top:setVisible(true)
        elseif eventType == ccui.ScrollviewEventType.bounceTop then
            self.img_base:setVisible(true)
            self.img_top:setVisible(false)
        elseif eventType == ccui.ScrollviewEventType.scrolling then
            self.img_base:setVisible(true)
            self.img_top:setVisible(true)
        end
    end)
end
--适配
function M:resetLayout()
    --隐藏滚动条
    self.sv_mrqd:setScrollBarEnabled(false)
    self:setScale(display.scaleX)
end
function M:setDaySharecfg(data)
    self.DaySharecfg = data
end

--显示每日签到页面
function M:setMrqdView(awardData)
    if tolua.isnull(self) then return end
    self.txt_data:setVisible(false)
    if not awardData then
        self.txt_hint:setVisible(true)
        return
    end
    --删除容器元素
    self.sv_mrqd:removeAllChildren()
    --获取新手签到次数
    local newUserCount = gg.UserData:GetNewUserCount()
    --获取签到的状态 3 没有签到 5已经签到 nil 代表web接口访问失败
    local Daytatus = gg.UserData:GetDailySignStatus()

    self.awardData = awardData
    --获取每日签到的次数
    self.iCount = gg.UserData:GetDailyCount()
    self.sv_mrqd:setInnerContainerSize( {width = 935, height = (#awardData/SV_ITEM_RANK)* 202} )
    for i = 1, #awardData do
        local  propNode = require( "ui.welfare.welfareMrqdItem.lua").create()
        local root = propNode.root

        --点击item不能翻页的解决方法
        local panel = root:getChildByName("Panel_1")
        root:removeChild(panel)
        local item = ccui.Layout:create()
        item:addChild(panel)
        local lq_panel = panel:getChildByName("lq_panel")
        --未签到可以点击签到
        if Daytatus and Daytatus == 3 and i == self.iCount+1  then
            panel:onClickScaleEffect( function()
                self:onClickDaily()
            end )
        else
            if Daytatus and Daytatus == 5  then
                panel:onClickScaleEffect( function()
                    GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "今天您已经签到过了，明天再来哦！")
                end)
            end
        end

        local glow_1 = panel:getChildByName("glow_1")
        local mrqd_1 = panel:getChildByName("mrqd_1")
        glow_1:runAction(propNode.animation)
        if Daytatus == 3  and i == self.iCount+1 then
            if propNode.animation then
                self.animation = propNode.animation
                self.glow_1 = glow_1
                glow_1:setVisible(true)
                mrqd_1:setVisible(true)
                propNode.animation:play("animasign", true)
            end
        end


        local txt_number = panel:getChildByName("txt_number")
        txt_number:setString(i)
        local iwidth = txt_number:getContentSize().width
        local txt_1 = panel:getChildByName("txt_1")
        txt_1:setString("第      天")
        if iwidth >= 20 then
            txt_1:setString("第        天")
        end
        for z,value in pairs(awardData[i]) do
            local img_tp = panel:getChildByName("img_tp")  --图片
            local txt_count = panel:getChildByName("txt_count")  --数量
            -- 奖励图片
            local prop = gg.GetPropList()[value[1]]
            img_tp:ignoreContentAdaptWithSize(true)
            if value[1] == PROP_ID_MONEY or value[1] == PROP_ID_XZMONEY then
                local path = value[1] == PROP_ID_MONEY and "hall/welfare/sign/icon_doudou.png" or "hall/welfare/sign/icon_zuanshi.png"
                img_tp:loadTexture(path, 1)
            else
                img_tp:loadTexture(prop.icon)
            end
            img_tp:setScale(90 / img_tp:getContentSize().width)
            -- 物品名称
            if value[1] == PROP_ID_MONEY then
                -- 奖励数量
                local cnt = value[2] * (prop.proportion or 1)
                txt_count:setString(string.format("%d豆",cnt))
            else
                -- 奖励数量
                local name = prop.name
                local cnt = value[2] * (prop.proportion or 1)
                txt_count:setString(string.format("%sx%d",name,cnt))
            end

            self:VipShow(value[1], panel)
        end

        --已经签到显示遮罩
        local vipZz = panel:getChildByName("vip_panel_zhezhao")

        if i <= self.iCount  then
            lq_panel:setVisible(true)
            local bshow = true
            if awardData[i][1][1] == PROP_ID_CANSAI or awardData[i][1][1] == PROP_ID_JIPAI then
                bshow = false
            end
            vipZz:setVisible(bshow)
        else
            vipZz:setVisible(false)
        end

        local rank = math.fmod(i - 1, SV_ITEM_RANK)  --i
        local row = math.ceil(i / SV_ITEM_RANK) - 1  --j

        item:setPosition(90+168*rank,  500 - 202 *row)
        self.sv_mrqd:addChild(item)

    end
    --设置跳转
    if self.iCount >= 5 then
        self.img_base:setVisible(false)
        self.img_top:setVisible(true)
        self.sv_mrqd:scrollToPercentVertical(100, 0, false)
    else
        self.img_base:setVisible(true)
        self.img_top:setVisible(false)
    end
end

function M:VipShow(id , panel)
    --Vip特权
    local vipBg = panel:getChildByName("vip_panel")
    local vipText = panel:getChildByName("vip_txt")
    local vipZz = panel:getChildByName("vip_panel_zhezhao")
    local bShow = true
    if id == PROP_ID_CANSAI or id == PROP_ID_JIPAI then
        bShow = false
    end
    --除了参赛券，记牌器其他都要显示vip
    vipBg:setVisible(bShow)
    vipText:setVisible(bShow)
    vipZz:setVisible(bShow)
    local vipGrade = welfareData:getVipGrade()
    if vipGrade >= 3 then
        vipText:setString("x".."v"..vipGrade.."t")
    else
        vipText:setString("v".."3".."j")
    end
    vipZz:setContentSize(cc.size(vipText:getContentSize().width + 10,27))
    vipBg:setContentSize(cc.size(vipText:getContentSize().width + 10,27))
end
--点击签到按钮
function M:onClickDaily()
    local cnt = self.iCount
    gg.AudioManager:playClickEffect()
    --3代表新版的记牌器  --直接使用的记牌器
    gg.Dapi:TaskAward(96, 3, 0, function(data)
        if data.status == 0 then

            --设置签到计数加一
            gg.UserData:SetDailyCount(cnt +1)
            --设置签到状态 5已签到
            gg.UserData:SetDailySignStatus(5)
            --福利的刷新显示通知
            GameApp:dispatchEvent(gg.Event.WELFARE_ACTIVITY, "mrqd")

            if tolua.isnull(self) then return end

            --刷新页面
            self:setMrqdView(self.awardData)

            --显示奖励特效
            if self.awardData then
                self:setDayAward()
            end
            printf("领取奖励成功")
        else
            printf("已领取任务奖励 ")
        end
    end)

end

--设置每日奖励
function M:setDayAward()
    local params = {}
    params.btnImgPath ="hall/welfare/sign/newShareBtn1.png"
    params.shareCallback =  function(result)
        if tolua.isnull(self) then return end
        if result.status == 0 then
            if self.awardview and self.awardview.removeWithoutCallback then
                self.awardview:removeWithoutCallback()
            end
            if self.setShareAward then
                self:setShareAward()
            end
        end
    end
    self.awardview = GameApp:DoShell(nil, "GetRewardView://2",  self:shareCommonDate() ,params)
end

--设置分享奖励
function M:setShareAward()
    local shareTb = gg.UserData:GetShareDataTable()
    local wxID = shareTb.wx_id or shareTb.id
    -- 分享成功每次都需要请求领取奖励接口来做统计
    --3代表新版的记牌器  --直接使用的记牌器
    gg.Dapi:ShareTaskAward(97, 3, 0,wxID,shareTb.domain, checkint(shareTb.share_id),function(data)
        if tolua.isnull(self) then return end
        if data.status == 0 then
            GameApp:DoShell(nil, "GetRewardView://0", self:shareCommonDate())
        end
    end)
end
--分享的加成数据
function M:shareCommonDate()
    self.iCount = (self.iCount == 0) and 15 or self.iCount
    local awardTab = self.awardData[self.iCount]
    local count = 0
    local vipGrade = welfareData:getVipGrade()
    for i,v in ipairs(vipAdditionDate) do
        if v.min <= vipGrade and v.max >= vipGrade then
            count = checkint(awardTab[1][2]) * tonumber(v.count)
            break;
        end
    end
    --参赛卷和记牌器不加成
    if awardTab[1][1] == PROP_ID_CANSAI or awardTab[1][1] == PROP_ID_JIPAI then
        count = awardTab[1][2]
    end
    local awardShareTab = {{awardTab[1][1], count}}
    return awardShareTab
end

--关闭
function M:onClickClose()
    self:removeSelf()
end

function M:onClickVIP()
   GameApp:DoShell(nil, "Vip://")
end

return M
