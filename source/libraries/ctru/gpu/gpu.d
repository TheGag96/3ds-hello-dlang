/**
 * @file gpu.h
 * @brief Barebones GPU communications driver.
 */

module ctru.gpu.gpu;

import ctru.types;
import ctru.gpu.registers;
import ctru.gpu.enums;

extern (C): nothrow: @nogc:

/// Creates a GPU command header from its write increments, mask, and register.
pragma(inline, true)
extern (D) auto GPUCMD_HEADER(T0, T1, T2)(auto ref T0 incremental, auto ref T1 mask, auto ref T2 reg)
{
    return (incremental << 31) | ((mask & 0xF) << 16) | (reg & 0x3FF);
}

extern __gshared uint* gpuCmdBuf; ///< GPU command buffer.
extern __gshared uint gpuCmdBufSize; ///< GPU command buffer size.
extern __gshared uint gpuCmdBufOffset; ///< GPU command buffer offset.

/**
 * @brief Sets the GPU command buffer to use.
 * @param adr Pointer to the command buffer.
 * @param size Size of the command buffer.
 * @param offset Offset of the command buffer.
 */
pragma(inline, true)
void GPUCMD_SetBuffer(uint* adr, uint size, uint offset)
{
    gpuCmdBuf=adr;
    gpuCmdBufSize=size;
    gpuCmdBufOffset=offset;
}

/**
 * @brief Sets the offset of the GPU command buffer.
 * @param offset Offset of the command buffer.
 */
pragma(inline, true)
void GPUCMD_SetBufferOffset(uint offset)
{
    gpuCmdBufOffset=offset;
}

/**
 * @brief Gets the current GPU command buffer.
 * @param addr Pointer to output the command buffer to.
 * @param size Pointer to output the size(in words) of the command buffer to.
 * @param offset Pointer to output the offset of the command buffer to.
 */
pragma(inline, true)
void GPUCMD_GetBuffer(uint** addr, uint* size, uint* offset)
{
    if(addr)*addr=gpuCmdBuf;
    if(size)*size=gpuCmdBufSize;
    if(offset)*offset=gpuCmdBufOffset;
}

/**
 * @brief Adds raw GPU commands to the current command buffer.
 * @param cmd Buffer containing commands to add.
 * @param size Size of the buffer.
 */
void GPUCMD_AddRawCommands(const(uint)* cmd, uint size);

/**
 * @brief Adds a GPU command to the current command buffer.
 * @param header Header of the command.
 * @param param Parameters of the command.
 * @param paramlength Size of the parameter buffer.
 */
void GPUCMD_Add(uint header, const(uint)* param, uint paramlength);

/**
 * @brief Splits the current GPU command buffer.
 * @param addr Pointer to output the command buffer to.
 * @param size Pointer to output the size(in words) of the command buffer to.
 */
void GPUCMD_Split(uint** addr, uint* size);

/**
 * @brief Converts a 32-bit float to a 16-bit float.
 * @param f Float to convert.
 * @return The converted float.
 */
uint f32tof16(float f);

/**
 * @brief Converts a 32-bit float to a 20-bit float.
 * @param f Float to convert.
 * @return The converted float.
 */
uint f32tof20(float f);

/**
 * @brief Converts a 32-bit float to a 24-bit float.
 * @param f Float to convert.
 * @return The converted float.
 */
uint f32tof24(float f);

/**
 * @brief Converts a 32-bit float to a 31-bit float.
 * @param f Float to convert.
 * @return The converted float.
 */
uint f32tof31(float f);

/// Adds a command with a single parameter to the current command buffer.
pragma(inline, true)
void GPUCMD_AddSingleParam(uint header, uint param)
{
    GPUCMD_Add(header, &param, 1);
}

/// Adds a masked register write to the current command buffer.
pragma(inline, true)
extern (D) auto GPUCMD_AddMaskedWrite(T0, T1, T2)(auto ref T0 reg, auto ref T1 mask, auto ref T2 val)
{
    return GPUCMD_AddSingleParam(GPUCMD_HEADER(0, mask, reg), val);
}

/// Adds a register write to the current command buffer.
pragma(inline, true)
extern (D) auto GPUCMD_AddWrite(T0, T1)(auto ref T0 reg, auto ref T1 val)
{
    return GPUCMD_AddMaskedWrite(reg, 0xF, val);
}

/// Adds multiple masked register writes to the current command buffer.
pragma(inline, true)
extern (D) auto GPUCMD_AddMaskedWrites(T0, T1, T2, T3)(auto ref T0 reg, auto ref T1 mask, auto ref T2 vals, auto ref T3 num)
{
    return GPUCMD_Add(GPUCMD_HEADER(0, mask, reg), vals, num);
}

/// Adds multiple register writes to the current command buffer.
pragma(inline, true)
extern (D) auto GPUCMD_AddWrites(T0, T1, T2)(auto ref T0 reg, auto ref T1 vals, auto ref T2 num)
{
    return GPUCMD_AddMaskedWrites(reg, 0xF, vals, num);
}

/// Adds multiple masked incremental register writes to the current command buffer.
pragma(inline, true)
extern (D) auto GPUCMD_AddMaskedIncrementalWrites(T0, T1, T2, T3)(auto ref T0 reg, auto ref T1 mask, auto ref T2 vals, auto ref T3 num)
{
    return GPUCMD_Add(GPUCMD_HEADER(1, mask, reg), vals, num);
}

/// Adds multiple incremental register writes to the current command buffer.
pragma(inline, true)
extern (D) auto GPUCMD_AddIncrementalWrites(T0, T1, T2)(auto ref T0 reg, auto ref T1 vals, auto ref T2 num)
{
    return GPUCMD_AddMaskedIncrementalWrites(reg, 0xF, vals, num);
}
