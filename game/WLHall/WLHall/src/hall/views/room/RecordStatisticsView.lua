
-- Author: 李阿城
-- Date: 2017/11/20  10:50:30
-- Describe：房间战绩统计界面

local RecordStatisticsView = class("RecordStatisticsView",cc.load("ViewBase"))

RecordStatisticsView.RESOURCE_FILENAME = "ui/recordstatistics/record_statistics.lua"

RecordStatisticsView.RESOURCE_BINDING = {
    ["lv_record"] = { ["varname"] = "lv_record" },
    ["txt_record_tips"] = { ["varname"] = "txt_record_tips" },      -- 暂无统计数据提示文本

}

-- 字符串转时间
local function string2time( str )
    local Y = string.sub( str, 1, 4 )
    local M = string.sub( str, 6, 7 )
    local D = string.sub( str, 9, 10 )
    local h = string.sub( str, 12, 13 )
    local m = string.sub( str, 15, 16 )
    local s = string.sub( str, 18, 19 )
    local time = os.time( { year=Y, month=M, day=D, hour=h, min=m, sec=s } )
    return time
end

-- 排序
local sortList = function (a,b)
    local bo = string2time( a.time ) > string2time( b.time )
    return bo
end

function RecordStatisticsView:onCreate( game,page )
    self.page = page
    -- 拉取数据
    self:PullData()
    -- 隐藏滚动条
    self.lv_record:setScrollBarEnabled(false)
end

--[[
* @brief 拉取网络数据
]]
function RecordStatisticsView:PullData()
    -- 拉取数据
    gg.Dapi:RecordFriend( nil,function( result )
        if tolua.isnull(self) then return end
        if not result then return end
        if result.status and checkint(result.status) ~= 0 then
            self.txt_record_tips:show()
            print( "战绩数据拉取错误："..result.msg )
            return
        end
        self:initView( checktable(result.data) )
    end )
end


--[[
* @brief 初始化界面
* @param data 数据
]]
function RecordStatisticsView:initView( data )
    if table.nums( data ) > 0 then
        self.txt_record_tips:setVisible( false )
    else
        self.txt_record_tips:show()
    end
    table.sort( data, sortList )
    for i,v in ipairs(data) do
        local item = self:createAddedItem( v )
        self.lv_record:pushBackCustomItem( item )
    end
end

--[[
* @brief 创建战绩统计item
* @param data 数据
]]
function RecordStatisticsView:createAddedItem( data )
    local node = require("res/ui/recordstatistics/statistic_image.lua").create()
    local item_record = node.root:getChildByName("item_record")

    item_record.data = data
    -- 判断是否有这个游戏
    local games = checktable(hallmanager.games[ checkint( data.game_id ) ])
    -- 游戏名
    local txt_game = item_record:getChildByName("txt_game")
    local strName = gg.SubUTF8StringByWidth( "未知游戏", 100, 24, "" )
    txt_game:setString( tostring( games.name or "未知游戏") )

    -- 房号
    local txt_roomid = item_record:getChildByName("txt_roomid")
    txt_roomid:setString( "房号:".. string.format("%06d", data.roomid or 0) )
    txt_roomid:setPositionX(txt_game:getPositionX() + txt_game:getSize().width +30)
    
    -- 时间
    local txt_time = item_record:getChildByName("txt_time")
    txt_time:setString( data.time or "0000:00:00 00:00:00")

    -- 回放码
    local txt_record_code = item_record:findNode("txt_record_code")
    txt_record_code:setString( string.format("回放码:%s", tostring(data.record_id)) )
    txt_record_code:setPositionX(txt_roomid:getPositionX() + txt_roomid:getSize().width +30)

    local is5P = data.players and #data.players > 4
    local offset_width = gg.IIF(is5P, 213, 245)  -- 每个玩家item间距

    -- 玩家数据
    for i,v in ipairs( checktable(data.players) ) do
        local palyerNode = self:createPlayerNode(v, #data.players)
        palyerNode:addTo(item_record)
        palyerNode:setPosition(15 + (i-1)*offset_width, 15)
    end

    --回放按钮
    local btn_hf = item_record:getChildByName("btn_hf")
    btn_hf:onClickScaleEffect( function( )
        self:onClickPlayback( data ,games )
    end )
    if #data.players>=5 then --大于等于5个人的时候，隐藏回放按钮
        btn_hf:setVisible(false)
    end
    item_record:removeFromParent( true )

    gg.LineHandle(item_record:getChildByName("line_img"))

    return item_record
end

--[[
* @brief palyerData 玩家数据
* @brief count 玩家个数
]]
function RecordStatisticsView:createPlayerNode(palyerData, count)
    local node = require("res/ui/recordstatistics/statistic_node.lua").create().root

    -- 玩家名字
    local uname = node:getChildByName( "txt_uname" )
    local strName = gg.SubUTF8StringByWidth( palyerData.nickname, 90, 22, "" )
    uname:setString( strName )

    -- 玩家id
    local uid = node:findNode( "txt_uid" )
    uid:setString( palyerData.user_id )

    -- 得分
    local score = node:getChildByName( "txt_score" )
    if palyerData.score then
        if checkint(palyerData.score)>=0 then
            score:setString( "+"..tostring( palyerData.score ) )
            score:setTextColor( cc.c3b( 204,56,56 ) )
        else
            score:setString( tostring( palyerData.score ) )
            score:setTextColor( cc.c3b( 72,147,233 ) )
        end
    end

    -- 设置头像
    local nd_avatar = node:getChildByName( "img_avatar" )
    local avatarPath = gg.IIF( checkint(palyerData.sex) == 1, "common/hd_male.png", "common/hd_female.png" )
    nd_avatar:loadTexture( avatarPath )
    if palyerData.avatar and palyerData.avatar ~= "" then
        avatarPath = palyerData.avatar
        --拉取网络图片
        gg.ImageDownload:LoadUserAvaterImage({url=avatarPath,ismine=false,image=nd_avatar})
    end

    -- 玩家人数超过5人的游戏item和其他人数item坐标调整
    local img_bg_1 = node:getChildByName("Image_1")
    local img_bg_2 = node:getChildByName("Image_2")
    img_bg_1:setVisible(count > 4)
    img_bg_2:setVisible(count <= 4)
    nd_avatar:setPositionX(gg.IIF(count > 4, 5, 10))
    uname:setPositionX(nd_avatar:getPositionX() + nd_avatar:getContentSize().width + 5)
    uid:setPositionX(nd_avatar:getPositionX() + nd_avatar:getContentSize().width + 3)
    score:setPositionX(gg.IIF(count > 4, 200, 225))

    return node
end

--[[
* @brief 回放按钮
]]
function RecordStatisticsView:onClickPlayback( data ,game )
    self.curPlayData = nil
    self.curPlayGame = nil

    if not hallmanager then
        self:showToast( "回放功能暂未开放！" )
        return
    end

    if not game.shortname then
        self:showToast( "找不到相应的游戏。" )
        return
    end

    local isNeedUpdate, msg = hallmanager:CheckGameNeedUpdate(game)
    if isNeedUpdate then
        -- 记录回放点击数据，更新完成之后模拟点击，清除该数据
        self.curPlayData = data
        self.curPlayGame = game
        -- 显示更新
        GameApp:dispatchEvent(gg.Event.SHOW_LOADING, "数据加载中...")
        hallmanager:DoUpdateGame(game)
        return
    end

    self:playReplayGame(data ,game)

end

function RecordStatisticsView:playReplayGame(data, game)
    -- 判断是否有回放功能
    local path = string.format( "games.%s.replay.config", tostring(game.shortname) )
    local ok, file = pcall( function( )
        return require( path )
    end )
    local config
    if ok then
        config = file
    else
        gg.ShowLoading(self:getScene()) -- 关闭Loading
        print(ok, file)
        self:showToast( "此游戏暂无回放功能！" )
        return
    end

    gg.ShowLoading(self:getScene(), "数据读取中...", 15 )

    local callback = function( result, url )
        if tolua.isnull(self) then return end
        if result.status ~= 0 then
            gg.ShowLoading(self:getScene())
            print("请求数据失败")
            return
        end

        if result.total and checkint(result.total) == 0 then
            gg.ShowLoading(self:getScene())
            -- self:showToast( "暂无回放数据！" )
            return
        end

        local replayMgrPath = nil
        if Helper.And( game.type , GAME_GROUP_POKER ) ~= 0 then
            replayMgrPath = "games.common.pkReplay.ReplayManager"
        elseif Helper.And( game.type , GAME_GROUP_MAHJONG ) ~= 0 then
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
            gg.ShowLoading(self) -- 关闭Loading
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
        postData.hashcode = data.hashcode
        postData.index = 0

        manager:setConfig(config, total, data, postData)

        local url = gg.Dapi:GetUserApiUrl("/record/download")

        gg.Dapi:SendRequest(gg.Dapi.METHOD_POST, url, function(code, msg)
            print("GameRecordStatisticsView code=", code, msg)
            if tolua.isnull(self) then return end
            if code ~= 200 then
                GameApp:dispatchEvent(gg.Event.SHOW_TOAST, msg or "数据读取失败")
                gg.ShowLoading(self:getScene())
                return
            end

            local isLoad = manager:parseData(msg)
            if isLoad then
                gg.ShowLoading(self:getScene())
                manager:runScene()
            else
                gg.ShowLoading(self:getScene())
                self:showToast( "回放数据加载失败！" )
                print("获取数据失败")
            end
        end, postData, 10, 1)

    end

    local hashcode = data.hashcode
    local index = -1
    gg.Dapi:RecordDownload(hashcode, index, callback)
end

-- 更新完成
function RecordStatisticsView:doUpdateFinish(event, shortname, error_)
    GameApp:dispatchEvent(gg.Event.SHOW_LOADING)
    if not error_ then
        if self.curPlayData and self.curPlayGame then
            self:onClickPlayback(self.curPlayData, self.curPlayGame)
        end
        return
    end
    self:showToast( "游戏数据加载失败！" )
    -- 清空记录数据，防止其他界面进行游戏更新时，切换至战绩界面时刚好更新完成，自动打开回放
    self.curPlayData = nil
    self.curPlayGame = nil
end

return RecordStatisticsView
