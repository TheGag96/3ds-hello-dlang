/**
 * @file font.h
 * @brief Shared font support.
 */

module ctru.font;

import ctru.types;

extern (C):

///@name Data types
///@{

/// Character width information structure.
struct charWidthInfo_s
{
    byte left; ///< Horizontal offset to draw the glyph with.
    ubyte glyphWidth; ///< Width of the glyph.
    ubyte charWidth; ///< Width of the character, that is, horizontal distance to advance.
}

/// Font texture sheet information.
struct TGLP_s
{
    ubyte cellWidth; ///< Width of a glyph cell.
    ubyte cellHeight; ///< Height of a glyph cell.
    ubyte baselinePos; ///< Vertical position of the baseline.
    ubyte maxCharWidth; ///< Maximum character width.

    uint sheetSize; ///< Size in bytes of a texture sheet.
    ushort nSheets; ///< Number of texture sheets.
    ushort sheetFmt; ///< GPU texture format (GPU_TEXCOLOR).

    ushort nRows; ///< Number of glyphs per row per sheet.
    ushort nLines; ///< Number of glyph rows per sheet.

    ushort sheetWidth; ///< Texture sheet width.
    ushort sheetHeight; ///< Texture sheet height.
    ubyte* sheetData; ///< Pointer to texture sheet data.
}

/// Font character width information block type.
alias CWDH_s = tag_CWDH_s;

/// Font character width information block structure.
struct tag_CWDH_s
{
    ushort startIndex; ///< First Unicode codepoint the block applies to.
    ushort endIndex; ///< Last Unicode codepoint the block applies to.
    CWDH_s* next; ///< Pointer to the next block.

    charWidthInfo_s[0] widths; ///< Table of character width information structures.
}

/// Font character map methods.
enum
{
    CMAP_TYPE_DIRECT = 0, ///< Identity mapping.
    CMAP_TYPE_TABLE  = 1, ///< Mapping using a table.
    CMAP_TYPE_SCAN   = 2  ///< Mapping using a list of mapped characters.
}

/// Font character map type.
alias CMAP_s = tag_CMAP_s;

/// Font character map structure.
struct tag_CMAP_s
{
    ushort codeBegin; ///< First Unicode codepoint the block applies to.
    ushort codeEnd; ///< Last Unicode codepoint the block applies to.
    ushort mappingMethod; ///< Mapping method.
    ushort reserved;
    CMAP_s* next; ///< Pointer to the next map.

    union
    {
        ushort indexOffset; ///< For CMAP_TYPE_DIRECT: index of the first glyph.
        ushort[0] indexTable; ///< For CMAP_TYPE_TABLE: table of glyph indices.
        /// For CMAP_TYPE_SCAN: Mapping data.
        struct
        {
            ushort nScanEntries; ///< Number of pairs.
            /// Mapping pairs.

            ///< Unicode codepoint.
            ///< Mapped glyph index.
            struct _Anonymous_0
            {
                ushort code;
                ushort glyphIndex;
            }

            _Anonymous_0[0] scanEntries;
        }
    }
}

/// Font information structure.
struct FINF_s
{
    uint signature; ///< Signature (FINF).
    uint sectionSize; ///< Section size.

    ubyte fontType; ///< Font type
    ubyte lineFeed; ///< Line feed vertical distance.
    ushort alterCharIndex; ///< Glyph index of the replacement character.
    charWidthInfo_s defaultWidth; ///< Default character width information.
    ubyte encoding; ///< Font encoding (?)

    TGLP_s* tglp; ///< Pointer to texture sheet information.
    CWDH_s* cwdh; ///< Pointer to the first character width information block.
    CMAP_s* cmap; ///< Pointer to the first character map.

    ubyte height; ///< Font height.
    ubyte width; ///< Font width.
    ubyte ascent; ///< Font ascent.
    ubyte padding;
}

/// Font structure.
struct CFNT_s
{
    uint signature; ///< Signature (CFNU).
    ushort endianness; ///< Endianness constant (0xFEFF).
    ushort headerSize; ///< Header size.
    uint version_; ///< Format version.
    uint fileSize; ///< File size.
    uint nBlocks; ///< Number of blocks.

    FINF_s finf; ///< Font information.
}

/// Font glyph position structure.
struct fontGlyphPos_s
{
    int sheetIndex; ///< Texture sheet index to use to render the glyph.
    float xOffset; ///< Horizontal offset to draw the glyph width.
    float xAdvance; ///< Horizontal distance to advance after drawing the glyph.
    float width; ///< Glyph width.
    /// Texture coordinates to use to render the glyph.
    struct _Anonymous_1
    {
        float left;
        float top;
        float right;
        float bottom;
    }

    _Anonymous_1 texcoord;
    /// Vertex coordinates to use to render the glyph.
    struct _Anonymous_2
    {
        float left;
        float top;
        float right;
        float bottom;
    }

    _Anonymous_2 vtxcoord;
}

/// Flags for use with fontCalcGlyphPos.
enum
{
    GLYPH_POS_CALC_VTXCOORD = BIT(0), ///< Calculates vertex coordinates in addition to texture coordinates.
    GLYPH_POS_AT_BASELINE   = BIT(1), ///< Position the glyph at the baseline instead of at the top-left corner.
    GLYPH_POS_Y_POINTS_UP   = BIT(2)  ///< Indicates that the Y axis points up instead of down.
}

///@}

///@name Initialization and basic operations
///@{

/// Ensures the shared system font is mapped.
Result fontEnsureMapped();

/**
 * @brief Fixes the pointers internal to a just-loaded font
 * @param font Font to fix
 * @remark Should never be run on the system font, and only once on any other font.
 */
void fontFixPointers(CFNT_s* font);

/// Gets the currently loaded system font
CFNT_s* fontGetSystemFont();

/**
 * @brief Retrieves the font information structure of a font.
 * @param font Pointer to font structure. If NULL, the shared system font is used.
 */
FINF_s* fontGetInfo(CFNT_s* font);

/**
 * @brief Retrieves the texture sheet information of a font.
 * @param font Pointer to font structure. If NULL, the shared system font is used.
 */
TGLP_s* fontGetGlyphInfo(CFNT_s* font);

/**
 * @brief Retrieves the pointer to texture data for the specified texture sheet.
 * @param font Pointer to font structure. If NULL, the shared system font is used.
 * @param sheetIndex Index of the texture sheet.
 */
void* fontGetGlyphSheetTex(CFNT_s* font, int sheetIndex);

/**
 * @brief Retrieves the glyph index of the specified Unicode codepoint.
 * @param font Pointer to font structure. If NULL, the shared system font is used.
 * @param codePoint Unicode codepoint.
 */
int fontGlyphIndexFromCodePoint(CFNT_s* font, uint codePoint);

/**
 * @brief Retrieves character width information of the specified glyph.
 * @param font Pointer to font structure. If NULL, the shared system font is used.
 * @param glyphIndex Index of the glyph.
 */
charWidthInfo_s* fontGetCharWidthInfo(CFNT_s* font, int glyphIndex);

/**
 * @brief Calculates position information for the specified glyph.
 * @param out Output structure in which to write the information.
 * @param font Pointer to font structure. If NULL, the shared system font is used.
 * @param glyphIndex Index of the glyph.
 * @param flags Calculation flags(see GLYPH_POS_* flags).
 * @param scaleX Scale factor to apply horizontally.
 * @param scaleY Scale factor to apply vertically.
 */
void fontCalcGlyphPos(fontGlyphPos_s* out_, CFNT_s* font, int glyphIndex, uint flags, float scaleX, float scaleY);

///@}
