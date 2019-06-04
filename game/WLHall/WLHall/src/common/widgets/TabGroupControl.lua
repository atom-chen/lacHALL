local TabGroupControl = class("TabGroupControl", cc.Node)
local LuaExtend = require "LuaExtend"

function TabGroupControl:ctor(nor_img, act_img, buttonNameTable, fn, isV, offset)
    self.buttonNameTable = buttonNameTable
    self.buttonTable = {}
    self.nor_img = nor_img
    self.act_img = act_img
    self.fn = fn
    self.isV = isV
    self.offset = offset
    self.index = 1

    self.tabType = 0
    if nor_img == nil and act_img == nil then
        self.nor_img = self.buttonNameTable[1] .. "_nor.png"
        self.act_img = self.buttonNameTable[1] .. "_act.png"
        self.tabType = 1
    end
    self:initView()
end

--初始化所有按钮
function TabGroupControl:initView()
    for i, txt in ipairs(self.buttonNameTable) do
        local btn = ccui.Button:create()
        btn:loadTextureNormal(self.nor_img, 0)
        btn:loadTexturePressed(self.nor_img, 0)
        btn["txt_path"] = txt
        table.insert(self.buttonTable, btn)

        local curOffset = self.offset * (i - 1)
        if self.isV then
            btn:setPosition(0, -curOffset)
        else
            btn:setPosition(curOffset, 0)
        end
        self:addChild(btn)

        if self.tabType == 0 and txt ~= "" then
            btn:onClickScaleEffect(handler(self, self.onClick))
            print(txt .. "_nor.png")
            local txtSprite = cc.Sprite:create(txt .. "_nor.png")
            local btnRect = self:getBtnSize(btn)
            txtSprite:setPosition(btnRect.width / 2, btnRect.height / 2)
            txtSprite:setName("txt")
            btn:addChild(txtSprite)
        else
            btn:onClickDarkEffect(handler(self, self.onClick))
        end
    end
    self:frushViewControl()
end

--设置回调函数
function TabGroupControl:setFunc(fn)
    self.fn = fn
end

--设置按钮对应二级窗口
function TabGroupControl:setButtonChildView(index, obj)
    self.buttonTable[index].child_view = obj
end

--获取对应按钮
function TabGroupControl:getButton(index)
    return self.buttonTable[index]
end

--获取与设置选中的按钮
function TabGroupControl:getIndex()
    return self.index
end

function TabGroupControl:setIndex(index)
    self.index = index
    self:frushViewControl()
    return self:getButton(self.index)
end

-----------------------
-- 获得当前选中按钮
function TabGroupControl:getCurButton()
    return self.buttonTable[self.index]
end

--设置对应按钮纹理
function TabGroupControl:setButtonImgPath(index, txt_path)
    self.buttonTable[index]["txt_path"] = txt_path
    self:frushViewControl()
end


function TabGroupControl:onClick(obj)
    print("TabGroupControl:onClick")
    for index, btn in ipairs(self.buttonTable) do
        if btn == obj then
            self:setIndex(index)
            if self.fn then self.fn(self) end
            return
        end
    end
end

function TabGroupControl:frushViewControl()
    if self.tabType == 0 then
        self:frushView()
    elseif self.tabType == 1 then
        self:frushView2()
    end

    for index, btn in ipairs(self.buttonTable) do
        if btn.child_view ~= nil then btn.child_view:setVisible(false) end
        if index == self:getIndex() then
            if btn.child_view ~= nil then btn.child_view:setVisible(true) end
        end
    end
end

function TabGroupControl:frushView()
    --重置所有按钮
    for i, btn in ipairs(self.buttonTable) do
        btn:getRendererNormal():setSpriteFrame(cc.SpriteFrame:create(self.nor_img, self:getBtnSize(btn)))
        btn:getRendererClicked():setSpriteFrame(cc.SpriteFrame:create(self.nor_img, self:getBtnSize(btn)))
        local txtSprite = btn:getChildByName("txt")
        if txtSprite then txtSprite:setTexture(btn.txt_path .. "_nor.png") end
    end
    --点亮选中按钮
    local btn = self.buttonTable[self.index]
    local txtSprite = btn:getChildByName("txt")
    btn:getRendererNormal():setSpriteFrame(cc.SpriteFrame:create(self.act_img, self:getBtnSize(btn)))
    btn:getRendererClicked():setSpriteFrame(cc.SpriteFrame:create(self.act_img, self:getBtnSize(btn)))
    if txtSprite then txtSprite:setTexture(btn.txt_path .. "_act.png") end
end

function TabGroupControl:frushView2()
    --重置所有按钮
    for i, btn in ipairs(self.buttonTable) do
        btn:getRendererNormal():setSpriteFrame(cc.SpriteFrame:create(btn.txt_path .. "_nor.png", self:getBtnSize(btn)))
        btn:getRendererClicked():setSpriteFrame(cc.SpriteFrame:create(btn.txt_path .. "_act.png", self:getBtnSize(btn)))
    end
    --点亮选中按钮
    local btn = self.buttonTable[self.index]
    btn:getRendererNormal():setSpriteFrame(cc.SpriteFrame:create(btn.txt_path .. "_act.png", self:getBtnSize(btn)))
    btn:getRendererClicked():setSpriteFrame(cc.SpriteFrame:create(btn.txt_path .. "_act.png", self:getBtnSize(btn)))
end

function TabGroupControl:getBtnSize(btn)
    local rect = btn:getRendererNormal():getSprite():getTextureRect()
    return cc.size(rect.width, rect.height)
end

return TabGroupControl