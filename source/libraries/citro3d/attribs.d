module citro3d.attribs;

import ctru.gpu.enums;

extern (C): nothrow: @nogc:

struct C3D_AttrInfo
{
    uint[2] flags;
    ulong permutation;
    int attrCount;
}

void AttrInfo_Init (C3D_AttrInfo* info);
int AttrInfo_AddLoader (C3D_AttrInfo* info, int regId, GPUFormats format, int count);
int AttrInfo_AddFixed (C3D_AttrInfo* info, int regId);

C3D_AttrInfo* C3D_GetAttrInfo ();
void C3D_SetAttrInfo (C3D_AttrInfo* info);
