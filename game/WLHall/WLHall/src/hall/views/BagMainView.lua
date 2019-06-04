
-- Author: zhaoxinyu
-- Date: 2016-09-02 19:44:20
-- Describe：背包层

local BagMainView = class("BagMainView", cc.load("ViewPop"))

BagMainView.RESOURCE_FILENAME="ui/bag/bag_node.lua"
BagMainView.ADD_BLUR_BG = true
BagMainView.RESOURCE_BINDING = {
    ["panel_l"]      = {["varname"] = "panel_l"     },                                                                      -- 背包左侧面板
    ["txt_mn_xd"]    = {["varname"] = "txt_mn_xd"   },                                                                      -- 携带的钱
    ["txt_mn_bg"]    = {["varname"] = "txt_mn_bg"   },                                                                      -- 背包的钱
    ["slider_cq"]    = {["varname"] = "slider_cq"   },
    ["cnt_bg"]       = {["varname"] = "cnt_bg"      },
    ["txt_bean_cnt"] = {["varname"] = "txt_bean_cnt"},
    ["txt_tips"]     = {["varname"] = "txt_tips"    },
    ["btn_service"]  = {["varname"] = "btn_service", ["events"] = {{event = "click", method = "onClickService"}}},          -- 联系客服
    ["btn_add"]      = {["varname"] = "btn_add",     ["events"] = {{event = "click", method = "onClickChangeMoney"}}},      -- 存减按钮
    ["btn_minus"]    = {["varname"] = "btn_minus",   ["events"] = {{event = "click", method = "onClickChangeMoney"}}},      -- 存减按钮
    ["btn_save"]     = {["varname"] = "btn_save",    ["events"] = {{event = "click", method = "onClickSave"}}},             -- 存按钮
    ["btn_take"]     = {["varname"] = "btn_take",    ["events"] = {{event = "click", method = "onClickTake"}}},             -- 取按钮
    ["btn_close"]    = {["varname"] = "btn_close",   ["events"] = {{event = "click_color", method = "onClickClose"}}},            -- 关闭按钮
}

-- 豆豆整存整取的基数
local BASE_MONEY_COUNT = 30000

function BagMainView:onCreate()
    -- 适配
    self:setScale(math.min(display.scaleX, display.scaleY))
    -- 初始化
    self:init()
    -- 初始化View
    self:initView()
    -- 开关检测
    self:checkSwitch()
    -- 更新背包钱数据
    self:updateData()
    -- 更新道具数据
    self:updatePropList()
    -- 注册消息通知
    self:registerEventListener()
end

function BagMainView:init()
    self._propListView = {}         -- 道具试图列表
    self._saveMoney = 0             -- 存钱数
    self._takeMoney = 0             -- 取钱数
    self._propInfoBox = nil         -- 道具信息框
    self._eb_q_input = nil          -- 取钱输入框
    self._eb_c_input = nil          -- 存钱输入框
    -- 这里 clone 一份是因为开关检查的时候会修改 PropDef 中的数据
    self._propDef  = gg.GetPropList()
    -- 是否开启整存整取开关
    self._CloseLumpSum = GameApp:CheckModuleEnable(ModuleTag.CloseLumpSum)

    self._cqMoney = 0               -- 用于存取的数
end

--[[
* @brief 开关检测
]]
function BagMainView:checkSwitch()
    -- 联系客服
    if not GameApp:CheckModuleEnable(ModuleTag.CustomerService) then
        self.btn_service:setVisible(false)
    end
    -- 道具（元宝）
    if not GameApp:CheckModuleEnable(ModuleTag[PROP_ID_LOTTERY]) then
        self._propDef[PROP_ID_LOTTERY].switch = true
    end
    -- 道具（话费）
    if not GameApp:CheckModuleEnable(ModuleTag[PROP_ID_PHONE_CARD]) then
        self._propDef[PROP_ID_PHONE_CARD].switch = true
        self._propDef[PROP_ID_263].switch = true
    end
    -- 道具（红包）
    if not GameApp:CheckModuleEnable(ModuleTag[PROP_ID_261]) then
        self._propDef[PROP_ID_261].switch = true
    end
     -- 道具（海底捞月）
    if not GameApp:CheckModuleEnable(ModuleTag.HaiDiLaoYue)then
        self._propDef[PROP_ID_HAIDILAOYUE].switch = true
    end

    -- 道具（房卡）
    if not GameApp:CheckModuleEnable(ModuleTag[PROP_ID_ROOM_CARD]) then
        self._propDef[PROP_ID_ROOM_CARD].switch = true
    end

    -- 道具（翻倍卡）
    if not GameApp:CheckModuleEnable(ModuleTag[PROP_ID_FANBEIKA]) then
        self._propDef[PROP_ID_FANBEIKA].switch = true
    end

    -- 屏蔽即时红包卡的显示
    self._propDef[PROP_ID_262].switch = true
    -- 不在背包中显示抽奖卡
    self._propDef[PROP_ID_LOTTERY_CARD].switch = true
    -- 不在背包中显示钻石
    self._propDef[PROP_ID_XZMONEY].switch = true
end

--[[
* @brief 初始化View
]]
function BagMainView:initView()
    -- 注册存取滑块滑动事件
    self.slider_cq:addEventListener(handler(self, self.onSliderMoveEvent))
    -- 单包存取功能不可操作
    if GameApp:IsCommonGame() then
        self.btn_save:setTouchEnabled(false)
        self.btn_save:setAllGray(true)

        self.btn_take:setTouchEnabled(false)
        self.btn_take:setAllGray(true)

        self.btn_add:setTouchEnabled(false)
        self.btn_add:setAllGray(true)

        self.btn_minus:setTouchEnabled(false)
        self.btn_minus:setAllGray(true)

        self.cnt_bg:setAllGray(true)

        self.slider_cq:setTouchEnabled(false)
        if hallmanager and checkint(hallmanager.userinfo.bankmoney) > 0 then
            -- 把已有的钱全部取出来
            hallmanager:ExchangeMoney(hallmanager.userinfo.bankmoney, false, "")
        end
    end

    -- 设置整存整取最低数额提示
    if not GameApp:IsCommonGame() and not self._CloseLumpSum then
        local baseCnt = self:getBaseMoneyCount()
        self.txt_tips:setString(string.format("*豆豆需%s整存整取", String:numToZn(baseCnt, 4, 0)))
        self.txt_tips:setVisible(true)
    end
end

--[[
* @brief 注册消息通知
]]
function BagMainView:registerEventListener()
    -- 存取应答通知
    self:addEventListener(gg.Event.HALL_EXCHANGE_MONEY_REPLY, handler(self, self.onEventExchangeMoney))
    -- 刷新道具
    self:addEventListener(gg.Event.HALL_UPDATE_USER_DATA, handler(self, self.onEventUpdateUserData))
    -- 刷新记牌器道具
    self:addEventListener(gg.Event.HALL_WEB_INIT, handler(self, self.updateJiPaiqiData))
end
--[[
* @brief 更新背包记牌器数据
]]
function BagMainView:updateJiPaiqiData()
    self:onEventUpdateUserData(nil,PROP_ID_JIPAI,nil)
end

--[[
* @brief 更新背包数据
]]
function BagMainView:updateData()
    if not hallmanager then return end
    local userInfo = hallmanager.userinfo
    if not userInfo then return end
    -- 设置背包钱数和银行钱数
    self.txt_mn_xd:setString(userInfo.money)
    self.txt_mn_bg:setString(userInfo.bankmoney)
end

--[[
* @brief 获取道具（特殊道具处理）
]]
function BagMainView:GetPropList()
    if not hallmanager then return end
    local propList = checktable(hallmanager.proplist)
    local userInfo = hallmanager.userinfo
    local tempProp = {}

    -- 添加所有可能出现的道具
    for k , v in pairs(self._propDef) do
        for i , j in pairs(checktable(propList)) do
            -- 筛选出配置和用户数据同时存在的道具
            if i == k then
                tempProp[ i ] = j
            end
        end
        -- 元宝
        if k == PROP_ID_LOTTERY then
            tempProp[ k ] = userInfo.lottery
        end
        --记牌器
        if k == PROP_ID_JIPAI then
            --记牌器的在使用中需要显示
           if gg.UserData:getCardHolder() ~= 0 then
                tempProp[ k ] = propList[ k ] or 0
            end
        end

        -- 为0显示的
        if v.zeroshow == true then
            if k ~= PROP_ID_LOTTERY then
                tempProp[ k ] = propList[ k ] or 0
            end
        end
    end

    -- 排除不符合条件的道具
    for k , v in pairs( tempProp ) do
        -- 排除审核不显示的
        if IS_REVIEW_MODE and self._propDef[k].reviewshow == false then
            tempProp[k] = nil
        end
        -- 排除为零不显示的
        if v == 0 and self._propDef[k].zeroshow ~= true then
            tempProp[k] = nil
        end
        -- 排除开关打开的
        if self._propDef[k].switch == true then
            tempProp[k] = nil
        end
        -- 不排除记牌器为零但是使用中的
        if k == PROP_ID_JIPAI and gg.UserData:getCardHolder() ~= 0   then
            tempProp[k] = tempProp[k] or 0
        end
    end

    -- 道具排序
    local orderProp = {}
    for k , v in pairs( tempProp ) do
        table.insert( orderProp , { k , v } )
    end

    table.sort( orderProp , function( a , b )
        return ( self._propDef[ a[1] ].sort or 0 ) > ( self._propDef[ b[1] ].sort or 0)
    end )

    return tempProp , orderProp
end

--[[
* @brief 刷新道具ListView
* @parameter propList 道具列表
]]
function BagMainView:updatePropList()
    -- 重新构造列表
    self:clearPropItem()
    if not hallmanager then return end
    -- 道具列表信息
    local propList , order = self:GetPropList()
    local userInfo = hallmanager.userinfo
    if not propList and not userInfo then return end

    -- 找到道具对应视图
    for i = 1 , #order do
        local p = order[i]
        local propItem = self:createPropItem( p[1], p[2])
        self.panel_l:addChild( propItem )
        -- 加入视图列表
        table.insert( self._propListView , propItem )
    end

    -- 刷新位置
    self:updateAllPropItemPosition()
end

--[[
* @brief 根据ID获取道具试图
* @param id 道具试图ID
]]
function BagMainView:getPropItem( id )
    for i = 1 , #self._propListView do
        if self._propListView[i]:getChildByName("img_icon"):getTag() == id then
            return self._propListView[i] , i
        end
    end
    return nil
end

--[[
* @brief 创建道具Item
* @parameter prop 道具信息
]]
function BagMainView:createPropItem( id , propCount )
    if propCount == nil then return end
    local propNode = require("ui/bag/bag_item_node.lua").create()
    local root = propNode.root

    self:setPropItemViewData( root , id, propCount  )
    -- 注册点击事件
    local img_icon = root:getChildByName("img_icon")
    img_icon:onClick(handler(self,self.onClickProp))
    img_icon:setTag( id )

    return root
end

--[[
* @brief 刷新PropItemView数据
* @parameter prop 道具信息
]]
function BagMainView:setPropItemViewData(  propItemView, id, propCount )
    if not propItemView and not propCount then return end
    -- 刷新坐标
    self:updateAllPropItemPosition()
    local img_icon = propItemView:getChildByName("img_icon")
    local txt_count = propItemView:getChildByName("txt_count")
    -- 获取道具资源配置
    local propDef = self._propDef[ id ]
    if not propDef then return end

    img_icon:loadTexture( propDef.icon )
    img_icon:ignoreContentAdaptWithSize(true)
    img_icon:setScale(95 / math.max(img_icon:getContentSize().width, img_icon:getContentSize().height))
    -- 设置道具数量和单位
    local countStr = propCount * ( self._propDef[id].proportion or 1 ) .. (self._propDef[id].unit or "")
    if id == PROP_ID_261 or id == PROP_ID_PHONE_CARD  or id == PROP_ID_263 or id == PROP_ID_262 then
        countStr = string.format( "x%.2f", propCount * ( self._propDef[id].proportion or 1 ))
    end

    --记牌器
    txt_count:setString( countStr )

    --要是记牌器已经使用的话,背包里面要显示剩余的图标,否则不显示
    self:isShowImgTimer(id, propItemView,txt_count)
end

--[[
* @brief 清空PropItemView
]]
function BagMainView:clearPropItem()
    for k , v in pairs(self._propListView) do
        v:removeFromParent(true )
    end
    self._propListView = {}
end

--[[
* @brief 更新所有道具Item位置
]]
function BagMainView:updateAllPropItemPosition()
    for k , v in pairs( self._propListView ) do
        local x, y = self:getPropAddPosition( k - 1 )
        v:setPosition(x, y)
    end
end

--[[
* @brief 根据道具ID获取道具所在列数
* @parm index 位置索引,从零开始
]]
function BagMainView:getPropRowCountByID( id )
    -- 根据ID获取索引
    local item , index = self:getPropItem(id)
    local cell_h_count = 4      -- 格子横向数
    return math.floor( ( index - 1 )   % cell_h_count)
end

--[[
* @brief 根据图标列数获取道具描述框位置
* @parm rowCount
]]
function BagMainView:getPropInfoBoxXByRowCount( rowCount )
    local x = 0
    if rowCount == 0 then
        x = display.width * 0.33
    elseif rowCount == 1 then
        x = display.width * 0.423
    elseif rowCount == 2 then
        x = display.width * 0.518
    elseif rowCount == 3 then
        x = display.width * 0.612
    end
    return x
end

--[[
* @brief 获取当前道具应添加的坐标
* @parm index 位置索引,从零开始
]]
function BagMainView:getPropAddPosition( index )
    local propItemCount = index -- gg.TableSize( self._propListView   )
    local cell_h_count = 4      -- 格子横向数
    local cell_v_count = 5      -- 格子纵向数
    -- 格子背景总大小
    local cellCountSize = self.panel_l:getContentSize()
    -- 计算出每个格子的宽高
    local cellW = 107
    local cellH = 107
    -- 总格子数
    local allCellCount = cell_h_count * cell_v_count
    -- 反向格子起始索引
    local startIndex = allCellCount - propItemCount
    -- 计算道具应放的行列
    local tempX =  math.floor(propItemCount % cell_h_count)
    local tempY =  math.floor((startIndex - 1) / cell_h_count)
    -- 计算x
    local x = 0
    x = 54 + tempX * 112
    -- 计算y
    local y = 0
    y = 54 + tempY * 112

    return x , y
end

-- 判断是否是快速点击
function BagMainView:isFastClick( sender )
    local curClickTime = socket.gettime()
    local spaceTime = 0.5
    local isFastClick = false
    if sender._lastClickTime and (curClickTime - sender._lastClickTime < spaceTime) then
        printf("快速点击")
        isFastClick = true
    end
    sender._lastClickTime = curClickTime
    return isFastClick
end

--[[
* @brief 关闭按钮
]]
function BagMainView:onClickClose( sender )
    self:removeSelf()
end

--[[
* @brief 道具点击事件
]]
function BagMainView:onClickProp( sender )
    self:showPropInfoBox( sender:getTag() )
end

--[[
* @brief 存取应答通知
]]
function BagMainView:onEventExchangeMoney( event , result )
    -- 成功
    if result == 0 then
        -- 刷新背包钱数据
        self:updateData()
        self._cqMoney = 0
        self.slider_cq:setPercent(0)
        self.cnt_bg:setPositionX(0)
        self.txt_bean_cnt:setString(0)
    end
end

--[[
* @brief 刷新用户数据
]]
function BagMainView:onEventUpdateUserData( userinfo,propid,propvalue )
    -- 更新道具
    if propid then
        -- 更新道具数据
        self:updatePropList()
    end
    -- 更新背包钱数据
    self:updateData()
end

--[[
* @brief 显示道具信息框
]]
function BagMainView:showPropInfoBox( propId )
    -- 获取道具配置
    local propDef = self._propDef[propId]
    local propList = self:GetPropList()

    if not propDef then return end
    -- 道具配置UI文件
    local uiPath = propDef.ui or "ui/bag/prop_ui/prop_info_node.lua"
    local root = require(uiPath).create().root
    self._propInfoBox = root

    -- 获取道具位置
    local rowCount = self:getPropRowCountByID( propId )
    root:setPosition( cc.p( self:getPropInfoBoxXByRowCount(rowCount) , display.height / 2  )  )
    self:addChild( root )

    -- 背景用于获取节点
    local img_bg = root:getChildByName( "img_bg" )

    -- 道具名称
    local txt_name = img_bg:getChildByName( "txt_name" )
    if txt_name then
        txt_name:setString( propDef.name or "" )
    end

    -- 计算数量的显示位置
    local titleCount = img_bg:getChildByName( "txt_title_count" )
    local cPosX = 0
    if titleCount then
        local titlePosX = titleCount:getPositionX()
        cPosX = titlePosX + (1 - titleCount:getAnchorPoint().x) * titleCount:getContentSize().width + 10
    end

    -- 道具icon
    local img_prop_icon = img_bg:getChildByName( "img_prop_icon" )
    if img_prop_icon then
        img_prop_icon:ignoreContentAdaptWithSize(true)
        img_prop_icon:loadTexture(propDef.icon or "" )
        img_prop_icon:setScale(100 / math.max(img_prop_icon:getContentSize().width, img_prop_icon:getContentSize().height))
    end

    -- 道具数量
    local txt_count = img_bg:getChildByName("txt_count")
    if txt_count then
        local countStr = propList[propId] * ( propDef.proportion or 1 )
        if propId == PROP_ID_261 or propId == PROP_ID_PHONE_CARD or propId == PROP_ID_263 or propId == PROP_ID_262 then
            countStr = string.format( "%.2f", countStr)
        end
        txt_count:setString( countStr )

        if cPosX > 0 then
            -- 需要动态计算数量的显示位置
            txt_count:setPositionX(cPosX + txt_count:getContentSize().width * txt_count:getAnchorPoint().x)
            cPosX = cPosX + txt_count:getContentSize().width + 10
        end
    end

    -- 物品描述
    local txt_describe = img_bg:getChildByName( "txt_describe" )
    if txt_describe then
        txt_describe:setString( propDef.des or "" )
        -- 微乐房卡描述需要调整为与视频相关
        if IS_WEILE and propId == PROP_ID_ROOM_CARD then
            txt_describe:setString("可以在朋友场开启视频，与好友\n实时互动。")
        end
    end

    -- 物品来源
    local txt_source = img_bg:getChildByName( "txt_source" )
    if txt_source then
        txt_source:setString( propDef.source or "" )
    end

    -- 单位
    local txt_prop_u = img_bg:getChildByName( "txt_prop_u" )
    if txt_prop_u then
        txt_prop_u:setString( propDef.unit or "个" )

        if cPosX > 0 then
            -- 需要动态计算单位的显示位置
            txt_prop_u:setPositionX(cPosX + txt_prop_u:getContentSize().width * txt_prop_u:getAnchorPoint().x)
        end
    end

    -- 背景事件注册
    local panel_bg = root:getChildByName( "panel_bg" )
    local function onClickBg( sender , eventType )
        if eventType == ccui.TouchEventType.ended then
            -- 销毁自己
            root:removeFromParent(true)
        end
    end

    if panel_bg then
        panel_bg:addTouchEventListener( onClickBg )
    end

    --功能按钮(记牌器)
    local event = (propId == PROP_ID_JIPAI) and self:isCardUser(img_bg) or propDef.event

    if event then
        local index = 0
        for k , v in pairs(event) do
            local btn = img_bg:getChildByTag( 1000 + index )
            if btn then
                btn.event = v
                -- 查找是否配置按钮名字
                local args = string.split(v, ":")
                if #args > 1 then
                    local txt = btn:getChildByName("txt")
                    if txt then
                        txt:setString( args[2] )
                    end
                    btn.event = args[1]
                end

                btn:onClickScaleEffect( function( sender )
                    local e = sender.event
                    if e then
                        -- 执行的命令或通知
                        local sub = string.sub( e , 1 , 2 )
                        if sub == "//" then
                            -- 命令
                            self:ExecutiveCommand( propId , e )
                        else
                            -- 通知
                            GameApp:dispatchEvent(e, propId )
                        end
                    end

                    -- 关闭
                    root:removeFromParent(true)
                end )
            end
            index = index + 1
        end

        -- 在按钮上显示敬请期待标志
        if propDef.develop then
            local btn = img_bg:getChildByTag(999 + #event)
            if btn then
                btn:setTouchEnabled(false)
                btn:setAllGray(true)
                self:addDevelopLogo(btn)
            end
        end
    end
end

--记牌器的特殊处理,判断是使用还是购买
function BagMainView:isCardUser(node)
    local titleCount = node:getChildByName( "txt_title_count" )
    local img_jpqtime = node:getChildByName("img_jpqtime")
    local txt_count = node:getChildByName( "txt_count")
    local txt_prop_u = node:getChildByName("txt_prop_u")
    -- 道具列表信息
    local propList, order = self:GetPropList()
    local propDef = self._propDef[ PROP_ID_JIPAI ]
    if  gg.UserData:getCardHolder() ~= 0 and propList[PROP_ID_JIPAI] > 0 then
        titleCount:setString("剩余")
        img_jpqtime:setVisible(true)
        local time_count = img_jpqtime:getChildByName("txt_time")
        time_count:setString(string.format( "%d%s",self.skycount,propDef.unit))
    elseif gg.UserData:getCardHolder() ~= 0 and propList[PROP_ID_JIPAI] == 0 then
        titleCount:setVisible(false)
        txt_prop_u:setVisible(false)
        txt_count:setVisible(false)
        img_jpqtime:setVisible(true)
        local time_count = img_jpqtime:getChildByName("txt_time")
        time_count:setString(string.format( "%d%s",self.skycount,propDef.unit))
        img_jpqtime:setPositionY(titleCount:getPositionY())
    end

    --记牌器使用的状态
    if propList[PROP_ID_JIPAI] > 0 then
        return  { "//UserJiPaiAllProp:使用"}
    else
        return  { "//OpenMall:购买" }
    end
end

function BagMainView:isShowImgTimer(id, propItemView,txtCount)
    --要是记牌器已经使用的话,背包里面要显示剩余的图标,否则不显示
    if id ~= PROP_ID_JIPAI then return end
    local panel_jpq = propItemView:getChildByName("panel_jpq")
    local img_jpq1 = propItemView:getChildByName("img_jpq1")
    local txt_jpq_count = panel_jpq:getChildByName("txt_jpq_count")
    local propList, order = self:GetPropList()
    --玩家使用系统赠送的记牌器 并且 自己本身也有记牌器
    if gg.UserData:getCardHolder() == 0 then return end
    local curtime = gg.UserData:getCardHolder() -os.time()
    self.skycount = math.ceil( curtime/ ( 3600 * 24 ) )
    local propDef = self._propDef[ id ]
    if gg.UserData:getCardHolder() ~=0 and propList[PROP_ID_JIPAI] > 0 then
        panel_jpq:setVisible(true)
        txt_jpq_count:setString(string.format( "%d%s",self.skycount,propDef.unit) )
    --玩家本身没有记牌器只有系统赠送的记牌器
    elseif gg.UserData:getCardHolder() ~=0 and propList[PROP_ID_JIPAI] == 0  then
        img_jpq1:setVisible(true)
        txtCount:setString(string.format( "%d%s",self.skycount,propDef.unit) )
        img_jpq1:setPosition(txtCount:getPositionX()- txtCount:getContentSize().width - 15,txtCount:getPositionY() )
    end
end

-- 添加敬请期待标志
function BagMainView:addDevelopLogo(node)
    local imgLogo = ccui.ImageView:create()
    imgLogo:loadTexture("hall/bag/img_jqqd.png", 1)
    imgLogo:setPosition(cc.p(node:getContentSize().width - 60, node:getContentSize().height + 18))
    node:addChild(imgLogo)
end

--[[
* @brief 执行命令
* @param propId 道具ID
* @param cd 命令
]]
function BagMainView:ExecutiveCommand( propId , cd )
    -- 命令验证
    if not cd and type(cd) ~= "string" and string.find( cd , 1 , 2 ) ~= "//"  then
        print( "配置命令不正确！" )
        return
    end

    -- 获取要执行的操作
    local command = string.sub( cd , 3 , #cd )

    if "OpenHF" == command then
        -- 打开话费兑换界面
        self:getScene():createView("gift.GiftView","huafei",PROP_ID_PHONE_CARD):pushInScene()
    elseif "OpenHB" == command then
        -- 打开红包领取界面
        self:getScene():createView("gift.GiftView","hongbao",PROP_ID_261):pushInScene()
    elseif "OpenHBDH" == command then
         -- 打开红包卡兑换界面
        local reddata = require("hall.models.StoreData"):GetDouInfoByGoodsID("goods50") --获取红包数据
        self:getScene():createView("store.ExchangeView" , reddata):addTo(self)
    elseif "OpenJSHF" == command then
        -- 打开即时话费兑换界面
        self:getScene():createView("gift.GiftView","huafei",PROP_ID_263):pushInScene()
    elseif "OpenJSHB" == command then
        -- 打开即时红包领取界面
        self:getScene():createView("gift.GiftView","hongbao",PROP_ID_262):pushInScene()
    elseif "OpenCJ" == command then
        self:getScene():createView("luckybag.LottoView"):addTo(self)
    elseif "OpenMall" == command then
        -- 打开商城
        GameApp:DoShell( self:getScene(), "Store://prop")
    elseif "OpenExchange" == command then
        -- 元宝兑换商城
        self:getScene():createView("gift.GiftView","lipin"):pushInScene()
    elseif "OpenYBCJ" == command then
        -- 元宝抽奖界面
        self:getScene():createView("luckybag.LottoView", nil, PROP_ID_LOTTERY):addTo(self)
    elseif "OpenSYGMK" == command then
        -- 使用改名卡
    elseif "UseProp" == command then
        -- 道具（荣誉卡）
        if  not GameApp:CheckModuleEnable(ModuleTag.Arena) and propId == cc.exports.PROP_ID_LEITAIKA then
            GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "即将开放，敬请期待！")
            return
        end
        -- 使用道具
        if hallmanager then
            local userID = gg.UserData:GetUserId()
            hallmanager:DoUseProp(userID, propId)
        end
    elseif "UseAllProp" == command then
        -- 道具（荣誉卡）
        if  not GameApp:CheckModuleEnable(ModuleTag.Arena) and propId == cc.exports.PROP_ID_LEITAIKA then
            GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "即将开放，敬请期待！")
            return
        end
        -- 使用道具
        if hallmanager then
            local userID = gg.UserData:GetUserId()
            local cnt = checkint(checktable(hallmanager.proplist)[propId])
            hallmanager:DoUseProp(userID, propId, cnt)
        end
    elseif  "UserJiPaiAllProp" == command then
        GameApp:DoShell(self:getScene(), "UseJiPaiQi://")
    end
end

--[[
* @brief 关闭道具信息框
]]
function BagMainView:hidePropInfoBox()
    if self._propInfoBox then
        self._propInfoBox:removeFromParent(true)
        self._propInfoBox = nil
    end
end

--[[
* @brief 判断道具是否是话费卡
* @parameter propId 道具id
]]
function BagMainView:isPhoneCard( propId )
    if propId == PROP_ID_PHONE_CARD or propId == PROP_ID_HUA_FEI_20 or propId == PROP_ID_HUA_FEI_50 or propId == PROP_ID_HUA_FEI_100 or propId == PROP_ID_263 then
        return true
    end
    return false
end

--[[
* @brief 联系客服
]]
function BagMainView:onClickService( sender )
   device.callCustomerServiceApi(ModuleTag.Bag)
end

------------------------------------------------------------
-- 存取
------------------------------------------------------------
-- 百分比计算
function BagMainView:percentCalculate( c , t )
    return c / t * 100
end

-- 获取整存整取的数值
function BagMainView:getBaseMoneyCount()
    local ret = checkint(BANK_STEP)
    if ret <= 0 then
        ret = BASE_MONEY_COUNT
    end
    return ret
end

function BagMainView:checkMoney(money, ownMoney, isSave)
    local baseCount = self:getBaseMoneyCount()
    if isSave then
        -- 存
        if ownMoney < baseCount then
            -- 存的数量不能小于整存基数
            return 0
        end
        return math.floor( money / baseCount ) * baseCount
    else
        -- 取
        if ownMoney < baseCount then
            return ownMoney
        else
            return math.floor( money / baseCount ) * baseCount
        end
    end
end

function BagMainView:onSliderMoveEvent(sender, eventType)
    if eventType == ccui.SliderEventType.percentChanged then
        -- 滑动条百分比
        local percent = sender:getPercent() / 100
        -- 百分比钱数
        if hallmanager then
            local userInfo = hallmanager.userinfo
            local maxNum = math.max(userInfo.money, userInfo.bankmoney)
            local moneyPercent = maxNum * percent

            local baseCnt = 10000
            if not self._CloseLumpSum then
                baseCnt = self:getBaseMoneyCount()
            end

            if maxNum >= baseCnt then
                self._cqMoney = math.floor(moneyPercent / baseCnt) * baseCnt
            else
                self._cqMoney = math.floor(moneyPercent)
            end
            -- 设置存取数量的显示和位置
            self.cnt_bg:setPositionX(sender:getContentSize().width * percent)
            self.txt_bean_cnt:setString(string.format("%d", self._cqMoney))
        end
    end
end

--[[
* @brief 存按钮
]]
function BagMainView:onClickSave(sender)
    if self:isFastClick(sender) then return end
    if not hallmanager then return end
    local userinfo = hallmanager.userinfo
    local baseCnt = self:getBaseMoneyCount()
    local cqMoney = 0
    if not self._CloseLumpSum then
        -- 开启了整存整取功能
        cqMoney = self:checkMoney(self._cqMoney, userinfo.money, true)
        if cqMoney < baseCnt then
            if checkint(self:getScene()._toastCount) == 0 then
                GameApp:dispatchEvent(gg.Event.SHOW_TOAST, string.format("豆豆需%s整存整取", gg.MoneyUnit(baseCnt)))
            end
            return
        end
    else
        cqMoney = self._cqMoney
    end

    -- 如果用户选择存入的钱数大于用户的钱数，则默认取最大值存入
    if cqMoney > userinfo.money then
        cqMoney = math.floor(userinfo.money / baseCnt) * baseCnt
    end
    if cqMoney <= 0 then return end
    self._cqMoney = cqMoney

    -- 发送存钱消息
    hallmanager:ExchangeMoney(self._cqMoney, true, "")
end

--[[
* @brief 取按钮
]]
function BagMainView:onClickTake(sender)
    if self:isFastClick(sender) then return end
    if not hallmanager then return end
    local userinfo = hallmanager.userinfo
    local baseCnt = self:getBaseMoneyCount()
    local cqMoney = 0
    if not self._CloseLumpSum then
        -- 开启了整存整取功能
        cqMoney = self:checkMoney(self._cqMoney, userinfo.bankmoney, false)
        if cqMoney < baseCnt and userinfo.bankmoney >= baseCnt then
            if checkint(self:getScene()._toastCount) == 0 then
                GameApp:dispatchEvent(gg.Event.SHOW_TOAST, string.format("豆豆需%s整存整取", gg.MoneyUnit(baseCnt)))
            end
            return
        end
    else
        cqMoney = self._cqMoney
    end

    -- 如果用户选择取出的钱数大于用户的钱数，则默认取最大值取出
    if cqMoney > userinfo.bankmoney then
        cqMoney = math.floor(userinfo.bankmoney / baseCnt) * baseCnt
    end
    if cqMoney <= 0 then return end
    self._cqMoney = cqMoney
    -- 发送取钱消息
    hallmanager:ExchangeMoney(self._cqMoney, false, "")
end

--[[
* @brief 修改存取钱数点击事件
]]
function BagMainView:onClickChangeMoney(sender)
    local wigth = sender:getName()
    if wigth == "btn_add" then
        self:updatePercent(true)
    elseif wigth == "btn_minus" then
        self:updatePercent(false)
    end
end

--[[
* @brief 根据存储钱数刷新进度和显示存储金额
* @parm isAdd 是否是加
]]
function BagMainView:updatePercent(isAdd)
    -- 基数
    local degree = 10000
    if not self._CloseLumpSum then
        -- 开启了整存整取功能
        degree = self:getBaseMoneyCount()
    end
    -- 玩家信息
    local userInfo = hallmanager.userinfo
    local maxNum = math.max(userInfo.money, userInfo.bankmoney)
    -- 临时计算值
    local temp = 0

    if isAdd then
        temp = self._cqMoney + degree
        if temp > maxNum then return end
    else
        temp = self._cqMoney - degree
        if temp < 0 then return end
    end

    self._cqMoney = temp
    -- 设置存取数量的显示和位置
    local percent = self:percentCalculate(self._cqMoney, maxNum)
    self.slider_cq:setPercent(percent)
    self.cnt_bg:setPositionX(self.slider_cq:getContentSize().width * percent / 100)
    self.txt_bean_cnt:setString(string.format("%d", self._cqMoney))
end

return BagMainView
