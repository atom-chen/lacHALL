local SharePrompt = class("SharePrompt", cc.load("ViewPop"))

SharePrompt.RESOURCE_FILENAME = "ui/luckybag/share_prompt.lua"

SharePrompt.RESOURCE_BINDING = {
    ["txt_title"] = { ["varname"] = "txt_title" },
    ["txt_award"] = { ["varname"] = "txt_award" },
    ["Text_3"]    = { ["varname"] = "Text_3" },         -- 每日限一次的提示字符串
    ["btn_close"] = { ["varname"] = "btn_close",   ["events"] = { { event = "click", method = "onClickClose"  } } }, -- 关闭按钮
    ["share_0"]   = { ["varname"] = "btn_share_0", ["events"] = { { event = "click", method = "onClickShare0" } } }, -- 分享好友按钮
    ["share_1"]   = { ["varname"] = "btn_share_1", ["events"] = { { event = "click", method = "onClickShare1" } } }, -- 分享朋友圈按钮
}

function SharePrompt:ctor(app, name, shareCallback)
    self.shareCallback = shareCallback
    SharePrompt.super.ctor(self, app, name)
end

function SharePrompt:setAwardCount( count )
    count = checkint(count)
    if count>0 then
        self.txt_title:setString( string.format("分享到朋友圈获赠%d豆", count) )
        self.txt_award:setString( string.format("赠%d豆", count) )
    else
        self.txt_title:setString( "分享-邀请好友")
        self.txt_award:setVisible(false)
        self.Text_3:setVisible(false)
    end
end

function SharePrompt:onClickClose()
    self:removeSelf()
end

function SharePrompt:onClickShare0()
    self.shareCallback(0)
    self:removeSelf()
end

function SharePrompt:onClickShare1()
    self.shareCallback(1)
    self:removeSelf()
end

return SharePrompt
