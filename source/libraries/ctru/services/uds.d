/**
 * @file uds.h
 * @brief UDS(NWMUDS) local-WLAN service. https://3dbrew.org/wiki/NWM_Services
 */

module ctru.services.uds;

import ctru.types;

extern (C): nothrow: @nogc:

/// Maximum number of nodes(devices) that can be connected to the network.
enum UDS_MAXNODES = 16;

/// Broadcast value for NetworkNodeID / alias for all NetworkNodeIDs.
enum UDS_BROADCAST_NETWORKNODEID = 0xFFFF;

/// NetworkNodeID for the host(the first node).
enum UDS_HOST_NETWORKNODEID = 0x1;

/// Default recv_buffer_size that can be used for udsBind() input / code which uses udsBind() internally.
enum UDS_DEFAULT_RECVBUFSIZE = 0x2E30;

/// Max size of user data-frames.
enum UDS_DATAFRAME_MAXSIZE = 0x5C6;

/// Check whether a fatal udsSendTo error occured(some error(s) from udsSendTo() can be ignored, but the frame won't be sent when that happens).
extern (D) auto UDS_CHECK_SENDTO_FATALERROR(T)(auto ref T x)
{
    return R_FAILED(x) && x != 0xC86113F0;
}

/// Node info struct.
struct udsNodeInfo
{
    ulong uds_friendcodeseed; //UDS version of the FriendCodeSeed.

    union
    {
        ubyte[0x18] usercfg; //This is the first 0x18-bytes from this config block: https://www.3dbrew.org/wiki/Config_Savegame#0x000A0000_Block

        struct
        {
            ushort[10] username;

            ushort unk_x1c; //Unknown, normally zero. Set to 0x0 with the output from udsScanBeacons().
            ubyte flag; //"u8 flag, unknown. Originates from the u16 bitmask in the beacon node-list header. This flag is normally 0 since that bitmask is normally 0?"
            ubyte pad_x1f; //Unknown, normally zero.
        }
    }

    //The rest of this is initialized by NWM-module.
    ushort NetworkNodeID;
    ushort pad_x22; //Unknown, normally zero?
    uint word_x24; //Normally zero?
}

/// Connection status struct.
struct udsConnectionStatus
{
    uint status;
    uint unk_x4;
    ushort cur_NetworkNodeID; //"u16 NetworkNodeID for this device."
    ushort unk_xa;
    uint[8] unk_xc;

    ubyte total_nodes;
    ubyte max_nodes;
    ushort node_bitmask; //"This is a bitmask of NetworkNodeIDs: bit0 for NetworkNodeID 0x1(host), bit1 for NetworkNodeID 0x2(first original client), and so on."
}

/// Network struct stored as big-endian.
struct udsNetworkStruct
{
    ubyte[6] host_macaddress;
    ubyte channel; //Wifi channel for this network. If you want to create a network on a specific channel instead of the system selecting it, you can set this to a non-zero channel value.
    ubyte pad_x7;

    ubyte initialized_flag; //Must be non-zero otherwise NWM-module will use zeros internally instead of the actual field data, for most/all(?) of the fields in this struct.

    ubyte[3] unk_x9;

    ubyte[3] oui_value; //"This is the OUI value for use with the beacon tags. Normally this is 001F32."
    ubyte oui_type; //"OUI type (21/0x15)"

    uint wlancommID; //Unique local-WLAN communications ID for each application.
    ubyte id8; //Additional ID that can be used by the application for different types of networks.
    ubyte unk_x15;

    ushort attributes; //See the UDSNETATTR enum values below.

    uint networkID;

    ubyte total_nodes;
    ubyte max_nodes;
    ubyte unk_x1e;
    ubyte unk_x1f;
    ubyte[0x1f] unk_x20;

    ubyte appdata_size;
    ubyte[0xc8] appdata;
}

struct udsBindContext
{
    uint BindNodeID;
    Handle event;
    bool spectator;
}

/// General NWM input structure used for AP scanning.
struct nwmScanInputStruct
{
    ushort unk_x0;
    ushort unk_x2;
    ushort unk_x4;
    ushort unk_x6;

    ubyte[6] mac_address;

    ubyte[0x26] unk_xe; //Not initialized by dlp.
}

/// General NWM output structure from AP scanning.
struct nwmBeaconDataReplyHeader
{
    uint maxsize; //"Max output size, from the command request."
    uint size; //"Total amount of output data written relative to struct+0. 0xC when there's no entries."
    uint total_entries; //"Total entries, 0 for none. "

    //The entries start here.
}

/// General NWM output structure from AP scanning, for each entry.
struct nwmBeaconDataReplyEntry
{
    uint size; //"Size of this entire entry. The next entry starts at curentry_startoffset+curentry_size."
    ubyte unk_x4;
    ubyte channel; //Wifi channel for the AP.
    ubyte unk_x6;
    ubyte unk_x7;
    ubyte[6] mac_address; //"AP MAC address."
    ubyte[6] unk_xe;
    uint unk_x14;
    uint val_x1c; //"Value 0x1C(size of this header and/or offset to the actual beacon data)."

    //The actual beacon data starts here.
}

/// Output structure generated from host scanning output.
struct udsNetworkScanInfo
{
    nwmBeaconDataReplyEntry datareply_entry;
    udsNetworkStruct network;
    udsNodeInfo[UDS_MAXNODES] nodes;
}

enum
{
    UDSNETATTR_DisableConnectSpectators = BIT(0), //When set new Spectators are not allowed to connect.
    UDSNETATTR_DisableConnectClients    = BIT(1), //When set new Clients are not allowed to connect.
    UDSNETATTR_x4                       = BIT(2), //Unknown what this bit is for.
    UDSNETATTR_Default                  = BIT(15) //Unknown what this bit is for.
}

enum
{
    UDS_SENDFLAG_Default   = BIT(0), //Unknown what this bit is for.
    UDS_SENDFLAG_Broadcast = BIT(1)  //When set, broadcast the data frame via the destination MAC address even when UDS_BROADCAST_NETWORKNODEID isn't used.
}

enum UDSConnectionType : ubyte
{
    client    = 0x1,
    spectator = 0x2
}

/**
 * @brief Initializes UDS.
 * @param sharedmem_size This must be 0x1000-byte aligned.
 * @param username Optional custom UTF-8 username(converted to UTF-16 internally) that other nodes on the UDS network can use. If not set the username from system-config is used. Max len is 10 characters without NUL-terminator.
 */
Result udsInit(size_t sharedmem_size, const(char)* username);

/// Exits UDS.
void udsExit();

/**
 * @brief Generates a NodeInfo struct with data loaded from system-config.
 * @param nodeinfo Output NodeInfo struct.
 * @param username If set, this is the UTF-8 string to convert for use in the struct. Max len is 10 characters without NUL-terminator.
 */
Result udsGenerateNodeInfo(udsNodeInfo* nodeinfo, const(char)* username);

/**
 * @brief Loads the UTF-16 username stored in the input NodeInfo struct, converted to UTF-8.
 * @param nodeinfo Input NodeInfo struct.
 * @param username This is the output UTF-8 string. Max len is 10 characters without NUL-terminator.
 */
Result udsGetNodeInfoUsername(const(udsNodeInfo)* nodeinfo, char* username);

/**
 * @brief Checks whether a NodeInfo struct was initialized by NWM-module(not any output from udsGenerateNodeInfo()).
 * @param nodeinfo Input NodeInfo struct.
 */
bool udsCheckNodeInfoInitialized(const(udsNodeInfo)* nodeinfo);

/**
 * @brief Generates a default NetworkStruct for creating networks.
 * @param network The output struct.
 * @param wlancommID Unique local-WLAN communications ID for each application.
 * @param id8 Additional ID that can be used by the application for different types of networks.
 * @param max_nodes Maximum number of nodes(devices) that can be connected to the network, including the host.
 */
void udsGenerateDefaultNetworkStruct(udsNetworkStruct* network, uint wlancommID, ubyte id8, ubyte max_nodes);

/**
 * @brief Scans for networks via beacon-scanning.
 * @param outbuf Buffer which will be used by the beacon-scanning command and for the data parsing afterwards. Normally there's no need to use the contents of this buffer once this function returns.
 * @param maxsize Max size of the buffer.
 * @Param networks Ptr where the allocated udsNetworkScanInfo array buffer is written. The allocsize is sizeof(udsNetworkScanInfo)*total_networks.
 * @Param total_networks Total number of networks stored under the networks buffer.
 * @param wlancommID Unique local-WLAN communications ID for each application.
 * @param id8 Additional ID that can be used by the application for different types of networks.
 * @param host_macaddress When set, this code will only return network info from the specified host MAC address.
 * @connected When not connected to a network this *must* be false. When connected to a network this *must* be true.
 */
Result udsScanBeacons(void* outbuf, size_t maxsize, udsNetworkScanInfo** networks, size_t* total_networks, uint wlancommID, ubyte id8, const(ubyte)* host_macaddress, bool connected);

/**
 * @brief This can be used by the host to set the appdata contained in the broadcasted beacons.
 * @param buf Appdata buffer.
 * @param size Size of the input appdata.
 */
Result udsSetApplicationData(const(void)* buf, size_t size);

/**
 * @brief This can be used while on a network(host/client) to get the appdata from the current beacon.
 * @param buf Appdata buffer.
 * @param size Max size of the output buffer.
 * @param actual_size If set, the actual size of the appdata written into the buffer is stored here.
 */
Result udsGetApplicationData(void* buf, size_t size, size_t* actual_size);

/**
 * @brief This can be used with a NetworkStruct, from udsScanBeacons() mainly, for getting the appdata.
 * @param buf Appdata buffer.
 * @param size Max size of the output buffer.
 * @param actual_size If set, the actual size of the appdata written into the buffer is stored here.
 */
Result udsGetNetworkStructApplicationData(const(udsNetworkStruct)* network, void* buf, size_t size, size_t* actual_size);

/**
 * @brief Create a bind.
 * @param bindcontext The output bind context.
 * @param NetworkNodeID This is the NetworkNodeID which this bind can receive data from.
 * @param spectator False for a regular bind, true for a spectator.
 * @param data_channel This is an arbitrary value to use for data-frame filtering. This bind will only receive data frames which contain a matching data_channel value, which was specified by udsSendTo(). The data_channel must be non-zero.
 * @param recv_buffer_size Size of the buffer under sharedmem used for temporarily storing received data-frames which are then loaded by udsPullPacket(). The system requires this to be >=0x5F4. UDS_DEFAULT_RECVBUFSIZE can be used for this.
 */
Result udsBind(udsBindContext* bindcontext, ushort NetworkNodeID, bool spectator, ubyte data_channel, uint recv_buffer_size);

/**
 * @brief Remove a bind.
 * @param bindcontext The bind context.
 */
Result udsUnbind(udsBindContext* bindcontext);

/**
 * @brief Waits for the bind event to occur, or checks if the event was signaled. This event is signaled every time new data is available via udsPullPacket().
 * @return Always true. However if wait=false, this will return false if the event wasn't signaled.
 * @param bindcontext The bind context.
 * @param nextEvent Whether to discard the current event and wait for the next event.
 * @param wait When true this will not return until the event is signaled. When false this checks if the event was signaled without waiting for it.
 */
bool udsWaitDataAvailable(const(udsBindContext)* bindcontext, bool nextEvent, bool wait);

/**
 * @brief Receives data over the network. This data is loaded from the recv_buffer setup by udsBind(). When a node disconnects, this will still return data from that node until there's no more frames from that node in the recv_buffer.
 * @param bindcontext Bind context.
 * @param buf Output receive buffer.
 * @param size Size of the buffer.
 * @param actual_size If set, the actual size written into the output buffer is stored here. This is zero when no data was received.
 * @param src_NetworkNodeID If set, the source NetworkNodeID is written here. This is zero when no data was received.
 */
Result udsPullPacket(const(udsBindContext)* bindcontext, void* buf, size_t size, size_t* actual_size, ushort* src_NetworkNodeID);

/**
 * @brief Sends data over the network.
 * @param dst_NetworkNodeID Destination NetworkNodeID.
 * @param data_channel See udsBind().
 * @param flags Send flags, see the UDS_SENDFLAG enum values.
 * @param buf Input send buffer.
 * @param size Size of the buffer.
 */
Result udsSendTo(ushort dst_NetworkNodeID, ubyte data_channel, ubyte flags, const(void)* buf, size_t size);

/**
 * @brief Gets the wifi channel currently being used.
 * @param channel Output channel.
 */
Result udsGetChannel(ubyte* channel);

/**
 * @brief Starts hosting a new network.
 * @param network The NetworkStruct, you can use udsGenerateDefaultNetworkStruct() for generating this.
 * @param passphrase Raw input passphrase buffer.
 * @param passphrase_size Size of the passphrase buffer.
 * @param context Optional output bind context which will be created for this host, with NetworkNodeID=UDS_BROADCAST_NETWORKNODEID.
 * @param data_channel This is the data_channel value which will be passed to udsBind() internally.
 * @param recv_buffer_size This is the recv_buffer_size value which will be passed to udsBind() internally.
 */
Result udsCreateNetwork(const(udsNetworkStruct)* network, const(void)* passphrase, size_t passphrase_size, udsBindContext* context, ubyte data_channel, uint recv_buffer_size);

/**
 * @brief Connect to a network.
 * @param network The NetworkStruct, you can use udsScanBeacons() for this.
 * @param passphrase Raw input passphrase buffer.
 * @param passphrase_size Size of the passphrase buffer.
 * @param context Optional output bind context which will be created for this host.
 * @param recv_NetworkNodeID This is the NetworkNodeID passed to udsBind() internally.
 * @param connection_type Type of connection, see the UDSConnectionType enum values.
 * @param data_channel This is the data_channel value which will be passed to udsBind() internally.
 * @param recv_buffer_size This is the recv_buffer_size value which will be passed to udsBind() internally.
 */
Result udsConnectNetwork(const(udsNetworkStruct)* network, const(void)* passphrase, size_t passphrase_size, udsBindContext* context, ushort recv_NetworkNodeID, UDSConnectionType connection_type, ubyte data_channel, uint recv_buffer_size);

/**
 * @brief Stop hosting the network.
 */
Result udsDestroyNetwork();

/**
 * @brief Disconnect this client device from the network.
 */
Result udsDisconnectNetwork();

/**
 * @brief This can be used by the host to force-disconnect client(s).
 * @param NetworkNodeID Target NetworkNodeID. UDS_BROADCAST_NETWORKNODEID can be used to disconnect all clients.
 */
Result udsEjectClient(ushort NetworkNodeID);

/**
 * @brief This can be used by the host to force-disconnect the spectators. Afterwards new spectators will not be allowed to connect until udsAllowSpectators() is used.
 */
Result udsEjectSpectator();

/**
 * @brief This can be used by the host to update the network attributes. If bitmask 0x4 is clear in the input bitmask, this clears that bit in the value before actually writing the value into state. Normally you should use the below wrapper functions.
 * @param bitmask Bitmask to clear/set in the attributes. See the UDSNETATTR enum values.
 * @param flag When false, bit-clear, otherwise bit-set.
 */
Result udsUpdateNetworkAttribute(ushort bitmask, bool flag);

/**
 * @brief This uses udsUpdateNetworkAttribute() for (un)blocking new connections to this host.
 * @param block When true, block the specified connection types(bitmask set). Otherwise allow them(bitmask clear).
 * @param clients When true, (un)block regular clients.
 * @param flag When true, update UDSNETATTR_x4. Normally this should be false.
 */
Result udsSetNewConnectionsBlocked(bool block, bool clients, bool flag);

/**
 * @brief This uses udsUpdateNetworkAttribute() for unblocking new spectator connections to this host. See udsEjectSpectator() for blocking new spectators.
 */
Result udsAllowSpectators();

/**
 * @brief This loads the current ConnectionStatus struct.
 * @param output Output ConnectionStatus struct.
 */
Result udsGetConnectionStatus(udsConnectionStatus* output);

/**
 * @brief Waits for the ConnectionStatus event to occur, or checks if the event was signaled. This event is signaled when the data from udsGetConnectionStatus() was updated internally.
 * @return Always true. However if wait=false, this will return false if the event wasn't signaled.
 * @param nextEvent Whether to discard the current event and wait for the next event.
 * @param wait When true this will not return until the event is signaled. When false this checks if the event was signaled without waiting for it.
 */
bool udsWaitConnectionStatusEvent(bool nextEvent, bool wait);

/**
 * @brief This loads a NodeInfo struct for the specified NetworkNodeID. The broadcast alias can't be used with this.
 * @param NetworkNodeID Target NetworkNodeID.
 * @param output Output NodeInfo struct.
 */
Result udsGetNodeInformation(ushort NetworkNodeID, udsNodeInfo* output);
