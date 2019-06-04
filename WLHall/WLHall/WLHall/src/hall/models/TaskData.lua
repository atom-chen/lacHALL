----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-03-15
-- 描述：任务数据
----------------------------------------------------------------------

local TaskData = class("TaskData")

function TaskData:getInstance()
    if TaskDataInstance then
        return TaskDataInstance
    end
    local ret = TaskData.new()
    ret:init()
    rawset(_G, "TaskDataInstance", ret)
    return ret
end

function TaskData:init()
	self:initTestData()
end

--------------------------
-- 集星礼包任务
--------------------------
function TaskData:getPackageTask(idx)
    return self.mPackageTask[idx]
end

--------------------------
--元宝任务
--------------------------
function TaskData:setYuanBaoData(name, rewards, done, cost)
    self.mYuanBaoTask = 
    {
        name = name, 
        rewards = rewards, 
        done = done,
        skip_cost = cost,
    }
end

function TaskData:getYuanBaoTask()
    return self.mYuanBaoTask
end

-- 跳过元宝任务
function TaskData:requestSkipYuanBaoTask(co)
    if GameClient == nil then return end
end

-- 领取元宝任务
function TaskData:requestGainYuanBaoTask(co)
    if GameClient == nil then return end
end

--------------------------
-- 宝箱任务 
--------------------------

function TaskData:setChestTaskData(curPlay, curWin, nBureau, nWinBureau)
    self.mChestTask[1].pro = curPlay
    self.mChestTask[2].pro = curWin
    self.mChestTask[1].total = nBureau or self.mChestTask[1].total
    self.mChestTask[2].total = nWinBureau or self.mChestTask[2].total
end

function TaskData:setChestLevel(level)
    level = level + 1
    level = math.max(1, level)
    level = math.min(4, level)
    self.mChestTask[1].level = level
    self.mChestTask[2].level = level
end

-- 增加进度
function TaskData:addChestTask(nBureau, nWinBureau)
    self.mChestTask[1].pro = self.mChestTask[1].pro + nBureau
    self.mChestTask[2].pro = self.mChestTask[2].pro + nWinBureau
    self.mChestTask[1].pro = math.min(self.mChestTask[1].pro, self.mChestTask[1].total)
    self.mChestTask[2].pro = math.min(self.mChestTask[2].pro, self.mChestTask[2].total)
end

function TaskData:setOpenChestData(data, vipData)
    local lv = gg.GetVipLevel(hallmanager.userinfo.vipvalue)
    self.mOpenChestData = data
    if lv > 0 then
        for _, val in ipairs(vipData) do
            val[3] = 1
            table.insert(self.mOpenChestData, val)
        end
    end
end

function TaskData:setChestRewards(bureauRewardsID, vipBureauRewardsID, winBureauRewardsID, winVipBureauRewardsID)
    local d1 = self:getChestTask(1)
    local d2 = self:getChestTask(2)
    local lv = gg.GetVipLevel(hallmanager.userinfo.vipvalue)
    d1.reward = bureauRewardsID
    d2.reward = winBureauRewardsID
    if lv > 0 then
        for _, val in ipairs(vipBureauRewardsID) do
            val[3] = 1
            table.insert(d1.reward, val)
        end
        for _, val in ipairs(winVipBureauRewardsID) do
            val[3] = 1
            table.insert(d2.reward, val)
        end
    end
end

function TaskData:getChestTask(idx)
    return self.mChestTask[idx]
end

function TaskData:getChestPercent()
    local p1 = self.mChestTask[1].pro / self.mChestTask[1].total
    local p2 = self.mChestTask[2].pro / self.mChestTask[2].total
    local max = math.max(p1, p2)
    local percent = math.min(100, math.floor(max * 100))
    return percent
end

-- 请求开启宝箱
function TaskData:requestOpenChest(co, idx)
    self.mOpenChestData = nil
    if not (GameClient == nil or GameClient.sendReceiveBureauRankReward == nil) then
        GameClient:sendReceiveBureauRankReward(idx)
        WaitForFuncResult(co, function() return self.mOpenChestData ~= nil end)
        return self.mOpenChestData
    end
    if self.requestFun then
        self.requestFun(idx)
        WaitForFuncResult(co, function() return self.mOpenChestData ~= nil end)
        return self.mOpenChestData
    end
end

function TaskData:registerOpenChestFun(fun)
    self.requestFun = fun
end


function TaskData:initTestData()
    self.mPackageTask = 
    {
		{
			id        = 1,
			title     = "7日礼包",
			content   = "Lv.1",
			remark    = "7天内累计一定星值,即可兑换奖励",
			pro       = 10,
			total     = 30,
			reward    = {{PROP_ID_LOTTERY,10},{PROP_ID_MONEY,10},{PROP_ID_MONEY,20}, {PROP_ID_MONEY,20}},
			remaining = "剩余7天",
			iscomplete=false,
			ico = "games/common/images/task/item_treasure_chest_3.png",
			title_color = gg.ConvertColor("f9e4d3"),
		},
		{
			id        = 2,
			title     = "30日礼包",
			content   = "Lv.2",
			remark    = "30天内累计一定星值,即可兑换奖励",
			pro       = 10,
			total     = 30,
			reward    = {{PROP_ID_LOTTERY,10},{PROP_ID_MONEY,10},{PROP_ID_MONEY,20, 1}},
			remaining = "剩余30天",
			iscomplete=false,
			ico = "games/common/images/task/item_treasure_chest_4.png",
			title_color = gg.ConvertColor("f9dad3"),
		},
	}

	self.mYuanBaoTask = 
    {
        lock = true,
        name = "未设置礼品券任务", 
        rewards = math.random(1000, 2000), 
        done = false,
        skip_cost = 100,
    }

	self.mChestTask = 
    {
		{
            format_title = "玩  %s  局",
			id    = 1,
			pro   = 0,
			total = 2,
			level = 1,

            title     = "局数宝箱",
			remark    = "累计玩到一定局数时，即可兑换奖励。VIP可获得额外奖励。",
            reward    = {{PROP_ID_LOTTERY,10},{PROP_ID_MONEY,10},{PROP_ID_MONEY,20, 1}},
		},
		{
            format_title = "胜  %s  局",
			id    = 2,
			pro   = 0,
			total = 2,
			level = 1,

            title     = "胜利宝箱",
			remark    = "累计胜利一定局数时，即可兑换奖励。VIP可获得额外奖励。",
            reward    = {{PROP_ID_LOTTERY,10},{PROP_ID_MONEY,10},{PROP_ID_MONEY,20, 1}},
		},
	}
end


return TaskData
