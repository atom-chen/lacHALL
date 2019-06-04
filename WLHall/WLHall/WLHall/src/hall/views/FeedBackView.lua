--
-- Author: zhaoxinyu
-- Date: 2016-08-26 17:36:29
-- Describe：意见反馈
local GameItemClass = import(".ItemRuleGame")
local DetailItemClass = import(".ItemRuleDetail")
local FeedBackView = class("FeedBackView", cc.load("ViewPop"))

local Http = require "common.HttpProxyHelper"

FeedBackView.RESOURCE_FILENAME = "ui/common/pop_feed_back_change.lua"
FeedBackView.RESOURCE_BINDING = {
	["full_bg"] 	= { ["varname"] = "full_bg" },
    ["title_bg"]    = { ["varname"] = "title_bg"  },     -- 标题背景
    ["nd_feed"]     = { ["varname"] = "nd_feed"   },     -- 意见反馈节点
    ["nd_rule"]     = { ["varname"] = "nd_rule"   },     -- 规则节点
    ["img_phone"]   = { ["varname"] = "img_phone" },     -- 电话输入底框
    ["img_input"]   = { ["varname"] = "img_input" },     -- 意见输入底框
    ["sv_feed"]     = { ["varname"] = "sv_feed"   },
    ["list_games"]  = { ["varname"] = "list_games" },    -- 规则页面-游戏列表
    ["list_detail"] = { ["varname"] = "list_detail" },   -- 规则页面-游戏具体说明
    ["feed_title_img"]   = { ["varname"] = "feed_title_img" },     -- 意见反馈横条
    ["rule_title_bg"]   = { ["varname"] = "rule_title_bg" },       -- 规则反馈横条
    ["rule_title_name"]   = { ["varname"] = "rule_title_name" },   -- 规则游戏名字
    ["btn_commit"]  = { ["varname"] = "btn_commit" ,  ["events"] = { { ["event"] = "click", ["method"] = "onClickCommit" } } },  -- 发送按钮
    ["btn_add_img"] = { ["varname"] = "btn_add_img" , ["events"] = { { ["event"] = "click", ["method"] = "onClickAddImg" } } },  -- 添加图片按钮

    ["nd_feed"]       = { ["varname"] = "nd_feed"   },     -- 意见反馈节点
    ["nd_rule"]       = { ["varname"] = "nd_rule"   },     -- 规则节点
    ["btn_close"]     = { ["varname"] = "btn_close",    ["events"] = { { ["event"] = "click_color", ["method"] = "onClickClose"  } } },	 -- 关闭按钮
    ["btn_rule"]      = { ["varname"] = "btn_rule",     ["events"] = { { ["event"] = "click", ["method"] = "onClickRule"  } } },	 -- 规则按钮
    ["btn_feedback"]  = { ["varname"] = "btn_feedback", ["events"] = { { ["event"] = "click", ["method"] = "onClickFeedback"  } } }, -- 反馈按钮
    ["btn_service"]   = { ["varname"] = "btn_service",  ["events"] = { { ["event"] = "click", ["method"] = "onClickService"  } } },	 -- 客服按钮
}

FeedBackView.CUSTOM_SERVICE_TAG = ModuleTag.FeedBack
FeedBackView.ADD_BLUR_BG = true

local DETAIL_TITLES = {
    "最近更新",
    "基本玩法",
    "结算说明",
}
local FEED_PLACEHOLDER_STR = "我们会非常重视您的建议，请在这里输入..."
local DETAIL_LOADING_STR = "数据加载中..."
local DETAIL_LOAD_FAILED_STR = "数据加载失败"
local picLimitCount = 5        -- 玩家上传图片限制数量

local PLACE_HOLDER_COLOR = {r=166,g=166,b=166}

local TAB_SELECT_COLOR = cc.c3b(255,234,138)
local TAB_UNSELECT_COLOR = cc.c3b(102, 153, 238)

function FeedBackView:onCreate( gameId ,idxTag)
    self:init( gameId ,idxTag)
    self:initView()
end

--[[
--[[
* @brief 初始化数据
]]
function FeedBackView:init( gameId ,idxTag)

    self._gameId = gameId            -- 当前游戏id
    self._input = nil                 -- 输入框
    self.addPhotoCount =0           -- 添加的图片数量
    self.photo = nil                -- 照片
    self.storePhoto  ={}            -- 存储照片的表
    self.isFirstENter = true        -- 是否第一次点击意见反馈中的添加照片
    self.addBtnX = 0                 -- 意见反馈中添加按钮x坐标
    self.addBtnY = 0                 -- 意见反馈中添加按钮y坐标
    self.addBtnSize = 0              -- 意见反馈中添加按钮的宽度大小
    self.storePhotoUrl = {}          -- 存储照片从服务器上反馈过来的地址
    self.storePhotoPath = {}         -- 存储照片路径的表
    self.massegeLabel = nil          -- 用户所提的意见
    self.scuccesCount = 0            -- 图片上传成功次数
    self.isAllPhotoScucces = false     -- 是否所有图片都已经上传成功
    self.isScuessTran = false
    self._uploadNode = {}            -- upload控件表

    -- 规则页面需要的数据
    self.gameNodes = {}             -- 游戏列表中的按钮数组
    self.detailNodes = {}           -- 游戏列表中的数据显示控件数组
    self.detailData = {}            -- 缓存的游戏规则信息
    self.curRequest = nil           -- 当前的 http 请求

    self.gamesList = {}             -- 游戏列表
    if not idxTag then
        self:selectTab("rule")
    else
        self:selectTab(idxTag)
    end
end

--[[
* @brief 初始化View
]]
function FeedBackView:initView()
    -- 适配
    self.full_bg:setAnchorPoint( cc.p( 0.5, 0.5 ) )
	self.full_bg:setScale(math.min(display.scaleX, display.scaleY))
	self.full_bg:setPosition(0,0)

    -- 获取添加游戏按钮的位置
    self.addBtnX, self.addBtnY = self.btn_add_img:getPosition()

    -- 初始化规则页面
    self:initRuleView()

    -- 电话输入框
    self:createPhoneEditBox()
    -- 意见反馈输入框
    self:createFeedEditBox()

    --联系客服开关
    if not GameApp:CheckModuleEnable( ModuleTag.CustomerService ) then
        self.btn_service:setVisible(false)
    end

end

function FeedBackView:onCleanup()
    self:cancelHttpRequest()
end

function FeedBackView:cancelHttpRequest()
    if self.curRequest then
        Http:CancelRequest(self.curRequest)
        self.curRequest = nil
    end
end

function FeedBackView:onTab(idx)
    FeedBackView.super:onTab(idx)
end

function FeedBackView:initRuleView()
    -- 获取游戏列表
    self.gamesList = hallmanager:GetAppList()
    -- 只显示麻将和扑克类游戏
    table.filter(self.gamesList, function(v, k)
        return (Helper.And(v.type, GAME_GROUP_MAHJONG) ~= 0 or Helper.And(v.type, GAME_GROUP_POKER) ~= 0)
    end)

    local games = {}

    -- 将当前游戏放在列表的第一个
    -- games 每个元素格式为：
    -- {["name"]="长春麻将", ["id"]=100}
    if self._gameId then
        local gameInfo = self.gamesList[self._gameId]
        if gameInfo then
            -- 审核游戏名称前加 品牌
            if not GameApp:CheckModuleEnable( ModuleTag.Room ) then
                gameInfo.name = PLATFORM_NAME..gameInfo.name
            end
            table.insert(games, {
                ["name"]=gameInfo.name,
                ["id"]=gameInfo.id
            })
        end
    end

    -- 审核只显示一款游戏的规则
    if GameApp:CheckModuleEnable( ModuleTag.Room ) then

        for id, gameInfo in pairs(self.gamesList) do
            if id ~= self._gameId then
                table.insert(games, {
                    ["name"]= gameInfo.name,
                    ["id"]=gameInfo.id
                })
            end
        end
    end

    if #games == 0 then
        -- 没有游戏数据，不需要初始化界面
        return
    end

    self:initGamesList(games)
    self:initDetailList()
    self:refreshDetail()
end

function FeedBackView:initGamesList(games)
    self.list_games:setScrollBarEnabled(false)
    local selectItem = nil
    for i, info in ipairs(games) do
        if not GameApp:CheckModuleEnable(ModuleTag.Room) then
            info.name = APP_NAME
        end
        local gameBtn = GameItemClass.new("ItemRuleGame", info, i > 1, handler(self, self.switchGameRule))
        self.list_games:pushBackCustomItem(gameBtn)
        table.insert( self.gameNodes, gameBtn )

        if info.id == self._gameId then
            selectItem = gameBtn
        end
    end

    if selectItem then
        selectItem:setSelected(true)
    elseif self.gameNodes[1] then
        self.gameNodes[1]:setSelected(true)
    end
end

function FeedBackView:initDetailList()
    self.list_detail:setScrollBarEnabled(false)
    local width = self.list_detail:getContentSize().width
    for i, title in ipairs(DETAIL_TITLES) do
        local info = { ["title"]=title }
        local detailItem = DetailItemClass.new("ItemRuleDetail", info, width, handler(self, self.refreshDetailList))
        self.list_detail:pushBackCustomItem(detailItem)
        table.insert( self.detailNodes, detailItem )
    end
end

function FeedBackView:refreshDetailList(detailNode)
    if not detailNode:isExtended() then
        -- 某个项取消展开了，更新布局就好了
        self.list_detail:forceDoLayout()
        return
    end

    -- 某个项展开了，需要将其他项折叠
    for i, item in ipairs(self.detailNodes) do
        if item ~= detailNode then
            item:setExtend(false)
        end
    end
    self.list_detail:forceDoLayout()
end

function FeedBackView:switchGameRule(gameId)
    -- 选择的游戏切换了
    self._gameId = gameId
    for i, btn in ipairs(self.gameNodes) do
        if btn.gameId ~= self._gameId then
            btn:setSelected(false)
        end
    end

    self:refreshDetail()
end

function FeedBackView:refreshDetail()
    if checkint(self._gameId) <= 0 or #(self.detailNodes) == 0 then
        return
    end

    -- 默认展开第一个 item
    for i, item in ipairs(self.detailNodes) do
        item:setExtend(i == 1)
    end

    local data = self.detailData[self._gameId]
    if data then
        -- 有本地缓存数据，直接显示
        self:setDetailData(data)
    else
        -- 将之前的 http 请求终止
        self:cancelHttpRequest()

        -- 将内容设置为 DETAIL_LOADING_STR
        self:setDetailData(DETAIL_LOADING_STR)

        -- 通过 web 接口获取数据
        self.curRequest = gg.Dapi:GetGameRule(self._gameId, function(data)
            if tolua.isnull(self) then return end
            self.curRequest = nil
            if data.status == -1 then
                self:setDetailData(data.msg or DETAIL_LOAD_FAILED_STR)
                return
            end

            -- 缓存数据
            self.detailData[self._gameId] = data
            -- 显示数据
            self:setDetailData(data)
        end)
    end

    --游戏名字更新
    if self.gamesList then
        local gameInfo = self.gamesList[self._gameId]
        local namestr = gameInfo.name.."-规则"
        self.rule_title_name:setString(namestr or "")
    end
end

function FeedBackView:setDetailData(data)
    if #(self.detailNodes) == 0 then
        return
    end

    if type(data)=="table" then
        self.detailNodes[1]:setDetailStr(data.update or "")       -- 设置最近更新数据
        self.detailNodes[2]:setDetailStr(data.rule or "")          -- 设置基本玩法数据
        self.detailNodes[3]:setDetailStr(data.settlement or "")   -- 设置结算说明数据
    else
        -- 是字符串，全部设置为指定的字符串
        for i, node in ipairs(self.detailNodes) do
            node:setDetailStr(data)
        end
    end
    self.list_detail:forceDoLayout()
end

-- 创建电话输入框
function FeedBackView:createPhoneEditBox()

    local function createPhoneEditBox_( size , palceholder )

        local edt = ccui.EditBox:create( size, "_" )
        edt:setPosition( cc.p( size.width / 2 + 20 , size.height / 2 ) )
        edt:setAnchorPoint( cc.p(0.5, 0.5) )
        edt:setPlaceHolder( palceholder or "" )
        --设置弹出键盘,EMAILADDR并不是设置输入文本为邮箱地址,而是键盘类型为方便输入邮箱地址,即英文键盘
        edt:setInputMode(cc.EDITBOX_INPUT_MODE_PHONENUMBER)
        -- edt:setPlaceholderFontColor( cc.c3b( 127, 127, 127 ) )
        edt:setFontColor( cc.c3b( 146, 62, 13 ) )
        edt:setFontSize( 34 )
        edt:setPlaceholderFontSize( 26 )
        return edt
    end

    -- 创建电话输入框
    local editBoxSize = self.img_phone:getContentSize()
    self._phoneInput = createPhoneEditBox_( cc.size( editBoxSize.width - 40, editBoxSize.height ), "请输入您的联系方式" ):addTo( self.img_phone )
end

-- 创建意见反馈输入框
function FeedBackView:createFeedEditBox( ... )

    local function createEditBox_( size, palceholder )
        local edt = ccui.EditBox:create( size, "_" )
        edt:setPosition( cc.p( size.width / 2 + 20 , size.height / 2 ) )
        edt:setAnchorPoint( cc.p( 0.5, 0.5 ) )
        edt:setPlaceHolder( palceholder or "" )
        edt:setFontSize( 0 )
        edt:setPlaceholderFontSize( 0 )
        edt:setOpacity( 0 )
        edt:setFontColor( cc.c4b( 146, 62, 13, 0 ) )
        return edt
    end
    local editBoxSize = self.img_input:getContentSize()
    self._input = createEditBox_( cc.size( editBoxSize.width - 40, editBoxSize.height), "" ):addTo(self.img_input)
    self._input:setSwallowTouches( false )
    self._input:setText(FEED_PLACEHOLDER_STR)    -- 不添加这段代码在真机上下面的label显示不出来

    -- 用于显示的文本,用于输入分行
    local label = cc.Label:create()
    label:setSystemFontSize( 26 )
    label:setTextColor(PLACE_HOLDER_COLOR)
    label:setAnchorPoint(cc.p(0,1))
    label:setPosition( cc.p( 23 , self.sv_feed:getInnerContainerSize().height - 10) )
    label:setWidth( self._input:getContentSize().width )
    label:setString(FEED_PLACEHOLDER_STR)
    self.sv_feed:addChild(label, 1)
    self.sv_feed:setScrollBarEnabled(false)

    -- 输入事件监听函数
    local handler = function(event)
        if event == "began" then
            local curStr = label:getString()
            if curStr == FEED_PLACEHOLDER_STR then
                self._input:setText("")
            else
                self._input:setText( curStr )
            end
        elseif event == "changed" then
            local str =  self._input:getText()
            label:setString(str)
            label:setTextColor( { r = 85 , g = 85, b = 85 } )
        elseif event == "ended" then

            local str = self._input:getText()
            self.massegeLabel = str
            print( self.massegeLabel )
            -- self._input:setText("")
            -- 获取意见反馈内容文本高度,超过显示区域时设置滑动控件的滑动区域
            local hTxt = label:getContentSize().height
            local innerSize = self.sv_feed:getInnerContainerSize()
            if hTxt > innerSize.height then
                self.sv_feed:setInnerContainerSize( { width = innerSize.width, height = hTxt } )
                self.sv_feed:setTouchEnabled(true)
                label:setPosition( cc.p( 23, hTxt ) )
            end
            -- 输入文本为空时
            if string.len( str ) == 0 or str == nil then
                label:setString(FEED_PLACEHOLDER_STR)
                label:setTextColor(PLACE_HOLDER_COLOR)
            end
        end
    end
    self._input:registerScriptEditBoxHandler( handler )
end

--[[
* @brief 发送点击事件
]]
function FeedBackView:onClickCommit( sender )

	-- 播放点击音效
    gg.AudioManager:playClickEffect()

    -- 有上传图片先拼接图片url
    local photoUrlpath = nil
    if self.storePhotoUrl then
        photoUrlpath = self.storePhotoUrl[1]
        local pingJie = "||"
        for i = 1 , #self.storePhotoUrl do
            if #self.storePhotoUrl == 1 then
                photoUrlpath = self.storePhotoUrl[i]
            elseif #self.storePhotoUrl > 1 then
                if self.storePhotoUrl[ i + 1 ] then
                photoUrlpath = photoUrlpath..pingJie..self.storePhotoUrl[i+1]
            end
            end
        end
    end

    -- 意见和图片二者中只要存在一个就可以上传
    if self.massegeLabel ~= nil or photoUrlpath then

        -- 电话号可填可不填,填写的话判断电话号码格式
        local phoneNum = self._phoneInput:getText()
        if string.len( phoneNum ) == 0 or (string.len( phoneNum )>0 and string.len( phoneNum ) ~= 11) then
            self:showToast( "请填写正确的电话号码。" )
            return
        end

        -- 请求意见反馈
        gg.Dapi:FeedBack( Helper.GetDeviceCode() , checkint(self._gameId), 0 ,self.massegeLabel or "用户没有输入文本！", phoneNum , photoUrlpath, function( a )
            if a and a.status == 0 then
                GameApp:dispatchEvent(gg.Event.SHOW_TOAST,"意见已成功提交,感谢您的反馈！")
            end
        end)

        self:removeSelf()
    else
        self:showToast( "您还未填写意见反馈或上传图片。" )
    end
end

function FeedBackView:imgPicked(imgfullpath)
    gg.InvokeFuncNextFrame(function()
        --display.removeImage(imgfullpath)

        --printf("----- path "..imgfullpath)
        -- 测试图片路径
        --local imgfullpath = "F:/project/WLGameHall/res/hall/bag/item_bg.png"

        -- 验证上传路径
        if imgfullpath and string.len(imgfullpath) > 0 then

              if self.addPhotoCount >= picLimitCount or self.scuccesCount >= picLimitCount then

               --GameApp:dispatchEvent(gg.Event.SHOW_TOAST,"添加图片达到上限,请勿继续添加!")
                  return false
               end

               -- 添加本地图片到意见反馈面板
               self:createUploadImg( imgfullpath )

               -- 达到添加上线隐藏添加按钮
               if self.addPhotoCount >= picLimitCount then
                   self.btn_add_img:setVisible( false )
               end

            -- 调用上传图片接口
            gg.Dapi:UploadCloudimg(imgfullpath,function (result)

                -- 上传图片回调
                if result and result.status == 0 then

                    -- 图片上传反馈的URL
                     local photoUrl = result.url
                     table.insert(self.storePhotoUrl,photoUrl)
                     self.scuccesCount = self.scuccesCount +1

                     -- 关闭等待动画
                     if self._uploadNode[ imgfullpath ] then
                         self._uploadNode[ imgfullpath ]:getChildByName("img_mask"):removeFromParent( true )
                     end

                else
                    GameApp:dispatchEvent(gg.Event.SHOW_TOAST,"上传失败,请重新添加！")
                    local uploadNode = self._uploadNode[ imgfullpath ]
                    local closeBtn = uploadNode:getChildByName("btn_close")
                    self:onCilckDeletePicBtn(closeBtn)
                end

            end)

        else

            --GameApp:dispatchEvent(gg.Event.SHOW_TOAST,"图片选取失败,请重试！")
        end

    end)
end

--[[
* @brief 添加图片按钮
]]
function FeedBackView:onClickAddImg( sender )

    -- 设备上传图片接口
    device.callImagePicker("library", handler(self, self.imgPicked), false)
end

--[[
* @brief 获取可添加图片的5个节点位置
* @param index 位置索引
]]
function FeedBackView:getAddBtnPosition( index )
    local x = self.addBtnX + ( index % 2 ) * 160
    local y = self.addBtnY - math.floor( index / 2  ) * 160

    return x , y
end

--[[
* @brief 创建上传的图片
]]
function FeedBackView:createUploadImg( imgfullpath )

     -- 第一次点击获取添加按钮位置
     local addBtn = self.btn_add_img
    self.addBtnSize = addBtn:getContentSize().width

    local node = require("ui/common/pop_feed_upload_img.lua").create()
    local img = node.root:getChildByName("img_bg")

    -- 删除按钮
    local closeBtn = img:getChildByName("btn_close")
    closeBtn:addClickEventListener( handler( self, self.onCilckDeletePicBtn ) )

    -- 照片缩放
    local bound = img:getBoundingBox()
    local photoWidth = bound.width
    local photoHeight = bound.height
    local BtnWidth = addBtn:getContentSize().width
    local BtnHeight = addBtn:getContentSize().height
    if photoWidth ~= BtnWidth or photoHeight ~= BtnHeight  then
        local scaleX = BtnWidth/photoWidth
        local scaleY = BtnHeight/photoHeight
        img:setScaleX(scaleX)
        img:setScaleY(scaleY)
    end
    -- 设置图片位置
    local phontoX , phontoY = addBtn:getPosition()
    node.root:setPosition( cc.p( phontoX , phontoY ) )

    self.btn_add_img:getParent():addChild( node.root )
    table.insert( self.storePhoto , node.root )

    local x1 = addBtn:getPositionX()
    local y1 = addBtn:getPositionY()

    -- 切换成玩家从相册中选择的照片
    img:loadTexture(imgfullpath)

    --    设置添加图片按钮的位置
    if img then
        self.addPhotoCount = self.addPhotoCount + 1

        local x , y = self:getAddBtnPosition( self.addPhotoCount )
        addBtn:setPosition( cc.p( x , y ) )
    end

    -- 开启旋转动画
    local loading = img:getChildByName("img_mask"):getChildByName("img_loading")
    loading:runAction( cc.RepeatForever:create( cc.RotateBy:create( 0.3 , 180 ) ) )

    self._uploadNode[ imgfullpath ] = img

end

-- 删除图片
function FeedBackView:onCilckDeletePicBtn( sender )

    local addBtn = self.btn_add_img
    -- 添加的图片数量-1
    self.addPhotoCount = self.addPhotoCount - 1
    -- 上传成功数量-1
    self.scuccesCount = self.scuccesCount -1
    -- 删除后没达到添加上线显示添加按钮
    if self.addPhotoCount < picLimitCount then
        self.btn_add_img:setVisible( true )
    end
    -- 删除对应位置的存储数据
    for k,v in pairs(self.storePhoto) do
        if v == sender:getParent():getParent() then

             table.remove(self.storePhoto,k)
             table.remove(self.storePhotoUrl,k)
        end
    end
    sender:getParent():getParent():removeFromParent(true)

    --重新设置位置
    if #self.storePhoto > 0  then

        for i = 1 , #self.storePhoto do
            local x , y = self:getAddBtnPosition(i - 1 )
            self.storePhoto[i]:setPosition( cc.p( x , y ) )
        end
    end

    local finalX , finalY = self:getAddBtnPosition( self.addPhotoCount )
    self.btn_add_img:setPosition( cc.p( finalX , finalY ) )

end

function FeedBackView:onClickClose()
    self:removeSelf()
end

function FeedBackView:onClickService()
    -- 播放点击音效
    gg.AudioManager:playClickEffect()
    --if self.serviceTag then
    --    device.callCustomerServiceApi(self.serviceTag)
    --end
	device.callCustomerServiceApi(ModuleTag.FeedBack)
end

function FeedBackView:selectTab(idxTag)

    local tab = "btn_" .. idxTag
    if tab == "btn_rule" then
        self.nd_rule:setVisible(true)
        self.nd_feed:setVisible(false)
        self.btn_rule:setColor(TAB_SELECT_COLOR)
        self.btn_feedback:setColor(TAB_UNSELECT_COLOR)
    else
        self.nd_feed:setVisible(true)
        self.nd_rule:setVisible(false)
        self.btn_rule:setColor(TAB_UNSELECT_COLOR)
        self.btn_feedback:setColor(TAB_SELECT_COLOR)
    end
end

function FeedBackView:keyBackClicked()
    self:removeSelf()
    return true, true
end

--[[
    * @brief 规则点击事件
--]]
function FeedBackView:onClickRule()
    -- 播放点击音效
    gg.AudioManager:playClickEffect()

    self.nd_feed:setVisible(false)
    self.nd_rule:setVisible(true)
    self.btn_rule:setColor(TAB_SELECT_COLOR)
    self.btn_feedback:setColor(TAB_UNSELECT_COLOR)
end

--[[
    *@brief 反馈点击事件
--]]
function FeedBackView:onClickFeedback()
    -- 播放点击音效
    gg.AudioManager:playClickEffect()

    self.nd_feed:setVisible(true)
    self.nd_rule:setVisible(false)
    self.btn_rule:setColor(TAB_UNSELECT_COLOR)
    self.btn_feedback:setColor(TAB_SELECT_COLOR)
end

return FeedBackView
