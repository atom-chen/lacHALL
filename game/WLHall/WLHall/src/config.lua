-- use framework, will disable all deprecated API, false - use legacy API
CC_USE_FRAMEWORK = true

-- show FPS on screen
CC_SHOW_FPS = false

-- disable create unexpected global variable
CC_DISABLE_GLOBAL = true 

-- for module display
CC_DESIGN_RESOLUTION = {
    width = 1280,
    height = 720,
    autoscale = "FIXED_WIDTH",
    callback = function(framesize)
        local ratio = framesize.width / framesize.height
        printf("frame size width==%d height=%d", framesize.width, framesize.height)
        if ratio <= 1.34 then --4:3 屏幕 单独适配

            -- if ratio>= 1024/768 then
            -- iPad 768*1024(1536*2048) is 4:3 screen
            return { autoscale = "FIXED_HEIGHT" }
        end
        
        if ratio >= 2 and framesize.width > 2000 then
            local newWidth = 720 * ratio
            gg.isWideScreenPhone = true;   --判断IPhoneX或全面屏
            return { autoscale = "FIXED_HEIGHT", width = newWidth }
        end
    end
}

-- Mac不要对print做任何处理
if CC_PLATFORM_MAC == Helper.platform then
    return
end

if Helper.platform ~= CC_PLATFORM_WIN32 then
    -- 在 windows 平台，print 被 LuaDebugger 接管了，这里不做重定义
    print = DEBUG > 0 and release_print  or function() end
end
