/**
 * @file news.h
 * @brief NEWS (Notification) service.
 */

module ctru.services.news;

import ctru.types;

extern (C): nothrow: @nogc:

/// Notification header data.
struct NotificationHeader
{
    bool dataSet;
    bool unread;
    bool enableJPEG;
    bool isSpotPass;
    bool isOptedOut;
    ubyte[3] unkData;
    ulong processID;
    ubyte[8] unkData2;
    ulong jumpParam;
    ubyte[8] unkData3;
    ulong time;
    ushort[32] title;
}

/// Initializes NEWS.
Result newsInit();

/// Exits NEWS.
void newsExit();

/**
 * @brief Adds a notification to the home menu Notifications applet.
 * @param title UTF-16 title of the notification.
 * @param titleLength Number of characters in the title, not including the null-terminator.
 * @param message UTF-16 message of the notification, or NULL for no message.
 * @param messageLength Number of characters in the message, not including the null-terminator.
 * @param image Data of the image to show in the notification, or NULL for no image.
 * @param imageSize Size of the image data in bytes.
 * @param jpeg Whether the image is a JPEG or not.
 */
Result NEWS_AddNotification(const(ushort)* title, uint titleLength, const(ushort)* message, uint messageLength, const(void)* imageData, uint imageSize, bool jpeg);

/**
 * @brief Gets current total notifications number.
 * @param num Pointer where total number will be saved.
 */
Result NEWS_GetTotalNotifications(uint* num);

/**
 * @brief Sets a custom header for a specific notification.
 * @param news_id Identification number of the notification.
 * @param header Pointer to notification header to set.
 */
Result NEWS_SetNotificationHeader(uint news_id, const(NotificationHeader)* header);

/**
 * @brief Gets the header of a specific notification.
 * @param news_id Identification number of the notification.
 * @param header Pointer where header of the notification will be saved.
 */
Result NEWS_GetNotificationHeader(uint news_id, NotificationHeader* header);

/**
 * @brief Sets a custom message for a specific notification.
 * @param news_id Identification number of the notification.
 * @param message Pointer to UTF-16 message to set.
 * @param size Size of message to set.
 */
Result NEWS_SetNotificationMessage(uint news_id, const(ushort)* message, uint size);

/**
 * @brief Gets the message of a specific notification.
 * @param news_id Identification number of the notification.
 * @param message Pointer where UTF-16 message of the notification will be saved.
 * @param size Pointer where size of the message data will be saved in bytes.
 */
Result NEWS_GetNotificationMessage(uint news_id, ushort* message, uint* size);

/**
 * @brief Sets a custom image for a specific notification.
 * @param news_id Identification number of the notification.
 * @param buffer Pointer to MPO image to set.
 * @param size Size of the MPO image to set.
 */
Result NEWS_SetNotificationImage(uint news_id, const(void)* buffer, uint size);

/**
 * @brief Gets the image of a specific notification.
 * @param news_id Identification number of the notification.
 * @param buffer Pointer where MPO image of the notification will be saved.
 * @param size Pointer where size of the image data will be saved in bytes.
 */
Result NEWS_GetNotificationImage(uint news_id, void* buffer, uint* size);
