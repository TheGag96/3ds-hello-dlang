/**
 * @file nfc.h
 * @brief NFC service. This can only be used with system-version >=9.3.0-X.
 */

module ctru.services.nfc;

import ctru.types;

extern (C): nothrow: @nogc:

/// This is returned when the current state is invalid for this command.
enum NFC_ERR_INVALID_STATE = 0xC8A17600;

/// This is returned by nfcOpenAppData() when the appdata is uninitialized since nfcInitializeWriteAppData() wasn't used previously.
enum NFC_ERR_APPDATA_UNINITIALIZED = 0xC8A17620;

/// This is returned by nfcGetAmiiboSettings() when the amiibo wasn't setup by the amiibo Settings applet.
enum NFC_ERR_AMIIBO_NOTSETUP = 0xC8A17628;

/// This is returned by nfcOpenAppData() when the input AppID doesn't match the actual amiibo AppID.
enum NFC_ERR_APPID_MISMATCH = 0xC8A17638;

/// "Returned for HMAC-hash mismatch(data corruption), with HMAC-calculation input_buffer_size=0x34."
enum NFC_ERR_DATACORRUPTION0 = 0xC8C1760C;

/// HMAC-hash mismatch with input_buffer_size=0x1DF, see here: https://www.3dbrew.org/wiki/Amiibo
enum NFC_ERR_DATACORRUPTION1 = 0xC8A17618;

/// This can be used for nfcStartScanning().
enum NFC_STARTSCAN_DEFAULTINPUT = 0;

/// NFC operation type.
enum NFCOpType : ubyte
{
    unknown = 1, /// Unknown.
    nfc_tag = 2, /// This is the default.
    raw_nfc = 3 /// Use Raw NFC tag commands. Only available with > = 10.0.0-X.
}

enum NFCTagState : ubyte
{
    uninitialized    = 0, /// nfcInit() was not used yet.
    scanning_stopped = 1, /// Not currently scanning for NFC tags. Set by nfcStopScanning() and nfcInit(), when successful.
    scanning         = 2, /// Currently scanning for NFC tags. Set by nfcStartScanning() when successful.
    in_range         = 3, /// NFC tag is in range. The state automatically changes to this when the state was previously value 2, without using any NFC service commands.
    out_of_range     = 4, /// NFC tag is now out of range, where the NFC tag was previously in range. This occurs automatically without using any NFC service commands. Once this state is entered, it won't automatically change to anything else when the tag is moved in range again. Hence, if you want to keep doing tag scanning after this, you must stop+start scanning.
    data_ready       = 5 /// NFC tag data was successfully loaded. This is set by nfcLoadAmiiboData() when successful.
}

/// Bit4-7 are always clear with nfcGetAmiiboSettings() due to "& 0xF".
enum
{
    setup          = BIT(4), /// This indicates that the amiibo was setup with amiibo Settings. nfcGetAmiiboSettings() will return an all-zero struct when this is not set.
    app_data_setup = BIT(5) /// This indicates that the AppData was previously initialized via nfcInitializeWriteAppData(), that function can't be used again with this flag already set.
}

struct NFC_TagInfo
{
    ushort id_offset_size; /// "u16 size/offset of the below ID data. Normally this is 0x7. When this is <=10, this field is the size of the below ID data. When this is >10, this is the offset of the 10-byte ID data, relative to structstart+4+<offsetfield-10>. It's unknown in what cases this 10-byte ID data is used."
    ubyte unk_x2; //"Unknown u8, normally 0x0."
    ubyte unk_x3; //"Unknown u8, normally 0x2."
    ubyte[0x28] id; //"ID data. When the above size field is 0x7, this is the 7-byte NFC tag UID, followed by all-zeros."
}

/// AmiiboSettings structure, see also here: https://3dbrew.org/wiki/NFC:GetAmiiboSettings
struct NFC_AmiiboSettings
{
    ubyte[0x60] mii; /// "Owner Mii."
    ushort[11] nickname; /// "UTF-16BE Amiibo nickname."
    ubyte flags; /// "This is plaintext_amiibosettingsdata[0] & 0xF." See also the NFC_amiiboFlag enums.
    ubyte countrycodeid; /// "This is plaintext_amiibosettingsdata[1]." "Country Code ID, from the system which setup this amiibo."
    ushort setupdate_year;
    ubyte setupdate_month;
    ubyte setupdate_day;
    ubyte[0x2c] unk_x7c; //Normally all-zero?
}

/// AmiiboConfig structure, see also here: https://3dbrew.org/wiki/NFC:GetAmiiboConfig
struct NFC_AmiiboConfig
{
    ushort lastwritedate_year;
    ubyte lastwritedate_month;
    ubyte lastwritedate_day;
    ushort write_counter;
    ubyte[3] characterID; /// the first element is the collection ID, the second the character in this collection, the third the variant
    ubyte series; /// ID of the series
    ushort amiiboID; /// ID shared by all exact same amiibo. Some amiibo are only distinguished by this one like regular SMB Series Mario and the gold one
    ubyte type; /// Type of amiibo 0 = figure, 1 = card, 2 = plush
    ubyte pagex4_byte3;
    ushort appdata_size; /// "NFC module writes hard-coded u8 value 0xD8 here. This is the size of the Amiibo AppData, apps can use this with the AppData R/W commands. ..."
    ubyte[0x30] zeros; /// "Unused / reserved: this is cleared by NFC module but never written after that."
}

/// Used by nfcInitializeWriteAppData() internally, see also here: https://3dbrew.org/wiki/NFC:GetAppDataInitStruct
struct NFC_AppDataInitStruct
{
    ubyte[0xC] data_x0;
    ubyte[0x30] data_xc; /// "The data starting at struct offset 0xC is the 0x30-byte struct used by NFC:InitializeWriteAppData, sent by the user-process."
}

/// Used by nfcWriteAppData() internally, see also: https://3dbrew.org/wiki/NFC:WriteAppData
struct NFC_AppDataWriteStruct
{
    ubyte[10] id; //7-byte UID normally.
    ubyte id_size;
    ubyte[0x15] unused_xb;
}

/**
 * @brief Initializes NFC.
 * @param type See the NFCOpType enum.
 */
Result nfcInit(NFCOpType type);

/**
 * @brief Shuts down NFC.
 */
void nfcExit();

/**
 * @brief Gets the NFC service handle.
 * @return The NFC service handle.
 */
Handle nfcGetSessionHandle();

/**
 * @brief Starts scanning for NFC tags.
 * @param inval Unknown. See NFC_STARTSCAN_DEFAULTINPUT.
 */
Result nfcStartScanning(ushort inval);

/**
 * @brief Stops scanning for NFC tags.
 */
void nfcStopScanning();

/**
 * @brief Read amiibo NFC data and load in memory.
 */
Result nfcLoadAmiiboData();

/**
 * @brief If the tagstate is valid(NFC_TagState_DataReady or 6), it then sets the current tagstate to NFC_TagState_InRange.
 */
Result nfcResetTagScanState();

/**
 * @brief This writes the amiibo data stored in memory to the actual amiibo data storage(which is normally the NFC data pages). This can only be used if NFC_LoadAmiiboData() was used previously.
 */
Result nfcUpdateStoredAmiiboData();

/**
 * @brief Returns the current NFC tag state.
 * @param state Pointer to write NFC tag state.
 */
Result nfcGetTagState(NFCTagState* state);

/**
 * @brief Returns the current TagInfo.
 * @param out Pointer to write the output TagInfo.
 */
Result nfcGetTagInfo(NFC_TagInfo* out_);

/**
 * @brief Opens the appdata, when the amiibo appdata was previously initialized. This must be used before reading/writing the appdata. See also: https://3dbrew.org/wiki/NFC:OpenAppData
 * @param amiibo_appid Amiibo AppID. See here: https://www.3dbrew.org/wiki/Amiibo
 */
Result nfcOpenAppData(uint amiibo_appid);

/**
 * @brief This initializes the appdata using the specified input, when the appdata previously wasn't initialized. If the appdata is already initialized, you must first use the amiibo Settings applet menu option labeled "Delete amiibo Game Data". This automatically writes the amiibo data into the actual data storage(normally NFC data pages). See also nfcWriteAppData().
 * @param amiibo_appid amiibo AppID. See also nfcOpenAppData().
 * @param buf Input buffer.
 * @param size Buffer size.
 */
Result nfcInitializeWriteAppData(uint amiibo_appid, const(void)* buf, size_t size);

/**
 * @brief Reads the appdata. The size must be >=0xD8-bytes, but the actual used size is hard-coded to 0xD8. Note that areas of appdata which were never written to by applications are uninitialized in this output buffer.
 * @param buf Output buffer.
 * @param size Buffer size.
 */
Result nfcReadAppData(void* buf, size_t size);

/**
 * @brief Writes the appdata, after nfcOpenAppData() was used successfully. The size should be <=0xD8-bytes. See also: https://3dbrew.org/wiki/NFC:WriteAppData
 * @param buf Input buffer.
 * @param size Buffer size.
 * @param taginfo TagInfo from nfcGetTagInfo().
 */
Result nfcWriteAppData(const(void)* buf, size_t size, NFC_TagInfo* taginfo);

/**
 * @brief Returns the current AmiiboSettings.
 * @param out Pointer to write the output AmiiboSettings.
 */
Result nfcGetAmiiboSettings(NFC_AmiiboSettings* out_);

/**
 * @brief Returns the current AmiiboConfig.
 * @param out Pointer to write the output AmiiboConfig.
 */
Result nfcGetAmiiboConfig(NFC_AmiiboConfig* out_);

/**
 * @brief Starts scanning for NFC tags when initialized with NFC_OpType_RawNFC. See also: https://www.3dbrew.org/wiki/NFC:StartOtherTagScanning
 * @param unk0 Same as nfcStartScanning() input.
 * @param unk1 Unknown.
 */
Result nfcStartOtherTagScanning(ushort unk0, uint unk1);

/**
 * @brief This sends a raw NFC command to the tag. This can only be used when initialized with NFC_OpType_RawNFC, and when the TagState is NFC_TagState_InRange. See also: https://www.3dbrew.org/wiki/NFC:SendTagCommand
 * @param inbuf Input buffer.
 * @param insize Size of the input buffer.
 * @param outbuf Output buffer.
 * @param outsize Size of the output buffer.
 * @param actual_transfer_size Optional output ptr to write the actual output-size to, can be NULL.
 * @param microseconds Timing-related field in microseconds.
 */
Result nfcSendTagCommand(const(void)* inbuf, size_t insize, void* outbuf, size_t outsize, size_t* actual_transfer_size, ulong microseconds);

/**
 * @brief Unknown. This can only be used when initialized with NFC_OpType_RawNFC, and when the TagState is NFC_TagState_InRange.
 */
Result nfcCmd21();

/**
 * @brief Unknown. This can only be used when initialized with NFC_OpType_RawNFC, and when the TagState is NFC_TagState_InRange.
 */
Result nfcCmd22();
