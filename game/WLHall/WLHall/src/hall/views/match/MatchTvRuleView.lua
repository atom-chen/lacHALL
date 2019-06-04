
-- Author: LiAchen
-- Date: 2018-09-19
-- Describe：电视赛规则页面

local MatchTvRuleView = class("MatchTvRuleView", cc.load("ViewPop"))

MatchTvRuleView.RESOURCE_FILENAME = "ui/room/match/match_tv_rule.lua"
MatchTvRuleView.RESOURCE_BINDING = {
    ["sv_content"] = {["varname"] = "sv_content"},
    ["txt_title"]  = {["varname"] = "txt_title" },
    ["btn_close"]  = {["varname"] = "btn_close", ["events"] = {{event = "click", method = "onClickClose"}}},
}

function MatchTvRuleView:onCreate(tvId)
    self:setScale(math.min(display.scaleX, display.scaleY))
    self:initView()
    self:pulldata(tvId)
end

function MatchTvRuleView:pulldata(tvId)
    self:setContents("暂无规则")
    self.txt_title:setString("海选规则")

    gg.Dapi:getTvAuditionRule(tvId, function(result)
        if tolua.isnull(self) then return end
        result = checktable(result)
        if result.status and checkint(result.status) == 0 then
            local data = checktable(result[0])
            if data then 
                self:setContents(data.content or "暂无规则")
                self.txt_title:setString(data.title or "海选规则")
            end            
        end
    end)
end

-- 设置界面数据
function MatchTvRuleView:setContents(data)
    self.txt_content:setString(data)
    -- 获取内容文本高度
    local hTxt = self.txt_content:getContentSize().height
    -- 当文本高度超过显示区域重新设置滑动高度和文本位置
    if hTxt > self.sv_content:getContentSize().height then
        self.sv_content:setInnerContainerSize({width = self.sv_content:getContentSize().width, height = hTxt})
        self.txt_content:setPosition(cc.p(0, hTxt))
    end
end

function MatchTvRuleView:initView()
    -- 隐藏listView滚动条
    self.sv_content:setScrollBarEnabled(false)
    -- 规则内容
    self.txt_content = cc.Label:create()
    self.txt_content:setSystemFontSize(26)
    self.txt_content:setTextColor({r = 119, g = 119, b = 119})
    self.txt_content:setAnchorPoint(cc.p(0, 1))
    self.txt_content:setWidth(self.sv_content:getContentSize().width)
    self.txt_content:setPosition(cc.p(0, self.sv_content:getContentSize().height))
    self.sv_content:addChild(self.txt_content, 1)
end

function MatchTvRuleView:onClickClose()
    self:removeSelf()
end

return MatchTvRuleView