--
-- Author: Your Name
-- Date: 2016-10-19 16:34:49
--全局枚举变量 WXScene
cc.exports.WXScene={
    Session  = 0,       -- /**< 聊天界面    */
    Timeline = 1,       -- /**< 朋友圈      */
    Favorite = 2,       -- /**< 收藏       */
}
local ProviderBase = class("ProviderBase")

ProviderBase.Enum =
{
    STATE_SUCCESS = 0, --成功
    STATE_FAILED = 1, --失败
    STATE_CANCEL = 2, --取消
    STATE_CHECKING = 3, --结果处理中
}


 --微信回调用 枚举变量 WXErrCode
ProviderBase.WXErrCode= {
    Success    = 0,   -- /**< 成功    */
    Common     = -1,  -- /**< 普通错误类型    */
    UserCancel = -2,  -- /**< 用户点击取消并返回    */
    SentFail   = -3,  -- /**< 发送失败    */
    AuthDeny   = -4,  -- /**< 授权失败    */
    Unsupport  = -5,  -- /**< 微信不支持    */
    SignErr    = -6,  -- /**< 签名错误     */

    Uninstall  = 1,   -- /**< 微信未安装    */
    Unknown    = 2,   -- /**< 未知错误  */
    ShareTypeError = 3,  -- /**< 使用了微信以外的分享渠道 */

    ImageLoadError = 101,   -- /** 加载图片失败 */
}

-- 分享结果提示
ProviderBase.ShareErrMsg = {
    [ProviderBase.WXErrCode.Success]    = "分享成功",   -- /**< 成功    */
    [ProviderBase.WXErrCode.Common]     = "分享普通错误",  -- /**< 普通错误类型    */
    [ProviderBase.WXErrCode.UserCancel] = "取消分享",  -- /**< 用户点击取消并返回    */
    [ProviderBase.WXErrCode.SentFail]   = "分享失败",  -- /**< 发送失败    */
    [ProviderBase.WXErrCode.AuthDeny]   = "分享授权失败",  -- /**< 授权失败    */
    [ProviderBase.WXErrCode.Unsupport]  = "微信不支持分享",  -- /**< 微信不支持    */
    [ProviderBase.WXErrCode.SignErr]    = "签名错误",
    [ProviderBase.WXErrCode.Uninstall]  = "请安装微信",  -- /**< 微信未安装    */
    [ProviderBase.WXErrCode.Unknown]    = "",  -- /**< 未知错误，目前未知错误的错误码是底层模拟的返回信息，不能确定分享成功还是失败。所以这里不提示任何信息。   */
    [ProviderBase.WXErrCode.ShareTypeError] = "请使用微信分享", -- /**< 使用了微信以外的分享渠道 */
    [ProviderBase.WXErrCode.ImageLoadError] = "加载图片失败"
}

function ProviderBase:_getShareErrMsg(errCode)
    return ProviderBase.ShareErrMsg[errCode]
end

-- 支付结果提示
ProviderBase.PayErrMsg = {
    ["wechat"] = {
        [ProviderBase.WXErrCode.Success]    = "支付成功",   -- /**< 成功    */
        [ProviderBase.WXErrCode.Common]     = "支付普通错误",  -- /**< 普通错误类型    */
        [ProviderBase.WXErrCode.UserCancel] = "取消支付",  -- /**< 用户点击取消并返回    */
        [ProviderBase.WXErrCode.SentFail]   = "支付失败",  -- /**< 发送失败    */
        [ProviderBase.WXErrCode.AuthDeny]   = "支付授权失败",  -- /**< 授权失败    */
        [ProviderBase.WXErrCode.Unsupport]  = "微信不支持支付",  -- /**< 微信不支持    */
        [ProviderBase.WXErrCode.SignErr]    = "签名错误，支付失败",
        [ProviderBase.WXErrCode.Uninstall]  = "请安装微信",  -- /**< 微信未安装    */
        [ProviderBase.WXErrCode.Unknown]    = "微信支付未知错误",  -- /**< 未知错误    */
    },
    ["midas"] = {
        [0]  = "支付成功",
        [-1] = "支付错误",
        [-2] = "取消支付",
        [-3] = "支付结果未知，请重新登录游戏！",
        [-4] = "token 过期，支付失败！",
        [-5] = "支付参数错误！",
    },
    ["baidu"] = {
        [0]     = "支付成功",
        [3011]  = "购买失败",
        [3012]  = "玩家取消支付",
        [3013]  = "购买出现异常",
        [3014]  = "玩家关闭支付中心",
        [3015]  = "用户透传数据不合法",
    },
    ["360"] = {
        [0] = "支付成功",
        [-1] = "取消支付",
        [1] = "支付失败",
        [4010201] = "360登录状态已失效，请重新登录后再支付"
    },
    ["oppo"] = {
        [0] = "支付成功",
        [1004] = "取消支付",
        [1100] = "支付失败"
    },
    ["vivo"] = {
        [0] = "支付成功",
        [1] = "支付失败"
    },
    ["huawei"] = {
        [0] = "支付成功",
        [-1] = "支付失败",
        [2] = "取消支付",
        [30000] = "取消支付", -- 新版本华为 SDK，取消支付返回 30000
    },
    ["toutiao"] = {
        [0] = "支付成功",
        [-1] = "取消支付",
        [-2] = "支付失败",
        [-3] = "未知错误"
    },
    ["newVivo"] = {
        [0] = "支付成功",
        [-1] = "取消支付",
        [-2] = "其他错误",
        [-3] = "参数错误",
        [-4] = "支付结果请求超时",
        [-5] = "非足额支付（充值成功，未完成支付）",
        [-6] = "初始化失败",
        [1]  = "未知错误",
    },
    ["meizu"] = {
        [0] = "支付成功",
        [1] = "网络连接超时, 请重试",
        [2] = "取消支付",
        [4] = "账户信息验证出错",
        [5] = "游戏ID验证出错",
        [6] = "重复支付",
        [7] = "下单出错",
        [100] = "插件服务启动不成功"
    },
    ["samsung"] = {
        [0] = "支付成功",
        [2] = "取消支付",
        [3] = "支付错误",
        [-1] = "支付签名验证失败"
    }
}

function ProviderBase:_getPayErrMsg(type, errCode)
    local msg = nil
    local errTable = ProviderBase.PayErrMsg[type]
    if errTable then
        msg = errTable[errCode]
    end

    return msg
end

function ProviderBase:ctor(interface)
    self.interface_ = interface
end

function ProviderBase:setListener(interface)
    self.interface_ = interface
end

--- 执行命令
function ProviderBase:doCommand(cmdstr,args)
    args = checktable(args)
    if cmdstr == "pay" then
        self:doOrderReq(args)
    elseif cmdstr == "wxshare" then
        GameApp:dispatchEvent(gg.Event.DISABLE_APPENTER)
        self:doWXShareReq(args)
    elseif cmdstr =="wxauth" then
        self:doWXAuthReq(args)
       -- printError("ProviderBase:doCommand() - invaild cmd:" .. args.cmd)
    end
end

--支付结果回调  { status=msg.status, paytype="appstore" ,msg="支付成功！"}
function ProviderBase:onPayCallback(result)
    result = checktable(result)
    printf("ProviderBase:onPayCallback(luastr)" .. tostring(json.encode(result)))
    result.msg = result.msg or self:_getPayErrMsg(result.type, result.status)
    result.msg = result.msg or ""
    GameApp:dispatchEvent(gg.Event.SHOW_LOADING)
    local Enum = checktable(ProviderBase.Enum)
    if result.status == Enum.STATE_CHECKING then --结果处理中
        GameApp:dispatchDelayEvent(gg.Event.SHOW_LOADING,0, result.msg)
    else
        if result.msg ~= "" then
            GameApp:dispatchDelayEvent(gg.Event.SHOW_TOAST, 0, result.msg)
        elseif result.status ~= 0 and result.type ~= "mi" then
            -- 小米SDK会自己弹吐司，游戏就不要再弹了
            GameApp:dispatchDelayEvent(gg.Event.SHOW_TOAST, 0, "支付错误码：" .. result.status .. "，请重试！")
        end

        GameApp:dispatchDelayEvent(gg.Event.ON_PAY_RESULT,0, result)   -- 支付结果回调
    end
    gg.InvokeFuncNextFrame(self.interface_,result)
end

--分享回调
function ProviderBase:onShareCallback(result)
    printf("ProviderBase:onShareCallback(result) "..json.encode(result))
    if checkint(result.status) == ProviderBase.WXErrCode.Unknown and SHARE_RETRY_PARAMS then
        -- 如果是未知错误，且需要重试，那么再调用一次share接口
        gg.InvokeFuncNextFrame(function()
            if SHARE_RETRY_PARAMS then
                gg.ShareHelper:doShare(SHARE_RETRY_PARAMS.args, SHARE_RETRY_PARAMS.cb)
                cc.exports.SHARE_RETRY_PARAMS = nil
            end
        end)
        return
    end

    -- 清除重试参数
    cc.exports.SHARE_RETRY_PARAMS = nil

    result.msg = self:_getShareErrMsg(result.status)
    result.msg = result.msg or ""

    if result.msg ~= "" then
        GameApp:dispatchDelayEvent(gg.Event.SHOW_TOAST,0, result.msg)
    end

    GameApp:dispatchDelayEvent(gg.Event.ON_SHARE_RESULT,0,result)
    gg.InvokeFuncNextFrame(self.interface_,result)
end

-- virtual interface
function ProviderBase:addListener() return self end

function ProviderBase:doPayReq(args)
    printf("plelease implement doPayReq function ")
    printf("pay method not supported platform %s", device.platform)
    GameApp:dispatchEvent(gg.Event.SHOW_TOAST, string.format("此功能不支持 %s 平台", device.platform))
end

function ProviderBase:doWXShareReq(args)
    printf("plelease implement doWXShareReq function ")
    printf("share method not supported platform %s", device.platform)
    GameApp:dispatchEvent(gg.Event.SHOW_TOAST, string.format("此功能不支持 %s 平台", device.platform))
end

function ProviderBase:doWXAuthReq(args)
    printf("plelease implement doWXAuthReq function ")
    printf("wxauth method not supported platform %s", device.platform)
    GameApp:dispatchEvent(gg.Event.SHOW_TOAST, string.format("此功能不支持 %s 平台", device.platform))
end

-- 下单操作
function ProviderBase:doOrderReq(args)
    assert(args,"支付参数未知！")
    local function ordercallback_(dat)
        GameApp:dispatchEvent(gg.Event.SHOW_LOADING)
        if dat and dat.status == 0 then
            local pay_args = checktable(dat)
            table.merge(checktable(args.ext), checktable(pay_args.ext))
            table.merge(pay_args, args)
            GameApp:dispatchEvent(gg.Event.DISABLE_APPENTER)
            self:doPayReq(pay_args)

            -- 第三方统计
            local tempArgs = clone(args)
            tempArgs.orderid = pay_args.orderid
            gg.ThirdParty:startPay(tempArgs)
        else
            if dat and (checkint(dat.status) == API_ERR_CODE.ShowToast or checkint(dat.status) == API_ERR_CODE.ShowMsg) then
                -- web 返回的状态码已进行了相应的提示，这里不再提示
                return
            end

            if dat and dat.msg then
                printf("下单失败！" .. dat.msg)
            end
            GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "下单失败,请重试！")
        end
    end

    -- 检测ios是否存在漏单的操作，如果存在则优先恢复购买
    if device.platform == "ios" and self.checkFailOrder then
        if args.type == "appstore" and self:checkFailOrder() then
            printf("ProviderBase:checkFailOrder ------ %s", json.encode(args))
            return
        end
    end
    printf("ProviderBase:doOrderReq------ "..json.encode(args))

    if device.platform == "ios" and not gg.PayHelper:checkHasH5SDK() then
        printf("doOrderReq has not h5 sdk")
        args.new_h5 = 1
    end

    gg.Dapi:OrderNew(args, ordercallback_)
end


return ProviderBase
