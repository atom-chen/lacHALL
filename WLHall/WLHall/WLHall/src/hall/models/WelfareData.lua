local WelfareData = {}
--status 图片的遮罩状态
--isOpen 活动的开启的标识默认是开着,用于判断游戏里面的相关的活动是否开启
--isExistence 即将开放的功能标识，用于判断福利的里面的功能是否开发了,没开放就flase

--是否首充的
local goodId, isFirstPay = gg.PopupGoodsCtrl:getFirstPayOrVIPGoods()

WelfareData.OPENSTATUS     = 0 --开启的的状态
WelfareData.UNLOCKEDSTATUS = 1 --未解锁的状态
WelfareData.RECRIVESTATUS  = 2 --已领取的状态
WelfareData.OTHNERRECRIVESTATUS  = 3 --其他已领取的状态
--福利活动的奖励配置
local  welfareAwardTab =
{
    ["bind"] = {{propCount = 3000, propType = PROP_ID_MONEY}, {propCount = 15, propType = PROP_ID_LIAN_PEN}},
    ["realName"] = {{propCount = 50, propType = PROP_ID_LIAN_PEN}},
}
--福利活动的配置
local welfareTb=
{
    {
        activeId = "share",
        weight = 1,
        status = WelfareData.OPENSTATUS,
        desc   = {isExistence = true, title = "分享有礼", icon = "hall/welfare/icon_share.png",statusHints = "本日已领取"},
        pushScnece = {"welfare.WelfareShareGift"},
    },
    {
        activeId = "bind",
        weight = 4,
        status = WelfareData.OPENSTATUS,
        desc   = {isExistence = true, title = "激活账号", icon = "hall/welfare/icon_jihuo.png" },
        pushScnece = {"personal.PersonMainView", "bind"},
    },
    {
        activeId = "realName",
        weight = 5,
        status = WelfareData.OPENSTATUS,
        desc   = {isExistence = true, title = "实名认证", icon = "hall/welfare/icon_shiming.png"},
        pushScnece = {"personal.PersonMainView", "real_name"},
    },
    {
        activeId = "gzyl",
        weight = 6,
        status = WelfareData.OPENSTATUS,
        desc   = {isExistence = true, title = "关注有礼", icon = "hall/welfare/icon_gzyl.png"},
        pushScnece = {"welfare.WelfareFollowViewActive"},
    },
    {
        activeId = "pjyl",
        weight = 7,
        status = WelfareData.OPENSTATUS,
        desc   = {isExistence = true, title = "评价有礼", icon = "hall/welfare/icon_pjyl.png"},
        pushScnece = {"welfare.WelfareEvaluateViewActive"},
    },
    {
        activeId = "xsqd",
        weight = 2,
        status = WelfareData.OPENSTATUS,
        desc   = {isExistence = true, title = "新手礼", icon = "hall/welfare/icon_xsqd.png",statusHints = "已完成"},
        pushScnece = {"welfare.WelfareXsqdActive"},
    },
    {
        activeId = "mrqd",
        weight = 3,
        status = WelfareData.OPENSTATUS,
        desc   = {isExistence = true, title = "每日签到", icon = "hall/welfare/icon_mrqd.png", statusHints = "剩余%d天解锁", unlocakContentId = "xsqd" },
        pushScnece = {"welfare.WelfareMrqdActive"},
    },
    {
        activeId = "firstCharge",
        weight = 8,
        status = WelfareData.OPENSTATUS,
        desc   = {
                     isExistence = false,
                     title = isFirstPay and "首充礼包" or "超值礼包",
                     icon  = isFirstPay and "hall/welfare/icon_shouchong.png" or "hall/welfare/icon_czlb.png"
                 },
        pushScnece = {},
    },

}
--获取该活动的奖励
function WelfareData:GetAwardCfg(activeId, call)
    --获取奖励名字
    local info = self:getAwardName(welfareAwardTab[activeId])
    if activeId == "bind" then
        if call then
            call(info)
        end
    elseif activeId == "realName" then
        if call then
            call(info)
        end
    elseif activeId == "pjyl" then
        local callback = function(result)
            result = checktable(result)
            if checkint(result.status) == 0 then
                local award = self:getConvertReward(checktable(result.data[1]).awards[1])
                call(self:getAwardName(award),award)
            end
        end
        gg.Dapi:TaskNewConfig(99, callback)
    elseif activeId == "share" then
        local callback = function(result)
            result = checktable(result)
            if checkint(result.status) == 0 then
                local award = self:getConvertReward(checktable(result.data[1]).awards[1])
                local awardTab = {}
                local Tab = {}
                table.insert(awardTab,award)
                table.insert(Tab,award[1])
                call(self:getAwardName(Tab),awardTab)
            end
        end
        gg.Dapi:TaskNewConfig(105,callback)
    elseif activeId == "gzyl" then
        local callback = function(result)
            result = checktable(result)
            if checkint(result.status) == 0 then
                local award = self:getConvertReward(checktable(result.data[1]).awards[1])
                local ermTab = {result.data[1].weChat_name, result.data[1].url}
                local awardTab = {}
                table.insert(awardTab,award)
                table.insert(awardTab,ermTab)
                call(self:getAwardName(award),awardTab)
            end
        end
        gg.Dapi:TaskNewConfig(98,callback)
    elseif activeId == "mrqd" then
        gg.UserData:checkLoaded(function()
            local callback = function(result)
                local curDate = gg.UserData:GetDailyCount() +1
                local tab = self:getConvertReward(result[curDate])
                call(self:getAwardName(tab))
            end
            self:getDailySignCfg(callback)
        end)
    elseif activeId == "xsqd" then
        gg.UserData:checkLoaded(function()
            local callback = function(result)
                local curDate = gg.UserData:GetNewUserCount() + 1 >= 6 and 5 or gg.UserData:GetNewUserCount() + 1
                local award = self:getConvertReward(result[curDate])
                call(self:getAwardName(award))
            end
            self:getNewUserSignCfg(callback)
        end)
    end
    return nil
end

--把数组转换成可以拼名字的表格式
function WelfareData:getConvertReward(webAwardTab)
    local award = {}
    for i,v in ipairs (webAwardTab) do
        award[i] = {propCount = v[2], propType = v[1]}
    end
    return award
end

--福利的遮罩处理（选择图片）
function WelfareData:shadeStatusImg(viewStatus, activeId)
     local tab =
     {
         [WelfareData.UNLOCKEDSTATUS] = "hall/welfare/img_locked.png",
         [WelfareData.RECRIVESTATUS] = "hall/welfare/img_finish.png",
         [WelfareData.OTHNERRECRIVESTATUS] = self:getWelfareAcitveInfo(activeId).desc.otherRecrivesImg,
     }
     return clone(tab[viewStatus])
end

function WelfareData:getWelfareAcitveInfo(id)
    for i, v in pairs (welfareTb) do
       if v.activeId == id then
           return v
       end
    end
end

--分享的奖励
function WelfareData:GetShareNameCallBack(callback)
    local data = nil
    local share_data = require("hall.models.ShareData")
    share_data:checkLoaded(function(status, shareInfo)
        if not status then return end
        local totalShareCnt = gg.UserData:GetShareNum()
        local maxShareCnt = 1
        for i,v in ipairs(shareInfo) do
            if maxShareCnt <= v["share_count"] then
                maxShareCnt = v["share_count"]
            end
        end

        local shareCnt = totalShareCnt % maxShareCnt
        -- 新的一轮分享，
        if shareCnt == 0 then
            data = shareInfo[1]
        else
            for i,v in ipairs(shareInfo) do
                if shareCnt < v["share_count"] then
                    data = v
                    break
                end
            end
        end

        local tab = {{propCount = data.prob_count, propType = data.prob_type}}
        callback(self:getAwardName(tab))
    end)
end

--拼奖励的接口
--格式{{propCount = data.prob_count, propType = data.prob_type}}
--福利界面的奖励显示,豆和魔法道具，只显示豆，豆和道具只显示道具
function WelfareData:getAwardName(data)
    if data == nil then return ; end
    local propDate = {}
    local magicPropCount = 0
    for i,v in ipairs(data) do
        if checkint(v.propType) == PROP_ID_MONEY then
            table.insert(propDate, {propCount = v.propCount, propType = v.propType, propSatue = 2})
        else
            if gg.IsMagicProp(checkint(v.propType)) then
                magicPropCount = v.propCount + magicPropCount
            else
                table.insert(propDate, {propCount = v.propCount, propType = v.propType, propSatue = 1})
            end
        end
    end
    if magicPropCount > 0 then
        table.insert(propDate, {propCount = magicPropCount, propType = PROP_ID_LIAN_PEN, propSatue = 3})
    end
    table.sort(propDate, function(a, b)
        return checkint(a.propSatue) < checkint(b.propSatue)
    end)

    local tab =
    {
        [PROP_ID_CANSAI] = "c",
        [PROP_ID_MONEY]  = "d",
        [PROP_ID_JIPAI]  = "j",
        [PROP_ID_LOTTERY]  = "l",
        [PROP_ID_LEITAIKA]  = "r",
        [PROP_ID_XZMONEY]  = "z",
    }
    local shareName ;
    if checkint(propDate[1].propType) == PROP_ID_MONEY then
        shareName = propDate[1].propCount .. tab[propDate[1].propType]
    else
        shareName = (tab[propDate[1].propType] and tab[propDate[1].propType] or "m").."x"..propDate[1].propCount
    end
    return shareName
end

function WelfareData:initActiveSwitch()
    -- 活动开关
    -- 活动默认是都是开着的，
    -- 只有满足要关的条件才保存，一下是关着的条件
    self._activeCloseBtn = {}  --需要关闭着的活动
    self._finishBtn = {}       --完成的活动
    --分享有礼
    if  gg.UserData:GetShareGiftStatus()  == 5 then
        table.insert(self._finishBtn, "share")
    end
    -- 首充
    local goodsId = gg.PopupGoodsCtrl:getFirstPayOrVIPGoods()
    if not goodsId then
        table.insert(self._activeCloseBtn, "firstCharge")
    end
    --激活账号
    if not GameApp:CheckModuleEnable(ModuleTag.P_ACTIVATE) then
        table.insert(self._activeCloseBtn, "bind")
    elseif gg.UserData.isActivited() then
        table.insert(self._finishBtn, "bind")
    end
    --实名认证
    local idCard, isBindIDCard = gg.UserData:GetIdCardSuffix()
    if not GameApp:CheckModuleEnable(ModuleTag.P_REALNAME) then
        table.insert(self._activeCloseBtn, "realName")
    elseif isBindIDCard then
        table.insert(self._finishBtn, "realName")
    end
    --关注有礼已经领取
    if not GameApp:CheckModuleEnable(ModuleTag.Attention) then
        table.insert(self._activeCloseBtn, "gzyl")
    elseif gg.UserData:getGzylStatus() == 5 then
        table.insert(self._finishBtn, "gzyl")
    end
    --评价有礼已经领取 (版本小于5的，评价有礼要关闭)
    if not GameApp:CheckModuleEnable(ModuleTag.Evaluate) or gg.GetNativeVersion() < 5 then
        table.insert(self._activeCloseBtn, "pjyl")
    elseif gg.UserData:getPjylStatus() == 5 then
        table.insert(self._finishBtn, "pjyl")
    end

    if self:isShowDay() then
        table.insert(self._finishBtn, "xsqd")
    end
    --不是新版本注册的玩家
    if not self:canShowNewUserActivity() then
        table.insert(self._activeCloseBtn, "xsqd")
        table.insert(self._finishBtn, "xsqd")
    end
    --不足的补足item
    self:addWelfareTable()

    --修改现在的活动状态
    self:collectionState()
    --
    table.sort(welfareTb, function(a, b)
        -- 即将开放的放在已开放后面
        if a.desc.isExistence ~= b.desc.isExistence then
            return a.desc.isExistence
        end
        -- 开启的在前面，未解锁的在中间，以领取放后面
        if a.status == b.status then
            return checkint(a.weight) < checkint(b.weight)
        else
            return a.status < b.status
        end
    end)
end

function WelfareData:addWelfareTable()
    --所有的活动剪去 关闭的活动 需要显示的活动数量
    local cout = 0
    for i,v in ipairs(welfareTb) do
         --关闭活动的数量
         if self:isActiveSatue(v.activeId, true) then
            cout = cout + 1
         end
    end

    local AactivityCount = #welfareTb - cout
    local Cnt = AactivityCount % 4
    if Cnt ~=0 then
        for i=1,4 - Cnt do
            local s= {
                activeId = "jjkf"..i,
                weight = AactivityCount +i,
                status = WelfareData.OPENSTATUS,
                desc   = {isExistence = false, title = "即将开放", icon = ""},
                pushScnece = {},
            }
             table.insert(welfareTb, s)
        end
    end

end

function WelfareData:GetWelfareTable(info)
     return clone(welfareTb)
end

function WelfareData:initDataInfo(welfareInfoTab)
    self:initActiveSwitch()
    --初始化游戏中需要的配置的数据
    if welfareInfoTab ~= nil and #welfareInfoTab > 0 then
        --读取游戏配置的接口
        self._gameInfo = welfareInfoTab
        self:filtrateGameData()
    end
end

--筛选游戏中需要的配置的数据
function WelfareData:filtrateGameData()
    local tab = {}
    for i,v in ipairs(self._gameInfo) do
        table.insert(tab, self:getWelfareAcitveInfo(v))
    end
    --开启的在前面，未解锁的在中间，以领取放后面
    table.sort(tab, function(a, b)
         if a.status == b.status then
             return checkint(a.weight) < checkint(b.weight)
         else
             return a.status < b.status
         end
    end)
    welfareTb = tab
end

--活动完成的状态
function WelfareData:collectionState()
    for i, v in ipairs (welfareTb) do
        if self:isActiveSatue(v.activeId, true) then
            v.desc.isOpen = false
        else
            v.desc.isOpen = true
        end
        --福利活动要解锁
        if v.desc.unlocakContentId and not self:isActiveSatue(v.desc.unlocakContentId)then
            v.status = WelfareData.UNLOCKEDSTATUS
        else
            v.status = WelfareData.OPENSTATUS
        end
        --福利活动完成的判断
        if  self:isActiveSatue(v.activeId) then
            --特殊活动的完成图片
            if v.desc.otherRecrivesImg then
                v.status = WelfareData.OTHNERRECRIVESTATUS
            else
                v.status = WelfareData.RECRIVESTATUS
            end
        end
    end
end

function WelfareData:isActiveSatue(bactiveId, statue)
    --ture去判断该活动是否开启，反之判断该活动是否完成领取奖励
    if statue then
        return  Table:isValueExist(self._activeCloseBtn, bactiveId)
    else
        return  Table:isValueExist(self._finishBtn,bactiveId)
    end
end

--------------------------------------------------------------------
-- 新手签到奖励
--------------------------------------------------------------------
local NewUserSignCfg = nil  --新手签到奖励配置
local NewUserbeiShuCfg = nil --新手签到双倍奖励配置
function WelfareData:getNewUserSignCfg(callback)
    if NewUserSignCfg and NewUserbeiShuCfg then
        if callback then
            callback(NewUserSignCfg,NewUserbeiShuCfg)
        end
    else
        gg.Dapi:TaskNewConfig(94, function(result)
            if result.status == 0 then
                NewUserSignCfg = result.data[1].awards
                NewUserbeiShuCfg = result.data[1].double
                if callback then
                    callback(NewUserSignCfg,NewUserbeiShuCfg)
                end
            end
        end)
    end
end

--判断是否需要显示新手签到活动
function WelfareData:canShowNewUserActivity()
    -- 只有更新到新版本之后注册的新用户才能弹出新手签到界面
    if not gg.UserData:IsNewAppVersionUser(39) then
        return false
    end
    return true
end
--------------------------------------------------------------------
-- 每日签到奖励
--------------------------------------------------------------------
local DailySignCfg = nil  --每日签到奖励配置
function WelfareData:getDailySignCfg(callback)
    if DailySignCfg  then
        if callback then
            callback(DailySignCfg)
        end
    else
        --获取每日签到奖励显示
        gg.Dapi:TaskNewConfig(96, function(result)
            if result.status == 0 then
                DailySignCfg = result.data[1].awards
                if callback then
                    callback(DailySignCfg)
                end
            end
        end, 1)
    end
end
local DailyShareCfg = nil  --每日分享奖励配置
function WelfareData:getDayShareAward(callback)
    if DailyShareCfg  then
        if callback then
            callback(DailyShareCfg)
        end
    else
        --获取每日签到奖励显示
        gg.Dapi:TaskNewConfig(97, function(result)
            if result.status == 0 then
                DailyShareCfg = result.data[1].awards
                if callback then
                    callback(DailyShareCfg)
                end
            end
        end)
    end
end
--显示签到
function WelfareData:isShowSign()
    --false 代表 新手签到未完成
    local newuserSign = self:isShowDay()
    --判断是否完成签到 及是新版本玩家
    if not newuserSign and self:canShowNewUserActivity()  then --新手签到
        local iStatus = gg.UserData:GetNewUserSignStatus()
        if iStatus == 3 then
            return 94,false
        else
            return 94,true
        end
    else --每日签到
        local iStatus = gg.UserData:GetDailySignStatus()
        if iStatus == 3 then
            return 96,false
        else
            return 96,true
        end
    end

end
--是否显示新手签到
function WelfareData:isShowDay()
    --新手签到已经完成
    local iStatus = gg.UserData:GetNewUserSignStatus()
    local iCount = gg.UserData:GetNewUserCount()
    local isNewUser = self:canShowNewUserActivity()  -- true代表不是新版本玩家
    if( (iStatus == 5 and iCount == 5) or (iStatus== 3 and iCount == 5) )  and isNewUser then
        return true  --新手已经完成
    end
    return false
end
--获取vip等级大于3
function WelfareData:getVipGrade()
    if not hallmanager or not hallmanager.userinfo then
        return 0
    end
    local vipvalue = checkint(hallmanager.userinfo.vipvalue)
    local lv = gg.GetVipLevel(vipvalue)
    return checkint(lv)
end

return WelfareData
