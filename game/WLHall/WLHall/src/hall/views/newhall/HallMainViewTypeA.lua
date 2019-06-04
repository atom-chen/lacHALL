--
-- Author: Cai
-- Date: 2018-07-03
-- Describe：自运营大厅

local M = class("HallMainViewTypeA", import(".HallMainViewBase"))
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
    self:resetLayout()
    -- 直接显示房间时隐藏人物图片，防止闪一下
    if not GameApp:CheckModuleEnable(ModuleTag.Room) then
        self.img_girl:setVisible(false)
    else
        -- 创建骨骼动画
        local params = {}
        params.pos = cc.p(self.img_girl:getPositionX() - 5, 107)
        params.aniName = "animation"
        self._girleAni = self:createSpineAni(CUR_PLATFORM.."/ani/Girl.json", CUR_PLATFORM.."/ani/Girl.atlas", params)
        if self._girleAni then
            self.img_girl:setVisible(false)
            self._girleAni:setScale(display.scaleY)
            self:addChild(self._girleAni)
        end
    end
    -- 注册消息通知
    self:registerCommonEventListener()
end

-- 适配
function M:resetLayout()
    self.nd_btns:setPosition(cc.p(gg.getPhoneRight(), display.cy))
    self.nd_btns:setScale(display.scaleY)
    self.img_girl:setPosition(cc.p(display.cx - 60, 0))
    self.img_girl:setScale(display.scaleY)
    -- 不显示大厅内容
    if not GameApp:CheckModuleEnable(ModuleTag.Room) then
        self.nd_btns:setVisible(false)
    end
    -- 初始化先隐藏比赛按钮和欢乐馆按钮
    self.btn_redpacket:setVisible(false)
    self.btn_mini:setVisible(false)
end

function M:updateBtnsShow()
    gg.GameCfgData:CheckLoaded(function()
        if tolua.isnull(self) then return end
        if hallmanager then
            self.btn_mini:setVisible(hallmanager:HasMiniGames())
        end
    end)
    -- 根据开关和斗地主游戏显示抢红包按钮
    if self:haveDDZGame() then
        self.btn_redpacket:setVisible(GameApp:CanShowMatch())
    else
        self.btn_redpacket:setVisible(false)
    end
    -- 根据显示调整坐标
    local posY = 182
    local idx = 0
    for i,v in ipairs(self.nd_btns:getChildren()) do
        if v:isVisible() then
            v:setPositionY(posY - 120 * idx)
            idx = idx + 1
        end
    end
end

-- 进入游戏
function M:enterGameAction()
    self.nd_btns:setVisible(false)
    if self._girleAni then
        self._girleAni:setVisible(false)
    else
        self.img_girl:setVisible(false)
    end
end

-- 返回大厅主界面
function M:playEnterAni()
    self.nd_btns:setVisible(true)
    if self._girleAni then
        self._girleAni:setVisible(true)
    else
        self.img_girl:setVisible(true)
    end

    self:setHallBlurBg(false)
    M.super.playEnterAni(self)
end

-- 更新完成隐藏并且重置进度
function M:onEventUpdateFinish(event, shortname, err)
    if "ddzh" == shortname then
        local node = self.btn_redpacket:getChildByName("download_bg")
        node:setVisible(false)
        local progress = node:getChildByName("progress")
        self:setDownloadProgress(0, progress)
        
        local curScene = GameApp:getRunningScene()
        local hasPopView = curScene:hasPopView()
        if self._isHallDownload and curScene.name_ == "HallScene" and not hasPopView and not err then
            self:doJoinMatchRoom()
        end
        self._isHallDownload = false
    end
end

-- 更新进度
function M:onEventUpdateChanged(event, p, shortname)
    if "ddzh" == shortname then
        local progress = self.btn_redpacket:getChildByName("download_bg"):getChildByName("progress")
        self:setDownloadProgress(p, progress)
    end
end

--==============================--
-- 点击事件
--==============================--
-- 抢红包
function M:onClickRedPacket()
    gg.AudioManager:playClickEffect()
    self:doJoinMatchRoom()
end

function M:doJoinMatchRoom()
    if not hallmanager or not hallmanager.games then return end
    local game = hallmanager:GetGameByShortName("ddzh")
    local isNeedUpdate, msg = hallmanager:CheckGameNeedUpdate(game)
    if isNeedUpdate then
        self._isHallDownload = true
        local node = self.btn_redpacket:getChildByName("download_bg")
        self:addProgress(node)
        node:setVisible(true)
        hallmanager:DoUpdateGame(game)
        return
    end

    self:joinMatchRoom()
end

-- 扑克馆
function M:onClickPoker()
    gg.AudioManager:playClickEffect()
    self:showGameListView("poker")
end

-- 麻将馆
function M:onClickMaJiang()
    gg.AudioManager:playClickEffect()
    self:showGameListView("majiang")
end

-- 欢乐馆
function M:onClickMini()
    gg.AudioManager:playClickEffect()
    self:showGameListView("xiuxian")
end

return M