--
-- Author: tang
-- Date: 2017-01-08 16:29:57
--
-- 私人房游戏顶层
local PrivateLayerModel = appdf.req(PriRoom.MODULE.PLAZAMODULE .."models.PrivateLayerModel")
local PriGameLayer = class("PriGameLayer", PrivateLayerModel)
-- local PriGameLayer = class("PriGameLayer", function(scene)
--     local layer = display.newLayer()
--     return layer
-- end)
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local PopupInfoHead = appdf.req(appdf.EXTERNAL_SRC .. "PopupInfoHead")
local ClipText = appdf.req(appdf.EXTERNAL_SRC .. "ClipText")
local MultiPlatform = appdf.req(appdf.EXTERNAL_SRC .. "MultiPlatform")
local DismissLayer = appdf.req(appdf.PUB_GAME_VIEW_SRC.."DismissLayer")
local cmd = import("..models.CMD_Game")

--local RES_PATH = "client/src/privatemode/game/yule/sparrowhz/res/"
local BTN_DISMISS = 101
local BTN_INVITE = 102
local BTN_SHARE = 103
local BTN_QUIT = 104
local BTN_ZANLI = 105

--local posRoomHost = {cc.p(1055, 677), cc.p(39, 509), cc.p(72, 231), cc.p(1286, 480)}

function PriGameLayer:ctor( gameLayer )
    PriGameLayer.super.ctor(self, gameLayer)
    -- 加载csb资源
    local rootLayer, csbNode = ExternalFun.loadRootCSB("privateRoom/RoomGameLayer.csb", self )
    self.m_rootLayer = rootLayer
    self.m_csbNode = csbNode

    --
    local image_bg = csbNode:getChildByName("sp_roomInfoBg")

    -- 房间ID
    self.m_atlasRoomID = image_bg:getChildByName("Text_roomNum")
    self.m_atlasRoomID:setString("房号：1008611")
    --名称(改作扎码数量了)
    local cbMaCount = self._gameLayer:getMaCount()
    self.m_textRoomName = image_bg:getChildByName("Text_roomName"):setString("0个扎码")
    -- 局数
    self.m_atlasCount = image_bg:getChildByName("Text_index")
    self.m_atlasCount:setString("1 / 5 局")
    --剩余
    self.m_textRemain = image_bg:getChildByName("Text_innings"):setString("剩 4 局")

    local function btncallback(ref, tType)
        if tType == ccui.TouchEventType.ended then
            self:onButtonClickedEvent(ref:getTag(),ref)
        end
    end
    -- 解散按钮
    local btn = csbNode:getChildByName("bt_dismiss")
    btn:setTag(BTN_DISMISS)
    btn:addTouchEventListener(btncallback)

    -- 暂离按钮
    local btn = csbNode:getChildByName("bt_zanli")
    btn:setTag(BTN_ZANLI)
    btn:addTouchEventListener(btncallback)

    -- 邀请按钮
    self.m_btnInvite = csbNode:getChildByName("bt_invite")
    self.m_btnInvite:setTag(BTN_INVITE)
    --self.m_btnInvite:setVisible(false)
    self.m_btnInvite:addTouchEventListener(btncallback)

    --self.sp_roomHost = csbNode:getChildByName("sp_roomHost"):setVisible(false)

    self._dismissLayer = DismissLayer:create(self, cmd):addTo(self._gameLayer._gameView, 10)
end

function PriGameLayer:onButtonClickedEvent( tag, sender )
    local cbMaCount = self._gameLayer:getMaCount()
    local strMa = ""
    if cbMaCount == 1 then
        strMa = "一码全中"
    else
        strMa = "扎码"..cbMaCount.."只"
    end

    if BTN_DISMISS == tag then              -- 请求解散游戏
        PriRoom:getInstance():queryDismissRoom()
    elseif BTN_INVITE == tag then
        local clicktype = 1
        PriRoom:getInstance():getPlazaScene():popTargetShare(clicktype,function(target, bMyFriend)
            bMyFriend = bMyFriend or false
            local function sharecall( isok )
                if type(isok) == "string" and isok == "true" then
                    showToast(self, "分享成功", 2)
                end
                GlobalUserItem.bAutoConnect = true
            end
            local shareTxt = "房号" .. PriRoom:getInstance().m_tabPriData.szRoomID .. 
                            "，局数" .. PriRoom:getInstance().m_tabPriData.dwDrawCountLimit .. 
                            "，人数" .. PriRoom:getInstance():getChairCount() .. "，" .. strMa .. 
                            "。红中麻将游戏精彩刺激, 一起来玩吧！"
            local friendC = "红中麻将房号" .. PriRoom:getInstance().m_tabPriData.szRoomID .. 
                            "，局数" .. PriRoom:getInstance().m_tabPriData.dwDrawCountLimit .. 
                            "，人数" .. PriRoom:getInstance():getChairCount() .. "，" .. strMa
            if bMyFriend then
                PriRoom:getInstance():getTagLayer(PriRoom.LAYTAG.LAYER_FRIENDLIST, function( frienddata )
                    local serverid = tonumber(PriRoom:getInstance().m_tabPriData.szRoomID) or 0                    
                    PriRoom:getInstance():priInviteFriend(frienddata, GlobalUserItem.nCurGameKind, serverid, yl.INVALID_TABLE, friendC)
                end)
            elseif nil ~= target then
                GlobalUserItem.bAutoConnect = false
                local url = yl.getPriInviteURL(GlobalUserItem.nCurGameKind, PriRoom:getInstance().m_tabPriData.szRoomID)
                MultiPlatform:getInstance():shareToTarget(target, sharecall, "【约战房间："..PriRoom:getInstance().m_tabPriData.szRoomID.."】", shareTxt, url, "")
            end
        end)
    elseif BTN_SHARE == tag then
        print("分享")
        local clicktype = 2
        PriRoom:getInstance():getPlazaScene():popTargetShare(clicktype,function(target, bMyFriend)
            bMyFriend = bMyFriend or false
            local function sharecall( isok )
                if type(isok) == "string" and isok == "true" then
                    showToast(self, "分享成功", 2)
                end
                GlobalUserItem.bAutoConnect = true
            end
            -- 截图分享
            local framesize = cc.Director:getInstance():getOpenGLView():getFrameSize()
            local area = cc.rect(0, 0, framesize.width, framesize.height)
            local imagename = "grade_share.jpg"
            if bMyFriend then
                imagename = "grade_share_" .. os.time() .. ".jpg"
            end
            ExternalFun.popupTouchFilter(0, false)
            captureScreenWithArea(area, imagename, function(ok, savepath)
                ExternalFun.dismissTouchFilter()
                if ok then
                    if bMyFriend then
                        PriRoom:getInstance():getTagLayer(PriRoom.LAYTAG.LAYER_FRIENDLIST, function( frienddata )
                            PriRoom:getInstance():imageShareToFriend(frienddata, savepath, "分享我的约战房战绩")
                        end)
                    elseif nil ~= target then
                        GlobalUserItem.bAutoConnect = false
                        local url = yl.getPriGradeURL()
                        MultiPlatform:getInstance():shareToTarget(target, sharecall, "我的约战房战绩", "分享我的约战房战绩", url, savepath, "true")
                    end            
                end
            end)
        end)
    elseif BTN_QUIT == tag then
        --self.layoutShield:removeFromParent()
        self.m_rootLayer:removeAllChildren()
        GlobalUserItem.bWaitQuit = false
        self._gameLayer:onExitRoom()
    elseif BTN_ZANLI == tag then
        PriRoom:getInstance():tempLeaveGame()
        self._gameLayer:onExitRoom()
    end
end

------
-- 继承/覆盖
------
-- 刷新界面
function PriGameLayer:onRefreshInfo()
    -- 房间ID
    self.m_atlasRoomID:setString("房号: "..PriRoom:getInstance().m_tabPriData.szRoomID or "000000")
    --扎码数量
    local strMa = ""
    local cbMaCount = self._gameLayer:getMaCount()
    if cbMaCount == 1 then
        strMa = "一码全中"
    else
        strMa = cbMaCount.."个扎码"
    end
    self.m_textRoomName:setString(strMa)
    -- 局数
    local dwPlayCount = PriRoom:getInstance().m_tabPriData.dwPlayCount
    print("局数：", dwPlayCount)
    local dwDrawCountLimit = PriRoom:getInstance().m_tabPriData.dwDrawCountLimit
    local strcount = dwPlayCount .. " / " .. dwDrawCountLimit.." 局"
    self.m_atlasCount:setString(strcount)
    --剩余
    self.m_textRemain:setString("剩 "..(dwDrawCountLimit - dwPlayCount).." 局")
    self:onRefreshInviteBtn()
    --房主
    self._gameLayer:updateRoomHost()
    --if wRoomHostViewId ~= 0 then
        --self.sp_roomHost:move(posRoomHost[wRoomHostViewId]):setVisible(true)
    --end
end

function PriGameLayer:onRefreshInviteBtn()
    print("invite .. ")
    print(self._gameLayer.m_cbGameStatus)
    if self._gameLayer.m_cbGameStatus ~= 0 then --不是空闲场景
        self.m_btnInvite:setVisible(false)
        return
    end
    -- 邀请按钮
    if nil ~= self._gameLayer.onGetSitUserNum then
        local chairCount = PriRoom:getInstance():getChairCount()
        if self._gameLayer:onGetSitUserNum() == chairCount then
            self.m_btnInvite:setVisible(false)
            return
        end
    end

    self.m_btnInvite:setVisible(true)
end

-- 私人房游戏结束
function PriGameLayer:onPriGameEnd( cmd_table )
    self:removeChildByName("private_end_layer")
    self._gameLayer.isPriOver = true

    --房卡结算屏蔽层
    self.layoutShield = ccui.Layout:create()
        :setContentSize(cc.size(display.width, display.height))
        :setTouchEnabled(true)
        :addTo(self.m_rootLayer, 1)
    --加载房卡结算
    local csbNode = ExternalFun.loadCSB("privateRoom/RoomResultLayer.csb", self.m_rootLayer)
    csbNode:setVisible(false)
    csbNode:setLocalZOrder(1) -- 勿删
    csbNode:setName("private_end_layer")

    local function btncallback(ref, tType)
        if tType == ccui.TouchEventType.ended then
            self:onButtonClickedEvent(ref:getTag(),ref)
        end
    end

    local fangjianid = csbNode:getChildByName("Text_19")
    fangjianid:setString(""..PriRoom:getInstance().m_tabPriData.szRoomID or "000000")

    --大赢家
    local scoreList = cmd_table.lScore[1]
    local nRoomHostIndex = 1
    local scoreListTemp = clone(scoreList)
    table.sort(scoreListTemp)
    local scoreMax = scoreListTemp[#scoreListTemp]
    --全部成绩
    local jsonStr = cjson.encode(scoreList)
    LogAsset:getInstance():logData(jsonStr, true)
    local tabUserRecord = self._gameLayer:getDetailScore()
    dump(tabUserRecord,"tabUserRecord=============>")
    for i = 1, 4 do
        
        local userItem = self._gameLayer:getUserInfoByChairID(i - 1)
        local nodeUser = csbNode:getChildByName("FileNode_"..i)
        nodeUser:setVisible(false) 
        assert(nodeUser, "The UI have problem!")
        if userItem and i<=self._gameLayer.chairCount then
            --头像
            head = PopupInfoHead:createClipHead(userItem, 55)
            head:setPosition(8.7, 10)         --初始位置
            head:enableHeadFrame(true)
            nodeUser:addChild(head)
            --昵称
            local textNickname = nodeUser:getChildByName("Text_account")
            local strNickname = string.EllipsisByConfig(userItem.szNickName, 190, 
                                                        string.getConfig(appdf.FONT_FILE, 21))
            textNickname:setString(strNickname)
            --玩家ID
            local textUserId = nodeUser:getChildByName("Text_id")
            textUserId:setString("" .. userItem.dwGameID)
            --胡牌次数
            local textHuNum = nodeUser:getChildByName("Text_huNum")
            textHuNum:setString(tabUserRecord[i].cbHuCount)
            --公杠次数
            local textGongGangNum = nodeUser:getChildByName("AtlasLabel_2")
            textGongGangNum:setString(tabUserRecord[i].cbMingGang)
            --暗杠次数
            local textAnGangNum = nodeUser:getChildByName("AtlasLabel_3")
            textAnGangNum:setString(tabUserRecord[i].cbAnGang)
            --中码个数
            local textMaNum = nodeUser:getChildByName("AtlasLabel_4")
            textMaNum:setString(tabUserRecord[i].cbMaCount)
            --总成绩
            --local textGradeTotal = nodeUser:getChildByName("Text_gradeTotal")
            local textGradeTotalNum = nodeUser:getChildByName("AtlasLabel_5")
            --local path = scoreList[i] >= 0 and "privateRoom/winscore.png" or "privateRoom/losescore.png"

            textGradeTotalNum:setString("/"..scoreList[i])

            if scoreList[i] < 0 then
                textGradeTotalNum:setVisible(false)
                textGradeTotalNum = cc.Label:createWithCharMap("privateRoom/losescore.png", 17, 21, 47)
                textGradeTotalNum:setPosition(10.8,-224)
                textGradeTotalNum:setAnchorPoint(cc.p(0,0.5))
                textGradeTotalNum:setString("/"..scoreList[i])
                nodeUser:addChild(textGradeTotalNum)
             end

            --房主标志
            if userItem.dwUserID == PriRoom:getInstance().m_tabPriData.dwTableOwnerUserID then
                local spRoomHost = display.newSprite("#sp_roomHost_1.png")
                    :move(-72, 10)
                    :addTo(nodeUser)
                -- local x = textNickname:getContentSize().width/2 + spRoomHost:getContentSize().width/2
                -- spRoomHost:setPositionX(x)
            end
            --大赢家标志
            if scoreList[i] == scoreMax and scoreList[i] > 0 then
                display.newSprite("#sp_bigWinner.png")
                    :move(90, -121)
                    :addTo(nodeUser)
                --放大效果
                --textGradeTotal:setFontSize(textGradeTotal:getFontSize() + 1)
                --textGradeTotalNum:setFontSize(textGradeTotalNum:getFontSize() + 1)
            end
            nodeUser:setVisible(true)     
        end
    end

    -- 分享按钮
    local btn = csbNode:getChildByName("bt_share")
    btn:setTag(BTN_SHARE)
    btn:addTouchEventListener(btncallback)

    -- 退出按钮
    local btn = csbNode:getChildByName("bt_leaveRoom")
    btn:setTag(BTN_QUIT)
    btn:addTouchEventListener(btncallback)

    self:setButtonEnabled(false)
    csbNode:runAction(cc.Sequence:create(cc.DelayTime:create(3),
        cc.CallFunc:create(function()
            csbNode:setVisible(true)
        end)))

    self:setLocalZOrder(yl.MAX_INT - 1)
end

function PriGameLayer:setButtonEnabled(bEnabled)
    self.m_csbNode:getChildByTag(BTN_DISMISS):setEnabled(bEnabled)
    self.m_csbNode:getChildByTag(BTN_ZANLI):setEnabled(bEnabled)
    self.m_csbNode:getChildByTag(BTN_INVITE):setEnabled(bEnabled)
end

return PriGameLayer