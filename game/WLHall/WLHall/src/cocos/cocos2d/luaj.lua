local luaj = {}

local callJavaStaticMethod = LuaJavaBridge.callStaticMethod


-- boolean  Z
-- byte B
-- char C
-- short    S
-- int  I
-- long L
-- float    F
-- double   D
-- 类    L全限定名;,比如String, 其签名为Ljava/lang/util/String;
-- 数组   [类型签名, 比如 [B

local function checkArguments(args, sig, ret_type)
    if type(args) ~= "table" then args = {} end
    if sig then return args, sig end
    ret_type = ret_type or "V"
    sig = { "(" }
    for i, v in ipairs(args) do
        local t = type(v)
        if t == "number" then
            sig[#sig + 1] = "F"
        elseif t == "boolean" then
            sig[#sig + 1] = "Z"
        elseif t == "function" then
            sig[#sig + 1] = "I"
        else
            sig[#sig + 1] = "Ljava/lang/String;"
        end
    end
    sig[#sig + 1] = ")" .. ret_type

    return args, table.concat(sig)
end

luaj.checkArguments = checkArguments

function luaj.callStaticMethod(className, methodName, args, sig)
    local args, sig = checkArguments(args, sig)

    printf("--------luaj.callStaticMethod(\"%s\",\n\t\"%s\",\n\targs,\n\t\"%s\"", className, methodName, sig)
    return callJavaStaticMethod(className, methodName, args, sig)
end

return luaj
