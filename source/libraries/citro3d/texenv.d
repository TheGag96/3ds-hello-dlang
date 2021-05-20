module citro3d.texenv;

import ctru.types;
import ctru.gpu.enums;

extern (C): nothrow: @nogc:

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

enum C3DTexEnvMode : ubyte
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

pragma(inline, true)
void C3D_TexEnvInit(C3D_TexEnv* env)
{
    env.srcRgb     = cast(ushort)GPU_TEVSOURCES(GPUTevSrc.previous, 0, 0);
    env.srcAlpha   = env.srcRgb;
    env.opAll      = 0;
    env.funcRgb    = GPUCombineFunc.replace;
    env.funcAlpha  = env.funcRgb;
    env.color      = 0xFFFFFFFF;
    env.scaleRgb   = GPUTevScale.x1;
    env.scaleAlpha = GPUTevScale.x1;
}

pragma(inline, true)
void C3D_TexEnvSrc(
    C3D_TexEnv* env,
    C3DTexEnvMode mode,
    GPUTevSrc s1,
    GPUTevSrc s2,
    GPUTevSrc s3)
{
    int param = GPU_TEVSOURCES(cast(int)s1, cast(int)s2, cast(int)s3);
    if (cast(int)mode & C3DTexEnvMode.rgb)
        env.srcRgb = cast(ushort)param;
    if (cast(int)mode & C3DTexEnvMode.alpha)
        env.srcAlpha = cast(ushort)param;
}

pragma(inline, true)
void C3D_TexEnvOpRgb(
    C3D_TexEnv* env,
    GPUTevOpRGB o1,
    GPUTevOpRGB o2,
    GPUTevOpRGB o3)
{
    env.opRgb = GPU_TEVOPERANDS(cast(int)o1, cast(int)o2, cast(int)o3);
}

pragma(inline, true)
void C3D_TexEnvOpAlpha(
    C3D_TexEnv* env,
    GPUTevOpA o1,
    GPUTevOpA o2,
    GPUTevOpA o3)
{
    env.opAlpha = GPU_TEVOPERANDS(cast(int)o1, cast(int)o2, cast(int)o3);
}

pragma(inline, true)
void C3D_TexEnvFunc(
    C3D_TexEnv* env,
    C3DTexEnvMode mode,
    GPUCombineFunc param)
{
    if (cast(int)mode & C3DTexEnvMode.rgb)
        env.funcRgb = cast(ushort)param;
    if (cast(int)mode & C3DTexEnvMode.alpha)
        env.funcAlpha = cast(ushort)param;
}

pragma(inline, true)
void C3D_TexEnvColor(C3D_TexEnv* env, uint color)
{
    env.color = color;
}

pragma(inline, true)
void C3D_TexEnvScale(C3D_TexEnv* env, int mode, GPUTevScale param)
{
    if (mode & C3DTexEnvMode.rgb)
        env.scaleRgb = cast(ushort)param;
    if (mode & C3DTexEnvMode.alpha)
        env.scaleAlpha = cast(ushort)param;
}

