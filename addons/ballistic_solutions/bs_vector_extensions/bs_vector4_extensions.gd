@abstract class_name BsVector4Extensions extends BsVectorExtensions


## Extension for [Vector4]


## [Vector4] whose elements are equal to [constant NAN].
const VECTOR_NAN: Vector4 = Vector4(NAN, NAN, NAN, NAN)


## Converts [Vector2] to [Vector4].
static func from_vector2(from: Vector2, z: float = 0, w: float = 0) -> Vector4: return BsVector2Extensions.to_vector4(from, z, w)


## Converts [Vector3] to [Vector4].
static func from_vector3(from: Vector3, w: float = 0) -> Vector4: return BsVector3Extensions.to_vector4(from, w)


## Converts [Vector4] to [Vector2].
static func to_vector2(from: Vector4) -> Vector2: return Vector2(from.x, from.y)


## Converts [Vector4] to [Vector3].
static func to_vector3(from: Vector4) -> Vector3: return Vector3(from.x, from.y, from.z)
