/**
 * @file pmdbg.h
 * @brief PM (Process Manager) debug service.
 */

module ctru.services.pmdbg;

import ctru.types;
import ctru.services.pmapp;
import ctru.services.fs;

extern (C): nothrow: @nogc:

/// Initializes pm:dbg.
Result pmDbgInit();

/// Exits pm:dbg.
void pmDbgExit();

/**
 * @brief Gets the current pm:dbg session handle.
 * @return The current pm:dbg session handle.
 */
Handle* pmDbgGetSessionHandle();

/**
 * @brief Enqueues an application for debug after setting cpuTime to 0, and returns a debug handle to it.
 * If another process was enqueued, this just calls @ref RunQueuedProcess instead.
 * @param[out] Pointer to output the debug handle to.
 * @param programInfo Program information of the title.
 * @param launchFlags Flags to launch the title with.
 */
Result PMDBG_LaunchAppDebug(Handle* outDebug, const(FS_ProgramInfo)* programInfo, uint launchFlags);

/**
 * @brief Launches an application for debug after setting cpuTime to 0.
 * @param programInfo Program information of the title.
 * @param launchFlags Flags to launch the title with.
 */
Result PMDBG_LaunchApp(const(FS_ProgramInfo)* programInfo, uint launchFlags);

/**
 * @brief Runs the queued process and returns a debug handle to it.
 * @param[out] Pointer to output the debug handle to.
 */
Result PMDBG_RunQueuedProcess(Handle* outDebug);
