-- Author: Cai
-- Date: 2018-06-20
-- Describe：地区选择框，未配置地图资源时直接弹出

local M = class("AreaSelectView", cc.load("ViewPop"))
M.RESOURCE_FILENAME = "ui/map/map_select_view.lua"
M.RESOURCE_BINDING = {
    ["pv"]            = {["varname"] = "pv"       },                                                                                                           -- 翻页容器
    ["img_bg"]        = {["varname"] = "img_bg"   },                                                                                                           -- 背景
    ["txt_area"]      = {["varname"] = "txt_area" },                                                                                                           -- 选择地区导航
    ["txt_title"]     = {["varname"] = "txt_title"},
    ["btn_join_game"] = {["varname"] = "btn_join_game", ["events"] = {{event = "click", method = "onClickJoinGame"}}},                                      -- 进入游戏
    ["panel_back"]    = {["varname"] = "panel_back"   , ["events"] = {{event = "click", method = "onClickBack"    }}},                                      -- 返回
    ["btn_close"]     = {["varname"] = "btn_close"    , ["events"] = {{event = "click_color", method = "onClickClose"}}},                                      -- 关闭按钮
}

cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/map.plist")

function M:onCreate(canClose)
    self:init(canClose)
    self:initView()
end

function M:init(canClose)
    self.canClose = canClose
    -- 包配置所属地区码
    if REGION_CODE == 0 then
        -- 家乡棋牌，显示玩家所选省的地级市
        self._belongsArea = checkint(USER_AREA_CODE)
    else
        -- 其他产品，显示 REGION_CODE 对应的地级市
        self._belongsArea = REGION_CODE
    end
    -- 当前所选的地区码
    self._currentSelectArea = nil
    -- 包配置地区( 所有地区 )
    self._areaConfig = GameApp:getAreaConfig()
    -- 选择地区导航列表
    self._selectAreaNavList = {}
    -- 创建有序的地区表
    self._hasOrderArea = {}
    for k, v in pairs(self._areaConfig) do
        table.insert(self._hasOrderArea, {k, v})
    end

    table.sort(self._hasOrderArea, function(a, b)
        return a[1] < b[1]
    end)
end

function M:initView()
    self.txt_title:setString("选择您所在的地区：")

    local scaleH = display.height / self.img_bg:getContentSize().height
    local scaleW = display.width / self.img_bg:getContentSize().width
    if scaleH < 1 or scaleW < 1 then
        -- 保证整个界面能被全部显示
        self.img_bg:setScale(gg.IIF(scaleH < scaleW, scaleH, scaleW))
    end
    -- 获取配置所属地区的下级地区
    local subordinateArea = self:getSubordinateArea(self._belongsArea)
    self:setAreaShow(subordinateArea)
    -- 进入游戏按钮设置不可用
    self:setJoinGameBtnStatus(false)
    -- 如果不能关闭，隐藏关闭按钮
    self.btn_close:setVisible(self.canClose)
    -- 设置导航列表
    table.insert(self._selectAreaNavList, self._belongsArea)
    self:updateSelectNav()
end

function M:setCloseFunc(func)
    self._closeFunc = func
end

function M:getViewZOrder()
    return 9220
end

--[[
* @brief 设置地区显示
* @parm areas 地区
]]
function M:setAreaShow(areas)
    self.pv:removeAllChildren()
    local pvSize = self.pv:getContentSize()
    self:setJoinGameBtnStatus(false)

    if self._pageLabel then
        self._pageLabel:removeFromParent()
        self._pageLabel = nil
    end

    -- 根据地区数量获取相应的布局数据
    local layoutInfo = self:getAreaLayoutInfo(areas)
    -- 数据分页
    local t = gg.ArrangePage(areas, layoutInfo.pageCount, false)
    -- 分页联动处理
    local checkBoxPanels = {}
    -- 遍历分页
    for i=1, gg.TableSize(t) do
        -- 创建翻页容器子页
        local layout = ccui.Layout:create()
        layout:setContentSize(pvSize)
        self.pv:addPage(layout)
        -- 创建单选组
        local checkBoxPanel = require("common.widgets.RadioButtonGroup"):create()
        layout:addChild(checkBoxPanel)
        checkBoxPanel:setPositionY(layoutInfo.posY)
        checkBoxPanel:setPositionX(layoutInfo.posX)
        -- 设置单选组元素数和间隔
        checkBoxPanel:setElementCountH(layoutInfo.hCount)
        checkBoxPanel:setSpacingH(layoutInfo.hSpace)
        checkBoxPanel:setSpacingV(layoutInfo.vSpace)
        -- 取消默认选择
        checkBoxPanel:cancelDefaultSelect()

        -- 设置选项内容
        local areaName = {}
        local areaID = {}
        for n=1, #t[i] do
            local name = t[i][n][2]
            -- 超过6个汉字显示5个汉字+...
            if #name > 18 then
                name = string.sub(name, 1, 15).."..."
            end
            table.insert(areaName, name)
            table.insert(areaID, t[i][n][1])
        end
        checkBoxPanel:setText(areaName)
        checkBoxPanel:setFontInfo(30, cc.c3b(100, 53, 13))
        checkBoxPanel:setImg("hall/map/btn_quan.png", "hall/map/btn_xzhong.png")

        table.insert(checkBoxPanels, checkBoxPanel)
        -- 注册地区选择事件
        checkBoxPanel:setSelectCallBack(function(index)
            -- 解决翻页不能联动选择问题
            for k, v in pairs(checkBoxPanels) do
                if v ~= checkBoxPanel then
                    v:cancelDefaultSelect()
                end
            end

            -- 地区ID
            local id = areaID[ index ]
            self:onAreaSelect( id )
        end )
    end

    -- 添加分页切页标识
    if #t > 1 and not self._pageLabel then
        local imgSize = self.img_bg:getContentSize()
        local pageLabel = require("common.widgets.PageLabel"):create("hall/common/btn_dian02.png","hall/common/btn_dian01.png", 30, #t, 0)
        pageLabel:setPosition(cc.p(imgSize.width / 2, imgSize.height * 0.23))
        self._pageLabel = pageLabel
        self.img_bg:addChild(pageLabel)

        -- 添加滚动层监听事件
        local function pageViewEvent(sender, eventType)
            if eventType == ccui.PageViewEventType.turning and self._pageLabel then
                local pageView = sender
                self._pageLabel:setIndex( pageView:getCurrentPageIndex() )
            end
        end

        self.pv:addEventListener( pageViewEvent)
    end

    -- 默认选中第一页
    self.pv:setCurrentPageIndex(0)
end

--[[
* @brief 地区选择回调
* @param areaID 地区ID
]]
function M:onAreaSelect(areaID)
    -- 获取配置所属地区的下级地区
    local subordinateArea = self:getSubordinateArea( areaID )
    if #subordinateArea > 0 then
        self:setAreaShow( subordinateArea )
        -- 设置导航列表
        table.insert( self._selectAreaNavList , areaID )
        self:updateSelectNav()
    else
        self:setJoinGameBtnStatus( true )
    end

    -- 记录当前所选的地区码
    self._currentSelectArea = areaID
end

--[[
* @brief 更新选择地区导航
]]
function M:updateSelectNav()
    -- 不可返回时隐藏返回按钮
    self.panel_back:setVisible(#self._selectAreaNavList > 1)

    local l = self._selectAreaNavList
    local str = "中国>"
    if self._belongsArea == 0 then
        str = "中国"
    end

    -- 导航缺少的地区补充
    local ca = self._selectAreaNavList[1]
    if self:getNumBits( ca ) > 2 then
        str = str .. self._areaConfig[ tonumber( string.sub( ca.."" , 1 , 2 ) )  ] .. ">"
        if self:getNumBits( ca ) > 4 then
            str = str .. self._areaConfig[ tonumber( string.sub( ca.."" , 1 , 4 ) )  ] .. ">"
        end
    end

    -- 根据选择的地区刷新导航
    for i = 1 , #self._selectAreaNavList do
        if self._selectAreaNavList[i] > 0 then
            str = str .. self._areaConfig[ self._selectAreaNavList[i] ]
        end

        if i < #self._selectAreaNavList then
            str = str ..">"
        end
    end
    self.txt_area:setString( str )
end

--[[
* @brief 设置进入游戏按钮状态
* @param isEnabled 是否可用
]]
function M:setJoinGameBtnStatus(isEnabled)
    self.btn_join_game:setEnabled(isEnabled)
    self.btn_join_game:setAllGray(not isEnabled)
end

--[[
* @brief 加入游戏事件
]]
function M:onClickJoinGame( sender )
    local function joinGame()
        local curRegion = gg.LocalConfig:GetRegionCode()
        -- 选择地区没有变化，直接关闭界面即可
        if curRegion == self._currentSelectArea then
            if self._closeFunc then self._closeFunc() end
            if self._countyView then
                self._countyView:onClickClose()
            end
            self:removeSelf()
            return
        end
        GameApp:doSelectRegionEvent(self._currentSelectArea)
        -- 关闭当前界面
        if self._countyView then
            self._countyView:onClickClose()
        end
        self:removeSelf()
    end

    if REGION_CODE == 0 then
        local dialogTitle = string.format("确定选择 [%s] 吗？", self._areaConfig[self._currentSelectArea])
        local msg = string.format("系统将为您推荐 [%s] 的特色游戏。", self._areaConfig[self._currentSelectArea])
        GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG, msg, function(bttype)
            if bttype == gg.MessageDialog.EVENT_TYPE_OK then
                joinGame()
            end
        end, {mode = gg.MessageDialog.MODE_OK_CANCEL_CLOSE, cancel = "重新选择", ok = "确定", title = dialogTitle})
    else
        joinGame()
    end
end

--[[
* @brief 返回事件
]]
function M:onClickBack( sender )

    if #self._selectAreaNavList > 1 then

        -- 移除导航表
        table.remove( self._selectAreaNavList , #self._selectAreaNavList )
        self:updateSelectNav()

        -- 获取地区
        local subordinateArea = self:getSubordinateArea( self._selectAreaNavList[ #self._selectAreaNavList ] )
        self:setAreaShow( subordinateArea )
    end
end

function M:onClickClose(sender)
    self:removeSelf()
end

------------------------------------------------
-- 获取地区配置
------------------------------------------------
function M:getSubordinateArea(areaID)
    if not areaID then return nil end
    -- 配置的所有区域
    local areaConfig = self._hasOrderArea
    -- 所有下级区域
    local subordinateArea = {}
    -- 找到所有下级区域
    for i = 1, #areaConfig do
        if self:isContain(areaConfig[i][1], areaID) then
            if areaID == 0 then
                table.insert(subordinateArea, areaConfig[i])
            end
            -- 常规地区
            if self:getNumBits(areaID) + 2 == self:getNumBits(areaConfig[i][1]) then
                table.insert(subordinateArea, areaConfig[i])
            end
            -- 省直辖县级市
            if self:getNumBits(areaID) == 2 and self:isContain(areaConfig[i][1], 90, 3) and self:getNumBits(areaConfig[i][1]) == 6 then
                table.insert(subordinateArea, areaConfig[i])
            end
            -- 直辖市直接对应区(天津、北京、上海、重庆)
            if areaID == 12 or areaID == 11 or areaID == 31 or areaID == 50 then
                if self:getNumBits(areaConfig[i][1]) == 6 then
                    table.insert(subordinateArea, areaConfig[i])
                end
            end
        end
    end

    return subordinateArea
end

--[[
* @brief 判断 数字a 是否包含 数字b
* @parm a 源数字
* @parm b 被包含
* @parm pos 包含的位置（默认1）
]]
function M:isContain(a, b, pos)
    if b == 0 then
        return self:getNumBits(a) == 2
    end
    pos = pos or 1
    local strA = string.format("%d", a)
    local strB = string.format("%d", b)
    local r = string.find(strA, strB)
    return r ~= nil and r == pos
end

--[[
* @brief 获取数字位数
* @parm num 数字
]]
function M:getNumBits(num)
    return #(num.."")
end

function M:getAreaLayoutInfo(areas)
    local ret = {}
    local areaCount = #areas
    if areaCount <= 9 then
        -- 小于 9 个(3 * 3 的布局)
        ret.pageCount = 9
        ret.hCount = 3
        ret.hSpace = 400
        ret.vSpace = 110
        ret.fontSize = 40
        ret.posX = 130
        ret.posY = 320
    elseif areaCount <= 20 then
        -- 10--20 个(4 * 5 的布局)
        ret.pageCount = 20
        ret.hCount = 4
        ret.hSpace = 290
        ret.vSpace = 80
        ret.fontSize = 35
        ret.posX = 70
        ret.posY = 370
    else
        -- 20 个以上 ( 5 * 5 的布局)
        ret.pageCount = 25
        ret.hCount = 5
        ret.hSpace = 230
        ret.vSpace = 80
        ret.fontSize = 32
        ret.posX = 60
        ret.posY = 350
    end

    return ret
end

return M