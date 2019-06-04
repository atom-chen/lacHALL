
----------------------------------------------------------------------
-- 作者：Cai
-- 日期：2017-03-15
-- 描述：朋友场创建规则界面
----------------------------------------------------------------------

local FriendRuleNode = class("FriendRuleNode", cc.load("ViewBase"))

FriendRuleNode.RESOURCE_FILENAME = "ui/room/friendroom/create_rule_node.lua"
FriendRuleNode.RESOURCE_BINDING = {
    ["txt_tips"]    = { ["varname"] = "txt_tips" },
    ["img_line"]    = { ["varname"] = "img_line" },
    ["img_download"]= { ["varname"] = "img_download" },
    ["panel_create"]= { ["varname"] = "panel_create" },
    ["panel_update"]= { ["varname"] = "panel_update" },
    ["btn_create"]  = { ["varname"] = "btn_create" , ["events"]={ {event="click",method="onClickCreate"} } },
    ["btn_update"]  = { ["varname"] = "btn_update" , ["events"]={ {event="click",method="onClickUpdate"} } },
}

-- 规则本地缓存
local fcData = require("hall.models.FriendCreateData")

local VIDEO_OPTION_NAME = "实时视频"
local RADIO_BTN_FONTSIZE = 30

--[[
@pram shortName 传入的游戏名,短名,4个字母的
@pram fkval 房卡消耗的倍数
]]--
function FriendRuleNode:onCreate( shortName )
    -- 初始化
    self:init( shortName )
    -- 初始化View
    self:initView()
end

function FriendRuleNode:init( shortName )
    -- 游戏短名
    self._shortName = shortName
    self:refreshData()

    -- 规则
    self._rule = nil
    -- 线处理函数
    gg.LineHandle(self.img_line)
end

function FriendRuleNode:refreshData()
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

function FriendRuleNode:initView()
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

function FriendRuleNode:checkGameNeedUpdate( )
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
function FriendRuleNode:showCreateBtn( bo )
    self.panel_create:setVisible( bo )
    self.btn_create:setEnabled( bo )
    self.panel_update:setVisible( not bo )
    self.btn_update:setEnabled( not bo )
end

-- 获取规则界面
function FriendRuleNode:showRuleView( )
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

function FriendRuleNode:onClickUpdate( ... )
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

function FriendRuleNode:refreshCheckBox()
    local visibleTb = { true, true, true, true, true }

    -- 审核模式隐藏 GPS
    visibleTb[2] = not IS_REVIEW_MODE

    -- 微乐屏蔽代开房间与仅限好友圈选项
    visibleTb[3] = (not IS_REVIEW_MODE) and (not IS_WEILE) and GameApp:CheckModuleEnable( ModuleTag.DaiKaiRoom )
    visibleTb[4] = (not IS_REVIEW_MODE) and (not IS_WEILE) and GameApp:CheckModuleEnable( ModuleTag.DaiKaiRoom )

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
function FriendRuleNode:addChatCheckBox()
    local titleTb = {"语音", "GPS测距", "代开房间", "仅限亲友圈", VIDEO_OPTION_NAME}
    local chatCheckBox = require("common.widgets.RadioButtonGroup"):create(titleTb, 2, "")
    chatCheckBox:setPosition(cc.p(35, 52))
    chatCheckBox:setFontInfo(RADIO_BTN_FONTSIZE, cc.c3b(51, 51, 51), "")
    chatCheckBox:changeBtnTitlePosY(1)
    chatCheckBox:setSpacingH(150)
    chatCheckBox:setElementCountH(3)
    chatCheckBox:setTag(10)
    chatCheckBox:setImg("hall/room/friend/bg_btn_02.png", "hall/room/friend/btn_gou.png")
    chatCheckBox:setSelectCallBack(function(k)
        if k==3 or k==4 then
            -- 代开房间功能只有推广员可以使用
            self:checkIsCanDaiKai(k)
        end
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
function FriendRuleNode:createUserCardNumTxt()
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
    self._txt_usercard:pushBackElement(ccui.RichElementText:create(1, cc.c3b(51, 51, 51), 255, propName, "", 26))
    self._txt_usercard:pushBackElement(ccui.RichElementText:create(2, cc.c3b(38, 155, 88), 255, cardNum, "", 28))
    self._txt_usercard:pushBackElement(ccui.RichElementText:create(3, cc.c3b(51, 51, 51), 255, " 张", "", 26))
    self._txt_usercard:setAnchorPoint(cc.p(1, 0.5))
    self._txt_usercard:setPosition(cc.p(795, 120))
    self:addChild(self._txt_usercard)
end

-- 视频选项状态变化了
function FriendRuleNode:videoStateChanged(btnIdx)
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
function FriendRuleNode:changeCheckBoxColor(tag)
    -- 语音 & GPS & 代开
    local panel = self:getChildByTag( tag or 10 )
    for k,v in pairs(panel._checkBoxList) do
        local txt = v:getText()
        if v:isSelected() then
            txt:setTextColor(cc.c3b(38, 155, 88))
        else
            txt:setTextColor(cc.c3b(51, 51, 51))
        end
    end
end

-- 代开特殊情况，只有代理人可以代开
function FriendRuleNode:checkIsCanDaiKai(idx)
    -- 是否可以创建
    local isCan = false
    -- 是否是代理人
    local isAgency = gg.UserData:GetIsAgency()
    if isAgency == 0 then
        isCan = false
        -- 取消按钮选中
        local panel = self:getChildByTag( 10 )
        if panel._checkBoxList[idx] then
            panel._checkBoxList[idx]:setSelected( false )
        end
        -- 提示框
        local tips = "只有推广员才可以代开房间"
        if idx == 4 then
            tips = "只有推广员才可以使用此选项"
        end
        GameApp:dispatchEvent( gg.Event.SHOW_MESSAGE_DIALOG, tips, function(btntype)
            if btntype == gg.MessageDialog.EVENT_TYPE_OK then
                -- 显示加盟界面
                self:getScene():createView("JoinApplyView"):pushInScene()
            end
        end, { ok="申请推广员" } )
    else
        isCan = true
    end
    return isCan
end

-- 退出时将当前选择数据本地化
function FriendRuleNode:onExit()
    self:recordData()
end

function FriendRuleNode:recordData()
    if self._ruleNode then
        -- 规则表
        local ruleTb = self._ruleNode:getRuleTable()
        -- 按钮选中位置
        local btnIdxTb = self._ruleNode:getBtnIndexTable( self._ruleNode._groupTb )
        -- 语音,GPS(代开不再记录缓存，而是根据入口来设置开关)
        local chatTb = {}
        local panel = self:getChildByTag( 10 )
        for i,v in ipairs( panel._checkBoxList ) do
            if i<=2 then
                if v:isSelected() then
                    table.insert( chatTb, 1 )
                else
                    table.insert( chatTb, 0 )
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
function FriendRuleNode:readDataFromCache()
    local chatTb = fcData:GetChatTableByName( self._shortName )
    local isAgency = gg.UserData:GetIsAgency()
    local panel = self:getChildByTag(10)
    for i,v in ipairs(panel._checkBoxList) do
        if not v:isVisible() then
            -- 不显示的按钮需要取消选中状态
            v:setSelected(false)
        elseif IS_REVIEW_MODE and i > 1 then
            -- 审核模式，关闭 GPS，代开相关
            v:setSelected( false )
        elseif i==3 then
            v:setSelected( false )
        elseif i==4 then
            -- 仅限朋友圈选项
            v:setSelected( false )
        else
            if chatTb then
                -- 如果有之前保存的配置，根据配置来设置按钮状态
                if chatTb[i] == 1 then
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
function FriendRuleNode:onClickCreate( sender )
    -- 快速点击判断
    if (gg.IsFastClick(sender)) then return end
    gg.AudioManager:playClickEffect()
    if not self._ruleNode then 
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "创建房间失败，请关闭界面重试！")    
        return 
    end

    -- 获取几人房
    local players = self._ruleNode:getPlayers()
    -- 获取规则面板的规则数据
    local rule = self._ruleNode:getRuleTable()
    -- 将语音聊天,GPS,代开房间规则写入
    local openChat = 0  -- 开启语音
    local openGps = 0   -- 开启GPS
    local dkRoom = 0    -- 代开房间
    local permission = 0 -- 仅限好友圈
    local openVideo = 0 -- 开启视频
    local panel = self:getChildByTag( 10 )
    for i,v in ipairs( panel._checkBoxList ) do
        if v:isSelected() then
            if i==1 then openChat=1 end
            if i==2 then openGps=1 end
            if i==3 then dkRoom=1 end
            if i==4 then permission=1 end
            if i==5 then openVideo=1 end
        end
    end
    -- table.insert( rule, dkRoom )
    table.insert( rule, openChat )
    table.insert( rule, openGps )
    table.insert( rule, openVideo )
    self._rule = rule

    -- 手机GPS功能未打开,用户选择了开启GPS功能,并且未选择代开房间
    if openGps==1 and dkRoom==0 and device.getGpsEnable()==0 then
        self:getScene():createView("room.OpenGpsAlertView"):pushInScene()
        return
    end

    local cardNum = self._ruleNode:getRoomCardCost(openVideo == 1)
    if dkRoom == 1 then
        -- 代开房间，直接进行创建
        hallmanager:CreateFriendRoom( self._shortName, rule, players, dkRoom, cardNum, permission, 0 )
        return
    end

    -- 如果在游戏中，会直接加入房间；否则才创建房间
    if hallmanager and hallmanager:IsConnected() and (not hallmanager:IsInFriendRoom()) then
        local isCreditUser = gg.UserData:GetIsCreditUser() == 1
        if cardNum > 0 and isCreditUser and GameApp:CheckModuleEnable(ModuleTag.CreditUser) then
            -- 如果是信用用户。提示是否使用信用好友的房卡创建房间
            local tipStr = string.format( "您可以使用自有房卡或推广员[%s]的房卡，请选择:", checkstring(gg.UserData:GetWebData("asn")))
            GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG, tipStr, function(bttype)
                local shortname = self._shortName
                if bttype == gg.MessageDialog.EVENT_TYPE_OK then
                    gg.InvokeFuncNextFrame(function()
                        -- 下一帧调用是为了保证创建房间时显示的 loading 界面不会被关闭
                        hallmanager:CreateFriendRoom( shortname, rule, players, dkRoom, cardNum, permission, 1 )
                    end)
                elseif bttype == gg.MessageDialog.EVENT_TYPE_CANCEL then
                    gg.InvokeFuncNextFrame(function()
                        -- 下一帧调用是为了保证创建房间时显示的 loading 界面不会被关闭
                        hallmanager:CreateFriendRoom( shortname, rule, players, dkRoom, cardNum, permission, 0 )
                    end)
                end
            end, { mode=gg.MessageDialog.MODE_OK_CANCEL_CLOSE, cancel="自有房卡", ok="推广员房卡"})
        else
            -- 获取视频需要的房卡数
            local videoNeedCard = 0
            if self._ruleNode.getVideoNeedCard then
                videoNeedCard = self._ruleNode:getVideoNeedCard()
            end

            if openVideo == 1 and videoNeedCard > 0 then
                -- 开了视频且需要消耗视频券，那么需要弹出确认框进行确认
                local tipStr = string.format( "%s功能需要消耗 %d 张视频券，确定开启此功能吗？", VIDEO_OPTION_NAME, videoNeedCard)
                GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG, tipStr, function(bttype)
                    if bttype == gg.MessageDialog.EVENT_TYPE_OK then
                        local shortname = self._shortName
                        gg.InvokeFuncNextFrame(function()
                            -- 下一帧调用是为了保证创建房间时显示的 loading 界面不会被关闭
                            hallmanager:CreateFriendRoom( shortname, rule, players, dkRoom, cardNum, permission, 0 )
                        end)
                    end
                end, { mode=gg.MessageDialog.MODE_OK_CANCEL_CLOSE, cancel="取消", ok="确定"})
            else
                hallmanager:CreateFriendRoom( self._shortName, rule, players, dkRoom, cardNum, permission, 0 )
            end
        end
    end
end

-- 游戏更新进度通知
function FriendRuleNode:doUpdateProgress(percent, shortname)
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
function FriendRuleNode:doUpdateFinish(shortname, errmsg)
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

return FriendRuleNode