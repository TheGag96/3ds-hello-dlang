module ctru.services.nwmext;

import ctru.types;

extern (C): nothrow: @nogc:

// Initializes NWMEXT.
Result nwmExtInit();

// Exits NWMEXT.
void nwmExtExit();

/**
 * @brief Turns wireless on or off.
 * @param enableWifi True enables it, false disables it.
 */
Result NWMEXT_ControlWirelessEnabled(bool enableWifi);
