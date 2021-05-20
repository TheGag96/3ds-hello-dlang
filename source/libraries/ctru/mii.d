/**
 * @file mii.h
 * @brief Shared Mii struct.
 *
 * @see https://www.3dbrew.org/wiki/Mii#Mii_format
 */

module ctru.mii;

import ctru.types;

extern (C): nothrow: @nogc:

/// Shared Mii struct
struct MiiData
{
    align (1):

    ubyte magic; ///< Always 3?

    /// Mii options

    ///< True if copying is allowed
    ///< Private name?
    ///< Region lock (0=no lock, 1=JPN, 2=USA, 3=EUR)
    ///< Character set (0=JPN+USA+EUR, 1=CHN, 2=KOR, 3=TWN)
    struct _Anonymous_0
    {
        import std.bitmanip : bitfields;

        mixin(bitfields!(
            bool, "allow_copying", 1,
            bool, "is_private_name", 1,
            ubyte, "region_lock", 2,
            ubyte, "char_set", 2,
            uint, "", 2));
    }

    _Anonymous_0 mii_options;

    /// Mii position in Mii selector or Mii maker

    ///< Page index of Mii
    ///< Slot offset of Mii on its Page
    struct _Anonymous_1
    {
        import std.bitmanip : bitfields;

        mixin(bitfields!(
            ubyte, "page_index", 4,
            ubyte, "slot_index", 4));
    }

    _Anonymous_1 mii_pos;

    /// Console Identity

    ///< Mabye padding (always seems to be 0)?
    ///< Console that the Mii was created on (1=WII, 2=DSI, 3=3DS)
    struct _Anonymous_2
    {
        import std.bitmanip : bitfields;

        mixin(bitfields!(
            ubyte, "unknown0", 4,
            ubyte, "origin_console", 3,
            uint, "", 1));
    }

    _Anonymous_2 console_identity;

    ulong system_id; ///< Identifies the system that the Mii was created on (Determines pants)
    uint mii_id; ///< ID of Mii
    ubyte[6] mac; ///< Creator's system's full MAC address
    ubyte[2] pad; ///< Padding

    /// Mii details

    ///< Sex of Mii (False=Male, True=Female)
    ///< Month of Mii's birthday
    ///< Day of Mii's birthday
    ///< Color of Mii's shirt
    ///< Whether the Mii is one of your 10 favorite Mii's
    struct _Anonymous_3
    {
        import std.bitmanip : bitfields;

        mixin(bitfields!(
            bool, "sex", 1,
            ushort, "bday_month", 4,
            ushort, "bday_day", 5,
            ushort, "shirt_color", 4,
            bool, "favorite", 1,
            uint, "", 1));
    }

    _Anonymous_3 mii_details;

    ushort[10] mii_name; ///< Name of Mii (Encoded using UTF16)
    ubyte height; ///< How tall the Mii is
    ubyte width; ///< How wide the Mii is

    /// Face style

    ///< Whether or not Sharing of the Mii is allowed
    ///< Face shape
    ///< Color of skin
    struct _Anonymous_4
    {
        import std.bitmanip : bitfields;

        mixin(bitfields!(
            bool, "disable_sharing", 1,
            ubyte, "shape", 4,
            ubyte, "skinColor", 3));
    }

    _Anonymous_4 face_style;

    /// Face details
    struct _Anonymous_5
    {
        import std.bitmanip : bitfields;

        mixin(bitfields!(
            ubyte, "wrinkles", 4,
            ubyte, "makeup", 4));
    }

    _Anonymous_5 face_details;

    ubyte hair_style;

    /// Hair details
    struct _Anonymous_6
    {
        import std.bitmanip : bitfields;

        mixin(bitfields!(
            ubyte, "color", 3,
            bool, "flip", 1,
            uint, "", 4));
    }

    _Anonymous_6 hair_details;

    /// Eye details
    struct _Anonymous_7
    {
        import std.bitmanip : bitfields;

        mixin(bitfields!(
            uint, "style", 6,
            uint, "color", 3,
            uint, "scale", 4,
            uint, "yscale", 3,
            uint, "rotation", 5,
            uint, "xspacing", 4,
            uint, "yposition", 5,
            uint, "", 2));
    }

    _Anonymous_7 eye_details;

    /// Eyebrow details
    struct _Anonymous_8
    {
        import std.bitmanip : bitfields;

        mixin(bitfields!(
            uint, "style", 5,
            uint, "color", 3,
            uint, "scale", 4,
            uint, "yscale", 3,
            uint, "pad", 1,
            uint, "rotation", 5,
            uint, "xspacing", 4,
            uint, "yposition", 5,
            uint, "", 2));
    }

    _Anonymous_8 eyebrow_details;

    /// Nose details
    struct _Anonymous_9
    {
        import std.bitmanip : bitfields;

        mixin(bitfields!(
            ushort, "style", 5,
            ushort, "scale", 4,
            ushort, "yposition", 5,
            uint, "", 2));
    }

    _Anonymous_9 nose_details;

    /// Mouth details
    struct _Anonymous_10
    {
        import std.bitmanip : bitfields;

        mixin(bitfields!(
            ushort, "style", 6,
            ushort, "color", 3,
            ushort, "scale", 4,
            ushort, "yscale", 3));
    }

    _Anonymous_10 mouth_details;

    /// Mustache details
    struct _Anonymous_11
    {
        import std.bitmanip : bitfields;

        mixin(bitfields!(
            ushort, "mouth_yposition", 5,
            ushort, "mustach_style", 3,
            ushort, "pad", 2,
            uint, "", 6));
    }

    _Anonymous_11 mustache_details;

    /// Beard details
    struct _Anonymous_12
    {
        import std.bitmanip : bitfields;

        mixin(bitfields!(
            ushort, "style", 3,
            ushort, "color", 3,
            ushort, "scale", 4,
            ushort, "ypos", 5,
            uint, "", 1));
    }

    _Anonymous_12 beard_details;

    /// Glasses details
    struct _Anonymous_13
    {
        import std.bitmanip : bitfields;

        mixin(bitfields!(
            ushort, "style", 4,
            ushort, "color", 3,
            ushort, "scale", 4,
            ushort, "ypos", 5));
    }

    _Anonymous_13 glasses_details;

    /// Mole details
    struct _Anonymous_14
    {
        import std.bitmanip : bitfields;

        mixin(bitfields!(
            bool, "enable", 1,
            ushort, "scale", 5,
            ushort, "xpos", 5,
            ushort, "ypos", 5));
    }

    _Anonymous_14 mole_details;

    ushort[10] author_name; ///< Name of Mii's author (Encoded using UTF16)
}
