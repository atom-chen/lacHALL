-- Author: lee
-- Date: 2016-12-14 15:09:06
local MSG_ID=import(".HallMsg")
local e = {}

--事件表
--大厅初始化
function e.Initialize(hall)
	return hall:init()
end

function e.Shutdown(hall)
    hall.isConnected_=nil
end

--连接到大厅服务器结果
function e.OnConnect( obj,bConnected )
    if not bConnected then
        GameApp:dispatchEvent(gg.Event.NETWORK_ERROR,NET_ERR_TAG_HALL,-4)
    end
end

--与大厅服务器连接断开
function e.OnSocketClose( obj,nErr )
    obj.isConnected_=false
    printf(" hallevent OnSocketClose code= "..nErr)
    -- 断线通知
    GameApp:dispatchEvent(gg.Event.NETWORK_ERROR,NET_ERR_TAG_HALL,nErr)
    if obj.roommanager and obj.roommanager:IsClientRunning() then
        --todo 通知游戏断线
    end
end

--[[
* @brief 登陆到大厅成功
* @param hall 大厅对象
* @param lastroomid 最后断线房间ID,如果为0,则非断线重连状态
--]]
function e.OnJoinHall( hall,lastroomid )
    -- 记录玩家累计的在线时长以及当前时间戳
    cc.exports.USER_TIRE_TIME = hall.userinfo.usertiretime
    cc.exports.LAST_RECORD_TIRETIME_STAMP = os.time()

    -- 记录用户已勾选阅读用户协议选项
    if checkint(cc.UserDefault:getInstance():getIntegerForKey("AgreeUserProtocol")) ~= 1 then
        cc.UserDefault:getInstance():setIntegerForKey("AgreeUserProtocol", 1)
    end

    -- 调用禁赌博广播
    -- 2018-10-09 断线重连状态不播放
    local scene = GameApp:getRunningScene()
    if scene and scene.doGambleBroadcast and (not GameApp:IsReconnecting()) then
        scene:doGambleBroadcast()
    end

    local curRegion = gg.LocalConfig:GetRegionCode()
    if REGION_CODE == 0 and hall.cityid ~= 0 and curRegion ~= 0 and curRegion ~= hall.cityid then
        -- 选择的地区跟服务器不一样，需要刷新本地数据，并重新走一遍版本检查和登录流程
        -- 这里需要先刷新重连状态，认为此次重连结束。然后再走一遍重连的流程。
        -- 否则，直接重连可能不会有任何效果。
        -- 如果是家乡棋牌产品才需要以服务器为准，地区产品以本地记录的地区码为准
        gg.LocalConfig:SetRegionCode( hall.cityid )
        GameApp:UpdateReconnectState(false, true)
        GameApp:ReconnectToHall(nil, true, true)
        return
    else
        hall.isConnected_=true
        if not IS_REVIEW_MODE and hall.cityid == 0 and curRegion ~= 0 then
            -- 非审核模式下，服务器选择的地区码为0时，无法获取游戏配置，重新上传地区码给服务端
            gg.Dapi:UserRegion(curRegion, function(result)
                if result.status and tonumber(result.status) == 0 then
                    GameApp:UpdateReconnectState(false, true)
                    GameApp:ReconnectToHall(nil, true, true)
                end
            end)
        end
    end

    -- 拉取cfg_game配置
    gg.GameCfgData:PullGameCfg()
    -- 拉取荣誉等级奖励配置
    gg.HonorHelper:getHonorRewardCfg()

    local userinfo = hall.userinfo
    local isingame=checkint(lastroomid)>0
    if not (GameApp:IsReconnecting()) then
         --大厅正常登录 或 正常退出断线 成功
        if userinfo.userfrom == USER_FROM_UNLOGIN or userinfo.userfrom == USER_FROM_PLATFORM or userinfo.userfrom == USER_FROM_JIXIANG  then
            local cookiedata={sex= (userinfo.sex == 1),id=userinfo.id,nick=userinfo.nick,avatarurl=userinfo.avatarurl}
            gg.Cookies:UpdateUserData(cookiedata)
        end
    end
    --if not IS_LOCAL_TEST then
        gg.UserData:initWebData()
    --end
    local rooms = hall.rooms

    hall:UpdateGameList()--刷新游戏列表数据
    GameApp:dispatchEvent(gg.Event.HALL_UPDATE_USER_DATA,hall.userinfo)
    GameApp:dispatchEvent(gg.Event.SHOW_LOADING)
    hall:GetUserGameInfo("erdz")
    GameApp:dispatchEvent(gg.Event.HALL_JOIN_HALL_SUCCESS,hall.userinfo)
------------------------------------------------------
    -- 输出游戏信息
    local function dumpGameInfo_(hall,rooms)
        for k,room in pairs(rooms) do
            local game= hall.games[room.gameid]
            if game   then
                printf("room.id=%s,game.id=%s, %s,%s,shortname=%s,version=%s ",room.id,game.id,game.name,room.name,game.shortname,game.version)
            end
        end
    end
    --输出游戏信息日志
    dumpGameInfo_(hall,hall.rooms)

    printf("-----用户Session:"..hall.session.."  lastroomid:"..checkint(lastroomid))
    printf("--userinfo"..json.encode(hall.userinfo))

    -- for k , v in pairs( hallmanager.games ) do
    --     print( v.name..":"..v.id)
    -- end

    -- 快速测试
    local QuickTest = require("QuickTest")
    if QuickTest:canQuickTest() then
        if QuickTest:getGameId()  and not (GameApp:IsReconnecting())  then
            hallmanager:JoinGame(QuickTest:getGameId(), nil)
        else
            local room = hall.rooms[checkint(QuickTest:getRoomId())]
            if room and not (GameApp:IsReconnecting()) then
                 hall:JoinRoom(room.id,(GameApp:IsReconnecting()))
                 GameApp:UpdateReconnectState(isingame, not isingame )
                 return
            end
        end
    end
 ----------------------------------------------------------

    if hall.onconnectedcallback_ then
        hall.onconnectedcallback_(isingame)
    end
    if checkint(lastroomid)>0 then -- do connect to room
        local room = hall.rooms[lastroomid]

        -- 游戏下载的回调处理
        local function statusCallback(status, shortname, err)
            -- 2 表示 GameDownloader.FINISH
            if status == 2 then
                if err then
                    -- 游戏下载失败，提示用户
                    GameApp:dispatchEvent(gg.Event.HALL_ON_JOIN_HALL)
                    GameApp:UpdateReconnectState(isingame, not isingame )
                    GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG, "无法进入游戏，请联系客服！")
                else
                    -- 游戏下载完成了，进入游戏
                    hall:JoinRoom(checktable(room).id,(GameApp:IsReconnecting()))
                end
            end
        end
        local function errorHandler(msg)
            -- 游戏下载失败，提示用户
            GameApp:dispatchEvent(gg.Event.HALL_ON_JOIN_HALL)
            GameApp:UpdateReconnectState(isingame, not isingame )
            GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG, msg)
        end

        local canJoin, update = hall:CheckCanJoinGame(checktable(room).gameid, true, statusCallback, errorHandler)
        if canJoin then
           hall:JoinRoom(checktable(room).id,(GameApp:IsReconnecting()))
        elseif update then
            -- 游戏更新中，在更新的回调中进行状态检查与处理
        else
            -- 游戏不存在，也无法下载，提示用户
            GameApp:dispatchEvent(gg.Event.HALL_ON_JOIN_HALL)
            GameApp:UpdateReconnectState(isingame, not isingame )
            GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG, "无法进入游戏，请联系客服！")
        end
    else
        printf("----已不在游戏中 如果是游戏场景，通知游戏客户端销毁场景----")
        GameApp:dispatchEvent(gg.Event.HALL_ON_JOIN_HALL)
        GameApp:UpdateReconnectState(isingame, not isingame )
        if gg.LocalConfig:GetRegionCode()>0  then
            local schemeuri=device.getUrlScheme()
            if (#checkstring(schemeuri))>0  then
                GameApp:HandleUrlScheme(schemeuri)
            end
        end
    end

    if not GameApp:CheckModuleEnable(ModuleTag.Room) and DEFAULT_GAME_ID then
        local function showGameList_()
            GameApp:getRunningScene():getChildByName("HallMainView"):enterGameAction()
            GameApp:getRunningScene():getChildByName("HallFrameView"):joinGameRoom()
            GameApp:getRunningScene():createView("newhall.HallGameListView"):pushInScene()
        end

        local game = hallmanager.games[DEFAULT_GAME_ID]
        local ok, bupdating = hallmanager:CheckCanJoinGame(game, true, function(state, shortname)
            -- 如果游戏需要更新，那么需要在更新时显示 loading 界面
            -- 并且在更新完成后再次调用 JoinGame 接口
            local GameDownloader= require("update.GameDownloader")
            if state == GameDownloader.WATTING then
                GameApp:dispatchEvent(gg.Event.SHOW_LOADING, "加载中，请稍候...")
            elseif state == GameDownloader.FINISH then
                GameApp:dispatchEvent(gg.Event.SHOW_LOADING)
                showGameList_()
            end
        end)

        if ok and not bupdating then
            showGameList_()
        end
    end

    -- for k , v in pairs( hallmanager.games ) do

    --     print( v.name..":"..v.id)

    --     for m , n in pairs(hallmanager.rooms) do

    --         if n.gameid == v.id and gg.GetRoomMode(n.type) == ROOM_TYPE_FRIEND_TEAM  then
    --             print( "room_id:"..n.id)
    --         end
    --     end
    -- end

    -- 请求比赛房间
    hallmanager:PullPk3RoomInfo()

end

--[[
* @brief 登陆到大厅失败

]]
function e.OnJoinHallFailed( hall,result )
    local loginAlready =1
    local msg
    if result == loginAlready then
        msg = "用户已经登录！"
    else
        msg="登录游戏失败,[错误码:"..tostring(result).."]!"
    end
    printf("OnJoinHallFailed code:"..tostring(result))
    if result == loginAlready or (not (GameApp:IsReconnecting())) then
        GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG,msg,function(bt)
            GameApp:CreateLoginManager(false)
        end,{ name="connect_failed_dialog",backdisable=true})
    else
        GameApp:dispatchEvent(gg.Event.NETWORK_ERROR,NET_ERR_TAG_HALL,-5)
    end
end


--[[
* @brief 退出房间
* @note 该事件仅通知,完毕后将销毁房间,当前事件不需要对房间执行销毁操作
]]
function e.OnExitRoom( hall )
    printf("HallManager:OnExitRoom--- %d",hall.roommanager:GetID())
end

--[[
* @brief 系统消息
* @param [in] msg 消息内容(文本)
* @param [in] msgtype 消息类型
]]
function e.OnSystemMessage( hall,msg,msgtype )

    -- 屏蔽消息
    if not GameApp:CheckModuleEnable( ModuleTag.SysMessage ) then
        return
    end

    if not hall.roommanager then
        GameApp:dispatchEvent(gg.Event.BROADCAST_SYSTEM_MESSAGE,msg,msgtype)
    end
 end

--[[
* @brief 更新房间玩家数量
* @param [in] lst 房间玩家表,key=房间ID,value=玩家数量
]]
function e.OnUpdateRoomPlayers( hall,lst )

    local rooms = hall.rooms
    for k,v in pairs(lst) do
        local room = rooms[k]
        if room then
            room.players = v
        end
    end
    -- 通知更新房间人数
    GameApp:dispatchEvent(gg.Event.HALL_UPDATE_UPDATE_ROOM_PLAYERS , lst)
end

--[[
* @brief 房间添加
* @param [in] hall CHallManager对象
* @param [in] roomid 房间ID
]]
function e.OnMsgAddRoom( hall,roomid )
    GameApp:dispatchEvent(gg.Event.ROOM_UPDATE , roomid)
end

--[[
* @brief 房间移除
* @param [in] roomid 移除的房间ID
]]
function e.OnMsgRemoveRoom( hall,roomid )
    --下面这行保持在最后
    hall.rooms[roomid] = nil
    GameApp:dispatchEvent(gg.Event.ROOM_UPDATE , roomid)
end

--[[
* @brief 进入房间应答
* param [in] result 进入房间结果,为0则成功
* param [in] lockedroomid 仅玩家已经在房间中时,该参数有意义
]]
function e.OnMsgJoinRoom(hall,result,lockedroomid)

    -- 隐藏等待框
    if result~=0 then
        GameApp:dispatchEvent(gg.Event.SHOW_LOADING)
        if GameApp:IsReconnecting() then
            GameApp:dispatchEvent(gg.Event.HALL_ON_JOIN_HALL)
            GameApp:UpdateReconnectState(false, true)
        end
    end
    printf("-----hallmanager OnMsgJoinRoom result= \"%d\" ,lockid= %d",result,checkint(lockedroomid))
    local msg
    local func
    local function exitroom_()
        if hall.roommanager then  --关闭房间管理器
            hall.roommanager:Shutdown()
            hall.roommanager=nil
            printf("OnMsgJoinRoom hall.roommanager Shutdown  set nil ")
        end
    end
    if result==0 then
        -- 加入房间成功，调用 RoomManager 的接口进行通知
        -- 目前捕鱼游戏依赖此通知
        if hall.roommanager and hall.roommanager.JoinRoomSuccess then
            hall.roommanager:JoinRoomSuccess()
        end
        return
    elseif result ==1 then --//特殊情况,玩家在房间内
        local  room = hall.rooms[lockedroomid]
        if room == nil then
            msg="进入房间失败,同一时刻只能进入一个房间!"
        else
            func = function(bttype)
                if(bttype==gg.MessageDialog.EVENT_TYPE_OK) then
                    if hall.roommanager and hall.roommanager.gameid~=room.gameid then
                        hall:JoinGame(room.gameid)
                    end
                    hall:JoinRoom(room.id,(GameApp:IsReconnecting()))
                end
            end
            if hall.roommanager and hall.roommanager.gameid==room.gameid then
                func(1) --进入房间
                return
            else
                -- 如果是断线重连回混房间，无法获取对应的映射房间，暂时隐藏房间名，避免混房间暴露出去
                if checktable(room.cmd).mrl then
                    msg="您正在[".. hall.games[room.gameid].name .."]房间中游戏,暂时无法进入其他房间!"
                else
                    msg="您正在["..hall.games[room.gameid].name .."-"..room.name.."]房间中游戏,暂时无法进入其他房间!"
                end
            end
        end
        exitroom_();
    elseif result == 2 or result == 3 then --//房间满员
        --需要提示推荐房间
        local roomType = gg.GetRoomMode(hall.roommanager:GetRoomType() )
        if roomType == ROOM_TYPE_ALLOCSIT or roomType == ROOM_TYPE_ALLOCSIT2 or roomType == ROOM_TYPE_FREE_MODE then
            -- 金币场房间提示玩家进入推荐房间
            msg="房间人数已满,进入其他房间？"
            local gameid= hall.roommanager.gameid
            local customRoomType = hall.roommanager:GetRoomType()
            local lfunc= function (bt) --查找一个差不多的房间
                if bt==gg.MessageDialog.EVENT_TYPE_OK then
                    hall:JoinRoomByGameId(gameid,nil,nil,nil,nil,customRoomType)
                end
            end
            GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG,msg,lfunc,{ok="进入推荐房间"})
        else
            -- 其他房间，提示玩家房间已满
            GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "房间人数已经满啦！")
        end
        exitroom_();
        return
    elseif result == 4 then--房间有权限要求
        msg = "进入房间失败,您没有权限进入"
    elseif result == 5 then --金钱或者积分不够
        local roomid = checkint(hall.roommanager:GetID())
        local roominfo = checktable(hall.rooms[roomid])
        local gameid = checkint(roominfo.gameid)
        local roocmd= checktable(roominfo.cmd)
        local giftDiamond = checkint(roocmd._MT) == PROP_ID_XZMONEY
        if not IS_REVIEW_MODE and Helper.And(hall.roommanager:GetRoomType(),ROOM_TYPE_MONEY)~=0 then
            --参数1代表 玩家进入房间时，申请救济金。
            GameApp:DoShell(nil, string.format("PayTips://%d&%d&%d&%d&%d",checkint(roocmd.pay),1,gameid,roomid, gg.PayHelper.PayStages.ROOM), giftDiamond)
            exitroom_();
            return
        else
            -- 根据房间要求货币情况来提示相应道具不足
            if giftDiamond then
                msg = "钻石不足，进入房间失败"
            else
                msg = BEAN_NAME.."不足，进入房间失败"
            end
        end
    elseif result == 6 then --金钱或者积分太高
        if Helper.And(hall.roommanager:GetRoomType(),ROOM_TYPE_MONEY)~=0 then
            msg="您的豆豆足够到高级的房间游戏啦！"
            local gameid= hall.roommanager.gameid
            local gametype = hall.roommanager:GetRoomType()
            local lfunc=function (bt)   --查找一个差不多的房间    --进入推荐房间
                if bt==gg.MessageDialog.EVENT_TYPE_OK then
                    hall:JoinRoomByGameId(gameid,nil,nil,nil,nil,gametype)
                end
            end
            GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG,msg,lfunc,{ok="进入推荐房间"})
           exitroom_();
            return
        else
            msg = "进入房间失败,您的积分太高"
        end

    elseif result == 7 then --房间限制进入（一般是临时维护或者时间没到)
        local roomType = gg.GetRoomMode(hall.roommanager:GetRoomType() )
        if  roomType == ROOM_TYPE_PK_MODE1 or roomType == ROOM_TYPE_PK_MODE2 or roomType == ROOM_TYPE_PK_MODE3 or roomType == ROOM_TYPE_PK_MODE4 then
            msg = "暂未开放，请进入其他游戏或稍后进入"
        else
            msg = "房间维护中，请进入其他游戏或稍后进入"
        end
    elseif result == 8 then -- 房间不存在或者已经关闭
        msg = "该房间不存在或者已关闭,请尝试进入其他房间"
    elseif result == 9 or result == 10 then --玩家已在该房间内或者玩家主动取消加入  什么都不做
    elseif result == 11 then --数据不够（一般是报名费不够)
        local room = hall.rooms[hall.roommanager:GetID()]
        local nDataType = tonumber(room.cmd.bmlx)  --期待数据类型
        local strDataValue = room.cmd.bmf  --期待数据值
        if nDataType and strDataValue then --有数据要求
            if nDataType == PROP_ID_PK_TICKET then
                msg="您背包中的参赛券不足"..strDataValue.."个,获取更多参赛券？"
                func=function()  end
            elseif nDataType == PROP_ID_MONEY or nDataType == PROP_ID_XZMONEY then
                local roomid = checkint(hall.roommanager:GetID())
                local roominfo = checktable(hall.rooms[roomid])
                local gameid = checkint(roominfo.gameid)
                local roocmd= checktable(roominfo.cmd)
                GameApp:DoShell(nil, string.format("PayTips://%d&%d&%d&%d&%d",checkint(roocmd.pay),checkint(roocmd.gift),gameid,roomid, gg.PayHelper.PayStages.ROOM))
                return
            elseif nDataType == PROP_ID_LOTTERY then
                msg = "您的礼品券不足"..strDataValue.."个,报名失败!"
            elseif nDataType == PROP_ID_WEEK_PK_CARD then
                msg="报名失败,您的周赛券不够！"
            elseif nDataType == PROP_ID_MONTH_PK_CARD then
                msg = "您的决赛券不足,报名失败"
            else
                msg = "您的报名费不足,报名失败!"
            end
        else
            msg = "您的报名条件不足,报名失败！"
        end
    elseif result == 12 then --当天输赢达到上限
        msg = "您今天的豆豆输赢已达上限,无法进入游戏"
    else
        msg = "进入房间失败,未知错误,请联系客服 "..HOT_LINE
    end
    exitroom_();
    if msg and string.len(msg)>0 then
        func =func or function() end
        GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG,msg,func)
    end
end

--[[
* @brief 离开房间通知
* @param [in] 房间对象
]]
function e.OnMsgLeaveRoom(hall,roommanager,roomid)
    printf("===============OnMsgLeaveRoom============= %s roomid=%s",tostring(roommanager),tostring(roomid))
    GameApp:dispatchEvent(gg.Event.SHOW_LOADING)
    GameApp:dispatchEvent(gg.Event.LEAVE_NORMAL_ROOM)
    if roommanager and (roommanager:GetID()==checkint(roomid)) then
         -- local msg = "与房间 ".. roommanager.name .." 连接断开!"
         -- GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG,msg)
       -- roommanager:ExitRoom()
    end
end

--[[
* @brief 存取开心豆应答
* @param tp 操作类型,0:存入 1:取出
* @param result 操作结果,0为成功
* @param money 操作的数量
]]
function e.OnMsgExchangeMoney( hall,tp,result,money)
    local msg

    if result == 0 then
        -- hall._scene:updateUserData()
        -- assert(nil,"成功则需要更新界面")
        -- 存取应答通知
        GameApp:dispatchEvent(gg.Event.HALL_EXCHANGE_MONEY_REPLY,result)
        GameApp:dispatchEvent(gg.Event.HALL_UPDATE_USER_DATA)

        if tp == 0 then
            local status = gg.UserData:GetTaskStatusById( 4 )
            if status~= 5 then
                gg.UserData:SetTaskStatusById( 4, 4 )
            end
        end

        return
    elseif result == 2 then
        msg = "游戏中无法操作,请退出游戏后再试"
    elseif result == 4 then
        msg="操作超时,请稍后再试"
    elseif result ==5 then
        msg="服务器忙,请稍后再试"
    elseif result == 6 then
        msg = "背包密码不正确"
    else
        if tp==0 then --存入
            if result == 1 then
                msg = "携带的豆豆不足!"

            elseif result == 3 then
                msg="存入失败,您背包内豆豆达到上限！"
            end
        else
            if result == 1 then
                msg= "您背包内的豆豆不够"
            elseif result == 3 then
                msg ="取款失败,您携带的豆豆达到上限!"
            end
        end
    end

    if msg then
         -- 提示信息
         GameApp:dispatchEvent( gg.Event.SHOW_MESSAGE_DIALOG , msg )
    end
end

--[[
* @brief 用户数据发生改变通知
* @param propid 发生改变的道具ID,可能为空,为空则propvalue无效
* @param propvalue 剩余道具数量
]]
function e.OnMsgUpdateUserData( hall,propid,propvalue)

    if hall.proplist and propid then
        hall.proplist[propid] =propvalue
    end
    GameApp:dispatchEvent(gg.Event.HALL_UPDATE_USER_DATA,hall.userinfo,propid,propvalue)

    -- 如果修改的是当前登录的账号
    local userInfo = hall.userinfo
    gg.Cookies:UpdateUserData({sex=userInfo.sex})

end

--[[
* @brief 使用道具应答
* @param propid 道具ID
* @param count 使用道具数量
* @param lottery　使用推荐礼包时,该值有效,为获赠元宝数量
]]
function e.OnMsgUseProp(hall,propid,count,lottery)
    printf("OnMsgUseProp id= %d  count= %d", propid,count)
    local proplist = hall.proplist
    if proplist==nil then
        proplist = {}
        hall.proplist = proplist
    end

    if lottery and lottery >0 then
        hall.userinfo.lottery = hall.userinfo.lottery+lottery
        if gg.GetNativeVersion() >= 6 then
            hall:UpdateUserInfo( hall.userinfo )
        end
    end

    -- 使用了荣誉卡，增加玩家荣誉值
    if propid == PROP_ID_LEITAIKA then
        hall.userinfo.prestige = hall.userinfo.prestige + 10 * count
        if gg.GetNativeVersion() >= 6 then
            hall:UpdateUserInfo( hall.userinfo )
        end
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, string.format("+%d荣誉分", 10 * count))
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, string.format("+%d排位分", 10 * count))
    end

    proplist[propid] = (proplist[propid] or 1)-count
    local propInfo = checktable(gg.GetPropList()[propid])
    local propName = propInfo.name or "道具"
    -- 使用魔法道具不弹提示
    if propid ~= PROP_ID_LEITAIKA and (not gg.IsMagicProp(checkint(propid))) then
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, propName.."使用成功")
    end
    GameApp:dispatchEvent(gg.Event.HALL_UPDATE_USER_DATA,hall.userinfo,propid,proplist[propid])
end

--[[
* @brief 更新玩家道具列表
* @param proplist 道具列表
]]
function e.OnMsgPropList(hall,proplist)
    hall.proplist = proplist
    GameApp:dispatchEvent(gg.Event.HALL_UPDATE_USER_DATA,hall.userinfo)

 end

--收到任务列表
function e.OnMsgMissionList( hall )
end

--收到任务完成列表
function e.OnMsgMissionCompleteList(hall)
    hall:DoCompleteMission(MISSION_DAILY_GIFT_MONEY)
end

--签到(获得钱数)
function e.OnMsgReport( hall,money )
    hall.userinfo.money= hall.userinfo.money+money
end

--[[
* @brief 设置二级密码应答(背包密码)
* @param
]]
function e.OnMsgSetSecondPassword( hall,result )

    if result==0 and hall.newSecondPassword then
        hall.hassecpassword= gg.IIF(hall.newSecondPassword=="",false,true)
        printf("has second password :"..tostring(hall.hassecpassword))
        hall.newSecondPassword=nil
    end
end

--[[
* @brief 检测二级密码是否正确(背包)应答
]]
function e.OnMsgCheckSecondPassword( hall,bOk)
    if not bOk  then
         GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG,"密码错误,请重试!")
    end
end

--[[
* @brief 任务完成
* @param id 任务ID
* @param result 完成结果
]]
function e.OnMsgMissionComplete( hall,id,result)
    if result ~= 0 then
        -- 领取失败了
        local  msgs = {"错误的任务ID","暂时没有达到领取条件,或者数据尚未到达本服务器"
            ,"次数限制","需要前缀任务","无法完成（这个任务不能提交)"}
        -- 因为领取救济金并不是用户主动操作的，所以这里不需要弹窗提示
        -- GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG,msgs[result])
        print("---- mission complete result : "..tostring(result))
        print("---- mission complete msg : "..tostring(msgs[result]))
        return
    end

    -- 更新玩家数据
    local function updateuserdata_(btype)
        GameApp:dispatchEvent(gg.Event.HALL_UPDATE_USER_DATA,hall.userinfo)
    end

    local mission = hall:GetMissionInfo(id)
    local nGift = mission.awardvalue
    if id == MISSION_DAILY_GIFT_MONEY then
        -- 是申请的豆豆救济金
        local nCompleteCount = hall:GetDailyComplete(id)
        local nLeftCount = mission.repeatcount - nCompleteCount
        if hall.roommanager then
            updateuserdata_()
            hall.roommanager:OnGiftMoneyReply(hall.userinfo.money,nGift,nCompleteCount,nLeftCount)
        else
            --设置签到奖励
            GameApp:DoShell(nil, "PopAlmsView://", nGift, nLeftCount)
        end
    elseif id == hall.MISSION_DAILY_GIFT_XZMONEY then
        -- 是申请的钻石救济金
        -- 客户端重新计算玩家的钻石数量
        hall.userinfo.xzmoney = hall.userinfo.xzmoney + nGift
        local msg= "系统免费为您补足"..hall.userinfo.xzmoney.."钻石"
        GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG, msg, updateuserdata_, {ok="领取"})
    else
        updateuserdata_()
    end
end

--[[
* @brief 救济金任务完成
* @param replyMsg msg_hall_mission_complete_reply2 消息
]]
function e.OnMsgMissionComplete2(hall, replyMsg)
    if not replyMsg then
        return
    end

    local id = replyMsg:ReadDword()
    local result = replyMsg:ReadByte()
    if result ~= 0 then
        -- 领取失败了
        local  msgs = {"错误的任务ID","暂时没有达到领取条件,或者数据尚未到达本服务器"
            ,"次数限制","需要前缀任务","无法完成（这个任务不能提交)"}
        -- 因为领取救济金并不是用户主动操作的，所以这里不需要弹窗提示
        -- GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG,msgs[result])
        print("---- mission complete result : "..tostring(result))
        print("---- mission complete msg : "..tostring(msgs[result]))
        return
    end

    -- 更新玩家数据
    local function updateuserdata_(btype)
        GameApp:dispatchEvent(gg.Event.HALL_UPDATE_USER_DATA,hall.userinfo)
    end

    local nCompleteCount = replyMsg:ReadByte()
    local nLeftCount = replyMsg:ReadByte()
    local vipLevel = replyMsg:ReadByte()
    local nGift = replyMsg:ReadDword()
    if id == MISSION_DAILY_GIFT_MONEY then
        -- 是申请的豆豆救济金
        if hall.roommanager then
            updateuserdata_()
            hall.roommanager:OnGiftMoneyReply(hall.userinfo.money,nGift,nCompleteCount,nLeftCount)
        else
            --设置签到奖励
            GameApp:DoShell(nil, "PopAlmsView://", nGift, nLeftCount)
        end
    elseif id == hall.MISSION_DAILY_GIFT_XZMONEY then
        -- 是申请的钻石救济金
        -- 客户端重新计算玩家的钻石数量
        hall.userinfo.xzmoney = hall.userinfo.xzmoney + nGift
        local msg= "系统免费为您补足"..hall.userinfo.xzmoney.."钻石"
        GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG, msg, updateuserdata_, {ok="领取"})
    else
        updateuserdata_()
    end
end

--[[
* @brief 服务器强制帐号退出
* @brief reason 0 无原因 1用户重复登陆被挤；2：被服务器强行踢掉
* @note 在触发该函数时,网络已经被断开
]]
function e.OnMsgLogout( hall,reason )
    local function showLogin_()
        GameApp:CreateLoginManager(false)
    end
    if reason == 1 then
        local msg="该帐号在别处登录,您已被迫下线！"
        GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG,msg,showLogin_)
    elseif reason == 2 then
        showLogin_()
        assert(nil,"无条件踢下线,不给任何提示！")
    end
end

--[[
* @brief 重新刷新游戏信息和节点信息,一般是在后台通过命令刷新
]]
function e.OnMsgReloadGames( hall )
    hall:UpdateGameList()
    --todo update hall ui layer
    if self.roomData_ then
        GameApp:dispatchEvent(gg.Event.SHOW_ROOM_LIST,self.roomData_:getRoomList())
    end
    --assert(nil,"OnMsgReloadGames todo update房间列表")
end

--[[
* @brief 附带命令（网站交互使用)
]]
function e.OnMsgCommand( hall,cmd )

    printf("-----------OnMsgCommand %s", tostring(cmd))
    local cmd_args = gg.ParsingCmd(checkstring(cmd))
    if "month_card" == cmd_args.type then --购买月卡成功
        if not cmd_args.goodstag or cmd_args.goodstag == "month_card_normal" then
            -- 购买贵族月卡成功
            -- 更新玩家的任务状态
			-- 获取状态
			local status = gg.UserData:GetPrivilegeStatus()
			if status ~= 5 then
				gg.UserData:SetTaskStatusById( 23, 4 )
			end

            -- 更新玩家的月卡到期时间
            gg.UserData:UpdateTaskInfo(23, {mc_end=cmd_args.mc_end})

            GameApp:dispatchEvent(gg.Event.BUG_MONTHCARD_SUCCESS)
            GameApp:dispatchEvent(gg.Event.SHOW_TOAST,"贵族月卡购买成功")
        elseif cmd_args.goodstag == "month_card_vip" then
            -- 购买星耀月卡成功
            -- 更新玩家的任务状态
			local status = gg.UserData:GetMonthCardVIPStatus()
			if status ~= 5 then
				gg.UserData:SetTaskStatusById( 87, 4 )
			end

            -- 更新玩家的月卡到期时间
            gg.UserData:UpdateTaskInfo(87, {mc_end=cmd_args.mc_end})

            GameApp:dispatchEvent(gg.Event.BUG_MONTHCARD_VIP_SUCCESS)
            GameApp:dispatchEvent(gg.Event.SHOW_TOAST,"星耀月卡购买成功")
        end
    elseif "everyday_first_pay" == cmd_args.type then    --首次充值》=12
        -- local status = gg.UserData:GetTaskStatusById( 9 )
        -- if status ~= 5 then
        --     gg.UserData:SetTaskStatusById( 9, 4 ) --刷新每日首冲任务状态
        -- end
        -- GameApp:dispatchEvent("event_daily_first_pay_success")
        -- GameApp:dispatchEvent(gg.Event.SHOW_TOAST,"首充任务完成,请去福袋领取奖励")

    elseif "pay_result" == cmd_args.type then -- H5 支付结果的通知
        cc.exports.isPaying = false
        local msg = cmd_args.msg
        -- 隐藏支付等待界面
        GameApp:dispatchEvent(gg.Event.SHOW_PAY_LOADING)
        if msg and #msg > 0 then
            GameApp:dispatchEvent(gg.Event.SHOW_TOAST, string.urldecode(msg))
        end
        -- 发送支付结果的消息
        GameApp:dispatchDelayEvent(gg.Event.ON_PAY_RESULT, 0, {status=0})

        -- 第三方统计
        gg.ThirdParty:paySuccess()

    elseif "show_toast" == cmd_args.type then -- 显示 Toast
        local msg = cmd_args.msg
        if msg and #msg > 0 then
            GameApp:dispatchEvent(gg.Event.SHOW_TOAST, string.urldecode(msg))
        end
    elseif string.find(cmd_args.type, "vip_") == 1 then
        local values = checktable(string.split(cmd_args.type , "_" ))
        gg.UserData:SetAlreadyBuyVipTable(cmd_args.type)
        GameApp:dispatchEvent("event_buy_vip_goods_success", values[2])
    elseif "unread" == cmd_args.type then
        -- 服务器通知的玩家未读消息增加了
        local count = checkint(cmd_args.count)
        if count > 0 then
            local curCount = gg.UserData:GetUserMsgCount()
            gg.UserData:UpdateWebDate("usermsg", curCount + count)
            GameApp:dispatchEvent(gg.Event.HALL_UPDATE_NOTICE_UNREAD_COUNT)
        end
    elseif "pop_pay" == cmd_args.type then
        local msg = cmd_args.msg
        if gg.PopupGoodsData then
            gg.PopupGoodsData:deductPopupGoodsLeftTime(msg)
        end
        GameApp:dispatchEvent(gg.Event.ON_POP_PAY)
    elseif "bfbfl_pay" == cmd_args.type then
        local money = checkint(cmd_args.msg)
        GameApp:dispatchEvent(gg.Event.ON_BFBFL_PAY, money)
    elseif "memory_card_time"== cmd_args.type  then
        local time = checkint(cmd_args.time)
        gg.UserData:setCardHolder(time)
        GameApp:dispatchEvent(gg.Event.BUY_JIPAIQI_SUCCESS, time)
    end
end

--[[
* @brief 日期发生改变,（需要重置日常任务数据和界面)
* @param nDay　新的日期天数
]]
function e.OnMsgDateChange( hall,nDay )

end

function e.OnMsgCheckSecondPassword( hall,bOk )
    -- hall._scene:onBagClicked(bOk)
        -- assert(nil,"OnMsgCheckSecondPassword")
end

--[[
* @brief 客户端成功创建后触发,一般会发生马上会发生场景切换
]]
function e.OnStartGame( hall,gameclient )
    GameApp:UpdateReconnectState(false,true)
    Helper.DisableScreenTimer(true)
    printf("OnStartGame GameClient.isreconnect %s",tostring(GameClient.isreconnect))
end

--[[
* @brief 客户端被关闭时触发,一般会发生马上会发生场景切换
]]
function e.OnStopGame( hall,gameclient )
    Helper.DisableScreenTimer(false)
    GameApp:dispatchEvent(gg.Event.GAME_STOP)
    printf("function e.OnStopGame( hall,gameclient )")
end

--hallmanager:GetUserGameInfo(shortname)
--获取游戏信息应答 二人斗地主连胜 idx=13
e[MSG_ID.GET_USER_GAMEDATA_REPLY]=function(hall,msg )
    local gamedata={
        llScore     = msg:ReadLonglong(),
        dwPlayerJoinRight= msg:ReadDword(),
        dwWinCount     = msg:ReadDword(),
        dwLostCount    = msg:ReadDword(),
        dwDrawCount    = msg:ReadDword(),
        dwFleeCount    = msg:ReadDword(),
        nGameData1     = msg:ReadInt(),
        nGameData2     = msg:ReadInt(),
        dwPKKempCount  = msg:ReadDword(),
        dwPKAwardCount = msg:ReadDword(),
        dwPKCount      = msg:ReadDword(),
        dwPKWinCount   = msg:ReadDword(),
        dwPKEliminate  = msg:ReadDword(),
       }
     gamedata.cbTaskData={}
     for i=1,GAME_EXTAND_DATA_LEN/4 do
          table.insert(gamedata.cbTaskData,msg:ReadDword())
     end
     gamedata.cbMacthData={}
     for i=1,GAME_EXTAND_DATA_LEN/4 do
          table.insert(gamedata.cbMacthData,msg:ReadDword())
     end
    gamedata.byFirstJoin=msg:ReadByte()              -- //第一次加入（没有产生过任何游戏数据）
    gamedata.shortname =msg:ReadStringAEx(4)   -- //游戏缩写名
    hall.gamedata=checktable(hall.gamedata)
    hall.gamedata[gamedata.shortname] =gamedata


end

--查询房间号应答
e[MSG_ID.QUERY_ROOMKEY_REPLY]=function(hall,msg )
    local  dwRoomKey= msg:ReadDword()
    local  roomid  = msg:ReadDword()
    printf(" on query roomkey  roomkey= %s  id= %s ", dwRoomKey,roomid)
    if checkint(roomid)>0 then
       local roommgr
       roommgr= hall:JoinRoom(roomid, false,function(...)
            if roommgr and dwRoomKey then
                printf(" 查询房间号 加入房间"..dwRoomKey)
                roommgr:JoinGroup( string.format("%06d",dwRoomKey))
            end
       end)
    else
        GameApp:dispatchEvent(gg.Event.HALL_QUERY_ROOMKEY_FAILED)
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST , "房间不存在,请重新输入！" )
    end
end

--//查询用户房间ID列表应答
e[MSG_ID.QUERY_USER_DESK_REPLY]=function(hall,msg )
    hall.friendroomlist={}
    local count= msg:ReadWord()
    for i=1,count do
        local roomid=msg:ReadDword()
        local deskid=msg:ReadWord()
        printf("QUERY_USER_DESK_REPLY roomid %d deskid %d" ,roomid,deskid)
        local key= string.format("%d%d",roomid,deskid)
        local value={roomid=roomid,deskid=deskid}
        hall.friendroomlist[key]=value
    end
    printf("查询用户房间ID列表应答 QUERY_USER_DESK_List_REPLY-------------------count: %d, msgID：%d",count,msg.id)
    local delay=0
    for k,v in pairs(hall.friendroomlist) do
        if type(v)=="table" then
            delay=delay+0.1
            if delay>=1 then delay=1 end
            gg.CallAfter(delay,hall.DoQueryUserDeskInfo,hall,v.roomid,v.deskid )
        end
    end
    GameApp:dispatchEvent(gg.Event.HALL_QUERY_USER_DESK_REPLY,hall.friendroomlist)
end

 --//用户创建房间应答
e[MSG_ID.CREATE_ROOM_REPLY]=function(hall,msg )
    local roomid=msg:ReadDword()
    local deskid=msg:ReadWord()
    local roomkey=""
    for i = 1, 6 do
        roomkey = roomkey..string.char(msg:ReadChar())
    end

    local credit_user = 0
    if msg.position < msg.len then
        msg:ReadChar()  -- roomkey的末尾有个'\0',多读取一位
        credit_user = msg:ReadByte()
    else
        print("error：使用的旧版游戏BaseGroup脚本文件，请更换新的！")
    end

    printf("-------CREATE_ROOM_REPLY------ %s ----", roomkey)
    GameApp:dispatchEvent(gg.Event.HALL_CREATE_ROOM_REPLY, roomkey, credit_user)
end

 --//创建房间失败
e[MSG_ID.CREATE_ROOM_FAILED]=function(hall,msg )
    local roomid=msg:ReadDword()
    local errmsg= msg:ReadStringW()
    printf(" ------CREATE_ROOM_FAILED msglen: %s , %s ,  %s  ",tostring(msg.len),tostring(roomid),tostring(errmsg))
    GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG , errmsg )
end

--//用户解散房间应答
e[MSG_ID.DISBAND_ROOM_REPLY]=function(hall,msg )
    local roomid=msg:ReadDword()
    local deskid=msg:ReadWord()
    local key= string.format("%d%d",roomid,deskid)
    printf("-------DISBAND_ROOM_REPLY------%s  %s",key,tostring(errmsg))
    if msg.position~=msg.len then
        local errmsg= msg:ReadStringW()
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST , errmsg )
    else
        checktable(hall.friendroomlist)[key] = nil
        GameApp:dispatchEvent(gg.Event.HALL_DISBAND_ROOM_REPLY,key)
    end
end

 --//查询桌子状态应答
e[MSG_ID.QUERY_DESKINFO_REPLY]=function(hall,msg )
    hall.friendroomlist=checktable(hall.friendroomlist)
    local tmp={}
    local roomid=msg:ReadDword()
    local deskid=msg:ReadWord()
    local ok=msg:ReadByte()
    tmp.roomid=roomid
    tmp.deskid=deskid
    local key= string.format("%d%d",roomid,deskid)
    printf(" 查询桌子状态应答 QUERY_DESKINFO_REPLY roomid %d ,deskid %d, %s,%d ",roomid,deskid,tostring(ok), msg.len)
    if ok == 1 then
        tmp.roomkey=msg:ReadStringA()
        tmp.gameid=msg:ReadDword()
        tmp.name= tostring(msg:ReadStringW())
        tmp.createtime=checkint(msg:ReadDword())
        tmp.gameing=msg:ReadBool()
        local rule_str=  tostring(msg:ReadStringW())
        tmp.rule=checktable(string.split(rule_str,";") )
        tmp.maxpalyer=checkint(msg:ReadByte())
        tmp.palyers=checkint(msg:ReadByte())
        tmp.playerinfo={}
        for i=1,(tmp.palyers) do
            local tp={
               id= msg:ReadDword(),
               sex= msg:ReadBool() and 1 or 0,
               nickname=tostring(msg:ReadStringW()),
               avatarpath= tostring(msg:ReadStringW()),
               chairid= msg:ReadWord()
            }
            table.insert(tmp.playerinfo,tp)
        end
        tmp.lock=msg:ReadBool()

        local verTag = msg:ReadDword()
        -- warming:消息总长度有附加长度为28的消息,所以判断增加一个28的偏移量
        -- 2017.10.13 增加总局数与当前局数,增加玩家是否准备
        if msg.position + 28 < msg.len and verTag == 1013 then
            for _, v in ipairs(tmp.playerinfo) do
                v.ready=msg:ReadByte() == 1
            end
            tmp.totaljs = checkint(msg:ReadWord())
            tmp.curjs = checkint(msg:ReadWord())
        end

        -- 2017.10.31 特殊情况没有局数时代开进度显示,由游戏直接传入所要显示的字符串
        if msg.position + 28 < msg.len and verTag == 1031 then
            for _, v in ipairs(tmp.playerinfo) do
                v.ready=msg:ReadByte() == 1
            end
            tmp.progress = tostring(msg:ReadStringW())
        end
    elseif ok == 2 then
        printf("信用用户创建房间 roomid %d deskid %d", roomid, deskid)
        hall.friendroomlist[key] = nil
    else
        printf("查询桌子状失败 roomid %d deskid %d", roomid, deskid)
    end

    hall.friendroomlist[key] = ok==1 and tmp or nil
    GameApp:dispatchEvent(gg.Event.HALL_QUERY_DESKINFO_REPLY,key,hall.friendroomlist[key])
end

--代开房主踢人应答
e[MSG_ID.KICK_PLAYER_BY_OWNER_REPLY]=function(hall,msg )
    local userid=msg:ReadDword()
    local roomid=msg:ReadDword()
    local deskid=msg:ReadWord()
    local chairid=msg:ReadWord()
    local key= string.format("%d%d",roomid,deskid)
    local msgerr
    local bsuccess=true
    if msg.position~=msg.len then
        msgerr=msg:ReadStringW()
        bsuccess=false
    end
    GameApp:dispatchEvent(gg.Event.HALL_KICK_PLAYER_BY_OWNER_REPLY,key,userid,chairid,bsuccess,msgerr)
end

-- 请求比赛房间信息应答
e[MSG_ID.MSG_HALL_QUERY_CONFIG_INFO_REPLY] = function(hall, msg)
    local signUpGroupTb = {}
    -- 已经报名的分组数量
    local signCnt = msg:ReadByte()
    for i=1,signCnt do
        local signUpGroup = {}
        signUpGroup.roomid = msg:ReadDword()         -- 报名的房间id
        signUpGroup.groupid = msg:ReadDword()        -- 组别ID
        signUpGroup.gignUpType = msg:ReadDword()     -- 报名类型
        signUpGroup.players = msg:ReadDword()        -- 报名人数
        signUpGroup.state = msg:ReadDword()          -- 当前报名分组状态 0-正常 1-开赛失败
        table.insert(signUpGroupTb, signUpGroup)
        hall:SetPk3SingUp(signUpGroup.roomid, signUpGroup.groupid, signUpGroup.gignUpType, signUpGroup.players, signUpGroup.state)
    end

    -- 如果有报名分组开启定时器
    if signCnt > 0 then
        hall:StartMatchTimer()
    end

    local roomCnt = msg:ReadByte()
    for i=1,roomCnt do
        local roominfo = {}
        roominfo.name = msg:ReadStringW()             -- 房间名字
        roominfo.cmd = {}
        roominfo.cmd.icon = msg:ReadStringW()         -- icon
        roominfo.cmd.lt = msg:ReadStringW()           -- lt
        roominfo.cmd.rt = msg:ReadStringW()           -- rt
        roominfo.cmd.rot = msg:ReadByte()             -- 比赛房间类型
        roominfo.cmd.pay = msg:ReadByte()             -- 支付类别（用与金币不足时拉起支付使用）
        roominfo.id = msg:ReadWord()                  -- 房间ID
        roominfo.gameid = msg:ReadWord()              -- 游戏ID
        roominfo.isBefor = msg:ReadByte()             -- 是否是预报名房间
        roominfo.cmd.awardType = msg:ReadByte()       -- 比赛类型
        roominfo.type = msg:ReadDword()               -- 房间类型
        
        -- 房间分组
        roominfo.group = {}
        local groupCnt = msg:ReadDword()

        for j=1,groupCnt do
            local group = {}
            group.id = msg:ReadDword()                   -- 分组id
            group.type = msg:ReadByte()                  -- 比赛类型
            group.startTime = msg:ReadDword()            -- 比赛开始时间
            group.downTime = msg:ReadDword()             -- 比赛剩余开始时间
            -- 计算与服务器时间差
            group.timeDiff = group.startTime - os.time() - group.downTime
            group.gignUpTypeList = {}                    -- 比赛报名类型列表
            group.curSignUpType = 0                      -- 当前报名类型
            -- 报名类型数量
            local signUpTypeCnt = msg:ReadByte()
            for m=1,signUpTypeCnt do
                local gignUpType = {}
                gignUpType.index = msg:ReadByte()        -- 报名方式索引
                if m <= 1 then
                    group.curSignUpType = gignUpType.index
                end
                gignUpType.pl = {}
                -- 道具类型数
                local propCnt = msg:ReadByte()
                for n=1,propCnt do
                    local prop = {}
                    prop.id = msg:ReadDword()             -- 道具ID
                    prop.count = msg:ReadDword()          -- 道具数量
                    table.insert(gignUpType.pl, prop)
                end

                group.gignUpTypeList[gignUpType.index] = gignUpType
            end

            table.insert(roominfo.group, group)
        end

        -- 每日赛今日场次都结束，将获取的分组数据时间戳修改为第二天
        local isNextDay = 0
        for k,g in pairs(roominfo.group) do
            if g.type == 0 then
                if g.downTime > 0 then
                    isNextDay = 1
                    break
                else
                    isNextDay = 2
                end
            end
        end

        if isNextDay == 2 then
            for k,g in pairs(roominfo.group) do
                g.startTime = g.startTime + 24 * 60 * 60
                g.downTime = g.startTime - os.time()
                g.timeDiff = 0
                g.isNextDay = true      
            end
        end

        roominfo.rank = {}
        roominfo.rank.awardinfo = {}
        -- 奖励分组数量
        local rankCnt = msg:ReadByte()
        for j=1,rankCnt do
            local rank = {}
            rank.rks = msg:ReadWord()     -- 最小名次
            local rke = msg:ReadWord()    -- 最大名次
            if rank.rks ~= rke then
                rank.rke = rke
            end
            rank.reward = {}
            table.insert(roominfo.rank.awardinfo, rank)

            -- 奖励道具类型数量
            for n = 1, msg:ReadByte() do
                local prop = {}
                prop.id = msg:ReadDword()       -- 道具ID
                prop.count = msg:ReadDword()    -- 道具数量
                prop.desc = msg:ReadStringW()   -- 道具显示文本
                table.insert(rank.reward, prop)
            end
        end

        roominfo.matchrule = {}
        -- 游戏规则数量
        local ruleCnt = msg:ReadByte()
        for j=1,ruleCnt do
            local rule = {}
            rule.title = msg:ReadStringW()
            rule.content = msg:ReadStringW()
            table.insert(roominfo.matchrule, rule)
        end

        -- 开赛提醒时间
        roominfo.tipsTime = msg:ReadDword()
        -- 奖励图标
        roominfo.cmd.nicon = msg:ReadStringW()
        -- 电视台id，如果为0表示不是电视赛
        roominfo.cmd.tv = msg:ReadByte()

        -- 将房间对应的用户报名分组信息存入房间数据
        roominfo.signUpGroup = {}
        for i,v in ipairs(signUpGroupTb) do
            if v.roomid == roominfo.id then
                table.insert(roominfo.signUpGroup, v)
            end
        end

        hall:SetPk3RoomInfo(roominfo)
    end

    hall:PkInfoLoadedSuccess()
end

-- pk3报名应答
e[MSG_ID.MSG_HALL_SIGN_UP_MATCH_REPLY] = function(hall, msg)
    local signUptype = msg:ReadByte()   -- 1.报名 2.退赛
    local result = msg:ReadByte()
    local resultString = msg:ReadStringW()
    local roomid = msg:ReadDword()
    local groupid = msg:ReadDword()

    local signupinfo = hall:GetSignUpInfo(roomid, groupid)
    -- 报名成功
    if result == 0 then
        GameApp:dispatchEvent(gg.Event.ROOM_JOIN_PK1_REPLY, result, signUptype == 1)
        if signUptype == 1 then
            if signupinfo then
                -- 开启计时器
                hall:StartMatchTimer()
                -- 开启通知
                local surTim = checkint(checktable(hall:GetLatelyGroup(roomid)).startTime) - os.time() - 5 * 60
                -- 报名时间距离开赛时间大于5分钟执行
                if surTim > 0 then
                    local title = string.format("您报名的【%s】还有5分钟就要开赛了", hall.rooms[roomid].name)
                    gg.NotificationHelper:registLocalNotification(gg.NotificationHelper.notifyType.MATCH_START, title, "点击前往游戏开始比赛", surTim)
                end
            end
        else
            -- 解除通知
            gg.NotificationHelper:cancelLocalNotification(gg.NotificationHelper.notifyType.MATCH_START)
            -- 清除报名信息
            hall:EmptySingUpInfo(roomid, groupid)
            -- 退赛成功通知
            if signupinfo then
                GameApp:dispatchEvent(gg.Event.ROOM_UPDATE_SIGNUP_PLAYERS, roomid, groupid, math.max(checkint(signupinfo.players) - 1, 0))
            end
        end
        return
    end

    -- 报名道具不足
    if result == 2 and signupinfo then
        local roominfo = hall.rooms[roomid]    
        local idx = signupinfo.signUpType or 1
        local bmfTb = checktable(checktable(checktable(roominfo.group[groupid].gignUpTypeList)[idx]).pl)[1]
        local propid = checktable(bmfTb).id
        if propid == PROP_ID_MONEY or propid == PROP_ID_XZMONEY then
            -- 提示充值
            GameApp:DoShell(nil, string.format("PayTips://%d&%d&%d&%d&%d", checkint(roominfo.cmd.pay), 0, 0, roomid, gg.PayHelper.PayStages.ROOM))
            -- 报名失败清空报名信息
            hall:EmptySingUpInfo(roomid, groupid)
            return
        end
    end

    GameApp:dispatchEvent(gg.Event.SHOW_TOAST, resultString)
    -- 报名失败清空报名信息
    if result == 1 and signUptype == 1 then
        hall:EmptySingUpInfo(roomid, groupid)
    end
end

-- 预报名比赛开始通知
e[MSG_ID.MSG_HALL_SIGN_UP_START_REPLY] = function(hall, msg)
    local roomid = msg:ReadDword()
    local groupid = msg:ReadDword()
    
    -- 如果玩家在游戏中不处理
    -- 2018-9-11 增加房间id判断，修复用户在比赛等待界面断线重连没有被重新拉回桌子问题
    local roomMgr = hall:GetRoomManager()
    if roomMgr and roomMgr:GetID() ~= roomid and roomMgr:IsClientRunning() then
        return
    end
    local sign = hall:GetSignUpInfo(roomid, groupid)
    if sign then
        -- 已经在比赛房间中了，仅清除比赛报名信息，防止再次请求加入房间游戏客户端重新刷新界面闪一下
        if roomMgr and roomMgr:IsClientRunning() then
            hallmanager:EmptySingUpInfo(roomid, groupid)
            return
        end
        -- 记录下当前用户重回比赛的分组ID，用于解决比赛开始时重回比赛，获取的groupid错误问题
        cc.exports.PK4_JOIN_GROUPID = groupid
        hall:JoinRoom(roomid, false)
        -- 比赛开始了，清除报名信息
	    hallmanager:EmptySingUpInfo(roomid, groupid)
    else
        print("没有找到报名信息，请检查用户是否报名了该场次的比赛")
    end
end

-- 预报名比赛人数通知
e[MSG_ID.MSG_HALL_SIGN_UP_PLAYERS_UPDATE] = function(hall, msg)
    local roomid = msg:ReadDword()
    local groupid = msg:ReadDword()
    local players = msg:ReadDword()
    GameApp:dispatchEvent(gg.Event.ROOM_UPDATE_SIGNUP_PLAYERS, roomid, groupid, players)

    local sign = hall:GetSignUpInfo(roomid, groupid)
    if sign then
        sign.players = players
    end
end

-- 预报名比赛开赛前提前将用户拉入等待界面
e[MSG_ID.MSG_HALL_TO_CLIENT_ROOMCANIN] = function(hall, msg)
    -- 如果玩家在游戏中不处理
    local roomMgr = hall:GetRoomManager()
    if roomMgr and roomMgr:IsClientRunning() then
        return
    end

    local roomid = msg:ReadDword()
    local groupid = msg:ReadDword()
    local sign = hall:GetSignUpInfo(roomid, groupid)

    if sign then
        -- 记录下当前用户加入比赛的分组ID，防止用户时间戳的问题导致用户进入错误分组
        cc.exports.PK4_JOIN_GROUPID = groupid
        hall:JoinRoom(roomid, false)
    else
        print("没有找到报名信息，请检查用户是否报名了该场次的比赛")
    end
end

-- 预报名比赛开赛失败通知
e[MSG_ID.MSG_HALL_TO_CLIENT_PK_ERR] = function(hall, msg)
    local roomid = msg:ReadDword()
    local groupid = msg:ReadDword()
    local errmsg = msg:ReadStringW()
    -- 记录当前分组开赛失败，用于重新创建报名界面
    cc.exports.PK_ROOM_FAILED_GROUPID = {rid = roomid, gid = groupid}
    GameApp:dispatchEvent(gg.Event.HALL_MATCH_START_FAILED_NOTIC, roomid, groupid, errmsg)
    -- 清除报名信息
    hallmanager:EmptySingUpInfo(roomid, groupid)
end

return e
