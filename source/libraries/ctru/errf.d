/**
 * @file errf.h
 * @brief Error Display API
 */

module ctru.errf;

import ctru.types;

extern (C): nothrow: @nogc:

/// Types of errors that can be thrown by err:f.
enum ERRF_ErrType : ubyte {
    generic      = 0,  ///< Generic fatal error. Shows miscellaneous info, including the address of the caller
    nand_damaged = 1,  ///< Damaged NAND (CC_ERROR after reading CSR)
    card_removed = 2,  ///< Game content storage medium (cartridge and/or SD card) ejected. Not logged
    exception    = 3,  ///< CPU or VFP exception
    failure      = 4,  ///< Fatal error with a message instead of the caller's address
    log_only     = 5,  ///< Log-level failure. Does not display the exception and does not force the system to reboot
}

/// Types of 'Exceptions' thrown for ERRF_ERRTYPE_EXCEPTION
enum ERRF_ExceptionType : ubyte
{
    prefetch_abort = 0, ///< Prefetch Abort
    data_abort     = 1, ///< Data abort
    undefined      = 2, ///< Undefined instruction
    vfp            = 3  ///< VFP (floating point) exception.
}

struct ERRF_ExceptionInfo
{
    ERRF_ExceptionType type; ///< Type of the exception. One of the ERRF_EXCEPTION_* values.
    ubyte[3] reserved;
    uint fsr; ///< ifsr (prefetch abort) / dfsr (data abort)
    uint far; ///< pc = ifar (prefetch abort) / dfar (data abort)
    uint fpexc;
    uint fpinst;
    uint fpinst2;
}

struct ERRF_ExceptionData
{
    ERRF_ExceptionInfo excep; ///< Exception info struct
    CpuRegisters regs; ///< CPU register dump.
}

struct ERRF_FatalErrInfo
{
    ERRF_ErrType type; ///< Type, one of the ERRF_ERRTYPE_* enum
    ubyte revHigh;     ///< High revison ID
    ushort revLow;     ///< Low revision ID
    uint resCode;      ///< Result code
    uint pcAddr;       ///< PC address at exception
    uint procId;       ///< Process ID of the caller
    ulong titleId;     ///< Title ID of the caller
    ulong appTitleId;  ///< Title ID of the running application

    ///< Data for when type is ERRF_ERRTYPE_EXCEPTION
    ///< String for when type is ERRF_ERRTYPE_FAILURE
    union _Anonymous_0
    {
        ERRF_ExceptionData exception_data;
        char[0x60] failure_mesg;
    }

    _Anonymous_0 data; ///< The different types of data for errors.
}

/// Initializes ERR:f. Unless you plan to call ERRF_Throw yourself, do not use this.
Result errfInit();

/// Exits ERR:f. Unless you plan to call ERRF_Throw yourself, do not use this.
void errfExit();

/**
 * @brief Gets the current err:f API session handle.
 * @return The current err:f API session handle.
 */
Handle* errfGetSessionHandle();

/**
 * @brief Throws a system error and possibly logs it.
 * @param[in] error Error to throw.
 *
 * ErrDisp may convert the error info to \ref ERRF_ERRTYPE_NAND_DAMAGED or \ref ERRF_ERRTYPE_CARD_REMOVED
 * depending on the error code.
 *
 * Except with \ref ERRF_ERRTYPE_LOG_ONLY, the system will panic and will need to be rebooted.
 * Fatal error information will also be logged into a file, unless the type either \ref ERRF_ERRTYPE_NAND_DAMAGED
 * or \ref ERRF_ERRTYPE_CARD_REMOVED.
 *
 * No error will be shown if the system is asleep.
 *
 * On retail units with vanilla firmware, no detailed information will be displayed on screen.
 *
 * You may wish to use ERRF_ThrowResult() or ERRF_ThrowResultWithMessage() instead of
 * constructing the ERRF_FatalErrInfo struct yourself.
 */
Result ERRF_Throw(const(ERRF_FatalErrInfo)* error);

/**
 * @brief Throws (and logs) a system error with the given Result code.
 * @param[in] failure Result code to throw.
 *
 * This calls \ref ERRF_Throw with error type \ref ERRF_ERRTYPE_GENERIC and fills in the required data.
 *
 * This function \em does fill in the address where this function was called from.
 */
Result ERRF_ThrowResult(Result failure);

/**
 * @brief Logs a system error with the given Result code.
 * @param[in] failure Result code to log.
 *
 * Similar to \ref ERRF_Throw, except that it does not display anything on the screen,
 * nor does it force the system to reboot.
 *
 * This function \em does fill in the address where this function was called from.
 */
Result ERRF_LogResult(Result failure);

/**
 * @brief Throws a system error with the given Result code and message.
 * @param[in] failure Result code to throw.
 * @param[in] message The message to display.
 *
 * This calls \ref ERRF_Throw with error type \ref ERRF_ERRTYPE_FAILURE and fills in the required data.
 *
 * This function does \em not fill in the address where this function was called from because it
 * would not be displayed.
 *
 * The message is only displayed on development units/patched ErrDisp.
 *
 * See https://3dbrew.org/wiki/ERR:Throw#Result_Failure for expected top screen output
 * on development units/patched ErrDisp.
 */
Result ERRF_ThrowResultWithMessage(Result failure, const(char)* message);

/**
 * @brief Specify an additional user string to use for error reporting.
 * @param[in] user_string User string (up to 256 bytes, not including NUL byte)
 */
Result ERRF_SetUserString(const(char)* user_string);

/**
 * @brief Handles an exception using ErrDisp.
 * @param excep Exception information
 * @param regs CPU registers
 *
 * You might want to clear ENVINFO's bit0 to be able to see any debugging information.
 * @sa threadOnException
 */
void ERRF_ExceptionHandler(ERRF_ExceptionInfo* excep, CpuRegisters* regs);
