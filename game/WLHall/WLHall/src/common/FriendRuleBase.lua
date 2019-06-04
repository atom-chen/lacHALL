
----------------------------------------------------------------------
-- 作者：Cai
-- 日期：2017-03-15
-- 描述：朋友场创建规则界面
---------------------------------------------------------------------
local UIBase = import(".UIBase")
local FriendRuleBase = class("FriendRuleBase", UIBase)
-- local FriendRuleBase = class("FriendRuleBase", cc.load("UIBase"))

cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/jx_room.plist")

-- 标题文字大小
local TITLE_FONT_SIZE = 30
-- 标题文字色值
local TITLE_FONT_COLOR = gg.IIF(PACKAGE_TYPE == 2, cc.c3b(108, 54, 0), cc.c3b(51, 51, 51))
-- 按钮字体大小
local BTN_FONT_SIZE = 30
-- 按钮正常状态色值
local BTN_FONT_NORMAL_COLOR = gg.IIF(PACKAGE_TYPE == 2, cc.c3b(143, 78, 12), cc.c3b(51, 51, 51))
-- 按钮选中状态色值
local BTN_FONT_SELECT_COLOR = gg.IIF(PACKAGE_TYPE == 2, cc.c3b(232, 113, 20), cc.c3b(38, 155, 88))
-- 按钮不可点击状态色值
local BTN_FONT_UNABLE_COLOR = cc.c3b(160, 160, 160)
-- 房卡消耗字体大小
local COST_FONT_SIZE = 24

local CUTTING_LINE_PATH = gg.IIF(PACKAGE_TYPE == 2, "hall/room/jxroom/create_line.png", "hall/common/new_line.png")
local AUDIO_DEFAULT_NOR_PATH = gg.IIF(PACKAGE_TYPE == 2, "hall/room/jxroom/create_cb_1.png", "hall/room/friend/bg_btn_01.png")
local AUDIO_DEFAULT_SEL_PATH = gg.IIF(PACKAGE_TYPE == 2, "hall/room/jxroom/create_cb_2.png", "hall/room/friend/btn_point.png")
local CHECKBOX_DEFAULT_NOR_PATH = gg.IIF(PACKAGE_TYPE == 2, "hall/room/jxroom/create_cb_3.png", "hall/room/friend/bg_btn_02.png")
local CHECKBOX_DEFAULT_SEL_PATH = gg.IIF(PACKAGE_TYPE == 2, "hall/room/jxroom/create_cb_4.png", "hall/room/friend/btn_gou.png")

-- fkval 房卡基础消耗值
function FriendRuleBase:onCreate( fkval, ... )
    -- 当前创建所需消耗的房卡数
    self._curCardCost = nil
end

--[[
* @brief 根据配置表来生成按钮面板
* @parm shortname 游戏短名
* @parm addSv BOOL类型参数，是否需要添加滚动层
* @parm scrollHight 滚动层的滚动区域高度
* @parm groupTb 返回参数,存储所有创建的按钮组btnGroup
]]
function FriendRuleBase:createRuleBtnGroup( shortname, titleTbs, layoutTbs, addSv, scrollHight )
	assert( titleTbs, "titleTbs is nil" )
	assert( layoutTbs, "layoutTbs is nil" )
	local groupTb = {}
    local sv = nil
    if addSv then
        sv = self:createScrollView(scrollHight)
    end
    -- 创建btnGroup
    for i,v in ipairs(titleTbs) do
    	local lTb = layoutTbs[i]
    	local params = {}
    	params.count = lTb.countH
    	params.spacingV = lTb.spaceH
        params.width = lTb.width
    	local btnGroup = self:createButtonGroup(v, lTb.type, params)
    	btnGroup.type = lTb.type
        if sv then
            btnGroup:setPosition(cc.p((lTb.posX or 128), lTb.posY + (sv:getInnerContainerSize().height - 620)))
            sv:addChild(btnGroup)
        else
            btnGroup:setPosition(cc.p(lTb.posX or 128, lTb.posY - 5))
            self:addChild(btnGroup)
        end
    	-- 添加分割线
    	if lTb.line then
    		-- 计算分割线添加的位置
    		local row = math.ceil(#v / lTb.countH)
    		local x = -128
    		local y = - (lTb.spaceH + 20) / 2 - lTb.spaceH * (row - 1)
    		self:addCuttingLine(btnGroup, cc.p(x, y))
    	end
    	-- 添加标题
    	if lTb.title then
            self:setGroupTitle(btnGroup, lTb.title)
        end
        -- 设置默认选择
        if lTb.defaultS then
            btnGroup:setDefaultSelect(lTb.defaultS)
        end
    	-- 将创建的btnGroup加入groupTb中
    	table.insert(groupTb, btnGroup)
    end

    return groupTb
end

-- 创建规则界面滚动容器
function FriendRuleBase:createScrollView( scrollHight )
    scrollHight = scrollHight or 600
    local sv = ccui.ScrollView:create()
    sv:setContentSize( cc.size( 816, 480 ) )
    sv:setInnerContainerSize({width = 870, height = scrollHight})
    sv:setPosition(0, 135)
    sv:setScrollBarEnabled(false)
    sv:setName( "sv_rule" )
    self:addChild( sv )
    return sv
end

-- 设置滚动容器的size和滚动size
function FriendRuleBase:setScrollViewSize( contentsize, innersize )
    local sv = self:getChildByName( "sv_rule" )
    if sv then
        if contentsize then
            sv:setContentSize( contentsize )
        end

        if innersize then
            sv:setInnerContainerSize( innersize )
        end
    end
end

-- 取消按钮组的默认选项
function FriendRuleBase:cancelDefultSelect( btnGroup )
	btnGroup:cancelDefultSelect()
end

-- 按钮组添加点击事件回调
function FriendRuleBase:setSelectCallBack( btnGroup, callback )
	btnGroup:setSelectCallBack( callback )
end

-- 获取某个按钮组中index位置是否被选中
function FriendRuleBase:getBtnIsSelectByIndex( btnGroup, index )
	for i,v in ipairs( btnGroup._checkBoxList ) do
		if i == index then
			return v:isSelected()
		end
	end
end

--[[
* @brief 按顺序读取配置表中设置的rule值
* @parm groupTb 存储所有按钮组的表格
* 适用条件：1) 单选按钮只传选中那个按钮的tag值
			2) 复选按钮选中传1,未选中传0
			3) 读取顺序从上到下,从左到右
			4) 要有配置表
]]
function FriendRuleBase:linkSequentialRule( groupTb,tagTbs )
	assert( tagTbs, "tagTbs is nil" )
	local rule = {}
    -- 遍历各个btnGroup获取所点击的index值来拼接传递的表
    for i,btnGroup in ipairs( groupTb ) do
        local tTb = clone( tagTbs[i] ) 		-- 可以发送的tag值获取
        if btnGroup.type ==1 then
            local index = btnGroup:getSelectIndex() -- 根据选择按钮的位置来获取传送的tag值
            for k,v in pairs( tTb ) do
                if k==index then
                    table.insert( rule , v )
                end
            end
        else
            local indexTable = btnGroup:getSelectIndex()
            for k,v in ipairs( indexTable ) do
                if tTb[v] then
                    tTb[v] = 1
                end
            end
            for k,v in ipairs( tTb ) do
                table.insert( rule , v )
            end
        end
    end
    return rule
end

-- 获取所有选中按钮位置的表,用于存入缓存
function FriendRuleBase:getBtnIndexTable( groupTb )
	-- 遍历各个panel获取所点击的index值来拼接传递的表
    local selectTb = {}
    for i,btnGroup in ipairs( groupTb ) do
        if btnGroup.type ==1 then
            local index = btnGroup:getSelectIndex() -- 根据选择按钮的位置来获取传送的tag值
            if index then
                table.insert( selectTb, index )
            else
                -- 单选按钮组被设置为不可点击的时候，有可能出现没有默认被选中的情况，这时候传入-1来记录缓存信息
                table.insert( selectTb, -1 )
            end
        else
            local indexTable = btnGroup:getSelectIndex()
            table.insert( selectTb, indexTable )
        end
    end
    return selectTb
end

-- 根据按钮位置表来设置按钮选中状态
function FriendRuleBase:setBtnSelectByTable( groupTb, table )
	if #table == #groupTb then
        for i,btnGroup in ipairs( groupTb ) do
            if btnGroup.type ==1 then
                local index = checknumber( table[i] )
                -- -1表示单选按钮组没有被选中的状态，直接跳过
                if index ~= -1 then
                    if index > #btnGroup._checkBoxList then
                        btnGroup:setDefaultSelect( 1 )
                    else
                        if index == 0 then index = 1 end
                        btnGroup:setDefaultSelect( index )
                    end
                else
                    btnGroup:cancelDefaultSelect()
                end
            else
                btnGroup:setDefaultSelect( checktable(table[i]) )
            end
        end
    else
        print( "配置表有新增或删减数据,导致读取失败,重置页面规则！" )
    end
end

--[[
* @brief 改变按钮选中颜色
* @parm btnGroup 按钮组
* @parm nor_color 未选中状态颜色
* @parm sel_color 选中状态颜色
* @parm un_color  不可点击状态颜色
]]
function FriendRuleBase:changeBtnTxtColor( btnGroup, nor_color, sel_color, un_color )
	assert( btnGroup, "btnGroup is nil" )
	nor_color = nor_color or BTN_FONT_NORMAL_COLOR
    sel_color = sel_color or BTN_FONT_SELECT_COLOR
    un_color = un_color or BTN_FONT_UNABLE_COLOR
    local function setBtnTxtColor_(btn, color)
        local title = btn:getText()
        local txt_cost = btn:getChildByName("txt_cost")
        title:setTextColor(color)
        if txt_cost then
            txt_cost:setTextColor(color)
        end
    end

	for k,btn in pairs( btnGroup._checkBoxList ) do
        if not btn:isEnabled() then
            setBtnTxtColor_(btn, un_color)
		elseif btn:isSelected() then
            setBtnTxtColor_(btn, sel_color)
            local txt_cost = btn:getChildByName("txt_cost")
            if txt_cost then
                self._curCardCost = txt_cost.costTag
            end
        else
            setBtnTxtColor_(btn, nor_color)
        end
	end
end

--[[
* @brief 创建按钮组
* @pram titleTb 按钮名称数组
* @pram bType 按钮组类型 1-单选按钮 2-复选按钮
* @pram params 布局参数表
		params.count 	 一行排布的按钮个数
		params.width 	 排布的宽度
		params.spacingV  按钮排布上下两行间距
		params.fontSize  字体大小
		params.fontColor 字体颜色
		params.audio_nor 单选按钮普通状态按钮图片
		params.audio_sel 单选按钮点击状态按钮图片
		params.check_nor 复选按钮普通状态按钮图片
		params.check_sel 复选按钮点击状态按钮图片
]]
function FriendRuleBase:createButtonGroup( titleTb, bType, params )
    cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
	local params = params or {}
	local count = params.count or 3
	local width = params.width or 663
	local spacingV = params.spacingV or 80
	local fontSize = params.fontSize or BTN_FONT_SIZE
	local fontColor = params.fontColor or BTN_FONT_NORMAL_COLOR
	local audio_nor = params.audio_nor or AUDIO_DEFAULT_NOR_PATH
	local audio_sel = params.audio_sel or AUDIO_DEFAULT_SEL_PATH
	local check_nor = params.check_nor or CHECKBOX_DEFAULT_NOR_PATH
	local check_sel = params.check_sel or CHECKBOX_DEFAULT_SEL_PATH

    local btnGroup = require("common.widgets.RadioButtonGroup"):create(titleTb, bType, "")
    btnGroup:setElementCountH(count)
    btnGroup:setSpacingH(width / count)	-- 根据宽度设置按钮水平间距
    btnGroup:setSpacingV(spacingV)
    btnGroup:setFontInfo(fontSize, fontColor, "")
    btnGroup:changeBtnTitlePosY(1)
    if bType == 1 then
    	btnGroup:setImg(audio_nor, audio_sel)
    else
    	btnGroup:setImg(check_nor, check_sel)
    	btnGroup:cancelDefaultSelect()
    end
    return btnGroup
end

--[[
* @brief 添加分割线
* @pram node 需要添加分割线的节点
* @pram size(cc.size) 分割线长度
* @pram point(cc.p) 添加的位置
]]
function FriendRuleBase:addCuttingLine(node, point, size)
    cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/common.plist")
	local cuttingLine = ccui.ImageView:create()
    cuttingLine:loadTexture(CUTTING_LINE_PATH, 1)
    cuttingLine:setScale9Enabled(true)
    cuttingLine:setContentSize(size or cc.size(gg.IIF(PACKAGE_TYPE == 2, 836, 816), 1))
    cuttingLine:setAnchorPoint(cc.p(0, 0))
    cuttingLine:setPosition(point)
    cuttingLine:setName("cuttingLine")
    gg.LineHandle(cuttingLine)  	-- 线处理函数
    node:addChild(cuttingLine)
    return cuttingLine
end

--[[
* @brief 设置btnGroup的标题
* @parm title 标题
* @pram params 布局参数表
		params.fontSize  字体大小
		params.fontColor 字体颜色
		params.point 标题位置
]]
function FriendRuleBase:setGroupTitle( node, title, params )
    local params = params or {}
    local fontSize = params.fontSize or TITLE_FONT_SIZE
    local fontColor = params.fontColor or TITLE_FONT_COLOR
    local point = params.point or cc.p(-80, 0)

    local txt = ccui.Text:create()
    txt:setString( title )
    txt:setFontSize( fontSize )
    txt:setTextColor( fontColor )
    txt:setName( "txt_title" )
    txt:setPosition( point )
    node:addChild( txt )
end

--[[
* @brief 添加房卡消耗文本
* @pram btnGroup 按钮组
* @pram fkval 房卡消耗基数
* @parm jushuTb 局数数据表,默认为4,8,16局
]]
function FriendRuleBase:addCostRoomCardTxt( btnGroup, fkval, jushuTb )
	local costTb = self:calculateCardCost( fkval, jushuTb )
	local costTxtTb = {}
	for i,v in ipairs( btnGroup._checkBoxList ) do
		local txt = ccui.Text:create()
        if not GameApp:CheckModuleEnable(ModuleTag[PROP_ID_ROOM_CARD]) then
            -- 审核模式隐藏房卡相关信息
            txt:setVisible( false )
        end

        -- 房卡消耗为0时不显示
        if costTb[i] == 0 then
            txt:setString("(限免)")
        else
            if IS_WEILE then
                txt:setString( string.format( "(视频券x%d)", costTb[i] ) )
            else
                txt:setString( string.format( "(房卡x%d)", costTb[i] ) )
            end
        end
	    txt:setFontSize(COST_FONT_SIZE)
	    txt:setTextColor( BTN_FONT_NORMAL_COLOR )
	    txt:setAnchorPoint( cc.p( 0, 0 ) )
	    txt:setPosition(cc.p(v:getContentSize_().width + 5, 0))
        txt:setName( "txt_cost" )
        txt.costTag = checkint( costTb[i] )
	    v:addChild( txt )
	    table.insert( costTxtTb, txt )
        -- 增加局数按钮的触碰区域
        local panel = v:getTouchPanel()
        local size = panel:getContentSize()
        panel:setContentSize( cc.size( size.width + txt:getContentSize().width, size.height ) )
	end
	return costTxtTb
end

--[[
* @brief 设置房卡消耗
* @pram costTxtTb 存储房卡消耗文本的表
* @pram costTb 房卡消耗数量表
]]
function FriendRuleBase:setCostRoomCardTxt( costTxtTb, costTb )
    for i,v in ipairs( costTxtTb ) do
        if not GameApp:CheckModuleEnable(ModuleTag[PROP_ID_ROOM_CARD]) then
            -- 审核模式隐藏房卡相关信息
            v:setVisible( false )
        else
            v:setVisible( true )
            if costTb[i] <= 0 then
                v:setString("(限免)")
            else
                 if IS_WEILE then
                    v:setString( string.format( "(视频券x%d)", costTb[i] ) )
                 else
                    v:setString( string.format( "(房卡x%d)", costTb[i] ) )
                 end
                 v.costTag = checkint( costTb[i] )
            end
        end
    end
end

--[[
* @brief 计算房卡消耗数值
* @parm fkval 房卡消耗基数
* @parm jushuTb 局数数据表
注：该方法的计算是按(4,8,9)局房卡消耗的消耗倍数为1,(16,18)局为2,(32,36)局为3。
    如有特殊情况请调用setCostRoomCardTxt方法自行设置。
]]
function FriendRuleBase:calculateCardCost( fkval, jushuTb )
	local costTb = {}
	local jushuTb = jushuTb or { 4, 8, 16 }
	local byDouble = 1
	for i,v in ipairs( jushuTb ) do
		if v == 16 or v == 18 then
			byDouble = 2
		elseif v == 32 or v == 36 then
			byDouble = 3
		end
		local fknum = ( fkval or 1 ) * byDouble
		table.insert( costTb, fknum )
	end
	return costTb
end

-- 获取当前选择的房卡消耗数
function FriendRuleBase:getRoomCardCost( )
    return self._curCardCost
end

--[[
* @brief 创建带按钮的封顶
* @parm params 参数表
* @parm [in] num 显示的基数,默认显示1
* @parm [in] multiple 按钮加减一次的倍数,默认为1
* @parm [in] min 最小值
* @parm [in] max 最大值
* @parm [in] unit 单位
注：需要特殊方法的请在 “ src/hall/views/room/FriendFengDingNode.lua ” 文件中自行添加
ex：local params = { num = 100, multiple = 10, min = 40, max = 150, unit = "倍" }
    local fdnode = self:createFengDingNode( params )
    fdnode:setPosition( cc.p( 150, 150 ) )
    self:addChild( fdnode )
]]
function FriendRuleBase:createFengDingNode( params )
    local fdNode = require( "hall.views.room.FriendFengDingNode" ).new( nil, nil, params )
    -- 添加封顶标题
    local tParams = {point = cc.p(-63, 23)}
    self:setGroupTitle( fdNode, "封顶", tParams )
    return fdNode
end

-- 获取游戏规则表中的某个位置Tag值
function FriendRuleBase:getRuleTagByIndex( shortname, index )
    local fcData = require("hall.models.FriendCreateData")
    local cacheTb = fcData:GetRuleTableByName( shortname )
    if cacheTb then
        return checkint( cacheTb[index] )
    end
end

--[[
* @brief 更改某个按钮组的文本显示
* @parm btnGroup 需要改变的按钮组
* @parm textTb 更换的文本数据表
* @parm params 文本字体相关参数表,可不传
        params.fontSize 字体大小
        params.fontColor 字体颜色
        params.selectColor 选中颜色
注：不支持新增按钮个数的情况
]]--
function FriendRuleBase:changeBtnGroupText( btnGroup, textTb, params )
    params = params or {}
    local fontColor = params.fontColor or BTN_FONT_NORMAL_COLOR
    local selectColor = params.selectColor or BTN_FONT_SELECT_COLOR
    local fontSize = params.fontSize or BTN_FONT_SIZE
    for i,v in ipairs(btnGroup._checkBoxList) do
        if textTb[i] then
            v:setVisible( true )
            v:setText( textTb[i], fontColor, fontSize, "" )
            -- 如果有房卡消耗文本，调整位置
            local txt_cost = v:getChildByName( "txt_cost" )
            if txt_cost then
                -- 设置点击区域
                local panel = v:getTouchPanel()
                local size = panel:getContentSize()
                panel:setContentSize(cc.size(size.width + txt_cost:getContentSize().width, size.height))
                txt_cost:setPositionX(v:getContentSize_().width + 5)
            end
        else
            v:setVisible( false )
            -- 如果被隐藏的按钮所在的按钮组是单选类型，当该按钮是被选中的状态时，默认切换选中第一个按钮
            if btnGroup.type == 1 and v:isSelected() then
                btnGroup:onSelectedEvent( btnGroup._checkBoxList[1] )
            end
        end
    end
    self:changeBtnTxtColor( btnGroup, fontColor, selectColor )
end

--[[
* @brief 如果有按钮组的按钮设置了隐藏，需要重新设置按钮组位置调用这个方法
]]
function FriendRuleBase:resetBtnGroupPos( btnGroup )
    if btnGroup then
        btnGroup:resetVisibleCbPos()
    end
end

-- 设置某个按钮是否可以点击
function FriendRuleBase:setBtnEnabled(btn, bo)
    btn:setEnabled(bo)
    local panel = btn:getParent()
    if panel then
        self:changeBtnTxtColor(panel)
    end
end

-- 设置某个按钮组的分割线显示
function FriendRuleBase:showGroupCuttingLine(btnGroup, bo)
    local line = btnGroup:getChildByName("cuttingLine")
    if line then
        line:setVisible(bo)
    end
end

-- 获取按钮组中按钮的字体大小
function FriendRuleBase:getBtnFontSize()
    return BTN_FONT_SIZE
end

-- 获取按钮组中按钮的正常状态色值，选中状态色值
function FriendRuleBase:getBtnFontColor()
    return BTN_FONT_NORMAL_COLOR, BTN_FONT_SELECT_COLOR
end

-- 获取按钮置灰色值
function FriendRuleBase:getBtnUnableFontColor()
    return BTN_FONT_UNABLE_COLOR
end

return FriendRuleBase