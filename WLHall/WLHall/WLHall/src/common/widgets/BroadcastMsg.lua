
-- Author: zhaoxinyu
-- Date: 2016-09-03 17:26:39
-- Describe：消息层

local MSG_TYPE={

    NONE=0, --!<不附带任何内容,纯文本
    P2P=0x1,--!<玩家跟玩家
    SYS=0x2,--!<系统消息
    FACTION2P=0x4,--!<门派内部聊天
    FACTION=0x8,--<门派系统消息
    GM2P=0x10,--<GM跟玩家
    SPEAKER=0x20,--!<小喇叭
    ROSE=0x40,--!<玫瑰花
    PROP=0x80,--!<道具
    HALL=0x100,--!<大厅消息
    CMD=0x200,--!<消息为命令
    GIFT=0x400,--!<奖励（喜报）
    SAVE2DB=0x80000000,--!<是否保存（保存到数据库)
}

local PREDEF_MSG_FMT = {
    [1] = {argCount = 1, fmt = { "福星高照，尊贵现身，星耀特权玩家【${n}】已上线，快来瞻仰吧！",
                                 "天雷一声响，福到运气到，祝星耀特权玩家【${n}】好运连连！",
                                 "星耀特权玩家【${n}】降临，祝您大吉大利，手气长虹~",}}
}

local MSG_TYPE_CONTENT ={

    [0]="",
    [0x1]="[玩家]",
    [0x2]="[系统消息]",
    [0x4]="[门派]",
    [0x8]="[门派系统]",
    [0x10]="[GM]",
    [0x20]="[小喇叭]",
    [0x40]="[玫瑰花]",
    [0x80]="[道具]",
    [0x100]="[大厅消息]",
    [0x200]="[消息]",
    [0x400]="[奖励]",
    [0X80000000]="[保存]",
}

local MARGIN = 30

-- local receivedSysMsgTag = false -- 收到系统消息标识

local BroadcastMsg = class("BroadcastMsg", cc.load("ViewBase"))

BroadcastMsg.RESOURCE_FILENAME = "ui/hall/message_node.lua"

BroadcastMsg.RESOURCE_BINDING = {
    ["panel_message"]   = { ["varname"] = "panel_message" },                                                                            -- 滚动层
    ["img_bg"]   = { ["varname"] = "img_bg"  },                                                                                         -- 背景
}

function BroadcastMsg:onCreate( ... )
    self.img_bg:setContentSize(cc.size(display.width, self.img_bg:getContentSize().height))
    self.panel_message:setContentSize(cc.size(display.width, self.panel_message:getContentSize().height))

    -- 初始化
    self:init()
end

function BroadcastMsg:init()
    self._messageList = {}          -- 消息队列
    self._seed = 200                -- 滚动速率
    self._scheduler = nil
    self._schedulerEntry = nil
end

--[[
* @brief 添加消息
* @param [in] msg 文本
* @param [in] msgtype 文本类型
]]
function BroadcastMsg:recordMsg( msg , msgtype )
    if not msg or msg == "" then
        return
    end

    -- 插入等待队列
    local msgT = {}
    if MSG_TYPE.CMD == checkint(msgtype) then
        msgT["m"] = self:genCMDMsg(msg)
    else
        msgT["m"] = msg
    end
    msgT["t"] = msgtype
    table.insert( self._messageList , msgT  )
end

-- 生成 cmd 类型的消息字符串
function BroadcastMsg:genCMDMsg(msg)
    local params = string.split(msg, "&")
    if #params <= 1 then
        -- 没有参数，直接返回
        return msg
    end

    local id = checkint(params[1])
    if id == 0 then
        -- 错误的消息 id
        return msg
    end

    local fmtInfo = PREDEF_MSG_FMT[id]
    local needCount = fmtInfo.argCount + 1
    if not fmtInfo  or #params < needCount then
        -- 没有预定义配置信息，或者参数不匹配
        return msg
    end

    -- 解析参数
    local useParams = {}
    for i=2, needCount do
        local paramStr = params[i]
        if i == needCount and #params > needCount then
            local lastParam = ""
            for j=needCount, #params do
                lastParam = lastParam..params[j]
                if j ~= #params then
                    lastParam = lastParam.."&"
                end
            end
            paramStr = lastParam
        end

        local tempIdx = string.find(paramStr, "=")
        if tempIdx then
            local key = string.lower(string.sub(paramStr, 1, tempIdx - 1))
            useParams[key] = string.sub(paramStr, tempIdx + 1)
        end
    end

    -- 替换字符串
    local ret = fmtInfo.fmt
    if type(fmtInfo.fmt) == "table" then
        -- 是 table 的话，格式随机选取
        math.randomseed(socket:gettime())
        local idx = math.random(1, #(fmtInfo.fmt))
        ret = fmtInfo.fmt[idx]
    end
    for k,v in pairs(useParams) do
        ret = String:replace(ret, string.format("${%s}", k), v)
    end
    return ret
end

--[[
* @brief 创建消息文本并开始滚动
* @param [in] index 在队列中的索引
* @param [in] txt 文本
* @param [in] msgtype 消息类型
]]
function BroadcastMsg:createMessageText()
    -- 没有消息不创建
    if #self._messageList == 0 then
        return
    end

    local index = #self._messageList
    local txt = self._messageList[1]["m"]
    local msgtype = self._messageList[1]["t"]

    -- 创建文本并添加到panel
    local txtView = ccui.Text:create()
    txtView:setString(txt)
    txtView:setColor(cc.c3b(255, 255, 255))
    txtView:setFontSize(32)
    txtView:setFontName( "ttf/MNCY.ttf" )
    self.panel_message:addChild( txtView )
    txtView:setTag( index )     -- 保存队列中的索引

    local panelSize = self.panel_message:getContentSize()
    local checkW = panelSize.width - MARGIN * 2
    local txtSize = txtView:getContentSize()
    local actList = {}
    table.insert(actList, cc.MoveBy:create(0.2, cc.p(0, -panelSize.height)))
    if txtSize.width <= checkW then
        -- 文本可以完整显示，则居中显示
        txtView:setAnchorPoint(cc.p(0.5, 0))
        txtView:setPosition(cc.p(panelSize.width / 2, panelSize.height))
        local delayT = 3
        -- 文本较短，调整限时时间
        if txtSize.width < panelSize.width / 2 then
            delayT = 2
        elseif txtSize.width < panelSize.width / 4 then
            delayT = 1
        end
        table.insert(actList, cc.DelayTime:create(delayT))   -- 固定显示时间
    else
        -- 文本无法完整显示，显示在左边
        txtView:setAnchorPoint(cc.p(0, 0))
        txtView:setPosition( cc.p(MARGIN, panelSize.height) )
        -- 需要向左移动
        local md = txtSize.width - checkW
        table.insert(actList, cc.DelayTime:create(1))   -- 1秒的延迟
        table.insert(actList, cc.MoveBy:create(md / self._seed ,cc.p(0 - md, 0)))
        table.insert(actList, cc.DelayTime:create(1))   -- 1秒的固定显示
    end

    -- table.insert(actList, cc.MoveBy:create(0.2, cc.p(0, panelSize.height)))   -- 上移隐藏
    table.insert(actList, cc.CallFunc:create(handler(self, self.onActionSequenceCallback))) -- 调用回调
    txtView:runAction(cc.Sequence:create(actList))
end

--[[
* @brief 文字滚动到尾部回调
* @param [in] node 执行动作的节点
]]
function BroadcastMsg:onActionSequenceCallback(node)
    -- 停止所有动作
    node:stopAllActions()
    node:removeFromParent(true)

    -- 从队列中移除
    table.remove(self._messageList, 1)

    if #self._messageList > 0 then
        -- 还有消息没播完，继续
        self:createMessageText()
    else
        -- 全部播完了，隐藏背景
        self:stopAllActions()
        self:runAction(cc.Sequence:create(cc.MoveTo:create(0.2, cc.p(0, self:getPositionY() + 49 ))))
    end
end

--[[
* @brief 消息消息
* @param [in] msg 消息内容
* @param [in] msgtype 消息类型
* @param [in] isLocal 是否是本地消息
]]
local actionLock = false
function BroadcastMsg:showMessage( msg , msgtype , speed )
    if speed then
        self._seed = speed
        print( "速度："..self._seed )
    end

    -- 记录消息
    self:recordMsg(msg , msgtype )

    -- 播放下滑动画
    if self:getPositionY() == display.height and actionLock == false then
        actionLock = true
        self:stopAllActions()
        self:runAction( cc.Spawn:create( cc.MoveTo:create( 0.2 , cc.p( 0 , self:getPositionY() - 49 ) )  , cc.CallFunc:create( function()
            -- 添加消息
            self:createMessageText()
            actionLock = false
         end)))
    end
end

return BroadcastMsg
