/**
 * @file httpc.h
 * @brief HTTP service.
 */

module ctru.services.httpc;

import ctru.types;
import ctru.services.sslc;

extern (C): nothrow: @nogc:

/// HTTP context.
struct httpcContext
{
    Handle servhandle; ///< Service handle.
    uint httphandle; ///< HTTP handle.
}

/// HTTP request method.
enum HTTPCRequestMethod : ubyte
{
    get     = 0x1,
    post    = 0x2,
    head    = 0x3,
    put     = 0x4,
    _delete = 0x5
}

/// HTTP request status.
enum HTTPCRequestStatus : ubyte
{
    request_in_progress = 0x5, ///< Request in progress.
    download_ready      = 0x7  ///< Download ready.
}

/// HTTP KeepAlive option.
enum HTTPCKeepAlive : ubyte
{
    disabled = 0x0,
    enabled  = 0x1
}

/// Result code returned when a download is pending.
enum HTTPC_RESULTCODE_DOWNLOADPENDING = 0xd840a02b;

// Result code returned when asked about a non-existing header.
enum HTTPC_RESULTCODE_NOTFOUND = 0xd840a028;

// Result code returned when any timeout function times out.
enum HTTPC_RESULTCODE_TIMEDOUT = 0xd820a069;

/// Initializes HTTPC. For HTTP GET the sharedmem_size can be zero. The sharedmem contains data which will be later uploaded for HTTP POST. sharedmem_size should be aligned to 0x1000-bytes.
Result httpcInit(uint sharedmem_size);

/// Exits HTTPC.
void httpcExit();

/**
 * @brief Opens a HTTP context.
 * @param context Context to open.
 * @param url URL to connect to.
 * @param use_defaultproxy Whether the default proxy should be used (0 for default)
 */
Result httpcOpenContext(httpcContext* context, HTTPCRequestMethod method, const(char)* url, uint use_defaultproxy);

/**
 * @brief Closes a HTTP context.
 * @param context Context to close.
 */
Result httpcCloseContext(httpcContext* context);

/**
 * @brief Cancels a HTTP connection.
 * @param context Context to close.
 */
Result httpcCancelConnection(httpcContext* context);

/**
 * @brief Adds a request header field to a HTTP context.
 * @param context Context to use.
 * @param name Name of the field.
 * @param value Value of the field.
 */
Result httpcAddRequestHeaderField(httpcContext* context, const(char)* name, const(char)* value);

/**
 * @brief Adds a POST form field to a HTTP context.
 * @param context Context to use.
 * @param name Name of the field.
 * @param value Value of the field.
 */
Result httpcAddPostDataAscii(httpcContext* context, const(char)* name, const(char)* value);

/**
 * @brief Adds a POST form field with binary data to a HTTP context.
 * @param context Context to use.
 * @param name Name of the field.
 * @param value The binary data to pass as a value.
 * @param len Length of the binary data which has been passed.
 */
Result httpcAddPostDataBinary(httpcContext* context, const(char)* name, const(ubyte)* value, uint len);

/**
 * @brief Adds a POST body to a HTTP context.
 * @param context Context to use.
 * @param data The data to be passed as raw into the body of the post request.
 * @param len Length of data passed by data param.
 */
Result httpcAddPostDataRaw(httpcContext* context, const(uint)* data, uint len);

/**
 * @brief Begins a HTTP request.
 * @param context Context to use.
 */
Result httpcBeginRequest(httpcContext* context);

/**
 * @brief Receives data from a HTTP context.
 * @param context Context to use.
 * @param buffer Buffer to receive data to.
 * @param size Size of the buffer.
 */
Result httpcReceiveData(httpcContext* context, ubyte* buffer, uint size);

/**
 * @brief Receives data from a HTTP context with a timeout value.
 * @param context Context to use.
 * @param buffer Buffer to receive data to.
 * @param size Size of the buffer.
 * @param timeout Maximum time in nanoseconds to wait for a reply.
 */
Result httpcReceiveDataTimeout(httpcContext* context, ubyte* buffer, uint size, ulong timeout);

/**
 * @brief Gets the request state of a HTTP context.
 * @param context Context to use.
 * @param out Pointer to output the HTTP request state to.
 */
Result httpcGetRequestState(httpcContext* context, HTTPCRequestStatus* out_);

/**
 * @brief Gets the download size state of a HTTP context.
 * @param context Context to use.
 * @param downloadedsize Pointer to output the downloaded size to.
 * @param contentsize Pointer to output the total content size to.
 */
Result httpcGetDownloadSizeState(httpcContext* context, uint* downloadedsize, uint* contentsize);

/**
 * @brief Gets the response code of the HTTP context.
 * @param context Context to get the response code of.
 * @param out Pointer to write the response code to.
 */
Result httpcGetResponseStatusCode(httpcContext* context, uint* out_);

/**
 * @brief Gets the response code of the HTTP context with a timeout value.
 * @param context Context to get the response code of.
 * @param out Pointer to write the response code to.
 * @param timeout Maximum time in nanoseconds to wait for a reply.
 */
Result httpcGetResponseStatusCodeTimeout(httpcContext* context, uint* out_, ulong timeout);

/**
 * @brief Gets a response header field from a HTTP context.
 * @param context Context to use.
 * @param name Name of the field.
 * @param value Pointer to output the value of the field to.
 * @param valuebuf_maxsize Maximum size of the value buffer.
 */
Result httpcGetResponseHeader(httpcContext* context, const(char)* name, char* value, uint valuebuf_maxsize);

/**
 * @brief Adds a trusted RootCA cert to a HTTP context.
 * @param context Context to use.
 * @param cert Pointer to DER cert.
 * @param certsize Size of the DER cert.
 */
Result httpcAddTrustedRootCA(httpcContext* context, const(ubyte)* cert, uint certsize);

/**
 * @brief Adds a default RootCA cert to a HTTP context.
 * @param context Context to use.
 * @param certID ID of the cert to add, see sslc.h.
 */
Result httpcAddDefaultCert(httpcContext* context, SSLCDefaultRootCert certID);

/**
 * @brief Sets the RootCertChain for a HTTP context.
 * @param context Context to use.
 * @param RootCertChain_contexthandle Contexthandle for the RootCertChain.
 */
Result httpcSelectRootCertChain(httpcContext* context, uint RootCertChain_contexthandle);

/**
 * @brief Sets the ClientCert for a HTTP context.
 * @param context Context to use.
 * @param cert Pointer to DER cert.
 * @param certsize Size of the DER cert.
 * @param privk Pointer to the DER private key.
 * @param privk_size Size of the privk.
 */
Result httpcSetClientCert(httpcContext* context, const(ubyte)* cert, uint certsize, const(ubyte)* privk, uint privk_size);

/**
 * @brief Sets the default clientcert for a HTTP context.
 * @param context Context to use.
 * @param certID ID of the cert to add, see sslc.h.
 */
Result httpcSetClientCertDefault(httpcContext* context, SSLCDefaultClientCert certID);

/**
 * @brief Sets the ClientCert contexthandle for a HTTP context.
 * @param context Context to use.
 * @param ClientCert_contexthandle Contexthandle for the ClientCert.
 */
Result httpcSetClientCertContext(httpcContext* context, uint ClientCert_contexthandle);

/**
 * @brief Sets SSL options for the context.
 * The HTTPC SSL option bits are the same as those defined in sslc.h
 * @param context Context to set flags on.
 * @param options SSL option flags.
 */
Result httpcSetSSLOpt(httpcContext* context, uint options);

/**
 * @brief Sets the SSL options which will be cleared for the context.
 * The HTTPC SSL option bits are the same as those defined in sslc.h
 * @param context Context to clear flags on.
 * @param options SSL option flags.
 */
Result httpcSetSSLClearOpt(httpcContext* context, uint options);

/**
 * @brief Creates a RootCertChain. Up to 2 RootCertChains can be created under this user-process.
 * @param RootCertChain_contexthandle Output RootCertChain contexthandle.
 */
Result httpcCreateRootCertChain(uint* RootCertChain_contexthandle);

/**
 * @brief Destroy a RootCertChain.
 * @param RootCertChain_contexthandle RootCertChain to use.
 */
Result httpcDestroyRootCertChain(uint RootCertChain_contexthandle);

/**
 * @brief Adds a RootCA cert to a RootCertChain.
 * @param RootCertChain_contexthandle RootCertChain to use.
 * @param cert Pointer to DER cert.
 * @param certsize Size of the DER cert.
 * @param cert_contexthandle Optional output ptr for the cert contexthandle(this can be NULL).
 */
Result httpcRootCertChainAddCert(uint RootCertChain_contexthandle, const(ubyte)* cert, uint certsize, uint* cert_contexthandle);

/**
 * @brief Adds a default RootCA cert to a RootCertChain.
 * @param RootCertChain_contexthandle RootCertChain to use.
 * @param certID ID of the cert to add, see sslc.h.
 * @param cert_contexthandle Optional output ptr for the cert contexthandle(this can be NULL).
 */
Result httpcRootCertChainAddDefaultCert(uint RootCertChain_contexthandle, SSLCDefaultRootCert certID, uint* cert_contexthandle);

/**
 * @brief Removes a cert from a RootCertChain.
 * @param RootCertChain_contexthandle RootCertChain to use.
 * @param cert_contexthandle Contexthandle of the cert to remove.
 */
Result httpcRootCertChainRemoveCert(uint RootCertChain_contexthandle, uint cert_contexthandle);

/**
 * @brief Opens a ClientCert-context. Up to 2 ClientCert-contexts can be open under this user-process.
 * @param cert Pointer to DER cert.
 * @param certsize Size of the DER cert.
 * @param privk Pointer to the DER private key.
 * @param privk_size Size of the privk.
 * @param ClientCert_contexthandle Output ClientCert context handle.
 */
Result httpcOpenClientCertContext(const(ubyte)* cert, uint certsize, const(ubyte)* privk, uint privk_size, uint* ClientCert_contexthandle);

/**
 * @brief Opens a ClientCert-context with a default clientclient. Up to 2 ClientCert-contexts can be open under this user-process.
 * @param certID ID of the cert to add, see sslc.h.
 * @param ClientCert_contexthandle Output ClientCert context handle.
 */
Result httpcOpenDefaultClientCertContext(SSLCDefaultClientCert certID, uint* ClientCert_contexthandle);

/**
 * @brief Closes a ClientCert context.
 * @param ClientCert_contexthandle ClientCert context to use.
 */
Result httpcCloseClientCertContext(uint ClientCert_contexthandle);

/**
 * @brief Downloads data from the HTTP context into a buffer.
 * The *entire* content must be downloaded before using httpcCloseContext(), otherwise httpcCloseContext() will hang.
 * @param context Context to download data from.
 * @param buffer Buffer to write data to.
 * @param size Size of the buffer.
 * @param downloadedsize Pointer to write the size of the downloaded data to.
 */
Result httpcDownloadData(httpcContext* context, ubyte* buffer, uint size, uint* downloadedsize);

/**
 * @brief Sets Keep-Alive for the context.
 * @param context Context to set the KeepAlive flag on.
 * @param option HTTPCKeepAlive option.
 */
Result httpcSetKeepAlive(httpcContext* context, HTTPCKeepAlive option);
