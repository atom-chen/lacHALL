-- 作者：chenjingmin
-- 日期：2017-03-5
-- 描述：创建活动主界面

local ActivityView = class("ActivityView", cc.load("ViewPop"))

ActivityView.RESOURCE_FILENAME = "ui/active/activity_view.lua"

ActivityView.RESOURCE_BINDING = {
    ["panel_bg"]    = { ["varname"] = "panel_bg" },
    ["nd_subview"]  = { ["varname"] = "nd_subview" },    -- 子界面节点
    ["active_tab"]  = { ["varname"] = "active_tab"     },
    ["Time_limited"]  = { ["varname"] = "Time_limited", ["events"] = { { ["event"] = "click", ["method"] = "OnClickTabBtn" } } },
    ["privilege"]  = { ["varname"] = "privilege" , ["events"] = { { ["event"] = "click", ["method"] = "OnClickTabBtn" } } },
    ["service"]  = { ["varname"] = "service" , ["events"] = { { ["event"] = "click", ["method"] = "OnClickTabBtn" } } },
    ["privilege_point"]  = { ["varname"] = "privilege_point"     },
    ["Time_limited_point"]  = { ["varname"] = "Time_limited_point"     },

    ["close"]   = { ["varname"] = "close", ["events"] = { { ["event"] = "click_color", ["method"] = "onClickClose" } } }, -- 关闭按钮
}

ActivityView.ADD_BLUR_BG = true

--一级的按钮颜色
local ACTIVE_NOT_SELECT_COLOR = cc.c3b(98, 158, 226)
local ACTIVE_SELECT_COLOR = cc.c3b(246,230,155)
--[[
* @brief 创建界面
@param first_but_tag 一级目录(1:限时活动 2:贵族星耀特权)
@param second_but_tag 二级目录标签
]]
function ActivityView:onCreate(pageData)
    self.pageData = pageData
    self:resetLayout()
    self:initView()
end

function ActivityView:resetLayout( )
    --自适应
    self:setScale(math.min(display.scaleX, display.scaleY))
    self.privilege_point:setVisible(false)
end

function ActivityView:initView()
    local ButtonList = {self.Time_limited,self.privilege,self.service}

    --活动开关
    if not GameApp:CheckModuleEnable( ModuleTag.Activity ) then
        self.Time_limited:setVisible(false)
    end

    -- 贵族月卡和星耀月卡都关闭时不显示月卡按钮
    if not GameApp:CheckModuleEnable(ModuleTag.Privilege) and not GameApp:CheckModuleEnable(ModuleTag.XYMonthCard) then
        self.privilege:setVisible(false)
    end

    --联系客服开关
    if not GameApp:CheckModuleEnable( ModuleTag.CustomerService ) then
        self.service:setVisible(false)
    end

    --设置按钮位置
    local posY = 567
    for i,btn in ipairs(ButtonList) do
        if btn:isVisible() then
            btn:setPositionY(posY)
            posY = posY - 110
        end
    end

    -- 选择指定的页面
    local selTab = self.Time_limited
    if self.privilege:isVisible() and self.pageData and self.pageData.first_but_tag == 2 then
        selTab = self.privilege
    end
    self:onTabBtn(selTab)
end

-- 左侧按钮点击事件
function ActivityView:onTabBtn( sender)
    if sender ~= self.service then
        -- 设置按钮点击状态
        self.Time_limited:setColor(ACTIVE_NOT_SELECT_COLOR)
        self.privilege:setColor(ACTIVE_NOT_SELECT_COLOR)
        self.service:setColor(ACTIVE_NOT_SELECT_COLOR)

        sender:setColor(ACTIVE_SELECT_COLOR)
    else
        -- 客服按钮
        device.callCustomerServiceApi(ModuleTag.Activity)
        return
    end

    -- 如果点击的是活动
    if sender == self.Time_limited then
        -- 先恢复关闭按钮的颜色
        if self._preBtnColor then
            self:UpdateStatus(self._preBtnColor)
        end

        if not self.pageActivity then
            local defTag
            if self.pageData and self.pageData.second_but_tag then
                defTag = self.pageData.second_but_tag
            end
            self.pageActivity = self:getScene():createView("active.ActivityListView", handler(self, self.UpdateStatus), defTag)
            self.nd_subview:addChild( self.pageActivity )
        end
        self.pageActivity:setVisible(true)

        -- 隐藏月卡界面
        if self.pagePrivilege then
            self.pagePrivilege:setVisible(false)
        end
    elseif sender == self.privilege then
        if not self.pagePrivilege then
            self.pagePrivilege = self:getScene():createView("active.Privilege")
            self.nd_subview:addChild( self.pagePrivilege )
        end
        self.pagePrivilege:setVisible(true)
        -- 记录切换到月卡界面时，关闭按钮的颜色
        self._preBtnColor = self.close:getChildByName("Image_7"):getColor()
        self:UpdateStatus(cc.c3b(51,51,51))
        -- 隐藏活动界面
        if self.pageActivity then
            self.pageActivity:setVisible(false)
        end
    end

    -- 更新活动已读状态
    self:UpdateReadStatus()
end

function ActivityView:OnClickTabBtn(sender)
    gg.AudioManager:playClickEffect()
    self:onTabBtn( sender)
end

-- 关闭事件
function ActivityView:onClickClose()
    self:removeSelf()
end

function ActivityView:UpdateReadStatus()
    -- 获取未读活动数
    gg.UserData:checkLoaded(function()
        if tolua.isnull(self) then return end
        if not GameApp:CheckModuleEnable(ModuleTag.Activity) then
            self.Time_limited_point:setVisible(false)
        else
            local unreadCount = gg.ActivityPageCtrl:getActivityUnreadCount()
            self.Time_limited_point:setVisible(unreadCount > 0)
        end
    end)
end

function ActivityView:UpdateStatus(color)
    self:UpdateReadStatus()
    if color then
        self.close:getChildByName("Image_7"):setColor(color)
    end
end

return ActivityView
