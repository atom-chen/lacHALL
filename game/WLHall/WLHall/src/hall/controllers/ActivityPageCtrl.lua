--
-- Author: zhangbin
-- Date: 2018-05-16
-- 活动相关的 controller
--
local ActivityPageCtrl = {}

--[[
@brief 创建指定的活动界面
@param activityTag 活动标签
]]
function ActivityPageCtrl:createPageView( activityTag, ... )
    -- 判断活动是否需要显示
    if not self:canShowActivity(activityTag) then
        return nil
    end

    -- 创建界面
    local viewName = self:getActivityViewName(activityTag)
    local activityInfo = gg.ActivityPageData:getActivityInfoByTag(activityTag)
    local view = require(viewName):create(nil, viewName, activityInfo, ...)
    return view
end

-- 判断活动是否需要显示
function ActivityPageCtrl:canShowActivity( activityTag )
    local activityInfo = gg.ActivityPageData:getActivityInfoByTag(activityTag)
    if not activityInfo then
        -- 没有活动数据
        return false
    end

    local viewName = self:getActivityViewName(activityTag)
    if not viewName then
        -- 没有相应的界面
        return false
    end

    if gg.ActivityPageData.ACTIVE_TAG_XSLB == activityTag then
        -- 新手礼包活动
        if not GameApp:CheckModuleEnable(ModuleTag[PROP_ID_261]) then
            -- 红包关闭了，不能显示
            return false
        end

        -- 只有更新到新版本之后注册的新用户才能弹出参与七天红包界面
        if not gg.UserData:IsNewAppVersionUser(31) then
            return false
        end

        -- 新手礼包活动需要检查玩家的注册时间
        local regTime = gg.UserData:GetUserRegisterTime()
        local endTime = regTime + 3600*24*10    -- 注册 10 天内可以显示
        local getTimes = gg.UserData:GetRedPacketTimes()
        -- 如果用户7天都未领取，则第8天登录也不再显示红包活动界面
        if os.time() > endTime or (os.time() > regTime + 3600*24*7 and getTimes == 0) then
            return false
        end
    elseif gg.ActivityPageData.ACTIVE_TAG_TJLB == activityTag then
        -- 限时特价活动，商品被禁用的话，活动不能显示
        local goods = gg.PopupGoodsData:getSpecialGoods()
        if gg.PayHelper:isGoodsDisabled(goods[1]) then
            return false
        end
    elseif gg.ActivityPageData.ACTIVE_TAG_CHDJC == activityTag then
        -- 超豪大奖池活动，商品被禁用的话，活动不能显示
        local StoreData = require("hall.models.StoreData")
        local goods = StoreData:getCHDJCGoods()
        if gg.PayHelper:isGoodsDisabled(goods[1].goods) then
            return false
        end
    end

    return true
end

-- 获取未读的活动数
function ActivityPageCtrl:getActivityUnreadCount( )
    local allActInfo = gg.ActivityPageData:getActivityInfo()
    local count = 0
    for k, v in pairs(allActInfo) do
        local canShow = self:canShowActivity(v.active_tag)
        local isRead = gg.ActivityPageData:isActivityRead(v.active_tag)
        if canShow and not isRead then
            count = count + 1
        end
    end

    return count
end

-- 获取可见的活动数
function ActivityPageCtrl:getActivityVisibleCount()
    local allActInfo = gg.ActivityPageData:getActivityInfo()
    local count = 0
    for k, v in pairs(allActInfo) do
        if self:canShowActivity(v.active_tag) then
            count = count + 1
        end
    end

    return count
end

-- 获取活动对应的界面名称
function ActivityPageCtrl:getActivityViewName(activityTag)
    -- 获取活动与弹出界面的映射关系
    local info = gg.ActivityPageData:getActivePageDataByTag(activityTag)
    if not info then
        return nil
    end

    -- 查找界面名称
    local viewName = info.viewName
    if not viewName or viewName == "" then
        return nil
    end

    return viewName
end

-- 检查是否有推送的活动
function ActivityPageCtrl:doCheckPush()
    if not GameApp:CheckModuleEnable(ModuleTag.Activity) then
        -- 活动模块没开启，啥也不用做
        return
    end

    local allActInfo = gg.ActivityPageData:getActivityInfo()
    local count = 0
    local pushTag
    for k, v in pairs(allActInfo) do
        local needPush = (checkint(v.push) == 1)
        local canShow = self:canShowActivity(v.active_tag)
        if needPush and canShow then
            -- 需要推送，并且可以显示，检查今天是否推送过
            local pushTime = gg.ActivityPageData:getPushTime(v.active_tag)
            if not pushTime then
                -- 没推送过
                pushTag = v.active_tag
                break
            end

            local dateStr = os.date("%Y%m%d", pushTime)
            local curDateStr = os.date("%Y%m%d")
            if dateStr ~= curDateStr then
                -- 今天没推送过
                pushTag = v.active_tag
                break
            end
        end
    end

    if pushTag then
        local pageData = {first_but_tag = 1, second_but_tag = pushTag}
        GameApp:dispatchEvent(gg.Event.SHOW_VIEW, "active.ActivityView", {push = true, popup = true}, pageData)
        -- 记录推送时间
        gg.ActivityPageData:recordPushTime(pushTag)
    end
end

return ActivityPageCtrl
