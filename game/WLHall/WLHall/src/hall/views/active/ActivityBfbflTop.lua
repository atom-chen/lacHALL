--活动 排行页面
local ActivityBfbflTop = class("ActivityBfbflTop" , cc.load("ViewPop"))

ActivityBfbflTop.RESOURCE_FILENAME = "ui/active/activity_bfbfl_top.lua"

ActivityBfbflTop.RESOURCE_BINDING = {


    ["lv_top"] = { ["varname"] = "lv_top"},
    ["txt_time"] = { ["varname"] = "txt_time"},

    ["btn_arrow"] = { ["varname"] = "btn_arrow" , ["events"] = {{["event"] = "click", ["method"] = "onClicBtnArrow" }}},

    ["btn_close"]   = {["varname"] = "btn_close",   ["events"] = {{event = "click", method = "onClickClose" }}},
    ["txt_explain"] = { ["varname"] = "txt_explain"},
}

function ActivityBfbflTop:onCreate(data)
    self.data = data
    self:init()

    if data.time then
        self.txt_time:setString(os.date("当前排名时间：%H:%M", data.time))
    end
    self.txt_explain:setString( string.format( "活动结束后，累充超%s元，且排行前%d的玩家，可赢取实物奖励!" ,checkint(data.grade_config[2]) ,checkint(data.grade_config[1] ) ))
end
function ActivityBfbflTop:init()

    --隐藏箭头按钮
    self.btn_arrow:setVisible(false)
    self._topItem = self:findNode("panel_user")
    self.lv_top:onScroll(function(event)
        if event.name and event.name == "CONTAINER_MOVED" then
            self:setShowArrow(event.target)
        end
    end)
    self:initRecordListView(self.lv_top)

    self.lv_top:reloadData(self.data.list)
    self.lv_top:scrollToCell(self.data.count, 0)
end


function ActivityBfbflTop:initRecordListView(listview)
    local tbView = require("src.common.TableViewEx").new(listview)
    tbView._createItemFunc = function() return self:createItem() end
    tbView._updateItemFunc = function(...) return self:updateItem(...) end
    tbView._cellSize = self:findNode("panel_user"):getContentSize()
    tbView._cpr = 1
    tbView._needRecreate = true
    tbView:setMargin(0)
    tbView:init()
end
function ActivityBfbflTop:createItem()
    local item = self._topItem:clone()
    item:setVisible(true)
    item:setPositionX(0)
    item:setPositionY(0)
    return item
end
function ActivityBfbflTop:updateItem(item, data, idx)
    if not hallmanager or not hallmanager.userinfo then return end
    local userinfo = hallmanager.userinfo
    --排行图片
    local img_top = item:getChildByName("img_top")
    if idx < 4 then
        local img =  string.format( "hall/active/bfbfl/top/img_top%d.png" , idx )
        img_top:loadTexture(img,1)
    else
        img_top:setVisible(false)
    end
    --设置排行
    local txt_top = item:getChildByName("txt_top")
    txt_top:setString( string.format( "第%d名" , idx ) )

    --金额
    local txt_money = item:getChildByName("txt_money")
    txt_money:setString(data.money)
    --101代表不在排行榜的
    if idx == 101 or checkint(data.money)  == 0 then
        img_top:setVisible(false)
        txt_top:setString("未入榜")
        if self.data.totalMoney  ~= 0  then
            txt_money:setString(self.data.totalMoney)
        end
    end
    --玩家未上榜 充值到已经上榜的显示
    if self.data.ShowUptop and self.data.totalMoney  ~=0  and data.userid == userinfo.id then
        txt_top:setString("已上榜,等待刷新")
        txt_top:setPositionX(txt_top:getPositionX() -55)
        img_top:setVisible(false)
        txt_money:setString(self.data.totalMoney)
    end

    --设置头像
    local img_avatar = item:getChildByName("img_head") --文字
    -- 显示头像图片
    local avatarPath = gg.IIF(checkint(data.sex) == 1, "common/hd_male.png", "common/hd_female.png")
    img_avatar:loadTexture(avatarPath)
    if data.avatar_url and data.avatar_url ~= "" then
        avatarPath = data.avatar_url
        gg.ImageDownload:LoadUserAvaterImage({url=avatarPath,ismine=false,image=img_avatar})
    end

    -- 昵称
    local txt_nickname = item:getChildByName("txt_nickname")
    txt_nickname:setString(data.nickname)
    if txt_nickname:getContentSize().width > 120 then
        local strNick = gg.SubUTF8StringByWidth(tostring(data.nickname), 120, 24, "")
        txt_nickname:setString(strNick)
    end

    if self.data.count == idx then  --自己的排行显示红色字体
        txt_nickname:setTextColor( { r = 255 , g = 120, b = 0} )
        txt_money:setTextColor( { r = 255 , g = 120, b = 0} )
        txt_top:setTextColor( { r = 255 , g = 120, b = 0}  )
    end
end

--设置箭头显示
function ActivityBfbflTop:setShowArrow(svtop)
    --item 所在的位置
    local curpos =   math.abs(math.floor(svtop:getInnerContainerPosition().y))
    --item 容器的高度
    local svheigt =  math.abs(math.floor(svtop:getInnerContainerSize().height))
    --可视的排行高度
    local sheight = svtop:getContentSize().height
    -- 50 表示item 一个的高度
    if svheigt - curpos <= sheight+50 then
        self.btn_arrow:setVisible(false)  --箭头
    else
        self.btn_arrow:setVisible(true)  --箭头
    end
end

function ActivityBfbflTop:onClickClose()
    self:removeSelf()
end

--点击箭头
function ActivityBfbflTop:onClicBtnArrow()
    -- 播放点击音效
    gg.AudioManager:playClickEffect()
    self.lv_top:scrollToCell(1, 0)
end

return ActivityBfbflTop