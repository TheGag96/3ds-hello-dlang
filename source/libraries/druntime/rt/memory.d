/**
 * Helper functions for memory management.
 *
 * Copyright: © 2015-2018, Dan Printzell
 * License: $(LINK2 https://www.mozilla.org/en-US/MPL/2.0/, Mozilla Public License Version 2.0)
 *  (See accompanying file LICENSE)
 * Authors: $(LINK2 https://vild.io/, Dan Printzell)
 */
module rt.memory;

extern (C): @nogc:

pure void* memset(return void* s, int c, size_t n) @trusted nothrow;

pure void* memcpy(return void* s1, scope const void* s2, size_t n) @trusted nothrow;

pure void* memmove(return void* s1, scope const void* s2, size_t n) @trusted nothrow;

pure int memcmp(scope const void* s1, scope const void* s2, size_t n) @trusted nothrow;