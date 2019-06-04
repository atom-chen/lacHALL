local M = class("WelfareShareGift", cc.load("ViewPop"))
M.RESOURCE_FILENAME = "ui/welfare/welfareShareGift.lua"
M.RESOURCE_BINDING =
{

    ["Panel_bg"] = { ["varname"] = "Panel_bg" },
    ["btn_close"] = {["varname"] = "btn_close",  ["events"] = {{["event"] = "click", ["method"] = "onClickClose"}}},
    ["btn_share"] = {["varname"] = "btn_share",  ["events"] = {{["event"] = "click", ["method"] = "onClickShare"}}},
    ["award1"] = {["varname"] = "award1",  ["events"] = {{["event"] = "click", ["method"] = "onClickAward"}}},
    ["award2"] = {["varname"] = "award2",  ["events"] = {{["event"] = "click", ["method"] = "onClickAward"}}},
    ["img_select"] = { ["varname"] = "img_select" },
}

M.AWARD_TYPES =
{
    BTN_DOUDOU= 0,
    BTN_GIFT = 1,
}

function M:onCreate()
    self:init()
end
function M:init()
    -- 道具
    self._propDef  = gg.GetPropList()
    self.Award_type = M.AWARD_TYPES.BTN_DOUDOU
end


function M:setAwardInfo(Info)
    if not Info then return end
    self._rewardTb = {}
    for i,v in ipairs(checktable(Info[1])) do
        table.insert(self._rewardTb, {v.propType, v.propCount})
    end
    --设置初始化奖励
    self:setAwaredView(Info[1])
end
--奖励的显示
function M:setAwaredView(data)
    if not data then return end
    self._rewardCfg = data
    for k,v in ipairs (data) do
        if k == 3 then return  end
        local award_Icon = self.Panel_bg:findNode("img_award"..k)
        local zz = award_Icon:getContentSize().width
        local award_Count = self.Panel_bg:findNode("award_count"..k)
        if award_Count == nil and award_Icon == nil  then return ; end

        local img_lipinprop = self._propDef[v.propType]
        if v.propType == PROP_ID_MONEY  then
            award_Count:setString(string.format( "%d豆" ,v.propCount) )
            award_Icon:loadTexture("hall/welfare/sign/icon_doudou.png",1)
            award_Icon:setScale(1.8)
        else
            award_Count:setString(string.format( "%sx%d" ,img_lipinprop.name,v.propCount) )
            local iconPath = gg.IIF(img_lipinprop.icon_l, img_lipinprop.icon_l, img_lipinprop.icon)
            award_Icon:loadTexture(iconPath)
            award_Icon:setScale(1)
        end
        award_Icon:ignoreContentAdaptWithSize(true)
    end

end
--选择奖励
function M:onClickAward(sender)
    if sender == self.award1 then
        self.Award_type = M.AWARD_TYPES.BTN_DOUDOU
        self.img_select:setPosition(self.award1:getPosition())
    elseif sender == self.award2 then
        self.Award_type = M.AWARD_TYPES.BTN_GIFT
        self.img_select:setPosition(self.award2:getPosition())
    end
end

--关闭
function M:onClickClose()
    self:removeSelf()
end


--分享朋友圈
function M:onClickShare()
    local shareTb = gg.UserData:GetShareDataTable()
    if (not shareTb.pic) and (not shareTb.text or not shareTb.icon or not shareTb.url) then
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "分享失败，请重试！")
        return
    end
    local wxID = shareTb.wx_id or shareTb.id
    local tabAward = nil
    if self._rewardTb and #self._rewardTb > 0 then
        tabAward = {self._rewardTb[self.Award_type + 1]}
    end
    local function shareCallback(result)
        if checkint(result.status) ~= 0 then return end
        if not self.Award_type then return end
        -- 分享成功每次都需要请求领取奖励接口来做统计
        gg.Dapi:ShareTaskAward(105, 0, self.Award_type, wxID, shareTb.domain, checkint(shareTb.share_id), function(x)
            if x.status == 0 then
                --设置已经分享状态
                gg.UserData:SetShareGiftStatus(5)
                --福利界面刷新
                GameApp:dispatchEvent(gg.Event.WELFARE_ACTIVITY, "share")
                -- 有奖励要弹出奖励领取成功提示
                local params = {}
                params.removeCallback  = function()
                    if tolua.isnull(self) then return end
                    self:removeSelf()
                end
                if tabAward then
                    --设置分享奖励
                    GameApp:DoShell(nil, "GetRewardView://0",  tabAward,params)
                end

            else
                print(x.msg or "未知错误！")
            end
        end)
    end

    if gg.UserData:GetShareType() == 1 then
        print("分享朋友圈，使用系统分享")
        if shareTb.pic and #shareTb.pic > 0 then
            gg.ImageDownload:Start(shareTb.pic, function(lpath, err)
                if lpath then
                    local params = {}
                    params.imgUrl = lpath
                    gg.ShareHelper:doShareBySystem(1, 2, params, shareCallback, wxID)
                else
                    GameApp:dispatchEvent(gg.Event.SHOW_TOAST, err or "分享拉取失败，错误码：1")
                end
            end, nil, Helper.sdcachepath)
        else
            if device.platform == "android" then
                -- 2018-07-21 安卓不支持图文分享格式，直接提示错误，不再调整使用SDK分享
                GameApp:dispatchEvent(gg.Event.SHOW_TOAST, err or "分享拉取失败，错误码：2")
                return
            end
            local params = {}
            params.content = shareTb.text
            params.url = shareTb.url
            local imgurl = shareTb.icon -- 使用连接的ICON作为图片进行分享
            gg.ImageDownload:Start(imgurl, function(lpath, err)
                if lpath then
                    params.imgUrl = lpath
                    gg.ShareHelper:doShareBySystem(1, 0, params, shareCallback, wxID)
                end
            end, nil, Helper.sdcachepath)
        end
    else
        print("SDK分享！！！！！！！！！！！")
        if shareTb.pic and #shareTb.pic > 0 then
            gg.ImageDownload:Start(shareTb.pic, function(lpath, err)
                if lpath then
                    gg.ShareHelper:doShareImageType(lpath, 1, shareCallback, wxID)
                else
                    GameApp:dispatchEvent(gg.Event.SHOW_TOAST, err or "分享拉取失败，错误码：1")
                end
            end, nil, Helper.sdcachepath)
        else
            gg.ShareHelper:doShareWebType(shareTb.text, shareTb.icon, shareTb.url, 1, shareCallback, nil, wxID)
        end
    end

end


return M