--
-- Author: Cai
-- Date: 2017-03-29
-- Describe：荣誉系统数据

local M = {}

local taskCfg = {
    [1] = {
        name = "累计对局(%d/100)",
        condition = 100,
        acnt = 10,
    },
    [2] = {
        name = "累计胜局(%d/100)",
        condition = 100,
        acnt = 30,
    },
    [3] = {
        name = "段位达到%s",
        acnt = 48,
    },
}
-- 获取荣誉系统的任务配置
function M:getHonorTaskCfg()
    return clone(taskCfg)
end

local gradeStr = {"新手", "初段", "中段", "高段", "专家", "大师"}
-- 获取段位的名称配置
function M:getGradeStrCfg()
    return clone(gradeStr)
end

--------------------------------------------------------------------
-- 用户的荣誉排行数据
--------------------------------------------------------------------
-- 注：荣誉系统的数据服务端每一小时刷新一次
local UserRankTime = 0
local UserRank = nil
function M:getUserHonorRanking(callback)
    local hour = os.date('%H', os.time())
    if not UserRank or tonumber(UserRankTime) ~= tonumber(hour) or #UserRank <= 0 then
        gg.Dapi:HonorRank(function(cb)
            cb = checktable(cb)
            if not cb.status or checkint(cb.status) ~= 0 then
                if callback then callback(UserRank, cb.msg or "网络错误，请关闭界面重试！") end
                return
            end
            -- 重新排序下数据表，方便界面的显示和控制
            local tb = checktable(cb.data)
            local newTb = {}
            local areaConfig = GameApp:getAreaConfig()
            for k,v in pairs(tb) do
                if string.find(v.name, "市辖区") then
                    local code = tonumber(string.sub(tostring(v.code), 1, string.len(v.code) - 2))
                    local name = areaConfig[code]
                    if name and string.len(name) > 1 then
                        if string.find(name, "市$") then
                            v.name = name .. "区"
                        else
                            v.name = name .. "市区"
                        end
                    end
                end

                if k == "Province" then
                    v.sort = 1
                elseif k == "City" then
                    v.sort = 2
                else
                    v.sort = 3
                end
                v.fabulous = checkint(cb.fabulous)
                v.is_light = checkint(cb.is_light)
                table.insert(newTb, v)
            end
            table.sort(newTb, function(a, b)
                return a.sort < b.sort
            end)
            UserRank = newTb
            UserRankTime = hour
            if callback then callback(UserRank) end
        end)
    else
        print("这个时段已经拉取过荣誉等级数据了！！！！")
        if callback then callback(UserRank) end
    end
end

--------------------------------------------------------------------
-- 荣誉排行榜数据
--------------------------------------------------------------------
local RankList = {}
local RankListTime = 0
function M:getRankListByRegion(rigion, callback)
    local hour = os.date('%H', os.time())
    if not RankList[rigion] or tonumber(RankListTime) ~= tonumber(hour) or #RankList[rigion] <= 0 then
        gg.Dapi:HonorList(rigion, function(cb)
            cb = checktable(cb)
            if not cb.status or checkint(cb.status) ~= 0 then
                if callback then callback(RankList[rigion], cb.msg or "网络错误，请关闭界面重试！") end
                return
            end
            RankList[rigion] = checktable(cb.data)
            RankListTime = hour
            if callback then callback(RankList[rigion]) end
        end)
    else
        if callback then callback(RankList[rigion]) end
    end
end

function M:updateZan(userid, isLight, count)
    for _,tb in pairs(RankList) do
        for _,v in pairs(tb) do
            if tonumber(v.userid) == tonumber(userid) then
                v.is_light = isLight
                v.fabulous = count
            end
        end
    end

    -- 给自己点赞修改缓存记录
    if hallmanager and hallmanager.userinfo and tonumber(hallmanager.userinfo.id) == tonumber(userid) then
        for _,v in pairs(checktable(UserRank)) do
            v.is_light = isLight
            v.fabulous = count
        end
    end
end

function M:doHonorShare(sharedata, shareCallback)
    if sharedata then
        self:shotShareImg(sharedata, shareCallback)
    else
        gg.Dapi:HonorProRank(function(cb)
            if cb.status and tonumber(cb.status) == 0 then
                self:shotShareImg(cb.data, shareCallback)
            else
                print("获取用户省排名数据失败...")
            end
        end)
    end
end

function M:shotShareImg(sharedata, shareCallback)
    local function doShotImg_(imgUrl)
        local imgPath = Helper.sdcachepath .. "honor_rank_share.jpg"
        if cc.FileUtils:getInstance():isFileExist(imgPath) then
            cc.FileUtils:getInstance():removeFile(imgPath)
        end
        local view = require("hall.views.honor.HonorShareView"):create()
        view:updateView(sharedata, imgUrl)
        local size = cc.Director:getInstance():getWinSize()
        local rtx = cc.RenderTexture:create(1136, 640, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888, gl.DEPTH24_STENCIL8_OES)
        rtx:begin()
        view:visit()
        rtx:endToLua()
        rtx:saveToFile(imgPath, cc.IMAGE_FORMAT_JPEG, false)

        gg.InvokeFuncNextFrame(function()
            self:doShare(imgPath, shareCallback)
        end)
    end

    local imgEwmUrl = gg.UserData:GetShareQuickMark("honor")
    if imgEwmUrl and imgEwmUrl ~= "" then
        GameApp:dispatchEvent(gg.Event.SHOW_LOADING, "正在拉起分享...")
        gg.ImageDownload:Start(imgEwmUrl, function(lpath, err)
            GameApp:dispatchEvent(gg.Event.SHOW_LOADING)
            if lpath then
                doShotImg_(lpath)
            else
                GameApp:dispatchEvent(gg.Event.SHOW_TOAST, err or "分享拉取失败，错误码：3")
            end
        end, nil, Helper.sdcachepath)
    else
        doShotImg_()
    end
end

function M:doShare(imgUrl, shareCallback)
    if not imgUrl then
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "分享失败，请重试！")
        return
    end

    if gg.UserData:GetShareType("honor") == 1 then
        print("调用系统分享分享荣誉排名")
        local params = {}
        params.imgUrl = imgUrl
        gg.ShareHelper:doShareBySystem(1, 2, params, shareCallback)
    else
        print("使用SDK分享分享荣誉排名")
        gg.ShareHelper:doShareImageType(imgUrl, 1, shareCallback)
    end
end

--------------------------------------------------------------------
-- 荣誉升段奖励
--------------------------------------------------------------------
local HonorRewardCfg = nil
function M:getHonorRewardCfg(callback)
    if HonorRewardCfg then
        if callback then
            callback(HonorRewardCfg)
        end
        return HonorRewardCfg
    else
        gg.Dapi:TaskNewConfig(93, function(result)
            if result.status == 0 then
                HonorRewardCfg = result.data[1].awards
                if callback then
                    callback(HonorRewardCfg)
                end
                return HonorRewardCfg
            end
        end)
    end
end

function M:cleanup()
    UserRankTime = 0
    RankListTime = 0
    UserRank = nil
    RankList = {}
end

return M