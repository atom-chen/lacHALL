-- Author: pengxunsheng
-- Date:2018.3.19
-- Describe：礼品商店

local GiftGood = class("GiftGood", cc.load("ViewLayout"))

GiftGood.RESOURCE_FILENAME="ui/gift/giftGood.lua"

GiftGood.RESOURCE_BINDING =
{
    ["goodbtn"]   = {["varname"] = "goodbtn",["events"] ={{event="click",method="onClick"}}},                      -- 背景
    ["nametext_good"]   = { ["varname"] = "nametext_good"  },                                                               -- 道具名字
    ["pricetext_good"]  = { ["varname"] = "pricetext_good" },                                                               -- 价格
    ["img_good"]   = { ["varname"] = "img_good"  },                                                                         -- 图标
    ["img"]   = { ["varname"] = "img"  },
}

function GiftGood:onCreate(...)
    self:init()
    self:initView()
end

function GiftGood:init()
    self._fun = nil
    self.gooddata = nil
    -- 道具
    self._propDef  = gg.GetPropList()
end

function GiftGood:initView()
    self.goodbtn:retain()
    self.goodbtn:removeFromParent( true )
    self:addChild( self.goodbtn )
    self.goodbtn:release()
end

--设置商品信息 点击回调函数
function GiftGood:setInfo(info)
    local img_lipinprop = self._propDef[PROP_ID_LOTTERY]
    self.img:loadTexture(img_lipinprop.icon)
    self.img:ignoreContentAdaptWithSize(true)
    self.img:setScale(60 / math.max(self.img:getContentSize().width, self.img:getContentSize().height))
    
    if type(info)=="table" then
       self.goodbtn:setBackGroundImage("hall/store/Bottomframe_1.jpg",1)
       self.gooddata = info
       self.nametext_good:setString(info.name)
       --网络图片的接口
       gg.ImageDownload:LoadHttpImageAsyn(info.pic, self.img_good)
       self.pricetext_good:setString("x"..info.price)
    else
       self.goodbtn:setBackGroundImage("hall/gift/duobao_bg.png",1)
       self.nametext_good:setVisible(false)
       self.img_good:loadTexture("hall/gift/duobao_icon.png",1)
       self.img_good:ignoreContentAdaptWithSize(true)
       self.img_good:setPositionY(self.img_good:getPositionY() + 20)
       self.pricetext_good:setString("x"..info)
    end

end

--设置回调
function GiftGood:setFun(fun)
    self._fun = fun
end

--商品回调
function GiftGood:onClick(event)
    --快速点击的判断
    if (gg.IsFastClick(event)) then return end
    if self._fun then
        self._fun(self.gooddata)
    end
end

function GiftGood:getSize()
    return  self.goodbtn:getContentSize()
end

return  GiftGood;
