/**
 * @file gx.h
 * @brief GX commands.
 */

module ctru.gpu.gx;

import ctru.types;

extern (C): nothrow: @nogc:

/**
 * @brief Creates a buffer dimension parameter from width and height values.
 * @param w buffer width for GX_DisplayTransfer, linesize for GX_TextureCopy
 * @param h buffer height for GX_DisplayTransfer, gap for GX_TextureCopy
 */
pragma(inline, true)
extern (D) auto GX_BUFFER_DIM(T0, T1)(auto ref T0 w, auto ref T1 h)
{
    return (h << 16) | (w & 0xFFFF);
}

/**
 * @brief Supported transfer pixel formats.
 * @sa GSPGPU_FramebufferFormat
 */
enum GxTransferFormat : ubyte
{
    rgba8  = 0, /// < 8-bit Red + 8-bit Green + 8-bit Blue + 8-bit Alpha
    rgb8   = 1, /// < 8-bit Red + 8-bit Green + 8-bit Blue
    rgb565 = 2, /// < 5-bit Red + 6-bit Green + 5-bit Blue
    rgb5a1 = 3, /// < 5-bit Red + 5-bit Green + 5-bit Blue + 1-bit Alpha
    rgba4  = 4  /// < 4-bit Red + 4-bit Green + 4-bit Blue + 4-bit Alpha
}

/**
 * @brief Anti-aliasing modes
 *
 * Please remember that the framebuffer is sideways.
 * Hence if you activate 2x1 anti-aliasing the destination dimensions are w = 240*2 and h = 400
 */
enum GxTransferScale : ubyte
{
    no = 0, /// < No anti-aliasing
    x  = 1, /// < 2x1 anti-aliasing
    xy = 2  /// < 2x2 anti-aliasing
}

/// GX transfer control flags
enum GxFillControl : ushort
{
    trigger      = 0x001, /// < Trigger the PPF event
    finished     = 0x002, /// < Indicates if the memory fill is complete. You should not use it when requesting a transfer.
    bit_depth_16 = 0x000, /// < The buffer has a 16 bit per pixel depth
    bit_depth_24 = 0x100, /// < The buffer has a 24 bit per pixel depth
    bit_depth_32 = 0x200  /// < The buffer has a 32 bit per pixel depth
}

/// Creates a transfer vertical flip flag.
pragma(inline, true)
extern (D) auto GX_TRANSFER_FLIP_VERT(T)(auto ref T x)
{
    return x << 0;
}

/// Creates a transfer tiled output flag.
pragma(inline, true)
extern (D) auto GX_TRANSFER_OUT_TILED(T)(auto ref T x)
{
    return x << 1;
}

/// Creates a transfer raw copy flag.
pragma(inline, true)
extern (D) auto GX_TRANSFER_RAW_COPY(T)(auto ref T x)
{
    return x << 3;
}

/// Creates a transfer input format flag.
pragma(inline, true)
extern (D) auto GX_TRANSFER_IN_FORMAT(T)(auto ref T x)
{
    return x << 8;
}

/// Creates a transfer output format flag.
pragma(inline, true)
extern (D) auto GX_TRANSFER_OUT_FORMAT(T)(auto ref T x)
{
    return x << 12;
}

/// Creates a transfer scaling flag.
pragma(inline, true)
extern (D) auto GX_TRANSFER_SCALING(T)(auto ref T x)
{
    return x << 24;
}

/// Updates gas additive blend results.
enum GX_CMDLIST_UPDATE_GAS_ACC = BIT(0);
/// Flushes the command list.
enum GX_CMDLIST_FLUSH = BIT(1);

extern __gshared uint* gxCmdBuf; ///< GX command buffer.

/// GX command entry
union gxCmdEntry_s
{
    uint[8] data; ///< Raw command data
    struct
    {
        ubyte type; ///< Command type
        ubyte unk1;
        ubyte unk2;
        ubyte unk3;
        uint[7] args; ///< Command arguments
    }
}

/// GX command queue structure
struct tag_gxCmdQueue_s
{
    gxCmdEntry_s* entries; ///< Pointer to array of GX command entries
    ushort maxEntries; ///< Capacity of the command array
    ushort numEntries; ///< Number of commands in the queue
    ushort curEntry; ///< Index of the first pending command to be submitted to GX
    ushort lastEntry; ///< Number of commands completed by GX
    void function (tag_gxCmdQueue_s*) callback; ///< User callback
    void* user; ///< Data for user callback
}

alias gxCmdQueue_s = tag_gxCmdQueue_s;

/**
 * @brief Clears a GX command queue.
 * @param queue The GX command queue.
 */
void gxCmdQueueClear (gxCmdQueue_s* queue);

/**
 * @brief Adds a command to a GX command queue.
 * @param queue The GX command queue.
 * @param entry The GX command to add.
 */
void gxCmdQueueAdd (gxCmdQueue_s* queue, const(gxCmdEntry_s)* entry);

/**
 * @brief Runs a GX command queue, causing it to begin processing incoming commands as they arrive.
 * @param queue The GX command queue.
 */
void gxCmdQueueRun (gxCmdQueue_s* queue);

/**
 * @brief Stops a GX command queue from processing incoming commands.
 * @param queue The GX command queue.
 */
void gxCmdQueueStop (gxCmdQueue_s* queue);

/**
 * @brief Waits for a GX command queue to finish executing pending commands.
 * @param queue The GX command queue.
 * @param timeout Optional timeout (in nanoseconds) to wait (specify -1 for no timeout).
 * @return false if timeout expired, true otherwise.
 */
bool gxCmdQueueWait (gxCmdQueue_s* queue, long timeout);

/**
 * @brief Sets the completion callback for a GX command queue.
 * @param queue The GX command queue.
 * @param callback The completion callback.
 * @param user User data.
 */
pragma(inline, true)
void gxCmdQueueSetCallback (
    gxCmdQueue_s* queue,
    void function (gxCmdQueue_s*) callback,
    void* user)
{
    queue.callback = callback;
    queue.user = user;
}

/**
 * @brief Selects a command queue to which GX_* functions will add commands instead of immediately submitting them to GX.
 * @param queue The GX command queue. (Pass NULL to remove the bound command queue)
 */
void GX_BindQueue (gxCmdQueue_s* queue);

/**
 * @brief Requests a DMA.
 * @param src Source to DMA from.
 * @param dst Destination to DMA to.
 * @param length Length of data to transfer.
 */
Result GX_RequestDma (uint* src, uint* dst, uint length);

/**
 * @brief Processes a GPU command list.
 * @param buf0a Command list address.
 * @param buf0s Command list size.
 * @param flags Flags to process with.
 */
Result GX_ProcessCommandList (uint* buf0a, uint buf0s, ubyte flags);

/**
 * @brief Fills the memory of two buffers with the given values.
 * @param buf0a Start address of the first buffer.
 * @param buf0v Dimensions of the first buffer.
 * @param buf0e End address of the first buffer.
 * @param control0 Value to fill the first buffer with.
 * @param buf1a Start address of the second buffer.
 * @param buf1v Dimensions of the second buffer.
 * @param buf1e End address of the second buffer.
 * @param control1 Value to fill the second buffer with.
 */
Result GX_MemoryFill (uint* buf0a, uint buf0v, uint* buf0e, ushort control0, uint* buf1a, uint buf1v, uint* buf1e, ushort control1);

/**
 * @brief Initiates a display transfer.
 * @note The PPF event will be signaled on completion.
 * @param inadr Address of the input.
 * @param indim Dimensions of the input.
 * @param outadr Address of the output.
 * @param outdim Dimensions of the output.
 * @param flags Flags to transfer with.
 */
Result GX_DisplayTransfer (uint* inadr, uint indim, uint* outadr, uint outdim, uint flags);

/**
 * @brief Initiates a texture copy.
 * @note The PPF event will be signaled on completion.
 * @param inadr Address of the input.
 * @param indim Dimensions of the input.
 * @param outadr Address of the output.
 * @param outdim Dimensions of the output.
 * @param size Size of the data to transfer.
 * @param flags Flags to transfer with.
 */
Result GX_TextureCopy (uint* inadr, uint indim, uint* outadr, uint outdim, uint size, uint flags);

/**
 * @brief Flushes the cache regions of three buffers. (This command cannot be queued in a GX command queue)
 * @param buf0a Address of the first buffer.
 * @param buf0s Size of the first buffer.
 * @param buf1a Address of the second buffer.
 * @param buf1s Size of the second buffer.
 * @param buf2a Address of the third buffer.
 * @param buf2s Size of the third buffer.
 */
Result GX_FlushCacheRegions (uint* buf0a, uint buf0s, uint* buf1a, uint buf1s, uint* buf2a, uint buf2s);
