-- Author: zhangbin
-- Date: 2018-08-27
-- 广告页界面

local AdView = class("AdView", cc.load("ViewPop"))

AdView.RESOURCE_FILENAME="ui/adview/ad_view.lua"

AdView.RESOURCE_BINDING = {
    ["panel_bg"]    = {["varname"] = "panel_bg", ["events"]={{["event"] = "click_color",  ["method"]="onClickBg"}}},
    ["panel_touch"] = {["varname"] = "panel_touch", ["events"]={{["event"] = "click_color",  ["method"]="onClickPageView"}}},
    ["panel_pages"] = {["varname"] = "panel_pages"},
    ["txt_loading"] = {["varname"] = "txt_loading"},
    ["nd_loading"]  = {["varname"] = "nd_loading"},
}

local MAX_IMGS = 3

function AdView:onCreate(data)
    self._data = data

    -- 初始化界面
    self:initView()
end

function AdView:initView()
    -- 分辨率适配
    self.panel_bg:setContentSize(cc.size(display.width, display.height))
    self.panel_touch:setPosition(cc.p(display.width / 2, display.height / 2))
    self.panel_pages:setPosition(cc.p(display.width / 2, display.height / 2))
    self.nd_loading:setPosition(cc.p(display.width / 2, display.height / 2))
    if not self._data or #(self._data) == 0 then
        self.txt_loading:setString("数据加载失败")
        self.nd_loading:setVisible(true)
        return
    end

    -- 截取数据
    if #(self._data) > MAX_IMGS then
        local temp = {}
        for i, v in ipairs(self._data) do
            if #temp == MAX_IMGS then
                break
            end
            table.insert(temp, d)
        end
        self._data = temp
    end

    self.nd_loading:setVisible(true)
    for i, info in ipairs(self._data) do
        local pic = ccui.ImageView:create()
        pic:ignoreContentAdaptWithSize( false )
        pic:setContentSize( self.panel_pages:getContentSize() )
        self.panel_pages:addPage(pic)

        gg.ImageDownload:LoadHttpImageAsyn( info.url, pic, function()
            if tolua.isnull(self) then return end
            info.loaded = true
            self:updateLoadingState()
        end)
    end
    self.panel_pages:setCurrentPageIndex(0)
    gg.InvokeFuncNextFrame(function()
        if tolua.isnull(self) then
            self:updateLoadingState()
        end
    end)
end

-- 更新 loading 文本的显示状态
function AdView:updateLoadingState()
    local idx = self.panel_pages:getCurrentPageIndex()
    local info = self._data[idx + 1]
    if info then
        self.nd_loading:setVisible(not info.loaded)
    end
end

-- 图片被点击了
function AdView:onClickPageView()
    if not self._data or #(self._data) == 0 then
        -- 数据有问题，直接关闭界面
        self:removeSelf()
        return
    end

    -- 执行相应的操作
    local curIdx = self.panel_pages:getCurrentPageIndex()
    local info = self._data[curIdx + 1]
    if info then
        GameApp:DoShell(nil, info.op)
    end

    -- 关闭界面
    self:removeSelf()
end

function AdView:onClickBg()
    local curIdx = self.panel_pages:getCurrentPageIndex()
    if curIdx == #(self._data) - 1 then
        -- 最后一张图了，关闭界面
        self:removeSelf()
        return
    end

    -- 显示下一张图
    self.panel_pages:scrollToPage( curIdx + 1 )
    self:updateLoadingState()
end

-- 拦截 back 键，不响应
function AdView:keyBackClicked()
    return false, false
end

return AdView
