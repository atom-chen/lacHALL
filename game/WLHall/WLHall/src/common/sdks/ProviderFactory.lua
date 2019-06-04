local CURRENT_MODULE_NAME = ...

local ProviderFactory = class("ProviderFactory")

function ProviderFactory.new(module,interface,...)
    local ok, providerCls = pcall(function()
        return import(string.format(".%s_%s",module,string.upper(device.platform)), CURRENT_MODULE_NAME)
    end)
    if ok then
        return providerCls.new(interface):addListener()
    else
    	GameApp:dispatchEvent(gg.Event.SHOW_TOAST,device.platform.." 平台暂未开放！")
        print("ProviderFactory " ..providerCls)
    end
end

return ProviderFactory
