@abstract class_name BsTime extends BallisticSolutions


## Provides methods for computing interception times between a projectile and a moving target under constant acceleration.
##
## @tutorial(Ballistic Solutions): https://github.com/neclor/ballistic-solutions/blob/main/README.md


const _SCRIPT: GDScript = BsTime


#region all_times
## Computes all possible interception times between a projectile and a moving target. [br]
## [b]Returns:[/b] A sorted array of all valid interception times (t > 0). Empty if interception is impossible.
static func all_times(projectile_speed_or_direction: Variant, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> Array[float]:
	var type: Variant.Type = typeof(projectile_speed_or_direction)
	match type:
		Variant.Type.TYPE_INT, Variant.Type.TYPE_FLOAT:
			return all_by_speed(projectile_speed_or_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)
		Variant.Type.TYPE_VECTOR2, Variant.Type.TYPE_VECTOR2I, Variant.Type.TYPE_VECTOR3, Variant.Type.TYPE_VECTOR3I, Variant.Type.TYPE_VECTOR4, Variant.Type.TYPE_VECTOR4I:
			return all_by_direction(projectile_speed_or_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)
		_:
			_BsLogger.format_error(_SCRIPT, BsTime.all_times, "Unsupported type `%s`" % type_string(type), [])
			return []
#endregion


#region all_by_direction
## Computes all possible interception times using projectile direction. [br]
## [b]Returns:[/b] A sorted array of all valid interception times (t > 0). Empty if interception is impossible.
static func all_by_direction(projectile_direction: Variant, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> Array[float]:
	var type: Variant.Type = typeof(projectile_direction)
	match type:
		Variant.Type.TYPE_VECTOR2, Variant.Type.TYPE_VECTOR2I: return all_by_direction_vector2(projectile_direction, to_target, BsVector2Extensions.from_vector(target_velocity), BsVector2Extensions.from_vector(projectile_acceleration), BsVector2Extensions.from_vector(target_acceleration))
		Variant.Type.TYPE_VECTOR3, Variant.Type.TYPE_VECTOR3I: return all_by_direction_vector3(projectile_direction, to_target, BsVector3Extensions.from_vector(target_velocity), BsVector3Extensions.from_vector(projectile_acceleration), BsVector3Extensions.from_vector(target_acceleration))
		Variant.Type.TYPE_VECTOR4, Variant.Type.TYPE_VECTOR4I: return all_by_direction_vector4(projectile_direction, to_target, BsVector4Extensions.from_vector(target_velocity), BsVector4Extensions.from_vector(projectile_acceleration), BsVector4Extensions.from_vector(target_acceleration))
		_:
			_BsLogger.format_error(_SCRIPT, BsTime.all_by_direction, "Unsupported type `%s`" % type_string(type), [])
			return []


## See [method BsTime.all_by_direction].
static func all_by_direction_vector2(projectile_direction: Vector2, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) -> Array[float]:
	return all_by_direction_vector4(BsVector2Extensions.to_vector4(projectile_direction), BsVector2Extensions.to_vector4(to_target), BsVector2Extensions.to_vector4(target_velocity), BsVector2Extensions.to_vector4(projectile_acceleration), BsVector2Extensions.to_vector4(target_acceleration))


## See [method BsTime.all_by_direction].
static func all_by_direction_vector3(projectile_direction: Vector3, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO, projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) -> Array[float]:
	return all_by_direction_vector4(BsVector3Extensions.to_vector4(projectile_direction), BsVector3Extensions.to_vector4(to_target), BsVector3Extensions.to_vector4(target_velocity), BsVector3Extensions.to_vector4(projectile_acceleration), BsVector3Extensions.to_vector4(target_acceleration))


## See [method BsTime.all_by_direction].
static func all_by_direction_vector4(projectile_direction: Vector4, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Array[float]:
	return BsEquations.time_by_direction(projectile_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)
#endregion


#region all_by_speed
## Computes all possible interception times using projectile speed. [br]
## [b]Returns:[/b] A sorted array of all valid interception times (t > 0). Empty if interception is impossible.
static func all_by_speed(projectile_speed: float, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> Array[float]:
	if projectile_speed < 0: _BsLogger.format_warning(_SCRIPT, BsTime.all_by_speed, "Negative `projectile_speed`")
	var type: Variant.Type = typeof(to_target)
	match type:
		Variant.Type.TYPE_VECTOR2, Variant.Type.TYPE_VECTOR2I: return all_by_speed_vector2(projectile_speed, to_target, BsVector2Extensions.from_vector(target_velocity), BsVector2Extensions.from_vector(projectile_acceleration), BsVector2Extensions.from_vector(target_acceleration))
		Variant.Type.TYPE_VECTOR3, Variant.Type.TYPE_VECTOR3I: return all_by_speed_vector3(projectile_speed, to_target, BsVector3Extensions.from_vector(target_velocity), BsVector3Extensions.from_vector(projectile_acceleration), BsVector3Extensions.from_vector(target_acceleration))
		Variant.Type.TYPE_VECTOR4, Variant.Type.TYPE_VECTOR4I: return all_by_speed_vector4(projectile_speed, to_target, BsVector4Extensions.from_vector(target_velocity), BsVector4Extensions.from_vector(projectile_acceleration), BsVector4Extensions.from_vector(target_acceleration))
		_:
			_BsLogger.format_error(_SCRIPT, BsTime.all_by_speed, "Unsupported type `%s`" % type_string(type), [])
			return []


## See [method BsTime.all_by_speed].
static func all_by_speed_vector2(projectile_speed: float, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) -> Array[float]:
	return all_by_speed_vector4(projectile_speed, BsVector2Extensions.to_vector4(to_target), BsVector2Extensions.to_vector4(target_velocity), BsVector2Extensions.to_vector4(projectile_acceleration), BsVector2Extensions.to_vector4(target_acceleration))


## See [method BsTime.all_by_speed].
static func all_by_speed_vector3(projectile_speed: float, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO, projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) -> Array[float]:
	return all_by_speed_vector4(projectile_speed, BsVector3Extensions.to_vector4(to_target), BsVector3Extensions.to_vector4(target_velocity), BsVector3Extensions.to_vector4(projectile_acceleration), BsVector3Extensions.to_vector4(target_acceleration))


## See [method BsTime.all_by_speed].
static func all_by_speed_vector4(projectile_speed: float, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Array[float]:
	return BsEquations.time_by_speed(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration)
#endregion


#region best_time
## Computes the earliest interception time between a projectile and a moving target. [br]
## [b]Returns:[/b] The earliest interception time (t > 0). Returns [constant @GDScript.NAN] if no interception is possible.
static func best_time(projectile_speed_or_direction: Variant, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> float:
	var type: Variant.Type = typeof(projectile_speed_or_direction)
	match type:
		Variant.Type.TYPE_INT, Variant.Type.TYPE_FLOAT:
			return best_by_speed(projectile_speed_or_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)
		Variant.Type.TYPE_VECTOR2, Variant.Type.TYPE_VECTOR2I, Variant.Type.TYPE_VECTOR3, Variant.Type.TYPE_VECTOR3I, Variant.Type.TYPE_VECTOR4, Variant.Type.TYPE_VECTOR4I:
			return best_by_direction(projectile_speed_or_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)
		_:
			_BsLogger.format_error(_SCRIPT, BsTime.best_time, "Unsupported type `%s`" % type_string(type), NAN)
			return NAN
#endregion


#region best_by_direction
## Computes the earliest interception time using projectile direction. [br]
## [b]Returns:[/b] The earliest interception time (t > 0). Returns [constant @GDScript.NAN] if no interception is possible.
static func best_by_direction(projectile_direction: Variant, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> float:
	var type: Variant.Type = typeof(projectile_direction)
	match type:
		Variant.Type.TYPE_VECTOR2, Variant.Type.TYPE_VECTOR2I: return best_by_direction_vector2(projectile_direction, to_target, BsVector2Extensions.from_vector(target_velocity), BsVector2Extensions.from_vector(projectile_acceleration), BsVector2Extensions.from_vector(target_acceleration))
		Variant.Type.TYPE_VECTOR3, Variant.Type.TYPE_VECTOR3I: return best_by_direction_vector3(projectile_direction, to_target, BsVector3Extensions.from_vector(target_velocity), BsVector3Extensions.from_vector(projectile_acceleration), BsVector3Extensions.from_vector(target_acceleration))
		Variant.Type.TYPE_VECTOR4, Variant.Type.TYPE_VECTOR4I: return best_by_direction_vector4(projectile_direction, to_target, BsVector4Extensions.from_vector(target_velocity), BsVector4Extensions.from_vector(projectile_acceleration), BsVector4Extensions.from_vector(target_acceleration))
		_:
			_BsLogger.format_error(_SCRIPT, BsTime.best_by_direction, "Unsupported type `%s`" % type_string(type), NAN)
			return NAN


## See [method BsTime.best_by_direction].
static func best_by_direction_vector2(projectile_direction: Vector2, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) -> float:
	return best_by_direction_vector4(BsVector2Extensions.to_vector4(projectile_direction), BsVector2Extensions.to_vector4(to_target), BsVector2Extensions.to_vector4(target_velocity), BsVector2Extensions.to_vector4(projectile_acceleration), BsVector2Extensions.to_vector4(target_acceleration))


## See [method BsTime.best_by_direction].
static func best_by_direction_vector3(projectile_direction: Vector3, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO, projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) -> float:
	return best_by_direction_vector4(BsVector3Extensions.to_vector4(projectile_direction), BsVector3Extensions.to_vector4(to_target), BsVector3Extensions.to_vector4(target_velocity), BsVector3Extensions.to_vector4(projectile_acceleration), BsVector3Extensions.to_vector4(target_acceleration))


## See [method BsTime.best_by_direction].
static func best_by_direction_vector4(projectile_direction: Vector4, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> float:
	var times: Array[float] = all_by_direction_vector4(projectile_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)
	return NAN if times.is_empty() else times[0]
#endregion


#region best_by_speed
## Computes the earliest interception time using projectile speed. [br]
## [b]Returns:[/b] The earliest interception time (t > 0). Returns [constant @GDScript.NAN] if no interception is possible.
static func best_by_speed(projectile_speed: float, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> float:
	if projectile_speed < 0: _BsLogger.format_warning(_SCRIPT, BsTime.best_by_speed, "Negative `projectile_speed`")
	var type: Variant.Type = typeof(to_target)
	match type:
		Variant.Type.TYPE_VECTOR2, Variant.Type.TYPE_VECTOR2I: return best_by_speed_vector2(projectile_speed, to_target, BsVector2Extensions.from_vector(target_velocity), BsVector2Extensions.from_vector(projectile_acceleration), BsVector2Extensions.from_vector(target_acceleration))
		Variant.Type.TYPE_VECTOR3, Variant.Type.TYPE_VECTOR3I: return best_by_speed_vector3(projectile_speed, to_target, BsVector3Extensions.from_vector(target_velocity), BsVector3Extensions.from_vector(projectile_acceleration), BsVector3Extensions.from_vector(target_acceleration))
		Variant.Type.TYPE_VECTOR4, Variant.Type.TYPE_VECTOR4I: return best_by_speed_vector4(projectile_speed, to_target, BsVector4Extensions.from_vector(target_velocity), BsVector4Extensions.from_vector(projectile_acceleration), BsVector4Extensions.from_vector(target_acceleration))
		_:
			_BsLogger.format_error(_SCRIPT, BsTime.best_by_speed, "Unsupported type `%s`" % type_string(type), NAN)
			return NAN


## See [method BsTime.best_by_speed].
static func best_by_speed_vector2(projectile_speed: float, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) -> float:
	return best_by_speed_vector4(projectile_speed, BsVector2Extensions.to_vector4(to_target), BsVector2Extensions.to_vector4(target_velocity), BsVector2Extensions.to_vector4(projectile_acceleration), BsVector2Extensions.to_vector4(target_acceleration))


## See [method BsTime.best_by_speed].
static func best_by_speed_vector3(projectile_speed: float, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO, projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) -> float:
	return best_by_speed_vector4(projectile_speed, BsVector3Extensions.to_vector4(to_target), BsVector3Extensions.to_vector4(target_velocity), BsVector3Extensions.to_vector4(projectile_acceleration), BsVector3Extensions.to_vector4(target_acceleration))


## See [method BsTime.best_by_speed].
static func best_by_speed_vector4(projectile_speed: float, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> float:
	var times: Array[float] = all_by_speed_vector4(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration)
	return NAN if times.is_empty() else times[0]
#endregion


#region deprecated
## @deprecated Use [method BsTime.all_times] instead.
static func all_impact_times(projectile_speed_or_direction: Variant, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> Array[float]:
	return all_times(projectile_speed_or_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsTime.all_by_direction] instead.
static func all_impact_times_by_direction(projectile_direction: Variant, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> Array[float]:
	return all_by_direction(projectile_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsTime.all_by_direction_vector2] instead.
static func all_impact_times_by_direction_vector2(projectile_direction: Vector2, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) -> Array[float]:
	return all_by_direction_vector2(projectile_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsTime.all_by_direction_vector3] instead.
static func all_impact_times_by_direction_vector3(projectile_direction: Vector3, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO, projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) -> Array[float]:
	return all_by_direction_vector3(projectile_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsTime.all_by_direction_vector4] instead.
static func all_impact_times_by_direction_vector4(projectile_direction: Vector4, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Array[float]:
	return all_by_direction_vector4(projectile_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsTime.all_by_speed] instead.
static func all_impact_times_by_speed(projectile_speed: float, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> Array[float]:
	return all_by_speed(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsTime.all_by_speed_vector2] instead.
static func all_impact_times_by_speed_vector2(projectile_speed: float, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) -> Array[float]:
	return all_by_speed_vector2(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsTime.all_by_speed_vector3] instead.
static func all_impact_times_by_speed_vector3(projectile_speed: float, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO, projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) -> Array[float]:
	return all_by_speed_vector3(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsTime.all_by_speed_vector4] instead.
static func all_impact_times_by_speed_vector4(projectile_speed: float, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Array[float]:
	return all_by_speed_vector4(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsTime.best_time] instead.
static func best_impact_time(projectile_speed_or_direction: Variant, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> float:
	return best_time(projectile_speed_or_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsTime.best_by_direction] instead.
static func best_impact_time_by_direction(projectile_direction: Variant, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> float:
	return best_by_direction(projectile_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsTime.best_by_direction_vector2] instead.
static func best_impact_time_by_direction_vector2(projectile_direction: Vector2, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) -> float:
	return best_by_direction_vector2(projectile_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsTime.best_by_direction_vector3] instead.
static func best_impact_time_by_direction_vector3(projectile_direction: Vector3, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO, projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) -> float:
	return best_by_direction_vector3(projectile_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsTime.best_by_direction_vector4] instead.
static func best_impact_time_by_direction_vector4(projectile_direction: Vector4, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> float:
	return best_by_direction_vector4(projectile_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsTime.best_by_speed] instead.
static func best_impact_time_by_speed(projectile_speed: float, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> float:
	return best_by_speed(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsTime.best_by_speed_vector2] instead.
static func best_impact_time_by_speed_vector2(projectile_speed: float, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) -> float:
	return best_by_speed_vector2(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsTime.best_by_speed_vector3] instead.
static func best_impact_time_by_speed_vector3(projectile_speed: float, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO, projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) -> float:
	return best_by_speed_vector3(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsTime.best_by_speed_vector4] instead.
static func best_impact_time_by_speed_vector4(projectile_speed: float, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> float:
	return best_by_speed_vector4(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration)
#endregion
