
-- Author: zhaoxinyu
-- Date: 2016-10-23 16:14:24
-- Describe：添加游戏层

local AddGameView = class("SettingView", cc.load("ViewPop"))
AddGameView.RESOURCE_FILENAME="ui/add_game/add_game_node_n.lua"

AddGameView.RESOURCE_BINDING = {

    ["sv_addgame"] = {["varname"] = "sv_addgame"},                -- 添加游戏层
    ["txt_province"] = {["varname"] = "txt_province"},  -- 省名称
    ["txt_switch"] = {["varname"] = "txt_switch"},      -- 切换文字
    ["btn_switch"] = { ["varname"] = "btn_switch", ["events"]={{event="click", method="switchArea"}} }, -- 切换地区
    ["btn_kefu"] = { ["varname"] = "btn_kefu", ["events"]={{event="click", method="onClickService"}} }, -- 客服
    ["btn_close"] = { ["varname"] = "btn_close", ["events"]={{event="click", method="onEventSelectArea"}} }, -- 关闭

}

AddGameView.ADD_BLUR_BG = true

local ITEM_HEIGHT = 112
local ITEM_MARGIN = 30

-- idx 1-只显示麻将类游戏, 2-只显示扑克类游戏, 3-扑克类和麻将类游戏都显示
function AddGameView:onCreate(idx)
    self.clickType  = idx or 1

    -- 初始化View
    self:initView()
    -- 注册事件
    self:registerEventListener()
    --自适应
    self:setScale(math.min(display.scaleX, display.scaleY))
    if not GameApp:CheckModuleEnable( ModuleTag.CustomerService ) then
        self.btn_kefu:setVisible(false)
    end
end


--[[
* @brief 初始化View
]]
function AddGameView:initView()


    -- 隐藏滚动Bar
    self.sv_addgame:setScrollBarEnabled(false)

    self.sv_addgame:setVisible(true)

    -- 调整切换地区按钮
    self:adjustSwitchBtn()

    if not hallmanager then
        return
    end

    -- 读取本地配置或者过滤服务器的
    local canAddGame = hallmanager:filterHideGames(hallmanager:GetCanAddGameConfigGame())

    local addGame = {}
    for k , v in pairs( canAddGame ) do
        if self.clickType == 3 and (Helper.And( v.type , GAME_GROUP_POKER ) ~= 0 or Helper.And( v.type , GAME_GROUP_MAHJONG ) ~= 0) then
            table.insert( addGame , v )
        elseif Helper.And( v.type , GAME_GROUP_POKER ) ~= 0 and self.clickType == 2 then
            -- 扑克
            table.insert( addGame , v )
        elseif Helper.And( v.type , GAME_GROUP_MAHJONG ) ~= 0  and self.clickType == 1 then
            -- 麻将
            table.insert( addGame , v )
        end
    end

    -- 扑克和麻将都显示时，扑克类游戏排在前面
    if self.clickType == 3 then
        table.sort(addGame, function(a, b)
            local tmp1 = gg.IIF(Helper.And(a.type , GAME_GROUP_POKER) ~= 0, 1, 0)
            local tmp2 = gg.IIF(Helper.And(b.type , GAME_GROUP_POKER) ~= 0, 1, 0)
            return tmp1 > tmp2
        end)
    end

    -- 设置滚动容器滚动区域纵向高
    local svH = self.sv_addgame:getContentSize().height
    local svW = self.sv_addgame:getContentSize().width
    -- 每行元素数
    local he = math.floor( svW /  372 )

    -- 麻将需要高度
    local mjn = math.ceil( #addGame /  he  ) * ( ITEM_HEIGHT + ITEM_MARGIN )

    -- 容器高
    local addSvH = gg.IIF( mjn < svH , svH ,mjn )

    self.sv_addgame:setInnerContainerSize( cc.size( svW , addSvH )  )

    -- 游戏
    for k , v in pairs(addGame) do

        -- 是否添加
        local isAdd = hallmanager:IsGameAdded( v.id )
        local addItem = self:createAddItem( v , isAdd )
        self.sv_addgame:addChild( addItem )
        local x , y = self:GetItemPox( addItem , addSvH)
        addItem:setPosition( cc.p( x , y ) )
    end
end

function AddGameView:registerEventListener()
    -- 选择地区通知
    self:addEventListener( gg.Event.HALL_SELECT_AREA , handler(self,self.onEventSelectArea ) )
end

function AddGameView:adjustSwitchBtn()
    if REGION_CODE ~= 0 then
        -- 地区产品不能切换地区
        self.btn_switch:setVisible(false)
        return
    end

    -- 家乡棋牌产品可以切换地区
    local areaConfig = GameApp:getAreaConfig()
    local userRegion = gg.LocalConfig:GetRegionCode()
    local areaCode = tonumber(string.sub(tostring(userRegion), 1, 2))
    local areaName = checkstring(areaConfig[areaCode])
    self.txt_province:setString(areaName)
    local provinceSize = self.txt_province:getContentSize()
    local txtSwitchSize = self.txt_province:getContentSize()
    local btnSize = self.btn_switch:getContentSize()
    self.btn_switch:setContentSize(cc.size(provinceSize.width + txtSwitchSize.width + 25, btnSize.height))
    self.txt_province:setPosition(cc.p(provinceSize.width + 10, btnSize.height / 2))
    self.txt_switch:setPosition(cc.p(provinceSize.width + 15, btnSize.height / 2))
end

-- function AddGameView:onClickClose()
--     if self.frushFun then
--         self.frushFun()
--     end
--     self:removeSelf()
-- end

local function dispatchRemoveEvent_(listeners)
    for _, callback in ipairs(listeners) do
        callback()
    end
end
function AddGameView:removeSelf()
    --刷新添加的游戏
    GameApp:dispatchEvent(gg.Event.ADDED_GAME_CHANGED)

    if not tolua.isnull(self) then
        dispatchRemoveEvent_(self.onRemoveListeners_)
        self:removeFromParent()
        return true
    end
    return false
end
--[[
* @brief 创建添加项
* @param game 游戏
* @param isAdd 是否添加
]]
function AddGameView:createAddItem( game , isAdd )

    -- 创建
    local uiPath = "ui/add_game/add_game_item.lua"
    local root = require(uiPath).create().root
    local img_bg = root:getChildByName("img_bg")
    img_bg:removeFromParent(true)
    img_bg:setTag( game.id )

    -- 选择框背景
    local img_select_bg = img_bg:getChildByName("img_select_bg")
    local img_nick = img_select_bg:getChildByName( "img_nike" )
    local txt_gname = img_bg:getChildByName("txt_gname")
    txt_gname:setString( game.name )
    if #game.name >= 5 then
        txt_gname:setFontSize(35)
    end

    -- 状态选择
    local function setStatus( isSelect )

        if isSelect then

            img_select_bg:loadTexture("hall/addgame/pic_ring_0.png", 1)
            img_bg:loadTexture("hall/addgame/pic_bg_0.png", 1)
            img_nick:setVisible( true )
            txt_gname:setTextColor( { r = 16, g = 145, b = 61 } )
        else

            img_select_bg:loadTexture("hall/addgame/pic_ring_1.png", 1)
            img_bg:loadTexture("hall/addgame/pic_bg_1.png", 1)
            img_nick:setVisible( false )
            txt_gname:setTextColor( { r = 88, g = 77, b = 68 } )
        end
    end

    -- 设置状态
    setStatus(isAdd)

    -- 添加事件
    img_bg:onClickScaleEffect( function( sender )

            if not hallmanager then
                return
            end

            -- 是否添加
            local isAdd = hallmanager:IsGameAdded( sender:getTag() )

            -- 设置状态
            setStatus(not isAdd)

            -- 添加游戏
            hallmanager:AddGameApp( sender:getTag() , not isAdd )
        end)

    return img_bg
end

--[[
* @brief 计算item位置
* @param item
* @param isPuKe 是否是扑克
* @return x , y
]]
function AddGameView:GetItemPox( item , svH )

    local sw = self.sv_addgame

    -- item宽
    local itemW = item:getContentSize().width
    -- item高
    local itemH = item:getContentSize().height
    -- 容器宽
    local svW = sw:getContentSize().width
    -- 每行元素数
    local he = math.floor( svW / itemW )
    -- 横向间距
    local vs = math.floor( ( svW - ( he * itemW ) ) / ( he - 1 ) )
    -- 当前容器中的元素数
    local eCount = sw:getChildrenCount() - 1

    -- 当前新元素添加的x位置
    local xP = ( eCount ) % he
    -- 当前新元素添加的y位置
    local yp = math.ceil( ( eCount + 1 ) / he )

    local x = ( xP ) * ( vs + itemW ) + itemW / 2
    local y = svH - ( yp - 1 ) * ( itemH + ITEM_MARGIN ) - itemH / 2

    return x , y
end

function AddGameView:switchArea()
    GameApp:CreateSelectAreaView(true)
end

function AddGameView:onEventSelectArea()
    self:removeSelf()
end
-- 联系客服
function AddGameView:onClickService()
    gg.AudioManager:playClickEffect()
    device.callCustomerServiceApi(ModuleTag.AddGame)
end
return AddGameView