
--Author : liacheng
--Date: 2017 - 12 -8
--Describe:拼手气界面

local MiniGamesView = class("MiniGamesView",cc.load("ViewPop"))
MiniGamesView.RESOURCE_FILENAME = "ui/room/minigames_view.lua"
MiniGamesView.MODE_ONE_HOT = 0   --  模式一小刺激
MiniGamesView.MODE_TWO_EXIT = 1  -- 模式二退出游戏

MiniGamesView.EVENT_TYPE_OK = 1   --按钮确定
MiniGamesView.EVENT_TYPE_CANCEL = 2   --按钮取消
MiniGamesView.EVENT_TYPE_CLOSE = 3        --按钮关闭

MiniGamesView.RESOURCE_BINDING = {


    ["panel_bg"]    = { ["varname"] = "panel_bg" },

    ["img_luckbg"]    = { ["varname"] = "img_luckbg" },
    ["img_exitbg"]    = { ["varname"] = "img_exitbg" },

    ["panel_luck"]    = { ["varname"] = "panel_luck" }, --拼手气页面
    ["panel_exit"]    = { ["varname"] = "panel_exit" }, --退出游戏界面
    ["txt_exitname"]    = { ["varname"] = "txt_exitname" },     --退出界面名称
    ["txt_hotname"]    = { ["varname"] = "txt_hotname" },  --小刺激界面名称
    ["ScrollView_game"]    = {["varname"] = "ScrollView_game"},          --翻页容器

    ["btn_close"]   = { ["varname"] = "btn_close", ["events"] = { { ["event"] = "click", ["method"] = "onClick" } } }, -- 关闭按钮

    ["btn_cancel"]  =  { ["varname"] = "btn_cancel", ["events"] = { { ["event"] = "click", ["method"] = "onClick" } } }, -- 取消按钮
    ["btn_exit"]  =  { ["varname"] = "btn_exit", ["events"] = { { ["event"] = "click", ["method"] = "onClick" } } }, -- 确定按钮
}
local GAME_ITEM_HIGHT = 195
local LIST_ITEM_COUNT = 3
local ROOM_ITEM_SPACE = 288  --间隔

local SV_BOTTOM_WIDTH = 870
local SV_BOTTOM_HEIGHT =400
function MiniGamesView:onCreate(callback,params)
    params = checktable(params)
    self.viewname = params.text
    self.callback = callback

    params.mode = params.mode or MiniGamesView.MODE_ONE_HOT
    self:handlerParams(params)
    --初始化
    self:init()

    --自适应
    self:setScale(math.min(display.scaleX, display.scaleY))

    gg.GameCfgData:CheckLoaded(function()
        if tolua.isnull(self) then return end
        self:updateListView()
    end)
    -- 注册消息通知
    self:registerEventListener()

end

function MiniGamesView:handlerParams(params)
    local FuncTable={
        ["ok"]= self.setOkContent,
        ["cancel"]=self.setCancelContent,
        ["mode"]=self.setMode,
    }
    for k,v in pairs(params) do
        local handle= FuncTable[k]
        if handle then
            handle(self,v)
        end
    end
end
--设置退出游戏 的左边按钮
function MiniGamesView:setOkContent(text)
    if text then
        self.btn_exit:getChildByName("txt_name"):setString(tostring(text) or "退出")
    end
    return self
end
--设置退出游戏 的右边按钮
function MiniGamesView:setCancelContent(text)
    if text then
        self.btn_cancel:getChildByName("txt_name"):setString(tostring(text) or "再玩一会")
    end
    return self
end
--设置模式
function MiniGamesView:setMode(mode)
    self.mode=mode
    if mode == MiniGamesView.MODE_ONE_HOT then  --小刺激模式
        self.txt_hotname:setString(self.viewname or "小刺激")
        self.panel_luck:setVisible(true)
        self.panel_exit:setVisible(false)
        self.img_luckbg:setVisible(true)
        self.img_exitbg:setVisible(false)
        GAME_ITEM_HIGHT = 205
    else   --退出游戏模式
        --界面名称
        self.txt_exitname:setString(self.viewname or "退出本游戏？")
        self.panel_exit:setVisible(true)
        self.panel_luck:setVisible(false)
        self.img_exitbg:setVisible(true)
        self.img_luckbg:setVisible(false)
        GAME_ITEM_HIGHT= 255
    end
    return self
end

--[[
* @brief 注册通知
]]
function MiniGamesView:registerEventListener()

    -- 更新完成
    GameApp:addEventListener( "event_game_update_finish" , handler(self,self.onEventUpdateFinish ) ,self )

    -- 更新进度
    GameApp:addEventListener( "event_game_update_progress_changed" , handler(self,self.onEventUpdateChanged ) ,self )
end

--[[
* @brief 初始化
]]
function MiniGamesView:init()


    self.ScrollView_game:setScrollBarEnabled(false)

end

-- 排序（同状态按照minisort排序,不同状态可点击优先）
local sortList = function (a,b)
    local bo = nil
    local itype = checkint(a.cmd.typesort) == checkint(b.cmd.typesort)

    if itype then
        if checkint(a.cmd.minisort) == checkint(b.cmd.minisort) then
            bo = checkint(a.cmd.dsort) < checkint(b.cmd.dsort)
        else
            bo = checkint(a.cmd.minisort) < checkint(b.cmd.minisort)
        end
    else
        bo = checkint(a.cmd.typesort) < checkint(b.cmd.typesort)
    end
    return bo
end

--根据条件 获取即将进入的房间
function MiniGamesView:GetRoomByCondition(gameid)
    gameid=checkint(gameid)
    local roommode  = Helper.Or(ROOM_TYPE_ALLOCSIT,ROOM_TYPE_ALLOCSIT2)
    local gamerooms= hallmanager:GetRoomsByGameId(gameid)
    gamerooms=hallmanager:FilterRoomsByMode(gamerooms,roommode)
    gamerooms=hallmanager:FilterMatchRooms(gamerooms) -- 过滤掉比赛房间，即比赛房间不能通过推荐自动进入
    for k,v in pairs(checktable(gamerooms)) do
        return  gamerooms[k]
    end
    return  nil
end

--[[
* @brief 更新列表信息
* @brief roomList 更新列表信息
]]
function MiniGamesView:updateListView()

    self._gameList = {}                     -- 房间数据

    -- 清除页面
    self.ScrollView_game:removeAllChildren()
    if not hallmanager then
        return
    end
    --添加小游戏
    self._gameList =  hallmanager:GetLeisureGame()
    
    --不显示配置为srl的游戏
    for i=#self._gameList, 1, -1 do
        local game = self._gameList[i]
        if game and game.cmd and checkint(game.cmd.srl) == 1 then
            table.remove(self._gameList, i)
        end
    end

    for k, v in pairs(self._gameList) do
        -- 记录游戏的默认排序
        v.cmd.dsort = k
        --是否有游戏房间
        local room  = hallmanager:GetLeisureRoomByGameId(v.id)
        if checkint(v.cmd.h5) ~=1 and (checkint(v.cmd.develop )== 1 or not room) then --不能点击的
            v.cmd.typesort= 2
        else
            v.cmd.typesort= 1
        end
    end
    --排序
    table.sort( self._gameList, sortList )
    --数据不够补空游戏item  4代表一个页面4个游戏
    if #self._gameList <LIST_ITEM_COUNT then
        local complatedatacount = LIST_ITEM_COUNT - #self._gameList
        for i = 1,complatedatacount do
            table.insert(self._gameList, { nilgame= 1})
        end
    end

    self.ScrollView_game:setInnerContainerSize( {width =SV_BOTTOM_WIDTH + (#self._gameList-LIST_ITEM_COUNT) *ROOM_ITEM_SPACE, height = SV_BOTTOM_HEIGHT} )
    for k, v in pairs(self._gameList) do
         -- 创建
        local roomView = self:createView(v)

        -- 设置位置
        roomView:setPositionX(-140+ROOM_ITEM_SPACE *k )
        roomView:setPositionY(GAME_ITEM_HIGHT)
       self.ScrollView_game:addChild(roomView)
    end
end
--按钮点击
function MiniGamesView:onClick(sender)
    local event_type = 1
    if sender == self.btn_close then  --关闭按钮
        event_type = MiniGamesView.EVENT_TYPE_CLOSE
    elseif sender == self.btn_cancel then --取消按钮
        event_type = MiniGamesView.EVENT_TYPE_CANCEL
    elseif sender == self.btn_exit then --确定按钮
        event_type = MiniGamesView.EVENT_TYPE_OK
    end
    if self.callback then
        self.callback(event_type)
    end
    self:removeSelf()
end

--[[
* @brief 创建房间View
* @brief roomData 房间数据
]]
function MiniGamesView:createView(data)

    if not data then
        return
    end
    -- 创建试图
    local lua_ui = require("ui/room/item_minigames.lua").create()
    -- 点击的背景
    local img_bk = lua_ui.root:getChildByName("img_bg")
    -- 这里将 img_bk 的上级 node 从节点树移除
    -- 是为了解决房间列表中无法在 item 区域进行拖拽的问题
    lua_ui.root:removeChild(img_bk)
    local item = ccui.Layout:create()
    item:addChild(img_bk)

    img_bk:setSwallowTouches(false)

    -- 更新数据
    self:updateItemViewData( img_bk ,data )

    return item
end

function MiniGamesView:updateItemViewData( itemView , data )
    if not itemView or not data then
        return
    end

    -- 标题
    local img_bk = itemView
    local btn_icon = img_bk:getChildByName("btn_icon")  --游戏按钮
    local img_logobg = btn_icon:getChildByName("img_logobg") --logo图片
    local img_icon = btn_icon:getChildByName("img_icon") --item远程图片
    local txt_name = btn_icon:getChildByName("txt_name") --游戏名字
    local txt_minMoney = btn_icon:getChildByName("txt_minMoney")  --最小入场
    local img_bg2 = btn_icon:getChildByName("Image_3")   --背景遮罩

    local panel = img_bk:getChildByName("panel") -- 进度条
    local txt = panel:getChildByName("txt") -- 进度条文字

    local img_jqqd = img_bk:getChildByName("img_jqqd") -- 敬请期待图片

    local img_right = btn_icon:getChildByName("img_right")  --右边的图片
    local img_left = btn_icon:getChildByName("img_left")  -- 入场金额左边的图片
    --设置默认背景图片
    img_logobg:loadTexture(CUR_PLATFORM.."/unifyicon.png" , 0 )

    if data.nilgame then  --补全敬请期待的图片
        btn_icon:setEnabled(false)
        img_jqqd:setVisible(true)
        txt_minMoney:setVisible(false)
        txt_name:setVisible(false)
        img_bg2:setVisible(false)
        img_icon:loadTexture("hall/room/minigames/wushuju.png",0 )
        img_icon:setVisible(true)
        return
    end

    --背景点击下载游戏
    btn_icon:onClickScaleEffect( function( )
        --游戏数据 ，进度条 ， 进度条文本
        self:onClickRoom( data,panel, txt )
    end )
    -- 进度条
    self._progress = nil
    -- 添加进度条
    self:addProgress(panel)
    -- 默认隐藏下载进度
    panel:setVisible(false)

    --游戏名字
    if data.name then
        txt_name:setVisible(true)
        txt_name:setString(data.name)
    end
    --默认隐藏远程图片加载成功在显示
    img_icon:setVisible(false)

    --设置最小入场金额
    txt_minMoney:setVisible(false)
    --获取最小入场分数
    local minMoney = 0
    local roomid = hallmanager:GetLeisureRoomByGameId(data.id)
    if roomid then
        local roomInfo = hallmanager.rooms[roomid]
        minMoney = checkint(roomInfo.minmoney)
    end

    local unLoadTxt = nil
    local loadedTxt = nil

    --是否有游戏房间
    local room  = self:GetRoomByCondition(data.id)
    if checkint(data.cmd.h5) ~=1 and (checkint(data.cmd.develop )== 1 or not room) then --开发中 ----没有房间
        btn_icon:setEnabled(false)
        img_jqqd:setVisible(true)
    else
        btn_icon:setEnabled(true)
        img_jqqd:setVisible(false)

        if minMoney > 0 then
            unLoadTxt = self:creatRichLable(minMoney, 26, 1)
            unLoadTxt:setPosition(cc.p(txt_minMoney:getPositionX() + 130, txt_minMoney:getPositionY() + 10))
            btn_icon:addChild(unLoadTxt)

            loadedTxt = self:creatRichLable(minMoney, 20, 0.5)
            loadedTxt:setPosition(cc.p(txt_minMoney:getPositionX() + 5, txt_minMoney:getPositionY()))
            loadedTxt:setVisible(false)
            img_right:setPositionX(txt_minMoney:getPositionX() - loadedTxt:getSize().width/2)
            img_left:setPositionX(txt_minMoney:getPositionX() + loadedTxt:getSize().width/2 + 10)
            btn_icon:addChild(loadedTxt)
        end
    end

    -- 使用web的图片
    if data.cmd.minico then
        local url = APP_ICON_PATH..data.cmd.minico..".png"
        gg.ImageDownload:LoadHttpImageAsyn(url , img_icon,function()
            if tolua.isnull(self) then return end
            img_icon:setVisible(true)
            txt_name:setVisible(false)
            img_bg2:setVisible(false)

            if unLoadTxt then unLoadTxt:setVisible(false) end
            if loadedTxt then
                loadedTxt:setVisible(true)
                img_left:setVisible(true)
                img_right:setVisible(true)
            end
        end)
    end
end

local function changeNum_(count)
    if count >= 1000000 then
        return gg.MoneyBaseUnit(count, 1000000) .. "百万"
    elseif count >= 10000 then
        return gg.MoneyBaseUnit(count, 10000) .. "万"
    elseif count >= 1000 then
        return gg.MoneyBaseUnit(count, 1000) .. "千"
    else
        return tostring(count)
    end
end

function MiniGamesView:creatRichLable(minMoney, txtSize, txtAnc)
    local RichLabel = require("common.richlabel.RichLabel")
    local richLb = RichLabel.new{
        fontSize = txtSize,
        fontColor = cc.c3b(255, 255, 255),
    }
    richLb:setString(string.format("%s豆入", changeNum_(minMoney)))
    richLb:walkElements(function(node, index)
        local ss = node:getString()
        if not tonumber(ss) then
            node:setFontSize(txtSize + 2)
        end
    end)
    richLb:setAnchorPoint(cc.p(txtAnc, 0.5))
    return richLb
end

--[[
* @brief 添加进度条
]]
function MiniGamesView:addProgress(panel)

    -- 创建进度条
    local progress = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("hall/room/minigames/img_jindutiao_2.png"))
    progress:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
    panel:addChild( progress)
    local ps = panel:getContentSize()
    progress:setPosition(  cc.p( ps.width / 2 , ps.height / 2 ) )
    self._progress = progress
end

--[[
* @brief 设置进度条进度
]]
function MiniGamesView:setSchedule( p )

    if self._progress then

        self._progress:setPercentage( p )
    end

    if p == 0 then

        -- 等待
        self.txt:setString("等待")
    else

        -- 进度
        self.txt:setString(p.."%")
    end
end


--[[
* @brief 更新完成
]]
function MiniGamesView:onEventUpdateFinish( event , shortname , error_ )
    if tostring(self._shortname) == tostring(shortname) then

        -- 隐藏并且重置进度
        self.panel:setVisible(false)
        self:setSchedule(0)
        --下载错误
        if error_ then
            if self.callback then
                self.callback(MiniGamesView.EVENT_TYPE_CLOSE)
            end
        else
            --已下载返回回调
            if self.callback then
                self.callback(self._shortname)
            end
        end
        --关闭页面
        self:removeSelf()

    end
end

--[[
* @brief 更新进度
]]
function MiniGamesView:onEventUpdateChanged( event , p , shortname )
    if tostring(self._shortname) == tostring(shortname)then
        -- 设置进度
        self:setSchedule(p)
        self.panel:setVisible(true)
    end
end


--点击更新
function MiniGamesView:onClickRoom(data,panel, txt)
    --点击按钮播放声音
    gg.AudioManager:playClickEffect()

    self.data = data
    self.panel = panel
    self.txt = txt
     --获取短名
    self._shortname = data.shortname

    -- h5 游戏点击直接返回
    if checkint(data.cmd.h5) == 1 then
        if self.callback then
            self.callback(self._shortname)
        end
        --关闭页面
        self:removeSelf()
        return
    end

    if not hallmanager then
        if self.callback then
            self.callback()
        end
        --关闭页面
        self:removeSelf()
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "游戏进入失败，请稍后重试。")
        return
    end
    local isNeedUpdate, msg = hallmanager:CheckGameNeedUpdate( data)
    if isNeedUpdate and serverVer == 0 then
        -- 需要更新，但是服务器并没有游戏版本
        local theUrl = data.cmd.openurl
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

    --游戏的处理
    if isNeedUpdate then
        -- 发送下载游戏通知
        GameApp:dispatchEvent(gg.Event.MINIGAMES_DOWNLOAD,self._shortname)
        -- 显示更新
        self.panel:setVisible(true)
        hallmanager:DoUpdateGame(data )
    else
        --已下载返回回调
        if self.callback then
            self.callback(self._shortname)
        end

        --关闭页面
        self:removeSelf()
    end

end


--返回按钮
function MiniGamesView:keyBackClicked()
    --返回回调
    if self.callback then
        self.callback(MiniGamesView.EVENT_TYPE_CLOSE)
    end

    self:removeSelf()
 end


return MiniGamesView