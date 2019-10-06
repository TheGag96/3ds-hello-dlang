module citro3d.texenv;

import ctru.gpu.enums;

extern (C):

struct C3D_TexEnv
{
    ushort srcRgb;
    ushort srcAlpha;

    union
    {
        uint opAll;

        struct
        {
            import std.bitmanip : bitfields;

            mixin(bitfields!(
                uint, "opRgb", 12,
                uint, "opAlpha", 12,
                uint, "", 8));
        }
    }

    ushort funcRgb;
    ushort funcAlpha;
    uint color;
    ushort scaleRgb;
    ushort scaleAlpha;
}

enum C3DTexEnvMode
{
    rgb   = BIT(0),
    alpha = BIT(1),
    both  = rgb | alpha
}

C3D_TexEnv* C3D_GetTexEnv(int id);
void C3D_SetTexEnv(int id, C3D_TexEnv* env);
void C3D_DirtyTexEnv(C3D_TexEnv* env);

void C3D_TexEnvBufUpdate(int mode, int mask);
void C3D_TexEnvBufColor(uint color);

void C3D_TexEnvInit(C3D_TexEnv* env);

void C3D_TexEnvSrc(
    C3D_TexEnv* env,
    C3D_TexEnvMode mode,
    GPUTevSrc s1,
    GPUTevSrc s2,
    GPUTevSrc s3);

void C3D_TexEnvOpRgb(
    C3D_TexEnv* env,
    GPUTevOpRGB o1,
    GPUTevOpRGB o2,
    GPUTevOpRGB o3);

void C3D_TexEnvOpAlpha(
    C3D_TexEnv* env,
    GPUTevOpA o1,
    GPUTevOpA o2,
    GPUTevOpA o3);

void C3D_TexEnvFunc(
    C3D_TexEnv* env,
    C3D_TexEnvMode mode,
    GPUCombineFunc param);

void C3D_TexEnvColor(C3D_TexEnv* env, uint color);

void C3D_TexEnvScale(C3D_TexEnv* env, int mode, GPUTevScale param);

