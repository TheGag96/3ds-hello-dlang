/**
 * @file ptmsysm.h
 * @brief PTMSYSM service.
 */

module ctru.services.ptmsysm;

import ctru.types;

extern (C): nothrow: @nogc:

/// Initializes ptm:sysm.
Result ptmSysmInit();

/// Exits ptm:sysm.
void ptmSysmExit();

/**
 * @brief return 1 if it's a New 3DS otherwise, return 0 for Old 3DS.
 */
Result PTMSYSM_CheckNew3DS();

/**
 * @brief Configures the New 3DS' CPU clock speed and L2 cache.
 * @param value Bit0: enable higher clock, Bit1: enable L2 cache.
 */
Result PTMSYSM_ConfigureNew3DSCPU(ubyte value);

/**
 * @brief Trigger a hardware system shutdown via the MCU
 * @param timeout: timeout passed to PMApp:TerminateNonEssential.
 */
Result PTMSYSM_ShutdownAsync(ulong timeout);

/**
 * @brief Trigger a hardware system reboot via the MCU.
 * @param timeout: timeout passed to PMApp:TerminateNonEssential.
 */
Result PTMSYSM_RebootAsync(ulong timeout);
