local M = {}
local m_notificationMgr = {}

--[[
    * 描述：添加通知事件
    * 参数：target谁来接听
    * 参数：notiName通知名称，也是函数名，函数名统一以onNotificationXXX()开头
--]]
function M:addNotification(target, notiName)
	assert(target and notiName)
   	local listener = { target=target, name=notiName }
   	table.insert(m_notificationMgr, listener)
end

function M:postNotification(notiName, ...)
    assert(notiName)
	for _, listener in pairs(m_notificationMgr) do
		if listener.name==notiName and listener.target and listener.target[notiName] then
			listener.target[notiName](listener.target, ...)
		end
	end
end


function M:removeNotification(target)
	assert(target)
	for key, listener in pairs(m_notificationMgr) do 
        if listener.target == target then 
        	m_notificationMgr[key] = nil
        end
    end
end

function M:removeNotificationByName(target, notiName)
    assert(target and notiName)
    for key, listener in pairs(m_notificationMgr) do 
        if listener.target==target and listener.name==notiName then 
        	m_notificationMgr[key] = nil
        end
    end
end

return M