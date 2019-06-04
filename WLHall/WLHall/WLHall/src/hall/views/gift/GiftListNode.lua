

local GiftListNode = class("GiftListNode", cc.load("ViewLayout"))

GiftListNode.RESOURCE_FILENAME="ui/gift/giftListNode.lua"

GiftListNode.RESOURCE_BINDING =
{
    ["Panel_bg"]   = { ["varname"] = "Panel_bg"},

    ["txt_zh"]   = { ["varname"] = "txt_zh"},
    ["txt_mm"]   = { ["varname"] = "txt_mm"},

    ["btn_kh"]  = { ["varname"] = "btn_kh" , ["events"]={{event="click",method="onClickCopyZH"}} },
    ["btn_mm"]  = { ["varname"] = "btn_mm" , ["events"]={{event="click",method="onClickCopyMM"}} },
}

function GiftListNode:onCreate()
    self:init()
end

function GiftListNode:init()
    self.Panel_bg:retain()
    self.Panel_bg:removeFromParent( true )
    self:addChild(self.Panel_bg )
    self.Panel_bg:release()
end

function GiftListNode:setInfo(tabInfo)
    self.tabInfo = tabInfo
    self:initView()
end

function GiftListNode:initView()
    self.txt_zh:setString(self.tabInfo.zh)
    self.txt_mm:setString(self.tabInfo.mm)
end

function GiftListNode:onClickCopyZH(sender)
    gg.AudioManager:playClickEffect()
    Helper.CopyToClipboard(self.tabInfo.zh)
    GameApp:dispatchEvent(gg.Event.SHOW_TOAST,"已复制到剪切板")
end

function GiftListNode:onClickCopyMM(sender)
    gg.AudioManager:playClickEffect()
    Helper.CopyToClipboard(self.tabInfo.mm)
    GameApp:dispatchEvent(gg.Event.SHOW_TOAST,"已复制到剪切板")
end

function GiftListNode:getSize()
    return  self.Panel_bg:getContentSize()
end

return  GiftListNode;
