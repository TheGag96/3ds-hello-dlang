/**
 * @file ptmgets.h
 * @brief PTMGETS Services
 */

module ctru.services.ptmgets;

import ctru.types;

extern (C): nothrow: @nogc:

/// Initializes PTMGETS.
Result ptmGetsInit();

/// Exits PTMGETS.
void ptmGetsExit();

/**
 * @brief Gets a pointer to the current ptm:gets session handle.
 * @return A pointer to the current ptm:gets session handle.
 */
Handle *ptmGetsGetSessionHandle();

/**
 * @brief Gets the system time.
 * @param[out] outMsY2k The pointer to write the number of milliseconds since 01/01/2000 to.
 */
Result PTMGETS_GetSystemTime(long* outMsY2k);