/**
 * @file cfgnor.h
 * @brief CFGNOR service.
 */

module ctru.services.cfgnor;

import ctru.types;

extern (C): nothrow: @nogc:

/**
 * @brief Initializes CFGNOR.
 * @param value Unknown, usually 1.
 */
Result cfgnorInit (ubyte value);

/// Exits CFGNOR
void cfgnorExit ();

/**
 * @brief Dumps the NOR flash.
 * @param buf Buffer to dump to.
 * @param size Size of the buffer.
 */
Result cfgnorDumpFlash (uint* buf, uint size);

/**
 * @brief Writes the NOR flash.
 * @param buf Buffer to write from.
 * @param size Size of the buffer.
 */
Result cfgnorWriteFlash (uint* buf, uint size);

/**
 * @brief Initializes the CFGNOR session.
 * @param value Unknown, usually 1.
 */
Result CFGNOR_Initialize (ubyte value);

/// Shuts down the CFGNOR session.
Result CFGNOR_Shutdown ();

/**
 * @brief Reads data from NOR.
 * @param offset Offset to read from.
 * @param buf Buffer to read data to.
 * @param size Size of the buffer.
 */
Result CFGNOR_ReadData (uint offset, uint* buf, uint size);

/**
 * @brief Writes data to NOR.
 * @param offset Offset to write to.
 * @param buf Buffer to write data from.
 * @param size Size of the buffer.
 */
Result CFGNOR_WriteData (uint offset, uint* buf, uint size);
