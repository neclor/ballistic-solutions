class_name BdcVector3Extensions extends Object


static func from_vector(from: Variant, z: float = 0) -> Vector3:
	var type: Variant.Type = typeof(from)
	match type:
		Variant.Type.TYPE_VECTOR2, Variant.Type.TYPE_VECTOR2I:
			return from_vector2(from, z)

		Variant.Type.TYPE_VECTOR3, Variant.Type.TYPE_VECTOR3I:
			return from

		Variant.Type.TYPE_VECTOR4, Variant.Type.TYPE_VECTOR4I:
			return from_vector4(from)

		_:
			assert(false, "Unsupported type: " + type_string(type))
			return Vector3()


static func from_vector2(from: Vector2, z: float = 0) -> Vector3:
	return Vector3(from.x, from.y, z)


static func from_vector4(from: Vector4) -> Vector3:
	return Vector3(from.x, from.y, from.z)


static func to_vector2(from: Vector3) -> Vector2:
	return Vector2(from.x, from.y)


static func to_vector4(from: Vector3, w: float = 0) -> Vector4:
	return Vector4(from.x, from.y, from.z, w)
