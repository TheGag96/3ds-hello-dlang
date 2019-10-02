/**
 * @file env.h
 * @brief Homebrew environment information.
 */

module ctru.env;

import ctru.types;

extern (C):

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
uint envGetAptAppId();

/**
 * @brief Gets the size of the application heap.
 * @return The application heap size.
 */
uint envGetHeapSize();

/**
 * @brief Gets the size of the linear heap.
 * @return The linear heap size.
 */
uint envGetLinearHeapSize();

/**
 * @brief Gets the environment argument list.
 * @return The argument list.
 */
const(char)* envGetSystemArgList();

/**
 * @brief Gets the environment run flags.
 * @return The run flags.
 */
uint envGetSystemRunFlags();
