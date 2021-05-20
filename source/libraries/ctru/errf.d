/**
 * @file errf.h
 * @brief Error Display API
 */

module ctru.errf;

import ctru.types;

extern (C): nothrow: @nogc:

/// Types of errors that can be thrown by err:f.
enum ERRF_ErrType : ubyte
{
    generic      = 0, ///< For generic errors. Shows miscellaneous info.
    mem_corrupt  = 1, ///< Same output as generic, but informs the user that "the System Memory has been damaged".
    card_removed = 2, ///< Displays the "The Game Card was removed." message.
    exception    = 3, ///< For exceptions, or more specifically 'crashes'. union data should be exception_data.
    failure      = 4, ///< For general failure. Shows a message. union data should have a string set in failure_mesg
    logged       = 5  ///< Outputs logs to NAND in some cases.
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
    ubyte revHigh; ///< High revison ID
    ushort revLow; ///< Low revision ID
    uint resCode; ///< Result code
    uint pcAddr; ///< PC address at exception
    uint procId; ///< Process ID.
    ulong titleId; ///< Title ID.
    ulong appTitleId; ///< Application Title ID.

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
 * @brief Throws a system error and possibly results in ErrDisp triggering.
 * @param[in] error Error to throw.
 *
 * After performing this, the system may panic and need to be rebooted. Extra information will be displayed on the
 * top screen with a developer console or the proper patches in a CFW applied.
 *
 * The error may not be shown and execution aborted until errfExit(void) is called.
 *
 * You may wish to use ERRF_ThrowResult() or ERRF_ThrowResultWithMessage() instead of
 * constructing the ERRF_FatalErrInfo struct yourself.
 */
Result ERRF_Throw(const(ERRF_FatalErrInfo)* error);

/**
 * @brief Throws a system error with the given Result code.
 * @param[in] failure Result code to throw.
 *
 * This calls ERRF_Throw() with error type ERRF_ERRTYPE_GENERIC and fills in the required data.
 *
 * This function \em does fill in the address where this function was called from.
 *
 * See https://3dbrew.org/wiki/ERR:Throw#Generic for expected top screen output
 * on development units/patched ErrDisp.
 */
Result ERRF_ThrowResult(Result failure);

/**
 * @brief Throws a system error with the given Result code and message.
 * @param[in] failure Result code to throw.
 * @param[in] message The message to display.
 *
 * This calls ERRF_Throw() with error type ERRF_ERRTYPE_FAILURE and fills in the required data.
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
 * @brief Handles an exception using ErrDisp.
 * @param excep Exception information
 * @param regs CPU registers
 *
 * You might want to clear ENVINFO's bit0 to be able to see any debugging information.
 * @sa threadOnException
 */
void ERRF_ExceptionHandler(ERRF_ExceptionInfo* excep, CpuRegisters* regs);
