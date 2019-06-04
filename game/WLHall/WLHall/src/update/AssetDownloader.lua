 -- Date: 2017-04-01 21:07:39
local HTTPS_ = "https"
local HTTP_ = "http"

local AssetDownloader = ClassEx("AssetDownloader", function()
    return CHttpClient.New()
end )

local RT_MANIFEST=1 --清单文件
local RT_FILES=2    --更新文件
local RT_APK=3      --安装包文件

--1:Lua热更新；2:apk整包更新
local UPTYPE_HOT=1
local UPTYPE_FORCE=2

local OP_ADD = 0;
local OP_DEL = 1;
local OP_REN = 2;
local OP_CLOSE = 3;
local OP_RUN = 4;

--0 添加--1 删除--2 重命名--3 关闭--4 运行
local COMMAND={
	[OP_ADD]=function(obj,fileInfo)
        local filename = Helper.writepath .. fileInfo.path;
        if not Helper.CreateDir(fileInfo.path) then
            obj:FinishCallback("创建目录失败,请确定您有足够的权限！");
            return true
        end
        local path,fname= obj.cururl_:match('(.*/)(.*)')
        obj:StartDownloadFile(path..obj.version_.."/" .. fileInfo.fname,filename)
        return true
    end,
	[OP_DEL]=function(obj,fileInfo)
        Helper.DeleteFile(Helper.writepath .. fileInfo.path);
        return true
    end,
	[OP_REN]=function(obj,fileInfo)
        Helper.RenameFile(Helper.writepath .. fileInfo.src, Helper.writepath .. fileInfo.des);
        return true
    end,
	[OP_CLOSE]=function(obj,fileInfo)
        GameApp:Exit()
        return true
    end,
	[OP_RUN]=function(obj,fileInfo)
        local filename = fileInfo.path;
        if filename ~= nil and #filename > 0 then --如果有指定文件名,则执行LUA文件
            dofile(Helper.writepath .. filename);
        end
        local cmd = fileInfo.cmd;
        if cmd ~= nil and #cmd > 0 then --如果有指定命令行,则执行lua字符串
            loadstring(cmd)();
        end
        return true
     end,
}

local function safecall_(callback,...)
    if callback then callback(...) return true  end
    return false
end
local function startwith_(source, str)
    local len = string.len(str)
    return string.lower(string.sub(source, 1, len)) == str
end

local function handlerurl_(url)
    if url and startwith_(url, "://") then
        return HTTPS_ .. tostring(url)
    else
        return url
    end
end

-- LUAGETIMP(CHttpClient,url);
-- LUAGETIMP(CHttpClient,speed);
-- LUAGETIMP(CHttpClient,filename);
-- LUAGETIMP(CHttpClient,code);
-- LUAGETIMP(CHttpClient,size);
-- LUAGETIMP(CHttpClient,cursize);
-- LUAGETIMP(CHttpClient,dowloading);
function AssetDownloader:ctor(url,callback)
	self:RegisterEvent("OnHttpClose",self.OnHttpClose)
	self:RegisterEvent("OnHttpComplete",self.OnHttpComplete)
	self:RegisterEvent("OnHttpDataArrival",self.OnHttpDataArrival)
	self:RegisterEvent("OnHttpError",self.OnHttpError)
    self.requesthandler_={
        [RT_MANIFEST]=handler(self, self.HandleManifestFile),
        [RT_FILES]=handler(self, self.HandleHotUpdateFile),
        [RT_APK]=handler(self, self.HandleApkFile),
    }
    self.cururl_=url
	self.allsize_ = 0;
    self.cursize_=0
    self.curversion_=0;
 	self.callback_=callback
end

function AssetDownloader:FinishCallback(msg,cancontinue)
    if not self:ExecuteQueue() then
        safecall_(self.callback_,msg,true)
    end
    printf("on FinishCallback : %s , listsize: %d",tostring(msg),#checktable(self.download_list_))
end

function AssetDownloader:RegisterEvent(e,func)
	self.event[e] =func
end

function AssetDownloader:AddProgressChangeListener(listener)
    self.progresschange_=listener
end

function AssetDownloader:StartDownloadApk(url)
    self.requesttype_=RT_APK
    url=handlerurl_(url)
    self:SetSoTimeout(0)
    local filename = Helper.sdcachepath .. Helper.sha1(url) .. ".apk";
    self:Start(url, filename)
end

function AssetDownloader:StartDownloadFile(url,filepath)
    printf("StartDownloadFile  url:%s  filepath:%s",url,filepath )
    self.requesttype_=RT_FILES
    self:SetSoTimeout(0)
    url=handlerurl_(url)
	self:Start(url,filepath)
end

function AssetDownloader:ExecuteQueue(list)
    if list then
        assert(#list>0,"下载列表空")
        self.download_list_=list
        self:SetSoTimeout(60)
    end
    local it=checktable(self.download_list_)[1]
    if it then
        table.remove(self.download_list_,1)
        self:Execute(it.url,it.version)
        return true
    else
        return false
    end
end

function AssetDownloader:Execute(url,version)
    self.cururl_=url or self.cururl_
    assert(version,"version nil error")
    self.version_=version
    self:PullManifestFile(self.cururl_)
    return self
end

function AssetDownloader:PullManifestFile(url)
    assert(url,"url param is nil error")
    printf("PullManifestFile %s",url)
    self.requesttype_=RT_MANIFEST
    self.allsize_ = 0;
    self.cursize_=0
    url=handlerurl_(url)
    if  url and self:Start(url, Helper.writepath .. "_tmp_.tmp") then
        return true
    end
    return false
end

function AssetDownloader:HandleManifestFile()
    printf("HandleManifestFile %s",self.filename)
	self.filelist_=assert(loadfile(self.filename))();
    if self.filelist_ == nil or checktable(self.filelist_).status then
 		self:FinishCallback("更新失败,文件列表空")
        return
    end
    self.allsize_ = 0;
    for _, v in ipairs(self.filelist_) do
        --v.version > HALL_UPDATE_VERSION and
        if  v.op == OP_ADD then
            self.allsize_ = self.allsize_ + v.size;
        end
    end
    self:ParseFileList()
end

function AssetDownloader:HandleHotUpdateFile()
    printf("HandleHotUpdateFile 解压  更新文件")
    local fileInfo = self.filelist_[1];
    self.cursize_ =self.cursize_+ fileInfo.size;
    --检测文件sha1码
    local filename = self.filename
    local hashcode = Helper.FileSha1(filename);
    local subname = string.sub(fileInfo.fname, 1, 40);

    if hashcode ~= string.sub(fileInfo.fname, 1, 40) then
        printf("err filename:"..tostring(fileInfo.fname))
        self:FinishCallback("更新文件校验不正确");
        return;
    end
    cc.FileUtils:getInstance():purgeCachedEntries() -- 清除文件缓存
    --是否是压缩包
    if fileInfo.compr then
        local zfile = CLuaZip.New();
        if not zfile:Open(filename) then
            printf("打开zip失败");
        else
            zfile:UnzipAllFiles();         --解压所有文件
            zfile:Close();
            Helper.DeleteFile(filename);   --删除包文件
        end
    end

    table.remove(self.filelist_, 1);
    local ret, msg = pcall(self.ParseFileList, self);
    if not ret then
        printf(msg);
        self:FinishCallback("解析更新文件出错");
    end
end

function AssetDownloader:UpdateUI(filesize, downloadsize, speed)
   -- printf( " update %d %d %d %s" ,tonumber(filesize), tonumber(downloadsize), tonumber(speed),tostring(percent))
    local percent =checkint(math.floor(downloadsize * 100 /filesize + 0.5))
    if not safecall_(self.progresschange_,filesize, downloadsize,speed,percent) then
        GameApp:dispatchEvent("event_update_progress_changed",filesize, downloadsize,speed,percent)
    end
    -- if not  cur or not all then
    --     BreakPoint()
    -- end
  -- print("下载进度:" .. tostring( math.floor(downloadsize * 100 /filesize + 0.5)))
end

function AssetDownloader:HandleApkFile()
    device.installApk(self.filename)
    printf("AssetDownloader HandleApkFile")
end

function AssetDownloader:ParseFileList()
    printf("AssetDownloader ParseFileList")

    repeat
        local fileInfo = self.filelist_[1]; --当前处理的文件
        if fileInfo then --还有需要处理
            if type(fileInfo) == "table" and fileInfo.version >= self.curversion_ then --如果大于本地版本号
                local cmd= COMMAND[checknumber(fileInfo.op,nil,-1)]
                if cmd and cmd(self,fileInfo) then
                    if fileInfo.op ==OP_ADD  then  break; end
                 else
                    self:FinishCallback("更新命令错误")
                    break;
                end
            end
            table.remove(self.filelist_, 1);
        else
            self:FinishCallback();
            break --更新完成
        end
    until (false)
end

function AssetDownloader:OnHttpClose(nErrorCode)
 	printf("function AssetDownloader:OnHttpClose(nErrorCode)")
end

--http 完成
function AssetDownloader:OnHttpComplete()
   printf("function AssetDownloader:OnHttpComplete(nErrorCode) "..tostring(self) ..tostring(self.requesttype_))
   local reqhandle= self.requesthandler_[checkint(self.requesttype_ )]
   local ret,msg
    if reqhandle then
       ret,msg= pcall(reqhandle,self)
    end
    if not ret then
        printf(msg)
        self:FinishCallback("更新失败，请重试！")
    end
end

function AssetDownloader:OnHttpDataArrival(filesize, downloadsize, speed)
   -- printf( " OnHttpDataArrival %d %d %d " ,tonumber(filesize), tonumber(downloadsize), tonumber(speed))
    self.allsize_=checknumber(self.allsize_,nil,filesize)
    local rt =  self.requesttype_
    if rt == RT_FILES then  --更新文件
        self:UpdateUI(self.allsize_,self.cursize_ + downloadsize,  speed);
       -- printf(" 更新文件 %d %d %d",tonumber(self.cursize_ + downloadsize), tonumber(self.allsize_), tonumber(speed))
    elseif rt == RT_APK then   --安装包文件
        self:UpdateUI(self.size,downloadsize,  speed);
       -- printf(" 安装包文件 %d %d %d",tonumber(downloadsize), tonumber(self.size), tonumber(speed))
    end
end

function AssetDownloader:OnHttpError( strError)
    printf(" AssetDownloader:OnHttpError{ url: %s ,err: %s}",self.url,tostring(strError))
    self:FinishCallback("更新失败，请重试！")
end

function AssetDownloader:ExecuteMethod(ispost)
	--self:Start(url, "", "", false, "", "")
end

return AssetDownloader