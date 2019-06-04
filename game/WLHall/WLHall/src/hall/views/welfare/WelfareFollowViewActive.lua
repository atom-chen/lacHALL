--关注有礼品

local M = class("WelfareFollowViewActive", cc.load("ViewPop"))
M.RESOURCE_FILENAME = "ui/welfare/welfareFollowActive.lua"
M.RESOURCE_BINDING =
{
    ["panel_bg"] = { ["varname"] = "panel_bg"},
    ["txt_ewm"] =  {["varname"] = "txt_ewm"},
    ["img_ewm"] =  {["varname"] = "img_ewm"},
    ["panel_awards"] =  {["varname"] = "panel_awards"},
    ["btn_copy"]  = {["varname"] = "btn_copy" ,  ["events"] = {{event = "click", method = "onClickCopy" }}},
    ["btn_close"] = {["varname"] = "btn_close",  ["events"] = {{event = "click", method = "onClickClose" }}},
    ["btn_followAward"]  = {["varname"] = "btn_followAward",  ["events"] = {{event = "click", method = "onClickFollowAward" }}},
}
M.LAYER_ALPHA = 25

function M:onCreate()
    --适配
    self:resetLayout()
    --
    self:initDate()
    --
    self:initView()

end

function M:setAwardInfo(Info)
    self._rewardTb = {}
    for i,v in ipairs(checktable(Info[1])) do
        table.insert(self._rewardTb, {v.propType, v.propCount})
    end

    --二维码
    self:setViewInfo(Info[2])
    --设置初始化奖励
    self:setAwaredView(Info[1])
end

function M:initView()
    self.img_ewm:setVisible(false)
    self.txt_ewm:setVisible(false)
    self.panel_awards:setVisible(false)

    --是否已领取
    if gg.UserData:getGzylStatus() == 5 then
        --按钮修改成已领取
        self:setBtnImg(self.btn_followAward, "hall/welfare/gzyl/img_yilingqu.png")
    end
end

function M:setViewInfo(webTabInfo)
    self.txt_ewm:setVisible(true)
    self.img_ewm:setVisible(true)
    self.panel_awards:setVisible(true)
    self.txt_ewm:setString(webTabInfo[1])
    --网络图片的接口
    gg.ImageDownload:LoadHttpImageAsyn(webTabInfo[2], self.img_ewm)
end

function M:initDate()
    -- 道具
    self._propDef  = gg.GetPropList()
end

function M:setAwaredView(tab)
    local isFirst = true
    --
    for k,v in ipairs (tab) do
        if isFirst then
            self:setNodeInfo(self.panel_awards, v)
            isFirst = false
        else
            local itemNode = self.panel_awards:clone()
            self:setNodeInfo(itemNode, v)
            itemNode:setPosition(cc.p(self.panel_awards:getPositionX() + (k - 1) * 120, self.panel_awards:getPositionY()))
            self.panel_bg:addChild(itemNode)
        end
    end
end

function M:setNodeInfo(node, tabInfo)
    local award_Icon = node:findNode("img_award1")
    local award_Count = node:findNode("txt_count1")
    if award_Count == nil and award_Icon == nil  then return ; end
    award_Count:setString("x"..tabInfo.propCount)

    local img_lipinprop = self._propDef[tabInfo.propType]
    award_Icon:loadTexture(img_lipinprop.icon)
    award_Icon:ignoreContentAdaptWithSize(true)
    award_Icon:setScale(0.75)
end

function M:resetLayout()
    self:setScale(math.min(display.scaleX, display.scaleY))
end

--复制公众号
function M:onClickCopy()
    if self.txt_ewm:getString() then
        Helper.CopyToClipboard(self.txt_ewm:getString())
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "复制成功")
    end
end
--是否可以复制
function M:onIsPaste()
    local isPaste = true
    if device.platform == "android" or device.platform == "ios" then
        if gg.GetNativeVersion() < 5 then
            isPaste = false
        else
            isPaste = true
        end
    else
        isPaste = false
    end
    return isPaste
end
function M:onClickFollowAward(sender)
    if self:onIsPaste() then
        --剪贴板的复制
        device.getPasteboardString(handler(self, self.getAward))
    else
        self.welfareFollowGet =  self:getScene():createView("welfare.welfareFollowGet")
        self.welfareFollowGet:pushInScene()
        self.welfareFollowGet:setCallback(handler(self, self.getAward))
    end
end

function M:getAward(copyInfo)
    if copyInfo and string.find(string.lower(copyInfo), "wlgzy") then

        local txt = self:getUrlFileName(copyInfo,"【", "】") or copyInfo
        local copyInfos = ((string.gsub(txt, "^%s*(.-)%s*$", "%1")))
        --关注领取的状态
        local callback = function(result)
            if tolua.isnull(self) then return end
            if not result then return end
            if result.status == 0 then
                gg.UserData:setGzylStatus()
                --福利界面数据更新的通知
                GameApp:dispatchEvent(gg.Event.WELFARE_ACTIVITY)
                if self.welfareFollowGet then
                    self.welfareFollowGet:onClickClose()
                end
                if #self._rewardTb > 0 then
                    GameApp:DoShell(nil, "GetRewardView://", self._rewardTb)
                else
                    GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "领取成功")
                end
                --按钮修改成已领取
                self:setBtnImg(self.btn_followAward, "hall/welfare/gzyl/img_yilingqu.png")
            end
        end
        gg.Dapi:TaskAward(98, copyInfos, 0, callback)
    else
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "兑换码无效，请重试！")
    end
end
function M:setBtnImg(btn, imgPath)
    btn:loadTextureNormal(imgPath, 1)
    btn:loadTexturePressed(imgPath, 1)
    btn:loadTextureDisabled(imgPath, 1)
    btn:setTouchEnabled(false)
end

--startString 开始字符截取 endString结束字符截取
function M:getUrlFileName(copyInfo, startString, endString)
    local bExist1, bExist2 = string.find(copyInfo, "【")
    if bExist1 == nil then return ; end
    local param1, param2 = string.find(copyInfo, "】")
    if param1 == nil then return ; end
    local difference = checkint(bExist2 - bExist1) + 1
    local result = string.sub(copyInfo, bExist1 + difference, param2 - difference )
    return result
end

function M:onClickClose()
    self:removeSelf()
end

return M
