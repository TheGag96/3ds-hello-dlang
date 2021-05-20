/**
 * @file ampxi.h
 * @brief AMPXI service. This is normally not accessible to userland apps. https://3dbrew.org/wiki/Application_Manager_Services_PXI
 */

module ctru.services.ampxi;

import ctru.types;
import ctru.services.fs;

extern (C): nothrow: @nogc:

/**
 * @brief Initializes AMPXI.
 * @param servhandle Optional service session handle to use for AMPXI, if zero srvGetServiceHandle() will be used.
 */
Result ampxiInit(Handle servhandle);

/// Exits AMPXI.
void ampxiExit();

/**
 * @brief Writes a TWL save-file to NAND. https://www.3dbrew.org/wiki/AMPXI:WriteTWLSavedata
 * @param titleid ID of the TWL title.
 * @param buffer Savedata buffer ptr.
 * @param size Size of the savedata buffer.
 * @param image_filepos Filepos to use for writing the data to the NAND savedata file.
 * @param section_type https://www.3dbrew.org/wiki/AMPXI:WriteTWLSavedata
 * @param operation https://3dbrew.org/wiki/AM:ImportDSiWare
 */
Result AMPXI_WriteTWLSavedata(ulong titleid, ubyte* buffer, uint size, uint image_filepos, ubyte section_type, ubyte operation);

/**
 * @brief Finalizes title installation. https://3dbrew.org/wiki/AMPXI:InstallTitlesFinish
 * @param mediaType Mediatype of the titles to finalize.
 * @param db Which title database to use.
 * @param size Size of the savedata buffer.
 * @param titlecount Total titles.
 * @param tidlist List of titleIDs.
 */
Result AMPXI_InstallTitlesFinish(FSMediaType mediaType, ubyte db, uint titlecount, ulong* tidlist);
