-- 初始化扩展控件属性

import(".extends.FunctionEx")
import(".extends.LayerEx")
import(".extends.NodeEx")
import(".extends.SceneEx")
import(".extends.WidgetEx")
import(".extends.DeviceEx")
import(".ApiHelper")

gg.Queue = import(".utils.DQueue")
gg.Stack = import(".utils.Stack")
gg.Event = import(".utils.Event")
gg.ReconnectModule=import(".ReconnectModule")

--导出富文本控件全局名字
cc.exports.RichLabel=import(".richlabel.RichLabel")

-- 事件表定义
require "def.eventdef"
require "def.switch"
-- 配置加载模块列表
local configs =
{
    { "ViewBase", "common.ViewBase" },
    { "ViewPop", "common.ViewPop" },
    { "ViewLayout", "common.ViewLayout" },
    { "TabGroup", "common.tabgroup.TabGroup" }
}
local function preload_()
    for i, v in ipairs(configs) do
        local key = v[1]
        local value = v[2]
        local status, m = xpcall(function()
            return require(value)
        end, function(msg)
            if not string.find(msg, string.format("'%s' not found:", packageName)) then
                print("preload--- load moudel error: ", msg)
            end
        end)
        local t = type(m)
        if status and (t == "table" or t == "userdata") then
            cc.register(tostring(key), m)
        else
            printInfo("---preload %s filed!---", value)
        end
    end
end
preload_();

gg.MessageDialog = require("common.widgets.MessageDialog")

gg.ImageDownload = require("common.ImageDownloader")
--支付
gg.PayHelper = require("common.sdks.PayHelper")
--分享
gg.ShareHelper = require("common.sdks.ShareHelper")
--第三方
gg.ThirdParty = require("common.sdks.ThirdParty")

gg.InviteHelper = require("common.InviteHelper")

--推送
gg.NotificationHelper = require("common.sdks.NotificationHelper")

-- 荣誉
gg.HonorHelper = require("hall.models.HonorData")