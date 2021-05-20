/**
 * @file irrst.h
 * @brief IRRST service.
 */

module ctru.services.irrst;

import ctru.types;
import ctru.services.hid;

extern (C): nothrow: @nogc:

//See also: http://3dbrew.org/wiki/IR_Services http://3dbrew.org/wiki/IRRST_Shared_Memory

// for circlePosition definition

/// IRRST's shared memory handle.
extern __gshared Handle irrstMemHandle;

/// IRRST's shared memory.
extern __gshared vu32* irrstSharedMem;

/// Initializes IRRST.
Result irrstInit();

/// Exits IRRST.
void irrstExit();

/// Scans IRRST for input.
void irrstScanInput();

/**
 * @brief Gets IRRST's held keys.
 * @return IRRST's held keys.
 */
uint irrstKeysHeld();

/**
 * @brief Reads the current c-stick position.
 * @param pos Pointer to output the current c-stick position to.
 */
void irrstCstickRead(circlePosition* pos);

/**
 * @brief Waits for the IRRST input event to trigger.
 * @param nextEvent Whether to discard the current event and wait until the next event.
 */
void irrstWaitForEvent(bool nextEvent);

/// Macro for irrstCstickRead.
alias hidCstickRead = irrstCstickRead;

/**
 * @brief Gets the shared memory and event handles for IRRST.
 * @param outMemHandle Pointer to write the shared memory handle to.
 * @param outEventHandle Pointer to write the event handle to.
 */
Result IRRST_GetHandles(Handle* outMemHandle, Handle* outEventHandle);

/**
 * @brief Initializes IRRST.
 * @param unk1 Unknown.
 * @param unk2 Unknown.
 */
Result IRRST_Initialize(uint unk1, ubyte unk2);

/// Shuts down IRRST.
Result IRRST_Shutdown();
