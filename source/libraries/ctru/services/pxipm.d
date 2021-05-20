/**
 * @file pxipm.h
 * @brief Process Manager PXI service
 */

module ctru.services.pxipm;

import ctru.types;
import ctru.exheader;
import ctru.services.fs;

extern (C): nothrow: @nogc:

/// Initializes PxiPM.
Result pxiPmInit();

/// Exits PxiPM.
void pxiPmExit();

/**
 * @brief Gets the current PxiPM session handle.
 * @return The current PxiPM session handle.
 */
Handle* pxiPmGetSessionHandle();

/**
 * @brief Retrives the exheader information set(s) (SCI+ACI) about a program.
 * @param exheaderInfos[out] Pointer to the output exheader information set.
 * @param programHandle The program handle.
 */
Result PXIPM_GetProgramInfo(ExHeader_Info* exheaderInfo, ulong programHandle);

/**
 * @brief Loads a program and registers it to Process9.
 * @param programHandle[out] Pointer to the output the program handle to.
 * @param programInfo Information about the program to load.
 * @param updateInfo Information about the program update to load.
 */
Result PXIPM_RegisterProgram(ulong* programHandle, const(FS_ProgramInfo)* programInfo, const(FS_ProgramInfo)* updateInfo);

/**
 * @brief Unloads a program and unregisters it from Process9.
 * @param programHandle The program handle.
 */
Result PXIPM_UnregisterProgram(ulong programHandle);
