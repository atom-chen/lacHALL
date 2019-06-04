
local M = class("WelfareActive", cc.load("ViewLayout"))

local welfareViewData   = require("hall.models.WelfareData")

M.RESOURCE_FILENAME="ui/welfare/welfareActive.lua"

M.RESOURCE_BINDING =
{
    ["Panel_bg"]   = {["varname"] = "Panel_bg",["events"] ={{event="click",method="onClick"}}},  -- 背景

    ["Image_bg"]   = {["varname"] = "Image_bg"},  -- 背景
    ["Image_icon"] = {["varname"] = "Image_icon"},
    ["txt_title"]   = {["varname"] = "txt_title"},
    ["img_aniteBg"]   = {["varname"] = "img_aniteBg"},
    ["ani_mffl1"]   = {["varname"] = "ani_mffl1"},

    ["img_anite"]   = {["varname"] = "img_anite"},
    ["nd_txt"]   = {["varname"] = "nd_txt"},
    ["txt_count"]   = {["varname"] = "txt_count"},
    ["img_finish"]  = {["varname"] = "img_finish"},

    ["img_zhezhao"]  = {["varname"] = "img_zhezhao"},
}

function M:onCreate()
    self._welfareInfo = nil
    self.animation = self.resourceNode_["animation"]
    self:runAction(self.animation)
    self:stopAnite()
end

function M:setInfo(welfareInfo)
    self._welfareInfo = welfareInfo
    --
    if welfareInfo.status > welfareViewData.OPENSTATUS then
        self.Panel_bg:setTouchEnabled(false)
    else
        self.Panel_bg:setTouchEnabled(true)
    end
    --活动开放背景和即将开放的背景
    local path = welfareInfo.desc.isExistence and "hall/welfare/img_diban1.png" or "hall/welfare/img_diban2.png"
    self.Image_bg:loadTexture(path, 1)
    --活动icon
    self.Image_icon:loadTexture(welfareInfo.desc.icon, 1)
    self.Image_icon:ignoreContentAdaptWithSize(true)
    self.Image_icon:setVisible(welfareInfo.desc.isExistence)
    self.Image_icon:setScale(0.85)
    --活动标题
    self.txt_title:setString(welfareInfo.desc.isExistence and welfareInfo.desc.title or "即将开放")
    self.txt_title:setPositionY(welfareInfo.desc.isExistence and self.txt_title:getPositionY() or self.Image_bg:getContentSize().height /2 )

    self.ani_mffl1:setVisible(false)
    self.img_anite:setVisible(false)
    self.img_aniteBg:setVisible(false)
    self.nd_txt:setVisible(false)
    --活动奖励物品文本节点
    local call = function(info,otherInfo)
        if info then
            self._awardTab = info
            self._otherInfoTab = otherInfo

            self.txt_count:setString(info)
            --活动奖励整个节点
            self.nd_txt:setVisible(welfareInfo.desc.isExistence)
            --整个奖励的节点居中
            self:setNodePos()
        end
    end
    welfareViewData:GetAwardCfg(welfareInfo.activeId, call)

    --解锁和已领取的标识
    local bLockedOrReceive = welfareInfo.status >= welfareViewData.UNLOCKEDSTATUS and true or false
    self.img_zhezhao:setVisible(bLockedOrReceive)
    self.img_finish:loadTexture(welfareViewData:shadeStatusImg(welfareInfo.status, welfareInfo.activeId), 1)
    self.img_finish:ignoreContentAdaptWithSize(true)

    --解锁的功能文本提示
    local txt_locked = self.img_zhezhao:findNode("txt_tishi")

    txt_locked:setVisible(welfareInfo.status ~= welfareViewData.OTHNERRECRIVESTATUS and true or false)
    txt_locked:setString(welfareInfo.desc.statusHints or "已领取")
    --每日签到显示剩余多少天解锁
    if welfareInfo.activeId == "mrqd" then
        local newUserCount = gg.UserData:GetNewUserCount()
        txt_locked:setString(string.format(welfareInfo.desc.statusHints, 5 - newUserCount))
    end

    --即将开放的Node处理
    if not welfareInfo.desc.isExistence then
        self.Panel_bg:setTouchEnabled(false)
        self.nd_txt:setVisible(false)
    end
end

function M:showAnite()
    if self.animation then
        self.img_aniteBg:setVisible(true)
        self.ani_mffl1:setVisible(true)
       local ante = self.Panel_bg:getChildByName("img_anite")
       ante:setVisible(true)
       self.animation:play("ante", true)
    end
end

function M:stopAnite()
    if self.animation then
        self.animation:stop()
    end
end

function M:setNodePos()
    --超过节点的宽度就缩放
    local iwidth = self.txt_count:getContentSize().width
    local scaling = iwidth > self.img_zhezhao:getContentSize().width and (self.img_zhezhao:getContentSize().width - 20) / iwidth or 1

    local nodeWidth = (self.txt_count:getContentSize().width) * scaling
    self.nd_txt:setPositionX(self.Panel_bg:getContentSize().width/2 - nodeWidth/2)
    self.nd_txt:setScale(scaling)
end

function M:onClick(sender)
    if self._welfareInfo.desc.isExistence then
        if self._welfareInfo.activeId == "firstCharge" then
            self:onFirstPay()
        else
            local viewNode = self:getScene():createView(self._welfareInfo.pushScnece[1], self._welfareInfo.pushScnece[2])
            viewNode:pushInScene()
            if self._otherInfoTab then
                viewNode:setAwardInfo(self._otherInfoTab)
            end
        end
    else
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "此功能暂未开放！")
    end
end

function M:onFirstPay()
    local goodsId = gg.PopupGoodsCtrl:getFirstPayOrVIPGoods()
    if not goodsId then return end
    gg.InvokeFuncNextFrame(function()
        local popView = gg.PopupGoodsCtrl:popupGoodsView(goodsId)
    end)
end

function M:getNodeSize()
    return  self.Panel_bg:getContentSize()
end

return M;
