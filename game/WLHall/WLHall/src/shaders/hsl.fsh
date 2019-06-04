
#ifdef GL_ES
precision lowp float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
uniform vec4 v_hsl_value;

float Hue_2_RGB(float v1, float v2, float vH)
{
  float ret;

  if (vH < 0.0)
  {
    vH += 1.0;
  }
    
  if (vH > 1.0)
  {
    vH -= 1.0;
  }
    
  if ((6.0 * vH) < 1.0)
  {
    ret = (v1 + (v2 - v1) * 6.0 * vH);
  }
  else if ((2.0 * vH) < 1.0)
  {
    ret = (v2);
  }
  else if ((3.0 * vH) < 2.0)
  {
    ret = (v1 + (v2 - v1) * ((2.0 / 3.0) - vH) * 6.0);
  }
  else
  {
    ret = v1;
  }
   
  return ret;
}

void main(void)
{
  float Cmax;
  float Cmin;
  float D;
  float H;
  float S;
  float L;
  float R;
  float G;
  float B;

  vec4 color = texture2D(CC_Texture0, v_texCoord);

  if (v_hsl_value.a == 0.0)
  {
    gl_FragColor = v_fragmentColor * color;
    return;
  }

  R = color.r;
  G = color.g;
  B = color.b;
  
  Cmax = max (R, max (G, B));
  Cmin = min (R, min (G, B));
  L = (Cmax + Cmin) / 2.0;

  if (Cmax == Cmin)
  {
    H = 0.0;
    S = 0.0;
  }
  else
  {
    D = Cmax - Cmin;
    
    if (L < 0.5)
    {
      S = D / (Cmax + Cmin);
    }
    else
    {
      S = D / (2.0 - (Cmax + Cmin));
    }

    if (R == Cmax)
    {
      H = (G - B) / D;
    } 
    else 
    {
      if (G == Cmax)
      {
        H = 2.0 + (B - R) /D;
      }
      else
      {
        H = 4.0 + (R - G) / D;
      }
    }
    
    H = H / 6.0;
  }

  // modify H/S/L values
  H += v_hsl_value.r;
  S += v_hsl_value.g;
  L += v_hsl_value.b;

  if (H < 0.0)
  {
    H = H + 1.0;
  }

  H = clamp(H, 0.0, 1.0);
  S = clamp(S, 0.0, 1.0);
  L = clamp(L, 0.0, 1.0);

  // convert back to RGB
  float var_2;
  float var_1;

  if (S == 0.0)
  {
    R = L;
    G = L;
    B = L;
  }
  else
  {
    if (L < 0.5)
    {
      var_2 = L * (1.0 + S);
    }
    else
    {
      var_2 = (L + S) - (S * L);
    }

    var_1 = 2.0 * L - var_2;

    R = Hue_2_RGB(var_1, var_2, H + (1.0 / 3.0));
    G = Hue_2_RGB(var_1, var_2, H);
    B = Hue_2_RGB(var_1, var_2, H - (1.0 / 3.0));
  }

  gl_FragColor = v_fragmentColor * vec4(R, G, B, color.a);
}
