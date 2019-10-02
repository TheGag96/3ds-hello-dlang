/**
 * @file ipc.h
 * @brief Inter Process Communication helpers
 */

module ctru.ipc;

import ctru.types;

extern(C):

/// IPC buffer access rights.
enum IPC_BufferRights
{
    r  = BIT(1), /// < Readable
    w  = BIT(2), /// < Writable
    rw = r | w   /// < Readable and Writable
}

/**
 * @brief Creates a command header to be used for IPC
 * @param command_id       ID of the command to create a header for.
 * @param normal_params    Size of the normal parameters in words. Up to 63.
 * @param translate_params Size of the translate parameters in words. Up to 63.
 * @return The created IPC header.
 *
 * Normal parameters are sent directly to the process while the translate parameters might go through modifications and checks by the kernel.
 * The translate parameters are described by headers generated with the IPC_Desc_* functions.
 *
 * @note While #normal_params is equivalent to the number of normal parameters, #translate_params includes the size occupied by the translate parameters headers.
 */
uint IPC_MakeHeader(
    ushort command_id,
    uint normal_params,
    uint translate_params);

/**
 * @brief Creates a header to share handles
 * @param number The number of handles following this header. Max 64.
 * @return The created shared handles header.
 *
 * The #number next values are handles that will be shared between the two processes.
 *
 * @note Zero values will have no effect.
 */
uint IPC_Desc_SharedHandles(uint number);

/**
 * @brief Creates the header to transfer handle ownership
 * @param number The number of handles following this header. Max 64.
 * @return The created handle transfer header.
 *
 * The #number next values are handles that will be duplicated and closed by the other process.
 *
 * @note Zero values will have no effect.
 */
uint IPC_Desc_MoveHandles(uint number);

/**
 * @brief Returns the code to ask the kernel to fill the handle with the current process ID.
 * @return The code to request the current process ID.
 *
 * The next value is a placeholder that will be replaced by the current process ID by the kernel.
 */
uint IPC_Desc_CurProcessId();

uint IPC_Desc_CurProcessHandle();

/**
 * @brief Creates a header describing a static buffer.
 * @param size      Size of the buffer. Max ?0x03FFFF?.
 * @param buffer_id The Id of the buffer. Max 0xF.
 * @return The created static buffer header.
 *
 * The next value is a pointer to the buffer. It will be copied to TLS offset 0x180 + static_buffer_id*8.
 */
uint IPC_Desc_StaticBuffer(size_t size, uint buffer_id);

/**
 * @brief Creates a header describing a buffer to be sent over PXI.
 * @param size         Size of the buffer. Max 0x00FFFFFF.
 * @param buffer_id    The Id of the buffer. Max 0xF.
 * @param is_read_only true if the buffer is read-only. If false, the buffer is considered to have read-write access.
 * @return The created PXI buffer header.
 *
 * The next value is a phys-address of a table located in the BASE memregion.
 */
uint IPC_Desc_PXIBuffer(size_t size, uint buffer_id, bool is_read_only);

/**
 * @brief Creates a header describing a buffer from the main memory.
 * @param size   Size of the buffer. Max 0x0FFFFFFF.
 * @param rights The rights of the buffer for the destination process.
 * @return The created buffer header.
 *
 * The next value is a pointer to the buffer.
 */
uint IPC_Desc_Buffer(size_t size, IPC_BufferRights rights);
