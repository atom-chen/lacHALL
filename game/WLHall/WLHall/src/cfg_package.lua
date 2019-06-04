-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 2

--包配置
APP_ID = 110
-------------------------------------------------------------------------
local PACKAGE_CFG = {
    [109]={
        APP_NAME="微乐龙江棋牌",
        CHANNEL_ID="11",
        APP_KEY = "0fd00a8ecb3b4e38dcd921efc0deda77" ,
        WX_APP_ID_LOGIN="wx29494dd88fb64e38",
        WX_APP_ID_SHARE="wx29494dd88fb64e38",
        HALL_APP_VERSION={4,0,2},
        REGION_CODE=23,
    },
    [110]={
        APP_NAME="微乐龙江棋牌",
        CHANNEL_ID="200",
        APP_KEY = "0fd00a8ecb3b4e38dcd921efc0deda77" ,
        WX_APP_ID_LOGIN="wx29494dd88fb64e38",
        WX_APP_ID_SHARE="wx29494dd88fb64e38",
        HALL_APP_VERSION={4,1,6},
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
    [116]={
        APP_NAME="微乐湖南棋牌",
        CHANNEL_ID="200",
        APP_KEY="17992fea7637624fbbef7c941f30b59d",
        WX_APP_ID_LOGIN="wx02b4c1c216a23b44",
        WX_APP_ID_SHARE="wx02b4c1c216a23b44",
        HALL_APP_VERSION={1,0,0},
        REGION_CODE=43,
    },
    [122]={
        APP_NAME="微乐贵阳棋牌",
        CHANNEL_ID="200",
        APP_KEY="4fe957853fdcd9228f271aca6bdd166e",
        WX_APP_ID_LOGIN="wx51324c476b2c7ba1",
        WX_APP_ID_SHARE="wx51324c476b2c7ba1",
        HALL_APP_VERSION={3,9,1},
        REGION_CODE=52,
    },
    [137]={
        APP_NAME="微乐陕西棋牌",
        CHANNEL_ID="11",
        APP_KEY = "3647fed2fa310e0f1e48683557d157aa" ,
        WX_APP_ID_LOGIN="wxf78eea4e5d444058",
        WX_APP_ID_SHARE="wxf78eea4e5d444058",
        HALL_APP_VERSION={1,2,1},
        REGION_CODE=61,
    },
    [138]={
        APP_NAME="微乐陕西棋牌",
        CHANNEL_ID="200",
        APP_KEY = "3647fed2fa310e0f1e48683557d157aa" ,
        WX_APP_ID_LOGIN="wxc7778a71254ce9a6",
        WX_APP_ID_SHARE="wxc7778a71254ce9a6",
        HALL_APP_VERSION={3,7,1},
        REGION_CODE=61,
    },
    [137]={
        APP_NAME="微乐陕西棋牌",
        CHANNEL_ID="11",
        APP_KEY = "3647fed2fa310e0f1e48683557d157aa" ,
        WX_APP_ID_LOGIN="wxc7778a71254ce9a6",
        WX_APP_ID_SHARE="wxc7778a71254ce9a6",
        HALL_APP_VERSION={1,3,1},
        REGION_CODE=61,
    },
    [140]={
        APP_NAME="微乐江西棋牌",
        CHANNEL_ID="717",
        APP_KEY="d6959bf8673b0ecd85b5914c08e1dc15",
        WX_APP_ID_LOGIN="wx51324c476b2c7ba1",
        WX_APP_ID_SHARE="wx51324c476b2c7ba1",
        HALL_APP_VERSION={3,8,1},
        REGION_CODE=36,
    },
    [266]={
        APP_NAME="微乐海南麻将",
        CHANNEL_ID="200",
        APP_KEY = "4A8A68C450984db6e8B470f457DA0E91" ,
        WX_APP_ID_LOGIN="wx16733c4533a80d19",
        WX_APP_ID_SHARE="wx16733c4533a80d19",
        HALL_APP_VERSION={1,0,0},
        REGION_CODE=46,
    },
    [268]={
        APP_NAME="微乐三公",
        CHANNEL_ID="200",
        APP_KEY = "E48272dEEfA6139bBACEfDa1381ac8C3" ,
        WX_APP_ID_LOGIN="",
        WX_APP_ID_SHARE="",
        HALL_APP_VERSION={1,0,0},
        REGION_CODE=46,
    },
    [270]={
        APP_NAME="微乐湖北麻将",
        CHANNEL_ID="200",
        APP_KEY = "De7daBaB553849a6fc290E4BfCf1Ac4C" ,
        WX_APP_ID_LOGIN="wx4b12acf407bdbc49",
        WX_APP_ID_SHARE="wx4b12acf407bdbc49",
        HALL_APP_VERSION={1,0,0},
        REGION_CODE=42,
    },
    [272]={
        APP_NAME="微乐卡五星",
        CHANNEL_ID="210",
        APP_KEY = "C2702195a17fcBcd467CC571EEd6Bb50" ,
        WX_APP_ID_LOGIN="",
        WX_APP_ID_SHARE="",
        HALL_APP_VERSION={1,0,0},
        REGION_CODE=42,
    },
    [277]={
        APP_NAME = "微乐河南棋牌",
        CHANNEL_ID = "11",
        APP_KEY = "49ec42fC6EADbDc1aC8E4f0EB5501927" ,
        WX_APP_ID_LOGIN = "wxf78eea4e5d444058",
        WX_APP_ID_SHARE = "wxf78eea4e5d444058",
        HALL_APP_VERSION = {1,0,1},
        REGION_CODE = 41,
    },
    [278]={
        APP_NAME = "微乐河南棋牌",
        CHANNEL_ID = "200",
        APP_KEY = "49ec42fC6EADbDc1aC8E4f0EB5501927" ,
        WX_APP_ID_LOGIN = "wxf78eea4e5d444058",
        WX_APP_ID_SHARE = "wxf78eea4e5d444058",
        HALL_APP_VERSION = {1,0,1},
        REGION_CODE = 41,
    },
    [276]={
        APP_NAME="微乐天津麻将",
        CHANNEL_ID="11",
        APP_KEY = "3ABCa67393dB63BfcA7a4B47D87Ec6A9" ,
        WX_APP_ID_LOGIN="wx6d8890e578864ac5",
        WX_APP_ID_SHARE="wx6d8890e578864ac5",
        HALL_APP_VERSION={1,0,1},
        REGION_CODE=12,
    },
    [282]={
        APP_NAME = "微乐河北棋牌",
        CHANNEL_ID = "200",
        APP_KEY = "7Ebd000c164AA0Bd8aECA0CAAec6C6bd" ,
        WX_APP_ID_LOGIN = "",
        WX_APP_ID_SHARE = "",
        HALL_APP_VERSION = {1,0,0},
        REGION_CODE = 13,
    },
    [286]={
        APP_NAME = "微乐宁夏麻将",
        CHANNEL_ID = "200",
        APP_KEY = "f14E80f95E8cc0E675333Cb29b1EB3CA" ,
        WX_APP_ID_LOGIN = "",
        WX_APP_ID_SHARE = "",
        HALL_APP_VERSION = {1,0,0},
        REGION_CODE = 64,
    },

    [1001]={
        APP_NAME="家乡麻将",
        CHANNEL_ID="11",
        APP_KEY = "D529d4C14C45714dEBe6589E25BAcE99" ,
        WX_APP_ID_LOGIN="wx29494dd88fb64e38",
        WX_APP_ID_SHARE="wx29494dd88fb64e38",
        HALL_APP_VERSION={1,1,3},
        REGION_CODE=0,
    },

    [10002]={
        APP_NAME="微乐家乡棋牌",
        CHANNEL_ID="200",
        APP_KEY = "a110AeeeEc43d2ecA8086c4637Ec009C" ,
        WX_APP_ID_LOGIN="wxf78eea4e5d444058",
        WX_APP_ID_SHARE="wxf78eea4e5d444058",
        HALL_APP_VERSION={1,0,0},
        REGION_CODE=61,
    },

    [301]={
        APP_NAME="微乐甘肃棋牌",
        CHANNEL_ID="200",
        APP_KEY = "b4E4bfEddcdb8b69A8e50dA8aD0bd772" ,
        WX_APP_ID_LOGIN="wxf78eea4e5d444058",
        WX_APP_ID_SHARE="wxf78eea4e5d444058",
        HALL_APP_VERSION={1,0,1},
        REGION_CODE=62,
    },
    [34]={
        APP_NAME="微乐斗地主",
        CHANNEL_ID="200",
        APP_KEY = "3109b4b1582b7b1074d4e81348cc338e" ,
        WX_APP_ID_LOGIN="wx225e04d5d6adb163",
        WX_APP_ID_SHARE="wx25470c9871cff1f0",
        HALL_APP_VERSION={4,0,1},
        REGION_CODE=0,
        PACKAGE_TYPE = 1,
    }
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
--YY语音 sdk  appid
YY_APP_ID=1001334
-- wechat: 微信支付
-- alipay_client : 支付宝
-- unionpay_client : 银联支付
-- appstore : 苹果AppStore
PAY_CONFIG = {
    -- 微信支付 ID
    ["wechat"] = { appid=WX_APP_ID_LOGIN },
    ["alipay_client"] = {
        -- 密钥
        rsa_private = "MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBANY3GTv3SaqX/zNMhf4at61rJg1Cm9GpdHujJ3N5LnEtjXL6BwtGUlPe1A+XOSXoqZB1BeOi+aiE6yHfNs643nIPCLsSAmKZSulrssCDjnPOG/MuL8lcOT8c+rbezeWYmS2sm6ynE2lXxNHEA5u1bP+okR/zEdJIB01YgZUFnTJ1AgMBAAECgYEAqhRBIs1qXdoks1Q0ptYLs9L4+VpDYSoL5AZcUmCKsS2buwgtA5Sn1RN8h4xnwWODDcD8FgrV8ijmj5QsbeF2KuCElg+p4g4Moo1A/xznXfDm0ATY+8IzChuQkBtGoBNW1E5PWD0+BkaEf0+FhJDKVzGRAE+JLEyFbTDS9uZ0XwECQQD51oV+utG3cfNqBnedcrO4z6hROUs0tn+y+PuKPZUlVCH09YEkGyDX1Z9fBIRaUCFNiApl/VDIEChpNkbskqphAkEA23+npV2ABGu/ODJ1Fuu/fdJYIPXSGdvu9OalBkP2EpcKulFAH3gklQRfbkp5EBSX7GCFQkBm021hOLKdGA0IlQJBAND1ycXLP2itWCfPrO/1ZbgnhuIYh3xZP8lTUh+3ji0ghx440ICAaCHdvGRehMx8xL3yELBpBM2wJfyJtxxbN0ECQDssmwGVx2Fpus9nqvFW9PTytBeOremSxUT4uRyLTdeNKLM6HFNfjF0wJJoTMbgIFT0AeGx3+ECfiEpEvN0zBlECQGZ9JA9y91mKJS8ZlJrDc2HTB/wphQf5w5Mp+JuKmAWCk5I+k0TYm/8eAD9zTCTDTfrFG/kn0E3L87sEJ3KKGEY=",
        -- 商户 ID
        partner = "2088221603340274",
        -- 商户 email
        email = "jiaxianghudong@weile.com"
    },
    -- 银联支付
    ["unionpay_client"] = { mode = "00" },
    ["appstore"] = {
        --ios 支付产品id
        -- 微乐豆页面商品
        -- ["goods1"]="com.xinyue.jilinmj.goods2", -- 使用价格 ￥6 计费点
        -- ["goods2"]="com.xinyue.jilinmj.goods2", -- 使用价格 ￥12 计费点
        -- ["goods3"]="com.xinyue.jilinmj.goods2", -- 使用价格 ￥30 计费点
        -- ["goods4"]="com.xinyue.jilinmj.goods2", -- 使用价格 ￥50 计费点
        -- ["goods5"]="com.xinyue.jilinmj.goods2", -- 使用价格 ￥98 计费点
        -- ["goods6"]="com.xinyue.jilinmj.goods2", -- 使用价格 ￥448 计费点
        -- ["goods7"]="com.xinyue.jilinmj.goods2", -- 使用价格 ￥188 计费点
    }
}

-- 版本检查的并发请求域名前缀
UPDATE_URL_PREFIX={"p3kcsai8"}
IOS_AMAP_KEY = "d2a5fe84f42a316e9107170febba7308"
