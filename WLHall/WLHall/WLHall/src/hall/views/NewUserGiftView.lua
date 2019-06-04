
-- Author: Star
-- Date: 2018-03-16 9:45:20
-- Describe：迎新红包界面

local NewUserGiftView = class("NewUserGiftView", cc.load("ViewPop"))

NewUserGiftView.RESOURCE_FILENAME="ui/store/newuser_gift_view.lua"

NewUserGiftView.RESOURCE_BINDING = {
    ["panel"]         = { ["varname"] = "panel" },              -- 父节点
    ["not_open"]      = { ["varname"] = "not_open"},            -- 未翻转红包
    ["open"]          = { ["varname"] = "open"},                -- 翻转后红包
    ["img_normal"]    = { ["varname"] = "img_normal"},          -- 未翻开红包口
    ["img_open"]      = { ["varname"] = "img_open"},            -- 翻开红包口
    ["txt_tixian"]    = { ["varname"] = "txt_tixian"},          -- 提现文本
    ["hb_content"]    = { ["varname"] = "hb_content"},          -- 红包内券
    ["txt_money"]     = { ["varname"] = "txt_money"},           -- 金额
    ["txt_yuan"]      = { ["varname"] = "txt_yuan"},            -- 元
    -- ["txt_prop"]      = { ["varname"] = "txt_prop"},         -- 道具信息
    ["btn_kai"]       = { ["varname"] = "btn_kai",  ["events"] = { { event = "click", method = "onClickOpen" } } },  -- 开红包按钮
    ["btn_lingqu"]    = { ["varname"] = "btn_lingqu",  ["events"] = { { event = "click", method = "onClickCollection" } } }, -- 领取按钮
}

local TXT_MONEY_COLOR = {r = 210, g = 56, b = 51}

function NewUserGiftView:onCreate()
    -- 初始化
    self:init()

    -- 初始化View
    self:initView()
end

function NewUserGiftView:init()
    self._propDef = gg.GetPropList()
end

--[[
* @brief 初始化View
]]
function NewUserGiftView:initView()
    --开启事件
    self:enableNodeEvents()

    self.animation = self.resourceNode_["animation"]
    self:runAction(self.animation)

    self.txt_yuan:setColor(TXT_MONEY_COLOR)
    self.txt_money:setColor(TXT_MONEY_COLOR)
end

-- 显示动画节点并播放动画
function NewUserGiftView:playEnterAni()
    if self.animation then
        self.animation:play("animation", false)
    end
end

--[[
* @brief 设置数据完后播放动画
]]
function NewUserGiftView:setPropData(data)
    self:setMoney(data)
    --设置完数据后，1秒后开始播放翻转动画
    gg.CallAfter(0.1, handler(self, self.onActionBegin))
end

--[[
* @brief 设置红包数据
]]
function NewUserGiftView:setMoney(num)
    local str = string.format("%0.2f", num) --保留2位小数
    self.txt_money:setString(str)
end

--[[
* @brief 打开按钮回调
]]
function NewUserGiftView:onClickOpen(sender)
    -- 播放点击音效
    gg.AudioManager:playClickEffect()

    gg.Dapi:OpenNewUserGift(function( data )
        -- dump(data,"红包数据返回")
        if tolua.isnull(self) then return end
        if self._gotResult then
            -- 已经有一次结果了，直接返回
            return
        end

        self._gotResult = true
        if checkint(data.status) == 0 then
            local value  = checkint(checktable(data.red_val)[PROP_ID_261])
            local v = value * (self._propDef[PROP_ID_261].proportion or 1)
            self:setPropData(v)
        else
            self:goToNextScene()
            -- 发送提示
            if checkstring(data.msg) ~= "" then
                GameApp:dispatchEvent( gg.Event.SHOW_TOAST, data.msg)
            end
        end
    end )
end

--[[
* @brief 领取按钮
]]
function NewUserGiftView:onClickCollection()
    -- 播放点击音效
    gg.AudioManager:playClickEffect()

    if self._clickOnce then
        -- 已经领取过一次，直接返回
        return
    end
    self._clickOnce = true
    self:playAwardAction()
end

---------------------动画 and 粒子效果 begin --------------------------
--[[
* @brief 开始执行动画
]]
function NewUserGiftView:onActionBegin()
    self:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),cc.CallFunc:create(function()
        self:turn(self.open,self.not_open)
    end)))
end

--[[
* @brief 翻转红包动画
]]
function NewUserGiftView:turn(nodeBg,nodeFg)
    local time = 0.1

    --cocos2d::DisplayLinkDirector::Projection::_2D
    cc.Director:getInstance():setProjection(cc.DIRECTOR_PROJECTION2_D)
    --开始角度设置为0，旋转90度
    nodeFg:runAction(cc.Sequence:create(cc.OrbitCamera:create(time,1,0,0,90,0,0),cc.Hide:create(),cc.CallFunc:create(
        function()
            --开始角度是270，旋转90度
            nodeBg:runAction(cc.Sequence:create(cc.Show:create(),cc.OrbitCamera:create(time,1,0,270,90,0,0)
            ,cc.CallFunc:create(
                function()
                    self:turnUp(self.img_normal,self.img_open)
                    self:actionMoveTo(self.hb_content)
                    cc.Director:getInstance():setProjection(cc.DIRECTOR_PROJECTION3_D)
                end
            )))
        end
    )))
end

--[[
* @brief 翻开红包口动画
]]
function NewUserGiftView:turnUp(nodeBg,nodeFg)
    nodeBg:runAction(cc.Sequence:create(cc.DelayTime:create(0.2)
       ,cc.ScaleTo:create(-1,1)
       ,cc.Hide:create()
       ,cc.CallFunc:create(
        function()
             nodeFg:runAction(cc.Sequence:create(cc.Show:create()
                ,cc.ScaleTo:create(-1,1)))
        end))
    )
    nodeFg:setFlippedX(true)
end

--[[
* @brief 内券淡出
]]
function NewUserGiftView:actionMoveTo(node)
    local pos_x = 0 --node:getPositionX()
    local pos_y = node:getPositionY()
    node:runAction(cc.Sequence:create(cc.DelayTime:create(0.35) ,cc.MoveBy:create(0.2,cc.p(pos_x,pos_y*1.85)),cc.CallFunc:create(
        function()
             self.txt_tixian:setVisible(true)
             self.btn_lingqu:setVisible(true)
        end))
    )
end

--[[
* @brief 播放粒子效果(金币飘落)
]]
function NewUserGiftView:playAwardAction()
    local node = self.panel
    local ActionNode = cc.Node:create()
        :addTo(node)
        :layout(Layout.center,cc.p(0,0))

    --------------------------- 粒子特效 ---------------------
    --彩带
    for i=1,8 do
        local emitter1 = Particle:create("res/hall/newUserGift/particle_texture.plist", "res/hall/newUserGift/particle_texture0"..i..".png")
        emitter1:setAutoRemoveOnFinish(true)    --设置播放完毕之后自动释放内存
        emitter1:setPosition(cc.p(0, 80))
        ActionNode:addChild(emitter1,1020)
    end
    -- 豆子掉落
    Action:newDelayCallfun(0.2,function()
        local emitter2 = cc.ParticleSystemQuad:create("res/hall/newUserGift/Particle_diaodoudou.plist")
        emitter2:setAutoRemoveOnFinish(true)    --设置播放完毕之后自动释放内存
        emitter2:setPosition(cc.p(0, display.height / 2))
        ActionNode:addChild(emitter2)
        gg.AudioManager:playEffect("res/common/audio/gold_move.mp3")
    end)
    -- 豆子弹起
    Action:newDelayCallfun(0.6, function()
        local emitter3 = cc.ParticleSystemQuad:create("res/hall/newUserGift/Particle_shengdoudou.plist")
        emitter3:setAutoRemoveOnFinish(true)    --设置播放完毕之后自动释放内存
        emitter3:setPosition(cc.p(0, -300))
        ActionNode:addChild(emitter3, 510)
    end)
    --------------------------- Lua 播放粒子特效应用 ---------------------

    -- 动画完成后移除界面
    gg.CallAfter(3, handler(self, self.onActionFinished))
end
---------------------动画 and 粒子效果 end --------------------------
--[[
* @brief 跳转界面(活动界面)
]]
function NewUserGiftView:goToNextScene()
    if not IS_REVIEW_MODE then
        -- 非审核模式，显示活动界面
        local pageData = {first_but_tag = 1, second_but_tag = gg.ActivityPageData.ACTIVE_TAG_XSLB}
        local actView = self:getScene():createView("active.ActivityView", pageData)
        actView:pushInScene()
        -- 弹出活动界面是该界面已经关闭，先记录下回调行数
        local callback = self._callback
        actView:addRemoveListener(function()
            if callback then callback() end
        end)
    end
    self:removeSelf()
end

function NewUserGiftView:setPopViewCallback(callback)
    self._callback = callback
end

--[[
* @brief 动画播放完成回调
]]
function NewUserGiftView:onActionFinished()
    -- 动画完成之后跳转活动界面并提示领取成功
    self:goToNextScene()
    gg.InvokeFuncNextFrame(function()
        -- 发送提示
        GameApp:dispatchEvent( gg.Event.SHOW_TOAST, "领取成功！")
    end)
end

function NewUserGiftView:keyBackClicked()
    return false, false
end

return NewUserGiftView
