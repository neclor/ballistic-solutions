@abstract class_name BsVelocity extends BallisticSolutions


## Provides methods for computing required firing velocities to hit a target under constant acceleration conditions.
##
## @tutorial(Ballistic Solutions): https://github.com/neclor/ballistic-solutions/blob/main/README.md


const _SCRIPT: GDScript = BsVelocity


#region all_velocities
## Computes firing velocities for all valid interception times. [br]
## [b]Returns:[/b] An array of firing velocity vectors, one for each valid interception time.
static func all_velocities(projectile_speed_or_direction: Variant, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> Array[Variant]:
	var type: Variant.Type = typeof(projectile_speed_or_direction)
	match type:
		Variant.Type.TYPE_INT, Variant.Type.TYPE_FLOAT:
			return all_by_speed(projectile_speed_or_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)
		Variant.Type.TYPE_VECTOR2, Variant.Type.TYPE_VECTOR2I, Variant.Type.TYPE_VECTOR3, Variant.Type.TYPE_VECTOR3I, Variant.Type.TYPE_VECTOR4, Variant.Type.TYPE_VECTOR4I:
			return all_by_direction(projectile_speed_or_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)
		_:
			_BsLogger.format_error(_SCRIPT, BsVelocity.all_velocities, "Unsupported type `%s`" % type_string(type), [])
			return []
#endregion


#region all_by_direction
## Computes firing velocities for all valid interception times using projectile direction. [br]
## [b]Returns:[/b] An array of firing velocity vectors, one for each valid interception time.
static func all_by_direction(projectile_direction: Variant, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> Array[Variant]:
	var type: Variant.Type = typeof(projectile_direction)
	match type:
		Variant.Type.TYPE_VECTOR2, Variant.Type.TYPE_VECTOR2I: return all_by_direction_vector2(projectile_direction, to_target, BsVector2Extensions.from_vector(target_velocity), BsVector2Extensions.from_vector(projectile_acceleration), BsVector2Extensions.from_vector(target_acceleration))
		Variant.Type.TYPE_VECTOR3, Variant.Type.TYPE_VECTOR3I: return all_by_direction_vector3(projectile_direction, to_target, BsVector3Extensions.from_vector(target_velocity), BsVector3Extensions.from_vector(projectile_acceleration), BsVector3Extensions.from_vector(target_acceleration))
		Variant.Type.TYPE_VECTOR4, Variant.Type.TYPE_VECTOR4I: return all_by_direction_vector4(projectile_direction, to_target, BsVector4Extensions.from_vector(target_velocity), BsVector4Extensions.from_vector(projectile_acceleration), BsVector4Extensions.from_vector(target_acceleration))
		_:
			_BsLogger.format_error(_SCRIPT, BsVelocity.all_by_direction, "Unsupported type `%s`" % type_string(type), [])
			return []


## See [method BsVelocity.all_by_direction].
static func all_by_direction_vector2(projectile_direction: Vector2, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) -> Array[Vector2]:
	return Array(
		all_by_direction_vector4(BsVector2Extensions.to_vector4(projectile_direction), BsVector2Extensions.to_vector4(to_target), BsVector2Extensions.to_vector4(target_velocity), BsVector2Extensions.to_vector4(projectile_acceleration), BsVector2Extensions.to_vector4(target_acceleration))
			.map(func(v: Vector4) -> Vector2: return BsVector4Extensions.to_vector2(v)),
		Variant.Type.TYPE_VECTOR2, "", null
	)


## See [method BsVelocity.all_by_direction].
static func all_by_direction_vector3(projectile_direction: Vector3, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO, projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) -> Array[Vector3]:
	return Array(
		all_by_direction_vector4(BsVector3Extensions.to_vector4(projectile_direction), BsVector3Extensions.to_vector4(to_target), BsVector3Extensions.to_vector4(target_velocity), BsVector3Extensions.to_vector4(projectile_acceleration), BsVector3Extensions.to_vector4(target_acceleration))
			.map(func(v: Vector4) -> Vector3: return BsVector4Extensions.to_vector3(v)),
		Variant.Type.TYPE_VECTOR3, "", null
	)


## See [method BsVelocity.all_by_direction].
static func all_by_direction_vector4(projectile_direction: Vector4, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Array[Vector4]:
	return Array(
		BsTime.all_by_direction_vector4(projectile_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)
			.map(func(t: float) -> Vector4: return velocity_vector4(t, to_target, target_velocity, projectile_acceleration, target_acceleration)),
		Variant.Type.TYPE_VECTOR4, "", null
	)
#endregion


#region all_by_speed
## Computes firing velocities for all valid interception times using projectile speed. [br]
## [b]Returns:[/b] An array of firing velocity vectors, one for each valid interception time.
static func all_by_speed(projectile_speed: float, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> Array[Variant]:
	if projectile_speed < 0: _BsLogger.format_warning(_SCRIPT, BsVelocity.all_by_speed, "Negative `projectile_speed`")
	var type: Variant.Type = typeof(to_target)
	match type:
		Variant.Type.TYPE_VECTOR2, Variant.Type.TYPE_VECTOR2I: return all_by_speed_vector2(projectile_speed, to_target, BsVector2Extensions.from_vector(target_velocity), BsVector2Extensions.from_vector(projectile_acceleration), BsVector2Extensions.from_vector(target_acceleration))
		Variant.Type.TYPE_VECTOR3, Variant.Type.TYPE_VECTOR3I: return all_by_speed_vector3(projectile_speed, to_target, BsVector3Extensions.from_vector(target_velocity), BsVector3Extensions.from_vector(projectile_acceleration), BsVector3Extensions.from_vector(target_acceleration))
		Variant.Type.TYPE_VECTOR4, Variant.Type.TYPE_VECTOR4I: return all_by_speed_vector4(projectile_speed, to_target, BsVector4Extensions.from_vector(target_velocity), BsVector4Extensions.from_vector(projectile_acceleration), BsVector4Extensions.from_vector(target_acceleration))
		_:
			_BsLogger.format_error(_SCRIPT, BsVelocity.all_by_speed, "Unsupported type `%s`" % type_string(type), [])
			return []


## See [method BsVelocity.all_by_speed].
static func all_by_speed_vector2(projectile_speed: float, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) -> Array[Vector2]:
	return Array(
		all_by_speed_vector4(projectile_speed, BsVector2Extensions.to_vector4(to_target), BsVector2Extensions.to_vector4(target_velocity), BsVector2Extensions.to_vector4(projectile_acceleration), BsVector2Extensions.to_vector4(target_acceleration))
			.map(func(v: Vector4) -> Vector2: return BsVector4Extensions.to_vector2(v)),
		Variant.Type.TYPE_VECTOR2, "", null
	)


## See [method BsVelocity.all_by_speed].
static func all_by_speed_vector3(projectile_speed: float, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO, projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) -> Array[Vector3]:
	return Array(
		all_by_speed_vector4(projectile_speed, BsVector3Extensions.to_vector4(to_target), BsVector3Extensions.to_vector4(target_velocity), BsVector3Extensions.to_vector4(projectile_acceleration), BsVector3Extensions.to_vector4(target_acceleration))
			.map(func(v: Vector4) -> Vector3: return BsVector4Extensions.to_vector3(v)),
		Variant.Type.TYPE_VECTOR3, "", null
	)


## See [method BsVelocity.all_by_speed].
static func all_by_speed_vector4(projectile_speed: float, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Array[Vector4]:
	return Array(
		BsTime.all_by_speed_vector4(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration)
			.map(func(t: float) -> Vector4: return velocity_vector4(t, to_target, target_velocity, projectile_acceleration, target_acceleration)),
		Variant.Type.TYPE_VECTOR4, "", null
	)
#endregion


#region best_velocity
## Computes the firing velocity required for the earliest valid interception. [br]
## [b]Returns:[/b] The required firing velocity vector. Returns a NaN vector if interception is impossible.
static func best_velocity(projectile_speed_or_direction: Variant, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> Variant:
	var type: Variant.Type = typeof(projectile_speed_or_direction)
	match type:
		Variant.Type.TYPE_INT, Variant.Type.TYPE_FLOAT:
			return best_by_speed(projectile_speed_or_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)
		Variant.Type.TYPE_VECTOR2, Variant.Type.TYPE_VECTOR2I, Variant.Type.TYPE_VECTOR3, Variant.Type.TYPE_VECTOR3I, Variant.Type.TYPE_VECTOR4, Variant.Type.TYPE_VECTOR4I:
			return best_by_direction(projectile_speed_or_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)
		_:
			_BsLogger.format_error(_SCRIPT, BsVelocity.best_velocity, "Unsupported type `%s`" % type_string(type), null)
			return null
#endregion


#region best_by_direction
## Computes the firing velocity required for the earliest valid interception using projectile direction. [br]
## [b]Returns:[/b] The required firing velocity vector. Returns a NaN vector if interception is impossible.
static func best_by_direction(projectile_direction: Variant, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> Variant:
	var type: Variant.Type = typeof(projectile_direction)
	match type:
		Variant.Type.TYPE_VECTOR2, Variant.Type.TYPE_VECTOR2I: return best_by_direction_vector2(projectile_direction, to_target, BsVector2Extensions.from_vector(target_velocity), BsVector2Extensions.from_vector(projectile_acceleration), BsVector2Extensions.from_vector(target_acceleration))
		Variant.Type.TYPE_VECTOR3, Variant.Type.TYPE_VECTOR3I: return best_by_direction_vector3(projectile_direction, to_target, BsVector3Extensions.from_vector(target_velocity), BsVector3Extensions.from_vector(projectile_acceleration), BsVector3Extensions.from_vector(target_acceleration))
		Variant.Type.TYPE_VECTOR4, Variant.Type.TYPE_VECTOR4I: return best_by_direction_vector4(projectile_direction, to_target, BsVector4Extensions.from_vector(target_velocity), BsVector4Extensions.from_vector(projectile_acceleration), BsVector4Extensions.from_vector(target_acceleration))
		_:
			_BsLogger.format_error(_SCRIPT, BsVelocity.best_by_direction, "Unsupported type `%s`" % type_string(type), null)
			return null


## See [method BsVelocity.best_by_direction].
static func best_by_direction_vector2(projectile_direction: Vector2, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) -> Vector2:
	return BsVector4Extensions.to_vector2(best_by_direction_vector4(BsVector2Extensions.to_vector4(projectile_direction), BsVector2Extensions.to_vector4(to_target), BsVector2Extensions.to_vector4(target_velocity), BsVector2Extensions.to_vector4(projectile_acceleration), BsVector2Extensions.to_vector4(target_acceleration)))


## See [method BsVelocity.best_by_direction].
static func best_by_direction_vector3(projectile_direction: Vector3, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO, projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) -> Vector3:
	return BsVector4Extensions.to_vector3(best_by_direction_vector4(BsVector3Extensions.to_vector4(projectile_direction), BsVector3Extensions.to_vector4(to_target), BsVector3Extensions.to_vector4(target_velocity), BsVector3Extensions.to_vector4(projectile_acceleration), BsVector3Extensions.to_vector4(target_acceleration)))


## See [method BsVelocity.best_by_direction].
static func best_by_direction_vector4(projectile_direction: Vector4, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Vector4:
	return velocity_vector4(BsTime.best_by_direction_vector4(projectile_direction, to_target, target_velocity, projectile_acceleration, target_acceleration), to_target, target_velocity, projectile_acceleration, target_acceleration)
#endregion


#region best_by_speed
## Computes the firing velocity required for the earliest valid interception using projectile speed. [br]
## [b]Returns:[/b] The required firing velocity vector. Returns a NaN vector if interception is impossible.
static func best_by_speed(projectile_speed: float, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> Variant:
	if projectile_speed < 0: _BsLogger.format_warning(_SCRIPT, BsVelocity.best_by_speed, "Negative `projectile_speed`")
	var type: Variant.Type = typeof(to_target)
	match type:
		Variant.Type.TYPE_VECTOR2, Variant.Type.TYPE_VECTOR2I: return best_by_speed_vector2(projectile_speed, to_target, BsVector2Extensions.from_vector(target_velocity), BsVector2Extensions.from_vector(projectile_acceleration), BsVector2Extensions.from_vector(target_acceleration))
		Variant.Type.TYPE_VECTOR3, Variant.Type.TYPE_VECTOR3I: return best_by_speed_vector3(projectile_speed, to_target, BsVector3Extensions.from_vector(target_velocity), BsVector3Extensions.from_vector(projectile_acceleration), BsVector3Extensions.from_vector(target_acceleration))
		Variant.Type.TYPE_VECTOR4, Variant.Type.TYPE_VECTOR4I: return best_by_speed_vector4(projectile_speed, to_target, BsVector4Extensions.from_vector(target_velocity), BsVector4Extensions.from_vector(projectile_acceleration), BsVector4Extensions.from_vector(target_acceleration))
		_:
			_BsLogger.format_error(_SCRIPT, BsVelocity.best_by_speed, "Unsupported type `%s`" % type_string(type), null)
			return null


## See [method BsVelocity.best_by_speed].
static func best_by_speed_vector2(projectile_speed: float, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) -> Vector2:
	return BsVector4Extensions.to_vector2(best_by_speed_vector4(projectile_speed, BsVector2Extensions.to_vector4(to_target), BsVector2Extensions.to_vector4(target_velocity), BsVector2Extensions.to_vector4(projectile_acceleration), BsVector2Extensions.to_vector4(target_acceleration)))


## See [method BsVelocity.best_by_speed].
static func best_by_speed_vector3(projectile_speed: float, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO, projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) -> Vector3:
	return BsVector4Extensions.to_vector3(best_by_speed_vector4(projectile_speed, BsVector3Extensions.to_vector4(to_target), BsVector3Extensions.to_vector4(target_velocity), BsVector3Extensions.to_vector4(projectile_acceleration), BsVector3Extensions.to_vector4(target_acceleration)))


## See [method BsVelocity.best_by_speed].
static func best_by_speed_vector4(projectile_speed: float, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Vector4:
	return velocity_vector4(BsTime.best_by_speed_vector4(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration), to_target, target_velocity, projectile_acceleration, target_acceleration)
#endregion


#region velocity
## Computes the firing velocity required to hit the target at a given interception time. [br]
## [b]Returns:[/b] The required firing velocity vector. Returns a NaN vector if [param time] ≤ 0.
static func velocity(time: float, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> Variant:
	var type: Variant.Type = typeof(to_target)
	match type:
		Variant.Type.TYPE_VECTOR2, Variant.Type.TYPE_VECTOR2I: return velocity_vector2(time, to_target, BsVector2Extensions.from_vector(target_velocity), BsVector2Extensions.from_vector(projectile_acceleration), BsVector2Extensions.from_vector(target_acceleration))
		Variant.Type.TYPE_VECTOR3, Variant.Type.TYPE_VECTOR3I: return velocity_vector3(time, to_target, BsVector3Extensions.from_vector(target_velocity), BsVector3Extensions.from_vector(projectile_acceleration), BsVector3Extensions.from_vector(target_acceleration))
		Variant.Type.TYPE_VECTOR4, Variant.Type.TYPE_VECTOR4I: return velocity_vector4(time, to_target, BsVector4Extensions.from_vector(target_velocity), BsVector4Extensions.from_vector(projectile_acceleration), BsVector4Extensions.from_vector(target_acceleration))
		_:
			_BsLogger.format_error(_SCRIPT, BsVelocity.velocity, "Unsupported type `%s`" % type_string(type), null)
			return null


## See [method BsVelocity.velocity].
static func velocity_vector2(time: float, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) -> Vector2:
	return BsVector4Extensions.to_vector2(velocity_vector4(time, BsVector2Extensions.to_vector4(to_target), BsVector2Extensions.to_vector4(target_velocity), BsVector2Extensions.to_vector4(projectile_acceleration), BsVector2Extensions.to_vector4(target_acceleration)))


## See [method BsVelocity.velocity].
static func velocity_vector3(time: float, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO, projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) -> Vector3:
	return BsVector4Extensions.to_vector3(velocity_vector4(time, BsVector3Extensions.to_vector4(to_target), BsVector3Extensions.to_vector4(target_velocity), BsVector3Extensions.to_vector4(projectile_acceleration), BsVector3Extensions.to_vector4(target_acceleration)))


## See [method BsVelocity.velocity].
static func velocity_vector4(time: float, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Vector4:
	return BsEquations.velocity(time, to_target, target_velocity, projectile_acceleration, target_acceleration)
#endregion


#region deprecated
## @deprecated Use [method BsVelocity.all_velocities] instead.
static func all_firing_velocities(projectile_speed_or_direction: Variant, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> Array[Variant]:
	return all_velocities(projectile_speed_or_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsVelocity.all_by_direction] instead.
static func all_firing_velocities_by_direction(projectile_direction: Variant, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> Array[Variant]:
	return all_by_direction(projectile_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsVelocity.all_by_direction_vector2] instead.
static func all_firing_velocities_by_direction_vector2(projectile_direction: Vector2, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) -> Array[Vector2]:
	return all_by_direction_vector2(projectile_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsVelocity.all_by_direction_vector3] instead.
static func all_firing_velocities_by_direction_vector3(projectile_direction: Vector3, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO, projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) -> Array[Vector3]:
	return all_by_direction_vector3(projectile_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsVelocity.all_by_direction_vector4] instead.
static func all_firing_velocities_by_direction_vector4(projectile_direction: Vector4, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Array[Vector4]:
	return all_by_direction_vector4(projectile_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsVelocity.all_by_speed] instead.
static func all_firing_velocities_by_speed(projectile_speed: float, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> Array[Variant]:
	return all_by_speed(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsVelocity.all_by_speed_vector2] instead.
static func all_firing_velocities_by_speed_vector2(projectile_speed: float, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) -> Array[Vector2]:
	return all_by_speed_vector2(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsVelocity.all_by_speed_vector3] instead.
static func all_firing_velocities_by_speed_vector3(projectile_speed: float, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO, projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) -> Array[Vector3]:
	return all_by_speed_vector3(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsVelocity.all_by_speed_vector4] instead.
static func all_firing_velocities_by_speed_vector4(projectile_speed: float, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Array[Vector4]:
	return all_by_speed_vector4(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsVelocity.best_velocity] instead.
static func best_firing_velocity(projectile_speed_or_direction: Variant, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> Variant:
	return best_velocity(projectile_speed_or_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsVelocity.best_by_direction] instead.
static func best_firing_velocity_by_direction(projectile_direction: Variant, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> Variant:
	return best_by_direction(projectile_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsVelocity.best_by_direction_vector2] instead.
static func best_firing_velocity_by_direction_vector2(projectile_direction: Vector2, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) -> Vector2:
	return best_by_direction_vector2(projectile_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsVelocity.best_by_direction_vector3] instead.
static func best_firing_velocity_by_direction_vector3(projectile_direction: Vector3, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO, projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) -> Vector3:
	return best_by_direction_vector3(projectile_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsVelocity.best_by_direction_vector4] instead.
static func best_firing_velocity_by_direction_vector4(projectile_direction: Vector4, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Vector4:
	return best_by_direction_vector4(projectile_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsVelocity.best_by_speed] instead.
static func best_firing_velocity_by_speed(projectile_speed: float, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> Variant:
	return best_by_speed(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsVelocity.best_by_speed_vector2] instead.
static func best_firing_velocity_by_speed_vector2(projectile_speed: float, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) -> Vector2:
	return best_by_speed_vector2(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsVelocity.best_by_speed_vector3] instead.
static func best_firing_velocity_by_speed_vector3(projectile_speed: float, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO, projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) -> Vector3:
	return best_by_speed_vector3(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsVelocity.best_by_speed_vector4] instead.
static func best_firing_velocity_by_speed_vector4(projectile_speed: float, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Vector4:
	return best_by_speed_vector4(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsVelocity.velocity] instead.
static func firing_velocity(time: float, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> Variant:
	return velocity(time, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsVelocity.velocity_vector2] instead.
static func firing_velocity_vector2(time: float, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) -> Vector2:
	return velocity_vector2(time, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsVelocity.velocity_vector3] instead.
static func firing_velocity_vector3(time: float, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO, projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) -> Vector3:
	return velocity_vector3(time, to_target, target_velocity, projectile_acceleration, target_acceleration)

## @deprecated Use [method BsVelocity.velocity_vector4] instead.
static func firing_velocity_vector4(time: float, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Vector4:
	return velocity_vector4(time, to_target, target_velocity, projectile_acceleration, target_acceleration)
#endregion
