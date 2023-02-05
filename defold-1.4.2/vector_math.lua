---@meta

---Vector math API documentation
---@class vmath
vmath = {}

---Docs: https://defold.com/ref/stable/vmath/?q=vmath.vector#vmath.vector
---
---Creates a vector of arbitrary size. The vector is initialized
---with numeric values from a table.
---The table values are converted to floating point
---values. If a value cannot be converted, a 0 is stored in that
---value position in the vector.
---@param t table table of numbers
---@return vector v new vector
function vmath.vector(t) end

---Docs: https://defold.com/ref/stable/vmath/?q=vmath.vector3#vmath.vector3
---
---Creates a new vector with the components set to the
---supplied values.
---@param x number x coordinate
---@param y number y coordinate
---@param z number z coordinate
---@overload fun(): vector3
---@overload fun(n: number): vector3
---@overload fun(v1: vector3): vector3
---@return vector3 v new vector
function vmath.vector3(x, y, z) end

---Docs: https://defold.com/ref/stable/vmath/?q=vmath.vector4#vmath.vector4
---
---Creates a new vector with the components set to the
---supplied values.
---@param x number x coordinate
---@param y number y coordinate
---@param z number z coordinate
---@param w number w coordinate
---@overload fun(): vector4
---@overload fun(n: number): vector4
---@overload fun(v1: vector4): vector4
---@return vector4 v new vector
function vmath.vector4(x, y, z, w) end

---Docs: https://defold.com/ref/stable/vmath/?q=vmath.quat#vmath.quat
---
---Creates a new quaternion with the components set
---according to the supplied parameter values.
---@param x number x coordinate
---@param y number y coordinate
---@param z number z coordinate
---@param w number w coordinate
---@overload fun(): quaternion
---@overload fun(q1: quaternion): quaternion
---@return quaternion q new quaternion
function vmath.quat(x, y, z, w) end

---Docs: https://defold.com/ref/stable/vmath/?q=vmath.quat_from_to#vmath.quat_from_to
---
---The resulting quaternion describes the rotation that,
---if applied to the first vector, would rotate the first
---vector to the second. The two vectors must be unit
---vectors (of length 1).
---The result is undefined if the two vectors point in opposite directions
---@param v1 vector3 first unit vector, before rotation
---@param v2 vector3 second unit vector, after rotation
---@return quaternion q quaternion representing the rotation from first to second vector
function vmath.quat_from_to(v1, v2) end

---Docs: https://defold.com/ref/stable/vmath/?q=vmath.quat_axis_angle#vmath.quat_axis_angle
---
---The resulting quaternion describes a rotation of <code>angle</code>
---radians around the axis described by the unit vector <code>v</code>.
---@param v vector3 axis
---@param angle number angle
---@return quaternion q quaternion representing the axis-angle rotation
function vmath.quat_axis_angle(v, angle) end

---Docs: https://defold.com/ref/stable/vmath/?q=vmath.quat_basis#vmath.quat_basis
---
---The resulting quaternion describes the rotation from the
---identity quaternion (no rotation) to the coordinate system
---as described by the given x, y and z base unit vectors.
---@param x vector3 x base vector
---@param y vector3 y base vector
---@param z vector3 z base vector
---@return quaternion q quaternion representing the rotation of the specified base vectors
function vmath.quat_basis(x, y, z) end

---Docs: https://defold.com/ref/stable/vmath/?q=vmath.quat_rotation_x#vmath.quat_rotation_x
---
---The resulting quaternion describes a rotation of <code>angle</code>
---radians around the x-axis.
---@param angle number angle in radians around x-axis
---@return quaternion q quaternion representing the rotation around the x-axis
function vmath.quat_rotation_x(angle) end

---Docs: https://defold.com/ref/stable/vmath/?q=vmath.quat_rotation_y#vmath.quat_rotation_y
---
---The resulting quaternion describes a rotation of <code>angle</code>
---radians around the y-axis.
---@param angle number angle in radians around y-axis
---@return quaternion q quaternion representing the rotation around the y-axis
function vmath.quat_rotation_y(angle) end

---Docs: https://defold.com/ref/stable/vmath/?q=vmath.quat_rotation_z#vmath.quat_rotation_z
---
---The resulting quaternion describes a rotation of <code>angle</code>
---radians around the z-axis.
---@param angle number angle in radians around z-axis
---@return quaternion q quaternion representing the rotation around the z-axis
function vmath.quat_rotation_z(angle) end

---Docs: https://defold.com/ref/stable/vmath/?q=vmath.matrix4#vmath.matrix4
---
---Creates a new matrix with all components set to the
---corresponding values from the supplied matrix. I.e.
---the function creates a copy of the given matrix.
---@param m1 matrix4 existing matrix
---@overload fun(): matrix4
---@return matrix4 m matrix which is a copy of the specified matrix
function vmath.matrix4(m1) end

---Docs: https://defold.com/ref/stable/vmath/?q=vmath.matrix4_frustum#vmath.matrix4_frustum
---
---Constructs a frustum matrix from the given values. The left, right,
---top and bottom coordinates of the view cone are expressed as distances
---from the center of the near clipping plane. The near and far coordinates
---are expressed as distances from the tip of the view frustum cone.
---@param left number coordinate for left clipping plane
---@param right number coordinate for right clipping plane
---@param bottom number coordinate for bottom clipping plane
---@param top number coordinate for top clipping plane
---@param near number coordinate for near clipping plane
---@param far number coordinate for far clipping plane
---@return matrix4 m matrix representing the frustum
function vmath.matrix4_frustum(left, right, bottom, top, near, far) end

---Docs: https://defold.com/ref/stable/vmath/?q=vmath.matrix4_look_at#vmath.matrix4_look_at
---
---The resulting matrix is created from the supplied look-at parameters.
---This is useful for constructing a view matrix for a camera or
---rendering in general.
---@param eye vector3 eye position
---@param look_at vector3 look-at position
---@param up vector3 up vector
---@return matrix4 m look-at matrix
function vmath.matrix4_look_at(eye, look_at, up) end

---Docs: https://defold.com/ref/stable/vmath/?q=vmath.matrix4_orthographic#vmath.matrix4_orthographic
---
---Creates an orthographic projection matrix.
---This is useful to construct a projection matrix for a camera or rendering in general.
---@param left number coordinate for left clipping plane
---@param right number coordinate for right clipping plane
---@param bottom number coordinate for bottom clipping plane
---@param top number coordinate for top clipping plane
---@param near number coordinate for near clipping plane
---@param far number coordinate for far clipping plane
---@return matrix4 m orthographic projection matrix
function vmath.matrix4_orthographic(left, right, bottom, top, near, far) end

---Docs: https://defold.com/ref/stable/vmath/?q=vmath.matrix4_perspective#vmath.matrix4_perspective
---
---Creates a perspective projection matrix.
---This is useful to construct a projection matrix for a camera or rendering in general.
---@param fov number angle of the full vertical field of view in radians
---@param aspect number aspect ratio
---@param near number coordinate for near clipping plane
---@param far number coordinate for far clipping plane
---@return matrix4 m perspective projection matrix
function vmath.matrix4_perspective(fov, aspect, near, far) end

---Docs: https://defold.com/ref/stable/vmath/?q=vmath.matrix4_from_quat#vmath.matrix4_from_quat
---
---The resulting matrix describes the same rotation as the quaternion, but does not have any translation (also like the quaternion).
---@param q quaternion quaternion to create matrix from
---@return matrix4 m matrix represented by quaternion
function vmath.matrix4_from_quat(q) end

---Docs: https://defold.com/ref/stable/vmath/?q=vmath.matrix4_axis_angle#vmath.matrix4_axis_angle
---
---The resulting matrix describes a rotation around the axis by the specified angle.
---@param v vector3 axis
---@param angle number angle in radians
---@return matrix4 m matrix represented by axis and angle
function vmath.matrix4_axis_angle(v, angle) end

---Docs: https://defold.com/ref/stable/vmath/?q=vmath.matrix4_rotation_x#vmath.matrix4_rotation_x
---
---The resulting matrix describes a rotation around the x-axis
---by the specified angle.
---@param angle number angle in radians around x-axis
---@return matrix4 m matrix from rotation around x-axis
function vmath.matrix4_rotation_x(angle) end

---Docs: https://defold.com/ref/stable/vmath/?q=vmath.matrix4_rotation_y#vmath.matrix4_rotation_y
---
---The resulting matrix describes a rotation around the y-axis
---by the specified angle.
---@param angle number angle in radians around y-axis
---@return matrix4 m matrix from rotation around y-axis
function vmath.matrix4_rotation_y(angle) end

---Docs: https://defold.com/ref/stable/vmath/?q=vmath.matrix4_rotation_z#vmath.matrix4_rotation_z
---
---The resulting matrix describes a rotation around the z-axis
---by the specified angle.
---@param angle number angle in radians around z-axis
---@return matrix4 m matrix from rotation around z-axis
function vmath.matrix4_rotation_z(angle) end

---Docs: https://defold.com/ref/stable/vmath/?q=vmath.matrix4_translation#vmath.matrix4_translation
---
---The resulting matrix describes a translation of a point
---in euclidean space.
---@param position vector3|vector4 position vector to create matrix from
---@return matrix4 m matrix from the supplied position vector
function vmath.matrix4_translation(position) end

---Docs: https://defold.com/ref/stable/vmath/?q=vmath.inv#vmath.inv
---
---The resulting matrix is the inverse of the supplied matrix.
---For ortho-normal matrices, e.g. regular object transformation,
---use <code>vmath.ortho_inv()</code> instead.
---The specialized inverse for ortho-normalized matrices is much faster
---than the general inverse.
---@param m1 matrix4 matrix to invert
---@return matrix4 m inverse of the supplied matrix
function vmath.inv(m1) end

---Docs: https://defold.com/ref/stable/vmath/?q=vmath.ortho_inv#vmath.ortho_inv
---
---The resulting matrix is the inverse of the supplied matrix.
---The supplied matrix has to be an ortho-normal matrix, e.g.
---describe a regular object transformation.
---For matrices that are not ortho-normal
---use the general inverse <code>vmath.inv()</code> instead.
---@param m1 matrix4 ortho-normalized matrix to invert
---@return matrix4 m inverse of the supplied matrix
function vmath.ortho_inv(m1) end

---Docs: https://defold.com/ref/stable/vmath/?q=vmath.dot#vmath.dot
---
---The returned value is a scalar defined as:
---<code>P &#x22C5; Q = |P| |Q| cos &#x03B8;</code>
---where &#x03B8; is the angle between the vectors P and Q.
---
---If the dot product is positive then the angle between the vectors is below 90 degrees.
---
---If the dot product is zero the vectors are perpendicular (at right-angles to each other).
---
---If the dot product is negative then the angle between the vectors is more than 90 degrees.
---
---@param v1 vector3|vector4 first vector
---@param v2 vector3|vector4 second vector
---@return number n dot product
function vmath.dot(v1, v2) end

---Docs: https://defold.com/ref/stable/vmath/?q=vmath.length_sqr#vmath.length_sqr
---
---Returns the squared length of the supplied vector or quaternion.
---@param v vector3|vector4|quat value of which to calculate the squared length
---@return number n squared length
function vmath.length_sqr(v) end

---Docs: https://defold.com/ref/stable/vmath/?q=vmath.length#vmath.length
---
---Returns the length of the supplied vector or quaternion.
---If you are comparing the lengths of vectors or quaternions, you should compare
---the length squared instead as it is slightly more efficient to calculate
---(it eliminates a square root calculation).
---@param v vector3|vector4|quat value of which to calculate the length
---@return number n length
function vmath.length(v) end

---Docs: https://defold.com/ref/stable/vmath/?q=vmath.normalize#vmath.normalize
---
---Normalizes a vector, i.e. returns a new vector with the same
---direction as the input vector, but with length 1.
---The length of the vector must be above 0, otherwise a
---division-by-zero will occur.
---@param v1 vector3|vector4|quat vector to normalize
---@return vector3|vector4|quat v new normalized vector
function vmath.normalize(v1) end

---Docs: https://defold.com/ref/stable/vmath/?q=vmath.cross#vmath.cross
---
---Given two linearly independent vectors P and Q, the cross product,
---P &#x00D7; Q, is a vector that is perpendicular to both P and Q and
---therefore normal to the plane containing them.
---If the two vectors have the same direction (or have the exact
---opposite direction from one another, i.e. are not linearly independent)
---or if either one has zero length, then their cross product is zero.
---@param v1 vector3 first vector
---@param v2 vector3 second vector
---@return vector3 v a new vector representing the cross product
function vmath.cross(v1, v2) end

---Docs: https://defold.com/ref/stable/vmath/?q=vmath.lerp#vmath.lerp
---
---Linearly interpolate between two vectors. The function
---treats the vectors as positions and interpolates between
---the positions in a straight line. Lerp is useful to describe
---transitions from one place to another over time.
---The function does not clamp t between 0 and 1.
---@param t number interpolation parameter, 0-1
---@param v1 vector3|vector4 vector to lerp from
---@param v2 vector3|vector4 vector to lerp to
---@overload fun(t: number, q1: quaternion, q2: quaternion): vector3|vector4
---@overload fun(t: number, n1: number, n2: number): vector3|vector4
---@return vector3|vector4 v the lerped vector
function vmath.lerp(t, v1, v2) end

---Docs: https://defold.com/ref/stable/vmath/?q=vmath.slerp#vmath.slerp
---
---Spherically interpolates between two vectors. The difference to
---lerp is that slerp treats the vectors as directions instead of
---positions in space.
---The direction of the returned vector is interpolated by the angle
---and the magnitude is interpolated between the magnitudes of the
---from and to vectors.
---Slerp is computationally more expensive than lerp.
---The function does not clamp t between 0 and 1.
---@param t number interpolation parameter, 0-1
---@param v1 vector3|vector4 vector to slerp from
---@param v2 vector3|vector4 vector to slerp to
---@overload fun(t: number, q1: quaternion, q2: quaternion): vector3|vector4
---@return vector3|vector4 v the slerped vector
function vmath.slerp(t, v1, v2) end

---Docs: https://defold.com/ref/stable/vmath/?q=vmath.conj#vmath.conj
---
---Calculates the conjugate of a quaternion. The result is a
---quaternion with the same magnitudes but with the sign of
---the imaginary (vector) parts changed:
---<code>q* = [w, -v]</code>
---@param q1 quaternion quaternion of which to calculate the conjugate
---@return quaternion q the conjugate
function vmath.conj(q1) end

---Docs: https://defold.com/ref/stable/vmath/?q=vmath.rotate#vmath.rotate
---
---Returns a new vector from the supplied vector that is
---rotated by the rotation described by the supplied
---quaternion.
---@param q quaternion quaternion
---@param v1 vector3 vector to rotate
---@return vector3 v the rotated vector
function vmath.rotate(q, v1) end

---Docs: https://defold.com/ref/stable/vmath/?q=vmath.project#vmath.project
---
---Calculates the extent the projection of the first vector onto the second.
---The returned value is a scalar p defined as:
---<code>p = |P| cos &#x03B8; / |Q|</code>
---where &#x03B8; is the angle between the vectors P and Q.
---@param v1 vector3 vector to be projected on the second
---@param v2 vector3 vector onto which the first will be projected, must not have zero length
---@return number n the projected extent of the first vector onto the second
function vmath.project(v1, v2) end

---Docs: https://defold.com/ref/stable/vmath/?q=vmath.mul_per_elem#vmath.mul_per_elem
---
---Performs an element wise multiplication between two vectors of the same type
---The returned value is a vector defined as (e.g. for a vector3):
---<code>v = vmath.mul_per_elem(a, b) = vmath.vector3(a.x * b.x, a.y * b.y, a.z * b.z)</code>
---@param v1 vector3|vector4 first vector
---@param v2 vector3|vector4 second vector
---@return vector3|vector4 v multiplied vector
function vmath.mul_per_elem(v1, v2) end

