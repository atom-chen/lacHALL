--Author: liacheng
--Date:2017-12-11
--小刺激单项

local HotItem = class("HotItem",cc.load("ViewLayout"))
HotItem.RESOURCE_FILENAME = "ui/room/item_hot.lua"
HotItem.RESOURCE_BINDING = {
    ["img_bg"]      = {["varname"] = "img_bg"     },   -- 背景
    ["txt_min"]     = {["varname"] = "txt_min"    },   -- 最小入场文字
    ["txt_min_1"]   = {["varname"] = "txt_min_1"  },   -- 默认最小入场文字
    ["img_min"]     = {["varname"] = "img_min"    },
    ["panel"]       = {["varname"] = "panel"      },   -- 进度条
    ["img_load"]    = {["varname"] = "img_load"   },   -- 加载图片
    ["txt"]         = {["varname"] = "txt"        },   -- 进度条文字
    ["img_icon"]    = {["varname"] = "img_icon"   },   -- item图片
    ["txt_name"]    = {["varname"] = "txt_name"   },   -- item名字
    ["action_node"] = {["varname"] = "action_node"},
}

HotItem.SPECIAL_TAG = {
    FISH_GAMES = -1,
}

function HotItem:onCreate(data)
    self:enableNodeEvents()

    self:setContentSize(cc.size(184, 114))
    --点击item不能翻页的解决方法
    self.img_bg:retain()
    self.img_bg:removeFromParent( true )
    self:addChild( self.img_bg )
    self.img_bg:release()

    -- 隐藏动画节点
    self.action_node:setVisible(false)
    self.animation = self.resourceNode_["animation"]
    self:runAction(self.animation)

    --设置默认背景图片
    self.img_icon:loadTexture(CUR_PLATFORM.."/img_moren.png" , 0 )
    self.txt_min:setVisible(false)
    self.img_min:setVisible(false)
    --item的点击
    self.img_bg:onClickScaleEffect(handler(self, self.onClickRoom))
    self:initView(data)

     -- 默认隐藏下载进度
    self.panel:setVisible(false)
    -- 注册消息通知
    self:registerEventListener()
end

--开始动画
function HotItem:startAction()
    -- 显示动画节点并播放动画
    self.action_node:setVisible(true)
    if self.animation then
        self.animation:play("hot_animation", true)
    end
end

-- 退出
function HotItem:onExit()
    if CLICKED_HOT_ITEM and CLICKED_HOT_ITEM == self then
        CLICKED_HOT_ITEM = nil
    end
end

-- 设置回调
function HotItem:setCallFun(fun)
    self._callback = fun
end

function HotItem:initView(data)
    if not data then return end
    self._data = data
    if self._data.id == HotItem.SPECIAL_TAG.FISH_GAMES then
        self.txt_name:setVisible(false)
        self.img_icon:loadTexture("hall/newhall/img_fish_games.png", 0)
        return
    end

    self._shortname = data.shortname
    -- 如果有指定图片，下载并显示图片
    self.txt_name:setVisible(true)
    if data.cmd.hotname then
        self.txt_name:setString(data.cmd.hotname)
    elseif data.name then
        self.txt_name:setString(data.name)
    end

    --设置最小钱数
    local tipStr = nil
    local roomid = hallmanager:GetLeisureRoomByGameId(data.id)
    if roomid then
        local room = hallmanager.rooms[roomid]
        if room and room.cmd.hottip then
            tipStr = room.cmd.hottip
        elseif room and room.minmoney and room.minmoney > 0 then
            local minmoney = String:numToZn(room.minmoney, 4, 0)
            tipStr = minmoney .. "豆入"
        end
    end

    if tipStr then
        self.txt_min:setVisible(false)
        self.txt_min:setString(tipStr)
        self.img_min:setVisible(true)
        self.txt_min_1:setString(tipStr)
    end

    -- icon
    self.img_icon:ignoreContentAdaptWithSize(true)
    if data.cmd.hico then
        local url = APP_ICON_PATH .. data.cmd.hico .. ".png"
        gg.ImageDownload:LoadHttpImageAsyn(url, self.img_icon, function()
            if tolua.isnull(self) then return end
            self.txt_name:setVisible(false)
            self.img_min:setVisible(false)
            if tipStr then
                self.txt_min:setVisible(true)
                self.txt_min:getChildByName("img_line_1"):setPositionX(0)
                self.txt_min:getChildByName("img_line_2"):setPositionX(self.txt_min:getContentSize().width)
            end
        end)
    end

    --播放特效
    if data.cmd.hot then
        self:startAction()
    end
end

-- 注册通知
function HotItem:registerEventListener()
    -- 更新完成
    GameApp:addEventListener("event_game_update_finish", handler(self, self.onEventUpdateFinish), self)
    -- 更新进度
    GameApp:addEventListener("event_game_update_progress_changed", handler(self, self.onEventUpdateChanged), self)
end

-- 设置进度条进度
function HotItem:setSchedule(p)
    if p == 0 then
        self.txt:setString("等待")
    else
        self.txt:setString(p .. "%")
    end
end

-- 更新完成
function HotItem:onEventUpdateFinish(event, shortname, error_)
    if tostring(self._shortname) == tostring(shortname) then
        -- 隐藏并且重置进度
        self.img_load:stopAllActions()
        self.panel:setVisible(false)
        self:setSchedule(0)
        -- 如果是准备进入的游戏短名，则下载完成后需要再模拟一次点击事件
        -- 这里模拟点击事件是因为如果点击的是游戏，不能直接调用进入房间
        if CLICKED_HOT_ITEM and CLICKED_HOT_ITEM == self and not error_ then
            self:doIconClick()
        end
    end
end

-- 更新进度
function HotItem:onEventUpdateChanged(event, p, shortname)
    if tostring(self._shortname) == tostring(shortname)then
        -- 设置进度
        self:setSchedule(p)
        self.panel:setVisible(true)
    end
end

function HotItem:onClickRoom()
    gg.AudioManager:playClickEffect()
    self:doIconClick()
end

function HotItem:doIconClick(sender, eventType)
    -- 清除之前记录的点击对象
    cc.exports.CLICKED_HOT_ITEM = nil

    if self._data.id == HotItem.SPECIAL_TAG.FISH_GAMES then
        self:getScene():createView("newhall.HallFishGamesView"):pushInScene()
        return
    end

    if hallmanager and hallmanager.games then
        -- 检测游戏的命令行参数限制参数
        local cmdmsg = hallmanager:CheckGameCmdLimit(self._data)
        if cmdmsg then
            GameApp:dispatchEvent(gg.Event.SHOW_TOAST, cmdmsg)
            return
        end

        -- h5小游戏
        if self._data.cmd and checkint(self._data.cmd.h5) == 1 and self._data.cmd.appid then
            gg.WebGameCtrl:openGameWebView(self._data.cmd.appid, self._data.id)
            return
        end

        -- 检查游戏是否需要更新
        local isNeedUpdate, msg = hallmanager:CheckGameNeedUpdate(self._data)
        local serverVer = checkint(self._data.version)
        if isNeedUpdate and serverVer == 0 then
            -- 需要更新，但是服务器并没有游戏版本
            local theUrl = self._data.cmd.openurl
            if theUrl and #theUrl then
                -- 如果游戏的 cmd 中配置了 openurl，那么直接打开相应的网页
                -- 用于为其他游戏倒量，比如：捕鱼
                device.openURL(Url:addParams(theUrl, {channel_id=CHANNEL_ID}))
                return
            else
                -- 提示游戏在开发中
                GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "攻城狮正在加班加点开发,敬请期待")
                print("游戏的最新版本是 0，无法下载")
                return
            end
        end

        if isNeedUpdate then
            -- 记录点击的游戏图标对象
            cc.exports.CLICKED_HOT_ITEM = self
            -- 显示更新
            local action = cc.RepeatForever:create(cc.RotateBy:create(1.5, 360))
            self.img_load:runAction(action)
            self.panel:setVisible(true)
            hallmanager:DoUpdateGame(self._data)
            return
        end
        -- 如果游戏有自定义入口文件，调用之
        local customEntrance = hallmanager:getGameCustomEntrance(self._data)
        if customEntrance then
            dofile(customEntrance)
        else
            -- 休闲类小游戏根据游戏找到对应的房间直接加入，如果没有则提示敬请期待
            local roomid = hallmanager:GetLeisureRoomByGameId(self._data.id)
            if not roomid then
                GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "攻城狮正在加班加点开发,敬请期待")
                print("游戏服务器没有启动，没有房间。。。")
                return
            end

            self:joinGameRoom(roomid)
        end
    end

    if self._callback then self._callback() end
end

function HotItem:joinGameRoom(roomid)
    if hallmanager and hallmanager:IsConnected() then
        if hallmanager:IsInFriendRoom() then return end
        hallmanager:JoinRoom(roomid, false)
    end
end

return HotItem