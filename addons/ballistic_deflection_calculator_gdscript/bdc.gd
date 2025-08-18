class_name Bdc extends Object


## Ballistic deflection calculator is a tool for calculating the shot vector considering speeds and accelerations for Godot.
##
## @tutorial(BDC - Ballistic Deflection Calculator): https://github.com/neclor/godot-ballistic-deflection-calculator/blob/main/README.md


#region Public
#region Velocities
## Returns an array of velocity vectors for a lead shot sorted by time to hit, if the hit is not possible, returns an empty array.
static func velocities(
	projectile_speed: float,
	to_target: Variant,
	target_velocity: Variant = Vector4.ZERO,
	projectile_acceleration: Variant = Vector4.ZERO,
	target_acceleration: Variant = Vector4.ZERO
) -> Array[Variant]:
	var type: Variant.Type = typeof(to_target)
	match type:
		Variant.Type.TYPE_VECTOR2, Variant.Type.TYPE_VECTOR2I:
			return velocities_vector2(
				projectile_speed,
				to_target,
				BdcVector2Extensions.from_vector(target_velocity),
				BdcVector2Extensions.from_vector(projectile_acceleration),
				BdcVector2Extensions.from_vector(target_acceleration),
			)

		Variant.Type.TYPE_VECTOR3, Variant.Type.TYPE_VECTOR3I:
			return velocities_vector3(
				projectile_speed,
				to_target,
				BdcVector3Extensions.from_vector(target_velocity),
				BdcVector3Extensions.from_vector(projectile_acceleration),
				BdcVector3Extensions.from_vector(target_acceleration),
			)

		Variant.Type.TYPE_VECTOR4, Variant.Type.TYPE_VECTOR4I:
			return velocities_vector4(
				projectile_speed,
				to_target,
				BdcVector4Extensions.from_vector(target_velocity),
				BdcVector4Extensions.from_vector(projectile_acceleration),
				BdcVector4Extensions.from_vector(target_acceleration),
			)

		_:
			assert(false, "Unsupported type: " + type_string(type))
			return []


## Returns an array of velocity vectors for a lead shot sorted by time to hit, if the hit is not possible, returns an empty array.
static func velocities_vector2(
	projectile_speed: float,
	to_target: Vector2,
	target_velocity: Vector2 = Vector2.ZERO,
	projectile_acceleration: Vector2 = Vector2.ZERO,
	target_acceleration: Vector2 = Vector2.ZERO
) -> Array[Vector2]:
	return Array(
		velocities_vector4(
			projectile_speed,
			BdcVector4Extensions.from_vector2(to_target),
			BdcVector4Extensions.from_vector2(target_velocity),
			BdcVector4Extensions.from_vector2(projectile_acceleration),
			BdcVector4Extensions.from_vector2(target_acceleration)
		).map(func(velocity: Vector4) -> Vector2: return BdcVector2Extensions.from_vector4(velocity)),
		TYPE_VECTOR2,
		"",
		null
	)


## Returns an array of velocity vectors for a lead shot sorted by time to hit, if the hit is not possible, returns an empty array.
static func velocities_vector3(
	projectile_speed: float,
	to_target: Vector3,
	target_velocity: Vector3 = Vector3.ZERO,
	projectile_acceleration: Vector3 = Vector3.ZERO,
	target_acceleration: Vector3 = Vector3.ZERO
) -> Array[Vector3]:
	return Array(
		velocities_vector4(
			projectile_speed,
			BdcVector4Extensions.from_vector3(to_target),
			BdcVector4Extensions.from_vector3(target_velocity),
			BdcVector4Extensions.from_vector3(projectile_acceleration),
			BdcVector4Extensions.from_vector3(target_acceleration)
		).map(func(velocity: Vector4) -> Vector3: return BdcVector3Extensions.from_vector4(velocity)),
		TYPE_VECTOR3,
		"",
		null
	)


## Returns an array of velocity vectors for a lead shot sorted by time to hit, if the hit is not possible, returns an empty array.
static func velocities_vector4(
	projectile_speed: float,
	to_target: Vector4,
	target_velocity: Vector4 = Vector4.ZERO,
	projectile_acceleration: Vector4 = Vector4.ZERO,
	target_acceleration: Vector4 = Vector4.ZERO
) -> Array[Vector4]:
	return Array(
		times_to_hit_vector4(
			projectile_speed,
			to_target,
			target_velocity,
			projectile_acceleration,
			target_acceleration
		).map(
			func(time_to_hit: float) -> Vector4: return velocity_from_time_to_hit_vector4(
				time_to_hit,
				to_target,
				target_velocity,
				projectile_acceleration,
				target_acceleration
			)
		),
		TYPE_VECTOR4,
		"",
		null
	)
#endregion


#region Times To Hit
## Returns a sorted array of times before the hit, if the hit is not possible, returns an empty array.
static func times_to_hit(
	projectile_speed: float,
	to_target: Variant,
	target_velocity: Variant = Vector4.ZERO,
	projectile_acceleration: Variant = Vector4.ZERO,
	target_acceleration: Variant = Vector4.ZERO
) -> Array[float]:
	var type: Variant.Type = typeof(to_target)
	match type:
		Variant.Type.TYPE_VECTOR2, Variant.Type.TYPE_VECTOR2I:
			return times_to_hit_vector2(
				projectile_speed,
				to_target,
				BdcVector2Extensions.from_vector(target_velocity),
				BdcVector2Extensions.from_vector(projectile_acceleration),
				BdcVector2Extensions.from_vector(target_acceleration),
			)

		Variant.Type.TYPE_VECTOR3, Variant.Type.TYPE_VECTOR3I:
			return times_to_hit_vector3(
				projectile_speed,
				to_target,
				BdcVector3Extensions.from_vector(target_velocity),
				BdcVector3Extensions.from_vector(projectile_acceleration),
				BdcVector3Extensions.from_vector(target_acceleration),
			)

		Variant.Type.TYPE_VECTOR4, Variant.Type.TYPE_VECTOR4I:
			return times_to_hit_vector4(
				projectile_speed,
				to_target,
				BdcVector4Extensions.from_vector(target_velocity),
				BdcVector4Extensions.from_vector(projectile_acceleration),
				BdcVector4Extensions.from_vector(target_acceleration),
			)

		_:
			assert(false, "Unsupported type: " + type_string(type))
			return []


## Returns a sorted array of times before the hit, if the hit is not possible, returns an empty array.
static func times_to_hit_vector2(
	projectile_speed: float,
	to_target: Vector2,
	target_velocity: Vector2 = Vector2.ZERO,
	projectile_acceleration: Vector2 = Vector2.ZERO,
	target_acceleration: Vector2 = Vector2.ZERO
) -> Array[float]:
	return times_to_hit_vector4(
		projectile_speed,
		BdcVector4Extensions.from_vector2(to_target),
		BdcVector4Extensions.from_vector2(target_velocity),
		BdcVector4Extensions.from_vector2(projectile_acceleration),
		BdcVector4Extensions.from_vector2(target_acceleration)
	)


## Returns a sorted array of times before the hit, if the hit is not possible, returns an empty array.
static func times_to_hit_vector3(
	projectile_speed: float,
	to_target: Vector3,
	target_velocity: Vector3 = Vector3.ZERO,
	projectile_acceleration: Vector3 = Vector3.ZERO,
	target_acceleration: Vector3 = Vector3.ZERO
) -> Array[float]:
	return times_to_hit_vector4(
		projectile_speed,
		BdcVector4Extensions.from_vector3(to_target),
		BdcVector4Extensions.from_vector3(target_velocity),
		BdcVector4Extensions.from_vector3(projectile_acceleration),
		BdcVector4Extensions.from_vector3(target_acceleration)
	)


## Returns a sorted array of times before the hit, if the hit is not possible, returns an empty array.
static func times_to_hit_vector4(
	projectile_speed: float,
	to_target: Vector4,
	target_velocity: Vector4 = Vector4.ZERO,
	projectile_acceleration: Vector4 = Vector4.ZERO,
	target_acceleration: Vector4 = Vector4.ZERO
) -> Array[float]:	
	var relative_acceleration: Vector4 = projectile_acceleration - target_acceleration

	var a: float = relative_acceleration.length_squared() / 4
	var b: float = -relative_acceleration.dot(target_velocity)
	var c: float = target_velocity.length_squared() - relative_acceleration.dot(to_target) - projectile_speed * projectile_speed
	var d: float = 2 * target_velocity.dot(to_target)
	var e: float = to_target.length_squared()

	return Array(
		Res.solve_quartic(a, b, c, d, e).filter(func(time_to_hit: float) -> bool: return time_to_hit > 0),
		TYPE_FLOAT,
		"",
		null
	)
#endregion


#region Velocity From Time To Hit
## Returns the velocity vector for a lead shot.
static func velocity_from_time_to_hit(
	time_to_hit: float,
	to_target: Variant,
	target_velocity: Variant = Vector4.ZERO,
	projectile_acceleration: Variant = Vector4.ZERO,
	target_acceleration: Variant = Vector4.ZERO
) -> Variant:
	var type: Variant.Type = typeof(to_target)
	match type:
		Variant.Type.TYPE_VECTOR2, Variant.Type.TYPE_VECTOR2I:
			return velocity_from_time_to_hit_vector2(
				time_to_hit,
				to_target,
				BdcVector2Extensions.from_vector(target_velocity),
				BdcVector2Extensions.from_vector(projectile_acceleration),
				BdcVector2Extensions.from_vector(target_acceleration),
			)

		Variant.Type.TYPE_VECTOR3, Variant.Type.TYPE_VECTOR3I:
			return velocity_from_time_to_hit_vector3(
				time_to_hit,
				to_target,
				BdcVector3Extensions.from_vector(target_velocity),
				BdcVector3Extensions.from_vector(projectile_acceleration),
				BdcVector3Extensions.from_vector(target_acceleration),
			)

		Variant.Type.TYPE_VECTOR4, Variant.Type.TYPE_VECTOR4I:
			return velocity_from_time_to_hit_vector4(
				time_to_hit,
				to_target,
				BdcVector4Extensions.from_vector(target_velocity),
				BdcVector4Extensions.from_vector(projectile_acceleration),
				BdcVector4Extensions.from_vector(target_acceleration),
			)

		_:
			assert(false, "Unsupported type: " + type_string(type))
			return []


## Returns the velocity vector for a lead shot.
static func velocity_from_time_to_hit_vector2(
	time_to_hit: float,
	to_target: Vector2,
	target_velocity: Vector2 = Vector2.ZERO,
	projectile_acceleration: Vector2 = Vector2.ZERO,
	target_acceleration: Vector2 = Vector2.ZERO
) -> Vector2:
	return BdcVector2Extensions.from_vector4(
		velocity_from_time_to_hit_vector4(
			time_to_hit,
			BdcVector4Extensions.from_vector2(to_target),
			BdcVector4Extensions.from_vector2(target_velocity),
			BdcVector4Extensions.from_vector2(projectile_acceleration),
			BdcVector4Extensions.from_vector2(target_acceleration)
		)
	)


## Returns the velocity vector for a lead shot.
static func velocity_from_time_to_hit_vector3(
	time_to_hit: float,
	to_target: Vector3,
	target_velocity: Vector3 = Vector3.ZERO,
	projectile_acceleration: Vector3 = Vector3.ZERO,
	target_acceleration: Vector3 = Vector3.ZERO
) -> Vector3:
	return BdcVector3Extensions.from_vector4(
		velocity_from_time_to_hit_vector4(
			time_to_hit,
			BdcVector4Extensions.from_vector3(to_target),
			BdcVector4Extensions.from_vector3(target_velocity),
			BdcVector4Extensions.from_vector3(projectile_acceleration),
			BdcVector4Extensions.from_vector3(target_acceleration)
		)
	)


## Returns the velocity vector for a lead shot.
static func velocity_from_time_to_hit_vector4(
	time_to_hit: float,
	to_target: Vector4,
	target_velocity: Vector4 = Vector4.ZERO,
	projectile_acceleration: Vector4 = Vector4.ZERO,
	target_acceleration: Vector4 = Vector4.ZERO
) -> Vector4:
	if time_to_hit < 0 or is_zero_approx(time_to_hit): return Vector4.ZERO
	return to_target / time_to_hit + target_velocity - (projectile_acceleration - target_acceleration) * time_to_hit / 2
#endregion
#endregion
