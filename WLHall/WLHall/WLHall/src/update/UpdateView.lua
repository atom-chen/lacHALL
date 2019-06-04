--更新进度界面
local ViewBase = require("common.ViewBase")
local UpdateView = class("UpdateView", ViewBase)

UpdateView.RESOURCE_FILENAME = "ui/loading/loading_node.lua"
UpdateView.RESOURCE_BINDING = {
    ["logo_node"] = { ["varname"] = "logo_node" }, 
    ["img_logo"] = { ["varname"] = "img_logo" },
    ["btn_contact"] = { ["varname"] = "btn_contact", ["events"] = { { event = "click", method = "onClickCustomService_" } } }, -- 联系客服
    ["btn_repair"] = { ["varname"] = "btn_repair", ["events"] = { { event = "click", method = "onClickFix_" } } }, -- 修复
}

function UpdateView:onCreate(onremovecallback)
    self.logo_node:posByScreen(cc.p(Alignment.LEFT, Alignment.TOP), 0, -250)
    self.btn_contact:posByScreen(cc.p(Alignment.RIGHT, Alignment.TOP), -121, -57)
    self.btn_repair:posByScreen(cc.p(Alignment.RIGHT, Alignment.TOP), -285, -57)
    local banhao,benan=gg.LocalConfig:GetCopyRightInfo()
    self.logo_node:findNode("text_approval1"):setString(banhao)
    self.logo_node:findNode("text_approval2"):setString(benan)
    if BRAND==0 then
        self.img_logo:loadTexture(CUR_PLATFORM.."/img_logo.png",0)
    end
    if onremovecallback then
        self:addRemoveListener(onremovecallback)
    end

    self:addEventListener("event_update_progress_changed",handler(self, self.onEventUpdateProgressChanged_))

    -- 开关检测
    self:checkSwitch()
end

-- 隐藏修复和联系客服按钮
function UpdateView:checkSwitch()
    self.btn_repair:setVisible( false )
    self.btn_contact:setVisible( false )
end

function UpdateView:onEventUpdateProgressChanged_(event,filesize, downloadsize, speed,percent) 
    if percent>0 then
        self:setPercent(percent):setTotal(downloadsize,filesize):setDesc("正在更新...")
    end
end

-----------------------------------------------
-- 载入文本
-----------------------------------------------
function UpdateView:initLoadingTxt( )
    self._darkBg = cc.LayerColor:create( cc.c4b( 0,0,0,177 ) )
    if display.width/display.height == 4/3 then
        self._darkBg:setContentSize( cc.size( display.width, 123 ) )
    else
        self._darkBg:setContentSize( cc.size( display.width, 140 ) )
    end
    self:addChild( self._darkBg )

    local loading = require("ui/common/loading.lua").create()
    self._loadingNode = loading.root
    self._loadingNode = loading.root:setPosition( display.cx - 20, 140 )
    self._loadingNode:runAction( loading.animation )
    loading.animation:gotoFrameAndPlay(1)
    self:addChild( self._loadingNode ) 

    local txt_msg = self._loadingNode:getChildByName( "txt_msg" )
    txt_msg:setString( "加载中 ·" )
    txt_msg:setAnchorPoint( cc.p( 0,0.5 ) )
    txt_msg:setOpacity( 200 )

    local nd_img = self._loadingNode:getChildByName( "nd_img" ):setScale( 0.7 )
    nd_img:setPosition( cc.p( nd_img:getPositionX() - 25, nd_img:getPositionY() - 70 ) )

    self:startLodingTimer()
end

function UpdateView:startLodingTimer( )
    self._times = 0
    if self._timer then
        self._timer:killAll()
    else
        self._timer = require("common.utils.Timer").new()
    end
    self._timer:start( handler( self, self.aniDotLoading ), 1 )
end

function UpdateView:aniDotLoading( )
    if self._times then
        local txt = self._loadingNode:getChildByName( "txt_msg" )
        if self._times % 3 == 0 then
            txt:setString( "加载中 ·" )
        elseif self._times % 3 == 1 then
            txt:setString( "加载中 · ·" )
        elseif self._times % 3 == 2 then
            txt:setString( "加载中 · · ·" )
        end
        self._times = self._times + 1
    end
end

function UpdateView:clearTimer() 
    if self._loadingNode then
        self._loadingNode:setVisible( false )
    end
    if self._timer then
        self._timer:killAll()
    end
end

-----------------------------------------------
-- 进度条
-----------------------------------------------
-- 设置更新进度条
function UpdateView:initLoadingWidget()
    self:clearTimer()
    if self.progress then
        return
    end
    local LoadingProgress = require("common.widgets.LoadingProgress")
    self.progress = LoadingProgress.new(self:getScene(), "LoadingProgress"):addTo(self):move(display.cx, 20 * display.scaleY)
    self.progress:setWidth(display.width)
    self:setProgressVisible(true)
    self:setPercent(1)
    self:setDesc("正在更新中...")
end

-- 进度条是否可见
function UpdateView:setProgressVisible(visible)
    if self.progress then
        self.progress:setVisible(visible)
    end
    return self
end

--0-100  
function UpdateView:setPercent(percent)
	self.progress:setPercent(percent)  
    return self
end

-- 设置更新大小
function UpdateView:setTotal( curnum, total ) 
    self.progress:setTotal(string.format( " %0.2fKB" , curnum/(1024)),  string.format( "%0.2fKB" , total/(1024)) )
    return self
end

-- 设置提示
function UpdateView:setDesc( desc )
    self.progress:setDesc( desc )
    return self
end

--联系客服
function UpdateView:onClickCustomService_(...)
    device.callCustomerServiceApi(ModuleTag.Update) 
    printf("UpdateView:onClickCustomService")
end

function UpdateView:onClickFix_(...) 
    printf("----------click fix")
end

function UpdateView:onCleanup()
    self.progress=nil
    self:clearTimer()
end
return UpdateView