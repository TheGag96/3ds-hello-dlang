module citro3d.buffers;

import ctru.types;

extern (C): nothrow: @nogc:

struct C3D_BufCfg
{
    uint offset;
    uint[2] flags;
}

struct C3D_BufInfo
{
    uint base_paddr;
    int bufCount;
    C3D_BufCfg[12] buffers;
}

void BufInfo_Init (C3D_BufInfo* info);
int BufInfo_Add (C3D_BufInfo* info, const(void)* data, ptrdiff_t stride, int attribCount, ulong permutation);

C3D_BufInfo* C3D_GetBufInfo ();
void C3D_SetBufInfo (C3D_BufInfo* info);
