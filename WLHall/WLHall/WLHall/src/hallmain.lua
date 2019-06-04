-- http://www.tuicool.com/articles/JRFFviY
-- 必须前置,本地热更
local function _getNativePackageKeys()
    local pakcageKeys = {}
    local loaded = package.loaded
    for k, v in pairs(loaded) do
        pakcageKeys[k] = true
    end
    return pakcageKeys
end

local function _clearPackage(nativeKeys)
    local loaded = package.loaded
    for k, v in pairs(loaded) do
        if nativeKeys[k] == nil then
            loaded[k] = nil
        end
    end
end
--[[
* @brief 执行拷贝操作
* @brief 将数据从应用内拷贝到数据区
]]
local function _copyfile()
   local flag = "_cpflag"..table.concat(HALL_APP_VERSION)
    local configfile = Helper.writepath .. flag;
    local fconfig = io.open(configfile, "rb")
    --[[ 决定是否检测是否拷贝文件  ]]
    if fconfig then --文件存在,则已经拷贝过
        fconfig:close();
        return true;
    end
    Helper.CreateDir("download/"); --//创建下载目录
    local fl = require("src/copyfilelist");
    if type(fl) == "table" then
        local _CopyFile_ = Helper.CopyFile;
        for k, v in pairs(fl) do
            if not _CopyFile_(v, k, true) then --_CopyFile_第三个参数决定如果文件存在,是否覆盖,默认不覆盖
                --printf("copy file failed:"..k);
                return false;
            end
        end
    end
    fconfig = io.open(configfile, "w+");
    if fconfig then
        fconfig:close();
        return true;
    end
    return false;
end

local function _init()
    require  ("src/cfg_package")

    _copyfile();

    cc.FileUtils:getInstance():setPopupNotify(false)
    cc.FileUtils:getInstance():addSearchPath(Helper.writepath,true)
    cc.FileUtils:getInstance():addSearchPath(Helper.writepath.."res/")
    cc.FileUtils:getInstance():addSearchPath(Helper.writepath..SEARCH_SRC)
    cc.FileUtils:getInstance():addSearchPath(Helper.writepath.."hall/")

    cc.FileUtils:getInstance():addSearchPath(SEARCH_SRC)
    cc.FileUtils:getInstance():addSearchPath("res/")
end

--第一入口文件
SEARCH_SRC="src/"  --脚本文件搜索路径
CC_PLATFORM_IOS=1
CC_PLATFORM_ANDROID=2
CC_PLATFORM_WIN32=3
-- GAME_LIST_INTERNAL=Helper.GetDirChildDirs("games") or {}

-- if Helper.platform==CC_PLATFORM_ANDROID then
--      GAME_LIST_INTERNAL={"xlch"}
-- end

--[[
    * 描述：本地热更,清除本地require的文件
--]]
if not __app_loaded then
    __app_loaded = _getNativePackageKeys()

    _init()
else
    _clearPackage(__app_loaded)
end

--[[
    * 描述：本地热将要更新通知,可以在这里释放不需要的资源
--]]
function c_luaWillReload()
end

---检查大版本号 比较 更新 server>client true 有更新
function CompareVersion(serVer,clientVer)
    if type(serVer)=="string" then
       serVer= Helper.StringSpliter(serVer,".")
    end
    if type(clientVer)=="string" then
        clientVer= Helper.StringSpliter(clientVer,".")
    end
    assert(#serVer == #clientVer, "版本号格式不一致")
    for i=1,#serVer do
        local v1 = tonumber(serVer[i])
        local v2 = tonumber(clientVer[i])
        if v1 > v2 then
            return true
        elseif v1 < v2 then
            print("---------大版本更新版本小于原客户端版本--------")
            return false
        end
    end
    return false
end

--execute clear resource cache files
local app_version=cc.UserDefault:getInstance():getStringForKey("app_version")
if not app_version or app_version == "" or CompareVersion(HALL_APP_VERSION, app_version) then
    print("------------ 首次安装或者应用大版本更新  执行文件缓存清理------------")
    Helper.DeleteFile(Helper.writepath.."res")
    Helper.DeleteFile(Helper.writepath.."src")
    Helper.DeleteFile(Helper.writepath.."games/common")
    Helper.DeleteFile(Helper.writepath.."games/mj_common")
    Helper.DeleteFile(Helper.writepath.."cache")
    GAME_LIST_INTERNAL=GAME_LIST_INTERNAL or {}
    for i,v in ipairs( GAME_LIST_INTERNAL ) do
        -- remove cahce games
        local fpath = Helper.writepath.."games/"..tostring(v)
        Helper.DeleteFile(fpath)
        print("rm game:"..fpath)
    end
    cc.UserDefault:getInstance():setStringForKey("app_version", table.concat(HALL_APP_VERSION,"."))
end

print("------------------------------ reload game ------------------------------\n")

require "globalconfig"
require "init"
require "libs.Init"
local function Main()
    -- 大厅入口
    local app = (require "GameApp").new()
    rawset(_G, "GameApp", app)
    return app:Run()

    -- 麻将测试入口
    -- local OpenTest = require("games.mj_common.common.OpenTest")
    -- OpenTest:openTestLayer()
end

xpcall(Main, __G__TRACKBACK__)

