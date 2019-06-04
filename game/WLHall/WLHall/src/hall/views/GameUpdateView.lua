
-- Author: zhaoxinyu
-- Date: 2016-11-10 11:04:16
-- Describe：游戏更新界面

local GameUpdateView = class("GameUpdateView",cc.Node)

--[[
* @brief 创建函数
]]
function GameUpdateView:ctor()

	-- 初始化数据
	self:init()

	-- 初始化UI
	self:initView()
end

--[[
* @brief 初始化数据
]]
function GameUpdateView:init()

	self._progress = nil 			-- 进度条
	self._txt = nil 				-- 描述
end

--[[
* @brief UI初始化
]]
function GameUpdateView:initView()

	-- 创建进度条
    local progress = cc.ProgressTimer:create(cc.Sprite:create("hall/hall/download_mask.png"))
    progress:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
    self:addChild( progress)
    self._progress = progress
    progress:setPercentage( 0 )

    -- 文本
    local txt_des = ccui.Text:create()
    txt_des:setColor( { r = 0 , g = 0 , b = 0 } )
    txt_des:setString([[等待]])
    self:addChild(txt_des)
    self._txt = txt_des
    txt_des:setVisible(false)
end

--[[
* @brief 设置等待
]]
function GameUpdateView:setWait()

	self._txt:setVisible(true)
end

--[[
* @brief 设置进度
]]
function GameUpdateView:setPercent( percentage )

	-- 更新UI进度
	self._progress:setPercentage( percentage )
	self._txt:setVisible(false)

	-- -- 下载完成销毁
	-- if percentage >= 100 then
	-- 	self:removeFromParent( true )
	-- end
end

--[[
* @brief 设置总进度
]]
function GameUpdateView:setTotal( total , percentage )



end

--[[
* @brief 设置详细说明
]]
function GameUpdateView:setDesc( txt )

	print( "desc:"..txt )
end

return GameUpdateView