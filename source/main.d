// Simple citro2d sprite drawing example
// Converted to D and made stereoscopic 3D by TheGag96
// Images borrowed from:
//   https://kenney.nl/assets/space-shooter-redux

extern (C):

import ctru;
import citro2d;
import citro3d;
import core.stdc.stdio;

enum MAX_SPRITES   = 768;
enum SCREEN_WIDTH  = 400;
enum SCREEN_HEIGHT = 240;

// Simple sprite struct
struct Sprite
{
  C2D_Sprite spr;
  float z;
  float dx, dy; // velocity
}

static C2D_SpriteSheet spriteSheet;
static Sprite[MAX_SPRITES] sprites;
static size_t numSprites = MAX_SPRITES/2;

float depth = 100;
bool rotation = false;

//TODO: replace with real rand once std lib stuff is fixed
enum RAND_MAX = int.max;
int rand()
{
  static int seed = 123456789;
  static int m = RAND_MAX;
  static int a = 1103515245;
  static int c = 12345;

  seed = (a * seed + c) % m;
  return seed;
}

//---------------------------------------------------------------------------------
void initSprites() {
//---------------------------------------------------------------------------------
  size_t numImages = C2D_SpriteSheetCount(spriteSheet);
  //srand(time(null));

  for (size_t i = 0; i < MAX_SPRITES; i++)
  {
    Sprite* sprite = &sprites[i];

    // Random image, position, rotation and speed
    C2D_SpriteFromSheet(&sprite.spr, spriteSheet, rand() % numImages);
    C2D_SpriteSetCenter(&sprite.spr, 0.5f, 0.5f);
    C2D_SpriteSetPos(&sprite.spr, rand() % SCREEN_WIDTH, rand() % SCREEN_HEIGHT);
    C2D_SpriteSetRotation(&sprite.spr, C3D_Angle(rand()/cast(float)RAND_MAX));
    sprite.dx = rand()*4.0f/cast(float)RAND_MAX - 2.0f;
    sprite.dy = rand()*4.0f/cast(float)RAND_MAX - 2.0f;
    sprite.z  = (MAX_SPRITES-i) / depth;
    // sprite.z  = -(rand()*10.0f/RAND_MAX - 5.0f);
  }
}

//---------------------------------------------------------------------------------
void moveSprites() {
//---------------------------------------------------------------------------------
  for (size_t i = 0; i < numSprites; i++)
  {
    Sprite* sprite = &sprites[i];
    C2D_SpriteMove(&sprite.spr, sprite.dx, sprite.dy);

    if (rotation) {
      C2D_SpriteRotateDegrees(&sprite.spr, 1.0f);
    }

    // Check for collision with the screen boundaries
    if ((sprite.spr.params.pos.x < sprite.spr.params.pos.w / 2.0f && sprite.dx < 0.0f) ||
      (sprite.spr.params.pos.x > (SCREEN_WIDTH-(sprite.spr.params.pos.w / 2.0f)) && sprite.dx > 0.0f))
      sprite.dx = -sprite.dx;

    if ((sprite.spr.params.pos.y < sprite.spr.params.pos.h / 2.0f && sprite.dy < 0.0f) ||
      (sprite.spr.params.pos.y > (SCREEN_HEIGHT-(sprite.spr.params.pos.h / 2.0f)) && sprite.dy > 0.0f))
      sprite.dy = -sprite.dy;

    sprite.z  = (MAX_SPRITES-i) / depth;
  }
}

//---------------------------------------------------------------------------------
int main() {
//---------------------------------------------------------------------------------
  // Init libs
  romfsInit();
  gfxInitDefault();
  gfxSet3D(true); // Enable stereoscopic 3D
  C3D_Init(C3D_DEFAULT_CMDBUF_SIZE);
  C2D_Init(C2D_DEFAULT_MAX_OBJECTS);
  C2D_Prepare();
  consoleInit(GFXScreen.bottom, null);

  // Create screens
  C3D_RenderTarget* topLeft = C2D_CreateScreenTarget(GFXScreen.top, GFX3DSide.left);
  C3D_RenderTarget* topRight = C2D_CreateScreenTarget(GFXScreen.top, GFX3DSide.right);

  // Load graphics
  spriteSheet = C2D_SpriteSheetLoad("romfs:/gfx/sprites.t3x");
  //if (!spriteSheet) svcBreak(USERBREAK_PANIC);

  // Initialize sprites
  initSprites();

  printf("\x1b[8;1HPress Up to increment sprites");
  printf("\x1b[9;1HPress Down to decrement sprites");

  // Main loop
  while (aptMainLoop())
  {
    hidScanInput();

    // Respond to user input
    uint kDown = hidKeysDown();
    if (kDown & Key.start)
      break; // break in order to return to hbmenu

    if (kDown & Key.x)
      rotation = !rotation;

    uint kHeld = hidKeysHeld();
    if ((kHeld & Key.up) && numSprites < MAX_SPRITES)
      numSprites++;
    if ((kHeld & Key.down) && numSprites > 1)
      numSprites--;

    if ((kHeld & Key.left))
      depth--;
    if ((kHeld & Key.right))
      depth++;

    moveSprites();

    printf("\x1b[1;1HSprites: %zu/%u\x1b[K", numSprites, MAX_SPRITES);
    printf("\x1b[2;1HCPU:     %6.2f%%\x1b[K", C3D_GetProcessingTime()*6.0f);
    printf("\x1b[3;1HGPU:     %6.2f%%\x1b[K", C3D_GetDrawingTime()*6.0f);
    printf("\x1b[4;1HCmdBuf:  %6.2f%%\x1b[K", C3D_GetCmdBufUsage()*100.0f);
    printf("\x1b[5;1Hdepth:   %6.2f%%\x1b[K", depth);

    // Render the scene
    C3D_FrameBegin(C3D_FRAME_SYNCDRAW);
    C2D_TargetClear(topLeft, C2D_Color32f(0.0f, 0.0f, 0.0f, 1.0f));
    C2D_SceneBegin(topLeft);
    foreach (i; 0..numSprites) {
      float oldX = sprites[i].spr.params.pos.x;
      sprites[i].spr.params.pos.x -= sprites[i].z;
      C2D_DrawSprite(&sprites[i].spr);
      sprites[i].spr.params.pos.x = oldX;
    }


    C2D_TargetClear(topRight, C2D_Color32f(0.0f, 0.0f, 0.0f, 1.0f));
    C2D_SceneBegin(topRight);
    foreach (i; 0..numSprites) {
      float oldX = sprites[i].spr.params.pos.x;
      sprites[i].spr.params.pos.x += sprites[i].z;
      C2D_DrawSprite(&sprites[i].spr);
      sprites[i].spr.params.pos.x = oldX;
    }

    C3D_FrameEnd(0);
  }

  // Delete graphics
  C2D_SpriteSheetFree(spriteSheet);

  // Deinit libs
  C2D_Fini();
  C3D_Fini();
  gfxExit();
  romfsExit();
  return 0;
}
