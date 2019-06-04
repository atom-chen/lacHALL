local LottoAwardView = class("LottoAwardView", cc.load("ViewPop"))

LottoAwardView.RESOURCE_FILENAME = "ui/luckybag/lottery_award_view.lua"
LottoAwardView.RESOURCE_BINDING = {
    ["img_light"] = { ["varname"] = "img_light" },
    ["img_prop"]  = { ["varname"] = "img_prop"  },
    ["txt_cnt"]   = { ["varname"] = "txt_cnt"   },
    ["btn_more"]  = { ["varname"] = "btn_more",  ["events"] = { { event = "click", method = "onClickClose" } } }, -- 关闭按钮
    ["btn_share"] = { ["varname"] = "btn_share", ["events"] = { { event = "click", method = "onClickShare" } } }, -- 分享好友按钮
}

function LottoAwardView:onCreate(pData, shareCallback)
    self.shareCallback = shareCallback
    self.img_light:runAction(cc.RepeatForever:create(cc.RotateBy:create(10, 360)))

    if not pData then return end
    local propDef = require("def.PropDef")[checkint(pData[1])]
    -- 奖励物品数量
    local count = checkint(pData[2]) * (propDef.proportion or 1)
    local propName = propDef.name or ""
    if checkint(pData[1]) == PROP_ID_PHONE_CARD or checkint(pData[1]) == PROP_ID_261 then
        count = string.format("%.2f",count)
    end
    if checkint(pData[1]) == PROP_ID_MONEY then propName = "豆" end
    self.txt_cnt:setString(string.format("%sx%s", propName, tostring(count)))
    -- 奖励的物品
    self.img_prop:ignoreContentAdaptWithSize(true)
    self.img_prop:loadTexture(propDef.icon)

    -- 没有分享数据时不显示分享按钮，再来一次按钮居中
    if not self.shareCallback then
        self.btn_share:setVisible(false)
        self.btn_more:setPositionX(0)
    end
end

function LottoAwardView:onClickClose()
    self:removeSelf()
end

function LottoAwardView:onClickShare()
    if self.shareCallback then self.shareCallback(1) end
    self:removeSelf()
end

return LottoAwardView
