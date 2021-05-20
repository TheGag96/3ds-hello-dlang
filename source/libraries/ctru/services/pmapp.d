/**
 * @file pmapp.h
 * @brief PM (Process Manager) application service.
 */

module ctru.services.pmapp;

import ctru.types;
import ctru.exheader;
import ctru.services.fs;

extern (C): nothrow: @nogc:

/// Launch flags for PM launch commands.
enum
{
    PMLAUNCHFLAG_NORMAL_APPLICATION = BIT(0),
    PMLAUNCHFLAG_LOAD_DEPENDENCIES = BIT(1),
    PMLAUNCHFLAG_NOTIFY_TERMINATION = BIT(2),
    PMLAUNCHFLAG_QUEUE_DEBUG_APPLICATION = BIT(3),
    PMLAUNCHFLAG_TERMINATION_NOTIFICATION_MASK = 0xF0,
    PMLAUNCHFLAG_FORCE_USE_O3DS_APP_MEM = BIT(8), ///< Forces the usage of the O3DS system mode app memory setting even if N3DS system mode is not "Legacy". Dev4 and Dev5 not supported. N3DS only.
    PMLAUNCHFLAG_FORCE_USE_O3DS_MAX_APP_MEM = BIT(9), ///< In conjunction with the above, forces the 96MB app memory setting. N3DS only.
    PMLAUNCHFLAG_USE_UPDATE_TITLE = BIT(16)
}

/// Initializes pm:app.
Result pmAppInit();

/// Exits pm:app.
void pmAppExit();

/**
 * @brief Gets the current pm:app session handle.
 * @return The current pm:app session handle.
 */
Handle* pmAppGetSessionHandle();

/**
 * @brief Launches a title.
 * @param programInfo Program information of the title.
 * @param launchFlags Flags to launch the title with.
 */
Result PMAPP_LaunchTitle(const(FS_ProgramInfo)* programInfo, uint launchFlags);

/**
 * @brief Launches a title, applying patches.
 * @param programInfo Program information of the title.
 * @param programInfoUpdate Program information of the update title.
 * @param launchFlags Flags to launch the title with.
 */
Result PMAPP_LaunchTitleUpdate(const(FS_ProgramInfo)* programInfo, const(FS_ProgramInfo)* programInfoUpdate, uint launchFlags);

/**
 * @brief Gets a title's ExHeader Arm11CoreInfo and SystemInfo flags.
 * @param[out] outCoreInfo Pointer to write the ExHeader Arm11CoreInfo to.
 * @param[out] outSiFlags Pointer to write the ExHeader SystemInfo flags to.
 * @param programInfo Program information of the title.
 */
Result PMAPP_GetTitleExheaderFlags(ExHeader_Arm11CoreInfo* outCoreInfo, ExHeader_SystemInfoFlags* outSiFlags, const(FS_ProgramInfo)* programInfo);

/**
 * @brief Sets the current FIRM launch parameters.
 * @param size Size of the FIRM launch parameter buffer.
 * @param in Buffer to retrieve the launch parameters from.
 */
Result PMAPP_SetFIRMLaunchParams(uint size, const(void)* in_);

/**
 * @brief Gets the current FIRM launch parameters.
 * @param size Size of the FIRM launch parameter buffer.
 * @param[out] out Buffer to write the launch parameters to.
 */
Result PMAPP_GetFIRMLaunchParams(void* out_, uint size);

/**
 * @brief Sets the current FIRM launch parameters.
 * @param firmTidLow Low Title ID of the FIRM title to launch.
 * @param size Size of the FIRM launch parameter buffer.
 * @param in Buffer to retrieve the launch parameters from.
 */
Result PMAPP_LaunchFIRMSetParams(uint firmTidLow, uint size, const(void)* in_);

/**
 * @brief Terminate most processes, to prepare for a reboot or a shutdown.
 * @param timeout Time limit in ns for process termination, after which the remaining processes are killed.
 */
Result PMAPP_PrepareForReboot(long timeout);

/**
 * @brief Terminates the current Application
 * @param timeout Timeout in nanoseconds
 */
Result PMAPP_TerminateCurrentApplication(long timeout);

/**
 * @brief Terminates the processes having the specified titleId.
 * @param titleId Title ID of the processes to terminate
 * @param timeout Timeout in nanoseconds
 */
Result PMAPP_TerminateTitle(ulong titleId, long timeout);

/**
 * @brief Terminates the specified process
 * @param pid Process-ID of the process to terminate
 * @param timeout Timeout in nanoseconds
 */
Result PMAPP_TerminateProcess(uint pid, long timeout);

/**
 * @brief Unregisters a process
 * @param tid TitleID of the process to unregister
 */
Result PMAPP_UnregisterProcess(ulong tid);

/**
 * @brief Sets the APPLICATION cputime reslimit.
 * @param cpuTime Reslimit value.
 * @note cpuTime can be no higher than reslimitdesc[0] & 0x7F in exheader (or 80 if the latter is 0).
 */
Result PMAPP_SetAppResourceLimit(long cpuTime);

/**
 * @brief Gets the APPLICATION cputime reslimit.
 * @param[out] cpuTime Pointer to write the reslimit value to.
 */
Result PMAPP_GetAppResourceLimit(long* outCpuTime);
