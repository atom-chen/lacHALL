-- 房间列表数据
-- Date: 2016-09-07 09:59:27
--
local RoomData = class("RoomData")

function RoomData:ctor(gameinfo)
	self.gameinfo_ = gameinfo
	self.re_type_ = gameinfo.relation_type
	self.roomlist_=nil 
end

function RoomData:addRoom(room)
 
	if room == nil then return  end

	room.kind = RELATION_TYPE_ROOM 
	room.shell = "Room://"..tostring(room.id) 

	--//检测是否有关系节点
	for kr,vr in pairs(hallmanager.relations)do
		if vr.parenttype==RELATION_TYPE_GAME and vr.parenttype == room.gameid and vr.objecttype==RELATION_TYPE_ROOM and vr.objectid==k then
			room.cmd.sort= vr.sort 
			for kc,vc in pairs(vr.cmd)do room.cmd[kc]=vc end
		end
	end

	if room.cmd.hidden==nil and tonumber(room.cmd.hidden) ~= 0 then
		if room.cmd.shell then
			room.shell = room.cmd.shell 
		end
		room.sort = tonumber(room.cmd.sort) or DEFAULT_SORT_INDEX 
		table.insert(self.roomlist_,room)
	end

end

-- 添加节点
function RoomData:addRelation( relation )
	printf("RoomLayer:addRelation")
	if relation == nil then return  end 

	relation.shell=	"Relation://"..tostring(relation.id) 
	relation.kind= RELATION_TYPE_RELATION 

	--//检测是否有关系节点
	for kr,vr in pairs(hallmanager.relations)do
		if vr.parenttype==RELATION_TYPE_GAME and vr.parenttype == game.id and vr.objecttype==RELATION_TYPE_RELATION and vr.objectid==k then
			relation.sort= vr.sort 
			for kc,vc in pairs(vr.cmd)do relation.cmd[kc]=vc end
		end
	end

	if relation.cmd.hidden==nil and tonumber(relation.cmd.hidden) ~= 0 then
		if relation.cmd.shell then
			relation.shell = relation.cmd.shell 
		end
		table.insert(self.roomlist_,relation) 
	end
end

-- 添加游戏节点
function RoomData:addGame( game )

    if not game then
        return
    end
	game.shell = "Game://"..tostring(game.id) 
	game.kind = RELATION_TYPE_GAME 

    --//检测是否有关系节点
	for kr,vr in pairs(hallmanager.relations)do
		if vr.parenttype == RELATION_TYPE_GAME and vr.parenttype == game.id and vr.objecttype == RELATION_TYPE_GAME and vr.objectid==k then
			game.sort = vr.sort 
			for kc,vc in pairs(vr.cmd) do 
                game.cmd[kc] = vc 
            end
		end
	end

    if game.cmd.hidden == nil and tonumber(game.cmd.hidden) ~= 0 then
		if game.cmd.shell then
			game.shell = game.cmd.shell 
		end
		table.insert(self.roomlist_,game) 
	end


end

function RoomData:getRoomList()

	--//计算房间列表
	local RoomList = {} 
	self.roomlist_= RoomList 
	local rooms = hallmanager.rooms 
	printf("RoomLayerupdateRoomData:RoomData:getRoomLis");
	local relations = hallmanager.relations 
    local games = hallmanager.games

	if self.re_type_ == RELATION_TYPE_GAME then --//游戏	
		local game = self.gameinfo_ 
		for k,v in pairs(rooms)do --先添加房间
			if v.gameid == game.id and tonumber(v.cmd.hidden) ~= 1 then --属性带hidden的房间在游戏中不可见
				self:addRoom(gg.TableClone(v)) 
			end
		end

		for k,v in pairs(relations) do --添加关系节点
			if v.parenttype == RELATION_TYPE_GAME and v.pairs == game.id and v.objecttype == RELATION_TYPE_ROOT then
				self:addRelation(gg.TableClone(v)) 
			end
		end
	else --//节点
		local relation = self.gameinfo_ 
		for k,v in pairs(relations)do
			if v.parenttype == RELATION_TYPE_RELATION and v.parentid == relation.id then
				if v.objecttype == RELATION_TYPE_ROOM  then --房间
					self:addRoom(rooms[v.objectid]) 

				elseif v.objecttype == RELATION_TYPE_RELATION then--节点
					self:addRelation(relation[v.objectid]) 
                elseif v.objecttype == RELATION_TYPE_GAME then
                    
                    self:addGame(games[v.objectid]) 

				end
			end
		end
	end

	table.sort(RoomList,function(a,b) return 

		checkint( a.sort ) <checkint( b.sort  )
		end) 

	return RoomList

end

return RoomData
