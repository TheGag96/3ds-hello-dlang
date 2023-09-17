module ctru.netinet.in_;

public import ctru.types;
public import ctru.socket;

extern (C): nothrow: @nogc:

enum INADDR_LOOPBACK  = 0x7f000001;
enum INADDR_ANY       = 0x00000000;
enum INADDR_BROADCAST = 0xFFFFFFFF;
enum INADDR_NONE      = 0xFFFFFFFF;

enum INET_ADDRSTRLEN  = 16;

/*
 * Protocols (See RFC 1700 and the IANA)
 */
enum IPPROTO_IP         =  0;               /* dummy for IP */
enum IPPROTO_UDP        = 17;               /* user datagram protocol */
enum IPPROTO_TCP        =  6;               /* tcp */

enum IP_TOS             =  7;
enum IP_TTL             =  8;
enum IP_MULTICAST_LOOP  =  9;
enum IP_MULTICAST_TTL   = 10;
enum IP_ADD_MEMBERSHIP  = 11;
enum IP_DROP_MEMBERSHIP = 12;

alias in_port_t = ushort;
alias in_addr_t = uint;

struct in_addr {
  in_addr_t       s_addr;
};

struct sockaddr_in {
  sa_family_t     sin_family;
  in_port_t       sin_port;
  in_addr         sin_addr;
  ubyte[8]        sin_zero;
};

/* Request struct for multicast socket ops */
struct ip_mreq  {
  in_addr imr_multiaddr; /* IP multicast address of group */
  in_addr imr_interface; /* local IP address of interface */
};