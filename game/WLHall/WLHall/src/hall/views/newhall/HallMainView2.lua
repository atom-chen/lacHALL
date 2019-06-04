
-- Describe：大厅主界面
-- Type：常规包大厅

local M = class("HallMainView2", import(".HallMainViewBase"))
M.RESOURCE_FILENAME = "ui/newhall/hall_main2/hall_main_view2.lua"
M.RESOURCE_BINDING =
{
    ["nd_btns"]  = {["varname"] = "nd_btns"},  -- 游戏入口按钮节点

    ["btn_pkg"] = {["varname"] = "btn_pkg", ["events"] = {{event = "click", method = "onClickPkg"}}},--扑克馆
    ["btn_mjg"]  = {["varname"] = "btn_mjg",  ["events"] = {{event = "click", method = "onClickMjg"}}},  --麻将馆
    ["btn_ddz"] = {["varname"] = "btn_ddz",  ["events"] = {{event = "click", method = "onClickDdz"}}},  --斗地主
    ["btn_ylg"] = {["varname"] = "btn_ylg",  ["events"] = {{event = "click", method = "onClickYlg"}}},  --娱乐馆
}

function M:onCreate()
    --适配
    self:resetLayout()
    --初始化开关
    self:initSwitch()
    --初始化大厅动画
    self:runHallAni()
    -- 注册消息通知
    self:registerCommonEventListener()
end

function M:runHallAni()
    self.animation = self.resourceNode_["animation"]
    self:runAction(self.animation)
    if self.animation then
        self.animation:play("btnani", true)
    end
end

function M:resetLayout()
    -- 适配
    self.nd_btns:setPosition(cc.p(gg.getPhoneRight(), display.cy + 20))
    self.nd_btns:setScale(math.min( display.scaleX, display.scaleY))
end

function M:initSwitch()
      -- 不显示大厅内容
    if not GameApp:CheckModuleEnable(ModuleTag.Room) then
        self.nd_btns:setVisible(false)
    end
    -- 初始化先隐藏比赛,娱乐馆按钮
    self.btn_ddz:setVisible(false)
    self.btn_ylg:setVisible(false)
    --虚化背景
    self:setHallBlurBg(true)
end

-- 刷新界面按钮显示的方法，需要在各自界面重写已响应通知
function M:updateBtnsShow()
    if hallmanager then
        gg.GameCfgData:CheckLoaded(function()
            if tolua.isnull(self) then return end
            self.btn_ylg:setVisible(hallmanager:HasMiniGames())
        end)
    end
    -- 根据开关和斗地主游戏显示抢红包按钮
    if self:haveDDZGame() then
        self.btn_ddz:setVisible(GameApp:CanShowMatch())
    else
        self.btn_ddz:setVisible(false)
    end
end

-- 进入游戏
function M:enterGameAction()
    self.nd_btns:setVisible(false)
end

-- 返回大厅主界面
function M:playEnterAni()
    self.nd_btns:setVisible(true)
    M.super.playEnterAni(self)
end

-- 更新完成隐藏并且重置进度
function M:onEventUpdateFinish(event, shortname, err)
    if "ddzh" == shortname then
        local node = self.btn_ddz:getChildByName("download_bg")
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
        local progress = self.btn_ddz:getChildByName("download_bg"):getChildByName("progress")
        self:setDownloadProgress(p, progress)
    end
end

-- 扑克馆
function M:onClickPkg(sender)
    gg.AudioManager:playClickEffect()
    self:showGameListView("poker")
end

-- 麻将馆
function M:onClickMjg(sender)
    gg.AudioManager:playClickEffect()
    self:showGameListView("majiang")
end

-- 斗地主
function M:onClickDdz(sender)
    gg.AudioManager:playClickEffect()
    self:doJoinMatchRoom()
end

function M:onClickYlg(sender)
    gg.AudioManager:playClickEffect()
    self:showGameListView("xiuxian")
end

function M:doJoinMatchRoom()
    if not hallmanager or not hallmanager.games then return end
    local game = hallmanager:GetGameByShortName("ddzh")
    local isNeedUpdate, msg = hallmanager:CheckGameNeedUpdate(game)
    if isNeedUpdate then
        self._isHallDownload = true
        local node = self.btn_ddz:getChildByName("download_bg")
        self:addProgress(node)
        node:setVisible(true)
        hallmanager:DoUpdateGame(game)
        return
    end

    self:joinMatchRoom()
end

return M
