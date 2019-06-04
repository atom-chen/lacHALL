local M = {}

--[[
    * 描述：开启游戏是否自带自定义参数
    * 备注：如果要使用该接口，请注册c_system接口，请搜索lua_open_system_argv
    * 备注：自定义参数判断条件为，字符串含有","
--]]
function M:hasArgc()
    if nil == c_system then
        return
    end

    local argv = c_system:getArgv()
    for _,arg in ipairs(argv) do
        local res = string.find(arg, ",")
        if res then
            return true 
        end
    end
    return false
end

--[[
    * 描述：获取自定义参数数据
           自定义数据格式如 xx:xx, xx:xx 以:和,分开
           如username:nihao, password:1233456
    * 备注：如果要使用该接口，请注册c_system接口，请搜索lua_open_system_argv
    * 返回值：{ username=nihao, password=123456, roomid=55 }
--]]
function M:getCustomData()
    if nil == c_system then
        return {}
    end

    local argv = c_system:getArgv()
    for _,arg in ipairs(argv) do
        local res = string.find(arg, ",")
        local res2 = string.find(arg, "=")
        if res and res2 then
            return String:splitToTable(arg, ",", "=") 
        end
    end
    return nil 
end

return M

