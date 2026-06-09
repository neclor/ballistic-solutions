@abstract class_name BsPosition extends BallisticSolutions


## Provides methods for computing projectile positions, impact positions, and displacement calculations under constant acceleration.
##
## @tutorial(Ballistic Solutions): https://github.com/neclor/ballistic-solutions/blob/main/README.md


const _SCRIPT: GDScript = BsPosition


#region all_positions
## Computes all possible impact positions corresponding to valid interception times. [br]
## [b]Returns:[/b] An array of vectors representing all valid impact positions.
static func all_positions(projectile_speed_or_direction: Variant, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> Array[Variant]:
	var type: Variant.Type = typeof(projectile_speed_or_direction)
	match type:
		Variant.Type.TYPE_INT, Variant.Type.TYPE_FLOAT:
			return all_by_speed(projectile_speed_or_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)
		Variant.Type.TYPE_VECTOR2, Variant.Type.TYPE_VECTOR2I, Variant.Type.TYPE_VECTOR3, Variant.Type.TYPE_VECTOR3I, Variant.Type.TYPE_VECTOR4, Variant.Type.TYPE_VECTOR4I:
			return all_by_direction(projectile_speed_or_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)
		_:
			_BsLogger.format_error(_SCRIPT, BsPosition.all_positions, "Unsupported type `%s`" % type_string(type), [])
			return []
#endregion


#region all_by_direction
## Computes all possible impact positions using projectile direction. [br]
## [b]Returns:[/b] An array of vectors representing all valid impact positions.
static func all_by_direction(projectile_direction: Variant, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> Array[Variant]:
	var type: Variant.Type = typeof(projectile_direction)
	match type:
		Variant.Type.TYPE_VECTOR2, Variant.Type.TYPE_VECTOR2I: return all_by_direction_vector2(projectile_direction, to_target, BsVector2Extensions.from_vector(target_velocity), BsVector2Extensions.from_vector(projectile_acceleration), BsVector2Extensions.from_vector(target_acceleration))
		Variant.Type.TYPE_VECTOR3, Variant.Type.TYPE_VECTOR3I: return all_by_direction_vector3(projectile_direction, to_target, BsVector3Extensions.from_vector(target_velocity), BsVector3Extensions.from_vector(projectile_acceleration), BsVector3Extensions.from_vector(target_acceleration))
		Variant.Type.TYPE_VECTOR4, Variant.Type.TYPE_VECTOR4I: return all_by_direction_vector4(projectile_direction, to_target, BsVector4Extensions.from_vector(target_velocity), BsVector4Extensions.from_vector(projectile_acceleration), BsVector4Extensions.from_vector(target_acceleration))
		_:
			_BsLogger.format_error(_SCRIPT, BsPosition.all_by_direction, "Unsupported type `%s`" % type_string(type), [])
			return []


## See [method BsPosition.all_by_direction].
static func all_by_direction_vector2(projectile_direction: Vector2, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) -> Array[Vector2]:
	return Array(
		all_by_direction_vector4(BsVector2Extensions.to_vector4(projectile_direction), BsVector2Extensions.to_vector4(to_target), BsVector2Extensions.to_vector4(target_velocity), BsVector2Extensions.to_vector4(projectile_acceleration), BsVector2Extensions.to_vector4(target_acceleration))
			.map(func(p: Vector4) -> Vector2: return BsVector4Extensions.to_vector2(p)),
		Variant.Type.TYPE_VECTOR2, "", null
	)


## See [method BsPosition.all_by_direction].
static func all_by_direction_vector3(projectile_direction: Vector3, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO, projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) -> Array[Vector3]:
	return Array(
		all_by_direction_vector4(BsVector3Extensions.to_vector4(projectile_direction), BsVector3Extensions.to_vector4(to_target), BsVector3Extensions.to_vector4(target_velocity), BsVector3Extensions.to_vector4(projectile_acceleration), BsVector3Extensions.to_vector4(target_acceleration))
			.map(func(p: Vector4) -> Vector3: return BsVector4Extensions.to_vector3(p)),
		Variant.Type.TYPE_VECTOR3, "", null
	)


## See [method BsPosition.all_by_direction].
static func all_by_direction_vector4(projectile_direction: Vector4, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Array[Vector4]:
	return Array(
		BsTime.all_by_direction_vector4(projectile_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)
			.map(func(t: float) -> Vector4: return position_vector4(to_target, t, target_velocity, target_acceleration)),
		Variant.Type.TYPE_VECTOR4, "", null
	)
#endregion


#region all_by_speed
## Computes all possible impact positions using projectile speed. [br]
## [b]Returns:[/b] An array of vectors representing all valid impact positions.
static func all_by_speed(projectile_speed: float, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> Array[Variant]:
	if projectile_speed < 0: _BsLogger.format_warning(_SCRIPT, BsPosition.all_by_speed, "Negative `projectile_speed`")
	var type: Variant.Type = typeof(to_target)
	match type:
		Variant.Type.TYPE_VECTOR2, Variant.Type.TYPE_VECTOR2I: return all_by_speed_vector2(projectile_speed, to_target, BsVector2Extensions.from_vector(target_velocity), BsVector2Extensions.from_vector(projectile_acceleration), BsVector2Extensions.from_vector(target_acceleration))
		Variant.Type.TYPE_VECTOR3, Variant.Type.TYPE_VECTOR3I: return all_by_speed_vector3(projectile_speed, to_target, BsVector3Extensions.from_vector(target_velocity), BsVector3Extensions.from_vector(projectile_acceleration), BsVector3Extensions.from_vector(target_acceleration))
		Variant.Type.TYPE_VECTOR4, Variant.Type.TYPE_VECTOR4I: return all_by_speed_vector4(projectile_speed, to_target, BsVector4Extensions.from_vector(target_velocity), BsVector4Extensions.from_vector(projectile_acceleration), BsVector4Extensions.from_vector(target_acceleration))
		_:
			_BsLogger.format_error(_SCRIPT, BsPosition.all_by_speed, "Unsupported type `%s`" % type_string(type), [])
			return []


## See [method BsPosition.all_by_speed].
static func all_by_speed_vector2(projectile_speed: float, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) -> Array[Vector2]:
	return Array(
		all_by_speed_vector4(projectile_speed, BsVector2Extensions.to_vector4(to_target), BsVector2Extensions.to_vector4(target_velocity), BsVector2Extensions.to_vector4(projectile_acceleration), BsVector2Extensions.to_vector4(target_acceleration))
			.map(func(p: Vector4) -> Vector2: return BsVector4Extensions.to_vector2(p)),
		Variant.Type.TYPE_VECTOR2, "", null
	)


## See [method BsPosition.all_by_speed].
static func all_by_speed_vector3(projectile_speed: float, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO, projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) -> Array[Vector3]:
	return Array(
		all_by_speed_vector4(projectile_speed, BsVector3Extensions.to_vector4(to_target), BsVector3Extensions.to_vector4(target_velocity), BsVector3Extensions.to_vector4(projectile_acceleration), BsVector3Extensions.to_vector4(target_acceleration))
			.map(func(p: Vector4) -> Vector3: return BsVector4Extensions.to_vector3(p)),
		Variant.Type.TYPE_VECTOR3, "", null
	)


## See [method BsPosition.all_by_speed].
static func all_by_speed_vector4(projectile_speed: float, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Array[Vector4]:
	return Array(
		BsTime.all_by_speed_vector4(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration)
			.map(func(t: float) -> Vector4: return position_vector4(to_target, t, target_velocity, target_acceleration)),
		Variant.Type.TYPE_VECTOR4, "", null
	)
#endregion


#region best_position
## Computes the impact position of the earliest valid interception. [br]
## [b]Returns:[/b] The impact position vector. Returns a NaN vector if interception is impossible.
static func best_position(projectile_speed_or_direction: Variant, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> Variant:
	var type: Variant.Type = typeof(projectile_speed_or_direction)
	match type:
		Variant.Type.TYPE_INT, Variant.Type.TYPE_FLOAT:
			return best_by_speed(projectile_speed_or_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)
		Variant.Type.TYPE_VECTOR2, Variant.Type.TYPE_VECTOR2I, Variant.Type.TYPE_VECTOR3, Variant.Type.TYPE_VECTOR3I, Variant.Type.TYPE_VECTOR4, Variant.Type.TYPE_VECTOR4I:
			return best_by_direction(projectile_speed_or_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)
		_:
			_BsLogger.format_error(_SCRIPT, BsPosition.best_position, "Unsupported type `%s`" % type_string(type), null)
			return null
#endregion


#region best_by_direction
## Computes the impact position of the earliest valid interception using projectile direction. [br]
## [b]Returns:[/b] The impact position vector. Returns a NaN vector if interception is impossible.
static func best_by_direction(projectile_direction: Variant, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> Variant:
	var type: Variant.Type = typeof(projectile_direction)
	match type:
		Variant.Type.TYPE_VECTOR2, Variant.Type.TYPE_VECTOR2I: return best_by_direction_vector2(projectile_direction, to_target, BsVector2Extensions.from_vector(target_velocity), BsVector2Extensions.from_vector(projectile_acceleration), BsVector2Extensions.from_vector(target_acceleration))
		Variant.Type.TYPE_VECTOR3, Variant.Type.TYPE_VECTOR3I: return best_by_direction_vector3(projectile_direction, to_target, BsVector3Extensions.from_vector(target_velocity), BsVector3Extensions.from_vector(projectile_acceleration), BsVector3Extensions.from_vector(target_acceleration))
		Variant.Type.TYPE_VECTOR4, Variant.Type.TYPE_VECTOR4I: return best_by_direction_vector4(projectile_direction, to_target, BsVector4Extensions.from_vector(target_velocity), BsVector4Extensions.from_vector(projectile_acceleration), BsVector4Extensions.from_vector(target_acceleration))
		_:
			_BsLogger.format_error(_SCRIPT, BsPosition.best_by_direction, "Unsupported type `%s`" % type_string(type), null)
			return null


## See [method BsPosition.best_by_direction].
static func best_by_direction_vector2(projectile_direction: Vector2, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) -> Vector2:
	return BsVector4Extensions.to_vector2(best_by_direction_vector4(BsVector2Extensions.to_vector4(projectile_direction), BsVector2Extensions.to_vector4(to_target), BsVector2Extensions.to_vector4(target_velocity), BsVector2Extensions.to_vector4(projectile_acceleration), BsVector2Extensions.to_vector4(target_acceleration)))


## See [method BsPosition.best_by_direction].
static func best_by_direction_vector3(projectile_direction: Vector3, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO, projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) -> Vector3:
	return BsVector4Extensions.to_vector3(best_by_direction_vector4(BsVector3Extensions.to_vector4(projectile_direction), BsVector3Extensions.to_vector4(to_target), BsVector3Extensions.to_vector4(target_velocity), BsVector3Extensions.to_vector4(projectile_acceleration), BsVector3Extensions.to_vector4(target_acceleration)))


## See [method BsPosition.best_by_direction].
static func best_by_direction_vector4(projectile_direction: Vector4, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Vector4:
	return position_vector4(to_target, BsTime.best_by_direction_vector4(projectile_direction, to_target, target_velocity, projectile_acceleration, target_acceleration), target_velocity, target_acceleration)
#endregion


#region best_by_speed
## Computes the impact position of the earliest valid interception using projectile speed. [br]
## [b]Returns:[/b] The impact position vector. Returns a NaN vector if interception is impossible.
static func best_by_speed(projectile_speed: float, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> Variant:
	if projectile_speed < 0: _BsLogger.format_warning(_SCRIPT, BsPosition.best_by_speed, "Negative `projectile_speed`")
	var type: Variant.Type = typeof(to_target)
	match type:
		Variant.Type.TYPE_VECTOR2, Variant.Type.TYPE_VECTOR2I: return best_by_speed_vector2(projectile_speed, to_target, BsVector2Extensions.from_vector(target_velocity), BsVector2Extensions.from_vector(projectile_acceleration), BsVector2Extensions.from_vector(target_acceleration))
		Variant.Type.TYPE_VECTOR3, Variant.Type.TYPE_VECTOR3I: return best_by_speed_vector3(projectile_speed, to_target, BsVector3Extensions.from_vector(target_velocity), BsVector3Extensions.from_vector(projectile_acceleration), BsVector3Extensions.from_vector(target_acceleration))
		Variant.Type.TYPE_VECTOR4, Variant.Type.TYPE_VECTOR4I: return best_by_speed_vector4(projectile_speed, to_target, BsVector4Extensions.from_vector(target_velocity), BsVector4Extensions.from_vector(projectile_acceleration), BsVector4Extensions.from_vector(target_acceleration))
		_:
			_BsLogger.format_error(_SCRIPT, BsPosition.best_by_speed, "Unsupported type `%s`" % type_string(type), null)
			return null


## See [method BsPosition.best_by_speed].
static func best_by_speed_vector2(projectile_speed: float, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) -> Vector2:
	return BsVector4Extensions.to_vector2(best_by_speed_vector4(projectile_speed, BsVector2Extensions.to_vector4(to_target), BsVector2Extensions.to_vector4(target_velocity), BsVector2Extensions.to_vector4(projectile_acceleration), BsVector2Extensions.to_vector4(target_acceleration)))


## See [method BsPosition.best_by_speed].
static func best_by_speed_vector3(projectile_speed: float, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO, projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) -> Vector3:
	return BsVector4Extensions.to_vector3(best_by_speed_vector4(projectile_speed, BsVector3Extensions.to_vector4(to_target), BsVector3Extensions.to_vector4(target_velocity), BsVector3Extensions.to_vector4(projectile_acceleration), BsVector3Extensions.to_vector4(target_acceleration)))


## See [method BsPosition.best_by_speed].
static func best_by_speed_vector4(projectile_speed: float, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Vector4:
	return position_vector4(to_target, BsTime.best_by_speed_vector4(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration), target_velocity, target_acceleration)
#endregion


#region displacement
## Computes displacement under constant acceleration. [br]
## [b]Returns:[/b] The displacement vector after [param time] has elapsed.
static func displacement(time: float, velocity: Variant, acceleration: Variant = Vector4.ZERO) -> Variant:
	var type: Variant.Type = typeof(velocity)
	match type:
		Variant.Type.TYPE_VECTOR2, Variant.Type.TYPE_VECTOR2I: return displacement_vector2(time, velocity, BsVector2Extensions.from_vector(acceleration))
		Variant.Type.TYPE_VECTOR3, Variant.Type.TYPE_VECTOR3I: return displacement_vector3(time, velocity, BsVector3Extensions.from_vector(acceleration))
		Variant.Type.TYPE_VECTOR4, Variant.Type.TYPE_VECTOR4I: return displacement_vector4(time, velocity, BsVector4Extensions.from_vector(acceleration))
		_:
			_BsLogger.format_error(_SCRIPT, BsPosition.displacement, "Unsupported type `%s`" % type_string(type), null)
			return null


## See [method BsPosition.displacement].
static func displacement_vector2(time: float, velocity: Vector2, acceleration: Vector2 = Vector2.ZERO) -> Vector2:
	return BsVector4Extensions.to_vector2(displacement_vector4(time, BsVector2Extensions.to_vector4(velocity), BsVector2Extensions.to_vector4(acceleration)))


## See [method BsPosition.displacement].
static func displacement_vector3(time: float, velocity: Vector3, acceleration: Vector3 = Vector3.ZERO) -> Vector3:
	return BsVector4Extensions.to_vector3(displacement_vector4(time, BsVector3Extensions.to_vector4(velocity), BsVector3Extensions.to_vector4(acceleration)))


## See [method BsPosition.displacement].
static func displacement_vector4(time: float, velocity: Vector4, acceleration: Vector4 = Vector4.ZERO) -> Vector4:
	return BsEquations.displacement(time, velocity, acceleration)
#endregion


#region position
## Computes position after elapsed time under constant acceleration. [br]
## [b]Returns:[/b] The position vector after [param time] has elapsed.
static func position(position: Variant, time: float, velocity: Variant = Vector4.ZERO, acceleration: Variant = Vector4.ZERO) -> Variant:
	var type: Variant.Type = typeof(position)
	match type:
		Variant.Type.TYPE_VECTOR2, Variant.Type.TYPE_VECTOR2I: return position_vector2(position, time, BsVector2Extensions.from_vector(velocity), BsVector2Extensions.from_vector(acceleration))
		Variant.Type.TYPE_VECTOR3, Variant.Type.TYPE_VECTOR3I: return position_vector3(position, time, BsVector3Extensions.from_vector(velocity), BsVector3Extensions.from_vector(acceleration))
		Variant.Type.TYPE_VECTOR4, Variant.Type.TYPE_VECTOR4I: return position_vector4(position, time, BsVector4Extensions.from_vector(velocity), BsVector4Extensions.from_vector(acceleration))
		_:
			_BsLogger.format_error(_SCRIPT, BsPosition.position, "Unsupported type `%s`" % type_string(type), null)
			return null


## See [method BsPosition.position].
static func position_vector2(position: Vector2, time: float, velocity: Vector2 = Vector2.ZERO, acceleration: Vector2 = Vector2.ZERO) -> Vector2:
	return BsVector4Extensions.to_vector2(position_vector4(BsVector2Extensions.to_vector4(position), time, BsVector2Extensions.to_vector4(velocity), BsVector2Extensions.to_vector4(acceleration)))


## See [method BsPosition.position].
static func position_vector3(position: Vector3, time: float, velocity: Vector3 = Vector3.ZERO, acceleration: Vector3 = Vector3.ZERO) -> Vector3:
	return BsVector4Extensions.to_vector3(position_vector4(BsVector3Extensions.to_vector4(position), time, BsVector3Extensions.to_vector4(velocity), BsVector3Extensions.to_vector4(acceleration)))


## See [method BsPosition.position].
static func position_vector4(position: Vector4, time: float, velocity: Vector4 = Vector4.ZERO, acceleration: Vector4 = Vector4.ZERO) -> Vector4:
	return BsEquations.position(position, time, velocity, acceleration)
#endregion


#region deprecated
## @deprecated Use [method BsPosition.all_positions] instead.
static func all_impact_positions(projectile_speed_or_direction: Variant, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> Array[Variant]:
	return all_positions(projectile_speed_or_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsPosition.all_by_direction] instead.
static func all_impact_positions_by_direction(projectile_direction: Variant, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> Array[Variant]:
	return all_by_direction(projectile_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsPosition.all_by_direction_vector2] instead.
static func all_impact_positions_by_direction_vector2(projectile_direction: Vector2, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) -> Array[Vector2]:
	return all_by_direction_vector2(projectile_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsPosition.all_by_direction_vector3] instead.
static func all_impact_positions_by_direction_vector3(projectile_direction: Vector3, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO, projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) -> Array[Vector3]:
	return all_by_direction_vector3(projectile_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsPosition.all_by_direction_vector4] instead.
static func all_impact_positions_by_direction_vector4(projectile_direction: Vector4, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Array[Vector4]:
	return all_by_direction_vector4(projectile_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsPosition.all_by_speed] instead.
static func all_impact_positions_by_speed(projectile_speed: float, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> Array[Variant]:
	return all_by_speed(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsPosition.all_by_speed_vector2] instead.
static func all_impact_positions_by_speed_vector2(projectile_speed: float, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) -> Array[Vector2]:
	return all_by_speed_vector2(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsPosition.all_by_speed_vector3] instead.
static func all_impact_positions_by_speed_vector3(projectile_speed: float, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO, projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) -> Array[Vector3]:
	return all_by_speed_vector3(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsPosition.all_by_speed_vector4] instead.
static func all_impact_positions_by_speed_vector4(projectile_speed: float, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Array[Vector4]:
	return all_by_speed_vector4(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsPosition.best_position] instead.
static func best_impact_position(projectile_speed_or_direction: Variant, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> Variant:
	return best_position(projectile_speed_or_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsPosition.best_by_direction] instead.
static func best_impact_position_by_direction(projectile_direction: Variant, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> Variant:
	return best_by_direction(projectile_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsPosition.best_by_direction_vector2] instead.
static func best_impact_position_by_direction_vector2(projectile_direction: Vector2, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) -> Vector2:
	return best_by_direction_vector2(projectile_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsPosition.best_by_direction_vector3] instead.
static func best_impact_position_by_direction_vector3(projectile_direction: Vector3, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO, projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) -> Vector3:
	return best_by_direction_vector3(projectile_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsPosition.best_by_direction_vector4] instead.
static func best_impact_position_by_direction_vector4(projectile_direction: Vector4, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Vector4:
	return best_by_direction_vector4(projectile_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsPosition.best_by_speed] instead.
static func best_impact_position_by_speed(projectile_speed: float, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> Variant:
	return best_by_speed(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsPosition.best_by_speed_vector2] instead.
static func best_impact_position_by_speed_vector2(projectile_speed: float, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) -> Vector2:
	return best_by_speed_vector2(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsPosition.best_by_speed_vector3] instead.
static func best_impact_position_by_speed_vector3(projectile_speed: float, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO, projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) -> Vector3:
	return best_by_speed_vector3(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsPosition.best_by_speed_vector4] instead.
static func best_impact_position_by_speed_vector4(projectile_speed: float, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Vector4:
	return best_by_speed_vector4(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration)
#endregion
