module citro3d.uniforms;

extern (C):

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

C3D_FVec* C3D_FVUnifWritePtr (GPUShaderType type, int id, int size);

C3D_IVec* C3D_IVUnifWritePtr (GPUShaderType type, int id);

// Struct copy.
void C3D_FVUnifMtxNx4 (
    GPUShaderType type,
    int id,
    const(C3D_Mtx)* mtx,
    int num);

void C3D_FVUnifMtx4x4 (GPUShaderType type, int id, const(C3D_Mtx)* mtx);

void C3D_FVUnifMtx3x4 (GPUShaderType type, int id, const(C3D_Mtx)* mtx);

void C3D_FVUnifMtx2x4 (GPUShaderType type, int id, const(C3D_Mtx)* mtx);

void C3D_FVUnifSet (
    GPUShaderType type,
    int id,
    float x,
    float y,
    float z,
    float w);

void C3D_IVUnifSet (GPUShaderType type, int id, int x, int y, int z, int w);

void C3D_BoolUnifSet (GPUShaderType type, int id, bool value);

void C3D_UpdateUniforms (GPUShaderType type);
