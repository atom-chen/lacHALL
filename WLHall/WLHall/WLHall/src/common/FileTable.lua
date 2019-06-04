--[[
* 序列化/反序列化表到文件
]]

local FileTable = {};

if not json then
    require "cocos.cocos2d.json"
end

--创建一个序列化对象
function FileTable.New()
    local tmp = {};
    local mt = {};
    mt.__index = FileTable;
    setmetatable(tmp, mt);
    return tmp;
end

--读取一个文件,并序列化为table
function FileTable:Open(filename)
    self.filename = filename;
    if not Helper.IsFileExist(filename) then
        self.lastsaved={}
        return {};
    else
        local fObj = io.open(filename)
        local content = fObj:read("*all")
        local ok, func = pcall(function() return loadstring(content) end)
        local tmp
        if ok and type(func) == "function" then
            -- 是 lua 格式的，解析之后转存储为 json 格式
            tmp = func() or {}
            self:Save(tmp, filename)
        else
            -- 是 json 格式，直接解析
            tmp = json.decode(content) or {}
        end
        self.lastsaved = gg.TableClone(tmp);
        return tmp;
    end
end

--保存一个表到文件,filename如果为nil,则保存为打开时的文件名
function FileTable:Save(t, filename)
    if gg.TableComp(t, self.lastsaved) then
        return true;
    end

    self.lastsaved = gg.TableClone(t);
    filename = filename or self.filename;

    local fWrite = io.open(filename, "w+");
    if fWrite then
        fWrite:write(json.encode(t));
        fWrite:close();
        return true;
    else
        printf("回写文件失败！filename:" .. filename)
        return false;
    end
end

--获得最后一次序列化的数据内容
function FileTable:LastSaved()
    return self.lastsaved;
end

--获得文件名
function FileTable:GetFileName()
    return self.filename;
end

return FileTable;

