/**
 * @file ps.h
 * @brief PS service.
 */

module ctru.services.ps;

import ctru.types;

extern (C): nothrow: @nogc:

/// PS AES algorithms.
enum PSAESAlgorithm : ubyte
{
    cbc_enc = 0, ///< CBC encryption.
    cbc_dec = 1, ///< CBC decryption.
    ctr_enc = 2, ///< CTR encryption.
    ctr_dec = 3, ///< CTR decryption(same as ctr_enc).
    ccm_enc = 4, ///< CCM encryption.
    ccm_dec = 5  ///< CCM decryption.
}

/// PS key slots.
enum PSAESKeyType : ubyte
{
    slot_0d     = 0, ///< Key slot 0x0D.
    slot_2d     = 1, ///< Key slot 0x2D.
    slot_31     = 2, ///< Key slot 0x31.
    slot_38     = 3, ///< Key slot 0x38.
    slot_32     = 4, ///< Key slot 0x32.
    slot_39_dlp = 5, ///< Key slot 0x39. (DLP)
    slot_2e     = 6, ///< Key slot 0x2E.
    invalid     = 7, ///< Invalid key slot.
    slot_36     = 8, ///< Key slot 0x36.
    slot_39_nfc = 9  ///< Key slot 0x39. (NFC)
}

/// RSA context.
struct psRSAContext
{
    ubyte[0x100] modulo;
    ubyte[0x100] exponent;
    uint rsa_bitsize; //The signature byte size is rsa_bitsize>>3.
    uint unk; //Normally zero?
}

/// Initializes PS.
Result psInit();

/**
 * @brief Initializes PS with the specified session handle.
 * @param handle Session handle.
 */
Result psInitHandle(Handle handle);

/// Exits PS.
void psExit();

/// Returns the PS session handle.
Handle psGetSessionHandle();

/**
 * @brief Signs a RSA signature.
 * @param hash SHA256 hash to sign.
 * @param ctx RSA context.
 * @param signature RSA signature.
 */
Result PS_SignRsaSha256(ubyte* hash, psRSAContext* ctx, ubyte* signature);

/**
 * @brief Verifies a RSA signature.
 * @param hash SHA256 hash to compare with.
 * @param ctx RSA context.
 * @param signature RSA signature.
 */
Result PS_VerifyRsaSha256(ubyte* hash, psRSAContext* ctx, ubyte* signature);

/**
 * @brief Encrypts/Decrypts AES data. Does not support AES CCM.
 * @param size Size of the data.
 * @param in Input buffer.
 * @param out Output buffer.
 * @param aes_algo AES algorithm to use.
 * @param key_type Key type to use.
 * @param iv Pointer to the CTR/IV. The output CTR/IV is also written here.
 */
Result PS_EncryptDecryptAes(uint size, ubyte* in_, ubyte* out_, PSAESAlgorithm aes_algo, PSAESKeyType key_type, ubyte* iv);

/**
 * @brief Encrypts/Decrypts signed AES CCM data.
 * When decrypting, if the MAC is invalid, 0xC9010401 is returned. After encrypting the MAC is located at inputbufptr.
 * @param in Input buffer.
 * @param in_size Size of the input buffer. Must include MAC size when decrypting.
 * @param out Output buffer.
 * @param out_size Size of the output buffer. Must include MAC size when encrypting.
 * @param data_len Length of the data to be encrypted/decrypted.
 * @param mac_data_len Length of the MAC data.
 * @param mac_len Length of the MAC.
 * @param aes_algo AES algorithm to use.
 * @param key_type Key type to use.
 * @param nonce Pointer to the nonce.
 */
Result PS_EncryptSignDecryptVerifyAesCcm(ubyte* in_, uint in_size, ubyte* out_, uint out_size, uint data_len, uint mac_data_len, uint mac_len, PSAESAlgorithm aes_algo, PSAESKeyType key_type, ubyte* nonce);

/**
 * @brief Gets the 64-bit console friend code seed.
 * @param seed Pointer to write the friend code seed to.
 */
Result PS_GetLocalFriendCodeSeed(ulong* seed);

/**
 * @brief Gets the 32-bit device ID.
 * @param device_id Pointer to write the device ID to.
 */
Result PS_GetDeviceId(uint* device_id);

/**
 * @brief Generates cryptographically secure random bytes.
 * @param out Pointer to the buffer to write the bytes to.
 * @param len Number of bytes to write.
 */
Result PS_GenerateRandomBytes(void* out_, size_t len);
