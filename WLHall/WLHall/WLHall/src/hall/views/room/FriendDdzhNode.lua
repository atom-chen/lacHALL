
----------------------------------------------------------------------
-- 作者：zhangbin
-- 日期：2017-12-26
-- 描述：朋友场斗地主规则界面
----------------------------------------------------------------------

local FriendDdzhNode = class("FriendDdzhNode", import(".FriendRuleNode"))

FriendDdzhNode.RESOURCE_FILENAME = "ui/room/friendroom/create_rule_node.lua"
FriendDdzhNode.RESOURCE_BINDING = {
    ["txt_tips"]    = { ["varname"] = "txt_tips" },
    ["img_line"]    = { ["varname"] = "img_line" },
    ["img_download"]= { ["varname"] = "img_download" },
    ["panel_create"]= { ["varname"] = "panel_create" },
    ["panel_update"]= { ["varname"] = "panel_update" },
    ["btn_create"]  = { ["varname"] = "btn_create" , ["events"]={ {event="click",method="onClickCreate"} } },
    ["btn_update"]  = { ["varname"] = "btn_update" , ["events"]={ {event="click",method="onClickUpdate"} } },
}

local GAME_SHORT_NAMES = {
    "erdz",     -- 二人斗地主
    "ddzh",     -- 斗地主
}
local PLAYER_NUMS = {
    "二人玩法", "经典三人",
}

-- 未完成功能开关开启时显示四人玩法
if GameApp:CheckModuleEnable(ModuleTag.Unimplemented) then
    table.insert(GAME_SHORT_NAMES, "")
    table.insert(PLAYER_NUMS, "四人玩法")
end

local PLAYER_OPTION_LIST_NODE_TAG = 101

--[[
]]--
function FriendDdzhNode:onCreate( shortName )
    -- 初始化
    self:init(shortName)
    -- 初始化View
    self:initView()
end

function FriendDdzhNode:init( shortName )
    if Table:isValueExist(GAME_SHORT_NAMES, shortName) then
        -- 如果可以支持指定的短名，设置为默认
        self._shortName = shortName
    else
        -- 默认选中 ddzh
        self._shortName = "ddzh"
    end

    self:refreshData()

    -- 线处理函数
    gg.LineHandle(self.img_line)
end

function FriendDdzhNode:refreshView()
    -- 更新规则部分的显示
    if self._shortName ~= "" then
        self:checkGameNeedUpdate()
    else
        self:showRuleView()
    end

    -- 更新固定选项的显示
    self:refreshCheckBox()

    -- 设置聊天,GPS,代开按钮状态
    self:readDataFromCache()

    -- 设置选中按钮文本颜色
    self:changeCheckBoxColor()
end

function FriendDdzhNode:initView()
    -- 创建人数选项显示
    self:addPlayersOption()

    FriendDdzhNode.super.initView(self)

    self:selectPlayerCountIdx(Table:findKey(GAME_SHORT_NAMES, self._shortName))
end

function FriendDdzhNode:selectPlayerCountIdx(idx)
    -- 先记录之前选择的数据
    self:recordData()

    self._shortName = GAME_SHORT_NAMES[idx]
    self:refreshData()
    self:refreshView()

    for k, v in pairs(self._playersBtns._checkBoxList) do
        v:setSelected(false)
        if k == idx then
            v:setSelected(true)
        end
    end

    self:changeCheckBoxColor(PLAYER_OPTION_LIST_NODE_TAG)
end

function FriendDdzhNode:addPlayersOption()
    self._playersBtns = require("common.widgets.RadioButtonGroup"):create(PLAYER_NUMS, 1, "")
    self._playersBtns:setPosition(cc.p(128, 590))
    self._playersBtns:setFontInfo(30, cc.c3b(51, 51, 51), "")
    self._playersBtns:setSpacingH(217)
    self._playersBtns:changeBtnTitlePosY(1)
    self._playersBtns:setTag(PLAYER_OPTION_LIST_NODE_TAG)
    self._playersBtns:setImg("hall/room/friend/bg_btn_01.png", "hall/room/friend/btn_point.png")
    self._playersBtns:setSelectCallBack(handler(self, self.selectPlayerCountIdx))

    -- 创建文本控件
    local txt_ = ccui.Text:create()
    txt_:setString("人数")
    txt_:setFontSize( 30 )
    txt_:setTextColor(cc.c3b(51, 51, 51))
    txt_:setName("txt")
    txt_:setPosition(cc.p(-80, 0))
    self._playersBtns:addChild(txt_)

    -- 线
    cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
    local cuttingLine = ccui.ImageView:create()
    cuttingLine:loadTexture( "hall/common/new_line.png", 1 )
    cuttingLine:setScale9Enabled( true )
    cuttingLine:setName("line")
    cuttingLine:setContentSize(cc.size( 816, 1 ) )
    cuttingLine:setAnchorPoint(cc.p(0, 0))
    cuttingLine:setPosition( -128,-40 )
    gg.LineHandle( cuttingLine )
    self._playersBtns:addChild(cuttingLine)
    self:addChild( self._playersBtns )
end

--给斗地主游戏的节点
function FriendDdzhNode:getPlayersGroupNode()
    return self._playersBtns
end

-- 获取规则界面
function FriendDdzhNode:showRuleView( )
    -- 显示创建按钮
    self:showCreateBtn( true )
    self._ruleNode = nil

    if self._shortName == "ddzh" then
        -- 斗地主，需要隐藏二人斗地主的规则和开发提示
        if self._erdzNode then self._erdzNode:setVisible(false) end
        self.txt_tips:hide()
        self.img_download:setVisible(false)
        if self._ddzhNode then
            self._ruleNode = self._ddzhNode
        end
    elseif self._shortName == "erdz" then
        -- 二人斗地主，需要隐藏斗地主的规则和开发提示
        if self._ddzhNode then self._ddzhNode:setVisible(false) end
        self.txt_tips:hide()
        self.img_download:setVisible(false)
        if self._erdzNode then
            self._ruleNode = self._erdzNode
        end
    else
        -- 四人斗地主开发中，显示提示信息
        if self._ddzhNode then self._ddzhNode:setVisible(false) end
        if self._erdzNode then self._erdzNode:setVisible(false) end
        self.txt_tips:setString( "攻城狮正在加班加点开发，敬请期待！" )
        self.txt_tips:show()
        self.img_download:setVisible(false)
        self.btn_create:setEnabled( false )
        return
    end

    if not self._ruleNode then
        -- 创建规则节点
        FriendDdzhNode.super.showRuleView(self)

        -- 创建成功了
        if self._ruleNode then
            -- 记录相应的节点
            if checkstring(self._shortName) == "ddzh" then
                self._ddzhNode = self._ruleNode
            elseif checkstring(self._shortName) == "erdz" then
                self._erdzNode = self._ruleNode
            end

            --设置位置
            for k,v in pairs(self._ruleNode._groupTb) do
                v:setPositionY(v:getPositionY()-90)
            end
        end
    end

    if self._ruleNode then
        -- 显示节点
        self._ruleNode:setVisible(true)
    end
end

return FriendDdzhNode
