--
-- Author: Cai
-- Date: 2017-06-05
-- Describe：招商界面

local JoinApplyView = class("JoinApplyView", cc.load("ViewPop"))

JoinApplyView.CLOSE_ANIMATION = true
JoinApplyView.RESOURCE_FILENAME = "ui/hall/join_apply_view.lua"
JoinApplyView.RESOURCE_CLICK_SOUND = "res/common/audio/ui_click.mp3"
JoinApplyView.RESOURCE_BINDING = {
	["img_bg"]     = { ["varname"] = "img_bg" 	  },
    ["pv_picture"] = { ["varname"] = "pv_picture" },      -- 顶部图片滚动
    ["txt_wx"]     = { ["varname"] = "txt_wx"     },      -- 微信号
    ["btn_copy"]   = { ["varname"] = "btn_copy",  ["events"] = { { ["event"] = "click_color", ["method"] = "onClickCopy"  } } },
	["btn_close"]  = { ["varname"] = "btn_close", ["events"] = { { ["event"] = "click_color", ["method"] = "onClickClose" } } },
}

function JoinApplyView:onCreate( )
	self:init()
    self:initView()
end

function JoinApplyView:init( )
	-- 微信号
	self._wechatID = nil
    -- 分页符
    self._pageBreak = nil
    -- 当前显示的页码
    self._pageIdx = 1
end

function JoinApplyView:initView( )
    local callback = function(result)
        if tolua.isnull(self) then return end
        if checkint(result.status)==0 then
            -- 设置滚动图片
            self:initPicturePageView( result.data )
            -- 开启图片轮播计时器
            if #result.data > 1 then
                self:startTimer()
            end
        else
            self.loadingNode:setVisible(false)
            GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "数据加载失败")
        end
    end
    self:addLoadingLabel()
    gg.Dapi:GetAgentAdUrl( callback )
    -- 设置微信号文本显示
    self:setWechatId()
end

function JoinApplyView:startTimer( )
    if self.timer_ then
        self.timer_:killAll()
    else
        local Timer = require("common.utils.Timer")
        self.timer_ = Timer.new()
    end
    self.timer_:start( handler(self,self.autoScrollView), 6 )
end

function JoinApplyView:autoScrollView( )
    local index = self.pv_picture:getCurrentPageIndex()
    self.pv_picture:scrollToPage( index+1 )
end

function JoinApplyView:onExit()
    if self.timer_ then
        self.timer_:killAll()
        self.timer_ = nil
    end
end

function JoinApplyView:addLoadingLabel()
    self.loadingNode = cc.Label:createWithSystemFont("加载中...", "Arial", 30)
    self.loadingNode:setName("loadingNode")
    self.loadingNode:setTextColor(cc.c3b(78, 78, 78))
    self.img_bg:addChild(self.loadingNode)
    self.loadingNode:setPosition(cc.p(self.img_bg:getContentSize().width / 2, self.img_bg:getContentSize().height / 2 + 90))
end

function JoinApplyView:initPicturePageView( urlTb )
    urlTb = urlTb or {}
    -- 创建滚动图片，其中第一张为最后一张图片，最后一张为第一张图片
    local totalPic = #urlTb
    if totalPic==1 then
        local pic = ccui.ImageView:create()
        pic:ignoreContentAdaptWithSize( false )
        pic:setContentSize( self.pv_picture:getContentSize() )
        self.pv_picture:addPage(pic)
        gg.ImageDownload:LoadHttpImageAsyn( urlTb[1], pic, function()
            if tolua.isnull(self) then return end
            if self.loadingNode then
                self.loadingNode:setVisible(false)
            end
        end )
    else
        for i=1,totalPic+2 do
            local pic = ccui.ImageView:create()
            pic:ignoreContentAdaptWithSize( false )
            pic:setContentSize( self.pv_picture:getContentSize() )
            self.pv_picture:addPage(pic)
            if i==1 then
                gg.ImageDownload:LoadHttpImageAsyn( urlTb[totalPic], pic, function()
                    if tolua.isnull(self) then return end
                    if self.loadingNode then
                        self.loadingNode:setVisible(false)
                    end
                end )
            elseif i==(totalPic+2) then
                gg.ImageDownload:LoadHttpImageAsyn( urlTb[1], pic, function()
                    if tolua.isnull(self) then return end
                    if self.loadingNode then
                        self.loadingNode:setVisible(false)
                    end
                end )
            else
                gg.ImageDownload:LoadHttpImageAsyn( urlTb[i-1], pic, function()
                    if tolua.isnull(self) then return end
                    if self.loadingNode then
                        self.loadingNode:setVisible(false)
                    end
                end )
            end
        end
        self.pv_picture:setCurrentPageIndex( 1 )

        -- 添加分页切页标识
        if self._pageBreak then
            self._pageBreak:removeFromParent()
            self._pageBreak = nil
        end
        if totalPic > 1 then
            local pageBreak = require("common.widgets.PageLabel"):create( "hall/common/ico_point2.png", "hall/common/ico_point1.png", 38, totalPic, 0 )
            pageBreak:setPosition( cc.p( self.img_bg:getContentSize().width / 2, 195 ) )
            self._pageBreak = pageBreak
            self.img_bg:addChild( pageBreak )
        end

        -- 添加滚动层监听事件
        local function pageViewEvent( sender, eventType )
            if tolua.isnull(self) then return end
            if eventType == ccui.PageViewEventType.turning then
                local pageView = sender
                local index = pageView:getCurrentPageIndex()
                if index==0 then
                    gg.InvokeFuncNextFrame( function()
                        self.pv_picture:setCurrentPageIndex( totalPic )
                    end )
                elseif index==(totalPic+1) then
                    gg.InvokeFuncNextFrame( function()
                        self.pv_picture:setCurrentPageIndex( 1 )
                    end )
                end

                if self._pageBreak then
                    if index==0 then
                        self._pageBreak:setIndex( totalPic )
                    elseif index==(totalPic+1) then
                        self._pageBreak:setIndex( 0 )
                    else
                        self._pageBreak:setIndex( index-1 )
                    end
                end
            end
        end
        self.pv_picture:addEventListener( pageViewEvent )
    end
end

-- 设置微信号
function JoinApplyView:setWechatId( )
    local tbs = gg.LocalConfig:GetServiceInfo()
    local str_wx = checktable(tbs[1])[1]
    if str_wx then
        local subPos = string.find( str_wx, ":" )
        if not subPos then
            subPos = string.find( str_wx, "：" )
            if subPos then
                str_wx = string.sub( str_wx, subPos+3 )
            end
        else
            str_wx = string.sub( str_wx, subPos+1 )
        end
        self._wechatID = str_wx
        self.txt_wx:setString( tostring( self._wechatID ) )
    end
end

-- 复制兑换码
function JoinApplyView:onClickCopy( sender )
	if self._wechatID then
		Helper.CopyToClipboard( self._wechatID )
        GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG, "复制成功！请粘贴到微信，添加好友。")
	end
end

-- 关闭
function JoinApplyView:onClickClose( )
	self:removeSelf()
end

return JoinApplyView
