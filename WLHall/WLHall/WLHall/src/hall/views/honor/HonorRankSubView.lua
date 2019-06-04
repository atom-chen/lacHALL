--
-- Author: Cai
-- Date: 2017-03-24
-- Describe：荣誉排行界面

local M = class("HonorRankSubView", cc.load("ViewBase"))

M.RESOURCE_FILENAME = "ui/honor/honor_rank_view.lua"
M.RESOURCE_BINDING = {

}

function M:onCreate(uRank)
    self._uRank = checktable(uRank)
    self._btnTb = {}
    self._tmpItem = self:findNode("item_user")
    local heigt = 574
    --荣誉关闭显示时高度缩小
    if GameApp:CheckModuleEnable(ModuleTag.HonorGift) then
        heigt = 486
    end
    for i=1,3 do
        local btn = self:findNode("btn_" .. i)
        btn:setVisible(false)

        local lv = self:findNode("lv_rank_" .. i)
        lv:setVisible(false)
        lv:setBounceEnabled(true)
        lv:setContentSize(cc.size(1028, heigt))
        lv:setScrollBarEnabled(false)
        btn.childView = lv
    end

    local posX = 0
    for i,v in ipairs(checktable(uRank)) do
        local btn = self:findNode("btn_" .. i)
        local txt = btn:getChildByName("txt_name")
        btn:setVisible(true)
        txt:setString(v.name)
        btn:setTag(v.code)
        btn:onClick(function()
            gg.AudioManager:playClickEffect()
            self:updateView(btn)
        end)
        table.insert(self._btnTb, btn)

        -- 初始化listview
        local lv = self:findNode("lv_rank_" .. i)
        self:initRecordListView(lv)

        local btnW = math.max(txt:getContentSize().width + 40, 120)
        txt:setPositionX(btnW / 2)
        btn:getChildByName("img_sel"):setContentSize(cc.size(btnW, btn:getContentSize().height))
        btn:setContentSize(cc.size(btnW, btn:getContentSize().height))
        btn:setPositionX(posX + btnW / 2)
        posX = posX + btnW
    end
end

function M:onEnter()
    self:updateView(self:findNode("btn_1"))
end

function M:updateView(sender)
    for i,btn in ipairs(self._btnTb) do
        btn:setTouchEnabled(not (sender == btn))
        btn.childView:setVisible(sender == btn)
        btn:getChildByName("img_sel"):setVisible(sender == btn)
        local fontColor = gg.IIF(sender == btn, cc.c3b(49, 94, 167), cc.c3b(255, 255, 255))
        btn:getChildByName("txt_name"):setTextColor(fontColor)
    end

    local region = tonumber(sender:getTag())
    -- 请求过数据不再请求
    if self["loaded" .. region] then return end
    gg.HonorHelper:getRankListByRegion(sender:getTag(), function(data, errMsg)
        if tolua.isnull(self) then return end
        if errMsg then
            GameApp:dispatchEvent(gg.Event.SHOW_TOAST, errMsg)
        else
            data = self:insertUserData(clone(data), region)
            sender.childView:reloadData(data)
            self["loaded" .. region] = true
        end
    end)
end

-- 将玩家自身的数据转换格式插入到排行榜数据中
function M:insertUserData(data, region)
    local userinfo = {}
    if hallmanager and hallmanager:IsConnected() then
        userinfo = hallmanager.userinfo or {}
    end

    for _,v in pairs(self._uRank) do
        if tonumber(v.code) == region then
            local tb = {}
            tb.nickname = userinfo.nick
            tb.userid = userinfo.id
            tb.honor = hallmanager:GetHonorValue()
            tb.avatarurl = userinfo.avatarurl
            tb.sex = userinfo.sex
            tb.rank = tonumber(v.rank)
            tb.is_light = v.is_light
            tb.fabulous = v.fabulous
            table.insert(data, 1, tb)
        end
    end

    return data
end

function M:initRecordListView(listview)
    local tbView = require("src.common.TableViewEx").new(listview)
    tbView._createItemFunc = function() return self:createItem() end
    tbView._updateItemFunc = function(...) return self:updateItem(...) end
    tbView._cellSize = self:findNode("item_user"):getContentSize()
    tbView._cpr = 1
    tbView._needRecreate = true
    tbView:setMargin(0)
    tbView:init()
end

function M:createItem()
    local item = self._tmpItem:clone()
    item:setVisible(true)
    item:setPositionX(0)
    item:setPositionY(0)
    return item
end

function M:updateItem(item, data, idx)
    item.data = data

    local bgColor = gg.IIF(idx % 2 == 0, cc.c3b(240,240,240), cc.c3b(255,255,255))
    item:setBackGroundColor(bgColor)
    -- 排名
    local img_rank = item:getChildByName("img_rank")
    local txt_rank = item:getChildByName("txt_rank")
    local txt_wsb = item:getChildByName("txt_wsb")
    data.rank = checkint(data.rank)
    data.honor = checkint(data.honor)
    img_rank:setVisible(data.rank <= 3 and data.rank > 0)
    txt_rank:setVisible(data.rank > 3)
    if data.rank <= 0 then
        txt_wsb:setVisible(true)
    elseif data.rank <= 3 then
        img_rank:loadTexture(string.format("hall/honor/rank_%d.png", data.rank), 1)
    else
        txt_rank:setString(tostring(data.rank))
    end
    -- 我的排名
    if idx == 1 then
        item:getChildByName("txt_wdpm"):setVisible(true)
        txt_rank:setPositionY(txt_rank:getPositionY() - 8)
        txt_wsb:setPositionY(txt_wsb:getPositionY() - 3)
    end
    -- 头像
    local img_avatar = item:getChildByName("img_avatar")
    local avatarPath = gg.IIF(data.sex == 1, "common/hd_male.png", "common/hd_female.png")
    if data.avatarurl and data.avatarurl ~= "" then
        local ismine = idx == 1
        gg.ImageDownload:LoadUserAvaterImage({url = data.avatarurl, ismine = ismine, image = img_avatar})
    else
        img_avatar:loadTexture(avatarPath)
    end
    -- 昵称
    local txt_nick = item:getChildByName("txt_nick")
    txt_nick:setString(tostring(data.nickname))
    if txt_nick:getContentSize().width > 120 then
        local strNick = gg.SubUTF8StringByWidth(tostring(data.nickname), 120, 24, "")
        txt_nick:setString(strNick)
    end
    -- 荣誉值
    item:getChildByName("txt_hexp"):setString(String:numToZn(data.honor, 4, 2))

    local Panel_16 = item:getChildByName("Panel_16")
    local nd_honor = item:getChildByName("nd_honor")
    -- 段位logo
    local grade, star = gg.GetHonorGradeAndLevel(tonumber(data.honor))
    local img_cup = nd_honor:getChildByName("img_1")
    img_cup:ignoreContentAdaptWithSize(true)
    img_cup:loadTexture(string.format("hall/honor/grade_img_%d.png", grade), 1)
    img_cup:setScale(56 / img_cup:getContentSize().height)

    -- 初始星星数显示
    for i = 1 ,5 do
        nd_honor:findNode("star_" .. i):setPercent(0)
    end
    -- 设置星星数显示
    for i=1,star do
        nd_honor:findNode("star_" .. i):setPercent(100)
    end
    if star < 5 then
        local lv, minExp, nextExp= gg.GetHonorLevel(data.honor)
        local percent = (data.honor - minExp) / (nextExp - minExp) * 100
        nd_honor:findNode("star_" .. star + 1):setPercent(percent)
    end

   -- local grade, star = gg.GetHonorGradeAndLevel(hlvExp)


    --item:getChildByName("img_grade"):loadTexture("hall/honor/grade_img_" .. grade .. ".png", 1)
    -- 点赞数
    local txt_zan = item:getChildByName("txt_zan")
    txt_zan:setString(string.format("共%d赞", tonumber(data.fabulous)))
    -- 点赞
    local btn_zan = item:findNode("btn_zan")
    btn_zan:setBright(tonumber(data.is_light) == 1)
    btn_zan:onClickScaleEffect(function()
        gg.AudioManager:playClickEffect()
        self:onClickZan(btn_zan, data)
    end)
end

function M:onClickZan(btn, data)
    local state = not btn:isBright()
    local is_light = state and 1 or 0
    local fabulous = gg.IIF(state, tonumber(data.fabulous) + 1, tonumber(data.fabulous) - 1)

    local function callback(cb)
        if cb.status and checkint(cb.status) == 0 then
            -- 更新缓存数据中的赞
            gg.HonorHelper:updateZan(data.userid, is_light, fabulous)
            -- 刷新item的数据
            for i=1,3 do
                local lv = self:findNode("lv_rank_" .. i)
                if lv.mDataList then
                    for i,v in ipairs(lv.mDataList) do
                        if tonumber(v.userid) == tonumber(data.userid) then
                            v.fabulous = fabulous
                            v.is_light = is_light
                        end
                    end
                end

                for _,nd in pairs(lv:getItems()) do
                    local item = nd:getChildren()[1]
                    if item and item.data and tonumber(item.data.userid) == tonumber(data.userid) then
                        item:getChildByName("txt_zan"):setString(string.format("共%d赞", fabulous))
                        item:findNode("btn_zan"):setBright(state)
                    end
                end
            end

            if state then
                GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "点赞成功！")
            else
                GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "取消点赞！")
            end
        else
            GameApp:dispatchEvent(gg.Event.SHOW_TOAST, cb.msg or "网络错误，请重试！")
        end
    end
    gg.Dapi:HonorLight(data.userid, callback)
end

return M