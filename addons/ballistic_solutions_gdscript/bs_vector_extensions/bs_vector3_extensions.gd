@abstract class_name BsVector3Extensions extends BsVectorExtensions


## Extension for [Vector3]


## [Vector3] whose elements are equal to [constant NAN].
const NAN_VECTOR: Vector3 = Vector3(NAN, NAN, NAN)


## Converts any vector to [Vector3].
static func from_vector(from: Variant, z: float = 0) -> Vector3:
	var type: Variant.Type = typeof(from)
	match type:
		Variant.Type.TYPE_VECTOR2, Variant.Type.TYPE_VECTOR2I: return from_vector2(from, z)
		Variant.Type.TYPE_VECTOR3, Variant.Type.TYPE_VECTOR3I: return from
		Variant.Type.TYPE_VECTOR4, Variant.Type.TYPE_VECTOR4I: return from_vector4(from)
		_:
			_BsLogger._push_error("`BsVector3Extensions.from_vector`: Unsupported type `" + type_string(type) + "`. Returned NAN_VECTOR.")
			return NAN_VECTOR


## Converts [Vector2] to [Vector3].
static func from_vector2(from: Vector2, z: float = 0) -> Vector3:
	return BsVector2Extensions.to_vector3(from, z)


## Converts [Vector4] to [Vector3].
static func from_vector4(from: Vector4) -> Vector3:
	return BsVector4Extensions.to_vector3(from)


## Converts [Vector3] to [Vector2].
static func to_vector2(from: Vector3) -> Vector2:
	return Vector2(from.x, from.y)


## Converts [Vector3] to [Vector4].
static func to_vector4(from: Vector3, w: float = 0) -> Vector4:
	return Vector4(from.x, from.y, from.z, w)
