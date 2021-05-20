/**
 * @file sdmc.h
 * @brief SDMC driver.
 */

module ctru.sdmc;

import ctru.types;
import ctru.services.fs;

extern (C): nothrow: @nogc:

enum SDMC_DIRITER_MAGIC = 0x73646D63; /* "sdmc" */

/*! Open directory struct */
struct sdmc_dir_t
{
    uint magic; /*! "sdmc" */
    Handle fd; /*! CTRU handle */
    ssize_t index; /*! Current entry index */
    size_t size; /*! Current batch size */
    FS_DirectoryEntry[32] entry_data; /*! Temporary storage for reading entries */
}

/// Initializes the SDMC driver.
Result sdmcInit();

/// Enable/disable copy in sdmc_write
void sdmcWriteSafe(bool enable);

/// Exits the SDMC driver.
Result sdmcExit();

/// Get a file's mtime
Result sdmc_getmtime(const(char)* name, ulong* mtime);
