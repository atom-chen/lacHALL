local M = {}

--[[
    * 描述：创建粒子效果
    * 参数：plistPath数据文件路径
    * 参数：imagePath纹理图片路径
--]]
function M:create(plistPath, imagePath)
    assert(cc.FileUtils:getInstance():isFileExist(plistPath))
    assert(cc.FileUtils:getInstance():isFileExist(imagePath))

    local emitter = cc.ParticleSystemQuad:create(plistPath)
    emitter:setTexture(cc.Director:getInstance():getTextureCache():addImage(imagePath))
    return emitter
end

return M