/**
 * @file apt.h
 * @brief APT (Applet) service.
 */

module ctru.services.apt;

import ctru.types;

extern (C): nothrow: @nogc:

/**
 * @brief NS Application IDs.
 *
 * Retrieved from http://3dbrew.org/wiki/NS_and_APT_Services#AppIDs
 */
enum NSAppID : ushort
{
    none               = 0,
    homemenu           = 0x101, ///< Home Menu
    camera             = 0x110, ///< Camera applet
    friends_list       = 0x112, ///< Friends List applet
    game_notes         = 0x113, ///< Game Notes applet
    web                = 0x114, ///< Internet Browser
    instruction_manual = 0x115, ///< Instruction Manual applet
    notifications      = 0x116, ///< Notifications applet
    miiverse           = 0x117, ///< Miiverse applet (olv)
    miiverse_posting   = 0x118, ///< Miiverse posting applet (solv3)
    amiibo_settings    = 0x119, ///< Amiibo settings applet (cabinet)
    application        = 0x300, ///< Application
    eshop              = 0x301, ///< eShop (tiger)
    software_keyboard  = 0x401, ///< Software Keyboard
    appleted           = 0x402, ///< appletEd
    pnote_ap           = 0x404, ///< PNOTE_AP
    snote_ap           = 0x405, ///< SNOTE_AP
    error              = 0x406, ///< error
    mint               = 0x407, ///< mint
    extrapad           = 0x408, ///< extrapad
    memolib            = 0x409  ///< memolib
}

/// APT applet position.
enum APTAppletPos : byte
{
    none     = -1, ///< No position specified.
    app      = 0,  ///< Application.
    applib   = 1,  ///< Application library (?).
    sys      = 2,  ///< System applet.
    syslib   = 3,  ///< System library (?).
    resident = 4   ///< Resident applet.
}

alias APT_AppletAttr = ubyte;

struct PtmWakeEvents;

/// Create an APT_AppletAttr bitfield from its components.
pragma(inline, true)
APT_AppletAttr aptMakeAppletAttr (
    APTAppletPos pos,
    bool manualGpuRights,
    bool manualDspRights)
{
    return cast(ubyte) ((pos&7) | (manualGpuRights ? BIT(3) : 0) | (manualDspRights ? BIT(4) : 0));
}

/// APT query reply.
enum APTQueryReply
{
    reject = 0,
    accept = 1,
    later  = 2
}

/// APT signals.
enum APTSignal : ubyte
{
    none         = 0,  ///< No signal received.
    homebutton   = 1,  ///< HOME button pressed.
    homebutton2  = 2,  ///< HOME button pressed (again?).
    sleep_query  = 3,  ///< Prepare to enter sleep mode.
    sleep_cancel = 4,  ///< Triggered when ptm:s GetShellStatus() returns 5.
    sleep_enter  = 5,  ///< Enter sleep mode.
    sleep_wakeup = 6,  ///< Wake from sleep mode.
    shutdown     = 7,  ///< Shutdown.
    powerbutton  = 8,  ///< POWER button pressed.
    powerbutton2 = 9,  ///< POWER button cleared (?).
    try_sleep    = 10, ///< System sleeping (?).
    ordertoclose = 11  ///< Order to close (such as when an error happens?).
}

/// APT commands.
enum APTCommand : ubyte
{
    none               = 0,  ///< No command received.
    wakeup             = 1,  ///< Applet should wake up.
    request            = 2,  ///< Source applet sent us a parameter.
    response           = 3,  ///< Target applet replied to our parameter.
    exit               = 4,  ///< Exit (??)
    message            = 5,  ///< Message (??)
    homebutton_once    = 6,  ///< HOME button pressed once.
    homebutton_twice   = 7,  ///< HOME button pressed twice (double-pressed).
    dsp_sleep          = 8,  ///< DSP should sleep (manual DSP rights related?).
    dsp_wakeup         = 9,  ///< DSP should wake up (manual DSP rights related?).
    wakeup_exit        = 10, ///< Applet wakes up due to a different applet exiting.
    wakeup_pause       = 11, ///< Applet wakes up after being paused through HOME menu.
    wakeup_cancel      = 12, ///< Applet wakes up due to being cancelled.
    wakeup_cancelall   = 13, ///< Applet wakes up due to all applets being cancelled.
    wakeup_powerbutton = 14, ///< Applet wakes up due to POWER button being pressed (?).
    wakeup_jumptohome  = 15, ///< Applet wakes up and is instructed to jump to HOME menu (?).
    sysapplet_request  = 16, ///< Request for sysapplet (?).
    wakeup_launchapp   = 17  ///< Applet wakes up and is instructed to launch another applet (?).
}

/// APT capture buffer information.
struct aptCaptureBufInfo
{
    uint size;
    uint is3D;

    struct _Anonymous_0
    {
        uint leftOffset;
        uint rightOffset;
        uint format;
    }

    _Anonymous_0 top;
    _Anonymous_0 bottom;
}

/// APT hook types.
enum APTHookType
{
    onsuspend = 0, ///< App suspended.
    onrestore = 1, ///< App restored.
    onsleep   = 2, ///< App sleeping.
    onwakeup  = 3, ///< App waking up.
    onexit    = 4, ///< App exiting.

    count     = 5  ///< Number of APT hook types.
}

/// APT hook function.
alias aptHookFn = void function (APTHookType hook, void* param);

/// APT hook cookie.
struct tag_aptHookCookie
{
    tag_aptHookCookie* next; ///< Next cookie.
    aptHookFn callback; ///< Hook callback.
    void* param; ///< Callback parameter.
}

alias aptHookCookie = tag_aptHookCookie;

/// APT message callback.
alias aptMessageCb = void function (void* user, NSAppID sender, void* msg, size_t msgsize);

/// Initializes APT.
Result aptInit();

/// Exits APT.
void aptExit();

/**
 * @brief Sends an APT command through IPC, taking care of locking, opening and closing an APT session.
 * @param aptcmdbuf Pointer to command buffer (should have capacity for at least 16 words).
 */
Result aptSendCommand(uint* aptcmdbuf);

// Returns true if the application is currently in the foreground.
bool aptIsActive();

/// Returns true if the system has told the application to close.
bool aptShouldClose();

/// Returns true if the system can enter sleep mode while the application is active.
bool aptIsSleepAllowed();

/// Configures whether the system can enter sleep mode while the application is active.
void aptSetSleepAllowed(bool allowed);

/// Handles incoming sleep mode requests.
void aptHandleSleep();

/// Returns true if the user can press the HOME button to jump back to the HOME menu while the application is active.
bool aptIsHomeAllowed();

/// Configures whether the user can press the HOME button to jump back to the HOME menu while the application is active.
void aptSetHomeAllowed(bool allowed);

/**
 * @brief Returns when the HOME button is pressed.
 * @return Whether the HOME button is being pressed.
 */
bool aptIsHomePressed();

/// Returns true if the system requires the application to jump back to the HOME menu.
bool aptShouldJumpToHome();

/// Returns true if there is an incoming HOME button press rejected by the policy set by \ref aptSetHomeAllowed (use this to show a "no HOME allowed" icon).
bool aptCheckHomePressRejected();

/// \deprecated Alias for \ref aptCheckHomePressRejected.
pragma(inline, true)
deprecated bool aptIsHomePressed()
{
    return aptCheckHomePressRejected();
}

/// Jumps back to the HOME menu.
void aptJumpToHomeMenu();

/// Handles incoming jump-to-HOME requests.
pragma(inline, true)
void aptHandleJumpToHome()
{
    if (aptShouldJumpToHome())
        aptJumpToHomeMenu();
}

/**
 * @brief Main function which handles sleep mode and HOME/power buttons - call this at the beginning of every frame.
 * @return true if the application should keep running, false otherwise (see \ref aptShouldClose).
 */
bool aptMainLoop();

/**
 * @brief Sets up an APT status hook.
 * @param cookie Hook cookie to use.
 * @param callback Function to call when APT's status changes.
 * @param param User-defined parameter to pass to the callback.
 */
void aptHook(aptHookCookie* cookie, aptHookFn callback, void* param);

/**
 * @brief Removes an APT status hook.
 * @param cookie Hook cookie to remove.
 */
void aptUnhook(aptHookCookie* cookie);

/**
 * @brief Sets the function to be called when an APT message from another applet is received.
 * @param callback Callback function.
 * @param user User-defined data to be passed to the callback.
 */
void aptSetMessageCallback(aptMessageCb callback, void* user);

/**
 * @brief Launches a library applet.
 * @param appId ID of the applet to launch.
 * @param buf Input/output buffer that contains launch parameters on entry and result data on exit.
 * @param bufsize Size of the buffer.
 * @param handle Handle to pass to the library applet.
 * @return Whether the application should continue running after the library applet launch.
 */
void aptLaunchLibraryApplet(NSAppID appId, void* buf, size_t bufsize, Handle handle);

/// Clears the chainloader state.
void aptClearChainloader();

/**
 * @brief Configures the chainloader to launch a specific application.
 * @param programID ID of the program to chainload to.
 * @param mediatype Media type of the program to chainload to.
 */
void aptSetChainloader(ulong programID, ubyte mediatype);

/// Configures the chainloader to launch the previous application.
void aptSetChainloaderToCaller();

/// Configures the chainloader to relaunch the current application (i.e. soft-reset)
void aptSetChainloaderToSelf();

/**
 * @brief Sets the "deliver arg" and HMAC for the chainloader, which will
 *        be passed to the target 3DS/DS(i) application. The meaning of each
 *        parameter varies on a per-application basis.
 * @param deliverArg Deliver arg to pass to the target application.
 * @param deliverArgSize Size of the deliver arg, maximum 0x300 bytes.
 * @param hmac HMAC buffer, 32 bytes. Use NULL to pass an all-zero dummy HMAC.
 */
void aptSetChainloaderArgs(const(void)* deliverArg, size_t deliverArgSize, const(void)* hmac);

/**
 * @brief Gets an APT lock handle.
 * @param flags Flags to use.
 * @param lockHandle Pointer to output the lock handle to.
 */
Result APT_GetLockHandle(ushort flags, Handle* lockHandle);

/**
 * @brief Initializes an application's registration with APT.
 * @param appId ID of the application.
 * @param attr Attributes of the application.
 * @param signalEvent Pointer to output the signal event handle to.
 * @param resumeEvent Pointer to output the resume event handle to.
 */
Result APT_Initialize(NSAppID appId, APT_AppletAttr attr, Handle* signalEvent, Handle* resumeEvent);

/**
 * @brief Terminates an application's registration with APT.
 * @param appID ID of the application.
 */
Result APT_Finalize(NSAppID appId);

/// Asynchronously resets the hardware.
Result APT_HardwareResetAsync();

/**
 * @brief Enables APT.
 * @param attr Attributes of the application.
 */
Result APT_Enable(APT_AppletAttr attr);

/**
 * @brief Gets applet management info.
 * @param inpos Requested applet position.
 * @param outpos Pointer to output the position of the current applet to.
 * @param req_appid Pointer to output the AppID of the applet at the requested position to.
 * @param menu_appid Pointer to output the HOME menu AppID to.
 * @param active_appid Pointer to output the AppID of the currently active applet to.
 */
Result APT_GetAppletManInfo(APTAppletPos inpos, APTAppletPos* outpos, NSAppID* req_appid, NSAppID* menu_appid, NSAppID* active_appid);

/**
 * @brief Gets the menu's app ID.
 * @return The menu's app ID.
 */
pragma(inline, true)
NSAppID aptGetMenuAppID()
{
    NSAppID menu_appid = NSAppID.none;
    APT_GetAppletManInfo(APTAppletPos.none, null, null, &menu_appid, null);
    return menu_appid;
}

/**
 * @brief Gets an applet's information.
 * @param appID AppID of the applet.
 * @param pProgramID Pointer to output the program ID to.
 * @param pMediaType Pointer to output the media type to.
 * @param pRegistered Pointer to output the registration status to.
 * @param pLoadState Pointer to output the load state to.
 * @param pAttributes Pointer to output the applet atrributes to.
 */
Result APT_GetAppletInfo(NSAppID appID, ulong* pProgramID, ubyte* pMediaType, bool* pRegistered, bool* pLoadState, APT_AppletAttr* pAttributes);

/**
 * @brief Gets an applet's program information.
 * @param id ID of the applet.
 * @param flags Flags to use when retreiving the information.
 * @param titleversion Pointer to output the applet's title version to.
 *
 * Flags:
 * - 0x01: Use AM_ListTitles with NAND media type.
 * - 0x02: Use AM_ListTitles with SDMC media type.
 * - 0x04: Use AM_ListTitles with GAMECARD media type.
 * - 0x10: Input ID is an app ID. Must be set if 0x20 is not.
 * - 0x20: Input ID is a program ID. Must be set if 0x10 is not.
 * - 0x100: Sets program ID high to 0x00040000, else it is 0x00040010. Only used when 0x20 is set.
 */
Result APT_GetAppletProgramInfo(uint id, uint flags, ushort* titleversion);

/**
 * @brief Gets the current application's program ID.
 * @param pProgramID Pointer to output the program ID to.
 */
Result APT_GetProgramID(ulong* pProgramID);

/// Prepares to jump to the home menu.
Result APT_PrepareToJumpToHomeMenu();

/**
 * @brief Jumps to the home menu.
 * @param param Parameters to jump with.
 * @param Size of the parameter buffer.
 * @param handle Handle to pass.
 */
Result APT_JumpToHomeMenu(const(void)* param, size_t paramSize, Handle handle);

/**
 * @brief Prepares to jump to an application.
 * @param exiting Specifies whether the applet is exiting.
 */
Result APT_PrepareToJumpToApplication(bool exiting);

/**
 * @brief Jumps to an application.
 * @param param Parameters to jump with.
 * @param Size of the parameter buffer.
 * @param handle Handle to pass.
 */
Result APT_JumpToApplication(const(void)* param, size_t paramSize, Handle handle);

/**
 * @brief Gets whether an application is registered.
 * @param appID ID of the application.
 * @param out Pointer to output the registration state to.
 */
Result APT_IsRegistered(NSAppID appID, bool* out_);

/**
 * @brief Inquires as to whether a signal has been received.
 * @param appID ID of the application.
 * @param signalType Pointer to output the signal type to.
 */
Result APT_InquireNotification(uint appID, APTSignal* signalType);

/**
 * @brief Requests to enter sleep mode, and later sets wake events if allowed to.
 * @param wakeEvents The wake events. Limited to "shell" (bit 1) for the PDN wake events part
 * and "shell opened", "shell closed" and "HOME button pressed" for the MCU interrupts part.
 */
Result APT_SleepSystem(const(PtmWakeEvents)* wakeEvents);

/**
 * @brief Notifies an application to wait.
 * @param appID ID of the application.
 */
Result APT_NotifyToWait(NSAppID appID);

/**
 * @brief Calls an applet utility function.
 * @param id Utility function to call.
 * @param out Pointer to write output data to.
 * @param outSize Size of the output buffer.
 * @param in Pointer to the input data.
 * @param inSize Size of the input buffer.
 */
Result APT_AppletUtility(int id, void* out_, size_t outSize, const(void)* in_, size_t inSize);

/// Sleeps if shell is closed (?).
Result APT_SleepIfShellClosed();

/**
 * @brief Locks a transition (?).
 * @param transition Transition ID.
 * @param flag Flag (?)
 */
Result APT_LockTransition(uint transition, bool flag);

/**
 * @brief Tries to lock a transition (?).
 * @param transition Transition ID.
 * @param succeeded Pointer to output whether the lock was successfully applied.
 */
Result APT_TryLockTransition(uint transition, bool* succeeded);

/**
 * @brief Unlocks a transition (?).
 * @param transition Transition ID.
 */
Result APT_UnlockTransition(uint transition);

/**
 * @brief Glances at a receieved parameter without removing it from the queue.
 * @param appID AppID of the application.
 * @param buffer Buffer to receive to.
 * @param bufferSize Size of the buffer.
 * @param sender Pointer to output the sender's AppID to.
 * @param command Pointer to output the command ID to.
 * @param actualSize Pointer to output the actual received data size to.
 * @param parameter Pointer to output the parameter handle to.
 */
Result APT_GlanceParameter(NSAppID appID, void* buffer, size_t bufferSize, NSAppID* sender, APTCommand* command, size_t* actualSize, Handle* parameter);

/**
 * @brief Receives a parameter.
 * @param appID AppID of the application.
 * @param buffer Buffer to receive to.
 * @param bufferSize Size of the buffer.
 * @param sender Pointer to output the sender's AppID to.
 * @param command Pointer to output the command ID to.
 * @param actualSize Pointer to output the actual received data size to.
 * @param parameter Pointer to output the parameter handle to.
 */
Result APT_ReceiveParameter(NSAppID appID, void* buffer, size_t bufferSize, NSAppID* sender, APTCommand* command, size_t* actualSize, Handle* parameter);

/**
 * @brief Sends a parameter.
 * @param source AppID of the source application.
 * @param dest AppID of the destination application.
 * @param command Command to send.
 * @param buffer Buffer to send.
 * @param bufferSize Size of the buffer.
 * @param parameter Parameter handle to pass.
 */
Result APT_SendParameter(NSAppID source, NSAppID dest, APTCommand command, const(void)* buffer, uint bufferSize, Handle parameter);

/**
 * @brief Cancels a parameter which matches the specified source and dest AppIDs.
 * @param source AppID of the source application (use NSAppID.none to disable the check).
 * @param dest AppID of the destination application (use NSAppID.none to disable the check).
 * @param success Pointer to output true if a parameter was cancelled, or false otherwise.
 */
Result APT_CancelParameter(NSAppID source, NSAppID dest, bool* success);

/**
 * @brief Sends capture buffer information.
 * @param captureBuf Capture buffer information to send.
 */
Result APT_SendCaptureBufferInfo(const(aptCaptureBufInfo)* captureBuf);

/**
 * @brief Replies to a sleep query.
 * @param appID ID of the application.
 * @param reply Query reply value.
 */
Result APT_ReplySleepQuery(NSAppID appID, APTQueryReply reply);

/**
 * @brief Replies that a sleep notification has been completed.
 * @param appID ID of the application.
 */
Result APT_ReplySleepNotificationComplete(NSAppID appID);

/**
 * @brief Prepares to close the application.
 * @param cancelPreload Whether applet preloads should be cancelled.
 */
Result APT_PrepareToCloseApplication(bool cancelPreload);

/**
 * @brief Closes the application.
 * @param param Parameters to close with.
 * @param paramSize Size of param.
 * @param handle Handle to pass.
 */
Result APT_CloseApplication(const(void)* param, size_t paramSize, Handle handle);

/**
 * @brief Sets the application's CPU time limit.
 * @param percent CPU time limit percentage to set.
 */
Result APT_SetAppCpuTimeLimit(uint percent);

/**
 * @brief Gets the application's CPU time limit.
 * @param percent Pointer to output the CPU time limit percentage to.
 */
Result APT_GetAppCpuTimeLimit(uint* percent);

/**
 * @brief Checks whether the system is a New 3DS.
 * @param out Pointer to write the New 3DS flag to.
 */
Result APT_CheckNew3DS(bool* out_);

/**
 * @brief Prepares for an applicaton jump.
 * @param flags Flags to use.
 * @param programID ID of the program to jump to.
 * @param mediatype Media type of the program to jump to.
 */
Result APT_PrepareToDoApplicationJump(ubyte flags, ulong programID, ubyte mediatype);

/**
 * @brief Performs an application jump.
 * @param param Parameter buffer.
 * @param paramSize Size of parameter buffer.
 * @param hmac HMAC buffer (should be 0x20 bytes long).
 */
Result APT_DoApplicationJump(const(void)* param, size_t paramSize, const(void)* hmac);

/**
 * @brief Prepares to start a library applet.
 * @param appID AppID of the applet to start.
 */
Result APT_PrepareToStartLibraryApplet(NSAppID appID);

/**
 * @brief Starts a library applet.
 * @param appID AppID of the applet to launch.
 * @param param Buffer containing applet parameters.
 * @param paramsize Size of the buffer.
 * @param handle Handle to pass to the applet.
 */
Result APT_StartLibraryApplet(NSAppID appID, const(void)* param, size_t paramSize, Handle handle);

/**
 * @brief Prepares to start a system applet.
 * @param appID AppID of the applet to start.
 */
Result APT_PrepareToStartSystemApplet(NSAppID appID);

/**
 * @brief Starts a system applet.
 * @param appID AppID of the applet to launch.
 * @param param Buffer containing applet parameters.
 * @param paramSize Size of the parameter buffer.
 * @param handle Handle to pass to the applet.
 */
Result APT_StartSystemApplet(NSAppID appID, const(void)* param, size_t paramSize, Handle handle);

/**
 * @brief Retrieves the shared system font.
 * @brief fontHandle Pointer to write the handle of the system font memory block to.
 * @brief mapAddr Pointer to write the mapping address of the system font memory block to.
 */
Result APT_GetSharedFont(Handle* fontHandle, uint* mapAddr);

/**
 * @brief Receives the deliver (launch) argument
 * @param param Parameter buffer.
 * @param paramSize Size of parameter buffer.
 * @param hmac HMAC buffer (should be 0x20 bytes long).
 * @param sender Pointer to output the sender's AppID to.
 * @param received Pointer to output whether an argument was received to.
 */
Result APT_ReceiveDeliverArg(void* param, size_t paramSize, void* hmac, ulong* sender, bool* received);
