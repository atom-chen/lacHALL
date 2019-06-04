--
-- Author: zhangbin
-- Date: 2017-05-25
-- Describe：规则界面中游戏列表中的游戏按钮
local ItemRuleGame = class("ItemRuleGame", cc.load("ViewLayout"))

ItemRuleGame.RESOURCE_FILENAME = "ui/common/rule_game_item.lua"
ItemRuleGame.RESOURCE_BINDING = {
	["label_game"] = {["varname"] = "label_game"},
    ["img_sep"]    = {["varname"] = "img_sep"},
    ["game_icon"]    = {["varname"] = "game_icon"},
    ["img_sel"] = {["varname"] = "img_sel"},
	["btn_container"] = {["varname"] = "btn_container"},
}

function ItemRuleGame:onCreate( gameInfo, showSep, clickCallback )
    -- 这里将 btn_container 的上级 node 从节点树移除
    -- 是为了解决游戏列表中无法在按钮区域进行拖拽的问题
    local curRoot = self.resourceNode_.root
    curRoot:removeChild(self.btn_container)
    self:removeChild(curRoot)
    self:addChild(self.btn_container)
    self.resourceNode_ = self.btn_container
    self:setContentSize(274,92)
    self.btn_container:onClick(handler(self, self.onClick))

    local info = checktable(gameInfo)
    self.label_game:setString(info.name or "")
    self.gameId = info.id
    self.callback = clickCallback
    self:setSelected(false)
    self.img_sep:setVisible(showSep)

    --拉去游戏icon
    if hallmanager and hallmanager.games then
        local game = hallmanager.games[self.gameId]
        if game then
           local url = APP_ICON_PATH..game.shell..".png"
            printf("拉取游戏图标 url :".. url )

            if url then
                gg.ImageDownload:LoadHttpImageAsyn( url , self.game_icon )
            end
        end
    end
end

function ItemRuleGame:setSelected(value)
    if self.selected == value then
        return
    end

    self.selected = value
    if self.selected then
		self.img_sep:setVisible(false)
		self.img_sel:setVisible(true)
        self.label_game:setTextColor({r = 119, g = 51, b = 51})
    else
		self.img_sep:setVisible(true)
		self.img_sel:setVisible(false)
        self.label_game:setTextColor({r = 255, g = 255, b = 255})
    end

    if self.selected and self.callback then
        self.callback(self.gameId)
    end
end

function ItemRuleGame:onClick()
	-- 播放点击音效
    gg.AudioManager:playClickEffect()
    self:setSelected(true)
end

return ItemRuleGame
