--
-- Author: lee
-- Date: 2016-12-10 20:19:01
--
local loaded_ = false
local CookiesHelper =
{
    defRoleIdx_ = 1,
    accountList_ = {},
    roleSerialData_ = nil,
    lastRoleFrom_ = -1,
}

--//当前角色保存文件
local ROLE_DATA_PATH_ = device.writablePath .. "role.dat";
local userdefault = cc.UserDefault:getInstance()

--//加载账号列表
function CookiesHelper:lazyInit()
    if loaded_ then
        return;
    end
    loaded_ = true
    local fRoles = io.open(ROLE_DATA_PATH_)
    if fRoles then
        local croledata = fRoles:read("*all")
        fRoles:close()
        self.roleSerialData_ = Helper.RoleDataDecode(croledata)

        if self.roleSerialData_ and string.len(self.roleSerialData_) > 0 then
            printf("----用户数据：" .. self.roleSerialData_);
            local ok, func = pcall(function() return loadstring(self.roleSerialData_) end)

            if ok and type(func) == "function" then
                -- 是 lua 格式的，解析之后转存储为 json 格式
                local list, idx, lastRoleFrom = func()
                self.accountList_ = list
                self.defRoleIdx_ = idx
                self.lastRoleFrom_ = lastRoleFrom

                self:Flush()
            else
                -- 是 json 格式的，直接进行解析
                local jsonObj = json.decode(self.roleSerialData_)
                if jsonObj then
                    self.accountList_ = jsonObj.accountList
                    self.defRoleIdx_ = jsonObj.defIdx
                    self.lastRoleFrom_ = jsonObj.lastRoleFrom
                end
            end
        end
    else
        --- [[
        -- 账号列表
        local nAccountCount = userdefault:getIntegerForKey("AccountCount")

        for i = 1, nAccountCount do
            local key = "Account_" .. tostring(i - 1);
            local session = userdefault:getStringForKey(key);

            local info = {};
            info.sex = userdefault:getBoolForKey(key .. "bSex");
            info.userfrom = userdefault:getIntegerForKey(key .. "wUserFrom");
            if info.userfrom ~=USER_FROM_UNLOGIN then --账号用户
                info.username = userdefault:getStringForKey(key .. "strAccount");
                info.pwd = userdefault:getStringForKey(key .. "strPassword");
            else
                info.username = session;
                info.pwd =""
            end
            info.avatarurl = userdefault:getStringForKey(key.."strAvatar");
            info.nick = userdefault:getStringForKey(key .. "strNickName");
            info.autologin = userdefault:getBoolForKey(key .. "bAuto");
            if info.autologin then
                self.defRoleIdx_ = i;
                self.lastRoleFrom_ = info.userfrom
            end
            self.accountList_[i] = info;
        end
        --]]
        self:Flush()
    end
    return loaded_
end

--//回写账号信息
function CookiesHelper:Flush()
    if loaded_ then
        local data = { }
        data.accountList = self.accountList_
        data.defIdx = self.defRoleIdx_
        data.lastRoleFrom = self.lastRoleFrom_
        local strData = json.encode(data)
        if strData == self.roleSerialData_ then
            return
        end

        self.roleSerialData_ = strData
        local cryptdata = Helper.RoleDataEncode(strData)

        local fRoles = io.open(ROLE_DATA_PATH_, "w+")
        if fRoles then
            fRoles:write(cryptdata)
            fRoles:close()
            fRoles = nil
        end
    end
    return loaded_
end

function CookiesHelper:AddUserData(params)
    self:lazyInit()
    local idx = #self.accountList_ + 1
    self:UpdateUserData(params, idx)
end

function CookiesHelper:UpdateUserData(params, idx)
    self:lazyInit()
    idx = idx or self.defRoleIdx_
    if params and table.nums(params) > 0 then
        self.accountList_[idx] = checktable(self.accountList_[idx])
        table.merge(self.accountList_[idx], checktable(params))
        self.defRoleIdx_ = idx
        self.lastRoleFrom_ = self.accountList_[idx].userfrom
        self:Flush()
        return true
    end
    return false
end

--获得当前用户的索引号
function CookiesHelper:GetDefRoleIndex()
    self:lazyInit()
    return self.defRoleIdx_;
end

function CookiesHelper:Logout()
   self:lazyInit()
   local role,idx= self:GetDefRole()
   local from= BRAND==0 and USER_FROM_JIXIANG or USER_FROM_PLATFORM
   if role and (role.userfrom~=from and role.userfrom~=USER_FROM_UNLOGIN) then
        self:RemoveRole(idx)
   end
end

--获取上次用户登录方式
function CookiesHelper:getLastRoleFrom()
    self:lazyInit()
    return self.lastRoleFrom_
end

--获得默认用户 可根据类型筛选
function CookiesHelper:GetDefRole(userfrom)

    self:lazyInit()
    local idx = self.defRoleIdx_
    local role = self.accountList_[idx]
    if checkint(userfrom) ~= USER_FROM_UNKOWN and checktable(role).userfrom ~= userfrom then
        role = nil
        for k, v in ipairs(self.accountList_) do
            if v.userfrom == userfrom then
                role = v
                idx = k
            end
        end
    end
    return role, idx
end

--[[
* @brief 设置默认用户
* @param [in] id 用户id
--]]
function CookiesHelper:SetDefRoleById(id)
    self:lazyInit()
    local _, idx = self:GetRoleById(id)
    if checkint(idx) > 0 then
        self.defRoleIdx_ = idx
    end
end

--[[
* @brief 设置默认用户
* @param [in] index 用户索引号
--]]
function CookiesHelper:SetDefRoleIndex(index)
    self:lazyInit()
    self.defRoleIdx_ = index or self.defRoleIdx_
end

--是否有游客账号
function CookiesHelper:HasVistorRole()
    self:lazyInit()
    return self:GetRoleCount(USER_FROM_UNLOGIN) > 0
end

--[[
* @brief 获取游客账号信息
--]]
function CookiesHelper:GetVistorInfo()
    self:lazyInit()
    for k, v in pairs(self.accountList_) do
        if v.userfrom == USER_FROM_UNLOGIN then
            return v, k
        end
    end
end

--获取角色数量 可根据类型筛选
function CookiesHelper:GetRoleCount(userfrom)
    self:lazyInit()
    local count = #self.accountList_
    if checkint(userfrom) ~= USER_FROM_UNKOWN then
        count = 0
        for k, v in ipairs(self.accountList_) do
            if v.userfrom == userfrom then
                count = count + 1
            end
        end
    end
    return count
end

--获取角色列表
function CookiesHelper:GetRoleList()
    self:lazyInit()
    return checktable(self.accountList_)
end

--获取角色
function CookiesHelper:GetRoleByUserName(username)
    self:lazyInit()
    if username and string.len(username) > 0 then
        for k, v in ipairs(self.accountList_) do
            if v.username == username then
                return v, k
            end
        end
    end
end

--获取角色
function CookiesHelper:GetRoleById(id)
    self:lazyInit()
    if checkint(id) > 0 then
        for k, v in ipairs(self.accountList_) do
            if v.id == id then
                return v, k
            end
        end
    end
end

--移除指定索引的用户
function CookiesHelper:RemoveRoleById(id)
    self:lazyInit()
    local _, idx = self:GetRoleById(id)
    if idx then
        table.remove(self.accountList_, idx);
        if self.defRoleIdx_ == idx then
            self.defRoleIdx_ = 1
        end
        self:Flush();
    end
end

--获取角色
function CookiesHelper:GetRoleInfo(idx)
    self:lazyInit()
    idx = idx or #self.accountList_
    if idx > 0 then
        return self.accountList_[idx];
    end
end

--移除指定索引的用户
function CookiesHelper:RemoveRole(idx)
    self:lazyInit()
    idx = idx or 0
    if idx > 0 and idx <= #self.accountList_ then
        table.remove(self.accountList_, idx);
        if self.defRoleIdx_ == idx then
            self.defRoleIdx_ = 1
        end
        self:Flush();
    end
end

--设置自动登陆角色
function CookiesHelper:SetAutoLoginRole(username)
    self:lazyInit()
    if #checkstring(username) > 0 then
        for k, v in pairs(self.accountList_) do
            v.autologin = (v.username == username)
            if v.autologin then
                self.defRoleIdx_ = k
            end
        end
        self:Flush()
    end
end

--[[
* @brief 根据索引设置自动登录角色
* @param [in] idx 索引
--]]
function CookiesHelper:SetAutoLoginRoleByIndex(idx)
    self:lazyInit()
    idx = checkint(idx)
    if idx > 0 and idx <= #self.accountList_ then
        for k, v in pairs(self.accountList_) do
            v.autologin = false
        end
        self.defRoleIdx_ = idx
        checktable(self.accountList_[idx]).autologin = true
    end
end


--[[
* @brief 添加一个游客账号
* @param [in] session 游客会话ID,必须为32个16进制字符
]]
function CookiesHelper:AddVistorInfo(session, userfrom, nickname)
    self:lazyInit()
    assert(type(session) == "string" and #session == 32, "无效的会话ID");
    userfrom = userfrom or USER_FROM_UNLOGIN --默认游客角色
    local role = {};
    role.userfrom = userfrom;
    role.username = session;
    role.sex = true;
    role.avatarurl = nil;
    role.pwd = "";
    role.nick = nickname or "mobile" .. tostring(math.random(1, 100));
    self.defRoleIdx_ = #self.accountList_ + 1
    self.accountList_[self.defRoleIdx_] = role;
    self:SetAutoLoginRoleByIndex(self.defRoleIdx_)
    self:Flush();
end

return CookiesHelper
