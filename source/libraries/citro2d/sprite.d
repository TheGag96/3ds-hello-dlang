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
import citro3d.maths;
import core.stdc.math;

extern (C): nothrow: @nogc:

struct C2D_Sprite
{
    nothrow: @nogc:

    C2D_Image image;
    C2D_DrawParams params;

    pragma(inline, true)
    static C2D_Sprite fromImage(C2D_Image image) {
        C2D_Sprite result = void;
        C2D_SpriteFromImage(&result, image);
        return result;
    }

    pragma(inline, true)
    static C2D_Sprite fromSheet(C2D_SpriteSheet sheet, size_t index) {
        C2D_Sprite result = void;
        C2D_SpriteFromSheet(&result, sheet, index);
        return result;
    }

    pragma(inline, true)
    void scale(float x, float y)
    {
        C2D_SpriteScale(&this, x, y);
    }

    pragma(inline, true)
    void rotate(float radians)
    {
        C2D_SpriteRotate(&this, radians);
    }

    pragma(inline, true)
    void rotateDegrees(float degrees)
    {
        C2D_SpriteRotateDegrees(&this, degrees);
    }

    pragma(inline, true)
    void move(float x, float y)
    {
        C2D_SpriteMove(&this, x, y);
    }

    pragma(inline, true)
    void setScale(float x, float y)
    {
        C2D_SpriteScale(&this, x, y);
    }

    pragma(inline, true)
    void setRotation(float radians)
    {
        C2D_SpriteSetRotation(&this, radians);
    }

    pragma(inline, true)
    void setRotationDegrees(float degrees)
    {
        C2D_SpriteSetRotationDegrees(&this, degrees);
    }

    pragma(inline, true)
    void setCenter(float x, float y)
    {
        C2D_SpriteSetCenter(&this, x, y);
    }

    pragma(inline, true)
    void setCenterRaw(float x, float y)
    {
        C2D_SpriteSetCenterRaw(&this, x, y);
    }

    pragma(inline, true)
    void setPos(float x, float y)
    {
        C2D_SpriteSetPos(&this, x, y);
    }

    pragma(inline, true)
    void setDepth(float depth)
    {
        C2D_SpriteSetDepth(&this, depth);
    }

    pragma(inline, true)
    void draw()
    {
        C2D_DrawSprite(&this);
    }

    pragma(inline, true)
    void draw(const(C2D_ImageTint)* tint)
    {
        C2D_DrawSpriteTinted(&this, tint);
    }

    pragma(inline, true)
    void setFlipX(bool flip) {
        if ((flip && params.pos.w > 0) || (!flip && params.pos.w <= 0)) {
            params.pos.w    *= -1;
            //params.center.x *= -1;
        }
    }

    pragma(inline, true)
    void setFlipY(bool flip) {
        if ((flip && params.pos.h > 0) || (!flip && params.pos.h <= 0)) {
            params.pos.h    *= -1;
            //params.center.y *= -1;
        }
    }
}

/** @defgroup Sprite Sprite functions
 *  @{
 */

/** @brief Initializes a sprite from an image
 *  @param[in] Pointer to sprite
 *  @param[in] image Image to use
 */
pragma(inline, true)
void C2D_SpriteFromImage(C2D_Sprite* sprite, C2D_Image image)
{
    sprite.image           = image;
    sprite.params.pos.x    = 0.0f;
    sprite.params.pos.y    = 0.0f;
    sprite.params.pos.w    = image.subtex.width;
    sprite.params.pos.h    = image.subtex.height;
    sprite.params.center.x = 0.0f;
    sprite.params.center.y = 0.0f;
    sprite.params.angle    = 0.0f;
    sprite.params.depth    = 0.0f;
}

/** @brief Initializes a sprite from an image stored in a sprite sheet
 *  @param[in] Pointer to sprite
 *  @param[in] sheet Sprite sheet handle
 *  @param[in] index Index of the image inside the sprite sheet
 */
pragma(inline, true)
void C2D_SpriteFromSheet(C2D_Sprite* sprite, C2D_SpriteSheet sheet, size_t index)
{
    C2D_SpriteFromImage(sprite, C2D_SpriteSheetGetImage(sheet, index));
}

/** @brief Scale sprite (relative)
 *  @param[in] sprite Pointer to sprite
 *  @param[in] x      X scale (negative values flip the sprite horizontally)
 *  @param[in] y      Y scale (negative values flip the sprite vertically)
 */
pragma(inline, true)
void C2D_SpriteScale(C2D_Sprite* sprite, float x, float y)
{
    sprite.params.pos.w *= x;
    sprite.params.pos.h *= y;
    sprite.params.center.x *= x;
    sprite.params.center.y *= x;
}

/** @brief Rotate sprite (relative)
 *  @param[in] sprite  Pointer to sprite
 *  @param[in] radians Amount to rotate in radians
 */
pragma(inline, true)
void C2D_SpriteRotate(C2D_Sprite* sprite, float radians)
{
    sprite.params.angle += radians;
}

/** @brief Rotate sprite (relative)
 *  @param[in] sprite  Pointer to sprite
 *  @param[in] degrees Amount to rotate in degrees
 */
pragma(inline, true)
void C2D_SpriteRotateDegrees(C2D_Sprite* sprite, float degrees)
{
    C2D_SpriteRotate(sprite, C3D_AngleFromDegrees(degrees));
}

/** @brief Move sprite (relative)
 *  @param[in] sprite  Pointer to sprite
 *  @param[in] x       X translation
 *  @param[in] y       Y translation
 */
pragma(inline, true)
void C2D_SpriteMove(C2D_Sprite* sprite, float x, float y)
{
    sprite.params.pos.x += x;
    sprite.params.pos.y += y;
}

/** @brief Scale sprite (absolute)
 *  @param[in] sprite Pointer to sprite
 *  @param[in] x      X scale (negative values flip the sprite horizontally)
 *  @param[in] y      Y scale (negative values flip the sprite vertically)
 */
pragma(inline, true)
void C2D_SpriteSetScale(C2D_Sprite* sprite, float x, float y)
{
    float oldCenterX = sprite.params.center.x / sprite.params.pos.w;
    float oldCenterY = sprite.params.center.y / sprite.params.pos.h;
    sprite.params.pos.w = x*sprite.image.subtex.width;
    sprite.params.pos.h = y*sprite.image.subtex.height;
    sprite.params.center.x = fabsf(oldCenterX*sprite.params.pos.w);
    sprite.params.center.y = fabsf(oldCenterY*sprite.params.pos.h);
}

/** @brief Rotate sprite (absolute)
 *  @param[in] sprite  Pointer to sprite
 *  @param[in] radians Amount to rotate in radians
 */
pragma(inline, true)
void C2D_SpriteSetRotation(C2D_Sprite* sprite, float radians)
{
    sprite.params.angle = radians;
}

/** @brief Rotate sprite (absolute)
 *  @param[in] sprite  Pointer to sprite
 *  @param[in] degrees Amount to rotate in degrees
 */
pragma(inline, true)
void C2D_SpriteSetRotationDegrees(C2D_Sprite* sprite, float degrees)
{
    C2D_SpriteSetRotation(sprite, C3D_AngleFromDegrees(degrees));
}

/** @brief Set the center of a sprite in values independent of the sprite size (absolute)
 *  @param[in] sprite  Pointer to sprite
 *  @param[in] x       X position of the center (0.0 through 1.0)
 *  @param[in] y       Y position of the center (0.0 through 1.0)
 */
pragma(inline, true)
void C2D_SpriteSetCenter(C2D_Sprite* sprite, float x, float y)
{
    sprite.params.center.x = x*sprite.params.pos.w;
    sprite.params.center.y = y*sprite.params.pos.h;
}

/** @brief Set the center of a sprite in terms of pixels (absolute)
 *  @param[in] sprite  Pointer to sprite
 *  @param[in] x       X position of the center (in pixels)
 *  @param[in] y       Y position of the center (in pixels)
 */
pragma(inline, true)
void C2D_SpriteSetCenterRaw(C2D_Sprite* sprite, float x, float y)
{
    sprite.params.center.x = x;
    sprite.params.center.y = y;
}

/** @brief Move sprite (absolute)
 *  @param[in] sprite  Pointer to sprite
 *  @param[in] x       X position
 *  @param[in] y       Y position
 */
pragma(inline, true)
void C2D_SpriteSetPos(C2D_Sprite* sprite, float x, float y)
{
    sprite.params.pos.x = x;
    sprite.params.pos.y = y;
}

/** @brief Sets the depth level of a sprite (absolute)
 *  @param[in] sprite  Pointer to sprite
 *  @param[in] depth   Depth value
 */
pragma(inline, true)
void C2D_SpriteSetDepth(C2D_Sprite* sprite, float depth)
{
    sprite.params.depth = depth;
}

/** @brief Draw sprite
 *  @param[in] sprite Sprite to draw
 */
pragma(inline, true)
bool C2D_DrawSprite(const(C2D_Sprite)* sprite)
{
    return C2D_DrawImage((cast(C2D_Sprite*)sprite).image, &sprite.params, null);
}

/** @brief Draw sprite with color tinting
 *  @param[in] sprite Sprite to draw
 *  @param[in] tint Color tinting parameters to apply to the sprite
 */
pragma(inline, true)
bool C2D_DrawSpriteTinted(const(C2D_Sprite)* sprite, const(C2D_ImageTint)* tint)
{
    return C2D_DrawImage((cast(C2D_Sprite*)sprite).image, &sprite.params, tint);
}

/** @} */