--
-- Author: Your Name
-- Date: 2017-04-01 11:20:32
-- 朋友场邀请好友 数据缓存 快捷邀请

local InviteHelper = InviteHelper or {}
local HttpParams = import(".utils.HttpParams")

local inviteDescStr = nil

--设置 邀请好友规则描述 缓存串
function InviteHelper:setInviteDesc(_inviteDesc)
    inviteDescStr = _inviteDesc
end

--清除 邀请 序列串
function InviteHelper:clear()
    printf(" --- InviteHelper:clear 清除 邀请好友规则描述 缓存串")
    inviteDescStr = nil
end

--邀请 (点击邀请后调用) rulestr。规则字符串 ，roomownernick 房主昵称 可nil。 gamename 游戏名字 可nil
-- 2018-07-10 新增参数sharetype, 可nil。0-分享好友，1-友趣分享
function InviteHelper:inviteFriend(callback, rulestr, roomownernick, gamename, sharetype)
    sharetype = checkint(sharetype)

    inviteDescStr = rulestr or inviteDescStr
    if inviteDescStr == nil or inviteDescStr == "" or inviteDescStr == " " then
        printf("InviteHelper 邀请数据为空")
        return
    end
    if not GameClient then
        printf("InviteHelper game disconnected error ")
        return
    end

    local total = 0
    for i = 1, GameClient.roominfo.playersperdesk do
        if GameClient:GetPlayerByChair(i - 1) then
            total = total + 1
        end
    end
    local strPlayersCnt = ""
    local lackCnt = tonumber(checkint(GameClient.roominfo.playersperdesk) - checkint(total))
    if lackCnt > 0 and checkint(total) > 0 then
        strPlayersCnt = string.format(" 缺%d人", lackCnt)
    end

    roomownernick = roomownernick or "代开房间"
    gamename = gamename or checktable(GameClient.gameinfo).name
    gamename = string.gsub(gamename, "麻将", "")
    local title = gamename .. " 房号:" .. tostring(GameClient.roomkey) .. strPlayersCnt

    local roomkey = GameClient.roomkey
    local extTb = {game = gamename, roomid = GameClient.roominfo.id, gameid = GameClient.gameinfo.id, rule = inviteDescStr}
    -- 如果游戏命令行中有“mini”字段，要在邀请链接的数据中加入 mini=1
    if hallmanager and hallmanager.games then
        local game = hallmanager.games[GameClient.gameinfo.id]
        if game and checkint(checktable(game.cmd).mini) == 1 then
            extTb.mini = 1
        end
    end
    local url = self:getInviteLink(roomkey, roomownernick, extTb)
    
    if sharetype == 1 then
        -- 有趣分享
        local params = {}
        params.appIcon = gg.UserData:GetInviteIconUrl()
        params.appName = APP_NAME
        params.title = title
        params.content = inviteDescStr
        params.returnContent = url
        gg.ShareHelper:doShareByYouqu(params, callback)
    else
        -- 微信好友分享
        local wx_id = gg.UserData:GetInviteShareAppId()
        gg.ShareHelper:doShareWebType(title, gg.UserData:GetInviteIconUrl(), url, 0, callback, inviteDescStr, wx_id)
    end
end

-- 代开邀请好友 (点击邀请后调用)
function InviteHelper:agentInviteFriend(data, roomownernick, playerscnt)
    assert(data, "data nil error ")
    local roomkey = data.roomkey
    if not roomownernick and hallmanager then
        roomownernick = checktable(hallmanager.userinfo).nick
    end

    local title = tostring(data.name) .. " 房号:" .. tostring(roomkey) .. tostring(playerscnt or "")
    -- 拼接规则作为分享内容
    local desc = ""
    for i, v in ipairs(checktable(data.rule)) do
        local pos = string.find(v, ":")
        if pos then
            local str_rule = ""
            if string.sub(v, 1, pos - 1) == "局数" then
                str_rule = "共" .. string.sub(v, pos + 1) .. "局"
            else
                str_rule = v
            end
            desc = desc .. " " .. str_rule
        else
            desc = desc .. " " .. v
        end
    end

    local extTb = {game = data.name, roomid = data.roomid, gameid = data.gameid, rule = desc}
    if hallmanager and hallmanager.games then
        local game = hallmanager.games[data.gameid]
        if game and checkint(checktable(game.cmd).mini) == 1 then
            extTb.mini = 1
        end
    end

    local url = self:getInviteLink(roomkey, roomownernick, extTb)
    local wx_id = gg.UserData:GetInviteShareAppId()
    gg.ShareHelper:doShareWebType(title, gg.UserData:GetInviteIconUrl(), url, 0, nil, desc, wx_id)
end


--  房间号。房间规则。【房主 名称】可空
function InviteHelper:getInviteLink(roomkey, roomownernick, exttable)

    local packagename = Helper.packagescheme
    local region = gg.LocalConfig:GetRegionCode()
    if IS_WEILE and device.platform == "ios" and PRODUCT_ID then
        -- iOS 把 package scheme 中的 1001 换成 product id
        packagename = String:replace(packagename, "1001", tostring(PRODUCT_ID))
    end

    local params = {
        key = roomkey,
        package = packagename,
        appid = APP_ID,
        channelid = CHANNEL_ID,
        roomowner = roomownernick,
        region = region
    }
    if exttable and type(exttable) == "table" then --扩展参数表
        table.merge(params, exttable)
    end

    local schemeDomain = gg.UserData:GetSchemeDomain()
    local url = tostring(schemeDomain) .. "/joinRoom?key=" .. tostring(roomkey) .. "&data=" .. tostring(Helper.Base64Encode(HttpParams:BuildQuery(params)))

    printf("InviteHelper getInviteLink url :%s ", url)
    return url
end


return InviteHelper
