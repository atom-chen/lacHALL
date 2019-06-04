--活动 规则页面
local ActiveRuleView = class("ActiveRuleView" , cc.load("ViewPop"))

ActiveRuleView.RESOURCE_FILENAME = "ui/active/activity_rule_view.lua"

ActiveRuleView.RESOURCE_BINDING = {
    ["sv_content"] = { ["varname"] = "sv_content" },

    ["txt_title"] = { ["varname"] = "txt_title" },
    ["btn_close"]   = {["varname"] = "btn_close",   ["events"] = {{event = "click", method = "onClickClose" }}},
}
--[[
* @brief 创建
]]
function ActiveRuleView:onCreate(ruleDate)
    --自适应
    self:setScale(math.min(display.scaleX, display.scaleY))
    self:init()
    self:initView()
    self:setContents( ruleDate.body or "暂无规则")
    self.txt_title:setString( ruleDate.title or "暂无规则")
end

function ActiveRuleView:init()
 -- 隐藏listView滚动条
 self.sv_content:setScrollBarEnabled(false)
end

-- 设置界面数据
function ActiveRuleView:setContents( data )
    self.txt_content:setString( data )
    -- 获取内容文本高度
    local hTxt = self.txt_content:getContentSize().height
    -- 当文本高度超过显示区域重新设置滑动高度和文本位置
    if hTxt > self.sv_content:getContentSize().height then
        self.sv_content:setInnerContainerSize( { width = self.sv_content:getContentSize().width, height = hTxt } )
        self.txt_content:setPosition( cc.p( 0, hTxt ) )
    end
end

function ActiveRuleView:initView( )
    -- 规则内容
    self.txt_content = cc.Label:create()
    self.txt_content:setSystemFontSize(26)
    self.txt_content:setTextColor( { r = 140 , g = 30, b = 0} )
    self.txt_content:setAnchorPoint( cc.p( 0, 1 ) )
    self.txt_content:setWidth( self.sv_content:getContentSize().width )
    self.txt_content:setPosition( cc.p( 0 , self.sv_content:getContentSize().height ) )
    self.sv_content:addChild( self.txt_content, 1 )
end

function ActiveRuleView:onClickClose()
    self:removeSelf()
end

return ActiveRuleView
