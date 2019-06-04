-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 2

--包配置
APP_ID = 138 
-------------------------------------------------------------------------
local PACKAGE_CFG = {
    [138]={
        APP_NAME="测试",
        CHANNEL_ID="200",
        APP_KEY = "3647fed2fa310e0f1e48683557d157aa" ,
        WX_APP_ID_LOGIN="wxf78eea4e5d444058",
        WX_APP_ID_SHARE="wxf78eea4e5d444058",
        HALL_APP_VERSION={3,7,1},
        REGION_CODE=61,
    },
    [132]={
        APP_NAME="微乐湖北棋牌",
        CHANNEL_ID="200",
        APP_KEY = "a395b6f59af4fc2a8c3ded3d77205702" ,
        WX_APP_ID_LOGIN="wxfcb5c468afda4dd9",
        WX_APP_ID_SHARE="wxfcb5c468afda4dd9",
        HALL_APP_VERSION={1,0,0},
        REGION_CODE=42,
    },
    [110]={
        APP_NAME="微乐龙江棋牌",
        CHANNEL_ID="200",
        APP_KEY = "0fd00a8ecb3b4e38dcd921efc0deda77" ,
        WX_APP_ID_LOGIN="wx29494dd88fb64e38",
        WX_APP_ID_SHARE="wx29494dd88fb64e38",
        HALL_APP_VERSION={3,8,1},
        REGION_CODE=23,
    },
    [111]={
        APP_NAME="微乐辽宁棋牌",
        CHANNEL_ID="11",
        APP_KEY="825223e185a0d044245e18e79fbb8430",
        WX_APP_ID_LOGIN="wx3dfaf6e059ba1638",
        WX_APP_ID_SHARE="wx3dfaf6e059ba1638",
        HALL_APP_VERSION={3,8,1},
        REGION_CODE=21,
    },
    [112]={
        APP_NAME="微乐辽宁棋牌",
        CHANNEL_ID="200",
        APP_KEY="825223e185a0d044245e18e79fbb8430",
        WX_APP_ID_LOGIN="wx3dfaf6e059ba1638",
        WX_APP_ID_SHARE="wx3dfaf6e059ba1638",
        HALL_APP_VERSION={3,8,1},
        REGION_CODE=21,
    },
}

local function EXPORT_GLOABL_VAR(appid)
    local cfg=PACKAGE_CFG[appid]
    assert(cfg,"未匹配到 APP_ID:"..tostring(APP_ID).." 应用包的配置信息，请检查配置")
    for k,v in pairs(cfg) do
        _G[k]=v
    end
end

-------------------------------------------------------------------------------------
EXPORT_GLOABL_VAR(APP_ID)
-- wechat: 微信支付
-- alipay_client : 支付宝
-- unionpay_client : 银联支付
-- appstore : 苹果AppStore
PAY_CONFIG = {
    ["wechat"] = { appid=WX_APP_ID_LOGIN },
    ["alipay_client"] = {  
        rsa_private = "",
    },
    ["unionpay_client"] = { mode = "00" },
    ["appstore"] = {
        --ios 支付产品id
        -- ["goods20"]="com.xinyue.jilinmj.goods1",
        -- ["goods18"]="com.xinyue.jilinmj.goods2",
        -- ["goods19"]="com.xinyue.jilinmj.goods3",
    }
}
 
--陕西
UPDATE_URL_PREFIX={"xy3hsngp","hw5ooxsg","client9"}

-- 内容
-- 应用ID    121
-- 渠道ID    11
-- 分享地区    市
-- 支付宝配置   Email：jiaxianghudong@weile.com
-- 商户ID：2088221603340274
-- 微信ID    家乡：wx51324c476b2c7ba1
-- 微乐：wxf47ac51cdb0a8250
-- 个体：wx820a5c76b24910f4
-- 分享：wxd9f0b25fa5289e79，wx6a0507aab69e27cf
-- 游戏名称    微乐贵阳捉鸡
-- if Helper.platform==CC_PLATFORM_IOS then
--     APP_ID = "121" 
--     CHANNEL_ID = "11" 
--     APP_KEY = "4fe957853fdcd9228f271aca6bdd166e" 
--     WX_APP_ID_LOGIN="wx51324c476b2c7ba1" --微信登录appid
-- else
--     print("----platform "..Helper.platform)
--     APP_ID = "122" 
--     CHANNEL_ID = "200" 
--     APP_KEY = "4fe957853fdcd9228f271aca6bdd166e" 
--     WX_APP_ID_LOGIN="wx51324c476b2c7ba1" --微信登录appid
-- -- end
-- REGION_CODE = 52 --地区代码
 
-- wechat: 微信支付
-- alipay_client : 支付宝
-- unionpay_client : 银联支付
-- appstore : 苹果AppStore
-- PAY_CONFIG = {
--     ["wechat"] = { appid="wx51324c476b2c7ba1" },
--     ["alipay_client"] = {  
--         rsa_private = "MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBANY3GTv3SaqX/zNMhf4at61rJg1Cm9GpdHujJ3N5LnEtjXL6BwtGUlPe1A+XOSXoqZB1BeOi+aiE6yHfNs643nIPCLsSAmKZSulrssCDjnPOG/MuL8lcOT8c+rbezeWYmS2sm6ynE2lXxNHEA5u1bP+okR/zEdJIB01YgZUFnTJ1AgMBAAECgYEAqhRBIs1qXdoks1Q0ptYLs9L4+VpDYSoL5AZcUmCKsS2buwgtA5Sn1RN8h4xnwWODDcD8FgrV8ijmj5QsbeF2KuCElg+p4g4Moo1A/xznXfDm0ATY+8IzChuQkBtGoBNW1E5PWD0+BkaEf0+FhJDKVzGRAE+JLEyFbTDS9uZ0XwECQQD51oV+utG3cfNqBnedcrO4z6hROUs0tn+y+PuKPZUlVCH09YEkGyDX1Z9fBIRaUCFNiApl/VDIEChpNkbskqphAkEA23+npV2ABGu/ODJ1Fuu/fdJYIPXSGdvu9OalBkP2EpcKulFAH3gklQRfbkp5EBSX7GCFQkBm021hOLKdGA0IlQJBAND1ycXLP2itWCfPrO/1ZbgnhuIYh3xZP8lTUh+3ji0ghx440ICAaCHdvGRehMx8xL3yELBpBM2wJfyJtxxbN0ECQDssmwGVx2Fpus9nqvFW9PTytBeOremSxUT4uRyLTdeNKLM6HFNfjF0wJJoTMbgIFT0AeGx3+ECfiEpEvN0zBlECQGZ9JA9y91mKJS8ZlJrDc2HTB/wphQf5w5Mp+JuKmAWCk5I+k0TYm/8eAD9zTCTDTfrFG/kn0E3L87sEJ3KKGEY="
--     },
--     ["unionpay_client"] = { mode = "00" },
--     ["appstore"] = {
--         --ios 支付产品id
--         -- [6]  = "com.weile.newMoney1",
--         -- [12] = "com.weile.newMoney2",
--         -- [30] = "com.weile.newMoney3",
--         -- [50] = "com.weile.newMoney4",
--         -- [98] = "com.weile.newMoney5",
--         -- [188] ="com.weile.newMoney6",
--         -- [448] ="com.weile.newMoney7",
--         -- [18] = "com.weile.newMoney8"
--     }
-- }

--  