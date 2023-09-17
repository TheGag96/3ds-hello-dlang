/**
 * @file archive.h
 * @brief FS_Archive driver
 */

module ctru.archive;

public import ctru.services.fs;
public import ctru.types;

extern (C): nothrow: @nogc:

enum ARCHIVE_DIRITER_MAGIC = 0x68637261; /* "arch" */

/*! Open directory struct */
struct archive_dir_t
{
  uint              magic;          /*! "arch" */
  Handle            fd;             /*! CTRU handle */
  ssize_t           index;          /*! Current entry index */
  size_t            size;           /*! Current batch size */
  FS_DirectoryEntry[32] entry_data; /*! Temporary storage for reading entries */
}

/// Mounts the SD
Result archiveMountSdmc();

/// Mounts and opens an archive as deviceName
/// Returns either an archive open error code, or -1 for generic failure
Result archiveMount(FSArchiveID archiveID, FS_Path archivePath, const(char)* deviceName);

/// Uses FSUSER_ControlArchive with control action ARCHIVE_ACTION_COMMIT_SAVE_DATA on the opened archive. Not done automatically at unmount.
/// Returns -1 if the specified device is not found
Result archiveCommitSaveData(const(char)* deviceName);

/// Unmounts the specified device, closing its archive in the process
/// Returns -1 if the specified device was not found
Result archiveUnmount(const(char)* deviceName);

/// Unmounts all devices and cleans up any resources used by the driver
Result archiveUnmountAll();

/// Get a file's mtime
Result archive_getmtime(const(char)* name, ulong* mtime);