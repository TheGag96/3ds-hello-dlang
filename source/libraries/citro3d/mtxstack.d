module citro3d.mtxstack;

import citro3d.types;
import ctru.gpu.enums;

extern (C): nothrow: @nogc:

enum C3D_MTXSTACK_SIZE = 8;

struct C3D_MtxStack
{
    C3D_Mtx[C3D_MTXSTACK_SIZE] m;
    int pos;
    ubyte unifType;
    ubyte unifPos;
    ubyte unifLen;
    bool isDirty;
}

pragma(inline, true)
C3D_Mtx* MtxStack_Cur(C3D_MtxStack* stk)
{
    stk.isDirty = true;
    return &stk.m[stk.pos];
}

void MtxStack_Init(C3D_MtxStack* stk);
void MtxStack_Bind(C3D_MtxStack* stk, GPUShaderType unifType, int unifPos, int unifLen);
C3D_Mtx* MtxStack_Push(C3D_MtxStack* stk);
C3D_Mtx* MtxStack_Pop(C3D_MtxStack* stk);
void MtxStack_Update(C3D_MtxStack* stk);
