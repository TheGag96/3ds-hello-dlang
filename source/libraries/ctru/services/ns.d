/**
 * @file ns.h
 * @brief NS (Nintendo Shell) service.
 */

module ctru.services.ns;

import ctru.types; 

extern (C): nothrow: @nogc:

/// Initializes NS.
Result nsInit();

/// Exits NS.
void nsExit();

/**
 * @brief Launches a title and the required firmware (only if necessary).
 * @param titleid ID of the title to launch, 0 for gamecard, JPN System Settings' titleID for System Settings.
 */
Result NS_LaunchFIRM(ulong titleid);

/**
 * @brief Launches a title.
 * @param titleid ID of the title to launch, or 0 for gamecard.
 * @param launch_flags Flags used when launching the title.
 * @param procid Pointer to write the process ID of the launched title to.
 */
Result NS_LaunchTitle(ulong titleid, uint launch_flags, uint* procid);

/// Terminates the application from which this function is called
Result NS_TerminateTitle();
/**
 * @brief Launches a title and the required firmware.
 * @param titleid ID of the title to launch, 0 for gamecard.
 * @param flags Flags for firm-launch. bit0: require an application title-info structure in FIRM paramters to be specified via FIRM parameters. bit1: if clear, NS will check certain Configuration Memory fields.
 */
Result NS_LaunchApplicationFIRM(ulong titleid, uint flags);

/**
 * @brief Reboots to a title.
 * @param mediatype Mediatype of the title.
 * @param titleid ID of the title to launch.
 */
Result NS_RebootToTitle(ubyte mediatype, ulong titleid);

/**
 * @brief Terminates the process with the specified titleid.
 * @param titleid ID of the title to terminate.
 * @param timeout Timeout in nanoseconds. Pass 0 if not required.
 */
Result NS_TerminateProcessTID(ulong titleid, ulong timeout);

/// Reboots the system
Result NS_RebootSystem();
