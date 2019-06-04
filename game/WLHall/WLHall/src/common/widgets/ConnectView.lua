-- Author:lee
-- Date: 2017-04-27 13:19:50 
local ConnectView = class("ConnectView", cc.load("ViewBase"))
ConnectView.RESOURCE_FILENAME = "ui/common/break_tip.lua"
ConnectView.RESOURCE_BINDING = { 
    ["bg_root"]   = { ["varname"] = "bg_root" },
    ["txt_tips"]   = { ["varname"] = "txt_tips" },
}

function ConnectView:onCreate(timeoutcallback,timeout,...)
	gg.HandleTouchBeginEvent(self,true,function() printf("ConnectView on touch swallow") end)
    self.bg_root:setPosition(cc.p(display.size.width/2,display.size.height*3/5))        
    self:runFrameAnimation(1) 
    self.timeoutcallback_=timeoutcallback
    self:startTimer_(timeout)
end

function ConnectView:startTimer_(timeout) 
  	if self.timer_ then
        self.timer_:killAll()
    else
        local Timer = require("common.utils.Timer")
        self.timer_ = Timer.new()
    end
    self.timer_:addCountdown(handler(self,self.updateCountdown_), timeout or CONNECT_TIMEOUT, 1)   
end 

function ConnectView:updateCountdown_(cusor, dt, data, timerId)
    if cusor<=0 then
    	if self.timeoutcallback_ then self.timeoutcallback_() end
    else
    	self.txt_tips:setString(string.format("正在尝试重连%02d...",cusor))   	
    end
end

function ConnectView:onCleanup()
	self.timeoutcallback_=nil
	if self.timer_ then
        self.timer_:killAll()
    end
end
--吞噬返回键
function ConnectView:keyBackClicked()
	printf("ConnectView key back disabled ")
	return false, false
end

return ConnectView