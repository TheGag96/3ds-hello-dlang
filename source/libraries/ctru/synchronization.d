/**
 * @file synchronization.h
 * @brief Provides synchronization locks.
 */

module ctru.synchronization;

import ctru.types, ctru.svc;

extern (C): nothrow: @nogc:

// #include "../../newlib-3.1.0/newlib/libc/sys/linux/sys/lock.h"

/// A light lock.
alias _LOCK_T = int;
alias LightLock = int;

/// A recursive lock.
struct __lock_t
{
    _LOCK_T lock;
    uint thread_tag;
    uint counter;
}

alias _LOCK_RECURSIVE_T = __lock_t;
alias RecursiveLock = __lock_t;

/// A light event.
struct LightEvent
{
    int state; ///< State of the event: -2=cleared sticky, -1=cleared oneshot, 0=signaled oneshot, 1=signaled sticky
    LightLock lock; ///< Lock used for sticky timer operation
}

/// A light semaphore.
struct LightSemaphore
{
    int current_count; ///< The current release count of the semaphore
    short num_threads_acq; ///< Number of threads concurrently acquiring the semaphore
    short max_count; ///< The maximum release count of the semaphore
}

/// Performs a Data Synchronization Barrier operation.
pragma(inline, true)
void __dsb()
{
    //TODO
    version (LDC)
    {
        assert(0, "Not working until LDC updated to support GCC-style inline ASM fully.");
    }
    else
    {
        asm @nogc nothrow { "mcr p15, 0, %[val], c7, c10, 4" :: [val] "r" (0) : "memory"; }
    }
    assert(0, "Not working until LDC updated to support GCC-style inline ASM fully.");
}

/// Performs a clrex operation.
pragma(inline, true)
void __clrex()
{
    //TODO
    version (LDC)
    {
        assert(0, "Not working until LDC updated to support GCC-style inline ASM fully.");
    }
    else
    {
        asm @nogc nothrow { "clrex" ::: "memory"; }
    }
    assert(0, "Not working until LDC updated to support GCC-style inline ASM fully.");
}

/**
 * @brief Performs a ldrex operation.
 * @param addr Address to perform the operation on.
 * @return The resulting value.
 */
pragma(inline, true)
int __ldrex(int* addr)
{
    //TODO
    int val;
    version (LDC)
    {
        assert(0, "Not working until LDC updated to support GCC-style inline ASM fully.");
    }
    else
    {
        asm @nogc nothrow { "ldrex %[val], %[addr]" : [val] "=r" (val) : [addr] "Q" (*addr); }
    }
    assert(0, "Not working until LDC updated to support GCC-style inline ASM fully.");
    return val;
}

/**
 * @brief Performs a strex operation.
 * @param addr Address to perform the operation on.
 * @param val Value to store.
 * @return Whether the operation was successful.
 */
pragma(inline, true)
bool __strex(int* addr, int val)
{
    //TODO
    bool res;
    version (LDC)
    {
        assert(0, "Not working until LDC updated to support GCC-style inline ASM fully.");
    }
    else
    {
        asm @nogc nothrow { "strex %[res], %[val], %[addr]" : [res] "=&r" (res) : [val] "r" (val), [addr] "Q" (*addr); }
    }
    assert(0, "Not working until LDC updated to support GCC-style inline ASM fully.");
    return res;
}

/**
 * @brief Performs a ldrexh operation.
 * @param addr Address to perform the operation on.
 * @return The resulting value.
 */
pragma(inline, true)
ushort __ldrexh(ushort* addr)
{
    //TODO
    ushort val;
    version (LDC)
    {
        assert(0, "Not working until LDC updated to support GCC-style inline ASM fully.");
    }
    else
    {
        asm @nogc nothrow { "ldrexh %[val], %[addr]" : [val] "=r" (val) : [addr] "Q" (*addr); }
    }
    assert(0, "Not working until LDC updated to support GCC-style inline ASM fully.");
    return val;
}

/**
 * @brief Performs a strexh operation.
 * @param addr Address to perform the operation on.
 * @param val Value to store.
 * @return Whether the operation was successful.
 */
pragma(inline, true)
bool __strexh(ushort* addr, ushort val)
{
    //TODO
    bool res;
    version (LDC)
    {
        assert(0, "Not working until LDC updated to support GCC-style inline ASM fully.");
    }
    else
    {
        asm @nogc nothrow { "strexh %[res], %[val], %[addr]" : [res] "=&r" (res) : [val] "r" (val), [addr] "Q" (*addr); }
    }
    return res;
}

/**
 * @brief Performs a ldrexb operation.
 * @param addr Address to perform the operation on.
 * @return The resulting value.
 */
pragma(inline, true)
ubyte __ldrexb(ubyte* addr)
{
    //TODO
    ubyte val;
    version (LDC)
    {
        assert(0, "Not working until LDC updated to support GCC-style inline ASM fully.");
    }
    else
    {
        asm @nogc nothrow { "ldrexb %[val], %[addr]" : [val] "=r" (val) : [addr] "Q" (*addr); }
    }
    assert(0, "Not working until LDC updated to support GCC-style inline ASM fully.");
    return val;
}

/**
 * @brief Performs a strexb operation.
 * @param addr Address to perform the operation on.
 * @param val Value to store.
 * @return Whether the operation was successful.
 */
pragma(inline, true)
bool __strexb(ubyte* addr, ubyte val)
{
    //TODO
    bool res;
    version (LDC)
    {
        assert(0, "Not working until LDC updated to support GCC-style inline ASM fully.");
    }
    else
    {
        asm @nogc nothrow { "strexb %[res], %[val], %[addr]" : [res] "=&r" (res) : [val] "r" (val), [addr] "Q" (*addr); }
    }
    return res;
}

/// Performs an atomic pre-increment operation.
pragma(inline, true)
extern (D) auto AtomicIncrement(T)(auto ref T ptr)
{
    return __atomic_add_fetch(cast(uint*) ptr, 1, __ATOMIC_SEQ_CST);
}

/// Performs an atomic pre-decrement operation.
pragma(inline, true)
extern (D) auto AtomicDecrement(T)(auto ref T ptr)
{
    return __atomic_sub_fetch(cast(uint*) ptr, 1, __ATOMIC_SEQ_CST);
}

/// Performs an atomic post-increment operation.
pragma(inline, true)
extern (D) auto AtomicPostIncrement(T)(auto ref T ptr)
{
    return __atomic_fetch_add(cast(uint*) ptr, 1, __ATOMIC_SEQ_CST);
}

/// Performs an atomic post-decrement operation.
pragma(inline, true)
extern (D) auto AtomicPostDecrement(T)(auto ref T ptr)
{
    return __atomic_fetch_sub(cast(uint*) ptr, 1, __ATOMIC_SEQ_CST);
}

/// Performs an atomic swap operation.
pragma(inline, true)
extern (D) auto AtomicSwap(T0, T1)(auto ref T0 ptr, auto ref T1 value)
{
    return __atomic_exchange_n(cast(uint*) ptr, value, __ATOMIC_SEQ_CST);
}

/**
 * @brief Retrieves the synchronization subsystem's address arbiter handle.
 * @return The synchronization subsystem's address arbiter handle.
 */
Handle __sync_get_arbiter();

/**
 * @brief Initializes a light lock.
 * @param lock Pointer to the lock.
 */
void LightLock_Init(LightLock* lock);

/**
 * @brief Locks a light lock.
 * @param lock Pointer to the lock.
 */
void LightLock_Lock(LightLock* lock);

/**
 * @brief Attempts to lock a light lock.
 * @param lock Pointer to the lock.
 * @return Zero on success, non-zero on failure.
 */
int LightLock_TryLock(LightLock* lock);

/**
 * @brief Unlocks a light lock.
 * @param lock Pointer to the lock.
 */
void LightLock_Unlock(LightLock* lock);

/**
 * @brief Initializes a recursive lock.
 * @param lock Pointer to the lock.
 */
void RecursiveLock_Init(RecursiveLock* lock);

/**
 * @brief Locks a recursive lock.
 * @param lock Pointer to the lock.
 */
void RecursiveLock_Lock(RecursiveLock* lock);

/**
 * @brief Attempts to lock a recursive lock.
 * @param lock Pointer to the lock.
 * @return Zero on success, non-zero on failure.
 */
int RecursiveLock_TryLock(RecursiveLock* lock);

/**
 * @brief Unlocks a recursive lock.
 * @param lock Pointer to the lock.
 */
void RecursiveLock_Unlock(RecursiveLock* lock);

/**
 * @brief Initializes a light event.
 * @param event Pointer to the event.
 * @param reset_type Type of reset the event uses (RESET_ONESHOT/RESET_STICKY).
 */
void LightEvent_Init(LightEvent* event, ResetType reset_type);

/**
 * @brief Clears a light event.
 * @param event Pointer to the event.
 */
void LightEvent_Clear(LightEvent* event);

/**
 * @brief Wakes up threads waiting on a sticky light event without signaling it. If the event had been signaled before, it is cleared instead.
 * @param event Pointer to the event.
 */
void LightEvent_Pulse(LightEvent* event);

/**
 * @brief Signals a light event, waking up threads waiting on it.
 * @param event Pointer to the event.
 */
void LightEvent_Signal(LightEvent* event);

/**
 * @brief Attempts to wait on a light event.
 * @param event Pointer to the event.
 * @return Non-zero if the event was signaled, zero otherwise.
 */
int LightEvent_TryWait(LightEvent* event);

/**
 * @brief Waits on a light event.
 * @param event Pointer to the event.
 */
void LightEvent_Wait(LightEvent* event);

/**
 * @brief Initializes a light semaphore.
 * @param event Pointer to the semaphore.
 * @param max_count Initial count of the semaphore.
 * @param max_count Maximum count of the semaphore.
 */
void LightSemaphore_Init(LightSemaphore* semaphore, short initial_count, short max_count);

/**
 * @brief Acquires a light semaphore.
 * @param semaphore Pointer to the semaphore.
 * @param count Acquire count
 */
void LightSemaphore_Acquire(LightSemaphore* semaphore, int count);

/**
 * @brief Releases a light semaphore.
 * @param semaphore Pointer to the semaphore.
 * @param count Release count
 */
void LightSemaphore_Release(LightSemaphore* semaphore, int count);
