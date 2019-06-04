--
-- Author: liacheng
-- Date: 2018-03-07
-- Describe：规则界面

local ArenaRuleView = class("ArenaRuleView", cc.load("ViewPop"))
ArenaRuleView.RESOURCE_FILENAME = "ui/arena/arena_rule.lua"
ArenaRuleView.RESOURCE_BINDING = {
    ["txt_content"]   = { ["varname"] = "txt_content" },
    ["sv"]   = { ["varname"] = "sv" },
    ["txt_title"]   = { ["varname"] = "txt_title" },

    ["btn_close"]   = {["varname"] = "btn_close",["events"]={{["event"] = "click",["method"]="onClickClose"}}},

}

ArenaRuleView.AUTO_RESOLUTION = true

local ContentStr = [[
参赛规则
1.	日排位开放时间为每日00:00至23:59，超过结算时间将不会计入当日积分；
2.	玩家在各玩法普通场、精英场、土豪场、至尊场中赢局均可获得积分；
3.	每日晚23:59后定榜结算；

比赛规则
1.	在开放时间内进入各玩法普通场、精英场、土豪场、至尊场中进行游戏，赢局将获得对应数量的积分，输局也会扣除对应积分；
2.	玩家赢局获得的积分受到VIP等级、普通月卡、星耀月卡等的加成影响，扣除不受加成影响；

奖励说明
1.	积分相同的情况下，先到达该点数的玩家排名在前；
2.	每日定榜后，积分最高的玩家将成为日冠军，获得日冠军大奖，其它积分排名靠前的玩家也会依次获得对应奖励；
3.   奖励将通过邮件发放，请及时查看；
]]


local ContentStr2 = [[
参赛规则
1.	周排位开放时间为当周每日00:00至23:59，超过结算时间将不会计入当周积分；
2.	玩家在各玩法普通场、精英场、土豪场、至尊场中赢局均可获得积分；
3.	每周日晚23:59后定榜结算；

比赛规则
1.	在开放时间内进入各玩法普通场、精英场、土豪场、至尊场中进行游戏，赢局将获得对应数量的积分，输局也会扣除对应积分；
2.	玩家赢局获得的积分受到VIP等级、普通月卡、星耀月卡等的加成影响，扣除不受加成影响；

奖励说明
1.	积分相同的情况下，先到达该点数的玩家排名在前；
2.	每周定榜后，积分最高的玩家将成为周冠军，获得周冠军大奖，其它积分排名靠前的玩家也会依次获得对应奖励；
3.	奖励将通过邮件发放，请及时查看；
        ]]

function ArenaRuleView:onCreate(data)
    -- 隐藏滚动条
    self.sv:setScrollBarEnabled(false)
    self:initView(data)
end

function ArenaRuleView:initView(data)
    if not data then return end
    if data == 1  then
        self.txt_title:setString("日排位规则说明")
    else
        self.txt_title:setString("周排位规则说明")
    end
    -- 创建一个 label 替换掉 txt_content
    self.real_content = cc.Label:create()
    self.real_content:setSystemFontSize(28)
    self.real_content:setString( gg.IIF(data == 1,ContentStr,ContentStr2))
    self.real_content:setTextColor( { r = 103 , g = 103, b = 103 } )
    self.real_content:setAnchorPoint( cc.p( 0, 1 ) )

    self.real_content:setWidth( self.txt_content:getContentSize().width )
    self.real_content:setPosition( self.txt_content:getPosition() )
    self.sv:addChild( self.real_content, 1 )
    self.txt_content:setVisible(false)

    local svWidth = self.sv:getInnerContainerSize().width
    local svHeight = self.real_content:getContentSize().height
    svHeight = math.max(svHeight, self.sv:getInnerContainerSize().height)
    self.sv:setInnerContainerSize(cc.size(svWidth, svHeight))
    self.real_content:setPositionY(svHeight)
end

function ArenaRuleView:onClickClose()
    self:removeSelf()
end

return ArenaRuleView
