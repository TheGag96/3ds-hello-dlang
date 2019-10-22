/**
 * @file sprite.h
 * @brief Stateful sprite API
 */

module citro2d.sprite;

import ctru.services.cfgu;
import ctru.font;
import ctru.types;
import citro2d.base;
import citro2d.spritesheet;

extern (C):

struct C2D_Sprite
{
    C2D_Image image;
    C2D_DrawParams params;
}

/** @defgroup Sprite Sprite functions
 *  @{
 */

/** @brief Initializes a sprite from an image
 *  @param[in] Pointer to sprite
 *  @param[in] image Image to use
 */
void C2D_SpriteFromImage(C2D_Sprite* sprite, C2D_Image image);

/** @brief Initializes a sprite from an image stored in a sprite sheet
 *  @param[in] Pointer to sprite
 *  @param[in] sheet Sprite sheet handle
 *  @param[in] index Index of the image inside the sprite sheet
 */
void C2D_SpriteFromSheet(
    C2D_Sprite* sprite,
    C2D_SpriteSheet sheet,
    size_t index);

/** @brief Scale sprite (relative)
 *  @param[in] sprite Pointer to sprite
 *  @param[in] x      X scale (negative values flip the sprite horizontally)
 *  @param[in] y      Y scale (negative values flip the sprite vertically)
 */
void C2D_SpriteScale(C2D_Sprite* sprite, float x, float y);

/** @brief Rotate sprite (relative)
 *  @param[in] sprite  Pointer to sprite
 *  @param[in] radians Amount to rotate in radians
 */
void C2D_SpriteRotate(C2D_Sprite* sprite, float radians);

/** @brief Rotate sprite (relative)
 *  @param[in] sprite  Pointer to sprite
 *  @param[in] degrees Amount to rotate in degrees
 */
void C2D_SpriteRotateDegrees(C2D_Sprite* sprite, float degrees);

/** @brief Move sprite (relative)
 *  @param[in] sprite  Pointer to sprite
 *  @param[in] x       X translation
 *  @param[in] y       Y translation
 */
void C2D_SpriteMove(C2D_Sprite* sprite, float x, float y);

/** @brief Scale sprite (absolute)
 *  @param[in] sprite Pointer to sprite
 *  @param[in] x      X scale (negative values flip the sprite horizontally)
 *  @param[in] y      Y scale (negative values flip the sprite vertically)
 */
void C2D_SpriteSetScale(C2D_Sprite* sprite, float x, float y);

/** @brief Rotate sprite (absolute)
 *  @param[in] sprite  Pointer to sprite
 *  @param[in] radians Amount to rotate in radians
 */
void C2D_SpriteSetRotation(C2D_Sprite* sprite, float radians);

/** @brief Rotate sprite (absolute)
 *  @param[in] sprite  Pointer to sprite
 *  @param[in] degrees Amount to rotate in degrees
 */
void C2D_SpriteSetRotationDegrees(C2D_Sprite* sprite, float degrees);

/** @brief Set the center of a sprite in values independent of the sprite size (absolute)
 *  @param[in] sprite  Pointer to sprite
 *  @param[in] x       X position of the center (0.0 through 1.0)
 *  @param[in] y       Y position of the center (0.0 through 1.0)
 */
void C2D_SpriteSetCenter(C2D_Sprite* sprite, float x, float y);

/** @brief Set the center of a sprite in terms of pixels (absolute)
 *  @param[in] sprite  Pointer to sprite
 *  @param[in] x       X position of the center (in pixels)
 *  @param[in] y       Y position of the center (in pixels)
 */
void C2D_SpriteSetCenterRaw(C2D_Sprite* sprite, float x, float y);

/** @brief Move sprite (absolute)
 *  @param[in] sprite  Pointer to sprite
 *  @param[in] x       X position
 *  @param[in] y       Y position
 */
void C2D_SpriteSetPos(C2D_Sprite* sprite, float x, float y);

/** @brief Sets the depth level of a sprite (absolute)
 *  @param[in] sprite  Pointer to sprite
 *  @param[in] depth   Depth value
 */
void C2D_SpriteSetDepth(C2D_Sprite* sprite, float depth);

/** @brief Draw sprite
 *  @param[in] sprite Sprite to draw
 */
bool C2D_DrawSprite(const(C2D_Sprite)* sprite);

/** @brief Draw sprite with color tinting
 *  @param[in] sprite Sprite to draw
 *  @param[in] tint Color tinting parameters to apply to the sprite
 */
bool C2D_DrawSpriteTinted(
    const(C2D_Sprite)* sprite,
    const(C2D_ImageTint)* tint);

/** @} */
