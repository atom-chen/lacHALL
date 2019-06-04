-- Author: 李阿城
-- Date: 2018/4/25
-- Describe：排行界面

local ArenaTop = class("ArenaTop",cc.load("ViewPop"))

ArenaTop.RESOURCE_FILENAME = "ui/arena/arena_top.lua"

ArenaTop.RESOURCE_BINDING = {

    ["panel"] = { ["varname"] = "panel" },
    ["userinfo"] = { ["varname"] = "userinfo" },  --个人排行
    ["btn_close"]  = {["varname"] = "btn_close",["events"]={{["event"] = "click",["method"]="onClickclose"}} },    -- 关闭界面按钮
    ["item_rank"] = { ["varname"] = "item_rank" },  --排行item
    ["list_node"] = { ["varname"] = "list_node" },  --容器节点

    ["lv_time"] = { ["varname"] = "lv_time" },   --按钮容器

    ["txt_day_arena"] = { ["varname"] = "txt_day_arena" },  --日排位标题
    ["txt_explain"] = { ["varname"] = "txt_explain" },     --排行说明
    ["txt_arena"] = { ["varname"] = "txt_arena" },     --排位说明标题

    ["txt_notdata"] = { ["varname"] = "txt_notdata" },  --暂无排行文字

    ["img_arena_type"] = { ["varname"] = "img_arena_type" },  --排位赛奖杯图片

    ["btn_arrow"]  = {["varname"] = "btn_arrow",["events"]={{["event"] = "click",["method"]="onClickarrow"}} },    -- 箭头按钮

}
--78 表示item 一个的高度
local ITEM_HEIGHT = 78
--[[
* @btndata 按钮数据 1是每日排位赛 ，2 是周排位赛
* @ ArenaType 获取当前点击的是日排位还是周排位 1为日排位 2为周排位
* @ curcount 单前的排行值

* @brief roomList 更新列表信息
]]
function ArenaTop:onCreate(btndata,ArenaType,curcount)
    -- 道具
    self.btndata = btndata
    self.ArenaType = ArenaType
    self.curcount= curcount
    --是否当日的数据
    self.isCurdata = false
    self.isCurTag = 0
    --排行数据
    self.TopData = {}
    --自适应
    self:setScale(math.min(display.scaleX, display.scaleY))
    self.listview = {}
    self.btntype = 0
    self._propDef  = gg.GetPropList()
    --隐藏箭头按钮
    self.btn_arrow:setVisible(false)
    if not ArenaType then return end
    --获取当前点击的是
    self.curBtnType = ArenaType
    if ArenaType == 2 then
        --排位赛类型图片
        self.img_arena_type:loadTexture("hall/arena/img_week_2.png",1)
        --更新说明
        self.txt_explain:setString("(本期积分排行，每天刷新)")
        --排位标题
        self.txt_arena:setString("本期获得积分")
    elseif ArenaType == 1 then
        --排位赛类型图片
        self.img_arena_type:loadTexture("hall/arena/img_day_1.png",1)
        --更新说明
        self.txt_explain:setString("(本期积分排行，每小时刷新)")
        --排位标题
        self.txt_arena:setString("本日获得积分")
    end
    self:createBtn(btndata)
end


function ArenaTop:setShowArrow(svtop)
    --item 所在的位置
    local curpos =   math.abs(math.floor(svtop:getInnerContainerPosition().y))
    --item 容器的高度
    local svheigt =  math.abs(math.floor(svtop:getInnerContainerSize().height))
    --可视的排行高度
    local sheight = svtop:getContentSize().height
    -- 78 表示item 一个的高度
    if svheigt - curpos <= sheight+ITEM_HEIGHT then
        self.btn_arrow:setVisible(false)  --箭头
    else
        self.btn_arrow:setVisible(true)  --箭头
    end
end

function ArenaTop:createBtn(btndata)
    if not btndata then
        --显示周排位标题
        self.txt_day_arena:setString("周排位")
        self.txt_day_arena:setVisible(true)
        self.txt_notdata:setVisible(true)
        return
    end

    local btn_width  = 0
    -- 清除按钮数据
    self.lv_time:removeAllChildren()
    local datalength = #btndata
    self._btnTb = {}
    local btnCount = 1
    for i,v in ipairs(checktable(btndata)) do
        --按钮页面
        local node = require("res/ui/arena/arena_button_item.lua").create()
        local btn = node.root:getChildByName("btn_time")

        local txtAta = btn:getChildByName("txt_time")  --设置按钮名字
        local txt_jxz = btn:getChildByName("txt_jxz")  --进行中
        local img_bg = btn:getChildByName("img_bg")  --背景图片
        local img_tag = btn:getChildByName("img_tag")  --移动图片
        if self.ArenaType == 1 then
            txt_jxz:setString("(进行中)")
        end
        --排行容器
        local toplist = require("res/ui/arena/arena_toplist.lua").create()
        local listview = toplist.root:getChildByName("listview_top")
        self.list_node:addChild(toplist.root)

        listview:onScroll(function(event)
            if event.name and event.name == "CONTAINER_MOVED" then
                self:setShowArrow(event.target)
            end
        end)



        -- 隐藏滚动条
        listview:setScrollBarEnabled(false)
        self:initRecordListView(listview)

        btn.childView = listview
        btn.tag = btndata[i].tags
        if btnCount ~=1 then
            img_bg:loadTexture("hall/arena/img_bg2.png",1)
        end

        --设置名字
        txtAta:setString(btndata[i].name)

        local txt_jxz_width =0
        if datalength == btnCount then
            txt_jxz:setVisible(true)
            txt_jxz_width = txt_jxz:getSize().width +10
        end

        --获取名字大小
        local txt_width = txtAta:getSize().width + txt_jxz_width
        btn:setContentSize(cc.size(txt_width+60, 60.50))
        img_bg:setContentSize(cc.size(txt_width+60, 60.50))
        local width = btn:getContentSize().width
        txtAta:setPositionX(btn:getContentSize().width / 2 - txt_jxz_width/2)
        img_tag:setPositionX(btn:getContentSize().width / 2)
        txt_jxz:setPositionX(txtAta:getPositionX()+10+ txtAta:getSize().width/2)
        --设置tag
        btn:setTag(btndata[i].tags)

        table.insert(self._btnTb, btn)

        --设置按钮位置
        btn:setPosition(cc.p(0 + btn_width,30))
        btn_width = btn_width + width

        self.lv_time:addChild(node.root)

         -- 按钮添加触摸事件
         btn:addTouchEventListener(function(sender, state)
            local touchTag = sender:getTag()
            -- 判断是否是已经点击的按钮
            if touchTag ~= self.curBtnTag then
                if state ==  ccui.TouchEventType.ended then
                    -- 播放点击音效
                    gg.AudioManager:playClickEffect()
                    self:onTabBtn(sender.childView,touchTag)
                end
            end
        end)

        btnCount = btnCount + 1
    end
    self.isCurTag = checkint(self._btnTb[btnCount - 1].tag)
   self:onTabBtn(self._btnTb[btnCount - 1].childView, checkint(self._btnTb[btnCount - 1].tag)) -- 默认点击进行中按钮
end

--时间按钮的点击
function ArenaTop:onTabBtn(btnlistview,Tag)

    if Tag == self.isCurTag  then
        self.isCurdata = false
        if self.ArenaType == 1 then
            self.txt_arena:setString("本日获得积分")
        end
    else
        self.isCurdata = true
        if self.ArenaType == 1 then
            self.txt_arena:setString("昨日获得积分")
        end
    end
    if self.TopData[Tag] and self.TopData[Tag].curdata then
        --更新个人排行
        self:updateInfoView(self.TopData[Tag].curdata)
    end

    --隐藏提示消息
    self.txt_notdata:setVisible(false)
    self:hideDataLoading()
    self.curBtnTag = Tag
    self:UpdateBtn(Tag) --更新按钮
    self:pullTopData(btnlistview,Tag)  --领取排位数据
end

function ArenaTop:UpdateBtn(tag)
    for i,btn in ipairs(self._btnTb) do
        local txtAta = btn:getChildByName("txt_time")  --设置按钮名字
        local txt_jxz = btn:getChildByName("txt_jxz")  --进行中
        local img_tag = btn:getChildByName("img_tag")  --图片标签
        local img_bg = btn:getChildByName("img_bg")  --背景图片
        local v =  btn:getTag()
        if v == tag then
            btn.childView:setVisible(true)
            img_bg:setOpacity(255);  -- 设置透明度
            txtAta:setTextColor({r=58, g=111, b=192})  --设置字体颜色
            txt_jxz:setTextColor({r=216, g=90, b=34})
            img_tag:setVisible(true)            --设置标签显示
        else
            btn.childView:setVisible(false)
            img_bg:setOpacity(0);
            txtAta:setTextColor({r=255, g=255, b=255})
            txt_jxz:setTextColor({r=255, g=255, b=255})
            img_tag:setVisible(false)
        end
    end
end

function ArenaTop:showDataLoading()
    if not self.loadingNode then
        self.loadingNode = ccui.Text:create()
        self.loadingNode:setFontSize(28)
        self.loadingNode:setTextColor({r = 127, g = 127, b = 127})
        self.loadingNode:setString("数据加载中...")
        self.loadingNode:setPosition(self.txt_notdata:getPosition())

        self.panel:addChild(self.loadingNode)
    end
    self.loadingNode:setVisible(true)
end

function ArenaTop:hideDataLoading()
    if self.loadingNode then
        self.loadingNode:setVisible(false)
    end
end

--获取排行数据
function ArenaTop:pullTopData(listview,time)

    self.btntype = time
    if not self:isNeedPullData(self.TopData[time]) then
        self.btn_arrow:setVisible(true)
        self:setShowArrow(self.listview[self.btntype])
        return
    end
    --显示数据加载中
    self:showDataLoading()
    --领取排行数据 self.curBtnType为1是日排位 2周排位。time为周排行的第几期。
    gg.Dapi:Rank2NumList(self.curBtnType, time, self.curcount,function(data)
        if tolua.isnull(self) then return end
        --隐藏数据加载中
        self:hideDataLoading()
        local data = checktable(data).data
        if not data then
            GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "数据获取失败")
            self.txt_notdata:setVisible(true)
            return
        end

        --更新个人排行
        self:updateInfoView(data.active_num)
        if data.list and  #data.list > 0 then
            if not self.TopData[time] then
                self.TopData[time] ={}
            end
            self.btn_arrow:setVisible(true)
            --保存数据
            self.TopData[time].data = data.list
            self.TopData[time].curdata = data.active_num
            listview:reloadData(data.list)

            self.listview[self.btntype]  = listview
            if self.curcount >3 then
                listview:scrollToCell(self.curcount, 0)
            else
                self.btn_arrow:setVisible(false)
            end
        else
            --隐藏按钮
            self.btn_arrow:setVisible(false)
            --显示暂无数据
            self.txt_notdata:setVisible(true)
        end
    end)

end

--[[
* @brief 判断是否要拉取数据
]]
function ArenaTop:isNeedPullData(data)
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
--创建item
function ArenaTop:createItem()
    local item = self.item_rank:clone()
    item:setVisible(true)
    item:setPositionX(0)
    item:setPositionY(0)
    return item
end
--初始化列表视图
function ArenaTop:initRecordListView(listview)
    local tbView = require("src.common.TableViewEx").new(listview)
    tbView._createItemFunc = function() return self:createItem() end
    tbView._updateItemFunc = function(...) return self:updateItem(...) end
    tbView._cellSize = self:findNode("item_rank"):getContentSize()
    tbView._cpr = 1
    tbView._needRecreate = true
    tbView:setMargin(0)
    tbView:init()
end

--更新自己的榜单
function ArenaTop:updateInfoView(data)
    if not data then return end
    --排行值
    local txt_top_value = self.userinfo:getChildByName("txt_top_value")
    txt_top_value:setString(data.self_rank or "未入榜")

    --排位分
    local txt_arena_value = self.userinfo:getChildByName("txt_arena_value")
    txt_arena_value:setString(data.score or "0")
end

--更新排行
function ArenaTop:updateItem(item, data, idx)

    --设置背景
    local img_bg = item:getChildByName("img_bg")
    if(idx%2 == 0) then
        img_bg:setBackGroundColor({r = 255, g = 255, b = 255})
    else
        img_bg:setBackGroundColor({r = 241, g = 241, b = 241})
    end
    --设置排行
    local img_top = item:getChildByName("img_top") --图片
    local txt_top = item:getChildByName("txt_top") --文字
    if idx > 3 then
        img_top:setVisible(false)
        txt_top:setVisible(true)
        txt_top:setString(idx)
    else
        img_top:loadTexture(string.format("hall/honor/rank_%d.png", idx), 1)
        img_top:setVisible(true)
        txt_top:setVisible(false)
    end

    --设置头像
    local img_avatar = item:getChildByName("img_head") --文字
    -- 显示头像图片
    local avatarPath = gg.IIF(checkint(data.sex) == 1, "common/hd_male.png", "common/hd_female.png")
    img_avatar:loadTexture(avatarPath)
    if data.avatarurl and data.avatarurl ~= "" then
        avatarPath = data.avatarurl
        gg.ImageDownload:LoadUserAvaterImage({url=avatarPath,ismine=false,image=img_avatar})
    end
    --用户昵称
    local strNick = gg.SubUTF8StringByWidth(data.nickname, 160, 24, "")
    local txtnickname = item:getChildByName("txt_nickname")
    txtnickname:setString(strNick or "小木")

    --大师分
    local txt_score = item:getChildByName("txt_score")
    txt_score:setString("积分:"..data.score )
    --显示奖励
    if self.isCurdata  then
        --获取奖励的数量
        local awardamount  = Table:length(data.dataid_count)
        --奖励计数
        local awardcount = 1
        for propid,value in pairs(data.dataid_count) do
            -- 道具id
            local propid = propid
            -- 道具数量
            local propCount = value
            local lv_award = item:getChildByName("lv_award_"..awardcount)  --奖励图片1
            --设置奖励
            local img_award = lv_award:getChildByName("img_award")
            local txt_award_value = lv_award:getChildByName("txt_award_value")

            -- 奖励图片
            img_award:loadTexture(self._propDef[propid].icon, 0)
            lv_award:setVisible(true)
            if awardcount == 2 then
                lv_award:setVisible(false)
            end

            local countStr = checkint(propCount)* ( self._propDef[propid].proportion or 1 )
            local strtxt = 0
            if propid == PROP_ID_261 or propid == PROP_ID_PHONE_CARD then
                countStr = string.format( "%.2f", countStr)
                strtxt = string.format("x%s",countStr)
            else
                strtxt = gg.MoneyUnit(countStr)
            end
            -- 奖励内容
            txt_award_value:setString(strtxt)
            awardcount = awardcount + 1
        end
    else
         local img_jb = item:getChildByName("img_jb")
         txt_score:setPositionX(txt_score:getPositionX() + 230)
         img_jb:setPositionX(img_jb:getPositionX() + 230)
    end
    return panel_bg
end

--关闭点击
function ArenaTop:onClickclose(sender)
    self:removeSelf()
end
--返回首页排行
function ArenaTop:onClickarrow(sender)
    -- 播放点击音效
    gg.AudioManager:playClickEffect()
    if self.listview[self.btntype] then
        self.listview[self.btntype]:scrollToCell(1, 0)
    end
end

return ArenaTop