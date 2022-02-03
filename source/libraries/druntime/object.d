// Basic 3DS runtime
// Based on the PowerNexOS runtime, which is based on the object.d in druntime
// Distributed under the Boost Software License, Version 1.0.
// (See accompanying file BOOST-LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

module object;

nothrow: @nogc:

alias size_t = typeof(int.sizeof);
alias ptrdiff_t = typeof(cast(void*)0 - cast(void*)0);

alias sizediff_t = ptrdiff_t; // For backwards compatibility only.
alias noreturn = typeof(*null);  /// bottom type

alias hash_t = size_t; // For backwards compatibility only.
alias equals_t = bool; // For backwards compatibility only.

alias string  = immutable(char)[];
alias wstring = immutable(wchar)[];
alias dstring = immutable(dchar)[];

class Object {
  string toString() { return ""; }

  size_t toHash() @trusted nothrow {
    // BUG: this prevents a compacting GC from working, needs to be fixed
    size_t addr = cast(size_t) cast(void*) this;
    // The bottom log2((void*).alignof) bits of the address will always
    // be 0. Moreover it is likely that each Object is allocated with a
    // separate call to malloc. The alignment of malloc differs from
    // platform to platform, but rather than having special cases for
    // each platform it is safe to use a shift of 4. To minimize
    // collisions in the low bits it is more important for the shift to
    // not be too small than for the shift to not be too big.
    return addr ^ (addr >>> 4);
  }

  int opComp(Object o) {
    return this !is o;
  }

  bool opEquals(Object o) {
    return this is o;
  }

  interface Monitor {
    void lock();
    void unlock();
  }

  static Object factory(string classname) {
    return null;
  }
}

class Throwable { }
class Exception : Throwable { }
class Error     : Throwable { }

class TypeInfo { }

// lhs == rhs lowers to __equals(lhs, rhs) for dynamic arrays
bool __equals(T1, T2)(T1[] lhs, T2[] rhs) {
  import core.internal.traits : Unqual;
  alias U1 = Unqual!T1;
  alias U2 = Unqual!T2;

  static @trusted ref R at(R)(R[] r, size_t i) { return r.ptr[i]; }
  static @trusted R trustedCast(R, S)(S[] r) { return cast(R) r; }

  if (lhs.length != rhs.length)
    return false;

  if (lhs.length == 0 && rhs.length == 0)
    return true;

  static if (is(U1 == void) && is(U2 == void)) {
    return __equals(trustedCast!(ubyte[])(lhs), trustedCast!(ubyte[])(rhs));
  }
  else static if (is(U1 == void)) {
    return __equals(trustedCast!(ubyte[])(lhs), rhs);
  }
  else static if (is(U2 == void)) {
    return __equals(lhs, trustedCast!(ubyte[])(rhs));
  }
  else static if (!is(U1 == U2)) {
    // This should replace src/object.d _ArrayEq which
    // compares arrays of different types such as long & int,
    // char & wchar.
    // Compiler lowers to __ArrayEq in dmd/src/opover.d
    foreach (const u; 0 .. lhs.length) {
      if (at(lhs, u) != at(rhs, u))
        return false;
    }
    return true;
  }
  else static if (__traits(isIntegral, U1)) {
    if (!__ctfe) {
      import core.stdc.string : memcmp;
      return () @trusted { return memcmp(cast(void*)lhs.ptr, cast(void*)rhs.ptr, lhs.length * U1.sizeof) == 0; }();
    }
    else {
      foreach (const u; 0 .. lhs.length) {
        if (at(lhs, u) != at(rhs, u))
          return false;
      }
      return true;
    }
  }
  else {
    foreach (const u; 0 .. lhs.length) {
      static if (__traits(compiles, __equals(at(lhs, u), at(rhs, u)))) {
        if (!__equals(at(lhs, u), at(rhs, u)))
          return false;
      }
      else static if (__traits(isFloating, U1)) {
        if (at(lhs, u) != at(rhs, u))
          return false;
      }
      else static if (is(U1 : Object) && is(U2 : Object)) {
        if (!(cast(Object)at(lhs, u) is cast(Object)at(rhs, u)
          || at(lhs, u) && (cast(Object)at(lhs, u)).opEquals(cast(Object)at(rhs, u))))
          return false;
      }
      else static if (__traits(hasMember, U1, "opEquals")) {
        if (!at(lhs, u).opEquals(at(rhs, u)))
          return false;
      }
      else static if (is(U1 == delegate)) {
        if (at(lhs, u) != at(rhs, u))
          return false;
      }
      else static if (is(U1 == U11*, U11)) {
        if (at(lhs, u) != at(rhs, u))
          return false;
      }
      else static if (__traits(isAssociativeArray, U1)) {
        if (at(lhs, u) != at(rhs, u))
          return false;
      }
      else {
        if (at(lhs, u).tupleof != at(rhs, u).tupleof)
          return false;
      }
    }

    return true;
  }
}

void __switch_error()(string file = __FILE__, size_t line = __LINE__) {
  assert(0, "Final switch fallthough! " ~ __PRETTY_FUNCTION__);
}

extern (C) void[] _d_arraycast(uint toTSize, uint fromTSize, void[] a) @trusted {
  //import std.io.log : Log;

  auto len = a.length * fromTSize;
  assert(len % toTSize == 0, "_d_arraycast failed!");

  return a[0 .. len / toTSize];
}

extern (C) void[] _d_arraycopy(size_t size, void[] from, void[] to) @trusted {
  import rt.memory : memmove;

  memmove(to.ptr, from.ptr, from.length * size);
  return to;
}

version (LDC) {
  extern(C) void _d_array_slice_copy(void* dst, size_t dstlen, void* src, size_t srclen, size_t elemsz) @trusted {
    import ldc.intrinsics : llvm_memcpy;
    llvm_memcpy!size_t(dst, src, dstlen * elemsz, 0);
  }
}

static if (false) /* <-- remove to use custom assert handler */ debug {
  private static extern(C) int printf(
    scope const(char*) format, ...
  ) nothrow @nogc;

  private extern(C) bool aptMainLoop()  nothrow @nogc;
  private extern(C) void hidScanInput() nothrow @nogc;
  private extern(C) uint hidKeysDown()  nothrow @nogc;

  private extern(C) void exit(
    int status
  ) nothrow @nogc;

  /**
   * In recent devkitARM updates, one of the things linked in defines __assert for some reason.
   * If you would like to use this custom assert, you have to weaken theirs so that the linker
   * will choose this one like so:
   * sudo $DEVKITARM/bin/arm-none-eabi-objcopy --weaken-symbol=__assert $DEVKITARM/arm-none-eabi/lib/armv6k/fpu/libg.a /opt/devkitpro/devkitARM/arm-none-eabi/lib/armv6k/fpu/libg.a
   **/
  extern (C) void __assert(const char* msg_, const char* file_, int line) @trusted {
    printf("\x1b[1;1HAssert failed in file %s at line %d: %s\x1b[K", file_, line, msg_);

    printf("\n\nPress Start to exit...\n");

    //wait for key press and exit (so we can read the error message)
    while (aptMainLoop()) {
      hidScanInput();

      if ((hidKeysDown() & (1<<3))) {
        exit(0);
      }
    }
  }
}

// From https://github.com/dlang/druntime/commit/96408ecb775f06809314fa3eded3158d60b40e31

// compiler frontend lowers dynamic array comparison to this
extern (C) bool _ArrayEq(T1, T2)(T1[] a1, T2[] a2) {
  if (a1.length != a2.length)
    return false;

  // This is function is used as a compiler intrinsic and explicitly written
  // in a lowered flavor to use as few CTFE instructions as possible.
  size_t idx = 0;
  immutable length = a1.length;

  for(;idx < length;++idx)
  {
    if (a1[idx] != a2[idx])
      return false;
  }
  return true;
}

size_t hashOf(T)(auto ref T arg, size_t seed = 0) {
  import core.internal.hash;
  return core.internal.hash.hashOf(arg, seed);
}

// compiler frontend lowers struct array postblitting to this
extern (C) void __ArrayPostblit(T)(T[] a) {
  foreach (ref T e; a)
    e.__xpostblit();
}

// compiler frontend lowers dynamic array deconstruction to this
extern (C) void __ArrayDtor(T)(T[] a) {
  foreach_reverse (ref T e; a)
    e.__xdtor();
}

// Based on https://github.com/dlang/druntime/commit/2aed1042c633516e236f21b9dd39fd3f472b65bf#diff-a68e58fcf0de5aa198fcaceafe4e8cf9

/**
Used by `__ArrayCast` to emit a descriptive error message.
It is a template so it can be used by `__ArrayCast` in -betterC
builds.  It is separate from `__ArrayCast` to minimize code
bloat.
Params:
    fromType = name of the type being cast from
    fromSize = total size in bytes of the array being cast from
    toType   = name of the type being cast o
    toSize   = total size in bytes of the array being cast to
 */
private void onArrayCastError()(string fromType, size_t fromSize, string toType, size_t toSize) @trusted {
  //printf("\x1b[1;1HonArrayCastError failed: fromType: %s, fromSize: %d, toType: %s, toSize: %d\x1b[K", fromType.ptr, fromSize, toType.ptr, toSize);
  //stderr.writeln("onArrayCastError failed: fromType: ", fromType, ", fromSize: ", fromSize, " toType: ", toType, ", toSize: ", toSize);
  assert(false, "onArrayCastError");
  while (true) { }
}

/**
The compiler lowers expressions of `cast(TTo[])TFrom[]` to
this implementation.
Params:
    from = the array to reinterpret-cast
Returns:
    `from` reinterpreted as `TTo[]`
 */
extern (C) TTo[] __ArrayCast(TFrom, TTo)(TFrom[] from) @nogc pure @trusted {
  const fromSize = from.length * TFrom.sizeof;
  const toLength = fromSize / TTo.sizeof;

  if ((fromSize % TTo.sizeof) != 0)
    onArrayCastError(TFrom.stringof, fromSize, TTo.stringof, toLength * TTo.sizeof);

  struct Array {
    size_t length;
    void* ptr;
  }

  auto a = cast(Array*)&from;
  a.length = toLength; // jam new length
  return *cast(TTo[]*)a;
}

/**
Destroys the given object and optionally resets to initial state. It's used to
_destroy an object, calling its destructor or finalizer so it no longer
references any other objects. It does $(I not) initiate a GC cycle or free
any GC memory.
If `initialize` is supplied `false`, the object is considered invalid after
destruction, and should not be referenced.
*/
void destroy(bool initialize = true, T)(ref T obj) if (is(T == struct))
{
  destructRecurse(obj);

  static if (initialize)
  {
    // We need to re-initialize `obj`.  Previously, an immutable static
    // and memcpy were used to hold an initializer. With improved unions, this is no longer
    // needed.
    union UntypedInit
    {
      T dummy;
    }
    static struct UntypedStorage
    {
      align(T.alignof) void[T.sizeof] dummy;
    }

    () @trusted {
      *cast(UntypedStorage*) &obj = cast(UntypedStorage) UntypedInit.init;
    } ();
  }
}

public void destructRecurse(E, size_t n)(ref E[n] arr)
{
  import core.internal.traits : hasElaborateDestructor;

  static if (hasElaborateDestructor!E)
  {
    foreach_reverse (ref elem; arr)
      destructRecurse(elem);
  }
}

public void destructRecurse(S)(ref S s)
  if (is(S == struct))
{
  static if (__traits(hasMember, S, "__xdtor") &&
      // Bugzilla 14746: Check that it's the exact member of S.
      __traits(isSame, S, __traits(parent, s.__xdtor)))
    s.__xdtor();
}

// Test static struct
nothrow @safe @nogc unittest
{
  static int i = 0;
  static struct S { ~this() nothrow @safe @nogc { i = 42; } }
  S s;
  destructRecurse(s);
  assert(i == 42);
}
