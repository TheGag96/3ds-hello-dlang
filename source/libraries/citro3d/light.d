module citro3d.light;

import ctru.types;
import ctru.gpu.enums;
import citro3d.lightlut;
import citro3d.types;

extern (C): nothrow: @nogc:

//-----------------------------------------------------------------------------
// Material
//-----------------------------------------------------------------------------

struct C3D_Material
{
    float[3] ambient;
    float[3] diffuse;
    float[3] specular0;
    float[3] specular1;
    float[3] emission;
}

//-----------------------------------------------------------------------------
// Light environment
//-----------------------------------------------------------------------------

// Forward declarations
alias C3D_Light = C3D_Light_t;
alias C3D_LightEnv = C3D_LightEnv_t;

struct C3D_LightLutInputConf
{
    uint abs;
    uint select;
    uint scale;
}

struct C3D_LightEnvConf
{
    uint ambient;
    uint numLights;
    uint[2] config;
    C3D_LightLutInputConf lutInput;
    uint permutation;
}

enum
{
    C3DF_LightEnv_Dirty    = BIT(0),
    C3DF_LightEnv_MtlDirty = BIT(1),
    C3DF_LightEnv_LCDirty  = BIT(2)
}

extern (D) auto C3DF_LightEnv_IsCP(T)(auto ref T n)
{
    return BIT(18 + n);
}

enum C3DF_LightEnv_IsCP_Any = 0xFF << 18;

extern (D) auto C3DF_LightEnv_LutDirty(T)(auto ref T n)
{
    return BIT(26 + n);
}

enum C3DF_LightEnv_LutDirtyAll = 0x3F << 26;

struct C3D_LightEnv_t
{
    uint flags;
    C3D_LightLut*[6] luts;
    float[3] ambient;
    C3D_Light*[8] lights;
    C3D_LightEnvConf conf;
    C3D_Material material;
}

void C3D_LightEnvInit(C3D_LightEnv* env);
void C3D_LightEnvBind(C3D_LightEnv* env);

void C3D_LightEnvMaterial(C3D_LightEnv* env, const(C3D_Material)* mtl);
void C3D_LightEnvAmbient(C3D_LightEnv* env, float r, float g, float b);
void C3D_LightEnvLut(C3D_LightEnv* env, GPULightLutId lutId, GPULightLutInput input, bool negative, C3D_LightLut* lut);

enum
{
    GPU_SHADOW_PRIMARY   = BIT(16),
    GPU_SHADOW_SECONDARY = BIT(17),
    GPU_INVERT_SHADOW    = BIT(18),
    GPU_SHADOW_ALPHA     = BIT(19)
}

void C3D_LightEnvFresnel(C3D_LightEnv* env, GPUFresnelSel selector);
void C3D_LightEnvBumpMode(C3D_LightEnv* env, GPUBumpMode mode);
void C3D_LightEnvBumpSel(C3D_LightEnv* env, int texUnit);
void C3D_LightEnvShadowMode(C3D_LightEnv* env, uint mode);
void C3D_LightEnvShadowSel(C3D_LightEnv* env, int texUnit);
void C3D_LightEnvClampHighlights(C3D_LightEnv* env, bool clamp);

//-----------------------------------------------------------------------------
// Light
//-----------------------------------------------------------------------------

struct C3D_LightMatConf
{
    uint specular0;
    uint specular1;
    uint diffuse;
    uint ambient;
}

struct C3D_LightConf
{
    C3D_LightMatConf material;
    ushort[3] position;
    ushort padding0;
    ushort[3] spotDir;
    ushort padding1;
    uint padding2;
    uint config;
    uint distAttnBias;
    uint distAttnScale;
}

enum
{
    C3DF_Light_Enabled    = BIT(0),
    C3DF_Light_Dirty      = BIT(1),
    C3DF_Light_MatDirty   = BIT(2),
    //C3DF_Light_Shadow   = BIT(3),
    //C3DF_Light_Spot     = BIT(4),
    //C3DF_Light_DistAttn = BIT(5),

    C3DF_Light_SPDirty = BIT(14),
    C3DF_Light_DADirty = BIT(15)
}

struct C3D_Light_t
{
    ushort flags;
    ushort id;
    C3D_LightEnv* parent;
    C3D_LightLut* lut_SP;
    C3D_LightLut* lut_DA;
    float[3] ambient;
    float[3] diffuse;
    float[3] specular0;
    float[3] specular1;
    C3D_LightConf conf;
}

int C3D_LightInit(C3D_Light* light, C3D_LightEnv* env);
void C3D_LightEnable(C3D_Light* light, bool enable);
void C3D_LightTwoSideDiffuse(C3D_Light* light, bool enable);
void C3D_LightGeoFactor(C3D_Light* light, int id, bool enable);
void C3D_LightAmbient(C3D_Light* light, float r, float g, float b);
void C3D_LightDiffuse(C3D_Light* light, float r, float g, float b);
void C3D_LightSpecular0(C3D_Light* light, float r, float g, float b);
void C3D_LightSpecular1(C3D_Light* light, float r, float g, float b);
void C3D_LightPosition(C3D_Light* light, C3D_FVec* pos);
void C3D_LightShadowEnable(C3D_Light* light, bool enable);
void C3D_LightSpotEnable(C3D_Light* light, bool enable);
void C3D_LightSpotDir(C3D_Light* light, float x, float y, float z);
void C3D_LightSpotLut(C3D_Light* light, C3D_LightLut* lut);
void C3D_LightDistAttnEnable(C3D_Light* light, bool enable);
void C3D_LightDistAttn(C3D_Light* light, C3D_LightLutDA* lut);

pragma(inline, true)
void C3D_LightColor(C3D_Light* light, float r, float g, float b)
{
    C3D_LightDiffuse(light, r, g, b);
    C3D_LightSpecular0(light, r, g, b);
    C3D_LightSpecular1(light, r, g, b);
}

