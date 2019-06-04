--[[
    * 描述：通过Flash文件生成Sprite
    * 优点：资源文件小、跨平台、矢量图片
--]]
local M = class("libs.flash.FlashSprite", function()
    return cc.Sprite:create()
end)

--[[
    * 描述：通过Flash文件创建Sprite
    * 参数binName："DIR/BinName:StateName"，":"号前为文件路径不包含后缀，符号后为状态名，如："flash/logo:jiemian"
    * 参数configTable：{scale=1.0, format=0, save=true}
        scale：缩放比例
        format：0=RGBA8888, 1=RGBA4444
        save：true=缓存，false=不缓存
--]]
function M:ctor(binName, configTable)
    local spriteFrame = fla.ex.getSpriteFrame(binName, configTable)
    self:setSpriteFrame(spriteFrame)
end

return M