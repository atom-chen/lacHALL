--[[
* @brief 图片下载缓存
]]

--下载队列,多个请求存在时,按顺序下载
local downloadlist = {};
--默认路径,决定是在SD卡还是data目录
local cachePath = Helper.GetCachePath()
-- printf("cachePath ---------------"..cachePath)
--assert(Helper.CreateDir(cachePath),"cache folder create error :"..tostring(cachePath))
-- cc.FileUtils:getInstance():createDirectory(cachePath)
-- local cachePath = device.writablePath .. "cache/"
-- printf("cachePath ---------------"..cachePath)
-- Helper.CreateDir("/cache/");
local dllist = {}; --下载列表
local nIndex = 1; --正在下载的索引
local nAddIndex = 0; --添加的索引
local bDownloading = false; --//是否正在下载
local downloadobj;
local ImageDownload = {
    headers_ = "" --下载的附带http请求头
};

--http请求对象,不支持https
local httpClient = CHttpClient:New();
--下载事件回调
local e = httpClient.event;

local function nextIndexAdd_()
    dllist[nIndex] = nil;
    nIndex = nIndex + 1;
end

--下载完成通知,如果err为nil,则成功,否则err为失败原因
local function onComplete_(err)
    local filename
    if err then
        printf("下载失败,url=" .. httpClient.url .. ",err=" .. err);
    else --//下载成功
        filename = downloadobj.filename
    end

    for k, v in pairs(downloadobj.callback) do
        v(filename, err, downloadobj.tagobj);
    end
    nextIndexAdd_()
    bDownloading = false;
    ImageDownload:StartDownload();
end

function e.OnHttpClose(http, nErrorCode)
    onComplete_("与服务器连接关闭!");
end

function e.OnHttpComplete(http)
    onComplete_();
end

function e.OnHttpError(http, strError)
    onComplete_(strError);
end

-- 下载进度变化
function e.OnHttpDataArrival(http, size, dowanload, speed)
    if downloadobj and downloadobj.onProgressChanged then
        downloadobj.onProgressChanged()
        --downloadobj.tagobj
       -- http.onProgressChanged(size.downloadobj, speed)
    end
end

function ImageDownload:SetProgressChangeListener(listener)
    self.onProgressChanged=listener
end

--启动下载,这个函数不应该在文件外被调用
function ImageDownload:StartDownload()

    local obj = dllist[nIndex];
    if obj == nil then
        return false;
    end
    bDownloading = true;
    if not httpClient:Start(obj.url, obj.filename, self.headers_) then
        bDownloading = false;
        onComplete_("连接到下载地址失败!");
        nextIndexAdd_()
        return self:StartDownload();
    else
        downloadobj = obj;
        return true;
    end
end

--[[
* @brief 启动下载
* @param url 下载的地址,仅支持http协议,不支持https和ftp
* @param callback 下载回调函数,回调函数原型为
* @param cuspath 自定义下载路径
* @code
	function(filename,err)
		--filename：如果成功,则filename为下载的文件路径,失败则该值为nil
		--err:如果成功,则该值忽略,否则,该值为错误原因
	end
* @endcode
]]
function ImageDownload:Start(url, callback, tagobj, cuspath)
    if gg.StartWith(url, "://") then
        url = "http" .. url
    end
    assert(callback ,"ImageDownload callback nil")

    local ext
    local sizeStr = url:match("(/%d+)$")
    if sizeStr then
        -- 如果 url 中有大小的参数，需要去除大小的参数再获取扩展名
        local tmpUrl = string.sub(url, 1, string.len(url) - string.len(sizeStr))
        ext = gg.GetFileExt(tmpUrl) or "tmp"
    else
        ext = gg.GetFileExt(url) or "tmp"
    end

    local fpath = cuspath or cachePath
    local filename = fpath .. Helper.sha1(url) .. "." ..ext;

    if Helper.IsFileExist(filename) then --//文件存在,直接返回
        callback(filename);
        return filename;
    end

    -- 包含 avatar3. 的图片 url 需要先获取实际的图片 url 地址
    local pos = string.find(url, "avatar3." .. WEB_DOMAIN)
    if pos then
        -- 需要从 url 获取实际的图片下载地址
        gg.Http:Get(url, function ( code, data )
            if code and checkint(code) ~= 200 then
                printf("Get avatar real url err: %s  %s", tostring(code), tostring(data))
                return
            end

            -- 读取头像的实际地址
            local ok, datatable = pcall(function() return loadstring(data)(); end)
            if ok and checkint(datatable.status) == 0 and datatable.url then
                self:_doStart(datatable.url, callback, tagobj, cuspath, filename)
            else
                printf("Get avatar real url faile, %s ", json.encode(data))
            end
        end)
    else
        self:_doStart(url, callback, tagobj, cuspath, filename)
    end
end

function ImageDownload:_doStart(url, callback, tagobj, cuspath, filename)
    local o = dllist.url;
    if o == nil then
        o = {}
        setmetatable(o, self);
        nAddIndex = nAddIndex + 1
        dllist[nAddIndex] = o;
        o.url = url;
        o.index = nAddIndex;
        o.tagobj = tagobj
        o.callback = {};
    end

    table.insert(o.callback, callback);
    o.filename = filename;
    if not bDownloading then
       return self:StartDownload();
    end
end

function ImageDownload:CancelAll()
    if httpClient then
        httpClient:Cancel()
        -- httpClient:Release()
        -- httpClient = nil
    end

    dllist = {}
end



--[[
* @brief 加载网络图片
* @param url 地址
* @param image 需要加载资源的控件
* @param finishcall 下载完成的回调
* @param cusPath 自定义存储文件夹
]]
function ImageDownload:LoadHttpImageAsyn(url, image, finishcall, cusPath)
    if (url and string.len(url) > 0) and image then
        if gg.StartWith(url, "http") or gg.StartWith(url, "://") then --网址
            image:retain();
            self:Start(url, function(path, err)
                if path then
                    image:loadTexture(path);
                    if finishcall then
                        finishcall()
                    end
                end
                image:release();
            end, nil, cusPath);
        else --//直接加载图标
            image:loadTexture(url)
            if finishcall then
                finishcall()
            end
        end
    end
end

--[[
* @brief 加载用户头像图片
* @parm url 地址
* @parm image 需要加载资源的控件
* @parm sizetype 图片尺寸类型, 0:小图 1:中图 2:大图
* @parm ismine 是否是自己的头像
]]
function ImageDownload:LoadUserAvaterImage(params, finishcall)
    params = params or {}
    local url = params.url
    local image = params.image
    local sizetype = checkint(params.sizetype)
    local ismine = params.ismine

    -- 将头像保存在 tmp 中对应下载日期的文件夹
    local date = os.date("%Y%m%d", os.time())
    local savepath = cachePath .. "tmp/" .. date .. "/"

    -- 如果是用户自己的头像，则默认下载大图，并且保存在非临时文件夹下
    if ismine then
        sizetype = 2
        savepath = cachePath
    end

    -- 如果是 iOS，不需要自己管理临时文件
    if device.platform == "ios" then
        savepath = cachePath
    end

    -- url 中增加大小的参数
    url = self:joinImageSize(url, sizetype)

    -- 如果临时文件夹不存在，先清除tmp文件夹，再重新创建当日头像缓存临时文件夹
    if device.platform ~= "ios" and not ismine and not Helper.IsDirectory(savepath) then
        Helper.DeleteFile(cachePath .. "tmp")
        Helper.CreateDir("cache/tmp/"..date.."/")
    end

    -- 下载图片
    self:LoadHttpImageAsyn(url, image, finishcall, savepath)
end

-- 第一类域名，
local SIZE_TB_1 = {46, 64, 96}
local SIZE_TB_2 = {30, 50, 100}
local SIZE_TB_3 = {40, 60, 100}

local IMG_DOMAIN = {
    ["thirdwx.qlogo.cn"] = SIZE_TB_1,
    ["wx.qlogo.cn"] = SIZE_TB_1,
    ["thirdapp0.qlogo.cn"] = SIZE_TB_2,
    ["thirdapp1.qlogo.cn"] = SIZE_TB_2,
    ["thirdapp2.qlogo.cn"] = SIZE_TB_2,
    ["thirdapp3.qlogo.cn"] = SIZE_TB_2,
    ["thirdqq.qlogo.cn"] = SIZE_TB_2,
    ["cloudimg2.weile.com"] = SIZE_TB_3,
}

-- 指定域名的url地址拼接上图片尺寸大小
function ImageDownload:joinImageSize(url, sizetype)
    -- 非网络地址，不需要增加参数
    if not gg.StartWith(url, "http") and not gg.StartWith(url, "://") then
        return url
    end

    sizetype = checkint(sizetype) + 1
    if sizetype < 1 then sizetype = 1 end
    if sizetype > 3 then sizetype = 3 end

    local size = nil
    for k,v in pairs(IMG_DOMAIN) do
        local pos = string.find(url, k)
        if pos then
            size = v[sizetype]
            break
        end
    end
    -- 如果有域名匹配，则遍历url移除末尾的“/数字”，重新拼接上需要下载的图片尺寸
    local newUrl = url
    if size then
        local curSize = url:match("/(%d+)$")
        if curSize then
            newUrl = string.sub(newUrl, 1, string.len(newUrl) - string.len(curSize))
        end

        if not newUrl:match("/$") then
            newUrl = newUrl .. "/"
        end
        newUrl = newUrl..size
    end

    return newUrl
end

return ImageDownload