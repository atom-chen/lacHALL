
--[[
* @brief 游戏应用维护
* @note 主要用来创建登陆管理器＼大厅管理器＼下载＼更新...
]]
local SceneClass = require("common.SceneBase")
local e = {}
local App = ClassEx("App", function()
    local obj = CGameHallApp.New();
    obj.event = e;
    return obj;
end);

App.SCENE_BG = "hall/newhall/img_login_bg.jpg"

-- 游戏关闭事件
function e.Shutdown(app)
    printf("-------APP e.Shutdown")
end

function App:ctor()
    self.curScene_ = nil
    self.reconnecting_=nil
    if self:Initialize() then
        self.event_ = gg.Event.new()
    else
        printf("----App  Initialize Failed----")
    end
end

--设置当前活动场景
function App:setRuningScene(scene)
    assert( scene==nil or tolua.type(scene)=="cc.Scene","not scene")
    self.curScene_ =scene
end

--获取当前活动场景
function App:getRunningScene()
    if self.curScene_ and tolua.isnull(self.curScene_) then
        printf("function App:getRunningScene() c++")
        return display.getRunningScene()
    else
        return self.curScene_
    end
end

function App:HandleCheckVersionError(msg,successcallback)
    if (self:IsReconnecting()) then
        printf(" reconnect check version error  HandleCheckVersionError")
        gg.ReconnectModule:showConnectFailedDialog()
        return
    end
    self:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG, msg,function(bttype)
        if bttype==gg.MessageDialog.EVENT_TYPE_OK then
            self:CheckVersionUpdate(successcallback)
        else
            self:Exit()
        end
    end,{ mode=gg.MessageDialog.MODE_OK_CANCEL,cancel="退出",ok="重 试",backdisable=true})
end

function App:StartUpdate(data,successcallback)
    printf("-------------do lua update App:StartUpdate")
    Helper.DisableScreenTimer(true)
    self:dispatchEvent("event_show_update_loading")
    local mgr= require("update.AssetDownloader").new(nil,function(msg,cancontinue,needreload)
        Helper.DisableScreenTimer(false)
        if not msg then
            -- 更新完成后，调用 reload 会重新触发版本检查，这里不需要再调用版本检查的回调
            reload()
        else
            printf("StartUpdate callback"..tostring(msg))
            self:HandleCheckVersionError(msg,successcallback)
        end
     end)
    if data.uptype==gg.VersionHelper.UPDATE_TYPE_PACK then
        local viewObj =  require("update.UpdateTipsView").new(self.curScene_, "UpdateTipsView",function()
            if device.platform == "ios" then ---大版本更新打开appstore
                device.openURL(data.url)
            else
                mgr:StartDownloadApk(data.url)
            end
        end,data.log)
        self.curScene_:pushViewInScene(viewObj)
    else
        local download_list={}
        -- 更新大厅资源
        if gg.VersionHelper:isModuleNeedUpdate(gg.VersionHelper.VER_MODULE_HALL) then
            if checktable(data.hall).url then
                table.insert(download_list, {url = data.hall.url, version = checkint(data.hall.latest_version), desc = "正在更新大厅资源"})
                -- 记录大厅版本更新时的时间戳
                gg.LocalConfig:SetHallUpdateTime(checkint(data.hall.latest_version))
            else
                print("hall update error:" .. tostring(data.msg))
                self:HandleCheckVersionError(tostring(checktable(data.hall).msg or "更新大厅失败！"), successcallback)
            end
        end

        if data.uptype==gg.VersionHelper.UPDATE_TYPE_HOT then
            table.insert(download_list,{url=data.url,version=data.last})
        end

        -- 通用组件需要更新
        if gg.VersionHelper:isModuleNeedUpdate(gg.VersionHelper.VER_MODULE_GAME_COMMON) then
            if checktable(data.common_base).url then
                table.insert(download_list,{url=data.common_base.url,version=checkint(data.common_base.latest_version),desc="正在更新通用资源"})
            else
                print("game common update error:".. tostring(data.msg))
                self:HandleCheckVersionError(tostring( checktable(data.common_base).msg or "通用资源更新失败！"),successcallback)
            end
        end
        if #download_list>0 then
            dump(download_list,"update gameapp")
            mgr:ExecuteQueue(download_list)
        end
        --mgr:Execute(data.url,data.last)
    end
end

--//创建更新界面
function App:CheckVersionUpdate(successcallback)
    printf(" CheckVersionUpdate")
    local FuncTable={
        [gg.VersionHelper.STATE_ERROR]=function(data)
            self:HandleCheckVersionError("网络连接不可用,请检查网状态！",successcallback)
        end,
        [gg.VersionHelper.STATE_LATEST]=function(data)
            gg.InvokeFunc(successcallback, gg.VersionHelper.STATE_LATEST)
        end,
        [gg.VersionHelper.STATE_MAINTAIN]=function(data)
            self:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG, data.msg or "正在维护中,请官网关注公告！",function(...)  self:Exit()  end)
        end,
        [gg.VersionHelper.STATE_UPDATE]=function(data) --启动更新
            if self.curScene_ and self.curScene_.__cname=="LaunchScene" then
                self:StartUpdate(data,successcallback)
            else
                self.curScene_ = require("common.LaunchScene").new("LaunchScene",App.SCENE_BG):run(function()
                    self:StartUpdate(data,successcallback)
                end)
            end
        end,
    }
    local function oncheckversionresp_(state,respdata)
        local func= FuncTable[state]
        if type(func)=="function" then
            func(respdata)
        else
            self:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG, "版本检查失败,请重新启动",function(...) self:Exit() end,{ backdisable=true})
        end
    end

    gg.VersionHelper:checkVersion(oncheckversionresp_)
end

--模块开关检查函数
function App:CheckModuleEnable(modulename)
    -- 微乐屏蔽视频券（by zhangbin 2018-8-14)
    if IS_WEILE and modulename == ModuleTag[PROP_ID_ROOM_CARD] then
        return false
    end

    local bit_tag= MODULE_SWITCH_TABLE[checkstring(modulename)]
    local enable=true
    local bit_location = bit_tag.modulelocation  --数据位置
    local bit_data = bit_tag.moduledata          --模块数据
    if bit_data then
        if type(MODULES_SWTITCH)=="table"then
            local module_length = #MODULES_SWTITCH
            if (module_length>=bit_location) then
               enable=Helper.And(MODULES_SWTITCH[bit_location],bit_data)==0
            end
        else
            if (bit_location == 1) then
               enable=Helper.And(MODULES_SWTITCH,bit_data)==0
            end
        end
    end
    if not enable then
        printf("模块："..checkstring(modulename).." 状态 已关闭")
        --  self:dispatchEvent(gg.Event.SHOW_TOAST,"正在拼命研发中,暂未开放")
    end
    return enable
end

function App:CanShowMatch()
    -- 多开App跳过
    if require("QuickTest"):canQuickTest() then return true end
    -- 内网测试跳过
    if IS_LOCAL_TEST then return true end

    if not self:CheckModuleEnable(ModuleTag.DDZHMatch) then
        return false
    end

    local match_limit = checkint(MATCH_LIMIT_CNT)
    if match_limit == -1 then return false end
    if match_limit == 0 then return true end
    if hallmanager then
        local totalCnt = checkint(hallmanager:GetEffortData(EffortData.TOTAL_GAME_COUNT))
        if totalCnt < match_limit then return false end
    end
    return true
end

-- 创建朋友场开关，根据设置的游戏局数设定(-1:关闭 0:开启 其它数值:大于等于该数值开启)
function App:CanCreateFriendRoom()
    -- 多开App跳过
    if require("QuickTest"):canQuickTest() then return true end
    -- 内网测试跳过
    if IS_LOCAL_TEST then return true end

    local friend_room_limit = checkint(FRIEND_ROOM_LIMIT)
    if friend_room_limit == -1 then return false end
    if friend_room_limit == 0 then return true end
    if hallmanager then
        local totalCnt = checkint(hallmanager:GetEffortData(EffortData.TOTAL_GAME_COUNT))
        if totalCnt < friend_room_limit then return false end
    end
    return true
end

-- 1：微信-- 2：支付宝-- 4：银联-- 8：AppStore
--获取支付开关表
function App:GetPaySwitchTable()
    local switch = {
        { id = 1, visible = Helper.And(PAY_SWITCH,1)~=0 },
        { id = 2, visible = Helper.And(PAY_SWITCH,2)~=0 },
        { id = 3, visible = Helper.And(PAY_SWITCH,4)~=0 },
        { id = 4, visible = Helper.And(PAY_SWITCH,8)~=0 }
   }
   return switch,gg.TableValueNums(switch, function(v) return v.visible end)
end

function App:GetHallManager(callback)
    if not hallmanager or not hallmanager:IsConnected() then
        self:ReconnectToHall(function(errcode)
            if errcode==0 then
                gg.InvokeFunc(callback,hallmanager)
            end
        end,true)
    else
        gg.InvokeFunc(callback,hallmanager)
    end
    return hallmanager
end

-- 创建房间管理器
function App:CreateRoomManager(roomid,roomtype,callback)
    local nRoomType = gg.GetRoomMode(roomtype);
    local function getRoomMgrObj(type)
        local RoomTypeTable = require("hall.models.RoomTypeConfig")
        local roomname = RoomTypeTable[nRoomType]
        if roomname and string.len(roomname) > 0 then
            local ok, cls = pcall(function()
                return require(roomname)
            end)
            if ok then
                return cls.new(callback)
            else
                print(cls)
            end
        end
        return nil
    end

    local roommgr = getRoomMgrObj(roomtype)
    if roommgr and hallmanager then
        roommgr:SetRoomInfo(hallmanager, roomid);
        if roommgr:Initialize() then
            return roommgr;
        else
            printf("初始化房间失败!");
            roommgr:Shutdown();
        end
    else
        self:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG, "该房间暂未开放！")
    end
end

--//创建登陆管理器
function App:CreateLoginManager(autologin)
    if hallmanager ~= nil then
        hallmanager:dealloc()
    end
    printf("function App:CreateLoginManager() "..tostring(autologin))

    -- 自动登录的用户没有已阅读用户协议的记录字段时，不自动登录
    local isAgreeProtocol = (checkint(cc.UserDefault:getInstance():getIntegerForKey("AgreeUserProtocol")) == 1)

    if autologin and gg.Cookies:GetDefRole() and gg.LoginHelper:CanAutoLogin() and isAgreeProtocol then --自动登录
        self:dispatchEvent(gg.Event.SHOW_LOADING, "正在自动登录,请稍后。。。")
        gg.LoginHelper:DoAutoLogin(function(errcode)
            -- 自动登录失败，展示登录界面
            if errcode ~= 0 then
                self:CreateLoginManager(false)
            end
        end)
    else
        self.reconnecting_=false
        -- 显示登录按钮页面
        self.curScene_ = require("common.LaunchScene").new("LoginScene",App.SCENE_BG):run()
        local viewClass = require("login.views.LoginView")
        local viewObj = viewClass.new(self.curScene_, "LoginView")
        self.curScene_:pushViewInScene(viewObj)
            -- 停止背景音乐
        gg.AudioManager:stopBackgroundMusic()
    end
    return true
end


--//创建大厅管理器
function App:CreateHallManager(session, userid, serverip, serverport)
    -- 2018-7-31 将地区配置表中的市辖区替换为xx市区
    local areaConfig = self:getAreaConfig()
    for k,v in pairs(areaConfig) do
        if string.find(v, "市辖区") then
            local code = tonumber(string.sub(tostring(k), 1, string.len(k) - 2))
            local name = areaConfig[code]
            if name and string.len(name) > 1 then
                if string.find(name, "市$") then
                    areaConfig[k] = name .. "区"
                else
                    areaConfig[k] = name .. "市区"
                end
            end
        end
    end

    local HallManager = require("hall.managers.HallManager")
    local hallmgr = HallManager:getInstance()
    if hallmgr and hallmgr:Connect( {id=userid,session=session,ip=serverip,port=serverport}) then
        if not self.reconnecting_ then
            gg.UserData:initWithUserId(userid)
            self.curScene_ = require("hall.scene.HallScene").new("HallScene", App.SCENE_BG):run()
            -- 添加背景
            local bg = self.curScene_:createView("BackgroundView")
            bg:setName( "BackgroundView" )
            bg:addTo(self.curScene_)

            local fileName = nil
            if PACKAGE_TYPE == 1 then
                -- 扑克单包大厅
                fileName = "HallMainView1"
            elseif PACKAGE_TYPE == 2 then
                -- 常规包大厅
                fileName = "HallMainView2"
            elseif PACKAGE_TYPE == 4 then
                -- oppo大厅
                fileName = "HallMainViewTypeB"
            else
                -- 自运营大厅
                fileName = "HallMainViewTypeA"
            end
            local viewObj = require("hall.views.newhall." .. fileName).new(self.curScene_, "HallMainView")
            self.curScene_:pushViewInScene(viewObj)

            local view = "newhall.HallMenuView"
            if PACKAGE_TYPE == 2 then
                view = "newhall.HallMenuView2"
            end
            -- 添加FramView
            local hallFrameView = self.curScene_:createView(view)
            hallFrameView:setName( "HallFrameView" )
            hallFrameView:addTo(self.curScene_)

            gg.ShowLoading(self.curScene_,"正在连接服务器...",CONNECT_TIMEOUT,function(...)
                 self:dispatchEvent(gg.Event.NETWORK_ERROR,NET_ERR_TAG_HALL,-4)
             end)

            self:CreateSelectAreaView(false)
        end
        return true
    end
    return false
end

function App:doSelectRegionEvent(region)
    local curRegion = gg.LocalConfig:GetRegionCode()
    if region == curRegion then
        return
    end
    local doEvent = function ( ... )
        -- 存储选择的地区
        gg.LocalConfig:SetRegionCode(region)
        -- 切换了地区，清除之前添加的游戏数据
        gg.LocalConfig:ClearCustomGameTable()
        -- 清除之前地区拉取的荣誉值排名数据
        gg.HonorHelper:cleanup()
        -- 发送选择地区通知
        GameApp:dispatchEvent(gg.Event.HALL_SELECT_AREA)
        -- 地区码变化，重新拉取cfg_game配置
        gg.GameCfgData:PullGameCfg()

        local function callback(result)
            printf("新用户登录发送地区码给服务端:%s", tostring(result.msg))
            if REGION_CODE == 0 then
                -- 家乡棋牌产品，走一遍断线重连来获取最新的数据
                GameApp:UpdateReconnectState(false, true)
                GameApp:ReconnectToHall(nil, true, true)
            end
        end
        gg.Dapi:UserRegion(gg.LocalConfig:GetRegionCode(), callback)
    end
    -- 防止玩家数据未初始化的时候刷新界面报错
    if not hallmanager or not hallmanager.userinfo then
        gg.CallAfter(0.5, function ( ... )
            self:doSelectRegionEvent(region)
        end)
    else
        doEvent()
    end
end

function App:AutoSelectRegion(selectView)
    local selectTimeout = 3
    -- 添加雷达扫描界面
    local loadingView = require("ui.leida.leida").create()
    if not tolua.isnull(selectView) and loadingView then
        local animation = loadingView.animation
        loadingView.root:runAction(animation)
        loadingView.root:setPosition(display.width/2, display.height/2)
        animation:play("animation0", true)
        selectView:addChild(loadingView.root)
    end
    -- 获取玩家定位
    local province, city, district, adcode
    device.requestReGeocode(function (gpsInfo)
        gpsInfo = checktable(gpsInfo)
        province = gpsInfo.province
        city = gpsInfo.city
        district = gpsInfo.district
        adcode = gpsInfo.adcode
    end)
    -- 延迟执行自动选择地区操作
    gg.CallAfter(selectTimeout, function ()
        if loadingView then
            loadingView.root:removeSelf()
        end

        if tolua.isnull(selectView) then
            return
        end
        -- 测试数据
        -- province = "贵州省"
        -- city = "贵阳市"
        -- district = "白云区"
        -- adcode = "520113"

        -- 没获取到定位
        if not province or not city or not district or not adcode then
            GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "定位失败请手动选择")
            selectView:setMapButtonEnable(true)
            return
        end

        local areaConfig = self:getAreaConfig()
        local regionCode = checkint(string.sub(adcode, 1, 2))   -- REGION_CODE
        local cityCode = checkint(string.sub(adcode, 1, 4))     -- 城市编码
        local areaCode = checkint(adcode)                       -- 地区码

        -- 省包和定位不匹配 手动选择地区
        if REGION_CODE > 0 and REGION_CODE ~= checkint(regionCode) then
            GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "定位失败请手动选择")
            selectView:setMapButtonEnable(true)
            return
        end

        local playAutoSelectAnimation = function (_regionCode, _cityCode, _areaCode)
            if checkint(_areaCode) > 0 then
                if not tolua.isnull(selectView) then
                    if selectView.showAutoSelectAnimation then
                        selectView:showAutoSelectAnimation(_regionCode, _cityCode, _areaCode)
                    else
                        self:doSelectRegionEvent(_areaCode)
                        selectView:removeSelf()
                    end
                end
            end
        end
        if areaConfig[areaCode] then
            -- 匹配到地区码，播放自动选区动画
            playAutoSelectAnimation(regionCode, cityCode, areaCode)
            return
        else
            local newCityCode = checkint(Table:findKey(areaConfig, city))
            local newAreaCode = checkint(Table:findKey(areaConfig, district))
            local isRight = false
            -- newCityCode > 10 考虑到如果是直辖市的情况如北京市
            if newCityCode > 10 and newAreaCode > 100000 then
                local cityRegion = string.sub(tostring(newCityCode), 1, 2)
                local areaRegion = string.sub(tostring(newAreaCode), 1, 2)
                local isSameCity = true
                -- 同一个省市下存在相同区县的情况
                if newCityCode > 1000 and checkint(string.sub(tostring(newAreaCode), 1, 4)) ~= newCityCode then
                    isSameCity = false
                end
                if cityRegion == areaRegion and (areaRegion == REGION_CODE or REGION_CODE == 0) and isSameCity then
                    isRight = true
                end
            end
            if isRight then
                -- 匹配到城市名称和地区名称
                playAutoSelectAnimation(regionCode, newCityCode, newAreaCode)
                return
            else
                -- 匹配到城市但是地区码和地区名称都不匹配，自动分配到直辖市
                newAreaCode = cityCode * 100 + 1
                if areaConfig[newAreaCode] then
                    playAutoSelectAnimation(regionCode, cityCode, newAreaCode)
                    return
                end
            end
        end
        if  not tolua.isnull(selectView) and selectView.setMapButtonEnable then
            GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "定位失败请手动选择")
            selectView:setMapButtonEnable(true)
        end
    end)
end

function App:CreateSelectAreaView(force)
    -- android 审核模式或者单款游戏不选择地区
    -- iOS 审核是也需要开启选择地区
    if (device.platform == "android" and IS_REVIEW_MODE) or (not GameApp:CheckModuleEnable( ModuleTag.Room )) then
        return
    end

    local regionCode = gg.LocalConfig:GetRegionCode()
    if not force and regionCode > 100 then
        -- 不是强制显示，且已经选择过地区，不用再选。
        -- 使用 >100 来判断，是因为如果小于 100 表示只选择了省，还没有选择市和县
        return
    end

    local name = ""
    if REGION_CODE == 0 and (force or regionCode == 0) then
        -- 家乡棋牌产品的话，如果强制显示或者还没选择省，需要从省级开始选
        name = "login/ProvinceMapView"
    else
        -- 其他情况直接选择地级市
        -- 如果配置了对应的省级地图资源，则显示地图版选择地区
        if Helper.IsFileExist(string.format("res/hall/map/map_%d/btn_%d.png", REGION_CODE, REGION_CODE)) then
            name = "login/AreaMapView"
        else
            name = "login/AreaSelectView"
        end
    end

    -- 如果是强制显示，那么可以被关闭
    local selectview = self.curScene_:createView(name, force)
    -- 如果为不显示地图的地区显示，将界面名称重新命名为login/AreaMapView
    if name == "login/AreaSelectView" then
        selectview:setName("login/AreaMapView")
    end

    if force then
        -- 使用 pushInScene 是为了使得弹出的界面可以响应 back 键
        selectview:pushInScene()
    else
        -- 使用 addTo 显示的界面不能响应 back 键
        if selectview.getViewZOrder then
            selectview:setLocalZOrder(selectview:getViewZOrder())
        end
        selectview:addTo(self.curScene_)
        -- 首次进入进行定位，自动选择地区玩法,native版本大于6才有获取地区信息功能
        if gg.GetNativeVersion() >= 6 and device.platform ~= "ios" then
            if selectview and selectview.setMapButtonEnable then
                selectview:setMapButtonEnable(false)
                gg.CallAfter(0, function ( ... )
                    GameApp:AutoSelectRegion(selectview)
                end)
            end
        end
    end
end

--更新断线连接状态  bconnecting 是否连接中 ,是否连接成功
function App:UpdateReconnectState(bconnecting,issuccess)
    printf("UpdateReconnectState bconnecting: %s %s",tostring(bconnecting), tostring(issuccess))
    self.reconnecting_ =bconnecting
    gg.ReconnectModule:didConnectToHall( issuccess)
    if not bconnecting and issuccess then
        if self.curScene_ and not tolua.isnull(self.curScene_)  then
            local view= self.curScene_:getChildByName("connect_failed_dialog")
            if view then view:removeSelf() end
        end
    end
    return self
end

--参数1 是否在断线重连中 参数2 是否连接成功  onstartgame 之前有效
function App:IsReconnecting()
    return self.reconnecting_
end

--判断游戏是否断线中
function App:IsGameDisconnected()
    return not (GameClient and not GameClient.isreconnect)
end

--用于断线重连调用
function App:ReconnectToHall(callback,forcelogin,checkversion)
   if not self.reconnecting_ then
        self.reconnecting_=true
        GameApp:dispatchEvent(gg.Event.RECONNECT_BEGIN)
        if GameClient then
            GameClient.isreconnect=true
        end
        printf("ReconnectToHall ( %s , %s , game reconnecting:%s )",tostring(forcelogin),tostring(checkversion),tostring(self:IsGameDisconnected()))
        forcelogin=true
        if  hallmanager and not forcelogin then
            hallmanager:Reconnect()
        else
            if hallmanager ~= nil then hallmanager:dealloc()  end
            if checkversion then
                self:CheckVersionUpdate(function()  gg.LoginHelper:DoAutoLogin(callback)   end)
            else
                gg.LoginHelper:DoAutoLogin(callback)
            end
        end
    else
        printf("----断线重连中。。。")
   end
   return self
end

--解析协议
function App:HandleUrlScheme(uri)
    printf("handleUrlScheme %s",tostring(uri))
    local sctb = string.split(uri,"://")
    if #sctb>1 then
        local func={
            ["joinroom"]= function(p)
                if p.key and #p.key>0 then
                    hallmanager:JoinFriendRoomByRoomKey(p.key)
                else
                    printf("无效scheme参数 %s",tostring(p.key))
                end
            end
        }
        local paths = checktable(string.split(string.split(sctb[#sctb],"?")[1],'/'))
        local cmd= string.lower(checkstring(paths[#paths]))
        if hallmanager and func[cmd] then
            local params=string.parseurl(sctb[#sctb])
            return  pcall(func[cmd],params)
        else
            printf("error scheme  params ")
        end
    end
end

--切换账号
function App:Logout()
    if hallmanager~=nil  then   hallmanager:dealloc()   end
    if loginmanager~=nil then  loginmanager:dealloc()  end
    gg.UserData:clear()
    gg.GameCfgData:clear()
    gg.Cookies:Logout()
    gg.HonorHelper:cleanup()
    require("libs.yy_utils.YYSound"):logoutYYSDK()
    self:CheckVersionUpdate(function()  self:CreateLoginManager(false)  end)  --版本检查
    -- 玩家退出登录，重置签到弹窗
    cc.exports.SIGN_POPUP = 0
    -- 玩家退出登录，清除防沉迷系统已提示的 flag
    cc.exports.TIRE_TIME_TIP_POPED_1 = nil    -- 3小时的 tip
end

-- 退出游戏
function App:Exit()
    printf("-----------App Exit() ")
    cc.Director:getInstance():endToLua()
    if hallmanager~=nil then
       hallmanager:dealloc()
    end
    if loginmanager then
       loginmanager:dealloc()
    end

    if device.platform == "ios" then
        os.exit()
    end
end

function App:ExportLocalCfg()
    local userRegion = gg.LocalConfig:GetRegionCode()
    local areaRegion = tonumber(string.sub(tostring(userRegion), 1, 2))
    local regionToAppInfo = require("src/region_to_app")
    if userRegion == 0 or (not regionToAppInfo) then
        return
    end

    -- 导出当前所属省的地区码
    cc.exports.USER_AREA_CODE = areaRegion
    local curInfo = regionToAppInfo[areaRegion]
    if not curInfo then
        return
    end

    -- 这里只导出一个 PRODUCT_ID，用于免房号邀请
    cc.exports.PRODUCT_ID = curInfo.product_id
    cc.exports.UPDATE_URL_PREFIX = curInfo.update_url_prefix
end

-- 运行函数
function App:Run()
    -- 清除 app 右上角的角标
    gg.NotificationHelper:cleanBadge()

    -- 清除资源缓存，避免在游戏过程中被触发的热更新（比如在大厅界面断线重连触发热更新）没有使用最新的资源
    -- 对于正常的进入游戏，这行代码没有作用
    gg.ClearCache()

    if CC_SHOW_FPS then
        cc.Director:getInstance():setDisplayStats(true)
    end
    self.event_:bind(self)
    local openappcount = gg.LocalConfig:GetOpenAppCount()
    if openappcount == 0 then
        --todo
        --todo  第一次打开应用 操作
    end
    --游戏打开次数
    printf("打开应用%d次", openappcount)

    if CHANNEL_ID == "12" then
        -- 如果是 12 渠道，需要重新加载 cfg_package 以恢复 APP_ID 等全局变量
        require("src/cfg_package")
        cc.exports.URLKEY = APP_ID..APP_KEY..APP_ID
        -- 通知相应的模块更新数据
        gg.Dapi:refreshAppInfo()
    end

    -- 对于 REGION_CODE = 0 的情况，需要检查本地配置并修改相应的全局变量
    -- 用于 家乡棋牌产品 的逻辑
    -- added by zhangbin
    if REGION_CODE == 0 then
        self:ExportLocalCfg()
    end

    -- 2018-6-14 记录首次安装或者应用大版本更新时的时间戳
    gg.LocalConfig:SetHallUpdateTime(gg.VersionHelper:getModuleClientVer(gg.VersionHelper.VER_MODULE_HALL))

    --todo 测试 跳过更新检测
    self.curScene_ = require("common.LaunchScene").new("LaunchScene",App.SCENE_BG):run()

    -- 版本检查本来是放在 LaunchScene 的 onEnter 回调里面的，但发生版本更新后 reload() 导致
    -- 再次走到这里时，onEnter 回调并不会被执行，最简单的方法就是把版本检查相关的处理放在下一帧
    -- 确保不管是正常进游戏还是下载更新包后 reload() 都能够走版本检查逻辑
    gg.InvokeFuncNextFrame(function()
        -- 快速启动测试
        if require("QuickTest"):canQuickTest() then
            require("QuickTest"):quickLogin()
            return
        end

        local function doLogin()
            self:CreateLoginManager(true)
        end

        self:CheckVersionUpdate(doLogin)  --版本检查
     end)

    self.curScene_:showInitLoading()
    gg.LocalConfig:AddOpenAppCount(1)
end

--启动一个应用命令  格式  shellname://args
function  App:DoShell(node,shell,...)
    local scene=node or self.curScene_
    assert(scene,"scene is nil")
    assert(shell ,"shell is nil")
    local nPos = string.find(shell,"://")
    assert(nPos ,"shell string format error :"..shell)
    if nPos == nil then
        return
    end
    local strType = string.sub(shell,1,nPos-1)
    local strData = string.sub(shell,nPos+3)

    local functionTable={
        ["QuickJoinGame"]=function(params)
            if hallmanager and hallmanager:IsConnected() then
                hallmanager:JoinRoomByGameId(params)
            end
        end,
        ["JoinRoom"]=function(params)   -- 加入房间，params:房间id
            if hallmanager and hallmanager:IsConnected() then
                hallmanager:JoinRoom(tonumber(params), GameApp:IsReconnecting())
            end
        end,
        ["ShowMiniGames"]=function(params, ...)   -- 显示小游戏界面
            -- warming 弹出小游戏的选择界面，并将该界面返回
            -- warming 界面需要提供一个设置回调函数，用于返回用户所选择的小游戏短名
            return scene:createView("room.MiniGamesView",...):pushInScene()
        end,
        ["JoinMiniGame"]=function(params)   -- 进入小游戏，params:游戏短名
            if hallmanager and hallmanager:IsConnected() then
                local game = hallmanager:GetGameByShortName(params)

                -- h5小游戏
                if game.cmd and checkint(game.cmd.h5) == 1 and game.cmd.appid then
                    gg.WebGameCtrl:openGameWebView(game.cmd.appid, game.id)
                    return
                end

                local customEntrance = hallmanager:getGameCustomEntrance(game)
                if customEntrance then
                    dofile(customEntrance)
                else
                    -- 获取小游戏的房间进入
                    local roomid = hallmanager:GetLeisureRoomByGameId(game.id)
                    if roomid then
                        hallmanager:JoinRoom(roomid)
                    end
                end
            end
        end,
        ["HaiDiLaoYue"]=function(params, ...)   -- 显示海底捞月的购买界面
            local needNum = checkint(params)

            if IS_REVIEW_MODE or needNum == 0 or  not GameApp:CheckModuleEnable(ModuleTag.HaiDiLaoYue) then
                return nil
            end

            -- 显示海底捞月的购买界面
            local view = scene:createView("popupGoodsView.HaiDiLaoYueView", needNum)
            view:pushInScene()
            return view
        end,
        ["Challenge"]=function(params)  -- 擂台赛预留  1 可操作 0不可操作
            if  GameApp:CheckModuleEnable( ModuleTag.Arena ) then  --判断擂台比赛是否打开
                scene:createView("arena.ArenaView",params):pushInScene()
            end
        end,
        ["PopupGoodsView"]=function(params, ...)   -- 弹出指定商品的界面，params:道具id&延迟显示时间
            local goodid = params
            local delaytime = 0
            local args = string.split(params, "&")
            if #args == 2 then
                goodid = args[1]
                delaytime = checkint(args[2])
            end
            return gg.PopupGoodsCtrl:popupGoodsView(goodid, delaytime, ...)
        end,
        ["ShowBuyBackView"]=function(params, ...)   -- 显示当局返还计费点，params:输掉的豆豆数量&延迟显示时间
            if IS_REVIEW_MODE then
                -- 审核模式不需要处理
                return
            end

            -- 解析参数
            local beanCount = params
            local delaytime = 0
            local args = string.split(params, "&")
            if #args == 2 then
                beanCount = args[1]
                delaytime = checkint(args[2])
            end

            -- 根据输掉的豆豆来决定需要显示哪个计费点
            local goodsID = gg.PopupGoodsCtrl:getBuyBackGoodsID(checkint(beanCount))
            if goodsID then
                -- 有合适的计费点
                return gg.PopupGoodsCtrl:popupGoodsView(goodsID, delayTime, checkint(beanCount), ...)
            end
        end,
        ["PayTips"]=function(params, giftDiamond)
            local args = string.split(params, "&")
            local goodsId = params
            local doGift = false
            local gameid = 0
            local roomid = 0
            local stage = gg.PayHelper.PayStages.GAME -- 默认情况下 PayTips 只有游戏内调用
            if #args >= 2 then
                -- 有多个参数，那么第一个为 goodsId，第二个为 gift
                -- 第三个为 gameid，第四个为 roomid
                goodsId = args[1]
                doGift = (checkint(args[2]) ~= 0)
                gameid = checkint(args[3])
                roomid = checkint(args[4])
                if args[5] and checkint(args[5]) > 0 then
                    stage = checkint(args[5])
                end
            end

            local StoreData = require("hall.models.StoreData")
            local goodsdata = StoreData:GetGoodsDataById(goodsId)
            if giftDiamond or (goodsdata and goodsdata.type and goodsdata.type == PROP_ID_XZMONEY) then
                -- 钻石不足，提示红包兑换钻石
                GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG, "钻石不足，可以通过兑换获取钻石。",function(bttype)
                    if bttype==gg.MessageDialog.EVENT_TYPE_OK then
                        goodsdata = StoreData:GetGoodsDataById(47)
                        local exchangeView = scene:createView("store.ExchangeView" , goodsdata)
                        exchangeView:pushInScene()
                    end
                end,{ mode=gg.MessageDialog.MODE_OK_CANCEL_CLOSE, cancel="取消", ok="确定"})
                return
            end

            -- 如果可以购买首充，弹出首充计费点界面
            local goods, isFirstPay = gg.PopupGoodsCtrl:getFirstPayOrVIPGoods()
            if goods and isFirstPay then
                return gg.PopupGoodsCtrl:popupGoodsView(goods, nil, true)
            end

            -- 审核屏蔽商城
            if not GameApp:CheckModuleEnable( ModuleTag.Store ) then
                GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "豆豆不足")
                return
            end

            local buyPromptView = require("common.BuyPromptView"):create(doGift, gameid, roomid, stage, giftDiamond)
            buyPromptView:setGoods( goodsdata )
            buyPromptView:pushInScene()
            return buyPromptView
          end,
        ["Store"]=function(params)
            if hallmanager and self:CheckModuleEnable( ModuleTag.Store ) then
                local idxMap = {
                    [1] = "bean",
                    [2] = "prop",
                    [3] = "diamond",
                }
                -- 如果传入的参数是数字或者数字的字符串
                if tonumber(params) then
                    params = idxMap[tonumber(params)]
                end
                local storeView = scene:createView("store.StoreView", params)
                storeView:pushInScene()
                return storeView
            end
         end,
        ["Game"]=function(params)
            hallmanager:JoinRoom(tonumber(params))
         end,
        ["Play"]=function(params) end,
        ["PersonInfo"]=function(params)
            if self:CheckModuleEnable( ModuleTag.PersonInfo ) then
                scene:createView("personal.PersonMainView",tostring(params)):pushInScene()
            end
        end,
        ["Bag"]=function(params) scene:createView("BagMainView",true):pushInScene() end,
        ["CreateRoom"]=function(params) return scene:createView("room.FriendCreateFrame",params):pushInScene() end,

        ["Share"]=function(params)
            local shareTb = gg.UserData:GetShareDataTable()
            if not shareTb.text or not shareTb.icon or not shareTb.url then
                self:dispatchEvent(gg.Event.SHOW_TOAST, "分享失败，请重试！")
            else
                gg.ShareHelper:doShareWebType( shareTb.text, shareTb.icon, shareTb.url, strData ,function(result)
                    printf("分享成功")
                    if checkint(result.status)==0 then
                        -- gg.Dapi:TaskAward(1,nil,nil,function(cb) printf("TaskAward :"..json.encode(cb)) end)
                    end
                end )
            end
         end,
        ["Vip"] = function(params)
            return  scene:createView("store.VipDetailed" , false , gg.IIF( checkint(params) == 1 , true , false ) ):pushInScene()
        end,
        ["BuyProp"] = function(params)
            -- 购买道具
            local propId = checkint(params)
            if propId == 0 then
                GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "道具不足")
                print(tostring(params).." 不是有效的道具 ID")
                return
            end

            -- 商城或者道具购买被屏蔽了
            if (not GameApp:CheckModuleEnable( ModuleTag.Store )) then
                GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "道具不足")
                return
            end

            local goodsdata = require("hall.models.StoreData"):GetGoodInfoByPropID(propId)
            if not goodsdata then
                GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "道具不足")
                print("无法获取道具 "..tostring(propId).." 对应的商品信息")
                return
            end

            gg.PayHelper:showPay( self:getRunningScene() , goodsdata, nil, 0, 0, gg.PayHelper.PayStages.GAME )
        end,
        --福利
        ["WelfareView"] = function(params, ...)
            local storeView = scene:createView("welfare.WelfareView", ...)
            storeView:pushInScene()
        end,
        -- 通用获取奖励界面
        -- params 1为显示关闭按钮 0为点击屏幕任意位置可关闭界面
        ["GetRewardView"] = function(params, ...)
            local vType = checkint(params)
            local view = require("common.widgets.GetRewardCommonView"):create(self, "GetRewardCommonView", vType, ...)
            view:pushInScene()
            return view
        end,
        -- 弹出救济金界面
        -- nGift:救济金数量  nLeftCount:剩余领取数量
        ["PopAlmsView"] = function(params, nGift, nLeftCount)
            local view = scene:createView("newhall.HallAlmsView", nGift, nLeftCount):pushInScene()
            return view
        end,
        ["Activity"] = function(params)
            -- 打开指定的活动界面
            local pageData = {first_but_tag = 1, second_but_tag = params}
            GameApp:dispatchEvent(gg.Event.SHOW_VIEW, "active.ActivityView", {push = true, popup = true}, pageData)
        end,
        ["Monthcard"] = function(params)
            -- 打开月卡界面
            local pageData = {first_but_tag = 2}
            GameApp:dispatchEvent(gg.Event.SHOW_VIEW, "active.ActivityView", {push = true, popup = true}, pageData)
        end,
        ["Voucher"] = function(params)
            -- 打开兑换界面的指定标签
            GameApp:dispatchEvent(gg.Event.SHOW_VIEW, "gift.GiftView", {push = true, popup = true}, params)
        end,
        ["UseJiPaiQi"] = function(params, tips)
            if not hallmanager then return end
            local cnt = hallmanager:GetPropCountByID(PROP_ID_JIPAI)
            if cnt <= 0 then
                GameApp:dispatchEvent(gg.Event.SHOW_TOAST,  "记牌器数量不足。")
                return
            end
            local txt
            if tips and tips ~= "" then
                txt = tips
            else
                txt = string.format("您当前拥有%d天的记牌器，使用后开始计时，确定现在使用吗？", cnt)
            end
            GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG, txt, function(bttype)
                if bttype == gg.MessageDialog.EVENT_TYPE_OK then
                    --使用道具
                    gg.Dapi:UseMemoryCard(function(data)
                        if data.status == 0 then
                            local userID = gg.UserData:GetUserId()
                            hallmanager:DoUseProp(userID, PROP_ID_JIPAI, cnt)
                        end
                    end)
                end
            end, {mode=gg.MessageDialog.MODE_OK_CANCEL_CLOSE, cancel="取消", ok="确定"})
        end,
        -- 购买游戏中的辅助道具，例如记牌器，海底捞月卡
        ["BuyGameProp"]=function(params)
            -- 审核屏蔽商城
            if not GameApp:CheckModuleEnable(ModuleTag.Store) then
                GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "功能尚未完成，敬请期待！")
                return
            end

            local args = string.split(params, "&")
            local goodsId = params
            local doGift = false
            local gameid = 0
            local roomid = 0
            local stage = gg.PayHelper.PayStages.GAME -- 默认情况下 PayTips 只有游戏内调用
            if #args >= 2 then
                -- 有多个参数，那么第一个为 goodsId，第二个为 gift
                -- 第三个为 gameid，第四个为 roomid
                goodsId = args[1]
                doGift = (checkint(args[2]) ~= 0)
                gameid = checkint(args[3])
                roomid = checkint(args[4])
                if args[5] and checkint(args[5]) > 0 then
                    stage = checkint(args[5])
                end
            end

            local StoreData = require("hall.models.StoreData")
            local goodsdata = StoreData:GetGoodsDataById(goodsId)
            gg.PayHelper:showPay(self:getRunningScene(), goodsdata, nil, roomid, gameid, stage)
        end,
        ["Arena"] = function(params)
            --添加开关控制
            if GameApp:CheckModuleEnable( ModuleTag.Arena ) then
                -- 打开擂台赛界面的指定标签
                local pageData = 1
                local params = checkstring(params)
                if params =="star" then --名人堂
                    pageData = 3
                elseif params =="week" then--周擂台
                    pageData = 2
                end
                GameApp:dispatchEvent(gg.Event.SHOW_VIEW, "arena.ArenaView", {push = true, popup = true}, pageData)
            end
        end,
        ["Honor"] = function(params)
            --添加开关控制
            if GameApp:CheckModuleEnable(ModuleTag.Honor) then
                local params = checkstring(params)
                -- 打开荣誉界面的指定标签
                GameApp:dispatchEvent(gg.Event.SHOW_VIEW, "honor.HonorMainView", {push = true, popup = true}, params)
            end
        end,
        ["Games"] = function(params)  --打开游戏列表
            local btndata =
            {
                ["pk"] = "poker",  --扑克
                ["mj"] = "majiang", --麻将
                ["mini"] = "xiuxian", --休闲小游戏
            }
            local params = checkstring(btndata[params])
            if scene then
                local HallMainView = scene:getChildByName("HallMainView")
                local HallFrameView = scene:getChildByName("HallFrameView")
                if HallMainView and HallFrameView then
                    HallMainView:enterGameAction()
                    HallFrameView:joinGameRoom()
                    local view = scene:createView("newhall.HallGameListView",params)
                    view:setName("HallGameListView")
                    view:pushInScene()
                 end
            end
        end,
        ["Match"] = function(params)  --打开比赛列表
            local btndata =
            {
                ["normal"] = "yb",  --锦标赛
                ["welfare"] = "fl", --福利赛
                ["tv"] = "tx", --电视赛
            }
            local params = checkstring(btndata[params])
            if not hallmanager or not hallmanager.games then return end
            local game = hallmanager:GetGameByShortName("ddzh")
            local isNeedUpdate, msg = hallmanager:CheckGameNeedUpdate(game)

            local function joinMatchRoom()
                if not scene then return end
                local hfView = scene:getChildByName("HallFrameView")
                local hmview = scene:getChildByName("HallMainView")
                if hfView and hmview then
                    hfView:joinGameRoom()
                    hfView:updateNodeShow(2)
                    hmview:enterGameAction()
                end
                scene:createView("match.MatchView",params):pushInScene(false)
            end

            if isNeedUpdate then
                local function statuscb_( status, shortname, errmsg )
                    if shortname ~= game.shortname then return end
                    if status == 2 then
                        if scene then
                            gg.ShowLoading(scene)
                        end
                        joinMatchRoom()
                    end
                end
                if scene then
                    gg.ShowLoading(scene, "数据下载中...", 15 )
                end
                hallmanager:DoUpdateGame(game.shortname, statuscb_ )
            else
                joinMatchRoom()
            end
        end,

    }

    local cmdfunction= functionTable[strType]
    if cmdfunction and type(cmdfunction)=="function"  then
        return cmdfunction(strData, ...)
    else
        printf("no cmd shell function : "..shell)
        --Helper.OpenBrowser(shell)
    end

end


--返回按键处理函数  游戏中退出提示需要重写此函数实现
function App:onKeyBackClicked()
    if gg.ThirdParty:thirdPartyHandleQuitGame() then
        -- 第三方已经接管了退出的处理
        return
    end

    local function showExitDialog_()
        self:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG, "确定退出游戏么？",function(bttype)
            if bttype==gg.MessageDialog.EVENT_TYPE_OK then
                if self.Exit then
                   self:Exit()
                end
            end
        end,{ mode=gg.MessageDialog.MODE_OK_CANCEL_CLOSE, cancel="取消", ok="确定"})
    end

    if IS_REVIEW_MODE or (not hallmanager) then
        showExitDialog_()
        return
    end

    --获取玩家的豆
    local money = checkint(checktable(hallmanager.userinfo).money)
    --显示小刺激页面  -- 分数大于10000 并且 小游戏界面开关打开的时候
    if money >= 10000 and hallmanager:HasMiniGames() then

        self:DoShell(nil,"ShowMiniGames://",function(bttype)
            if type(bttype) == "string" then
                local  strname = bttype
                if strname then --进入游戏
                    self:DoShell(nil,"JoinMiniGame://" .. strname)
                end
            else
                if bttype==1 then
                    if self.Exit then
                       self:Exit()
                    end
                end
            end
        end,{mode = 1,ok = "退出 ",cancel = "再玩一会 ",text = "确定退出游戏？ "})
    -- 暂时屏蔽弹出限时特价计费点的逻辑
    -- elseif money < 10000 and GameApp:CheckModuleEnable(ModuleTag.Activity) then
    --         --最小特价礼包
    --     local goodsid = gg.PopupGoodsData:getMinBuyid()
    --     if goodsid then
    --         --显示限时特价页面
    --         local exitView = require("hall.views.popupGoodsView.ExitBuyView"):create(goodsid)
    --         exitView:pushInScene()
    --     else
    --         showExitDialog_()
    --     end
    else
        showExitDialog_()
    end

end

function App:getLoginFailedMsg(result)
    local msgs = {
        "登录失败,账号或者密码错误！(错误码:1)",
        "登录失败,账号或者密码错误！(错误码:2)",
        "登录失败,帐号已经登录！",
        "登录失败,该帐号已经绑定其它机器！",
        "登录失败,该帐号被锁,请与管理员联系",
        "登录失败,服务器忙,请稍后尝试！",
        "登录失败,您尝试的错误次数太多,暂时无法登录",
        "登录失败,您需要输入验证码!",
        "登录失败,验证码已过期或者不存在",
        "登录失败,验证码不正确"
    };

    return msgs[result]
end

function App:IsCommonGame()
    return checkint(PACKAGE_TYPE) == 1
end

function App:getAreaConfig()
    local ret

    if IS_REVIEW_MODE then
        -- 审核模式使用特定的配置
        ret = require("review_areaconfig")
    end

    if not ret or table.nums(ret) == 0 then
        ret = require("areaconfig")
    end
    return ret
end

return App
