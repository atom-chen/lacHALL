
-- Describe：大厅主界面
-- Type：单包大厅 or 地方扑克单包

local M = class("HallMainView1", import(".HallMainViewBase"))
M.RESOURCE_FILENAME = "ui/newhall/hall_main1/hall_main_view1.lua"
M.RESOURCE_BINDING =
{
    ["nd_btns"]  = {["varname"] = "nd_btns"},  -- 游戏入口按钮节点
    ["img_girl"] = {["varname"] = "img_girl"}, -- 人物

    ["btn_bs"] = {["varname"] = "btn_bs", ["events"] = {{event = "click", method = "onClickBs"}}},--比赛
    ["btn_ddz"]  = {["varname"] = "btn_ddz",  ["events"] = {{event = "click", method = "onClickDdz"}}},  --斗地主
    ["btn_ylg"]  = {["varname"] = "btn_ylg",  ["events"] = {{event = "click", method = "onClickYlg"}}},  --娱乐馆
}

function M:onCreate()
    --适配
    self:resetLayout()
    -- 替换资源
    self:replaceRes()
    --初始化动画
    self:initGirlAni()
    --初始化大厅动画
    -- 直接显示房间时隐藏人物图片，防止闪一下
    if not GameApp:CheckModuleEnable(ModuleTag.Room) then
        self.img_girl:setVisible(false)
    else
        self:runHallAni()
    end
    --初始化开关
    self:initSwitch()
    -- 注册消息通知
    self:registerCommonEventListener()
end

function M:replaceRes()
    -- 替换比赛按钮背景图
    if Helper.IsFileExist("hall/newhall/replace/btn_match_bg.png") then
        self.btn_bs:loadTextureNormal("hall/newhall/replace/btn_match_bg.png",0)
        self.btn_bs:loadTexturePressed("hall/newhall/replace/btn_match_bg.png",0)
        self.btn_bs:loadTextureDisabled("hall/newhall/replace/btn_match_bg.png",0)
    end

    -- 替换比赛按钮动画icon
    if Helper.IsFileExist("hall/newhall/replace/bs_icon_1.png") then
        self.btn_bs:getChildByName("img_bisai1"):loadTexture("hall/newhall/replace/bs_icon_1.png", 0)
    end

    if Helper.IsFileExist("hall/newhall/replace/bs_icon_2.png") then
        self.btn_bs:getChildByName("img_bisai2"):loadTexture("hall/newhall/replace/bs_icon_2.png", 0)
    end

    -- 替换单包游戏icon背景图
    if Helper.IsFileExist("hall/newhall/replace/btn_game_bg.png") then
        self.btn_ddz:loadTextureNormal("hall/newhall/replace/btn_game_bg.png",0)
        self.btn_ddz:loadTexturePressed("hall/newhall/replace/btn_game_bg.png",0)
        self.btn_ddz:loadTextureDisabled("hall/newhall/replace/btn_game_bg.png",0)
    end

    -- 替换单包游戏按钮动画icon
    if Helper.IsFileExist("hall/newhall/replace/game_icon.png") then
        self.btn_ddz:getChildByName("img_ddz1"):loadTexture("hall/newhall/replace/game_icon.png", 0)
        self.btn_ddz:getChildByName("img_ddz1"):ignoreContentAdaptWithSize(true)
    end

    -- 替换单包游戏按钮游戏名
    if Helper.IsFileExist("hall/newhall/replace/game_name.png") then
        self.btn_ddz:getChildByName("img_ddz2"):loadTexture("hall/newhall/replace/game_name.png", 0)
    end
end

function M:runHallAni()
    self.animation = self.resourceNode_["animation"]
    self:runAction(self.animation)
    if self.animation then
        self.animation:play("btnani", true)
    end
end

function M:initSwitch()
      -- 不显示大厅内容
    if not GameApp:CheckModuleEnable(ModuleTag.Room) then
        self.nd_btns:setVisible(false)
    end
    -- 初始化先隐藏比赛,娱乐馆按钮
    self.btn_bs:setVisible(false)
    self.btn_ddz:setVisible(false)
    self.btn_ylg:setVisible(false)
end

function M:resetLayout()
    -- 适配
    self.nd_btns:setPosition(cc.p(gg.getPhoneRight(), display.cy))
    self.nd_btns:setScale(math.min( display.scaleX, display.scaleY))
    self.img_girl:setPosition(cc.p(display.cx - 175, 0))
    self.img_girl:setScale(math.min( display.scaleX, display.scaleY))

    --增加ipad适配
    if display.width / display.height == 4/3 then
        self.img_girl:setPosition(cc.p(display.cx - 130, 0))
    end
end

function M:initGirlAni()
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

------------------------------------
-- 重写方法
------------------------------------
-- 刷新界面按钮显示的方法，需要在各自界面重写已响应通知
function M:updateBtnsShow()
    if hallmanager then
        gg.GameCfgData:CheckLoaded(function()
            if tolua.isnull(self) then return end
            self.btn_ylg:setVisible(hallmanager:HasMiniGames())
        end)
    end
    -- 根据开关和斗地主游戏控制比赛按钮
    self.btn_ddz:setVisible(true)
    if self:haveDDZGame() then
        self.btn_bs:setVisible(GameApp:CanShowMatch())
    end
end

function M:enterGameAction()
    self.nd_btns:setVisible(false)
    if self._girleAni then
        self._girleAni:setVisible(false)
    else
        self.img_girl:setVisible(false)
    end
end

-- 更新完成隐藏并且重置进度
function M:onEventUpdateFinish(event, shortname, err)
    if "ddzh" == shortname then
        local node = self.btn_bs:getChildByName("download_bg")
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
        local progress = self.btn_bs:getChildByName("download_bg"):getChildByName("progress")
        self:setDownloadProgress(p, progress)
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

--抢红包
function M:onClickBs(sender)
    gg.AudioManager:playClickEffect()
    self:doJoinMatchRoom()
end

function M:doJoinMatchRoom()
    if not hallmanager or not hallmanager.games then return end
    local game = hallmanager:GetGameByShortName("ddzh")
    local isNeedUpdate, msg = hallmanager:CheckGameNeedUpdate(game)
    if isNeedUpdate then
        self._isHallDownload = true
        local node = self.btn_bs:getChildByName("download_bg")
        self:addProgress(node)
        node:setVisible(true)
        hallmanager:DoUpdateGame(game)
        return
    end

    self:joinMatchRoom()
end

function M:onClickDdz(sender)
    gg.AudioManager:playClickEffect()
    self:showGameListView("poker")
end

function M:onClickYlg(sender)
    gg.AudioManager:playClickEffect()
    self:showGameListView("xiuxian")
end

return M
