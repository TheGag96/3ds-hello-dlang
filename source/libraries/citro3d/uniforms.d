module citro3d.uniforms;

extern (C): nothrow: @nogc:

import ctru.types;
import citro3d.types;
import ctru.gpu.enums;

enum C3D_FVUNIF_COUNT = 96;
enum C3D_IVUNIF_COUNT = 4;

extern __gshared C3D_FVec[C3D_FVUNIF_COUNT][2] C3D_FVUnif;
extern __gshared C3D_IVec[C3D_IVUNIF_COUNT][2] C3D_IVUnif;
extern __gshared ushort[2] C3D_BoolUnifs;

extern __gshared bool[C3D_FVUNIF_COUNT][2] C3D_FVUnifDirty;
extern __gshared bool[C3D_IVUNIF_COUNT][2] C3D_IVUnifDirty;
extern __gshared bool[2] C3D_BoolUnifsDirty;

pragma(inline, true)
C3D_FVec* C3D_FVUnifWritePtr(GPUShaderType type, int id, int size)
{
    foreach (i; 0..size)
        C3D_FVUnifDirty[type][id+i] = true;
    return &C3D_FVUnif[type][id];
}

pragma(inline, true)
C3D_IVec* C3D_IVUnifWritePtr(GPUShaderType type, int id)
{
    id -= 0x60;
    C3D_IVUnifDirty[type][id] = true;
    return &C3D_IVUnif[type][id];
}

pragma(inline, true)
void C3D_FVUnifMtxNx4(GPUShaderType type, int id, const C3D_Mtx* mtx, int num)
{
    C3D_FVec* ptr = C3D_FVUnifWritePtr(type, id, num);
    foreach (i; 0..num)
        ptr[i] = mtx.r.ptr[i]; // Struct copy. (Intentional write "out of bounds")
}

pragma(inline, true)
void C3D_FVUnifMtx4x4(GPUShaderType type, int id, const C3D_Mtx* mtx)
{
    C3D_FVUnifMtxNx4(type, id, mtx, 4);
}

pragma(inline, true)
void C3D_FVUnifMtx3x4(GPUShaderType type, int id, const C3D_Mtx* mtx)
{
    C3D_FVUnifMtxNx4(type, id, mtx, 3);
}

pragma(inline, true)
void C3D_FVUnifMtx2x4(GPUShaderType type, int id, const C3D_Mtx* mtx)
{
    C3D_FVUnifMtxNx4(type, id, mtx, 2);
}

pragma(inline, true)
void C3D_FVUnifSet(GPUShaderType type, int id, float x, float y, float z, float w)
{
    C3D_FVec* ptr = C3D_FVUnifWritePtr(type, id, 1);
    ptr.x = x;
    ptr.y = y;
    ptr.z = z;
    ptr.w = w;
}

pragma(inline, true)
void C3D_IVUnifSet(GPUShaderType type, int id, int x, int y, int z, int w)
{
    C3D_IVec* ptr = C3D_IVUnifWritePtr(type, id);
    *ptr = IVec_Pack(cast(ubyte)x, cast(ubyte)y, cast(ubyte)z, cast(ubyte)w);
}

pragma(inline, true)
void C3D_BoolUnifSet(GPUShaderType type, int id, bool value)
{
    id -= 0x68;
    C3D_BoolUnifsDirty[type] = true;
    if (value)
        C3D_BoolUnifs[type] |= BIT(id);
    else
        C3D_BoolUnifs[type] &= ~BIT(id);
}

void C3D_UpdateUniforms(GPUShaderType type);