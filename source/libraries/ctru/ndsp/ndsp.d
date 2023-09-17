/**
 * @file ndsp.h
 * @brief Interface for Nintendo's default DSP component.
 */

module ctru.ndsp.ndsp;

import ctru.types;
import ctru.os;

extern (C): nothrow: @nogc:

enum NDSP_SAMPLE_RATE = SYSCLOCK_SOC / 512.0;

///@name Data types
///@{
/// Sound output modes.
enum NDSPOutputMode : ubyte
{
    mono     = 0, ///< Mono sound
    stereo   = 1, ///< Stereo sound
    surround = 2  ///< 3D Surround sound
}

// Clipping modes.
enum NDSPClippingMode : ubyte
{
    normal = 0, ///< "Normal" clipping mode (?)
    soft   = 1  ///< "Soft" clipping mode (?)
}

// Surround speaker positions.
enum NDSPSpeakerPos : ubyte
{
    square = 0, ///< ?
    wide   = 1, ///< ?
    num    = 2  ///< ?
}

/// ADPCM data.
struct ndspAdpcmData
{
    ushort index; ///< Current predictor index
    short history0; ///< Last outputted PCM16 sample.
    short history1; ///< Second to last outputted PCM16 sample.
}

/// Wave buffer type.
alias ndspWaveBuf = tag_ndspWaveBuf;

/// Wave buffer status.
enum
{
    NDSP_WBUF_FREE = 0, ///< The wave buffer is not queued.
    NDSP_WBUF_QUEUED = 1, ///< The wave buffer is queued and has not been played yet.
    NDSP_WBUF_PLAYING = 2, ///< The wave buffer is playing right now.
    NDSP_WBUF_DONE = 3 ///< The wave buffer has finished being played.
}

/// Wave buffer struct.
struct tag_ndspWaveBuf
{
    union
    {
        byte* data_pcm8; ///< Pointer to PCM8 sample data.
        short* data_pcm16; ///< Pointer to PCM16 sample data.
        ubyte* data_adpcm; ///< Pointer to DSPADPCM sample data.
        const(void)* data_vaddr; ///< Data virtual address.
    }

    uint nsamples; ///< Total number of samples (PCM8=bytes, PCM16=halfwords, DSPADPCM=nibbles without frame headers)
    ndspAdpcmData* adpcm_data; ///< ADPCM data.

    uint offset; ///< Buffer offset. Only used for capture.
    bool looping; ///< Whether to loop the buffer.
    ubyte status; ///< Queuing/playback status.

    ushort sequence_id; ///< Sequence ID. Assigned automatically by ndspChnWaveBufAdd.
    ndspWaveBuf* next; ///< Next buffer to play. Used internally, do not modify.
}

/// Sound frame callback function. (data = User provided data)
alias ndspCallback = void function (void* data);
/// Auxiliary output callback function. (data = User provided data, nsamples = Number of samples, samples = Sample data)
alias ndspAuxCallback = void function (void* data, int nsamples, void*[4] samples);
///@}

///@name Initialization and basic operations
///@{
/**
 * @brief Sets up the DSP component.
 * @param binary DSP binary to load.
 * @param size Size of the DSP binary.
 * @param progMask Program RAM block mask to load the binary to.
 * @param dataMask Data RAM block mask to load the binary to.
 */
void ndspUseComponent(const(void)* binary, uint size, ushort progMask, ushort dataMask);

/// Initializes NDSP.
Result ndspInit ();

/// Exits NDSP.
void ndspExit ();

/**
 * @brief Gets the number of dropped sound frames.
 * @return The number of dropped sound frames.
 */
uint ndspGetDroppedFrames ();

/**
 * @brief Gets the total sound frame count.
 * @return The total sound frame count.
 */
uint ndspGetFrameCount ();
///@}

///@name General parameters
///@{
/**
 * @brief Sets the master volume.
 * @param volume Volume to set. Defaults to 1.0f.
 */
void ndspSetMasterVol(float volume);

/**
 * @brief Gets the master volume.
 * @return The master volume.
 */
float ndspGetMasterVol();

/**
 * @brief Sets the output mode.
 * @param mode Output mode to set. Defaults to NDSP_OUTPUT_STEREO.
 */
void ndspSetOutputMode(NDSPOutputMode mode);

/**
 * @brief Gets the output mode.
 * @return The output mode.
 */
NDSPOutputMode ndspGetOutputMode();

/**
 * @brief Sets the clipping mode.
 * @param mode Clipping mode to set. Defaults to NDSP_CLIP_SOFT.
 */
void ndspSetClippingMode(NDSPClippingMode mode);

/**
 * @brief Gets the clipping mode.
 * @return The clipping mode.
 */
NDSPClippingMode ndspGetClippingMode();

/**
 * @brief Sets the output count.
 * @param count Output count to set. Defaults to 2.
 */
void ndspSetOutputCount(int count);

/**
 * @brief Gets the output count.
 * @return The output count.
 */
int ndspGetOutputCount();

/**
 * @brief Sets the wave buffer to capture audio to.
 * @param capture Wave buffer to capture to.
 */
void ndspSetCapture(ndspWaveBuf* capture);

/**
 * @brief Sets the sound frame callback.
 * @param callback Callback to set.
 * @param data User-defined data to pass to the callback.
 */
void ndspSetCallback(ndspCallback callback, void* data);
///@}

///@name Surround
///@{
/**
 * @brief Sets the surround sound depth.
 * @param depth Depth to set. Defaults to 0x7FFF.
 */
void ndspSurroundSetDepth(ushort depth);

/**
 * @brief Gets the surround sound depth.
 * @return The surround sound depth.
 */
ushort ndspSurroundGetDepth();

/**
 * @brief Sets the surround sound position.
 * @param pos Position to set. Defaults to NDSP_SPKPOS_SQUARE.
 */
void ndspSurroundSetPos(NDSPSpeakerPos pos);

/**
 * @brief Gets the surround sound position.
 * @return The surround sound speaker position.
 */
NDSPSpeakerPos ndspSurroundGetPos();

/**
 * @brief Sets the surround sound rear ratio.
 * @param ratio Rear ratio to set. Defaults to 0x8000.
 */
void ndspSurroundSetRearRatio(ushort ratio);

/**
 * @brief Gets the surround sound rear ratio.
 * @return The rear ratio.
 */
ushort ndspSurroundGetRearRatio();
///@}

///@name Auxiliary output
///@{
/**
 * @brief Configures whether an auxiliary output is enabled.
 * @param id ID of the auxiliary output.
 * @param enable Whether to enable the auxiliary output.
 */
void ndspAuxSetEnable(int id, bool enable);

/**
 * @brief Gets whether auxiliary output is enabled.
 * @param id ID of the auxiliary output.
 * @return Whether auxiliary output is enabled.
 */
bool ndspAuxIsEnabled(int id);

/**
 * @brief Configures whether an auxiliary output should use front bypass.
 * @param id ID of the auxiliary output.
 * @param bypass Whether to use front bypass.
 */
void ndspAuxSetFrontBypass(int id, bool bypass);

/**
 * @brief Gets whether auxiliary output front bypass is enabled.
 * @param id ID of the auxiliary output.
 * @return Whether auxiliary output front bypass is enabled.
 */
bool ndspAuxGetFrontBypass(int id);

/**
 * @brief Sets the volume of an auxiliary output.
 * @param id ID of the auxiliary output.
 * @param volume Volume to set.
 */
void ndspAuxSetVolume(int id, float volume);

/**
 * @brief Gets the volume of an auxiliary output.
 * @param id ID of the auxiliary output.
 * @return Volume of the auxiliary output.
 */
float ndspAuxGetVolume(int id);

/**
 * @brief Sets the callback of an auxiliary output.
 * @param id ID of the auxiliary output.
 * @param callback Callback to set.
 * @param data User-defined data to pass to the callback.
 */
void ndspAuxSetCallback(int id, ndspAuxCallback callback, void* data);
///@}
