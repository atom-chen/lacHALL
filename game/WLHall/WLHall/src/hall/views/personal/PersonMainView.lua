--
-- Author: Cai
-- Date: 2018-04-12
-- Describe：个人资料主界面

local M = class("PersonMainView", cc.load("ViewPop"))

M.RESOURCE_FILENAME = "ui/person_info/personal_main_view.lua"
M.RESOURCE_BINDING = {
    ["main_bg"]    = {["varname"] = "main_bg"},
    ["lv_tab"]     = {["varname"] = "lv_tab" },
    ["btn_kefu"]   = { ["varname"] = "btn_kefu"   , ["events"] = { { ["event"] = "click", ["method"] = "onClickKeFu"  } } }, -- 客服

    ["btn_close"]  = {["varname"] = "btn_close", ["events"] = {{["event"] = "click_color", ["method"] = "onClickClose"}}},

    ["txt_title"]  = {["varname"] = "txt_title"},  --视图名字

}
M.ADD_BLUR_BG = true

-- 因为整个界面的 tab 页是动态变化的，所以这里定义一些页面名称。
-- 通过构造函数可以传入这些字符串，以便定位到指定的页面
local PAGE_NAME_INFO = "info"               -- 我的资料页面
local PAGE_NAME_REAL_NAME = "real_name"     -- 实名认证页面
local PAGE_NAME_CHANGE_PWD = "change_pwd"   -- 修改密码页面
local PAGE_NAME_BIND = "bind"               -- 激活、解绑等页面

local ICON_CFG = {
    ["page_info"] = "hall/person_info/wodeziliao.png",
    ["page_change_pwd"] = "hall/person_info/xiugaimima.png",
    ["page_bind_phone"] = "hall/person_info/bangdingshouji.png",
    ["page_active"] = "hall/person_info/jihuozhanghao.png",
    ["page_unbind_phone"] = "hall/person_info/jiebangshouji.png",
    ["page_real_name"] = "hall/person_info/shimingrenzheng.png",
}

function M:onCreate(tabidx)
    self:setScale(math.min(display.scaleX, display.scaleY))
    self.lv_tab:setScrollBarEnabled(false)
    self._tabTb = {} -- 用于存储tab上的按钮
    --联系客服开关
    if not GameApp:CheckModuleEnable( ModuleTag.CustomerService ) then
        self.btn_kefu:setVisible(false)
    end

    self:showDataLoading()
    self:registerEventListener()
    gg.UserData:checkLoaded(function()
        if tolua.isnull(self) then return end
        self:hideDataLoading()
        -- 根据情况构造 tab 页
        self:refreshTabs()
        self:selectTab(tabidx or PAGE_NAME_INFO)
    end)
end

function M:refreshTabs()
    -- 清理所有的 page 节点
    self.curPages = checktable(self.curPages)
    for name, node in pairs(self.curPages) do
        if node then
            self.main_bg:removeChild(node)
        end
    end

    -- 更新整个界面的 tab 按钮和页面情况
    self.curPages = {}
    local tabsInfo = {}

    -- 创建个人资料界面
    if self.page_info == nil then
        self.page_info = self:getScene():createView("personal.InpageInfo")
        self.page_info:retain()
    end
    self.main_bg:addChild(self.page_info)
    self.curPages[PAGE_NAME_INFO] = self.page_info
    table.insert(tabsInfo, {["framename"] = "我的资料", ["pagenode"] = "page_info"})

    -- 如果是激活状态且 USER_FROM_PLATFORM，那么显示修改密码界面
    local from = BRAND == 0 and USER_FROM_JIXIANG or USER_FROM_PLATFORM
    if gg.UserData:isActivited() and
       hallmanager and hallmanager.userinfo and hallmanager.userinfo.userfrom == from then
        if self.page_change_pwd == nil then
            self.page_change_pwd = self:getScene():createView("personal.InpageModifyLoginPwd")
            self.page_change_pwd:retain()
        end
        self.main_bg:addChild(self.page_change_pwd)
        self.curPages[PAGE_NAME_CHANGE_PWD] = self.page_change_pwd
        table.insert(tabsInfo, {["framename"] = "修改密码", ["pagenode"] = "page_change_pwd"})
    end

    -- 根据不同状态，初始化不同的 tab 页面(激活、绑定)
    local bindPageNode = nil
    local bindTabFrame = nil
    local bindPageVarName = nil
    if GameApp:CheckModuleEnable(ModuleTag.P_ACTIVATE) then
        if not gg.UserData.isActivited() then
            -- 未激活，显示激活界面
            if not self.page_active then
                self.page_active = self:getScene():createView("personal.InpageActive", handler(self, self.userActived))
                self.page_active:retain()
            end
            bindPageNode = self.page_active
            bindTabFrame = "激活账号"
            bindPageVarName = "page_active"
        else
            if gg.UserData:isBindPhone() then
                -- 显示解绑手机页面
                if not self.page_unbind_phone then
                    self.page_unbind_phone = self:getScene():createView("personal.UnbindPhoneView", handler(self, self.phoneBindChanged))
                    self.page_unbind_phone:retain()
                end
                bindPageNode = self.page_unbind_phone
                bindTabFrame = "解绑手机"
                bindPageVarName = "page_unbind_phone"
            else
                -- 显示绑定手机页面
                if not self.page_bind_phone then
                    self.page_bind_phone = self:getScene():createView("personal.BindPhoneView", handler(self, self.phoneBindChanged))
                    self.page_bind_phone:retain()
                end
                bindPageNode = self.page_bind_phone
                bindTabFrame = "绑定手机"
                bindPageVarName = "page_bind_phone"
            end
        end
    end

    if bindPageNode then
        self.main_bg:addChild(bindPageNode)
        self.curPages[PAGE_NAME_BIND] = bindPageNode
        table.insert(tabsInfo, {["framename"] = bindTabFrame, ["pagenode"] = bindPageVarName})
    end

    local idCard, isBindIDCard = gg.UserData:GetIdCardSuffix()
    if not isBindIDCard and GameApp:CheckModuleEnable(ModuleTag.P_REALNAME) then
        -- 没有实名认证，需要添加实名认证界面
        if self.page_real_name == nil then
            self.page_real_name = self:getScene():createView("personal.AuthenticateView", handler(self, self.realNameAuthed))
            self.page_real_name:retain()
        end
        self.main_bg:addChild(self.page_real_name)
        self.curPages[PAGE_NAME_REAL_NAME] = self.page_real_name
        table.insert(tabsInfo, {["framename"] = "实名认证", ["pagenode"] = "page_real_name"})
    end

    self:initTabs(checktable(tabsInfo))
end

function M:initTabs(tabsInfo)
    if not tabsInfo then return end
    self.lv_tab:removeAllChildren()
    self._tabTb = {}

    for i,v in ipairs(tabsInfo) do
        local root = require("ui/person_info/item_personal_tab.lua").create().root
        local btn = root:getChildByName("tab_btn")
        btn:removeFromParent(true)
        btn:onClick(handler(self, self.onClickTabBtn))
        btn:getChildByName("txt_title"):setString(v.framename)
        local iconPath = ICON_CFG[v.pagenode]
        if iconPath then
            btn:getChildByName("img_icon"):ignoreContentAdaptWithSize(true)
            btn:getChildByName("img_icon"):loadTexture(iconPath, 1)
        end
        btn.name = v.framename
        btn.pagenode = v.pagenode

        self.lv_tab:pushBackCustomItem(btn)
        table.insert(self._tabTb, btn)
    end
end

function M:onClickTabBtn(sender)
    gg.AudioManager:playClickEffect()
    self:onTab(sender)
end

function M:onTab(sender)
    if self._preBtn and sender == self._preBtn then return end
    --设置标题
    self.txt_title:setString(sender.name)
    self._preBtn = sender
    for i,btn in ipairs(self._tabTb) do
        local fontColor = gg.IIF(btn == sender, cc.c3b(119,51,51), cc.c3b(255,255,255))
        btn:getChildByName("txt_title"):setTextColor(fontColor)
        btn:getChildByName("img_sel"):setVisible(btn == sender)
        local iconColor = gg.IIF(btn == sender, cc.c3b(119,51,51), cc.c3b(255,255,255))
        btn:getChildByName("img_icon"):setColor(iconColor)
    end

    for k,page in pairs(self.curPages) do
        page:setVisible(false)
    end

    self.serviceTag = ModuleTag.PersonInfo
    local curPage = self[sender.pagenode]
    if curPage then
        -- 不同的 tab 页，可能联系客服的 tag 是不同的，这里需要切换联系客服的 tag 值
        if curPage == self.page_real_name then
            self.serviceTag = ModuleTag.P_REALNAME
        end
        if curPage == self.page_active then
            self.serviceTag = ModuleTag.P_ACTIVATE
        end

        curPage:setVisible(true)
    end
end

function M:selectTab(idx)
    local defalutBtn
    idx = idx or PAGE_NAME_INFO
    if type(idx) == "string" then
        for i,btn in ipairs(self._tabTb) do
            if self[btn.pagenode] == self.curPages[idx] then
                self:onTab(btn)
                return
            end

            -- 获取默认页面的 btn
            if self[btn.pagenode] == self.curPages[PAGE_NAME_INFO] then
                defalutBtn = btn
            end
        end
    end

    if defalutBtn then
        -- 未找到指定的页面，显示默认页面
        self:onTab(defalutBtn)
    end
end

-- 实名认证了
function M:realNameAuthed()
    self:refreshTabs()
    self:selectTab(PAGE_NAME_INFO)
    -- 刷新我的资料中的身份证数据
    self.page_info:updateIDCardInfo()
end

-- 账号激活了
function M:userActived()
    self:refreshTabs()
    self:selectTab(PAGE_NAME_INFO)
    -- 刷新我的资料中的数据
    self.page_info:updatePhone()
end

-- 手机绑定状态变化了
function M:phoneBindChanged()
    self:refreshTabs()
    self:selectTab(PAGE_NAME_INFO)
    -- 刷新我的资料中的数据
    self.page_info:updatePhone()
end

function M:onClickClose()
    self:removeSelf()
end

--==============================--
-- 通知
--==============================--
function M:registerEventListener()
    -- 手机激活通知
    self:addEventListener(gg.Event.HALL_ACTIVATE_USER_PHONE, handler(self, self.onEventActivateUserPhone) )
end

-- 手机激活通知显示提示框
function M:onEventActivateUserPhone(event, phoneid, pwd)
	GameApp:dispatchEvent(gg.Event.SHOW_VIEW, "personal.ActivatePrompt", {push = false}, phoneid, pwd)
end

--==============================--
--
--==============================--
-- 清理所有的 page 节点
function M:onCleanup()
    self.page_active = self:safeReleaseNode(self.page_active)
    self.page_unbind_phone = self:safeReleaseNode(self.page_unbind_phone)
    self.page_bind_phone = self:safeReleaseNode(self.page_bind_phone)
    self.page_info = self:safeReleaseNode(self.page_info)
    self.page_change_pwd = self:safeReleaseNode(self.page_change_pwd)
    self.page_real_name = self:safeReleaseNode(self.page_real_name)
end

function M:safeReleaseNode(node)
    if node then node:release() end
    return nil
end

function M:showDataLoading()
    if not self.loadingNode then
        self.loadingNode = ccui.Text:create()
        self.loadingNode:setFontSize(34)
        self.loadingNode:setTextColor({r = 127, g = 127, b = 127})
        self.loadingNode:setString("数据加载中...")
        local parentSize = self.main_bg:getContentSize()
        self.loadingNode:setPosition(parentSize.width / 2, parentSize.height / 2)
        self.main_bg:addChild(self.loadingNode)
    end
    self.loadingNode:setVisible(true)
end

function M:hideDataLoading()
    if self.loadingNode then
        self.loadingNode:setVisible(false)
    end
end

--[[
* @brief 客服
]]
function M:onClickKeFu()
    -- 播放点击音效
    gg.AudioManager:playClickEffect()
    if self.serviceTag then
        device.callCustomerServiceApi(self.serviceTag)
    end
end

function M:removeSelf()
    M.super.removeSelf(self)

    -- 进行防沉迷检查
    if hallmanager then
        hallmanager:CheckTireTime()
    end
end

return M
