/**
 * @file hid.h
 * @brief HID service.
 */

module ctru.services.hid;

import ctru.types;

extern (C): nothrow: @nogc:

//See also: http://3dbrew.org/wiki/HID_Services http://3dbrew.org/wiki/HID_Shared_Memory

/// Key values.
enum Key : uint
{
    a            = BIT(0),  ///< A
    b            = BIT(1),  ///< B
    select       = BIT(2),  ///< Select
    start        = BIT(3),  ///< Start
    dright       = BIT(4),  ///< D-Pad Right
    dleft        = BIT(5),  ///< D-Pad Left
    dup          = BIT(6),  ///< D-Pad Up
    ddown        = BIT(7),  ///< D-Pad Down
    r            = BIT(8),  ///< R
    l            = BIT(9),  ///< L
    x            = BIT(10), ///< X
    y            = BIT(11), ///< Y
    zl           = BIT(14), ///< ZL (New 3DS only)
    zr           = BIT(15), ///< ZR (New 3DS only)
    touch        = BIT(20), ///< Touch (Not actually provided by HID)
    cstick_right = BIT(24), ///< C-Stick Right (New 3DS only)
    cstick_left  = BIT(25), ///< C-Stick Left (New 3DS only)
    cstick_up    = BIT(26), ///< C-Stick Up (New 3DS only)
    cstick_down  = BIT(27), ///< C-Stick Down (New 3DS only)
    cpad_right   = BIT(28), ///< Circle Pad Right
    cpad_left    = BIT(29), ///< Circle Pad Left
    cpad_up      = BIT(30), ///< Circle Pad Up
    cpad_down    = BIT(31), ///< Circle Pad Down

    // Generic catch-all directions
    up    = dup    | cpad_up,   ///< D-Pad Up or Circle Pad Up
    down  = ddown  | cpad_down, ///< D-Pad Down or Circle Pad Down
    left  = dleft  | cpad_left, ///< D-Pad Left or Circle Pad Left
    right = dright | cpad_right ///< D-Pad Right or Circle Pad Right
}

/// Touch position.
struct touchPosition
{
    ushort px; ///< Touch X
    ushort py; ///< Touch Y
}

/// Circle Pad position.
struct circlePosition
{
    short dx; ///< Pad X
    short dy; ///< Pad Y
}

/// Accelerometer vector.
struct accelVector
{
    short x; ///< Accelerometer X
    short y; ///< Accelerometer Y
    short z; ///< Accelerometer Z
}

/// Gyroscope angular rate.
struct angularRate
{
    short x; ///< Roll
    short z; ///< Yaw
    short y; ///< Pitch
}

/// HID events.
enum HIDEvent : ubyte
{
    pad0     = 0, ///< Event signaled by HID-module, when the sharedmem+0(PAD/circle-pad)/+0xA8(touch-screen) region was updated.
    pad1     = 1, ///< Event signaled by HID-module, when the sharedmem+0(PAD/circle-pad)/+0xA8(touch-screen) region was updated.
    accel    = 2, ///< Event signaled by HID-module, when the sharedmem accelerometer state was updated.
    gyro     = 3, ///< Event signaled by HID-module, when the sharedmem gyroscope state was updated.
    debugpad = 4, ///< Event signaled by HID-module, when the sharedmem DebugPad state was updated.

    max      = 5  ///< Used to know how many events there are.
}

extern __gshared Handle hidMemHandle; ///< HID shared memory handle.
extern __gshared vu32* hidSharedMem; ///< HID shared memory.

/// Initializes HID.
Result hidInit();

/// Exits HID.
void hidExit();

/// Scans HID for input data.
void hidScanInput();

/**
 * @brief Returns a bitmask of held buttons.
 * Individual buttons can be extracted using binary AND.
 * @return 32-bit bitmask of held buttons (1+ frames).
 */
uint hidKeysHeld();

/**
 * @brief Returns a bitmask of newly pressed buttons, this frame.
 * Individual buttons can be extracted using binary AND.
 * @return 32-bit bitmask of newly pressed buttons.
 */
uint hidKeysDown();

/**
* @brief Returns a bitmask of newly released buttons, this frame.
 * Individual buttons can be extracted using binary AND.
 * @return 32-bit bitmask of newly released buttons.
 */
uint hidKeysUp();

/**
 * @brief Reads the current touch position.
 * @param pos Pointer to output the touch position to.
 */
void hidTouchRead(touchPosition* pos);

/**
 * @brief Reads the current circle pad position.
 * @param pos Pointer to output the circle pad position to.
 */
void hidCircleRead(circlePosition* pos);

/**
 * @brief Reads the current accelerometer data.
 * @param vector Pointer to output the accelerometer data to.
 */
void hidAccelRead(accelVector* vector);

/**
 * @brief Reads the current gyroscope data.
 * @param rate Pointer to output the gyroscope data to.
 */
void hidGyroRead(angularRate* rate);

/**
 * @brief Waits for an HID event.
 * @param id ID of the event.
 * @param nextEvent Whether to discard the current event and wait for the next event.
 */
void hidWaitForEvent(HIDEvent id, bool nextEvent);

/// Compatibility macro for hidScanInput.
alias scanKeys = hidScanInput;
/// Compatibility macro for hidKeysHeld.
alias keysHeld = hidKeysHeld;
/// Compatibility macro for hidKeysDown.
alias keysDown = hidKeysDown;
/// Compatibility macro for hidKeysUp.
alias keysUp = hidKeysUp;
/// Compatibility macro for hidTouchRead.
alias touchRead = hidTouchRead;
/// Compatibility macro for hidCircleRead.
alias circleRead = hidCircleRead;

/**
 * @brief Gets the handles for HID operation.
 * @param outMemHandle Pointer to output the shared memory handle to.
 * @param eventpad0 Pointer to output the pad 0 event handle to.
 * @param eventpad1 Pointer to output the pad 1 event handle to.
 * @param eventaccel Pointer to output the accelerometer event handle to.
 * @param eventgyro Pointer to output the gyroscope event handle to.
 * @param eventdebugpad Pointer to output the debug pad event handle to.
 */
Result HIDUSER_GetHandles(Handle* outMemHandle, Handle* eventpad0, Handle* eventpad1, Handle* eventaccel, Handle* eventgyro, Handle* eventdebugpad);

/// Enables the accelerometer.
Result HIDUSER_EnableAccelerometer();

/// Disables the accelerometer.
Result HIDUSER_DisableAccelerometer();

/// Enables the gyroscope.
Result HIDUSER_EnableGyroscope();

/// Disables the gyroscope.
Result HIDUSER_DisableGyroscope();

/**
 * @brief Gets the gyroscope raw to dps coefficient.
 * @param coeff Pointer to output the coefficient to.
 */
Result HIDUSER_GetGyroscopeRawToDpsCoefficient(float* coeff);

/**
 * @brief Gets the current volume slider value. (0-63)
 * @param volume Pointer to write the volume slider value to.
 */
Result HIDUSER_GetSoundVolume(ubyte* volume);
