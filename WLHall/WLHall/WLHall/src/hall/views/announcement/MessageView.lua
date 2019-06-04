
--活动-公告-我的消息 主界面

local AnnounceData = require("hall.models.AnnounceData")     --公告数据
local MymsgData = require("hall.models.MymsgData")             --我的消息数据
local MessageView = class("MessageView",  cc.load("ViewPop"))

MessageView.RESOURCE_FILENAME = "ui/announcement/messageView.lua"
MessageView.RESOURCE_BINDING = {
    ["btn_xtgg"]   = { ["varname"] = "btn_xtgg"   , ["events"] = { { ["event"] = "click", ["method"] = "onClickxtgg"  } } },
    ["btn_wdxx"]   = { ["varname"] = "btn_wdxx"   , ["events"] = { { ["event"] = "click", ["method"] = "onClickwdxx"  } } },
    ["btn_kf"]   = { ["varname"] = "btn_kf"   , ["events"] = { { ["event"] = "touch", ["method"] = "onClickkf"  } } },
    ["lb_bg"]     = { ["varname"] = "lb_bg"     },    -- 礼包的背景
    ["btn_bg"]     = { ["varname"] = "btn_bg"     },
    ["text_bg"]     = { ["varname"] = "text_bg"     },

    ["title_bg"]     = { ["varname"] = "title_bg"     },
    ["title_text"]     = { ["varname"] = "title_text"     },
    ["real_content"]     = { ["varname"] = "real_content"     },
    ["content_title"]     = { ["varname"] = "content_title"     },
    ["list_xtgg"]     = { ["varname"] = "list_xtgg"     },
    ["list_wdxx"]     = { ["varname"] = "list_wdxx"     },
    ["point_wdxx"]     = { ["varname"] = "point_wdxx"     },
    ["point_xtgg"]     = { ["varname"] = "point_xtgg"     },
    ["btn_recive_del"]     = { ["varname"] = "btn_recive_del"     },
    ["btn_close"]   = { ["varname"] = "btn_close"   , ["events"] = { { ["event"] = "click_color", ["method"] = "onClickClose"  } } }, -- 关闭按钮
    ["btn_bg_1"]   = { ["varname"] = "btn_bg_1"   , ["events"] = { { ["event"] = "click", ["method"] = "onClickReciveDel"  } } },
    ["btn_bg_2"]   = { ["varname"] = "btn_bg_2"   , ["events"] = { { ["event"] = "click", ["method"] = "onClickReciveDel"  } } },

    ["txt_name"]     = { ["varname"] = "txt_name"     },--暂无数据文本
    ["lv_hint"]     = { ["varname"] = "lv_hint"     },  --暂无数据容器

}

MessageView.ADD_BLUR_BG = true

--一级的按钮颜色
local TAB_NOT_SELECT_COLOR = cc.c3b(98, 158, 226)
local TAB_SELECT_COLOR = cc.c3b(246, 230, 155)
--二级的按钮颜色
local TWO_NOT_SELECT_COLOR = cc.c3b(255,255,255)
local TWO_TAB_SELECT_COLOR = cc.c3b(119,51,51)

--[[
* @brief 创建界面
@param tag1 一级目录(1:公告 2:消息)
@param tag2 对应的公告/消息id
]]
function MessageView:onCreate(pageData)
    self._propDef  = gg.GetPropList()
    self._pageData = checktable(pageData)

    -- 初始化界面
    self:initView()

    -- 加载数据
    self:showLoading("数据加载中...")
    gg.UserData:checkLoaded(function()
        if tolua.isnull(self) then return end
        self:showLoading()
        self:pullMsgData()
    end)
end

-- 初始化界面
function MessageView:initView()
    --适配分辨率
    self:setScale(math.min(display.scaleX, display.scaleY))

    -- 检查开关
    self:checkSwitch()

    -- 设置客服按钮颜色
    self.btn_kf:setColor(TAB_NOT_SELECT_COLOR)

    if self._pageData.tag1 and self._pageData.tag1 then
        -- 指定了需要选中的页面
        self:selTab(self._pageData.tag1)
    else
        -- 未指定页面，默认选中公告
        self:selTab(1)
    end
end

-- 开关检测
function MessageView:checkSwitch()
    if not GameApp:CheckModuleEnable( ModuleTag.CustomerService ) then
        self.btn_kf:setVisible(false)
    end
end

function MessageView:pullMsgData()
    -- 如果有数据拉取数据 --- 公告
    if gg.UserData:GetNoticeCount() == 0 then
        self:initListView_notice()
    else
        AnnounceData:pullData(handler(self, self.initListView_notice))
    end

    -- 如果有数据拉取数据 --- 我的消息
    if gg.UserData:GetUserMsgCount() == 0 then
        self:initListView_mymsg()
    else
        MymsgData:pullData(handler(self, self.initListView_mymsg))
    end
end

function MessageView:showPoint(node,datalist)
    local unreadcount = gg.TableValueNums(checktable(datalist),function(v,k)
        if checkint(v.status) ==0 then
            return true
        end
     end )

    if unreadcount>0 then
        node:setVisible(true)
    else
        node:setVisible(false)
    end
end

--系统公告 listView
function MessageView:initListView_notice()
    if tolua.isnull(self) then return end
    local dataList = AnnounceData:GetAllData()
    self:showPoint(self.point_xtgg,dataList)
    if #dataList <= 0 then
        return
    end

    self.lv_hint:setVisible(false)
    self.list_xtgg:setScrollBarEnabled(false)
    self.list_xtgg:removeAllItems()

    local selItem
    for i,v in ipairs(dataList) do
        local node = require("hall.views.announcement.NoticeItemEx").new()
        node:setData(v,1)
        node:setCallFunc( handler( self, self.onClick_noticeItem ), handler( self, self.onDel_noticeItem ) )
        self.list_xtgg:pushBackCustomItem(node)

        if self._pageData.tag2 and checkint(v.id) == checkint(self._pageData.tag2) then
            selItem = node
        elseif not selItem then
            selItem = node
        end
    end

    -- 当前显示了公告页面需要选中相应的公告
    if checkint(self._curPage) == 1 and selItem then
        self:selectNoticeItem(selItem)
    end
end

--我的消息 listView
function MessageView:initListView_mymsg()
    if tolua.isnull(self) then return end
    local dataList = MymsgData:GetAllData()
    self:showPoint(self.point_wdxx,dataList)
    if #dataList <= 0 then
        return
    end

    self.lv_hint:setVisible(false)
    self.list_wdxx:setScrollBarEnabled(false)
    self.list_wdxx:removeAllItems()

    local selItem
    for i,v in ipairs(dataList) do
        local node = require("hall.views.announcement.NoticeItemEx").new()
        node:setData(v,2)
        node:setCallFunc( handler( self, self.onClick_mymsgItem ), handler( self, self.onDel_mymsgItem ) )
        self.list_wdxx:pushBackCustomItem(node)

        if self._pageData.tag2 and checkint(v.id) == checkint(self._pageData.tag2) then
            selItem = node
        elseif not selItem then
            selItem = node
        end
    end

    -- 当前显示了消息页面需要选中相应的消息
    if checkint(self._curPage) == 2 and selItem then
        self:selectMsgItem(selItem)
    end
end

--点击系统公告
function MessageView:onClick_noticeItem(_item)
    gg.AudioManager:playClickEffect()
    self:selectNoticeItem(_item)
end

-- 选中某个公告
function MessageView:selectNoticeItem(_item)
    self.curitem = _item
    -- 先取消所有 item 的选中状态
    self:resetItemStatus(1)
    local dataList = AnnounceData:GetAllData()
    self.real_content:setVisible(true)
    self.content_title:setVisible(true)
    self.content_title:setFontSize(33)
    self.real_content:setFontSize(24)
    _item.item_bg_sel:setVisible(true)
    _item.item_bg:setVisible(false)
    _item.txt_title:setTextColor(TWO_TAB_SELECT_COLOR)
    _item.txt_time:setTextColor(TWO_TAB_SELECT_COLOR)

    --公告消息读取时发送
    if checkint(_item.m_data.status) == 0 then
        -- 发送读取消息到服务器
        gg.Dapi:MsgReadAfter( _item.m_data.id, "notice",function( a )
            if a and checkint(a.status) == 0 then
                printf("发送读取消息成功")
            else
                printf("发送读取消息失败")
            end
        end)
        -- 设置为已读状态
        AnnounceData:UpdataData( _item.m_data.id, "status", 1 )
        _item:updaeReadStatus()
        GameApp:dispatchEvent(gg.Event.HALL_UPDATE_NOTICE_UNREAD_COUNT)
    end

    self.real_content:setString(_item.m_data.body)
    self.content_title:setString(_item.m_data.title)
    self:showPoint(self.point_xtgg,dataList)
    self:changebtnstatus(2,"删除")
    self.btn_bg:setVisible(true)
end

--点击 我的消息
function MessageView:onClick_mymsgItem(_item)
    gg.AudioManager:playClickEffect()
    self:selectMsgItem(_item)
end

function MessageView:selectMsgItem(_item)
    self.curitem = _item
    -- 先取消所有 item 的选中状态
    self:resetItemStatus(2)
    self.real_content:setVisible(true)
    self.content_title:setVisible(true)
    self.content_title:setFontSize(36)
    self.real_content:setFontSize(26)
    _item.item_bg_sel:setVisible(true)
    _item.item_bg:setVisible(false)
    _item.txt_title:setTextColor(TWO_TAB_SELECT_COLOR)
    _item.txt_time:setTextColor(TWO_TAB_SELECT_COLOR)

      --消息读取时发送
    if checkint(_item.m_data.status) == 0 then
        -- 发送服务器消息
        gg.Dapi:MsgReadAfter( _item.m_data.id, "msg",function( a )
            if a and checkint(a.status) == 0 then
                printf("发送读取消息成功")
            else
                printf("发送读取消息失败")
            end
        end)

        -- 设置为已读
        MymsgData:UpdataData( _item.m_data.id, "status", 1 )
        _item:updaeReadStatus()
        -- 通知未读数更新
        GameApp:dispatchEvent(gg.Event.HALL_UPDATE_NOTICE_UNREAD_COUNT)
    end

    --第二种验证消息类型
    if _item.m_data.type and checkint(_item.m_data.type) == 2 then
        -- 是需要调用回调的类型
        local btnEnabled = (_item.m_data.btn_status and checkint(_item.m_data.btn_status) == 0)
        self:setBtnEnabled(btnEnabled,gg.IIF(_item.m_data.btn_text, _item.m_data.btn_text, "确定"))
    else
        self:showlb(_item.m_data)
    end
    local dataList = MymsgData:GetAllData()
    self.content_title:setString(_item.m_data.title)
    self.real_content:setString(_item.m_data.body)
    self:showPoint(self.point_wdxx,dataList)
    self.btn_bg:setVisible(true)
end

function MessageView:setBtnEnabled(enabled,txt)
    if enabled then
        self:changebtnstatus(1,txt)
    else
        self:changebtnstatus(2,"删除")
    end
end

--设置标题的色值
function MessageView:resetItemStatus(id)
    local items = {}
    if id == 2 then
        items = self.list_wdxx:getItems()
    elseif id == 1 then
        items = self.list_xtgg:getItems()
    end

    for i,v in ipairs(items) do
        v.item_bg_sel:setVisible(false)
        v.item_bg:setVisible(true)
        v.txt_title:setTextColor(TWO_NOT_SELECT_COLOR)
        v.txt_time:setTextColor(TWO_NOT_SELECT_COLOR)
    end
end

function MessageView:showlb(data)
    -- 附件
    if data.awards then
        self.lb_bg:setVisible(true)
        self:setProps( data.awards )
        self:showStamps(data)

        --礼物已领取，设置已领取标志，隐藏领取按钮
        if data.receive_status ==1 then
            self:changebtnstatus(2,"删除")
        else
            self:changebtnstatus(1,"领取")
        end
    else--系统公告、文字消息 显示删除
        self:changebtnstatus(2,"删除")
        self.lb_bg:setVisible(false)
    end
end

-- 设置附件奖励
function MessageView:setProps( data )
    for i,v in ipairs( checktable(data) ) do
        local propDef = self._propDef[ checkint(v[1]) ]
        if not propDef then return end

        local item = self:findNode( "item_"..i )
        local img = item:getChildByName( "img_prop" )
        local num = item:getChildByName( "txt_num" )

        -- 设置图片
        img:setTexture( propDef.icon )
        img:setScale( (item:getContentSize().width) / img:getContentSize().width )

        -- 设置数量
        if checkint(v[1]) == PROP_ID_MONEY and checkint(v[2]) >= 10000 then
              local count = gg.MoneyUnit( checkint(v[2]) )
            num:setString(count)
        else
            num:setString(checkint(v[2]) )
        end
        item:show()
    end
end

function MessageView:showStamps( datas )
    local data=datas.awards
    for i,v in ipairs( checktable(data) ) do
        local stamp = self:findNode( "stamp_"..i )
        if datas.receive_status and datas.receive_status ==1 then
            stamp:setVisible(true)
        else
            stamp:setVisible(false)
        end
    end

    for i=#data+1,5 do
        local item = self:findNode( "item_"..i )
        local stamp = self:findNode( "stamp_"..i )
        stamp:setVisible(false)
        item:setVisible(false)
    end
end

--删除 公告
function MessageView:onDel_noticeItem(_item)
    --删除数据
    AnnounceData:DeleteData(_item:getData().id)

    --删除ui
    local items = self.list_xtgg:getItems()
    for i,v in ipairs(items) do
        if v==_item then
            self.list_xtgg:removeItem(i-1)
            break
        end
    end
end

--删除 我的消息
function MessageView:onDel_mymsgItem(_item)
    --删除数据
    MymsgData:DeleteData(_item:getData().id)

    --删除ui
    local items = self.list_wdxx:getItems()
    for i,v in ipairs(items) do
        if v==_item then
            self.list_wdxx:removeItem(i-1)
            break
        end
    end
end

function MessageView:onClickClose()
    self:removeSelf()
end

--点击系统公告
function MessageView:onClickxtgg()
    self.curitem = nil
    gg.AudioManager:playClickEffect()
    self:selTab(1)

    local item = self.list_xtgg:getItem(0)
    if item then
        item:onClickSelf()
    end
end

--点击我的消息
function MessageView:onClickwdxx()
    self.curitem = nil
    gg.AudioManager:playClickEffect()
    self:selTab(2)

    local item = self.list_wdxx:getItem(0)
    if item then
        item:onClickSelf()
    end
end

--点击客服
function MessageView:onClickkf(event)
    -- 播放点击音效
    if event.name == "began" then
        self.btn_kf:setColor(TAB_SELECT_COLOR)
        gg.AudioManager:playClickEffect()
        device.callCustomerServiceApi(ModuleTag.Notice)
    else
        self.btn_kf:setColor(TAB_NOT_SELECT_COLOR)
    end
end

--点取领取
function MessageView:onClickReciveDel()
    if self.curitem~=nil then
        -- 播放点击音效
        gg.AudioManager:playClickEffect()

        if self.curitem.tabType==2 then--我的消息存在删除和领取/确定三种情况
            local data = self.curitem.m_data
            if data then
                if data.receive_status and checkint(data.receive_status) ==0 and data.awards then--带附件并且未领取，领取
                    self:receiveProps()
                elseif data.type and data.btn_status and checkint(data.type) == 2 and checkint(data.btn_status) == 0 then--第二种消息类型并且未处理
                    self:invokeCallback()
                else
                    self:delItemTishi()
                end
            end
        else
            self:delItemTishi()
        end
   end
end

function MessageView:delItemTishi()
    GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG, "删除之后将无法恢复，确定要删除吗？", function(bttype)
        if bttype==gg.MessageDialog.EVENT_TYPE_OK then
                self:delItem()
        end
    end,{ mode=gg.MessageDialog.MODE_OK_CANCEL_CLOSE, cancel="取消", ok="确定"})
end


function MessageView:delItem()
    self:selTab(self.curitem.tabType)
    if self.curitem.tabType==1 then
        self:onDel_noticeItem(self.curitem)
    elseif self.curitem.tabType==2 then
        self:onDel_mymsgItem(self.curitem)
    end

    self.btn_bg:setVisible(false)
    self.lb_bg:setVisible(false)
    self.curitem=nil
end

-- 调用 web 接口的回调
function MessageView:invokeCallback()
    local msgid = checkint( self.curitem.m_data.id )
    local callback = function( result )
        GameApp:dispatchEvent( gg.Event.SHOW_LOADING )
        if checkint(result.status) == 0 then
            if not tolua.isnull(self) and self.curitem and checkint(msgid)==checkint(self.curitem.m_data.id) then
                self:setBtnEnabled(false) --将确认按钮改成删除按钮
            end

            -- 修改按钮状态
            msgdata:UpdataData( msgid, "btn_status", 1 )
            GameApp:dispatchEvent(gg.Event.UPDATE_MESSAGE_STATUS,msgid)
            if result.data then
                local retData = checktable(result.data)
                if retData.type and retData.type == "rcas" then
                    gg.UserData:UpdateWebDate("rcas", 1)
                    gg.UserData:UpdateWebDate("asn", gg.IIF(retData.asn, retData.asn, ""))
                end
            end
        else
            printf( result.msg )
        end
    end

    GameApp:dispatchEvent( gg.Event.SHOW_LOADING , "处理中..." )
    gg.Dapi:MsgCallback( msgid, callback )
end

-- 领取附件
function MessageView:receiveProps()
    local msgid = checkint( self.curitem.m_data.id )
    local callback1 = function( result )
        GameApp:dispatchEvent( gg.Event.SHOW_LOADING )
        if checkint(result.status) == 0 then
            if not tolua.isnull(self) and self.curitem and checkint(msgid)==checkint(self.curitem.m_data.id) then
                self:showToast( "附件领取成功" )
                self.curitem.m_data.receive_status = 1
                self:showStamps(self.curitem.m_data)--显示已领取
                self:changebtnstatus(2,"删除")
            end

             -- 修改任务领取状态
            MymsgData:UpdataData( msgid, "receive_status", 1 )
            GameApp:dispatchEvent(gg.Event.UPDATE_MESSAGE_STATUS,msgid)
        else
            printf( result.msg )
        end
    end
    GameApp:dispatchEvent( gg.Event.SHOW_LOADING , "奖励领取中..." )
    gg.Dapi:MsgReward( msgid, callback1 )
end

function MessageView:changebtnstatus(status,text)
    --复位所有颜色
    for i=1,2 do
        self.btn_recive_del:getChildByName( "btn_bg_"..i ):setVisible(false)
    end

    --1:绿色，2:红色
    local btn = self.btn_recive_del:getChildByName( "btn_bg_"..status);

    btn:setVisible(true)
    btn:getChildByName("txt"):setString(text)
end

function MessageView:selTab(id)
    local items = {}
    self._curPage = id
    self.lv_hint:setVisible(true)

    if id == 2 then
        items = self.list_wdxx:getItems()
        self.txt_name:setString("暂无邮件")
        if #items > 0 then
            self.lv_hint:setVisible(false)
        end
        self.title_text:setString("我的邮件")
    elseif id == 1 then
        items = self.list_xtgg:getItems()
        self.txt_name:setString("暂无公告")
        if #items > 0 then
            self.lv_hint:setVisible(false)
        end
        self.title_text:setString("系统公告")
    end

    self.real_content:setVisible(false)
    self.content_title:setVisible(false)

    --显示对应tab的list
    self.list_xtgg:setVisible(id==1)
    self.list_wdxx:setVisible(id==2)

    if id==1 then
        self.btn_xtgg:setColor(TAB_SELECT_COLOR)
        self.btn_wdxx:setColor(TAB_NOT_SELECT_COLOR)
    else
       self.btn_wdxx:setColor(TAB_SELECT_COLOR)
       self.btn_xtgg:setColor(TAB_NOT_SELECT_COLOR)
    end

    self.lb_bg:setVisible(false)
    self.btn_bg:setVisible(false)
end

return MessageView
