--全局通用配置

--是否是内网测试
IS_LOCAL_TEST = false

if IS_LOCAL_TEST then
     --//登陆服务器列表
    LOGIN_SERVER_LIST = { {url="192.168.67.6",port=6532} }
    print("内网测试服务器 : ".. LOGIN_SERVER_LIST[1].url)
else
    --//登陆服务器列表
    LOGIN_SERVER_LIST = LOGIN_SERVER_LIST or {}
end

IS_REVIEW_MODE = IS_REVIEW_MODE ~= nil and IS_REVIEW_MODE  --//审核模式默认状态为 false
--0 吉祥 1 微乐
BRAND = BRAND or 1
IS_WEILE = BRAND==1
URLKEY = APP_ID .. APP_KEY .. APP_ID

PLATFORM={}
PLATFORM[0]="jixiang"
PLATFORM[1]="weile"
PLATFORM[2]="xinyueyouxi"

PLATFORM_NAMES={}
PLATFORM_NAMES[0]="吉祥"
PLATFORM_NAMES[1]="微乐"
PLATFORM_NAMES[2]="心悦"

--//热线电话
HOT_LINES ={}
HOT_LINES[0]= "4008-777-868"
HOT_LINES[1]= "4008-323-777"

--//默认网址
WEB_DOMAINS={}
WEB_DOMAINS[0]="jixiang.cn"
WEB_DOMAINS[1]="weile.com"

--豆豆名字根据品牌显示
BEAN_NAME= BRAND==1 and "微乐豆" or "开心豆"

HOT_LINE=HOT_LINES[BRAND]
WEB_DOMAIN = WEB_DOMAINS[BRAND]
PLATFORM_NAME=PLATFORM_NAMES[BRAND]
CUR_PLATFORM=PLATFORM[BRAND]

URLKEY = APP_ID .. APP_KEY .. APP_ID
--//默认游戏LOGO下载地址
APP_ICON_PATH = "http://assets." .. WEB_DOMAIN .. "/icon/common/"

FORGOT_PASSWORD_URL = "http://u."..WEB_DOMAIN.."/password"

 --是否开启vip功能 提供游戏中使用
VIP_ENABLE = VIP_ENABLE or 0
-- 模块开关1：关闭游戏添加功能
-- 2：关闭福袋
-- 4：关闭个人信息
-- 8：关闭公告
-- 16：关闭背包
-- 32：关闭商城
MODULES_SWTITCH = MODULES_SWTITCH or 0

--支付开关：1:微信 2：支付宝 4：银联 8：AppStore
PAY_SWITCH = PAY_SWITCH or 0xffffFFFF

--游戏版本 [1]=2,[2]=13
GAME_VERSION_LIST=GAME_VERSION_LIST or {}

-- execute hot update manifest file
local hall_manifest_file=loadfile( SEARCH_SRC.."manifest.lua")
local ok,manifest_table=pcall(hall_manifest_file)  --大厅动态版本号 热更新自动增加
if ok and manifest_table then
    HALL_WEB_VERSION = manifest_table.version or HALL_APP_VERSION
    if manifest_table.cmd ~= nil and #manifest_table.cmd > 0 then --如果有指定命令行,则执行lua字符串
        local ok,msg= pcall(loadstring(manifest_table.cmd))
        if not ok then
            print("execute launch cmd error :"..msg)
        end
    end

    if manifest_table.extfile and manifest_table.extfile ~= "" then
        --执行本地配置,本地配置会覆盖全局配置
        dofile(manifest_table.extfile)
    end
else
    HALL_WEB_VERSION=HALL_APP_VERSION
end
