/**
 * @file romfs.h
 * @brief RomFS driver.
 */

module ctru.romfs;

import ctru.types;

extern (C):

/// RomFS header.
struct romfs_header
{
    uint headerSize; ///< Size of the header.
    uint dirHashTableOff; ///< Offset of the directory hash table.
    uint dirHashTableSize; ///< Size of the directory hash table.
    uint dirTableOff; ///< Offset of the directory table.
    uint dirTableSize; ///< Size of the directory table.
    uint fileHashTableOff; ///< Offset of the file hash table.
    uint fileHashTableSize; ///< Size of the file hash table.
    uint fileTableOff; ///< Offset of the file table.
    uint fileTableSize; ///< Size of the file table.
    uint fileDataOff; ///< Offset of the file data.
}

/// RomFS directory.
struct romfs_dir
{
    uint parent; ///< Offset of the parent directory.
    uint sibling; ///< Offset of the next sibling directory.
    uint childDir; ///< Offset of the first child directory.
    uint childFile; ///< Offset of the first file.
    uint nextHash; ///< Directory hash table pointer.
    uint nameLen; ///< Name length.
    ushort[] name; ///< Name. (UTF-16)
}

/// RomFS file.
struct romfs_file
{
    uint parent; ///< Offset of the parent directory.
    uint sibling; ///< Offset of the next sibling file.
    ulong dataOff; ///< Offset of the file's data.
    ulong dataSize; ///< Length of the file's data.
    uint nextHash; ///< File hash table pointer.
    uint nameLen; ///< Name length.
    ushort[] name; ///< Name. (UTF-16)
}

struct romfs_mount;

/**
 * @brief Mounts the Application's RomFS.
 * @param mount Output mount handle
 */
Result romfsMount(romfs_mount** mount);
Result romfsInit();

/**
 * @brief Mounts RomFS from an open file.
 * @param file Handle of the RomFS file.
 * @param offset Offset of the RomFS within the file.
 * @param mount Output mount handle
 */
Result romfsMountFromFile(Handle file, uint offset, romfs_mount** mount);
Result romfsInitFromFile(Handle file, uint offset);

/// Bind the RomFS mount
Result romfsBind(romfs_mount* mount);

/// Unmounts the RomFS device.
Result romfsUnmount(romfs_mount* mount);
Result romfsExit();
