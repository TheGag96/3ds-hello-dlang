/**
 * @file exheader.h
 * @brief NCCH extended header definitions.
 */

module ctru.exheader;

import ctru.types;

extern (C): nothrow: @nogc:

/// ARM9 descriptor flags
enum
{
    ARM9DESC_MOUNT_NAND      = BIT(0), ///< Mount "nand:/"
    ARM9DESC_MOUNT_NANDRO_RW = BIT(1), ///< Mount nand:/ro/ as read-write
    ARM9DESC_MOUNT_TWLN      = BIT(2), ///< Mount "twln:/"
    ARM9DESC_MOUNT_WNAND     = BIT(3), ///< Mount "wnand:/"
    ARM9DESC_MOUNT_CARDSPI   = BIT(4), ///< Mount "cardspi:/"
    ARM9DESC_USE_SDIF3       = BIT(5), ///< Use SDIF3
    ARM9DESC_CREATE_SEED     = BIT(6), ///< Create seed (movable.sed)
    ARM9DESC_USE_CARD_SPI    = BIT(7), ///< Use card SPI, required by multiple pxi:dev commands
    ARM9DESC_SD_APPLICATION  = BIT(8), ///< SD application (not checked)
    ARM9DESC_MOUNT_SDMC_RW   = BIT(9)  ///< Mount "sdmc:/" as read-write
}

/// Filesystem access flags
enum
{
    FSACCESS_CATEGORY_SYSTEM_APPLICATION = BIT(0),  /// < Category "system application"
    FSACCESS_CATEGORY_HARDWARE_CHECK     = BIT(1),  /// < Category "hardware check"
    FSACCESS_CATEGORY_FILESYSTEM_TOOL    = BIT(2),  /// < Category "filesystem tool"
    FSACCESS_DEBUG                       = BIT(3),  /// < Debug
    FSACCESS_TWLCARD_BACKUP              = BIT(4),  /// < TWLCARD backup
    FSACCESS_TWLNAND_DATA                = BIT(5),  /// < TWLNAND data
    FSACCESS_BOSS                        = BIT(6),  /// < BOSS (SpotPass)
    FSACCESS_SDMC_RW                     = BIT(7),  /// < SDMC (read-write)
    FSACCESS_CORE                        = BIT(8),  /// < Core
    FSACCESS_NANDRO_RO                   = BIT(9),  /// < nand:/ro/ (read-only)
    FSACCESS_NANDRW                      = BIT(10), /// < nand:/rw/
    FSACCESS_NANDRO_RW                   = BIT(11), /// < nand:/ro/ (read-write)
    FSACCESS_CATEGORY_SYSTEM_SETTINGS    = BIT(12), /// < Category "System Settings"
    FSACCESS_CARDBOARD                   = BIT(13), /// < Cardboard (System Transfer)
    FSACCESS_EXPORT_IMPORT_IVS           = BIT(14), /// < Export/Import IVs (movable.sed)
    FSACCESS_SDMC_WO                     = BIT(15), /// < SDMC (write-only)
    FSACCESS_SWITCH_CLEANUP              = BIT(16), /// < "Switch cleanup" (3.0+)
    FSACCESS_SAVEDATA_MOVE               = BIT(17), /// < Savedata move (5.0+)
    FSACCESS_SHOP                        = BIT(18), /// < Shop (5.0+)
    FSACCESS_SHELL                       = BIT(19), /// < Shop (5.0+)
    FSACCESS_CATEGORY_HOME_MENU          = BIT(20), /// < Category "Home Menu" (6.0+)
    FSACCESS_SEEDDB                      = BIT(21)  /// < Seed DB (9.6+)
}

/// The resource limit category of a title
enum ResourceLimitCategory : ubyte
{
    application = 0, ///< Regular application
    sys_applet  = 1, ///< System applet
    lib_applet  = 2, ///< Library applet
    other       = 3  ///< System modules running inside the BASE memregion
}

/// The system mode a title should be launched under
enum SystemMode : ubyte
{
    o3ds_prod = 0, ///< 64MB of usable application memory
    n3ds_prod = 1, ///< 124MB of usable application memory. Unusable on O3DS
    dev1      = 2, ///< 97MB/178MB of usable application memory
    dev2      = 3, ///< 80MB/124MB of usable application memory
    dev3      = 4, ///< 72MB of usable application memory. Same as "Prod" on N3DS
    dev4      = 5  ///< 32MB of usable application memory. Same as "Prod" on N3DS
}

/// The system info flags and remaster version of a title
struct ExHeader_SystemInfoFlags
{
    import std.bitmanip : bitfields;

    ubyte[5] reserved;

    mixin(bitfields!(
        bool, "compress_exefs_code", 1,
        bool, "is_sd_application", 1,
        uint, "", 6)); ///< Reserved
    ///< Whether the ExeFS's .code section is compressed
    ///< Whether the title is meant to be used on an SD card
    ushort remaster_version; ///< Remaster version
}

/// Information about a title's section
struct ExHeader_CodeSectionInfo
{
    uint address; ///< The address of the section
    uint num_pages; ///< The number of pages the section occupies
    uint size; ///< The size of the section
}

/// The name of a title and infomation about its section
struct ExHeader_CodeSetInfo
{
    char[8] name; ///< Title name
    ExHeader_SystemInfoFlags flags; ///< System info flags, see @ref ExHeader_SystemInfoFlags
    ExHeader_CodeSectionInfo text; ///< .text section info, see @ref ExHeader_CodeSectionInfo
    uint stack_size; ///< Stack size
    ExHeader_CodeSectionInfo rodata; ///< .rodata section info, see @ref ExHeader_CodeSectionInfo
    uint reserved; ///< Reserved
    ExHeader_CodeSectionInfo data; ///< .data section info, see @ref ExHeader_CodeSectionInfo
    uint bss_size; ///< .bss section size
}

/// The savedata size and jump ID of a title
struct ExHeader_SystemInfo
{
    ulong savedata_size; ///< Savedata size
    ulong jump_id; ///< Jump ID
    ubyte[0x30] reserved; ///< Reserved
}

/// The code set info, dependencies and system info of a title (SCI)
struct ExHeader_SystemControlInfo
{
    ExHeader_CodeSetInfo codeset_info; ///< Code set info, see @ref ExHeader_CodeSetInfo
    ulong[48] dependencies; ///< Title IDs of the titles that this program depends on
    ExHeader_SystemInfo system_info; ///< System info, see @ref ExHeader_SystemInfo
}

/// The ARM11 filesystem info of a title
struct ExHeader_Arm11StorageInfo
{
    import std.bitmanip : bitfields;

    ulong extdata_id; ///< Extdata ID
    uint[2] system_savedata_ids; ///< IDs of the system savedata accessible by the title
    ulong accessible_savedata_ids; ///< IDs of the savedata accessible by the title, 20 bits each, followed by "Use other variation savedata"
    uint fs_access_info;

    mixin(bitfields!(
        uint, "reserved", 24,
        bool, "no_romfs", 1,
        bool, "use_extended_savedata_access", 1,
        uint, "", 6)); ///< FS access flags
    ///< Reserved
    ///< Don't use any RomFS
    ///< Use the "extdata_id" field to store 3 additional accessible savedata IDs
}

/// The CPU-related and memory-layout-related info of a title
struct ExHeader_Arm11CoreInfo
{
    import std.bitmanip : bitfields;

    uint core_version;

    mixin(bitfields!(
        bool, "use_cpu_clockrate_804MHz", 1,
        bool, "enable_l2c", 1,
        ubyte, "flag1_unused", 6,
        SystemMode, "n3ds_system_mode", 4,
        ubyte, "flag2_unused", 4,
        ubyte, "ideal_processor", 2,
        ubyte, "affinity_mask", 2,
        SystemMode, "o3ds_system_mode", 4,
        uint, "", 8)); ///< The low title ID of the target firmware
    ///< Whether to start the title with the 804MHz clock rate
    ///< Whether to start the title with the L2C-310 enabled enabled
    ///< Unused
    ///< The system mode to use on N3DS
    ///< Unused
    ///< The ideal processor to start the title on
    ///< The affinity mask of the title
    ///< The system mode to use on N3DS
    ubyte priority; ///< The priority of the title's main thread
}

/// The ARM11 system-local capabilities of a title
struct ExHeader_Arm11SystemLocalCapabilities
{
    ulong title_id; ///< Title ID
    ExHeader_Arm11CoreInfo core_info; ///< Core info, see @ref ExHeader_Arm11CoreInfo
    ushort[16] reslimits; ///< Resource limit descriptors, only "CpuTime" (first byte) sems to be used
    ExHeader_Arm11StorageInfo storage_info; ///< Storage info, see @ref ExHeader_Arm11StorageInfo
    char[8][34] service_access; ///< List of the services the title has access to. Limited to 32 prior to system version 9.3
    ubyte[15] reserved; ///< Reserved
    ResourceLimitCategory reslimit_category; ///< Resource limit category, see @ref ExHeader_Arm11SystemLocalCapabilities
}

/// The ARM11 kernel capabilities of a title
struct ExHeader_Arm11KernelCapabilities
{
    uint[28] descriptors; ///< ARM11 kernel descriptors, see 3dbrew
    ubyte[16] reserved; ///< Reserved
}

/// The ARM9 access control of a title
struct ExHeader_Arm9AccessControl
{
    ubyte[15] descriptors; ///< Process9 FS descriptors, see 3dbrew
    ubyte descriptor_version; ///< Descriptor version
}

/// The access control information of a title
struct ExHeader_AccessControlInfo
{
    ExHeader_Arm11SystemLocalCapabilities local_caps; ///< ARM11 system-local capabilities, see @ref ExHeader_Arm11SystemLocalCapabilities
    ExHeader_Arm11KernelCapabilities kernel_caps; ///< ARM11 kernel capabilities, see @ref ExHeader_Arm11SystemLocalCapabilities
    ExHeader_Arm9AccessControl access_control; ///< ARM9 access control, see @ref ExHeader_Arm9AccessControl
}

/// Main extended header data, as returned by PXIPM, Loader and FSREG service commands
struct ExHeader_Info
{
    ExHeader_SystemControlInfo sci; ///< System control info, see @ref ExHeader_SystemControlInfo
    ExHeader_AccessControlInfo aci; ///< Access control info, see @ref ExHeader_AccessControlInfo
}

/// Extended header access descriptor
struct ExHeader_AccessDescriptor
{
    ubyte[0x100] signature; ///< The signature of the access descriptor (RSA-2048-SHA256)
    ubyte[0x100] ncchModulus; ///< The modulus used for the above signature, with 65537 as public exponent
    ExHeader_AccessControlInfo acli; ///< This is compared for equality with the first ACI by Process9, see @ref ExHeader_AccessControlInfo
}

/// The NCCH Extended Header of a title
struct ExHeader
{
    ExHeader_Info info; ///< Main extended header data, see @ref ExHeader_Info
    ExHeader_AccessDescriptor access_descriptor; ///< Access descriptor, see @ref ExHeader_AccessDescriptor
}
