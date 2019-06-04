
local NoticeItemEx = class("NoticeItemEx", cc.load("ViewLayout"))
NoticeItemEx.RESOURCE_FILENAME="ui/announcement/noticeItemEx.lua"
NoticeItemEx.RESOURCE_BINDING = {
    ["panel"]                  = {["varname"] = "panel"},
    ["img_ico"]                = {["varname"] = "img_ico"},
    ["Img_gg"]                = {["varname"] = "Img_gg"},
    ["lw_bg"]                = {["varname"] = "lw_bg"},
    ["redPoint"]               = {["varname"] = "redPoint"},
    ["txt_title"]              = {["varname"] = "txt_title"},
    ["txt_time"]               = {["varname"] = "txt_time"},
    ["item_bg_sel"]               = {["varname"] = "item_bg_sel"},
    ["item_bg"]               = {["varname"] = "item_bg"},
}

function NoticeItemEx:onCreate()
    self:setContentSize(cc.size(274, 92))
    self.m_touchValid = false     --点击是否有效
    self.m_touchPos = nil         --点击的坐标
    self:addTouchEvent()
end

--判断自己是否真的可见
function NoticeItemEx:isVisibleTrue()
    if not self:isVisible() then
        return false
    end
    local loopNum = 0
    local parent = self:getParent()
    while parent ~= nil do
        if not parent:isVisible() then
            return false
        end
        loopNum = loopNum + 1
        if loopNum > 100 then return true end
        parent = parent:getParent()
    end
    return true
end


--添加 触摸事件
function NoticeItemEx:addTouchEvent()
    -- 注册触摸事件
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler( handler(self,self.onTouchBegin), cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler( handler(self,self.onTouchMove), cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler( handler(self,self.onTouchEnd), cc.Handler.EVENT_TOUCH_ENDED )

    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
    self.m_listener = listener
end

function NoticeItemEx:onTouchBegin( touch, event )
    if not self:isVisibleTrue() then return false end

    self.m_touchValid = false
    self.m_touchPos = nil
    self.m_listener:setSwallowTouches(false)

    --判断点击点是否在范围内
    local locationPos = self:convertToNodeSpace(touch:getLocation())
    local size = self:getContentSize()
    local rect = cc.rect(0, 0, size.width, size.height)
    if cc.rectContainsPoint(rect, locationPos) then
        self.m_touchValid = true
        self.m_touchPos = touch:getLocation()
        self.m_move = false
        return true
    else
        self.m_touchValid = false
         return false
    end
end

function NoticeItemEx:onTouchMove( touch, event )
    if not self.m_touchValid then return end
    --判断点击点是否在范围内
    local locationPos = self:convertToNodeSpace(touch:getLocation())
    local size = self:getContentSize()
    local rect = cc.rect(0, 0, size.width, size.height)
    if cc.rectContainsPoint(rect, locationPos) then
        self.m_listener:setSwallowTouches(true)
        self:moveFunc(touch:getLocation())
    else
        self.m_touchValid = false
        self.m_listener:setSwallowTouches(false)
        return false
    end
end

function NoticeItemEx:onTouchEnd( touch, event )
    if self.m_touchValid then
        self:onClickSelf()
    end
end

--触摸滑动时的逻辑处理
function NoticeItemEx:moveFunc(_pos)
    if not self.m_move and math.abs( self.m_touchPos.x - _pos.x ) < 10 and math.abs( self.m_touchPos.y - _pos.y ) > 20 then
        self.m_touchValid = false
        self.m_listener:setSwallowTouches(false)
        return
    end
end

--更新阅读状态
function NoticeItemEx:updaeReadStatus()
    --更新状态
    local status = self.m_data.status or self.m_data.receive_status or self.m_data.btn_status
    if status == 1 then --已读
        self.redPoint:setVisible(false)
        self.Img_gg:setVisible(false)
        self.img_ico:setVisible(true)
    else           --未读
        self.redPoint:setVisible(true)
        self.Img_gg:setVisible(true)
        self.img_ico:setVisible(false)
    end

end

--点击自己
function NoticeItemEx:onClickSelf()
    if self.m_clickCallFunc ~= nil then
        self.m_clickCallFunc(self)
    end
    --更新阅读状态
    self:updaeReadStatus()
end

--点击删除
function NoticeItemEx:onClickDel()
    if self.m_delCallFunc ~= nil then
        self.m_delCallFunc(self)
    end
end

--设置数据
function NoticeItemEx:setData(_data,id)
    self.m_data = _data
    self.tabType= id  --1：系统公告；2：我的消息

    local strlen = 150

    -- 2018-08-21 暂时隐藏礼物图片
    self.lw_bg:setVisible(false)
    -- if _data.awards then
    --     self.lw_bg:setVisible(true)
    -- else
    --     strlen = 180
    --     --self.txt_title:setContentSize(cc.size(230, 90))
    --     self.lw_bg:setVisible(false)
    -- end
    --设置标题
    self.txt_title:setString(self.m_data.title)
    local iwidth = self.txt_title:getContentSize().width
    local scaling = 1
    if iwidth > 170 then
        scaling = 170 / iwidth
    end
    self.txt_title:setScale(scaling)

    --设置时间
    if self.m_data.time then
        --拆分时间和日期
        local time = string.split( self.m_data.time," ")  --2018-03-20
        local date = string.split( time[1],"-")
        self.txt_time:setString(tostring(date[2] or " ").."-"..tostring(date[3] or " ").." "..tostring(time[2] or " "))--时间
    else
        self.txt_time:setVisible(false)
    end

     --更新阅读状态
    self:updaeReadStatus()
end

--获取数据
function NoticeItemEx:getData()
    return self.m_data
end

-- 设置 点击回调 删除回调
function NoticeItemEx:setCallFunc(_clickFunc,_delFunc)
    self.m_clickCallFunc = _clickFunc
    self.m_delCallFunc = _delFunc
end

return NoticeItemEx