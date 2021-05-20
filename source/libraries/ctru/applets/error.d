/**
 * @file error.h
 * @brief Error applet.
 */

module ctru.applets.error;

import ctru.types;
import ctru.services.cfgu;

extern (C): nothrow: @nogc:

enum
{
    ERROR_LANGUAGE_FLAG = 0x100, ///<??-Unknown flag
    ERROR_WORD_WRAP_FLAG = 0x200 ///<??-Unknown flag
}

///< Type of Error applet to be called

enum ErrorType : ushort
{
    code                    = 0,                                                ///< Displays the infrastructure communications-related error message corresponding to the error code.
    text                    = 1,                                                ///< Displays text passed to this applet.
    eula                    = 2,                                                ///< Displays the EULA
    type_eula_first_boot    = 3,                                                ///< Use prohibited.
    type_eula_draw_only     = 4,                                                ///< Use prohibited.
    type_agree              = 5,                                                ///< Use prohibited.
    code_language           = code | ERROR_LANGUAGE_FLAG,                       ///< Displays a network error message in a specified language.
    text_language           = text | ERROR_LANGUAGE_FLAG,                       ///< Displays text passed to this applet in a specified language.
    eula_language           = eula | ERROR_LANGUAGE_FLAG,                       ///< Displays EULA in a specified language.
    text_word_wrap          = text | ERROR_WORD_WRAP_FLAG,                      ///< Displays the custom error message passed to this applet with automatic line wrapping
    text_language_word_wrap = text | ERROR_LANGUAGE_FLAG | ERROR_WORD_WRAP_FLAG ///< Displays the custom error message with automatic line wrapping and in the specified language.
}

///< Flags for the Upper Screen.Does nothing even if specified.

enum ErrorScreenFlag : ubyte
{
    normal = 0,
    stereo = 1
}

///< Return code of the Error module.Use UNKNOWN for simple apps.

enum ErrorReturnCode : byte
{
    unknown        = -1,
    none           = 0,
    success        = 1,
    not_supported  = 2,
    home_button    = 10,
    software_reset = 11,
    power_button   = 12
}

///< Structure to be passed to the applet.Shouldn't be modified directly.

struct errorConf
{
    ErrorType type;
    int errorCode;
    ErrorScreenFlag upperScreenFlag;
    ushort useLanguage;
    ushort[1900] Text;
    bool homeButton;
    bool softwareReset;
    bool appJump;
    ErrorReturnCode returnCode;
    ushort eulaVersion;
}

/**
* @brief Init the error applet.
* @param err Pointer to errorConf.
* @param type ErrorType Type of error.
* @param lang CFGLanguage Lang of error.
*/
void errorInit(errorConf* err, ErrorType type, CFGLanguage lang);
/**
* @brief Sets error code to display.
* @param err Pointer to errorConf.
* @param error Error-code to display.
*/
void errorCode(errorConf* err, int error);
/**
* @brief Sets error text to display.
* @param err Pointer to errorConf.
* @param text Error-text to display.
*/
void errorText(errorConf* err, const(char)* text);
/**
* @brief Displays the error applet.
* @param err Pointer to errorConf.
*/
void errorDisp(errorConf* err);
