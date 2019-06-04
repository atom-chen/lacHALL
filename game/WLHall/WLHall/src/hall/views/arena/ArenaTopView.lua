-- Author: 李阿城
-- Date: 2018/3/17
-- Describe：每日 周擂台赛界面

local ArenaTopView = class("ArenaTopView",cc.load("ViewBase"))

ArenaTopView.RESOURCE_FILENAME = "ui/arena/arena_topview.lua"

ArenaTopView.RESOURCE_BINDING = {
    ["panel_arena"] = { ["varname"] = "panel_arena" },

    ["lv_top"] = { ["varname"] = "lv_top" }, -- 排行容器
    ["txt_top"] = { ["varname"] = "txt_top" }, -- 我的排行
    ["txt_score"] = { ["varname"] = "txt_score" }, -- 积分

    ["btn_rule"]  = {["varname"] = "btn_rule",["events"]={{["event"] = "click",["method"]="onClickRule"}} },    -- 规则按钮
     ["btn_close"]  = {["varname"] = "btn_close",["events"]={{["event"] = "click",["method"]="onClickclose"}} },    -- 关闭界面按钮
    ["btn_top"]  = {["varname"] = "btn_top",["events"]={{["event"] = "click",["method"]="onClickTop"}} },    -- 排行按钮
    ["txt_honor"] = { ["varname"] = "txt_honor" }, -- 积分


    ["img_titie"] = { ["varname"] = "img_titie" },--擂台标题
    ["txt_time"] = { ["varname"] = "txt_time" },


    ["img_arena_type"] = { ["varname"] = "img_arena_type" },--擂台赛奖杯图片


}
--[[
* @data 按钮数据 1是每日擂台赛 ，2 是周擂台赛
* @ callBack 关闭按钮回调
* @brief roomList 更新列表信息
]]
function ArenaTopView:onCreate(data,callBack)

    self.curBtn = data   --用于判断点击的按钮是日擂台还是周末擂台

    -- 道具
     self._propDef  = gg.GetPropList()

    --初始化
     self:init()

     -- 回调函数
     self._callBack = callBack

end
--初始化
function ArenaTopView:init()

    -- 隐藏滚动条
    self.lv_top:setScrollBarEnabled(false)
    --擂台排行数据
    self.ArenaData = {}

end
--更新视图
function ArenaTopView:updataView()
    -- 清除页面
    self.lv_top:removeAllChildren()
    self:updataTitle()
    self:pullAward()
end
--更新标题
function ArenaTopView:updataTitle()
    if self.curBtn == 1 then
        self.txt_honor:setString("本日获得的积分进行排行，前500名获奖")
        self.img_titie:loadTexture("hall/arena/img_day_arena.png",1 )
        self.txt_time:setString("本日积分:")
        --擂台赛类型图片
        self.img_arena_type:loadTexture("hall/arena/img_day.png",1)
    else
        self.txt_honor:setString("本周获得的积分进行排行，前500名获奖")
        self.img_titie:loadTexture("hall/arena/img_week_arena.png",1 )
        self.txt_time:setString("本周积分:")
        --擂台赛类型图片
        self.img_arena_type:loadTexture("hall/arena/img_week.png",1)

    end
end
--更新榜单
function ArenaTopView:initArenaAwardView(data)
    if not data then
        return
    end
    self.lv_top:setInnerContainerSize( {width = 260 *#data, height = 340} )
    for i = 1, #data do
        local data = data[i]

        local propNode = require( "ui.arena.arena_item.lua").create()

        local root = propNode.root
        --点击item不能翻页的解决方法
        local item_rank = root:getChildByName("item_rank")
        root:removeChild(item_rank)
        local item = ccui.Layout:create()
        item:addChild(item_rank)

        --背景点击显示排行
        item_rank:onClickScaleEffect( function( )
            --排行数据,最大数据

            self:onClicktops(checkint(data.prize_num))
        end )

        local img_bg = item_rank:getChildByName("img_bg")  --背景图片
        local img_ranking = item_rank:getChildByName("img_ranking")  --前3名排行的图片
        local txt_ranking = item_rank:getChildByName("txt_ranking")  --后面排行的描述
        local txt_score = item_rank:getChildByName("txt_score")   --积分
       -- checkint()
        txt_score:setString(checkint(data.prize_master_score))
        if i <= 3 then
            img_bg:loadTexture("hall/arena/img_top"..i..".png",0)

            img_ranking:loadTexture("hall/arena/top"..i..".png",1)

        else
            img_bg:loadTexture("hall/arena/img_top4.png",0)

            img_ranking:setVisible(false)
            txt_ranking:setString(data.title)
            txt_ranking:setVisible(true)
        end

        for propid,value in pairs(data.dataid) do
            -- 道具id
            local propid = propid
            -- 道具数量
            local propCount = value
            local lv_award = item_rank:getChildByName("award1")  --奖励图片
            local img_award = lv_award:getChildByName("img_1")  --奖励图片

            local txt_money = lv_award:getChildByName("txt_money1")  --数量
            local txt_name = lv_award:getChildByName("txt_name1")  --名称
            lv_award:setVisible(true)
            --设置奖励图片
            if propid == PROP_ID_LOTTERY then -- 礼品劵
                img_award:loadTexture("hall/arena/award1.png",0)
            elseif propid == PROP_ID_MONEY then -- 豆豆
                img_award:loadTexture("hall/arena/award2.png",0)
            end

            --获取名字
            local name = self._propDef[propid].name or ""
            txt_name:setString(name)

            local countStr = checkint(propCount)* ( self._propDef[propid].proportion or 1 )
            local strtxt = 0
            if propid == PROP_ID_261 or propid == PROP_ID_PHONE_CARD then
                countStr = string.format( "%.2f", countStr)
                strtxt = string.format("x%s",countStr)
            else
                strtxt = string.format("x%s", gg.MoneyUnit(countStr))
            end
            -- 奖励内容
            txt_money:setString(strtxt)

            --位置奖励的位置
            txt_name:setPositionX(lv_award:getContentSize().width/2  - txt_money:getSize().width/2-5)
            txt_money:setPositionX(txt_name:getPositionX()+txt_name:getContentSize().width/2 + 5)
        end

        item:setPosition(260*(i-1),0)
        self.lv_top:addChild(item)
    end
end

--获取初始化消息
function ArenaTopView:pullAward()
    --没有数据需要拉取
    if self:isNeedPullData(self.ArenaData[self.curBtn]) then
        gg.Dapi:Rank2prize(self.curBtn, function(data)  --curbtn 1 为 日擂台 ， 2为周擂台
            if tolua.isnull(self) then return end
            local data =  checktable(data).data
            if not data then
                --显示默认图片
                GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "数据获取失败")
                --设置排行按钮不可点击
                self.btn_top:setTouchEnabled(false)
                return
            end
            if not self.ArenaData[self.curBtn] then
                self.ArenaData[self.curBtn] ={}
            end

            self.ArenaData[self.curBtn].awarddata = data.prizes
            self.ArenaData[self.curBtn].selfdata = data.active_num
            self.ArenaData[self.curBtn].btndata = data.timeBtn
            self:initArenaAwardView(self.ArenaData[self.curBtn].awarddata) --更新奖励界面
            self:selfArena( self.ArenaData[self.curBtn].selfdata)           --更新个人擂台
        end)
    else
        self:initArenaAwardView(self.ArenaData[self.curBtn].awarddata) --更新奖励界面
        self:selfArena(self.ArenaData[self.curBtn].selfdata )           --更新个人擂台
    end
end

--[[
* @brief 判断是否要拉取数据
]]
function ArenaTopView:isNeedPullData(data)
    if not data then
        -- 没有数据，需要拉取
        return true
    end
    --获取当前的时间
    local currentTimeStampOfDayStart = socket.gettime()
    --保存当前时间
    data.curtime = currentTimeStampOfDayStart

    if currentTimeStampOfDayStart -  data.curtime  <= 3600 then
        -- 数据时间戳是小于 10分钟内的，不用重新拉取
        return false
    end
    -- 其他情况都需要重新拉取
    return true
 end


--个人擂台消息
function ArenaTopView:selfArena(data)
    if not data then return end

    self.txt_top:setString( data.self_rank or "未入榜")
    self.txt_score:setString(checkint(data.self_score ))
end

--规则点击
function ArenaTopView:onClickRule(sender)
    -- 播放点击音效
    gg.AudioManager:playClickEffect()
    self:getScene():createView("arena.ArenaRuleView",self.curBtn):pushInScene()
end

--关闭点击
function ArenaTopView:onClickclose(sender)
    -- 调用回调
    self._callBack()
end

--排行点击
function ArenaTopView:onClickTop(sender)
    -- 播放点击音效
    self:onClicktops(1)
end

function ArenaTopView:onClicktops(curcount)
    -- 播放点击音效
    gg.AudioManager:playClickEffect()

    local data = checktable(self.ArenaData[self.curBtn]).btndata
    self:getScene():createView("arena.ArenaTop",data,self.curBtn,curcount):pushInScene()
end


--更新视图
function ArenaTopView:updateData()
    --更新视图
    self:updataView()
end

return ArenaTopView