/**
 * @file qtm.h
 * @brief QTM service.
 */

module ctru.services.qtm;

import ctru.types;

extern (C): nothrow: @nogc:

//See also: http://3dbrew.org/wiki/QTM_Services

/// Head tracking coordinate pair.
struct QTM_HeadTrackingInfoCoord
{
    float x; ///< X coordinate.
    float y; ///< Y coordinate.
}

/// Head tracking info.
struct QTM_HeadTrackingInfo
{
    ubyte[5] flags; ///< Flags.
    ubyte[3] padding; ///< Padding.
    float floatdata_x08; ///< Unknown. Not used by System_Settings.
    QTM_HeadTrackingInfoCoord[4] coords0; ///< Head coordinates.
    uint[5] unk_x2c; ///< Unknown. Not used by System_Settings.
}

/// Initializes QTM.
Result qtmInit();

/// Exits QTM.
void qtmExit();

/**
 * @brief Checks whether QTM is initialized.
 * @return Whether QTM is initialized.
 */
bool qtmCheckInitialized();

/**
 * @brief Checks whether a head is fully detected.
 * @param info Tracking info to check.
 */
bool qtmCheckHeadFullyDetected(QTM_HeadTrackingInfo* info);

/**
 * @brief Converts QTM coordinates to screen coordinates.
 * @param coord Coordinates to convert.
 * @param screen_width Width of the screen. Can be NULL to use the default value for the top screen.
 * @param screen_height Height of the screen. Can be NULL to use the default value for the top screen.
 * @param x Pointer to output the screen X coordinate to.
 * @param y Pointer to output the screen Y coordinate to.
 */
Result qtmConvertCoordToScreen(QTM_HeadTrackingInfoCoord* coord, float* screen_width, float* screen_height, uint* x, uint* y);

/**
 * @brief Gets the current head tracking info.
 * @param val Normally 0.
 * @param out Pointer to write head tracking info to.
 */
Result QTM_GetHeadTrackingInfo(ulong val, QTM_HeadTrackingInfo* out_);
