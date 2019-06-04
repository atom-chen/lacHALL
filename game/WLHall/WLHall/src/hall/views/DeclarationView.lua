--
-- Author: zhangbin
-- Date: 2018-01-25
-- Describe：声明界面

local DeclarationView = class("DeclarationView", cc.load("ViewPop"))
DeclarationView.RESOURCE_FILENAME = "ui/common/declaration_view.lua"
DeclarationView.RESOURCE_BINDING = {
    ["sv"] = {["varname"] = "sv"},
    ["btn_close"] = {["varname"] = "btn_close", ["events"] = {{["event"] = "click_color", ["method"] = "onClickClose"}}},
    ["btn_service"] = {["varname"] = "btn_service", ["events"] = {{["event"] = "click", ["method"] = "onService"}}},
}

DeclarationView.AUTO_RESOLUTION = true

local ContentStr = "<div><div fontcolor=#222222>关于朋友场的积分：\n</div>朋友场的积分仅用于每盘对局的分数记录，在每盘结束时清零，不具有任何货币价值；\n \n<div fontcolor=#222222>关于礼品券：\n</div>礼品券是系统奖励的一种道具，礼品券不参与任何游戏（含朋友场游戏）的结算，与游戏胜负无关！只能通过完成游戏任务、免费抽奖等免费方式获得，不能通过法定货币购买；不能通过购买虚拟货币（微乐豆）间接获得；不能通过使用虚拟货币兑换获得；不能通过兑换游戏积分获得；且用户间不能转让，不能进行交易；\n \n本公司严禁用户之间进行赌博行为，对用户拥有的虚拟货币和积分均不提供任何形式的回购，也不允许相互赠与和转让。</div>"

function DeclarationView:onCreate()
    self.sv:setScrollBarEnabled(false)
    self:initView()
end

function DeclarationView:initView()
    local RichLabel = require("common.richlabel.RichLabel")
    local label = RichLabel.new({
      fontSize = 28,
      fontColor = cc.c3b(119, 119, 119),
      maxWidth = 1010,
      linespace = 5,
    })
    label:setString(ContentStr)
    self.sv:addChild(label)

    local svWidth = self.sv:getInnerContainerSize().width
    local svHeight = label:getSize().height
    svHeight = math.max(svHeight, self.sv:getInnerContainerSize().height)
    self.sv:setInnerContainerSize(cc.size(svWidth, svHeight))
    label:setPositionY(svHeight)
end

function DeclarationView:onClickClose()
    self:removeSelf()
end

-- 联系客服
function DeclarationView:onService()
    device.callCustomerServiceApi(ModuleTag.Declaration)
end

return DeclarationView
