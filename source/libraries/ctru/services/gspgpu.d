/**
 * @file gspgpu.h
 * @brief GSPGPU service.
 */

module ctru.services.gspgpu;

import ctru.types;
import ctru.gfx;

extern (C):

extern (D) auto GSPGPU_REBASE_REG(T)(auto ref T r)
{
    return r - 0x1EB00000;
}

/// Framebuffer information.
struct GSPGPU_FramebufferInfo
{
    uint active_framebuf; ///< Active framebuffer. (0 = first, 1 = second)
    uint* framebuf0_vaddr; ///< Framebuffer virtual address, for the main screen this is the 3D left framebuffer.
    uint* framebuf1_vaddr; ///< For the main screen: 3D right framebuffer address.
    uint framebuf_widthbytesize; ///< Value for 0x1EF00X90, controls framebuffer width.
    uint format; ///< Framebuffer format, this u16 is written to the low u16 for LCD register 0x1EF00X70.
    uint framebuf_dispselect; ///< Value for 0x1EF00X78, controls which framebuffer is displayed.
    uint unk; ///< Unknown.
}

/// Framebuffer format.
enum GSPGPU_FramebufferFormats
{
    GSP_RGBA8_OES = 0, ///< RGBA8. (4 bytes)
    GSP_BGR8_OES = 1, ///< BGR8. (3 bytes)
    GSP_RGB565_OES = 2, ///< RGB565. (2 bytes)
    GSP_RGB5_A1_OES = 3, ///< RGB5A1. (2 bytes)
    GSP_RGBA4_OES = 4 ///< RGBA4. (2 bytes)
}

/// Capture info entry.
struct GSPGPU_CaptureInfoEntry
{
    uint* framebuf0_vaddr; ///< Left framebuffer.
    uint* framebuf1_vaddr; ///< Right framebuffer.
    uint format; ///< Framebuffer format.
    uint framebuf_widthbytesize; ///< Framebuffer pitch.
}

/// Capture info.
struct GSPGPU_CaptureInfo
{
    GSPGPU_CaptureInfoEntry[2] screencapture; ///< Capture info entries, one for each screen.
}

/// GSPGPU events.
enum GSPGPUEvent
{
    psc0    = 0, ///< Memory fill completed.
    psc1    = 1, ///< TODO
    vblank0 = 2, ///< TODO
    vblank1 = 3, ///< TODO
    ppf     = 4, ///< Display transfer finished.
    p3d     = 5, ///< Command list processing finished.
    dma     = 6, ///< TODO

    max     = 7  ///< Used to know how many events there are.
}

/// Initializes GSPGPU.
Result gspInit();

/// Exits GSPGPU.
void gspExit();

/**
 * @brief Configures a callback to run when a GSPGPU event occurs.
 * @param id ID of the event.
 * @param cb Callback to run.
 * @param data Data to be passed to the callback.
 * @param oneShot When true, the callback is only executed once. When false, the callback is executed every time the event occurs.
 */
void gspSetEventCallback(GSPGPU_Event id, ThreadFunc cb, void* data, bool oneShot);

/**
 * @brief Initializes the GSPGPU event handler.
 * @param gspEvent Event handle to use.
 * @param gspSharedMem GSP shared memory.
 * @param gspThreadId ID of the GSP thread.
 */
Result gspInitEventHandler(Handle gspEvent, vu8* gspSharedMem, ubyte gspThreadId);

/// Exits the GSPGPU event handler.
void gspExitEventHandler();

/**
 * @brief Waits for a GSPGPU event to occur.
 * @param id ID of the event.
 * @param nextEvent Whether to discard the current event and wait for the next event.
 */
void gspWaitForEvent(GSPGPU_Event id, bool nextEvent);

/**
 * @brief Waits for any GSPGPU event to occur.
 * @return The ID of the event that occurred.
 *
 * The function returns immediately if there are unprocessed events at the time of call.
 */
GSPGPU_Event gspWaitForAnyEvent();

/// Waits for PSC0
extern (D) auto gspWaitForPSC0()
{
    return gspWaitForEvent(GSPGPU_Event.GSPGPU_EVENT_PSC0, false);
}

/// Waits for PSC1
extern (D) auto gspWaitForPSC1()
{
    return gspWaitForEvent(GSPGPU_Event.GSPGPU_EVENT_PSC1, false);
}

/// Waits for VBlank.
alias gspWaitForVBlank = gspWaitForVBlank0;

/// Waits for VBlank0.
extern (D) auto gspWaitForVBlank0()
{
    return gspWaitForEvent(GSPGPU_Event.GSPGPU_EVENT_VBlank0, true);
}

/// Waits for VBlank1.
extern (D) auto gspWaitForVBlank1()
{
    return gspWaitForEvent(GSPGPU_Event.GSPGPU_EVENT_VBlank1, true);
}

/// Waits for PPF.
extern (D) auto gspWaitForPPF()
{
    return gspWaitForEvent(GSPGPU_Event.GSPGPU_EVENT_PPF, false);
}

/// Waits for P3D.
extern (D) auto gspWaitForP3D()
{
    return gspWaitForEvent(GSPGPU_Event.GSPGPU_EVENT_P3D, false);
}

/// Waits for DMA.
extern (D) auto gspWaitForDMA()
{
    return gspWaitForEvent(GSPGPU_Event.GSPGPU_EVENT_DMA, false);
}

/**
 * @brief Submits a GX command.
 * @param sharedGspCmdBuf Command buffer to use.
 * @param gxCommand GX command to execute.
 */
Result gspSubmitGxCommand(uint* sharedGspCmdBuf, ref uint[0x8] gxCommand);

/**
 * @brief Acquires GPU rights.
 * @param flags Flags to acquire with.
 */
Result GSPGPU_AcquireRight(ubyte flags);

/// Releases GPU rights.
Result GSPGPU_ReleaseRight();

/**
 * @brief Retrieves display capture info.
 * @param captureinfo Pointer to output capture info to.
 */
Result GSPGPU_ImportDisplayCaptureInfo(GSPGPU_CaptureInfo* captureinfo);

/// Sames the VRAM sys area.
Result GSPGPU_SaveVramSysArea();

/// Restores the VRAM sys area.
Result GSPGPU_RestoreVramSysArea();

/**
 * @brief Sets whether to force the LCD to black.
 * @param flags Whether to force the LCD to black. (0 = no, non-zero = yes)
 */
Result GSPGPU_SetLcdForceBlack(ubyte flags);

/**
 * @brief Updates a screen's framebuffer state.
 * @param screenid ID of the screen to update.
 * @param framebufinfo Framebuffer information to update with.
 */
Result GSPGPU_SetBufferSwap(uint screenid, GSPGPU_FramebufferInfo* framebufinfo);

/**
 * @brief Flushes memory from the data cache.
 * @param adr Address to flush.
 * @param size Size of the memory to flush.
 */
Result GSPGPU_FlushDataCache(const(void)* adr, uint size);

/**
 * @brief Invalidates memory in the data cache.
 * @param adr Address to invalidate.
 * @param size Size of the memory to invalidate.
 */
Result GSPGPU_InvalidateDataCache(const(void)* adr, uint size);

/**
 * @brief Writes to GPU hardware registers.
 * @param regAddr Register address to write to.
 * @param data Data to write.
 * @param size Size of the data to write.
 */
Result GSPGPU_WriteHWRegs(uint regAddr, uint* data, ubyte size);

/**
 * @brief Writes to GPU hardware registers with a mask.
 * @param regAddr Register address to write to.
 * @param data Data to write.
 * @param datasize Size of the data to write.
 * @param maskdata Data of the mask.
 * @param masksize Size of the mask.
 */
Result GSPGPU_WriteHWRegsWithMask(uint regAddr, uint* data, ubyte datasize, uint* maskdata, ubyte masksize);

/**
 * @brief Reads from GPU hardware registers.
 * @param regAddr Register address to read from.
 * @param data Buffer to read data to.
 * @param size Size of the buffer.
 */
Result GSPGPU_ReadHWRegs(uint regAddr, uint* data, ubyte size);

/**
 * @brief Registers the interrupt relay queue.
 * @param eventHandle Handle of the GX command event.
 * @param flags Flags to register with.
 * @param outMemHandle Pointer to output the shared memory handle to.
 * @param threadID Pointer to output the GSP thread ID to.
 */
Result GSPGPU_RegisterInterruptRelayQueue(Handle eventHandle, uint flags, Handle* outMemHandle, ubyte* threadID);

/// Unregisters the interrupt relay queue.
Result GSPGPU_UnregisterInterruptRelayQueue();

/// Triggers a handling of commands written to shared memory.
Result GSPGPU_TriggerCmdReqQueue();

/**
 * @brief Sets 3D_LEDSTATE to the input state value.
 * @param disable False = 3D LED enable, true = 3D LED disable.
 */
Result GSPGPU_SetLedForceOff(bool disable);
