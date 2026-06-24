@abstract class_name BsVector2Extensions extends BsVectorExtensions


## Extension for [Vector2]


## [Vector2] whose elements are equal to [constant NAN].
const VECTOR_NAN: Vector2 = Vector2(NAN, NAN)


## Converts [Vector3] to [Vector2].
static func from_vector3(from: Vector3) -> Vector2: return BsVector3Extensions.to_vector2(from)


## Converts [Vector4] to [Vector2].
static func from_vector4(from: Vector4) -> Vector2: return BsVector4Extensions.to_vector2(from)


## Converts [Vector2] to [Vector3].
static func to_vector3(from: Vector2, z: float = 0) -> Vector3: return Vector3(from.x, from.y, z)


## Converts [Vector2] to [Vector4].
static func to_vector4(from: Vector2, z: float = 0, w: float = 0) -> Vector4: return Vector4(from.x, from.y, z, w)
