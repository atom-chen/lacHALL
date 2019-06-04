--
-- Author: Cai
-- Date: 2018-07-13
-- Describe：通用获的奖励提示

local M = class("GetRewardCommonView", cc.load("ViewPop"))
M.RESOURCE_FILENAME = "ui/common/common_reward_ani.lua"
M.RESOURCE_BINDING = {
    ["txt_vip_tips"]  = {["varname"] = "txt_vip_tips" },
    ["txt_more_tips"] = {["varname"] = "txt_more_tips"},
    ["txt_share_title"] = {["varname"] = "txt_share_title"},
    ["txt_close_tips"]  = {["varname"] = "txt_close_tips" },
    ["img_line"]  = {["varname"] = "img_line" },
    ["nd_ani"]    = {["varname"] = "nd_ani"  },
    ["icon_title"]= {["varname"] = "icon_title"},
    ["nd_items"]  = {["varname"] = "nd_items"},
    ["nd_prop"]   = {["varname"] = "nd_prop" },
    ["btn_close"] = {["varname"] = "btn_close", ["events"] = {{event = "click", method = "onClickClose"}}},
    ["panel_bg"]  = {["varname"] = "panel_bg",  ["events"] = {{event = "click_color", method = "onClickClose"}}},
    ["btn_share"] = {["varname"] = "btn_share", ["events"] = {{event = "click", method = "onClickShare"}}},
    ["btn_vip_tips"] = {["varname"] = "btn_vip_tips", ["events"] = {{event = "click", method = "showVIPDetail"}}},
    ["btn_common"] = {["varname"] = "btn_common", ["events"] = {{event = "click", method = "onClickCommonBtn"}}},
}

M.MODE = {
    NORMOL_MODE = 0,            -- 普通显示，只有关闭提示语句
    ONLY_VIP_TIPS_MODE = 1,     -- 界面显示仅VIP提示按钮
    ONLY_SHARE_BTN_MODE = 2,    -- 界面显示仅分享按钮
    SHARE_BTN_AND_VIP_MODE = 3, -- 界面显示分享按钮和VIP提示按钮
    COMMON_BTN_AND_VIP_MODE = 4,-- 普通按钮和VIP提示按钮
}

-- awardTb 获得的奖励，table类型，奖励id和数量，例：{{15, 2000}, {261, 1000}}
-- vType 界面类型
function M:onCreate(vType, awardTb, params)
    assert(awardTb, "award is nil")
    params = checktable(params)
    -- 为设置显示关闭按钮参数时，默认普通模式不显示，其他模式显示关闭按钮
    params.showCloseBtn = params.showCloseBtn or (vType > 0)

    self:initView(vType)
    self:setReward(awardTb)
    self:handlerParams(params)

    self.animation = self.resourceNode_["animation"]
    self:runAction(self.animation)
    if self.animation then
        self.animation:play("popAni", false)
        gg.AudioManager:playEffect("common/audio/get_reward.mp3")
    end
end

function M:initView(vType)
    self.btn_close:setVisible(false)
    self.btn_vip_tips:setVisible(false)
    self.panel_bg:setContentSize(cc.size(display.width, display.height))
    self.nd_ani:setScale(math.min(display.scaleX, display.scaleY))
    self.btn_close:setPosition(cc.p(display.cx - 60, display.cy - 60))

    if vType == M.MODE.ONLY_VIP_TIPS_MODE then
        self.btn_vip_tips:setVisible(true)
    elseif vType == M.MODE.ONLY_SHARE_BTN_MODE then
        self.btn_share:setVisible(true)
    elseif vType == M.MODE.SHARE_BTN_AND_VIP_MODE then
        self.btn_vip_tips:setPositionX(self.btn_share:getPositionX() - 350)
        self.btn_vip_tips:setPositionY(self.btn_share:getPositionY() - self.btn_share:getContentSize().height / 2  +18)
        self.btn_vip_tips:setVisible(true)
        self.btn_share:setVisible(true)
    elseif vType == M.MODE.COMMON_BTN_AND_VIP_MODE then
        self.btn_vip_tips:setPositionX(self.btn_share:getPositionX() - 300)
        self.btn_vip_tips:setPositionY(self.btn_share:getPositionY() - self.btn_share:getContentSize().height / 2 - 22)
        self.btn_vip_tips:setVisible(true)
        self.btn_common:setVisible(true)
        self.btn_common:setPositionY(self.btn_share:getPositionY() - 40)
    else
        self.txt_close_tips:setVisible(true)
        self.txt_close_tips:setPositionY(-display.cy + 50)
    end

    -- 分享开关关闭不显示分享按钮
    if not gg.UserData:CanDoShare() then
        self.btn_share:setVisible(false)
    end
    -- VIP开关
    if not GameApp:CheckModuleEnable(ModuleTag.VIP) then
        self.btn_vip_tips:setVisible(false)
    end
end

function M:setReward(awardTb)
    for i,v in ipairs(awardTb) do
        local item = self.nd_prop:clone()
        item:setVisible(true)
        item:setPosition(cc.p(116 / 2 + 130 * (i - 1), 0))
        self.nd_items:addChild(item)

        -- 奖励图片
        local prop = gg.GetPropList()[v[1]]
        item:getChildByName("img_icon"):loadTexture(prop.icon)
        -- 奖励数量
        local cnt = v[2] * (prop.proportion or 1)
        item:getChildByName("txt_cnt"):setString(string.format("x%d", cnt))
        -- 物品名称
        local name = prop.name
        if v[1] == PROP_ID_MONEY then
            name = BEAN_NAME
        end
        item:getChildByName("txt_prop"):setString(prop.name)
    end

    self.nd_items:setPositionX(- (#awardTb * 130 - 14) / 2)
end

function M:handlerParams(params)
    local FuncTable={
        ["showCloseBtn"] = self.setCloseBtn,
        ["vipTips"] = self.setVipTips,
        ["timesTips"] = self.setTimesTips,
        ["btnName"] = self.setShareBtnName,
        ["btnImgPath"] = self.setShareBtnPath,
        ["commonBtnImg"] = self.setCommonBtnImg,
        ["commonCallback"] = self.setCommonCallback,
        ["shareCallback"] = self.setShareCallback,
        ["removeCallback"] = self.setRemoveCallback,
        ["zorder"] = self.setViewZOrder,
    }
    for k,v in pairs(params) do
        local handle = FuncTable[k]
        if handle then
            handle(self, v)
        end
    end
end

function M:hideCloseBtn()
    self.btn_close:setVisible(false)
end

function M:setViewZOrder(z)
    self._zorder = z
end

function M:setCommonCallback(commonCallback)
    self._commonCallback = commonCallback
end

function M:setRemoveCallback(removeCallback)
    self._removeCallback = removeCallback
end

function M:setShareCallback(shareCallback)
    self._shareCallback = shareCallback
end

function M:setShareBtnPath(path)
    if not path then return end
    self.txt_share_title:setVisible(false)
    self.btn_share:ignoreContentAdaptWithSize(true)    
    self.btn_share:loadTextureNormal(path, 0)
    self.btn_share:loadTexturePressed(path, 0)
    self.btn_share:loadTextureDisabled(path, 0)
end

function M:setCommonBtnImg(path)
    if not path then return end
    local img = ccui.ImageView:create()
    img:loadTexture(path, 0)
    local size = img:getContentSize()

    self.btn_common:setContentSize(size)
    self.btn_common:ignoreContentAdaptWithSize(true)    
    self.btn_common:loadTextureNormal(path, 0)
    self.btn_common:loadTexturePressed(path, 0)
    self.btn_common:loadTextureDisabled(path, 0)
end

function M:setShareBtnName(txt)
    if not txt then return end
    self.txt_share_title:setString(txt)
    self.btn_share:setContentSize(cc.size(self.txt_share_title:getContentSize().width + 40, self.btn_share:getContentSize().height))
    self.txt_share_title:setPositionX(self.btn_share:getContentSize().width / 2)
end

function M:setTimesTips(txt)
    if not txt then return end
    self.icon_title:setPositionY(self.icon_title:getPositionY() + 30)
    self.txt_more_tips:setString(txt)
    self.txt_more_tips:setVisible(true)
end

function M:setVipTips(txt)
    if not txt then return end
    self.txt_vip_tips:setString(txt)
    self.btn_vip_tips:setContentSize(cc.size(self.txt_vip_tips:getContentSize().width + 10, self.btn_vip_tips:getContentSize().height))

    self.txt_vip_tips:setPositionX(self.btn_vip_tips:getContentSize().width / 2)
    self.img_line:setContentSize(cc.size(self.txt_vip_tips:getContentSize().width, 1))
    self.img_line:setPositionX(self.btn_vip_tips:getContentSize().width / 2)
    gg.LineHandle(self.img_line)
end

-- 设置关闭按钮显示
function M:setCloseBtn(showCloseBtn)
    self.panel_bg:setTouchEnabled(not showCloseBtn)
    self.btn_close:setVisible(showCloseBtn)
end

function M:showVIPDetail()
    self:getScene():createView("store.VipDetailed"):pushInScene()
end

function M:onClickCommonBtn()
    if self._commonCallback then
        self._commonCallback()
    end
    self:removeSelf()
end

function M:onClickShare()
    local shareTb = gg.UserData:GetShareDataTable()
    if (not shareTb.pic) and (not shareTb.text or not shareTb.icon or not shareTb.url) then
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "分享失败，请重试！")
        return
    end

    local wxID = shareTb.wx_id or shareTb.id
    local shareCallback = self._shareCallback

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

function M:onClickClose()
    self:removeSelf()
end

function M:removeWithoutCallback()
    M.super.removeSelf(self)
end

function M:removeSelf()
    if self._removeCallback then
        self._removeCallback()
    end
    M.super.removeSelf(self)
end

function M:getViewZOrder()
    return checkint(self._zorder)
end

return M