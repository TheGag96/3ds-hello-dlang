/**
 * @file console.h
 * @brief 3ds stdio support.
 *
 * Provides stdio integration for printing to the 3DS screen as well as debug print
 * functionality provided by stderr.
 *
 * General usage is to initialize the console by:
 * @code
 * consoleDemoInit()
 * @endcode
 * or to customize the console usage by:
 * @code
 * consoleInit()
 * @endcode
 */

module ctru.console;

import ctru.types;
import ctru.gfx;

extern (C): nothrow: @nogc:

extern (D) enum string CONSOLE_ESC(size_t x) = () {
    //import std.conv : to;

    return "\x1b[" ~ cast(char)(x / 10) ~ cast(char)(x % 10);
}();

enum CONSOLE_RESET = CONSOLE_ESC!(0);
enum CONSOLE_BLACK = CONSOLE_ESC!(30);

/// A callback for printing a character.
alias ConsolePrint = bool function (void* con, int c);

/// A font struct for the console.
struct ConsoleFont
{
    ubyte* gfx; ///< A pointer to the font graphics
    ushort asciiOffset; ///< Offset to the first valid character in the font table
    ushort numChars; ///< Number of characters in the font graphics
}

/**
 * @brief Console structure used to store the state of a console render context.
 *
 * Default values from consoleGetDefault();
 * @code
 * PrintConsole defaultConsole =
 * {
 * 	//Font:
 * 	{
 * 		(u8*)default_font_bin, //font gfx
 * 		0, //first ascii character in the set
 * 		128, //number of characters in the font set
 *	},
 *	0,0, //cursorX cursorY
 *	0,0, //prevcursorX prevcursorY
 *	40, //console width
 *	30, //console height
 *	0,  //window x
 *	0,  //window y
 *	32, //window width
 *	24, //window height
 *	3, //tab size
 *	0, //font character offset
 *	0,  //print callback
 *	false //console initialized
 * };
 * @endcode
 */
struct PrintConsole
{
    ConsoleFont font; ///< Font of the console

    ushort* frameBuffer; ///< Framebuffer address

    int cursorX; ///< Current X location of the cursor (as a tile offset by default)
    int cursorY; ///< Current Y location of the cursor (as a tile offset by default)

    int prevCursorX; ///< Internal state
    int prevCursorY; ///< Internal state

    int consoleWidth; ///< Width of the console hardware layer in characters
    int consoleHeight; ///< Height of the console hardware layer in characters

    int windowX; ///< Window X location in characters (not implemented)
    int windowY; ///< Window Y location in characters (not implemented)
    int windowWidth; ///< Window width in characters (not implemented)
    int windowHeight; ///< Window height in characters (not implemented)

    int tabSize; ///< Size of a tab
    int fg; ///< Foreground color
    int bg; ///< Background color
    int flags; ///< Reverse/bright flags

    ConsolePrint PrintChar; ///< Callback for printing a character. Should return true if it has handled rendering the graphics (else the print engine will attempt to render via tiles).

    bool consoleInitialised; ///< True if the console is initialized
}

enum CONSOLE_COLOR_BOLD    = BIT(0); ///< Bold text
enum CONSOLE_COLOR_FAINT   = BIT(1); ///< Faint text
enum CONSOLE_ITALIC        = BIT(2); ///< Italic text
enum CONSOLE_UNDERLINE     = BIT(3); ///< Underlined text
enum CONSOLE_BLINK_SLOW    = BIT(4); ///< Slow blinking text
enum CONSOLE_BLINK_FAST    = BIT(5); ///< Fast blinking text
enum CONSOLE_COLOR_REVERSE = BIT(6); ///< Reversed color text
enum CONSOLE_CONCEAL       = BIT(7); ///< Concealed text
enum CONSOLE_CROSSED_OUT   = BIT(8); ///< Crossed out text

/// Console debug devices supported by libnds.
enum debugDevice : ubyte
{
    _null   = 0,  ///< Swallows prints to stderr
    svc     = 1,  ///< Outputs stderr debug statements using svcOutputDebugString, which can then be captured by interactive debuggers
    console = 2,  ///< Directs stderr debug statements to 3DS console window
    _3dmoo  = svc
}

/**
 * @brief Loads the font into the console.
 * @param console Pointer to the console to update, if NULL it will update the current console.
 * @param font The font to load.
 */
void consoleSetFont(PrintConsole* console, ConsoleFont* font);

/**
 * @brief Sets the print window.
 * @param console Console to set, if NULL it will set the current console window.
 * @param x X location of the window.
 * @param y Y location of the window.
 * @param width Width of the window.
 * @param height Height of the window.
 */
void consoleSetWindow(PrintConsole* console, int x, int y, int width, int height);

/**
 * @brief Gets a pointer to the console with the default values.
 * This should only be used when using a single console or without changing the console that is returned, otherwise use consoleInit().
 * @return A pointer to the console with the default values.
 */
PrintConsole* consoleGetDefault();

/**
 * @brief Make the specified console the render target.
 * @param console A pointer to the console struct(must have been initialized with consoleInit(PrintConsole* console)).
 * @return A pointer to the previous console.
 */
PrintConsole* consoleSelect(PrintConsole* console);

/**
 * @brief Initialise the console.
 * @param screen The screen to use for the console.
 * @param console A pointer to the console data to initialize(if it's NULL, the default console will be used).
 * @return A pointer to the current console.
 */
PrintConsole* consoleInit(GFXScreen screen, PrintConsole* console);

/**
 * @brief Initializes debug console output on stderr to the specified device.
 * @param device The debug device(or devices) to output debug print statements to.
 */
void consoleDebugInit(debugDevice device);

/// Clears the screan by using iprintf("\x1b[2J");
void consoleClear();

