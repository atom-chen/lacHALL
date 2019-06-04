local M = {}

local m_vert = [[
    attribute vec4 a_position;
    attribute vec2 a_texCoord;
    attribute vec4 a_color;
    
    #ifdef GL_ES
    varying lowp vec4 v_fragmentColor;
    varying mediump vec2 v_texCoord;
    #else
    varying vec4 v_fragmentColor;
    varying vec2 v_texCoord;
    #endif
    
    void main()
    {
        gl_Position = CC_PMatrix * a_position;
        v_fragmentColor = a_color;
        v_texCoord = a_texCoord;
    }
]]

local m_grayFrag = [[
        #ifdef GL_ES
        precision lowp float;
        #endif
        
        varying vec4 v_fragmentColor;
        varying vec2 v_texCoord;
        
        void main()
        {
            vec4 color = v_fragmentColor * texture2D(CC_Texture0, v_texCoord);
            float gray = 0.3 * color.r + 0.59 * color.g + 0.11 * color.b;
            gray = gray * 1.2;
            color.r = gray;
            color.g = gray;
            color.b = gray;
            gl_FragColor = color;
        }
    ]]

local m_highlightFrag = [[
        #ifdef GL_ES
        precision lowp float;
        #endif
        
        varying vec4 v_fragmentColor;
        varying vec2 v_texCoord;
        
        vec4 change_color(vec4 color)
        {
            vec4 flash_colorAdd = vec4(0.196078, 0.196078, 0, 0);
            color = color + flash_colorAdd * color.a;
            return color;
        }
        
        void main()
        {
            gl_FragColor = v_fragmentColor * texture2D(CC_Texture0, v_texCoord); 
            gl_FragColor = change_color(gl_FragColor);
        }
    ]]

local function createProgreamState(frag, key)
    -- 先屏蔽，此处性能可以在优化
    -- local programState = ccex.RefCache:getInstance():get(key)
    -- if programState then
    --     return programState
    -- end

    local program = cc.GLProgram:createWithByteArrays(m_vert, frag)
    local programState = cc.GLProgramState:create(program)
    -- ccex.RefCache:getInstance():add(programState, key)
    return programState
end

function M:getHighlightButtonState()
    return createProgreamState(m_highlightFrag, "__glprogram://highlight_button")
end


function M:getGray()
    return createProgreamState(m_grayFrag, "__glprogram://gray")
end

-- 隐身
function M:getStealth()
    return createProgreamState(m_grayFrag, "__glprogram://stealth")
end

return M

