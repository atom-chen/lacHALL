
----------------------------------------------------------------------
-- 作者：chenjingmin
-- 日期：2017-03-5
-- 描述：创建贵族星耀特权
----------------------------------------------------------------------

local Privilege = class("Privilege", cc.load("ViewBase"))
local storeData = require("hall.models.StoreData")

Privilege.RESOURCE_FILENAME = "ui/active/activity_privilege_view.lua"
Privilege.RESOURCE_BINDING = {
    ["img_noble_1"]            = { ["varname"] = "img_noble_1"             },
    ["text_noble_1"]           = { ["varname"] = "text_noble_1"            },
    ["text_noble_unit_1"]      = { ["varname"] = "text_noble_unit_1"       },
    ["img_noble_2"]            = { ["varname"] = "img_noble_2"             },
    ["text_noble_2"]           = { ["varname"] = "text_noble_2"            },
    ["text_noble_unit_2"]      = { ["varname"] = "text_noble_unit_2"       },
    ["img_noble_3"]            = { ["varname"] = "img_noble_3"             },
    ["text_noble_3"]           = { ["varname"] = "text_noble_3"            },
    ["text_noble_unit_3"]      = { ["varname"] = "text_noble_unit_3"       },
    ["price_noble"]            = { ["varname"] = "price_noble"             },
    ["current_price_noble"]    = { ["varname"] = "current_price_noble"     },
    ["img_xy_1"]               = { ["varname"] = "img_xy_1"                },
    ["text_xy_1"]              = { ["varname"] = "text_xy_1"               },
    ["text_xy_unit_1"]         = { ["varname"] = "text_xy_unit_1"          },
    ["img_xy_2"]               = { ["varname"] = "img_xy_2"                },
    ["text_xy_2"]              = { ["varname"] = "text_xy_2"               },
    ["text_xy_unit_2"]         = { ["varname"] = "text_xy_unit_2"          },
    ["img_xy_3"]               = { ["varname"] = "img_xy_3"                },
    ["text_xy_3"]              = { ["varname"] = "text_xy_3"               },
    ["text_xy_unit_3"]         = { ["varname"] = "text_xy_unit_3"          },
    ["price_xy"]               = { ["varname"] = "price_xy"                },
    ["current_price_xy"]       = { ["varname"] = "current_price_xy"        },

    ["panel_noble"]            = { ["varname"] = "panel_noble"             },
    ["panel_xy"]               = { ["varname"] = "panel_xy"                },

    ["panel_noble_button_buy"] = { ["varname"] = "panel_noble_button_buy"  ,["events"] = { { ["event"] = "click", ["method"] = "onClickNoble"        } } },--贵族月卡未购买
    ["panel_noble_jg"]         = { ["varname"] = "panel_noble_jg"          },                --未购买显示的金额
    ["txt_gzyk"]               = { ["varname"] = "txt_gzyk"                },                --未领取的文字
    ["panel_noble_ylq"]        = { ["varname"] = "panel_noble_ylq"         },                --已领取的文字
    ["panel_noble_receive"]    = { ["varname"] = "panel_noble_receive"     ,["events"] = { { ["event"] = "click", ["method"] = "onClickNobleRewards" } } },--贵族月卡已购买 未领取
    ["panel_xy_receive"]       = { ["varname"] = "panel_xy_receive"        ,["events"] = { { ["event"] = "click", ["method"] = "onClickXYRewards"    } } },--星耀月卡已购买 未领取
    ["panel_xy_button_buy"]    = { ["varname"] = "panel_xy_button_buy"     ,["events"] = { { ["event"] = "click", ["method"] = "onClickXY"           } } },--星耀月卡未购买
    ["panel_xy_jg"]            = { ["varname"] = "panel_xy_jg"             },                --未购买显示的金额
    ["panel_xy_ylq"]           = { ["varname"] = "panel_xy_ylq"            },                --已领取的文字
    ["txt_xyyk"]               = { ["varname"] = "txt_xyyk"                },
    ["img_xyyk_anim"]          = { ["varname"] = "img_xyyk_anim"           },                --星耀月卡
    ["img_gzye_anim"]          = { ["varname"] = "img_gzye_anim"           },                --贵族月卡
}

function Privilege:onCreate()
    gg.UserData:checkLoaded(function()
        if tolua.isnull(self) then return end
        -- 刷新购买状态
        self:updateNobleBuyStatus()
        self:updateXYBuyStatus()
    end)

    -- 初始化
    self:init()
    -- 初始化界面
    self:initView()
    -- 注册事件
    self:registerEventListener()
end

function Privilege:registerEventListener()
    -- 购买月卡成功的事件回调
    self:addEventListener(gg.Event.BUG_MONTHCARD_SUCCESS, handler(self, self.updateNobleBuyStatus))
    self:addEventListener(gg.Event.BUG_MONTHCARD_VIP_SUCCESS, handler(self, self.updateXYBuyStatus))
end

function Privilege:init()
    self._profDef = gg.GetPropList()
end

function Privilege:initView()
    -- 审核模式隐藏原价显示
    if IS_REVIEW_MODE then
        self.panel_xy_jg:getChildByName("price_0"):setVisible(false)
        self.panel_xy_jg:getChildByName("price_1"):setVisible(false)
        self.panel_xy_jg:getChildByName("price_xy"):setVisible(false)
        self.panel_xy_jg:getChildByName("Image_14"):setVisible(false)

        self.panel_noble_jg:getChildByName("price_0"):setVisible(false)
        self.panel_noble_jg:getChildByName("price_1"):setVisible(false)
        self.panel_noble_jg:getChildByName("price_noble"):setVisible(false)
        self.panel_noble_jg:getChildByName("Image_14"):setVisible(false)
    end

    -- 获取礼包配置
    local xy_gift = storeData:GetMonthCardVIPGiftTable()
	local noble_gift = storeData:GetPrivilegeGiftTable()

    -- 设置贵族礼包信息
    self:setNobleProps(noble_gift.daily_prop)
    self:setNobleProp(noble_gift.prop)
    --星耀
    self:setXYProps(xy_gift.daily_prop)
    self:setXYProp(xy_gift.prop)

	-- 获取礼包价格
    local xy_money = storeData:GetMonthCardVIPGoodsInfo()
	local noble_money = storeData:GetPrivilegeGoodsInfo()
	assert( noble_money , "贵族礼包商品未配置！" )
    assert( xy_money , "星耀礼包商品未配置！" )

    -- 设置价格
    self:setNoblePrice(noble_money)
    self:setXYPrice(xy_money)
end
-- 贵族礼包信息1
function Privilege:setNobleProp(nobleProp)
    if not nobleProp then return end

    for i=1,2 do
        local node =  self.panel_noble:getChildByName("prop_"..i)
        local img_prop =  node:getChildByName("img_"..i)
        local txt_prop_count =  node:getChildByName("txt_"..i)
        local propId = nobleProp[i][1]
        local propCount = nobleProp[i][2]
        local propDef = self._profDef[propId]
        if propId ~= PROP_ID_MONEY then
            img_prop:loadTexture(propDef.icon)
            local countStr = checkint(propCount)* ( self._profDef[propId].proportion or 1 )
            local strtxt = string.format("%s%s%s",countStr,self._profDef[propId].unit or "",self._profDef[propId].name or"")
            txt_prop_count:setString(strtxt)
        else
            -- 豆豆处理
            img_prop:loadTexture("hall/active/privilege/img_doudou.png",1)
            local strtxt = gg.MoneyUnit(propCount)
            txt_prop_count:setString(string.format("%s豆",strtxt))
        end
    end
end
-- 贵族礼包信息2
function Privilege:setNobleProps(nobleProps)
    if not nobleProps then return end

    local mofacount = 0
    for i ,v in pairs(nobleProps) do
        local propType = v[1]  --id
        local propCount = v[2]  --数量
        if gg.IsMagicProp(propType) then
            mofacount = mofacount +propCount
        end
    end

    -- 创建道具
    for i=1,3 do
        local img_prop = self["img_noble_" .. i]            -- 道具图标
        img_prop:ignoreContentAdaptWithSize(true)
        local txt_prop_count = self["text_noble_" .. i]     -- 数量
        local txt_prop_unit = self["text_noble_unit_" .. i] -- 单位

        local propId = nobleProps[i][1]
        local propCount = nobleProps[i][2]
        local propDef = self._profDef[propId]
        if gg.IsMagicProp(propId) then
            img_prop:loadTexture("common/prop/gift_1.png")
            txt_prop_count:setString("x"..mofacount.."\n魔法道具")
            txt_prop_count:setAnchorPoint(0.5,0)
            txt_prop_count:setTextHorizontalAlignment(2)
            txt_prop_count:setFontSize(24)
            txt_prop_count:setPosition(txt_prop_count:getPositionX() - 3,0)
            txt_prop_unit:setVisible(false)
        else
            if propId ~= PROP_ID_MONEY then
                img_prop:loadTexture(propDef.icon)
                txt_prop_count:setString(propCount)
                txt_prop_unit:setString(propDef.unit or "")
            else
                -- 豆豆处理
                local minmoneyTr = propCount / 10000
                img_prop:loadTexture("hall/common/dou_1.png")
                txt_prop_count:setString(minmoneyTr)
                txt_prop_unit:setString("万")
            end
            -- 设置数量和单位位置
            txt_prop_count:setPositionX(txt_prop_count:getPositionX() - txt_prop_unit:getContentSize().width / 2)
            txt_prop_unit:setPositionX(txt_prop_count:getContentSize().width)
        end
        -- 部分道具ui做特殊处理
        if propId == PROP_ID_JIPAI or propId == PROP_ID_HAIDILAOYUE then
            img_prop:setScale(85 / img_prop:getContentSize().height)
        else
            img_prop:setScale(100 / img_prop:getContentSize().height)
        end

        if propId == PROP_ID_CANSAI or propId == PROP_ID_263 or propId == PROP_ID_PHONE_CARD then
            img_prop:setPositionY(img_prop:getPositionY() - 10)
        end

    end
end
-- 星耀礼包信息1
function Privilege:setXYProp(xyProp)
    if not xyProp then return end
    for i=1,2 do
        local node =  self.panel_xy:getChildByName("prop_"..i)
        local img_prop =  node:getChildByName("img_"..i)
        local txt_prop_count =  node:getChildByName("txt_"..i)
        local propId = xyProp[i][1]
        local propCount = xyProp[i][2]
        local propDef = self._profDef[propId]

        if propId ~= PROP_ID_MONEY then
            img_prop:loadTexture(propDef.icon)
            local countStr = checkint(propCount)* ( self._profDef[propId].proportion or 1 )
            local strtxt = string.format("%s%s%s",countStr,self._profDef[propId].unit or "",self._profDef[propId].name or"")
            txt_prop_count:setString(strtxt)
            -- 部分道具ui做特殊处理
            if propId == PROP_ID_263 or propId == PROP_ID_LEITAIKA  then

                img_prop:ignoreContentAdaptWithSize(true)
                img_prop:setScale(100 / img_prop:getContentSize().height)
                img_prop:setPositionY( img_prop:getPositionY() - 8)
                if propId == PROP_ID_263 then
                    txt_prop_count:setPositionX( txt_prop_count:getPositionX() - 25)
                end
            end
            if propId == PROP_ID_LEITAIKA or propId == PROP_ID_263 then
                img_prop:setPositionY(img_prop:getPositionY() - 10)
            end
        else
            -- 豆豆处理
            img_prop:loadTexture("hall/active/privilege/img_doudou.png",1)
            local strtxt = gg.MoneyUnit(propCount)
            txt_prop_count:setString(string.format("%s豆",strtxt))
            --显示即时话费 位置左移
            if xyProp[2][1] == PROP_ID_263 then
                txt_prop_count:setPositionX( txt_prop_count:getPositionX() - 25)
            end
        end
    end
end
-- 星耀礼包信息2
function Privilege:setXYProps( xyProps )
    if not xyProps then return end
    local mofacount = 0
    for i ,v in pairs(xyProps) do
        local propType = v[1]  --id
        local propCount = v[2]  --数量
        if gg.IsMagicProp(propType) then
            mofacount = mofacount +propCount
        end
    end
    -- 创建道具
    for i=1,3 do
        local img_prop = self["img_xy_" .. i]            -- 道具图标
        img_prop:ignoreContentAdaptWithSize(true)
        local txt_prop_count = self["text_xy_" .. i]     -- 数量
        local txt_prop_unit = self["text_xy_unit_" .. i] -- 单位

        local propId = xyProps[i][1]
        local propCount = xyProps[i][2]
        local propDef = self._profDef[propId]
        if gg.IsMagicProp(propId) then

            img_prop:loadTexture("common/prop/gift_1.png")
            txt_prop_count:setString("x"..mofacount.."\n魔法道具")
            txt_prop_count:setAnchorPoint(0.5,0)
            txt_prop_count:setTextHorizontalAlignment(2)
            txt_prop_count:setFontSize(24)
            txt_prop_count:setPosition(txt_prop_count:getPositionX() - 3,0)
            txt_prop_unit:setVisible(false)


        else
            if propId ~= PROP_ID_MONEY then
                img_prop:loadTexture(propDef.icon)
                txt_prop_count:setString(propCount)
                txt_prop_unit:setString(propDef.unit or "")
            else
                -- 豆豆处理
                local minmoneyTr = propCount / 10000
                img_prop:loadTexture("hall/common/dou_1.png")
                txt_prop_count:setString(minmoneyTr)
                txt_prop_unit:setString("万")
            end
            -- 设置数量和单位位置
            txt_prop_count:setPositionX(txt_prop_count:getPositionX() - txt_prop_unit:getContentSize().width / 2)
            txt_prop_unit:setPositionX(txt_prop_count:getContentSize().width)
        end
        -- 部分道具ui做特殊处理
        if propId == PROP_ID_JIPAI or propId == PROP_ID_HAIDILAOYUE then
            img_prop:setScale(85 / img_prop:getContentSize().height)
        else
            img_prop:setScale(100 / img_prop:getContentSize().height)
        end

        if propId == PROP_ID_CANSAI or propId == PROP_ID_263 or propId == PROP_ID_PHONE_CARD or propId == PROP_ID_LEITAIKA then
            img_prop:setPositionY(img_prop:getPositionY() - 10)
        end

    end
end

-- 贵族价格
function Privilege:setNoblePrice( noble_money )
    self.price_noble:setString(noble_money.origPrice)
    self.current_price_noble:setString(noble_money.price)
end

-- 星耀价格
function Privilege:setXYPrice( xy_money )
    self.price_xy:setString(xy_money.origPrice)
    self.current_price_xy:setString(xy_money.price)
end

-- 星耀点击事件
function Privilege:onClickXY( sender )
    local data = storeData:GetMonthCardVIPGoodsInfo()
    local payMethods = gg.PayHelper:getPayMethods(data.goods)
    local payCount = #payMethods
    if payCount == 1 then
        gg.PayHelper:payByMethod(data,payMethods[payCount])
    else
        gg.PayHelper:showPay(GameApp:getRunningScene(), data)
    end
end

-- 贵族点击事件
function Privilege:onClickNoble( sender )
    local data = storeData:GetPrivilegeGoodsInfo()
    local payMethods = gg.PayHelper:getPayMethods(data.goods)
    local payCount = #payMethods
    if payCount == 1 then
        gg.PayHelper:payByMethod(data,payMethods[payCount])
    else
        gg.PayHelper:showPay(GameApp:getRunningScene(), data)
    end
end

-- 星耀领取奖励
function Privilege:onClickXYRewards(sender)
    if not hallmanager then
        return
    end

    -- 领取奖励
    local userinfo = checktable( hallmanager.userinfo )
    gg.Dapi:TaskAward(87, 0, 0, function(result)
        if tolua.isnull(self) then return end
        if result.status == 0 then
            -- 修改任务状态
            gg.UserData:SetTaskStatusById( 87, 5 )

            -- 更新界面显示
            self:updateXYBuyStatus()
            GameApp:dispatchEvent( gg.Event.SHOW_TOAST, "恭喜您成功领取！")
            -- 发送月卡领取奖励通知
            GameApp:dispatchEvent(gg.Event.GOT_PRIVILEGE_REWARD)
        else
            GameApp:dispatchEvent( gg.Event.SHOW_TOAST, "领取失败！")
        end
    end)
end

function Privilege:onClickNobleRewards(sender)
    if not hallmanager then
        return
    end

    -- 领取奖励
    local userinfo = checktable( hallmanager.userinfo )
    gg.Dapi:TaskAward(23, 0, 0, function(result)
        if tolua.isnull(self) then return end
        if result.status == 0 then
            -- 修改任务状态
            gg.UserData:SetTaskStatusById( 23, 5 )

            -- 更新界面显示
            self:updateNobleBuyStatus()
            GameApp:dispatchEvent( gg.Event.SHOW_TOAST, "恭喜您成功领取！")
            -- 发送月卡领取奖励通知
            GameApp:dispatchEvent(gg.Event.GOT_PRIVILEGE_REWARD)
        else
            GameApp:dispatchEvent( gg.Event.SHOW_TOAST, "领取失败！")
        end
    end)
end

function Privilege:updateNobleBuyStatus()
    if tolua.isnull(self) then return end

    -- 获取状态
    local status = gg.UserData:GetPrivilegeStatus()
    if (not status) or status == 2 then
        -- 未购买状态
        self.panel_noble_button_buy:setVisible(true)
        self.panel_noble_jg:setVisible(true)

        self.panel_noble_ylq:setVisible(false)
        self.panel_noble_receive:setVisible(false)
        self.txt_gzyk:setVisible(false)
    else
        -- 已买状态
        self.panel_noble_button_buy:setVisible(false)
        self.panel_noble_jg:setVisible(false)

        self.txt_gzyk:setVisible(true)
        self.panel_noble_receive:setVisible(true)

        self.panel_noble_ylq:setVisible(false)

        -- 获取截止日期
        local taskInfo = gg.UserData:GetTaskInfo( 23 )
        local endTime = ""
        if taskInfo and taskInfo.mc_end then
            endTime = taskInfo.mc_end
        end
        self.txt_gzyk:setString(string.format( "领取时间剩余：%s天" , endTime))
        -- 状态为 5 表示已领取奖励
        if status == 5  then
            self.panel_noble_receive:setVisible(false)
            self.panel_noble_ylq:setVisible(true)
            --停止之前的动画
            self.img_gzye_anim:stopAllActions()
        else
            --播放贵族月卡领取动画
            self.img_gzye_anim:runAction(cc.RepeatForever:create(
                cc.Sequence:create(
                cc.ScaleTo:create(0.6, 1.1),
                cc.ScaleTo:create(0.6, 1.0)
            )))
        end
	end
end

function Privilege:updateXYBuyStatus()
    if tolua.isnull(self) then return end

    -- 获取状态
    local status = gg.UserData:GetMonthCardVIPStatus()
    if (not status) or status == 2 then
        -- 未购买状态
        self.panel_xy_button_buy:setVisible(true)
        self.panel_xy_jg:setVisible(true)

        self.panel_xy_receive:setVisible(false)
        self.panel_xy_ylq:setVisible(false)
        self.txt_xyyk:setVisible(false)
    else
        -- 已买状态
        self.panel_xy_button_buy:setVisible(false)
        self.panel_xy_jg:setVisible(false)
        self.panel_xy_receive:setVisible(true)
        self.txt_xyyk:setVisible(true)
        self.panel_xy_ylq:setVisible(false)
        -- 获取截止日期
        local taskInfo = gg.UserData:GetTaskInfo( 87 )
        local endTime = ""
        if taskInfo and taskInfo.mc_end then
            endTime = taskInfo.mc_end
        end
        self.txt_xyyk:setString(string.format( "领取时间剩余：%s天" , endTime))
        -- 状态为 5 表示已领取奖励
        if status == 5 then
            self.panel_xy_receive:setVisible(false)
            self.panel_xy_ylq:setVisible(true)
            --停止之前的动画
            self.img_xyyk_anim:stopAllActions()
        else
            --播放星耀月卡领取动画
            self.img_xyyk_anim:runAction(cc.RepeatForever:create(
                cc.Sequence:create(
                cc.ScaleTo:create(0.6, 1.1),
                cc.ScaleTo:create(0.6, 1.0)
            )))
        end
    end
end

return Privilege
