#ifdef GL_ES
precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;

uniform vec2 resolution;
uniform float blurRadius;
uniform float sampleNum;
uniform vec2 startPos;
uniform vec2 size;

vec4 blur(vec2);

bool isContainPos(vec2 p)
{
    if (p.x > startPos.x && p.y > startPos.y && p.x < startPos.x + size.x && p.y < startPos.y + size.y)
    {
        return true;
    }
    return false;
}

void main(void)
{
    if (isContainPos(v_texCoord))
    {
        vec4 col = blur(v_texCoord);
        gl_FragColor = vec4(col) * v_fragmentColor;
    }
    else
    {
        gl_FragColor = texture2D(CC_Texture0, v_texCoord) * v_fragmentColor;
    }
}

vec4 blur(vec2 p)
{
    if (blurRadius > 0.0 && sampleNum > 1.0)
    {
        vec4 col = vec4(0);
        vec2 unit = 1.0 / resolution.xy;
        
        float r = blurRadius;
        float sampleStep = r / sampleNum;
        
        float count = 0.0;
        
        for(float x = -r; x < r; x += sampleStep)
        {
            for(float y = -r; y < r; y += sampleStep)
            {
                float weight = (r - abs(x)) * (r - abs(y));
                col += texture2D(CC_Texture0, p + vec2(x * unit.x, y * unit.y)) * weight;
                count += weight;
            }
        }
        
        return col / count;
    }
    
    return texture2D(CC_Texture0, p);
}
