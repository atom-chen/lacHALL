local MessageDialog = class("MessageDialog", cc.load("ViewPop"))

MessageDialog.MODE_OK_ONLY = 0
MessageDialog.MODE_OK_CANCEL = 1
MessageDialog.MODE_OK_CANCEL_CLOSE = 2
MessageDialog.MODE_OK_CLOSE = 3

MessageDialog.EVENT_TYPE_CLOSE = 2
MessageDialog.EVENT_TYPE_OK = 1
MessageDialog.EVENT_TYPE_CANCEL = 0

MessageDialog.RESOURCE_FILENAME = "ui/common/message_dialog.lua"

MessageDialog.RESOURCE_BINDING = {
    ["btn_determine"] = { ["varname"] = "btn_determine", ["events"] = { { event = "click", method = "onClickDetermine" } } }, -- 确定按钮
    ["btn_cancel"]    = { ["varname"] = "btn_cancel", ["events"] = { { event = "click", method = "onClickCancel" } } }, -- 取消按钮
    ["btn_close"]     = { ["varname"] = "btn_close", ["events"] = { { event = "click", method = "onClickClose" } } }, -- 关闭按钮
    ["content_txt"]   = { ["varname"] = "content_txt" }, -- 内容文本
    ["txt_title"]     = { ["varname"] = "txt_title" },   -- 标题
    ["img_line"]      = { ["varname"] = "img_line"  },   --线
}

function MessageDialog:createWithText(text, callbackfn, params)
    return MessageDialog.new(nil, "MessageDialog", text, callbackfn, params)
end

--@params 字段格式 {mode,ok,cancel,theme,tite,font}
-- mode 按钮显示模式
-- ok 确定按钮内容
-- cancel 取消按钮内容
-- theme皮肤模版样式
-- title nil 默认格式
function MessageDialog:ctor(app, name, text, callbackfn, params)
    params = checktable(params)
    if params.theme and string.len(params.theme) > 0 then
        MessageDialog.RESOURCE_FILENAME = params.theme
    end
    name = name or params.name
    MessageDialog.super.ctor(self, app, name, text, callbackfn, params)
end

--[[
* @brief 提示框初始化
* @param [in] t 提示文本
* @param [in] style 按钮风格
* @param [in] fn( tag ) 回调  tag = 0 确定、1取消
{mode,ok,cancel,theme}
]]
function MessageDialog:onCreate(text, callbackfn, params)
        --线处理
    gg.LineHandle( self.img_line)
    self.callbackfn_ = callbackfn
    params.mode =params.mode or MessageDialog.MODE_OK_CLOSE
    self:setContentLineSpacing(10)
    self.content_txt:setString(tostring(text) or "")
    self:handlerParams(params)
end

function MessageDialog:handlerParams(params)
    local FuncTable={
        ["font"]=self.setContentFont,
        ["title"]= self.setTitle,
        ["ok"]= self.setOkContent,
        ["cancel"]=self.setCancelContent,
        ["swapbtn"]=self.swapButton,
        ["mode"]=self.setMode,
        ["backdisable"]=self.setKeybackDisable,
        ["hideclose"]=function() self.btn_close:setVisible(false) end,
        ["contentfontsize"]=self.setContentFontSize,
    }
    for k,v in pairs(params) do
        local handle= FuncTable[k]
        if handle then
            handle(self,v)
        end
    end
end


--设置内容字体
function MessageDialog:setContentFont(font)
    self.content_txt:setFontName(font)
    return self
end

--设置内容字体
function MessageDialog:setContentFontSize(size)
    self.content_txt:setFontSize(size)
    return self
end

--设置内容行间距 注意！！系统字体行间距无效
function MessageDialog:setContentLineSpacing(space)
    self.content_txt:getVirtualRenderer():setLineSpacing(space)
    return self
end

function MessageDialog:setMode(mode)
    mode = mode or self.mode_
    self.mode_=mode
    self.btn_close:setVisible(true)
    if mode == MessageDialog.MODE_OK_ONLY then
        self.btn_cancel:setVisible(false)
        self.btn_close:setVisible(false)
    elseif mode== MessageDialog.MODE_OK_CANCEL then
        self.btn_close:setVisible(false)
        self.btn_cancel:setVisible(true)
    elseif mode== MessageDialog.MODE_OK_CLOSE then
        self.btn_cancel:setVisible(false)
    else
        self.btn_cancel:setVisible(true)
    end
    return self
end

function MessageDialog:setContentPosY(y)
    self.content_txt:setPositionY(y)
    return self
end

function MessageDialog:setContent(text)
    if text then
        self.content_txt:setString(tostring(text) or "温馨提示。。。")
    end
    return self
end

function MessageDialog:setTitle(text)
    self.txt_title:setVisible(true)
    if text then
        if string.len(text) == 0 then
            self.txt_title:setVisible(false)
        else
            self.txt_title:setString(tostring(text))
        end
    end
    return self
end

--设置确定按钮颜色
function MessageDialog:setOkColor(color)
    self.btn_determine:getChildByName("btn_bg"):setColor(color or { r = 0, g = 177, b = 92 })
    return self
end

--设置取消按钮颜色
function MessageDialog:setCancelColor(color)
    self.btn_cancel:getChildByName("btn_bg"):setColor(color or { r = 203, g = 89, b = 70 })
    return self
end

function MessageDialog:setOkContent(text)
    if text then
        local txt = self.btn_determine:getChildByName("btn_txt")
        if string.len(text) > 15 then
            -- 超过5个汉字，调整字体大小
            txt:setFontSize(28)
        end
        txt:setString(tostring(text) or "")
    end
    return self
end

function MessageDialog:setCancelContent(text)
    if text then
        local txt = self.btn_cancel:getChildByName("btn_txt")
        if string.len(text) > 15 then
            -- 超过5个汉字，调整字体大小
            txt:setFontSize(28)
        end
        txt:setString(tostring(text) or "")
    end
    return self
end

function MessageDialog:show()
    local name=checkstring(self:getName())
    if #name>0 and  not tolua.isnull(self:getScene()) then
         local child= self:getScene():getChildByName(name)
         if child and not tolua.isnull(child) then
            child:removeSelf()
            printf("--- already exists child in scene  name is :"..tostring(name))
          --  return self
        end
    end
    self:pushInScene()
    return self
end

function MessageDialog:setKeybackDisable(disable)
    self.backdisable_=disable
end

function MessageDialog:keyBackClicked()
    if not self.backdisable_ then
        self:removeSelf(MessageDialog.EVENT_TYPE_CLOSE)
        return true, true
    end
    return false, false
end

function MessageDialog:removeSelf(bType)
    if self.callbackfn_ then
        self.callbackfn_(bType or MessageDialog.EVENT_TYPE_CLOSE)
    end
    MessageDialog.super.removeSelf(self)
end

--[[
* @brief 确定按钮事件
]]
function MessageDialog:onClickDetermine(sender)
    self:removeSelf(MessageDialog.EVENT_TYPE_OK)
end

function MessageDialog:onClickCancel(sender)
    self:removeSelf(MessageDialog.EVENT_TYPE_CANCEL)
end
--[[
* @brief 取消按钮事件
]]
function MessageDialog:onClickClose(sender)
    self:removeSelf(MessageDialog.EVENT_TYPE_CLOSE)
end

--交换确定 取消 按钮 位置  默认位置 左侧确定右侧取消
function MessageDialog:swapButton()
    if self.mode_~= MessageDialog.MODE_OK_ONLY then
        local x, y = self.btn_determine:getPosition()
        self.btn_determine:setPosition(self.btn_cancel:getPosition())
        self.btn_cancel:setPosition(x, y)
    end
    return self
end

--[[
* @brief 联系客服按钮事件
]]
function MessageDialog:onClickService(sender)
    self:removeSelf()
end

function MessageDialog:getViewZOrder()
    return 9900
end

return MessageDialog