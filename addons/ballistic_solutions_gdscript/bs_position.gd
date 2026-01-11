@abstract class_name BsPosition extends BallisticSolutions


## Provides methods for computing projectile positions, impact positions, and displacement calculations under constant acceleration.
##
## @tutorial(Ballistic Solutions): https://github.com/neclor/ballistic-solutions/blob/main/README.md


## Computes the impact position of the earliest valid interception. [br]
## [b]Returns:[/b] The impact position vector. Returns [constant @GDScript.NAN] vector if interception is impossible.
static func best_impact_position(projectile_speed: float, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> Variant:
	var type: Variant.Type = typeof(to_target)
	match type:
		Variant.Type.TYPE_VECTOR2, Variant.Type.TYPE_VECTOR2I: return best_impact_position_vector2(projectile_speed, to_target, BsVector2Extensions.from_vector(target_velocity), BsVector2Extensions.from_vector(projectile_acceleration), BsVector2Extensions.from_vector(target_acceleration))
		Variant.Type.TYPE_VECTOR3, Variant.Type.TYPE_VECTOR3I: return best_impact_position_vector3(projectile_speed, to_target, BsVector3Extensions.from_vector(target_velocity), BsVector3Extensions.from_vector(projectile_acceleration), BsVector3Extensions.from_vector(target_acceleration))
		Variant.Type.TYPE_VECTOR4, Variant.Type.TYPE_VECTOR4I: return best_impact_position_vector4(projectile_speed, to_target, BsVector4Extensions.from_vector(target_velocity), BsVector4Extensions.from_vector(projectile_acceleration), BsVector4Extensions.from_vector(target_acceleration))
		_:
			_BsLogger._push_error("`Bsc.best_impact_position`: Unsupported type `" + type_string(type) + "`. Returned null.")
			return null


## See [method best_impact_position].
static func best_impact_position_vector4(projectile_speed: float, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Vector4:
	if projectile_speed < 0: _BsLogger._push_warning("`Bsc.best_impact_position`: Negative `projectile_speed`.");
	return to_target + displacement_vector4(BsTime.best_impact_time_vector4(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration), target_velocity, target_acceleration)


## See [method best_impact_position].
static func best_impact_position_vector3(projectile_speed: float, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO, projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) -> Vector3:
	return BsVector4Extensions.to_vector3(best_impact_position_vector4(projectile_speed, BsVector3Extensions.to_vector4(to_target), BsVector3Extensions.to_vector4(target_velocity), BsVector3Extensions.to_vector4(projectile_acceleration), BsVector3Extensions.to_vector4(target_acceleration)))


## See [method best_impact_position].
static func best_impact_position_vector2(projectile_speed: float, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) -> Vector2:
	return BsVector4Extensions.to_vector2(best_impact_position_vector4(projectile_speed, BsVector2Extensions.to_vector4(to_target), BsVector2Extensions.to_vector4(target_velocity), BsVector2Extensions.to_vector4(projectile_acceleration), BsVector2Extensions.to_vector4(target_acceleration)))


## Computes displacement under constant acceleration. [br]
## [b]Returns:[/b] The displacement vector after [param time] has elapsed.
static func displacement(time: float, velocity: Variant, acceleration: Variant = Vector4.ZERO) -> Variant:
	var type: Variant.Type = typeof(velocity)
	match type:
		Variant.Type.TYPE_VECTOR2, Variant.Type.TYPE_VECTOR2I: return displacement_vector2(time, velocity, BsVector2Extensions.from_vector(acceleration))
		Variant.Type.TYPE_VECTOR3, Variant.Type.TYPE_VECTOR3I: return displacement_vector3(time, velocity, BsVector3Extensions.from_vector(acceleration))
		Variant.Type.TYPE_VECTOR4, Variant.Type.TYPE_VECTOR4I: return displacement_vector4(time, velocity, BsVector4Extensions.from_vector(acceleration))
		_:
			_BsLogger._push_error("`Bsc.displacement`: Unsupported type `" + type_string(type) + "`. Returned null.")
			return null


## See [method displacement].
static func displacement_vector4(time: float, velocity: Vector4, acceleration: Vector4 = Vector4.ZERO) -> Vector4:
	return time * (velocity + acceleration * time / 2)


## See [method displacement].
static func displacement_vector3(time: float, velocity: Vector3, acceleration: Vector3 = Vector3.ZERO) -> Vector3:
	return BsVector4Extensions.to_vector3(displacement_vector4(time, BsVector3Extensions.to_vector4(velocity), BsVector3Extensions.to_vector4(acceleration)))


## See [method displacement].
static func displacement_vector2(time: float, velocity: Vector2, acceleration: Vector2 = Vector2.ZERO) -> Vector2:
	return BsVector4Extensions.to_vector2(displacement_vector4(time, BsVector2Extensions.to_vector4(velocity), BsVector2Extensions.to_vector4(acceleration)))






## Computes all possible impact positions corresponding to valid interception times. [br]
## [b]Returns:[/b] An array of vectors representing all valid impact positions.
static func impact_positions(projectile_speed: float, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> Array:
	var type: Variant.Type = typeof(to_target)
	match type:
		Variant.Type.TYPE_VECTOR2, Variant.Type.TYPE_VECTOR2I:
			return impact_positions_vector2(projectile_speed, to_target, BsVector2Extensions.from_vector(target_velocity), BsVector2Extensions.from_vector(projectile_acceleration), BsVector2Extensions.from_vector(target_acceleration))

		Variant.Type.TYPE_VECTOR3, Variant.Type.TYPE_VECTOR3I:
			return impact_positions_vector3(projectile_speed, to_target, BsVector3Extensions.from_vector(target_velocity), BsVector3Extensions.from_vector(projectile_acceleration), BsVector3Extensions.from_vector(target_acceleration))

		Variant.Type.TYPE_VECTOR4, Variant.Type.TYPE_VECTOR4I:
			return impact_positions_vector4(projectile_speed, to_target, BsVector4Extensions.from_vector(target_velocity), BsVector4Extensions.from_vector(projectile_acceleration), BsVector4Extensions.from_vector(target_acceleration))

		_:
			_BsLogger._push_error("`Bsc.impact_positions`: Unsupported type `" + type_string(type) + "`. Returned [].")
			return []


## See [method impact_positions].
static func impact_positions_vector4(projectile_speed: float, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Array[Vector4]:
	if projectile_speed < 0: _BsLogger._push_warning("`Bsc.impact_positions`: Negative `projectile_speed`.");

	return Array(
		BsTime.impact_times_vector4(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration)
			.map(func(impact_time: float) -> Vector4: return to_target + displacement_vector4(impact_time, target_velocity, target_acceleration)),
		TYPE_VECTOR4,
		"",
		null
	)


## See [method impact_positions].
static func impact_positions_vector3(projectile_speed: float, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO, projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) -> Array[Vector3]:
	return Array(
		impact_positions_vector4(projectile_speed, BsVector3Extensions.to_vector4(to_target), BsVector3Extensions.to_vector4(target_velocity), BsVector3Extensions.to_vector4(projectile_acceleration), BsVector3Extensions.to_vector4(target_acceleration))
			.map(func(impact_position: Vector4) -> Vector3: return BsVector4Extensions.to_vector3(impact_position)),
		TYPE_VECTOR3,
		"",
		null
	)


## See [method impact_positions].
static func impact_positions_vector2(projectile_speed: float, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) -> Array[Vector2]:
	return Array(
		impact_positions_vector4(projectile_speed, BsVector2Extensions.to_vector4(to_target), BsVector2Extensions.to_vector4(target_velocity), BsVector2Extensions.to_vector4(projectile_acceleration), BsVector2Extensions.to_vector4(target_acceleration))
			.map(func(impact_position: Vector4) -> Vector2: return BsVector4Extensions.to_vector2(impact_position)),
		TYPE_VECTOR2,
		"",
		null
	)
