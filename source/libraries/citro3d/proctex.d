module citro3d.proctex;

import ctru.types;
import ctru.gpu.enums;
import ctru.services.fs;

extern (C): nothrow: @nogc:

struct C3D_ProcTexColorLut
{
    uint[256] color;
    uint[256] diff;
}

struct C3D_ProcTex
{
    union
    {
        uint proctex0;

        struct
        {
            import std.bitmanip : bitfields;

            mixin(bitfields!(
                uint, "uClamp", 3,
                uint, "vClamp", 3,
                uint, "rgbFunc", 4,
                uint, "alphaFunc", 4,
                bool, "alphaSeparate", 1,
                bool, "enableNoise", 1,
                uint, "uShift", 2,
                uint, "vShift", 2,
                uint, "lodBiasLow", 8,
                uint, "", 4));
        }
    }

    union
    {
        uint proctex1;

        struct
        {
            ushort uNoiseAmpl;
            ushort uNoisePhase;
        }
    }

    union
    {
        uint proctex2;

        struct
        {
            ushort vNoiseAmpl;
            ushort vNoisePhase;
        }
    }

    union
    {
        uint proctex3;

        struct
        {
            ushort uNoiseFreq;
            ushort vNoiseFreq;
        }
    }

    union
    {
        uint proctex4;

        struct
        {
            import std.bitmanip : bitfields;

            mixin(bitfields!(
                uint, "minFilter", 3,
                uint, "unknown1", 8,
                uint, "width", 8,
                uint, "lodBiasHigh", 8,
                uint, "", 5));
        }
    }

    union
    {
        uint proctex5;

        struct
        {
            import std.bitmanip : bitfields;

            mixin(bitfields!(
                uint, "offset", 8,
                uint, "unknown2", 24));
        }
    }
}

enum
{
    C3D_ProcTex_U = BIT(0),
    C3D_ProcTex_V = BIT(1),
    C3D_ProcTex_UV = C3D_ProcTex_U | C3D_ProcTex_V
}

void C3D_ProcTexInit(C3D_ProcTex* pt, int offset, int length);
void C3D_ProcTexNoiseCoefs(C3D_ProcTex* pt, int mode, float amplitude, float frequency, float phase);
void C3D_ProcTexLodBias(C3D_ProcTex* pt, float bias);
void C3D_ProcTexBind(int texCoordId, C3D_ProcTex* pt);

// GPU_LUT_NOISE, GPU_LUT_RGBMAP, GPU_LUT_ALPHAMAP
alias C3D_ProcTexLut = uint[128];
void C3D_ProcTexLutBind(GPUProcTexLutId id, C3D_ProcTexLut* lut);
void ProcTexLut_FromArray(C3D_ProcTexLut* lut, ref const(float)[129] in_);

void C3D_ProcTexColorLutBind(C3D_ProcTexColorLut* lut);
void ProcTexColorLut_Write(C3D_ProcTexColorLut* out_, const(uint)* in_, int offset, int length);

pragma(inline, true)
void C3D_ProcTexClamp(C3D_ProcTex* pt, GPUProcTexClamp u, GPUProcTexClamp v)
{
    pt.uClamp = u;
    pt.vClamp = v;
}

pragma(inline, true)
void C3D_ProcTexCombiner(C3D_ProcTex* pt, bool separate, GPUProcTexMapFunc rgb, GPUProcTexMapFunc alpha)
{
    pt.alphaSeparate = separate;
    pt.rgbFunc = rgb;
    if (separate)
        pt.alphaFunc = alpha;
}

pragma(inline, true)
void C3D_ProcTexNoiseEnable(C3D_ProcTex* pt, bool enable)
{
    pt.enableNoise = enable;
}

pragma(inline, true)
void C3D_ProcTexShift(C3D_ProcTex* pt, GPUProcTexShift u, GPUProcTexShift v)
{
    pt.uShift = u;
    pt.vShift = v;
}

pragma(inline, true)
void C3D_ProcTexFilter(C3D_ProcTex* pt, GPUProcTexFilter min)
{
    pt.minFilter = min;
}