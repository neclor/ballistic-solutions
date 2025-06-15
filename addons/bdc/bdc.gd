class_name BDC extends Object


## Ballistic deflection calculator is a tool for calculating the shot vector considering speeds and accelerations for Godot.


#region Public
#region Velocities
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
			_vector4_from_vector2(to_target),
			_vector4_from_vector2(target_velocity),
			_vector4_from_vector2(projectile_acceleration),
			_vector4_from_vector2(target_acceleration)
		)
			.map(
				func(velocity: Vector4) -> Vector2: return _vector2_from_vector4(velocity)
			),
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
			_vector4_from_vector3(to_target),
			_vector4_from_vector3(target_velocity),
			_vector4_from_vector3(projectile_acceleration),
			_vector4_from_vector3(target_acceleration)
		)
			.map(
				func(velocity: Vector4) -> Vector3: return _vector3_from_vector4(velocity)
			),
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
		)
			.map(
				func(time: float) -> Vector4: return velocity_from_time_to_hit_vector4(
					time,
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
static func times_to_hit_vector2(
	projectile_speed: float,
	to_target: Vector2,
	target_velocity: Vector2 = Vector2.ZERO,
	projectile_acceleration: Vector2 = Vector2.ZERO,
	target_acceleration: Vector2 = Vector2.ZERO
) -> Array[float]:
	return times_to_hit_vector4(
		projectile_speed,
		_vector4_from_vector2(to_target),
		_vector4_from_vector2(target_velocity),
		_vector4_from_vector2(projectile_acceleration),
		_vector4_from_vector2(target_acceleration)
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
		_vector4_from_vector3(to_target),
		_vector4_from_vector3(target_velocity),
		_vector4_from_vector3(projectile_acceleration),
		_vector4_from_vector3(target_acceleration)
	)


## Returns a sorted array of times before the hit, if the hit is not possible, returns an empty array.
static func times_to_hit_vector4(
	projectile_speed: float,
	to_target: Vector4,
	target_velocity: Vector4 = Vector4.ZERO,
	projectile_acceleration: Vector4 = Vector4.ZERO,
	target_acceleration: Vector4 = Vector4.ZERO
) -> Array[float]:
	var v: float = projectile_speed
	var Pt: Vector4 = to_target
	var Vt: Vector4 = target_velocity
	var Ap: Vector4 = projectile_acceleration
	var At: Vector4 = target_acceleration
	var A: Vector4 = Ap - At

	var a: float = A.length_squared() / 4
	var b: float = -A.dot(Vt)
	var c: float = Vt.length_squared() - A.dot(Pt) - v ** 2
	var d: float = 2 * Vt.dot(Pt)
	var e: float = Pt.length_squared()

	return Array(
		RES.solve_quartic(a, b, c, d, e).filter(func(t: float) -> bool: return t >= 0),
		TYPE_FLOAT,
		"",
		null
	)
#endregion


#region Velocity From Time To Hit

## Returns the velocity vector for a lead shot.
static func velocity_from_time_to_hit_vector2(
	time_to_hit: float,
	to_target: Vector2,
	target_velocity: Vector2 = Vector2.ZERO,
	projectile_acceleration: Vector2 = Vector2.ZERO,
	target_acceleration: Vector2 = Vector2.ZERO
) -> Vector2:
	return _vector2_from_vector4(
		velocity_from_time_to_hit_vector4(
			time_to_hit,
			_vector4_from_vector2(to_target),
			_vector4_from_vector2(target_velocity),
			_vector4_from_vector2(projectile_acceleration),
			_vector4_from_vector2(target_acceleration)
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
	return _vector3_from_vector4(
		velocity_from_time_to_hit_vector4(
			time_to_hit,
			_vector4_from_vector3(to_target),
			_vector4_from_vector3(target_velocity),
			_vector4_from_vector3(projectile_acceleration),
			_vector4_from_vector3(target_acceleration)
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
	if is_zero_approx(time_to_hit): return Vector4.ZERO
	var A: Vector4 = projectile_acceleration - target_acceleration
	return to_target / time_to_hit + target_velocity - A * time_to_hit / 2
#endregion
#endregion

#region Private

static func _vector2_from_vector4(from: Vector4) -> Vector2:
	return Vector2(from.x, from.y)


static func _vector3_from_vector4(from: Vector4) -> Vector3:
	return Vector3(from.x, from.y, from.z)


static func _vector4_from_vector2(from: Vector2) -> Vector4:
	return Vector4(from.x, from.y, 0, 0)


static func _vector4_from_vector3(from: Vector3) -> Vector4:
	return Vector4(from.x, from.y, from.z, 0)

#endregion
