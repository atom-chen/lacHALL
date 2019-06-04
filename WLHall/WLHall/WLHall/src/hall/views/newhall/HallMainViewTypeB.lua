----------------------------------------------------------------------
-- 作者：Cai
-- 日期：2018-07-23
-- 描述：oppo渠道大厅界面
----------------------------------------------------------------------

local M = class("HallMainViewTypeB", import(".HallMainViewTypeA"))
M.RESOURCE_FILENAME = "ui/newhall/hall_main_view.lua"
M.RESOURCE_BINDING = {
    ["nd_btns"]     = {["varname"] = "nd_btns"    },    -- 游戏入口按钮节点
    ["img_girl"]    = {["varname"] = "img_girl"   },
    ["btn_redpacket"] = {["varname"] = "btn_redpacket", ["events"] = {{event = "click", method = "onClickRedPacket"}}},
    ["btn_poker"]     = {["varname"] = "btn_poker",     ["events"] = {{event = "click", method = "onClickPoker"    }}},
    ["btn_majiang"]   = {["varname"] = "btn_majiang",   ["events"] = {{event = "click", method = "onClickMaJiang"  }}},
    ["btn_mini"]      = {["varname"] = "btn_mini",      ["events"] = {{event = "click", method = "onClickMini"     }}},
}

function M:onCreate()
    -- 替换资源
    self:replaceRes()
    -- 初始化先隐藏全部按钮，防止初始化按钮变化位置，闪一下问题
    for k,v in pairs(self.nd_btns:getChildren()) do
        v:setVisible(false)
    end

    M.super.onCreate(self)
end

function M:replaceRes()
    -- 将欢乐馆图片替换为小刺激
    self.btn_mini:loadTextureNormal("hall/newhall/hall_main3/btn_xcj.png", 0)
    self.btn_mini:loadTexturePressed("hall/newhall/hall_main3/btn_xcj.png", 0)
    self.btn_mini:loadTextureDisabled("hall/newhall/hall_main3/btn_xcj.png", 0)

    -- 替换麻将馆按钮图
    if Helper.IsFileExist("hall/newhall/replace/btn_mj.png") then
        self.btn_majiang:loadTextureNormal("hall/newhall/replace/btn_mj.png",0)
        self.btn_majiang:loadTexturePressed("hall/newhall/replace/btn_mj.png",0)
        self.btn_majiang:loadTextureDisabled("hall/newhall/replace/btn_mj.png",0)
    end

    -- 替换扑克馆按钮图
    if Helper.IsFileExist("hall/newhall/replace/btn_pk.png") then
        self.btn_poker:loadTextureNormal("hall/newhall/replace/btn_pk.png",0)
        self.btn_poker:loadTexturePressed("hall/newhall/replace/btn_pk.png",0)
        self.btn_poker:loadTextureDisabled("hall/newhall/replace/btn_pk.png",0)
    end
end

function M:updateBtnsShow()
    self.btn_majiang:setVisible(true)
    self.btn_poker:setVisible(true)
    M.super.updateBtnsShow(self)
end

return M