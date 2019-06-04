
-- Author: Cai
-- Date: 2018-04-18
-- Describe：区县选择界面

local M = class("CountyMapView", cc.load("ViewBase"))
M.RESOURCE_FILENAME = "ui/map/map_county_view.lua"
M.RESOURCE_BINDING = {
    ["panel_bg"]  = {["varname"] = "panel_bg" },
    ["view_bg"]   = {["varname"] = "view_bg"  },
    ["txt_title"] = {["varname"] = "txt_title"},
    ["pv_county"] = {["varname"] = "pv_county"},
    ["btn_join"]  = {["varname"] = "btn_join",  ["events"] = {{["event"] = "click", ["method"] = "onClickJoin"}}},
    ["btn_close"] = {["varname"] = "btn_close", ["events"] = {{["event"] = "click_color", ["method"] = "onClickClose"}}},
}

cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/map.plist")

function M:onCreate(countyTb, hideBtn)
    self.panel_bg:setContentSize(cc.size(display.width, display.height))
    self.panel_bg:setPosition(cc.p(display.cx, display.cy))
    self.view_bg:setPosition(cc.p(display.cx, display.cy))
    self.btn_join:setTouchEnabled(false)
    self.btn_join:setAllGray(true)
    -- 直辖市直接弹出该界面，故将关闭按钮隐藏
    self.btn_close:setVisible(not hideBtn)
    self.panel_bg:setTouchEnabled(not hideBtn)

    self._currentSelectArea = nil
    self._areaConfig = GameApp:getAreaConfig()
    self:updateCountyPv(countyTb)
end

function M:setCallback(callback)
    self._callback = callback
end

function M:updateCountyPv(countyTb)
    if not countyTb then return end
    self.pv_county:removeAllChildren()
    local pvSize = self.pv_county:getContentSize()
    local pageTb = gg.ArrangePage(countyTb, 12, false)
    -- 分页联动处理
    local checkBoxPanels = {}
    for i=1, gg.TableSize(pageTb) do
        local layout = ccui.Layout:create()
        layout:setContentSize(pvSize)
        self.pv_county:addPage(layout)

        local cbPanel = require("common.widgets.RadioButtonGroup"):create()
        cbPanel:setPosition(cc.p(40, 230))
        cbPanel:setElementCountH(4)
        cbPanel:setSpacingH(pvSize.width / 4)
        cbPanel:setSpacingV(90)
        cbPanel:cancelDefaultSelect()
        layout:addChild(cbPanel)

        -- 设置选项内容
        local areaName = {}
        local areaID = {}
        for n=1, #pageTb[i] do
            local name = pageTb[i][n][2]
            -- 超过6个汉字显示5个汉字+...
            if #name > 18 then
                name = string.sub(name, 1, 15) .. "..."
            end
            table.insert(areaName, name)
            table.insert(areaID, pageTb[i][n][1])
        end
        cbPanel:setText(areaName)
        cbPanel:setFontInfo(30, cc.c3b(100, 53, 13))
        cbPanel:setImg("hall/map/btn_quan.png", "hall/map/btn_xzhong.png")

        table.insert(checkBoxPanels, cbPanel)
        -- 注册地区选择事件
        cbPanel:setSelectCallBack(function(index)
            -- 解决翻页不能联动选择问题
            for k, v in pairs(checkBoxPanels) do
                if v ~= cbPanel then
                    v:cancelDefaultSelect()
                end
            end
            -- 地区ID
            self._currentSelectArea = areaID[index]
            self.btn_join:setTouchEnabled(true)
            self.btn_join:setAllGray(false)
        end )
    end

    -- 添加分页切页标识
    if self._pageBreak then
        self._pageBreak:removeFromParent()
        self._pageBreak = nil
    end

    if #pageTb > 1 then
        self._pageBreak = require("common.widgets.PageLabel"):create("hall/common/btn_dian02.png", "hall/common/btn_dian01.png", 30, #pageTb, 0)
        self._pageBreak:setPosition(cc.p(self.view_bg:getContentSize().width / 2, 120))
        self.view_bg:addChild(self._pageBreak)
        -- 添加滚动层监听事件
        local function pageViewEvent(sender, eventType)
            if eventType == ccui.PageViewEventType.turning and self._pageBreak then
                self._pageBreak:setIndex(sender:getCurrentPageIndex())
            end
        end
        self.pv_county:addEventListener(pageViewEvent)
    end

    -- 默认选中第一页
    self.pv_county:setCurrentPageIndex(0)
end

function M:onClickJoin(sender)
    if self._callback then
        self._callback(self._currentSelectArea)
    end
end

function M:onClickClose()
    self:removeSelf()
end

function M:removeSelf()
    if self._callback then
        self._callback()
    end
    M.super.removeSelf(self)
end

function M:getViewZOrder()
    return 9220
end

return M