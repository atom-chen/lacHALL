local SceneBase=require("common.SceneBase")
local LaunchScene= class("LaunchScene", SceneBase)

function LaunchScene:ctor(name,...)
	name = name or LaunchScene.__cname
	LaunchScene.super.ctor(self,name,...)
end

function LaunchScene:onRun()

end

function LaunchScene:initUpdateView()
	if not self.updateView_ then
		self.updateView_=require("update.UpdateView").new(self, "UpdateView",function() end):pushInScene()
	end
end

function LaunchScene:showInitLoading()
	self:initUpdateView()
	self.updateView_:initLoadingTxt()
end

function LaunchScene:onEnter()
	self:addEventListener("event_show_update_loading",handler(self, self.onEventShowUpdate_))
    -- 设置 launch scene 的帧率
    cc.Director:getInstance():setAnimationInterval(1 / 30)
end

function LaunchScene:onNetworkChanged_(event) end

--显示更新界面
function LaunchScene:onEventShowUpdate_(event)
	self:initUpdateView()
    self.updateView_:initLoadingWidget()

    -- 需要更新的时候，就需要把登录界面去掉，避免表现异常的问题
    local loginView = self:getChildByName("LoginView")
    if loginView then
        loginView:removeFromParent()
    end
end

function LaunchScene:onCleanup()
	self.updateView_=nil
end

return LaunchScene