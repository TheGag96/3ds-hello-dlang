module ctru.ioctl;

extern (C): nothrow: @nogc:

enum FIONBIO = 1;

int ioctl(int fd, int request, ...);

