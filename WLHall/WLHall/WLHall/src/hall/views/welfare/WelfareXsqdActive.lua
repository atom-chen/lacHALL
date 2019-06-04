--新手签到页面

local M = class("WelfareXsqdActive", cc.load("ViewPop"))

M.RESOURCE_FILENAME = "ui/welfare/welfareXsqdActive.lua"
M.RESOURCE_BINDING =
{
    ["Panel_bg"] = { ["varname"] = "Panel_bg"},
    ["sv_xsqd"] = { ["varname"] = "sv_xsqd"},

    ["btn_close"] = {["varname"] = "btn_close",  ["events"] = {{["event"] = "click", ["method"] = "onClickClose"}}},

    ["btn_lq"] = {["varname"] = "btn_lq",  ["events"] = {{["event"] = "click", ["method"] = "onClicklq"}}},

    ["btn_ylq"] = {["varname"] = "btn_ylq",  ["events"] = {{["event"] = "click", ["method"] = "onClickClose"}}},

    ["txt_hint"] = { ["varname"] = "txt_hint"},

    ["img_left"] = { ["varname"] = "img_left"},  --左边
    ["img_right"] = { ["varname"] = "img_right"},       --右边

    ["txt_data"] = { ["varname"] = "txt_data"},
}
M.LAYER_ALPHA = 25

local welfareData   = require("hall.models.WelfareData")

function M:onCreate()
    self:init()

    --适配
    self:resetLayout()

end
--适配
function M:resetLayout()
    --隐藏滚动条
    self.sv_xsqd:setScrollBarEnabled(false)
    self:setScale(display.scaleX)
    -- 添加滚动事件，控制提示左右阴影图片的显示
    self.sv_xsqd:addEventListener(function(sender, eventType)
        --item 所在的位置
        local curpos =   math.abs(math.floor(self.sv_xsqd:getInnerContainerPosition().x))
        --item 容器的宽度度
        local svwidth=  math.abs(math.floor(self.sv_xsqd:getInnerContainerSize().width))
        --可视的排行高度
        local sheight = self.sv_xsqd:getContentSize().width
        --左边
        if eventType == ccui.ScrollviewEventType.bounceLeft then
            self.img_left:setVisible(false)
            self.img_right:setVisible(true)
        elseif sheight  >=svwidth - curpos then  --右边
            self.img_left:setVisible(true)
            self.img_right:setVisible(false)
        elseif eventType == ccui.ScrollviewEventType.scrolling then
            self.img_left:setVisible(true)
            self.img_right:setVisible(true)
        end
    end)

end

function M:init()
    --当前签到的按钮
    self.signBtn = nil
    self.awardData = nil
    gg.UserData:checkLoaded(function()
        if tolua.isnull(self) then return end
        --获取新手签到状态
        self.iStatus = gg.UserData:GetNewUserSignStatus()
        if not self.iStatus  then
            self.btn_lq:setVisible(false)
            self.btn_ylq:setVisible(false)
        elseif self.iStatus == 5 then  --已经领取
            self.btn_lq:setVisible(false)
            self.btn_ylq:setVisible(true)
        end

        --设置奖励视图
        welfareData:getNewUserSignCfg(handler(self, self.setXsqdView))
    end)
end
--显示新手签到页面
function M:setXsqdView(awardData,beiShuData)
    if tolua.isnull(self) then return end
    self.beiShuData= beiShuData
    self.txt_data:setVisible(false)
    if not awardData then
        self.btn_lq:setVisible(false)
        self.txt_hint:setVisible(true)
        return
    end

    --奖励数据
    self.awardData = awardData
    --获取签到次数
    self.iCount = gg.UserData:GetNewUserCount()
    self.sv_xsqd:setInnerContainerSize( {width = 215 *#awardData, height = 288} )

    --获取魔法道具数量
    local mofacount = 0
    for i = 1, #awardData do
        for s,v in pairs(awardData[i]) do
          local propCount = v[2]
            if gg.IsMagicProp(v[1]) then
                mofacount = mofacount +propCount
            end
        end
    end

    for i = 1, #awardData do
        local  propNode = require( "ui.welfare.welfareXsqdItem.lua").create()
        local root = propNode.root

        --点击item不能翻页的解决方法
        local panel = root:getChildByName("Panel_1")
        root:removeChild(panel)
        local item = ccui.Layout:create()
        item:addChild(panel)
        --未签到显示特价
        local glow_1 = panel:getChildByName("glow_1")
        local xsqd_1 = panel:getChildByName("xsqd_1")

        glow_1:runAction(propNode.animation)
        if self.iStatus == 3  and i == self.iCount+1 then
            if propNode.animation then
                self.glow_1 = glow_1
                self.animation = propNode.animation
                glow_1:setVisible(true)
                xsqd_1:setVisible(true)
                propNode.animation:play("animasign", true)
            end
        end

        local txt_number = panel:getChildByName("txt_number")
        txt_number:setString(i)

        -- local img_bei = panel:getChildByName("img_bei")
        -- --设置双倍的显示
        -- for v,z in ipairs(beiShuData) do
        --     if i == z then
        --         img_bei:setVisible(true)
        --     end
        -- end

        local award_panel = panel:getChildByName("award_panel")
        --设置奖励
        local awardamount = #awardData[i]
        for z,value in pairs(awardData[i]) do
            if z >= 3 then
                break
            end
            local img = award_panel:getChildByName("img_award"..z)
            local txt_count = award_panel:getChildByName("txt_count"..z)
            --设置魔法道具
            if gg.IsMagicProp(value[1]) then
                img:loadTexture("common/prop/gift_1.png")
                local nameStr = string.format("魔法道具x%d",mofacount)
                txt_count:setString(nameStr)
                img:setVisible(true)
                txt_count:setVisible(true)
            else
                -- 奖励图片
                local prop = gg.GetPropList()[value[1]]

                img:setVisible(true)
                img:loadTexture(prop.icon)

                if value[1] == PROP_ID_MONEY then
                    -- 奖励数量
                    local cnt = value[2] * (prop.proportion or 1)
                    txt_count:setVisible(true)
                    txt_count:setString(string.format("%d豆",cnt))
                else
                    -- 物品名称
                    local name = prop.name
                    -- 奖励数量
                    local cnt = value[2] * (prop.proportion or 1)
                    txt_count:setVisible(true)
                    txt_count:setString(string.format("%sx%d", name,cnt))
                end


            end
            --如果只有一个奖励的话 显示居中
            if awardamount == 1 then
                img:setPositionX(award_panel:getContentSize().width/2)
                txt_count:setPositionY(txt_count:getPositionY() - 20)
            end

        end

        local lq_panel = panel:getChildByName("lq_panel")   --已经签到显示
        if i <= self.iCount  then  --已签到的显示
            lq_panel:setVisible(true)
        end
        if i == self.iCount + 1 and self.iCount  +1 < #awardData +1 then
            self.signBtn = lq_panel
        end

        item:setPosition(215*(i-1),10)
        self.sv_xsqd:addChild(item)
    end
    --设置跳转和左右图片的显示
    if self.iCount >=3 then
        self.sv_xsqd:jumpToPercentHorizontal(100)
        self.img_left:setVisible(true)
        self.img_right:setVisible(false)
    elseif self.iCount ==2 then
        self.sv_xsqd:jumpToPercentHorizontal(50)
        self.img_left:setVisible(true)
        self.img_right:setVisible(true)
    else
        self.img_left:setVisible(false)
        self.img_right:setVisible(true)
    end

end

--点击签到按钮
function M:onClicklq()
    local cnt = self.iCount
    gg.AudioManager:playClickEffect()
    --3代表新版的记牌器  --直接使用的记牌器
    gg.Dapi:TaskAward(94, 3, 0, function(data)
        if data.status == 0 then
            --设置签到次数+1
            gg.UserData:SetNewUserCount(cnt +1)
            --设置签到状态
            gg.UserData:SetNewUserSignStatus()
            --福利的刷新显示通知
            GameApp:dispatchEvent(gg.Event.WELFARE_ACTIVITY, "mrqd")

            if tolua.isnull(self) then return end
            self.btn_lq:setVisible(false)
            self.btn_ylq:setVisible(true)
            --签到成功隐藏动画
            if self.glow_1 then
                self.glow_1:setVisible(false)
            end
            if self.animation then
                self.animation:stop()
            end
            if self.signBtn then
                self.signBtn:setVisible(true)
            end

            --设置奖励
            if self.awardData then

                if self:isMultipleAward() then
                    self:setOneAward()
                else
                    self:setAward()
                end

            end
            printf("领取奖励成功")
        else
            printf("已领取任务奖励 ")
        end
    end)

end

--是否是双倍奖励
function M:isMultipleAward()
    if not self.beiShuData then return end
    local isMultipleAward = false
    local iCount = gg.UserData:GetNewUserCount()
    for k,v in pairs(self.beiShuData ) do
        if iCount == v then
            isMultipleAward = true
        end
    end
    return isMultipleAward
end

--设置分享奖励第一次奖励
function M:setOneAward()
    local params = {}
    params.btnImgPath ="hall/welfare/sign/newShareBtn1.png"
    params.shareCallback = function(result)
        if result.status == 0 then
            if tolua.isnull(self) then return end
            if self.awardview and self.awardview.removeWithoutCallback then
                self.awardview:removeWithoutCallback()
            end
            --分享奖励
            self:setShareAward()
        end
    end
    params.removeCallback =  function()
        if tolua.isnull(self) then return end
        self:setDaySate()
    end
    --设置签到奖励
    self.awardview = GameApp:DoShell(nil, "GetRewardView://2",  self.awardData[self.iCount+1],params)
end

--普通奖励
function M:setAward()
    local params = {}
    params.removeCallback  = function()
        if tolua.isnull(self) then return end
        self:setDaySate()
    end
    --设置签到奖励
    GameApp:DoShell(nil, "GetRewardView://0",  self.awardData[self.iCount+1],params)
end

--设置每日签到的状态及设置通知福利动画的播放
function M:setDaySate()

    local iCount = gg.UserData:GetNewUserCount()
    if iCount == 5 then
        self:removeSelf()
    end

end
--设置分享奖励
function M:setShareAward()
    local shareTb = gg.UserData:GetShareDataTable()
    local wxID = shareTb.wx_id or shareTb.id
    -- 分享成功每次都需要请求领取奖励接口来做统计
    --3代表新版的记牌器  --直接使用的记牌器
    gg.Dapi:ShareTaskAward(95, 3, 0,wxID,shareTb.domain, checkint(shareTb.share_id),function(data)
        if tolua.isnull(self) then return end
        if data.status == 0 then
            --显示第二次奖励
            self:setAward()
        end
    end)

end

--关闭
function M:onClickClose()

    self:removeSelf()
end

return M