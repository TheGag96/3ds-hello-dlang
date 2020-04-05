/**
 * @file internal.d
 * @brief Types and functions included from citro2d's source code
 */

module citro2d.internal;

import ctru.types, ctru.gpu, citro3d, citro2d.base;

extern(C):

enum
{
    C2DiF_Active       = BIT(0),
    C2DiF_DirtyProj    = BIT(1),
    C2DiF_DirtyMdlv    = BIT(2),
    C2DiF_DirtyTex     = BIT(3),
    C2DiF_DirtySrc     = BIT(4),
    C2DiF_DirtyFade    = BIT(5),
    C2DiF_DirtyProcTex = BIT(6),

    C2DiF_Src_None  = 0,
    C2DiF_Src_Tex   = BIT(31),
    C2DiF_Src_Mask  = BIT(31),

    C2DiF_ProcTex_Circle = BIT(30),

    C2DiF_DirtyAny = C2DiF_DirtyProj | C2DiF_DirtyMdlv | C2DiF_DirtyTex | C2DiF_DirtySrc | C2DiF_DirtyFade | C2DiF_DirtyProcTex,
};

enum C2D_Corner : ubyte
{
    top_left,     ///< Top left corner
    top_right,    ///< Top right corner
    bottom_left,  ///< Bottom left corner
    bottom_right, ///< Bottom right corner
}

struct C2Di_Vertex
{
    float[3] pos;
    float[3] texcoordX;
    float[2] ptcoord;
    uint color;
}

struct C2Di_Context
{
    DVLB_s* shader;
    shaderProgram_s program;
    C3D_AttrInfo attrInfo;
    C3D_BufInfo bufInfo;
    C3D_ProcTex ptBlend;
    C3D_ProcTex ptCircle;
    C3D_ProcTexLut ptBlendLut;
    C3D_ProcTexLut ptCircleLut;
    uint sceneW, sceneH;

    C2Di_Vertex* vtxBuf;
    size_t vtxBufSize;
    size_t vtxBufPos;
    size_t vtxBufLastPos;

    uint flags;
    C3D_Mtx projMtx;
    C3D_Mtx mdlvMtx;
    C3D_Tex* curTex;
    uint fadeClr;
}

struct C2Di_Quad
{
    float[2] topLeft;
    float[2] topRight;
    float[2] botLeft;
    float[2] botRight;
}

extern __gshared C2Di_Context __C2Di_Context;

pragma(inline, true)
C2Di_Context* C2Di_GetContext()
{
    return &__C2Di_Context;
}

pragma(inline, true)
void C2Di_SetCircle(bool iscircle)
{
    C2Di_Context* ctx = C2Di_GetContext();
    if (iscircle && !(ctx.flags & C2DiF_ProcTex_Circle))
    {
        ctx.flags |= C2DiF_DirtyProcTex;
        ctx.flags |= C2DiF_ProcTex_Circle;
    }
    else if (!iscircle && (ctx.flags & C2DiF_ProcTex_Circle))
    {
        ctx.flags |= C2DiF_DirtyProcTex;
        ctx.flags &= ~C2DiF_ProcTex_Circle;
    }
}

pragma(inline, true)
void C2Di_SetSrc(uint src)
{
    C2Di_Context* ctx = C2Di_GetContext();
    src &= C2DiF_Src_Mask;
    if ((ctx.flags & C2DiF_Src_Mask) != src)
        ctx.flags = C2DiF_DirtySrc | (ctx.flags &~ C2DiF_Src_Mask) | src;
}

pragma(inline, true)
void C2Di_SetTex(C3D_Tex* tex)
{
    C2Di_Context* ctx = C2Di_GetContext();
    C2Di_SetSrc(C2DiF_Src_Tex);
    if (tex != ctx.curTex)
    {
        ctx.flags |= C2DiF_DirtyTex;
        ctx.curTex = tex;
    }
}

pragma(inline, true)
void C2Di_SwapUV(float[2] a, float[2] b)
{
    float[2] temp = [ a[0], a[1] ];
    a[0] = b[0];
    a[1] = b[1];
    b[0] = temp[0];
    b[1] = temp[1];
}

void C2Di_Update();
void C2Di_AppendVtx(float x, float y, float z, float u, float v, float ptx, float pty, uint color);
void C2Di_CalcQuad(C2Di_Quad* quad, const(C2D_DrawParams)* params);