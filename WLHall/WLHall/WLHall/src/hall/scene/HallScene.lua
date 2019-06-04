local SceneBase=require("common.SceneBase")
local HallScene= class("HallScene", SceneBase)

function HallScene.getType()
    return HallScene.__cname
end

function HallScene:ctor(...)
    HallScene.super.ctor(self,...)
    local openurllistener = cc.EventListenerCustom:create("EVENT_OPEN_URL", handler(self,self.handleOpenUrl_))
    self:getEventDispatcher():addEventListenerWithSceneGraphPriority(openurllistener, self)
end
function HallScene:onAppEnterForegroundCallback_(difftime)
    local  breconnect
    if  difftime>=7 and self.isbackground_ and not self.isdisableswitch_ then
        breconnect = gg.ReconnectModule:onAppEnterForeground(difftime,"hall",self)
    end
    if not breconnect and device.platform=="android" then
        self:handleOpenUrl_()
    end
end

function HallScene:handleOpenUrl_(event)
    printf("function HallScene:handleOpenUrl_(event)--- " )
   if hallmanager and hallmanager:IsConnected() and (not GameApp:IsReconnecting()) then
        local schemeuri=device.getUrlScheme()
        printf("HallScene handleOpenUrl_ scheme :%s",tostring(schemeuri))
        if (#checkstring(schemeuri))>0 and tonumber(gg.LocalConfig:GetRegionCode())>0  then
            GameApp:HandleUrlScheme(schemeuri)
        end
   end
end

function HallScene:onEnter()
	self:addEventListener(gg.Event.ROOM_MONEY_LIMIT,handler(self, self.onGameMoneyLimitNotify))
	self:addEventListener("event_on_show_push_msg",handler(self, self.onShowPushMsgEvent_))
    self:addEventListener(gg.Event.NETWORK_ERROR,handler(self, self.onNetworkStateChangeEvent_))
    -- 2017-12-15 by zhangbin 支付成功后不再显示 vip 界面
    -- self:addEventListener(gg.Event.ON_PAY_RESULT,handler(self, self.onPayResult_))
    if hallmanager and hallmanager:IsConnected()==false and not GameApp:IsReconnecting() then
        self:onNetworkStateChangeEvent_(nil,NET_ERR_TAG_HALL,-7 )
    end

    -- 设置大厅的帧率
    cc.Director:getInstance():setAnimationInterval(1 / 60)
end

function HallScene:onExit()
    if self._popViewTimer then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry( self._popViewTimer )
        self._popViewTimer = nil
    end
end

function HallScene:onCleanup()
    self:getEventDispatcher():removeCustomEventListeners("EVENT_OPEN_URL")
end

-- 2017-12-15 by zhangbin 支付成功后不再显示 vip 界面
-- function HallScene:onPayResult_(event, result)
--     if result.status == 0 and GameApp:CheckModuleEnable(ModuleTag.VIP) then
--         GameApp:DoShell(nil, "Vip://0")
--     end
-- end

function HallScene:onNetworkStateChangeEvent_(event,tag,state)
	printf(" HallScene:onNetworkStateChangeEvent_ tag: "..tag.." state: ".. tostring(state).." last:"..tostring(self.last_netstate_))
    local laststate= self.last_netstate_ or 1
	if state<=0 or (state>0 and laststate <=0 ) then
		printf("  call ReconnectModule onNetworkStateChangeEvent_ tag: "..tag.." state: ".. tostring(state))
        if self.isdisableswitch_ then
           gg.CallAfter(1,function() gg.ReconnectModule:onNetworkChanged(tag,state,"hall",self) end)
        else
           gg.ReconnectModule:onNetworkChanged(tag,state,"hall",self)
        end
	end
end

--  系统推送消息 公告 活动的  我的消息
function HallScene:onShowPushMsgEvent_(event,data)
    if not GameApp:CheckModuleEnable(ModuleTag.Notice) then
        -- 公告关闭了，直接返回
        return
    end

	data = data or {}
    -- todo 弹出消息类型判断 1.公告 2.我的消息 3.活动
    -- 弹出的消息只弹出未读的,即只弹一次
    if data.type==1 then
    	local itemData = require( "hall.models.AnnounceData" ):GetDataById( data.id )
    	if itemData and itemData.status==0 then
    		local pageData = {tag1 = 1, tag2 = data.id}
            GameApp:dispatchEvent(gg.Event.SHOW_VIEW, "announcement.MessageView", {push = true, popup = true}, pageData)
        else
            print("error: no notice push msg id ="..tostring(data.id))
    	end

    elseif data.type==2 then
        local itemData = require( "hall.models.MymsgData" ):GetDataById( data.id )
        if itemData and itemData.status==0 then
            local pageData = {tag1 = 2, tag2 = data.id}
            GameApp:dispatchEvent(gg.Event.SHOW_VIEW, "announcement.MessageView", {push = true, popup = true}, pageData)
        else
            print("error: no user push msg id ="..tostring(data.id))
        end
    end
end

-- 判断是否可以弹出活动界面，规则：一天只弹出一次
function HallScene:canPopActivityView(actId)
    local aKey = "activity_pop_date_" .. actId
    local lastPopDate = gg.UserData:getConfigByKey(aKey)
    local today = os.date("%x", os.time())
    if lastPopDate and lastPopDate == today then
        return false
    end
    return true
end

 --demo GameApp:dispatchDelayEvent(gg.Event.ROOM_MONEY_LIMIT,0.1,1,1)
--游戏中金钱条件限制 code 0 不处理	1//低于最小分限制 2//高于最大分限制 idx 为 cmd.pay 命令行参数
function HallScene:onGameMoneyLimitNotify(e,gameid,code,idx)
	printf("onGameMoneyLimitNotify ROOM_MONEY_LIMIT code:"..tostring(code))
    if not idx then
        return
    end

	if code==1 then
		GameApp:DoShell(self, string.format("PayTips://%d&%d&%d&%d&%d", checkint(idx), 0, checkint(gameid), 0, gg.PayHelper.PayStages.GAME))
    elseif code==2 then
        local  msg="您的豆豆足够到高级的房间游戏啦！"
        local lfunc=function (bt)   --查找一个差不多的房间    --进入推荐房间
            if bt==gg.MessageDialog.EVENT_TYPE_OK then
                GameApp:DoShell(self,"QuickJoinGame://"..checkint(gameid))
            end
        end
        GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG,msg,lfunc,{ok="进入推荐房间"})
	end
end

function HallScene:onCleanup()
	gg.ReconnectModule:cleanup()
end

return HallScene
