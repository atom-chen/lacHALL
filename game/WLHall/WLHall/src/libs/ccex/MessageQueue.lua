
--[[
    * 描述：用于网络延迟，服务器连续发送多条事件则需按顺序播放动画效果或加快播放速度
--]]
local M = {}
local m_isLocking = false 
local m_messageQueue = {}
local m_maxSize = 5

function M:lock()
    m_isLocking = true
end

function M:unlock()
    m_isLocking = false
end

--[[
    * 描述：添加消息事件
    * 参数：actionFun(isMuch)处理流程
           isMuch当前消息队列数量超过设置的最大数量，通过该参数判断是否需要加速动画播放
--]]
function M:add(actionFun)
    assert(actionFun)
    
    table.insert(m_messageQueue, actionFun)
    if not m_isLocking then
        self:next()
    end
end

--[[
    * 描述：actionFun执行完毕需要手动调用该接口
--]]
function M:next()
    self:unlock()

    if #m_messageQueue < 1 then
        return
    end

    local actionFun = m_messageQueue[1]
    table.remove(m_messageQueue, 1)

    self:lock()

    local isMuch = #m_messageQueue > m_maxSize
    actionFun(isMuch)
end

function M:clear()
    self:unlock()
    m_messageQueue = {}
end

return M

