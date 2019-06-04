local M = {}

--[[
    * 描述：创建使用图片文字的Label
    * 参数：string显示的文字
    * 参数：charMapFile图片文件路径
    * 参数：startCharMap从哪个数字开始算起
    * 参数：图片总共几个数字
    数字顺序：! " # $ % & ' ( ) * + , - . / 
            0 1 2 3 4 5 6 7 8 9 : ; < = >
            @ A B C D E F ....

    备注：此接口不适合数字有换行
--]]
function M:create(string, charMapFile, startCharMap, numberCount)
    local texture = cc.Director:getInstance():getTextureCache():addImage(charMapFile)
    assert(texture, string.format("错误：找不到资源图片%s", charMapFile))
    local size = texture:getContentSize()
    return cc.LabelAtlas:_create(string, charMapFile, size.width/numberCount, size.height, string.byte(startCharMap))
            :anchor(cc.p(0.5, 0.5))
end


return M