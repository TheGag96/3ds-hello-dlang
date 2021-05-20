/**
 * @file frd.h
 * @brief Friend Services
 */

module ctru.services.frd;

import ctru.types;
import ctru.mii;

extern (C): nothrow: @nogc:

enum FRIEND_SCREEN_NAME_SIZE = 0xB;  ///< 11-byte UTF-16 screen name
enum FRIEND_COMMENT_SIZE     = 0x21; ///< 33-byte UTF-16 comment
enum FRIEND_LIST_SIZE        = 0x64; ///< 100 (Max number of friends)

/// Friend key data
struct FriendKey
{
    uint principalId;
    uint padding;
    ulong localFriendCode;
}

/// Friend Title data
struct TitleData
{
    ulong tid;
    uint version_;
    uint unk;
}

/// Friend profile data
struct FriendProfile
{
    ubyte region; ///< The region code for the hardware.
    ubyte country; ///< Country code.
    ubyte area; ///< Area code.
    ubyte language; ///< Language code.
    ubyte platform; ///< Platform code.
    uint padding;
}

/// Game Description structure
struct GameDescription
{
    TitleData data;
    ushort[128] desc;
}

/// Friend Notification Event structure
struct NotificationEvent
{
    ubyte type;
    ubyte[3] padding3;
    uint padding;
    FriendKey key;
}

/// Enum to use with FRD_GetNotificationEvent
enum NotificationTypes : ubyte
{
    user_went_online        = 1, ///< Self went online
    user_went_offline       = 2, ///< Self went offline
    friend_went_online      = 3, ///< Friend Went Online
    friend_updated_presence = 4, ///< Friend Presence changed
    friend_updated_mii      = 5, ///< Friend Mii changed
    friend_updated_profile  = 6, ///< Friend Profile changed
    friend_went_offline     = 7, ///< Friend went offline
    friend_registered_user  = 8, ///< Friend registered self as friend
    friend_sent_invitation  = 9  ///< Friend Sent invitation
}

/// Initializes FRD service.
Result frdInit();

/// Exists FRD.
void frdExit();

/// Get FRD handle.
Handle* frdGetSessionHandle();
/**
 * @brief Gets the login status of the current user.
 * @param state Pointer to write the current user's login status to.
 */
Result FRDU_HasLoggedIn(bool* state);

/**
 * @brief Gets the online status of the current user.
 * @param state Pointer to write the current user's online status to.
 */
Result FRDU_IsOnline(bool* state);

/// Logs out of Nintendo's friend server.
Result FRD_Logout();

/**
 * @brief Log in to Nintendo's friend server.
 * @param event Event to signal when Login is done.
 */
Result FRD_Login(Handle event);

/**
 * @brief Gets the current user's friend key.
 * @param key Pointer to write the current user's friend key to.
 */
Result FRD_GetMyFriendKey(FriendKey* key);

/**
 * @brief Gets the current user's privacy information.
 * @param isPublicMode Determines whether friends are notified of the current user's online status.
 * @param isShowGameName Determines whether friends are notified of the application that the current user is running.
 * @param isShowPlayedGame Determiens whether to display the current user's game history.
 */
Result FRD_GetMyPreference(bool* isPublicMode, bool* isShowGameName, bool* isShowPlayedGame);

/**
 * @brief Gets the current user's profile information.
 * @param profile Pointer to write the current user's profile information to.
 */
Result FRD_GetMyProfile(FriendProfile* profile);

/**
 * @brief Gets the current user's screen name.
 * @param name Pointer to write the current user's screen name to.
 * @param max_size Max size of the screen name.
 */
Result FRD_GetMyScreenName(char* name, size_t max_size);

/**
 * @brief Gets the current user's Mii data.
 * @param mii Pointer to write the current user's mii data to.
 */
Result FRD_GetMyMii(MiiData* mii);

/**
 * @brief Gets the current user's playing game.
 * @param titleId Pointer to write the current user's playing game to.
 */
Result FRD_GetMyPlayingGame(ulong* titleId);

/**
 * @brief Gets the current user's favourite game.
 * @param titleId Pointer to write the title ID of current user's favourite game to.
 */
Result FRD_GetMyFavoriteGame(ulong* titleId);

/**
 * @brief Gets the current user's comment on their friend profile.
 * @param comment Pointer to write the current user's comment to.
 * @param max_size Max size of the comment.
 */
Result FRD_GetMyComment(char* comment, size_t max_size);

/**
 * @brief Gets the current user's friend key list.
 * @param friendKeyList Pointer to write the friend key list to.
 * @param num Stores the number of friend keys obtained.
 * @param offset The index of the friend key to start with.
 * @param size Size of the friend key list. (FRIEND_LIST_SIZE)
 */
Result FRD_GetFriendKeyList(FriendKey* friendKeyList, uint* num, uint offset, uint size);

/**
 * @brief Gets the current user's friends' Mii data.
 * @param miiDataList Pointer to write Mii data to.
 * @param friendKeyList Pointer to FriendKeys.
 * @param size Number of Friendkeys.
 */
Result FRD_GetFriendMii(MiiData* miiDataList, const(FriendKey)* friendKeyList, size_t size);

/**
 * @brief Get the current user's friends' profile data.
 * @param profile Pointer to write profile data to.
 * @param friendKeyList Pointer to FriendKeys.
 * @param size Number of FriendKeys.
 */
Result FRD_GetFriendProfile(FriendProfile* profile, const(FriendKey)* friendKeyList, size_t size);

/**
 * @brief Get the current user's friends' playing game.
 * @param desc Pointer to write Game Description data to.
 * @param friendKeyList Pointer to FriendKeys,
 * @param size Number Of FriendKeys.
 */
Result FRD_GetFriendPlayingGame(GameDescription* desc, const(FriendKey)* friendKeyList, size_t size);

/**
 * @brief Get the current user's friends' favourite game.
 * @param desc Pointer to write Game Description data to.
 * @param friendKeyList Pointer to FriendKeys,
 * @param count Number Of FriendKeys.
 */
Result FRD_GetFriendFavouriteGame(GameDescription* desc, const(FriendKey)* friendKeyList, uint count);

/**
 * @brief Gets whether a friend key is included in the current user's friend list.
 * @param friendKeyList Pointer to a list of friend keys.
 * @param isFromList Pointer to a write the friendship status to.
 */
Result FRD_IsInFriendList(FriendKey* friendKeyList, bool* isFromList);

/**
 * @brief Updates the game mode description string.
 * @param desc Pointer to write the game mode description to.
 */
Result FRD_UpdateGameModeDescription(const(char)* desc);

/**
 * @brief Event which is signaled when friend login states change.
 * @param event event which will be signaled.
 */
Result FRD_AttachToEventNotification(Handle event);

/**
 * @brief Get Latest Event Notification
 * @param event Pointer to write recieved notification event struct to.
 * @param count Number of events
 * @param recievedNotifCount Number of notification reccieved.
 */
Result FRD_GetEventNotification(NotificationEvent* event, uint count, uint* recievedNotifCount);

/**
 * @brief Returns the friend code using the given principal ID.
 * @param principalId The principal ID being used.
 * @param friendCode Pointer to write the friend code to.
 */
Result FRD_PrincipalIdToFriendCode(uint principalId, ulong* friendCode);

/**
 * @brief Returns the principal ID using the given friend code.
 * @param friendCode The friend code being used.
 * @param principalId Pointer to write the principal ID to.
 */
Result FRD_FriendCodeToPrincipalId(ulong friendCode, uint* principalId);

/**
 * @brief Checks if the friend code is valid.
 * @param friendCode The friend code being used.
 * @param isValid Pointer to write the validity of the friend code to.
 */
Result FRD_IsValidFriendCode(ulong friendCode, bool* isValid);

/**
 * @brief Sets the Friend API to use a specific SDK version.
 * @param sdkVer The SDK version needed to be used.
 */
Result FRD_SetClientSdkVersion(uint sdkVer);

/**
 * @brief Add a Friend online.
 * @param event Event signaled when friend is registered.
 * @param principalId PrincipalId of the friend to add.
 */
Result FRD_AddFriendOnline(Handle event, uint principalId);

/**
 * @brief Remove a Friend.
 * @param principalId PrinipalId of the friend code to remove.
 * @param localFriendCode LocalFriendCode of the friend code to remove.
 */
Result FRD_RemoveFriend(uint principalId, ulong localFriendCode);
