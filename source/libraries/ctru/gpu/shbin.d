/**
 * @file shbin.h
 * @brief Shader binary support.
 */

module ctru.gpu.shbin;

import ctru.gpu.gpu;
import ctru.gpu.enums;
import ctru.types;

extern (C): nothrow: @nogc:

/// DVLE type.
enum DVLEType : ubyte
{
    vertex_shdr   = GPUShaderType.vertex_shader,  ///< Vertex shader.
    geometry_shdr = GPUShaderType.geometry_shader ///< Geometry shader.
}

/// Constant type.
enum DVLEConstantType : ubyte
{
    _bool   = 0x0, ///< Bool.
    u8      = 0x1, ///< Unsigned 8-bit integer.
    float24 = 0x2  ///< 24-bit float.
}

/// Output attribute.
enum DVLEOutputAttribute : ubyte
{
    position   = 0x0, ///< Position.
    normalquat = 0x1, ///< Normal Quaternion.
    color      = 0x2, ///< Color.
    texcoord0  = 0x3, ///< Texture coordinate 0.
    texcoord0w = 0x4, ///< Texture coordinate 0 W.
    texcoord1  = 0x5, ///< Texture coordinate 1.
    texcoord2  = 0x6, ///< Texture coordinate 2.
    view       = 0x8, ///< View.
    dummy      = 0x9  ///< Dummy attribute (used as passthrough for geometry shader input).
}

/// Geometry shader operation modes.
enum DVLEGeoShaderMode : ubyte
{
    point         = 0, ///< Point processing mode.
    variable_prim = 1, ///< Variable-size primitive processing mode.
    fixed_prim    = 2  ///< Fixed-size primitive processing mode.
}

/// DVLP data.
struct DVLP_s
{
    uint codeSize; ///< Code size.
    uint* codeData; ///< Code data.
    uint opdescSize; ///< Operand description size.
    uint* opcdescData; ///< Operand description data.
}

/// DVLE constant entry data.
struct DVLE_constEntry_s
{
    ushort type; ///< Constant type. See @ref DVLEConstantType
    ushort id; ///< Constant ID.
    uint[4] data; ///< Constant data.
}

/// DVLE output entry data.
struct DVLE_outEntry_s
{
    ushort type; ///< Output type. See @ref DVLEOutputAttribute
    ushort regID; ///< Output register ID.
    ubyte mask; ///< Output mask.
    ubyte[3] unk; ///< Unknown.
}

/// DVLE uniform entry data.
struct DVLE_uniformEntry_s
{
    uint symbolOffset; ///< Symbol offset.
    ushort startReg; ///< Start register.
    ushort endReg; ///< End register.
}

/// DVLE data.
struct DVLE_s
{
    DVLEType type; ///< DVLE type.
    bool mergeOutmaps; ///< true = merge vertex/geometry shader outmaps ('dummy' output attribute is present).
    DVLEGeoShaderMode gshMode; ///< Geometry shader operation mode.
    ubyte gshFixedVtxStart; ///< Starting float uniform register number for storing the fixed-size primitive vertex array.
    ubyte gshVariableVtxNum; ///< Number of fully-defined vertices in the variable-size primitive vertex array.
    ubyte gshFixedVtxNum; ///< Number of vertices in the fixed-size primitive vertex array.
    DVLP_s* dvlp; ///< Contained DVLPs.
    uint mainOffset; ///< Offset of the start of the main function.
    uint endmainOffset; ///< Offset of the end of the main function.
    uint constTableSize; ///< Constant table size.
    DVLE_constEntry_s* constTableData; ///< Constant table data.
    uint outTableSize; ///< Output table size.
    DVLE_outEntry_s* outTableData; ///< Output table data.
    uint uniformTableSize; ///< Uniform table size.
    DVLE_uniformEntry_s* uniformTableData; ///< Uniform table data.
    char* symbolTableData; ///< Symbol table data.
    ubyte outmapMask; ///< Output map mask.
    uint[8] outmapData; ///< Output map data.
    uint outmapMode; ///< Output map mode.
    uint outmapClock; ///< Output map attribute clock.
}

/// DVLB data.
struct DVLB_s
{
    uint numDVLE; ///< DVLE count.
    DVLP_s DVLP; ///< Primary DVLP.
    DVLE_s* DVLE; ///< Contained DVLE.
}

/**
 * @brief Parses a shader binary.
 * @param shbinData Shader binary data.
 * @param shbinSize Shader binary size.
 * @return The parsed shader binary.
 */
DVLB_s* DVLB_ParseFile(uint* shbinData, uint shbinSize);

/**
 * @brief Frees shader binary data.
 * @param dvlb DVLB to free.
 */
void DVLB_Free(DVLB_s* dvlb);

/**
 * @brief Gets a uniform register index from a shader.
 * @param dvle Shader to get the register from.
 * @param name Name of the register.
 * @return The uniform register index.
 */
byte DVLE_GetUniformRegister(DVLE_s* dvle, const(char)* name);

/**
 * @brief Generates a shader output map.
 * @param dvle Shader to generate an output map for.
 */
void DVLE_GenerateOutmap(DVLE_s* dvle);
