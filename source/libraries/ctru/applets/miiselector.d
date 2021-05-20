/**
 * @file miiselector.h
 * @brief Mii Selector Applet (appletEd).
 */

module ctru.applets.miiselector;

import ctru.types;
import ctru.mii;

extern (C): nothrow: @nogc:

/// Magic value needed to launch the applet.
enum MIISELECTOR_MAGIC = 0x13DE28CF;

/// Maximum length of title to be displayed at the top of the Mii selector applet
enum MIISELECTOR_TITLE_LEN = 64;

/// Number of Guest Miis available for selection
enum MIISELECTOR_GUESTMII_SLOTS = 6;

/// Maximum number of user Miis available for selection
enum MIISELECTOR_USERMII_SLOTS = 100;

/// Parameter structure passed to AppletEd
struct MiiSelectorConf
{
    ubyte enable_cancel_button; ///< Enables canceling of selection if nonzero.
    ubyte enable_selecting_guests; ///< Makes Guets Miis selectable if nonzero.
    ubyte show_on_top_screen; ///< Shows applet on top screen if nonzero,
    ///< otherwise show it on the bottom screen.
    ubyte[5] _unk0x3; ///< @private
    ushort[MIISELECTOR_TITLE_LEN] title; ///< UTF16-LE string displayed at the top of the applet. If
    ///< set to the empty string, a default title is displayed.
    ubyte[4] _unk0x88; ///< @private
    ubyte show_guest_page; ///< If nonzero, the applet shows a page with Guest
    ///< Miis on launch.
    ubyte[3] _unk0x8D; ///< @private
    uint initial_index; ///< Index of the initially selected Mii. If
    ///< @ref MiiSelectorConf.show_guest_page is
    ///< set, this is the index of a Guest Mii,
    ///< otherwise that of a user Mii.
    ubyte[MIISELECTOR_GUESTMII_SLOTS] mii_guest_whitelist; ///< Each byte set to a nonzero value
    ///< enables its corresponding Guest
    ///< Mii to be enabled for selection.
    ubyte[MIISELECTOR_USERMII_SLOTS] mii_whitelist; ///< Each byte set to a nonzero value enables
    ///< its corresponding user Mii to be enabled
    ///< for selection.
    ushort _unk0xFE; ///< @private
    uint magic; ///< Will be set to @ref MIISELECTOR_MAGIC before launching the
    ///< applet.
}

/// Maximum length of the localized name of a Guest Mii
enum MIISELECTOR_GUESTMII_NAME_LEN = 12;

/// Structure written by AppletEd
struct MiiSelectorReturn
{
    uint no_mii_selected; ///< 0 if a Mii was selected, 1 if the selection was
    ///< canceled.
    uint guest_mii_was_selected; ///< 1 if a Guest Mii was selected, 0 otherwise.
    uint guest_mii_index; ///< Index of the selected Guest Mii,
    ///< 0xFFFFFFFF if no guest was selected.
    MiiData mii; ///< Data of selected Mii.
    ushort _pad0x68; ///< @private
    ushort checksum; ///< Checksum of the returned Mii data.
    ///< Stored as a big-endian value; use
    ///< @ref miiSelectorChecksumIsValid to
    ///< verify.
    ushort[MIISELECTOR_GUESTMII_NAME_LEN] guest_mii_name; ///< Localized name of a Guest Mii,
    ///< if one was selected (UTF16-LE
    ///< string). Zeroed otherwise.
}

/// AppletEd options
enum
{
    MIISELECTOR_CANCEL = BIT(0), ///< Show the cancel button
    MIISELECTOR_GUESTS = BIT(1), ///< Make Guets Miis selectable
    MIISELECTOR_TOP = BIT(2), ///< Show AppletEd on top screen
    MIISELECTOR_GUESTSTART = BIT(3) ///< Start on guest page
}

/**
 * @brief Initialize Mii selector config
 * @param conf Pointer to Miiselector config.
 */
void miiSelectorInit (MiiSelectorConf* conf);

/**
 * @brief Launch the Mii selector library applet
 *
 * @param conf Configuration determining how the applet should behave
 * @param returnbuf Data returned by the applet
 */
Result miiSelectorLaunch(const(MiiSelectorConf)* conf, MiiSelectorReturn* returnbuf);

/**
 * @brief Sets title of the Mii selector library applet
 *
 * @param conf Pointer to miiSelector configuration
 * @param text Title text of Mii selector
 */
void miiSelectorSetTitle(MiiSelectorConf* conf, const(char)* text);

/**
 * @brief Specifies which special options are enabled in the Mii selector
 *
 * @param conf Pointer to miiSelector configuration
 * @param options Options bitmask
 */
void miiSelectorSetOptions(MiiSelectorConf* conf, uint options);

/**
 * @brief Specifies which guest Miis will be selectable
 *
 * @param conf Pointer to miiSelector configuration
 * @param index Index of the guest Miis that will be whitelisted.
 * @ref MIISELECTOR_GUESTMII_SLOTS can be used to whitelist all the guest Miis.
 */
void miiSelectorWhitelistGuestMii(MiiSelectorConf* conf, uint index);

/**
 * @brief Specifies which guest Miis will be unselectable
 *
 * @param conf Pointer to miiSelector configuration
 * @param index Index of the guest Miis that will be blacklisted.
 * @ref MIISELECTOR_GUESTMII_SLOTS can be used to blacklist all the guest Miis.
 */
void miiSelectorBlacklistGuestMii(MiiSelectorConf* conf, uint index);

/**
 * @brief Specifies which user Miis will be selectable
 *
 * @param conf Pointer to miiSelector configuration
 * @param index Index of the user Miis that will be whitelisted.
 * @ref MIISELECTOR_USERMII_SLOTS can be used to whitlist all the user Miis
 */
void miiSelectorWhitelistUserMii(MiiSelectorConf* conf, uint index);

/**
 * @brief Specifies which user Miis will be selectable
 *
 * @param conf Pointer to miiSelector configuration
 * @param index Index of the user Miis that will be blacklisted.
 * @ref MIISELECTOR_USERMII_SLOTS can be used to blacklist all the user Miis
 */
void miiSelectorBlacklistUserMii(MiiSelectorConf* conf, uint index);

/**
 * @brief Specifies which Mii the cursor should start from
 *
 * @param conf Pointer to miiSelector configuration
 * @param index Indexed number of the Mii that the cursor will start on.
 * If there is no mii with that index, the the cursor will start at the Mii
 * with the index 0 (the personal Mii).
 */
pragma(inline, true)
void miiSelectorSetInitialIndex(MiiSelectorConf* conf, uint index)
{
    conf.initial_index = index;
}

/**
 * @brief Get Mii name
 *
 * @param returnbuf Pointer to miiSelector return
 * @param out String containing a Mii's name
 * @param max_size Size of string. Since UTF8 characters range in size from 1-3 bytes
 * (assuming that no non-BMP characters are used), this value should be 36 (or 30 if you are not
 * dealing with guest miis).
 */
void miiSelectorReturnGetName(const(MiiSelectorReturn)* returnbuf, char* out_, size_t max_size);

/**
 * @brief Get Mii Author
 *
 * @param returnbuf Pointer to miiSelector return
 * @param out String containing a Mii's author
 * @param max_size Size of string. Since UTF8 characters range in size from 1-3 bytes
 * (assuming that no non-BMP characters are used), this value should be 30.
 */
void miiSelectorReturnGetAuthor(const(MiiSelectorReturn)* returnbuf, char* out_, size_t max_size);

/**
 * @brief Verifies that the Mii data returned from the applet matches its
 * checksum
 *
 * @param returnbuf Buffer filled by Mii selector applet
 * @return `true` if `returnbuf->checksum` is the same as the one computed from `returnbuf`
 */
bool miiSelectorChecksumIsValid(const(MiiSelectorReturn)* returnbuf);
