/**
 * @file fs.h
 * @brief Filesystem Services
 */

module ctru.services.fs;

import core.stdc.config;
import ctru.types;

extern (C): nothrow: @nogc:

/// Open flags.
enum
{
    FS_OPEN_READ   = BIT(0), ///< Open for reading.
    FS_OPEN_WRITE  = BIT(1), ///< Open for writing.
    FS_OPEN_CREATE = BIT(2)  ///< Create file.
}

/// Write flags.
enum
{
    FS_WRITE_FLUSH       = BIT(0), ///< Flush.
    FS_WRITE_UPDATE_TIME = BIT(8)  ///< Update file timestamp.
}

/// Attribute flags.
enum
{
    FS_ATTRIBUTE_DIRECTORY = BIT(0),  ///< Directory.
    FS_ATTRIBUTE_HIDDEN    = BIT(8),  ///< Hidden.
    FS_ATTRIBUTE_ARCHIVE   = BIT(16), ///< Archive.
    FS_ATTRIBUTE_READ_ONLY = BIT(24)  ///< Read-only.
}

/// Media types.
enum FSMediaType : ubyte
{
    nand      = 0, ///< NAND.
    sd        = 1, ///< SD card.
    game_card = 2  ///< Game card.
}

/// System media types.
enum FSSystemMediaType : ubyte
{
    ctr_nand  = 0, ///< CTR NAND.
    twl_nand  = 1, ///< TWL NAND.
    sd        = 2, ///< SD card.
    twl_photo = 3  ///< TWL Photo.
}

/// Archive IDs.
enum FSArchiveID : uint
{
    romfs                    = 0x00000003, ///< RomFS archive.
    savedata                 = 0x00000004, ///< Save data archive.
    extdata                  = 0x00000006, ///< Ext data archive.
    shared_extdata           = 0x00000007, ///< Shared ext data archive.
    system_savedata          = 0x00000008, ///< System save data archive.
    sdmc                     = 0x00000009, ///< SDMC archive.
    sdmc_write_only          = 0x0000000A, ///< Write-only SDMC archive.
    boss_extdata             = 0x12345678, ///< BOSS ext data archive.
    card_spifs               = 0x12345679, ///< Card SPI FS archive.
    extdata_and_boss_extdata = 0x1234567B, ///< Ext data and BOSS ext data archive.
    system_savedata2         = 0x1234567C, ///< System save data archive.
    nand_rw                  = 0x1234567D, ///< Read-write NAND archive.
    nand_ro                  = 0x1234567E, ///< Read-only NAND archive.
    nand_ro_write_access     = 0x1234567F, ///< Read-only write access NAND archive.
    savedata_and_content     = 0x2345678A, ///< User save data and ExeFS/RomFS archive.
    savedata_and_content2    = 0x2345678E, ///< User save data and ExeFS/RomFS archive (only ExeFS for fs:LDR).
    nand_ctr_fs              = 0x567890AB, ///< NAND CTR FS archive.
    twl_photo                = 0x567890AC, ///< TWL PHOTO archive.
    twl_sound                = 0x567890AD, ///< TWL SOUND archive.
    nand_twl_fs              = 0x567890AE, ///< NAND TWL FS archive.
    nand_w_fs                = 0x567890AF, ///< NAND W FS archive.
    gamecard_savedata        = 0x567890B1, ///< Game card save data archive.
    user_savedata            = 0x567890B2, ///< User save data archive.
    demo_savedata            = 0x567890B4  ///< Demo save data archive.
}

/// Path types.
enum FSPathType : ubyte
{
    invalid = 0, ///< Invalid path.
    empty   = 1, ///< Empty path.
    binary  = 2, ///< Binary path. Meaning is per-archive.
    ascii   = 3, ///< ASCII text path.
    utf16   = 4  ///< UTF-16 text path.
}

/// Secure value slot.
enum FSSecureValueSlot : ushort
{
    sd = 0x1000 ///< SD application.
}

/// Card SPI baud rate.
enum FSCardSPIBaudRate : ubyte
{
    _512khz = 0, ///< 512KHz.
    _1mhz   = 1, ///< 1MHz.
    _2mhz   = 2, ///< 2MHz.
    _4mhz   = 3, ///< 4MHz.
    _8mhz   = 4, ///< 8MHz.
    _16mhz  = 5  ///< 16MHz.
}

/// Card SPI bus mode.
enum FSCardSPIBusMode : ubyte
{
    _1bit = 0, ///< 1-bit.
    _4bit = 1  ///< 4-bit.
}

/// Card SPI bus mode.
enum FSSpecialContentType : ubyte
{
    update    = 1, ///< Update.
    manual    = 2, ///< Manual.
    dlp_child = 3  ///< DLP child.
}

enum FSCardType : ubyte
{
    ctr = 0, ///< CTR card.
    twl = 1  ///< TWL card.
}

/// FS control actions.
enum FSAction : ubyte
{
    unknown = 0
}

/// Archive control actions.
enum FSArchiveAction : ushort
{
    commit_save_data = 0,      ///< Commits save data changes. No inputs/outputs.
    get_timestamp    = 1,      ///< Retrieves a file's last-modified timestamp. In: "u16*, UTF-16 Path", Out: "u64, Time Stamp".
    unknown          = 0x789D, //< Unknown action; calls FSPXI command 0x56. In: "FS_Path instance", Out: "u32[4], Unknown"
}

/// Secure save control actions.
enum FSSecureSaveAction : ubyte
{
    _delete = 0, ///< Deletes a save's secure value. In: "u64, ((SecureValueSlot << 32) | (TitleUniqueId << 8) | TitleVariation)", Out: "u8, Value Existed"
    format  = 1  ///< Formats a save. No inputs/outputs.
}

/// File control actions.
enum FSFileAction : ubyte
{
    unknown = 0
}

/// Directory control actions.
enum FSDirectoryAction : ubyte
{
    unknown = 0
}

/// Directory entry.
struct FS_DirectoryEntry
{
    ushort[0x106] name; ///< UTF-16 directory name.
    char[0x0A] shortName; ///< File name.
    char[0x04] shortExt; ///< File extension.
    ubyte valid; ///< Valid flag. (Always 1)
    ubyte reserved; ///< Reserved.
    uint attributes; ///< Attributes.
    ulong fileSize; ///< File size.
}

/// Archive resource information.
struct FS_ArchiveResource
{
    uint sectorSize; ///< Size of each sector, in bytes.
    uint clusterSize; ///< Size of each cluster, in bytes.
    uint totalClusters; ///< Total number of clusters.
    uint freeClusters; ///< Number of free clusters.
}

/// Program information.
struct FS_ProgramInfo
{
    import std.bitmanip : bitfields;

    ulong programId;
    mixin(bitfields!(FSMediaType, "mediaType", 8)); ///< Program ID.
    ///< Media type.
    ubyte[7] padding; ///< Padding.
}

/// Product information.
struct FS_ProductInfo
{
    char[0x10] productCode; ///< Product code.
    char[0x2] companyCode; ///< Company code.
    ushort remasterVersion; ///< Remaster version.
}

/// Integrity verification seed.
struct FS_IntegrityVerificationSeed
{
    ubyte[0x10] aesCbcMac; ///< AES-CBC MAC over a SHA256 hash, which hashes the first 0x110-bytes of the cleartext SEED.
    ubyte[0x120] movableSed; ///< The "nand/private/movable.sed", encrypted with AES-CTR using the above MAC for the counter.
}

/// Ext save data information.
struct FS_ExtSaveDataInfo
{
    import std.bitmanip : bitfields;
    align (1):
    mixin(bitfields!(FSMediaType, "mediaType", 8));

    ///< Media type.
    ubyte unknown; ///< Unknown.
    ushort reserved1; ///< Reserved.
    ulong saveId; ///< Save ID.
    uint reserved2; ///< Reserved.
}

/// System save data information.
struct FS_SystemSaveDataInfo
{
    import std.bitmanip : bitfields;
    mixin(bitfields!(FSMediaType, "mediaType", 8));

    ///< Media type.
    ubyte unknown; ///< Unknown.
    ushort reserved; ///< Reserved.
    uint saveId; ///< Save ID.
}

/// Device move context.
struct FS_DeviceMoveContext
{
    ubyte[0x10] ivs; ///< IVs.
    ubyte[0x10] encryptParameter; ///< Encrypt parameter.
}

/// Filesystem path data, detailing the specific target of an operation.
struct FS_Path
{
    FSPathType type; ///< FS path type.
    uint size; ///< FS path size.
    const(void)* data; ///< Pointer to FS path data.
}

/// SDMC/NAND speed information
struct FS_SdMmcSpeedInfo
{
    bool highSpeedModeEnabled;  ///< Whether or not High Speed Mode is enabled.
    bool usesHighestClockRate;  ///< Whether or not a clock divider of 2 is being used.
    ushort sdClkCtrl;           ///< The value of the SD_CLK_CTRL register.
}

/// Filesystem archive handle, providing access to a filesystem's contents.
alias FS_Archive = ulong;

/// Initializes FS.
Result fsInit ();

/// Exits FS.
void fsExit ();

/**
 * @brief Sets the FSUSER session to use in the current thread.
 * @param session The handle of the FSUSER session to use.
 */
void fsUseSession (Handle session);

/// Disables the FSUSER session override in the current thread.
void fsEndUseSession ();

/**
 * @brief Exempts an archive from using alternate FS session handles provided with @ref fsUseSession
 * Instead, the archive will use the default FS session handle, opened with @ref srvGetSessionHandle
 * @param archive Archive to exempt.
 */
void fsExemptFromSession (FS_Archive archive);

/**
 * @brief Unexempts an archive from using alternate FS session handles provided with @ref fsUseSession
 * @param archive Archive to remove from the exemption list.
 */
void fsUnexemptFromSession (FS_Archive archive);

/**
 * @brief Creates an FS_Path instance.
 * @param type Type of path.
 * @param path Path to use.
 * @return The created FS_Path instance.
 */
FS_Path fsMakePath (FSPathType type, const(void)* path);

/**
 * @brief Gets the current FS session handle.
 * @return The current FS session handle.
 */
Handle* fsGetSessionHandle ();

/**
 * @brief Performs a control operation on the filesystem.
 * @param action Action to perform.
 * @param input Buffer to read input from.
 * @param inputSize Size of the input.
 * @param output Buffer to write output to.
 * @param outputSize Size of the output.
 */
Result FSUSER_Control (FSAction action, const(void)* input, uint inputSize, void* output, uint outputSize);

/**
 * @brief Initializes a FSUSER session.
 * @param session The handle of the FSUSER session to initialize.
 */
Result FSUSER_Initialize (Handle session);

/**
 * @brief Opens a file.
 * @param out Pointer to output the file handle to.
 * @param archive Archive containing the file.
 * @param path Path of the file.
 * @param openFlags Flags to open the file with.
 * @param attributes Attributes of the file.
 */
Result FSUSER_OpenFile (Handle* out_, FS_Archive archive, FS_Path path, uint openFlags, uint attributes);

/**
 * @brief Opens a file directly, bypassing the requirement of an opened archive handle.
 * @param out Pointer to output the file handle to.
 * @param archiveId ID of the archive containing the file.
 * @param archivePath Path of the archive containing the file.
 * @param filePath Path of the file.
 * @param openFlags Flags to open the file with.
 * @param attributes Attributes of the file.
 */
Result FSUSER_OpenFileDirectly (Handle* out_, FSArchiveID archiveId, FS_Path archivePath, FS_Path filePath, uint openFlags, uint attributes);

/**
 * @brief Deletes a file.
 * @param archive Archive containing the file.
 * @param path Path of the file.
 */
Result FSUSER_DeleteFile (FS_Archive archive, FS_Path path);

/**
 * @brief Renames a file.
 * @param srcArchive Archive containing the source file.
 * @param srcPath Path of the source file.
 * @param dstArchive Archive containing the destination file.
 * @param dstPath Path of the destination file.
 */
Result FSUSER_RenameFile (FS_Archive srcArchive, FS_Path srcPath, FS_Archive dstArchive, FS_Path dstPath);

/**
 * @brief Deletes a directory, failing if it is not empty.
 * @param archive Archive containing the directory.
 * @param path Path of the directory.
 */
Result FSUSER_DeleteDirectory (FS_Archive archive, FS_Path path);

/**
 * @brief Deletes a directory, also deleting its contents.
 * @param archive Archive containing the directory.
 * @param path Path of the directory.
 */
Result FSUSER_DeleteDirectoryRecursively (FS_Archive archive, FS_Path path);

/**
 * @brief Creates a file.
 * @param archive Archive to create the file in.
 * @param path Path of the file.
 * @param attributes Attributes of the file.
 * @param fileSize Size of the file.
 */
Result FSUSER_CreateFile (FS_Archive archive, FS_Path path, uint attributes, ulong fileSize);

/**
 * @brief Creates a directory
 * @param archive Archive to create the directory in.
 * @param path Path of the directory.
 * @param attributes Attributes of the directory.
 */
Result FSUSER_CreateDirectory (FS_Archive archive, FS_Path path, uint attributes);

/**
 * @brief Renames a directory.
 * @param srcArchive Archive containing the source directory.
 * @param srcPath Path of the source directory.
 * @param dstArchive Archive containing the destination directory.
 * @param dstPath Path of the destination directory.
 */
Result FSUSER_RenameDirectory (FS_Archive srcArchive, FS_Path srcPath, FS_Archive dstArchive, FS_Path dstPath);

/**
 * @brief Opens a directory.
 * @param out Pointer to output the directory handle to.
 * @param archive Archive containing the directory.
 * @param path Path of the directory.
 */
Result FSUSER_OpenDirectory (Handle* out_, FS_Archive archive, FS_Path path);

/**
 * @brief Opens an archive.
 * @param archive Pointer to output the opened archive to.
 * @param id ID of the archive.
 * @param path Path of the archive.
 */
Result FSUSER_OpenArchive (FS_Archive* archive, FSArchiveID id, FS_Path path);

/**
 * @brief Performs a control operation on an archive.
 * @param archive Archive to control.
 * @param action Action to perform.
 * @param input Buffer to read input from.
 * @param inputSize Size of the input.
 * @param output Buffer to write output to.
 * @param outputSize Size of the output.
 */
Result FSUSER_ControlArchive (FS_Archive archive, FSArchiveAction action, const(void)* input, uint inputSize, void* output, uint outputSize);

/**
 * @brief Closes an archive.
 * @param archive Archive to close.
 */
Result FSUSER_CloseArchive (FS_Archive archive);

/**
 * @brief Gets the number of free bytes within an archive.
 * @param freeBytes Pointer to output the free bytes to.
 * @param archive Archive to check.
 */
Result FSUSER_GetFreeBytes (ulong* freeBytes, FS_Archive archive);

/**
 * @brief Gets the inserted card type.
 * @param type Pointer to output the card type to.
 */
Result FSUSER_GetCardType (FSCardType* type);

/**
 * @brief Gets the SDMC archive resource information.
 * @param archiveResource Pointer to output the archive resource information to.
 */
Result FSUSER_GetSdmcArchiveResource (FS_ArchiveResource* archiveResource);

/**
 * @brief Gets the NAND archive resource information.
 * @param archiveResource Pointer to output the archive resource information to.
 */
Result FSUSER_GetNandArchiveResource (FS_ArchiveResource* archiveResource);

/**
 * @brief Gets the last SDMC fatfs error.
 * @param error Pointer to output the error to.
 */
Result FSUSER_GetSdmcFatfsError (uint* error);

/**
 * @brief Gets whether an SD card is detected.
 * @param detected Pointer to output the detection status to.
 */
Result FSUSER_IsSdmcDetected (bool* detected);

/**
 * @brief Gets whether the SD card is writable.
 * @param writable Pointer to output the writable status to.
 */
Result FSUSER_IsSdmcWritable (bool* writable);

/**
 * @brief Gets the SDMC CID.
 * @param out Pointer to output the CID to.
 * @param length Length of the CID buffer. (should be 0x10)
 */
Result FSUSER_GetSdmcCid (ubyte* out_, uint length);

/**
 * @brief Gets the NAND CID.
 * @param out Pointer to output the CID to.
 * @param length Length of the CID buffer. (should be 0x10)
 */
Result FSUSER_GetNandCid (ubyte* out_, uint length);

/**
 * @brief Gets the SDMC speed info.
 * @param speedInfo Pointer to output the speed info to.
 */
Result FSUSER_GetSdmcSpeedInfo (FS_SdMmcSpeedInfo* speedInfo);

/**
 * @brief Gets the NAND speed info.
 * @param speedInfo Pointer to output the speed info to.
 */
Result FSUSER_GetNandSpeedInfo (FS_SdMmcSpeedInfo* speedInfo);

/**
 * @brief Gets the SDMC log.
 * @param out Pointer to output the log to.
 * @param length Length of the log buffer.
 */
Result FSUSER_GetSdmcLog (ubyte* out_, uint length);

/**
 * @brief Gets the NAND log.
 * @param out Pointer to output the log to.
 * @param length Length of the log buffer.
 */
Result FSUSER_GetNandLog (ubyte* out_, uint length);

/// Clears the SDMC log.
Result FSUSER_ClearSdmcLog ();

/// Clears the NAND log.
Result FSUSER_ClearNandLog ();

/**
 * @brief Gets whether a card is inserted.
 * @param inserted Pointer to output the insertion status to.
 */
Result FSUSER_CardSlotIsInserted (bool* inserted);

/**
 * @brief Powers on the card slot.
 * @param status Pointer to output the power status to.
 */
Result FSUSER_CardSlotPowerOn (bool* status);

/**
 * @brief Powers off the card slot.
 * @param status Pointer to output the power status to.
 */
Result FSUSER_CardSlotPowerOff (bool* status);

/**
 * @brief Gets the card's power status.
 * @param status Pointer to output the power status to.
 */
Result FSUSER_CardSlotGetCardIFPowerStatus (bool* status);

/**
 * @brief Executes a CARDNOR direct command.
 * @param commandId ID of the command.
 */
Result FSUSER_CardNorDirectCommand (ubyte commandId);

/**
 * @brief Executes a CARDNOR direct command with an address.
 * @param commandId ID of the command.
 * @param address Address to provide.
 */
Result FSUSER_CardNorDirectCommandWithAddress (ubyte commandId, uint address);

/**
 * @brief Executes a CARDNOR direct read.
 * @param commandId ID of the command.
 * @param size Size of the output buffer.
 * @param output Output buffer.
 */
Result FSUSER_CardNorDirectRead (ubyte commandId, uint size, void* output);

/**
 * @brief Executes a CARDNOR direct read with an address.
 * @param commandId ID of the command.
 * @param address Address to provide.
 * @param size Size of the output buffer.
 * @param output Output buffer.
 */
Result FSUSER_CardNorDirectReadWithAddress (ubyte commandId, uint address, uint size, void* output);

/**
 * @brief Executes a CARDNOR direct write.
 * @param commandId ID of the command.
 * @param size Size of the input buffer.
 * @param output Input buffer.
 */
Result FSUSER_CardNorDirectWrite (ubyte commandId, uint size, const(void)* input);

/**
 * @brief Executes a CARDNOR direct write with an address.
 * @param commandId ID of the command.
 * @param address Address to provide.
 * @param size Size of the input buffer.
 * @param input Input buffer.
 */
Result FSUSER_CardNorDirectWriteWithAddress (ubyte commandId, uint address, uint size, const(void)* input);

/**
 * @brief Executes a CARDNOR 4xIO direct read.
 * @param commandId ID of the command.
 * @param address Address to provide.
 * @param size Size of the output buffer.
 * @param output Output buffer.
 */
Result FSUSER_CardNorDirectRead_4xIO (ubyte commandId, uint address, uint size, void* output);

/**
 * @brief Executes a CARDNOR direct CPU write without verify.
 * @param address Address to provide.
 * @param size Size of the input buffer.
 * @param output Input buffer.
 */
Result FSUSER_CardNorDirectCpuWriteWithoutVerify (uint address, uint size, const(void)* input);

/**
 * @brief Executes a CARDNOR direct sector erase without verify.
 * @param address Address to provide.
 */
Result FSUSER_CardNorDirectSectorEraseWithoutVerify (uint address);

/**
 * @brief Gets a process's product info.
 * @param info Pointer to output the product info to.
 * @param processId ID of the process.
 */
Result FSUSER_GetProductInfo (FS_ProductInfo* info, uint processId);

/**
 * @brief Gets a process's program launch info.
 * @param info Pointer to output the program launch info to.
 * @param processId ID of the process.
 */
Result FSUSER_GetProgramLaunchInfo (FS_ProgramInfo* info, uint processId);

/**
 * @brief Sets the CARDSPI baud rate.
 * @param baudRate Baud rate to set.
 */
Result FSUSER_SetCardSpiBaudRate (FSCardSPIBaudRate baudRate);

/**
 * @brief Sets the CARDSPI bus mode.
 * @param busMode Bus mode to set.
 */
Result FSUSER_SetCardSpiBusMode (FSCardSPIBusMode busMode);

/// Sends initialization info to ARM9.
Result FSUSER_SendInitializeInfoTo9 ();

/**
 * @brief Gets a special content's index.
 * @param index Pointer to output the index to.
 * @param mediaType Media type of the special content.
 * @param programId Program ID owning the special content.
 * @param type Type of special content.
 */
Result FSUSER_GetSpecialContentIndex (ushort* index, FSMediaType mediaType, ulong programId, FSSpecialContentType type);

/**
 * @brief Gets the legacy ROM header of a program.
 * @param mediaType Media type of the program.
 * @param programId ID of the program.
 * @param header Pointer to output the legacy ROM header to. (size = 0x3B4)
 */
Result FSUSER_GetLegacyRomHeader (FSMediaType mediaType, ulong programId, ubyte* header);

/**
 * @brief Gets the legacy banner data of a program.
 * @param mediaType Media type of the program.
 * @param programId ID of the program.
 * @param header Pointer to output the legacy banner data to. (size = 0x23C0)
 */
Result FSUSER_GetLegacyBannerData (FSMediaType mediaType, ulong programId, ubyte* banner);

/**
 * @brief Checks a process's authority to access a save data archive.
 * @param access Pointer to output the access status to.
 * @param mediaType Media type of the save data.
 * @param saveId ID of the save data.
 * @param processId ID of the process to check.
 */
Result FSUSER_CheckAuthorityToAccessExtSaveData (bool* access, FSMediaType mediaType, ulong saveId, uint processId);

/**
 * @brief Queries the total quota size of a save data archive.
 * @param quotaSize Pointer to output the quota size to.
 * @param directories Number of directories.
 * @param files Number of files.
 * @param fileSizeCount Number of file sizes to provide.
 * @param fileSizes File sizes to provide.
 */
Result FSUSER_QueryTotalQuotaSize (ulong* quotaSize, uint directories, uint files, uint fileSizeCount, ulong* fileSizes);

/**
 * @brief Abnegates an access right.
 * @param accessRight Access right to abnegate.
 */
Result FSUSER_AbnegateAccessRight (uint accessRight);

/// Deletes the 3DS SDMC root.
Result FSUSER_DeleteSdmcRoot ();

/// Deletes all ext save data on the NAND.
Result FSUSER_DeleteAllExtSaveDataOnNand ();

/// Initializes the CTR file system.
Result FSUSER_InitializeCtrFileSystem ();

/// Creates the FS seed.
Result FSUSER_CreateSeed ();

/**
 * @brief Retrieves archive format info.
 * @param totalSize Pointer to output the total size to.
 * @param directories Pointer to output the number of directories to.
 * @param files Pointer to output the number of files to.
 * @param duplicateData Pointer to output whether to duplicate data to.
 * @param archiveId ID of the archive.
 * @param path Path of the archive.
 */
Result FSUSER_GetFormatInfo (uint* totalSize, uint* directories, uint* files, bool* duplicateData, FSArchiveID archiveId, FS_Path path);

/**
 * @brief Gets the legacy ROM header of a program.
 * @param headerSize Size of the ROM header.
 * @param mediaType Media type of the program.
 * @param programId ID of the program.
 * @param header Pointer to output the legacy ROM header to.
 */
Result FSUSER_GetLegacyRomHeader2 (uint headerSize, FSMediaType mediaType, ulong programId, ubyte* header);

/**
 * @brief Gets the CTR SDMC root path.
 * @param out Pointer to output the root path to.
 * @param length Length of the output buffer.
 */
Result FSUSER_GetSdmcCtrRootPath (ubyte* out_, uint length);

/**
 * @brief Gets an archive's resource information.
 * @param archiveResource Pointer to output the archive resource information to.
 * @param mediaType System media type to check.
 */
Result FSUSER_GetArchiveResource (FS_ArchiveResource* archiveResource, FSSystemMediaType mediaType);

/**
 * @brief Exports the integrity verification seed.
 * @param seed Pointer to output the seed to.
 */
Result FSUSER_ExportIntegrityVerificationSeed (FS_IntegrityVerificationSeed* seed);

/**
 * @brief Imports an integrity verification seed.
 * @param seed Seed to import.
 */
Result FSUSER_ImportIntegrityVerificationSeed (FS_IntegrityVerificationSeed* seed);

/**
 * @brief Formats save data.
 * @param archiveId ID of the save data archive.
 * @param path Path of the save data.
 * @param blocks Size of the save data in blocks. (512 bytes)
 * @param directories Number of directories.
 * @param files Number of files.
 * @param directoryBuckets Directory hash tree bucket count.
 * @param fileBuckets File hash tree bucket count.
 * @param duplicateData Whether to store an internal duplicate of the data.
 */
Result FSUSER_FormatSaveData (FSArchiveID archiveId, FS_Path path, uint blocks, uint directories, uint files, uint directoryBuckets, uint fileBuckets, bool duplicateData);

/**
 * @brief Gets the legacy sub banner data of a program.
 * @param bannerSize Size of the banner.
 * @param mediaType Media type of the program.
 * @param programId ID of the program.
 * @param header Pointer to output the legacy sub banner data to.
 */
Result FSUSER_GetLegacySubBannerData (uint bannerSize, FSMediaType mediaType, ulong programId, ubyte* banner);

/**
 * @brief Hashes the given data and outputs a SHA256 hash.
 * @param data Pointer to the data to be hashed.
 * @param inputSize The size of the data.
 * @param hash Hash output pointer.
 */
Result FSUSER_UpdateSha256Context (const(void)* data, uint inputSize, ubyte* hash);

/**
 * @brief Reads from a special file.
 * @param bytesRead Pointer to output the number of bytes read to.
 * @param fileOffset Offset of the file.
 * @param size Size of the buffer.
 * @param data Buffer to read to.
 */
Result FSUSER_ReadSpecialFile (uint* bytesRead, ulong fileOffset, uint size, ubyte* data);

/**
 * @brief Gets the size of a special file.
 * @param fileSize Pointer to output the size to.
 */
Result FSUSER_GetSpecialFileSize (ulong* fileSize);

/**
 * @brief Creates ext save data.
 * @param info Info of the save data.
 * @param directories Number of directories.
 * @param files Number of files.
 * @param sizeLimit Size limit of the save data.
 * @param smdhSize Size of the save data's SMDH data.
 * @param smdh SMDH data.
 */
Result FSUSER_CreateExtSaveData (FS_ExtSaveDataInfo info, uint directories, uint files, ulong sizeLimit, uint smdhSize, ubyte* smdh);

/**
 * @brief Deletes ext save data.
 * @param info Info of the save data.
 */
Result FSUSER_DeleteExtSaveData (FS_ExtSaveDataInfo info);

/**
 * @brief Reads the SMDH icon of ext save data.
 * @param bytesRead Pointer to output the number of bytes read to.
 * @param info Info of the save data.
 * @param smdhSize Size of the save data SMDH.
 * @param smdh Pointer to output SMDH data to.
 */
Result FSUSER_ReadExtSaveDataIcon (uint* bytesRead, FS_ExtSaveDataInfo info, uint smdhSize, ubyte* smdh);

/**
 * @brief Gets an ext data archive's block information.
 * @param totalBlocks Pointer to output the total blocks to.
 * @param freeBlocks Pointer to output the free blocks to.
 * @param blockSize Pointer to output the block size to.
 * @param info Info of the save data.
 */
Result FSUSER_GetExtDataBlockSize (ulong* totalBlocks, ulong* freeBlocks, uint* blockSize, FS_ExtSaveDataInfo info);

/**
 * @brief Enumerates ext save data.
 * @param idsWritten Pointer to output the number of IDs written to.
 * @param idsSize Size of the IDs buffer.
 * @param mediaType Media type to enumerate over.
 * @param idSize Size of each ID element.
 * @param shared Whether to enumerate shared ext save data.
 * @param ids Pointer to output IDs to.
 */
Result FSUSER_EnumerateExtSaveData (uint* idsWritten, uint idsSize, FSMediaType mediaType, uint idSize, bool shared_, ubyte* ids);

/**
 * @brief Creates system save data.
 * @param info Info of the save data.
 * @param totalSize Total size of the save data.
 * @param blockSize Block size of the save data. (usually 0x1000)
 * @param directories Number of directories.
 * @param files Number of files.
 * @param directoryBuckets Directory hash tree bucket count.
 * @param fileBuckets File hash tree bucket count.
 * @param duplicateData Whether to store an internal duplicate of the data.
 */
Result FSUSER_CreateSystemSaveData (FS_SystemSaveDataInfo info, uint totalSize, uint blockSize, uint directories, uint files, uint directoryBuckets, uint fileBuckets, bool duplicateData);

/**
 * @brief Deletes system save data.
 * @param info Info of the save data.
 */
Result FSUSER_DeleteSystemSaveData (FS_SystemSaveDataInfo info);

/**
 * @brief Initiates a device move as the source device.
 * @param context Pointer to output the context to.
 */
Result FSUSER_StartDeviceMoveAsSource (FS_DeviceMoveContext* context);

/**
 * @brief Initiates a device move as the destination device.
 * @param context Context to use.
 * @param clear Whether to clear the device's data first.
 */
Result FSUSER_StartDeviceMoveAsDestination (FS_DeviceMoveContext context, bool clear);

/**
 * @brief Sets an archive's priority.
 * @param archive Archive to use.
 * @param priority Priority to set.
 */
Result FSUSER_SetArchivePriority (FS_Archive archive, uint priority);

/**
 * @brief Gets an archive's priority.
 * @param priority Pointer to output the priority to.
 * @param archive Archive to use.
 */
Result FSUSER_GetArchivePriority (uint* priority, FS_Archive archive);

/**
 * @brief Configures CTRCARD latency emulation.
 * @param latency Latency to apply, in milliseconds.
 * @param emulateEndurance Whether to emulate card endurance.
 */
Result FSUSER_SetCtrCardLatencyParameter (ulong latency, bool emulateEndurance);

/**
 * @brief Toggles cleaning up invalid save data.
 * @param enable Whether to enable cleaning up invalid save data.
 */
Result FSUSER_SwitchCleanupInvalidSaveData (bool enable);

/**
 * @brief Enumerates system save data.
 * @param idsWritten Pointer to output the number of IDs written to.
 * @param idsSize Size of the IDs buffer.
 * @param ids Pointer to output IDs to.
 */
Result FSUSER_EnumerateSystemSaveData (uint* idsWritten, uint idsSize, uint* ids);

/**
 * @brief Initializes a FSUSER session with an SDK version.
 * @param session The handle of the FSUSER session to initialize.
 * @param version SDK version to initialize with.
 */
Result FSUSER_InitializeWithSdkVersion (Handle session, uint version_);

/**
 * @brief Sets the file system priority.
 * @param priority Priority to set.
 */
Result FSUSER_SetPriority (uint priority);

/**
 * @brief Gets the file system priority.
 * @param priority Pointer to output the priority to.
 */
Result FSUSER_GetPriority (uint* priority);

/**
 * @brief Sets the save data secure value.
 * @param value Secure value to set.
 * @param slot Slot of the secure value.
 * @param titleUniqueId Unique ID of the title. (default = 0)
 * @param titleVariation Variation of the title. (default = 0)
 */
Result FSUSER_SetSaveDataSecureValue (ulong value, FSSecureValueSlot slot, uint titleUniqueId, ubyte titleVariation);

/**
 * @brief Gets the save data secure value.
 * @param exists Pointer to output whether the secure value exists to.
 * @param value Pointer to output the secure value to.
 * @param slot Slot of the secure value.
 * @param titleUniqueId Unique ID of the title. (default = 0)
 * @param titleVariation Variation of the title. (default = 0)
 */
Result FSUSER_GetSaveDataSecureValue (bool* exists, ulong* value, FSSecureValueSlot slot, uint titleUniqueId, ubyte titleVariation);

/**
 * @brief Performs a control operation on a secure save.
 * @param action Action to perform.
 * @param input Buffer to read input from.
 * @param inputSize Size of the input.
 * @param output Buffer to write output to.
 * @param outputSize Size of the output.
 */
Result FSUSER_ControlSecureSave (FSSecureSaveAction action, const(void)* input, uint inputSize, void* output, uint outputSize);

/**
 * @brief Gets the media type of the current application.
 * @param mediaType Pointer to output the media type to.
 */
Result FSUSER_GetMediaType (FSMediaType* mediaType);

/**
 * @brief Performs a control operation on a file.
 * @param handle Handle of the file.
 * @param action Action to perform.
 * @param input Buffer to read input from.
 * @param inputSize Size of the input.
 * @param output Buffer to write output to.
 * @param outputSize Size of the output.
 */
Result FSFILE_Control (Handle handle, FSFileAction action, const(void)* input, uint inputSize, void* output, uint outputSize);

/**
 * @brief Opens a handle to a sub-section of a file.
 * @param handle Handle of the file.
 * @param subFile Pointer to output the sub-file to.
 * @param offset Offset of the sub-section.
 * @param size Size of the sub-section.
 */
Result FSFILE_OpenSubFile (Handle handle, Handle* subFile, ulong offset, ulong size);

/**
 * @brief Reads from a file.
 * @param handle Handle of the file.
 * @param bytesRead Pointer to output the number of bytes read to.
 * @param offset Offset to read from.
 * @param buffer Buffer to read to.
 * @param size Size of the buffer.
 */
Result FSFILE_Read (Handle handle, uint* bytesRead, ulong offset, void* buffer, uint size);

/**
 * @brief Writes to a file.
 * @param handle Handle of the file.
 * @param bytesWritten Pointer to output the number of bytes written to.
 * @param offset Offset to write to.
 * @param buffer Buffer to write from.
 * @param size Size of the buffer.
 * @param flags Flags to use when writing.
 */
Result FSFILE_Write (Handle handle, uint* bytesWritten, ulong offset, const(void)* buffer, uint size, uint flags);

/**
 * @brief Gets the size of a file.
 * @param handle Handle of the file.
 * @param size Pointer to output the size to.
 */
Result FSFILE_GetSize (Handle handle, ulong* size);

/**
 * @brief Sets the size of a file.
 * @param handle Handle of the file.
 * @param size Size to set.
 */
Result FSFILE_SetSize (Handle handle, ulong size);

/**
 * @brief Gets the attributes of a file.
 * @param handle Handle of the file.
 * @param attributes Pointer to output the attributes to.
 */
Result FSFILE_GetAttributes (Handle handle, uint* attributes);

/**
 * @brief Sets the attributes of a file.
 * @param handle Handle of the file.
 * @param attributes Attributes to set.
 */
Result FSFILE_SetAttributes (Handle handle, uint attributes);

/**
 * @brief Closes a file.
 * @param handle Handle of the file.
 */
Result FSFILE_Close (Handle handle);

/**
 * @brief Flushes a file's contents.
 * @param handle Handle of the file.
 */
Result FSFILE_Flush (Handle handle);

/**
 * @brief Sets a file's priority.
 * @param handle Handle of the file.
 * @param priority Priority to set.
 */
Result FSFILE_SetPriority (Handle handle, uint priority);

/**
 * @brief Gets a file's priority.
 * @param handle Handle of the file.
 * @param priority Pointer to output the priority to.
 */
Result FSFILE_GetPriority (Handle handle, uint* priority);

/**
 * @brief Opens a duplicate handle to a file.
 * @param handle Handle of the file.
 * @param linkFile Pointer to output the link handle to.
 */
Result FSFILE_OpenLinkFile (Handle handle, Handle* linkFile);

/**
 * @brief Performs a control operation on a directory.
 * @param handle Handle of the directory.
 * @param action Action to perform.
 * @param input Buffer to read input from.
 * @param inputSize Size of the input.
 * @param output Buffer to write output to.
 * @param outputSize Size of the output.
 */
Result FSDIR_Control (Handle handle, FSDirectoryAction action, const(void)* input, uint inputSize, void* output, uint outputSize);

/**
 * @brief Reads one or more directory entries.
 * @param handle Handle of the directory.
 * @param entriesRead Pointer to output the number of entries read to.
 * @param entryCount Number of entries to read.
 * @param entryOut Pointer to output directory entries to.
 */
Result FSDIR_Read (Handle handle, uint* entriesRead, uint entryCount, FS_DirectoryEntry* entries);

/**
 * @brief Closes a directory.
 * @param handle Handle of the directory.
 */
Result FSDIR_Close (Handle handle);

/**
 * @brief Sets a directory's priority.
 * @param handle Handle of the directory.
 * @param priority Priority to set.
 */
Result FSDIR_SetPriority (Handle handle, uint priority);

/**
 * @brief Gets a directory's priority.
 * @param handle Handle of the directory.
 * @param priority Pointer to output the priority to.
 */
Result FSDIR_GetPriority (Handle handle, uint* priority);
