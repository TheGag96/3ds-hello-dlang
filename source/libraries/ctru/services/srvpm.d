/**
 * @file srvpm.h
 * @brief srv:pm service.
 */

module ctru.services.srvpm;

import ctru.types;

extern (C): nothrow: @nogc:

/// Initializes srv:pm and the service API.
Result srvPmInit();

/// Exits srv:pm and the service API.
void srvPmExit();

/**
 * @brief Gets the current srv:pm session handle.
 * @return The current srv:pm session handle.
 */
Handle* srvPmGetSessionHandle();

/**
 * @brief Publishes a notification to a process.
 * @param notificationId ID of the notification.
 * @param process Process to publish to.
 */
Result SRVPM_PublishToProcess(uint notificationId, Handle process);

/**
 * @brief Publishes a notification to all processes.
 * @param notificationId ID of the notification.
 */
Result SRVPM_PublishToAll(uint notificationId);

/**
 * @brief Registers a process with SRV.
 * @param pid ID of the process.
 * @param count Number of services within the service access control data.
 * @param serviceAccessControlList Service Access Control list.
 */
Result SRVPM_RegisterProcess(uint pid, uint count, ref const(char)[8]* serviceAccessControlList);

/**
 * @brief Unregisters a process with SRV.
 * @param pid ID of the process.
 */
Result SRVPM_UnregisterProcess(uint pid);
