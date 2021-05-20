/**
 * @file enums.h
 * @brief GPU enumeration values.
 */

module ctru.gpu.enums;

import ctru.types;

extern (C): nothrow: @nogc:

/// Creates a texture magnification filter parameter from a @ref GPU_TEXTURE_FILTER_PARAM
pragma(inline, true)
extern (D) auto GPU_TEXTURE_MAG_FILTER(T)(auto ref T v)
{
    return (v & 0x1) << 1;
}

/// Creates a texture minification filter parameter from a @ref GPU_TEXTURE_FILTER_PARAM
pragma(inline, true)
extern (D) auto GPU_TEXTURE_MIN_FILTER(T)(auto ref T v)
{
    return (v & 0x1) << 2;
}

/// Creates a texture mipmap filter parameter from a @ref GPU_TEXTURE_FILTER_PARAM
pragma(inline, true)
extern (D) auto GPU_TEXTURE_MIP_FILTER(T)(auto ref T v)
{
    return (v & 0x1) << 24;
}

/// Creates a texture wrap S parameter from a @ref GPU_TEXTURE_WRAP_PARAM
pragma(inline, true)
extern (D) auto GPU_TEXTURE_WRAP_S(T)(auto ref T v)
{
    return (v & 0x3) << 12;
}

/// Creates a texture wrap T parameter from a @ref GPU_TEXTURE_WRAP_PARAM
pragma(inline, true)
extern (D) auto GPU_TEXTURE_WRAP_T(T)(auto ref T v)
{
    return (v & 0x3) << 8;
}

/// Creates a texture mode parameter from a @ref GPU_TEXTURE_MODE_PARAM
pragma(inline, true)
extern (D) auto GPU_TEXTURE_MODE(T)(auto ref T v)
{
    return (v & 0x7) << 28;
}

/// Texture parameter indicating ETC1 texture.
enum GPU_TEXTURE_ETC1_PARAM = BIT(5);
/// Texture parameter indicating shadow texture.
enum GPU_TEXTURE_SHADOW_PARAM = BIT(20);

/// Creates a combiner buffer write configuration.
pragma(inline, true)
extern (D) auto GPU_TEV_BUFFER_WRITE_CONFIG(T0, T1, T2, T3)(auto ref T0 stage0, auto ref T1 stage1, auto ref T2 stage2, auto ref T3 stage3)
{
    return stage0 | (stage1 << 1) | (stage2 << 2) | (stage3 << 3);
}

/// Texture filters.
enum GPUTextureFilterParam : ubyte
{
    nearest = 0x0, ///< Nearest-neighbor interpolation.
    linear  = 0x1  ///< Linear interpolation.
}

/// Texture wrap modes.
enum GPUTextureWrapParam : ubyte
{
    clamp_to_edge   = 0x0, ///< Clamps to edge.
    clamp_to_border = 0x1, ///< Clamps to border.
    repeat          = 0x2, ///< Repeats texture.
    mirrored_repeat = 0x3  ///< Repeats with mirrored texture.
}

/// Texture modes.
enum GPUTextureModeParam : ubyte
{
    _2d         = 0x0, ///< 2D texture
    cube_map    = 0x1, ///< Cube map
    shadow_2d   = 0x2, ///< 2D Shadow texture
    projection  = 0x3, ///< Projection texture
    shadow_cube = 0x4, ///< Shadow cube map
    disabled    = 0x5  ///< Disabled
}

/// Supported texture units.
enum GPUTexUnit : ubyte
{
    texunit0 = 0x1, ///< Texture unit 0.
    texunit1 = 0x2, ///< Texture unit 1.
    texunit2 = 0x4  ///< Texture unit 2.
}

/// Supported texture formats.
enum GPUTexColor : ubyte
{
    rgba8    = 0x0, ///< 8-bit Red + 8-bit Green + 8-bit Blue + 8-bit Alpha
    rgb8     = 0x1, ///< 8-bit Red + 8-bit Green + 8-bit Blue
    rgba5551 = 0x2, ///< 5-bit Red + 5-bit Green + 5-bit Blue + 1-bit Alpha
    rgb565   = 0x3, ///< 5-bit Red + 6-bit Green + 5-bit Blue
    rgba4    = 0x4, ///< 4-bit Red + 4-bit Green + 4-bit Blue + 4-bit Alpha
    la8      = 0x5, ///< 8-bit Luminance + 8-bit Alpha
    hilo8    = 0x6, ///< 8-bit Hi + 8-bit Lo
    l8       = 0x7, ///< 8-bit Luminance
    a8       = 0x8, ///< 8-bit Alpha
    la4      = 0x9, ///< 4-bit Luminance + 4-bit Alpha
    l4       = 0xA, ///< 4-bit Luminance
    a4       = 0xB, ///< 4-bit Alpha
    etc1     = 0xC, ///< ETC1 texture compression
    etc1a4   = 0xD  ///< ETC1 texture compression + 4-bit Alpha
}

// Texture faces.
enum GPUTexFace : ubyte
{
    texface_2d = 0, // 2D face
    positive_x = 0, // +X face
    negative_x = 1, // -X face
    positive_y = 2, // +Y face
    negative_y = 3, // -Y face
    positive_z = 4, // +Z face
    negative_z = 5  // -Z face
}

/// Procedural texture clamp modes.
enum GPUProcTexClamp : ubyte
{
    clamp_to_zero   = 0, ///< Clamp to zero.
    clamp_to_edge   = 1, ///< Clamp to edge.
    repeat          = 2, ///< Symmetrical repeat.
    mirrored_repeat = 3, ///< Mirrored repeat.
    pulse           = 4  ///< Pulse.
}

/// Procedural texture mapping functions.
enum GPUProcTexMapFunc : ubyte
{
    u     = 0, ///< U
    u2    = 1, ///< U2
    v     = 2, ///< V
    v2    = 3, ///< V2
    add   = 4, ///< U+V
    add2  = 5, ///< U2+V2
    sqrt2 = 6, ///< sqrt(U2+V2)
    min   = 7, ///< min
    max   = 8, ///< max
    rmax  = 9  ///< rmax
}

/// Procedural texture shift values.
enum GPUProcTexShift : ubyte
{
    none = 0, ///< No shift.
    odd  = 1, ///< Odd shift.
    even = 2  ///< Even shift.
}

/// Procedural texture filter values.
enum GPUProcTexFilter : ubyte
{
    nearest             = 0, ///< Nearest-neighbor
    linear              = 1, ///< Linear interpolation
    nearest_mip_nearest = 2, ///< Nearest-neighbor with mipmap using nearest-neighbor
    linear_mip_nearest  = 3, ///< Linear interpolation with mipmap using nearest-neighbor
    nearest_mip_linear  = 4, ///< Nearest-neighbor with mipmap using linear interpolation
    linear_mip_linear   = 5  ///< Linear interpolation with mipmap using linear interpolation
}

/// Procedural texture LUT IDs.
enum GPUProcTexLutId : ubyte
{
    noise    = 0, ///< Noise table
    rgbmap   = 2, ///< RGB mapping function table
    alphamap = 3, ///< Alpha mapping function table
    color    = 4, ///< Color table
    colordif = 5  ///< Color difference table
}

/// Supported color buffer formats.
enum GPUColorBuf : ubyte
{
    rgba8    = 0, ///< 8-bit Red + 8-bit Green + 8-bit Blue + 8-bit Alpha
    rgb8     = 1, ///< 8-bit Red + 8-bit Green + 8-bit Blue
    rgba5551 = 2, ///< 5-bit Red + 5-bit Green + 5-bit Blue + 1-bit Alpha
    rgb565   = 3, ///< 5-bit Red + 6-bit Green + 5-bit Blue
    rgba4    = 4  ///< 4-bit Red + 4-bit Green + 4-bit Blue + 4-bit Alpha
}

/// Supported depth buffer formats.
enum GPUDepthBuf : ubyte
{
    depth16          = 0, ///< 16-bit Depth
    depth24          = 2, ///< 24-bit Depth
    depth24_stencil8 = 3  ///< 24-bit Depth + 8-bit Stencil
}

/// Test functions.
enum GPUTestFunc : ubyte
{
    never    = 0, ///< Never pass.
    always   = 1, ///< Always pass.
    equal    = 2, ///< Pass if equal.
    notequal = 3, ///< Pass if not equal.
    less     = 4, ///< Pass if less than.
    lequal   = 5, ///< Pass if less than or equal.
    greater  = 6, ///< Pass if greater than.
    gequal   = 7  ///< Pass if greater than or equal.
}

/// Early depth test functions.
enum GPUEarlyDepthFunc : ubyte
{
    gequal  = 0, ///< Pass if greater than or equal.
    greater = 1, ///< Pass if greater than.
    lequal  = 2, ///< Pass if less than or equal.
    less    = 3  ///< Pass if less than.
}

/// Gas depth functions.
enum GPUGasDepthFunc : ubyte
{
    never   = 0, ///< Never pass (0).
    always  = 1, ///< Always pass (1).
    greater = 2, ///< Pass if greater than (1-X).
    less    = 3  ///< Pass if less than (X).
}

/// Converts \ref GPU_TESTFUNC into \ref GPU_GASDEPTHFUNC.
pragma(inline, true)
extern (D) auto GPU_MAKEGASDEPTHFUNC(T)(auto ref T n)
{
    return cast(GPU_GASDEPTHFUNC) (0xAF02 >> (cast(int) n << 1)) & 3;
}

/// Scissor test modes.
enum GPUScissorMode : ubyte
{
    disable = 0, ///< Disable.
    invert  = 1, ///< Exclude pixels inside the scissor box.
    // 2 is the same as 0
    normal  = 3  ///< Exclude pixels outside of the scissor box.
}

/// Stencil operations.
enum GPUStencilOp : ubyte
{
    keep      = 0, ///< Keep old value. (old_stencil)
    zero      = 1, ///< Zero. (0)
    replace   = 2, ///< Replace value. (ref)
    incr      = 3, ///< Increment value. (old_stencil + 1 saturated to [0, 255])
    decr      = 4, ///< Decrement value. (old_stencil - 1 saturated to [0, 255])
    invert    = 5, ///< Invert value. (~old_stencil)
    incr_wrap = 6, ///< Increment value. (old_stencil + 1)
    decr_wrap = 7  ///< Decrement value. (old_stencil - 1)
}

/// Pixel write mask.
enum GPUWriteMask : ubyte
{
    red   = 0x01, ///< Write red.
    green = 0x02, ///< Write green.
    blue  = 0x04, ///< Write blue.
    alpha = 0x08, ///< Write alpha.
    depth = 0x10, ///< Write depth.

    color = 0x0F, ///< Write all color components.
    all   = 0x1F  ///< Write all components.
}

/// Blend modes.
enum GPUBlendEquation : ubyte
{
    add              = 0, ///< Add colors.
    subtract         = 1, ///< Subtract colors.
    reverse_subtract = 2, ///< Reverse-subtract colors.
    min              = 3, ///< Use the minimum color.
    max              = 4  ///< Use the maximum color.
}

/// Blend factors.
enum GPUBlendFactor : ubyte
{
    zero                     = 0,  ///< Zero.
    one                      = 1,  ///< One.
    src_color                = 2,  ///< Source color.
    one_minus_src_color      = 3,  ///< Source color - 1.
    dst_color                = 4,  ///< Destination color.
    one_minus_dst_color      = 5,  ///< Destination color - 1.
    src_alpha                = 6,  ///< Source alpha.
    one_minus_src_alpha      = 7,  ///< Source alpha - 1.
    dst_alpha                = 8,  ///< Destination alpha.
    one_minus_dst_alpha      = 9,  ///< Destination alpha - 1.
    constant_color           = 10, ///< Constant color.
    one_minus_constant_color = 11, ///< Constant color - 1.
    constant_alpha           = 12, ///< Constant alpha.
    one_minus_constant_alpha = 13, ///< Constant alpha - 1.
    src_alpha_saturate       = 14  ///< Saturated alpha.
}

/// Logical operations.
enum GPULogicOp : ubyte
{
    clear         = 0,  ///< Clear.
    and           = 1,  ///< Bitwise AND.
    and_reverse   = 2,  ///< Reverse bitwise AND.
    copy          = 3,  ///< Copy.
    set           = 4,  ///< Set.
    copy_inverted = 5,  ///< Inverted copy.
    noop          = 6,  ///< No operation.
    invert        = 7,  ///< Invert.
    nand          = 8,  ///< Bitwise NAND.
    or            = 9,  ///< Bitwise OR.
    nor           = 10, ///< Bitwise NOR.
    xor           = 11, ///< Bitwise XOR.
    equiv         = 12, ///< Equivalent.
    and_inverted  = 13, ///< Inverted bitwise AND.
    or_reverse    = 14, ///< Reverse bitwise OR.
    or_inverted   = 15  ///< Inverted bitwize OR.
}

/// Fragment operation modes.
enum GPUFragOpMode : ubyte
{
    gl      = 0, ///< OpenGL mode.
    gas_acc = 1, ///< Gas mode (?).
    shadow  = 3  ///< Shadow mode (?).
}

/// Supported component formats.
enum GPUFormats : ubyte
{
    _byte         = 0, ///< 8-bit byte.
    unsigned_byte = 1, ///< 8-bit unsigned byte.
    _short        = 2, ///< 16-bit short.
    _float        = 3  ///< 32-bit float.
}

/// Cull modes.
enum GPUCullMode : ubyte
{
    none      = 0, ///< Disabled.
    front_ccw = 1, ///< Front, counter-clockwise.
    back_ccw  = 2  ///< Back, counter-clockwise.
}

/// Creates a VBO attribute parameter from its index, size, and format.
pragma(inline, true)
extern (D) auto GPU_ATTRIBFMT(T0, T1, T2)(auto ref T0 i, auto ref T1 n, auto ref T2 f)
{
    return (((n - 1) << 2) | (f & 3)) << (i * 4);
}

/// Texture combiner sources.
enum GPUTevSrc : ubyte
{
    primary_color            = 0x00, ///< Primary color.
    fragment_primary_color   = 0x01, ///< Primary fragment color.
    fragment_secondary_color = 0x02, ///< Secondary fragment color.
    texture0                 = 0x03, ///< Texture unit 0.
    texture1                 = 0x04, ///< Texture unit 1.
    texture2                 = 0x05, ///< Texture unit 2.
    texture3                 = 0x06, ///< Texture unit 3.
    previous_buffer          = 0x0D, ///< Previous buffer.
    constant                 = 0x0E, ///< Constant value.
    previous                 = 0x0F  ///< Previous value.
}

/// Texture RGB combiner operands.
enum GPUTevOpRGB : ubyte
{
    src_color           = 0x00, /// < Source color.
    one_minus_src_color = 0x01, /// < Source color - 1.
    src_alpha           = 0x02, /// < Source alpha.
    one_minus_src_alpha = 0x03, /// < Source alpha - 1.
    src_r               = 0x04, /// < Source red.
    one_minus_src_r     = 0x05, /// < Source red - 1.
    _0x06               = 0x06, /// < Unknown.
    _0x07               = 0x07, /// < Unknown.
    src_g               = 0x08, /// < Source green.
    one_minus_src_g     = 0x09, /// < Source green - 1.
    _0x0a               = 0x0A, /// < Unknown.
    _0x0b               = 0x0B, /// < Unknown.
    src_b               = 0x0C, /// < Source blue.
    one_minus_src_b     = 0x0D, /// < Source blue - 1.
    _0x0e               = 0x0E, /// < Unknown.
    _0x0f               = 0x0F  /// < Unknown.
}

/// Texture Alpha combiner operands.
enum GPUTevOpA : ubyte
{
    src_alpha           = 0x00, ///< Source alpha.
    one_minus_src_alpha = 0x01, ///< Source alpha - 1.
    src_r               = 0x02, ///< Source red.
    one_minus_src_r     = 0x03, ///< Source red - 1.
    src_g               = 0x04, ///< Source green.
    one_minus_src_g     = 0x05, ///< Source green - 1.
    src_b               = 0x06, ///< Source blue.
    one_minus_src_b     = 0x07  ///< Source blue - 1.
}

/// Texture combiner functions.
enum GPUCombineFunc : ubyte
{
    replace      = 0x00, ///< Replace.
    modulate     = 0x01, ///< Modulate.
    add          = 0x02, ///< Add.
    add_signed   = 0x03, ///< Signed add.
    interpolate  = 0x04, ///< Interpolate.
    subtract     = 0x05, ///< Subtract.
    dot3_rgb     = 0x06, ///< Dot3. RGB only.
    multiply_add = 0x08, ///< Multiply then add.
    add_multiply = 0x09  ///< Add then multiply.
}

/// Texture scale factors.
enum GPUTevScale : ubyte
{
    x1 = 0x0, ///< 1x
    x2 = 0x1, ///< 2x
    x4 = 0x2  ///< 4x
}

/// Creates a texture combiner source parameter from three sources.
pragma(inline, true)
extern (D) auto GPU_TEVSOURCES(T0, T1, T2)(auto ref T0 a, auto ref T1 b, auto ref T2 c)
{
    return (a) | (b << 4) | (c << 8);
}

/// Creates a texture combiner operand parameter from three operands.
pragma(inline, true)
extern (D) auto GPU_TEVOPERANDS(T0, T1, T2)(auto ref T0 a, auto ref T1 b, auto ref T2 c)
{
    return (a) | (b << 4) | (c << 8);
}

/// Creates a light environment layer configuration parameter.
pragma(inline, true)
extern (D) auto GPU_LIGHT_ENV_LAYER_CONFIG(T)(auto ref T n)
{
    return n + (n == 7);
}

/// Light shadow disable bits in GPUREG_LIGHT_CONFIG1.
alias lc1_shadowbit = BIT;
/// Light spot disable bits in GPUREG_LIGHT_CONFIG1.
pragma(inline, true)
extern (D) auto GPU_LC1_SPOTBIT(T)(auto ref T n)
{
    return BIT(n + 8);
}

/// LUT disable bits in GPUREG_LIGHT_CONFIG1.
pragma(inline, true)
extern (D) auto GPU_LC1_LUTBIT(T)(auto ref T n)
{
    return BIT(n + 16);
}

/// Light distance attenuation disable bits in GPUREG_LIGHT_CONFIG1.
pragma(inline, true)
extern (D) auto GPU_LC1_ATTNBIT(T)(auto ref T n)
{
    return BIT(n + 24);
}

/// Creates a light permutation parameter.
pragma(inline, true)
extern (D) auto GPU_LIGHTPERM(T0, T1)(auto ref T0 i, auto ref T1 n)
{
    return n << (i * 4);
}

/// Creates a light LUT input parameter.
pragma(inline, true)
extern (D) auto GPU_LIGHTLUTINPUT(T0, T1)(auto ref T0 i, auto ref T1 n)
{
    return n << (i * 4);
}

/// Creates a light LUT index parameter.
pragma(inline, true)
extern (D) auto GPU_LIGHTLUTIDX(T0, T1, T2)(auto ref T0 c, auto ref T1 i, auto ref T2 o)
{
    return o | (i << 8) | (c << 11);
}

/// Creates a light color parameter from red, green, and blue components.
pragma(inline, true)
extern (D) auto GPU_LIGHTCOLOR(T0, T1, T2)(auto ref T0 r, auto ref T1 g, auto ref T2 b)
{
    return (b & 0xFF) | ((g << 10) & 0xFF) | ((r << 20) & 0xFF);
}

/// Fresnel options.
enum GPUFresnelSel : ubyte
{
    no_fresnel            = 0, ///< None.
    pri_alpha_fresnel     = 1, ///< Primary alpha.
    sec_alpha_fresnel     = 2, ///< Secondary alpha.
    pri_sec_alpha_fresnel = 3  ///< Primary and secondary alpha.
}

/// Bump map modes.
enum GPUBumpMode : ubyte
{
    bump_not_used = 0, ///< Disabled.
    bump_as_bump  = 1, ///< Bump as bump mapping.
    bump_as_tang  = 2  ///< Bump as tangent/normal mapping.
}

/// LUT IDs.
enum GPULightLutId : ubyte
{
    d0 = 0, ///< D0 LUT.
    d1 = 1, ///< D1 LUT.
    sp = 2, ///< Spotlight LUT.
    fr = 3, ///< Fresnel LUT.
    rb = 4, ///< Reflection-Blue LUT.
    rg = 5, ///< Reflection-Green LUT.
    rr = 6, ///< Reflection-Red LUT.
    da = 7  ///< Distance attenuation LUT.
}

/// LUT inputs.
enum GPULightLutInput : ubyte
{
    nh = 0, ///< Normal*HalfVector
    vh = 1, ///< View*HalfVector
    nv = 2, ///< Normal*View
    ln = 3, ///< LightVector*Normal
    sp = 4, ///< -LightVector*SpotlightVector
    cp = 5  ///< cosine of phi
}

/// LUT scalers.
enum GPULightLutScaler : ubyte
{
    x1    = 0, ///< 1x scale.
    x2    = 1, ///< 2x scale.
    x4    = 2, ///< 4x scale.
    x8    = 3, ///< 8x scale.
    x0_25 = 6, ///< 0.25x scale.
    x0_5  = 7  ///< 0.5x scale.
}

/// LUT selection.
enum GPULightLutSelect : ubyte
{
    common = 0, ///< LUTs that are common to all lights.
    sp     = 1, ///< Spotlight LUT.
    da     = 2  ///< Distance attenuation LUT.
}

/// Fog modes.
enum GPUFogMode : ubyte
{
    no_fog = 0, ///< Fog/Gas unit disabled.
    fog    = 5, ///< Fog/Gas unit configured in Fog mode.
    gas    = 7  ///< Fog/Gas unit configured in Gas mode.
}

/// Gas shading density source values.
enum GPUGasMode : ubyte
{
    plain_density = 0, ///< Plain density.
    depth_density = 1  ///< Depth density.
}

/// Gas color LUT inputs.
enum GPUGasLutInput : ubyte
{
    gas_density  = 0, ///< Gas density used as input.
    light_factor = 1  ///< Light factor used as input.
}

/// Supported primitives.
enum GPUPrimitive : ushort
{
    triangles      = 0x0000, ///< Triangles.
    triangle_strip = 0x0100, ///< Triangle strip.
    triangle_fan   = 0x0200, ///< Triangle fan.
    geometry_prim  = 0x0300  ///< Geometry shader primitive.
}

/// Shader types.
enum GPUShaderType : ubyte
{
    vertex_shader   = 0x0, ///< Vertex shader.
    geometry_shader = 0x1  ///< Geometry shader.
}
