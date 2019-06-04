--
-- Abasehor: lee
-- Date: 2016-08-18 11:37:39
--

local M = {}

-- 创建目录
function M.Mkdir(path)
    if device.platform == "windows" then
        os.execute("mkdir \"" .. path .. "\"")
    else
        os.execute("mkdir -p \"" .. path .. "\"")
    end
    return path
end

function M.ClearGameRequire(shortname)
    local loaded = package.loaded
    for k, v in pairs(loaded) do
        if M.StartWith(k, string.format("games.%s", shortname)) or M.StartWith(k, string.format("games/%s", shortname)) then
            loaded[k] = nil
        end
    end
end

function M.StartWith(source, str,case_sensitive)
    assert(source,"StartWith source is nil")
    str= str or ""
    local len = string.len(str)
    if case_sensitive then --大小写敏感
        return string.sub(source, 1, len) == str
    else
        return string.lower(string.sub(source, 1, len)) == string.lower(str)
    end
end

--获取路径或 文件扩展名
function M.GetFileExt(filename)
    filename=checkstring(filename)
    return filename:match(".+%.(%w+)$")
end

--获取文件路径
function M.GetFilePath(filename)
    return string.match(filename, "(.+)/[^/]*%.%w+$") -- *nix system
    --return string.match(filename, “(.+)\\[^\\]*%.%w+$”) — windows
end

--获取文件名
function M.GetFileName(filename)
    return string.match(filename, ".+/([^/]*%.%w+)$") -- *nix system
    --return string.match(filename, “.+\\([^\\]*%.%w+)$”) — *nix system
end

--去除扩展名
function M.StripFileExt(filename)
    local idx = filename:match(".+()%.%w+$")
    if(idx) then
        return filename:sub(1, idx-1)
    else
        return filename
    end
end

--相当于C++中的?:运算符
function M.IIF(condition, v1, v2)
    if condition then
        return v1;
    else
        return v2;
    end
end

function M.GetFileTable(file_path)
    local file_data = loadfile(file_path)

    if not file_data then
        local msg = "'".. tostring(file_path) .."' 文件不存在！"
        return false, msg
    end

    local ok, file_table = pcall(file_data)
    return ok, file_table
end

function M.GetManifestTable(manifest_path)
    assert(manifest_path,"manifest_path is nil error")

    local ok = false
    local manifest_table = nil

    local MANIFEST_FILE = nil
    local ext = string.lower(gg.GetFileExt(manifest_path) or "")
    if ext == "" then
        -- 优先使用带 .lua 后缀的文件
        ok, manifest_table = gg.GetFileTable(manifest_path .. ".lua")
    end

    if not ok then
        -- 没有用到自动补全 .lua 后缀的功能，直接读取传入的文件
        ok, manifest_table = gg.GetFileTable(manifest_path)
    end

    if not ok then
        print("--load manifest error :"..tostring(manifest_table))
    end
    return ok, manifest_table
end

function M.CreatEnumTable(tbl, index)
    local enumtbl = {}
    local enumindex = index or 0
    for i, v in ipairs(tbl) do
        enumtbl[v] = enumindex + i - 1
    end
    return enumtbl
end

--//将LUA对象转换为字符串
function M.SerialObject(obj)
    local tp = type(obj);
    if tp == "nil" then
        return "nil";
    elseif tp == "string" then
        return "\"" .. string.gsub(obj,"\n","\\n") .. "\"";
    elseif tp == "number" then
        return tostring(obj);
    elseif tp == "table" then
        local str = "{";
        local bFirstKey = true;
        for k, v in pairs(obj) do
            if bFirstKey then
                bFirstKey = false;
            else
                str = str .. ",";
            end

            local typek = type(k);
            if typek == "number" then
                str = str .. "[" .. tostring(k) .. "]" .. "=" .. M.SerialObject(v);
            elseif typek == "table" then
                str = str .. M.SerialObject(k) .. "=" .. M.SerialObject(v);
            else
                str = str .. "[\"" .. tostring(k) .. "\"]=" .. M.SerialObject(v);
            end
        end
        str = str .. "}";
        return str;
    else
        return tostring(obj);
    end
end

function M.TableComp(t1, t2)
    if t1 == t2 then
        return true;
    elseif type(t1) ~= type(t2) then
        return false;
    end

    local k1, k2, v1, v2;
    repeat
        k1, v1 = next(t1, k1);
        k2, v2 = next(t2, k2);
        if k1 == nil and k2 == nil then
            break;
        elseif k1 ~= k2 or v1 ~= v2 then
            return false;
        end
    until (false);

    return true;
end

function M.TableSize(t)
    if t == nil then return 0; end

    local nLen = 0;
    for k, v in pairs(t) do nLen = nLen + 1; end;

    return nLen;
end

function M.TableClone(tOld)
    local tmp = {};
    for k, v in pairs(tOld) do
        if type(v) == "table" then
            tmp[k] = M.TableClone(v);
        else
            tmp[k] = v;
        end
    end
    return tmp;
end

function M.TableValueNums(table,filterfunc)
    assert(table)
    local count = 0
    for k, v in pairs(table) do
        if filterfunc and filterfunc(v) then
            count = count + 1
        end
    end
    return count
end

function M.TableFindV(table,filterfunc)
    assert(table)
    for k, v in pairs(table) do
        if filterfunc and filterfunc(v) then
           return v,k
        end
    end
end

function M.GoogleCalc(posA,posB)

  local function rad(d)
    return d * 3.141592653 / 180.0;
  end

  local radLat1 = rad(posA.y);
  local radLat2 = rad(posB.y);
  local a = radLat1 - radLat2;
  local b = rad(posA.x) - rad(posB.x);
  local s = 2 * math.asin(math.sqrt(math.pow(math.sin(a/2),2)+math.cos(radLat1)*math.cos(radLat2)*math.pow(math.sin(b/2),2)));
  s = s * 6378137.0;
  return s;
end

function M.StringAppend(src,ap,maxlen)
    assert(src and ap,"src or ap nil ")
    for i=1, tonumber(maxlen or 0)-#tostring(src) do
        src=src..tostring(ap)
    end
    return src
end

return M