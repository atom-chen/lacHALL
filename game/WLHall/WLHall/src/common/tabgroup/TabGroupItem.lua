local TabGroupItem = class("TabGroupItem", ccui.Button)
local LuaExtend = require "LuaExtend"

--[[
    * @brief 带有二级子界面的按钮组中的按钮item
    * @pram nor_img 正常状态图片
    * @pram act_img 点击状态图片
    注：1、按钮组中的按钮创建,初始化创建仅通过传入的图片设置正常状态和点击状态的按钮
        2、如果需要设置带文字标题的,调用setTitle()方法,要修改按钮标题的也是调用这个方法
        3、如果传入的图片是张位图片,需要缩放的话调用setScale9()方法来设置按钮的大小
        4、如果需要在按钮上添加对象(精灵,节点等),调用setSpritNode()方法
        5、需要更改图片调用loadTexture()方法
]]--

function TabGroupItem:ctor( nor_img, act_img ,imgType)
    self:ignoreContentAdaptWithSize(false)  -- 忽略内容适应,如果设置为true,使用系统默认的渲染大小,与实际的图片资源大小无关
    self.nor_img = nor_img  -- 普通状态时的图片
    self.act_img = act_img  -- 点击状态时的图片
    self.act = false        -- item是否被点击,默认为未点击
    self.imgType = imgType or 1
    self:initView()         -- 初始化item

end

-- 初始化item
function TabGroupItem:initView( )

    self:loadTextureNormal(self.nor_img, self.imgType)   -- 设置普通状态图片
    self:loadTexturePressed(self.act_img, self.imgType)  -- 设置点击状态图片
end

-- item上添加精灵的初始化
function TabGroupItem:initSpritNode()
    if self.nor_node then
        self:addChild(self.nor_node)
        self.nor_node:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
    end
    if self.act_node then
        self:addChild(self.act_node)
        self.act_node:setVisible(false)
        self.act_node:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
    end
end

-- 设置按钮状态
function TabGroupItem:setAct( bo )
    self.act = bo
    self:updateItemState( )
end

-- 设置普通或未点击不同状态下的显示
function TabGroupItem:updateItemState(  )
    if self.act then
        self:setBrightStyle(1)  -- 设置为点击状态
        self:setTouchEnabled( false )
        if self.nor_node then self.nor_node:setVisible(false) end
        if self.act_node then self.act_node:setVisible(true) end
        if self.txt_ then
            self.txt_:setTextColor( self._txtLigC )
        end
    else
        self:setBrightStyle(0)  -- 设置为普通状态
        self:setTouchEnabled( true )
        if self.nor_node then self.nor_node:setVisible(true) end
        if self.act_node then self.act_node:setVisible(false) end
        if self.txt_ then
            self.txt_:setTextColor( self._txtNorC )
        end
    end
    self:setSwallowTouches( false )
end

-- 设置按钮纹理颜色
function TabGroupItem:setTextureColor4State( nor_color, act_color )
    if nor_color then
        self:getRendererNormal():setColor( nor_color )
    end
    if act_color then
        self:getRendererClicked():setColor( act_color )
    end
end

-- 如果图片需要进行缩放的话调用这个方法来调整大小
function TabGroupItem:setScale9(capInsets, size)
    self:setScale9Enabled(true)
    self:setCapInsets(capInsets)
    self:setContentSize(size)
end

-- 获取item的尺寸
function TabGroupItem:getItemSize()
    local rect = self:getRendererNormal():getSprite():getTextureRect()
    return cc.size(rect.width, rect.height)
end

-- 添加标题,需要设置文本标题时调用
function TabGroupItem:setTitle( txt, fontSize, fontColor, lightColor, fontName )
    -- 避免重复设置文本
    if self.txt_ then
        self.txt_:removeFromParent(true)
        self.txt_ = nil
    end
    -- 记录颜色
    self._txtNorC = fontColor or { r = 255, g = 255, b = 255 }
    self._txtLigC = lightColor or { r = 255, g = 255, b = 255 }
    -- 创建文本控件
    local txt_ = ccui.Text:create()
    txt_:setString(txt or "")
    txt_:setFontSize( fontSize or 34 )
    txt_:setFontName( fontName or "Arial" )
    txt_:setTextColor( self._txtNorC )
    txt_:setName("txt")
    -- 设置文本位置
    local size = self:getContentSize()
    txt_:setPositionY(size.height / 2 - 2 )
    txt_:setPositionX(size.width / 2)
    self:addChild(txt_)
    -- 记录文本控件
    self.txt_ = txt_
end

function TabGroupItem:setTitleAnchorPoint( x, y )
    if self.txt_ then
        self.txt_:setAnchorPoint( cc.p( x, y ) )
    end
end

-- 设置标题位置,rate为位置的百分数
function TabGroupItem:setTitlePosition( rateX, rateY )
    if self.txt_ then
        local size = self:getContentSize()
        self.txt_:setPositionX( size.width * rateX or 0.5 )
        self.txt_:setPositionY( size.height * rateY or 0.5 )
   end
end

-- 设置item状态图片
function TabGroupItem:loadTexture( nor_img , act_img )
    if nor_img then
        self.nor_img = nor_img  -- 普通状态时的图片
    end
    if act_img then
        self.act_img = act_img  -- 点击状态时的图片
    end
    self:initView()
end

-- 在按钮上添加精灵对象
function TabGroupItem:setSpritNode( nor_node, act_node )
    -- 避免重复添加,设置时先移除原来的
    if self.nor_node then
        self.nor_node:removeFromParent()
        self.nor_node = nil
    end
    if self.act_node then
        self.act_node:removeFromParent()
        self.act_node = nil
    end
    if nor_node then self.nor_node = nor_node end
    if act_node then self.act_node = act_node end
    self:initSpritNode()
    self:updateItemState()
end

function TabGroupItem:setNodePosition( rateX, rateY )
    local size = self:getContentSize()
    if self.nor_node then
        self.nor_node:setPosition( size.width * rateX or 0.5, size.height * rateY or 0.5 )
    end
    if self.act_node then
        self.act_node:setPosition( size.width * rateX or 0.5, size.height * rateY or 0.5 )
    end
end

return TabGroupItem