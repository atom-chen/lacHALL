local PopupLayer=import(".PopupLayer")
local ExternalFun =  appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local PopupInfoLayer = appdf.req(appdf.EXTERNAL_SRC .. "PopupInfoLayer")
local ClipText = appdf.req(appdf.EXTERNAL_SRC .. "ClipText")
local PopupInfoHead = appdf.req(appdf.EXTERNAL_SRC .. "PopupInfoHead")

local PlayerlistLayer=class("PlayerlistLayer",PopupLayer)

function PlayerlistLayer:ctor(playerlist)
	PlayerlistLayer.super.ctor(self)
	self.csbNode=ExternalFun.loadCSB("Playerlist.csb",self)
	self.bg=appdf.getNodeByName(self.csbNode,"bg")
	self.cellBase=appdf.getNodeByName(self.csbNode,"cellBase")
	self.cellBase:setAnchorPoint(0,0)
	self.cellBase:setPosition(self.bg:getContentSize().width/2,0)
	self:showPlayerList(playerlist)
	self.cellBase:removeSelf()
	self.cellBase:retain()
	self.closeBtn=appdf.getNodeByName(self.csbNode,"closeBtn")
	self.closeBtn:addClickEventListener(function() self:removeSelf() end)
end

function PlayerlistLayer:showPlayerList(mplayerlist)
	if nil==mplayerlist then return end
	local playerlist={}
	for k,v in pairs(mplayerlist) do
		table.insert(playerlist,v)
	end

	self.playerlistArray=playerlist
	local function sortFunc(user1,user2) --按VIP等级从大到小、金币数从大到小
		local vip1=user1.cbMemberOrder or 0
		local vip2=user2.cbMemberOrder or 0
		local coin1=user1.lScore or 0
		local coin2=user2.lScore or  0
		if vip1~=vip2 then
			return vip1>vip2
		end
		return coin1>coin2
	end

	table.sort(playerlist,sortFunc)

	local len= #playerlist

	local function tableCellTouched(view, cell)
		 self.touchedCellIndex=cell:getIdx()
	end

	local function numberOfCellsInTableView()
		return math.ceil(len/3) --DefPlayerlistRows
	end

	local cellH=110
	local function cellSizeForTable(table,idx) 
    	return 879,cellH
	end

	local function tableCellAtIndex(table, idx) --idx从0开始
    	local cell=table:dequeueCell()
    	local playerRow
    	if nil==cell then
    		cell=cc.TableViewCell:create()
    		playerRow=self.cellBase:clone()
    		cell:addChild(playerRow)
    		playerRow:setPositionY(cellH/2)
    		playerRow:setName("playerRow")

    		local children=playerRow:getChildren()
    	end
    	
    	if nil==playerRow then
    		playerRow=cell:getChildByName("playerRow")
    	end

    	-- local chr=self.cellBase:getChildren()
    	-- print("chrlen: ",#chr)

    	-- local children=playerRow:getChildren()
    	-- print("chidld ",#children)
		for i=1,3 do
			local playerSp=playerRow:getChildByName("Image_"..i)
			local player=playerlist[idx*3+i]
			if nil==player then 
				playerSp:setVisible(false) 
				if i<3 then
					playerRow:getChildByName("Image_"..i+1):setVisible(false) 
					if i==1 then playerRow:getChildByName("Image_"..i+2):setVisible(false)  end 
				end
				break 
			else
				playerSp:setVisible(true)
			end
			local usrName=player.szNickName
			local coinNum=ExternalFun.formatScoreText(player.lScore)
			
            local headBG = playerSp:getChildByName("headsp")
            local head = PopupInfoHead:createClipHead(player, headBG:getContentSize().height)
		    head:setPosition(cc.p(headBG:getContentSize().width/2,headBG:getContentSize().height/2))
		    headBG:addChild(head)

    		local clipText=playerSp:getChildByName("cliptext")
    		if clipText~=nil then
    			clipText:setString(usrName)
    		else
	    		clipText= ClipText:createClipText({width=130,height=30},usrName)
				clipText:setTextFontSize(22)
				clipText:setAnchorPoint(cc.p(0,0.5))
				clipText:setPosition(95,65)
	    		clipText:addTo(playerSp)
	    		clipText:setName("cliptext")
	    	end
    		local uiText=playerSp:getChildByName("coinbg"):getChildByName("coinnum")
    		uiText:setString(coinNum)
    			:setAnchorPoint(0,0.5)
    			:setPositionX(41)

    		local vip=player.cbMemberOrder or 0
	    	local vipsp=playerSp:getChildByName("vipsp")
	    	if vipsp~=nil then vipsp:removeSelf() end
	    	if vip>=1 and vip<=5 then
				cc.Sprite:create("atlas_vipnumber.png",cc.rect(28*vip,0,28,26))
					:setName("vipsp")
					:addTo(playerSp)
					:setPosition(237,63)
	    	end
    	end
        
    	return cell
	end

	local tableView=cc.TableView:create(cc.size(960,330))
	tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(cc.p(0,100))
    tableView:setDelegate()
    self.bg:addChild(tableView)
    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
   -- tableView:registerScriptHandler(scrollViewDidScroll,cc.SCROLLVIEW_SCRIPT_SCROLL)
    -- tableView:registerScriptHandler(scrollViewDidZoom,cc.SCROLLVIEW_SCRIPT_ZOOM)
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    self.recordView=tableView
    tableView:reloadData()
end


function PlayerlistLayer:onTouchEnded(touch, event)
	
	if nil==self.touchedCellIndex then
		return
	end
   
   	local x=self.bg:getPosition()
	local loc=touch:getLocation()
	local col=math.ceil((loc.x-x+self.bg:getContentSize().width/2)/293)
	local idx=self.touchedCellIndex*3+col
	local n=#self.playerlistArray
	if nil==self.playerlistArray or n==0 or idx<=0 or idx>n then
		self.touchedCellIndex=nil
		return
	end

	local infoLayer=PopupInfoLayer:create(self, true)
	infoLayer:showLayer(true)
	self:addChild(infoLayer)
	infoLayer:setPosition(200,-140)
	infoLayer:refresh(self.playerlistArray[idx], cc.p(300,300 ) )
	self.touchedCellIndex=nil
end

function PlayerlistLayer:onExit()
	self.cellBase:release()
	PlayerlistLayer.super.onExit(self)
end


return PlayerlistLayer