-- Author: 李阿城
-- Date: 2018/3/17
-- Describe：名人堂界面

local ArenaHofView = class("ArenaHofView",cc.load("ViewBase"))

ArenaHofView.RESOURCE_FILENAME = "ui/arena/arena_hofview.lua"

ArenaHofView.RESOURCE_BINDING = {
    ["panel_hof"] = { ["varname"] = "panel_hof" },
    ["list_hof"] = { ["varname"] = "list_hof" },
    ["btn_close"]  = {["varname"] = "btn_close",["events"]={{["event"] = "click",["method"]="onClickclose"}} },    -- 关闭界面按钮

}

function ArenaHofView:onCreate( view , callBack )

    self.view = view
    self.list_hof:setScrollBarEnabled(false)
    self.HofData = nil
    self.currentTime = 0
    self.ArenaHofData = nil
    -- 回调函数
    self._callBack = callBack

end

--更新数据
function ArenaHofView:updateData()
    self:pullData()
end
--[[
* @brief 拉取名人堂数据
]]
function ArenaHofView:pullData()

    if not self.ArenaHofData then
        -- 更新数据
        -- 开启等待框
        gg.ShowLoading(self.view, "数据获取中...")
        gg.Dapi:Rank2NumList(3, 1,1, function(data)
            if tolua.isnull(self) then return end
            gg.ShowLoading(self.view)
            local data = checktable(data).data
            if not data then
                GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "数据获取失败")
                return
            end
            self.ArenaHofData= data.list

            self:initHofView(self.ArenaHofData)

        end)
    else

        self:initHofView(self.ArenaHofData)

    end
end

--关闭点击
function ArenaHofView:onClickclose(sender)
    -- 调用回调
    self._callBack()
end

--[[
* @brief 刷新名人堂界面
]]
function ArenaHofView:initHofView(data)
    self.list_hof:removeAllChildren()

     if not data then
         -- 没有数据
         return
     end
     --更新榜单
     self:updateTop(data)
 end

 --更新榜单
function ArenaHofView:updateTop(data)

    self.list_hof:setInnerContainerSize( {width =  250 *#data, height = 400} )
    local datacount =  #data
    for i = 1, #data do
        local data = data[i]
        local propNode = require( "ui.arena.hof_item.lua").create()
        local root = propNode.root
        local item_rank = root:getChildByName("item_rank")
        local img_avatar = item_rank:getChildByName("img_avatar")  --头像图片
        local txt_name = item_rank:getChildByName("txt_name")   --玩家名字
        local txt_score = item_rank:getChildByName("txt_score")   --积分
        local txt_phase = item_rank:getChildByName("txt_phase")   --第几期


        -- 显示头像图片
        local avatarPath = gg.IIF(checkint(data.sex) == 1, "common/hd_male.png", "common/hd_female.png")
        img_avatar:loadTexture(avatarPath)
        if data.avatarurl and data.avatarurl ~= "" then
            avatarPath = data.avatarurl
            gg.ImageDownload:LoadUserAvaterImage({url=avatarPath,ismine=false,image=img_avatar})
        end
        txt_phase:setString(data.phase)
        --设置昵称
        txt_name:setString(data.nickname)
        --设置积分
        txt_score:setString("积分:"..checkint(data.score))
        --设置位置
        if datacount == 1 then
            root:setPosition(375,50)
        elseif datacount == 2 then
            root:setPosition(225+300*(i-1),50)
        elseif datacount == 3 then
            root:setPosition(75+300*(i-1),50)
        else
            root:setPosition(250*(i-1),50)
        end
        self.list_hof:addChild(root)
    end
    self.list_hof:jumpToPercentHorizontal(100)
end


return ArenaHofView