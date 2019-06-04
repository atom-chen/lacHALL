
----------------------------------------------------------------------
-- 作者：Cai
-- 日期：2018-08-24
-- 描述：朋友场斗地主规则界面
----------------------------------------------------------------------

local M = class("JXFriendDdzhNode", import(".JXFriendRuleNode"))

M.RESOURCE_FILENAME = "ui/room/friendroom/jx_create_rule_node.lua"
M.RESOURCE_BINDING = {
    ["txt_tips"]    = {["varname"] = "txt_tips"},
    ["img_line"]    = {["varname"] = "img_line"},
    ["img_download"]= {["varname"] = "img_download"},
    ["btn_create"]  = {["varname"] = "btn_create", ["events"] = {{event = "click", method = "onClickCreate"}}},
    ["btn_update"]  = {["varname"] = "btn_update", ["events"] = {{event = "click", method = "onClickUpdate"}}},
}

local GAME_SHORT_NAMES = {
    "erdz",     -- 二人斗地主
    "ddzh",     -- 斗地主
    "",         -- 四人斗地主预留
}

local PLAYER_NUMS = {
    "二人玩法", "经典三人", "四人玩法",
}

local PLAYER_OPTION_LIST_NODE_TAG = 101

local RADIO_BTN_FONTSIZE = 30
local RADIO_BTN_COLOR_NOR = cc.c3b(143, 78, 12)
local RADIO_BTN_COLOR_SEL = cc.c3b(232, 113, 20)

local RULE_TITLE_COLOR = cc.c3b(108, 54, 0)
local RULE_TITLE_FONTSIZE = 30

function M:onCreate(shortName, enterType, clubId, managerid, cLubRule, convenientTag)
    cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/jx_room.plist")
    -- 初始化
    self:init(shortName, enterType, clubId, managerid, cLubRule, convenientTag)
    -- 初始化View
    self:initView()
end

function M:init(shortName, enterType, clubId, managerid , cLubRule, convenientTag)
    if Table:isValueExist(GAME_SHORT_NAMES, shortName) then
        -- 如果可以支持指定的短名，设置为默认
        self._shortName = shortName
    else
        -- 默认选中 ddzh
        self._shortName = "ddzh"
    end

    self._enterType = enterType or 1
    self._clubId = clubId or 0
    self._managerid = managerid
    self._rule = nil

    self._convenientTag = convenientTag
    
    self._loadClubRule = checktable(cLubRule)

    self:refreshData()

    if self:isConvenientCreate() then
        self.btn_create:loadTextureNormal("hall/room/jxroom/create_btn_bc.png",1)
        self.btn_create:loadTexturePressed("hall/room/jxroom/create_btn_bc.png",1)
        self.btn_create:loadTextureDisabled("hall/room/jxroom/create_btn_bc.png",1)
    end

    -- 线处理函数
    gg.LineHandle(self.img_line)
end

function M:refreshView()
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

function M:initView()
    -- 创建人数选项显示
    self:addPlayersOption()

    M.super.initView(self)

    self:selectPlayerCountIdx(Table:findKey(GAME_SHORT_NAMES, self._shortName))
end

function M:selectPlayerCountIdx(idx)
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

function M:addPlayersOption()
    self._playersBtns = require("common.widgets.RadioButtonGroup"):create(PLAYER_NUMS, 1, "")
    self._playersBtns:setPosition(cc.p(128, 590))
    self._playersBtns:setFontInfo(RADIO_BTN_FONTSIZE, RADIO_BTN_COLOR_NOR, "")
    self._playersBtns:setSpacingH(217)
    self._playersBtns:changeBtnTitlePosY(1)
    self._playersBtns:setTag(PLAYER_OPTION_LIST_NODE_TAG)
    self._playersBtns:setImg("hall/room/jxroom/create_cb_1.png", "hall/room/jxroom/create_cb_2.png")
    self._playersBtns:setSelectCallBack(handler(self, self.selectPlayerCountIdx))

    -- 创建文本控件
    local txt_ = ccui.Text:create()
    txt_:setString("人数")
    txt_:setFontSize(RULE_TITLE_FONTSIZE)
    txt_:setTextColor(RULE_TITLE_COLOR)
    txt_:setName("txt")
    txt_:setPosition(cc.p(-80, 0))
    self._playersBtns:addChild(txt_)

    -- 线
    local cuttingLine = ccui.ImageView:create()
    cuttingLine:loadTexture("hall/room/jxroom/create_line.png", 1)
    cuttingLine:setScale9Enabled( true )
    cuttingLine:setName("line")
    cuttingLine:setContentSize(cc.size( 836, 1 ) )
    cuttingLine:setAnchorPoint(cc.p(0, 0))
    cuttingLine:setPosition( -128,-40 )
    gg.LineHandle( cuttingLine )
    self._playersBtns:addChild(cuttingLine)
    self:addChild( self._playersBtns )
end

--给斗地主游戏的节点
function M:getPlayersGroupNode()
    return self._playersBtns
end

-- 获取规则界面
function M:showRuleView( )
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
        M.super.showRuleView(self)

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

return M
