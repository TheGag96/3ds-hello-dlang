/**
 * @file os.h
 * @brief OS related stuff.
 */

module ctru.os;

import ctru.types;
import ctru.svc;

extern (C): nothrow: @nogc:

///< The external clock rate for the SoC.
enum SYSCLOCK_SOC = 16756991;
///< The base system clock rate (for I2C, NDMA, etc.).
enum SYSCLOCK_SYS        =    SYSCLOCK_SOC * 2;
///< The base clock rate for the SDMMC controller (and some other peripherals).
enum SYSCLOCK_SDMMC      =    SYSCLOCK_SYS * 2;
///< The clock rate for the Arm9.
enum SYSCLOCK_ARM9 = SYSCLOCK_SOC * 8;
///< The clock rate for the Arm11 in CTR mode and in \ref svcGetSystemTick.
enum SYSCLOCK_ARM11 = SYSCLOCK_ARM9 * 2;
///< The clock rate for the Arm11 in LGR1 mode.
enum SYSCLOCK_ARM11_LGR1 =    SYSCLOCK_ARM11 * 2;
///< The clock rate for the Arm11 in LGR2 mode.
enum SYSCLOCK_ARM11_LGR2 =    SYSCLOCK_ARM11 * 3;
///< The highest possible clock rate for the Arm11 on known New 3DS units.
enum SYSCLOCK_ARM11_NEW = SYSCLOCK_ARM11 * 3;

enum CPU_TICKS_PER_MSEC = SYSCLOCK_ARM11 / 1000.0;
enum CPU_TICKS_PER_USEC = SYSCLOCK_ARM11 / 1000000.0;

/// Packs a system version from its components.
pragma(inline, true)
extern (D) auto SYSTEM_VERSION(T0, T1, T2)(auto ref T0 major, auto ref T1 minor, auto ref T2 revision)
{
    return (major << 24) | (minor << 16) | (revision << 8);
}

/// Retrieves the major version from a packed system version.
pragma(inline, true)
extern (D) auto GET_VERSION_MAJOR(T)(auto ref T _version)
{
    return _version >> 24;
}

/// Retrieves the minor version from a packed system version.
pragma(inline, true)
extern (D) auto GET_VERSION_MINOR(T)(auto ref T _version)
{
    return (_version >> 16) & 0xFF;
}

/// Retrieves the revision version from a packed system version.
pragma(inline, true)
extern (D) auto GET_VERSION_REVISION(T)(auto ref T _version)
{
    return (_version >> 8) & 0xFF;
}

enum OS_HEAP_AREA_BEGIN = 0x08000000; ///< Start of the heap area in the virtual address space
enum OS_HEAP_AREA_END   = 0x0E000000; ///< End of the heap area in the virtual address space

enum OS_MAP_AREA_BEGIN  = 0x10000000; ///< Start of the mappable area in the virtual address space
enum OS_MAP_AREA_END    = 0x14000000; ///< End of the mappable area in the virtual address space

enum OS_OLD_FCRAM_VADDR = 0x14000000; ///< Old pre-8.x linear FCRAM mapping virtual address
enum OS_OLD_FCRAM_PADDR = 0x20000000; ///< Old pre-8.x linear FCRAM mapping physical address
enum OS_OLD_FCRAM_SIZE  = 0x8000000;  ///< Old pre-8.x linear FCRAM mapping size (128 MiB)

enum OS_QTMRAM_VADDR    = 0x1E800000; ///< New3DS QTM memory virtual address
enum OS_QTMRAM_PADDR    = 0x1F000000; ///< New3DS QTM memory physical address
enum OS_QTMRAM_SIZE     = 0x400000;   ///< New3DS QTM memory size (4 MiB; last 128 KiB reserved by kernel)

enum OS_MMIO_VADDR      = 0x1EC00000; ///< Memory mapped IO range virtual address
enum OS_MMIO_PADDR      = 0x10100000; ///< Memory mapped IO range physical address
enum OS_MMIO_SIZE       = 0x400000;   ///< Memory mapped IO range size (4 MiB)

enum OS_VRAM_VADDR      = 0x1F000000; ///< VRAM virtual address
enum OS_VRAM_PADDR      = 0x18000000; ///< VRAM physical address
enum OS_VRAM_SIZE       = 0x600000;   ///< VRAM size (6 MiB)

enum OS_DSPRAM_VADDR    = 0x1FF00000; ///< DSP memory virtual address
enum OS_DSPRAM_PADDR    = 0x1FF00000; ///< DSP memory physical address
enum OS_DSPRAM_SIZE     = 0x80000;    ///< DSP memory size (512 KiB)

enum OS_KERNELCFG_VADDR = 0x1FF80000; ///< Kernel configuration page virtual address
enum OS_SHAREDCFG_VADDR = 0x1FF81000; ///< Shared system configuration page virtual address

enum OS_FCRAM_VADDR     = 0x30000000; ///< Linear FCRAM mapping virtual address
enum OS_FCRAM_PADDR     = 0x20000000; ///< Linear FCRAM mapping physical address
enum OS_FCRAM_SIZE      = 0x10000000; ///< Linear FCRAM mapping size (256 MiB)

enum OS_KernelConfig = (cast(const(osKernelConfig_s*))OS_KERNELCFG_VADDR); ///< Pointer to the kernel configuration page (see \ref osKernelConfig_s)
enum OS_SharedConfig = (cast(osSharedConfig_s*)OS_SHAREDCFG_VADDR);        ///< Pointer to the shared system configuration page (see \ref osSharedConfig_s)

/// Kernel configuration page (read-only).
struct osKernelConfig_s
{
    uint kernel_ver;
    uint update_flag;
    ulong ns_tid;
    uint kernel_syscore_ver;
    ubyte  env_info;
    ubyte  unit_info;
    ubyte  boot_env;
    ubyte  unk_0x17;
    uint kernel_ctrsdk_ver;
    uint unk_0x1c;
    uint firmlaunch_flags;
    ubyte[0xc] unk_0x24;
    uint app_memtype;
    ubyte[0xc] unk_0x34;
    uint[3] memregion_sz;
    ubyte[0x14] unk_0x4c;
    uint firm_ver;
    uint firm_syscore_ver;
    uint firm_ctrsdk_ver;
}

/// Time reference information struct (filled in by PTM).
struct osTimeRef_s
{
    ulong value_ms;   ///< Milliseconds elapsed since January 1900 when this structure was last updated
    ulong value_tick; ///< System ticks elapsed since boot when this structure was last updated
    long sysclock_hz; ///< System clock frequency in Hz adjusted using RTC measurements (usually around \ref SYSCLOCK_ARM11)
    long drift_ms;    ///< Measured time drift of the system clock (according to the RTC) in milliseconds since the last update
}

/// Shared system configuration page structure (read-only or read-write depending on exheader).
struct osSharedConfig_s
{
    /* volatile */ uint timeref_cnt;
    ubyte   running_hw;
    ubyte   mcu_hwinfo;
    ubyte[0x1A] unk_0x06;
    /* volatile */ osTimeRef_s[2] timeref;
    ubyte[6] wifi_macaddr;
    /* volatile */ ubyte  wifi_strength;
    /* volatile */ ubyte  network_state;
    ubyte[0x18] unk_0x68;
    /* volatile */ float slider_3d;
    /* volatile */ ubyte  led_3d;
    /* volatile */ ubyte  led_battery;
    /* volatile */ ubyte  unk_flag;
    ubyte   unk_0x87;
    ubyte[0x18] unk_0x88;
    /* volatile */ ulong menu_tid;
    /* volatile */ ulong cur_menu_tid;
    ubyte[0x10] unk_0xB0;
    /* volatile */ ubyte  headset_connected;
}

/// Tick counter.
struct TickCounter
{
    ulong elapsed;   ///< Elapsed CPU ticks between measurements.
    ulong reference; ///< Point in time used as reference.
}

/// OS_VersionBin. Format of the system version: "<major>.<minor>.<build>-<nupver><region>"
struct OS_VersionBin
{
    ubyte build;
    ubyte minor;
    ubyte mainver; //"major" in CVER, NUP version in NVer.
    ubyte reserved_x3;
    char region; //"ASCII character for the system version region"
    ubyte[0x3] reserved_x5;
}

/**
 * @brief Converts an address from virtual (process) memory to physical memory.
 * @param vaddr Input virtual address.
 * @return The corresponding physical address.
 * It is sometimes required by services or when using the GPU command buffer.
 */
uint osConvertVirtToPhys(const(void)* vaddr);

/**
 * @brief Converts 0x14* vmem to 0x30*.
 * @param vaddr Input virtual address.
 * @return The corresponding address in the 0x30* range, the input address if it's already within the new vmem, or 0 if it's outside of both ranges.
 */
void* osConvertOldLINEARMemToNew(const(void)* vaddr);

/**
 * @brief Retrieves basic information about a service error.
 * @param error Error to retrieve information about.
 * @return A string containing a summary of an error.
 *
 * This can be used to get some details about an error returned by a service call.
 */
const(char)* osStrError(Result error);

/**
 * @brief Gets the system's FIRM version.
 * @return The system's FIRM version.
 *
 * This can be used to compare system versions easily with @ref SYSTEM_VERSION.
 */
pragma(inline, true)
uint osGetFirmVersion()
{
    return (*cast(vu32*)0x1FF80060) & ~0xFF;
}

/**
 * @brief Gets the system's kernel version.
 * @return The system's kernel version.
 *
 * This can be used to compare system versions easily with @ref SYSTEM_VERSION.
 *
 * @code
 * if(osGetKernelVersion() > SYSTEM_VERSION(2,46,0)) printf("You are running 9.0 or higher\n");
 * @endcode
 */
pragma(inline, true)
uint osGetKernelVersion()
{
    return (*cast(vu32*)0x1FF80000) & ~0xFF;
}

/// Gets the system's "core version" (2 on NATIVE_FIRM, 3 on SAFE_FIRM, etc.)
pragma(inline, true)
uint osGetSystemCoreVersion()
{
    return *cast(vu32*)0x1FF80010;
}

/// Gets the system's memory layout ID (0-5 on Old 3DS, 6-8 on New 3DS)
pragma(inline, true)
uint osGetApplicationMemType()
{
    return *cast(vu32*)0x1FF80030;
}

/**
 * @brief Gets the size of the specified memory region.
 * @param region Memory region to check.
 * @return The size of the memory region, in bytes.
 */
pragma(inline, true)
uint osGetMemRegionSize(MemRegion region)
{
    if(region == MemRegion.all) {
        return osGetMemRegionSize(MemRegion.application) + osGetMemRegionSize(MemRegion.system) + osGetMemRegionSize(MemRegion.base);
    } else {
        return *cast(vu32*) (0x1FF80040 + (region - 1) * 0x4);
    }
}

/**
 * @brief Gets the number of used bytes within the specified memory region.
 * @param region Memory region to check.
 * @return The number of used bytes of memory.
 */
pragma(inline, true)
uint osGetMemRegionUsed(MemRegion region)
{
    long mem_used;
    svcGetSystemInfo(&mem_used, 0, region);
    return cast(uint) mem_used;
}

/**
 * @brief Gets the number of free bytes within the specified memory region.
 * @param region Memory region to check.
 * @return The number of free bytes of memory.
 */
pragma(inline, true)
uint osGetMemRegionFree(MemRegion region)
{
    return cast(uint) osGetMemRegionSize(region) - osGetMemRegionUsed(region);
}

/**
 * @brief Gets the current time.
 * @return The number of milliseconds since 1st Jan 1900 00:00.
 */
ulong osGetTime();

/**
 * @brief Starts a tick counter.
 * @param cnt The tick counter.
 */
pragma(inline, true)
void osTickCounterStart(TickCounter* cnt)
{
    cnt.reference = svcGetSystemTick();
}

/**
 * @brief Updates the elapsed time in a tick counter.
 * @param cnt The tick counter.
 */
pragma(inline, true)
void osTickCounterUpdate(TickCounter* cnt)
{
    ulong now = svcGetSystemTick();
    cnt.elapsed = now - cnt.reference;
    cnt.reference = now;
}

/**
 * @brief Reads the elapsed time in a tick counter.
 * @param cnt The tick counter.
 * @return The number of milliseconds elapsed.
 */
double osTickCounterRead(const(TickCounter)* cnt);

/**
 * @brief Gets the current Wifi signal strength.
 * @return The current Wifi signal strength.
 *
 * Valid values are 0-3:
 * - 0 means the signal strength is terrible or the 3DS is disconnected from
 *   all networks.
 * - 1 means the signal strength is bad.
 * - 2 means the signal strength is decent.
 * - 3 means the signal strength is good.
 *
 * Values outside the range of 0-3 should never be returned.
 *
 * These values correspond with the number of wifi bars displayed by Home Menu.
 */
pragma(inline, true)
ubyte osGetWifiStrength()
{
    return *cast(/* volatile */ ubyte*)0x1FF81066;
}

/**
 * @brief Gets the state of the 3D slider.
 * @return The state of the 3D slider(0.0~1.0)
 */
pragma(inline, true)
float osGet3DSliderState()
{
    return *cast(float*)0x1FF81080;
}

/**
 * @brief Checks whether a headset is connected.
 * @return true or false.
 */
pragma(inline, true)
bool osIsHeadsetConnected()
{
    return OS_SharedConfig.headset_connected != 0;
}

/**
 * @brief Configures the New 3DS speedup.
 * @param enable Specifies whether to enable or disable the speedup.
 */
void osSetSpeedupEnable(bool enable);

/**
 * @brief Gets the NAND system-version stored in NVer/CVer.
 * @param nver_versionbin Output OS_VersionBin structure for the data read from NVer.
 * @param cver_versionbin Output OS_VersionBin structure for the data read from CVer.
 * @return The result-code. This value can be positive if opening "romfs:/version.bin" fails with stdio, since errno would be returned in that case. In some cases the error can be special negative values as well.
 */
Result osGetSystemVersionData(OS_VersionBin* nver_versionbin, OS_VersionBin* cver_versionbin);

/**
 * @brief This is a wrapper for osGetSystemVersionData.
 * @param nver_versionbin Optional output OS_VersionBin structure for the data read from NVer, can be NULL.
 * @param cver_versionbin Optional output OS_VersionBin structure for the data read from CVer, can be NULL.
 * @param sysverstr Output string where the printed system-version will be written, in the same format displayed by the System Settings title.
 * @param sysverstr_maxsize Max size of the above string buffer, *including* NULL-terminator.
 * @return See osGetSystemVersionData.
 */
Result osGetSystemVersionDataString(OS_VersionBin* nver_versionbin, OS_VersionBin* cver_versionbin, char* sysverstr, uint sysverstr_maxsize);
