module citro3d.texture;

import ctru.types;
import ctru.gpu.enums;

extern (C): nothrow: @nogc:

struct C3D_TexCube
{
    void*[6] data;
}

struct C3D_Tex
{
    import std.bitmanip : bitfields;

    union
    {
        void* data;
        C3D_TexCube* cube;
    }

    mixin(bitfields!(
        GPUTexColor, "fmt", 4,
        size_t, "size", 28));

    union
    {
        uint dim;

        struct
        {
            ushort height;
            ushort width;
        }
    }

    uint param;
    uint border;

    union
    {
        uint lodParam;

        struct
        {
            ushort lodBias;
            ubyte maxLevel;
            ubyte minLevel;
        }
    }
}

align (8) struct C3D_TexInitParams
{
    import std.bitmanip : bitfields;

    ushort width;
    ushort height;

    mixin(bitfields!(
        ubyte, "maxLevel", 4,
        GPUTexColor, "format", 4,
        GPUTextureModeParam, "type", 3,
        bool, "onVram", 1,
        uint, "", 4));
}

bool C3D_TexInitWithParams(C3D_Tex* tex, C3D_TexCube* cube, C3D_TexInitParams p);
void C3D_TexLoadImage(C3D_Tex* tex, const(void)* data, GPUTexFace face, int level);
void C3D_TexGenerateMipmap(C3D_Tex* tex, GPUTexFace face);
void C3D_TexBind(int unitId, C3D_Tex* tex);
void C3D_TexFlush(C3D_Tex* tex);
void C3D_TexDelete(C3D_Tex* tex);

void C3D_TexShadowParams(bool perspective, float bias);

// avoid sizes smaller than 8
pragma(inline, true)
int C3D_TexCalcMaxLevel(uint width, uint height)
{
    import core.bitop : bsr;
    return (31-bsr(width < height ? width : height)) - 3; // avoid sizes smaller than 8
}

pragma(inline, true)
uint C3D_TexCalcLevelSize(uint size, int level)
{
    return size >> (2*level);
}

pragma(inline, true)
uint C3D_TexCalcTotalSize(uint size, int maxLevel)
{
    /*
    S  = s + sr + sr^2 + sr^3 + ... + sr^n
    Sr = sr + sr^2 + sr^3 + ... + sr^(n+1)
    S-Sr = s - sr^(n+1)
    S(1-r) = s(1 - r^(n+1))
    S = s (1 - r^(n+1)) / (1-r)

    r = 1/4
    1-r = 3/4

    S = 4s (1 - (1/4)^(n+1)) / 3
    S = 4s (1 - 1/4^(n+1)) / 3
    S = (4/3) (s - s/4^(n+1))
    S = (4/3) (s - s/(1<<(2n+2)))
    S = (4/3) (s - s>>(2n+2))
    */
    return (size - C3D_TexCalcLevelSize(size,maxLevel+1)) * 4 / 3;
}

pragma(inline, true)
bool C3D_TexInit(
    C3D_Tex* tex,
    ushort width,
    ushort height,
    GPUTexColor format)
{
    C3D_TexInitParams params; 
    params.width    = width;
    params.height   = height;
    params.maxLevel = 0;
    params.format   = format;
    params.type     = GPUTextureModeParam._2d;
    params.onVram   = false;

    return C3D_TexInitWithParams(tex, null, params);
}

pragma(inline, true)
bool C3D_TexInitMipmap(
    C3D_Tex* tex,
    ushort width,
    ushort height,
    GPUTexColor format)
{
    C3D_TexInitParams params; 
    params.width    = width;
    params.height   = height;
    params.maxLevel = cast(ubyte)C3D_TexCalcMaxLevel(width, height);
    params.format   = format;
    params.type     = GPUTextureModeParam._2d;
    params.onVram   = false;

    return C3D_TexInitWithParams(tex, null, params);
}

pragma(inline, true)
bool C3D_TexInitCube(
    C3D_Tex* tex,
    C3D_TexCube* cube,
    ushort width,
    ushort height,
    GPUTexColor format)
{
    C3D_TexInitParams params; 
    params.width    = width;
    params.height   = height;
    params.maxLevel = 0;
    params.format   = format;
    params.type     = GPUTextureModeParam.cube_map;
    params.onVram   = false;

    return C3D_TexInitWithParams(tex, cube, params);
}

pragma(inline, true)
bool C3D_TexInitVRAM(
    C3D_Tex* tex,
    ushort width,
    ushort height,
    GPUTexColor format)
{
    C3D_TexInitParams params; 
    params.width    = width;
    params.height   = height;
    params.maxLevel = 0;
    params.format   = format;
    params.type     = GPUTextureModeParam._2d;
    params.onVram   = true;

    return C3D_TexInitWithParams(tex, null, params);
}

pragma(inline, true)
bool C3D_TexInitShadow(C3D_Tex* tex, ushort width, ushort height)
{
    C3D_TexInitParams params; 
    params.width    = width;
    params.height   = height;
    params.maxLevel = 0;
    params.format   = GPUTexColor.rgba8;
    params.type     = GPUTextureModeParam._2d;
    params.onVram   = true;

    return C3D_TexInitWithParams(tex, null, params);
}

pragma(inline, true)
bool C3D_TexInitShadowCube(
    C3D_Tex* tex,
    C3D_TexCube* cube,
    ushort width,
    ushort height)
{
    C3D_TexInitParams params; 
    params.width    = width;
    params.height   = height;
    params.maxLevel = 0;
    params.format   = GPUTexColor.rgba8;
    params.type     = GPUTextureModeParam.shadow_cube;
    params.onVram   = true;

    return C3D_TexInitWithParams(tex, cube, params);
}

pragma(inline, true)
GPUTextureModeParam C3D_TexGetType(C3D_Tex* tex)
{
    return cast(GPUTextureModeParam)((tex.param>>28)&0x7);
}

pragma(inline, true)
void* C3D_TexGetImagePtr(C3D_Tex* tex, void* data, int level, uint* size)
{
    if (size) *size = level >= 0 ? C3D_TexCalcLevelSize(tex.size, level) : C3D_TexCalcTotalSize(tex.size, tex.maxLevel);
    if (!level) return data;
    return cast(ubyte*)data + (level > 0 ? C3D_TexCalcTotalSize(tex.size, level-1) : 0);
}

pragma(inline, true)
void* C3D_Tex2DGetImagePtr(C3D_Tex* tex, int level, uint* size)
{
    return C3D_TexGetImagePtr(tex, tex.data, level, size);
}

pragma(inline, true)
void* C3D_TexCubeGetImagePtr(
    C3D_Tex* tex,
    GPUTexFace face,
    int level,
    uint* size)
{
    return C3D_TexGetImagePtr(tex, tex.cube.data[face], level, size);
}

pragma(inline, true)
void C3D_TexUpload(C3D_Tex* tex, const(void)* data)
{
    C3D_TexLoadImage(tex, data, GPUTexFace.texface_2d, 0);
}

pragma(inline, true)
void C3D_TexSetFilter(
    C3D_Tex* tex,
    GPUTextureFilterParam magFilter,
    GPUTextureFilterParam minFilter)
{
    tex.param &= ~(GPU_TEXTURE_MAG_FILTER(GPUTextureFilterParam.linear) | GPU_TEXTURE_MIN_FILTER(GPUTextureFilterParam.linear));
    tex.param |= GPU_TEXTURE_MAG_FILTER(magFilter) | GPU_TEXTURE_MIN_FILTER(minFilter);
}

pragma(inline, true)
void C3D_TexSetFilterMipmap(C3D_Tex* tex, GPUTextureFilterParam filter)
{
    tex.param &= ~GPU_TEXTURE_MIP_FILTER(GPUTextureFilterParam.linear);
    tex.param |= GPU_TEXTURE_MIP_FILTER(filter);
}

pragma(inline, true)
void C3D_TexSetWrap(
    C3D_Tex* tex,
    GPUTextureWrapParam wrapS,
    GPUTextureWrapParam wrapT)
{
    tex.param &= ~(GPU_TEXTURE_WRAP_S(3) | GPU_TEXTURE_WRAP_T(3));
    tex.param |= GPU_TEXTURE_WRAP_S(wrapS) | GPU_TEXTURE_WRAP_T(wrapT);
}

pragma(inline, true)
void C3D_TexSetLodBias(C3D_Tex* tex, float lodBias)
{
    int iLodBias = cast(int)(lodBias*0x100);
    if (iLodBias > 0xFFF)
        iLodBias = 0xFFF;
    else if (iLodBias < -0x1000)
        iLodBias = -0x1000;
    tex.lodBias = iLodBias & 0x1FFF;
}
