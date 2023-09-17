/**
 * @file gdbhio.h
 * @brief Luma3DS GDB HIO (called File I/O in GDB documentation) functions.
 */

module ctru.gdbhio;

public import ctru.types;

extern (C): nothrow: @nogc:

enum GDBHIO_STDIN_FILENO   = 0;
enum GDBHIO_STDOUT_FILENO  = 1;
enum GDBHIO_STDERR_FILENO  = 2;

struct stat;

int gdbHioOpen(const(char)* pathname, int flags, mode_t mode);
int gdbHioClose(int fd);
int gdbHioRead(int fd, void* buf, uint count);
int gdbHioWrite(int fd, const(void) *buf, uint count);
off_t gdbHioLseek(int fd, off_t offset, int flag);
int gdbHioRename(const(char)* oldpath, const(char)* newpath);
int gdbHioUnlink(const(char)* pathname);
int gdbHioStat(const(char)* pathname, stat* st);
int gdbHioFstat(int fd, stat* st);
int gdbHioGettimeofday(timeval* tv, void* tz);
int gdbHioIsatty(int fd);

///< Host I/O 'system' function, requires 'set remote system-call-allowed 1'.
int gdbHioSystem(const(char)* command);