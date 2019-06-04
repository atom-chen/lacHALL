local M = class("libs.widget.RichText", function()
    return ccui.RichText:create()
end)

--[[
    * 描述：未配置的参数统一使用以下默认配置，设置一次即可
    * 参数strokeSize：描边大小，int类型
--]]
local m_fontName    = "STHeitiSC-Medium"
local m_fontColor   = cc.c4b(255, 255, 255, 255)
local m_fontSize    = 30
local m_strokeSize  = 3
function M:setDefalutConfig(fontName, fontColor, fontSize)
    assert(fontName and fontColor and strokeColor)
    m_fontName      = fontName
    m_fontColor     = fontColor
    m_fontSize      = fontSize
end

--[[
    * 描述：将文字显示为富文本格式
    * 点击事件：onClieked(key)
    * 例子："恭喜<r>type='Label', content='xxx玩家', fontSize=30,fontColor=cc.c4b(255,0,255,255)</r>获得了<r>type='ButtonLabel',key='ThisIsKey',content='xxx宝物',index='key',underlineColor=cc.c4b(255,255,255,255)</r>，请鼓掌"
      则：'xxx玩家'红色显示，'xxx宝物'可点击并且有下划线
      
    * 类型：由type不同可以分为以下几类，以下除了type和content参数，其他都是可选
    纯文本：   type='Label', content='文本内容', fontSize='30', fontColor=cc.c4b(255,255,255,255), fontName='STHeitiSC-Medium'
    点击文本： type='ButtonLabel'，(其他同上)，underlineColor=cc.c4b(0,255,255,255), key='点击事件的回调', strokeColor=cc.c4b(255,255,0,255), strokeSize=3
    图片：    type='Image',  content='图片路径名'
    按钮：    type='Button', content='图片路径名', key='点击事件的回调'
    动画：    type='Animate', content='plist文件路径名'
--]]
function M:ctor(text)
    self._tagIndex = 0
    if text then 
        self:setText(text)
    end 
end

function M:setText(text)
    self:_clear()
    local parseTable = String:parseSubs(text, "<r>", "</r>")
    for index,value in ipairs(parseTable) do
        self:_parseValue(value[1], value[2])
    end
end

--[[
    * 描述：设置位置、大小、换行间距，建议统一使用该接口
    * 参数centerPos：中心点位置
    * 参数size：视图大小cc.size
    * 参数verticalSpace：换行间距
    * 备注：文字等内容显示是从视图的左上角开始计算
--]]
function M:setViewRect(centerPos, size, verticalSpace)
    self:ignoreContentAdaptWithSize(false)
    self:setContentSize(size)
    self:setPosition(centerPos)
    self:setVerticalSpace(verticalSpace)
end

---------------------------------------- 接口分割线 ---------------------------------------- 

function M:_clear()
    for i = 1,self._tagIndex do
        self:removeElement(0)
    end
    self._tagIndex = 0
end

function M:_parseValue(content, isParse)
    if isParse then 
        self:_pushNeedParseValue(content)
    else 
        self:_pushLabel(content)
    end
end

function M:_getNextTag()
    self._tagIndex = self._tagIndex + 1
    return self._tagIndex
end

function M:_pushLabel(content)
    local elementText = ccui.RichElementText:create(self:_getNextTag(), 
                    cc.c3b(m_fontColor.r, m_fontColor.g, m_fontColor.b), m_fontColor.a, content, m_fontName, m_fontSize)
    self:pushBackElement(elementText)
end

function M:_pushNeedParseValue(content)
    local string = string.format("{%s}", content)
    local valueFunction = loadstring("return " .. string)
    if nil==valueFunction then 
        print("富文本解析错误：content=%s", content)
        return
    end

    local value = valueFunction()
    if nil==value.type then 
        print("富文本解析错误：未定义type参数")
        return
    end

    if nil==value.content then 
        print("富文本解析错误：未定义content参数")
        return
    end

    local typeTable = 
    {
        Label           = function(v) self:_parseLabel(v) end, 
        ButtonLabel     = function(v) self:_parseButtonLabel(v) end,
        Image           = function(v) self:_parseImage(v) end,
        Button          = function(v) self:_parseButton(v) end,
        Animate         = function(v) self:_parseAnimate(v) end,
    }

    Function:safeCall(typeTable, value.type, value)
    if not typeTable[value.type] then 
        print("富文本解析错误：未定义的type类型=", value.type)
        self:_pushLabel(content)
    end
end

function M:_parseLabel(value)
    local content = value.content
    local fontSize = value.fontSize and value.fontSize or m_fontSize
    local fontColor = value.fontColor and value.fontColor or m_fontColor
    local fontName = value.fontName and value.fontName or m_fontName
    local elementText = ccui.RichElementText:create(self:_getNextTag(), 
                    fontColor, fontColor.a, content, fontName, fontSize)
    self:pushBackElement(elementText)
end

function M:_parseButtonLabel(value)
    -- underLineColor=cc.c4b(0,255,255,255), key='点击事件的回调',
    
    local content = value.content
    local fontSize = value.fontSize and value.fontSize or m_fontSize
    local buttonLabel = ButtonLabel.new(content, fontSize)

    -- 描边
    local strokeColor = value.strokeColor
    if strokeColor then 
        local size = value.strokeSize and value.strokeSize or m_strokeSize
        buttonLabel:setStrokeColor(strokeColor, size)
    end

    -- 下划线
    local underlineColor = value.underlineColor
    if underlineColor then 
        buttonLabel:setUnderLineColor(underlineColor)
    end

    -- 点击事件
    buttonLabel.key = value.key
    buttonLabel.onClicked = function(buttonLabel)
        self:_onClickByKey(buttonLabel.key)
    end

    local fontColor = value.fontColor and value.fontColor or m_fontColor
    local elementCustom = ccui.RichElementCustomNode:create(self:_getNextTag(), fontColor, fontColor.a, buttonLabel)
    self:pushBackElement(elementCustom)
end

function M:_parseImage(value)
    local elementImage = ccui.RichElementImage:create(self:_getNextTag(), cc.c3b(255, 255, 255), 255, value.content)
    assert(elementImage, string.format("富文本解析错误：图片不存在=%s", value.content))
    self:pushBackElement(elementImage)
end

function M:_parseButton(value)
    local button = Button:createWithFileName(value.content)

    -- 点击事件
    button.key = value.key
    button.onClicked = function(button)
        self:_onClickByKey(button.key)
    end

    local elementCustom = ccui.RichElementCustomNode:create(self:_getNextTag(), cc.c3b(255, 255, 255), 255, button)
    self:pushBackElement(elementCustom)
end

function M:_parseAnimate(value)
    local animateSprite = SpriteAnimateRepeatForver.new(value.content)
    assert(animateSprite)
   
    local elementCustom = ccui.RichElementCustomNode:create(self:_getNextTag(), cc.c3b(255, 255, 255), 255, animateSprite)
    self:pushBackElement(elementCustom)
end

function M:_onClickByKey(key)
    if self.onClicked then 
        self.onClicked(key)
    end
end

return M

