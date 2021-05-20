module citro3d.effect;

import ctru.gpu.enums;

extern (C): nothrow: @nogc:

void C3D_DepthMap(bool bIsZBuffer, float zScale, float zOffset);
void C3D_CullFace(GPUCullMode mode);
void C3D_StencilTest(bool enable, GPUTestFunc function_, int ref_, int inputMask, int writeMask);
void C3D_StencilOp(GPUStencilOp sfail, GPUStencilOp dfail, GPUStencilOp pass);
void C3D_BlendingColor(uint color);
void C3D_EarlyDepthTest(bool enable, GPUEarlyDepthFunc function_, uint ref_);
void C3D_DepthTest(bool enable, GPUTestFunc function_, GPUWriteMask writemask);
void C3D_AlphaTest(bool enable, GPUTestFunc function_, int ref_);
void C3D_AlphaBlend(GPUBlendEquation colorEq, GPUBlendEquation alphaEq, GPUBlendFactor srcClr, GPUBlendFactor dstClr, GPUBlendFactor srcAlpha, GPUBlendFactor dstAlpha);
void C3D_ColorLogicOp(GPULogicOp op);
void C3D_FragOpMode(GPUFragOpMode mode);
void C3D_FragOpShadow(float scale, float bias);
