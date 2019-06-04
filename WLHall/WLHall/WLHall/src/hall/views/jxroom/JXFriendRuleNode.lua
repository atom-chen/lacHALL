
----------------------------------------------------------------------
-- 作者：Cai
-- 日期：2018-08-24
-- 描述：朋友场创建规则界面
----------------------------------------------------------------------

local M = class("JXFriendRuleNode", cc.load("ViewBase"))

M.RESOURCE_FILENAME = "ui/room/friendroom/jx_create_rule_node.lua"
M.RESOURCE_BINDING = {
    ["txt_tips"]    = {["varname"] = "txt_tips"},
    ["img_line"]    = {["varname"] = "img_line"},
    ["img_download"]= {["varname"] = "img_download"},
    ["btn_create"]  = {["varname"] = "btn_create", ["events"] = {{event = "click", method = "onClickCreate"}}},
    ["btn_update"]  = {["varname"] = "btn_update", ["events"] = {{event = "click", method = "onClickUpdate"}}},
}

-- 规则本地缓存
local fcData = require("hall.models.FriendCreateData")

local VIDEO_OPTION_NAME = "实时视频"
local RADIO_BTN_FONTSIZE = 30
local RADIO_BTN_COLOR_NOR = cc.c3b(143, 78, 12)
local RADIO_BTN_COLOR_SEL = cc.c3b(232, 113, 20)

local RULE_TITLE_COLOR = cc.c3b(108, 54, 0)
local RULE_TITLE_FONTSIZE = 30

--[[
@pram shortName 传入的游戏名,短名,4个字母的
@pram fkval 房卡消耗的倍数
]]--
function M:onCreate(shortName, enterType, clubId, managerid, cLubRule, convenientTag)
    -- 初始化
    self:init(shortName, enterType, clubId, managerid, cLubRule, convenientTag)
    -- 初始化View
    self:initView()
end

function M:init(shortName, enterType, clubId, managerid, cLubRule, convenientTag)
    self._enterType = enterType or 1
    self._clubId = clubId or 0
    self._managerid = managerid
    -- 游戏短名
    self._shortName = shortName
    self:refreshData()

    self._convenientTag = convenientTag
    self._loadClubRule = checktable(cLubRule)
    -- 规则
    self._rule = nil

    if self:isConvenientCreate() then
        self.btn_create:loadTextureNormal("hall/room/jxroom/create_btn_bc.png",1)
        self.btn_create:loadTexturePressed("hall/room/jxroom/create_btn_bc.png",1)
        self.btn_create:loadTextureDisabled("hall/room/jxroom/create_btn_bc.png",1)
    end
    -- 线处理函数
    gg.LineHandle(self.img_line)
end

function M:refreshData()
    -- 房卡消耗
    if hallmanager and hallmanager:IsConnected() then
        self._fkval = hallmanager:GetRoomCardCost( self._shortName )
        self._videoFKVal = hallmanager:GetRoomCardCost( self._shortName, true )
        printf( "房卡消耗基数为："..self._fkval )
        printf( "视频消耗房卡基数为："..self._fkval )
    else
        self._fkval = 0
        self._videoFKVal = 0
    end
end

function M:initView()
    -- 检测游戏是否需要更新
    self:checkGameNeedUpdate()
    -- 添加语音聊天checkbox
    self:addChatCheckBox()
    -- 用户已有房卡数
    self:createUserCardNumTxt()
    -- 设置聊天,GPS,代开按钮状态
    self:readDataFromCache()
    -- 设置选中按钮文本颜色
    self:changeCheckBoxColor()
end

function M:checkGameNeedUpdate( )
    if hallmanager and hallmanager:IsConnected() then
        local isNeedUpdate, msg = hallmanager:CheckGameNeedUpdate( self._shortName )
        self._msg = msg
        self.img_download:setVisible(false)
        if isNeedUpdate then    -- 需要更新
            self.txt_tips:setString( msg )
            self.txt_tips:show()
            self:showCreateBtn( false )
            -- 将创建规则本地缓存清除
            fcData:RemoveRuleTableByName( self._shortName )
            if self._ruleNode then self._ruleNode:setVisible(false) end
        else
            if msg then         -- 游戏不存在
                self.txt_tips:setString( msg )
                self.txt_tips:show()
                self.btn_create:setEnabled( false )
            else                -- 可直接创建游戏
                self:showRuleView()
            end
        end
    end
end

-- 显示更新按钮或创建按钮方法
function M:showCreateBtn( bo )
    self.btn_create:setVisible( bo )
    self.btn_create:setEnabled( bo )
    self.btn_update:setVisible( not bo )
    self.btn_update:setEnabled( not bo )
end

-- 获取规则界面
function M:showRuleView( )
    local function addRuleNode_(filePath)
        self._ruleNode = filePath.new("RuleView", self._fkval, self._videoFKVal, self)
        -- 根据是否选择视频来刷新房卡消耗
        self:videoStateChanged(5)
        self:addChild(self._ruleNode)
    end

    -- 显示创建按钮
    self:showCreateBtn( true )
    -- 2018-05-07 同时存在新旧版本规则界面时，先判断是否有新的规则文件
    local ok, path = pcall(function()
        return require("games." .. self._shortName.. ".rule_" .. self._shortName .. "_v2")
    end)
    if ok then
        addRuleNode_(path)
        return
    end
    -- 不存在新的规则界面，则判断是否存在旧版本规则界面
    ok, path = pcall(function()
        return require( "games."..self._shortName..".rule_"..self._shortName )
    end)
    if ok then
        addRuleNode_(path)
    else
        printf( string.format("找不到rule_%s规则文件或者规则文件错误导致无法读取！",self._shortName) )
        self.txt_tips:setString( "此游戏暂时未开放朋友场,敬请期待！" )
        self.txt_tips:show()
        self.btn_create:setEnabled( false )
    end
end

function M:onClickUpdate( ... )
    gg.AudioManager:playClickEffect()
    local function statuscb_( status, shortname, errmsg )
        if tolua.isnull(self) then return end
        if shortname ~= self._shortName then return end
        if status == 0 then
            self.btn_update:setEnabled( false )
            self.txt_tips:setString( "等待更新中..." )
        elseif status == -1 then
            self.btn_update:setEnabled( true )
        end
    end

    if hallmanager and hallmanager:IsConnected() then
        hallmanager:DoUpdateGame(self._shortName, statuscb_ )
    end
end

function M:refreshCheckBox()
    local visibleTb = { true, true, true, true, true }

    -- 审核模式隐藏 GPS
    visibleTb[2] = not IS_REVIEW_MODE

    -- 审核模式或者普通创建房间, 代开和仅限按钮隐藏
    if IS_REVIEW_MODE or self._enterType == 1 then
        visibleTb[3] = false
        visibleTb[4] = false
    else
        visibleTb[3] = false
        visibleTb[4] = (self._enterType ~= 1)
    end

    -- 微乐 & 开启了视频开关 & 底层支持视频 & 游戏支持视频功能
    local gameSupportVideo = false
    if hallmanager and hallmanager:IsConnected() then
        local gameInfo = hallmanager:GetGameByShortName(self._shortName)
        if gameInfo and gameInfo.cmd then
            gameSupportVideo = (checkint(gameInfo.cmd.video) == 1)
        end
    end
    printf("---- game %s support video : %s", self._shortName, tostring(gameSupportVideo))
    visibleTb[5] = (not IS_REVIEW_MODE) and IS_WEILE and gameSupportVideo and GameApp:CheckModuleEnable(ModuleTag.Video) and gg.AgoraManager:isNativeSupportAgora()

    -- 调整GPS与语音按钮之间的间距
    local panel = self:getChildByTag( tag or 10 )
    for i,v in ipairs( panel._checkBoxList ) do
        -- 设置按钮的显示状态
        v:setVisible(visibleTb[i])

        -- 不显示的按钮，取消选中
        if not visibleTb[i] then
            v:setSelected( false )
        end

        -- 调整代开和仅限好友群选项位置
        if i > 2 and i ~= 5 then
            v:setPositionY( 85 )
        end

        -- 调整视频按钮位置
        if i == 5 and visibleTb[5] then
            v:setPositionY(panel._checkBoxList[1]:getPositionY())
        end
    end

    if visibleTb[5] then
        -- 有显示视频按钮，调整第一排按钮位置
        panel._checkBoxList[2]:setPositionX(145)
        panel._checkBoxList[5]:setPositionX(330)
    elseif visibleTb[4] then
        panel._checkBoxList[4]:setPosition(cc.p(0, panel._checkBoxList[1]:getPositionY()))
        panel._checkBoxList[1]:setPositionX(230)
        panel._checkBoxList[2]:setPositionX(360)
    end
end

-- 语音聊天 & GPS测距 & 代开房间 & 仅限好友圈
function M:addChatCheckBox()
    local titleTb = {"语音", "GPS测距", "代开房间", "仅限亲友圈", VIDEO_OPTION_NAME}
    local chatCheckBox = require("common.widgets.RadioButtonGroup"):create(titleTb, 2, "")
    chatCheckBox:setPosition(cc.p(35, 52))
    chatCheckBox:setFontInfo(RADIO_BTN_FONTSIZE, RADIO_BTN_COLOR_NOR, "")
    chatCheckBox:changeBtnTitlePosY(1)
    chatCheckBox:setSpacingH(150)
    chatCheckBox:setElementCountH(3)
    chatCheckBox:setTag(10)
    chatCheckBox:setImg("hall/room/jxroom/create_cb_3.png", "hall/room/jxroom/create_cb_4.png")
    chatCheckBox:setSelectCallBack(function(k)
        -- 视频按钮选择状态变化需要通知游戏
        if k==5 then
            self:videoStateChanged(k)
        end
        -- 改变按钮选中状态字体颜色
        self:changeCheckBoxColor()
    end )
    self:addChild(chatCheckBox)

    -- 刷新按钮的显示
    self:refreshCheckBox()
end

-- 创建用户房卡数文本
function M:createUserCardNumTxt()
    -- 审核模式或者房卡关闭了隐藏房卡相关信息
    if IS_REVIEW_MODE or not GameApp:CheckModuleEnable(ModuleTag[PROP_ID_ROOM_CARD]) then return end
    -- 玩家房卡数
    local cardNum = 0
    local propList = hallmanager.proplist
    if propList and propList[PROP_ID_ROOM_CARD] then
        cardNum = propList[PROP_ID_ROOM_CARD]
    end
    local propName = gg.IIF(IS_WEILE, "已有视频券 ", "已有房卡 ")
    -- 房卡数富文本
    self._txt_usercard = ccui.RichText:create()
    self._txt_usercard:pushBackElement(ccui.RichElementText:create(1, RADIO_BTN_COLOR_NOR, 255, propName, "", 26))
    self._txt_usercard:pushBackElement(ccui.RichElementText:create(2, RADIO_BTN_COLOR_SEL, 255, cardNum, "", 28))
    self._txt_usercard:pushBackElement(ccui.RichElementText:create(3, RADIO_BTN_COLOR_NOR, 255, " 张", "", 26))
    self._txt_usercard:setAnchorPoint(cc.p(1, 0.5))
    self._txt_usercard:setPosition(cc.p(795, 120))
    self:addChild(self._txt_usercard)
    if self._enterType == 3 or self:isConvenientCreate() then
        self._txt_usercard:setVisible(false)
    else
        self._txt_usercard:setVisible(true)   
    end
end

-- 视频选项状态变化了
function M:videoStateChanged(btnIdx)
    if not self._ruleNode or not self._ruleNode.videoStateChanged then
        return
    end

    -- 通知游戏，视频选项状态变化了
    local panel = self:getChildByTag( 10 )
    if panel then
        self._ruleNode:videoStateChanged(panel._checkBoxList[btnIdx]:isSelected())
    end
end

-- 更改选择按钮颜色
function M:changeCheckBoxColor(tag)
    -- 语音 & GPS & 代开
    local panel = self:getChildByTag( tag or 10 )
    for k,v in pairs(panel._checkBoxList) do
        local txt = v:getText()
        if v:isSelected() then
            txt:setTextColor(RADIO_BTN_COLOR_SEL)
        else
            txt:setTextColor(RADIO_BTN_COLOR_NOR)
        end
    end
end

-- 退出时将当前选择数据本地化
function M:onExit()
    self:recordData()
end

function M:recordData()
    if self._ruleNode then
        -- 规则表
        local ruleTb = self._ruleNode:getRuleTable()
        -- 按钮选中位置
        local btnIdxTb = self._ruleNode:getBtnIndexTable( self._ruleNode._groupTb )
        -- 语音,GPS(代开不再记录缓存，而是根据入口来设置开关)
        local chatTb = {}
        local oldChatTb = fcData:GetChatTableByName( self._shortName )
        local panel = self:getChildByTag( 10 )
        for i,v in ipairs( panel._checkBoxList ) do
            if i <= 2 then
                table.insert(chatTb, gg.IIF(v:isSelected(), 1, 0))
            end
            -- 2017-12-26 自建房仅限好友群勾选记录
            if i == 4 then
                if self._enterType == 3 then
                    table.insert(chatTb, gg.IIF(v:isSelected(), 1, 0))
                else
                    table.insert(chatTb, checkint(checktable(oldChatTb)[3]))
                end
            end
        end
        -- 几人房
        local players = self._ruleNode:getPlayers()
        -- 写入本地
        fcData:WriteRuleToLocal( self._shortName, ruleTb, btnIdxTb, chatTb, players )
    end
end

-- 从本地缓存中读取用户规则数据
function M:readDataFromCache()
    local chatTb = fcData:GetChatTableByName( self._shortName )
    local panel = self:getChildByTag(10)
    for i,v in ipairs(panel._checkBoxList) do
        if not v:isVisible() then
            -- 不显示的按钮需要取消选中状态
            v:setSelected(false)
        elseif IS_REVIEW_MODE and i > 1 then
            -- 审核模式，关闭 GPS，代开相关
            v:setSelected( false )
        elseif i == 3 then
            -- 判断入口，从代开页面进入代开按钮默认勾选，否则取消勾选
            v:setSelected(self._enterType == 3)
        elseif i == 4 then
            -- 2017-12-23 仅限好友群按钮可取消
            if self._enterType == 3 then
                v:setSelected(checkint(checktable(chatTb)[3]) == 1)
            else
                v:setSelected(false)
            end
        else
            if chatTb then
                -- 如果有之前保存的配置，根据配置来设置按钮状态
                if checkint(chatTb[i]) == 1 then
                    v:setSelected( true )
                else
                    v:setSelected( false )
                end
            else
                -- 没有保存的配置，使用默认值
                -- 1 表示 语音，默认开启
                -- 2 表示 GPS，默认关闭
                -- 5 表示 视频，默认关闭
                v:setSelected( i ~= 2 and i ~= 5 )
            end
        end
    end
end

------------------------------------------------------
-- 创建房间相关
------------------------------------------------------
-- 创建房间按钮点击
function M:onClickCreate( sender )

    if self:isConvenientCreate() then
        if not self._ruleNode then return end
            local function findRule( short_name , players ,jushu )

                if jushu == 0 then return false end

                for i,v in ipairs(self._loadClubRule) do
                    if checkint(v.tag) ~= self._convenientTag and tostring(v.short_name) == tostring(short_name) and checkint(v.players_num) == checkint(players) and checkint(v.inning) == checkint(jushu) then
                        return true
                    end
                end
                return false
            end

            -- 规则表
            local ruleTb = self:getRuleTableByPlayerIndexStringTB()
            local players , jushu , btnIdxTb , cardnum = self:getCreateFirendRoomDataforDaiKai()

            if not findRule(self._shortName , players , jushu) then
                -- 语音,GPS(代开不再记录缓存，而是根据入口来设置开关)
                local chatTb = {}
                local oldChatTb = fcData:GetChatTableByName( self._shortName )
                local panel = self:getChildByTag( 10 )
                for i,v in ipairs( panel._checkBoxList ) do
                    table.insert(chatTb, gg.IIF(v:isSelected(), 1, 0))
                end
                table.insert(chatTb,cardnum)

                local ok, manifest_tb = hallmanager:GetGameManifestTable( self._shortName )
                local gamever = checkint(checktable(manifest_tb).version)

                self:sendData(self._clubId, self._shortName,gamever,ruleTb, btnIdxTb, chatTb, players, jushu, self._convenientTag, function(cb)
                    if tolua.isnull(self) then return end
                    if cb.status ~= 0 then
                        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, cb.msg or "保存快捷建房规则失败")
                        return
                    end
                    if cb.status == 0 then
                        -- GameApp:dispatchEvent(gg.Event.SHOW_TOAST, cb.msg or "设置固定规则成功")
                        GameApp:dispatchEvent(gg.Event.SAVE_CONVENIENTCREATE_SUCCESS, self._clubId, self._convenientTag, self._shortName, gamever, ruleTb, btnIdxTb, chatTb, players, jushu)
                    end
                end)
            else
                GameApp:dispatchEvent(gg.Event.SHOW_TOAST,"同一游戏，相同人数规则无法重复添加")
            end

        return
    end

    -- 快速点击判断
    if (gg.IsFastClick(sender)) then return end
    gg.AudioManager:playClickEffect()
    -- 获取几人房
    local players = self._ruleNode:getPlayers()
    -- 获取局数
    local jushu = 0
    if self._ruleNode.getGameJushu then
        jushu = self._ruleNode:getGameJushu()
    end
    -- 获取规则面板的规则数据
    local rule = self._ruleNode:getRuleTable()
    -- 将语音聊天,GPS,代开房间规则写入
    local openChat = 0  -- 开启语音
    local openGps = 0   -- 开启GPS
    local permission = 0 -- 仅限好友圈
    local openVideo = 0 -- 开启视频
    local panel = self:getChildByTag( 10 )
    for i,v in ipairs( panel._checkBoxList ) do
        if v:isSelected() then
            if i==1 then openChat=1 end
            if i==2 then openGps=1 end
            if i==4 then permission=1 end
            if i==5 then openVideo=1 end
        end
    end
    table.insert( rule, openChat )
    table.insert( rule, openGps )
    table.insert( rule, openVideo )
    self._rule = rule

    -- 手机GPS功能未打开,用户选择了开启GPS功能,并且未选择代开房间
    if self._enterType == 1 then
        if openGps == 1 and device.getGpsEnable() == 0 then
            self:getScene():createView("room.OpenGpsAlertView"):pushInScene()
            return
        end
    end

    local cardNum = self._ruleNode:getRoomCardCost()

    if hallmanager and hallmanager:IsConnected() then
        if self._enterType == 2 then    -- 信用开房
            printf("信用开房")
            hallmanager:CreateFriendRoom(self._shortName, rule, players, 0, cardNum, permission, 1, self._clubId, jushu, self._managerid)
        elseif self._enterType == 3  then --比赛 代开房间

            printf("比赛 代开房间")
            hallmanager:CreateFriendRoom(self._shortName, rule, players, 1, cardNum, permission, 0, self._clubId, jushu, self._managerid)
         else    -- 普通创建
            printf("普通创建")
            hallmanager:CreateFriendRoom(self._shortName, rule, players, 0, cardNum, 0, 0, self._clubId, jushu, self._managerid)
        end
    end
end

-- 游戏更新进度通知
function M:doUpdateProgress(percent, shortname)
    if shortname ~= self._shortName then return end
    self.btn_update:setEnabled( false )
    -- 下载转圈圈动画
    if not self.img_download:isVisible() then
		self.img_download:stopAllActions()
        self.img_download:setVisible( true )
        local action = cc.RepeatForever:create(cc.RotateBy:create(1.5, 360))
        self.img_download:runAction( action )
    end
    if self.txt_tips:isVisible() then
        self.txt_tips:setString( string.format("正在更新...%d%%", percent) )
    end
end

-- 游戏更新进度通知
function M:doUpdateFinish(shortname, errmsg)
    if shortname ~= self._shortName then return end
    if errmsg then
        self.img_download:setVisible( false )
        self.txt_tips:setString( self._msg or "更新出错，请重试！" )
        self:showCreateBtn( false )
    else
        self.txt_tips:setVisible( false )
        self.img_download:stopAllActions()
        self.img_download:setVisible( false )
        self:showRuleView()     -- 显示规则界面
    end
end

function M:isConvenientCreate()
    return self._enterType == 4
end

function M:sendData(clubId, shortname, gamever, ruleTb, btnIdxTb, chatTb, playersIndex, jushu, tag, callback)
    if self:isConvenientCreate() then
        gg.Dapi:setConvenientRule(clubId, shortname, gamever, ruleTb, btnIdxTb, chatTb, playersIndex, jushu, tag, callback)
    else
        gg.Dapi:setClubGameRule(clubId, shortname, gamever, ruleTb, btnIdxTb, chatTb, playersIndex, jushu, callback)
    end
end

function M:getRuleTableByPlayerIndexStringTB()
    local rule_str = {}
    if self._ruleNode then
        local rule_Tb = self._ruleNode:getBtnIndexTable( self._ruleNode._groupTb )
        local str_rs = ""
        local str_js = ""
        for i,v in ipairs(rule_Tb) do
            local str = ""
            if type(v) == "table" then
                for k,val in ipairs(v) do
                    str = self._ruleNode._groupTb[i].titleTb[val]
                    local _checkBoxList = self._ruleNode._groupTb[i]._checkBoxList[val]
                    if self._ruleNode._groupTb[i]:isVisible() and _checkBoxList:isVisible() then
                        table.insert(rule_str,str)
                    end
                end
            else
                if self._ruleNode._groupTb[i].titleName == "人数" then
                    str_rs = self._ruleNode._groupTb[i].titleTb[v]
                elseif self._ruleNode._groupTb[i].titleName == "局数" or self._ruleNode._groupTb[i].titleName == "圈数" then
                    str_js = self._ruleNode._groupTb[i].titleTb[v] 
                else
                    str = self._ruleNode._groupTb[i].titleTb[v] 
                    local _checkBoxList = self._ruleNode._groupTb[i]._checkBoxList[v]
                    if self._ruleNode._groupTb[i]:isVisible() and _checkBoxList:isVisible() then
                        table.insert(rule_str,str)
                    end
                end  
            end
        end

        if str_js ~= "" then
            table.insert(rule_str,1,str_js)
        end

        if str_rs == "" then
            str_rs = string.format("%d人",self._ruleNode:getPlayers())
        end

        table.insert(rule_str,1,str_rs)
    end

    return rule_str
end

function M:getCreateFirendRoomDataforDaiKai()
    if not self._ruleNode then return end

    -- 获取几人房
    local players = self._ruleNode:getPlayers()
    -- 获取规则面板的规则数据
    local rule = self._ruleNode:getRuleTable()

    -- 判断语音，GPS，代开房间功能是否开启，0-未开启，1-开启
    local openChat = 0  -- 开启语音
    local openGps = 0   -- 开启GPS
    local permission = 0 -- 仅限好友圈
    local panel = self:getChildByTag( 10 )
    for i,v in ipairs( panel._checkBoxList ) do
        if v:isSelected() then
            if i==1 then openChat=1 end
            if i==2 then openGps=1 end
            if i==4 then permission=1 end
        end
    end
    -- 审核模式下gps关闭
    if IS_REVIEW_MODE then
        openGps = 0
    end
    -- 将语音聊天,GPS,代开房间规则写入
    table.insert( rule, openChat )
    table.insert( rule, openGps )
    self._rule = rule

    -- 获取局数
    local jushu = 0
    if self._ruleNode.getGameJushu then
        jushu = self._ruleNode:getGameJushu()
    end

    -- 房卡消耗值
    local cardnum = self._ruleNode:getRoomCardCost()

    return players , jushu , rule , cardnum , permission
end

return M