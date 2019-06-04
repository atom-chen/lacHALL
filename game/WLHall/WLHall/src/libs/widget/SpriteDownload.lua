local M = class("libs.ccex.SpriteDownload", function()
    return cc.Node:create()
end)

M.Mode = 
{
    EqualHeight = 0,
    EqualWidth  = 1,
    EqualHeightAndWidth  = 2, 
}

--[[
    * 描述：网络下载图片精灵
    * 参数：url下载地址，如果存在就开始下载，否则使用startDownload()
    * 参数：defaultSprite默认精灵
--]]
function M:ctor(url, defaultSprite)
    self._downloadId = nil 
    self:_initDefalutSprite(defaultSprite)
    self:setAnchorPoint(cc.p(0.5, 0.5))
    
    if url then
        self:startDownload(url)
    end

    self:enableNodeEvents()
end

--[[
    * 描述：下载的资源图片与defaultSprite的适配模式
    * 参数：mode适配模式，0等高，1等宽 
--]]
function M:setContentFactor(mode)
    assert(mode>=M.Mode.EqualHeight and mode<=M.Mode.EqualHeightAndWidth)
    self._mode = mode
    self:_resetMode()
    return self
end

function M:startDownload(url)
    assert(url, "url不能为空")
    if self._url == url then
        return
    end
    
    self._url = url 
    
    -- 本地资源已经存在则不用下载
    local fullPath = self:_getFullPath(url)
    local isFileExist = File:isFileExist(fullPath)
    if isFileExist then
        self:_loadDownloadImage(fullPath)
        return
    end

    -- * 提醒：该类需要在C++端注册Lua binding，搜索函数lua_open_download()
    self:_cancelDownload()
    self._downloadId = c_network.download.start(url, function(info)
        self:_downloadCallback(info)
    end)
end

--------------------------- 华丽分割线 ---------------------------

function M:_cancelDownload()
    if self._downloadId then
         c_network.download.cancel(self._downloadId)
         self._downloadId = nil 
    end
end

function M:onCleanup()
    self:_cancelDownload()
end

function M:_getImageDirectory()
    return device.writablePath .. "ImageCache/"
end

function M:_markImageDirectoryExist(dir)
    cc.FileUtils:getInstance():createDirectory(dir)
end

function M:_getImageFileName(url)
    local index = String:rfindIndex(url, "/")
    if not index then
        return nil 
    end

    return string.sub(url, index+1)
end

function M:_getFullPath(url)
    local fileName = self:_getImageFileName(url)
    if not fileName then
        return nil 
    end

    local dir = self:_getImageDirectory()
    return dir .. fileName
end

function M:_saveDataToLocal(data, url)
    -- 创建文件夹
    local dir = self:_getImageDirectory()
    self:_markImageDirectoryExist(dir)

    -- 创建文件
    local fullPath = self:_getFullPath(url)
    return File:writeToFile(data, fullPath)
end

function M:_initDefalutSprite(sprite)
    if not sprite then
        return
    end

    self:addChild(sprite)
    self._defalutSprite = sprite
    local size = sprite:getContentSize()
    self:setContentSize(size)
    sprite:layout(Layout.center)
end

function M:_downloadCallback(info)
    if not info.result then
        print(string.format("下载失败:code=%d", info.code))
        return
    end

    local fullPath = self:_getFullPath(info.url)

    -- 数据保存本地
    local res = self:_saveDataToLocal(info.data, info.url) 
    if not res then
        printf("错误：图片下载保存失败path=%s, data=%s, url=%s", 
            fullPath, info.data, info.url)
        return
    end

    self:_loadDownloadImage(fullPath)
end

function M:_loadDownloadImage(fullPath)
    if self._defalutSprite then
        self._defalutSprite:removeFromParent()
        self._defalutSprite = nil 
    end

    self._downloadSprite = cc.Sprite:create(fullPath)
                :addTo(self)
                :layout(Layout.center)

    self:_resetMode()
end

function M:_resetMode()
    if self._mode==nil or self._downloadSprite==nil then
        return
    end

    local contetSize = self:getContentSize()
    local size = self._downloadSprite:getContentSize()
    local scaleX = 1.0
    local scaleY = 1.0
    if M.Mode.EqualHeight == self._mode then
        scaleY =  contentSize.height / size.height
    elseif M.Mode.EqualWidth == self._mode then
        scaleX = contentSize.width / size.width
    elseif M.Mode.EqualHeightAndWidth == self._mode then
        scaleY =  contentSize.height / size.height
        scaleX = contentSize.width / size.width
    end

    self._downloadSprite:setScaleX(scaleX)
    self._downloadSprite:setScaleY(scaleY)
end

return M