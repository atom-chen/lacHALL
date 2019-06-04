local UIBase = import(".UIBase")
local ViewBase = class("ViewBase", UIBase)

function ViewBase.getType()
    return ViewBase.__cname
end

function ViewBase:ctor(scene, name, ...)
    self:enableNodeEvents()
    self.scaleX_ = 1
    self.scaleY_ = 1
    self.app_ = scene   --注 此变量不可外部访问 外部访问 统一使用 self:getScene() 获取当前层场景对象
    self:calcScale()
    self.waitingNode = nil
    self.onRemoveListeners_ = {}

    ViewBase.super.ctor(self, name, ...)
end

local function dispatchRemoveEvent_(listeners)
    for _, callback in ipairs(listeners) do
        callback()
    end
end
--获取当前层附属场景或当前运行场景
function ViewBase:getScene()
    if self.app_ and tolua.type(self.app_)=="cc.Scene" then
        return  self.app_
    elseif self:getParent() then
        return cc.Node.getScene(self)
    else
        return display.getRunningScene() or display.newScene()
    end
end

function ViewBase:calcScale()
    local cfg_ds = CC_DESIGN_RESOLUTION
    if cfg_ds.autoscale == "FIXED_WIDTH" then
        self.scaleY_ = display.height / cfg_ds.height
    elseif cfg_ds.autoscale == "FIXED_HEIGHT" then
        self.scaleX_ = display.width / cfg_ds.width
    end
end

-- 根据缩放比计算子节点坐标
function ViewBase:refreshPosition(...)
    local childs = { ... }
    if childs then
        for i = 1, #childs do
            local obj = childs[i]
            local x, y = obj:getPosition()
            obj:setPosition(x * self.scaleX_, y * self.scaleY_)
        end
    end
end

-- 根据缩放比计算子节点X坐标
function ViewBase:refreshPositionX(...)
    local childs = { ... }
    if childs then
        for i = 1, #childs do
            local obj = childs[i]
            local x, y = obj:getPosition()
            obj:setPositionX(x * self.scaleX_)
        end
    end
end

-- 根据缩放比计算节点大小
function ViewBase:refreshWidth(...)
    local childs = { ... }
    if childs then
        for i = 1, #childs do
            local obj = childs[i]
            local size = obj:getContentSize()
            obj:setContentSize(cc.size(size.width * self.scaleX_, size.height))
        end
    end
end

-- 视图对象自己压栈到当前场景
function ViewBase:pushInScene(invisiblePre)
    self:setVisible(true)
    local scene= self:getScene()
    if scene and scene.pushViewInScene then
        scene:pushViewInScene(self, invisiblePre)
    else
        scene = display.getRunningScene()
        if scene then
            scene:addChild(self)
        end
    end
    return self
end

--[[
添加事件监听
eventName 事件名字
listener 事件监听函数
tag 事件tag
]] --
function ViewBase:addEventListener(eventName, listener)
    return GameApp:addEventListener(eventName, listener, self)
end

function ViewBase:onExit_()
    cc.Node.onExit_(self)
    self:showLoading()
end

function ViewBase:onCleanup_()
    self.onRemoveListeners_ = {}
    if GameApp and GameApp.removeEventListenersByTag then
        GameApp:removeEventListenersByTag(self)
    end
    cc.Node.onCleanup_(self)
end

-- 显示页面加载动画效果
function ViewBase:showLoading(msg, timeout,removecallback, disabletimeout, cancelEnable, swallowBack)
   return gg.ShowLoading(self, msg, timeout,removecallback, disabletimeout, cancelEnable, swallowBack)
end

-- 层删除回掉事件
function ViewBase:addRemoveListener(onRemoveSelfCallback)
    if self.onRemoveListeners_ and onRemoveSelfCallback then
        table.insert(self.onRemoveListeners_, onRemoveSelfCallback)
    end
end

function ViewBase:removeSelf()
    if not tolua.isnull(self) then
        dispatchRemoveEvent_(self.onRemoveListeners_)
        self:removeFromParent()
        return true
    end
    return false
end

-- 发送返回键事件通知
function ViewBase:postKeyBackClick()
    local scene= self:getScene()
    if scene and scene.onKeyBackClicked_ then
        scene:onKeyBackClicked_()
    end
end

-- 返回键处理函数  如需要 拦截返回键  ret1  是否已处理  ret2 是否已删除
function ViewBase:keyBackClicked_()
    local payLoadingNode = self:getChildByName("PayLoading")
    if payLoadingNode then
        return true, false
    end

    local waitingSwallowed = false
    local removed = false
    if self.waitingNode_ then
        waitingSwallowed, removed = self.waitingNode_:keyBackClicked()
    end

    if waitingSwallowed then
        -- waiting 界面吞噬了事件，直接返回。不再调用实际的 keyBackClicked 回调
        return true, false
    end

    return self:keyBackClicked()
end

function ViewBase:keyBackClicked()
    self:removeSelf()
    return true, true
end

--[[
* @brief 吐司提示
* @pram params 参数
        params.type 显示的类型 不传或者0为队列型模式,1为常规模式
        params.location 吐司初始显示的位置
        params.img 吐司提示的背景图片
]]
function ViewBase:showToast( text, params )
    local scene= self:getScene()
    if scene and scene.showToast then
        scene:showToast( text, params, scene )
    end
end

function ViewBase:initWinEditBox( box, isPassword, maxLen, isNum )
    printf("ViewBase:initWinEditBox")

    local mybox = self[box]
    local parent = mybox:getParent()
    isPassword = isPassword or false
    local editBoxSize = mybox:getContentSize()

    self[box] = ccui.EditBox:create(cc.size(editBoxSize.width, editBoxSize.height + 20), "_") --editBoxSize.height
    self[box]:setPosition(cc.p(mybox:getPositionX(), mybox:getPositionY()))
    self[box]:setAnchorPoint(cc.p(0, 0.5))
    self[box]:setPlaceHolder(mybox:getPlaceHolder())
    --self[box]:setPlaceholderFontColor(cc.c3b(146,62,13))
    --self[box]:setInputMode(cc.EDITBOX_INPUT_MODE_EMAILADDR)
    if isNum then
        self[box]:setInputMode(cc.EDITBOX_INPUT_MODE_PHONENUMBER)
    else
        self[box]:setInputMode(cc.EDITBOX_INPUT_MODE_EMAILADDR)
    end

    self[box]:setFontSize(mybox:getFontSize()+2)
    self[box]:setPlaceholderFontSize(mybox:getFontSize())

    -- self[box]:setFontSize(25)
    -- self[box]:setPlaceholderFontSize(25)

    -- 设置输入最大长度
    if maxLen then
        self[box]:setMaxLength(maxLen)
    end

    if isPassword then
        self[box]:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
    end
    self[box]:setFontColor(cc.c3b(34, 34, 34))

    parent:addChild(self[box])
    mybox:removeFromParent()

    self[box].setString = function(self, str)
        self:setText(str)
    end
    self[box].getString = function(self)
        return self:getText()
    end
end

return ViewBase
