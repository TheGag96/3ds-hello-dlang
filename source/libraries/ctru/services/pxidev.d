/**
 * @file pxidev.h
 * @brief Gamecard PXI service.
 */

module ctru.services.pxidev;

import ctru.types;
import ctru.services.fs;

extern (C): nothrow: @nogc:

/// Card SPI wait operation type.
enum PXIDEVWaitType : ubyte
{
    none          = 0, ///< Do not wait.
    sleep         = 1, ///< Sleep for the specified number of nanoseconds.
    ireq_return   = 2, ///< Wait for IREQ, return if timeout.
    ireq_continue = 3  ///< Wait for IREQ, continue if timeout.
}

/// Card SPI register deassertion type.
enum PXIDEVDeassertType : ubyte
{
    none        = 0, ///< Do not deassert.
    before_wait = 1, ///< Deassert before waiting.
    after_wait  = 2  ///< Deassert after waiting.
}

/// Card SPI transfer buffer.
struct PXIDEV_SPIBuffer
{
    void* ptr; ///< Data pointer.
    uint size; ///< Data size.
    ubyte transferOption; ///< Transfer options. See @ref pxiDevMakeTransferOption
    ulong waitOperation; ///< Wait operation. See @ref pxiDevMakeWaitOperation
}

/// Initializes pxi:dev.
Result pxiDevInit();

/// Shuts down pxi:dev.
void pxiDevExit();

/**
 * @brief Creates a packed card SPI transfer option value.
 * @param baudRate Baud rate to use when transferring.
 * @param busMode Bus mode to use when transferring.
 * @return A packed card SPI transfer option value.
 */
pragma(inline, true)
ubyte pxiDevMakeTransferOption(
    FSCardSPIBaudRate baudRate,
    FSCardSPIBusMode busMode)
{
    return (baudRate & 0x3F) | ((busMode & 0x3) << 6);
}

/**
 * @brief Creates a packed card SPI wait operation value.
 * @param waitTypnbe Type of wait to perform.
 * @param deassertType Type of register deassertion to perform.
 * @param timeout Timeout, in nanoseconds, to wait, if applicable.
 * @return A packed card SPI wait operation value.
 */
pragma(inline, true)
ulong pxiDevMakeWaitOperation(
    PXIDEVWaitType waitType,
    PXIDEVDeassertType deassertType,
    ulong timeout)
{
    return (waitType & 0xF) | ((deassertType & 0xF) << 4) | ((timeout & 0xFFFFFFFFFFFFFF) << 8);
}

/**
 * @brief Performs multiple card SPI writes and reads.
 * @param header Header to lead the transfers with. Must be, at most, 8 bytes in size.
 * @param writeBuffer1 Buffer to make first transfer from.
 * @param readBuffer1 Buffer to receive first response to.
 * @param writeBuffer2 Buffer to make second transfer from.
 * @param readBuffer2 Buffer to receive second response to.
 * @param footer Footer to follow the transfers with. Must be, at most, 8 bytes in size. Wait operation is unused.
 */
Result PXIDEV_SPIMultiWriteRead(PXIDEV_SPIBuffer* header, PXIDEV_SPIBuffer* writeBuffer1, PXIDEV_SPIBuffer* readBuffer1, PXIDEV_SPIBuffer* writeBuffer2, PXIDEV_SPIBuffer* readBuffer2, PXIDEV_SPIBuffer* footer);

/**
 * @brief Performs a single card SPI write and read.
 * @param bytesRead Pointer to output the number of bytes received to.
 * @param initialWaitOperation Wait operation to perform before transferring data.
 * @param writeBuffer Buffer to transfer data from.
 * @param readBuffer Buffer to receive data to.
 */
Result PXIDEV_SPIWriteRead(uint* bytesRead, ulong initialWaitOperation, PXIDEV_SPIBuffer* writeBuffer, PXIDEV_SPIBuffer* readBuffer);
