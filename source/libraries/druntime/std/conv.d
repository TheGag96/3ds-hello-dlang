// Written in the D programming language.

/**
A one-stop shop for converting values from one type to another.

$(SCRIPT inhibitQuickIndex = 1;)
$(BOOKTABLE,
$(TR $(TH Category) $(TH Functions))
$(TR $(TD Generic) $(TD
        $(LREF asOriginalType)
        $(LREF castFrom)
        $(LREF emplace)
        $(LREF parse)
        $(LREF to)
        $(LREF toChars)
))
$(TR $(TD Strings) $(TD
        $(LREF text)
        $(LREF wtext)
        $(LREF dtext)
        $(LREF hexString)
))
$(TR $(TD Numeric) $(TD
        $(LREF octal)
        $(LREF roundTo)
        $(LREF signed)
        $(LREF unsigned)
))
$(TR $(TD Exceptions) $(TD
        $(LREF ConvException)
        $(LREF ConvOverflowException)
))
)

Copyright: Copyright Digital Mars 2007-.

License:   $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors:   $(HTTP digitalmars.com, Walter Bright),
           $(HTTP erdani.org, Andrei Alexandrescu),
           Shin Fujishiro,
           Adam D. Ruppe,
           Kenji Hara

Source:    $(PHOBOSSRC std/_conv.d)

*/
module std.conv;

import std.meta;
import std.range.primitives;
import std.traits;

/+
emplaceRef is a package function for phobos internal use. It works like
emplace, but takes its argument by ref (as opposed to "by pointer").

This makes it easier to use, easier to be safe, and faster in a non-inline
build.

Furthermore, emplaceRef optionally takes a type paremeter, which specifies
the type we want to build. This helps to build qualified objects on mutable
buffer, without breaking the type system with unsafe casts.
+/
package void emplaceRef(T, UT, Args...)(ref UT chunk, auto ref Args args)
{
    static if (args.length == 0)
    {
        static assert(is(typeof({static T i;})),
            convFormat("Cannot emplace a %1$s because %1$s.this() is annotated with @disable.", T.stringof));
        static if (is(T == class)) static assert(!isAbstractClass!T,
            T.stringof ~ " is abstract and it can't be emplaced");
        emplaceInitializer(chunk);
    }
    else static if (
        !is(T == struct) && Args.length == 1 /* primitives, enums, arrays */
        ||
        Args.length == 1 && is(typeof({T t = args[0];})) /* conversions */
        ||
        is(typeof(T(args))) /* general constructors */)
    {
        static struct S
        {
            T payload;
            this(ref Args x)
            {
                static if (Args.length == 1)
                    static if (is(typeof(payload = x[0])))
                        payload = x[0];
                    else
                        payload = T(x[0]);
                else
                    payload = T(x);
            }
        }
        if (__ctfe)
        {
            static if (is(typeof(chunk = T(args))))
                chunk = T(args);
            else static if (args.length == 1 && is(typeof(chunk = args[0])))
                chunk = args[0];
            else assert(0, "CTFE emplace doesn't support "
                ~ T.stringof ~ " from " ~ Args.stringof);
        }
        else
        {
            S* p = () @trusted { return cast(S*) &chunk; }();
            emplaceInitializer(*p);
            p.__ctor(args);
        }
    }
    else static if (is(typeof(chunk.__ctor(args))))
    {
        // This catches the rare case of local types that keep a frame pointer
        emplaceInitializer(chunk);
        chunk.__ctor(args);
    }
    else
    {
        //We can't emplace. Try to diagnose a disabled postblit.
        static assert(!(Args.length == 1 && is(Args[0] : T)),
            convFormat("Cannot emplace a %1$s because %1$s.this(this) is annotated with @disable.", T.stringof));

        //We can't emplace.
        static assert(false,
            convFormat("%s cannot be emplaced from %s.", T.stringof, Args[].stringof));
    }
}
// ditto
package void emplaceRef(UT, Args...)(ref UT chunk, auto ref Args args)
if (is(UT == Unqual!UT))
{
    emplaceRef!(UT, UT)(chunk, args);
}

//emplace helper functions
private void emplaceInitializer(T)(ref T chunk) @trusted pure nothrow
{
    static if (!hasElaborateAssign!T && isAssignable!T)
        chunk = T.init;
    else
    {
        import core.stdc.string : memcpy;
        static immutable T init = T.init;
        memcpy(&chunk, &init, T.sizeof);
    }
}

// emplace
/**
Given a pointer $(D chunk) to uninitialized memory (but already typed
as $(D T)), constructs an object of non-$(D class) type $(D T) at that
address. If `T` is a class, initializes the class reference to null.

Returns: A pointer to the newly constructed object (which is the same
as $(D chunk)).
 */
T* emplace(T)(T* chunk) @safe pure nothrow
{
    emplaceRef!T(*chunk);
    return chunk;
}

///
//@system unittest
//{
//    static struct S
//    {
//        int i = 42;
//    }
//    S[2] s2 = void;
//    emplace(&s2);
//    assert(s2[0].i == 42 && s2[1].i == 42);
//}

/////
//@system unittest
//{
//    interface I {}
//    class K : I {}

//    K k = void;
//    emplace(&k);
//    assert(k is null);

//    I i = void;
//    emplace(&i);
//    assert(i is null);
//}

/**
Given a pointer $(D chunk) to uninitialized memory (but already typed
as a non-class type $(D T)), constructs an object of type $(D T) at
that address from arguments $(D args). If `T` is a class, initializes
the class reference to `args[0]`.

This function can be $(D @trusted) if the corresponding constructor of
$(D T) is $(D @safe).

Returns: A pointer to the newly constructed object (which is the same
as $(D chunk)).
 */
T* emplace(T, Args...)(T* chunk, auto ref Args args)
if (is(T == struct) || Args.length == 1)
{
    emplaceRef!T(*chunk, args);
    return chunk;
}

///
//@system unittest
//{
//    int a;
//    int b = 42;
//    assert(*emplace!int(&a, b) == 42);
//}

//@system unittest
//{
//    shared int i;
//    emplace(&i, 42);
//    assert(i == 42);
//}

private void testEmplaceChunk(void[] chunk, size_t typeSize, size_t typeAlignment, string typeName) @nogc pure nothrow
{
    assert(chunk.length >= typeSize, "emplace: Chunk size too small.");
    assert((cast(size_t) chunk.ptr) % typeAlignment == 0, "emplace: Chunk is not aligned.");
}

/**
Given a raw memory area $(D chunk), constructs an object of $(D class)
type $(D T) at that address. The constructor is passed the arguments
$(D Args).

If `T` is an inner class whose `outer` field can be used to access an instance
of the enclosing class, then `Args` must not be empty, and the first member of it
must be a valid initializer for that `outer` field. Correct initialization of
this field is essential to access members of the outer class inside `T` methods.

Preconditions:
$(D chunk) must be at least as large as $(D T) needs
and should have an alignment multiple of $(D T)'s alignment. (The size
of a $(D class) instance is obtained by using $(D
__traits(classInstanceSize, T))).

Note:
This function can be $(D @trusted) if the corresponding constructor of
$(D T) is $(D @safe).

Returns: The newly constructed object.
 */
T emplace(T, Args...)(void[] chunk, auto ref Args args)
if (is(T == class))
{
    static assert(!isAbstractClass!T, T.stringof ~
        " is abstract and it can't be emplaced");

    enum classSize = __traits(classInstanceSize, T);
    testEmplaceChunk(chunk, classSize, classInstanceAlignment!T, T.stringof);
    auto result = cast(T) chunk.ptr;

    // Initialize the object in its pre-ctor state
    chunk[0 .. classSize] = typeid(T).initializer[];

    static if (isInnerClass!T)
    {
        static assert(Args.length > 0,
            "Initializing an inner class requires a pointer to the outer class");
        static assert(is(Args[0] : typeof(T.outer)),
            "The first argument must be a pointer to the outer class");

        result.outer = args[0];
        alias args1 = args[1..$];
    }
    else alias args1 = args;

    // Call the ctor if any
    static if (is(typeof(result.__ctor(args1))))
    {
        // T defines a genuine constructor accepting args
        // Go the classic route: write .init first, then call ctor
        result.__ctor(args1);
    }
    else
    {
        static assert(args1.length == 0 && !is(typeof(&T.__ctor)),
            "Don't know how to initialize an object of type "
            ~ T.stringof ~ " with arguments " ~ typeof(args1).stringof);
    }
    return result;
}
