----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：一些通用接口
----------------------------------------------------------------------

local function valToStr(val)
    local str = ""
    if str == nil then
        str = str .. "nil"
    elseif type(val) == "boolean" then
        str = val and str .. "true" or str .. "false"
    elseif type(val) == "number" then
        str = str .. tostring(val)
    elseif type(val) == "string" then
        str = str .. tostring(val)
    elseif type(val) == "userdata" then
        str = str .. "userdata"
    end
    return str
end

local oldPrint = print
local function print(...)
    local tb = {...}
    local str = ""
    local bFirst = true
    for _, val in ipairs(tb) do
        if not bFirst then
            str = str .. "   "
        end
        str = str .. valToStr(val)
        bFirst = false
    end
    oldPrint(str)
end

function LogKeys(obj, sFind)
	if not sFind then
		Log(obj)
		return 
	end

	sFind = sFind:upper()
	local t = {}
	for k,v in pairs(obj) do
		if type(k) == "string" and k:upper():find(sFind) then
			t[k] = v
		end
	end
	Log(t)
end

-- Log 支持多参数
function Log(...)
    --local str = print(debug.traceback("", 2))
    --str = string.split(str, "")
	local args = {...}
	if #args == 0 then
		print("nil")
		return 
	end

    local hasTable = false
	for _, v in ipairs(args) do
		local sType = type(v)
		if sType == "table" then
            hasTable = true
            break
        end
	end
    if not hasTable then
        print(...)
    else
        local str = debug.traceback("", 2)
        local tb = string.split(str, "\n")
        str = tb[3]
        print(str)
        LogTable(args[1])
    end
end
-- Log 支持加打印的层数
function LogSimple(tab,n)
	if not n then
		n = 2
	end
	if not tab then
		print("nil")
		return
	end
	LogTable(tab,nil,nil,n)
end



function LogTable(obj,parentDic,indent,deep)
	if not deep then
		deep = 10
	end
	deep = deep - 1 
	if deep < 0 then
		return
	end
	parentDic = parentDic or {}
	parentDic[obj] = true
	indent = indent or ""
	local oldIndent = indent
	print(indent.."{")
	indent = indent.."    "

	for k, v in pairs(obj) do
		local kType = type(k)
		local kStr = indent
		if kType == "number" then
			kStr = kStr.."["..k.."]"
		else
			kStr = kStr..tostring(k)
		end
		local sType = type(v)
		if sType == "table" then
			if parentDic[v] then
				print(kStr,"=","table is nest in parent")
			else
				print(kStr, "=")
				LogTable(v,parentDic,indent,deep)
			end
		elseif sType == "string" then
			print(kStr,"=", "'"..tostring(v).."'")
		else
			print(kStr,"=", tostring(v))
		end
	end

	print(oldIndent.."}")
	parentDic[obj] = nil
end


-- 显示图片占用内存
function LogPicMem()
	cc.TextureCache:getInstance():dumpCachedTextureInfo()
end


function Md5Crypto(str)
    return md5_crypto(str, str:len()) or ""
end

-- 执行dos命令
function RunDosCmd(cmdStr)
	local cmd = io.popen(cmdStr)
    local tb = {}
	if cmd then
		for k, _v in cmd:lines() do
			table.insert(tb, k)
		end
		cmd:close()
		return tb
	end
	return nil
end

----------------------------------------------------------------------
-- 日期：2016-3-31
-- 描述：通用函数
----------------------------------------------------------------------

-- 把node里的子控件挂载在ui对象上
function BindToUI(widget, obj, cf)
    if widget == nil or tolua.isnull(widget) then return end
    -- 按钮事件
    local function buttonEventHandler(child)
        local name = child:getName()
        local func = obj["click_"..name]
        if func then 
            func(obj, child)
        else
            print("no function", obj.__cname, "click_"..name)
        end
    end

    local function visitChild(child)
        local name = child:getName()
		if (not name) or name == '' then
			return
		end
        local com = child:getComponent("__ui_layout")
        if com and cf then cf(child, com) end
        --print(name)
		obj[name] = child -- 
		if tolua.iskindof(child, 'ccui.Button') or tolua.iskindof(child, 'ccui.CheckBox') then
			child:onClick(function() buttonEventHandler(child) end, 2)
		end
    end

    -- 遍历所有子控件
    local function visitAll(nd, fn)
	    local function fnVisitAll(nd, fn)
		    for k, child in pairs(nd:getChildren()) do
			    local bStop = fn(child)
			    if bStop then
				    return bStop
			    end
                if not tolua.iskindof(child, 'cc.TMXTiledMap') then
                    bStop = fnVisitAll(child, fn)
			        if bStop then
				        return bStop
			        end
                end
		    end
	    end

	    return fnVisitAll(nd, fn)
    end
    visitAll(widget, visitChild)
end

function NodeBindToTable(widget, obj, cf)
    if widget == nil or tolua.isnull(widget) then return end
    local function visitChild(child)
        local name = child:getName()
		if (not name) or name == '' then
			return
		end
        local com = child:getComponent("__ui_layout")
        if com and cf then cf(child, com) end
        --print(name)
		obj[name] = child -- 
    end

    -- 遍历所有子控件
    local function visitAll(nd, fn)
	    local function fnVisitAll(nd, fn)
		    for k, child in pairs(nd:getChildren()) do
			    local bStop = fn(child)
			    if bStop then
				    return bStop
			    end
                if not tolua.iskindof(child, 'cc.TMXTiledMap') then
                    bStop = fnVisitAll(child, fn)
			        if bStop then
				        return bStop
			        end
                end
		    end
	    end
	    return fnVisitAll(nd, fn)
    end
    visitAll(widget, visitChild)
end

-- 移除某个结点
function SafeRemoveNode(node)
    if node == nil or tolua.isnull(node) then return end
    node:removeFromParent(true)
end

-- 弹出消息框
function MsgBox(content)
    printError("")
    content = content or ""
    local str = valToStr(content)
    CCMessageBox(str, "")
end

-- 调用
function Invoke(target, name, ...)
    if target == nil then return end
    local func = target[name]
    if func == nil then return end
    return func(target, ...)
end

-- 重新加载lua文件
function ReloadLuaModule(name)
    package.loaded[name] = nil
    return require(name)
end

-- 清空该文件夹下所有加载的lua文件
function CleanDirLuaModule(dir)
    if cc.Application:getInstance():getTargetPlatform() ~= 0 then return end
    local workDir = RunDosCmd("cd")[1]
    local tb = RunDosCmd("dir " .. dir .. " /b/s")
    local tail = ".lua"
    local per = string.gsub(dir, "\\", ".") .. "."
	for _, val in ipairs(tb) do
		local path = string.sub(val, #workDir + 2)
        if string.sub(path, -4) == tail then
            path = string.gsub(path, ".lua", "")
            path = string.gsub(path, "\\", ".")
            package.loaded[path] = nil
        end
	end
end

-- 继承类
function ExtendClass(obj, cls)
    local parent = cls.new()
    if parent.super then
        ExtendClass(obj, parent.super)
    end
    --Log("++++++++++++++++++++", cls.__cname)
    -- 继承变量
    for name, val in pairs(parent) do
        if obj[name] == nil and name ~= "class" then
            --print("value", name, obj[name], val)
            obj[name] = val
        end
    end

    -- 继承方法
    for name, val in pairs(cls) do
        if obj[name] == nil then
            --Log("function", name, obj[name], val)
            obj[name] = val
        end
    end
end

-- 继承类
function WrapGameObject(obj, cls, parent)
    local parent = cls.new()
    if parent.super then
        WrapGameObject(obj, parent.super)
    end
    --Log("++++++++++++++++++++", cls.__cname)
    -- 继承变量
    for name, val in pairs(parent) do
        if obj[name] == nil and name ~= "class" then
            --print("value", name, obj[name], val)
            obj[name] = val
        end
    end

    -- 继承方法
    for name, val in pairs(cls) do
        if type(val) == "function" then
            --Log("function", name)
            obj[name] = val
        end
    end
end

-- 是否属于某个类
function IsKindOf(cls, name)
    if cls.__cname == name then return true end
    if cls.super then
        return IsKindOf(cls.super, name)
    end
    return false
end

-- 调试对象
function DebugGameObject(obj)
    local name = obj._filePath
    local cls = ReloadLuaModule(name)
    --print("DebugGameObject", name)
    for key, val in pairs(cls) do
        if type(val) == "function" then
            obj[key] = val
        end
    end
end

-- 功  能：生成多重排序规则
function MakeSortRule(...)
	local fnList = {...}
	local fnMore = function(x, y)
		for i = 1, #fnList do
			local fn = fnList[i]
			if fn(x, y) then
				return true
			elseif fn(y, x) then
				return false
			end

		end
		return false
	end
	return fnMore
end

----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：协程
----------------------------------------------------------------------

Coroutine = class("Coroutine")

function Coroutine:init(func, target)
	self.mUpdateFunc = nil		-- 更新函数接口
	self.mScene = nil			-- 所在的场景
    self.mNode = nil            -- 所运行的结点
    self.coroutine = nil
    self.mSchedulerId = nil
    self.mAlive = true
    self.function_name = ""
	local scheduler = cc.Director:getInstance():getScheduler()
    self.mSchedulerId = scheduler:scheduleScriptFunc(function(dt) self:onUpdate(dt) end, 0, false)
    local co = coroutine.create(func)
    self.coroutine = co
    return true
end

-- 清除协程
function Coroutine:cleanup()
    if not self.mAlive then return end
    --print("++++++++++++++++++关闭协程" .. self.function_name)
    self.mAlive = false
    if self.mSchedulerId then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.mSchedulerId)
        self.mSchedulerId = nil
    end
end

-- 每帧更新
function Coroutine:onUpdate(dt)
	-- 场景判断是否存活
	if self.mScene and tolua.isnull(self.mScene) then
        self.mNeedCleanup = true
        self:resume()
		self:cleanup()
		return
	end
    -- 绑定的结点是否存活
    if self.mNode and tolua.isnull(self.mNode) then
        self.mNeedCleanup = true
        self:resume()
        self:cleanup()
		return
    end
    if self.mUpdateFunc then self.mUpdateFunc(dt) end
end

-- 暂停
function Coroutine:pause(name, timeout)
    self.timeout = timeout
    --print("pause", name, timeout)
    coroutine.yield()
    -- 强制杀死协程
    if self.mNeedCleanup then
        Log("kill coroutine", name)
        NEED_TRACK_COROUTINE_ERROR = false
        local errors = nil
        errors = errors + 1
    end
end

-- 设置更新函数
function Coroutine:setUpdateFunc(handler)
    self.mUpdateFunc = handler
end

-- 恢复
function Coroutine:resume(name)
    self.mUpdateFunc = nil
    --print("resume", name, status)
    local success, yieldType, yieldParam = coroutine.resume(self.coroutine, self)
    if not success then
        print("resume failed", success, yieldType, yieldParam)
        self:cleanup()
        return
    end
    local status = coroutine.status(self.coroutine)
    -- 判断协程是否结束
    if status == "dead" then
    	self:cleanup()
    end
end

-- 描述：协程基本等待

local mCoroutineId = 0
NEED_TRACK_COROUTINE_ERROR = true

_CE_TRACKBACK_ = function(msg)
    if not NEED_TRACK_COROUTINE_ERROR then
        NEED_TRACK_COROUTINE_ERROR = true
        return
    end
    print("协程出错")
    local msg = debug.traceback(msg, 3)
	print(msg)
end

-- 创建新的协程
function NewCoroutine(target, name, ...)
	local func = target[name]
    local args = {...}
    if func == nil then
        assert("start coroutine can't find function name by "..name)
        return false
    end

    local co = nil
    local function callback()
        if type(target) == "function" then
            func(co, unpack(args))
        else
            func(target, co, unpack(args))
        end
    end

	-- 协程主函数
    local function executeFunc()
        if cc.Application:getInstance():getTargetPlatform() ~= 0 then
            callback()
        else
            xpcall(function() callback() end, _CE_TRACKBACK_)
        end
    end
    co = Coroutine.new()
    co:init(executeFunc)
	return co
end

-- 开启协程
function StartCoroutine(target, name, ...)
    local co = NewCoroutine(target, name, ...)
    co:resume("start run")
	return co
end

-- 等待数秒
function WaitForSeconds(co, seconds)
    WaitForFrames(co, 1)
    local function onUpdate(dt)
        if seconds > 0 then
            seconds = seconds - dt
        end
        if seconds <= 0 then
            co:resume("WaitForSeconds")
        end
    end
    co:setUpdateFunc(onUpdate)
    co:pause("WaitForSeconds")
end

-- 等待数帧
function WaitForFrames(co, frames)
    local function onUpdate(dt)
        if frames > 0 then
            frames = frames - 1
        end
        if frames <= 0 then
            co:resume("WaitForFrames")
        end
    end
    co:setUpdateFunc(onUpdate)
    co:pause("WaitForFrames")
end

-- 等待函数返回值为true 或不为nil
function WaitForFuncResult(co, func)
    local function onUpdate()
        if func() then
            co:resume("WaitForFuncResult")
        end
    end
    co:setUpdateFunc(onUpdate)
    co:pause("WaitForFuncResult")
end




