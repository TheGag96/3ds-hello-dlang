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

///@name System related
///@{

/**
 * @brief Initializes the LCD framebuffers with default parameters
 *
 * By default ctrulib will configure the LCD framebuffers with the @ref GSP_BGR8_OES format in linear memory.
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
 * This function will allocate the memory for the framebuffers and open a gsp service session.
 * It will also bind the newly allocated framebuffers to the LCD screen and setup the VBlank event.
 *
 * The 3D stereoscopic display is will be disabled.
 *
 * @note Even if the double buffering is disabled, it will allocate two buffer per screen.
 * @note You should always call @ref gfxExit once done to free the memory and services
 */
void gfxInit(GSPGPUFramebufferFormats topFormat, GSPGPUFramebufferFormats bottomFormat, bool vrambuffers);

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
 * @brief Enables the 3D stereoscopic effect.
 * @param enable Enables the 3D effect if true, disables it if false.
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
 * @brief Changes the color format of a screen
 * @param screen The screen of which format should be changed
 * @param format One of the gsp pixel formats.
 */
void gfxSetScreenFormat(GFXScreen screen, GSPGPUFramebufferFormats format);

/**
 * @brief Gets a screen pixel format.
 * @param screen Screen to get the pixel format of.
 * @return the pixel format of the chosen screen set by ctrulib.
 */
GSPGPUFramebufferFormats gfxGetScreenFormat(GFXScreen screen);

/**
 * @brief Sets whether to use ctrulib's double buffering
 * @param screen Screen to toggle double buffering for.
 * @param doubleBuffering Whether to use double buffering.
 *
 * ctrulib is by default using a double buffering scheme.
 * If you do not want to swap one of the screen framebuffers when @ref gfxSwapBuffers or @ref gfxSwapBuffers is called,
 * then you have to disable double buffering.
 *
 * It is however recommended to call @ref gfxSwapBuffers even if double buffering is disabled
 * for both screens if you want to keep the gsp configuration up to date.
 */
void gfxSetDoubleBuffering(GFXScreen screen, bool doubleBuffering);

/**
 * @brief Flushes the current framebuffers
 *
 * Use this if the data within your framebuffers changes a lot and that you want to make sure everything was updated correctly.
 * This shouldn't be needed and has a significant overhead.
 */
void gfxFlushBuffers();

/**
 * @brief Updates the configuration of the specified screen(swapping the buffers if double-buffering is enabled).
 * @param scr Screen to configure.
 * @param immediate Whether to apply the updated configuration immediately or let GSPGPU apply it after the next GX transfer completes.
 */
void gfxConfigScreen(GFXScreen scr, bool immediate);

/**
 * @brief Swaps the buffers and sets the gsp state
 *
 * This is to be called to update the gsp state and swap the framebuffers.
 * LCD rendering should start as soon as the gsp state is set.
 * When using the GPU, call @ref gfxSwapBuffers instead.
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
