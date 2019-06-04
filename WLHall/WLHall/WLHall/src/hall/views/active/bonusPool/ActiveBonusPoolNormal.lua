--[[
    create by John 2018-04-19
    五一奖金池活动界面
]]
local ActiveBonusPoolNormal = class("ActiveBonusPoolNormal", cc.load("ViewBase"))

ActiveBonusPoolNormal.RESOURCE_FILENAME = "ui/active/bonus_pool/activity_cjdjc.lua"

ActiveBonusPoolNormal.RESOURCE_BINDING =
{
    ["btn_rank"] = { ["varname"] = "btn_rank", ["events"] = { { ["event"] = "click", ["method"] = "onClickRank" } } },
    ["btn_rule"] = { ["varname"] = "btn_rule", ["events"] = { { ["event"] = "click", ["method"] = "onClickRule" } } },
    ["text_cur_coin"] = { ["varname"] = "text_cur_coin"},
    ["text_time"] = { ["varname"] = "text_time" },
    ["img_coin_unit"] = { ["varname"] = "img_coin_unit"},
    ["btn_buy"] = { ["varname"] = "btn_buy", ["events"] = { { ["event"] = "click", ["method"] = "onClickBuy" } } },
    ["img_bottom"] = { ["varname"] = "img_bottom"},
    ["node"] = { ["varname"] = "node"},
    ["text_des"] = { ["varname"] = "text_des"},
    ["img_coin_unit"] = { ["varname"] = "img_coin_unit"},

}

function ActiveBonusPoolNormal:onCreate(actInfo)
    self.node:setVisible(false)

    -- 显示活动的时间
    local startTime = os.date("%Y.%m.%d %H:%M", actInfo.start_time)
    local endTime = os.date("%m.%d %H:%M", actInfo.end_time)
    local strTime = string.format("活动时间：%s-%s", startTime, endTime)
    self.text_time:setString(strTime)

    -- 关注支付成功的事件
    self:addEventListener( gg.Event.ON_PAY_RESULT, handler( self, self.onPayResultsCallBack ) )

    self._richTxtRank = self:createRichTxt(cc.p(67, 195))
    self._richTxtPool = self:createRichTxt(cc.p(67, 143))
end

function ActiveBonusPoolNormal:requestCurCoins()
    gg.Dapi:BonusPoolCoinNum(gg.ActivityPageData.ACTIVE_TAG_CJDJC,function(cb)
        if tolua.isnull(self) then return end
        cb = checktable(cb)

        if not cb.status or checkint(cb.status) ~= 0 then
            GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "网络错误，请关闭界面重试！")
            return
        end

        self.text_cur_coin:setString(cb.data)

        local  nodeWidth = self.text_cur_coin:getContentSize().width + 20 + self.text_des:getContentSize().width + self.img_coin_unit:getContentSize().width

        self.text_cur_coin:setPositionX(self.text_des:getPositionX() + 10)
        self.img_coin_unit:setPositionX(self.text_cur_coin:getPositionX() + self.text_cur_coin:getContentSize().width + 10)

        self.node:setPositionX(self.img_bottom:getContentSize().width/2 - nodeWidth /2  )
        self.node:setVisible(true)
        -- 更新自己的数据
        self:updateOwnData(cb.user)
    end)
end

function ActiveBonusPoolNormal:updateOwnData(data)
    if not data then
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "网络错误，请关闭界面重试！")
        return
    end
    -- 排名数据
    local rankStr = ""
    if checkint(data.sor) <= 0 then
        rankStr = string.format("<div>暂无排名，充值.<div fontcolor=#E24500 fontsize=40>%d</div>.元，立即提升排名</div>", math.max(checkint(data.disparity), 1))
    elseif checkint(data.sor) == 1 then
        rankStr = "我的排名：第1名"
    else
        rankStr = string.format("<div>我的排名：第.<div fontcolor=#E24500 fontsize=40>%d</div>.名，充值.<div fontcolor=#E24500 fontsize=40>%d</div>.元，立即提升排名</div>", checkint(data.sor), checkint(data.disparity))
    end
    self:setRichTxtStr(self._richTxtRank, rankStr)
    -- 奖池数据
    local poolStr = string.format("<div>当前瓜分奖池：.<div fontcolor=#E24500 fontsize=40>%d</div>.豆</div>", checkint(data.myself))
    self:setRichTxtStr(self._richTxtPool, poolStr)
end

function ActiveBonusPoolNormal:onClickBuy(sender)
    gg.AudioManager:playClickEffect()
    GameApp:DoShell(self:getScene(), "Store://bean")
end

function ActiveBonusPoolNormal:onClickRank()
    gg.AudioManager:playClickEffect()
    self:getScene():createView("active.bonusPool.PopRankBonusPool",gg.ActivityPageData.ACTIVE_TAG_CJDJC):pushInScene()
end

function ActiveBonusPoolNormal:onClickRule()
    gg.AudioManager:playClickEffect()
    self:getScene():createView("active.bonusPool.PopRuleBonusPool",gg.ActivityPageData.ACTIVE_TAG_CJDJC):pushInScene()
end

function ActiveBonusPoolNormal:onPageShown( )
    self:requestCurCoins()
end

function ActiveBonusPoolNormal:onPayResultsCallBack(event, result)
    -- 支付成功刷新数据
    if result and result.status == 0 then
        self:requestCurCoins()
    end
end

-- 创建富文本
function ActiveBonusPoolNormal:createRichTxt(pos)
    local richTxt = RichLabel.new {
        fontSize = 27,
        fontColor = cc.c3b(114, 12, 0),
    }
    richTxt:setAnchorPoint(cc.p(0, 0.5))
    richTxt:setPosition(pos)
    self:addChild(richTxt)
    return richTxt
end

-- 设置富文本相关数据
function ActiveBonusPoolNormal:setRichTxtStr(richTxt, str)
    if not richTxt then return end
    richTxt:setString(str)   
    -- 由于排名设置的字体太大了，需要重新布局，否则文字会重叠
    richTxt:layout() 
    richTxt:walkElements(function(node, index)
        if not node then return end
        local ndstr = node:getString()
        -- 富文本空格无效，故这里使用“.”作为占位符顶替空格的作用
        if ndstr == "." then
            node:setVisible(false)
        end
    end)
end

return ActiveBonusPoolNormal
