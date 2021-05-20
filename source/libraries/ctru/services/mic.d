/**
 * @file mic.h
 * @brief MIC (Microphone) service.
 */

module ctru.services.mic;

import ctru.types;

extern (C): nothrow: @nogc:

/// Microphone audio encodings.
enum MICUEncoding : ubyte
{
    pcm8         = 0, ///< Unsigned 8-bit PCM.
    pcm16        = 1, ///< Unsigned 16-bit PCM.
    pcm8_signed  = 2, ///< Signed 8-bit PCM.
    pcm16_signed = 3  ///< Signed 16-bit PCM.
}

/// Microphone audio sampling rates.
enum MICUSampleRate : ubyte
{
    hz_32730 = 0, ///< 32728.498 Hz
    hz_16360 = 1, ///< 16364.479 Hz
    hz_10910 = 2, ///< 10909.499 Hz
    hz_8180  = 3  ///< 8182.1245 Hz
}

/**
 * @brief Initializes MIC.
 * @param size Shared memory buffer to write audio data to. Must be aligned to 0x1000 bytes.
 * @param handle Size of the shared memory buffer.
 */
Result micInit(ubyte* buffer, uint bufferSize);

/// Exits MIC.
void micExit();

/**
 * @brief Gets the size of the sample data area within the shared memory buffer.
 * @return The sample data's size.
 */
uint micGetSampleDataSize();

/**
 * @brief Gets the offset within the shared memory buffer of the last sample written.
 * @return The last sample's offset.
 */
uint micGetLastSampleOffset();

/**
 * @brief Maps MIC shared memory.
 * @param size Size of the shared memory.
 * @param handle Handle of the shared memory.
 */
Result MICU_MapSharedMem(uint size, Handle handle);

/// Unmaps MIC shared memory.
Result MICU_UnmapSharedMem();

/**
 * @brief Begins sampling microphone input.
 * @param encoding Encoding of outputted audio.
 * @param sampleRate Sample rate of outputted audio.
 * @param sharedMemAudioOffset Offset to write audio data to in the shared memory buffer.
 * @param sharedMemAudioSize Size of audio data to write to the shared memory buffer. This should be at most "bufferSize - 4".
 * @param loop Whether to loop back to the beginning of the buffer when the end is reached.
 */
Result MICU_StartSampling(MICUEncoding encoding, MICUSampleRate sampleRate, uint offset, uint size, bool loop);

/**
 * @brief Adjusts the configuration of the current sampling session.
 * @param sampleRate Sample rate of outputted audio.
 */
Result MICU_AdjustSampling(MICUSampleRate sampleRate);

/// Stops sampling microphone input.
Result MICU_StopSampling();

/**
 * @brief Gets whether microphone input is currently being sampled.
 * @param sampling Pointer to output the sampling state to.
 */
Result MICU_IsSampling(bool* sampling);

/**
 * @brief Gets an event handle triggered when the shared memory buffer is full.
 * @param handle Pointer to output the event handle to.
 */
Result MICU_GetEventHandle(Handle* handle);

/**
 * @brief Sets the microphone's gain.
 * @param gain Gain to set.
 */
Result MICU_SetGain(ubyte gain);

/**
 * @brief Gets the microphone's gain.
 * @param gain Pointer to output the current gain to.
 */
Result MICU_GetGain(ubyte* gain);

/**
 * @brief Sets whether the microphone is powered on.
 * @param power Whether the microphone is powered on.
 */
Result MICU_SetPower(bool power);

/**
 * @brief Gets whether the microphone is powered on.
 * @param power Pointer to output the power state to.
 */
Result MICU_GetPower(bool* power);

/**
 * @brief Sets whether to clamp microphone input.
 * @param clamp Whether to clamp microphone input.
 */
Result MICU_SetClamp(bool clamp);

/**
 * @brief Gets whether to clamp microphone input.
 * @param clamp Pointer to output the clamp state to.
 */
Result MICU_GetClamp(bool* clamp);

/**
 * @brief Sets whether to allow sampling when the shell is closed.
 * @param allowShellClosed Whether to allow sampling when the shell is closed.
 */
Result MICU_SetAllowShellClosed(bool allowShellClosed);
