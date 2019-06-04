local Touch = require ("libs.ccex.Touch")

local M = class("HonorChangeView", cc.Layer)

--[[
    * 描述：荣誉值变化（升降段，升降星）动画展示
    * 参数：grade 段位
    * 参数：star 星级
--]]
function M:ctor(grade, star)
    assert(grade>=1 and grade <= 6)
    assert(star>=0 and star<=5)

    self:_init()
    self:_createInfo(grade, star)
end

--[[
    * 描述：升星动画
    * 参数：star 星级
    * 参数：callback 动画播放结束后回调
--]]
function M:playShengXingAni(star, callback)
    assert(star>=1 and star<=5)

    if gg.CanUseSpine() then
        local rootPath = "hall/honor/honor_ani/"
        local animationPath1 = rootPath.."shengxing.json" 
        local animationPath2 = rootPath.."shengxing.atlas"
        local ani = sp.SkeletonAnimation:create(animationPath1, animationPath2, 1)
        ani:position(self._stars[star]:getPos())    

        ani:registerSpineEventHandler(function (event)
            ani:setVisible(false)
            self._stars[star]:setSpriteFrame("hall/honor/star.png")
            if callback then
                callback()    
            end
        end, sp.EventType.ANIMATION_COMPLETE)

        --设置动画的名字
        ani:setAnimation(0, "animation", false)
        self._base:addChild(ani)
        gg.AudioManager:playEffect("common/audio/honor_star.mp3")
    else
        self._stars[star]:setSpriteFrame("hall/honor/star.png")
        if callback then
            callback()    
        end
    end
end

--[[
    * 描述：升段动画
    * 参数：grade 段位
    * 参数：callback 动画播放结束后回调
--]]
function M:playShengDuanAni(grade, callback)
    assert(grade>=1 and grade<=6)

    self._title:setSpriteFrame("hall/honor/shengduan.png")

    if gg.CanUseSpine() then
        local rootPath = "hall/honor/honor_ani/"
        local animationPath1 = rootPath.."shengduan.json" 
        local animationPath2 = rootPath.."shengduan.atlas"
        local ani = sp.SkeletonAnimation:create(animationPath1, animationPath2, 1)

        local size = self._trophy:getContentSize()
        local pos = cc.p(size.width/2, size.height/2)
        ani:position(pos)    

        ani:registerSpineEventHandler(function (event)
            local config = self:_getGradeConfig(grade)
            self._trophy:setSpriteFrame("hall/honor/grade_img_"..grade..".png")
            self._trophy:scale(config[2])
            self._name:setString(config[1])
            for i=1,5 do
                self._stars[i]:setSpriteFrame("hall/honor/starbg.png")
            end
            if callback then
                callback()    
            end
        end, sp.EventType.ANIMATION_COMPLETE)

        --设置动画的名字
        ani:setAnimation(0, "animation", false)
        self._trophy:addChild(ani)
        gg.AudioManager:playEffect("common/audio/honor_star.mp3")
    else
        local config = self:_getGradeConfig(grade)
        self._trophy:setSpriteFrame("hall/honor/grade_img_"..grade..".png")
        self._trophy:scale(config[2])
        self._name:setString(config[1])
        for i=1,5 do
            self._stars[i]:setSpriteFrame("hall/honor/starbg.png")
        end
        if callback then
            callback()    
        end
    end
end

--[[
    * 描述：显示分享按钮
    * 参数：clickFun 点击按钮回调
--]]
function M:showShareBtn(clickFun)
    assert(clickFun)

    local spriteFrame = cc.SpriteFrameCache:getInstance():getSpriteFrame("hall/honor/share.png")
    local shareBtn = Button:createWithSpriteFrame(spriteFrame)
        :addTo(self._base)
        :anchor(cc.p(0.5, 1))
        :layout(Layout.center_bottom, cc.p(0, -20))
    shareBtn.onClicked = function(bt)
        clickFun()
    end
end

function M:setCanClose(canClose)
    assert(canClose == false or canClose == true)
    self._canClose = canClose
end

--------------------------- 华丽分割线 ---------------------------

function M:_init()
    cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/cup.plist")
    cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/honor.plist")

    self._canClose = true
    Touch:registerTouchOneByOne(self, true)
    self:_createBg()
end

function M:setRemoveCallback(callback)
    self._callback = callback
end

function M:onTouchBegan()
    return true
end

function M:onTouchEnded()
    if self._canClose then
        if self._callback then
            self._callback()
        end
        self:removeFromParent()
    end
end

function M:onTouchCancelled()
    self:onTouchEnded()
end

function M:_createBg()
    -- 半透明背景
    cc.LayerColor:create(cc.c4b(0, 0, 0, 180))
        :addTo(self)
        :setContentSize(display)

    cc.Sprite:create("hall/honor/bg.png")
        :addTo(self)
        :anchor(cc.p(0.5, 0.5))
        :layout(Layout.center) 

    self._base = cc.Sprite:createWithSpriteFrameName("hall/honor/base.png")
        :addTo(self)
        :anchor(cc.p(0.5, 0.5))
        :layout(Layout.center, cc.p(0, -130)) 
        :scale(1.2)
end

function M:_createInfo(grade, star)
    local config = self:_getGradeConfig(grade)
    self._trophy = cc.Sprite:createWithSpriteFrameName("hall/honor/grade_img_"..grade..".png")
        :addTo(self)
        :anchor(cc.p(0.5, 0))
        :layout(Layout.center, cc.p(0, -125))
        :scale(config[2])

    self._name = cc.Label:create()
    	:addTo(self._base)
    	:layout(Layout.center, cc.p(0, -25))
    	:setColor(cc.c3b(176,1,1))
        :setString(config[1])
        :setSystemFontSize(30)

    self._title = cc.Sprite:createWithSpriteFrameName("hall/honor/shengxing.png")
        :addTo(self._base)
        :anchor(cc.p(0.5, 0))
        :layout(Layout.center, cc.p(0, 320))

    self._stars = {}
    local layouts = {
    	cc.p(-130, 210),
    	cc.p(-68, 246),
    	cc.p(  0, 270),
    	cc.p( 70, 245),
    	cc.p( 130, 210),
	}
    for i=1,5 do
    	local imagePath = "hall/honor/"
    	imagePath = i <= star and imagePath.."star.png" or imagePath.."starbg.png"
    	local star = cc.Sprite:createWithSpriteFrameName(imagePath)
    		:addTo(self._base)
        	:anchor(cc.p(0.5, 0.5))
        	:layout(Layout.center, layouts[i])
       table.insert(self._stars, star)
    end
end

function M:_getGradeConfig(grade)
    local config = {
        {"新手", 1.4},
        {"初段", 1.3},
        {"中段", 1.2},
        {"高段", 1.2},
        {"专家", 1.15},
        {"大师", 1.05},
    }
	return config[grade]
end

return M