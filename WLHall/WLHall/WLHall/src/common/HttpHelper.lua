-- Author: lee
-- Date: 2016-08-25 10:43:06
local M = {}
local HttpParams= require("common.utils.HttpParams")

--http事件表
local e = {};


local HTTPS_ = IS_LOCAL_TEST and "http" or "https"
local HTTP_ = "http"
local TIME_OUT_=7

M.REQUEST_RESPONSE_STRING       = 0  --返回字符串结果
M.REQUEST_RESPONSE_ARRAY_BUFFER = 1  --CLuaMsgHeader
M.REQUEST_RESPONSE_BLOB         = 2  --CLuaMsgHeader
M.REQUEST_RESPONSE_DOCUMENT     = 3  --CLuaMsgHeader
M.REQUEST_RESPONSE_JSON         = 4  --返回json 格式结果
M.REQUEST_RESPONSE_LUA          = 5  --返回lua 格式结果

local function startwith_(source, str)
    local len = string.len(str)
    return string.lower(string.sub(source, 1, len)) == str
end

local function errorhandler_(http, msg)
    printf("http errorhandler_" .. tostring(msg))
    if http.callback then
        http.callback(http.code, msg)
    end
    http:Release();
end

--与服务器连接断开
-- function e.OnHttpClose(http,nErr)
-- 	local err_msg= "[错误] 与服务器连接失败,url:"..http.url
-- 	errorhandler_(http,err_msg)
-- end

--请求错误
function e.OnHttpError(http, err)
    local err_msg = string.format("[错误] code:[%s],msg:%s,url:%s", tostring(http.code), err, http.url)
    errorhandler_(http, err_msg)
end

--请求完毕  {"msg":"token was empty","status":131}
function e.OnHttpComplete(http)
    printf("[完成],code:" .. tostring(http.code) .. ",url:" .. http.url);
    if http.callback then
        local respType = http.responseType
        local data
        if gg.Http.REQUEST_RESPONSE_STRING == respType then
            data = http:GetData()
        elseif gg.Http.REQUEST_RESPONSE_JSON == respType then
            local dataStr = http:GetData()
            local ok, datatable = pcall(function() return json.decode(dataStr) end)
            data = ok and datatable or nil
        elseif gg.Http.REQUEST_RESPONSE_LUA == respType then
            local dataStr = http:GetData()
            local ok, datatable = pcall(function() return loadstring(dataStr)(); end)
            data = ok and datatable or nil
        elseif gg.Http.REQUEST_RESPONSE_ARRAY_BUFFER == respType then
            data = http:GetMsgData()
            data.position = 0
        else
            data = http:GetData()
        end
        http.callback(http.code, data)
    end
    http:Release();
end

-- 下载进度变化
function e.OnHttpDataArrival(http, size, dowanload, speed)
    if http and http.onProgressChanged then
        http.onProgressChanged(size,dowanload, speed)
    end
end

-- -- 拼接参数
local function joinParams_(params)
    return HttpParams:BuildQuery(params)
end

-- -- 加密
local function encrypt_(params)
    return HttpParams:Encrypt(params)
end
--生成 URL-encode 之后的请求字符串
function M:BuildQuery(params)
    return joinParams_(params)
end

function M:BuildEncryptData(params)
    return HttpParams:BuildEncryptData(params)
end

function M:UploadFile(url, callback, path, params, iscrypt)
    local headers = headers or ""
    if startwith_(url, "://") then
        url = HTTPS_ .. tostring(url)
    end
    if params then
        if iscrypt then
            url = url .. "/" .. encrypt_(joinParams_(params))
        else
            url = url .. "?" .. joinParams_(params)
        end
    end
    local http = CHttpClient.New();
    http.event = e;
    if callback then http.callback = callback; end
    http:AddRef();
    printf("---UploadFile url:%s filepaht %s" ,tostring(url),tostring(path))
    if http:StartUpload(url, path, "file", headers) then
        return http;
    elseif callback then
        callback("无法连接到服务器!");
    end
    http:Release();
    return http
end

-- get方式请求
function M:Get(url, callback, params, iscrypt, headers, sotimeout, responseType, connectiontimeout)
    if params then
        if type(params) == "table" then
            params = joinParams_(params)
        end
        if iscrypt then
            url = url .. "/data/" .. encrypt_(params)
        else
            url = url .. "?" .. params
        end
    end
    return self:_sendRequest(url, callback, "", headers, false, "", sotimeout, responseType, connectiontimeout)
end

-- post 方式请求
function M:Post(url, callback, params, iscrypt, sotimeout, responseType, headers, connectiontimeout)
    if params then
        if type(params) == "table" then
            params = joinParams_(params)
        end
        --printf("HttpPostParams:" .. params)
        if iscrypt then
            params = encrypt_(params)
          --  printf("HttpPostParams encrypt_:" .. params)
        end

    end
    return self:_sendRequest(url, callback, "", headers, true, params, sotimeout, responseType, connectiontimeout)
end

--[[
--发送请求
]]
function M:_sendRequest(url, callback, filename, headers, post, data, sotimeout, responseType, connectiontimeout)
    post = post or false
    filename = filename or ""
    headers = headers or ""
    data = data or ""
    if startwith_(url, "://") then
        url = HTTPS_ .. tostring(url)
    end
    return self:Start(CHttpClient.New(),url,callback, filename, headers, post, data,sotimeout,responseType,connectiontimeout)
end

function M:Start(http,url,callback, filename, headers, post, data,sotimeout,responseType,connectiontimeout)
    http = http or CHttpClient.New()
    http.event = e;
    if callback then http.callback = callback; end
    http.responseType = responseType or gg.Http.REQUEST_RESPONSE_STRING
    http:AddRef()
    sotimeout= sotimeout or TIME_OUT_*2
    connectiontimeout=connectiontimeout or TIME_OUT_
    if checkint(sotimeout) >0 then
        http:SetSoTimeout(checkint(sotimeout))
    end
    if checkint(connectiontimeout)>0  then
        http:SetConnectionTimeout(checkint(connectiontimeout))
    end
    if http:Start(url, filename, headers, post, data, #data) then
        http.packdata={url,callback, filename, headers, post, data}
        return http;
    elseif callback then
        callback("无法连接到服务器");
    end
    http:Release();
end

-- 添加http下载进度监听
function M:AddProgressListener(http, callback)
    if callback then
        http.onProgressChanged = callback
    end
end

function M:CancelRequest(http)
    if http then
        http:Cancel()
        http:Release();
    end
end

return M