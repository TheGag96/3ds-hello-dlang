/**
 * @file types.h
 * @brief Various system types.
 */

module ctru.types;

import core.stdc.config;
import core.stdc.stdint;

extern (C): nothrow: @nogc:

/// The maximum value of a u64.
enum U64_MAX = UINT64_MAX;

/// would be nice if newlib had this already

enum SSIZE_MAX = SIZE_MAX >> 1;

alias ssize_t = int; ///<  8-bit unsigned integer ///<  8-bit unsigned integer ///< 16-bit unsigned integer ///< 32-bit unsigned integer ///< 64-bit unsigned integer ///<  8-bit signed integer ///< 16-bit signed integer ///< 32-bit signed integer ///< 64-bit signed integer

alias vu8  = ubyte;  ///< 8-bit volatile unsigned integer.
alias vu16 = ushort; ///< 16-bit volatile unsigned integer.
alias vu32 = uint;   ///< 32-bit volatile unsigned integer.
alias vu64 = ulong;  ///< 64-bit volatile unsigned integer.

alias vs8  = byte;   ///< 8-bit volatile signed integer.
alias vs16 = short;  ///< 16-bit volatile signed integer.
alias vs32 = int;    ///< 32-bit volatile signed integer.
alias vs64 = long;   ///< 64-bit volatile signed integer.

alias Handle = uint; ///< Resource handle.
alias Result = int;  ///< Function result.
alias ThreadFunc = void function(void*); ///< Thread entrypoint function.
alias voidfn = void function();

/// Creates a bitmask from a bit number.
extern (D) auto BIT(T)(auto ref T n)
{
    return 1U << n;
}

/// Aligns a struct (and other types?) to m, making sure that the size of the struct is a multiple of m.
/// Packs a struct (and other types?) so it won't include padding bytes.

/// Flags a function as deprecated.

/// Flags a function as deprecated.

/// Structure representing CPU registers
struct CpuRegisters
{
    uint[13] r; ///< r0-r12.
    uint sp; ///< sp.
    uint lr; ///< lr.
    uint pc; ///< pc. May need to be adjusted.
    uint cpsr; ///< cpsr.
}

/// Structure representing FPU registers
struct FpuRegisters
{
    union
    {
        struct
        {
            align (1):

            double[16] d;
        } ///< d0-d15.
        float[32] s; ///< s0-s31.
    }

    uint fpscr; ///< fpscr.
    uint fpexc; ///< fpexc.
}

alias mode_t      = uint;
alias off_t       = int;
alias time_t      = long;
alias suseconds_t = int;

struct timeval {
    time_t      tv_sec;     /* seconds */
    suseconds_t tv_usec;    /* and microseconds */
}