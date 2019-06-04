--[[
* 事件回调类
* CCNotificationCenter在LUA中存在缺陷,对于同一个消息,只能存在一个绑定,并且需要在对象
* 销毁时进行移除,而LUA中没有析构函数,所以添加此类,通过C++接口实现多个消息绑定
]]

--全局事件对象表
local EventSink = EventSink or {};

--事件对象列表元表,弱引用key,当key销毁,自动取消绑定的事件
local mtList = {};
mtList.__mode = "k";

local function Init()
    local obj = {};
    setmetatable(obj, mtList);
    return obj;
end

local regList = Init();

--[[
* @brief 添加一个事件绑定
* @param obj 绑定的事件生命期跟这个对象关联,如果这个对象被GC,则事件取消绑定
* @param msg 事件对应的字符串
* @param callback 事件的回调函数
* @note 同一个obj对于同一个msg,只能有一个绑定,后绑定将覆盖前面已有的绑定
]]
function EventSink.AddSink(obj, msg, callback)
    for k, v in pairs(regList) do
        if k == obj then
            v:AddFun(msg, callback);
            return;
        end
    end

    local sink = CLuaEventSink:New();
    sink:AddFun(msg, callback);
    regList[obj] = sink;
end

--[[
* @brief 移除一个事件绑定
* @param obj 绑定事件的关联对象
* @param msg 绑定的消息
]]
function EventSink.RemoveSink(obj, msg)
    local sink = regList[obj];
    if sink == nil then
        return;
    end

    sink:RemoveFun(msg);

    if sink:IsEmpty() then
        regList[obj] = nil;
    end
end

--[[
* @brief 移除针对特定obj绑定的所有事件
]]
function EventSink.RemoveAllMsg(obj)
    local sink = regList[obj];
    if sink == nil then
        return;
    end

    sink:RemoveALLMessage();
    regList[obj] = nil;
end

--[[
* @brief 移除所有事件通知（仅通过EventSink注册的）
]]
function EventSink.RemoveAllObj()
    for k, v in pairs(regList) do
        v:RemoveALLMessage();
    end

    regList = Init();
end

