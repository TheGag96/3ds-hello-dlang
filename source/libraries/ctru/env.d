/**
 * @file env.h
 * @brief Homebrew environment information.
 */

module ctru.env;

import ctru.types;

extern (C): nothrow: @nogc:

/// System run-flags.
enum
{
    RUNFLAG_APTWORKAROUND = BIT(0), ///< Use APT workaround.
    RUNFLAG_APTREINIT     = BIT(1), ///< Reinitialize APT.
    RUNFLAG_APTCHAINLOAD  = BIT(2)  ///< Chainload APT on return.
}

/**
 * @brief Gets whether the application was launched from a homebrew environment.
 * @return Whether the application was launched from a homebrew environment.
 */
bool envIsHomebrew();

/**
 * @brief Retrieves a handle from the environment handle list.
 * @param name Name of the handle.
 * @return The retrieved handle.
 */
Handle envGetHandle(const(char)* name);

/**
 * @brief Gets the environment-recommended app ID to use with APT.
 * @return The APT app ID.
 */
pragma(inline, true)
uint envGetAptAppId()
{
    extern uint __apt_appid;
    return __apt_appid;
}

/**
 * @brief Gets the size of the application heap.
 * @return The application heap size.
 */
pragma(inline, true)
uint envGetHeapSize()
{
    extern uint __ctru_heap_size;
    return __ctru_heap_size;
}

/**
 * @brief Gets the size of the linear heap.
 * @return The linear heap size.
 */
pragma(inline, true)
uint envGetLinearHeapSize()
{
    extern uint __ctru_linear_heap_size;
    return __ctru_linear_heap_size;
}

/**
 * @brief Gets the environment argument list.
 * @return The argument list.
 */
pragma(inline, true)
const(char)* envGetSystemArgList()
{
    extern const(char*) __system_arglist;
    return __system_arglist;
}

/**
 * @brief Gets the environment run flags.
 * @return The run flags.
 */
pragma(inline, true)
uint envGetSystemRunFlags()
{
    extern uint __system_runflags;
    return __system_runflags;
}
