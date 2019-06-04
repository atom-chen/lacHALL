local ShareView = class("ShareView", cc.load("ViewPop"))

ShareView.RESOURCE_FILENAME = "ui/share/share_view.lua"

ShareView.RESOURCE_BINDING = {
    ["btn_close"] = { ["varname"] = "btn_close",   ["events"] = { { event = "click", method = "onClickClose"  } } }, -- 关闭按钮

    ["panel_bg"] = { ["varname"] = "panel_bg" },
    ["bg_share"] = { ["varname"] = "bg_share" },
    ["panel_root"] = { ["varname"] = "panel_root" },

    ["panel_1"] = { ["varname"] = "panel_1" },
    ["img_award_1"] = { ["varname"] = "img_award_1" },
    ["tick_1"] = { ["varname"] = "tick_1" },
    ["board_1"] = { ["varname"] = "board_1" },
    ["needs_1"] = { ["varname"] = "needs_1" },
    ["num_1"] = { ["varname"] = "num_1" },
    ["got_1"] = { ["varname"] = "got_1" },
    ["txt_award_1"] = { ["varname"] = "txt_award_1" },

    ["panel_2"] = { ["varname"] = "panel_2" },
    ["img_award_2"] = { ["varname"] = "img_award_2" },
    ["tick_2"] = { ["varname"] = "tick_2" },
    ["board_2"] = { ["varname"] = "board_2" },
    ["needs_2"] = { ["varname"] = "needs_2" },
    ["num_2"] = { ["varname"] = "num_2" },
    ["got_2"] = { ["varname"] = "got_2" },
    ["txt_award_2"] = { ["varname"] = "txt_award_2" },

    ["panel_3"] = { ["varname"] = "panel_3" },
    ["img_award_3"] = { ["varname"] = "img_award_3" },
    ["tick_3"] = { ["varname"] = "tick_3" },
    ["board_3"] = { ["varname"] = "board_3" },
    ["needs_3"] = { ["varname"] = "needs_3" },
    ["num_3"] = { ["varname"] = "num_3" },
    ["got_3"] = { ["varname"] = "got_3" },
    ["txt_award_3"] = { ["varname"] = "txt_award_3" },

    ["panel_4"] = { ["varname"] = "panel_4" },
    ["img_award_4"] = { ["varname"] = "img_award_4" },
    ["tick_4"] = { ["varname"] = "tick_4" },
    ["board_4"] = { ["varname"] = "board_4" },
    ["needs_4"] = { ["varname"] = "needs_4" },
    ["num_4"] = { ["varname"] = "num_4" },
    ["got_4"] = { ["varname"] = "got_4" },
    ["txt_award_4"] = { ["varname"] = "txt_award_4" },

    ["panel_5"] = { ["varname"] = "panel_5" },
    ["img_award_5"] = { ["varname"] = "img_award_5" },
    ["tick_5"] = { ["varname"] = "tick_5" },
    ["board_5"] = { ["varname"] = "board_5" },
    ["needs_5"] = { ["varname"] = "needs_5" },
    ["num_5"] = { ["varname"] = "num_5" },
    ["got_5"] = { ["varname"] = "got_5" },
    ["txt_award_5"] = { ["varname"] = "txt_award_5" },

    ["btn_share_0"]   = { ["varname"] = "btn_share_0", ["events"] = { { event = "click", method = "onClickShare0" } } }, -- 分享好友按钮
    ["btn_share_1"]   = { ["varname"] = "btn_share_1", ["events"] = { { event = "click", method = "onClickShare1" } } }, -- 分享朋友圈按钮
    ["btn_share_2"]   = { ["varname"] = "btn_share_2", ["events"] = { { event = "click", method = "onClickShare2" } } }, -- 分享有趣
}

function ShareView:onCreate()
    self:showDataLoading()
    self.panel_bg:setContentSize(cc.size(display.width, display.height))

    self.bg_share:setScale(math.min(display.scaleX, display.scaleY))

    -- 增加ipad适配，防止ipad界面分享关闭按钮不显示无法关闭界面问题
    if display.width / display.height == 4/3 then
        self.bg_share:setScale(display.scaleX)
    end

    local share_data = require("hall.models.ShareData")
    share_data:checkLoaded( function(status, share_info)
        if tolua.isnull(self) then return end

        if not status then
            self:showLoadFailed()
            return
        end

        self:hideDataLoading()

        self._isReward = false    -- 是否需要领取奖励

        self.share_info = share_info

        self:refresh()
    end )
end

function ShareView:refresh()
    local profDef = gg.GetPropList()

    local total_share_count = gg.UserData:GetShareNum()      -- 总分享次数
    local share_time = gg.UserData:GetShareTime()        -- 上一次有效（当天第一次）分享时间
    local share_date = os.date("%Y%m%d", share_time)
    local curr_date = os.date("%Y%m%d", os.time())

    local is_today_share = false    -- 今天是否分享过
    if curr_date == share_date then
        is_today_share = true
    end

    print("*** total share count:"..total_share_count..",time:"..share_time)

    -- 获取分享任务中最大的分享次数
    local max_share_count = 1
    for i, v in ipairs(self.share_info) do
        if max_share_count < v["share_count"] then
            max_share_count = v["share_count"]
        end
    end

    -- 当前轮分享到第几次
    local i_share_count = total_share_count % max_share_count

    --[[
        边界处理，当分享次数达到最大次数并且当天未分享过(通过分享状态判断)
        主要是为了满足以下场景：假设今天分享后分享次数达到最大值，则今天再进入分享界面则
            所有奖励均显示已领取。明天进入分享界面则所有奖励均显示为未领取，开始下一轮分享
    ]]--
    if i_share_count == 0 and is_today_share == true then
        i_share_count = max_share_count
    end

    for i, v in ipairs(self.share_info) do
        local share_count = v["share_count"]

        if i_share_count >= share_count then
            -- 已领取
            self["needs_"..i]:setVisible(false)
            self["num_"..i]:setVisible(false)
            self["got_"..i]:setVisible(true)
            self["tick_"..i]:setVisible(true)
            self["panel_"..i]:setOpacity(102)       -- 设置透明度
        else
            local need_num = share_count - i_share_count    -- 还需多少天可领取奖励

            if is_today_share == false and need_num == 1 then
                self._isReward = true       -- 有奖励的分享
                self._rewardCfg = {{v.prob_type, v.prob_count}}         -- 记录奖励数据
            end

            -- 还需xx天
            self["needs_"..i]:setVisible(true)
            self["num_"..i]:setVisible(true)
            self["num_"..i]:setString(tostring(need_num))
            self["got_"..i]:setVisible(false)
            self["tick_"..i]:setVisible(false)
            self["panel_"..i]:setOpacity(255)       -- 设置透明度
        end

        local prob_type = v["prob_type"]
        local prob_count = v["prob_count"]
        local prob_name = profDef[prob_type].name
        local prob_icon = profDef[prob_type].icon_l or profDef[prob_type].icon
        if prob_type == PROP_ID_MONEY then
            prob_icon = "hall/common/dou_3.png"
            self["img_award_"..i]:loadTexture(prob_icon, 1)
            self["img_award_"..i]:setScale(1.3)
        elseif prob_type == PROP_ID_XZMONEY then
            prob_icon = "hall/common/diamond.png"
            self["img_award_"..i]:loadTexture(prob_icon, 1)
            self["img_award_"..i]:setScale(0.9)
        else
            self["img_award_"..i]:loadTexture(prob_icon)
        end
        self["img_award_"..i]:ignoreContentAdaptWithSize(true)
        self["txt_award_"..i]:setString(prob_name.."x"..tostring(prob_count))
    end
end

function ShareView:showDataLoading()
    if not self.loadingNode then
        self.loadingNode = ccui.Text:create()
        self.loadingNode:setFontSize(34)
        self.loadingNode:setTextColor({r = 127, g = 127, b = 127})
        self.loadingNode:setString("数据加载中...")
        self.loadingNode:setPosition(display.width * 5 / 8, display.height / 2)
        self:addChild(self.loadingNode)
    end
    self.loadingNode:setVisible(true)
    self.panel_root:setVisible(false)
    self.btn_share_0:setVisible(false)
    self.btn_share_1:setVisible(false)
    self.btn_share_2:setVisible(false)
end

function ShareView:showLoadFailed()
    if self.loadingNode then
        self.loadingNode:setString("数据加载失败，请关闭窗口重试！")
    end
end

function ShareView:hideDataLoading()
    if self.loadingNode then
        self.loadingNode:setVisible(false)
    end

    self.panel_root:setVisible(true)
    self.btn_share_0:setVisible(true)
    self.btn_share_1:setVisible(true)
    self.btn_share_2:setVisible(true)
    --有趣的开关
    if gg.GetNativeVersion() < 6 or not GameApp:CheckModuleEnable(ModuleTag.YouQuShare) then
        self.btn_share_2:setVisible(false)
    end
end

function ShareView:onClickClose()
    self:removeSelf()
end

-- 分享给好友
function ShareView:onClickShare0()
    gg.AudioManager:playClickEffect()

    self:doShareWeChat(0)
    --self:removeSelf()
end

-- 分享到朋友圈
function ShareView:onClickShare1()
    gg.AudioManager:playClickEffect()

    self:doShareWeChat(1)
    --self:removeSelf()
end

-- 分享到有趣
function ShareView:onClickShare2()
    gg.AudioManager:playClickEffect()
    local shareTb = gg.UserData:GetShareDataTable()
    if (not shareTb.pic) and (not shareTb.text or not shareTb.icon or not shareTb.url) then
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "分享失败，请重试！")
        return
    end

    local shareCallback = function(status)
        gg.InvokeFuncNextFrame(function()
            if status and tonumber(status) == 0 then
                GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "分享成功！")                 
            else
                GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "分享失败！") 
            end
        end)
    end

    local params = {}
    params.appName = APP_NAME
    if shareTb.pic and #shareTb.pic > 0 then
        params.appIcon = shareTb.icon                
        params.imagePath = shareTb.pic
        gg.ShareHelper:doShareByYouqu(params, shareCallback)
    else
        params.imagePath = shareTb.icon
        params.title = shareTb.text
        params.content = shareTb.text
        params.returnContent = shareTb.url
        gg.ShareHelper:doShareByYouqu(params, shareCallback)
    end
end

-- 调起分享
-- 分享给好友只使用微信 SDK 分享
-- 分享到朋友圈时，不会给奖励的那次分享使用系统原生分享
function ShareView:doShareWeChat(wxscene)
    wxscene = wxscene or 1
    local shareTb = gg.UserData:GetShareDataTable()
    if (not shareTb.pic) and (not shareTb.text or not shareTb.icon or not shareTb.url) then
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "分享失败，请重试！")
        return
    end

    local wxID = shareTb.wx_id or shareTb.id
    local function shareCallback(result)
        if checkint(result.status) ~= 0 then return end
        -- 分享给好友不发奖励
        if wxscene == 0 then return end

        local share_time = gg.UserData:GetShareTime()        -- 上一次有效（当天第一次）分享时间
        local share_date = os.date("%Y%m%d", share_time)
        local curr_time = os.time()
        local curr_date = os.date("%Y%m%d", curr_time)
        
        -- 分享成功每次都需要请求领取奖励接口来做统计
        gg.Dapi:ShareTaskAward(86, 1, 0, wxID, shareTb.domain, checkint(shareTb.share_id), function(x)
            if x.status == 0 then
                -- 今天分享过，不是今日首次分享，不再进行领取奖励的逻辑
                if curr_date == share_date then return end

                gg.UserData:SetShareTime(curr_time)   -- 更新分享时间
                local share_num = gg.UserData:GetShareNum()      -- 总分享次数
                share_num = share_num + 1
                gg.UserData:SetShareNum(share_num)
                -- 分享领取奖励成功，通知大厅关闭分享提示动画
                GameApp:dispatchEvent(gg.Event.FIRST_DAILY_SHARE_SUCCESS)

                if tolua.isnull(self) then return end
                -- 有奖励的那次需要弹出奖励领取成功提示
                if self._isReward then
                    if self._rewardCfg then
                        GameApp:DoShell(nil, "GetRewardView://", self._rewardCfg)
                    else
                        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "奖励领取成功！")
                    end
                    self._isReward = false
                    self._rewardCfg = nil
                end
                self:refresh()
            else
                print(x.msg or "未知错误！")
            end
        end)
    end

    -- 2018-07-21 分享到朋友圈时，根据web下发的is_system_share字段控制是否使用系统分享
    if wxscene == 1 and gg.UserData:GetShareType() == 1 then
        print("分享朋友圈，使用系统分享")
        if shareTb.pic and #shareTb.pic > 0 then
            gg.ImageDownload:Start(shareTb.pic, function(lpath, err)
                if lpath then
                    local params = {}
                    params.imgUrl = lpath
                    gg.ShareHelper:doShareBySystem(wxscene, 2, params, shareCallback, wxID)
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
                    gg.ShareHelper:doShareBySystem(wxscene, 0, params, shareCallback, wxID)
                end
            end, nil, Helper.sdcachepath)
        end
    else
        print("SDK分享！！！！！！！！！！！")
        if shareTb.pic and #shareTb.pic > 0 then
            gg.ImageDownload:Start(shareTb.pic, function(lpath, err)
                if lpath then
                    gg.ShareHelper:doShareImageType(lpath, wxscene, shareCallback, wxID)
                else
                    GameApp:dispatchEvent(gg.Event.SHOW_TOAST, err or "分享拉取失败，错误码：1")
                end
            end, nil, Helper.sdcachepath)
        else
            gg.ShareHelper:doShareWebType(shareTb.text, shareTb.icon, shareTb.url, wxscene, shareCallback, nil, wxID)
        end
    end
end

return ShareView
