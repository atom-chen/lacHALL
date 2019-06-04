--评价有礼

local M = class("WelfareEvaluateViewActive", cc.load("ViewPop"))
M.RESOURCE_FILENAME = "ui/welfare/welfareEvaluateActive.lua"
M.RESOURCE_BINDING =
{
    ["panel_bg"] = { ["varname"] = "panel_bg"},

    ["panel_awards"] = { ["varname"] = "panel_awards"},

    ["btn_assess"]  = {["varname"] = "btn_assess",  ["events"] = {{event = "click", method = "onClickAssess" }}},
    ["btn_close"]   = {["varname"] = "btn_close",   ["events"] = {{event = "click", method = "onClickClose" }}},
}
M.LAYER_ALPHA = 25

function M:onCreate()
    --适配
    self:resetLayout()
    --
    self:initDate()

    self:initView()

    -- 关注前后台切换的事件
    self:enableAppEvents()
end

function M:resetLayout()
    self:setScale(math.min(display.scaleX, display.scaleY))
end

function M:initDate()
    -- 道具
    self._propDef  = gg.GetPropList()

end

function M:initView()
    --是否已领取
    if gg.UserData:getPjylStatus() == 5 then
        --按钮修改成已领取
        self:setBtnImg(self.btn_assess, "hall/welfare/pjyl/img_pjyilingqu.png")
    end

end

function M:setAwardInfo(tab)
    --奖励数据
    local pos =
    {
        [1] = {330},
        [2] = {190, 484},
        [3] = {120, 330, 540},
    }
    local isFirst = true
    local itemNode = nil
    --

    local newTb = {}
    for k,v in ipairs (tab) do
        if isFirst then
            self:setNodeInfo(self.panel_awards, v)
            itemNode = self.panel_awards
            isFirst = false
        else
            itemNode = self.panel_awards:clone()
            self:setNodeInfo(itemNode, v)
            self.panel_bg:addChild(itemNode)
        end
        itemNode:setPosition(cc.p(pos[#tab][k] ,self.panel_awards:getPositionY()))

        table.insert(newTb, {v.propType, v.propCount})
    end

    self._rewardTb = newTb
    Log(self._rewardTb)
end

function M:setNodeInfo(node, tabInfo)
    local award_Icon  = node:findNode("img_awards")
    local award_Count = self.panel_awards:findNode("txt_count")
    if award_Count == nil and award_Icon == nil  then return ; end

    local name = self._propDef[tabInfo.propType].name
    if checkint(tabInfo.propType) == PROP_ID_MONEY then
        name = "微乐豆"
    end
    local unit = self._propDef[tabInfo.propType].unit and self._propDef[tabInfo.propType].unit or ""
    award_Count:setString(name..unit.."x"..tabInfo.propCount)

    local img_lipinprop = self._propDef[tabInfo.propType]
    award_Icon:loadTexture(img_lipinprop.icon)
    award_Icon:ignoreContentAdaptWithSize(true)
end

function M:onClickAssess()
    device.openAppDetailByMarket()
    -- 记录用户是否是跳转到应用商城
    self._doReqReward = true
end

--app 从后台进入前台，请求奖励
function M:onAppEnterForeground(difftime)
    if self._doReqReward then
        self._doReqReward = false
        -- 向web发送评价有礼兑换码验证
        self:sedWebEvaluateQequest()
    end
end

--向web发送评价有礼
function M:sedWebEvaluateQequest(copyInfo)
    local callback = function(result)
        if tolua.isnull(self) then return end
        if not result then return end
        if result.status == 0 then
            gg.UserData:setPjylStatus()
            --福利界面数据更新的通知
            GameApp:dispatchEvent(gg.Event.WELFARE_ACTIVITY)

            if self._rewardTb then
                GameApp:DoShell(nil, "GetRewardView://", self._rewardTb)
            else
                GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "领取成功")
            end
            --按钮修改成已领取
            self:setBtnImg(self.btn_assess, "hall/welfare/pjyl/img_pjyilingqu.png")
        end
    end
    gg.Dapi:TaskAward(99, "", 0, callback)
end

function M:setBtnImg(btn, imgPath)
    btn:loadTextureNormal(imgPath, 1)
    btn:loadTexturePressed(imgPath, 1)
    btn:loadTextureDisabled(imgPath, 1)
    btn:setTouchEnabled(false)
end

function M:onClickClose()
    self:removeSelf()
end

return M
