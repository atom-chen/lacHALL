--
-- Author: zhong
-- Date: 2016-07-07 18:09:11
--
--玩家列表
local module_pre = "game.yule.sicbobattle.src"

local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")
local g_var = ExternalFun.req_var;
local UserItem = module_pre .. ".views.layer.userlist.UserItem"

local UserListLayer = class("UserListLayer", function (  )
	local colorLayer = cc.LayerColor:create(cc.c4b(0,0,0,100))
	return colorLayer
end)

--UserListLayer.__index = UserListLayer
UserListLayer.BT_CLOSE = 1

function UserListLayer:ctor( )
	--注册事件
	ExternalFun.registerNodeEvent(self) -- bind node event

	--用户列表
	self.m_userlist = {}

	--加载csb资源
	local csbNode = ExternalFun.loadCSB("game/118_userList.csb", self)
	csbNode:setPosition(yl.WIDTH/2,yl.HEIGHT/2)
	local sp_bg = csbNode:getChildByName("Sprite_userListBg")
	self.m_spBg = sp_bg
	local content = sp_bg:getChildByName("content")
	print("content:getContentSize()",content:getContentSize().width,content:getContentSize().height)
	--用户列表
	local m_tableView = cc.TableView:create(content:getContentSize())

	m_tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	m_tableView:setPosition(content:getPositionX(),content:getPositionY())
	m_tableView:setDelegate()
	m_tableView:registerScriptHandler(self.cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
	m_tableView:registerScriptHandler(handler(self, self.tableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX)
	m_tableView:registerScriptHandler(handler(self, self.numberOfCellsInTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
	sp_bg:addChild(m_tableView)
	self.m_tableView = m_tableView;
	content:removeFromParent()

	--关闭按钮
	local function btnEvent( sender, eventType )
		if eventType == ccui.TouchEventType.ended then
			self:onButtonClickedEvent(sender:getTag(), sender);
		end
	end
	local btn = sp_bg:getChildByName("Button_close")
	btn:setTag(UserListLayer.BT_CLOSE)
	btn:addTouchEventListener(btnEvent);

	content:removeFromParent()
end

function UserListLayer:refreshList( userlist )
	self:setVisible(true)
	self.m_userlist = userlist
	self.m_tableView:reloadData()
end

--tableview
function UserListLayer.cellSizeForTable( view, idx )
	return g_var(UserItem).getSize()
end

function UserListLayer:numberOfCellsInTableView( view )
	if nil == self.m_userlist then
		return 0
	else
		return #self.m_userlist
	end
end

function UserListLayer:tableCellAtIndex( view, idx )
	local cell = view:dequeueCell()
	
	if nil == self.m_userlist then
		return cell
	end

	local useritem = self.m_userlist[idx+1]
	local item = nil

	if nil == cell then
		cell = cc.TableViewCell:new()
		item = g_var(UserItem):create()
		item:setPosition(view:getViewSize().width * 0.5, 0)
		item:setName("user_item_view")
		cell:addChild(item)
	else
		item = cell:getChildByName("user_item_view")
	end

	if nil ~= useritem and nil ~= item then
		item:refresh(useritem, false, idx / #self.m_userlist)
	end

	return cell
end
--

function UserListLayer:onButtonClickedEvent( tag, sender )
	ExternalFun.playClickEffect()
	if UserListLayer.BT_CLOSE == tag then
		self:setVisible(false)
	end
end

function UserListLayer:onExit()
	local eventDispatcher = self:getEventDispatcher()
	eventDispatcher:removeEventListener(self.listener)
end

function UserListLayer:onEnterTransitionFinish()
	self:registerTouch()
end

function UserListLayer:registerTouch()
	local function onTouchBegan( touch, event )
		return self:isVisible()
	end

	local function onTouchEnded( touch, event )
		local pos = touch:getLocation();
		local m_spBg = self.m_spBg
        pos = m_spBg:convertToNodeSpace(pos)
        local rec = cc.rect(0, 0, m_spBg:getContentSize().width, m_spBg:getContentSize().height)
        if false == cc.rectContainsPoint(rec, pos) then
            self:setVisible(false)
        end        
	end

	local listener = cc.EventListenerTouchOneByOne:create();
	listener:setSwallowTouches(true)
	self.listener = listener;
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN );
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED );
    local eventDispatcher = self:getEventDispatcher();
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self);
end

return UserListLayer