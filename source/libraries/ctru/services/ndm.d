/**
 * @file ndm.h
 * @brief NDMU service. https://3dbrew.org/wiki/NDM_Services
 */

module ctru.services.ndm;

import ctru.types;

extern (C): nothrow: @nogc:

/// Exclusive states.
enum NDMExclusiveState : ubyte
{
    none                 = 0,
    infrastructure       = 1,
    local_communications = 2,
    streetpass           = 3,
    streetpass_data      = 4
}

/// Current states.
enum NDMState : ubyte
{
    initial                            = 0,
    suspended                          = 1,
    infrastructure_connecting          = 2,
    infrastructure_connected           = 3,
    infrastructure_working             = 4,
    infrastructure_suspending          = 5,
    infrastructure_force_suspending    = 6,
    infrastructure_disconnecting       = 7,
    infrastructure_force_disconnecting = 8,
    cec_working                        = 9,
    cec_force_suspending               = 10,
    cec_suspending                     = 11
}

// Daemons.
enum NDMDaemon : ubyte
{
    cec     = 0,
    boss    = 1,
    nim     = 2,
    friends = 3
}

/// Used to specify multiple daemons.
enum NDMDaemonMask : ubyte
{
    cec         = BIT(NDMDaemon.cec),
    boss        = BIT(NDMDaemon.boss),
    nim         = BIT(NDMDaemon.nim),
    friends     = BIT(NDMDaemon.friends),
    backgrouond = cec | boss | nim,
    all         = cec | boss | nim | friends,
    _default    = cec | friends
}

// Daemon status.
enum NDMDaemonStatus : ubyte
{
    busy       = 0,
    idle       = 1,
    suspending = 2,
    suspended  = 3
}

/// Initializes ndmu.
Result ndmuInit();

/// Exits ndmu.
void ndmuExit();

/**
 * @brief Sets the network daemon to an exclusive state.
 * @param state State specified in the NDMExclusiveState enumerator.
 */
Result NDMU_EnterExclusiveState(NDMExclusiveState state);

///  Cancels an exclusive state for the network daemon.
Result NDMU_LeaveExclusiveState();

/**
 * @brief Returns the exclusive state for the network daemon.
 * @param state Pointer to write the exclsuive state to.
 */
Result NDMU_GetExclusiveState(NDMExclusiveState* state);

///  Locks the exclusive state.
Result NDMU_LockState();

///  Unlocks the exclusive state.
Result NDMU_UnlockState();

/**
 * @brief Suspends network daemon.
 * @param mask The specified daemon.
 */
Result NDMU_SuspendDaemons(NDMDaemonMask mask);

/**
 * @brief Resumes network daemon.
 * @param mask The specified daemon.
 */
Result NDMU_ResumeDaemons(NDMDaemonMask mask);

/**
 * @brief Suspends scheduling for all network daemons.
 * @param flag 0 = Wait for completion, 1 = Perform in background.
 */
Result NDMU_SuspendScheduler(uint flag);

/// Resumes daemon scheduling.
Result NDMU_ResumeScheduler();

/**
 * @brief Returns the current state for the network daemon.
 * @param state Pointer to write the current state to.
 */
Result NDMU_GetCurrentState(NDMState* state);

/**
 * @brief Returns the daemon state.
 * @param state Pointer to write the daemons state to.
 */
Result NDMU_QueryStatus(NDMDaemonStatus* status);

/**
 * @brief Sets the scan interval.
 * @param interval Value to set the scan interval to.
 */
Result NDMU_SetScanInterval(uint interval);

/**
 * @brief Returns the scan interval.
 * @param interval Pointer to write the interval value to.
 */
Result NDMU_GetScanInterval(uint* interval);

/**
 * @brief Returns the retry interval.
 * @param interval Pointer to write the interval value to.
 */
Result NDMU_GetRetryInterval(uint* interval);

/// Reverts network daemon to defaults.
Result NDMU_ResetDaemons();

/**
 * @brief Gets the current default daemon bit mask.
 * @param interval Pointer to write the default daemon mask value to. The default value is (DAEMONMASK_CEC | DAEMONMASK_FRIENDS)
 */
Result NDMU_GetDefaultDaemons(NDMDaemonMask* mask);

///  Clears half awake mac filter.
Result NDMU_ClearMacFilter();
