--[[
* @brief 全局变量 扩展
--]]
local Ex = gg or {}

-- 清除资源缓存
function Ex.ClearCache()
    -- 按照应用层级由高到低，依次清除各种类型的缓存
    -- NOTE：修改清理的顺序可能会导致问题，请三思！！！
    -- cc.AnimationCache:getInstance():destroyInstance();

    cc.SpriteFrameCache:getInstance():removeUnusedSpriteFrames()

    cc.Director:getInstance():getTextureCache():removeUnusedTextures();
    cc.SpriteFrameCache:getInstance():removeSpriteFrames()
    cc.Director:getInstance():getTextureCache():removeAllTextures()
end

function Ex.ClearHotCache()
    cc.FileUtils:getInstance():purgeCachedEntries() -- 清除文件缓存
    Helper.DeleteFile(Helper.writepath.."res")
    Helper.DeleteFile(Helper.writepath.."src")
    Helper.DeleteFile(Helper.writepath.."cache")
    Helper.DeleteFile(Helper.writepath.."games")
end

function Ex.IsFileExist(path)
    return cc.FileUtils:getInstance():isFileExist(path)
end

-- 安全调用函数
function Ex.InvokeFunc(func,...)
    if func then func(...)  end
end
--使用延迟函数 注意 计时器释放问题
function Ex.InvokeFuncNextFrame(func ,...)
    if func then
        return require("common.utils.Timer").new():runOnce(function (dt,data,tid) func(unpack(data)) end,0,...)
    end
end
--使用延迟函数 注意 计时器释放问题
function Ex.CallAfter(delay,func ,...)
    delay=checknumber(delay,nil,0)
    if func then
       return require("common.utils.Timer").new():runOnce(function (dt,data,tid) func(unpack(data)) end,delay,...)
    end
end

function Ex.SplitString(str, split_char)
    local sub_str_tab = {};
    while (true) do
        local pos = string.find(str, split_char);
        if (not pos) then
            sub_str_tab[#sub_str_tab + 1] = str;
            break;
        end
        local sub_str = string.sub(str, 1, pos - 1);
        sub_str_tab[#sub_str_tab + 1] = sub_str;
        str = string.sub(str, pos + 1, #str);
    end

    return sub_str_tab;
end

function Ex.ParsingCmd(cmdstr)
    cmdstr=cmdstr or ""
    local params= Ex.SplitString(cmdstr,"&")
    local args_tab={}
    for _,v in pairs(params) do
        local arg =Ex.SplitString(v,"=")
        if #arg==2 then
            args_tab[arg[1]]=arg[2]
        end
    end
    return args_tab
end
--处理触摸事件  是否吞噬
function Ex.HandleTouchBeginEvent(node,swallow,ontouchbegin)
    local listener = cc.EventListenerTouchOneByOne:create();
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(function(touch, event)
        if ontouchbegin then
            ontouchbegin()
        end
        return swallow
    end,cc.Handler.EVENT_TOUCH_BEGAN);
    local eventDispatcher = node:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, node)
end

-- 注册返回键回调函数
function Ex.RegisterKeyBackEvent(regobj, onkeyBackCallback)
    local listener = cc.EventListenerKeyboard:create()
    local function onKeyReleased(keyCode, event)
        if keyCode == cc.KeyCode.KEY_BACK then
            onkeyBackCallback()
        end
    end

    listener:registerScriptHandler(onKeyReleased, cc.Handler.EVENT_KEYBOARD_RELEASED)
    local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, regobj)
end

-- 显示页面加载动画效果
function Ex.ShowLoading(node, msg, timeout,removecallback,disabletimeout, cancelEnable, swallowBack)
    if msg and string.len(msg) > 0 then
        local onRemoveCallBack = function(...)
            node.waitingNode_ = nil
            if removecallback then
                removecallback()
            end
            printf("remove waiting ...")
        end
        timeout = timeout or 30
        if node.waitingNode_ then
            node.waitingNode_:show(msg, timeout,onRemoveCallBack,disabletimeout, cancelEnable, swallowBack)
        else
            local waiting = require("common.widgets.WaitingDialog"):create(msg, timeout, onRemoveCallBack, 0, disabletimeout, cancelEnable, swallowBack)
            node:addChild(waiting)
            node.waitingNode_ = waiting
        end
    elseif node.waitingNode_ then
        node.waitingNode_:removeSelf()
        node.waitingNode_ = nil
    end
    return node.waitingNode_
end

--显示土司提示
function Ex.ShowToast(node,text)
    local Toast = require("common.widgets.Toast")
    return Toast.new(text, 10, 10,node):show()
end
--获取道具表
function Ex.GetPropList()
    local Proplist = clone(require("def.PropDef"))
    if IS_WEILE then
        for i,v in pairs(Proplist) do
            --如果道具是房卡替换成视频券
            if i == PROP_ID_ROOM_CARD then
                v.name = "视频券"
                v.des = "可以在朋友场开启视频，与好友实时互动。"
                v.icon = "common/prop/img_prop_videocard.png"
                v.icon_s = "hall/common/prop_spq_s.png"
                v.icon_l = "hall/store/img_icon_258.png"
                v.event = { "//OpenMall:购买" }
            end
        end
    end
    return Proplist
end

-- 获取 VIP 等级的节点
local VIP_COLORS = {
    { r = 114, g = 137, b = 163 },
    { r = 38,  g = 140, b = 217 },
    { r = 20,  g = 151, b = 193 },
    { r = 29,  g = 164, b = 216 },
    { r = 5,   g = 138, b = 118 },
    { r = 5,   g = 138, b = 89  },
    { r = 5,   g = 138, b = 9   },
    { r = 93,  g = 138, b = 5   },
    { r = 136, g = 138, b = 5   },
    { r = 138, g = 74,  b = 5   },
    { r = 138, g = 36,  b = 5   },
    { r = 195, g = 20,  b = 14  },
    { r = 177, g = 13,  b = 86  },
    { r = 177, g = 13,  b = 148 },
    { r = 121, g = 13,  b = 177 },
    { r = 79,  g = 13,  b = 177 },
    { r = 78,  g = 0,   b = 61  },
}
function Ex.GetVipLevelNode(lv)
    local vip_level = ccui.Layout:create()
    vip_level:setLayoutComponentEnabled(true)
    vip_level:setName("vip_level")
    vip_level:setAnchorPoint(0.0000, 0.5000)
    vip_level:setContentSize(cc.size(74,29))

    --Create img_vip_bg
    local img_vip_bg = cc.Sprite:create("common/pic_vipbg.png")
    img_vip_bg:setName("img_vip_bg")
    img_vip_bg:setAnchorPoint(0.0000, 0.0000)
    if VIP_COLORS[lv+1] then
        img_vip_bg:setColor(VIP_COLORS[lv+1])
    else
        img_vip_bg:setColor(VIP_COLORS[1])
    end
    vip_level:addChild(img_vip_bg)

    --Create img_vip
    local img_vip = ccui.ImageView:create()
    img_vip:loadTexture("common/pic_vip.png",0)
    img_vip:setName("img_vip")
    img_vip:setPosition(20.0000, 14.5000)
    vip_level:addChild(img_vip)

    --Create txt_vip
    local txt_vip = ccui.TextAtlas:create(tostring(lv), "fonts/num_vip.png", 14, 18, "0")
    txt_vip:setName("txt_vip")
    txt_vip:setPosition(50, 14)
    if lv > 0 then
        txt_vip:setColor({r = 255, g = 255, b = 0})
    else
        txt_vip:setColor({r = 255, g = 255, b = 255})
    end
    vip_level:addChild(txt_vip)

    return vip_level
end

--是否是整数
function Ex.IsInteger(number)
    return math.floor(number) == number
end

-- unsigned int 转换为 signed int 值
function Ex.toSignInt( n )
    return n - Helper.And(n, Helper.INT_MAX + 1) * 2
end

--返回 RMB 单位 如有余数精确到小数点后两位
function Ex.MoneyBaseUnit(money, base)
    local function fn(m, b)
        local number = tonumber(string.format("%.2f", (m / b)))
        local flnum = math.floor(number)
        if flnum > number then
            return flnum
        else
            return number
        end
    end

    if money >= base then
        return fn(money, base)
    else
        return tostring(money)
    end
end

function Ex.MoneyUnit(money)
    if money >= 100000000 then
        return Ex.MoneyBaseUnit(money, 100000000) .. "亿"
    elseif money >= 10000000 then
        return Ex.MoneyBaseUnit(money, 10000000) .. "千万"
    elseif money >= 10000 then
        return Ex.MoneyBaseUnit(money, 10000) .. "万"
    else
        return tostring(money)
    end
end

--取精确小数点后位数 的数字
function Ex.GetPreciseDecimal(nNum, n)
    if type(nNum) ~= "number" then
        return nNum;
    end
    n = n or 0;
    n = math.floor(n)
    local fmt = '%.' .. n .. 'f'
    local nRet = tonumber(string.format(fmt, nNum))
    return nRet;
end

-- 获取房间模式
function Ex.GetRoomMode(roomtype)
    return Helper.And(roomtype, ROOM_TYPE_SIT_MODE_MASK);
end

--获取房间等级
function Ex.GetRoomLevel(roomtype)
    return Helper.RShift(Helper.And(roomtype, ROOM_TYPE_LEVEL_MASK), 22);
end

-- VIP升级时间,单位：元
-- VIP 每一级需要充值的钱数为：
-- { 1, 98, 298, 448, 998, 1680, 2980, 5680, 8880, 12800, 15800, 19800, 19800, 29800, 29800, 29800 }
-- 所以最终经验值为：
local VIPEXP = { 1, 99, 397, 845, 1843, 3523, 6503, 12183, 21063, 33863, 49663, 69463, 89263, 119063, 148863, 178663, 999999999 };
function Ex.GetVipTable()
    return clone(VIPEXP)
end

function Ex.GetVipLevel(vipvalue)
    if not vipvalue or vipvalue == 0 then
        return 0, 0, VIPEXP[1];
    end
    local lv = 0
    for i = 1, #VIPEXP do
        lv = i-1
        if vipvalue < VIPEXP[i] then
            break
        end
    end
    local minexp = 0
    if lv >= 1 then
        minexp = VIPEXP[lv]
    end
    return lv, minexp, VIPEXP[lv+1]
end

-- 获取荣誉等级
local HONOREXP = {200, 400, 600, 800, 1000, 2000, 3000, 4000, 5000, 6000,
                  16000, 26000, 36000, 46000, 56000, 106000, 156000, 206000, 256000, 306000,
                  556000, 806000, 1056000, 1306000, 1556000, 2756000, 3956000, 5156000, 6356000, 7556000, 999999999999999999}
function Ex.GetHonorLevel(honorvalue)
    if not honorvalue or honorvalue == 0 then
        return 0, 0, HONOREXP[1];
    end
    local lv = 0
    for i = 1, #HONOREXP do
        if honorvalue < HONOREXP[i] then
            break
        end
        lv = i
    end
    local minexp = 0
    if lv > 0 then
        minexp = HONOREXP[lv]
    end
    return lv, minexp, HONOREXP[lv + 1]
end

function Ex.GetHonorExpTable( )
    return clone( HONOREXP )
end

-- 获取荣誉等级对应的段位和星级，升级到对应段位5星所需要的经验值
function Ex.GetHonorGradeAndLevel(honorval)
    if not honorval or honorval < HONOREXP[1] then
        return 1, 0, HONOREXP[5]
    end

    local lv = 1
    for i = 1, #HONOREXP do
        lv = i - 1
        if honorval < HONOREXP[i] then
            break
        end
    end
    -- 段位
    local grade = math.ceil(lv / 5)
    -- 星级
    local star = lv % 5
    -- 达到大师满级
    if star == 0 and grade >= 6 then
        return 6, 5, 0
    end

    if star == 0 then grade = grade + 1 end
    -- 距离该段位5星的经验差
    local maxexp = HONOREXP[grade * 5] - honorval

    return grade, star, maxexp
end

function Ex.Table2VerString(tab,step)
    step= step or "."
    return table.concat(checktable(tab),step)
end

-- 获取大厅版本号
function Ex.GetHallVerison()
    return table.concat(HALL_WEB_VERSION, ".")
    -- local tmpstr=HALL_WEB_VERSION[1]
    --    for i=2,#HALL_WEB_VERSION do
    --       tmpstr=tmpstr.."."..HALL_WEB_VERSION[i]
    --    end
    --    return tmpstr
end

-- 获取地区码
function Ex.GetRegionCode()
end

-- 获取 Native APP 版本号
function Ex.GetNativeVersion()
    return gg.GetNativeCfg("version", 0)
end

-- 是否可以使用spine骨骼动画
function Ex.CanUseSpine()
    if sp then
        return true
    else
        return false
    end
end

-- 获取 Native Info 配置表
function Ex.GetNativeInfo()
    if gg.NATIVE_INFO_TABLE then
        return gg.NATIVE_INFO_TABLE
    end

    gg.NATIVE_INFO_TABLE = {}
    local ok, nativeinfo_table = gg.GetFileTable("src/NativeInfo.lua")
    if not ok then
        -- 没有找到 NativeInfo.lua，那么检查 NativeInfo 文件
        ok, nativeinfo_table = gg.GetFileTable("src/NativeInfo")
        if not ok then
            -- 两个文件都没有，返回空表
            print("NativeInfo file not found")
            return gg.NATIVE_INFO_TABLE
        end
    end

    gg.NATIVE_INFO_TABLE = checktable(nativeinfo_table)
    return gg.NATIVE_INFO_TABLE
end

-- 获取 Native info 中的配置信息
function Ex.GetNativeCfg(key, defaultVal)
    -- 获取相应的字段
    local nativeInfo = gg.GetNativeInfo()
    local ret = nativeInfo[key]
    if ret ~= nil then
        printf("---- Native info %s : %s", key, tostring(ret))
        return ret
    else
        printf("---- %s is not found in native info, return default value : %s.", key, tostring(defaultVal))
        return defaultVal
    end
end

--显示版本号
function Ex.AddVersionTo(node,ver)
    assert(node)
    local common_ver = gg.VersionHelper:getModuleClientVer(gg.VersionHelper.VER_MODULE_GAME_COMMON)
    local hall_ver= gg.VersionHelper:getModuleClientVer(gg.VersionHelper.VER_MODULE_HALL)
    local defaultVerStr = string.format("App v%s  Res v%s.%s.%s(%d,%d,%d)",
                                        gg.Table2VerString(HALL_APP_VERSION),
                                        gg.Table2VerString(HALL_WEB_VERSION),
                                        common_ver, hall_ver,
                                        APP_ID, CHANNEL_ID, gg.GetNativeVersion())
    local verstr=  ver or defaultVerStr
    if not node.version_ then
        local versionlab =  cc.Label:createWithSystemFont(verstr, "Arial", 14)
        versionlab:setAnchorPoint(cc.p(0,1))
        versionlab:setPosition(cc.p(gg.getPhoneLeft() + 5, display.height-2))
        versionlab:setColor(cc.c3b(110,110,110))
        node.version_=versionlab
        node:addChild(versionlab,1,100)
    elseif not tolua.isnull(node.version_) then
        node.version_:setString(verstr)
    end
end

--获取版本号字符串  返回字符串 -- 基础通用组件版本.扑克通用组件版本.游戏版本。
function Ex.GetGameVersionStr(game)

    local game_common_ver = gg.VersionHelper:getModuleClientVer(gg.VersionHelper.VER_MODULE_GAME_COMMON)
    local game_ver = tostring(checkint(game.clientversion))
    local defaultVerStr = nil

    if (Helper.And(game.type, GAME_GROUP_MAHJONG) ~= 0) then    --判断是麻将类游戏
        defaultVerStr =  string.format("v%s.v%s.v%s",
        game_common_ver, --大厅基础版本
        gg.VersionHelper:getModuleClientVer(gg.VersionHelper.VER_MODULE_MJ_COMMON), --麻将通用版本
        game_ver) --游戏版本
    elseif (Helper.And(game.type, GAME_GROUP_POKER) ~= 0) then  --判断是扑克类游戏
        defaultVerStr =  string.format("v%s.v%s.v%s",
        game_common_ver, --大厅基础版本
        gg.VersionHelper:getModuleClientVer(gg.VersionHelper.VER_MODULE_PK_COMMON), --扑克通用版本
        game_ver) --游戏版本
    else
        defaultVerStr =  string.format("v%s", game_ver)
    end

    return defaultVerStr
end
-- 获取短昵称
function Ex.GetShortNickName(nickname, len)
    len = len or 13
    if nickname and string.len(nickname) > len then
        return string.sub(nickname, 1, len - 3) .. "..."
    else
        return nickname
    end
end

-- 颜色值转换 0x to rgb
function Ex.ConvertColor(xstr)
    local toTen = function(v)
        return tonumber("0x" .. v)
    end

    local b = string.sub(xstr, -2, -1)
    local g = string.sub(xstr, -4, -3)
    local r = string.sub(xstr, -6, -5)

    local red = toTen(r)
    local green = toTen(g)
    local blue = toTen(b)
    if red and green and blue then
        return cc.c4b(red, green, blue, 255)
    end
end

-- 截图函数
function Ex.CaptureNode(node)
    local size = node:getContentSize()
    local rtx = cc.RenderTexture:create(size.width, size.height, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888, gl.DEPTH24_STENCIL8_OES)
    rtx:begin()
    node:visit()
    rtx:endToLua()
    local photo_texture = rtx:getSprite():getTexture()
    local captureSprite = cc.Sprite:createWithTexture(photo_texture)
    captureSprite:setFlippedY(true)
    return captureSprite
end

-- 传入DrawNode对象,画圆角矩形
function Ex.DrawNodeRoundRect(drawNode, rect, borderWidth, radius, color, fillColor)
    -- segments表示圆角的精细度,值越大越精细
    local segments = 100
    local origin = cc.p(rect.x, rect.y)
    local destination = cc.p(rect.x + rect.width, rect.y - rect.height)
    local points = {}
    -- 算出1/4圆
    local coef = math.pi / 2 / segments
    local vertices = {}

    for i = 0, segments do
        local rads = (segments - i) * coef
        local x = radius * math.sin(rads)
        local y = radius * math.cos(rads)

        table.insert(vertices, cc.p(x, y))
    end
    local tagCenter = cc.p(0, 0)
    local minX = math.min(origin.x, destination.x)
    local maxX = math.max(origin.x, destination.x)
    local minY = math.min(origin.y, destination.y)
    local maxY = math.max(origin.y, destination.y)
    local dwPolygonPtMax = (segments + 1) * 4
    local pPolygonPtArr = {}
    -- 左上角
    tagCenter.x = minX + radius;
    tagCenter.y = maxY - radius;
    for i = 0, segments do
        local x = tagCenter.x - vertices[i + 1].x
        local y = tagCenter.y + vertices[i + 1].y

        table.insert(pPolygonPtArr, cc.p(x, y))
    end
    -- 右上角
    tagCenter.x = maxX - radius;
    tagCenter.y = maxY - radius;
    for i = 0, segments do
        local x = tagCenter.x + vertices[#vertices - i].x
        local y = tagCenter.y + vertices[#vertices - i].y

        table.insert(pPolygonPtArr, cc.p(x, y))
    end
    -- 右下角
    tagCenter.x = maxX - radius;
    tagCenter.y = minY + radius;

    for i = 0, segments do
        local x = tagCenter.x + vertices[i + 1].x
        local y = tagCenter.y - vertices[i + 1].y

        table.insert(pPolygonPtArr, cc.p(x, y))
    end
    -- 左下角
    tagCenter.x = minX + radius;
    tagCenter.y = minY + radius;

    for i = 0, segments do
        local x = tagCenter.x - vertices[#vertices - i].x
        local y = tagCenter.y - vertices[#vertices - i].y

        table.insert(pPolygonPtArr, cc.p(x, y))
    end

    if fillColor == nil then
        fillColor = cc.c4f(0, 0, 0, 0)
    end
    drawNode:drawPolygon(pPolygonPtArr, #pPolygonPtArr, fillColor, borderWidth, color)
    return drawNode
end

--[[
* @brief 分页函数
* @parm t 需要分页的表
* @parm eleCount 每页的元素数
* @parm isKv 返回的表是否为键值对的形式
]]
function Ex.ArrangePage(t, eleCount, isKv)

    if not t or not eleCount then
        return
    end

    -- 计算分页数
    local page = math.ceil(gg.TableSize(t) / eleCount)

    -- 分页大表
    local pageTable = {}

    for i = 1, page do

        -- 创建分页表
        local eleTable = {}
        local j = 1
        for k, v in pairs(t) do

            if i == math.ceil(j / eleCount) then

                if isKv then
                    eleTable[k] = v
                else
                    table.insert(eleTable, v)
                end
            end
            j = j + 1
        end
        table.insert(pageTable, eleTable)
    end

    return pageTable
end

--[[
* @brief 1像素线不同分辨率 处理函数 横线
]]
function Ex.LineHandle(...)
    local args={...}
    -- 线处理
    local winSize = cc.Director:getInstance():getWinSize()
    local framesize = cc.Director:getInstance():getOpenGLView():getFrameSize()
    for _,v in ipairs(checktable(args)) do
        v:setScaleY( winSize.height / framesize.height  )
    end
end

--[[
* @brief 1像素线不同分辨率 处理函数  竖线
]]
function Ex.HandleLineV(...)
    local args={...}
    -- 线处理
    local winSize = cc.Director:getInstance():getWinSize()
    local framesize = cc.Director:getInstance():getOpenGLView():getFrameSize()
    for _,v in ipairs(args) do
       v:setScaleX( winSize.width / framesize.width  )
    end
end

local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
-- Base64 encoding
function Ex.base64Encode(data)
    return ((data:gsub('.', function(x)
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return b:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end

-- Base64 decoding
function Ex.base64Decode(data)
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
            return string.char(c)
    end))
end

--[[
* @brief 截取UTF8字符串,避免出现中文乱码
* @parm str 被截取的字符串
* @parm len 所需要截取字符串长度
]]
function Ex.SubUTF8String( str, len )
    local dropping = string.byte(str, len+1)
    if not dropping then return str end
    if dropping >= 128 and dropping < 192 then
        return Ex.SubUTF8String(str, len-1)
    end
    return string.sub(str, 1, len)
end

--[[
* @brief 截取UTF8字符串到一定长度
* @parm str 被截取的字符串
* @parm width 所需要截取的长度
* @parm fontSize 字体大小
* @parm dot 结尾添加的文本
]]
function Ex.SubUTF8StringByWidth( str, width, fontSize, dot )

    if not str then return end

    local sStr = str
    local tCode = {}
    local tName = {}
    local nLenInByte = #sStr
    dot = dot or "..."

    for i=1,nLenInByte do
        local curByte = string.byte(sStr, i)
        local byteCount = 0;
        if curByte>0 and curByte<=127 then
            byteCount = 1
        elseif curByte>=192 and curByte<223 then
            byteCount = 2
        elseif curByte>=224 and curByte<239 then
            byteCount = 3
        elseif curByte>=240 and curByte<=247 then
            byteCount = 4
        end
        local char = nil
        if byteCount > 0 then
            char = string.sub(sStr, i, i+byteCount-1)
            i = i + byteCount -1
        end
        if byteCount == 1 then
            table.insert(tName,char)
            table.insert(tCode,2/3)

        elseif byteCount > 1 then
            table.insert(tName,char)
            table.insert(tCode,1)
        end
    end

    local _sN = ""
    local _len = 0
    for i=1,#tName do
        _sN = _sN .. tName[i]
        _len = _len + tCode[i] * fontSize
        if _len >= width then
            return ( _sN..dot )
        end
    end
    return str

end

--[[
* @brief 检查手机号
* @param phone 手机号
* @return false:不合法
]]
function Ex.CheckPhone( phone )

    -- 验空
    if phone == nil then

        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "请输入手机号码！")
        return false
    end

    if #phone <= 0 then

        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "请输入手机号码！")
        return false
    end

    -- 验证长度
    if #phone ~= 11 then

        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "手机号码无效,请重新输入！")
        return false
    end

    -- 验证是否是纯数字
    local isN = tonumber(phone);
    if not isN then
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "手机号码无效,请重新输入！")
        return false
    end

    return true
end

function Ex.ExistChinese(s)
    local f = '[%z\1-\127\194-\244][\128-\191]*';
    local line, lastLine, isBreak = '', false, false;
    for v in s:gfind(f) do
        if #v~=1 then
            return true
        end
    end
    return false
end

--[[
* @brief 密码格式检查
* @param password 身份证号
* @return false:不合法
]]
function Ex.CheckPassword( password )

    -- 验空
    if password == nil then

        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "请您输入密码！")
        return false
    end

    if #password <= 0 then

        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "请您输入密码！")
        return false
    end

    if #password <6 or #password >16 then

        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "您输入的密码不规范,请输入6-16位字母+数字！")
        return false
    end
    if Ex.ExistChinese(password) then
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "您输入的密码不能包含中文字符")
        return false
    end
    return true
end

--[[
* @brief 验证码格式检查
* @param code 验证码
* @return false:不合法
]]
function Ex.CheckCode( code )

    -- 验空
    if code == nil then

        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "请输入短信验证码！")
        return false
    end

    if #code <= 0 then

        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "请输入短信验证码！")
        return false
    end

    -- 验证长度
    if #code ~= 4 then

        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "请输入正确的短信验证码！")
        return false
    end

    -- 验证是否是纯数字
    local isN = tonumber(code);
    if not isN then
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "请输入正确的短信验证码！")
        return false
    end

    return true
end

--[[
* @brief 检查身份证号
* @param idCard 身份证号
* @return false:不合法
]]
function Ex.CheckIdCard( idCard )

    -- 验空
    if idCard == nil then

        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "请输入您的身份证号！")
        return false
    end

    -- 验证长度
    if #idCard <= 0 then

        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "请输入您的身份证号！")
        return false
    end

    -- 验证长度
    if #idCard == 15 or #idCard == 18 then
        return true
    end

    GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "身份证号码格式错误,请重新输入！")
    return false
end

-- 判断是否是快速点击
function Ex.IsFastClick( sender, spaceTime )
    local curClickTime = socket.gettime()
    spaceTime = spaceTime or 1
    if sender._lastClickTime and (curClickTime - sender._lastClickTime < spaceTime) then
        local surplus=spaceTime- checkint( curClickTime - sender._lastClickTime)
        return true,surplus
    end
    sender._lastClickTime = curClickTime
    return false
end

-- 创建圆形头像
function Ex.createAvatarUI(node, clipImg)
    local width = node:getContentSize().width
    local height = node:getContentSize().height
    cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/room.plist")
    local clipNode = cc.ClippingNode:create(cc.Sprite:createWithSpriteFrameName(clipImg or "hall/room/friend/player_head_bg.png"))
    local img_avatar = ccui.ImageView:create("")
    img_avatar:ignoreContentAdaptWithSize(false)
    img_avatar:setContentSize(cc.size(width, height))
    img_avatar:setName("user_avatar")
    clipNode:addChild(img_avatar)
    clipNode:setAlphaThreshold(0)
    clipNode:setPosition(width / 2, height / 2)
    node:addChild(clipNode)
    return img_avatar
end

-- add by zq 获得屏幕UI位置左边界
function Ex.getPhoneLeft()
    if gg.isWideScreenPhone then
        return display.width * 0.035
    end
    return 0
end
-- add by zq 获得屏幕UI位置右边界
function Ex.getPhoneRight()
    if gg.isWideScreenPhone then
        return display.width * 0.965
    end
    return display.width
end

-- 判断当前包是否为渠道包
local ChannelIdTb = {"201", "202", "205", "206", "216", "207", "210", "224", "229", "230"}
function Ex.IsChannelPack()
    return Table:isValueExist(ChannelIdTb, CHANNEL_ID)
end

-- 判断道具是否是魔法道具
function Ex.IsMagicProp(propid)
    if propid >= 272 and propid <= 281 then
        return true
    end
    return false
end

return Ex
