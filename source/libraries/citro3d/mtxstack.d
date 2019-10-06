module citro3d.mtxstack;

extern (C):

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

C3D_Mtx* MtxStack_Cur(C3D_MtxStack* stk);

void MtxStack_Init(C3D_MtxStack* stk);
void MtxStack_Bind(C3D_MtxStack* stk, GPU_SHADER_TYPE unifType, int unifPos, int unifLen);
C3D_Mtx* MtxStack_Push(C3D_MtxStack* stk);
C3D_Mtx* MtxStack_Pop(C3D_MtxStack* stk);
void MtxStack_Update(C3D_MtxStack* stk);
