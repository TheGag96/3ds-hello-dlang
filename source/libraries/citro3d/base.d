module citro3d.base;

import citro3d.types;
import ctru.gfx;
import ctru.gpu.enums;
import ctru.gpu.gpu;
import ctru.gpu.registers;
import ctru.gpu.shaderprogram;
import ctru.services.gspgpu;

extern (C): nothrow: @nogc:

enum C3D_DEFAULT_CMDBUF_SIZE = 0x40000;

enum
{
    C3D_UNSIGNED_BYTE  = 0,
    C3D_UNSIGNED_SHORT = 1
}

bool C3D_Init(size_t cmdBufSize);
void C3D_FlushAsync();
void C3D_Fini();

float C3D_GetCmdBufUsage();

void C3D_BindProgram(shaderProgram_s* program);

void C3D_SetViewport(uint x, uint y, uint w, uint h);
void C3D_SetScissor(GPUScissorMode mode, uint left, uint top, uint right, uint bottom);

void C3D_DrawArrays(GPUPrimitive primitive, int first, int size);
void C3D_DrawElements(GPUPrimitive primitive, int count, int type, const(void)* indices);

// Immediate-mode vertex submission
void C3D_ImmDrawBegin(GPUPrimitive primitive);
void C3D_ImmSendAttrib(float x, float y, float z, float w);
void C3D_ImmDrawEnd();

pragma(inline, true)
void C3D_ImmDrawRestartPrim()
{
    GPUCMD_AddWrite(GPUREG_RESTART_PRIMITIVE, 1);
}

pragma(inline, true)
void C3D_FlushAwait()
{
    gspWaitForP3D();
}

pragma(inline, true)
void C3D_Flush()
{
    C3D_FlushAsync();
    C3D_FlushAwait();
}

pragma(inline, true)
void C3D_VideoSync()
{
    gspWaitForEvent(GSPGPUEvent.vblank0, false);
    gfxSwapBuffersGpu();
}

// Fixed vertex attributes
C3D_FVec* C3D_FixedAttribGetWritePtr(int id);

pragma(inline, true)
void C3D_FixedAttribSet(int id, float x, float y, float z, float w)
{
    C3D_FVec* ptr = C3D_FixedAttribGetWritePtr(id);
    ptr.x = x;
    ptr.y = y;
    ptr.z = z;
    ptr.w = w;
}

