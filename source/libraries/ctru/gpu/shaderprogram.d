/**
 * @file shaderProgram.h
 * @brief Functions for working with shaders.
 */

module ctru.gpu.shaderprogram;

import ctru.types;
import ctru.gpu.shbin;

extern (C): nothrow: @nogc:

/// 24-bit float uniforms.
struct float24Uniform_s
{
    uint id; ///< Uniform ID.
    uint[3] data; ///< Uniform data.
}

/// Describes an instance of either a vertex or geometry shader.
struct shaderInstance_s
{
    DVLE_s* dvle; ///< Shader DVLE.
    ushort boolUniforms; ///< Boolean uniforms.
    ushort boolUniformMask; ///< Used boolean uniform mask.
    uint[4] intUniforms; ///< Integer uniforms.
    float24Uniform_s* float24Uniforms; ///< 24-bit float uniforms.
    ubyte intUniformMask; ///< Used integer uniform mask.
    ubyte numFloat24Uniforms; ///< Float uniform count.
}

/// Describes an instance of a full shader program.
struct shaderProgram_s
{
    shaderInstance_s* vertexShader; ///< Vertex shader.
    shaderInstance_s* geometryShader; ///< Geometry shader.
    uint[2] geoShaderInputPermutation; ///< Geometry shader input permutation.
    ubyte geoShaderInputStride; ///< Geometry shader input stride.
}

/**
 * @brief Initializes a shader instance.
 * @param si Shader instance to initialize.
 * @param dvle DVLE to initialize the shader instance with.
 */
Result shaderInstanceInit(shaderInstance_s* si, DVLE_s* dvle);

/**
 * @brief Frees a shader instance.
 * @param si Shader instance to free.
 */
Result shaderInstanceFree(shaderInstance_s* si);

/**
 * @brief Sets a bool uniform of a shader.
 * @param si Shader instance to use.
 * @param id ID of the bool uniform.
 * @param value Value to set.
 */
Result shaderInstanceSetBool(shaderInstance_s* si, int id, bool value);

/**
 * @brief Gets a bool uniform of a shader.
 * @param si Shader instance to use.
 * @param id ID of the bool uniform.
 * @param value Pointer to output the value to.
 */
Result shaderInstanceGetBool(shaderInstance_s* si, int id, bool* value);

/**
 * @brief Gets the location of a shader's uniform.
 * @param si Shader instance to use.
 * @param name Name of the uniform.
 */
byte shaderInstanceGetUniformLocation(shaderInstance_s* si, const(char)* name);

/**
 * @brief Initializes a shader program.
 * @param sp Shader program to initialize.
 */
Result shaderProgramInit(shaderProgram_s* sp);

/**
 * @brief Frees a shader program.
 * @param sp Shader program to free.
 */
Result shaderProgramFree(shaderProgram_s* sp);

/**
 * @brief Sets the vertex shader of a shader program.
 * @param sp Shader program to use.
 * @param dvle Vertex shader to set.
 */
Result shaderProgramSetVsh(shaderProgram_s* sp, DVLE_s* dvle);

/**
 * @brief Sets the geometry shader of a shader program.
 * @param sp Shader program to use.
 * @param dvle Geometry shader to set.
 * @param stride Input stride of the shader(pass 0 to match the number of outputs of the vertex shader).
 */
Result shaderProgramSetGsh(shaderProgram_s* sp, DVLE_s* dvle, ubyte stride);

/**
 * @brief Configures the permutation of the input attributes of the geometry shader of a shader program.
 * @param sp Shader program to use.
 * @param permutation Attribute permutation to use.
 */
Result shaderProgramSetGshInputPermutation(shaderProgram_s* sp, ulong permutation);

/**
 * @brief Configures the shader units to use the specified shader program.
 * @param sp Shader program to use.
 * @param sendVshCode When true, the vertex shader's code and operand descriptors are uploaded.
 * @param sendGshCode When true, the geometry shader's code and operand descriptors are uploaded.
 */
Result shaderProgramConfigure(shaderProgram_s* sp, bool sendVshCode, bool sendGshCode);

/**
 * @brief Same as shaderProgramConfigure, but always loading code/operand descriptors and uploading DVLE constants afterwards.
 * @param sp Shader program to use.
 */
Result shaderProgramUse(shaderProgram_s* sp);
