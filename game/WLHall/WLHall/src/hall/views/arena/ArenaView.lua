-- Author: 李阿城
-- Date: 2018/3/11
-- Describe：擂台赛界面

local ArenaView = class("ArenaView",cc.load("ViewPop"))
ArenaView.RESOURCE_FILENAME="ui/arena/arena_view.lua"
ArenaView.RESOURCE_BINDING = {
    ["img_arena"] = { ["varname"] = "img_arena" },
    ["btn_bg"] = { ["varname"] = "btn_bg" },
    ["btn_mrlt"]  = {["varname"] = "btn_mrlt",["events"]={{["event"] = "click",["method"]="OnClickTabBtn"}} },  -- 每日擂台按钮
    ["btn_zlt"]  = {["varname"] = "btn_zlt",["events"]={{["event"] = "click",["method"]="OnClickTabBtn"}} },   -- 周擂台按钮
    ["btn_mrt"]  = {["varname"] = "btn_mrt",["events"]={{["event"] = "click",["method"]="OnClickTabBtn"}} },    -- 名人堂按钮
    ["btn_kf"]  = {["varname"] = "btn_kf",["events"]={{["event"] = "click",["method"]="OnClickTabBtn"}} },    -- 客服按钮

    ["node_vrena"] = { ["varname"] = "node_vrena" },

}
ArenaView.ADD_BLUR_BG = true
--一级的按钮颜色
local ARENA_NOT_SELECT_COLOR = cc.c3b(98, 158, 226)
local ARENA_SELECT_COLOR = cc.c3b(246,230,155)

--按钮数据
ArenaView.BTN_DATA_TYPES =
{
    BTN_DataMeiRiLeiTai = 1,
    BTN_DataZhouLeiTai = 2,
}
function ArenaView:onCreate(data)

    self.itype = checkint(data)
    --按钮数据
    self.btnArena =
    {
        DataMeiRiLeiTai = nil,
        DataZhouLeiTai = nil,
        DataMingRenTang = nil,
        DataKeFu = nil,
    }
    self.currentClick = nil
    self.tabArena = {}
     --每日擂台
    self.taballArena = {self.btn_mrlt,self.btn_zlt,self.btn_mrt,self.btn_kf}
    self:initView()
    --自适应
    self:setScale(math.min(display.scaleX, display.scaleY))

    if self.itype > 0 and self.itype <= 3 then
        --点击传进来的值
        self:onClick(self.taballArena[self.itype])
    else
        --默认点击第一个按钮
        self:onClick(self.btn_mrlt)
    end

end
function ArenaView:initView()
    --联系客服开关
    if not GameApp:CheckModuleEnable( ModuleTag.CustomerService ) then
        self.btn_kf:setVisible(false)
    end
end
--点击按钮
function ArenaView:OnClickTabBtn(sender)
    -- 播放点击音效
    gg.AudioManager:playClickEffect()
    self:onClick( sender)
end


--点击按钮显示界面
function ArenaView:onClick(sender)

    if sender== self.btn_mrlt and self.currentClick ~= self.btn_mrlt then  -- 每日擂台按钮
        self.currentClick = self.btn_mrlt
        if self.btnArena.TYPE_DataMeiRiLeiTai== nil then
            self.btnArena.TYPE_DataMeiRiLeiTai = self:getScene():createView("arena.ArenaTopView",ArenaView.BTN_DATA_TYPES.BTN_DataMeiRiLeiTai,function()
                -- 关闭点击回调
                self:onClickclose()
            end )
            self.node_vrena:addChild( self.btnArena.TYPE_DataMeiRiLeiTai )
            table.insert(self.tabArena,self.btnArena.TYPE_DataMeiRiLeiTai)
        end
        self:updateView(self.btnArena.TYPE_DataMeiRiLeiTai)
        self:updatebtnBG(sender)
    elseif sender== self.btn_zlt  and self.currentClick ~= self.btn_zlt then  --周擂台按钮
        self.currentClick = self.btn_zlt
        if self.btnArena.DataZhouLeiTai== nil then
            self.btnArena.DataZhouLeiTai = self:getScene():createView("arena.ArenaTopView",ArenaView.BTN_DATA_TYPES.BTN_DataZhouLeiTai, function()
                -- 关闭点击回调
                self:onClickclose()
            end )
            self.node_vrena:addChild( self.btnArena.DataZhouLeiTai )
            table.insert(self.tabArena,self.btnArena.DataZhouLeiTai)
        end
        self:updateView(self.btnArena.DataZhouLeiTai)
        self:updatebtnBG(sender)
    elseif sender== self.btn_mrt and self.currentClick ~= self.btn_mrt then  --名人堂按钮
        self.currentClick = self.btn_mrt
        if self.btnArena.DataMingRenTang== nil then
            self.btnArena.DataMingRenTang = self:getScene():createView("arena.ArenaHofView",self, function()
                -- 关闭点击回调
                self:onClickclose()
            end )

            self.node_vrena:addChild(  self.btnArena.DataMingRenTang )
            table.insert(self.tabArena, self.btnArena.DataMingRenTang)
        end
        self:updateView( self.btnArena.DataMingRenTang)
        self:updatebtnBG(sender)
    elseif sender== self.btn_kf  then  --客服按钮
        -- 播放点击音效
        gg.AudioManager:playClickEffect()
        device.callCustomerServiceApi(ModuleTag.Hall)
    end

end
--更新按钮显示
function ArenaView:updateView(idx)
    for i, v in ipairs(self.tabArena) do
        if v == idx then
            v:setVisible(true)
            if idx ~=3 then
                v:updateData()
            end
        else
            v:setVisible(false)
        end
    end
end

--关闭点击
function ArenaView:onClickclose(sender)
    self:removeSelf()
end

function ArenaView:updatebtnBG(btn)
    --  在擂台赛页面上，需要更新左侧栏的几个按钮
    for i, v in ipairs(self.taballArena) do
        if v == btn then
            v:setColor(ARENA_SELECT_COLOR)
        else
            v:setColor(ARENA_NOT_SELECT_COLOR)
        end
    end
end

return ArenaView