--
-- Author: zhangbin
-- Date: 2018-08-14
-- Describe：游戏修复界面

local RepairGameView = class("RepairGameView", cc.load("ViewPop"))

RepairGameView.CLOSE_ANIMATION = true
RepairGameView.LAYER_ALPHA = 25
RepairGameView.RESOURCE_FILENAME = "ui/common/repair_game.lua"
RepairGameView.RESOURCE_BINDING = {
	["imgLight"]     = { ["varname"] = "imgLight" },
    ["txtTip"]     = { ["varname"] = "txtTip" },
	["btnClose"]  = { ["varname"] = "btnClose", ["events"] = { { ["event"] = "click", ["method"] = "onClickClose" } } },
}

function RepairGameView:onCreate(shortname)
    self._shortname = shortname

    -- 初始化界面
    self:initView()

    -- 注册事件
    self:registerEvents()

    -- 进行修复
    self:doRepair()
end

function RepairGameView:initView( )
    -- 分辨率适配
    self.btnClose:setPosition(display.width / 2 - 40, display.height / 2 - 40)

    -- 开始动画
    self.imgLight:setOpacity(146)
    local act1 = cc.FadeTo:create(1, 255)
    local act2 = cc.FadeTo:create(1, 146)
    self.imgLight:runAction(cc.RepeatForever:create(cc.Sequence:create(act1, act2)))
end

function RepairGameView:registerEvents()
    -- 更新完成
    GameApp:addEventListener("event_game_update_finish", handler(self,self.onEventUpdateFinish), self)
    -- 更新进度
    GameApp:addEventListener("event_game_update_progress_changed", handler(self, self.onEventUpdateChanged), self)
end

function RepairGameView:doRepair( )
    -- 删除旧的资源
    gg.ClearGameRequire(self._shortname)
    local fpath = Helper.writepath.."games/"..self._shortname
    Helper.DeleteFile(fpath)

    -- 重新下载游戏
    if hallmanager then
        hallmanager:DoUpdateGame(self._shortname)
    end
end

-- 更新完成
function RepairGameView:onEventUpdateFinish(event, shortname, error_)
    if self._shortname == shortname then
        -- 停止动画并关闭界面
        self.imgLight:stopAllActions()
        self:removeSelf()

        -- 弹出 toast 提示
        local tipMsg
        if error_ then
            tipMsg = "游戏下载失败，请稍候重试"
        else
            tipMsg = "修复完成！"
        end
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "修复完成！")
    end
end

-- 更新进度
function RepairGameView:onEventUpdateChanged(event, p, shortname)
    if self._shortname == shortname then
        self.txtTip:setString(string.format("修复中...%d%%", p % 100))
    end
end

function RepairGameView:onClickClose()
    self:removeSelf()
end

return RepairGameView
