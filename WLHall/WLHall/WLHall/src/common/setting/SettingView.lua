
--
-- Author: zhaoxinyu
-- Date: 2016-11-17 16:19:29
-- Describe：设置界面

local SettingView = class("SettingView", cc.load("ViewPop"))

SettingView.RESOURCE_FILENAME = "ui/common/seting.lua"
SettingView.CLOSE_ANIMATION = true
SettingView.RESOURCE_BINDING = {
    ["panel_bg"]   = { ["varname"] = "panel_bg"   },    -- 底层半透明背景
    ["img_bg_"]    = { ["varname"] = "img_bg_"    },    -- 里层背景
    ["txt_music"]  = { ["varname"] = "txt_music"  },    -- 音乐文本
    ["txt_effect"] = { ["varname"] = "txt_effect" },    -- 音效文本
    ["txt_fyyy"]   = { ["varname"] = "txt_fyyy"   },    -- 方言语音
    ["txt_jy"]     = { ["varname"] = "txt_jy"     },    -- 静音
    ["img_djcp"]   = { ["varname"] = "img_djcp"   },    -- 单击出牌
    ["img_fdcp"]   = { ["varname"] = "img_fdcp"   },    -- 放大出牌
    ["node_mj"]    = { ["varname"] = "node_mj"    },    -- 麻将显示节点
    ["node_pk"]    = { ["varname"] = "node_pk"    },    -- 扑克显示节点
    ["node_dt"]    = { ["varname"] = "node_dt"    },    -- 大厅显示节点
    ["cb_click"]   = { ["varname"] = "cb_click"   },    -- 加注方式：按钮
    ["cb_slide"]   = { ["varname"] = "cb_slide"   },    -- 加注方式：滑块
    ["lineV"]      = { ["varname"] = "lineV"      },
    ["img_avatar"]  = { ["varname"] = "img_avatar"   },
    ["txt_userid"]  = { ["varname"] = "txt_userid"   },  -- id
    ["txt_nickname"]= { ["varname"] = "txt_nickname" },  -- 昵称
    ["node_common"] = { ["varname"] = "node_common"  },  -- 按钮通用容器    
    ["btn_qihuan"]  = { ["varname"] = "btn_qihuan", ["events"] = { { event = "click", method = "onClickSwitch" } } }, -- 切换帐号
    ["btn_close"]   = { ["varname"] = "btn_close",  ["events"] = { { event = "click_color", method = "onClickClose"  } } }, -- 关闭按钮
}

-- 组件标示
SettingView.WIDGETS_MARK = {
    WIDGETS_MUSIC = 1,                  -- 音乐
    WIDGETS_EFFECT = 2,                 -- 音效
    WIDGETS_DIALECT = 3,                -- 方言语音
    WIDGETS_CLICK_OUT_CARD = 4,         -- 单击出牌
    WIDGETS_ENLARGECARD_OUT_CARD = 5,   -- 放大出牌
    WIDGETS_MUTE = 6,                   -- 静音
    WIDGETS_BET_TYPE = 7,               -- 加注方式
    WIDGETS_CARD_BG_STYLE = 8,          -- 牌背面图案
    WIDGETS_HALL_BG_STYLE = 9,          --大厅背景图案
}

-- 是否外部创建
local isCreate = false

--[[
* @brief 创建
* @parm shortname 短名
* @parm backgroundmusicpath 背景音乐路径
]]
function SettingView:create( shortname, backgroundmusicpath )
    -- 线处理
    gg.LineHandle(self.lineV)

    if not shortname then
        return
    end

    if type(shortname) ~= "string" then
        return
    end

    isCreate = true
    return self.new(nil, "SettingView", shortname , backgroundmusicpath )
end

function SettingView:onCreate( shortname, backgroundmusicpath )
    self:init( shortname, backgroundmusicpath )
    self:createUserAvatar()
    --自适应
    self:setScale(display.scaleX)

    self:initView()
end

--[[
* @brief 初始化数据
]]
function SettingView:init( shortname, backgroundmusicpath )
    -- 游戏短名(空为大厅)
    self._shortname = shortname
    -- 背景音乐路径
    self._backgroundmusicpath = backgroundmusicpath
    -- 音乐开关
    self._music = nil
    self._musicEnable = true
    -- 音效开关
    self._effect = nil
    self._effectEnable = true
    -- 方言开关
    self._fyyy = nil
    -- 静音开关
    self._btnJy = nil
    -- 单击出牌开关
    self._djcp = nil
    -- 放大出牌开关
    self._fdcp = nil
    -- 加注方式按钮组
    self._jzBtnTb = {}
    -- 牌背图片按钮组
    self._hpBtnTb = {}
    -- 牌背图片组
    self._hpImgTb = {}
    --大厅图片按钮组
    self._hlBtnTb = {}

    -- 组件状态回调
    self._cb = nil
    -- 设置管理者
    self._settingManager = nil
end

--[[
* @brief 初始化界面
]]
function SettingView:initView()
    self.panel_bg:setContentSize( cc.size( display.width, display.height ) )

    -- 读取该游戏的所有开关状态
    local settingManager = require("common.setting.SettingManager")
    self._settingManager = settingManager

    -- 开关控件
    local ControlSwitch = require("common.widgets.SwitchButton")

    -- 开关x坐标
    local swX = 153
    local swY = -10
    local mjX = 140

    -- 创建音乐开关
    local music = ControlSwitch:create(nil, handler(self, self.onSwitchChanged))
    music:setPositionX(swX)
    music:setPositionY(swY)
    self.txt_music:addChild(music)
    self._music = music
    music:setTag(SettingView.WIDGETS_MARK.WIDGETS_MUSIC)
    music:setOn(settingManager:GetMusicState(self._shortname))
    music:setEnabled(not settingManager:GetMuteState())

    -- 创建音效开关
    local effect = ControlSwitch:create(nil, handler(self, self.onSwitchChanged))
    effect:setPositionX(swX)
    effect:setPositionY(swY + 2)
    self.txt_effect:addChild(effect)
    self._effect = effect
    effect:setTag(SettingView.WIDGETS_MARK.WIDGETS_EFFECT)
    effect:setOn(settingManager:GetEffectState())
    effect:setEnabled(not settingManager:GetMuteState())

    -- 方言语音开关
    local fyyy = ControlSwitch:create(nil, handler(self, self.onSwitchChanged))
    fyyy:setPositionX(swX)
    fyyy:setPositionY(swY)
    self.txt_fyyy:addChild(fyyy)
    self._fyyy = fyyy
    fyyy:setTag(SettingView.WIDGETS_MARK.WIDGETS_DIALECT)
    fyyy:setOn(settingManager:GetDialectState(self._shortname))

    -- 单击出牌开关
    local djcp = ControlSwitch:create(nil, handler(self, self.onSwitchChanged))
    djcp:setPositionX(mjX)
    djcp:setPositionY(swY)
    self.img_djcp:addChild(djcp)
    self._djcp = djcp
    djcp:setTag(SettingView.WIDGETS_MARK.WIDGETS_CLICK_OUT_CARD)
    djcp:setOn(settingManager:GetClickOutCardState(self._shortname))

    -- 放大出牌开关
    local fdcp = ControlSwitch:create(nil, handler(self, self.onSwitchChanged))
    fdcp:setPositionX(mjX)
    fdcp:setPositionY(swY)
    self.img_fdcp:addChild(fdcp)
    self._fdcp = fdcp
    fdcp:setTag(SettingView.WIDGETS_MARK.WIDGETS_ENLARGECARD_OUT_CARD)
    fdcp:setOn(settingManager:GetClickEnlargeCardState(self._shortname))

    -- 创建静音开关
    local btnJy = ControlSwitch:create(nil, handler(self, self.onCheckBoxEvent))
    btnJy:setPositionX(swX)
    btnJy:setPositionY(swY + 2)
    self.txt_jy:addChild(btnJy)
    self._btnJy = btnJy
    btnJy:setTag(SettingView.WIDGETS_MARK.WIDGETS_MUTE)
    btnJy:setOn(settingManager:GetMuteState())

    -- 按钮加注方式
    self.cb_click.tag = 1
    self.cb_click:setSelected( settingManager:GetBetTypeState(self._shortname) == 1 )
    self.cb_click:addEventListener( handler( self, self.onClickSetBetType ) )
    table.insert( self._jzBtnTb, self.cb_click )

    -- 按钮加注方式
    self.cb_slide.tag = 2
    self.cb_slide:setSelected( settingManager:GetBetTypeState(self._shortname) == 2 )
    self.cb_slide:addEventListener( handler( self, self.onClickSetBetType ) )
    table.insert( self._jzBtnTb, self.cb_slide )

    -- 根据游戏类型来显示不同节点
    if hallmanager and hallmanager:IsConnected() then
        local shortname = string.gsub(self._shortname, "_f", "")
        local game = hallmanager:GetGameByShortName( shortname )
        if game then
            self.lineV:setPositionX(330)
            if Helper.And( game.type , GAME_GROUP_POKER ) ~= 0 then
                self.node_pk:setVisible( true )
                self.node_mj:setVisible( false )
                self.node_dt:setVisible( false )
                for i=1,3 do
                    local img_pk = self.node_pk:getChildByName("img_pk"..i)
                    img_pk:onClick( handler( self, self.onTouchCardBg ) )
                    img_pk.tag = i
                    table.insert( self._hpImgTb, img_pk )

                    local cb_pk = img_pk:getChildByName("cb_pk"..i)
                    cb_pk.tag = i
                    cb_pk:setSelected( settingManager:GetCardBgStyleState(self._shortname) == i )
                    cb_pk:addEventListener( handler( self, self.onClickSetCardBg ) )
                    table.insert( self._hpBtnTb, cb_pk )
                end
            elseif Helper.And( game.type , GAME_GROUP_MAHJONG ) ~= 0 then
                self.node_pk:setVisible( false )
                self.node_mj:setVisible( true )
                self.node_dt:setVisible( false )
                for i=1,3 do
                    local img_mj = self.node_mj:getChildByName("img_mj"..i)
                    img_mj:onClick( handler( self, self.onTouchCardBg ) )
                    img_mj.tag = i
                    table.insert( self._hpImgTb, img_mj )

                    local cb_mj = img_mj:getChildByName("cb_mj"..i)
                    cb_mj.tag = i
                    cb_mj:setSelected( settingManager:GetCardBgStyleState(self._shortname) == i )
                    cb_mj:addEventListener( handler( self, self.onClickSetCardBg ) )
                    table.insert( self._hpBtnTb, cb_mj )
                end
            end
        else

            self.node_pk:setVisible( false )
            self.node_mj:setVisible( false )
            if not hallmanager or not hallmanager.userinfo then return end
            local userinfo = hallmanager.userinfo
            -- 设置玩家昵称 & ID
            self.node_dt:findNode("txt_name"):setString(userinfo.nick)
            self.node_dt:findNode("txt_id"):setString(userinfo.id)
            -- 加载用户头像
            local avatarPath = gg.IIF(userinfo.sex == 1, "common/hd_male.png", "common/hd_female.png")
            if userinfo.avatar == 0xFFFFFFFF then
                avatarPath = userinfo.avatarurl
                gg.ImageDownload:LoadUserAvaterImage({url = avatarPath, ismine = true, image = self._avatar}, function()
                    self._avatar:setScale(120/self._avatar:getContentSize().width)
                end)
            else
                self._avatar:loadTexture(avatarPath)
                self._avatar:setScale(120/self._avatar:getContentSize().width)
            end
        end
    end

    -- 服务端指定要关闭暂未实现的功能，功能实现后一定要去掉
    if not GameApp:CheckModuleEnable(ModuleTag.Unimplemented) then
        self.txt_fyyy:setVisible(false)
        self.node_pk:setVisible(false)
        self.node_mj:setVisible(false)
    end
end

function SettingView:createUserAvatar()
    local imgBg = self.node_dt:findNode("img_kuan")
    -- 创建头像
    local drawNode = gg.DrawNodeRoundRect(cc.DrawNode:create(),cc.rect(0,0,115,-116), 1, 8, cc.c4b(0, 0, 0, 1), cc.c4f(0, 0, 0, 1))
    local clipNode = cc.ClippingNode:create(drawNode)
	clipNode:setInverted(false)
    clipNode:setPosition(0, 0)
    imgBg:addChild(clipNode)

    self._avatar = ccui.ImageView:create("common/hd_male.png")
    self._avatar:setPosition(115/2, 116/2)
    self._avatar:ignoreContentAdaptWithSize(true)

    clipNode:addChild(self._avatar)
end

--[[
* @brief 切换账号点击事件
]]
function SettingView:onClickSwitch(sender)
    -- 播放点击音效
	gg.AudioManager:playClickEffect()
	gg.LoginHelper:DoLogout()	-- 第三方渠道账号登出
	GameApp:Logout()
end


-- 设置加注方式按钮是否可以点击
function SettingView:setBetTypeBtnTouchEnabled( isEnabled )
    for i,v in ipairs(self._jzBtnTb) do
        v:setEnabled( isEnabled )
    end
end

-- 设置换牌按钮是否可以点击
function SettingView:setCardBgStyleBtnTouchEnabled( isEnabled )
    for i,v in ipairs(self._hpBtnTb) do
        v:setEnabled( isEnabled )
    end
    for i,v in ipairs(self._hpImgTb) do
        v:setTouchEnabled( isEnabled )
    end
end

-- 加注按钮点击事件
function SettingView:onClickSetBetType( sender )
    for i,v in ipairs(self._jzBtnTb) do
        v:setSelected( false )
        if v==sender then
            v:setSelected( true )
        end
    end
    if self._cb then
        local tag = sender.tag
        self._settingManager:SetStateByMark( self._shortname, SettingView.WIDGETS_MARK.WIDGETS_BET_TYPE, tag )
        self._cb( SettingView.WIDGETS_MARK.WIDGETS_BET_TYPE, tag )
    end
end

function SettingView:onTouchCardBg( sender )
    local tag = sender.tag
    if self._hpBtnTb[tag] then
        self:onClickSetCardBg( self._hpBtnTb[tag] )
    end
end

-- 换牌按钮点击事件
function SettingView:onClickSetCardBg( sender )
    for i,v in ipairs(self._hpBtnTb) do
        v:setSelected( false )
        if v==sender then
            v:setSelected( true )
        end
    end
    if self._cb then
        local tag = sender.tag
        self._settingManager:SetStateByMark( self._shortname, SettingView.WIDGETS_MARK.WIDGETS_CARD_BG_STYLE, tag )
        self._cb( SettingView.WIDGETS_MARK.WIDGETS_CARD_BG_STYLE, tag )
    end
end

--[[
* @brief 开关事件
]]
function SettingView:onSwitchChanged(sender, isOn)
    if self._cb then
        -- 存储设置
        self._settingManager:SetStateByMark(self._shortname, sender:getTag(), isOn)
        self._cb(sender:getTag(), isOn)
        -- 开关背景音乐
        if sender:getTag() == SettingView.WIDGETS_MARK.WIDGETS_MUSIC then
            if isOn then
                if self._backgroundmusicpath then
                    gg.AudioManager:playBackgroundMusic( self._backgroundmusicpath , self._shortname )
                end
            else
                gg.AudioManager:stopBackgroundMusic()
            end
        end
    end
end

function SettingView:setGameSwitchEnabled(bo)
    -- 方言开关
    self._fyyy:setEnabled(bo)
    -- 单击出牌开关
    self._djcp:setEnabled(bo)
    -- 放大出牌开关
    self._fdcp:setEnabled(bo)
end

--[[
* @brief 复选事件
]]
function SettingView:onCheckBoxEvent(sender, isOn)
    if self._cb then
        -- 存储设置
        self._settingManager:SetMuteState(isOn)
        self._cb(SettingView.WIDGETS_MARK.WIDGETS_MUTE, isOn)

        -- 设置音乐、音效不可用
        if self._musicEnable then
            self._music:setEnabled(not isOn)
        end
        if self._effectEnable then
            self._effect:setEnabled(not isOn)
        end

        -- 静音开关
        if isOn then
            gg.AudioManager:stopBackgroundMusic()
        else
            if not self._musicEnable then return end
            if self._backgroundmusicpath then
                gg.AudioManager:playBackgroundMusic( self._backgroundmusicpath , self._shortname )
            end
        end
    end
end

--[[
* @brief 关闭事件
]]
function SettingView:onClickClose(sender)
    if isCreate then
        self:removeSelf(true);
    else
        self:postKeyBackClick()
    end
end

--[[
* @brief 注册控件状态回调
* @parm cb 回调函数  函数原型  function cb( SettingView.WIDGETS_MARK , isOn ) end
]]
function SettingView:registerWidgetsCb(cb)
    self._cb = cb
end

--[[
* @brief 设置开关禁用
* @parm mark 需要禁用的开关  mark：SettingView.WIDGETS_MARK
]]
function SettingView:setEnabled( mark , isEnabled )

  if SettingView.WIDGETS_MARK.WIDGETS_DIALECT == mark then

    self._fyyy:setEnabled( isEnabled )

  elseif SettingView.WIDGETS_MARK.WIDGETS_CLICK_OUT_CARD == mark then

    self._djcp:setEnabled(isEnabled)

  elseif SettingView.WIDGETS_MARK.WIDGETS_ENLARGECARD_OUT_CARD == mark then

    self._fdcp:setEnabled(isEnabled)

  elseif SettingView.WIDGETS_MARK.WIDGETS_MUSIC == mark then

    self._musicEnable = isEnabled
    self._music:setEnabled(isEnabled)

  elseif SettingView.WIDGETS_MARK.WIDGETS_EFFECT == mark then

    self._effectEnable = isEnabled
    self._effect:setEnabled(isEnabled)

  end

end


--[[
* @brief 设置开关禁用
* @parm mark 需要禁用的开关  mark：SettingView.WIDGETS_MARK
]]
function SettingView:setOn( mark , isSelected )

  if SettingView.WIDGETS_MARK.WIDGETS_DIALECT == mark then

    self._fyyy:setOn( isSelected )

  elseif SettingView.WIDGETS_MARK.WIDGETS_CLICK_OUT_CARD == mark then

    self._djcp:setOn(isSelected)

  elseif SettingView.WIDGETS_MARK.WIDGETS_ENLARGECARD_OUT_CARD == mark then

    self._fdcp:setOn(isSelected)

  elseif SettingView.WIDGETS_MARK.WIDGETS_MUSIC == mark then

    self._music:setOn(isSelected)

  elseif SettingView.WIDGETS_MARK.WIDGETS_EFFECT == mark then

    self._effect:setOn(isSelected)

  end

end


--[[
* @brief 设置方言是否禁用
* @parm isEnabled 是否禁用
]]
function SettingView:setDialectEnabled( isEnabled )
    self:setEnabled( SettingView.WIDGETS_MARK.WIDGETS_DIALECT , isEnabled )
    -- 关闭方言
    if isEnabled == false then
        self._settingManager:SetStateByMark(self._shortname, SettingView.WIDGETS_MARK.WIDGETS_DIALECT , isEnabled)
    end
end

--[[
* @brief 设置单击出牌是否禁用
]]
function SettingView:setClickOutCardEnabled( isEnabled )
    self:setEnabled( SettingView.WIDGETS_MARK.WIDGETS_CLICK_OUT_CARD , isEnabled )
end

--[[
* @brief 设置放大出牌是否禁用
]]
function SettingView:setEnlargecardOutCardEnabled( isEnabled )
    self:setEnabled( SettingView.WIDGETS_MARK.WIDGETS_ENLARGECARD_OUT_CARD , isEnabled )
end

return SettingView