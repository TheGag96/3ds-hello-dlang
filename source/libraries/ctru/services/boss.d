/**
 * @file boss.h
 * @brief BOSS service, see also: https://www.3dbrew.org/wiki/BOSS_Services
 */

module ctru.services.boss;

import ctru.types;

extern (C): nothrow: @nogc:

/// BOSS context.
struct bossContext
{
    uint[0x7] property;

    char[0x200] url;

    uint property_x8;
    ubyte property_x9;

    ubyte[0x100] property_xa;

    ubyte[0x200] property_xb;

    char[0x360] property_xd; //Additonal optional HTTP request headers.

    uint property_xe;

    uint[3] property_xf;

    ubyte property_x10;
    ubyte property_x11;
    ubyte property_x12;
    uint property_x13;
    uint property_x14;

    ubyte[0x40] property_x15;

    uint property_x16;

    uint property_x3b;

    ubyte[0x200] property_x3e;
}

/// BOSS task status.
enum BossTaskStatus : ubyte
{
    started = 0x2,
    error   = 0x7
}

/// Type values for bossGetNsDataHeaderInfo().
enum BossNsDataHeaderInfoTypes : ubyte
{
    content_size = 0x3 /// Size of the content.
}

/// Size of the output data for bossGetNsDataHeaderInfo().
enum BossNsDataHeaderInfoTypeSizes : ubyte
{
    content_size = 0x4 ///Type2
}

/**
 * @brief Initializes BOSS.
 * @param programID programID to use, 0 for the current process. Only used when BOSSP is available without *hax payload.
 * @param force_user When true, just use bossU instead of trying to initialize with bossP first.
 */
Result bossInit(ulong programID, bool force_user);

/**
 * @brief Run the InitializeSession service cmd. This is mainly for changing the programID associated with the current BOSS session.
 * @param programID programID to use, 0 for the current process.
 */
Result bossReinit(ulong programID);

/// Exits BOSS.
void bossExit();

/// Returns the BOSS session handle.
Handle bossGetSessionHandle();

/**
 * @brief Set the content data storage location.
 * @param extdataID u64 extdataID, must have the high word set to the shared-extdata value when it's for NAND.
 * @param boss_size Probably the max size in the extdata which BOSS can use.
 * @param mediaType Roughly the same as FS mediatype.
 */
Result bossSetStorageInfo(ulong extdataID, uint boss_size, ubyte mediaType);

/**
 * @brief Unregister the content data storage location, which includes unregistering the BOSS-session programID with BOSS.
 */
Result bossUnregisterStorage();

/**
 * @brief Register a task.
 * @param taskID BOSS taskID.
 * @param unk0 Unknown, usually zero.
 * @param unk1 Unknown, usually zero.
 */
Result bossRegisterTask(const(char)* taskID, ubyte unk0, ubyte unk1);

/**
 * @brief Send a property.
 * @param PropertyID PropertyID
 * @param buf Input buffer data.
 * @param size Buffer size.
 */
Result bossSendProperty(ushort PropertyID, const(void)* buf, uint size);

/**
 * @brief Deletes the content file for the specified NsDataId.
 * @param NsDataId NsDataId
 */
Result bossDeleteNsData(uint NsDataId);

/**
 * @brief Gets header info for the specified NsDataId.
 * @param NsDataId NsDataId
 * @param type Type of data to load.
 * @param buffer Output buffer.
 * @param size Output buffer size.
 */
Result bossGetNsDataHeaderInfo(uint NsDataId, ubyte type, void* buffer, uint size);

/**
 * @brief Reads data from the content for the specified NsDataId.
 * @param NsDataId NsDataId
 * @param offset Offset in the content.
 * @param buffer Output buffer.
 * @param size Output buffer size.
 * @param transfer_total Optional output actual read size, can be NULL.
 * @param unk_out Optional unknown output, can be NULL.
 */
Result bossReadNsData(uint NsDataId, ulong offset, void* buffer, uint size, uint* transfer_total, uint* unk_out);

/**
 * @brief Starts a task soon after running this command.
 * @param taskID BOSS taskID.
 */
Result bossStartTaskImmediate(const(char)* taskID);

/**
 * @brief Similar to bossStartTaskImmediate?
 * @param taskID BOSS taskID.
 */
Result bossStartBgImmediate(const(char)* taskID);

/**
 * @brief Deletes a task by using CancelTask and UnregisterTask internally.
 * @param taskID BOSS taskID.
 * @param unk Unknown, usually zero?
 */
Result bossDeleteTask(const(char)* taskID, uint unk);

/**
 * @brief Returns task state.
 * @param taskID BOSS taskID.
 * @param inval Unknown, normally 0?
 * @param status Output status, see bossTaskStatus.
 * @param out1 Output field.
 * @param out2 Output field.
 */
Result bossGetTaskState(const(char)* taskID, byte inval, ubyte* status, uint* out1, ubyte* out2);

/**
 * @brief This loads the current state of PropertyID 0x0 for the specified task.
 * @param taskID BOSS taskID.
 */
Result bossGetTaskProperty0(const(char)* taskID, ubyte* out_);

/**
 * @brief Setup a BOSS context with the default config.
 * @param bossContext BOSS context.
 * @param seconds_interval Interval in seconds for running the task automatically.
 * @param url Task URL.
 */
void bossSetupContextDefault(bossContext* ctx, uint seconds_interval, const(char)* url);

/**
 * @brief Sends the config stored in the context. Used before registering a task.
 * @param bossContext BOSS context.
 */
Result bossSendContextConfig(bossContext* ctx);
