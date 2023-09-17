module ctru.netdb;

public import ctru.socket;

extern (C): nothrow: @nogc:

enum HOST_NOT_FOUND = 1;
enum NO_DATA        = 2;
enum NO_ADDRESS     = NO_DATA;
enum NO_RECOVERY    = 3;
enum TRY_AGAIN      = 4;

struct hostent {
  char*     h_name;       /* official name of host */
  char**    h_aliases;    /* alias list */
  ushort    h_addrtype;   /* host address type */
  ushort    h_length;     /* length of address */
  char**    h_addr_list;  /* list of addresses from name server */

  /* for backward compatibility */
  pragma(inline, true)
  char* h_addr() {
    return h_addr_list[0];
  }
}

enum AI_PASSIVE     = 0x01;
enum AI_CANONNAME   = 0x02;
enum AI_NUMERICHOST = 0x04;
enum AI_NUMERICSERV = 0x00; /* probably 0x08 but services names are never resolved */

// doesn't apply to 3ds
enum AI_ADDRCONFIG  = 0x00;


enum NI_MAXHOST     = 1025;
enum NI_MAXSERV     = 32;

enum NI_NOFQDN      = 0x01;
enum NI_NUMERICHOST = 0x02;
enum NI_NAMEREQD    = 0x04;
enum NI_NUMERICSERV = 0x00; /* probably 0x08 but services names are never resolved */
enum NI_DGRAM       = 0x00; /* probably 0x10 but services names are never resolved */

enum EAI_FAMILY     = (-303);
enum EAI_MEMORY     = (-304);
enum EAI_NONAME     = (-305);
enum EAI_SOCKTYPE   = (-307);

struct addrinfo {
  int             ai_flags;
  int             ai_family;
  int             ai_socktype;
  int             ai_protocol;
  socklen_t       ai_addrlen;
  char*           ai_canonname;
  sockaddr*       ai_addr;
  addrinfo*       ai_next;
};

extern int  h_errno;
hostent* gethostbyname(const(char)* name);
hostent* gethostbyaddr(const(void)* addr, socklen_t len, int type);
void    herror(const(char)* s);
const(char)* hstrerror(int err);

int getnameinfo(const(sockaddr)* sa, socklen_t salen,
  char *host, socklen_t hostlen,
  char *serv, socklen_t servlen, int flags);

int getaddrinfo(const(char)* node, const(char)* service,
  const(addrinfo)* hints,
  addrinfo** res);

void freeaddrinfo(addrinfo* ai);

const(char)* gai_strerror(int ecode);