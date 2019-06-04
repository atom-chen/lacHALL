--
-- Author: zhangbin
-- Date: 2017-05-25
-- Describe：规则界面中详细信息的展示
local ItemRuleDetail = class("ItemRuleDetail", cc.load("ViewLayout"))

ItemRuleDetail.RESOURCE_FILENAME = "ui/common/rule_detail_item.lua"
ItemRuleDetail.RESOURCE_BINDING = {
	["title_container"] = {["varname"] = "title_container"},
	["detail_container"] = {["varname"] = "detail_container"},
    ["detail_layout"]    = {["varname"] = "detail_layout"},
    --["img_sep"]    = {["varname"] = "img_sep"},
    ["label_title"]    = {["varname"] = "label_title"},
    -- ["label_detail"]    = {["varname"] = "label_detail"},
    ["detail_line"]    = {["varname"] = "detail_line"},
    ["btn_extend"] = {["varname"] = "btn_extend",["events"]={{["event"] = "click",["method"]="onExtendClick"}}},
	["btn_extend_layout"] = {["varname"] = "btn_extend_layout",["events"]={{["event"] = "click",["method"]="onExtendClick"}}},  --另加的透明按钮
}

function ItemRuleDetail:onCreate( info, width, extendCallback )
    self:setContentSize(width, 76)
    self.callback = extendCallback

    -- 创建一个描述信息的 label
    self:createDetailLabel(width - 60)

    --self.img_bg:setContentSize(self.img_bg:getContentSize())
    -- 适配相应的宽度
    --self:changeNodeWidth(self.detail_layout, width)
    self:changeNodeWidth(self.title_container, width)
    self:changeNodeWidth(self.detail_container, width)
    --self:changeNodeWidth(self.img_sep, width - 2)
    self:changeNodeWidth(self.detail_line, width)
    local x, y = self.btn_extend:getPosition()
    self.btn_extend:setPosition(cc.p(width - 45, y))

    --self.detail_line:setPosition(cc.p(0, -30))

    local info = checktable(info)
    self.label_title:setString(info.title or "")
    self:setDetailStr(info.detail or "")
    self:setExtend(false)
end

function ItemRuleDetail:createDetailLabel(width)
    self.label_detail = cc.Label:create()
    self.label_detail:setSystemFontSize( 26 )
    self.label_detail:setTextColor( { r = 102 , g = 102, b = 102} )
    self.label_detail:setAnchorPoint(cc.p(0,1))
    self.label_detail:setWidth( width )
    self.detail_container:addChild(self.label_detail)
end

function ItemRuleDetail:setExtend(value)
    if self.extended == value then
        return
    end

    self.extended = value

    -- 播放按钮旋转的动画
    self.btn_extend:stopAllActions()
    local targetDegree = 0
    if self.extended then
        targetDegree = 180
    end
    self.btn_extend:runAction(cc.RotateTo:create( 0.2, targetDegree))

    self:updateLayout(true)
end

function ItemRuleDetail:updateLayout(forceCallback)
    local detailStr = self.label_detail:getString()
    local titleH  = self.title_container:getContentSize().height
    local oldH = self.detail_layout:getContentSize().height
    local newH = titleH
    if self.extended and detailStr ~= "" then
        -- 展开状态且有字符串的情况下显示 detail container
        self.detail_container:setVisible(true)
        -- 调整背景图片高度
        local detailH = self.detail_container:getContentSize().height
        newH = detailH + titleH
    else
        self.detail_container:setVisible(false)
    end
    --self:changeNodeHeight(self.detail_layout, newH)
    self:changeNodeHeight(self, newH)
    --self.detail_layout:setPosition(cc.p(0, newH))
    self.title_container:setPosition(cc.p(0, newH))

    if self.callback and (forceCallback or oldH ~= newH) then
        -- 当高度变化时调用回调
        self.callback(self)
    end
end

function ItemRuleDetail:isExtended()
    return self.extended
end

function ItemRuleDetail:setDetailStr(str)
    self.label_detail:setString(str)
    local labelH = self.label_detail:getContentSize().height
    -- 调整 detail container 高度
    self:changeNodeHeight(self.detail_container, labelH + 60)

    -- 调整分割线的位置
    --self.detail_line:setPosition(cc.p(1, labelH + 58))

    -- 调整 label detail 的大小和位置
    self.label_detail:setPosition(cc.p(30, labelH + 30))

    if self.extended then
        self:updateLayout(false)
    end
end

function ItemRuleDetail:changeNodeWidth(node, w)
    node:setContentSize(w, node:getContentSize().height)
end

function ItemRuleDetail:changeNodeHeight(node, h)
    node:setContentSize(node:getContentSize().width, h)
end

function ItemRuleDetail:onExtendClick()
	-- 播放点击音效
    gg.AudioManager:playClickEffect()

    if self.extended then
        self:setExtend(false)
    else
        self:setExtend(true)
    end
end

return ItemRuleDetail
