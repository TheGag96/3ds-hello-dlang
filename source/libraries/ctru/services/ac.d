/**
 * @file ac.h
 * @brief AC service.
 */

module ctru.services.ac;

import ctru.types;

extern (C): nothrow: @nogc:

/// Wifi security modes.
enum ACSecurityMode : ubyte
{
    open       = 0, ///< Open authentication.
    wep_40bit  = 1, ///< WEP 40-bit authentication.
    wep_104bit = 2, ///< WEP 104-bit authentication.
    wep_128bit = 3, ///< WEP 128-bit authentication.
    wpa_tkip   = 4, ///< WPA TKIP authentication.
    wpa2_tkip  = 5, ///< WPA2 TKIP authentication.
    wpa_aes    = 6, ///< WPA AES authentication.
    wpa2_aes   = 7  ///< WPA2 AES authentication.
}

/// Struct to contain the data for connecting to a Wifi network from a stored slot.
struct acuConfig
{
    ubyte[0x200] reserved;
}

/// Initializes AC.
Result acInit();

/// Exits AC.
void acExit();

/// Waits for the system to connect to the internet.
Result acWaitInternetConnection();

/**
 * @brief Gets the connected Wifi status.
 * @param out Pointer to output the connected Wifi status to. (0 = not connected, 1 = O3DS Internet, 2 = N3DS Internet)
 */
Result ACU_GetWifiStatus(uint* out_);

/**
 * @brief Gets the connected Wifi status.
 * @param out Pointer to output the connected Wifi status to. (1 = not connected, 3 = connected)
 */
Result ACU_GetStatus(uint* out_);

/**
 * @brief Gets the connected Wifi security mode.
 * @param mode Pointer to output the connected Wifi security mode to. (0 = Open Authentication, 1 = WEP 40-bit, 2 = WEP 104-bit, 3 = WEP 128-bit, 4 = WPA TKIP, 5 = WPA2 TKIP, 6 = WPA AES, 7 = WPA2 AES)
 */
Result ACU_GetSecurityMode(ACSecurityMode* mode);

/**
 * @brief Gets the connected Wifi SSID.
 * @param SSID Pointer to output the connected Wifi SSID to.
 */
Result ACU_GetSSID(char* SSID);

/**
 * @brief Gets the connected Wifi SSID length.
 * @param out Pointer to output the connected Wifi SSID length to.
 */
Result ACU_GetSSIDLength(uint* out_);

/**
 * @brief Determines whether proxy is enabled for the connected network.
 * @param enable Pointer to output the proxy status to.
 */
Result ACU_GetProxyEnable(bool* enable);

/**
 * @brief Gets the connected network's proxy port.
 * @param out Pointer to output the proxy port to.
 */
Result ACU_GetProxyPort(uint* out_);

/**
 * @brief Gets the connected network's proxy username.
 * @param username Pointer to output the proxy username to. (The size must be at least 0x20-bytes)
 */
Result ACU_GetProxyUserName(char* username);

/**
 * @brief Gets the connected network's proxy password.
 * @param password Pointer to output the proxy password to. (The size must be at least 0x20-bytes)
 */
Result ACU_GetProxyPassword(char* password);

/**
 * @brief Gets the last error to occur during a connection.
 * @param errorCode Pointer to output the error code to.
 */
Result ACU_GetLastErrorCode(uint* errorCode);

/**
 * @brief Gets the last detailed error to occur during a connection.
 * @param errorCode Pointer to output the error code to.
 */
Result ACU_GetLastDetailErrorCode(uint* errorCode);

/**
 * @brief Prepares a buffer to hold the configuration data to start a connection.
 * @param config Pointer to an acuConfig struct to contain the data.
 */
Result ACU_CreateDefaultConfig(acuConfig* config);

/**
 * @brief Sets something that makes the connection reliable.
 * @param config Pointer to an acuConfig struct used with ACU_CreateDefaultConfig previously.
 * @param area Always 2 ?
 */
Result ACU_SetNetworkArea(acuConfig* config, ubyte area);

/**
 * @brief Sets the slot to use when connecting.
 * @param config Pointer to an acuConfig struct used with ACU_CreateDefaultConfig previously.
 * @param type Allowed slots flag. BIT(0) for slot 1, BIT(1) for slot 2, BIT(2) for slot 3.
 */
Result ACU_SetAllowApType(acuConfig* config, ubyte type);

/**
 * @brief Sets something that makes the connection reliable.
 * @param config Pointer to an acuConfig struct used with ACU_CreateDefaultConfig previously.
 */
Result ACU_SetRequestEulaVersion(acuConfig* config);

/**
 * @brief Starts the connection procedure.
 * @param config Pointer to an acuConfig struct used with ACU_CreateDefaultConfig previously.
 * @param connectionHandle Handle created with svcCreateEvent to wait on until the connection succeeds or fails.
 */
Result ACU_ConnectAsync(const(acuConfig)* config, Handle connectionHandle);
