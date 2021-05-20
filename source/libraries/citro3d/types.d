module citro3d.types;

extern (C): nothrow: @nogc:

alias C3D_IVec = uint;

pragma(inline, true)
C3D_IVec IVec_Pack (ubyte x, ubyte y, ubyte z, ubyte w)
{
    return cast(uint)x | (cast(uint)y << 8) | (cast(uint)z << 16) | (cast(uint)w << 24);
}

/**
 * @defgroup math_support Math Support Library
 * @brief Implementations of matrix, vector, and quaternion operations.
 * @{
 */

/**
 * @struct C3D_FVec
 * @brief Float vector
 *
 * Matches PICA layout
 */
union C3D_FVec
{
    /**
    	 * @brief Vector access
    	 */
    struct
    {
        float w; ///< W-component
        float z; ///< Z-component
        float y; ///< Y-component
        float x; ///< X-component
    }

    /**
    	 * @brief Quaternion access
    	 */
    struct
    {
        float r; ///< Real component
        float k; ///< K-component
        float j; ///< J-component
        float i; ///< I-component
    }

    /**
    	 * @brief Raw access
    	 */
    float[4] c;
}

/**
 * @struct C3D_FQuat
 * @brief Float quaternion. See @ref C3D_FVec.
 */
alias C3D_FQuat = C3D_FVec;

/**
 * @struct C3D_Mtx
 * @brief Row-major 4x4 matrix
 */
union C3D_Mtx
{
    C3D_FVec[4] r; ///< Rows are vectors
    float[16] m; ///< Raw access
}

/** @} */
