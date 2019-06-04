
-- Author: LiAchen
-- Date: 2018-09-21
-- Describe：完善用户资料

local MatchApplyView = class("MatchApplyView" , cc.load("ViewPop"))

MatchApplyView.RESOURCE_FILENAME = "ui/room/match/match_apply_view.lua"

MatchApplyView.RESOURCE_BINDING = {

    ["panel_bg"] = { ["varname"] = "panel_bg" },
    ["btn_close"]   = { ["varname"] = "btn_close" ,["events"]={{event="click",method="onClickClose"}} },    -- 关闭按钮

    ["input_name"] = { ["varname"] = "input_name" },           --姓名
    ["input_phone"] = { ["varname"] = "input_phone" },         --手机号
    ["input_identity"] = { ["varname"] = "input_identity" },   --身份证

    ["btn_apply"]   = { ["varname"] = "btn_apply" ,["events"]={{event="click",method="onClickApply"}} },    --

    ["input_province"] = { ["varname"] = "input_province" }, --省份

    ["input_city"] = { ["varname"] = "input_city" },  --城市

}

--输入数据
MatchApplyView.INPUT_DATA=
{
    [1] = "",   -- 姓名
    [2] = "",   -- 电话
    [3] = "",   -- 身份证
    [4] = "",   -- 省份
    [5] = "",   -- 城市
    [6] = "",   -- 电视台id
}

--按钮数据
MatchApplyView.BTN_DATA_TYPES =
{
    input_name = 1,     -- 姓名
    input_phone = 2,    -- 电话
    input_identity = 3, -- 身份证
    input_province = 4, -- 省份
    input_city = 5,     -- 城市
    input_tvid = 6,     -- 电视台id
}

--[[
* @brief 创建
]]
function MatchApplyView:onCreate(tvId)
    self.btn_apply:setAllGray(true)
    self.btn_apply:setTouchEnabled(false)
    --自适应
    self:setScale(math.min(display.scaleX, display.scaleY))

    self.input_province:onClick(handler(self, self.onClickProvince))  --省份按钮
    self.input_city:onClick(handler(self, self.onClickCity))  --省份按钮
    self:init()

    -- 设置电台id，用于记录用户是从哪个电视台路口记录的
    self:setUserData(MatchApplyView.BTN_DATA_TYPES.input_tvid, checkint(tvId))
end

function MatchApplyView:init()
    self.btnTb = {self.input_name,self.input_phone,self.input_identity,self.input_province,self.input_city,}

    local function createEditBox_(size, palceholder, inputflag)
        local edt = ccui.EditBox:create(size, "_")
        edt:setPosition(cc.p(size.width / 2 + 135, size.height / 2 +2))
        edt:setAnchorPoint(cc.p(0.5, 0.5))
        edt:setPlaceHolder(palceholder or "")

        --设置弹出键盘,EMAILADDR并不是设置输入文本为邮箱地址,而是键盘类型为方便输入邮箱地址,即英文键盘
        edt:setInputMode(cc.EDITBOX_INPUT_MODE_EMAILADDR)
        edt:setInputFlag(inputflag or cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_ALL_CHARACTERS)
        edt:setPlaceholderFontColor(cc.c3b(169,169,169))
        edt:setFontColor(cc.c3b(34, 34, 34))
        edt:setFontSize(32)
        edt:setMaxLength(20)
        edt:setPlaceholderFontSize(32)
        return edt
    end

    -- 创建密码输入框
    local editBoxSize = self.input_name:getContentSize()
    -- 姓名
    self.editName = createEditBox_(cc.size(editBoxSize.width -200, editBoxSize.height), "请输入姓名"):addTo(self.input_name):posBy(30, -4)
    self:inputMonitor(self.editName,self.input_name)

    -- 手机号
    self.editPhone = createEditBox_(cc.size(editBoxSize.width -200, editBoxSize.height), "请输入手机号"):addTo(self.input_phone):posBy(30, -4)
    -- 输入事件监听函数  手机号
    self:inputMonitor(self.editPhone,self.input_phone)

    --身份证
    self.editIdentity = createEditBox_(cc.size(editBoxSize.width -200, editBoxSize.height), "请输入身份证号"):addTo(self.input_identity):posBy(30, -4)
    self:inputMonitor(self.editIdentity,self.input_identity)

    for k,v in pairs(self.btnTb) do
        local line = v:getChildByName("img_line")
        if line then
            gg.LineHandle(line)
        end
    end
end

function MatchApplyView:inputMonitor(edit_1,input_1)

    local handler = function(event)
        if event == "ended" then

            local str = edit_1:getText()
            input_1:getChildByName("img_right"):setVisible(false)
            input_1:getChildByName("img_wrong"):setVisible(true)
            if string.len( str ) == 0 or str == nil then
                self:showBtn()
                return
            end

            if edit_1 == self.editName then --姓名
                local l=string.len(str)
                local isChinese = true
                for i=1,l do
                    local asc2=string.byte(string.sub(str,i,i))
                    if asc2<=127 then  --有字母
                        isChinese = false
                    end
                end
                if  string.len( str )  >= 6 and  string.len( str ) <= 12 and isChinese then
                    input_1:getChildByName("img_right"):setVisible(true)
                    input_1:getChildByName("img_wrong"):setVisible(false)
                    self:setUserData(MatchApplyView.BTN_DATA_TYPES.input_name,str)
                end
            end
            if edit_1 == self.editPhone then  --手机号
                local isPhone = string.match(str, "^[0-9]*$")
                if  string.len( str )  == 11 and isPhone then
                    input_1:getChildByName("img_right"):setVisible(true)
                    input_1:getChildByName("img_wrong"):setVisible(false)
                    self:setUserData(MatchApplyView.BTN_DATA_TYPES.input_phone,str)
                end
            end
            if edit_1 == self.editIdentity then  --身份证号
                local isIdentity=  string.match(str, "^[A-Za-z0-9]+$")
                if  string.len( str )  == ID_CARD_LEN and isIdentity then
                    input_1:getChildByName("img_right"):setVisible(true)
                    input_1:getChildByName("img_wrong"):setVisible(false)
                    self:setUserData(MatchApplyView.BTN_DATA_TYPES.input_identity,str)
                end
            end
            self:showBtn()
        end
    end
    edit_1:registerScriptEditBoxHandler( handler )

end

function MatchApplyView:setUserData(btnType,data)
    MatchApplyView.INPUT_DATA[btnType] = data
end

function MatchApplyView:onClickProvince()
    local MatchAreaView = self:getScene():createView("match.MatchAreaView",1, checkint(self.idx))
    MatchAreaView:pushInScene()
    MatchAreaView:setCallback(handler(self, self.setProvince))
end

function MatchApplyView:onClickCity()
    if not self.btnProvinceData then
        GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "请完成省份输入！")
        return
    end

    local MatchAreaView = self:getScene():createView("match.MatchAreaView",2, checkint(self.cityidx),self.btnProvinceData)
    MatchAreaView:pushInScene()
    MatchAreaView:setCallback(handler(self, self.setCity))
end

--设置城市回调
function MatchApplyView:setCity(data,idx)
    self.cityidx = idx
    self.input_city:getChildByName("img_right"):setVisible(true)
    local txt_city = self.input_city:getChildByName("txt_cs")
    txt_city:setString(data[2])
    --设置城市
    self:setUserData(MatchApplyView.BTN_DATA_TYPES.input_city,data[2])
    txt_city:setVisible(true)

    self:showBtn()
end

--设置省份回调
function MatchApplyView:setProvince(data,idx)
    self.idx = idx
    self.btnProvinceData = data[1]
    self.input_province:getChildByName("img_right"):setVisible(true)
    local txt_sheng = self.input_province:getChildByName("txt_sheng")
    txt_sheng:setString(data[2])
    --设置城市
    self:setUserData(MatchApplyView.BTN_DATA_TYPES.input_province,data[2])
    txt_sheng:setVisible(true)
    --隐藏城市选择
    self.cityidx = 0
    local txt_city = self.input_city:getChildByName("txt_cs")
    txt_city:setVisible(false)
    self.input_city:getChildByName("img_right"):setVisible(false)

    self:showBtn()
end

--判断按钮是否可以点击
function MatchApplyView:showBtn()
    local isOpen = true
    for i=1,#self.btnTb do
        local btn = self.btnTb[i]:getChildByName("img_right")
        --按钮的判断
        if not btn:isVisible() then
            isOpen = false
            break
        end
    end
    self.btn_apply:setAllGray(not isOpen)
    self.btn_apply:setTouchEnabled(isOpen)
end

function MatchApplyView:onClickClose()
    self:removeSelf()
end

--提交按钮
function MatchApplyView:onClickApply()
    gg.Dapi:UploadUserTvData(MatchApplyView.INPUT_DATA, function(result)
        result = checktable(result)
        if result.status and checkint(result.status) == 0 then
            GameApp:dispatchEvent(gg.Event.SHOW_TOAST, "资料提交成功！")
            gg.UserData:setTvMatchDataIntegrity()
            if tolua.isnull(self) then return end
            self:onClickClose()
        elseif checkint(result.status) ~= 99 then
            GameApp:dispatchEvent(gg.Event.SHOW_TOAST, result.msg or "资料提交失败，请重试！")
        end
    end)
end

return MatchApplyView