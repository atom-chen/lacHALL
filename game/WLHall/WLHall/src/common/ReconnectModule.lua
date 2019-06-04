
-- 断线重连
local M ={
    ARQCount_=0
}

local state={
    mobile=2,
    wifi=1,
    no_network=0,
    socket_err1=-1,
    socket_err2=-2,
    failed=-3,
    timeout=-4,
}

function M:reconnect(forcelogin,checkversion)
    local reconnecting=( GameApp:IsReconnecting())
    printf(" M:reconnect reconnectCount_ %s %d ",tostring(reconnecting), checkint(reqcount))
    if not reconnecting then
        self.ARQCount_=checkint(self.ARQCount_)+1
        if  self.ARQCount_>=3 then
            self:showConnectFailedDialog()
            return
        end
        self:cleanup()
        local timeout= CONNECT_TIMEOUT
        if self.ARQCount_<=1 then
            timeout= checkint(timeout/2)
        end
        self:showConnectingTip(timeout)
        GameApp:ReconnectToHall(nil, (self.ARQCount_>1 or forcelogin),checkversion or self.ARQCount_>=2)
        return true
    end
    return false
end

--网络状态变化通知netState: 0 无网络。1 wifi 网络。2 移动网络   sceneName 场景名字用于区分 游戏和大厅场景
function M:onNetworkChanged(tag,state,sceneName,tagdata)
    if tag==NET_ERR_TAG_LOGIN and  state <-3  then
        self:showConnectFailedDialog()
    elseif checkint(state)==0 then
        printf("onNetworkChanged state:"..tostring(state))
        self:showConnectFailedDialog()
    else
        self:reconnect(tag==NET_ERR_TAG_HALL and state <0,tag==NET_ERR_TAG_HALL)
    end
end

-- -- 游戏进入前台  sceneName 场景名字用于区分 游戏和大厅场景
function M:onAppEnterForeground(difftime,sceneName,tagdata)
    printf("RconnnectReconnectodule onAppEnterForeground time:%d",difftime)
    if device.platform == "windows" then
       -- return
    end
    if sceneName=="game" then

    end
    return self:reconnect(difftime>10,sceneName=="hall" )
end

--显示连接中提示
function M:showConnectingTip(timeout)
    local scene=GameApp:getRunningScene()
    local function onconnecttimeout()
        self:cleanup()
        GameApp:UpdateReconnectState(false,false)
        GameApp:dispatchEvent(gg.Event.NETWORK_ERROR,NET_ERR_TAG_TIMEOUT,-4)
        printf("M:onConnectTimeout_ showConnectFailedDialog timeout -4 ")
    end
    self.connectView= require("common.widgets.ConnectView").new(scene,"ConnectView",onconnecttimeout,timeout):pushInScene()
    self.connectView:addRemoveListener(function() self.connectView=nil end )
end

--显示重新登录对话框
function M:showConnectFailedDialog(tips,scene)
    self:cleanup()
    self.ARQCount_=0
    tips = tips or "连接超时,或本机已与网络断开!"
    scene= scene or GameApp:getRunningScene()
    if scene and not tolua.isnull(scene) then
        assert(tolua.type(scene)=="cc.Scene","scene params type error ")
        scene:showMsgDialog( tips, function(bttype)
            GameApp:UpdateReconnectState(false,false)
            printf("click dialog bttype "..tostring(bttype))
            if bttype == gg.MessageDialog.EVENT_TYPE_OK then
                self:reconnect(true,true)
            elseif bttype == gg.MessageDialog.EVENT_TYPE_CANCEL then
                self:cleanup()
                -- 调用 logout
                GameApp:Logout()
                GameApp:CreateLoginManager(false)
            else
                printf("close  showConnectFailedDialog(node)")
            end
        end,
       { name="connect_failed_dialog", ok = "重连",cancel="返回登录", backdisable=true, mode = gg.MessageDialog.MODE_OK_CANCEL,title = "温馨提示" })
    end
end

 --连接成功
function M:didConnectToHall(bsuccess)
    if bsuccess then
        printf("reconnect success count= %d",self.ARQCount_)
        self:cleanup()
        self.ARQCount_=0
        GameApp:dispatchEvent(gg.Event.RECONNECT_SUCCESS)
    end
end

--清理释放 在场景 onCleanup() 中调用
function M:cleanup()
    if GameApp==nil then
        return
    end

    GameApp:UpdateReconnectState(false,false)
    if self.connectView and not tolua.isnull(self.connectView) then
        self.connectView:removeSelf()
    end
    self.connectView = nil
    local scene= GameApp:getRunningScene()
    if scene and not tolua.isnull(scene)  then
        local view= scene:getChildByName("connect_failed_dialog")
        if view then view:removeSelf() end
    end
end

return M