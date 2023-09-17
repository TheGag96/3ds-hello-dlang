/**
 * @file fspxi.h
 * @brief  Service interface for PxiFS services. This is normally not accessible to userland apps. https://3dbrew.org/wiki/Filesystem_services_PXI
 */

module ctru.services.fspxi;

public import ctru.services.fs;
public import ctru.types;

extern (C): nothrow: @nogc:

alias FSPXI_Archive   = ulong;
alias FSPXI_File      = ulong;
alias FSPXI_Directory = ulong;

/**
 * @brief Opens a file.
 * @param out Pointer to output the file handle to.
 * @param archive Archive containing the file.
 * @param path Path of the file.
 * @param flags Flags to open the file with.
 * @param attributes Attributes of the file.
 */
Result FSPXI_OpenFile(Handle serviceHandle, FSPXI_File* out_, FSPXI_Archive archive, FS_Path path, uint flags, uint attributes);

/**
 * @brief Deletes a file.
 * @param archive Archive containing the file.
 * @param path Path of the file.
 */
Result FSPXI_DeleteFile(Handle serviceHandle, FSPXI_Archive archive, FS_Path path);

/**
 * @brief Renames a file.
 * @param srcArchive Archive containing the source file.
 * @param srcPath Path of the source file.
 * @param dstArchive Archive containing the destination file.
 * @param dstPath Path of the destination file.
 */
Result FSPXI_RenameFile(Handle serviceHandle, FSPXI_Archive srcArchive, FS_Path srcPath, FSPXI_Archive dstArchive, FS_Path dstPath);

/**
 * @brief Deletes a directory.
 * @param archive Archive containing the directory.
 * @param path Path of the directory.
 */
Result FSPXI_DeleteDirectory(Handle serviceHandle, FSPXI_Archive archive, FS_Path path);

/**
 * @brief Creates a file.
 * @param archive Archive to create the file in.
 * @param path Path of the file.
 * @param attributes Attributes of the file.
 * @param size Size of the file.
 */
Result FSPXI_CreateFile(Handle serviceHandle, FSPXI_Archive archive, FS_Path path, uint attributes, ulong fileSize);

/**
 * @brief Creates a directory.
 * @param archive Archive to create the directory in.
 * @param path Path of the directory.
 * @param attributes Attributes of the directory.
 */
Result FSPXI_CreateDirectory(Handle serviceHandle, FSPXI_Archive archive, FS_Path path, uint attributes);

/**
 * @brief Renames a directory.
 * @param srcArchive Archive containing the source directory.
 * @param srcPath Path of the source directory.
 * @param dstArchive Archive containing the destination directory.
 * @param dstPath Path of the destination directory.
 */
Result FSPXI_RenameDirectory(Handle serviceHandle, FSPXI_Archive srcArchive, FS_Path srcPath, FSPXI_Archive dstArchive, FS_Path dstPath);

/**
 * @brief Opens a directory.
 * @param out Pointer to output the directory handle to.
 * @param archive Archive containing the directory.
 * @param path Path of the directory.
 */
Result FSPXI_OpenDirectory(Handle serviceHandle, FSPXI_Directory* out_, FSPXI_Archive archive, FS_Path path);

/**
 * @brief Reads from a file.
 * @param file File to read from.
 * @param bytesRead Pointer to output the number of read bytes to.
 * @param offset Offset to read from.
 * @param buffer Buffer to read to.
 * @param size Size of the buffer.
 */
Result FSPXI_ReadFile(Handle serviceHandle, FSPXI_File file, uint* bytesRead, ulong offset, void* buffer, uint size);

/**
 * @brief Calculate SHA256 of a file.
 * @param file File to calculate the hash of.
 * @param buffer Buffer to output the hash to.
 * @param size Size of the buffer.
 */
Result FSPXI_CalculateFileHashSHA256(Handle serviceHandle, FSPXI_File file, void* buffer, uint size);

/**
 * @brief Writes to a file.
 * @param file File to write to.
 * @param bytesWritten Pointer to output the number of bytes written to.
 * @param offset Offset to write to.
 * @param buffer Buffer to write from.
 * @param size Size of the buffer.
 * @param flags Flags to use when writing.
 */
Result FSPXI_WriteFile(Handle serviceHandle, FSPXI_File file, uint* bytesWritten, ulong offset, const(void)* buffer, uint size, uint flags);

/**
 * @brief Calculates the MAC used in a DISA/DIFF header?
 * @param file Unsure
 * @param inBuffer 0x100-byte DISA/DIFF input buffer.
 * @param inSize Size of inBuffer.
 * @param outBuffer Buffer to write MAC to.
 * @param outSize Size of outBuffer.
 */
Result FSPXI_CalcSavegameMAC(Handle serviceHandle, FSPXI_File file, const(void)* inBuffer, uint inSize, void* outBuffer, uint outSize);

/**
 * @brief Get size of a file
 * @param file File to get the size of.
 * @param size Pointer to output size to.
 */
Result FSPXI_GetFileSize(Handle serviceHandle, FSPXI_File file, ulong* size);

/**
 * @brief Set size of a file
 * @param file File to set the size of
 * @param size Size to set the file to
 */
Result FSPXI_SetFileSize(Handle serviceHandle, FSPXI_File file, ulong size);

/**
 * @brief Close a file
 * @param file File to close
 */
Result FSPXI_CloseFile(Handle serviceHandle, FSPXI_File file);

/**
 * @brief Reads one or more directory entries.
 * @param directory Directory to read from.
 * @param entriesRead Pointer to output the number of entries read to.
 * @param entryCount Number of entries to read.
 * @param entryOut Pointer to output directory entries to.
 */
Result FSPXI_ReadDirectory(Handle serviceHandle, FSPXI_Directory directory, uint* entriesRead, uint entryCount, FS_DirectoryEntry* entries);

/**
 * @brief Close a directory
 * @param directory Directory to close.
 */
Result FSPXI_CloseDirectory(Handle serviceHandle, FSPXI_Directory directory);

/**
 * @brief Opens an archive.
 * @param archive Pointer to output the opened archive to.
 * @param id ID of the archive.
 * @param path Path of the archive.
 */
Result FSPXI_OpenArchive(Handle serviceHandle, FSPXI_Archive* archive, FSArchiveID archiveID, FS_Path path);

/**
 * @brief Checks if the archive contains a file at path.
 * @param archive Archive to check.
 * @param out Pointer to output existence to.
 * @param path Path to check for file
 */
Result FSPXI_HasFile(Handle serviceHandle, FSPXI_Archive archive, bool* out_, FS_Path path);

/**
 * @brief Checks if the archive contains a directory at path.
 * @param archive Archive to check.
 * @param out Pointer to output existence to.
 * @param path Path to check for directory
 */
Result FSPXI_HasDirectory(Handle serviceHandle, FSPXI_Archive archive, bool* out_, FS_Path path);

/**
 * @brief Commits an archive's save data.
 * @param archive Archive to commit.
 * @param id Archive action sent by FSUSER_ControlArchive. Must not be 0 or 0x789D
 * @remark Unsure why id is sent. This appears to be the default action for FSUSER_ControlArchive, with every action other than 0 and 0x789D being sent to this command.
 */
Result FSPXI_CommitSaveData(Handle serviceHandle, FSPXI_Archive archive, uint id);

/**
 * @brief Close an archive
 * @param archive Archive to close.
 */
Result FSPXI_CloseArchive(Handle serviceHandle, FSPXI_Archive archive);

/**
 * @brief Unknown 0x17. Appears to be an "is archive handle valid" command?
 * @param archive Archive handle to check validity of.
 * @param out Pointer to output validity to.
 */
Result FSPXI_Unknown0x17(Handle serviceHandle, FSPXI_Archive archive, bool* out_);

/**
 * @brief Gets the inserted card type.
 * @param out Pointer to output the card type to.
 */
Result FSPXI_GetCardType(Handle serviceHandle, FSCardType* out_);

/**
 * @brief Gets the SDMC archive resource information.
 * @param out Pointer to output the archive resource information to.
 */
Result FSPXI_GetSdmcArchiveResource(Handle serviceHandle, FS_ArchiveResource* out_);

/**
 * @brief Gets the NAND archive resource information.
 * @param out Pointer to output the archive resource information to.
 */
Result FSPXI_GetNandArchiveResource(Handle serviceHandle, FS_ArchiveResource* out_);

/**
 * @brief Gets the error code from the SDMC FatFS driver
 * @param out Pointer to output the error code to
 */
Result FSPXI_GetSdmcFatFsError(Handle serviceHandle, uint* out_);

/**
 * @brief Gets whether PXIFS0 detects the SD
 * @param out Pointer to output the detection status to
 */
Result FSPXI_IsSdmcDetected(Handle serviceHandle, bool* out_);

/**
 * @brief Gets whether PXIFS0 can write to the SD
 * @param out Pointer to output the writable status to
 */
Result FSPXI_IsSdmcWritable(Handle serviceHandle, bool* out_);

/**
 * @brief Gets the SDMC CID
 * @param out Buffer to output the CID to.
 * @param size Size of buffer.
 */
Result FSPXI_GetSdmcCid(Handle serviceHandle, void* out_, uint size);

/**
 * @brief Gets the NAND CID
 * @param out Buffer to output the CID to.
 * @param size Size of buffer.
 */
Result FSPXI_GetNandCid(Handle serviceHandle, void* out_, uint size);

/**
 * @brief Gets the SDMC speed info
 * @param out Buffer to output the speed info to.
 */
Result FSPXI_GetSdmcSpeedInfo(Handle serviceHandle, FS_SdMmcSpeedInfo* out_);

/**
 * @brief Gets the NAND speed info
 * @param out Buffer to output the speed info to.
 */
Result FSPXI_GetNandSpeedInfo(Handle serviceHandle, FS_SdMmcSpeedInfo* out_);

/**
 * @brief Gets the SDMC log
 * @param out Buffer to output the log to.
 * @param size Size of buffer.
 */
Result FSPXI_GetSdmcLog(Handle serviceHandle, void* out_, uint size);

/**
 * @brief Gets the NAND log
 * @param out Buffer to output the log to.
 * @param size Size of buffer.
 */
Result FSPXI_GetNandLog(Handle serviceHandle, void* out_, uint size);

/// Clears the SDMC log
Result FSPXI_ClearSdmcLog(Handle serviceHandle);

/// Clears the NAND log
Result FSPXI_ClearNandLog(Handle serviceHandle);

/**
 * @brief Gets whether a card is inserted.
 * @param inserted Pointer to output the insertion status to.
 */
Result FSPXI_CardSlotIsInserted(Handle serviceHandle, bool* inserted);

/**
 * @brief Powers on the card slot.
 * @param status Pointer to output the power status to.
 */
Result FSPXI_CardSlotPowerOn(Handle serviceHandle, bool* status);

/**
 * @brief Powers off the card slot.
 * @param status Pointer to output the power status to.
 */
Result FSPXI_CardSlotPowerOff(Handle serviceHandle, bool* status);

/**
 * @brief Gets the card's power status.
 * @param status Pointer to output the power status to.
 */
Result FSPXI_CardSlotGetCardIFPowerStatus(Handle serviceHandle, bool* status);

/**
 * @brief Executes a CARDNOR direct command.
 * @param commandId ID of the command.
 */
Result FSPXI_CardNorDirectCommand(Handle serviceHandle, ubyte commandId);

/**
 * @brief Executes a CARDNOR direct command with an address.
 * @param commandId ID of the command.
 * @param address Address to provide.
 */
Result FSPXI_CardNorDirectCommandWithAddress(Handle serviceHandle, ubyte commandId, uint address);

/**
 * @brief Executes a CARDNOR direct read.
 * @param commandId ID of the command.
 * @param size Size of the output buffer.
 * @param output Output buffer.
 */
Result FSPXI_CardNorDirectRead(Handle serviceHandle, ubyte commandId, uint size, void* output);

/**
 * @brief Executes a CARDNOR direct read with an address.
 * @param commandId ID of the command.
 * @param address Address to provide.
 * @param size Size of the output buffer.
 * @param output Output buffer.
 */
Result FSPXI_CardNorDirectReadWithAddress(Handle serviceHandle, ubyte commandId, uint address, uint size, void* output);

/**
 * @brief Executes a CARDNOR direct write.
 * @param commandId ID of the command.
 * @param size Size of the input buffer.
 * @param output Input buffer.
 * @remark Stubbed in latest firmware, since ?.?.?
 */
Result FSPXI_CardNorDirectWrite(Handle serviceHandle, ubyte commandId, uint size, const(void)* input);

/**
 * @brief Executes a CARDNOR direct write with an address.
 * @param commandId ID of the command.
 * @param address Address to provide.
 * @param size Size of the input buffer.
 * @param input Input buffer.
 */
Result FSPXI_CardNorDirectWriteWithAddress(Handle serviceHandle, ubyte commandId, uint address, uint size, const(void)* input);

/**
 * @brief Executes a CARDNOR 4xIO direct read.
 * @param commandId ID of the command.
 * @param address Address to provide.
 * @param size Size of the output buffer.
 * @param output Output buffer.
 */
Result FSPXI_CardNorDirectRead_4xIO(Handle serviceHandle, ubyte commandId, uint address, uint size, void* output);

/**
 * @brief Executes a CARDNOR direct CPU write without verify.
 * @param address Address to provide.
 * @param size Size of the input buffer.
 * @param output Input buffer.
 */
Result FSPXI_CardNorDirectCpuWriteWithoutVerify(Handle serviceHandle, uint address, uint size, const(void)* input);

/**
 * @brief Executes a CARDNOR direct sector erase without verify.
 * @param address Address to provide.
 */
Result FSPXI_CardNorDirectSectorEraseWithoutVerify(Handle serviceHandle, uint address);

/**
 * @brief Gets an NCCH's product info
 * @param info Pointer to output the product info to.
 * @param archive Open NCCH content archive
 */
Result FSPXI_GetProductInfo(Handle serviceHandle, FS_ProductInfo* info, FSPXI_Archive archive);

/**
 * @brief Sets the CARDSPI baud rate.
 * @param baudRate Baud rate to set.
 */
Result FSPXI_SetCardSpiBaudrate(Handle serviceHandle, FSCardSPIBaudRate baudRate);

/**
 * @brief Sets the CARDSPI bus mode.
 * @param busMode Bus mode to set.
 */
Result FSPXI_SetCardSpiBusMode(Handle serviceHandle, FSCardSPIBusMode busMode);

/**
 * @brief Sends initialization info to ARM9
 * @param unk FS sends *(0x1FF81086)
 */
Result FSPXI_SendInitializeInfoTo9(Handle serviceHandle, ubyte unk);

/**
 * @brief Creates ext save data.
 * @param info Info of the save data.
 */
Result FSPXI_CreateExtSaveData(Handle serviceHandle, FS_ExtSaveDataInfo info);

/**
 * @brief Deletes ext save data.
 * @param info Info of the save data.
 */
Result FSPXI_DeleteExtSaveData(Handle serviceHandle, FS_ExtSaveDataInfo info);

/**
 * @brief Enumerates ext save data.
 * @param idsWritten Pointer to output the number of IDs written to.
 * @param idsSize Size of the IDs buffer.
 * @param mediaType Media type to enumerate over.
 * @param idSize Size of each ID element.
 * @param shared Whether to enumerate shared ext save data.
 * @param ids Pointer to output IDs to.
 */
Result FSPXI_EnumerateExtSaveData(Handle serviceHandle, uint* idsWritten, uint idsSize, FSMediaType mediaType, uint idSize, bool shared_, ubyte* ids);

/**
 * @brief Gets a special content's index.
 * @param index Pointer to output the index to.
 * @param mediaType Media type of the special content.
 * @param programId Program ID owning the special content.
 * @param type Type of special content.
 */
Result FSPXI_GetSpecialContentIndex(Handle serviceHandle, ushort* index, FSMediaType mediaType, ulong programId, FSSpecialContentType type);

/**
 * @brief Gets the legacy ROM header of a program.
 * @param mediaType Media type of the program.
 * @param programId ID of the program.
 * @param header Pointer to output the legacy ROM header to. (size = 0x3B4)
 */
Result FSPXI_GetLegacyRomHeader(Handle serviceHandle, FSMediaType mediaType, ulong programId, void* header);

/**
 * @brief Gets the legacy banner data of a program.
 * @param mediaType Media type of the program.
 * @param programId ID of the program.
 * @param banner Pointer to output the legacy banner data to. (size = 0x23C0)
 * @param unk Unknown. Always 1?
 */
Result FSPXI_GetLegacyBannerData(Handle serviceHandle, FSMediaType mediaType, ulong programId, void* banner, ubyte unk);

/**
 * @brief Formats the CARDNOR device.
 * @param unk Unknown. Transaction?
 */
Result FSPXI_FormatCardNorDevice(Handle serviceHandle, uint unk);

/// Deletes the 3DS SDMC root.
Result FSPXI_DeleteSdmcRoot(Handle serviceHandle);

/// Deletes all ext save data on the NAND.
Result FSPXI_DeleteAllExtSaveDataOnNand(Handle serviceHandle);

/// Initializes the CTR file system.
Result FSPXI_InitializeCtrFilesystem(Handle serviceHandle);

/// Creates the FS seed.
Result FSPXI_CreateSeed(Handle serviceHandle);

/**
 * @brief Gets the CTR SDMC root path.
 * @param out Pointer to output the root path to.
 * @param length Length of the output buffer in bytes.
 */
Result FSPXI_GetSdmcCtrRootPath(Handle serviceHandle, ushort* out_, uint length);

/**
 * @brief Gets an archive's resource information.
 * @param archiveResource Pointer to output the archive resource information to.
 * @param mediaType System media type to check.
 */
Result FSPXI_GetArchiveResource(Handle serviceHandle, FS_ArchiveResource* archiveResource, FSSystemMediaType mediaType);

/**
 * @brief Exports the integrity verification seed.
 * @param seed Pointer to output the seed to.
 */
Result FSPXI_ExportIntegrityVerificationSeed(Handle serviceHandle, FS_IntegrityVerificationSeed* seed);

/**
 * @brief Imports an integrity verification seed.
 * @param seed Seed to import.
 */
Result FSPXI_ImportIntegrityVerificationSeed(Handle serviceHandle, const(FS_IntegrityVerificationSeed)* seed);

/**
 * @brief Gets the legacy sub banner data of a program.
 * @param bannerSize Size of the banner.
 * @param mediaType Media type of the program.
 * @param programId ID of the program.
 * @param header Pointer to output the legacy sub banner data to.
 */
Result FSPXI_GetLegacySubBannerData(Handle serviceHandle, uint bannerSize, FSMediaType mediaType, ulong programId, void* banner);

/**
 * @brief Generates random bytes. Uses same code as PSPXI_GenerateRandomBytes
 * @param buf Buffer to output random bytes to.
 * @param size Size of buffer.
 */
Result FSPXI_GenerateRandomBytes(Handle serviceHandle, void* buffer, uint size);

/**
 * @brief Gets the last modified time of a file in an archive.
 * @param archive The archive that contains the file.
 * @param out The pointer to write the timestamp to.
 * @param path The UTF-16 path of the file.
 * @param size The size of the path.
 */
Result FSPXI_GetFileLastModified(Handle serviceHandle, FSPXI_Archive archive, ulong* out_, const(ushort)* path, uint size);

/**
 * @brief Reads from a special file.
 * @param bytesRead Pointer to output the number of bytes read to.
 * @param fileOffset Offset of the file.
 * @param size Size of the buffer.
 * @param data Buffer to read to.
 */
Result FSPXI_ReadSpecialFile(Handle serviceHandle, uint* bytesRead, ulong fileOffset, uint size, void* data);

/**
 * @brief Gets the size of a special file.
 * @param fileSize Pointer to output the size to.
 */
Result FSPXI_GetSpecialFileSize(Handle serviceHandle, ulong* fileSize);

/**
 * @brief Initiates a device move as the source device.
 * @param context Pointer to output the context to.
 */
Result FSPXI_StartDeviceMoveAsSource(Handle serviceHandle, FS_DeviceMoveContext* context);

/**
 * @brief Initiates a device move as the destination device.
 * @param context Context to use.
 * @param clear Whether to clear the device's data first.
 */
Result FSPXI_StartDeviceMoveAsDestination(Handle serviceHandle, FS_DeviceMoveContext context, bool clear);

/**
 * @brief Reads data and stores SHA256 hashes of blocks
 * @param file File to read from.
 * @param bytesRead Pointer to output the number of read bytes to.
 * @param offset Offset to read from.
 * @param readBuffer Pointer to store read data in.
 * @param readBufferSize Size of readBuffer.
 * @param hashtable Pointer to store SHA256 hashes in.
 * @param hashtableSize Size of hashtable.
 * @param unk Unknown. Always 0x00001000? Possibly block size?
 */
Result FSPXI_ReadFileSHA256(Handle serviceHandle, FSPXI_File file, uint* bytesRead, ulong offset, void* readBuffer, uint readBufferSize, void* hashtable, uint hashtableSize, uint unk);

/**
 * @brief Assumedly writes data and stores SHA256 hashes of blocks
 * @param file File to write to.
 * @param bytesWritten Pointer to output the number of written bytes to.
 * @param offset Offset to write to.
 * @param writeBuffer Buffer to write from.
 * @param writeBufferSize Size of writeBuffer.
 * @param hashtable Pointer to store SHA256 hashes in.
 * @param hashtableSize Size of hashtable
 * @param unk1 Unknown. Might match with ReadFileSHA256's unknown?
 * @param unk2 Unknown. Might match with ReadFileSHA256's unknown?
 */
Result FSPXI_WriteFileSHA256(Handle serviceHandle, FSPXI_File file, uint* bytesWritten, ulong offset, const(void)* writeBuffer, uint writeBufferSize, void* hashtable, uint hashtableSize, uint unk1, uint unk2);

/**
 * @brief Configures CTRCARD latency emulation.
 * @param latency Latency to apply.
 */
Result FSPXI_SetCtrCardLatencyParameter(Handle serviceHandle, ulong latency);

/**
 * @brief Sets the file system priority.
 * @param priority Priority to set.
 */
Result FSPXI_SetPriority(Handle serviceHandle, uint priority);

/**
 * @brief Toggles cleaning up invalid save data.
 * @param enable Whether to enable cleaning up invalid save data.
 */
Result FSPXI_SwitchCleanupInvalidSaveData(Handle serviceHandle, bool enable);

/**
 * @brief Enumerates system save data.
 * @param idsWritten Pointer to output the number of IDs written to.
 * @param idsSize Size of the IDs buffer.
 * @param ids Pointer to output IDs to.
 */
Result FSPXI_EnumerateSystemSaveData(Handle serviceHandle, uint* idsWritten, uint idsSize, uint* ids);

/**
 * @brief Reads the NAND report.
 * @param unk Unknown
 * @param buffer Buffer to write the report to.
 * @param size Size of buffer
 */
Result FSPXI_ReadNandReport(Handle serviceHandle, void* buffer, uint size, uint unk);

/**
 * @brief Unknown command 0x56
 * @remark Called by FSUSER_ControlArchive with ArchiveAction 0x789D
 */
Result FSPXI_Unknown0x56(Handle serviceHandle, ref uint[4] out_, FS_Archive archive, FS_Path path);