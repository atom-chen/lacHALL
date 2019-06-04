-- Author: zhaoxinyu
-- Date: 2016-08-25 16:57:39
-- Describe：登录框层

local LoginViewAccount = class("LoginViewAccount", cc.load("ViewPop"))

LoginViewAccount.RESOURCE_FILENAME = "ui/login/login_node.lua"
LoginViewAccount.RESOURCE_BINDING = {
    ["btn_login"] = { ["varname"] = "btn_login", ["events"] = { { event = "click", method = "onLogin" } } }, -- 登录按钮
    ["txt_login"] = { ["varname"] = "txt_login" },

    ["btn_account_pull_down"] = { ["varname"] = "btn_account_pull_down", ["events"] = { { event = "click", method = "onAccountPullDown" } } }, -- 下拉按钮
    ["lv_account"] = { ["varname"] = "lv_account" }, -- 账号列表
    ["panel_lv_bg"] = { ["varname"] = "panel_lv_bg", ["events"] = { { event = "click", method = "onLvBg" } } }, -- list列表背景

    ["btn_register"] = { ["varname"] = "btn_register", ["events"] = { { event = "click", method = "onRegisterClicked" } } }, -- 找回密码
    ["btn_zhmm"] = { ["varname"] = "btn_zhmm", ["events"] = { { event = "click", method = "onRetrievePassword" } } }, -- 找回密码

    ["img_input_account_box"] = { ["varname"] = "img_input_account_box" }, -- 账号输入框背景
    ["img_input_password_box_0"] = { ["varname"] = "img_input_password_box_0" }, -- 密码输入框背景

    ["img_tm_bg"] = { ["varname"] = "img_tm_bg" }, -- 登录框透明背景

    ["btn_close"] = { ["varname"] = "btn_close", ["events"] = { { event = "click", method = "onClickClose" } } }, -- 关闭按钮
}

function LoginViewAccount:onCreate(loginmgr, ...)
   -- cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
    -- 初始化
    self:init()

    -- 初始化View
    self:initView()

    -- 重试登录应答通知
    self:addEventListener(gg.Event.RETRY_LOGIN, handler( self, self.onEventRetryLogin )  )


end

--[[
* @brief 初始化
]]
function LoginViewAccount:init()

    self._currentAccountIndex = gg.Cookies:GetDefRoleIndex() -- 当前账号索引
end


--[[
* @brief 初始化View
]]
function LoginViewAccount:initView()

    local function createEditBox_(size, palceholder, inputflag)

        local edt = ccui.EditBox:create(size, "_")
        edt:setPosition(cc.p(size.width / 2 + 40, size.height / 2))
        edt:setAnchorPoint(cc.p(0.5, 0.5))
        edt:setPlaceHolder(palceholder or "")

        --设置弹出键盘,EMAILADDR并不是设置输入文本为邮箱地址,而是键盘类型为方便输入邮箱地址,即英文键盘
        edt:setInputMode(cc.EDITBOX_INPUT_MODE_EMAILADDR)
        edt:setInputFlag(inputflag or cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_ALL_CHARACTERS)
        edt:setPlaceholderFontColor(cc.c3b(119,119,119))
        edt:setFontColor(cc.c3b(119, 119, 119))
        edt:setFontSize(50)
        edt:setMaxLength(16)
        edt:setPlaceholderFontSize(32)
        return edt
    end

    -- 创建密码输入框
    local editBoxSize = self.img_input_password_box_0:getContentSize()
    --,
    self.editPassword = createEditBox_(cc.size(editBoxSize.width - 80, editBoxSize.height), "请输入密码",cc.EDITBOX_INPUT_FLAG_PASSWORD):addTo(self.img_input_password_box_0):posBy(30, -4)

    self.editAccount = createEditBox_(cc.size(editBoxSize.width - 130, editBoxSize.height), "请输入账号"):addTo(self.img_input_account_box):posBy(30, -4)

    -- 隐藏滚动条
    self.lv_account:setScrollBarEnabled(false)

    -- 添加默认账号到输入框
     local from= BRAND==0 and USER_FROM_JIXIANG or USER_FROM_PLATFORM
    local roleInfo = gg.Cookies:GetDefRole(from)
    if roleInfo then
        self:writeBackToInput(roleInfo)
    end

    -- 适配
    local scale = cc.Director:getInstance():getVisibleSize().height / 768
    self.img_tm_bg:setPositionY(self.img_tm_bg:getPositionY() * scale)
    self.lv_account:setPositionY(self.lv_account:getPositionY() * scale)

    -- 审核模式，或者注册功能没有关闭时,开启注册功能
    if IS_REVIEW_MODE or not GameApp:CheckModuleEnable( ModuleTag.CloseRregister ) then
        self.btn_register:setVisible(true)
        self.btn_zhmm:setVisible(false)
        local img_bg = self.btn_login:getChildByName("img_bj") --获取按钮背景图片
        self.btn_login:setContentSize(cc.size(184, self.btn_login:getContentSize().height))
        img_bg:setContentSize(cc.size(184, self.btn_login:getContentSize().height))
        self.btn_login:setPositionX(562)
        img_bg:setPositionX(92)
        self.txt_login:setPositionX(92)
    else
        self.btn_register:setVisible(false)
        self.btn_zhmm:setVisible(true)
    end
end

--[[
* @brief 下拉三角按钮点击事件
]]
function LoginViewAccount:onAccountPullDown(sender)
    -- 判断是否有账号
     local from= BRAND==0 and USER_FROM_JIXIANG or USER_FROM_PLATFORM
    if gg.Cookies:GetRoleCount(from) == 0 then
        return
    end

    -- 显示账号列表
    if not self:isShowAccountList() then

        self:showAccountList()

    else
        self:hideAccountList()
    end
end

--[[
* @brief 账号列表背景事件
]]
function LoginViewAccount:onLvBg(sender)

    -- 隐藏list账号列表
    self:hideAccountList()
end

--[[
* @brief 找回密码事件
]]
function LoginViewAccount:onRetrievePassword(sender)
    -- 播放点击音效
    gg.AudioManager:playClickEffect()
    device.openURL(FORGOT_PASSWORD_URL)
end

function LoginViewAccount:onRegisterClicked(sender)
    -- 注册功能，显示注册界面
    require("login.views.LoginRegisterView").new(self:getScene(), "LoginRegisterView"):pushInScene(true)
end

--[[
* @brief 重试登录事件
]]
function LoginViewAccount:onEventRetryLogin(event)
    self:onLogin()
end
--[[
* @brief 登录事件
]]
function LoginViewAccount:onLogin(sender)
    -- 播放点击音效
    gg.AudioManager:playClickEffect()
    local accountTxt = self.editAccount:getText()
    local passwordTxt = self.editPassword:getText()

    -- 验证账号和密码
    local lenAccount = string.len(accountTxt)
    local lenPassword = string.len(passwordTxt)

    local function checkStr( str )
        return string.match(str, "^[A-Za-z0-9]+$")
    end

    local isAccount = checkStr( accountTxt )

    if (not isAccount and string.len(accountTxt)>0)  then
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "账号只能包含字母和数字。")
        return
    end

        -- 验证密码
    if not gg.CheckPassword(passwordTxt) then
        return
    end

    if lenAccount >= 6 and lenAccount <= 16 and lenPassword >= 6 and lenPassword <= 16 then

        -- 显示等待框
        GameApp:dispatchEvent(gg.Event.SHOW_LOADING, "正在登录服务器...")
        gg.LoginHelper:LoginByName(accountTxt, passwordTxt)
        return
    end

    GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG, "账号或密码长度不正确（6-16位）")


    local dir = cc.Director:getInstance()
    print("VisibleSize_width:" .. dir:getVisibleSize().width)
    print("VisibleSize_height:" .. dir:getVisibleSize().height)
    print("FrameSize_width:" .. dir:getOpenGLView():getFrameSize().width)
    print("FrameSize_height:" .. dir:getOpenGLView():getFrameSize().height)
end

--[[
* @brief 删除账号
]]
function LoginViewAccount:onDelAccount(sender)

    -- 删除账号
    if self:removeAccount(sender:getTag()) and self._currentAccountIndex == sender:getTag() then

        -- 清空输入框
        self:clearInput()

        -- 重置当前账号索引
        self._currentAccountIndex = 0
    end
end

--[[
* @brief 选中账号
]]
function LoginViewAccount:onSelectAccount(sender)
    -- 保存当前账号id
    self._currentAccountIndex = sender:getTag()
    -- 选中回写账号到输入框
    local roleInfo = gg.Cookies:GetRoleInfo(sender:getTag())
    self:writeBackToInput(roleInfo)
    -- 隐藏账号列表
    self:hideAccountList()
end


--[[
* @brief 显示账号列表
]]
function LoginViewAccount:showAccountList()

    if self.lv_account then

        self.panel_lv_bg:setVisible(true)
        self.lv_account:setVisible(true)

        --self.btn_account_pull_down:setFlipX(true)

        -- 移除所有item
        self.lv_account:removeAllChildren()

        -- 获取账号账号信息
        local roleList = gg.Cookies:GetRoleList()
        for i = 1, #roleList do
            local roleInfo = roleList[i]
             local from= BRAND==0 and USER_FROM_JIXIANG or USER_FROM_PLATFORM
            if roleInfo.userfrom == from then
                -- 创建账号列表Item
                local account_info_layer = self:createAccountItem(i, roleInfo)
                if account_info_layer then
                    self.lv_account:pushBackCustomItem(account_info_layer)
                end
            end
        end
    end
end

--[[
* @brief 创建账号列表Item
]]
function LoginViewAccount:createAccountItem(idx, roleInfo)
    if roleInfo == nil then
        return
    end

    -- 创建Item
    local account_info_layer = require("ui/login/account_info_node.lua").create()
    local panel_bg = account_info_layer.root:getChildByName("panel_bg")
    panel_bg:removeFromParent(true)

    -- 设置昵称
    local txt_name = panel_bg:getChildByName("txt_name")
    if roleInfo.userfrom == USER_FROM_UNLOGIN then
        txt_name:setString("游客账号")
    else
        txt_name:setString(roleInfo.nick)
    end

    -- 删除按钮
    local btn_del = panel_bg:getChildByName("btn_del")

    btn_del:onClickScaleEffect(handler(self, self.onDelAccount))
    btn_del:setTag(idx)
    panel_bg:addClickEventListener(handler(self, self.onSelectAccount))
    panel_bg:setTag(idx)

    -- 头像
    local img_avatar = panel_bg:getChildByName("img_avatar")

    -- 创建头像
    local clipNode = cc.ClippingNode:create(cc.Sprite:createWithSpriteFrameName("hall/common/bk_head_ico.png"))
    local _imgAvatar = ccui.ImageView:create("")
    clipNode:addChild(_imgAvatar)
    clipNode:setAlphaThreshold(0)
    clipNode:setPosition(img_avatar:getContentSize().width / 2, img_avatar:getContentSize().height / 2)
    clipNode:setScale(0.8)
    img_avatar:addChild(clipNode)

    local avatarurl = roleInfo.avatarurl
    if avatarurl and string.len(avatarurl) > 0 then
        -- 拉取头像
        gg.ImageDownload:LoadUserAvaterImage({url=avatarurl,ismine=true,image=_imgAvatar})
        return panel_bg
    end

    -- 默认头像
    local avatarPath = gg.IIF(roleInfo.sex, "common/hd_male.png", "common/hd_female.png")

    _imgAvatar:loadTexture(avatarPath)
    -- 84 图片的宽度
    _imgAvatar:setScale(84/ _imgAvatar:getContentSize().width)

    return panel_bg
end

--[[
* @brief 隐藏账号列表
]]
function LoginViewAccount:hideAccountList()


    self.panel_lv_bg:setVisible(false)
    self.lv_account:setVisible(false)
    --self.btn_account_pull_down:setFlipX(false)
end

--[[
* @brief 刷新显示账号列表
]]
function LoginViewAccount:updateAccountList()

    self:hideAccountList()
    self:showAccountList()
end

--[[
* @brief 账号列表是否显示
* @return 账号列表是否显示
]]
function LoginViewAccount:isShowAccountList()

    if self.panel_lv_bg == nil then
        return false
    end

    return self.panel_lv_bg:isVisible()
end

--[[
* @brief 回写账号密码到输入框
]]
function LoginViewAccount:writeBackToInput(roleInfo)

    if self.editPassword == nil or self.editAccount == nil then
        return
    end

    if not roleInfo then
        return
    end

    if roleInfo.userfrom == USER_FROM_UNLOGIN then
        -- 游客
        --self.editAccount:setText("游客账号")
        --self.editPassword:setText("123654789")
    else
        self.editAccount:setText(roleInfo.username)
        self.editPassword:setText(roleInfo.pwd)
    end
end

--[[
* @brief 删除账号
* @parameter 账号索引
* @return 删除是否成功
]]
function LoginViewAccount:removeAccount(roleIdx)
    local role = gg.Cookies:GetRoleInfo(roleIdx)
    if role.from == USER_FROM_UNLOGIN then
        -- 游客账号不允许删除
        GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG, "请先激活该账号")
        return false
    end
    -- 删除当前账号
    gg.Cookies:RemoveRole(roleIdx)
    -- 刷新账号列表
    self:updateAccountList()

    return true
end

--[[
* @brief 添加游客账号
]]
function LoginViewAccount:addTouristAccount()
    printf("addTouristAccount-----")
    -- 检测当前是否有游客账号

    -- 提示有游客账号
    --GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG,"已经有游客帐号！")
    -- 添加游客账号
end

--[[
* @brief 清空输入框
]]
function LoginViewAccount:clearInput()

    self.editPassword:setText("")
    self.editAccount:setText("")
end

--[[
* @brief 关闭按钮点击事件
]]
function LoginViewAccount:onClickClose(sender)

    self:postKeyBackClick()
end


return LoginViewAccount
