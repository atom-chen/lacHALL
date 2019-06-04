local PopRankBonusPool = class("PopRankBonusPool", cc.load("ViewPop"))

PopRankBonusPool.RESOURCE_FILENAME = "ui/active/bonus_pool/pop_rank.lua"

PopRankBonusPool.RESOURCE_BINDING =
{
    ["btn_close"] = { ["varname"] = "btn_close", ["events"] = { { ["event"] = "click", ["method"] = "onClickClose" } } },
    ["btn_update"] = { ["varname"] = "btn_update", ["events"] = { { ["event"] = "click", ["method"] = "onClickPassRank" } } },
    ["bg_panel"] = { ["varname"] = "bg_panel" },
    ["img_rank"] = { ["varname"] = "img_rank" },
    ["txt_rank"] = { ["varname"] = "txt_rank" },
    ["node_list"] = { ["varname"] = "node_list" },
    ["list_rank"] = { ["varname"] = "list_rank" },
    ["item_model"] = { ["varname"] = "item_model" },
    ["node_time"] = { ["varname"] = "node_time" },
    ["txt_time"] = { ["varname"] = "txt_time" },
}

-- 各个名次的奖励信息
local RANK_BONUS_INFO = {
    {min=1, max=1, bonus="12%"},
    {min=2, max=2, bonus="8%"},
    {min=3, max=3, bonus="6%"},
    {min=4, max=4, bonus="5%"},
    {min=5, max=5, bonus="4.5%"},
    {min=6, max=6, bonus="4%"},
    {min=7, max=7, bonus="3.5%"},
    {min=8, max=8, bonus="3%"},
    {min=9, max=9, bonus="2.5%"},
    {min=10, max=10, bonus="2%"},
    {min=11, max=15, bonus="1.6%"},
    {min=16, max=25, bonus="1.2%"},
    {min=26, max=35, bonus="0.8%"},
    {min=36, max=45, bonus="0.6%"},
    {min=46, max=55, bonus="0.5%"},
    {min=56, max=65, bonus="0.4%"},
    {min=66, max=75, bonus="0.3%"},
    {min=76, max=85, bonus="0.2%"},
    {min=86, max=100, bonus="0.1%"},
}

function PopRankBonusPool:onCreate( parentTag )
    self.parentTag = parentTag
    self:setScale(math.min(display.scaleX, display.scaleY))
    self:init()
    self:initRankList(cc.size(self.listWidth, self.listHeight))
    self:requestRankList()
end

function PopRankBonusPool:init()
    self.isPassRank = false
    self.listWidth = 799
    self.listHeight = 290
    self.cellHeight =  72

    -- 用于存储子界面
    self._subViewsTb = {}
    -- 隐藏滚动条
    self.list_rank:setScrollBarEnabled( false )

    self._richTxtRecharge = self:createRichTxt(cc.p(self.bg_panel:getContentSize().width / 2, 525))
    self._richTxtRank = self:createRichTxt(cc.p(self.bg_panel:getContentSize().width / 2, 467))
end

function PopRankBonusPool:requestRankList( ... )
    gg.Dapi:BonusPoolRankInfoList(self.parentTag,function(cb)
        if tolua.isnull(self) then return end
        cb = checktable(cb)
        if not cb.status or checkint(cb.status) ~= 0 or not cb.data then
            GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "网络错误，请关闭界面重试！")
            return
        end
        self.isPassRank = false

        local userData = checktable(checktable(cb.data).user)
        -- 设置今日充值金额
        local rechargeStr = string.format("<div>今日充值金额:.<div fontcolor=#E24500 fontsize=36>%d</div>.<div fontcolor=#E24500>元</div></div>", checkint(userData.totalMoney))
        self:setRichTxtRechargeStr(rechargeStr)
        -- 设置我的排名
        local rankStr = ""
        if checkint(userData.sor) <= 0 then
            rankStr = string.format("<div>我的排名:.<div fontcolor=#C71700 fontsize=50>暂无排名</div>.距离上一名还差.<div fontcolor=#C71700 fontsize=50>%d</div>.元</div>", math.max(checkint(userData.disparity), 1))
        elseif checkint(userData.sor) == 1 then
            -- 第一名，只显示排名就好了
            rankStr = string.format("<div>我的排名:.<div fontcolor=#C71700 fontsize=50>第.%d.名</div></div>", checkint(userData.sor))
        else
            rankStr = string.format("<div>我的排名:.<div fontcolor=#C71700 fontsize=50>第.%d.名</div>.距离上一名还差.<div fontcolor=#C71700 fontsize=54>%d</div>.元</div>", checkint(userData.sor), math.max(checkint(userData.disparity), 1))
        end
        self:setRichTxtRankStr(rankStr)

        self._rankInfoList = checktable(cb.data.rank).list
        self[ "subV_"..self.listHeight]:reloadData()

        local ts = checktable(cb.data.rank).UpdateTime
        if ts then
            self.txt_time:setString(os.date("当前排名时间：%H:%M", ts))
        end
    end)
end

function PopRankBonusPool:requestPastRankList( ... )
    gg.Dapi:BonusPoolPastRankInfoList(self.parentTag,function(cb)
        if tolua.isnull(self) then return end
        cb = checktable(cb)
        if not cb.status or checkint(cb.status) ~= 0 then
            GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "网络错误，请关闭界面重试！")
            return
        end
        self.isPassRank = true
        self._rankInfoList = cb.data
        self[ "subV_"..(self.listHeight + self.cellHeight)]:reloadData()
    end)
end

function PopRankBonusPool:onClickPassRank()
    if self.isPassRank == false then
      self.img_rank:setColor(cc.c3b(242,79,1))
      self.txt_rank:setString("当\n前\n排\n行")
      self.bg_panel:setVisible(false)
      self.node_time:setVisible(false)
      self.node_list:setPositionY(70)
      -- 设置listView大小
      self.list_rank:setContentSize(cc.size(self.listWidth, 345 + self.cellHeight))
      self.list_rank:setPositionY(-68 - self.cellHeight/2)

      self:initRankList(cc.size(self.listWidth,self.listHeight + self.cellHeight))
      self:requestPastRankList()
    else
      self.img_rank:setColor(cc.c3b(0,138,255))
      self.txt_rank:setString("往\n期\n回\n顾")
      self.bg_panel:setVisible(true)
      self.node_time:setVisible(true)
      self.node_list:setPositionY(0)
      -- 设置listView大小
      self.list_rank:setContentSize(cc.size(self.listWidth, 345))
      self.list_rank:setPositionY(-68)

      self:initRankList(cc.size(self.listWidth, self.listHeight))
      self:requestRankList()
    end
end

-- 根据TableView高度创建一个tableview
function PopRankBonusPool:initRankList( size )
    self.item_model:setVisible(false)
    if not self[ "subV_"..size.height ] then
      local tableView = cc.TableView:create(size)
      tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
      tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN);
      tableView:setPosition(cc.p(-399.50, 50 - size.height))
      tableView:setDelegate()

      tableView:registerScriptHandler( function(view, idx) return self:onCellSizeForTable(view, idx); end, cc.TABLECELL_SIZE_FOR_INDEX);
      tableView:registerScriptHandler( function(view, idx) return self:OnCellAtIndex(view, idx); end, cc.TABLECELL_SIZE_AT_INDEX);
      tableView:registerScriptHandler( function(view, cell) return self:OnCellTouched(view, cell); end, cc.TABLECELL_TOUCHED);
      tableView:registerScriptHandler( function(view) return self:OnNumberOfCellsInTableView(view); end, cc.NUMBER_OF_CELLS_IN_TABLEVIEW);
      self._tableView = tableView
      self[ "subV_"..size.height ] = tableView
      self.node_list:addChild(tableView)
      table.insert( self._subViewsTb, self[ "subV_"..size.height ] )
    end

    -- 显示,隐藏其他子界面
    for i,v in ipairs(self._subViewsTb) do
        v:setVisible(v == self["subV_"..size.height])
    end
end

function PopRankBonusPool:onCellSizeForTable(view, idx)
    return self.listWidth, self.cellHeight
end

function PopRankBonusPool:OnCellAtIndex(view, idx)
    local cell = view:cellAtIndex(idx)
    local icon, labRank, labUserId, labUserName, labMoney, labPercent
    if nil == cell then
        cell = cc.TableViewCell:create()
        icon = self.item_model:getChildByName("image_item_icon"):clone()
        labRank = self.item_model:getChildByName("text_item_rank"):clone()
        labUserId = self.item_model:getChildByName("text_item_id"):clone()
        labUserName = self.item_model:getChildByName("text_item_name"):clone()
        labMoney = self.item_model:getChildByName("text_item_coin"):clone()
        labPercent = self.item_model:getChildByName("text_item_percent"):clone()
        cell:addChild(icon)
        cell:addChild(labRank)
        cell:addChild(labUserId)
        cell:addChild(labUserName)
        cell:addChild(labMoney)
        cell:addChild(labPercent)
    else
        icon = cell:getChildByName("image_item_icon")
        labRank = cell:getChildByName("text_item_rank")
        labUserId = cell:getChildByName("text_item_id")
        labUserName = cell:getChildByName("text_item_name")
        labMoney = cell:getChildByName("text_item_coin")
        labPercent = cell:getChildByName("text_item_percent")
        icon:setVisible(true)
    end
    if idx == 0 then
        icon:loadTexture("hall/active/bonuspool/fight/gold_cup.png",1)
    elseif idx == 1 then
        icon:loadTexture("hall/active/bonuspool/fight/silver_cup.png",1)
    elseif idx == 2 then
        icon:loadTexture("hall/active/bonuspool/fight/copper_cup.png",1)
    else
        icon:setVisible(false)
    end

    local data = self._rankInfoList[idx + 1]
    local strName = gg.SubUTF8StringByWidth(tostring(data.nickname), 140, 20, "" )
    labRank:setString(""..idx+1)
    labUserId:setString(""..data.userid)
    labUserName:setString(""..strName)
    labMoney:setString(""..data.money)
    if self.isPassRank == false then
      labPercent:setString(self:getBonusPoolPercentByRank(idx+1))
    else
      labPercent:setString(""..data.exchange)
    end
    return cell
end

function PopRankBonusPool:getBonusPoolPercentByRank(rank)
    for i, v in ipairs(RANK_BONUS_INFO) do
        if rank >= v.min and rank <= v.max then
            return v.bonus
        end
    end

    return ""
end

function PopRankBonusPool:OnCellTouched(view, idx)

end

function PopRankBonusPool:OnNumberOfCellsInTableView(view, idx)
  if self._rankInfoList ~= nil then
    return #self._rankInfoList
  end
end

function PopRankBonusPool:onClickClose( ... )
    self:removeSelf()
end

-- 创建富文本
function PopRankBonusPool:createRichTxt(pos)
    local richTxt = RichLabel.new {
        fontSize = 26,
        fontColor = cc.c3b(115, 60, 0),
    }
    richTxt:setAnchorPoint(cc.p(0.5, 0.5))
    richTxt:setPosition(pos)
    self.bg_panel:addChild(richTxt)
    return richTxt
end

-- 设置富文本相关数据
function PopRankBonusPool:setRichTxtRechargeStr(str)
    if not self._richTxtRecharge then return end
    self._richTxtRecharge:setString(str)
    self._richTxtRecharge:walkElements(function(node, index)
        if not node then return end
        local ndstr = node:getString()
        -- 富文本空格无效，故这里使用“.”作为占位符顶替空格的作用
        if ndstr == "." then
            node:setVisible(false)
        end
    end)
end

function PopRankBonusPool:setRichTxtRankStr(str)
    if not self._richTxtRank then return end
    self._richTxtRank:setString(str)
    -- 由于排名设置的字体太大了，需要重新布局，否则文字会重叠
    self._richTxtRank:layout()
    -- 富文本空格无效，故这里使用“.”作为占位符顶替空格的作用
    self._richTxtRank:walkElements(function(node, index)
        if not node then return end
        local ndstr = node:getString()
        if ndstr == "." then
            node:setVisible(false)
        end
    end)
end

return PopRankBonusPool
