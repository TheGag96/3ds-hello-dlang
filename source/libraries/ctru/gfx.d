/**
 * @file gfx.h
 * @brief LCD Screens manipulation
 *
 * This header provides functions to configure and manipulate the two screens, including double buffering and 3D activation.
 * It is mainly an abstraction over the gsp service.
 */

module ctru.gfx;

import ctru.types;
import ctru.services.gspgpu;

extern (C): nothrow: @nogc:

/// Converts red, green, and blue components to packed RGB565.
extern (D) auto RGB565(T0, T1, T2)(auto ref T0 r, auto ref T1 g, auto ref T2 b)
{
    return (b & 0x1f) | ((g & 0x3f) << 5) | ((r & 0x1f) << 11);
}

/// Converts packed RGB8 to packed RGB565.
extern (D) auto RGB8_to_565(T0, T1, T2)(auto ref T0 r, auto ref T1 g, auto ref T2 b)
{
    return ((b >> 3) & 0x1f) | (((g >> 2) & 0x3f) << 5) | (((r >> 3) & 0x1f) << 11);
}

/// Available screens.
enum GFXScreen : ubyte
{
    top    = 0, ///< Top screen
    bottom = 1  ///< Bottom screen
}

/**
 * @brief Side of top screen framebuffer.
 *
 * This is to be used only when the 3D is enabled.
 * Use only GFX_LEFT if this concerns the bottom screen or if 3D is disabled.
 */
enum GFX3DSide : ubyte
{
    left  = 0, ///< Left eye framebuffer
    right = 1  ///< Right eye framebuffer
}

///@name Initialization and deinitialization
///@{

/**
 * @brief Initializes the LCD framebuffers with default parameters
 *
 * By default libctru will configure the LCD framebuffers with the @ref GSP_BGR8_OES format in linear memory.
 * This is the same as calling : @code gfxInit(GSP_BGR8_OES,GSP_BGR8_OES,false); @endcode
 *
 * @note You should always call @ref gfxExit once done to free the memory and services
 */
void gfxInitDefault();

/**
 * @brief Initializes the LCD framebuffers.
 * @param topFormat The format of the top screen framebuffers.
 * @param bottomFormat The format of the bottom screen framebuffers.
 * @param vramBuffers Whether to allocate the framebuffers in VRAM.
 *
 * This function allocates memory for the framebuffers in the specified memory region.
 * Initially, stereoscopic 3D is disabled and double buffering is enabled.
 *
 * @note This function internally calls \ref gspInit.
 */
void gfxInit(GSPGPUFramebufferFormat topFormat, GSPGPUFramebufferFormat bottomFormat, bool vrambuffers);

/**
 * @brief Closes the gsp service and frees the framebuffers.
 *
 * Just call it when you're done.
 */
void gfxExit();
///@}

///@name Control
///@{
/**
 * @brief Enables or disables the 3D stereoscopic effect on the top screen.
 * @param enable Pass true to enable, false to disable.
 * @note Stereoscopic 3D is disabled by default.
 */
void gfxSet3D(bool enable);

/**
 * @brief Retrieves the status of the 3D stereoscopic effect.
 * @return true if 3D enabled, false otherwise.
 */
bool gfxIs3D();

/**
 * @brief Retrieves the status of the 800px (double-height) high resolution display mode of the top screen.
 * @return true if wide mode enabled, false otherwise.
 */
bool gfxIsWide();

/**
 * @brief Enables or disables the 800px (double-height) high resolution display mode of the top screen.
 * @param enable Pass true to enable, false to disable.
 * @note Wide mode is disabled by default.
 * @note Wide and stereoscopic 3D modes are mutually exclusive.
 * @note In wide mode pixels are not square, since scanlines are half as tall as they normally are.
 * @warning Wide mode does not work on Old 2DS consoles (however it does work on New 2DS XL consoles).
 */
void gfxSetWide(bool enable);

/**
 * @brief Changes the pixel format of a screen.
 * @param screen Screen ID (see \ref gfxScreen_t)
 * @param format Pixel format (see \ref GSPGPU_FramebufferFormat)
 * @note If the currently allocated framebuffers are too small for the specified format,
 *       they are freed and new ones are reallocated.
 */
void gfxSetScreenFormat(GFXScreen screen, GSPGPUFramebufferFormat format);

/**
 * @brief Retrieves the current pixel format of a screen.
 * @param screen Screen ID (see \ref gfxScreen_t)
 * @return Pixel format (see \ref GSPGPU_FramebufferFormat)
 */
GSPGPUFramebufferFormat gfxGetScreenFormat(GFXScreen screen);

/**
 * @brief Enables or disables double buffering on a screen.
 * @param screen Screen ID (see \ref gfxScreen_t)
 * @param enable Pass true to enable, false to disable.
 * @note Double buffering is enabled by default.
 */
void gfxSetDoubleBuffering(GFXScreen screen, bool doubleBuffering);

///@}

///@name Rendering and presentation
///@{

/**
 * @brief Retrieves the framebuffer of the specified screen to which graphics should be rendered.
 * @param screen Screen ID (see \ref gfxScreen_t)
 * @param side Framebuffer side (see \ref gfx3dSide_t) (pass \ref GFX_LEFT if not using stereoscopic 3D)
 * @param width Pointer that will hold the width of the framebuffer in pixels.
 * @param height Pointer that will hold the height of the framebuffer in pixels.
 * @return A pointer to the current framebuffer of the chosen screen.
 *
 * Please remember that the returned pointer will change every frame if double buffering is enabled.
 */
ubyte* gfxGetFramebuffer(GFXScreen screen, GFX3DSide side, ushort* width, ushort* height);

/**
 * @brief Flushes the current framebuffers
 *
 * Use this if the data within your framebuffers changes a lot and that you want to make sure everything was updated correctly.
 * This shouldn't be needed and has a significant overhead.
 */
void gfxFlushBuffers();

/**
 * @brief Updates the configuration of the specified screen, swapping the buffers if double buffering is enabled.
 * @param scr Screen ID (see \ref gfxScreen_t)
 * @param hasStereo For the top screen in 3D mode: true if the framebuffer contains individual images
 *                  for both eyes, or false if the left image should be duplicated to the right eye.
 * @note Previously rendered content will be displayed on the screen after the next VBlank.
 * @note This function is still useful even if double buffering is disabled, as it must be used to commit configuration changes.
 * @warning Only call this once per screen per frame, otherwise graphical glitches will occur
 *          since this API does not implement triple buffering.
 */
void gfxScreenSwapBuffers(GFXScreen scr, bool hasStereo);

/**
 * @brief Updates the configuration of the specified screen(swapping the buffers if double-buffering is enabled).
 * @param scr Screen to configure.
 * @param immediate Whether to apply the updated configuration immediately or let GSPGPU apply it after the next GX transfer completes.
 */
deprecated void gfxConfigScreen(GFXScreen scr, bool immediate);

/**
 * @brief Swaps the buffers and sets the gsp state
 *
 * @brief Updates the configuration of both screens.
 * @note This function is equivalent to: \code gfxScreenSwapBuffers(GFX_TOP,true); gfxScreenSwapBuffers(GFX_BOTTOM,true); \endcode
 */
void gfxSwapBuffers();

/**
 * @brief Swaps the framebuffers
 *
 * This is the version to be used with the GPU since the GPU will use the gsp shared memory,
 * so the gsp state mustn't be set directly by the user.
 */
void gfxSwapBuffersGpu();

///@}

///@name Helper
///@{
/**
 * @brief Retrieves a framebuffer information.
 * @param screen Screen to retrieve framebuffer information for.
 * @param side Side of the screen to retrieve framebuffer information for.
 * @param width Pointer that will hold the width of the framebuffer in pixels.
 * @param height Pointer that will hold the height of the framebuffer in pixels.
 * @return A pointer to the current framebuffer of the choosen screen.
 *
 * Please remember that the returned pointer will change after each call to gfxSwapBuffers if double buffering is enabled.
 */
ubyte* gfxGetFramebuffer(GFXScreen screen, GFX3DSide side, ushort* width, ushort* height);
///@}

//global variables
extern __gshared ubyte*[2] gfxTopLeftFramebuffers;
extern __gshared ubyte*[2] gfxTopRightFramebuffers;
extern __gshared ubyte*[2] gfxBottomFramebuffers;
