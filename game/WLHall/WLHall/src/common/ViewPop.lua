local ViewPop = class("ViewPop", cc.load("ViewBase"))
function ViewPop.getType()
    return ViewPop.__cname
end
-- 创建弹出层 
function ViewPop:ctor(app, name, ...)
    ViewPop.super.ctor(self, app, name, ...)
    self.setTouchOutsideClose_ = nil
    self:initTouchEvent() 
    local closeani = rawget(self.class, "CLOSE_ANIMATION")   
    local animode = rawget(self.class, "ANIMATION_MODE")   --ANIMATION_MODE  0 左右动画  1,上下动画
    local addblurbg = rawget(self.class, "ADD_BLUR_BG")     -- 添加虚化背景
    local layeralpha = rawget(self.class, "LAYER_ALPHA")
    self._alpha = layeralpha or 76
    self.animode_=animode     
    self:initPopView(closeani, animode, addblurbg)
end

--区域外点击关闭
function ViewPop:setTouchOutsideClose(bclose)
    self.setTouchOutsideClose_ = bclose
    return self
end

function ViewPop:initTouchEvent()
    local listener = cc.EventListenerTouchOneByOne:create();
    listener:setSwallowTouches(true)
    local onTouchBegin = function(...)
        -- printf(" ViewPop onTouchBegin 事件 已处理")
        if self.setTouchOutsideClose_ then
            self:removeSelf()
        end
        return true
    end
    listener:registerScriptHandler(onTouchBegin, cc.Handler.EVENT_TOUCH_BEGAN);
    local eventDispatcher = self:getEventDispatcher() -- 得到事件派发器
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self) -- 将监听器注册到派发器中
end

function ViewPop:initPopView(closeani, animode, addblurbg)
    local winSize = cc.Director:getInstance():getVisibleSize()
    -- 2018-06-22 仅在大厅场景添加虚化背景图
    local curScene = GameApp:getRunningScene()
    if addblurbg and curScene.name_ == "HallScene" then
        self:createBlurBg(winSize)
    else
        self.bg_ = display.newLayer(cc.c4b(1, 14, 30, self._alpha))
        self:addChild(self.bg_, -1)
    end

    if self.resourceNode_ then
        self:getRootNode():setPosition(winSize.width / 2, winSize.height / 2)
    end    
    if not closeani then
        self:showPop(animode)
    end
end

function ViewPop:createBlurBg(winSize)
    local blurBg = cc.Sprite:create("res/hall/newhall/img_hall_blur_bg.jpg")
    if blurBg then
        blurBg:setScaleY(winSize.height / blurBg:getContentSize().height)
        blurBg:setPosition(cc.p(winSize.width / 2, winSize.height / 2))
        self.bg_ = blurBg
        self:addChild(self.bg_, -1)
    else
        self.bg_ = display.newLayer(cc.c4b(1, 14, 30, self._alpha))
        self:addChild(self.bg_, -1)
    end
end

function ViewPop:onEnter() 
end

function ViewPop:setScale(scale)
    self:getRootNode():setScale(scale)
end

function ViewPop:getScale()
    if self.resourceNode_ then
        return self:getRootNode():getScale()
    end
    return 1
end

function ViewPop:showPop(animode)
    animode= checkint(animode)
    local root = self:getRootNode()
    local scale = root:getScale()  
    root:setScale(0.82*scale)
    root:setCascadeOpacityEnabled(true)
    root:setOpacity(0)
    local seq1 = cc.Sequence:create(cc.FadeIn:create(0.09));
    local seq2 =  cc.Sequence:create(cc.ScaleTo:create(0.1, scale, scale), cc.DelayTime:create( 0.05),cc.CallFunc:create(handler(self, self.aniEnd)))
    local spawnaction = cc.Spawn:create(seq1, seq2); 
    root:runAction(spawnaction)
    -- self:setCascadeOpacityEnabled(true)
    -- self:setOpacity(0)
    -- self:runAction(cc.FadeIn:create(0.08))
    -- root:runAction(cc.Sequence:create(cc.EaseBackOut:create(cc.ScaleTo:create(0.1, scale, scale)), cc.CallFunc:create(handler(self, self.aniEnd))))
end

function ViewPop:aniEnd()
    self:onLoadView( )
end

-- 进入动画结束后调用该函数,处理页面进入卡顿时可以重写此函数
function ViewPop:onLoadView( ... )
end

function ViewPop:keyBackClicked()
    -- self:hidePop_()
    self:removeSelf()
    return true, true
end
--需要相应返回键窗口需要调用postkeyBackClicked 函数关闭
function ViewPop:hidePop_()    
     local aniEnd = function()
         if not tolua.isnull(self) then
             self:removeFromParent()
         end
     end
    local root = self:getRootNode()
    local scale = root:getScale()*0.9  
    -- local seq1 = cc.Sequence:create(cc.FadeOut:create( 0.13 ));
    local seq2 =cc.Sequence:create(cc.ScaleTo:create(0.05, scale, scale),cc.DelayTime:create( 0.05), cc.CallFunc:create(aniEnd)) 
    root:runAction(cc.Spawn:create( seq2))
  -- --  self:getRootNode():runAction(cc.Sequence:create(cc.EaseBackIn:create(cc.ScaleTo:create(0.15, 0.4, 0.4)), cc.CallFunc:create(aniEnd)))
 
end

-- -- 创建屏幕截图虚化精灵
-- function ViewPop:createBlurSprite()
--     local win_size = cc.Director:getInstance():getVisibleSize() 
--     local sprite_photo= self:captureNode(display.getRunningScene())
--             :addTo(self,-1)
--             :move(display.cx, display.cy)
--     --强制渲染
--     -- sprite_photo:visit()
--     --模糊处理
--     local size = sprite_photo:getTexture():getContentSizeInPixels()

--     local program = cc.GLProgram:createWithFilenames("shaders/example_Simple.vsh","shaders/blur.fsh")

--     local gl_program_state = cc.GLProgramState:getOrCreateWithGLProgram(program)

--     sprite_photo:setGLProgramState(gl_program_state)
--     --设置模糊参数
--     sprite_photo:getGLProgramState():setUniformVec2("resolution", cc.p(size.width, size.height)) --分辨率
--     sprite_photo:getGLProgramState():setUniformFloat("blurRadius", 16)  --半径
--     sprite_photo:getGLProgramState():setUniformFloat("sampleNum", 8)    --段数    

--     local blureSprite= self:captureNode(sprite_photo)
--     self:removeChild(sprite_photo)    
--     return blureSprite

-- end

-- function ViewPop:captureNode(node) 
--    return gg.CaptureNode(node)
-- end


-- function ViewPop:showBlurBg_()
--     self:createBlurSprite()
--                 :addTo(self,-1)
--                 :move(display.cx, display.cy)
--                 :opacity(0)
--                 :runAction(cc.FadeIn:create(0.2))
--     self:addChild(display.newLayer(cc.c4b(0,0,0,180)),-1)
--  end
--截图虚化异步处理方法
-- function ViewPop:enableBlurBk()
--     local function afterCaptured(succeed, outputFile)
--         if succeed and self.showBlurBk then
--             self:showBlurBk(outputFile)
--         end
--         cc.Director:getInstance():getTextureCache():removeTextureForKey(outputFile)
--       end
--     cc.utils:captureScreen(afterCaptured, "test.png")
-- end

-- function ViewPop:showBlurBk(outputFile)
--     self.spriteBlur = cc.Sprite:create(outputFile)
--     local winSize = cc.Director:getInstance():getVisibleSize()
--     self:addChild(self.spriteBlur,-100)
--     local properties = cc.Properties:createNonRefCounted("Materials/2d_effects.material#sample")
--     local mat1 = cc.Material:createWithProperties(properties)
--     self.spriteBlur:setNormalizedPosition(cc.p(0.1, 0.1))
--     self.spriteBlur:setGLProgramState(mat1:getTechniqueByName("blur"):getPassByIndex(1):getGLProgramState())

--     self.spriteBlur:setPosition(winSize.width / 2, winSize.height / 2)
--     self.spriteBlur:setScale(1024/self.spriteBlur:getContentSize().width)
--     self.spriteBlur:setOpacity(0)
--     --spriteBlur:runAction(cc.FadeTo:create(1,240))
--     self.spriteBlur:runAction(cc.FadeIn:create(0.2))
-- end

return ViewPop
