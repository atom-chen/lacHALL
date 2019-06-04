local PopRuleBonusPool = class("PopRuleBonusPool", cc.load("ViewPop"))

PopRuleBonusPool.RESOURCE_FILENAME = "ui/active/bonus_pool/pop_rule.lua"

PopRuleBonusPool.RESOURCE_BINDING =
{

    ["bg"] = {["varname"] = "bg"},
    ["btn_close"] = { ["varname"] = "btn_close", ["events"] = { { ["event"] = "click", ["method"] = "onClickClose" } } },
    ["text_title"] = {["varname"] = "text_title"},
    ["text_info"] = {["varname"] = "text_info"}

}

function PopRuleBonusPool:onCreate( parentTag )
    local txt_chdjc  = {
    "1.玩家在本活动内购买礼包，每充值1元，系统将向奖池内注入1000微乐豆",
    "2.每日活动排名前100名玩家，将根据充值的总金额按比例分配奖金池",
    "3.充值金额相同的玩家，充值先到达者排名靠前",
    "4.活动期间排行榜每10分钟刷新一次，每天零点重置奖金池,玩家排名将清零重新计算",
    "5.每天的奖励会在次日凌晨2点之前通过邮件的形式自动发放到玩家账号，请注意查收",
    }
    local txt_cjdjc = {
    "1.活动期间，在商城每充值1元(购买钻石除外)，系统将向奖池内注入1000微乐豆",
    "2.每日活动排名前100名玩家，将根据充值的总金额按比例分配奖金池",
    "3.充值金额相同的玩家，充值先到达者排名靠前",
    "4.活动期间排行榜每10分钟刷新一次,每天零点重置奖金池,玩家排名将清零重新计算",
    "5.每天的奖励会在次日凌晨2点之前通过邮件的形式自动发放到玩家账号，请注意查收",
}
    self:setScale(math.min(display.scaleX, display.scaleY))
    self.text_info:setVisible(false)

    local txt = nil
    self.text_info:getVirtualRenderer():setLineSpacing(17)
    if parentTag == gg.ActivityPageData.ACTIVE_TAG_CHDJC then
        txt = txt_chdjc
    elseif parentTag == gg.ActivityPageData.ACTIVE_TAG_CJDJC then
        txt = txt_cjdjc
    end

    for i = 1, 5 do
        local lbl1 = cc.Label:createWithSystemFont(txt[i], "Arial", 26)
        lbl1:setAnchorPoint(0,1)

        lbl1:setTextColor(cc.c3b(143, 30, 0))
        lbl1:setPosition(cc.p( self.text_title:getPositionX()+100,  self.text_title:getPositionY() +220 -( i * 55 )))
        self.bg:addChild(lbl1)
    end

end

function PopRuleBonusPool:onClickClose( ... )
    self:removeSelf()
end

return PopRuleBonusPool
