module citro3d.texture;

import ctru.types;
import ctru.gpu.enums;

extern (C):

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

struct C3D_TexInitParams
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
int C3D_TexCalcMaxLevel(uint width, uint height);

uint C3D_TexCalcLevelSize(uint size, int level);

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
uint C3D_TexCalcTotalSize(uint size, int maxLevel);

bool C3D_TexInit(
    C3D_Tex* tex,
    ushort width,
    ushort height,
    GPUTexColor format);

bool C3D_TexInitMipmap(
    C3D_Tex* tex,
    ushort width,
    ushort height,
    GPUTexColor format);

bool C3D_TexInitCube(
    C3D_Tex* tex,
    C3D_TexCube* cube,
    ushort width,
    ushort height,
    GPUTexColor format);

bool C3D_TexInitVRAM(
    C3D_Tex* tex,
    ushort width,
    ushort height,
    GPUTexColor format);

bool C3D_TexInitShadow(C3D_Tex* tex, ushort width, ushort height);

bool C3D_TexInitShadowCube(
    C3D_Tex* tex,
    C3D_TexCube* cube,
    ushort width,
    ushort height);

GPUTextureModeParam C3D_TexGetType(C3D_Tex* tex);

void* C3D_TexGetImagePtr(C3D_Tex* tex, void* data, int level, uint* size);

void* C3D_Tex2DGetImagePtr(C3D_Tex* tex, int level, uint* size);

void* C3D_TexCubeGetImagePtr(
    C3D_Tex* tex,
    GPUTexFace face,
    int level,
    uint* size);

void C3D_TexUpload(C3D_Tex* tex, const(void)* data);

void C3D_TexSetFilter(
    C3D_Tex* tex,
    GPUTextureFilterParam magFilter,
    GPUTextureFilterParam minFilter);

void C3D_TexSetFilterMipmap(C3D_Tex* tex, GPUTextureFilterParam filter);

void C3D_TexSetWrap(
    C3D_Tex* tex,
    GPUTextureWrapParam wrapS,
    GPUTextureWrapParam wrapT);

void C3D_TexSetLodBias(C3D_Tex* tex, float lodBias);
