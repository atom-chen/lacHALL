gg.Cookies = require("login.CookiesHelper")
gg.LoginHelper=require("login.LoginHelper")
cc.register("WXLogin", require("login.wx.WXLogin"))
cc.register("YSDKLogin", require("login.ysdk.YSDKLogin"))
cc.register("HWLogin", require("login.huawei.HWLogin"))
cc.register("VivoLogin", require("login.vivo.VivoLogin"))
cc.register("OppoLogin", require("login.oppo.OppoLogin"))
cc.register("XiaomiLogin", require("login.xiaomi.XiaomiLogin"))
cc.register("QihooLogin", require("login.qihoo.QihooLogin"))
cc.register("ToutiaoLogin", require("login.toutiao.ToutiaoLogin"))
cc.register("MeizuLogin", require("login.meizu.MeizuLogin"))
cc.register("SamsungLogin", require("login.samsung.SamsungLogin"))
cc.register("LoginManager", require("login.LoginManager"))