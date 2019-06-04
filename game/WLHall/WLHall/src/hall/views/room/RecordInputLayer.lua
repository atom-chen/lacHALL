--Author:陈吉塔
--Date:2018 3.13 16:00:00
--Descrlibe:查看他人战绩

local RecordInputLayer = class("RecordInputLayer", cc.load("ViewBase"))

RecordInputLayer.RESOURCE_FILENAME = "ui/recordstatistics/record_input_layer.lua"

RecordInputLayer.RESOURCE_BINDING = {
    ["lay_touch"] = { ["varname"] = "lay_touch" },
    ["search_bg"] = { ["varname"] = "search_bg" },
    ["tf_bg"] = { ["varname"] = "tf_bg" },
    ["btn_search"] = { ["varname"] = "btn_search", ["events"] = { { ["event"] = "click", ["method"] = "onClickSearch" } } },
}


function RecordInputLayer:onCreate()

    -- 初始化
    self:init()

    -- 初始化View
    self:initView()

end

--[[
* @brief 初始化
]]
function RecordInputLayer:init()
    self._callback = nil
    self._searchTf = nil
end

--[[
* @brief 初始化View
]]
function RecordInputLayer:initView()

    local size = cc.size( self.tf_bg:getContentSize().width , self.tf_bg:getContentSize().height )
    self._searchTf = self:createTextField( size, "请输入回放码", cc.EDITBOX_INPUT_MODE_NUMERIC ):addTo( self.tf_bg )

    -- 点击收起
    self.lay_touch:addTouchEventListener(function( sender, eventType )
        if eventType == ccui.TouchEventType.ended then
            self:closeView()
            if self._callback then
                self._callback()
            end
        end
    end)

end

function RecordInputLayer:setCallback( callback )
    self._callback = callback
end

function RecordInputLayer:showView( )
    -- 停止之前的动画
    self.search_bg:stopAllActions()
    self.lay_touch:stopAllActions()
    -- 执行动画
    self.lay_touch:setVisible( true )
    self.lay_touch:runAction( cc.FadeIn:create( 0.2 ) )
    self.search_bg:runAction( cc.MoveTo:create( 0.2, cc.p(0, self.lay_touch:getContentSize().height) ) )
end

function RecordInputLayer:closeView( )

    -- 停止之前的动画
    self.search_bg:stopAllActions()
    self.lay_touch:stopAllActions()

    -- 执行动画
    self.search_bg:runAction( cc.MoveTo:create( 0.11, cc.p(0, self.lay_touch:getContentSize().height+135) ) )
    self.lay_touch:runAction( cc.Sequence:create(cc.FadeOut:create( 0.2 ), cc.Hide:create()) )
end

-- 创建输入框
function RecordInputLayer:createTextField( size, placeholder, inputMode, inputflag )
    local tf = ccui.EditBox:create(size, "_")
    tf:setPosition( cc.p( 20, size.height / 2 ) )
    tf:setAnchorPoint( cc.p(0, 0.5) )
    tf:setPlaceHolder( placeholder or "" )
    tf:setInputMode( inputMode or cc.EDITBOX_INPUT_MODE_EMAILADDR )
    tf:setInputFlag( inputflag or cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_ALL_CHARACTERS )
    tf:setPlaceholderFontColor( cc.c3b( 162, 159, 158 ) )
    tf:setPlaceholderFontSize( 28 )
    tf:setFontColor( cc.c3b( 34, 34, 34 ) )
    tf:setFontSize( 28 )
    return tf
end

function RecordInputLayer:onClickSearch( sender )
    gg.AudioManager:playClickEffect()
    local record_id = self._searchTf:getText()
    if not record_id or record_id=="" then
        self:showToast("请输入回放码！")
        return
    end

    local callback = function(result)
        if tolua.isnull(self) then return end
        if result.status ~= 0 then
            gg.ShowLoading(self:getScene())
            self:showToast( result.msg )
            printf("---error:第一次请求对战局数数据失败")
            return
        end
        if result.status == 0 and result.total == 0 then
            gg.ShowLoading(self:getScene())
            self:showToast( "暂无回放数据！" )
            printf("---error:第一次请求返回的总局数为0")
            return
        end

        local data = checktable(result.data)
        -- 判断是否有这个游戏
        local games = hallmanager.games[ checkint( data.gameid ) ]
        if not games then
            gg.ShowLoading(self:getScene())
            self:showToast( "未找到相应的游戏！" )
            printf("---error:找不到对应的gameid=%d的游戏",checkint( data.gameid ))
            return
        end
        -- 检测是否有回放功能
        local path = string.format( "games.%s.replay.config", tostring(games.shortname) )
        local ok, config = pcall( function( )
            return require( path )
        end )
        if not ok then
            gg.ShowLoading(self:getScene()) -- 关闭Loading
            self:showToast( "游戏未下载或暂不支持回放功能。" )
            print(ok, config)
            return
        end

        local replayMgrPath = nil
        if Helper.And( games.type , GAME_GROUP_POKER ) ~= 0 then
            replayMgrPath = "games.common.pkReplay.ReplayManager"
        elseif Helper.And( games.type , GAME_GROUP_MAHJONG ) ~= 0 then
            replayMgrPath = "games.mj_common.replay.ReplayManager"
        else
            self:showToast("该类别游戏暂不支持回放功能!")
            printf("该游戏不属于麻将或者扑克类！！！")
            return
        end

        local existReplayMgr, ReplayManager = pcall(function( )
            return require(replayMgrPath)
        end)
        if not existReplayMgr then
            gg.ShowLoading(self:getScene()) -- 关闭Loading
            self:showToast("该游戏暂不支持回放功能!")
            print(existReplayMgr, ReplayManager)
            return
        end

        local manager = ReplayManager:create()
        local total = result.total -- 总局数
        local token = hallmanager:GetSession()
        local userId = hallmanager.userinfo.id
        manager:setDownPlayerId(userId)

        -- 请求参数
        local postData = {}
        postData.record_id = record_id
        postData.index = 0

        manager:setConfig(config, total, data, postData)
        local url = gg.Dapi:GetUserApiUrl("/record/download")

        gg.Dapi:SendRequest(gg.Dapi.METHOD_POST, url, function(code, msg)
            printf("GameRecordStatisticsView code= %s ,msg =%s", tostring(code),tostring( msg))
            if tolua.isnull(self) then return end
            if code ~= 200 then
                GameApp:dispatchEvent(gg.Event.SHOW_TOAST, msg or "数据读取失败")
                gg.ShowLoading(self:getScene())
                return
            end
            local isLoad = manager:parseData(msg)
            if isLoad then
                gg.ShowLoading(self:getScene())
                if self._callback then
                    self._callback()
                end
                manager:runScene()
            else
                gg.ShowLoading(self:getScene())
                self:showToast( "回放数据加载失败！" )
            end
        end, postData, 10, 1)
    end

    gg.ShowLoading( self:getScene(), "数据读取中...", 15 )
    gg.Dapi:FastSearchRecord( record_id, -1, callback )
end

return RecordInputLayer