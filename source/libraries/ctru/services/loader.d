/**
 * @file loader.h
 * @brief LOADER Service
 */

module ctru.services.loader;

import ctru.types;
import ctru.exheader;
import ctru.services.fs;

extern (C): nothrow: @nogc:

/// Initializes LOADER.
Result loaderInit();

/// Exits LOADER.
void loaderExit();

/**
 * @brief Loads a program and returns a process handle to the newly created process.
 * @param[out] process Pointer to output the process handle to.
 * @param programHandle The handle of the program to load.
 */
Result LOADER_LoadProcess(Handle* process, ulong programHandle);

/**
 * @brief Registers a program (along with its update).
 * @param[out] programHandle Pointer to output the program handle to.
 * @param programInfo The program info.
 * @param programInfo The program update info.
 */
Result LOADER_RegisterProgram(ulong* programHandle, const(FS_ProgramInfo)* programInfo, const(FS_ProgramInfo)* programInfoUpdate);

/**
 * @brief Unregisters a program (along with its update).
 * @param programHandle The handle of the program to unregister.
 */
Result LOADER_UnregisterProgram(ulong programHandle);

/**
 * @brief Retrives a program's main NCCH extended header info (SCI + ACI, see @ref ExHeader_Info).
 * @param[out] exheaderInfo Pointer to output the main NCCH extended header info.
 * @param programHandle The handle of the program to unregister
 */
Result LOADER_GetProgramInfo(ExHeader_Info* exheaderInfo, ulong programHandle);
