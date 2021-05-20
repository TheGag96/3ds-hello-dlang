module citro3d.lightlut;

import core.stdc.math;

extern (C): nothrow: @nogc:

struct C3D_LightLut
{
    uint[256] data;
}

struct C3D_LightLutDA
{
    C3D_LightLut lut;
    float bias;
    float scale;
}

alias C3D_LightLutFunc   = float function (float x, float param);
alias C3D_LightLutFuncDA = float function (float dist, float arg0, float arg1);

pragma(inline, true)
float quadratic_dist_attn(float dist, float linear, float quad)
{
    return 1.0f / (1.0f + linear*dist + quad*dist*dist);
}

pragma(inline, true)
float spot_step(float angle, float cutoff)
{
    return angle >= cutoff ? 1.0f : 0.0f;
}

void LightLut_FromArray(C3D_LightLut* lut, float* data);
void LightLut_FromFunc(C3D_LightLut* lut, C3D_LightLutFunc func, float param, bool negative);
void LightLutDA_Create(C3D_LightLutDA* lut, C3D_LightLutFuncDA func, float from, float to, float arg0, float arg1);

pragma(inline, true)
extern (D) auto LightLut_Phong(T0, T1)(auto ref T0 lut, auto ref T1 shininess)
{
    return LightLut_FromFunc(lut, &powf, shininess, false);
}

pragma(inline, true)
extern (D) auto LightLut_Spotlight(T0, T1)(auto ref T0 lut, auto ref T1 angle)
{
    return LightLut_FromFunc(lut, &spot_step, cosf(angle), true);
}

pragma(inline, true)
extern (D) auto LightLutDA_Quadratic(T0, T1, T2, T3, T4)(auto ref T0 lut, auto ref T1 from, auto ref T2 to, auto ref T3 linear, auto ref T4 quad)
{
    return LightLutDA_Create(lut, &quadratic_dist_attn, from, to, linear, quad);
}
