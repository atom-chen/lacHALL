--[[
* 游戏加载器入口
]]
-- local M = {};
-- setmetatable(M,{__index=_G});
-- local modelName = ...;
-- _G[modelName] = M;
-- GameClient.env=M;
-- setfenv(1,M);
printf("---runGame file "..GameClient.mainfile)
if hallmanager and hallmanager.GetRoomManager and hallmanager:GetRoomManager() and hallmanager:GetRoomManager().resetMixedRoom then
    hallmanager:GetRoomManager():resetMixedRoom()
end

-- 尝试启动游戏客户端
local ok, ret = pcall(function( )
    dofile(GameClient.mainfile);
end)

if not ok then
    -- 游戏启动失败了，提示修复或者联系客服
    printf("--- do file %s failed", GameClient.mainfile)
    local shortname = GameClient.gameinfo.shortname
    GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG, "游戏未能正常启动，猛戳“修复”。", function(bttype)
        if bttype == gg.MessageDialog.EVENT_TYPE_OK then
            -- 弹出修复界面
            GameApp:dispatchEvent(gg.Event.SHOW_VIEW, "RepairGameView", {push = true}, shortname)
        elseif bttype == gg.MessageDialog.EVENT_TYPE_CANCEL then
            -- 联系客服
            device.doCallCustomerServiceApi("entergame")
        end
    end, { mode=gg.MessageDialog.MODE_OK_CANCEL_CLOSE, ok="修复", cancel="联系客服"})

    -- 断言失败，这样可以让后续流程正常执行
    assert(false, string.format("do file %s failed", GameClient.mainfile))
else
    printf("--- do file %s succeed", GameClient.mainfile)
end
