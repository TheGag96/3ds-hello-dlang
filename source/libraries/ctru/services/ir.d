/**
 * @file ir.h
 * @brief IR service.
 */

module ctru.services.ir;

import ctru.types;

extern (C): nothrow: @nogc:

/**
 * @brief Initializes IRU.
 * The permissions for the specified memory is set to RO. This memory must be already mapped.
 * @param sharedmem_addr Address of the shared memory block to use.
 * @param sharedmem_size Size of the shared memory block.
 */
Result iruInit(uint* sharedmem_addr, uint sharedmem_size);

/// Shuts down IRU.
void iruExit();

/**
 * @brief Gets the IRU service handle.
 * @return The IRU service handle.
 */
Handle iruGetServHandle();

/**
 * @brief Sends IR data.
 * @param buf Buffer to send data from.
 * @param size Size of the buffer.
 * @param wait Whether to wait for the data to be sent.
 */
Result iruSendData(ubyte* buf, uint size, bool wait);

/**
 * @brief Receives IR data.
 * @param buf Buffer to receive data to.
 * @param size Size of the buffer.
 * @param flag Flags to receive data with.
 * @param transfercount Pointer to output the number of bytes read to.
 * @param wait Whether to wait for the data to be received.
 */
Result iruRecvData(ubyte* buf, uint size, ubyte flag, uint* transfercount, bool wait);

/// Initializes the IR session.
Result IRU_Initialize();

/// Shuts down the IR session.
Result IRU_Shutdown();

/**
 * @brief Begins sending data.
 * @param buf Buffer to send.
 * @param size Size of the buffer.
 */
Result IRU_StartSendTransfer(ubyte* buf, uint size);

/// Waits for a send operation to complete.
Result IRU_WaitSendTransfer();

/**
 * @brief Begins receiving data.
 * @param size Size of the data to receive.
 * @param flag Flags to use when receiving.
 */
Result IRU_StartRecvTransfer(uint size, ubyte flag);

/**
 * @brief Waits for a receive operation to complete.
 * @param transfercount Pointer to output the number of bytes read to.
 */
Result IRU_WaitRecvTransfer(uint* transfercount);

/**
 * @brief Sets the IR bit rate.
 * @param value Bit rate to set.
 */
Result IRU_SetBitRate(ubyte value);

/**
 * @brief Gets the IR bit rate.
 * @param out Pointer to write the bit rate to.
 */
Result IRU_GetBitRate(ubyte* out_);

/**
 * @brief Sets the IR LED state.
 * @param value IR LED state to set.
 */
Result IRU_SetIRLEDState(uint value);

/**
 * @brief Gets the IR LED state.
 * @param out Pointer to write the IR LED state to.
 */
Result IRU_GetIRLEDRecvState(uint* out_);
