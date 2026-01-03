@abstract class_name BsVector2Extensions extends BsVectorExtensions


## Extension for [Vector2]


## [Vector2] whose elements are equal to [constant NAN].
const NAN_VECTOR: Vector2 = Vector2(NAN, NAN)


## Converts any vector to [Vector2].
static func from_vector(from: Variant) -> Vector2:
	var type: Variant.Type = typeof(from)
	match type:
		Variant.Type.TYPE_VECTOR2, Variant.Type.TYPE_VECTOR2I: return from
		Variant.Type.TYPE_VECTOR3, Variant.Type.TYPE_VECTOR3I: return from_vector3(from)
		Variant.Type.TYPE_VECTOR4, Variant.Type.TYPE_VECTOR4I: return from_vector4(from)
		_:
			_BsLogger._push_error("`BsVector2Extensions.from_vector`: Unsupported type `" + type_string(type) + "`. Returning NAN_VECTOR.")
			return NAN_VECTOR


## Converts [Vector3] to [Vector2].
static func from_vector3(from: Vector3) -> Vector2:
	return BsVector3Extensions.to_vector2(from)


## Converts [Vector4] to [Vector2].
static func from_vector4(from: Vector4) -> Vector2:
	return BsVector4Extensions.to_vector2(from)


## Converts [Vector2] to [Vector3].
static func to_vector3(from: Vector2, z: float = 0) -> Vector3:
	return Vector3(from.x, from.y, z)


## Converts [Vector2] to [Vector4].
static func to_vector4(from: Vector2, z: float = 0, w: float = 0) -> Vector4:
	return Vector4(from.x, from.y, z, w)
