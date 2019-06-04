--
-- Author: lee
-- Date: 2017-03-07 17:48:33
--
local M={
    STATE_ERROR=-1,
    STATE_LATEST=0, --最新版本,无需升级
    STATE_MAINTAIN=9, --正在维护,此时msg键中存的是维护提示内容,请将其显示给用户
    STATE_UPDATE=11, --需要更新
    UPDATE_TYPE_HOT=1, --热更新
    UPDATE_TYPE_PACK=2, --整包更新
}

M.VER_MODULE_HALL = "hall"
M.VER_MODULE_GAME_COMMON = "game_common"
M.VER_MODULE_PK_COMMON = "pk_common"
M.VER_MODULE_MJ_COMMON = "mj_common"

local REQ_QUEUE={}
local ARQCount=0
local DEFAULT_LOGIN_SERVER_PORT = 6532
local CHECK_VERSION_TIMEOUT = 15    -- 版本检查的超时时间，单位：秒

local VersionData = nil

local VERNAMES_INFO = {
    [M.VER_MODULE_HALL] = { id = 888888888, path = "src/hall_manifest" },
    [M.VER_MODULE_GAME_COMMON] = { id = 999000000, path = "games/common/manifest_v2", src_path = { "common", "mj_common" } },
    [M.VER_MODULE_PK_COMMON] = { id = 999000001, path = "games/common/puke/manifest", src_path = "common" },
    [M.VER_MODULE_MJ_COMMON] = { id = 999000002, path = "games/mj_common/manifest", src_path = { "common", "mj_common" } },

    anhui = { id = 888340000, path = "games/area_AnHui/manifest", src_path = "area_AnHui" },
    fujian = { id = 888350000, path = "games/area_fuJian/manifest", src_path = "area_fuJian" },
    henan = { id = 888410000, path = "games/area_henan/manifest", src_path = "area_henan" },
    longjiang = { id = 888230000, path = "games/area_longjiang/manifest", src_path = "area_longjiang" },
    jiangsu = { id = 888320000, path = "games/area_JiangSu/manifest", src_path = "area_JiangSu" },
    guangxi = { id = 888450000, path = "games/area_guangxi/manifest", src_path = "area_guangxi" },
    jiangxi = { id = 888360000, path = "games/area_jiangxi/manifest", src_path = "area_jiangxi" },
    shandong = { id = 888370000, path = "games/area_shandong/manifest", src_path = "area_shandong" },
    dongbei = { id = 888220000, path = "games/area_dongBei/manifest", src_path = "area_dongBei" },
    guiyang = { id = 888520000, path = "games/area_guiyang/manifest", src_path = "area_guiyang" },
    liaoning = { id = 888210000, path = "games/area_liaoning/manifest", src_path = "area_liaoning" },
    shanxi = { id = 888610000, path = "games/area_shanxi/manifest", src_path = "area_shanxi" },
}

--热更新地址
local function GET_UPDATE_URL(vert,region)
    vert=vert or HALL_WEB_VERSION

    local a_id = "/" .. APP_ID
    local c_id = "/" .. CHANNEL_ID
    local verstr="/"..table.concat(vert,".")
    local common_ver = M:getModuleClientVer(M.VER_MODULE_GAME_COMMON)
    verstr=string.format("%s.%d",verstr,common_ver)

    -- 大厅版本号
    local hall_ver = M:getModuleClientVer(M.VER_MODULE_HALL)
    verstr=string.format("%s.%d",verstr,hall_ver)

    local dev_code=Helper.GetDeviceCode()
    local tmp={}
    local function inserturl(prefix)
        region=gg.StringAppend((region or REGION_CODE),0,6)
        local u_url=string.format("://%s.%s/update%s%s%s/%s/%s",prefix,WEB_DOMAIN,a_id,c_id,verstr,dev_code,region)
        table.insert(tmp,u_url)
    end
    if UPDATE_URL_PREFIX and #UPDATE_URL_PREFIX >0 then
        for i,v in ipairs(UPDATE_URL_PREFIX) do
            inserturl(v)
        end
    end
    if #tmp==0 then inserturl("client") end
    return tmp
end

local function startwith_(source, str)
    local len = string.len(str)
    return string.lower(string.sub(source, 1, len)) == str
end

--取消
local function cancelRequest()
    if REQ_QUEUE and #REQ_QUEUE>0 then
        for k,v in pairs(REQ_QUEUE) do
            v:Cancel()
        end
    end
    ARQCount=0
    REQ_QUEUE[{}]=nil
    REQ_QUEUE={}
end

-- 获取版本状态
local function get_ver_state_()
    -- 大厅或者通用组件有更新
    if M:isModuleNeedUpdate("hall") or M:isModuleNeedUpdate("game_common") then
        return M.STATE_UPDATE
    end

    if VersionData then
        return checknumber(VersionData.status, nil, -1)
    else
        return -1
    end
end

--处理版本数据 switch=63,spay=7,
local function handle_version_data_(ok,verdata)
    if not ok then
        return -1,{ msg="解析版本数据错误" }
    end
    verdata = checktable(verdata)
    if verdata.review ~= nil then --审核模式
        cc.exports.IS_REVIEW_MODE = iif(checkint(verdata.review)==1,true,false)
    end
    if verdata.switch ~= nil then ---功能开关
       cc.exports.MODULES_SWTITCH = verdata.switch
    end
    if verdata.friends_room_min_honor ~= nil then ---创建朋友场荣誉值限制
        cc.exports.FRIEND_ROOM_LIMIT = verdata.friends_room_min_honor
    end
    if verdata.hot_min_honor ~= nil then ---小刺激荣誉值限制
        cc.exports.HOT_MIN_HONOR = verdata.hot_min_honor
    end
    if verdata.match_min_honor ~= nil then ---比赛场显示局数限制
        cc.exports.MATCH_LIMIT_CNT = verdata.match_min_honor
    end
    if verdata.bank_step ~= nil then ---背包整存整取的数值
        cc.exports.BANK_STEP = verdata.bank_step
    end
    if verdata.spay ~= nil then ----支付开关
        cc.exports.PAY_SWITCH = verdata.spay
    end
    if verdata.games ~= nil then ----游戏信息列表
        cc.exports.GAME_VERSION_LIST = verdata.games
    end
    if verdata.login_game_id ~= nil and verdata.login_game_id > 0 then ----不显示房间列表时需要进入的游戏 ID
        cc.exports.DEFAULT_GAME_ID = verdata.login_game_id
    end
    if verdata.getipurl ~= nil then
        cc.exports.GET_IP_URL = verdata.getipurl
    end
    if verdata.getipregexp ~= nil then
        cc.exports.GET_IP_REGEXP = verdata.getipregexp
    end
    if verdata.test ~= nil then
        cc.exports.IS_TEST_SERVER = verdata.test == 1
    end
    -- 支付域名
    if verdata.d_pay ~= nil then
        cc.exports.PAY_API_DOMAIN = verdata.d_pay
    else
        cc.exports.PAY_API_DOMAIN = nil
    end

    -- 用户初始化 web 接口的域名
    if verdata.d_init ~= nil then
        cc.exports.USER_INIT_DOMAIN = verdata.d_init
    else
        cc.exports.USER_INIT_DOMAIN = nil
    end

    -- user API 对应的 web 接口域名
    if verdata.d_api ~= nil then
        cc.exports.USER_API_DOMAIN = verdata.d_api
    else
        cc.exports.USER_API_DOMAIN = nil
    end

    -- 需要限制显示的游戏信息
    if verdata.climits ~= nil then
        cc.exports.GAME_LIMIT_COUNTS = verdata.climits
    else
        cc.exports.GAME_LIMIT_COUNTS = nil
    end
    if verdata.glimit ~= nil then
        cc.exports.LIMIT_GAMES = verdata.glimit
    else
        cc.exports.LIMIT_GAMES = nil
    end

    local loginip = verdata.loginip; --登陆服务器地址
    if not IS_LOCAL_TEST then   --内网测试 不更新服务器地址
        LOGIN_SERVER_LIST[1] = checktable(LOGIN_SERVER_LIST[1])
        local loginserver = LOGIN_SERVER_LIST[1]
        if loginip and #loginip ~= 0 then
            local pos = string.find(loginip, ":");
            if pos ~= nil then
                loginserver.url = string.sub(loginip, 1, pos - 1);
                loginserver.port = tonumber(string.sub(loginip, pos + 1));
            else
                loginserver.url = loginip;
                loginserver.port = DEFAULT_LOGIN_SERVER_PORT
            end
        else
            -- 没获取到登录 ip 信息，清除默认的配置信息
            loginserver.url = ""
            print("未获取登录服务器地址")
        end
    end
    gg.LocalConfig:SetCopyRightInfo(verdata.banhao,verdata.beian)
    gg.LocalConfig:SetServiceInfo(verdata.fs)

    return verdata
end

local function httpgetcryptlua_(url,callback)

    local xhr = cc.XMLHttpRequest:new()
    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
    if startwith_(url, "://") then
        url = "https" .. tostring(url)
    end
    printf("request %s",url)
    xhr:open("GET", url)
    xhr.timeout=CHECK_VERSION_TIMEOUT
    xhr.Cancel=function(obj) obj.callback=nil  end
    xhr.callback=callback
    local function onReadyStateChanged()
        ARQCount=ARQCount+1
        printf("response: %s",url)
        if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207)then
            if not xhr.callback then return end
            local data =checkstring(xhr.response)
            if #data>0 and (not gg.StartWith(data, "return") ) then
                data= Helper.CryptStr(data,URLKEY,false,0);
                printf("--------data_parse_handler_ %s",tostring(data) )
            else
                printf("--------data_parse_handler_ no crypt error %s",tostring(xhr.response) )
            end

            -- 记录版本数据
            VersionData = handle_version_data_(pcall(function() return loadstring(data)(); end)  )

            -- 获取版本状态
            VersionData.status = get_ver_state_()

            xhr.callback( VersionData.status, clone(VersionData) )
            cancelRequest()
        elseif ARQCount>=#REQ_QUEUE then
            -- 版本检查失败了，清除版本数据
            VersionData = nil

            if xhr.callback then  xhr.callback(-1)  end
            cancelRequest()
            printf("版本检查回调 取消 xhr.readyState is:%d xhr.status is:  %d", xhr.readyState ,xhr.status)
        end
        xhr:unregisterScriptHandler()
    end
    xhr:registerScriptHandler(onReadyStateChanged)
    xhr:send()
    return xhr
end

--callback(status data)
function M:checkVersion(callback)
    cancelRequest()
    local userRegion = gg.LocalConfig:GetRegionCode()
    local urls= GET_UPDATE_URL(HALL_WEB_VERSION, gg.IIF(userRegion ~= 0, userRegion, nil))
    ARQCount=0
    if urls and type(urls)=="table" then
        for i,v in ipairs(urls) do
            local obj= httpgetcryptlua_(v,callback)
            table.insert(REQ_QUEUE,obj)
        end
    end

    -- 加一个定时器来处理可能 http 请求没有超时返回的问题
    self.callback = callback
    gg.CallAfter(CHECK_VERSION_TIMEOUT + 1, function()
        if REQ_QUEUE and #REQ_QUEUE>0 then
            if self.callback then self.callback(-1)  end
            cancelRequest()
        end
    end)
end

function M:cancel()
    cancelRequest()
end

-- 获取模块名称对应的id
function M:getModuleID(moduleName)
    local info = checktable(VERNAMES_INFO[string.lower(moduleName)])
    return info.id
end

-- 获取模块的客户端版本
function M:getModuleClientVer( moduleName )
    local info = VERNAMES_INFO[string.lower(moduleName)]
    if not info then
        printf("未找到 %s 模块的版本配置信息", moduleName)
        return 0
    end

    local ok, vertable = gg.GetManifestTable(info.path)
    return ok and checkint(vertable.version) or 0
end

-- 获取模块的服务器版本
function M:getModuleRemoteVer( moduleName )
    local verID = self:getModuleID(moduleName)
    return checkint(checktable(checktable(VersionData).games)[verID])
end

-- 检查模块是否需要更新
function M:isModuleNeedUpdate( moduleName )
    local clientVer = self:getModuleClientVer(moduleName)
    local remoteVer = self:getModuleRemoteVer(moduleName)
    return clientVer < remoteVer
end

-- 获取模块对应的源码路径
function M:getModuleSrcPath( moduleName )
    local info = VERNAMES_INFO[string.lower(moduleName)]
    if not info then
        printf("未找到 %s 模块的版本配置信息", moduleName)
        return 0
    end

    return info.src_path
end

return M
