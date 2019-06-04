--
-- Author: Cai
-- Date: 2017-03-30
-- Describe：荣誉分享界面
local ViewWidget = require("src.common.ViewWidget")
local M = class("HonorShareView", ViewWidget)

M.RESOURCE_FILENAME = "ui/honor/honor_share_view.lua"
M.RESOURCE_BINDING = {
    ["img_logo"]   = {["varname"] = "img_logo"  },
    ["img_ewm"]    = {["varname"] = "img_ewm"   },
    ["img_avatar"] = {["varname"] = "img_avatar"},
    ["txt_nick"]   = {["varname"] = "txt_nick"  },
    ["txt_time"]   = {["varname"] = "txt_time"  },
    ["img_grade"]  = {["varname"] = "img_grade" },
    ["txt_grade"]  = {["varname"] = "txt_grade" },
    ["nd_rank"]    = {["varname"] = "nd_rank"   },
    ["txt_area"]   = {["varname"] = "txt_area"  },
    ["txt_rank"]   = {["varname"] = "txt_rank"  },
    ["txt_str_m"]  = {["varname"] = "txt_str_m" },
    ["txt_str_smcyt"] = {["varname"] = "txt_str_smcyt"},
}

local GRADE_MAP = {
    [1] = "x",
    [2] = "c",
    [3] = "z",
    [4] = "g",
    [5] = "q",
    [6] = "d",
}

local HIDE_CODE_CHANNEL = {
    205, 206, 207, 210, 216, 224,
}

function M:updateView(data, imgEwm)
    --获取是否有二维码 有的话用获取的二维码
    self.img_logo:ignoreContentAdaptWithSize(true)
    self.img_logo:loadTexture(CUR_PLATFORM .. "/img_logo.png", 0)
    if imgEwm then
        self.img_ewm:loadTexture(imgEwm, 0)
    else
        -- 部分渠道隐藏二维码显示
        if Table:isValueExist(HIDE_CODE_CHANNEL, checkint(CHANNEL_ID)) then
            self.img_ewm:setVisible(false)
            self.txt_str_smcyt:setString(tostring(APP_NAME))
            self.txt_str_smcyt:setPositionX(1120)
        else
            self.img_ewm:loadTexture(CUR_PLATFORM .. "/honor_ewm.png", 0)
        end
    end

    local userinfo = {}
    if hallmanager and hallmanager:IsConnected() then
        userinfo = hallmanager.userinfo or {}
    end

    local hlvExp = hallmanager:GetHonorValue()
    local grade, star, maxexp = gg.GetHonorGradeAndLevel(hlvExp)
    -- 奖杯
    self.img_grade:loadTexture("hall/honor/grade_img_" .. grade .. ".png", 1)
    -- 段位
    self.txt_grade:setString(string.format("%s%ds", GRADE_MAP[grade], star))
    -- 昵称
    self.txt_nick:setString(gg.SubUTF8StringByWidth(tostring(userinfo.nick), 196, 28, ""))
    -- 头像
    local avatarPath = gg.IIF(userinfo.sex == 1, "common/hd_male.png", "common/hd_female.png")
    if userinfo.avatarurl and userinfo.avatarurl ~= "" then
        gg.ImageDownload:LoadUserAvaterImage({url = userinfo.avatarurl, ismine = true, image = self.img_avatar})
    else
        self.img_avatar:loadTexture(avatarPath)
    end
    -- 时间
    self.txt_time:setString(os.date("%Y/%m/%d", os.time()))
    -- 排名
    if checkint(data.rank) <= 0 then
        self.txt_area:setString(string.format("%s 即将上榜！", data.name))
        self.txt_str_m:setVisible(false)
        self.txt_rank:setVisible(false)
    else
        self.txt_area:setString(string.format("%s 第", data.name))
        self.txt_rank:setString(data.rank)
        self.txt_rank:setPositionX(self.txt_area:getContentSize().width + 10)
        self.txt_str_m:setPositionX(self.txt_rank:getPositionX() + self.txt_rank:getContentSize().width + 10)
        -- 设置文本居中
        local len = self.txt_area:getContentSize().width + self.txt_rank:getContentSize().width + self.txt_str_m:getContentSize().width + 20
        self.nd_rank:setPositionX(568 - len / 2)
    end
end

return M