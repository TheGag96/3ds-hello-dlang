module ctru;

extern (C):

struct ConsoleFont {
  ubyte* gfx;
  ushort asciiOffset;
  ushort numChars;
}

alias ConsolePrint = bool function(void*, int);

struct PrintConsole {
  ConsoleFont font;
  ushort* frameBuffer;
  int cursorX, cursorY, 
      prevCursorX, prevCursorY, 
      consoleWidth, consoleHeight, 
      windowX, windowY, 
      windowWidth, windowHeight, 
      tabSize, fg, bg, flags;
  ConsolePrint PrintChar;
  bool consoleInitialised;
}

enum GFXScreen {
  TOP, BOTTOM
}

PrintConsole* consoleInit(GFXScreen screen, PrintConsole* console);

bool aptMainLoop();

void hidScanInput();
uint hidKeysDown();
uint hidKeysUp();

void gfxInitDefault();
void gfxFlushBuffers();
void gfxSwapBuffers();
void gfxExit();


enum GSPGPU_Event {
  PSC0 = 0,
  PSC1,
  VBlank0,
  VBlank1,
  PPF,
  P3D,
  DMA,
  MAX
}
void gspWaitForEvent(GSPGPU_Event id, bool nextEvent);
pragma(inline) void gspWaitForVBlank0() {
  gspWaitForEvent(GSPGPU_Event.VBlank0, true);
}
alias gspWaitForVBlank() = gspWaitForVBlank0;
//
//import core.stdc.stdio : printf;

 extern(C) int printf (
  scope const(char*) format, ...
) nothrow @nogc; 