module ctru.poll;

public import ctru.types;

extern (C): nothrow: @nogc:

enum POLLIN   = 0x01;
enum POLLPRI  = 0x02;
enum POLLHUP  = 0x04; // unknown ???
enum POLLERR  = 0x08; // probably
enum POLLOUT  = 0x10;
enum POLLNVAL = 0x20;

alias nfds_t = uint;

struct pollfd
{
  int fd;
  int events;
  int revents;
};

int poll(pollfd* fds, nfds_t nfsd, int timeout);
