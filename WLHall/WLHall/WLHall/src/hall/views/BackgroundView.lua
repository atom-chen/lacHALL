
-- Author: zhaoxinyu
-- Date: 2017-05-05 16:36:20
-- Describe：背景界面

local BackgroundView = class("BackgroundView", cc.load("ViewBase"))

BackgroundView.RESOURCE_FILENAME = "ui/hall/background_layer.lua"
BackgroundView.RESOURCE_BINDING = {
	["pic_sky"] = {["varname"] = "pic_sky"},                 												-- 前景
}

BackgroundView.AUTO_RESOLUTION = true

local SettingManager = require("common.setting.SettingManager")

function BackgroundView:onCreate()
    self.rect = cc.rect(0, 0, display.width, display.height)
    self.pic_sky:setScaleY(display.height / self.pic_sky:getContentSize().height)
    self:initView()
end

--[[
* @brief 初始化View
]]
function BackgroundView:initView()
    local bgPath = "res/hall/newhall/img_hall_blur_bg.jpg"
    local blurBg = cc.Sprite:create(bgPath)
    if blurBg then
        blurBg:setScaleY(display.height / blurBg:getContentSize().height)
        blurBg:setPosition(cc.p(display.width / 2, display.height / 2))
        self._blurBg = blurBg
        self._blurBg:setVisible(false)
        self:addChild(self._blurBg)
    end
end

function BackgroundView:showBlurBg(isBlur)
    if self._blurBg then
        self._blurBg:setVisible(isBlur)
    end
end

return BackgroundView