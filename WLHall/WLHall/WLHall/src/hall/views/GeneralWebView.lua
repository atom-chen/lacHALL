
-- Author: zhaoxinyu
-- Date: 2016-12-8 17:17:24
-- Describe：通用WebView

local GeneralWebView = class("GeneralWebView", cc.load("ViewBase"))
GeneralWebView.RESOURCE_FILENAME="ui/hall/customer_service.lua"
GeneralWebView.RESOURCE_BINDING = {
    ["panel_web"]    = {["varname"] = "panel_web"   },          -- WebView面板
	["txt_win"]      = {["varname"] = "txt_win"     },          -- Win标识提示
	["panel_bg"]     = {["varname"] = "panel_bg"    },          -- Panel背景
	["img_title_bg"] = {["varname"] = "img_title_bg"},          -- 标题
    ["txt_title"]    = {["varname"] = "txt_title"   },          -- 标题文本
    ["panel_back"]   = {["varname"] = "panel_back", ["events"] = {{event = "click",method = "onClickClose"}}},  -- 返回按钮
}

local screenChangeState = {
    LOAD_WEB = 0,
    OPEN_STORE = 1,
    CLOSE_STORE = 2
}
local curScreenState = 0
local _isChangePortrait = false     -- 是否切换竖屏显示
local _url, _title, _hideTitleBar   

function GeneralWebView:loadWebview(url, title, hideTitleBar)
    self:registerEventListener()
    -- 适配
    self.panel_bg:setContentSize(cc.size(display.width, display.height))
    self._hideTitleBar = hideTitleBar
    if hideTitleBar then
        self.img_title_bg:setVisible(false)
        self.panel_web:setContentSize(self.panel_bg:getContentSize())
    else
        self.img_title_bg:setPositionY(display.height)
        self.panel_web:setContentSize(cc.size(self.panel_bg:getContentSize().width, self.panel_bg:getContentSize().height - self.img_title_bg:getContentSize().height + 7))
        self.txt_title:setPositionX(display.width / 2)
    end

    -- 设置标题
    if title then
        self:setTitleTxt( title )
    end

    if device.platform == "android" then
    elseif device.platform == "ios" then
    else
        self.txt_win:setVisible(true)
        self.txt_win:setPositionX( display.width / 2 )
        return
    end

    -- 添加WebView
    local winSize = self.panel_web:getContentSize()
    local webView = ccexp.WebView:create()
    webView:setPosition(display.width / 2, winSize.height / 2)
    webView:setContentSize(display.width,  winSize.height)
    webView:setScalesPageToFit(true)
    webView:setBounces(false)
    self.panel_web:addChild(webView)

    --webView:setRotationSkewX(90.0000)
    --webView:setRotationSkewY(90.0000)

    -- 添加加载事件监听
    self._curUrl = nil
    webView:setOnShouldStartLoading(function(sender, url)
        --GameApp:dispatchEvent(gg.Event.SHOW_LOADING,"正在加载...")
        if url and url ~= "" then
            print("---- should start loading :"..url)

            if device.platform == "ios" and not self._curUrl then
                -- iOS 初始化访问的 url 是游戏的网页地址，直接加载
                self._curUrl = url
                return true
            end

            return gg.WebGameCtrl:handleUrl(webView, url)
        end
        return true
    end)
    webView:setOnDidFinishLoading(function(sender, url)
        --GameApp:dispatchEvent(gg.Event.SHOW_LOADING)
    end)
    webView:setOnDidFailLoading(function(sender, url)
        --GameApp:dispatchEvent(gg.Event.SHOW_LOADING)
    end)

    --local url = "https://chat.jixiang.cn:8080/chat"
    --webView:loadURL(url)
    self._webView = webView

    -- 加载URL
    if url then
        self:loadUrl( url )
    end
end

function GeneralWebView:screenSizeChange(event)
    printf("GeneralWebView:screenSizeChange")
    if curScreenState == screenChangeState.LOAD_WEB then
        self:loadWebview(_url, _title, _hideTitleBar)
    elseif curScreenState == screenChangeState.OPEN_STORE then
        GameApp:DoShell(GameApp:getRunningScene(), "Store://diamond")
        self._webView:setVisible(false)
        self:setVisible(false)
    elseif curScreenState == screenChangeState.CLOSE_STORE then
        self:showWebView()
    end
end

-- @param isChangeLandscape bool 是否切换竖屏
function GeneralWebView:onCreate(url, title, hideTitleBar, isChangePortrait)
    _url = url
    _title = title
    _hideTitleBar = hideTitleBar

    if isChangePortrait and gg.GetNativeVersion() >= 7 then
        _isChangePortrait = isChangePortrait
        curScreenState = screenChangeState.LOAD_WEB
        self:addEventListener(gg.Event.SCREEN_SIZE_CHANGE, handler(self, self.screenSizeChange))
        device.setIsLandscape(false)
    else
        self:loadWebview(_url, _title, _hideTitleBar)
    end
end

--[[
* @brief 注册消息通知
]]
function GeneralWebView:registerEventListener()
    -- 注册消息
    -- self:addEventListener(gg.Event.NETWORK_ERROR, handler(self,self.onClickClose) )
    self:addEventListener(gg.Event.STORE_VIEW_CLOSE, handler(self,self.onEventStoreViewClose) )
    self:addEventListener(gg.Event.STORE_VIEW_OPEN, handler(self,self.hideWebView) )
    self:addEventListener(gg.Event.CLOSE_WEB_GAME, handler(self, self.onClickClose) )
    self:addEventListener(gg.Event.HALL_UPDATE_USER_DATA, handler(self, self.onEventDiamondCntChange))
    -- 关注前后台切换的事件
    self:enableAppEvents()
end

--app 从后台进入前台事件回调
function GeneralWebView:onAppEnterForeground(difftime)
    if device.platform == "ios" then
        -- ios 平台回到前台时，关闭支付的 webview
        device.closeWebView()
    end
    gg.WebGameCtrl:dispatchEvent(self._webView, gg.WebGameCtrl.EVENT_NAMES.ENTER_FOREGROUND)
end

--app 进入后台事件回调
function GeneralWebView:onAppEnterBackground()
    gg.WebGameCtrl:dispatchEvent(self._webView, gg.WebGameCtrl.EVENT_NAMES.ENTER_BACKGROUND)
end

function GeneralWebView:onEventDiamondCntChange(event, userinfo, propid, propvalue)
    if propid and propid == PROP_ID_XZMONEY then
        gg.WebGameCtrl:dispatchEvent(self._webView, gg.WebGameCtrl.EVENT_NAMES.DIAMOND_CHANGED, checkint(propvalue))
    end
end

function GeneralWebView:onEventStoreViewClose()
    if hallmanager and hallmanager.userinfo then
        local diamondCnt = checkint(hallmanager.userinfo.xzmoney)
        gg.WebGameCtrl:callbackToJS(self._webView, gg.WebGameCtrl.SUPPORT_CMDS.SHOW_DIAMOND_STORE, diamondCnt)
    end

    if _isChangePortrait then
        curScreenState = screenChangeState.CLOSE_STORE
        device.setIsLandscape(false)
    else
        self:showWebView()
    end
end

function GeneralWebView:showWebView()
    self._webView:setVisible(true)
    self:setVisible(true)
end

function GeneralWebView:hideWebView()
    if _isChangePortrait then
        curScreenState = screenChangeState.OPEN_STORE
        device.setIsLandscape(true)
    else
        GameApp:DoShell(GameApp:getRunningScene(), "Store://diamond")
        self._webView:setVisible(false)
        self:setVisible(false)
    end
end

--[[
* @brief 返回按钮
]]
function GeneralWebView:onClickClose( ... )
    self:removeSelf()
end

function GeneralWebView:removeSelf()
    if _isChangePortrait then    
        device.setIsLandscape(true)
    end
    GeneralWebView.super.removeSelf(self)
end

--[[
* @brief 设置标题文本
]]
function GeneralWebView:setTitleTxt( txt )

    self.txt_title:setString( txt )
 end

 --[[
* @brief 加载指定网页
]]
function GeneralWebView:loadUrl( url )

    if self._webView then
        self._webView:loadURL( url )
    end
end

-- 隐藏顶部标题栏，显示全屏网页时屏蔽back键响应
function GeneralWebView:keyBackClicked()
    if self._hideTitleBar then
        return false, false
    else
        return GeneralWebView.super.keyBackClicked(self)
    end
end

return GeneralWebView