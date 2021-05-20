/**
 * @file soc.h
 * @brief SOC service for sockets communications
 *
 * After initializing this service you will be able to use system calls from netdb.h, sys/socket.h etc.
 */

module ctru.services.soc;

import core.stdc.config;
import ctru.types;
//import ctru.netinet.in_;
//import ctru.sys.socket;

extern (C): nothrow: @nogc:

//TODO: enable later when i fix the c std lib

///// The config level to be used with @ref SOCU_GetNetworkOpt
//enum SOL_CONFIG = 0xfffe;

///// Options to be used with @ref SOCU_GetNetworkOpt
//enum NetworkOpt : ushort
//{
//    mac_address     = 0x1004, ///< The mac address of the interface (u32 mac[6])
//    arp_table       = 0x3002, ///< The ARP table @see SOCU_ARPTableEntry
//    ip_info         = 0x4003, ///< The cureent IP setup @see SOCU_IPInfo
//    ip_mtu          = 0x4004, ///< The value of the IP MTU (u32)
//    routing_table   = 0x4006, ///< The routing table @see SOCU_RoutingTableEntry
//    udp_number      = 0x8002, ///< The number of sockets in the UDP table (u32)
//    udp_table       = 0x8003, ///< The table of opened UDP sockets @see SOCU_UDPTableEntry
//    tcp_number      = 0x9002, ///< The number of sockets in the TCP table (u32)
//    tcp_table       = 0x9003, ///< The table of opened TCP sockets @see SOCU_TCPTableEntry
//    dns_table       = 0xB003, ///< The table of the DNS servers @see SOCU_DNSTableEntry -- Returns a buffer of size 336 but only 2 entries are set ?
//    dhcp_lease_time = 0xC001  ///< The DHCP lease time remaining, in seconds
//}

///// One entry of the ARP table retrieved by using @ref SOCU_GetNetworkOpt and @ref NETOPT_ARP_TABLE
//struct SOCU_ARPTableEntry
//{
//    uint unk0; // often 2 ? state ?
//    in_addr ip; ///< The IPv4 address associated to the entry
//    ubyte[6] mac; ///< The MAC address of associated to the entry
//    ubyte[2] padding;
//}

///// Structure returned by @ref SOCU_GetNetworkOpt when using @ref NETOPT_IP_INFO
//struct SOCU_IPInfo
//{
//    in_addr ip; ///< Current IPv4 address
//    in_addr netmask; ///< Current network mask
//    in_addr broadcast; ///< Current network broadcast address
//}

//// Linux netstat flags
//// NOTE : there are probably other flags supported, if you can forge ICMP requests please check for D and M flags

///** The route uses a gateway */
//enum ROUTING_FLAG_G = 0x01;

///// One entry of the routing table retrieved by using @ref SOCU_GetNetworkOpt and @ref NETOPT_ROUTING_TABLE
//struct SOCU_RoutingTableEntry
//{
//    in_addr dest_ip; ///< Destination IP address of the route
//    in_addr netmask; ///< Mask used for this route
//    in_addr gateway; ///< Gateway address to reach the network
//    uint flags; ///< Linux netstat flags @see ROUTING_FLAG_G
//    ulong time; ///< number of milliseconds since 1st Jan 1900 00:00.
//}

///// One entry of the UDP sockets table retrieved by using @ref SOCU_GetNetworkOpt and @ref NETOPT_UDP_TABLE
//struct SOCU_UDPTableEntry
//{
//    sockaddr_storage local; ///< Local address information
//    sockaddr_storage remote; ///< Remote address information
//}

/////@name TCP states
/////@{
//enum TCP_STATE_CLOSED = 1;
//enum TCP_STATE_LISTEN = 2;
//enum TCP_STATE_ESTABLISHED = 5;
//enum TCP_STATE_FINWAIT1 = 6;
//enum TCP_STATE_FINWAIT2 = 7;
//enum TCP_STATE_CLOSE_WAIT = 8;
//enum TCP_STATE_LAST_ACK = 9;
//enum TCP_STATE_TIME_WAIT = 11;
/////@}

///// One entry of the TCP sockets table retrieved by using @ref SOCU_GetNetworkOpt and @ref NETOPT_TCP_TABLE
//struct SOCU_TCPTableEntry
//{
//    uint state; ///< @see TCP states defines
//    sockaddr_storage local; ///< Local address information
//    sockaddr_storage remote; ///< Remote address information
//}

///// One entry of the DNS servers table retrieved by using @ref SOCU_GetNetworkOpt and @ref NETOPT_DNS_TABLE
//struct SOCU_DNSTableEntry
//{
//    uint family; /// Family of the address of the DNS server
//    in_addr ip; /// IP of the DNS server
//    ubyte[12] padding; // matches the length required for IPv6 addresses
//}

///**
// * @brief Initializes the SOC service.
// * @param context_addr Address of a page-aligned (0x1000) buffer to be used.
// * @param context_size Size of the buffer, a multiple of 0x1000.
// * @note The specified context buffer can no longer be accessed by the process which called this function, since the userland permissions for this block are set to no-access.
// */
//Result socInit(uint* context_addr, uint context_size);

///**
// * @brief Closes the soc service.
// * @note You need to call this in order to be able to use the buffer again.
// */
//Result socExit();

//// this is supposed to be in unistd.h but newlib only puts it for cygwin, waiting for newlib patch from dkA
///**
// * @brief Gets the system's host ID.
// * @return The system's host ID.
// */
//c_long gethostid();

//// this is supposed to be in unistd.h but newlib only puts it for cygwin, waiting for newlib patch from dkA
//int gethostname(char* name, size_t namelen);

//int SOCU_ShutdownSockets();

//int SOCU_CloseSockets();

///**
// * @brief Retrieves information from the network configuration. Similar to getsockopt().
// * @param level   Only value allowed seems to be @ref SOL_CONFIG
// * @param optname The option to be retrieved
// * @param optval  Will contain the output of the command
// * @param optlen  Size of the optval buffer, will be updated to hold the size of the output
// * @return 0 if successful. -1 if failed, and errno will be set accordingly. Can also return a system error code.
// */
//int SOCU_GetNetworkOpt(int level, NetworkOpt optname, void* optval, socklen_t* optlen);

///**
// * @brief Gets the system's IP address, netmask, and subnet broadcast
// * @return error
// */
//int SOCU_GetIPInfo(in_addr* ip, in_addr* netmask, in_addr* broadcast);

///**
// * @brief Adds a global socket.
// * @param sockfd   The socket fd.
// * @return error
// */
//int SOCU_AddGlobalSocket(int sockfd);
