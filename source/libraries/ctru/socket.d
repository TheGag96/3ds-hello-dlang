module ctru.socket;

import ctru.types;

extern (C): nothrow: @nogc:

enum SOL_SOCKET = 0xFFFF;

enum PF_UNSPEC = 0;
enum PF_INET   = 2;
enum PF_INET6  = 23;

enum AF_UNSPEC = PF_UNSPEC;
enum AF_INET   = PF_INET;
enum AF_INET6  = PF_INET6;

enum SOCK_STREAM = 1;
enum SOCK_DGRAM  = 2;

// any flags > 0x4 causes send/recv to return EOPNOTSUPP
enum MSG_OOB       = 0x0001;
enum MSG_PEEK      = 0x0002;
enum MSG_DONTWAIT  = 0x0004;
enum MSG_DONTROUTE = 0x0000; // ???
enum MSG_WAITALL   = 0x0000; // ???
enum MSG_MORE      = 0x0000; // ???
enum MSG_NOSIGNAL  = 0x0000; // there are no signals

enum SHUT_RD   = 0;
enum SHUT_WR   = 1;
enum SHUT_RDWR = 2;

/*
 * SOL_SOCKET options
 */
enum SO_REUSEADDR = 0x0004; // reuse address
enum SO_LINGER    = 0x0080; // linger (no effect?)
enum SO_OOBINLINE = 0x0100; // out-of-band data inline (no effect?)
enum SO_SNDBUF    = 0x1001; // send buffer size
enum SO_RCVBUF    = 0x1002; // receive buffer size
enum SO_SNDLOWAT  = 0x1003; // send low-water mark (no effect?)
enum SO_RCVLOWAT  = 0x1004; // receive low-water mark
enum SO_TYPE      = 0x1008; // get socket type
enum SO_ERROR     = 0x1009; // get socket error

enum SO_BROADCAST = 0x0000; // unrequired, included for compatibility

alias socklen_t = uint;
alias sa_family_t = ushort;

struct sockaddr
{
    sa_family_t sa_family;
    char[] sa_data;
}

// biggest size on 3ds is 0x1C (sockaddr_in6)
struct sockaddr_storage
{
    sa_family_t ss_family;
    char[26] __ss_padding;
}

struct linger
{
    int l_onoff;
    int l_linger;
}

int accept(int sockfd, sockaddr* addr, socklen_t* addrlen);
int bind(int sockfd, const(sockaddr)* addr, socklen_t addrlen);
int closesocket(int sockfd);
int connect(int sockfd, const(sockaddr)* addr, socklen_t addrlen);
int getpeername(int sockfd, sockaddr* addr, socklen_t* addrlen);
int getsockname(int sockfd, sockaddr* addr, socklen_t* addrlen);
int getsockopt(int sockfd, int level, int optname, void* optval, socklen_t* optlen);
int listen(int sockfd, int backlog);
ssize_t recv(int sockfd, void* buf, size_t len, int flags);
ssize_t recvfrom(int sockfd, void* buf, size_t len, int flags, sockaddr* src_addr, socklen_t* addrlen);
ssize_t send(int sockfd, const(void)* buf, size_t len, int flags);
ssize_t sendto(int sockfd, const(void)* buf, size_t len, int flags, const(sockaddr)* dest_addr, socklen_t addrlen);
int setsockopt(int sockfd, int level, int optname, const(void)* optval, socklen_t optlen);
int shutdown(int sockfd, int how);
int socket(int domain, int type, int protocol);
int sockatmark(int sockfd);

