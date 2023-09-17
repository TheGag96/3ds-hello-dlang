/**
 * @file 3dslink.h
 * @brief Netloader (3dslink) utilities
 */

module ctru._3dslink;

import ctru.netinet.in_;

extern (C): nothrow: @nogc:

/// Address of the host connected through 3dslink
extern __gshared in_addr __3dslink_host;

enum LINK3DS_COMM_PORT = 17491; ///< 3dslink TCP server port

/**
 * @brief Connects to the 3dslink host, setting up an output stream.
 * @param[in] redirStdout Whether to redirect stdout to nxlink output.
 * @param[in] redirStderr Whether to redirect stderr to nxlink output.
 * @return Socket fd on success, negative number on failure.
 * @note The socket should be closed with close() during application cleanup.
 */
int link3dsConnectToHost(bool redirStdout, bool redirStderr);

/// Same as \ref link3dsConnectToHost but redirecting both stdout/stderr.
pragma(inline, true)
int link3dsStdio() {
    return link3dsConnectToHost(true, true);
}

/// Same as \ref link3dsConnectToHost but redirecting only stderr.
pragma(inline, true)
int link3dsStdioForDebug() {
    return link3dsConnectToHost(false, true);
}