-- Author: Cai
-- Date: 2018-09-19
-- Describe：电视比赛item

local MatchTvItemView = class("MatchTvItemView", cc.load("ViewLayout"))

MatchTvItemView.RESOURCE_FILENAME = "ui/room/match/match_television_view.lua"
MatchTvItemView.RESOURCE_BINDING = {
    ["item_bg"]  = {["varname"] = "item_bg" },
    ["img_icon"] = {["varname"] = "img_icon"},
    ["img_hot"]  = {["varname"] = "img_hot" },
    ["txt_tv"]   = {["varname"] = "txt_tv"  },
}

function MatchTvItemView:onCreate(roomTb)
    local scale = (display.width - 210 - 2 * gg.getPhoneLeft()) / 1070
    self:setContentSize(cc.size(255* scale, 255* scale))
    self.item_bg:retain()
    self.item_bg:removeFromParent(true)
    self:addChild(self.item_bg)
    self.item_bg:release()
    self.item_bg:onClick(handler(self, self.onClickJoin))
    
    self._roomTb = roomTb
    self:initView(roomTb)
end

function MatchTvItemView:initView(roomTb)
    local info = roomTb[1]
    if not info then return end
    -- 电视台名称
    self.txt_tv:setString(info.name)
    -- 电视台icon
    self.img_icon:ignoreContentAdaptWithSize(true)
    if checktable(info.cmd).nicon and checktable(info.cmd).nicon ~= "" then
        local url = APP_ICON_PATH .. checktable(info.cmd).nicon .. ".png"
        gg.ImageDownload:LoadHttpImageAsyn(url , self.img_icon)
    end
    -- hot标志显示
    local tvid = checkint(checktable(info.cmd).tv)
    local curRegion = gg.LocalConfig:GetRegionCode()
    if REGION_CODE == 0 and curRegion ~= 0 then
        local code = checkint(string.sub(curRegion, 1, 2))
        self.img_hot:setVisible(code == tvid)
    elseif REGION_CODE ~= 0 then
        self.img_hot:setVisible(REGION_CODE == tvid)
    else
        self.img_hot:setVisible(false)
    end
end

function MatchTvItemView:onClickJoin()
   gg.AudioManager:playClickEffect()
   self:getScene():createView("match.MatchTvSelectView", self._roomTb):pushInScene()
end

return MatchTvItemView