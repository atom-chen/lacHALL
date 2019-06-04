--
-- Author: Cai
-- Date: 2017-02-11 17:00:00

local UpdateTipsView = class("UpdateTipsView", cc.load("ViewPop"))

UpdateTipsView.RESOURCE_FILENAME="ui/login/update_tips_view.lua"

UpdateTipsView.RESOURCE_BINDING = {
	["sv_content"] = { ["varname"] = "sv_content" },
	["btn_update"] = { ["varname"] = "btn_update", ["events"] = { { ["event"] = "click", ["method"] = "onClickUpdate" } } },
    ["btn_exit"]   = { ["varname"] = "btn_exit",   ["events"] = { { ["event"] = "click", ["method"] = "onClickExit"   } } },
}

function UpdateTipsView:onCreate( callback ,log)
    assert(type(callback)=="function" ,"type error "..type(callback)) 
    -- 设置回调函数
    self.callback_ = callback
	self:init()
    self:initView()
    self:setContents( log or "游戏有大版本更新了" )
end

function UpdateTipsView:init(  )
    -- 隐藏listView滚动条
    self.sv_content:setScrollBarEnabled(false)
end

function UpdateTipsView:initView( )
    -- 更新内容
    self.txt_content = cc.Label:create()
    self.txt_content:setSystemFontSize(32)
    self.txt_content:setTextColor( { r = 111 , g = 42, b = 9 } )
    self.txt_content:setAnchorPoint( cc.p( 0, 1 ) )
    self.txt_content:setWidth( self.sv_content:getContentSize().width )
    self.txt_content:setPosition( cc.p( 0 , self.sv_content:getContentSize().height ) )
    self.sv_content:addChild( self.txt_content, 1 )
end

-- 设置界面数据
function UpdateTipsView:setContents( data )
    self.txt_content:setString( data )
    -- 获取更新内容文本高度
    local hTxt = self.txt_content:getContentSize().height
    -- 当文本高度超过显示区域重新设置滑动高度和文本位置
    if hTxt > self.sv_content:getContentSize().height then
        self.sv_content:setInnerContainerSize( { width = self.sv_content:getContentSize().width, height = hTxt } )
        self.txt_content:setPosition( cc.p( 0, hTxt ) )
    end
end

function UpdateTipsView:keyBackClicked() 
    return true, false
end

-- 更新
function UpdateTipsView:onClickUpdate( sender )
    if self.callback_ then self.callback_() end
    if device.platform ~= "ios" then
        self:removeSelf()
    end
end

-- 退出
function UpdateTipsView:onClickExit( sender )
    GameApp:Exit()
end

return UpdateTipsView