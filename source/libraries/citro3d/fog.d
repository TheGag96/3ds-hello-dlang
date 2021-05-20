module citro3d.fog;

import ctru.gpu.enums;

extern (C): nothrow: @nogc:

struct C3D_FogLut
{
    uint[128] data;
}

struct C3D_GasLut
{
    uint[8] diff;
    uint[8] color;
}

pragma(inline, true)
float FogLut_CalcZ (float depth, float near, float far)
{
    return far*near/(depth*(far-near)+near);
}

void FogLut_FromArray (C3D_FogLut* lut, ref const(float)[256] data);
void FogLut_Exp (C3D_FogLut* lut, float density, float gradient, float near, float far);

void C3D_FogGasMode (GPUFogMode fogMode, GPUGasMode gasMode, bool zFlip);
void C3D_FogColor (uint color);
void C3D_FogLutBind (C3D_FogLut* lut);

void GasLut_FromArray (C3D_GasLut* lut, ref const(uint)[9] data);

void C3D_GasBeginAcc ();
void C3D_GasDeltaZ (float value);

void C3D_GasAccMax (float value);
void C3D_GasAttn (float value);
void C3D_GasLightPlanar (float min, float max, float attn);
void C3D_GasLightView (float min, float max, float attn);
void C3D_GasLightDirection (float dotp);
void C3D_GasLutInput (GPUGasLutInput input);
void C3D_GasLutBind (C3D_GasLut* lut);
