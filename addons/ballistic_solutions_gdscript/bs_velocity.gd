@abstract class_name BsVelocity extends BallisticSolutions


## Provides methods for computing required firing velocities to hit a target under constant acceleration conditions.
##
## @tutorial(Ballistic Solutions): https://github.com/neclor/ballistic-solutions/blob/main/README.md


## Computes the firing velocity required to hit the target at a given interception time. [br]
## [b]Returns:[/b] The required firing velocity vector. Returns [constant @GDScript.NAN] vector if [param impact_time] ≤ 0.
static func firing_velocity(impact_time: float, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> Variant:
	var type: Variant.Type = typeof(to_target)
	match type:
		Variant.Type.TYPE_VECTOR2, Variant.Type.TYPE_VECTOR2I:
			return firing_velocity_vector2(impact_time, to_target, BsVector2Extensions.from_vector(target_velocity), BsVector2Extensions.from_vector(projectile_acceleration), BsVector2Extensions.from_vector(target_acceleration))

		Variant.Type.TYPE_VECTOR3, Variant.Type.TYPE_VECTOR3I:
			return firing_velocity_vector3(impact_time, to_target, BsVector3Extensions.from_vector(target_velocity), BsVector3Extensions.from_vector(projectile_acceleration), BsVector3Extensions.from_vector(target_acceleration))

		Variant.Type.TYPE_VECTOR4, Variant.Type.TYPE_VECTOR4I:
			return firing_velocity_vector4(impact_time, to_target, BsVector4Extensions.from_vector(target_velocity), BsVector4Extensions.from_vector(projectile_acceleration), BsVector4Extensions.from_vector(target_acceleration))

		_:
			_BsLogger._push_error("`Bsc.firing_velocity`: Unsupported type `" + type_string(type) + "`. Returned null.")
			return null


## See [method firing_velocity].
static func firing_velocity_vector4(impact_time: float, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Vector4:
	if impact_time < 0 or is_zero_approx(impact_time):
		_BsLogger._push_error("`Bsc.firing_velocity`: Zero or negative `impact_time`. Returned NAN_VECTOR.");
		return BsVector4Extensions.NAN_VECTOR

	return to_target / impact_time + target_velocity - (projectile_acceleration - target_acceleration) * impact_time / 2


## See [method firing_velocity].
static func firing_velocity_vector3(impact_time: float, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO, projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) -> Vector3:
	return BsVector3Extensions.from_vector4(firing_velocity_vector4(impact_time, BsVector4Extensions.from_vector3(to_target), BsVector4Extensions.from_vector3(target_velocity), BsVector4Extensions.from_vector3(projectile_acceleration), BsVector4Extensions.from_vector3(target_acceleration)))


## See [method firing_velocity].
static func firing_velocity_vector2(impact_time: float, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) -> Vector2:
	return BsVector2Extensions.from_vector4(firing_velocity_vector4(impact_time, BsVector4Extensions.from_vector2(to_target), BsVector4Extensions.from_vector2(target_velocity), BsVector4Extensions.from_vector2(projectile_acceleration), BsVector4Extensions.from_vector2(target_acceleration)))


## Computes the firing velocity required for the earliest valid interception. [br]
## [b]Returns:[/b] The required firing velocity vector. Returns [constant @GDScript.NAN] vector if interception is impossible.
static func best_firing_velocity(projectile_speed: float, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> Variant:
	var type: Variant.Type = typeof(to_target)
	match type:
		Variant.Type.TYPE_VECTOR2, Variant.Type.TYPE_VECTOR2I:
			return best_firing_velocity_vector2(projectile_speed, to_target, BsVector2Extensions.from_vector(target_velocity), BsVector2Extensions.from_vector(projectile_acceleration), BsVector2Extensions.from_vector(target_acceleration))

		Variant.Type.TYPE_VECTOR3, Variant.Type.TYPE_VECTOR3I:
			return best_firing_velocity_vector3(projectile_speed, to_target, BsVector3Extensions.from_vector(target_velocity), BsVector3Extensions.from_vector(projectile_acceleration), BsVector3Extensions.from_vector(target_acceleration))

		Variant.Type.TYPE_VECTOR4, Variant.Type.TYPE_VECTOR4I:
			return best_firing_velocity_vector4(projectile_speed, to_target, BsVector4Extensions.from_vector(target_velocity), BsVector4Extensions.from_vector(projectile_acceleration), BsVector4Extensions.from_vector(target_acceleration))

		_:
			_BsLogger._push_error("`Bsc.best_firing_velocity`: Unsupported type `" + type_string(type) + "`. Returned null.")
			return null


## See [method best_firing_velocity].
static func best_firing_velocity_vector4(projectile_speed: float, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Vector4:
	if projectile_speed < 0: _BsLogger._push_warning("`Bsc.best_firing_velocity`: Negative `projectile_speed`.")

	return firing_velocity_vector4(BsTime.best_impact_time_vector4(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration), to_target, target_velocity, projectile_acceleration, target_acceleration)


## See [method best_firing_velocity].
static func best_firing_velocity_vector3(projectile_speed: float, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO, projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) -> Vector3:
	return BsVector3Extensions.from_vector4(best_firing_velocity_vector4(projectile_speed, BsVector4Extensions.from_vector3(to_target), BsVector4Extensions.from_vector3(target_velocity), BsVector4Extensions.from_vector3(projectile_acceleration), BsVector4Extensions.from_vector3(target_acceleration)))


## See [method best_firing_velocity].
static func best_firing_velocity_vector2(projectile_speed: float, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) -> Vector2:
	return BsVector2Extensions.from_vector4(best_firing_velocity_vector4(projectile_speed, BsVector4Extensions.from_vector2(to_target), BsVector4Extensions.from_vector2(target_velocity), BsVector4Extensions.from_vector2(projectile_acceleration), BsVector4Extensions.from_vector2(target_acceleration)))


## Computes firing velocities for all valid interception times. [br]
## [b]Returns:[/b] An array of firing velocity vectors, one for each valid interception time.
static func firing_velocities(projectile_speed: float, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> Array[Variant]:
	var type: Variant.Type = typeof(to_target)
	match type:
		Variant.Type.TYPE_VECTOR2, Variant.Type.TYPE_VECTOR2I:
			return firing_velocities_vector2(projectile_speed, to_target, BsVector2Extensions.from_vector(target_velocity), BsVector2Extensions.from_vector(projectile_acceleration), BsVector2Extensions.from_vector(target_acceleration))

		Variant.Type.TYPE_VECTOR3, Variant.Type.TYPE_VECTOR3I:
			return firing_velocities_vector3(projectile_speed, to_target, BsVector3Extensions.from_vector(target_velocity), BsVector3Extensions.from_vector(projectile_acceleration), BsVector3Extensions.from_vector(target_acceleration))

		Variant.Type.TYPE_VECTOR4, Variant.Type.TYPE_VECTOR4I:
			return firing_velocities_vector4(projectile_speed, to_target, BsVector4Extensions.from_vector(target_velocity), BsVector4Extensions.from_vector(projectile_acceleration), BsVector4Extensions.from_vector(target_acceleration))

		_:
			_BsLogger._push_error("`Bsc.firing_velocities`: Unsupported type `" + type_string(type) + "`. Returned [].")
			return []


## See [method firing_velocities].
static func firing_velocities_vector4(projectile_speed: float, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Array[Vector4]:
	return Array(
		BsTime.impact_times_vector4(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration)
			.map(func(impact_time: float) -> Vector4: return firing_velocity_vector4(impact_time, to_target, target_velocity, projectile_acceleration, target_acceleration)),
		TYPE_VECTOR4,
		"",
		null
	)


## See [method firing_velocities].
static func firing_velocities_vector3(projectile_speed: float, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO, projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) -> Array[Vector3]:
	return Array(
		firing_velocities_vector4(projectile_speed, BsVector4Extensions.from_vector3(to_target), BsVector4Extensions.from_vector3(target_velocity), BsVector4Extensions.from_vector3(projectile_acceleration), BsVector4Extensions.from_vector3(target_acceleration))
			.map(func(firing_velocity: Vector4) -> Vector3: return BsVector3Extensions.from_vector4(firing_velocity)),
		TYPE_VECTOR3,
		"",
		null
	)


## See [method firing_velocities].
static func firing_velocities_vector2(projectile_speed: float, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) -> Array[Vector2]:
	return Array(
		firing_velocities_vector4(projectile_speed, BsVector4Extensions.from_vector2(to_target), BsVector4Extensions.from_vector2(target_velocity), BsVector4Extensions.from_vector2(projectile_acceleration), BsVector4Extensions.from_vector2(target_acceleration))
			.map(func(firing_velocity: Vector4) -> Vector2: return BsVector2Extensions.from_vector4(firing_velocity)),
		TYPE_VECTOR2,
		"",
		null
	)
