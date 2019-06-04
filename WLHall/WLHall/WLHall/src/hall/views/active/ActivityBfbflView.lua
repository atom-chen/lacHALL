--返利充值活动
local ActivityBfbflView = class("ActivityBfbflView", cc.load("ViewBase"))

ActivityBfbflView.RESOURCE_FILENAME="ui/active/activity_bfbfl_view.lua"

ActivityBfbflView.RESOURCE_BINDING =
{

    ["Panel_bg"] = { ["varname"] = "Panel_bg"},

    ["btn_rule"] = { ["varname"] = "btn_rule" , ["events"] = {{["event"] = "click", ["method"] = "onClicBtnRule" }}},


    ["panel_top"] = { ["varname"] = "panel_top" , ["events"] = {{["event"] = "click", ["method"] = "onClicBtnTop" }}},

    ["btn_store"] = { ["varname"] = "btn_store" , ["events"] = {{["event"] = "click", ["method"] = "onClicBtnStore" }}},

    ["panel_bar"] = { ["varname"] = "panel_bar"},

    ["panel_txt_top"] = { ["varname"] = "panel_txt_top"},

    ["txt_mci"] = { ["varname"] = "txt_mci"},
    ["txt_Top_unit"] = { ["varname"] = "txt_Top_unit"},

    ["txt_myTop"] = { ["varname"] = "txt_myTop"},

    ["loadingbar"] = { ["varname"] = "loadingbar"},

    ["panel_mytop"] = { ["varname"] = "panel_mytop"},

    ["txt_myTop1"] = { ["varname"] = "txt_myTop1"},

    ["txt_cfg_money"] = { ["varname"] = "txt_cfg_money"},
    ["loading_data"] = { ["varname"] = "loading_data"},
    ["panel_title"] = { ["varname"] = "panel_title"},

    ["txt_time"] = { ["varname"] = "txt_time"},
    ["img_time_di"] = { ["varname"] = "img_time_di"},

    ["txt_hdsj"] = { ["varname"] = "txt_hdsj"},

    ["txt5"] = { ["varname"] = "txt5"},

}
--进度条数据
ActivityBfbflView.DATA_BAR=
{
    [1] = 0.10,
    [2] = 0.20,
    [3] = 0.30,
    [4] = 0.45,
    [5] = 0.65,
    [6] = 0.85,
}

function ActivityBfbflView:onCreate(data)
    self.data = data
    self:setActivityTime()
    if self.data.active_tag == gg.ActivityPageData.ACTIVE_BFBFL_QD then --渠道 华为p20
        local txt_title1 = self.panel_title:getChildByName("txt_title1")
        txt_title1:loadTexture("hall/active/bfbfl/txt_title2.png",0)
        local img_award1 = self.panel_title:getChildByName("img_award_1")
        img_award1:loadTexture("hall/active/bfbfl/img_award_1.1.png",1)
        img_award1:ignoreContentAdaptWithSize(true)
    end
    self:init()
    --返利充值成功
    self:addEventListener(gg.Event.ON_BFBFL_PAY, handler(self, self.bfbflPay))

end
--设置活动时间
function ActivityBfbflView:setActivityTime()
    -- 显示活动的时间
    local startTime = os.date("%Y年%m月%d日", self.data.start_time)
    local endTime = os.date("%m月%d日", self.data.end_time)
    local strTime = string.format(": %s至%s", startTime, endTime)
    self.txt_time:setString(strTime)
    self.img_time_di:setContentSize(self.txt_time:getSize().width + self.txt_hdsj:getSize().width +60, self.img_time_di:getContentSize().height)
    --规则按钮
    self.btn_rule:setPositionX(self.img_time_di:getPositionX() +  self.img_time_di:getSize().width +60 )
end

--更新数据
function ActivityBfbflView:bfbflPay(event,userMoney)
    if tolua.isnull(self) then return end
    self:updateView(userMoney,true)
end
--更新数据
function ActivityBfbflView:updateView(userMoney,isPay)

    local totalMoney = checkint(userMoney)
    if self.ActivityData.grade_list and #self.topList > 0  then

        if not hallmanager or not hallmanager.userinfo then return end
        local userinfo = hallmanager.userinfo
        self:setProgressBar( self.ActivityData.grade_list ,totalMoney)
        local list = self.topList
        --排行长度
        local topLength = #list
        local topCount = 0  --玩家排行
        local money = -1   --距离上一名的金额
        for i = topLength,1,-1 do
            --玩家已经在排行榜上 需要和上一名的玩家比较
            if checkint(list[i].money) == totalMoney and checkint(list[i].userid ) == userinfo.id then
                if i ~= 1 then  --玩家已经是第一名
                    topCount =  i - 1
                end
                break
            --玩家不在排行榜上
            elseif checkint(list[i].money) >= totalMoney and (self.ShowUptop or isPay ) then   --玩家充值之后大于上榜玩家
                topCount =  i
                break
            end
        end
        for i = topLength,1,-1 do
            if checkint(list[i].money) > totalMoney then
                money = checkint(list[i].money) - totalMoney
                break
            end
        end
        --充值之后未入榜的
        if money == -1 then
            money = checkint(self.ActivityData.list[topLength].money) - totalMoney
        elseif money < 0 then
            money = 0
        end
        --未上榜玩家充值之后上榜的
        if self.ShowUptop and totalMoney > checkint(self.ActivityData.list[topLength].money) then
            self.ActivityData.ShowUptop = true
        end
        --玩家自己的充值金额
        self.ActivityData.totalMoney = totalMoney
        --金额为0时 未上榜
        if totalMoney == 0 then
            topCount = 100
        end
        self:setMyTop(topCount + 1 ,checkint(money))
    end

end

function ActivityBfbflView:init()
    self.ActivityData = {}
    gg.Dapi:BonusPoolRankInfoList(self.data.active_tag ,function(cb)
        if tolua.isnull(self) then return end
        local cb = checktable(cb)
        if not hallmanager or not hallmanager.userinfo then return end
        if not cb.status or checkint(cb.status) ~= 0 or not cb.data then
            GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "网络错误，请关闭界面重试！")
            self.loading_data:setVisible(false)
            return
        end

        local userinfo = hallmanager.userinfo
        local toplist = checktable(cb.data.rank).list
        -- --排序
        -- table.sort(toplist, function(a, b)
        --     return checkint(a.money) > checkint(b.money)
        -- end)
        --原始排行数据
        self.topList =toplist
        --需要修改的排行数据
        local list = clone(toplist)
        local userData = checktable(checktable(cb.data).user)
        local grade_config = checktable(checktable(cb.data).grade_config)
        local grade_list = checktable(checktable(cb.data).grade_list)
        self.txt_cfg_money:setString(checkint(grade_config[2]))
        self.txt5:setPositionX(self.txt_cfg_money:getPositionX() +  self.txt_cfg_money:getSize().width + 5 )
        --判断用户是否入排行榜 返回排行值 0代表不在排名中
        local count = self:isUprank(list)
        --排行榜排行提示
        self.ActivityData.ShowUptop = false
        --显示上榜判断
        self.ShowUptop = false
        --不在排行榜 和 玩家充值为0的 需要提示
        if count == 0 or userData.totalMoney ~= 0 then
            self.ShowUptop = true
        end
        if count == 0 then
            table.insert( list,{nickname = userinfo.nick ,sex = userinfo.sex,userid = userinfo.id, avatar_url = userinfo.avatarurl ,money = checkint(userData.totalMoney)} )
            count = #list
        end
        self.ActivityData.grade_config = grade_config
        self.ActivityData.grade_list = grade_list
        self.ActivityData.list = list
        self.ActivityData.count = checkint(count)
        self.ActivityData.time =  checktable(cb.data.rank).UpdateTime
        self.ActivityData.plan =  checkint(checktable(cb.data).plan)
        --设置进度条和我的排行显示
        self:updateView(userData.totalMoney,false)

        self.loading_data:setVisible(false)
    end)
end

--设置当前排行及上一名的金额差
function ActivityBfbflView:setMyTop(myTop,Money)
    if  myTop == 101 then  --未入榜
        myTop = 0
    end
    local txt_unit = self.panel_txt_top:getChildByName("txt_unit")
    local txt_top2 = self.panel_txt_top:getChildByName("txt_top2")
    self.txt_myTop1:setVisible(false)
    if myTop == 1 then  --第一名
        self.txt_mci:setString(myTop)
        self.panel_mytop:setPositionY( self.txt_myTop1:getPositionY() - 15)
        self.panel_mytop:setVisible(true)
        self.panel_txt_top:setVisible(false)
    elseif myTop == 0 then  --未入榜
        txt_top2:setString("距离上榜还差")
        self.txt_myTop1:setVisible(true)
        self.panel_txt_top:setVisible(true)
        self.panel_mytop:setVisible(false)
    else
        txt_top2:setString("距离上一名还差")
        self.panel_txt_top:setVisible(true)
        self.panel_mytop:setVisible(true)
        self.txt_mci:setString(myTop)
    end

    local txt_unit = self.panel_txt_top:getChildByName("txt_unit")
    local txt_count = self.panel_txt_top:getChildByName("txt_count")
    txt_count:setString(Money)
    --设置位置
    txt_count:setPositionX(txt_unit:getPositionX() - 5)
    txt_top2:setPositionX(txt_count:getPositionX() - txt_count:getSize().width -5)
    self.txt_mci:setPositionX(self.txt_Top_unit:getPositionX() -5)
    self.txt_myTop:setPositionX(self.txt_mci:getPositionX() - self.txt_mci:getSize().width - 5)
end
--设置进度条
function ActivityBfbflView:setProgressBar(grade_list,myMoney)
    if not grade_list then return end
    self.panel_bar:setVisible(true)

    local gradelist =  checktable(grade_list.grade)
    self.loadingbar:setPercent(0)

    local percent = 0
    local shouldStop = false
    local txt_fl = self.panel_bar:getChildByName("txt_fl")
    for i=1, #gradelist do
        -- 显示对应的进度数值
        --百分百
        local txtbfb = self.panel_bar:getChildByName("txt_bfb"..i)
        local per = grade_list.grade_ratio[i]
        txtbfb:setString(string.format("%d%%" ,per*100) )
        --金额
        local txt_je = self.panel_bar:getChildByName("txt_je"..i)
        txt_je:setString(checkint(grade_list.grade[i]))

        local preVal = 0
        local preMoney = 0
        if i > 1 then
            preVal = ActivityBfbflView.DATA_BAR[i - 1]
            preMoney = checkint(gradelist[i - 1])
        end
        if checkint(gradelist[i]) <= myMoney then
            percent = ActivityBfbflView.DATA_BAR[i]
            -- 高亮显示
            if checkint(gradelist[i]) == myMoney then shouldStop = true end
            txtbfb:setTextColor( { r = 251 , g = 166, b = 32} )
            txt_fl:setTextColor( { r = 251 , g = 166, b = 32} )
           -- if i < 6 then
                local img_line = self.panel_bar:getChildByName("img_line"..i)
                local line1 = img_line:getChildByName("line1")
                line1:setVisible(true)
         --   end
        elseif checkint(gradelist[i]) > myMoney and not shouldStop then
            shouldStop = true
            percent = percent + (myMoney - preMoney) / (checkint(gradelist[i]) - preMoney) * (ActivityBfbflView.DATA_BAR[i] - preVal)
        end
        txtbfb:setVisible(true)
        txt_je:setVisible(true)
    end
    --用户达到最后金额直接100%
    if percent >= ActivityBfbflView.DATA_BAR[6] then
        percent = 1
    end
    self.loadingbar:setPercent(percent  *100)
end
--规则
function ActivityBfbflView:onClicBtnRule()
    -- 播放点击音效
    gg.AudioManager:playClickEffect()
    if not self.result then
        gg.Dapi:ActivityRuleInfoList(self.data.active_tag ,function(cb)
            if tolua.isnull(self) then return end
            local cb = checktable(cb)
            if not cb.status or checkint(cb.status) ~= 0 or not cb.list then
                GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "网络错误，请稍后重试！")
                return
            end
            local list = checktable(cb.list)
            self.result = checktable(list[1])
            self:getScene():createView("active.ActiveRule",self.result):pushInScene()
        end)
    else
        self:getScene():createView("active.ActiveRule",self.result):pushInScene()
    end

end
--玩家是否上排行榜
function ActivityBfbflView:isUprank(list)
    if #list == 0 then return  end
    if not hallmanager or not hallmanager.userinfo then return end
    local userinfo = hallmanager.userinfo
    local count = 0
    for i = 1 ,#list do
        if checkint(list[i].userid) == userinfo.id then
            count = i
            break
        end
    end

    return count
end

--排行
function ActivityBfbflView:onClicBtnTop()
    -- 播放点击音效
    gg.AudioManager:playClickEffect()
    --设置进度条和我的排行显示
    if not self.ActivityData.list or self.ActivityData.plan  == 1 then
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "排行榜维护中，请稍后在试！")
        return
    end
    self:getScene():createView("active.ActivityBfbflTop",self.ActivityData):pushInScene()
end

--点击充值
function ActivityBfbflView:onClicBtnStore()
    -- 播放点击音效
    gg.AudioManager:playClickEffect()
    GameApp:DoShell(self:getScene(), "Store://bean")
end
return ActivityBfbflView