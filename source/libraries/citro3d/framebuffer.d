module citro3d.framebuffer;

import citro3d.texture;
import ctru.gfx;
import ctru.gpu.enums;
import ctru.types;

extern (C): nothrow: @nogc:

struct C3D_FrameBuf
{
    import std.bitmanip : bitfields;

    void* colorBuf;
    void* depthBuf;
    ushort width;
    ushort height;
    GPUColorBuf colorFmt;
    GPUDepthBuf depthFmt;
    bool block32;

    mixin(bitfields!(
        ubyte, "colorMask", 4,
        ubyte, "depthMask", 4));
}

// Flags for C3D_FrameBufClear
enum C3DClearBits : ubyte
{
    clear_color = BIT(0),
    clear_depth = BIT(1),
    clear_all   = clear_color | clear_depth
}

uint C3D_CalcColorBufSize(uint width, uint height, GPUColorBuf fmt);
uint C3D_CalcDepthBufSize(uint width, uint height, GPUDepthBuf fmt);

C3D_FrameBuf* C3D_GetFrameBuf();
void C3D_SetFrameBuf(C3D_FrameBuf* fb);
void C3D_FrameBufTex(C3D_FrameBuf* fb, C3D_Tex* tex, GPUTexFace face, int level);
void C3D_FrameBufClear(C3D_FrameBuf* fb, C3DClearBits clearBits, uint clearColor, uint clearDepth);
void C3D_FrameBufTransfer(C3D_FrameBuf* fb, GFXScreen screen, GFX3DSide side, uint transferFlags);

pragma(inline, true)
void C3D_FrameBufAttrib(
    C3D_FrameBuf* fb,
    ushort width,
    ushort height,
    bool block32)
{
    fb.width   = width;
    fb.height  = height;
    fb.block32 = block32;
}

pragma(inline, true)
void C3D_FrameBufColor(C3D_FrameBuf* fb, void* buf, GPUColorBuf fmt)
{
    if (buf)
    {
        fb.colorBuf  = buf;
        fb.colorFmt  = fmt;
        fb.colorMask = 0xF;
    } else
    {
        fb.colorBuf  = null;
        fb.colorFmt  = GPUColorBuf.rgba8;
        fb.colorMask = 0;
    }
}

pragma(inline, true)
void C3D_FrameBufDepth(C3D_FrameBuf* fb, void* buf, GPUDepthBuf fmt)
{
    if (buf)
    {
        fb.depthBuf  = buf;
        fb.depthFmt  = fmt;
        fb.depthMask = fmt == GPUDepthBuf.depth24_stencil8 ? 0x3 : 0x2;
    } 
    else
    {
        fb.depthBuf  = null;
        fb.depthFmt  = GPUDepthBuf.depth24;
        fb.depthMask = 0;
    }
}

