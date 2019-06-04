--电视赛排行界面
local MatchTvRank = class("MatchTvRank" , cc.load("ViewPop"))

MatchTvRank.RESOURCE_FILENAME = "ui/room/match/match_rank_view.lua"

MatchTvRank.RESOURCE_BINDING = {

    ["btn_close"]   = {["varname"] = "btn_close",   ["events"] = {{event = "click", method = "onClickClose" }}},
    ["panel_user"] = { ["varname"] = "panel_user" },                   --个人排行

    ["panel_award"] = { ["varname"] = "panel_award" },              --奖励显示

    ["txt_loding"] = { ["varname"] = "txt_loding" },
    ["txt_ns_txt"] = { ["varname"] = "txt_ns_txt" },

}

function MatchTvRank:onCreate()
    --自适应
    self:setScale(math.min(display.scaleX, display.scaleY))
    self:init()
end

function MatchTvRank:init()
    self.oneData = {}
    self.setTxt = true
    self.topListData = {}
    self._btnTb = {}
    self._tmpItem = self:findNode("item_rank")
    local posX = 350
    for i=1,3 do
        local btn = self:findNode("btn_" .. i)
        local txt = btn:getChildByName("txt_name")
        btn:setVisible(true)
        btn:setTag(i)
        btn:onClick(function()
            gg.AudioManager:playClickEffect()
            self:updateView(btn)
        end)
        table.insert(self._btnTb, btn)

        -- 初始化listview
        local lv = self:findNode("lv_rank_" .. i)
        lv:setVisible(false)
        lv:setBounceEnabled(true)
        lv:setContentSize(cc.size(526, 356))
        lv:setScrollBarEnabled(false)
        btn.childView = lv

        -- lv:onScroll(function(event)
        --     if event.name and event.name == "CONTAINER_MOVED" then
        --         self:setShowUser(event.target)
        --     end
        -- end)

        self:initRecordListView(lv)

        local btnW = math.max(txt:getContentSize().width + 40, 140)
        txt:setPositionX(btnW / 2)
        btn:getChildByName("img_sel"):setContentSize(cc.size(btnW, btn:getContentSize().height))
        btn:setContentSize(cc.size(btnW, btn:getContentSize().height))
        btn:setPositionX(posX + btnW / 2)
        posX = posX + btnW
    end
    self:updateView(self:findNode("btn_3"))
end
-- --设置个人排行的显示
-- function MatchTvRank:setShowUser(svtop)
--     --item 所在的位置
--     local curpos =   math.abs(math.floor(svtop:getInnerContainerPosition().y))
--     --item 容器的高度
--     local svheigt =  math.abs(math.floor(svtop:getInnerContainerSize().height))
--     --可视的排行高度
--     local sheight = svtop:getContentSize().height
--     -- 78 表示item 一个的高度
--     if svheigt - curpos >= svheigt  -70 then
--         self.panel_user:setVisible(false)  --
--     else
--         self.panel_user:setVisible(true)  --
--     end
-- end

function MatchTvRank:updateView(sender)
    for i,btn in ipairs(self._btnTb) do
        btn:setTouchEnabled(not (sender == btn))
        btn.childView:setVisible(sender == btn)
        btn:getChildByName("img_sel"):setVisible(sender == btn)
        local fontColor = gg.IIF(sender == btn, cc.c3b(34, 34, 34), cc.c3b(255, 255, 255))
        btn:getChildByName("txt_name"):setTextColor(fontColor)
    end

    self.txt_loding:setVisible(false)
  --  self:setAwardTop(sender:getTag())
    local region = tonumber(sender:getTag())
    -- 请求过数据不再请求
    if self["loaded" .. region] then
        if self.oneData[region] then
            self:oneTop(self.oneData[region])
        end
        if table.nums(self.topListData[region]) == 0 then
            self.txt_loding:setVisible(true)
        end
        return
    end

    gg.Dapi:getRankingList(region, function(result)
        result = checktable(result)
        if result.status and checkint(result.status) == 0 then
            if tolua.isnull(self) then return end
            local data = checktable(result).data
            if data then
                self.oneData[region] = data.own
                self.topListData[region] = data.list
                if table.nums(data.list) == 0 then
                    self.txt_loding:setVisible(true)
                end
                if self.setTxt then
                    self.setTxt = false
                    self.txt_ns_txt:setString( string.format( "每天发放%d张电视台录制\n劵，排行靠前者优先获得\n，每人最多拥有一张。已\n拥有的玩家，奖励顺延至\n排名下一位的玩家。",data.count or 3))
                end
                self:oneTop(data.own)
                sender.childView:reloadData(data.list)
                self["loaded" .. region] = true
            else
                GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "数据获取失败")
            end
        else
            GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "数据获取失败")
        end
    end)
end

function MatchTvRank:oneTop(data)
    if not data then return end
    local txt_rank = self.panel_user:getChildByName("txt_rank")
    if checkint(data.rank) == -1  then
        txt_rank:setString("未上榜")
    else
        txt_rank:setString(string.format( "第%s名" ,data.rank ))
    end

    --头像
    local img_avatar = self.panel_user:getChildByName("img_avatar")
    self:initHead(img_avatar)
    --头像
    local avatarPath = gg.IIF(data.sex == 1,"common/hd_male.png","common/hd_female.png")
    local avatarurl = data.avatarurl
    if avatarurl and string.len(avatarurl) > 0 then
        -- 自定义头像
        gg.ImageDownload:LoadUserAvaterImage({url = avatarurl, ismine = true, image = self._imgAvatar}, function()
                -- 84 图片的宽度
                self._imgAvatar:setScale(84 / self._imgAvatar:getContentSize().width)
            end)
    else
        self._imgAvatar:loadTexture(avatarPath)
        self._imgAvatar:setScale(84 / self._imgAvatar:getContentSize().width)
    end

    --用户昵称
    local strNick = gg.SubUTF8StringByWidth(data.nickname, 160, 24, "")
    local txt_nick = self.panel_user:getChildByName("txt_nick")
    txt_nick:setString(strNick)

    --分数
    local txt_rankcount = self.panel_user:getChildByName("txt_rankcount")
    txt_rankcount:setString(string.format( "%s分" ,checkint(data.score)  ) )

end
--设置排行奖励
-- function MatchTvRank:setAwardTop(tag)
--     --标题
--     local txt_titleAward = self.panel_award:getChildByName("txt_titleAward")  --奖励说明
--     local img_jx1 = self.panel_award:getChildByName("img_jx1")  --左边箭头
--     local img_jx2 = self.panel_award:getChildByName("img_jx2")  --右边箭头

--     local panel_tv = self.panel_award:getChildByName("panel_tv")  --电视奖励容器
--     local img_tv = panel_tv:getChildByName("img_tv")  --前三奖励图片
--     local txt_tv = panel_tv:getChildByName("txt_tv")  --前三描述
--     local txt_ns_txt = panel_tv:getChildByName("txt_ns_txt")

--     local panel_ticket = self.panel_award:getChildByName("panel_ticket")  --门票容器
--     local img_ticket = panel_ticket:getChildByName("img_ticket")  --门票图片
--     local txt_ticket = panel_ticket:getChildByName("txt_ticket") --描述
--     txt_ns_txt:setVisible(false)
--     if tag == 3 then
--         panel_ticket:setVisible(false)
--         txt_tv:setString("电视台邀请资格")
--         txt_titleAward:setString("电视海选赛")
--         panel_tv:setPositionY(panel_tv:getPositionY() - 60)
--         txt_ns_txt:setVisible(true)
--     else
--         panel_tv:setPositionY(227)
--         panel_ticket:setVisible(true)
--         if tag == 1 then
--             img_ticket:loadTexture("hall/room/match/match_rank/img_ticket1.png",0)
--             txt_ticket:setString("月赛门票x1")
--             txt_titleAward:setString("周榜前三奖励")
--         else
--             img_ticket:loadTexture("hall/room/match/match_rank/img_ticket.png",0)
--             txt_ticket:setString("年赛门票x1")
--             txt_titleAward:setString("月榜前三奖励")
--         end
--     end
--     img_jx1:setPositionX(txt_titleAward:getPositionX()- txt_titleAward:getSize().width /2 -15)
--     img_jx2:setPositionX(txt_titleAward:getPositionX()+ txt_titleAward:getSize().width /2 +15)
-- end
function MatchTvRank:createItem()
    local item = self._tmpItem:clone()
    item:setVisible(true)
    item:setPositionX(0)
    item:setPositionY(0)
    return item
end

function MatchTvRank:initRecordListView(listview)
    local tbView = require("src.common.TableViewEx").new(listview)
    tbView._createItemFunc = function() return self:createItem() end
    tbView._updateItemFunc = function(...) return self:updateItem(...) end
    tbView._cellSize = self:findNode("item_rank"):getContentSize()
    tbView._cpr = 1
    tbView._needRecreate = true
    tbView:setMargin(6)
    tbView:init()
end
--更新排行
function MatchTvRank:updateItem(item, data, idx)

     --设置排行
     local img_rank = item:getChildByName("img_rank") --图片
     local txt_rank = item:getChildByName("txt_rank") --文字
     if idx > 3 then
        img_rank:setVisible(false)
        txt_rank:setVisible(true)
        txt_rank:setString(idx)
     else
        img_rank:loadTexture(string.format("hall/honor/rank_%d.png", idx), 1)
        img_rank:setVisible(true)
        txt_rank:setVisible(false)
     end

    local img_avatar = item:getChildByName("img_avatar")
    self:initHead(img_avatar)

    --头像
    local avatarPath = gg.IIF(data.sex == 1,"common/hd_male.png","common/hd_female.png")
    local avatarurl = data.avatarurl
    if avatarurl and string.len(avatarurl) > 0 then
        -- 自定义头像
        gg.ImageDownload:LoadUserAvaterImage({url = avatarurl, ismine = true, image = self._imgAvatar}, function()
            if tolua.isnull(self) then return end        
            -- 84 图片的宽度
            self._imgAvatar:setScale(84 / self._imgAvatar:getContentSize().width)
        end)
    else
        self._imgAvatar:loadTexture(avatarPath)
        self._imgAvatar:setScale(84 / self._imgAvatar:getContentSize().width)
    end

    --用户昵称
    local strNick = gg.SubUTF8StringByWidth(data.nickname, 160, 24, "")
    local txt_nick = item:getChildByName("txt_nick")
    txt_nick:setString(strNick)

    --分数
    local txt_rankcount = item:getChildByName("txt_rankcount")
    txt_rankcount:setString(string.format( "%s分" ,checkint(data.score)  ) )

end


function MatchTvRank:initHead(nodehead)
    if not nodehead then return end
    -- 创建头像
    local clipNode = cc.ClippingNode:create(cc.Sprite:createWithSpriteFrameName("hall/common/bk_head_ico.png"))
    self._imgAvatar = ccui.ImageView:create("")
    clipNode:addChild(self._imgAvatar)
    clipNode:setAlphaThreshold(0)
    clipNode:setPosition(nodehead:getContentSize().width / 2, nodehead:getContentSize().height / 2)
    clipNode:setScale(0.7)
    nodehead:addChild(clipNode)

    -- 添加头像边框
    local avatarFram = ccui.ImageView:create()
    avatarFram:loadTexture("hall/common/player_head_bg.png",0)
    avatarFram:setPosition(nodehead:getContentSize().width / 2 , nodehead:getContentSize().height / 2)

end


function MatchTvRank:onClickClose()
    self:removeSelf()
end
return MatchTvRank