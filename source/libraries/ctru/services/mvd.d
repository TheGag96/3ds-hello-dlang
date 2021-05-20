/**
 * @file mvd.h
 * @brief MVD service.
 */

module ctru.services.mvd;

import ctru.types;

extern (C): nothrow: @nogc:

//New3DS-only, see also: http://3dbrew.org/wiki/MVD_Services

///These values are the data returned as "result-codes" by MVDSTD.
enum MVD_STATUS_OK                   = 0x17000;
enum MVD_STATUS_PARAMSET             = 0x17001; ///"Returned after processing NAL-unit parameter-sets."
enum MVD_STATUS_BUSY                 = 0x17002;
enum MVD_STATUS_FRAMEREADY           = 0x17003;
enum MVD_STATUS_INCOMPLETEPROCESSING = 0x17004; ///"Returned when not all of the input NAL-unit buffer was processed."
enum MVD_STATUS_NALUPROCFLAG         = 0x17007; ///See here: https://www.3dbrew.org/wiki/MVDSTD:ProcessNALUnit

///This can be used to check whether mvdstdProcessVideoFrame() was successful.
extern (D) auto MVD_CHECKNALUPROC_SUCCESS(T)(auto ref T x)
{
    return x == MVD_STATUS_OK || x == MVD_STATUS_PARAMSET || x == MVD_STATUS_FRAMEREADY || x == MVD_STATUS_INCOMPLETEPROCESSING || x == MVD_STATUS_NALUPROCFLAG;
}

/// Default input size for mvdstdInit(). This is what the New3DS Internet Browser uses, from the MVDSTD:CalculateWorkBufSize output.
enum MVD_DEFAULT_WORKBUF_SIZE = 0x9006C8;

/// Processing mode.
enum MVDSTDMode : ubyte
{
    color_format_conv = 0, ///< Converting color formats.
    video_processing  = 1  ///< Processing video.
}

/// Input format.
enum MVDSTDInputFormat : uint
{
    yuyv422 = 0x00010001, ///< YUYV422
    h264    = 0x00020001  ///< H264
}

/// Output format.
enum MVDSTDOutputFormat : uint
{
    yuyv422 = 0x00010001, ///< YUYV422
    bgr565  = 0x00040002, ///< BGR565
    rgb565  = 0x00040004  ///< RGB565
}

/// Processing configuration.
struct MVDSTD_Config
{
    MVDSTDInputFormat input_type; ///< Input type.
    uint unk_x04; ///< Unknown.
    uint unk_x08; ///< Unknown. Referred to as "H264 range" in SKATER.
    uint inwidth; ///< Input width.
    uint inheight; ///< Input height.
    uint physaddr_colorconv_indata; ///< Physical address of color conversion input data.
    uint physaddr_colorconv_unk0; ///< Physical address used with color conversion.
    uint physaddr_colorconv_unk1; ///< Physical address used with color conversion.
    uint physaddr_colorconv_unk2; ///< Physical address used with color conversion.
    uint physaddr_colorconv_unk3; ///< Physical address used with color conversion.
    uint[6] unk_x28; ///< Unknown.
    uint enable_cropping; ///< Enables cropping with the input image when non-zero via the following 4 words.
    uint input_crop_x_pos;
    uint input_crop_y_pos;
    uint input_crop_height;
    uint input_crop_width;
    uint unk_x54; ///< Unknown.
    MVDSTDOutputFormat output_type; ///< Output type.
    uint outwidth; ///< Output width.
    uint outheight; ///< Output height.
    uint physaddr_outdata0; ///< Physical address of output data.
    uint physaddr_outdata1; ///< Additional physical address for output data, only used when the output format type is value 0x00020001.
    uint[38] unk_x6c; ///< Unknown.
    uint flag_x104; ///< This enables using the following 4 words when non-zero.
    uint output_x_pos; ///< Output X position in the output buffer.
    uint output_y_pos; ///< Same as above except for the Y pos.
    uint output_width_override; ///< Used for aligning the output width when larger than the output width. Overrides the output width when smaller than the output width.
    uint output_height_override; ///< Same as output_width_override except for the output height.
    uint unk_x118;
}

struct MVDSTD_ProcessNALUnitOut
{
    uint end_vaddr; //"End-address of the processed NAL-unit(internal MVD heap vaddr)."
    uint end_physaddr; //"End-address of the processed NAL-unit(physaddr following the input physaddr)."
    uint remaining_size; //"Total remaining unprocessed input data. Buffer_end_pos=bufsize-<this value>."
}

struct MVDSTD_OutputBuffersEntry
{
    void* outdata0; //Linearmem vaddr equivalent to config *_outdata0.
    void* outdata1; //Linearmem vaddr equivalent to config *_outdata1.
}

struct MVDSTD_OutputBuffersEntryList
{
    uint total_entries; //Total actual used entries below.
    MVDSTD_OutputBuffersEntry[17] entries;
}

/// This can be used to override the default input values for MVDSTD commands during initialization with video-processing. The default for these fields are all-zero, except for cmd1b_inval which is 1. See also here: https://www.3dbrew.org/wiki/MVD_Services
struct MVDSTD_InitStruct
{
    byte cmd5_inval0;
    byte cmd5_inval1;
    byte cmd5_inval2;
    uint cmd5_inval3;

    ubyte cmd1b_inval;
}

/**
 * @brief Initializes MVDSTD.
 * @param mode Mode to initialize MVDSTD to.
 * @param input_type Type of input to process.
 * @param output_type Type of output to produce.
 * @param size Size of the work buffer, MVD_DEFAULT_WORKBUF_SIZE can be used for this. Only used when type == MVDMODE_VIDEOPROCESSING.
 * @param initstruct Optional MVDSTD_InitStruct, this should be NULL normally.
 */
Result mvdstdInit(MVDSTDMode mode, MVDSTDInputFormat input_type, MVDSTDOutputFormat output_type, uint size, MVDSTD_InitStruct* initstruct);

/// Shuts down MVDSTD.
void mvdstdExit();

/**
 * @brief Generates a default MVDSTD configuration.
 * @param config Pointer to output the generated config to.
 * @param input_width Input width.
 * @param input_height Input height.
 * @param output_width Output width.
 * @param output_height Output height.
 * @param vaddr_colorconv_indata Virtual address of the color conversion input data.
 * @param vaddr_outdata0 Virtual address of the output data.
 * @param vaddr_outdata1 Additional virtual address for output data, only used when the output format type is value 0x00020001.
 */
void mvdstdGenerateDefaultConfig(MVDSTD_Config* config, uint input_width, uint input_height, uint output_width, uint output_height, uint* vaddr_colorconv_indata, uint* vaddr_outdata0, uint* vaddr_outdata1);

/**
 * @brief Run color-format-conversion.
 * @param config Pointer to the configuration to use.
 */
Result mvdstdConvertImage(MVDSTD_Config* config);

/**
 * @brief Processes a video frame(specifically a NAL-unit).
 * @param inbuf_vaddr Input NAL-unit starting with the 3-byte "00 00 01" prefix. Must be located in linearmem.
 * @param size Size of the input buffer.
 * @param flag See here regarding this input flag: https://www.3dbrew.org/wiki/MVDSTD:ProcessNALUnit
 * @param out Optional output MVDSTD_ProcessNALUnitOut structure.
 */
Result mvdstdProcessVideoFrame(void* inbuf_vaddr, size_t size, uint flag, MVDSTD_ProcessNALUnitOut* out_);

/**
 * @brief Renders the video frame.
 * @param config Optional pointer to the configuration to use. When NULL, MVDSTD_SetConfig() should have been used previously for this video.
 * @param wait When true, wait for rendering to finish. When false, you can manually call this function repeatedly until it stops returning MVD_STATUS_BUSY.
 */
Result mvdstdRenderVideoFrame(MVDSTD_Config* config, bool wait);

/**
 * @brief Sets the current configuration of MVDSTD.
 * @param config Pointer to the configuration to set.
 */
Result MVDSTD_SetConfig(MVDSTD_Config* config);

/**
 * @brief New3DS Internet Browser doesn't use this. Once done, rendered frames will be written to the output buffers specified by the entrylist instead of the output specified by configuration. See here: https://www.3dbrew.org/wiki/MVDSTD:SetupOutputBuffers
 * @param entrylist Input entrylist.
 * @param bufsize Size of each buffer from the entrylist.
 */
Result mvdstdSetupOutputBuffers(MVDSTD_OutputBuffersEntryList* entrylist, uint bufsize);

/**
 * @brief New3DS Internet Browser doesn't use this. This overrides the entry0 output buffers originally setup by mvdstdSetupOutputBuffers(). See also here: https://www.3dbrew.org/wiki/MVDSTD:OverrideOutputBuffers
 * @param cur_outdata0 Linearmem vaddr. The current outdata0 for this entry must match this value.
 * @param cur_outdata1 Linearmem vaddr. The current outdata1 for this entry must match this value.
 * @param new_outdata0 Linearmem vaddr. This is the new address to use for outaddr0.
 * @param new_outdata1 Linearmem vaddr. This is the new address to use for outaddr1.
 */
Result mvdstdOverrideOutputBuffers(void* cur_outdata0, void* cur_outdata1, void* new_outdata0, void* new_outdata1);
