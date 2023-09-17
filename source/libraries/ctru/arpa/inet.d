module ctru.arpa.inet;

public import ctru.types;
public import ctru.netinet.in_;
public import ctru.socket;

extern (C): nothrow: @nogc:

// Thanks, Sean Palmer
pragma(inline, true)
private uint bswap32(uint i) {
  return (i & 0xff) << 24
       | (i & 0xff00) << 8
       | (i >> 8) & 0xff00
       | (i >> 24) & 0xff;
}

pragma(inline, true)
private ushort bswap16(ushort i) {
  return (i & 0xff) << 8
       | (i >> 8);
}

pragma(inline, true)
uint htonl(uint hostlong)
{
  return bswap32(hostlong);
}

pragma(inline, true)
ushort htons(ushort hostshort)
{
  return bswap16(hostshort);
}

pragma(inline, true)
uint ntohl(uint netlong)
{
  return bswap32(netlong);
}

pragma(inline, true)
ushort ntohs(ushort netshort)
{
  return bswap16(netshort);
}

in_addr_t inet_addr(const(char)* cp);
int       inet_aton(const(char)* cp, in_addr* inp);
char*     inet_ntoa(in_addr in_);

const(char)* inet_ntop(int af, const(void)* src, char* dst, socklen_t size);
int          inet_pton(int af, const(char)* src, void* dst);
