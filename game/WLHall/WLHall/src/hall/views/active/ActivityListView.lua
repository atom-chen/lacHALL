
----------------------------------------------------------------------
-- 作者：chenjingmin
-- 日期：2017-03-5
-- 描述：创建限时活动ListView主界面
----------------------------------------------------------------------

local ActivityListView = class("ActivityListView", cc.load("ViewBase"))
ActivityListView.RESOURCE_FILENAME = "ui/active/activity_list_view.lua"

ActivityListView.RESOURCE_BINDING = {
    ["nd_subview"]  = { ["varname"] = "nd_subview" },    -- 子界面节点
    ["lv_tab"]      = { ["varname"] = "lv_tab"     },
    ["img_hint_bg"] = { ["varname"] = "img_hint_bg"},
    ["txt_hint"] = { ["varname"] = "txt_hint"},
    ["txt_loading"] = { ["varname"] = "txt_loading"},
    ["subview_bg"] = { ["varname"] = "subview_bg"},
}

local ACTIVE_TABLE = {}

--二级的按钮颜色
local TWO_ACTIVE_NOT_SELECT_COLOR = cc.c3b(255,255,255)
local TWO_ACTIVE_TAB_SELECT_COLOR = cc.c3b(119,51,51)

function ActivityListView:onCreate(callback,tag)
    self._tag = tag
    self._setFunc = callback
    self:initView()
end

function ActivityListView:initView()
    -- 隐藏滚动条
    self.lv_tab:setScrollBarEnabled(false)

    -- 用于存储活动的按钮与页面信息
    self._tabTable = {}

    -- 隐藏暂无活动相关的提示
    self.img_hint_bg:setVisible(false)
    self.txt_hint:setVisible(false)

    -- 显示数据加载的提示
    self.txt_loading:setVisible(true)
    gg.UserData:checkLoaded(function()
        if tolua.isnull(self) then return end
        self.txt_loading:setVisible(false)

        -- 初始化界面
        self:initTabs()
    end)
end

-- 创建左侧按钮
function ActivityListView:initTabs()
    -- 获取活动的数据
    local actCount = gg.ActivityPageCtrl:getActivityVisibleCount()
    if actCount == 0 then
        -- 显示暂无活动相关的提示
        self.img_hint_bg:setVisible(true)
        self.txt_hint:setVisible(true)
        return
    end

    -- 隐藏白色背景
    self.subview_bg:setVisible(false)

    -- 初始化界面
    local actInfo = gg.ActivityPageData:getActivityInfo()
    table.sort(actInfo, function(a,b) return checkint(a.sort) < checkint(b.sort) end)
    local defaultTag
    for i, v in ipairs(actInfo) do
        -- 检查是否需要显示该活动
        local canShow = gg.ActivityPageCtrl:canShowActivity(v.active_tag)
        if canShow then
            -- 记录活动相关的数据
            local btn = self:createListBtn(v)
            self._tabTable[v.active_tag] = { ["btn"] = btn }

            -- 获取需要选中的标签
            if self._tag and v.active_tag == self._tag then
                defaultTag = self._tag
            elseif not defaultTag then
                defaultTag = v.active_tag
            end
        end
    end

    self:onTagSelected( defaultTag ) -- 默认点击第一个按钮
end

-- 创建列表中的按钮
function ActivityListView:createListBtn(info)
    -- 创建节点
    local node = require("ui/active/activity_list_button.lua").create()

    -- 将节点添加到列表中
    local item = node.root:getChildByName("panel_frame")
    item:removeFromParent()
    self.lv_tab:pushBackCustomItem(item)

    -- 获取活动显示相关的数据
    local actViewCfg = gg.ActivityPageData:getActivePageDataByTag(info.active_tag)
    local item_image_ico= item:getChildByName("Image_ico")
    item_image_ico:ignoreContentAdaptWithSize(true)
    item_image_ico:loadTexture(checktable(actViewCfg).imagePath, 0)

    -- 设置标题
    local item_text_titile = item:getChildByName("text_title")
    item_text_titile:setString(checktable(actViewCfg).desc)

    -- 获取活动的已读状态
    local readStatus = gg.ActivityPageData:isActivityRead(info.active_tag)
    local item_read_point = item:getChildByName("read_point")
    item_read_point:setVisible(not readStatus)

    -- 记录相应的活动标签
    item.id = info.active_tag
    item:onClick(handler(self, self.OnClickTabBtn))

    -- 线处理
    gg.LineHandle(item:getChildByName("Image_line")) 
    
    return item
end

-- 左侧按钮点击事件
function ActivityListView:onTagSelected( actTag )
    -- 处理按钮与页面的状态
    for k, v in pairs(self._tabTable) do
        local btnTitle = v.btn:getChildByName("text_title")
        local btnBg = v.btn:getChildByName("image_bg")
        btnTitle:setColor(gg.IIF(actTag == k, TWO_ACTIVE_TAB_SELECT_COLOR, TWO_ACTIVE_NOT_SELECT_COLOR))
        btnBg:setVisible(actTag == k)

        -- 处理页面的显示状态
        if v.page then
            v.page:setVisible(actTag == k)
        end

        if actTag == k then
            -- 未读状态隐藏
            v.btn:getChildByName("read_point"):setVisible(false)

            -- 如果没有页面，创建之
            if not v.page then
                v.page = gg.ActivityPageCtrl:createPageView(actTag)
                self.nd_subview:addChild(v.page)
            end

            -- 通知界面需要显示了
            if v.page.onPageShown then
                v.page:onPageShown()
            end
        end
    end

    -- 设置活动已读状态
    gg.ActivityPageData:setActivityRead(actTag)

    -- 刷新活动标签页的未读状态
    if self._setFunc then
        local actViewCfg = gg.ActivityPageData:getActivePageDataByTag(actTag)
        self._setFunc(actViewCfg.btnCloseColor)
    end
end

function ActivityListView:OnClickTabBtn(sender)
    gg.AudioManager:playClickEffect()
    self:onTagSelected( sender.id )
end

return ActivityListView
