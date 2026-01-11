@abstract class_name BsTime extends BallisticSolutions


## Provides methods for computing interception times between a projectile and a moving target under constant acceleration.
##
## @tutorial(Ballistic Solutions): https://github.com/neclor/ballistic-solutions/blob/main/README.md


## Computes all possible interception times between a projectile and a moving target. [br]
## [b]Returns:[/b] A sorted array of all valid interception times (t > 0). Empty if interception is impossible.
static func all_impact_times(projectile_speed: float, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> Array[float]:
	var type: Variant.Type = typeof(to_target)
	match type:
		Variant.Type.TYPE_VECTOR2, Variant.Type.TYPE_VECTOR2I: return all_impact_times_by_speed_vector2(projectile_speed, to_target, BsVector2Extensions.from_vector(target_velocity), BsVector2Extensions.from_vector(projectile_acceleration), BsVector2Extensions.from_vector(target_acceleration))
		Variant.Type.TYPE_VECTOR3, Variant.Type.TYPE_VECTOR3I: return all_impact_times_by_speed_vector3(projectile_speed, to_target, BsVector3Extensions.from_vector(target_velocity), BsVector3Extensions.from_vector(projectile_acceleration), BsVector3Extensions.from_vector(target_acceleration))
		Variant.Type.TYPE_VECTOR4, Variant.Type.TYPE_VECTOR4I: return all_impact_times_by_speed_vector4(projectile_speed, to_target, BsVector4Extensions.from_vector(target_velocity), BsVector4Extensions.from_vector(projectile_acceleration), BsVector4Extensions.from_vector(target_acceleration))
		_:
			_BsLogger._push_error("`Bsc.impact_times`: Unsupported type `" + type_string(type) + "`. Returned [].")
			return []




## Computes all possible interception times between a projectile and a moving target. [br]
## [b]Returns:[/b] A sorted array of all valid interception times (t > 0). Empty if interception is impossible.
static func all_impact_times_by_speed(projectile_speed: float, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> Array[float]:
	var type: Variant.Type = typeof(to_target)
	match type:
		Variant.Type.TYPE_VECTOR2, Variant.Type.TYPE_VECTOR2I: return all_impact_times_by_speed_vector2(projectile_speed, to_target, BsVector2Extensions.from_vector(target_velocity), BsVector2Extensions.from_vector(projectile_acceleration), BsVector2Extensions.from_vector(target_acceleration))
		Variant.Type.TYPE_VECTOR3, Variant.Type.TYPE_VECTOR3I: return all_impact_times_by_speed_vector3(projectile_speed, to_target, BsVector3Extensions.from_vector(target_velocity), BsVector3Extensions.from_vector(projectile_acceleration), BsVector3Extensions.from_vector(target_acceleration))
		Variant.Type.TYPE_VECTOR4, Variant.Type.TYPE_VECTOR4I: return all_impact_times_by_speed_vector4(projectile_speed, to_target, BsVector4Extensions.from_vector(target_velocity), BsVector4Extensions.from_vector(projectile_acceleration), BsVector4Extensions.from_vector(target_acceleration))
		_:
			_BsLogger._push_error("`Bsc.impact_times`: Unsupported type `" + type_string(type) + "`. Returned [].")
			return []


## See [method impact_times].
static func all_impact_times_by_speed_vector2(projectile_speed: float, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) -> Array[float]:
	return all_impact_times_by_speed_vector4(projectile_speed, BsVector4Extensions.from_vector2(to_target), BsVector4Extensions.from_vector2(target_velocity), BsVector4Extensions.from_vector2(projectile_acceleration), BsVector4Extensions.from_vector2(target_acceleration))


## See [method impact_times].
static func all_impact_times_by_speed_vector3(projectile_speed: float, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO,projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) -> Array[float]:
	return all_impact_times_by_speed_vector4(projectile_speed, BsVector4Extensions.from_vector3(to_target), BsVector4Extensions.from_vector3(target_velocity), BsVector4Extensions.from_vector3(projectile_acceleration), BsVector4Extensions.from_vector3(target_acceleration))


## See [method impact_times].
static func all_impact_times_by_speed_vector4(projectile_speed: float, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Array[float]:
	if projectile_speed < 0: _BsLogger._push_warning("`BsTime.all_impact_times`: Negative `projectile_speed`.")
	
	var relative_acceleration: Vector4 = projectile_acceleration - target_acceleration

	var a: float = relative_acceleration.length_squared() / 4
	var b: float = -relative_acceleration.dot(target_velocity)
	var c: float = target_velocity.length_squared() - relative_acceleration.dot(to_target) - projectile_speed * projectile_speed
	var d: float = 2 * target_velocity.dot(to_target)
	var e: float = to_target.length_squared()

	var all_impact_times: Array[float] = Array(Res.quartic(a, b, c, d, e).filter(func(i: float) -> bool: return i > 0), TYPE_FLOAT, "", null)
	all_impact_times.sort()
	return all_impact_times





## See [method impact_times].
static func all_impact_times_by_direction_vector4(projectile_direction: Vector4, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Array[float]:
	var relative_acceleration: Vector4 = projectile_acceleration - target_acceleration

	

	var a: float = 0
	var b: float = 0
	var c: float = 0
	var d: float = 0
	var e: float = 0

	var all_impact_times: Array[float] = Array(
		Res.quartic(a, b, c, d, e).filter(func(i: float) -> bool: return i > 0),
		TYPE_FLOAT,
		"",
		null
	)
	all_impact_times.sort()
	return all_impact_times








## Computes the earliest positive interception time between a projectile and a moving target. [br]
## [b]Returns:[/b] The earliest interception time (t > 0). Returns [constant @GDScript.NAN] if no interception is possible.
static func best_impact_time_by_speed(projectile_speed: float, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> float:
	var type: Variant.Type = typeof(to_target)
	match type:
		Variant.Type.TYPE_VECTOR2, Variant.Type.TYPE_VECTOR2I: return best_impact_time_by_speed_vector2(projectile_speed, to_target, BsVector2Extensions.from_vector(target_velocity), BsVector2Extensions.from_vector(projectile_acceleration), BsVector2Extensions.from_vector(target_acceleration))
		Variant.Type.TYPE_VECTOR3, Variant.Type.TYPE_VECTOR3I: return best_impact_time_by_speed_vector3(projectile_speed, to_target, BsVector3Extensions.from_vector(target_velocity), BsVector3Extensions.from_vector(projectile_acceleration), BsVector3Extensions.from_vector(target_acceleration))
		Variant.Type.TYPE_VECTOR4, Variant.Type.TYPE_VECTOR4I: return best_impact_time_by_speed_vector4(projectile_speed, to_target, BsVector4Extensions.from_vector(target_velocity),  BsVector4Extensions.from_vector(projectile_acceleration), BsVector4Extensions.from_vector(target_acceleration))
		_:
			_BsLogger._push_error("`Bsc.best_impact_time`: Unsupported type `" + type_string(type) + "`. Returned NAN.")
			return NAN


## See [method best_impact_time].
static func best_impact_time_by_speed_vector3(projectile_speed: float, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO, projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) -> float:
	return best_impact_time_by_speed_vector4(projectile_speed, BsVector4Extensions.from_vector3(to_target), BsVector4Extensions.from_vector3(target_velocity), BsVector4Extensions.from_vector3(projectile_acceleration), BsVector4Extensions.from_vector3(target_acceleration))


## See [method best_impact_time].
static func best_impact_time_by_speed_vector2(projectile_speed: float, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) -> float:
	return best_impact_time_by_speed_vector4(projectile_speed, BsVector4Extensions.from_vector2(to_target), BsVector4Extensions.from_vector2(target_velocity), BsVector4Extensions.from_vector2(projectile_acceleration), BsVector4Extensions.from_vector2(target_acceleration))


## See [method best_impact_time].
static func best_impact_time_by_speed_vector4(projectile_speed: float, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> float:
	if projectile_speed < 0: _BsLogger._push_warning("`BsTime.best_impact_time`: Negative `projectile_speed`.")
	var impact_times: Array[float] = all_impact_times_by_speed_vector4(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration);
	return NAN if impact_times.is_empty() else impact_times[0];
