/**
 * @file cam.h
 * @brief CAM service for using the 3DS's front and back cameras.
 */

module ctru.services.cam;

import ctru.types;
import ctru.services.y2r;

extern (C): nothrow: @nogc:

/// Camera connection target ports.
enum
{
    PORT_NONE = 0x0,    ///< No port.
    PORT_CAM1 = BIT(0), ///< CAM1 port.
    PORT_CAM2 = BIT(1), ///< CAM2 port.

    // Port combinations.
    PORT_BOTH = PORT_CAM1 | PORT_CAM2 ///< Both ports.
}

/// Camera combinations.
enum
{
    SELECT_NONE = 0x0,    ///< No camera.
    SELECT_OUT1 = BIT(0), ///< Outer camera 1.
    SELECT_IN1  = BIT(1), ///< Inner camera 1.
    SELECT_OUT2 = BIT(2), ///< Outer camera 2.

    // Camera combinations.
    SELECT_IN1_OUT1  = SELECT_OUT1 | SELECT_IN1,              ///< Outer camera 1 and inner camera 1.
    SELECT_OUT1_OUT2 = SELECT_OUT1 | SELECT_OUT2,             ///< Both outer cameras.
    SELECT_IN1_OUT2  = SELECT_IN1  | SELECT_OUT2,             ///< Inner camera 1 and outer camera 2.
    SELECT_ALL       = SELECT_OUT1 | SELECT_IN1 | SELECT_OUT2 ///< All cameras.
}

/// Camera contexts.
enum CAMUContext : ubyte
{
    none = 0x0,                  ///< No context.
    a    = BIT(0),               ///< Context A.
    b    = BIT(1),               ///< Context B.

    // Context combinations.
    both = a | b ///< Both contexts.
}

/// Ways to flip the camera image.
enum CAMUFlip : ubyte
{
    none       = 0x0, ///< No flip.
    horizontal = 0x1, ///< Horizontal flip.
    vertical   = 0x2, ///< Vertical flip.
    reverse    = 0x3  ///< Reverse flip.
}

/// Camera image resolutions.
enum CAMUSize : ubyte
{
    vga            = 0x0,      ///< VGA size.         (640x480)
    qvga           = 0x1,      ///< QVGA size.        (320x240)
    qqvga          = 0x2,      ///< QQVGA size.       (160x120)
    cif            = 0x3,      ///< CIF size.         (352x288)
    qcif           = 0x4,      ///< QCIF size.        (176x144)
    ds_lcd         = 0x5,      ///< DS LCD size.      (256x192)
    ds_lcdx4       = 0x6,      ///< DS LCD x4 size.   (512x384)
    ctr_top_lcd    = 0x7,      ///< CTR Top LCD size. (400x240)

    // Alias for bottom screen to match top screen naming.
    ctr_bottom_lcd = qvga ///< CTR Bottom LCD size. (320x240)
}

/// Camera capture frame rates.
enum CAMUFrameRate : ubyte
{
    _15       = 0x0, ///< 15 FPS.
    _15_to_5  = 0x1, ///< 15-5 FPS.
    _15_to_2  = 0x2, ///< 15-2 FPS.
    _10       = 0x3, ///< 10 FPS.
    _8_5      = 0x4, ///< 8.5 FPS.
    _5        = 0x5, ///< 5 FPS.
    _20       = 0x6, ///< 20 FPS.
    _20_to_5  = 0x7, ///< 20-5 FPS.
    _30       = 0x8, ///< 30 FPS.
    _30_to_5  = 0x9, ///< 30-5 FPS.
    _15_to_10 = 0xA, ///< 15-10 FPS.
    _20_to_10 = 0xB, ///< 20-10 FPS.
    _30_to_10 = 0xC  ///< 30-10 FPS.
}

/// Camera white balance modes.
enum CAMUWhiteBalance : ubyte
{
    _auto                    = 0x0, ///< Auto white balance.
    _3200k                   = 0x1, ///< 3200K white balance.
    _4150k                   = 0x2, ///< 4150K white balance.
    _5200k                   = 0x3, ///< 5200K white balance.
    _6000k                   = 0x4, ///< 6000K white balance.
    _7000k                   = 0x5, ///< 7000K white balance.

    // White balance aliases.
    normal                  = _auto,  // Normal white balance.      (AUTO)
    tungsten                = _3200k, // Tungsten white balance.    (3200K)
    white_fluorescent_light = _4150k, // Fluorescent white balance. (4150K)
    daylight                = _5200k, // Daylight white balance.    (5200K)
    cloudy                  = _6000k, // Cloudy white balance.      (6000K)
    horizon                 = _6000k, // Horizon white balance.     (6000K)
    shade                   = _7000k  // Shade white balance.       (7000K)
}

/// Camera photo modes.
enum CAMUPhotoMode : ubyte
{
    normal    = 0x0, ///< Normal mode.
    portrait  = 0x1, ///< Portrait mode.
    landscape = 0x2, ///< Landscape mode.
    nightview = 0x3, ///< Night mode.
    letter    = 0x4  ///< Letter mode.
}

/// Camera special effects.
enum CAMUEffect : ubyte
{
    none     = 0x0, ///< No effects.
    mono     = 0x1, ///< Mono effect.
    sepia    = 0x2, ///< Sepia effect.
    negative = 0x3, ///< Negative effect.
    negafilm = 0x4, ///< Negative film effect.
    sepia01  = 0x5  ///< Sepia effect.
}

/// Camera contrast patterns.
enum CAMUContrast : ubyte
{
    pattern_01 = 0x0, ///< Pattern 1.
    pattern_02 = 0x1, ///< Pattern 2.
    pattern_03 = 0x2, ///< Pattern 3.
    pattern_04 = 0x3, ///< Pattern 4.
    pattern_05 = 0x4, ///< Pattern 5.
    pattern_06 = 0x5, ///< Pattern 6.
    pattern_07 = 0x6, ///< Pattern 7.
    pattern_08 = 0x7, ///< Pattern 8.
    pattern_09 = 0x8, ///< Pattern 9.
    pattern_10 = 0x9, ///< Pattern 10.
    pattern_11 = 0xA, ///< Pattern 11.

    // Contrast aliases.
    low    = pattern_05, ///< Low contrast.    (5)
    normal = pattern_06, ///< Normal contrast. (6)
    high   = pattern_07  ///< High contrast.   (7)
}

/// Camera lens correction modes.
enum CAMULensCorrection : ubyte
{
    off    = 0x0,   ///< No lens correction.
    on_70  = 0x1,   ///< Edge-to-center brightness ratio of 70.
    on_90  = 0x2,   ///< Edge-to-center brightness ratio of 90.

    // Lens correction aliases.
    dark   = off,   ///< Dark lens correction.   (OFF)
    normal = on_70, ///< Normal lens correction. (70)
    bright = on_90  ///< Bright lens correction. (90)
}

/// Camera image output formats.
enum CAMUOutputFormat : ubyte
{
    yuv_422 = 0x0, ///< YUV422
    rgb_565 = 0x1  ///< RGB565
}

/// Camera shutter sounds.
enum CAMUShutterSoundType : ubyte
{
    normal    = 0x0, ///< Normal shutter sound.
    movie     = 0x1, ///< Shutter sound to begin a movie.
    movie_end = 0x2  ///< Shutter sound to end a movie.
}

/// Image quality calibration data.
struct CAMU_ImageQualityCalibrationData
{
    short aeBaseTarget; ///< Auto exposure base target brightness.
    short kRL; ///< Left color correction matrix red normalization coefficient.
    short kGL; ///< Left color correction matrix green normalization coefficient.
    short kBL; ///< Left color correction matrix blue normalization coefficient.
    short ccmPosition; ///< Color correction matrix position.
    ushort awbCcmL9Right; ///< Right camera, left color correction matrix red/green gain.
    ushort awbCcmL9Left; ///< Left camera, left color correction matrix red/green gain.
    ushort awbCcmL10Right; ///< Right camera, left color correction matrix blue/green gain.
    ushort awbCcmL10Left; ///< Left camera, left color correction matrix blue/green gain.
    ushort awbX0Right; ///< Right camera, color correction matrix position threshold.
    ushort awbX0Left; ///< Left camera, color correction matrix position threshold.
}

/// Stereo camera calibration data.
struct CAMU_StereoCameraCalibrationData
{
    ubyte isValidRotationXY; ///< #bool Whether the X and Y rotation data is valid.
    ubyte[3] padding; ///< Padding. (Aligns isValidRotationXY to 4 bytes)
    float scale; ///< Scale to match the left camera image with the right.
    float rotationZ; ///< Z axis rotation to match the left camera image with the right.
    float translationX; ///< X axis translation to match the left camera image with the right.
    float translationY; ///< Y axis translation to match the left camera image with the right.
    float rotationX; ///< X axis rotation to match the left camera image with the right.
    float rotationY; ///< Y axis rotation to match the left camera image with the right.
    float angleOfViewRight; ///< Right camera angle of view.
    float angleOfViewLeft; ///< Left camera angle of view.
    float distanceToChart; ///< Distance between cameras and measurement chart.
    float distanceCameras; ///< Distance between left and right cameras.
    short imageWidth; ///< Image width.
    short imageHeight; ///< Image height.
    ubyte[16] reserved; ///< Reserved for future use. (unused)
}

/// Batch camera configuration for use without a context.
struct CAMU_PackageParameterCameraSelect
{
    ubyte camera; ///< Selected camera.
    byte exposure; ///< Camera exposure.
    ubyte whiteBalance; ///< #CAMUWhiteBalance Camera white balance.
    byte sharpness; ///< Camera sharpness.
    ubyte autoExposureOn; ///< #bool Whether to automatically determine the proper exposure.
    ubyte autoWhiteBalanceOn; ///< #bool Whether to automatically determine the white balance mode.
    ubyte frameRate; ///< #CAMUFrameRate Camera frame rate.
    ubyte photoMode; ///< #CAMUPhotoMode Camera photo mode.
    ubyte contrast; ///< #CAMUContrast Camera contrast.
    ubyte lensCorrection; ///< #CAMULensCorrection Camera lens correction.
    ubyte noiseFilterOn; ///< #bool Whether to enable the camera's noise filter.
    ubyte padding; ///< Padding. (Aligns last 3 fields to 4 bytes)
    short autoExposureWindowX; ///< X of the region to use for auto exposure.
    short autoExposureWindowY; ///< Y of the region to use for auto exposure.
    short autoExposureWindowWidth; ///< Width of the region to use for auto exposure.
    short autoExposureWindowHeight; ///< Height of the region to use for auto exposure.
    short autoWhiteBalanceWindowX; ///< X of the region to use for auto white balance.
    short autoWhiteBalanceWindowY; ///< Y of the region to use for auto white balance.
    short autoWhiteBalanceWindowWidth; ///< Width of the region to use for auto white balance.
    short autoWhiteBalanceWindowHeight; ///< Height of the region to use for auto white balance.
}

/// Batch camera configuration for use with a context.
struct CAMU_PackageParameterContext
{
    ubyte camera; ///< Selected camera.
    ubyte context; ///< #CAMUContext Selected context.
    ubyte flip; ///< #CAMUFlip Camera image flip mode.
    ubyte effect; ///< #CAMUEffect Camera image special effects.
    ubyte size; ///< #CAMUSize Camera image resolution.
}

/// Batch camera configuration for use with a context and with detailed size information.
struct CAMU_PackageParameterContextDetail
{
    ubyte camera; ///< Selected camera.
    ubyte context; ///< #CAMUContext Selected context.
    ubyte flip; ///< #CAMUFlip Camera image flip mode.
    ubyte effect; ///< #CAMUEffect Camera image special effects.
    short width; ///< Image width.
    short height; ///< Image height.
    short cropX0; ///< First crop point X.
    short cropY0; ///< First crop point Y.
    short cropX1; ///< Second crop point X.
    short cropY1; ///< Second crop point Y.
}

/**
 * @brief Initializes the cam service.
 *
 * This will internally get the handle of the service, and on success call CAMU_DriverInitialize.
 */
Result camInit ();

/**
 * @brief Closes the cam service.
 *
 * This will internally call CAMU_DriverFinalize and close the handle of the service.
 */
void camExit ();

/**
 * Begins capture on the specified camera port.
 * @param port Port to begin capture on.
 */
Result CAMU_StartCapture (uint port);

/**
 * Terminates capture on the specified camera port.
 * @param port Port to terminate capture on.
 */
Result CAMU_StopCapture (uint port);

/**
 * @brief Gets whether the specified camera port is busy.
 * @param busy Pointer to output the busy state to.
 * @param port Port to check.
 */
Result CAMU_IsBusy (bool* busy, uint port);

/**
 * @brief Clears the buffer and error flags of the specified camera port.
 * @param port Port to clear.
 */
Result CAMU_ClearBuffer (uint port);

/**
 * @brief Gets a handle to the event signaled on vsync interrupts.
 * @param event Pointer to output the event handle to.
 * @param port Port to use.
 */
Result CAMU_GetVsyncInterruptEvent (Handle* event, uint port);

/**
 * @brief Gets a handle to the event signaled on camera buffer errors.
 * @param event Pointer to output the event handle to.
 * @param port Port to use.
 */
Result CAMU_GetBufferErrorInterruptEvent (Handle* event, uint port);

/**
 * @brief Initiates the process of receiving a camera frame.
 * @param event Pointer to output the completion event handle to.
 * @param dst Buffer to write data to.
 * @param port Port to receive from.
 * @param imageSize Size of the image to receive.
 * @param transferUnit Transfer unit to use when receiving.
 */
Result CAMU_SetReceiving (Handle* event, void* dst, uint port, uint imageSize, short transferUnit);

/**
 * @brief Gets whether the specified camera port has finished receiving image data.
 * @param finishedReceiving Pointer to output the receiving status to.
 * @param port Port to check.
 */
Result CAMU_IsFinishedReceiving (bool* finishedReceiving, uint port);

/**
 * @brief Sets the number of lines to transfer into an image buffer.
 * @param port Port to use.
 * @param lines Lines to transfer.
 * @param width Width of the image.
 * @param height Height of the image.
 */
Result CAMU_SetTransferLines (uint port, short lines, short width, short height);

/**
 * @brief Gets the maximum number of lines that can be saved to an image buffer.
 * @param maxLines Pointer to write the maximum number of lines to.
 * @param width Width of the image.
 * @param height Height of the image.
 */
Result CAMU_GetMaxLines (short* maxLines, short width, short height);

/**
 * @brief Sets the number of bytes to transfer into an image buffer.
 * @param port Port to use.
 * @param bytes Bytes to transfer.
 * @param width Width of the image.
 * @param height Height of the image.
 */
Result CAMU_SetTransferBytes (uint port, uint bytes, short width, short height);

/**
 * @brief Gets the number of bytes to transfer into an image buffer.
 * @param transferBytes Pointer to write the number of bytes to.
 * @param port Port to use.
 */
Result CAMU_GetTransferBytes (uint* transferBytes, uint port);

/**
 * @brief Gets the maximum number of bytes that can be saved to an image buffer.
 * @param maxBytes Pointer to write the maximum number of bytes to.
 * @param width Width of the image.
 * @param height Height of the image.
 */
Result CAMU_GetMaxBytes (uint* maxBytes, short width, short height);

/**
 * @brief Sets whether image trimming is enabled.
 * @param port Port to use.
 * @param trimming Whether image trimming is enabled.
 */
Result CAMU_SetTrimming (uint port, bool trimming);

/**
 * @brief Gets whether image trimming is enabled.
 * @param trimming Pointer to output the trim state to.
 * @param port Port to use.
 */
Result CAMU_IsTrimming (bool* trimming, uint port);

/**
 * @brief Sets the parameters used for trimming images.
 * @param port Port to use.
 * @param xStart Start X coordinate.
 * @param yStart Start Y coordinate.
 * @param xEnd End X coordinate.
 * @param yEnd End Y coordinate.
 */
Result CAMU_SetTrimmingParams (uint port, short xStart, short yStart, short xEnd, short yEnd);

/**
 * @brief Gets the parameters used for trimming images.
 * @param xStart Pointer to write the start X coordinate to.
 * @param yStart Pointer to write the start Y coordinate to.
 * @param xEnd Pointer to write the end X coordinate to.
 * @param yEnd Pointer to write the end Y coordinate to.
 * @param port Port to use.
 */
Result CAMU_GetTrimmingParams (short* xStart, short* yStart, short* xEnd, short* yEnd, uint port);

/**
 * @brief Sets the parameters used for trimming images, relative to the center of the image.
 * @param port Port to use.
 * @param trimWidth Trim width.
 * @param trimHeight Trim height.
 * @param camWidth Camera width.
 * @param camHeight Camera height.
 */
Result CAMU_SetTrimmingParamsCenter (uint port, short trimWidth, short trimHeight, short camWidth, short camHeight);

/**
 * @brief Activates the specified camera.
 * @param select Camera to use.
 */
Result CAMU_Activate (uint select);

/**
 * @brief Switches the specified camera's active context.
 * @param select Camera to use.
 * @param context Context to use.
 */
Result CAMU_SwitchContext (uint select, CAMUContext context);

/**
 * @brief Sets the exposure value of the specified camera.
 * @param select Camera to use.
 * @param exposure Exposure value to use.
 */
Result CAMU_SetExposure (uint select, byte exposure);

/**
 * @brief Sets the white balance mode of the specified camera.
 * @param select Camera to use.
 * @param whiteBalance White balance mode to use.
 */
Result CAMU_SetWhiteBalance (uint select, CAMUWhiteBalance whiteBalance);

/**
 * @brief Sets the white balance mode of the specified camera.
 * TODO: Explain "without base up"?
 * @param select Camera to use.
 * @param whiteBalance White balance mode to use.
 */
Result CAMU_SetWhiteBalanceWithoutBaseUp (uint select, CAMUWhiteBalance whiteBalance);

/**
 * @brief Sets the sharpness of the specified camera.
 * @param select Camera to use.
 * @param sharpness Sharpness to use.
 */
Result CAMU_SetSharpness (uint select, byte sharpness);

/**
 * @brief Sets whether auto exposure is enabled on the specified camera.
 * @param select Camera to use.
 * @param autoWhiteBalance Whether auto exposure is enabled.
 */
Result CAMU_SetAutoExposure (uint select, bool autoExposure);

/**
 * @brief Gets whether auto exposure is enabled on the specified camera.
 * @param autoExposure Pointer to output the auto exposure state to.
 * @param select Camera to use.
 */
Result CAMU_IsAutoExposure (bool* autoExposure, uint select);

/**
 * @brief Sets whether auto white balance is enabled on the specified camera.
 * @param select Camera to use.
 * @param autoWhiteBalance Whether auto white balance is enabled.
 */
Result CAMU_SetAutoWhiteBalance (uint select, bool autoWhiteBalance);

/**
 * @brief Gets whether auto white balance is enabled on the specified camera.
 * @param autoWhiteBalance Pointer to output the auto white balance state to.
 * @param select Camera to use.
 */
Result CAMU_IsAutoWhiteBalance (bool* autoWhiteBalance, uint select);

/**
 * @brief Flips the image of the specified camera in the specified context.
 * @param select Camera to use.
 * @param flip Flip mode to use.
 * @param context Context to use.
 */
Result CAMU_FlipImage (uint select, CAMUFlip flip, CAMUContext context);

/**
 * @brief Sets the image resolution of the given camera in the given context, in detail.
 * @param select Camera to use.
 * @param width Width to use.
 * @param height Height to use.
 * @param cropX0 First crop point X.
 * @param cropY0 First crop point Y.
 * @param cropX1 Second crop point X.
 * @param cropY1 Second crop point Y.
 * @param context Context to use.
 */
Result CAMU_SetDetailSize (uint select, short width, short height, short cropX0, short cropY0, short cropX1, short cropY1, CAMUContext context);

/**
 * @brief Sets the image resolution of the given camera in the given context.
 * @param select Camera to use.
 * @param size Size to use.
 * @param context Context to use.
 */
Result CAMU_SetSize (uint select, CAMUSize size, CAMUContext context);

/**
 * @brief Sets the frame rate of the given camera.
 * @param select Camera to use.
 * @param frameRate Frame rate to use.
 */
Result CAMU_SetFrameRate (uint select, CAMUFrameRate frameRate);

/**
 * @brief Sets the photo mode of the given camera.
 * @param select Camera to use.
 * @param photoMode Photo mode to use.
 */
Result CAMU_SetPhotoMode (uint select, CAMUPhotoMode photoMode);

/**
 * @brief Sets the special effects of the given camera in the given context.
 * @param select Camera to use.
 * @param effect Effect to use.
 * @param context Context to use.
 */
Result CAMU_SetEffect (uint select, CAMUEffect effect, CAMUContext context);

/**
 * @brief Sets the contrast mode of the given camera.
 * @param select Camera to use.
 * @param contrast Contrast mode to use.
 */
Result CAMU_SetContrast (uint select, CAMUContrast contrast);

/**
 * @brief Sets the lens correction mode of the given camera.
 * @param select Camera to use.
 * @param lensCorrection Lens correction mode to use.
 */
Result CAMU_SetLensCorrection (uint select, CAMULensCorrection lensCorrection);

/**
 * @brief Sets the output format of the given camera in the given context.
 * @param select Camera to use.
 * @param format Format to output.
 * @param context Context to use.
 */
Result CAMU_SetOutputFormat (uint select, CAMUOutputFormat format, CAMUContext context);

/**
 * @brief Sets the region to base auto exposure off of for the specified camera.
 * @param select Camera to use.
 * @param x X of the region.
 * @param y Y of the region.
 * @param width Width of the region.
 * @param height Height of the region.
 */
Result CAMU_SetAutoExposureWindow (uint select, short x, short y, short width, short height);

/**
 * @brief Sets the region to base auto white balance off of for the specified camera.
 * @param select Camera to use.
 * @param x X of the region.
 * @param y Y of the region.
 * @param width Width of the region.
 * @param height Height of the region.
 */
Result CAMU_SetAutoWhiteBalanceWindow (uint select, short x, short y, short width, short height);

/**
 * @brief Sets whether the specified camera's noise filter is enabled.
 * @param select Camera to use.
 * @param noiseFilter Whether the noise filter is enabled.
 */
Result CAMU_SetNoiseFilter (uint select, bool noiseFilter);

/**
 * @brief Synchronizes the specified cameras' vsync timing.
 * @param select1 First camera.
 * @param select2 Second camera.
 */
Result CAMU_SynchronizeVsyncTiming (uint select1, uint select2);

/**
 * @brief Gets the vsync timing record of the specified camera for the specified number of signals.
 * @param timing Pointer to write timing data to. (size "past * sizeof(s64)")
 * @param port Port to use.
 * @param past Number of past timings to retrieve.
 */
Result CAMU_GetLatestVsyncTiming (long* timing, uint port, uint past);

/**
 * @brief Gets the specified camera's stereo camera calibration data.
 * @param data Pointer to output the stereo camera data to.
 */
Result CAMU_GetStereoCameraCalibrationData (CAMU_StereoCameraCalibrationData* data);

/**
 * @brief Sets the specified camera's stereo camera calibration data.
 * @param data Data to set.
 */
Result CAMU_SetStereoCameraCalibrationData (CAMU_StereoCameraCalibrationData data);

/**
 * @brief Writes to the specified I2C register of the specified camera.
 * @param select Camera to write to.
 * @param addr Address to write to.
 * @param data Data to write.
 */
Result CAMU_WriteRegisterI2c (uint select, ushort addr, ushort data);

/**
 * @brief Writes to the specified MCU variable of the specified camera.
 * @param select Camera to write to.
 * @param addr Address to write to.
 * @param data Data to write.
 */
Result CAMU_WriteMcuVariableI2c (uint select, ushort addr, ushort data);

/**
 * @brief Reads the specified I2C register of the specified camera.
 * @param data Pointer to read data to.
 * @param select Camera to read from.
 * @param addr Address to read.
 */
Result CAMU_ReadRegisterI2cExclusive (ushort* data, uint select, ushort addr);

/**
 * @brief Reads the specified MCU variable of the specified camera.
 * @param data Pointer to read data to.
 * @param select Camera to read from.
 * @param addr Address to read.
 */
Result CAMU_ReadMcuVariableI2cExclusive (ushort* data, uint select, ushort addr);

/**
 * @brief Sets the specified camera's image quality calibration data.
 * @param data Data to set.
 */
Result CAMU_SetImageQualityCalibrationData (CAMU_ImageQualityCalibrationData data);

/**
 * @brief Gets the specified camera's image quality calibration data.
 * @param data Pointer to write the quality data to.
 */
Result CAMU_GetImageQualityCalibrationData (CAMU_ImageQualityCalibrationData* data);

/**
 * @brief Configures a camera with pre-packaged configuration data without a context.
 * @param Parameter to use.
 */
Result CAMU_SetPackageParameterWithoutContext (CAMU_PackageParameterCameraSelect param);

/**
 * @brief Configures a camera with pre-packaged configuration data with a context.
 * @param Parameter to use.
 */
Result CAMU_SetPackageParameterWithContext (CAMU_PackageParameterContext param);

/**
 * @brief Configures a camera with pre-packaged configuration data without a context and extra resolution details.
 * @param Parameter to use.
 */
Result CAMU_SetPackageParameterWithContextDetail (CAMU_PackageParameterContextDetail param);

/**
 * @brief Gets the Y2R coefficient applied to image data by the camera.
 * @param coefficient Pointer to output the Y2R coefficient to.
 */
Result CAMU_GetSuitableY2rStandardCoefficient (Y2RUStandardCoefficient* coefficient);

/**
 * @brief Plays the specified shutter sound.
 * @param sound Shutter sound to play.
 */
Result CAMU_PlayShutterSound (CAMUShutterSoundType sound);

/// Initializes the camera driver.
Result CAMU_DriverInitialize ();

/// Finalizes the camera driver.
Result CAMU_DriverFinalize ();

/**
 * @brief Gets the current activated camera.
 * @param select Pointer to output the current activated camera to.
 */
Result CAMU_GetActivatedCamera (uint* select);

/**
 * @brief Gets the current sleep camera.
 * @param select Pointer to output the current sleep camera to.
 */
Result CAMU_GetSleepCamera (uint* select);

/**
 * @brief Sets the current sleep camera.
 * @param select Camera to set.
 */
Result CAMU_SetSleepCamera (uint select);

/**
 * @brief Sets whether to enable synchronization of left and right camera brightnesses.
 * @param brightnessSynchronization Whether to enable brightness synchronization.
 */
Result CAMU_SetBrightnessSynchronization (bool brightnessSynchronization);
