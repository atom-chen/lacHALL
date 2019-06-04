local FriendFengDingNode = class("FriendFengDingNode", cc.load("ViewBase"))

FriendFengDingNode.RESOURCE_FILENAME = "ui/room/friendroom/fc_fengding_node.lua"
FriendFengDingNode.RESOURCE_BINDING = {
	["txt_num"]   = { ["varname"] = "txt_num"  }, 
	["txt_unit"]  = { ["varname"] = "txt_unit" },	   
	["btn_minus"] = { ["varname"] = "btn_minus", ["events"] = { { event = "click_color", method = "onClickMinus" } } },
	["btn_add"]   = { ["varname"] = "btn_add",   ["events"] = { { event = "click_color", method = "onClickAdd"   } } },
}	    

--[[
* @parm params 参数表
* @parm [in] num 显示的基数,默认显示1
* @parm [in] multiple 按钮加减一次的倍数,默认为1
* @parm [in] min 最小值
* @parm [in] max 最大值
* @parm [in] unit 单位
]]
function FriendFengDingNode:onCreate( params )
	self:init( params )
end

function FriendFengDingNode:init( params )
	local params = params or {}
	self._num = params.num or 1
	self._multiple =  params.multiple or 1
	self._min = params.min or 1
	self._max = params.max or 9999999999
	self._unit = params.unit or ""
	self.txt_num:setString( self._num )
	self.txt_unit:setString( self._unit )
end

-- 获取封顶数量
function FriendFengDingNode:getFengDingNum( )
	return self._num
end

-- 设置封顶数量
function FriendFengDingNode:setFengDingNum( count )
	self._num = count
	self.txt_num:setString( self._num )
end
-- 获取封顶数量文本的位置
function FriendFengDingNode:getNumPosition( )
	return self._num:getPosition()
end

-- 设置封顶数量的位置
-- posX x坐标
-- udistance 单位距离数量的距离,可不传
function FriendFengDingNode:setNumPositionX( posX, udistance )
	self._num:setPositionX( posX )
	self._unit:setPositionX( posX + udistance or 7 )
end

-- 设置最大值
function FriendFengDingNode:setMaxNum( max )
	self._max = max
end

-- 设置最小值
function FriendFengDingNode:setMinNum( min )
	self._min = min
end

-- 设置单位
function FriendFengDingNode:setUnit( unit )
	self._unit = unit
	self.txt_unit:setString( self._unit )
end

-- 加
function FriendFengDingNode:onClickAdd( sender )
	self._num = self._num + self._multiple
	if self._num > self._max then
		self._num = self._max
	end
	self.txt_num:setString( self._num )
	self:onAdd()
end

-- 减
function FriendFengDingNode:onClickMinus( sender )
	self._num = self._num - self._multiple
	if self._num < self._multiple then
		self._num = self._multiple
	end
	if self._num < self._min then
		self._num = self._min
	end
	self.txt_num:setString( self._num )
	self:onMinus()
end

function FriendFengDingNode:onAdd()
end

function FriendFengDingNode:onMinus()
end

return FriendFengDingNode