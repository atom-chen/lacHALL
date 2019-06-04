--
-- Author: chenjingmin
-- Date: 2018-03-10
-- 活动相关的数据
--
local ActivityPageData = {}
local activePath = "hall.views.active."
local activeImagePath = "hall/active/"
local localCfgFile = require("common.FileTable").New()

-- 本地配置路径变量
local cachePath = Helper.GetCachePath()
local localConfigPath = cachePath.."activityReadTb.tmp"

-- 读取本地记录的活动已读状态数据
-- 数据格式：
-- {"xslb": { "1434534346" : 1}}
local actReadTb = localCfgFile:Open(localConfigPath)

-- 刷新本地存储
local function flush_()
    localCfgFile:Save(actReadTb, localConfigPath)
end

-- 活动 tag
ActivityPageData.ACTIVE_TAG_XSLB = "xslb"
ActivityPageData.ACTIVE_TAG_TJLB = "tjlb"
ActivityPageData.ACTIVE_TAG_CHDJC = "chdjc"
ActivityPageData.ACTIVE_TAG_CJDJC = "cjdjc"

ActivityPageData.ACTIVE_BFBFL_ZYY = "bfbfl-zyy"
ActivityPageData.ACTIVE_BFBFL_QD = "bfbfl-qd"

-- 活动显示相关的配置信息
local ActiveViewInfo =
{
    [ActivityPageData.ACTIVE_TAG_XSLB] = { viewName = activePath.."WelcomeSevenDay", imagePath = activeImagePath.."img_icon_xinshouhongbao.png", desc = "新手红包(7天)",btnCloseColor = {r=34,g=34,b=34} },
    [ActivityPageData.ACTIVE_TAG_TJLB] = { viewName = activePath.."ActiveSpecials", imagePath=activeImagePath.."img_icon_jindou3.png", desc = "特价礼包" ,btnCloseColor = {r=255,g=255,b=255} },
    [ActivityPageData.ACTIVE_TAG_CHDJC] = { viewName = activePath.."bonusPool.ActiveBonusPool", imagePath=activeImagePath.."img_ico_chaohao.png", desc = "超豪大奖池",btnCloseColor = {r=187,g=77,b=93} },
    [ActivityPageData.ACTIVE_TAG_CJDJC] = { viewName = activePath.."bonusPool.ActiveBonusPoolNormal", imagePath=activeImagePath.."img_ico_chaoji.png", desc = "超级大奖池",btnCloseColor = {r=187,g=77,b=93} },

    [ActivityPageData.ACTIVE_BFBFL_ZYY] = { viewName = activePath.."ActivityBfbflView", imagePath = activeImagePath.."img_ico_bfbfl.png",desc = "百分百返利",btnCloseColor = {r=255,g=255,b=255}},
    [ActivityPageData.ACTIVE_BFBFL_QD] = { viewName = activePath.."ActivityBfbflView", imagePath = activeImagePath.."img_ico_bfbfl.png",desc = "百分百返利",btnCloseColor = {r=255,g=255,b=255}},
}

-- 获取活动显示相关的配置信息
function ActivityPageData:getActivePageData()
    return clone(ActiveViewInfo)
end

-- 获取某个活动显示相关的配置信息
function ActivityPageData:getActivePageDataByTag(activityTag)
    local ret
    if ActiveViewInfo[activityTag] then
        ret = clone(ActiveViewInfo[activityTag])
    end
    return ret
end

-- 初始化活动数据
function ActivityPageData:initActiveData( data )
    self.activeInfo = data
end

-- 获取活动数据
function ActivityPageData:getActivityInfo()
    local ret = {}
    if self.activeInfo then
        ret = clone(self.activeInfo)
    end
    return ret
end

-- 获取某个活动的数据
function ActivityPageData:getActivityInfoByTag( activeTag )
    if not self.activeInfo then
        return nil
    end

    -- 查找相应的活动数据
    for k, v in pairs(self.activeInfo) do
        if v.active_tag == activeTag then
            return clone(v)
        end
    end

    return nil
end

-- 获取活动是否已读
function ActivityPageData:isActivityRead( activeTag )
    -- 获取活动的开始时间
    local info = self:getActivityInfoByTag(activeTag)
    local startTime = info.start_time

    -- 获取已读状态数据
    local readInfo = checktable(actReadTb[activeTag])
    return (readInfo and checkint(readInfo[""..startTime]) == 1)
end

-- 设置某个活动已读
function ActivityPageData:setActivityRead( activeTag )
    if self:isActivityRead(activeTag) then
        return
    end

    -- 获取活动的开始时间
    local info = self:getActivityInfoByTag(activeTag)
    local startTime = info.start_time

    -- 记录已读状态
    actReadTb[activeTag] = checktable(actReadTb[activeTag])
    actReadTb[activeTag][""..startTime] = 1

    -- 写入文件
    flush_()

    -- 发送活动已读通知
    GameApp:dispatchEvent(gg.Event.UPDATE_ACTIVITY_READED)
end

-- 获取某个活动的推送时间
function ActivityPageData:getPushTime( activeTag )
    actReadTb[activeTag] = checktable(actReadTb[activeTag])
    return actReadTb[activeTag].pushTime
end

-- 记录某个活动的推送时间
function ActivityPageData:recordPushTime( activeTag )
    -- 记录已读状态
    actReadTb[activeTag] = checktable(actReadTb[activeTag])
    actReadTb[activeTag].pushTime = os.time()

    -- 写入文件
    flush_()
end

return ActivityPageData
