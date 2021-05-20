/**
 * @file dsp.h
 * @brief DSP Service to access the DSP processor commands(sound)
 *
 * The DSP has access to the Linear memory region, and to the DSP memory region if allowed in the exheader.
 */

module ctru.services.dsp;

import ctru.types;

extern (C): nothrow: @nogc:

/// DSP interrupt types.
enum DSPInterruptType : ubyte
{
    pipe = 2 ///< Pipe interrupt.
}

/// DSP pipe directions.
enum DSPPipeDirection : ubyte
{
    input  = 0, ///< DSP to ARM
    output = 1  ///< ARM to DSP
}

/**
 * @brief Initializes the dsp service.
 *
 * Call this before calling any DSP_* function.
 * @note This will also unload any previously loaded DSP binary.
 *       It is done this way since you have to provide your binary when the 3DS leaves sleep mode anyway.
 */
Result dspInit();

/**
 * @brief Closes the dsp service.
 * @note This will also unload the DSP binary.
 */
void dspExit();

/**
 * @brief Checks if a headphone is inserted.
 * @param is_inserted Pointer to output the insertion status to.
 */
Result DSP_GetHeadphoneStatus(bool* is_inserted);

/**
 * @brief Flushes the cache
 * @param address   Beginning of the memory range to flush, inside the Linear or DSP memory regions
 * @param size      Size of the memory range to flush
 *
 * Flushes the cache for the specified memory range and invalidates the cache
 */
Result DSP_FlushDataCache(const(void)* address, uint size);

/**
 * @brief Invalidates the cache
 * @param address   Beginning of the memory range to invalidate, inside the Linear or DSP memory regions
 * @param size      Size of the memory range to flush
 *
 * Invalidates the cache for the specified memory range
 */
Result DSP_InvalidateDataCache(const(void)* address, uint size);

/**
 * @brief Retrieves the handle of the DSP semaphore.
 * @param semaphore Pointer to output the semaphore to.
 */
Result DSP_GetSemaphoreHandle(Handle* semaphore);

/**
 * @brief Sets the DSP hardware semaphore value.
 * @param value Value to set.
 */
Result DSP_SetSemaphore(ushort value);

/**
 * @brief Masks the DSP hardware semaphore value.
 * @param mask Mask to apply.
 */
Result DSP_SetSemaphoreMask(ushort mask);

/**
 * @brief Loads a DSP binary and starts the DSP
 * @param component The program file address in memory
 * @param size      The size of the program
 * @param prog_mask DSP memory block related ? Default is 0xff.
 * @param data_mask DSP memory block related ? Default is 0xff.
 * @param is_loaded Indicates if the DSP was succesfully loaded.
 *
 * @note The binary must be signed(http://3dbrew.org/wiki/DSP_Binary)
 * @note Seems to be called when the 3ds leaves the Sleep mode
 */
Result DSP_LoadComponent(const(void)* component, uint size, ushort prog_mask, ushort data_mask, bool* is_loaded);

///Stops the DSP by unloading the binary.
Result DSP_UnloadComponent();

/**
 * @brief Registers an event handle with the DSP through IPC
 * @param handle Event handle to register.
 * @param interrupt The type of interrupt that will trigger the event. Usual value is DSP_INTERRUPT_PIPE.
 * @param channel The pipe channel. Usual value is 2
 *
 * @note It is possible that interrupt are inverted
 */
Result DSP_RegisterInterruptEvents(Handle handle, uint interrupt, uint channel);

/**
 * @brief Reads a pipe if possible.
 * @param channel     unknown. Usually 2
 * @param peer        unknown. Usually 0
 * @param buffer      The buffer that will store the values read from the pipe
 * @param length      Length of the buffer
 * @param length_read Number of bytes read by the command
 */
Result DSP_ReadPipeIfPossible(uint channel, uint peer, void* buffer, ushort length, ushort* length_read);

/**
 * @param Writes to a pipe.
 * @param channel unknown. Usually 2
 * @param buffer  The message to send to the DSP process
 * @param length  Length of the message
 */
Result DSP_WriteProcessPipe(uint channel, const(void)* buffer, uint length);

/**
 * @brief Converts a DSP memory address to a virtual address usable by the process.
 * @param dsp_address Address to convert.
 * @param arm_address Pointer to output the converted address to.
 */
Result DSP_ConvertProcessAddressFromDspDram(uint dsp_address, uint* arm_address);

/**
 * @brief Reads a DSP register
 * @param regNo Offset of the hardware register, base address is 0x1EC40000
 * @param value Pointer to read the register value to.
 */
Result DSP_RecvData(ushort regNo, ushort* value);

/**
 * @brief Checks if you can read a DSP register
 * @param regNo Offset of the hardware register, base address is 0x1EC40000
 * @param is_ready Pointer to write the ready status to.
 *
 * @warning This call might hang if the data is not ready. See @ref DSP_SendDataIsEmpty.
 */
Result DSP_RecvDataIsReady(ushort regNo, bool* is_ready);

/**
 * @brief Writes to a DSP register
 * @param regNo Offset of the hardware register, base address is 0x1EC40000
 * @param value Value to write.
 *
 * @warning This call might hang if the SendData is not empty. See @ref DSP_SendDataIsEmpty.
 */
Result DSP_SendData(ushort regNo, ushort value);

/**
 * @brief Checks if you can write to a DSP register ?
 * @param regNo Offset of the hardware register, base address is 0x1EC40000
 * @param is_empty Pointer to write the empty status to.
 */
Result DSP_SendDataIsEmpty(ushort regNo, bool* is_empty);
