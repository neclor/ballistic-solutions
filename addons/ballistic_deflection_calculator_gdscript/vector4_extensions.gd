class_name BdcVector4Extensions extends Object


static func from_vector(from: Variant, z: float = 0, w: float = 0) -> Vector4:
	var type: Variant.Type = typeof(from)
	match type:
		Variant.Type.TYPE_VECTOR2, Variant.Type.TYPE_VECTOR2I:
			return from_vector2(from, z, w)

		Variant.Type.TYPE_VECTOR3, Variant.Type.TYPE_VECTOR3I:
			return from_vector3(from, w)

		Variant.Type.TYPE_VECTOR4, Variant.Type.TYPE_VECTOR4I:
			return from

		_:
			assert(false, "Unsupported type: " + type_string(type))
			return Vector4()


static func from_vector2(from: Vector2, z: float = 0, w: float = 0) -> Vector4:
	return Vector4(from.x, from.y, z, w)


static func from_vector3(from: Vector3, w: float = 0) -> Vector4:
	return Vector4(from.x, from.y, from.z, w)


static func to_vector2(from: Vector4) -> Vector2:
	return Vector2(from.x, from.y)


static func to_vector3(from: Vector4) -> Vector3:
	return Vector3(from.x, from.y, from.z)
