--
-- Author: Cai
-- Date: 2017-03-24
-- Describe：荣誉等级界面

local M = class("HonorLevelSubView", cc.load("ViewBase"))

M.RESOURCE_FILENAME = "ui/honor/honor_level_view.lua"
M.RESOURCE_BINDING = {
    ["sv_honor"] = {["varname"] = "sv_honor"},
    ["btn_cheats"] = {["varname"] = "btn_cheats",  ["events"] = {{["event"] = "click", ["method"] = "onClickCheats"}}},
    ["panel_share"]   = {["varname"] = "panel_share"  },
    ["img_arrow1"]   = {["varname"] = "img_arrow1"  },
    ["img_arrow2"]   = {["varname"] = "img_arrow2"  },
    ["panel_userinfo"]   = {["varname"] = "panel_userinfo"  },
    ["txt_tips"] = {["varname"] = "txt_tips"},
}

local GRADE_STR = gg.HonorHelper:getGradeStrCfg()

function M:onCreate(grade,data)
    self._grade = grade
    self.awardNode = nil
    self.awarddata = nil
    self.sv_honor:setScrollBarEnabled(false)
    self._propDef  = gg.GetPropList()
    -- 审核模式不显示排行
    if IS_REVIEW_MODE then
        self.panel_share:setVisible(false)
    end
    self._grade = 1
    self:createUserAvatar()
    --更新用户消息
    self:updateUserInfoNode()

    self:updateUsershare(data)
    --设置段位奖励
    gg.HonorHelper:getHonorRewardCfg(handler(self, self.setgradeAward))

    self:initView()
    -- 添加滚动事件，控制提示箭头的显示
    self.sv_honor:addEventListener(function(sender, eventType)
        local rightcount = 0
        if eventType == 10 then
            rightcount = math.abs(math.floor(self.sv_honor:getInnerContainerPosition().x / self.sv_honor:getInnerContainerSize().width * 100))
        end

        if eventType == ccui.ScrollviewEventType.bounceLeft then
            self.img_arrow1:setVisible(false)  --左边箭头
            self.img_arrow2:setVisible(true)  --右边箭头
        elseif rightcount >= 51 then
            self.img_arrow1:setVisible(true)
            self.img_arrow2:setVisible(false)
        elseif eventType == ccui.ScrollviewEventType.scrolling then
            self.img_arrow1:setVisible(true)  --左边箭头
            self.img_arrow2:setVisible(true)  --右边箭头

            if self.awardNode:isVisible() then
                self.awardNode:setVisible(false)

            end
        end
    end)
end
function M:initView()

    self.awardNode = require( "ui.honor.honor_award_item.lua").create().root
    self.awardNode:setVisible(false)
    self.sv_honor:addChild(self.awardNode)

    --设置段位奖杯
    self:setgradeView()
end

--获取荣誉点击奖励数据
function M:getgradeData(data)
    local AwardData = {}
    for i =1, #data  do
        if data[i].id and data[i].id == 93 then
            AwardData = data[i].awards
            return AwardData
        end
    end
    return false
end
function M:setgradeAward(rewardData)
    self.awarddata = rewardData
end
function M:createUserAvatar()
    local imgBg = self.panel_userinfo:findNode("img_avatar")
    -- 创建头像
    local drawNode = gg.DrawNodeRoundRect(cc.DrawNode:create(),cc.rect(0,0,62,-67), 1, 8, cc.c4b(0, 0, 0, 1), cc.c4f(0, 0, 0, 1))
    local clipNode = cc.ClippingNode:create(drawNode)
	clipNode:setInverted(false)
    clipNode:setPosition(0, 0)
    imgBg:addChild(clipNode)

    self._avatar = ccui.ImageView:create("common/hd_male.png")
    self._avatar:setPosition(62/2, 67/2)
    self._avatar:ignoreContentAdaptWithSize(true)

    self._avatar:setScale(68/self._avatar:getContentSize().width)
    clipNode:addChild(self._avatar)
end

function M:updateUserInfoNode()
    if not hallmanager or not hallmanager.userinfo then return end
    local userinfo = hallmanager.userinfo
    -- 设置玩家昵称
    local txt_nick = self.panel_userinfo:findNode("txt_nickname")
    txt_nick:setString(userinfo.nick)
    if txt_nick:getContentSize().width > 110 then
        local strNick = gg.SubUTF8StringByWidth(tostring(userinfo.nick), 110, 24, "")
        txt_nick:setString(strNick)
    end

    local hlvExp = hallmanager:GetHonorValue()
    self._grade =  gg.GetHonorGradeAndLevel(hlvExp)
    self.panel_userinfo:findNode("txt_honor"):setString(hlvExp)

    -- 加载用户头像
    local avatarPath = gg.IIF(userinfo.sex == 1, "common/hd_male.png", "common/hd_female.png")
    if userinfo.avatar == 0xFFFFFFFF then
        avatarPath = userinfo.avatarurl
        gg.ImageDownload:LoadUserAvaterImage({url = avatarPath, ismine = true, image = self._avatar}, function()
            self._avatar:setScale(68 / self._avatar:getContentSize().width)
        end)
    else
        self._avatar:loadTexture(avatarPath)
    end
end

--显示荣誉等级页面
function M:setgradeView()

    self.sv_honor:setInnerContainerSize( {width = 335 *6, height = 390} )
    -- 根据配置表中的数据设置详细中的数值显示
    local htb = gg.GetHonorExpTable()
    for i = 1, 6 do
        local propNode = nil
        if self._grade == i then
            propNode = require( "ui.honor.honor_grade_item_2.lua").create()
        else
            propNode = require( "ui.honor.honor_grade_item_1.lua").create()
        end
        local root = propNode.root

        --点击item不能翻页的解决方法
        local panel = root:getChildByName("panel_1")
        root:removeChild(panel)
        local item = ccui.Layout:create()
        item:addChild(panel)

        local img_suo = panel:getChildByName("img_suo")  --锁
        local img_di = panel:getChildByName("img_di")

        local img_cup = panel:getChildByName("img_cup")  --奖杯图片
        img_cup:ignoreContentAdaptWithSize(true)
       -- 补领奖励 审核模式下不可点击
        if  i <= self._grade and  not IS_REVIEW_MODE then
            panel:addClickEventListener(function()
                self:onClickCurGrade(i)
            end )
        end
        -- 大于本身荣誉值才可点击；审核模式下不可点击
        if i > self._grade and not IS_REVIEW_MODE then
            --背景点击显示奖励
            panel:onClickScaleEffect( function( )
                self:onClickAward(item,i)
            end )
        end

        img_cup:loadTexture(string.format("hall/newhonor/grade_%d.png", i), 1)
        if  self._grade == i then
            img_cup:loadTexture(string.format("hall/honor/grade_img_%d.png", i), 1)
            local nd_honor = panel:getChildByName("nd_star")
            -- 根据荣誉等级计算出用户所在的等级
            local hlvExp = hallmanager:GetHonorValue()
            local grade, star = gg.GetHonorGradeAndLevel(hlvExp)
            -- 初始星星数显示
            for i = 1 ,5 do
                nd_honor:getChildByName("star_" .. i):setPercent(0)
            end
            -- 设置星星数显示
            for i=1,star do
                nd_honor:getChildByName("star_" .. i):setPercent(100)
            end
            if star < 5 then
                local lv, minExp, nextExp= gg.GetHonorLevel(hlvExp)
                local percent = (hlvExp - minExp) / (nextExp - minExp) * 100
                nd_honor:getChildByName("star_" .. star + 1):setPercent(percent)
            end
        end
        if  i > self._grade then
            img_suo:setVisible(true)
        end

        if self._grade > 3 and i == self._grade then
            img_cup:setScale(1.05)
        end
        local txt = panel:getChildByName("txt_grade")
        local a = gg.IIF(i==1, 0, string.format("%s", String:numToZn(checkint(htb[5 * (i -1)]), 4, 1)))
        local b = string.format("%s", String:numToZn(checkint(htb[5 * i]), 4, 1))
        txt:setString(string.format("%s(%s-%s)", GRADE_STR[i], a, b))

        item:setPosition(30+320*(i-1),0)
        self.sv_honor:addChild(item)
    end
    if self._grade == 1 or self._grade == 2 then
        self.img_arrow1:setVisible(false)  --左边箭头
        self.img_arrow2:setVisible(true)  --右边箭头
    elseif self._grade == 3 then
        self.sv_honor:jumpToPercentHorizontal(33)
    elseif self._grade == 4 then
        self.sv_honor:jumpToPercentHorizontal(66)
    elseif self._grade == 5 or self._grade == 6 then
        self.sv_honor:jumpToPercentHorizontal(98)
        self.img_arrow1:setVisible(true)  --左边箭头
        self.img_arrow2:setVisible(false)  --右边箭头
    end
end
--点击拉取当前的奖励
function M:onClickCurGrade(i)
    if checkint(i) <=1 then return end
    local curclick = i
    if gg.UserData:CanGetCurGradeHonoAward(curclick) then
        gg.Dapi:TaskAward(93, curclick-1, curclick-1, function(data)
            if data.status and checkint(data.status) == 0 then
                printf("领取奖励成功")
                --领取后设置为1
                gg.UserData:SetCurGradeHonoAward(curclick, curclick)
                gg.HonorHelper:getHonorRewardCfg(function(rewardData)
                    if rewardData[curclick-1] then
                        GameApp:DoShell(nil, "GetRewardView://", rewardData[curclick - 1])
                    end
                end)
            else
                printf("已领取任务奖励 ")
            end
        end)
    end

end
function M:onClickAward(cupNode, Honortype)
    self.awardNode:setVisible(true)
    self.awardNode:setPosition(cc.p(cupNode:getPositionX() +200, cupNode:getPositionY() +305) )

    local panel =  self.awardNode:getChildByName("panel_1")
    local award = panel:getChildByName("award")
    local txt1 = panel:getChildByName("txt1")
    local img_line =  award:getChildByName("img_line")  --线

    local img_award_1 =  award:getChildByName("award_1")  --奖励1图片

    local img_award_2 =  award:getChildByName("award_2")  --奖励2图片

    local award_count1 =  award:getChildByName("award_count1")  --奖励1数量

    local award_count2 =  award:getChildByName("award_count2")  --奖励2数量
    if Honortype >1 and self.awarddata then  --显示奖励
        award:setVisible(true)
        txt1:setVisible(false)
        local award1 =  self.awarddata[Honortype-1][1] --奖励1
        local awardid1 = award1[1]
        local awardcount1 = award1[2]

        local award2 =  self.awarddata[Honortype-1][2] --奖励2
        local awardid2 = award2[1]
        local awardcount2 = award2[2]

        img_award_1:loadTexture(self._propDef[awardid1].icon, 0)
        img_award_2:loadTexture(self._propDef[awardid2].icon, 0)
        local strtxt1 = gg.MoneyUnit(awardcount1)
        award_count1:setString(strtxt1)

        local strtxt2 = gg.MoneyUnit(awardcount2)
        award_count2:setString(strtxt2)
    else
        award:setVisible(false)
        txt1:setVisible(true)
    end
end

function M:onEnter()

end

-- 地区分享面板
function M:updateUsershare(data)
    if not data then
        self.panel_share:setVisible(false)
        return
    end

    -- 先暂时隐藏
    for i=1,3 do
        self.panel_share:findNode("item_" .. i):setVisible(false)
    end

    for i,v in ipairs(data) do
        self.panel_share:findNode("item_" .. i):setVisible(true)
        local dq = self.panel_share:findNode("txt_diqu" .. i)
        local px = self.panel_share:findNode("txt_top" .. i)

        dq:setVisible(true)
        px:setVisible(true)
        dq:setString(v.name)

        if checkint(v.rank) <= 0 then
            px:setString("未上榜")
        else
            px:setString(string.format("第%d名", tonumber(v.rank)))
        end

        local bestData = checktable(data[i])
        local btn = self.panel_share:findNode("btn_share"..i)
        if GameApp:CheckModuleEnable(ModuleTag.WeixinShare) then
            btn.data = bestData
            btn:setVisible(true)
            btn:onClickScaleEffect(handler(self, self.onClickShare))

            local status = gg.UserData:GetHonorShareTaskStatus()
            self.txt_tips:setVisible(status == 3)
        else
            btn:setVisible(false)
        end
    end
end

function M:onClickShare(sender)
    gg.AudioManager:playClickEffect()
    gg.HonorHelper:doHonorShare(sender.data, function(result)
        if checkint(result.status) ~= 0 then return end

        local status = gg.UserData:GetHonorShareTaskStatus()
        -- 分享完成的不再请求领取奖励接口
        if status ~= 3 then return end

        local shareTb = gg.UserData:GetShareDataTable("honor")
        local wxID = shareTb.wx_id or shareTb.id
        -- 分享成功每次都需要请求领取奖励接口来做统计
        gg.Dapi:ShareTaskAward(92, 1, 0,wxID,shareTb.domain, checkint(shareTb.share_id),function(x)
            if x.status == 0 then
                gg.UserData:SetHonorShareTaskStatus(5)
                if tolua.isnull(self) then return end
                self.txt_tips:setVisible(false)
                -- 奖励提示动画
                GameApp:DoShell(nil, "GetRewardView://", {{15, 2000}})
            else
                print(x.msg or "未知错误！")
            end
        end)
    end)
end

-- 升级小秘籍
function M:onClickCheats()
    gg.AudioManager:playClickEffect()
    self:getScene():createView("honor.HonorCheatsView", self._grade):pushInScene()
end

return M