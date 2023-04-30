module citro3d.maths;

import core.stdc.math;
import citro3d.types;

extern (C): nothrow: @nogc:

/**
 * @addtogroup math_support
 * @brief Implementations of matrix, vector, and quaternion operations.
 * @{
 */

/**
 * The one true circumference-to-radius ratio.
 * See http://tauday.com/tau-manifesto
 */
enum M_PI = 3.14159265358979;
enum M_TAU = 2 * M_PI;

/**
 * @brief Convert an angle from revolutions to radians
 * @param[in_] _angle Proportion of a full revolution
 * @return Angle in_ radians
 */
pragma(inline, true)
extern (D) auto C3D_Angle(T)(auto ref T _angle)
{
    return _angle * M_TAU;
}

/**
 * @brief Convert an angle from degrees to radians
 * @param[in_] _angle Angle in_ degrees
 * @return Angle in_ radians
 */
pragma(inline, true)
extern (D) auto C3D_AngleFromDegrees(T)(auto ref T _angle)
{
    return _angle * M_TAU / 360.0f;
}

enum C3D_AspectRatioTop = 400.0f / 240.0f; ///< Aspect ratio for 3DS top screen
enum C3D_AspectRatioBot = 320.0f / 240.0f; ///< Aspect ratio for 3DS bottom screen

/**
 * @name Vector Math
 * @{
 */

/**
 * @brief Create a new FVec4
 * @param[in_] x X-component
 * @param[in_] y Y-component
 * @param[in_] z Z-component
 * @param[in_] w W-component
 * @return New FVec4
 */
pragma(inline, true)
C3D_FVec FVec4_New(float x, float y, float z, float w)
{
    return C3D_FVec(w, z, y, x);
}

/**
 * @brief Add two FVec4s
 * @param[in_] lhs Augend
 * @param[in_] rhs Addend
 * @return lhs+rhs (sum)
 */
pragma(inline, true)
C3D_FVec FVec4_Add(C3D_FVec lhs, C3D_FVec rhs)
{
    // component-wise addition
    return FVec4_New(lhs.x+rhs.x, lhs.y+rhs.y, lhs.z+rhs.z, lhs.w+rhs.w);
}

/**
 * @brief Subtract two FVec4s
 * @param[in_] lhs Minuend
 * @param[in_] rhs Subtrahend
 * @return lhs-rhs (difference)
 */
pragma(inline, true)
C3D_FVec FVec4_Subtract(C3D_FVec lhs, C3D_FVec rhs)
{
    // component-wise subtraction
    return FVec4_New(lhs.x-rhs.x, lhs.y-rhs.y, lhs.z-rhs.z, lhs.w-rhs.w);
}

/**
 * @brief Negate a FVec4
 * @note This is equivalent to `FVec4_Scale(v, -1)`
 * @param[in_] v Vector to negate
 * @return -v
 */
pragma(inline, true)
C3D_FVec FVec4_Negate(C3D_FVec v)
{
    // component-wise negation
    return FVec4_New(-v.x, -v.y, -v.z, -v.w);
}

/**
 * @brief Scale a FVec4
 * @param[in_] v Vector to scale
 * @param[in_] s Scale factor
 * @return v*s
 */
pragma(inline, true)
C3D_FVec FVec4_Scale(C3D_FVec v, float s)
{
    // component-wise scaling
    return FVec4_New(v.x*s, v.y*s, v.z*s, v.w*s);
}

/**
 * @brief Perspective divide
 * @param[in_] v Vector to divide
 * @return v/v.w
 */
pragma(inline, true)
C3D_FVec FVec4_PerspDivide(C3D_FVec v)
{
    // divide by w
    return FVec4_New(v.x/v.w, v.y/v.w, v.z/v.w, 1.0f);
}

/**
 * @brief Dot product of two FVec4s
 * @param[in_] lhs Left-side FVec4
 * @param[in_] rhs Right-side FVec4
 * @return lhs∙rhs
 */
pragma(inline, true)
float FVec4_Dot(C3D_FVec lhs, C3D_FVec rhs)
{
    // A∙B = sum of component-wise products
    return lhs.x*rhs.x + lhs.y*rhs.y + lhs.z*rhs.z + lhs.w*rhs.w;
}

/**
 * @brief Magnitude of a FVec4
 * @param[in_] v Vector
 * @return ‖v‖
 */
pragma(inline, true)
float FVec4_Magnitude(C3D_FVec v)
{
    // ‖v‖ = √(v∙v)
    return sqrtf(FVec4_Dot(v,v));
}

/**
 * @brief Normalize a FVec4
 * @param[in_] v FVec4 to normalize
 * @return v/‖v‖
 */
pragma(inline, true)
C3D_FVec FVec4_Normalize(C3D_FVec v)
{
    // get vector magnitude
    float m = FVec4_Magnitude(v);

    // scale by inverse magnitude to get a unit vector
    return FVec4_New(v.x/m, v.y/m, v.z/m, v.w/m);
}

/**
 * @brief Create a new FVec3
 * @param[in_] x X-component
 * @param[in_] y Y-component
 * @param[in_] z Z-component
 * @return New FVec3
 */
pragma(inline, true)
C3D_FVec FVec3_New(float x, float y, float z)
{
    return FVec4_New(x, y, z, 0.0f);
}

/**
 * @brief Dot product of two FVec3s
 * @param[in_] lhs Left-side FVec3
 * @param[in_] rhs Right-side FVec3
 * @return lhs∙rhs
 */
pragma(inline, true)
float FVec3_Dot(C3D_FVec lhs, C3D_FVec rhs)
{
    // A∙B = sum of component-wise products
    return lhs.x*rhs.x + lhs.y*rhs.y + lhs.z*rhs.z;
}

/**
 * @brief Magnitude of a FVec3
 * @param[in_] v Vector
 * @return ‖v‖
 */
pragma(inline, true)
float FVec3_Magnitude(C3D_FVec v)
{
    // ‖v‖ = √(v∙v)
    return sqrtf(FVec3_Dot(v,v));
}

/**
 * @brief Normalize a FVec3
 * @param[in_] v FVec3 to normalize
 * @return v/‖v‖
 */
pragma(inline, true)
C3D_FVec FVec3_Normalize(C3D_FVec v)
{
    // get vector magnitude
    float m = FVec3_Magnitude(v);

    // scale by inverse magnitude to get a unit vector
    return FVec3_New(v.x/m, v.y/m, v.z/m);
}

/**
 * @brief Add two FVec3s
 * @param[in_] lhs Augend
 * @param[in_] rhs Addend
 * @return lhs+rhs (sum)
 */
pragma(inline, true)
C3D_FVec FVec3_Add(C3D_FVec lhs, C3D_FVec rhs)
{
    // component-wise addition
    return FVec3_New(lhs.x+rhs.x, lhs.y+rhs.y, lhs.z+rhs.z);
}

/**
 * @brief Subtract two FVec3s
 * @param[in_] lhs Minuend
 * @param[in_] rhs Subtrahend
 * @return lhs-rhs (difference)
 */
pragma(inline, true)
C3D_FVec FVec3_Subtract(C3D_FVec lhs, C3D_FVec rhs)
{
    // component-wise subtraction
    return FVec3_New(lhs.x-rhs.x, lhs.y-rhs.y, lhs.z-rhs.z);
}

/**
 * @brief Distance between two 3D points
 * @param[in_] lhs Relative origin
 * @param[in_] rhs Relative point of interest
 * @return ‖lhs-rhs‖
 */
pragma(inline, true)
float FVec3_Distance(C3D_FVec lhs, C3D_FVec rhs)
{
                // distance = ‖lhs-rhs‖
    return FVec3_Magnitude(FVec3_Subtract(lhs, rhs));
}

/**
 * @brief Scale a FVec3
 * @param[in_] v Vector to scale
 * @param[in_] s Scale factor
 * @return v*s
 */
pragma(inline, true)
C3D_FVec FVec3_Scale(C3D_FVec v, float s)
{
    // component-wise scaling
    return FVec3_New(v.x*s, v.y*s, v.z*s);
}

/**
 * @brief Negate a FVec3
 * @note This is equivalent to `FVec3_Scale(v, -1)`
 * @param[in_] v Vector to negate
 * @return -v
 */
pragma(inline, true)
C3D_FVec FVec3_Negate(C3D_FVec v)
{
    // component-wise negation
    return FVec3_New(-v.x, -v.y, -v.z);
}

/**
 * @brief Cross product of two FVec3s
 * @note This returns a pseudo-vector which is perpendicular to the plane
 *       spanned by the two input vectors.
 * @param[in_] lhs Left-side FVec3
 * @param[in_] rhs Right-side FVec3
 * @return lhs×rhs
 */
pragma(inline, true)
C3D_FVec FVec3_Cross(C3D_FVec lhs, C3D_FVec rhs)
{
    // A×B = (AyBz - AzBy, AzBx - AxBz, AxBy - AyBx)
    return FVec3_New(lhs.y*rhs.z - lhs.z*rhs.y, lhs.z*rhs.x - lhs.x*rhs.z, lhs.x*rhs.y - lhs.y*rhs.x);
}
/** @} */

/**
 * @name Matrix Math
 * @note All matrices are 4x4 unless otherwise noted.
 * @{
 */

/**
 * @brief Zero matrix
 * @param[out_] out_ Matrix to zero
 */
pragma(inline, true)
void Mtx_Zeros(C3D_Mtx* out_)
{
    import core.stdc.string : memset;
    memset(out_, 0, C3D_Mtx.sizeof);
}

/**
 * @brief Copy a matrix
 * @param[out_] out_ Output matrix
 * @param[in_]  in_  Input matrix
 */
pragma(inline, true)
void Mtx_Copy(C3D_Mtx* out_, const(C3D_Mtx)* in_)
{
    *out_ = *in_;
}

/**
 * @brief Creates a matrix with the diagonal using the given parameters.
 * @param[out_]  out_    Output matrix.
 * @param[in_]   x      The X component.
 * @param[in_]   y      The Y component.
 * @param[in_]   z      The Z component.
 * @param[in_]   w      The W component.
 */
pragma(inline, true)
void Mtx_Diagonal(C3D_Mtx* out_, float x, float y, float z, float w)
{
    Mtx_Zeros(out_);
    out_.r[0].x = x;
    out_.r[1].y = y;
    out_.r[2].z = z;
    out_.r[3].w = w;
}

/**
 * @brief Identity matrix
 * @param[out_] out_ Matrix to fill
 */
pragma(inline, true)
void Mtx_Identity(C3D_Mtx* out_)
{
    Mtx_Diagonal(out_, 1.0f, 1.0f, 1.0f, 1.0f);
}

/**
 *@brief Transposes the matrix. Row => Column, and vice versa.
 *@param[in_,out_] out_     Output matrix.
 */
void Mtx_Transpose(C3D_Mtx* out_);

/**
 * @brief Matrix addition
 * @param[out_]   out_    Output matrix.
 * @param[in_]    lhs    Left matrix.
 * @param[in_]    rhs    Right matrix.
 * @return lhs+rhs (sum)
 */
pragma(inline, true)
void Mtx_Add(C3D_Mtx* out_, const(C3D_Mtx)* lhs, const(C3D_Mtx)* rhs)
{
    for (int i = 0; i < 16; i++)
        out_.m[i] = lhs.m[i] + rhs.m[i];
}

/**
 * @brief Matrix subtraction
 * @param[out_]   out_    Output matrix.
 * @param[in_]    lhs    Left matrix.
 * @param[in_]    rhs    Right matrix.
 * @return lhs-rhs (difference)
 */
pragma(inline, true)
void Mtx_Subtract(C3D_Mtx* out_, const(C3D_Mtx)* lhs, const(C3D_Mtx)* rhs)
{
    for (int i = 0; i < 16; i++)
        out_.m[i] = lhs.m[i] - rhs.m[i];
}

/**
 * @brief Multiply two matrices
 * @param[out_] out_ Output matrix
 * @param[in_]  a   Multiplicand
 * @param[in_]  b   Multiplier
 */
void Mtx_Multiply(C3D_Mtx* out_, const(C3D_Mtx)* a, const(C3D_Mtx)* b);

/**
 * @brief Inverse a matrix
 * @param[in_,out_] out_ Matrix to inverse
 * @retval 0.0f Degenerate matrix (no inverse)
 * @return determinant
 */
float Mtx_Inverse(C3D_Mtx* out_);

/**
 * @brief Multiply 3x3 matrix by a FVec3
 * @param[in_] mtx Matrix
 * @param[in_] v   Vector
 * @return mtx*v (product)
 */
C3D_FVec Mtx_MultiplyFVec3(const(C3D_Mtx)* mtx, C3D_FVec v);

/**
 * @brief Multiply 4x4 matrix by a FVec4
 * @param[in_] mtx Matrix
 * @param[in_] v   Vector
 * @return mtx*v (product)
 */
C3D_FVec Mtx_MultiplyFVec4(const(C3D_Mtx)* mtx, C3D_FVec v);

/**
 * @brief Multiply 4x3 matrix by a FVec3
 * @param[in_] mtx Matrix
 * @param[in_] v   Vector
 * @return mtx*v (product)
 */
pragma(inline, true)
C3D_FVec Mtx_MultiplyFVecH(const(C3D_Mtx)* mtx, C3D_FVec v)
{
    v.w = 1.0f;

    return Mtx_MultiplyFVec4(mtx, v);
}

/**
 * @brief Get 4x4 matrix equivalent to Quaternion
 * @param[out_] m Output matrix
 * @param[in_]  q Input Quaternion
 */
void Mtx_FromQuat(C3D_Mtx* m, C3D_FQuat q);
/** @} */

/**
 * @name 3D Transformation Matrix Math
 * @note bRightSide is used to determine which side to perform the transformation.
 *       With an input matrix A and a transformation matrix B, bRightSide being
 *       true yields AB, while being false yield BA.
 * @{
 */

/**
 * @brief 3D translation
 * @param[in_,out_] mtx Matrix to translate
 * @param[in_]     x            X component to translate
 * @param[in_]     y            Y component to translate
 * @param[in_]     z            Z component to translate
 * @param[in_]     bRightSide   Whether to transform from the right side
 */
void Mtx_Translate(C3D_Mtx* mtx, float x, float y, float z, bool bRightSide);

/**
 * @brief 3D Scale
 * @param[in_,out_] mtx Matrix to scale
 * @param[in_]     x   X component to scale
 * @param[in_]     y   Y component to scale
 * @param[in_]     z   Z component to scale
 */
void Mtx_Scale(C3D_Mtx* mtx, float x, float y, float z);

/**
 * @brief 3D Rotation
 * @param[in_,out_] mtx        Matrix to rotate
 * @param[in_]     axis       Axis about which to rotate
 * @param[in_]     angle      Radians to rotate
 * @param[in_]     bRightSide Whether to transform from the right side
 */
void Mtx_Rotate(C3D_Mtx* mtx, C3D_FVec axis, float angle, bool bRightSide);

/**
 * @brief 3D Rotation about the X axis
 * @param[in_,out_] mtx        Matrix to rotate
 * @param[in_]     angle      Radians to rotate
 * @param[in_]     bRightSide Whether to transform from the right side
 */
void Mtx_RotateX(C3D_Mtx* mtx, float angle, bool bRightSide);

/**
 * @brief 3D Rotation about the Y axis
 * @param[in_,out_] mtx        Matrix to rotate
 * @param[in_]     angle      Radians to rotate
 * @param[in_]     bRightSide Whether to transform from the right side
 */
void Mtx_RotateY(C3D_Mtx* mtx, float angle, bool bRightSide);

/**
 * @brief 3D Rotation about the Z axis
 * @param[in_,out_] mtx        Matrix to rotate
 * @param[in_]     angle      Radians to rotate
 * @param[in_]     bRightSide Whether to transform from the right side
 */
void Mtx_RotateZ(C3D_Mtx* mtx, float angle, bool bRightSide);
/** @} */

/**
 * @name 3D Projection Matrix Math
 * @{
 */

/**
 * @brief Orthogonal projection
 * @param[out_] mtx Output matrix
 * @param[in_]  left         Left clip plane (X=left)
 * @param[in_]  right        Right clip plane (X=right)
 * @param[in_]  bottom       Bottom clip plane (Y=bottom)
 * @param[in_]  top          Top clip plane (Y=top)
 * @param[in_]  near         Near clip plane (Z=near)
 * @param[in_]  far          Far clip plane (Z=far)
 * @param[in_]  isLeftHanded Whether to build a LH projection
 * @sa Mtx_OrthoTilt
 */
void Mtx_Ortho(C3D_Mtx* mtx, float left, float right, float bottom, float top, float near, float far, bool isLeftHanded);

/**
 * @brief Perspective projection
 * @param[out_] mtx          Output matrix
 * @param[in_]  fovy         Vertical field of view in_ radians
 * @param[in_]  aspect       Aspect ration of projection plane (width/height)
 * @param[in_]  near         Near clip plane (Z=near)
 * @param[in_]  far          Far clip plane (Z=far)
 * @param[in_]  isLeftHanded Whether to build a LH projection
 * @sa Mtx_PerspTilt
 * @sa Mtx_PerspStereo
 * @sa Mtx_PerspStereoTilt
 */
void Mtx_Persp(C3D_Mtx* mtx, float fovy, float aspect, float near, float far, bool isLeftHanded);

/**
 * @brief Stereo perspective projection
 * @note Typically you will use iod to mean the distance between the eyes. Plug
 *       in_ -iod for the left eye and iod for the right eye.
 * @note The focal length is defined by screen. If objects are further than this,
 *       they will appear to be inside the screen. If objects are closer than this,
 *       they will appear to pop out_ of the screen. Objects at this distance appear
 *       to be at the screen.
 * @param[out_] mtx          Output matrix
 * @param[in_]  fovy         Vertical field of view in_ radians
 * @param[in_]  aspect       Aspect ration of projection plane (width/height)
 * @param[in_]  near         Near clip plane (Z=near)
 * @param[in_]  far          Far clip plane (Z=far)
 * @param[in_]  iod          Interocular distance
 * @param[in_]  screen       Focal length
 * @param[in_]  isLeftHanded Whether to build a LH projection
 * @sa Mtx_Persp
 * @sa Mtx_PerspTilt
 * @sa Mtx_PerspStereoTilt
 */
void Mtx_PerspStereo(C3D_Mtx* mtx, float fovy, float aspect, float near, float far, float iod, float screen, bool isLeftHanded);

/**
 * @brief Orthogonal projection, tilted to account for the 3DS screen rotation
 * @param[out_] mtx          Output matrix
 * @param[in_]  left         Left clip plane (X=left)
 * @param[in_]  right        Right clip plane (X=right)
 * @param[in_]  bottom       Bottom clip plane (Y=bottom)
 * @param[in_]  top          Top clip plane (Y=top)
 * @param[in_]  near         Near clip plane (Z=near)
 * @param[in_]  far          Far clip plane (Z=far)
 * @param[in_]  isLeftHanded Whether to build a LH projection
 * @sa Mtx_Ortho
 */
void Mtx_OrthoTilt(C3D_Mtx* mtx, float left, float right, float bottom, float top, float near, float far, bool isLeftHanded);

/**
 * @brief Perspective projection, tilted to account for the 3DS screen rotation
 * @param[out_] mtx          Output matrix
 * @param[in_]  fovy         Vertical field of view in_ radians
 * @param[in_]  aspect       Aspect ration of projection plane (width/height)
 * @param[in_]  near         Near clip plane (Z=near)
 * @param[in_]  far          Far clip plane (Z=far)
 * @param[in_]  isLeftHanded Whether to build a LH projection
 * @sa Mtx_Persp
 * @sa Mtx_PerspStereo
 * @sa Mtx_PerspStereoTilt
 */
void Mtx_PerspTilt(C3D_Mtx* mtx, float fovy, float aspect, float near, float far, bool isLeftHanded);

/**
 * @brief Stereo perspective projection, tilted to account for the 3DS screen rotation
 * @note See the notes for @ref Mtx_PerspStereo
 * @param[out_] mtx          Output matrix
 * @param[in_]  fovy         Vertical field of view in_ radians
 * @param[in_]  aspect       Aspect ration of projection plane (width/height)
 * @param[in_]  near         Near clip plane (Z=near)
 * @param[in_]  far          Far clip plane (Z=far)
 * @param[in_]  iod          Interocular distance
 * @param[in_]  screen       Focal length
 * @param[in_]  isLeftHanded Whether to build a LH projection
 * @sa Mtx_Persp
 * @sa Mtx_PerspTilt
 * @sa Mtx_PerspStereo
 */
void Mtx_PerspStereoTilt(C3D_Mtx* mtx, float fovy, float aspect, float near, float far, float iod, float screen, bool isLeftHanded);

/**
 * @brief Look-At matrix, based on DirectX implementation
 * @note See https://msdn.microsoft.com/en-us/library/windows/desktop/bb205342
 * @param[out_] out_            Output matrix.
 * @param[in_]  cameraPosition Position of the intended camera in_ 3D space.
 * @param[in_]  cameraTarget   Position of the intended target the camera is supposed to face in_ 3D space.
 * @param[in_]  cameraUpVector The vector that points straight up depending on the camera's "Up" direction.
 * @param[in_]  isLeftHanded   Whether to build a LH projection
 */
void Mtx_LookAt(C3D_Mtx* out_, C3D_FVec cameraPosition, C3D_FVec cameraTarget, C3D_FVec cameraUpVector, bool isLeftHanded);
/** @} */

/**
 * @name Quaternion Math
 * @{
 */

/**
 * @brief Create a new Quaternion
 * @param[in_] i I-component
 * @param[in_] j J-component
 * @param[in_] k K-component
 * @param[in_] r Real component
 * @return New Quaternion
 */
alias Quat_New = FVec4_New;

/**
 * @brief Negate a Quaternion
 * @note This is equivalent to `Quat_Scale(v, -1)`
 * @param[in_] q Quaternion to negate
 * @return -q
 */
alias Quat_Negate = FVec4_Negate;

/**
 * @brief Add two Quaternions
 * @param[in_] lhs Augend
 * @param[in_] rhs Addend
 * @return lhs+rhs (sum)
 */
alias Quat_Add = FVec4_Add;

/**
 * @brief Subtract two Quaternions
 * @param[in_] lhs Minuend
 * @param[in_] rhs Subtrahend
 * @return lhs-rhs (difference)
 */
alias Quat_Subtract = FVec4_Subtract;

/**
 * @brief Scale a Quaternion
 * @param[in_] q Quaternion to scale
 * @param[in_] s Scale factor
 * @return q*s
 */
alias Quat_Scale = FVec4_Scale;

/**
 * @brief Normalize a Quaternion
 * @param[in_] q Quaternion to normalize
 * @return q/‖q‖
 */
alias Quat_Normalize = FVec4_Normalize;

/**
 * @brief Dot product of two Quaternions
 * @param[in_] lhs Left-side Quaternion
 * @param[in_] rhs Right-side Quaternion
 * @return lhs∙rhs
 */
alias Quat_Dot = FVec4_Dot;

/**
 * @brief Multiply two Quaternions
 * @param[in_] lhs Multiplicand
 * @param[in_] rhs Multiplier
 * @return lhs*rhs
 */
C3D_FQuat Quat_Multiply(C3D_FQuat lhs, C3D_FQuat rhs);

/**
 * @brief Raise Quaternion to a power
 * @note If p is 0, this returns the identity Quaternion.
 *       If p is 1, this returns q.
 * @param[in_] q Base Quaternion
 * @param[in_] p Power
 * @return q<sup>p</sup>
 */
C3D_FQuat Quat_Pow(C3D_FQuat q, float p);

/**
 * @brief Cross product of Quaternion and FVec3
 * @param[in_] q Base Quaternion
 * @param[in_] v Vector to cross
 * @return q×v
 */
C3D_FVec Quat_CrossFVec3(C3D_FQuat q, C3D_FVec v);

/**
 * @brief 3D Rotation
 * @param[in_] q          Quaternion to rotate
 * @param[in_] axis       Axis about which to rotate
 * @param[in_] r          Radians to rotate
 * @param[in_] bRightSide Whether to transform from the right side
 * @return Rotated Quaternion
 */
C3D_FQuat Quat_Rotate(C3D_FQuat q, C3D_FVec axis, float r, bool bRightSide);

/**
 * @brief 3D Rotation about the X axis
 * @param[in_] q          Quaternion to rotate
 * @param[in_] r          Radians to rotate
 * @param[in_] bRightSide Whether to transform from the right side
 * @return Rotated Quaternion
 */
C3D_FQuat Quat_RotateX(C3D_FQuat q, float r, bool bRightSide);

/**
 * @brief 3D Rotation about the Y axis
 * @param[in_] q          Quaternion to rotate
 * @param[in_] r          Radians to rotate
 * @param[in_] bRightSide Whether to transform from the right side
 * @return Rotated Quaternion
 */
C3D_FQuat Quat_RotateY(C3D_FQuat q, float r, bool bRightSide);

/**
 * @brief 3D Rotation about the Z axis
 * @param[in_] q          Quaternion to rotate
 * @param[in_] r          Radians to rotate
 * @param[in_] bRightSide Whether to transform from the right side
 * @return Rotated Quaternion
 */
C3D_FQuat Quat_RotateZ(C3D_FQuat q, float r, bool bRightSide);

/**
 * @brief Get Quaternion equivalent to 4x4 matrix
 * @note If the matrix is orthogonal or special orthogonal, where determinant(matrix) = +1.0f, then the matrix can be converted.
 * @param[in_]   m Input  Matrix
 * @return      Generated Quaternion
 */
C3D_FQuat Quat_FromMtx(const(C3D_Mtx)* m);

/**
 * @brief Identity Quaternion
 * @return Identity Quaternion
 */
pragma(inline, true)
C3D_FQuat Quat_Identity()
{
    // r=1, i=j=k=0
    return Quat_New(0.0f, 0.0f, 0.0f, 1.0f);
}

/**
 * @brief Quaternion conjugate
 * @param[in_] q Quaternion of which to get conjugate
 * @return q*
 */
pragma(inline, true)
C3D_FQuat Quat_Conjugate(C3D_FQuat q)
{
    // q* = q.r - q.i - q.j - q.k
    return Quat_New(-q.i, -q.j, -q.k, q.r);
}

/**
 * @brief Quaternion inverse
 * @note This is equivalent to `Quat_Pow(v, -1)`
 * @param[in_] q Quaternion of which to get inverse
 * @return q<sup>-1</sup>
 */
pragma(inline, true)
C3D_FQuat Quat_Inverse(C3D_FQuat q)
{
    // q^-1 = (q.r - q.i - q.j - q.k) / (q.r^2 + q.i^2 + q.j^2 + q.k^2)
    //      = q* / (q∙q)
    C3D_FQuat c = Quat_Conjugate(q);
    float     d = Quat_Dot(q, q);
    return Quat_New(c.i/d, c.j/d, c.k/d, c.r/d);
}

/**
 * @brief Cross product of FVec3 and Quaternion
 * @param[in_] v Base FVec3
 * @param[in_] q Quaternion to cross
 * @return v×q
 */
pragma(inline, true)
C3D_FVec FVec3_CrossQuat(C3D_FVec v, C3D_FQuat q)
{
    // v×q = (q^-1)×v
    return Quat_CrossFVec3(Quat_Inverse(q), v);
}

/**
 * @brief Converting Pitch, Yaw, and Roll to Quaternion equivalent
 * @param[in_] pitch      The pitch angle in_ radians.
 * @param[in_] yaw        The yaw angle in_ radians.
 * @param[in_] roll       The roll angle in_ radians.
 * @param[in_] bRightSide Whether to transform from the right side
 * @return    C3D_FQuat  The Quaternion equivalent with the pitch, yaw, and roll (in_ that order) orientations applied.
 */
C3D_FQuat Quat_FromPitchYawRoll(float pitch, float yaw, float roll, bool bRightSide);

/**
 * @brief Quaternion Look-At
 * @param[in_] source   C3D_FVec Starting position. Origin of rotation.
 * @param[in_] target   C3D_FVec Target position to orient towards.
 * @param[in_] forwardVector C3D_FVec The Up vector.
 * @param[in_] upVector C3D_FVec The Up vector.
 * @return Quaternion rotation.
 */
C3D_FQuat Quat_LookAt(C3D_FVec source, C3D_FVec target, C3D_FVec forwardVector, C3D_FVec upVector);

/**
 * @brief Quaternion, created from a given axis and angle in_ radians.
 * @param[in_] axis  C3D_FVec The axis to rotate around at.
 * @param[in_] angle float The angle to rotate. Unit: Radians
 * @return Quaternion rotation based on the axis and angle. Axis doesn't have to be orthogonal.
 */
C3D_FQuat Quat_FromAxisAngle(C3D_FVec axis, float angle);