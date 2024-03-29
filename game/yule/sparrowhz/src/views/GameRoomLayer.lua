--
-- Author: zhong
-- Date: 2016-10-12 15:22:32
--
local RoomLayerModel = appdf.req(appdf.CLIENT_SRC.."gamemodel.GameRoomLayerModel")
local GameRoomLayer = class("GameRoomLayer", RoomLayerModel)

--获取桌子参数(背景、椅子布局)
function GameRoomLayer:getTableParam(frameEngine)
    local table_bg = cc.Sprite:create("game/yule/sparrowhz/res/roomlist/roomtable.png")

    if nil ~= table_bg then
        local bgSize = table_bg:getContentSize()
        --桌号背景
        display.newSprite("Room/bg_tablenum.png")
            :addTo(table_bg)
            :move(bgSize.width * 0.5,10)
        ccui.Text:create("", appdf.FONT_FILE, 16)
            :addTo(table_bg)
            :setColor(cc.c4b(255,193,200,255))
            :setTag(1)
            :move(bgSize.width * 0.5,12)
        --状态
        display.newSprite("Room/flag_waitstatus.png")
            :addTo(table_bg)
            :setTag(2)
            :move(bgSize.width * 0.5,98)
    end    

    local chairCount = frameEngine:GetChairCount()
    local tabPos = {}
    if chairCount == 2 then
        tabPos = {cc.p(107,246), cc.p(107,-56)}
    elseif chairCount == 3 then
        tabPos = {cc.p(-50,100), cc.p(266,100), cc.p(107,-56)}
    elseif chairCount == 4 then
        tabPos = {cc.p(-50,100), cc.p(107,246), cc.p(266,100), cc.p(107,-56)}
    end
    
    return table_bg, tabPos
end

return GameRoomLayer