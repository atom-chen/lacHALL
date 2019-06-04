--
--Author:李阿城
--Date: 2017 10.20 14:20:2
--Descrlibe:战绩界面
--------修改人员
--Author:陈吉塔
--Date:2018 3.13 16:00:00
--Descrlibe:战绩界面

local GameRecordStatisticsView = class("GameRecordStatisticsView", cc.load("ViewBase"))

GameRecordStatisticsView.RESOURCE_FILENAME="ui/recordstatistics/friend_statistics_view.lua"
GameRecordStatisticsView.RESOURCE_BINDING = {
    ["parent_node"]   = { ["varname"] = "parent_node"},  --所有root节点
    ["listview_bg"]   = { ["varname"] = "listview_bg"},  --列表节点
    ["btn_look_other_statistic"] = { ["varname"] = "btn_look_other_statistic", ["events"] = { { ["event"] = "click_color", ["method"] = "onClickLookOtherStatistic"} } }, -- 查看他人战绩
    ["shape_xhx"]  =  { ["varname"] = "shape_xhx"},  --箭头图片
}

function GameRecordStatisticsView:onCreate(game)
     -- 游戏数据
    self:init(game)
    -- 构造 tab 页
    self:refreshTabs()
end

function GameRecordStatisticsView:init( game )
    -- 游戏数据
    self.game = game
    -- 是否显示回放码界面
    self._isShowView = false
    -- 查找回放码按钮
    self._btnShow = nil

end

function GameRecordStatisticsView:refreshTabs()

    local tabsInfo = {}
     -- 创建战绩界面
    if self.page_statistics == nil then
        self.page_statistics = self:getScene():createView("room.RecordStatisticsView",self.game,self)
    end
    self:addPageNode(self.page_statistics)
end

--[[
* @brief 添加页面节点
]]
function GameRecordStatisticsView:addPageNode(pageNode)
    if pageNode and self.listview_bg then
        self.listview_bg:addChild(pageNode)
    end
end

--[[
* @brief 关闭回放码页面
]]
function GameRecordStatisticsView:closeSearchView( )
    self._isShowView = false
    self.shape_xhx:runAction(cc.RotateTo:create( 0.2, 0))
    self._searchView:closeView()
end

--[[
* @brief 查看他人战绩
]]
function GameRecordStatisticsView:onClickLookOtherStatistic()
    gg.AudioManager:playClickEffect()

    if self._isShowView then
        self:closeSearchView()
    else
        self:showSearchView()
    end

end



--[[
* @brief 打开回放码页面
]]
function GameRecordStatisticsView:showSearchView( )
    if not self._searchView then
        --回放码界面
        self._searchView = self:getScene():createView("room.RecordInputLayer")
        self:addChild( self._searchView )
        self._searchView:setCallback(function( )
            self._isShowView = false
            self.shape_xhx:runAction(cc.RotateTo:create( 0.2, 0))
        end)
    end
    self._isShowView = true
    self.shape_xhx:runAction(cc.RotateTo:create( 0.2, 180))
    self._searchView:setVisible( true )
    self._searchView:showView()
end

-- 游戏更新
function GameRecordStatisticsView:doUpdateFinish(shortname, err)
    if self.page_statistics and self.page_statistics.doUpdateFinish then
        self.page_statistics:doUpdateFinish(percent, shortname)
    end
end

return GameRecordStatisticsView