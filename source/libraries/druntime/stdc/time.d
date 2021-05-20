/**
 * D header file for C99.
 *
 * $(C_HEADER_DESCRIPTION pubs.opengroup.org/onlinepubs/009695399/basedefs/_time.h.html, _time.h)
 *
 * Copyright: Copyright Sean Kelly 2005 - 2009.
 * License: Distributed under the
 *      $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0).
 *    (See accompanying file LICENSE)
 * Authors:   Sean Kelly,
 *            Alex Rønne Petersen
 * Source:    $(DRUNTIMESRC core/stdc/_time.d)
 * Standards: ISO/IEC 9899:1999 (E)
 */

module core.stdc.time;

version (Posix)
    public import core.sys.posix.stdc.time;
else version (Windows)
    public import core.sys.windows.stdc.time;
else version (_3DS) { }  // defined below
else
    static assert(0, "unsupported system");

import core.stdc.config;

extern (C):
@trusted: // There are only a few functions here that use unsafe C strings.
nothrow:
@nogc:

version (CRuntime_Newlib_3DS)
{
    struct tm
    {
        int         tm_sec;
        int         tm_min;
        int         tm_hour;
        int         tm_mday;
        int         tm_mon;
        int         tm_year;
        int         tm_wday;
        int         tm_yday;
        int         tm_isdst;
        c_long      tm_gmtoff;
        const char* tm_zone;
    }

    alias c_long time_t;
    alias c_long clock_t;

    enum clock_t CLOCKS_PER_SEC = 1_000;
    clock_t clock();
    
    ///
    void tzset();
    ///
    extern __gshared const(char)*[2] tzname;
}

///
pure double  difftime(time_t time1, time_t time0); // MT-Safe
///
@system time_t  mktime(scope tm* timeptr); // @system: MT-Safe env locale
///
time_t  time(scope time_t* timer);

///
@system char*   asctime(const scope tm* timeptr); // @system: MT-Unsafe race:asctime locale
///
@system char*   ctime(const scope time_t* timer); // @system: MT-Unsafe race:tmbuf race:asctime env locale
///
@system tm*     gmtime(const scope time_t* timer); // @system: MT-Unsafe race:tmbuf env locale
///
@system tm*     localtime(const scope time_t* timer); // @system: MT-Unsafe race:tmbuf env locale
///
@system size_t  strftime(scope char* s, size_t maxsize, const scope char* format, const scope tm* timeptr); // @system: MT-Safe env locale
