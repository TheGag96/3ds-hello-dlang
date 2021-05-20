/**
 * @file nim.h
 * @brief NIM (network installation management) service.
 *
 * This service is used to download and install titles from Nintendo's CDN.
 *
 * We differentiate between two different kinds of downloads:
 *
 * - "active" downloads, which are downloads started with @ref NIMS_StartDownload or @ref NIMS_StartDownloadSimple. The process must keep polling the current status using @ref NIMS_GetProgress.
 * - "tasks", which are downloads started with @ref NIMS_RegisterTask. These are only processed in sleep mode.
 */

module ctru.services.nim;

import ctru.types;
import ctru.services.fs;

extern (C): nothrow: @nogc:

// FSMediaType

/// Mode that NIM downloads/installs a title with.
enum NIMInstallationMode : ubyte
{
    _default  = 0, ///< Initial installation
    unknown1  = 1, ///< Unknown
    unknown2  = 2, ///< Unknown
    reinstall = 3  ///< Reinstall currently installed title; use this if the title is already installed (including updates)
}

/// Current state of a NIM download/installation.
enum NIMDownloadState : ubyte
{
    not_initialized   = 0,  ///< Download not yet initialized
    initialized       = 1,  ///< Download initialized
    download_tmd      = 2,  ///< Downloading and installing TMD
    prepare_save_data = 3,  ///< Initializing save data
    download_contents = 4,  ///< Downloading and installing contents
    wait_commit       = 5,  ///< Waiting before calling AM_CommitImportTitles
    committing        = 6,  ///< Running AM_CommitImportTitles
    finished          = 7,  ///< Title installation finished
    version_error     = 8,  ///< (unknown error regarding title version)
    create_context    = 9,  ///< Creating the .ctx file?
    cannot_recover    = 10, ///< Irrecoverable error encountered (e.g. out of space)
    invalid           = 11  ///< Invalid state
}

/// Input configuration for NIM download/installation tasks.
struct NIM_TitleConfig
{
    ulong titleId; ///< Title ID
    uint version_; ///< Title version
    uint unknown_0; ///< Always 0
    ubyte ratingAge; ///< Age for the HOME Menu parental controls
    ubyte mediaType; ///< Media type, see @ref FSMediaType enum
    ubyte[2] padding; ///< Padding
    uint unknown_1; ///< Unknown input, seems to be always 0
}

/// Output struct for NIM downloads/installations in progress.
struct NIM_TitleProgress
{
    uint state; ///< State, see NIM_DownloadState enum
    Result lastResult; ///< Last result code in NIM
    ulong downloadedSize; ///< Amount of bytes that have been downloaded
    ulong totalSize; ///< Amount of bytes that need to be downloaded in total
}

/**
 * @brief Initializes nim:s. This uses networking and is blocking.
 * @param buffer A buffer for internal use. It must be at least 0x20000 bytes long.
 * @param buffer_len Length of the passed buffer.
 */
Result nimsInit(void* buffer, size_t buffer_len);

/**
 * @brief Initializes nim:s with the given TIN. This uses networking and is blocking.
 * @param buffer A buffer for internal use. It must be at least 0x20000 bytes long.
 * @param buffer_len Length of the passed buffer.
 * @param TIN The TIN to initialize nim:s with. If you do not know what a TIN is or why you would want to change it, use @ref nimsInit instead.
 */
Result nimsInitWithTIN(void* buffer, size_t buffer_len, const(char)* TIN);

/// Exits nim:s.
void nimsExit();

/// Gets the current nim:s session handle.
Handle* nimsGetSessionHandle();

/**
 * @brief Sets an attribute.
 * @param attr Name of the attribute.
 * @param val Value of the attribute.
 */
Result NIMS_SetAttribute(const(char)* attr, const(char)* val);

/**
 * @brief Checks if nim wants a system update.
 * @param want_update Set to true if a system update is required. Can be NULL.
 */
Result NIMS_WantUpdate(bool* want_update);

/**
 * @brief Makes a TitleConfig struct for use with @ref NIMS_RegisterTask, @ref NIMS_StartDownload or @ref NIMS_StartDownloadSimple.
 * @param cfg Struct to initialize.
 * @param titleId Title ID to download and install.
 * @param version Version of the title to download and install.
 * @param ratingAge Age for which the title is aged; used by parental controls in HOME Menu.
 * @param mediaType Media type of the title to download and install.
 */
void NIMS_MakeTitleConfig(NIM_TitleConfig* cfg, ulong titleId, uint version_, ubyte ratingAge, FSMediaType mediaType);

/**
 * @brief Registers a background download task with NIM. These are processed in sleep mode only.
 * @param cfg Title config to use. See @ref NIMS_MakeTitleConfig.
 * @param name Name of the title in UTF-8. Will be displayed on the HOME Menu. Maximum 73 characters.
 * @param maker Name of the maker/publisher in UTF-8. Will be displayed on the HOME Menu. Maximum 37 characters.
 */
Result NIMS_RegisterTask(const(NIM_TitleConfig)* cfg, const(char)* name, const(char)* maker);

/**
 * @brief Checks whether a background download task for the given title is registered with NIM.
 * @param titleId Title ID to check for.
 * @param registered Whether there is a background download task registered.
 */
Result NIMS_IsTaskRegistered(ulong titleId, bool* registered);

/**
 * @brief Unregisters a background download task.
 * @param titleId Title ID whose background download task to cancel.
 */
Result NIMS_UnregisterTask(ulong titleId);

/**
 * @brief Starts an active download with NIM. Progress can be checked with @ref NIMS_GetProcess. Do not exit the process while a download is in progress without calling @ref NIMS_CancelDownload.
 * @param cfg Title config to use. See @ref NIMS_MakeTitleConfig.
 * @param mode The installation mode to use. See @ref NIMInstallationMode.
 */
Result NIMS_StartDownload(const(NIM_TitleConfig)* cfg, NIMInstallationMode mode);

/**
 * @brief Starts an active download with NIM with default installation mode; cannot reinstall titles. Progress can be checked with @ref NIMS_GetProcess. Do not exit the process while a download is in progress without calling @ref NIMS_CancelDownload.
 * @param cfg Title config to use. See @ref NIMS_MakeTitleConfig.
 */
Result NIMS_StartDownloadSimple(const(NIM_TitleConfig)* cfg);

/**
 * @brief Checks the status of the current active download.
 * @param tp Title progress struct to write to. See @ref NIM_TitleProgress.
 */
Result NIMS_GetProgress(NIM_TitleProgress* tp);

/**
 * @brief Cancels the current active download with NIM.
 */
Result NIMS_CancelDownload();
