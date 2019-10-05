/**
 * @file hb.h
 * @brief HB (Homebrew) service.
 */

module ctru.services.hb;

import ctru.types;

extern (C):

// WARNING ! THIS FILE PROVIDES AN INTERFACE TO A NON-OFFICIAL SERVICE PROVIDED BY NINJHAX
// BY USING COMMANDS FROM THIS SERVICE YOU WILL LIKELY MAKE YOUR APPLICATION INCOMPATIBLE WITH OTHER HOMEBREW LAUNCHING METHODS
// A GOOD WAY TO COPE WITH THIS IS TO CHECK THE OUTPUT OF hbInit FOR ERRORS

/// Initializes HB.
Result hbInit();

/// Exits HB.
void hbExit();

/// Flushes/invalidates the entire data/instruction cache.
Result HB_FlushInvalidateCache();

/**
 * @brief Fetches the address for Ninjhax 1.x bootloader addresses.
 * @param load3dsx void(*callBootloader)(Handle hb, Handle file);
 * @param setArgv void(*setArgs)(u32* src, u32 length);
 */
Result HB_GetBootloaderAddresses(void** load3dsx, void** setArgv);

/**
 * @brief Changes the permissions of a given number of pages at address addr to mode.
 * Should it fail, the appropriate kernel error code will be returned and *reprotectedPages(if not NULL)
 * will be set to the number of sequential pages which were successfully reprotected + 1
 * @param addr Address to reprotect.
 * @param pages Number of pages to reprotect.
 * @param mode Mode to reprotect to.
 * @param reprotectedPages Number of successfully reprotected pages, on failure.
 */
Result HB_ReprotectMemory(uint* addr, uint pages, uint mode, uint* reprotectedPages);
