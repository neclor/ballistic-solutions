class_name Bsc extends BallisticSolutions


## Bsc - Ballistic Solutions Calculator [br]
## Provides methods for calculating projectile interception with moving targets.
## It computes interception times, impact positions, and required firing velocities while accounting for both projectile and target velocities and accelerations.
##
## @tutorial(Ballistic Solutions): https://github.com/neclor/ballistic-solutions/blob/main/README.md


#region Time
## Computes the earliest positive interception time between a projectile and a moving target. [br]
## Returns: The earliest interception time (t > 0). Returns [constant @GDScript.NAN] if no interception is possible.
static func best_impact_time(projectile_speed: float, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> float:
	var type: Variant.Type = typeof(to_target)
	match type:
		Variant.Type.TYPE_VECTOR2, Variant.Type.TYPE_VECTOR2I:
			return best_impact_time_vector2(projectile_speed, to_target, BallisticSolutionsVector2Extensions.from_vector(target_velocity), BallisticSolutionsVector2Extensions.from_vector(projectile_acceleration), BallisticSolutionsVector2Extensions.from_vector(target_acceleration))

		Variant.Type.TYPE_VECTOR3, Variant.Type.TYPE_VECTOR3I:
			return best_impact_time_vector3(projectile_speed, to_target, BallisticSolutionsVector3Extensions.from_vector(target_velocity), BallisticSolutionsVector3Extensions.from_vector(projectile_acceleration), BallisticSolutionsVector3Extensions.from_vector(target_acceleration))

		Variant.Type.TYPE_VECTOR4, Variant.Type.TYPE_VECTOR4I:
			return best_impact_time_vector4(projectile_speed, to_target, BallisticSolutionsVector4Extensions.from_vector(target_velocity),  BallisticSolutionsVector4Extensions.from_vector(projectile_acceleration), BallisticSolutionsVector4Extensions.from_vector(target_acceleration))

		_:
			_error("`Bsc.best_impact_time`: Unsupported type `" + type_string(type) + "`. Returning NAN.")
			return NAN


## See [method best_impact_time].
static func best_impact_time_vector4(projectile_speed: float, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> float:
	if projectile_speed < 0: _warning("`Bsc.best_impact_time`: Negative `projectile_speed`.")

	var impact_times: Array[float] = impact_times_vector4(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration);
	if impact_times.size() == 0: return NAN;

	return impact_times[0];


## See [method best_impact_time].
static func best_impact_time_vector3(projectile_speed: float, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO, projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) -> float:
	return best_impact_time_vector4(projectile_speed, BallisticSolutionsVector4Extensions.from_vector3(to_target), BallisticSolutionsVector4Extensions.from_vector3(target_velocity), BallisticSolutionsVector4Extensions.from_vector3(projectile_acceleration), BallisticSolutionsVector4Extensions.from_vector3(target_acceleration))


## See [method best_impact_time].
static func best_impact_time_vector2(projectile_speed: float, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) -> float:
	return best_impact_time_vector4(projectile_speed, BallisticSolutionsVector4Extensions.from_vector2(to_target), BallisticSolutionsVector4Extensions.from_vector2(target_velocity), BallisticSolutionsVector4Extensions.from_vector2(projectile_acceleration), BallisticSolutionsVector4Extensions.from_vector2(target_acceleration))


## Computes all possible interception times between a projectile and a moving target. [br]
## Returns: A sorted array of all valid interception times (t > 0). Empty if interception is impossible.
static func impact_times(projectile_speed: float, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> Array[float]:
	var type: Variant.Type = typeof(to_target)
	match type:
		Variant.Type.TYPE_VECTOR2, Variant.Type.TYPE_VECTOR2I:
			return impact_times_vector2(projectile_speed, to_target, BallisticSolutionsVector2Extensions.from_vector(target_velocity), BallisticSolutionsVector2Extensions.from_vector(projectile_acceleration), BallisticSolutionsVector2Extensions.from_vector(target_acceleration))

		Variant.Type.TYPE_VECTOR3, Variant.Type.TYPE_VECTOR3I:
			return impact_times_vector3(projectile_speed, to_target, BallisticSolutionsVector3Extensions.from_vector(target_velocity), BallisticSolutionsVector3Extensions.from_vector(projectile_acceleration), BallisticSolutionsVector3Extensions.from_vector(target_acceleration))

		Variant.Type.TYPE_VECTOR4, Variant.Type.TYPE_VECTOR4I:
			return impact_times_vector4(projectile_speed, to_target, BallisticSolutionsVector4Extensions.from_vector(target_velocity), BallisticSolutionsVector4Extensions.from_vector(projectile_acceleration), BallisticSolutionsVector4Extensions.from_vector(target_acceleration))

		_:
			_error("`Bsc.impact_times`: Unsupported type `" + type_string(type) + "`. Returning [].")
			return []


## See [method impact_times].
static func impact_times_vector4(projectile_speed: float, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Array[float]:	
	var relative_acceleration: Vector4 = projectile_acceleration - target_acceleration

	var a: float = relative_acceleration.length_squared() / 4
	var b: float = -relative_acceleration.dot(target_velocity)
	var c: float = target_velocity.length_squared() - relative_acceleration.dot(to_target) - projectile_speed * projectile_speed
	var d: float = 2 * target_velocity.dot(to_target)
	var e: float = to_target.length_squared()

	var impact_times: Array[float] = Array(
		Res.quartic(a, b, c, d, e).filter(func(impact_time: float) -> bool: return impact_time > 0),
		TYPE_FLOAT,
		"",
		null
	)
	impact_times.sort()
	return impact_times


## See [method impact_times].
static func impact_times_vector3(projectile_speed: float, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO,projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) -> Array[float]:
	return impact_times_vector4(projectile_speed, BallisticSolutionsVector4Extensions.from_vector3(to_target), BallisticSolutionsVector4Extensions.from_vector3(target_velocity), BallisticSolutionsVector4Extensions.from_vector3(projectile_acceleration), BallisticSolutionsVector4Extensions.from_vector3(target_acceleration))


## See [method impact_times].
static func impact_times_vector2(projectile_speed: float, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) -> Array[float]:
	return impact_times_vector4(projectile_speed, BallisticSolutionsVector4Extensions.from_vector2(to_target), BallisticSolutionsVector4Extensions.from_vector2(target_velocity), BallisticSolutionsVector4Extensions.from_vector2(projectile_acceleration), BallisticSolutionsVector4Extensions.from_vector2(target_acceleration))
#endregion


#region Position
## Computes displacement under constant acceleration. [br]
## Returns: The displacement vector after [param time] has elapsed.
static func displacement(time: float, velocity: Variant, acceleration: Variant = Vector4.ZERO) -> Variant:
	var type: Variant.Type = typeof(velocity)
	match type:
		Variant.Type.TYPE_VECTOR2, Variant.Type.TYPE_VECTOR2I:
			return displacement_vector2(time, velocity, BallisticSolutionsVector2Extensions.from_vector(acceleration))

		Variant.Type.TYPE_VECTOR3, Variant.Type.TYPE_VECTOR3I:
			return displacement_vector3(time, velocity, BallisticSolutionsVector3Extensions.from_vector(acceleration))

		Variant.Type.TYPE_VECTOR4, Variant.Type.TYPE_VECTOR4I:
			return displacement_vector4(time, velocity, BallisticSolutionsVector4Extensions.from_vector(acceleration))

		_:
			_error("`Bsc.displacement`: Unsupported type `" + type_string(type) + "`. Returning null.")
			return null


## See [method displacement].
static func displacement_vector4(time: float, velocity: Vector4, acceleration: Vector4 = Vector4.ZERO) -> Vector4:
	return time * (velocity + acceleration * time / 2)


## See [method displacement].
static func displacement_vector3(time: float, velocity: Vector3, acceleration: Vector3 = Vector3.ZERO) -> Vector3:
	return BallisticSolutionsVector3Extensions.from_vector4(displacement_vector4(time, BallisticSolutionsVector4Extensions.from_vector3(velocity), BallisticSolutionsVector4Extensions.from_vector3(acceleration)))


## See [method displacement].
static func displacement_vector2(time: float, velocity: Vector2, acceleration: Vector2 = Vector2.ZERO) -> Vector2:
	return BallisticSolutionsVector2Extensions.from_vector4(displacement_vector4(time, BallisticSolutionsVector4Extensions.from_vector2(velocity), BallisticSolutionsVector4Extensions.from_vector2(acceleration)))


## Computes the impact position of the earliest valid interception. [br]
## Returns: The impact position vector. Returns NAN_VECTOR if interception is impossible.
static func best_impact_position(projectile_speed: float, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> Variant:
	var type: Variant.Type = typeof(to_target)
	match type:
		Variant.Type.TYPE_VECTOR2, Variant.Type.TYPE_VECTOR2I:
			return best_impact_position_vector2(projectile_speed, to_target, BallisticSolutionsVector2Extensions.from_vector(target_velocity), BallisticSolutionsVector2Extensions.from_vector(projectile_acceleration), BallisticSolutionsVector2Extensions.from_vector(target_acceleration))

		Variant.Type.TYPE_VECTOR3, Variant.Type.TYPE_VECTOR3I:
			return best_impact_position_vector3(projectile_speed, to_target, BallisticSolutionsVector3Extensions.from_vector(target_velocity), BallisticSolutionsVector3Extensions.from_vector(projectile_acceleration), BallisticSolutionsVector3Extensions.from_vector(target_acceleration))

		Variant.Type.TYPE_VECTOR4, Variant.Type.TYPE_VECTOR4I:
			return best_impact_position_vector4(projectile_speed, to_target, BallisticSolutionsVector4Extensions.from_vector(target_velocity), BallisticSolutionsVector4Extensions.from_vector(projectile_acceleration), BallisticSolutionsVector4Extensions.from_vector(target_acceleration))

		_:
			_error("`Bsc.best_impact_position`: Unsupported type `" + type_string(type) + "`. Returning null.")
			return null


## See [method best_impact_position].
static func best_impact_position_vector4(projectile_speed: float, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Vector4:
	if projectile_speed < 0: _warning("`Bsc.best_impact_position`: Negative `projectile_speed`.");

	return to_target + displacement_vector4(best_impact_time_vector4(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration), target_velocity, target_acceleration)


## See [method best_impact_position].
static func best_impact_position_vector3(projectile_speed: float, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO, projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) -> Vector3:
	return BallisticSolutionsVector3Extensions.from_vector4(best_impact_position_vector4(projectile_speed, BallisticSolutionsVector4Extensions.from_vector3(to_target), BallisticSolutionsVector4Extensions.from_vector3(target_velocity), BallisticSolutionsVector4Extensions.from_vector3(projectile_acceleration), BallisticSolutionsVector4Extensions.from_vector3(target_acceleration)))


## See [method best_impact_position].
static func best_impact_position_vector2(projectile_speed: float, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) -> Vector2:
	return BallisticSolutionsVector2Extensions.from_vector4(best_impact_position_vector4(projectile_speed, BallisticSolutionsVector4Extensions.from_vector2(to_target), BallisticSolutionsVector4Extensions.from_vector2(target_velocity), BallisticSolutionsVector4Extensions.from_vector2(projectile_acceleration), BallisticSolutionsVector4Extensions.from_vector2(target_acceleration)))


## Computes all possible impact positions corresponding to valid interception times. [br]
## Returns: An array of vectors representing all valid impact positions.
static func impact_positions(projectile_speed: float, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> Array:
	var type: Variant.Type = typeof(to_target)
	match type:
		Variant.Type.TYPE_VECTOR2, Variant.Type.TYPE_VECTOR2I:
			return impact_positions_vector2(projectile_speed, to_target, BallisticSolutionsVector2Extensions.from_vector(target_velocity), BallisticSolutionsVector2Extensions.from_vector(projectile_acceleration), BallisticSolutionsVector2Extensions.from_vector(target_acceleration))

		Variant.Type.TYPE_VECTOR3, Variant.Type.TYPE_VECTOR3I:
			return impact_positions_vector3(projectile_speed, to_target, BallisticSolutionsVector3Extensions.from_vector(target_velocity), BallisticSolutionsVector3Extensions.from_vector(projectile_acceleration), BallisticSolutionsVector3Extensions.from_vector(target_acceleration))

		Variant.Type.TYPE_VECTOR4, Variant.Type.TYPE_VECTOR4I:
			return impact_positions_vector4(projectile_speed, to_target, BallisticSolutionsVector4Extensions.from_vector(target_velocity), BallisticSolutionsVector4Extensions.from_vector(projectile_acceleration), BallisticSolutionsVector4Extensions.from_vector(target_acceleration))

		_:
			_error("`Bsc.impact_positions`: Unsupported type `" + type_string(type) + "`. Returning [].")
			return []


## See [method impact_positions].
static func impact_positions_vector4(projectile_speed: float, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Array[Vector4]:
	if projectile_speed < 0: _warning("`Bsc.impact_positions`: Negative `projectile_speed`.");

	return Array(
		impact_times_vector4(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration)
			.map(func(impact_time: float) -> Vector4: return to_target + displacement_vector4(impact_time, target_velocity, target_acceleration)),
		TYPE_VECTOR4,
		"",
		null
	)


## See [method impact_positions].
static func impact_positions_vector3(projectile_speed: float, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO, projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) -> Array[Vector3]:
	return Array(
		impact_positions_vector4(projectile_speed, BallisticSolutionsVector4Extensions.from_vector3(to_target), BallisticSolutionsVector4Extensions.from_vector3(target_velocity), BallisticSolutionsVector4Extensions.from_vector3(projectile_acceleration), BallisticSolutionsVector4Extensions.from_vector3(target_acceleration))
			.map(func(impact_position: Vector4) -> Vector3: return BallisticSolutionsVector3Extensions.from_vector4(impact_position)),
		TYPE_VECTOR3,
		"",
		null
	)


## See [method impact_positions].
static func impact_positions_vector2(projectile_speed: float, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) -> Array[Vector2]:
	return Array(
		impact_positions_vector4(projectile_speed, BallisticSolutionsVector4Extensions.from_vector2(to_target), BallisticSolutionsVector4Extensions.from_vector2(target_velocity), BallisticSolutionsVector4Extensions.from_vector2(projectile_acceleration), BallisticSolutionsVector4Extensions.from_vector2(target_acceleration))
			.map(func(impact_position: Vector4) -> Vector2: return BallisticSolutionsVector2Extensions.from_vector4(impact_position)),
		TYPE_VECTOR2,
		"",
		null
	)
#endregion


#region Velocity
## Computes the firing velocity required to hit the target at a given interception time. [br]
## Returns: The required firing velocity vector. Returns NAN_VECTOR if [param impact_time] <= 0.
static func firing_velocity(impact_time: float, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> Variant:
	var type: Variant.Type = typeof(to_target)
	match type:
		Variant.Type.TYPE_VECTOR2, Variant.Type.TYPE_VECTOR2I:
			return firing_velocity_vector2(impact_time, to_target, BallisticSolutionsVector2Extensions.from_vector(target_velocity), BallisticSolutionsVector2Extensions.from_vector(projectile_acceleration), BallisticSolutionsVector2Extensions.from_vector(target_acceleration))

		Variant.Type.TYPE_VECTOR3, Variant.Type.TYPE_VECTOR3I:
			return firing_velocity_vector3(impact_time, to_target, BallisticSolutionsVector3Extensions.from_vector(target_velocity), BallisticSolutionsVector3Extensions.from_vector(projectile_acceleration), BallisticSolutionsVector3Extensions.from_vector(target_acceleration))

		Variant.Type.TYPE_VECTOR4, Variant.Type.TYPE_VECTOR4I:
			return firing_velocity_vector4(impact_time, to_target, BallisticSolutionsVector4Extensions.from_vector(target_velocity), BallisticSolutionsVector4Extensions.from_vector(projectile_acceleration), BallisticSolutionsVector4Extensions.from_vector(target_acceleration))

		_:
			_error("`Bsc.firing_velocity`: Unsupported type `" + type_string(type) + "`. Returning null.")
			return null


## See [method firing_velocity].
static func firing_velocity_vector4(impact_time: float, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Vector4:
	if impact_time < 0 or is_zero_approx(impact_time):
		_error("`Bsc.firing_velocity`: Zero or negative `impact_time`. Returning NAN_VECTOR.");
		return BallisticSolutionsVector4Extensions.NAN_VECTOR

	return to_target / impact_time + target_velocity - (projectile_acceleration - target_acceleration) * impact_time / 2


## See [method firing_velocity].
static func firing_velocity_vector3(impact_time: float, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO, projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) -> Vector3:
	return BallisticSolutionsVector3Extensions.from_vector4(firing_velocity_vector4(impact_time, BallisticSolutionsVector4Extensions.from_vector3(to_target), BallisticSolutionsVector4Extensions.from_vector3(target_velocity), BallisticSolutionsVector4Extensions.from_vector3(projectile_acceleration), BallisticSolutionsVector4Extensions.from_vector3(target_acceleration)))


## See [method firing_velocity].
static func firing_velocity_vector2(impact_time: float, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) -> Vector2:
	return BallisticSolutionsVector2Extensions.from_vector4(firing_velocity_vector4(impact_time, BallisticSolutionsVector4Extensions.from_vector2(to_target), BallisticSolutionsVector4Extensions.from_vector2(target_velocity), BallisticSolutionsVector4Extensions.from_vector2(projectile_acceleration), BallisticSolutionsVector4Extensions.from_vector2(target_acceleration)))


## Computes the firing velocity required for the earliest valid interception. [br]
## Returns: The required firing velocity vector. Returns Vector4.Zero if interception is impossible.
static func best_firing_velocity(projectile_speed: float, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> Variant:
	var type: Variant.Type = typeof(to_target)
	match type:
		Variant.Type.TYPE_VECTOR2, Variant.Type.TYPE_VECTOR2I:
			return best_firing_velocity_vector2(projectile_speed, to_target, BallisticSolutionsVector2Extensions.from_vector(target_velocity), BallisticSolutionsVector2Extensions.from_vector(projectile_acceleration), BallisticSolutionsVector2Extensions.from_vector(target_acceleration))

		Variant.Type.TYPE_VECTOR3, Variant.Type.TYPE_VECTOR3I:
			return best_firing_velocity_vector3(projectile_speed, to_target, BallisticSolutionsVector3Extensions.from_vector(target_velocity), BallisticSolutionsVector3Extensions.from_vector(projectile_acceleration), BallisticSolutionsVector3Extensions.from_vector(target_acceleration))

		Variant.Type.TYPE_VECTOR4, Variant.Type.TYPE_VECTOR4I:
			return best_firing_velocity_vector4(projectile_speed, to_target, BallisticSolutionsVector4Extensions.from_vector(target_velocity), BallisticSolutionsVector4Extensions.from_vector(projectile_acceleration), BallisticSolutionsVector4Extensions.from_vector(target_acceleration))

		_:
			_error("`Bsc.best_firing_velocity`: Unsupported type `" + type_string(type) + "`. Returning null.")
			return null


## See [method best_firing_velocity].
static func best_firing_velocity_vector4(projectile_speed: float, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Vector4:
	if projectile_speed < 0: _warning("`Bsc.best_firing_velocity`: Negative `projectile_speed`.")

	return firing_velocity_vector4(best_impact_time_vector4(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration), to_target, target_velocity, projectile_acceleration, target_acceleration)


## See [method best_firing_velocity].
static func best_firing_velocity_vector3(projectile_speed: float, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO, projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) -> Vector3:
	return BallisticSolutionsVector3Extensions.from_vector4(best_firing_velocity_vector4(projectile_speed, BallisticSolutionsVector4Extensions.from_vector3(to_target), BallisticSolutionsVector4Extensions.from_vector3(target_velocity), BallisticSolutionsVector4Extensions.from_vector3(projectile_acceleration), BallisticSolutionsVector4Extensions.from_vector3(target_acceleration)))


## See [method best_firing_velocity].
static func best_firing_velocity_vector2(projectile_speed: float, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) -> Vector2:
	return BallisticSolutionsVector2Extensions.from_vector4(best_firing_velocity_vector4(projectile_speed, BallisticSolutionsVector4Extensions.from_vector2(to_target), BallisticSolutionsVector4Extensions.from_vector2(target_velocity), BallisticSolutionsVector4Extensions.from_vector2(projectile_acceleration), BallisticSolutionsVector4Extensions.from_vector2(target_acceleration)))


## Computes firing velocities for all valid interception times. [br]
## Returns: An array of firing velocity vectors, one for each valid interception time.
static func firing_velocities(projectile_speed: float, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) -> Array[Variant]:
	var type: Variant.Type = typeof(to_target)
	match type:
		Variant.Type.TYPE_VECTOR2, Variant.Type.TYPE_VECTOR2I:
			return firing_velocities_vector2(projectile_speed, to_target, BallisticSolutionsVector2Extensions.from_vector(target_velocity), BallisticSolutionsVector2Extensions.from_vector(projectile_acceleration), BallisticSolutionsVector2Extensions.from_vector(target_acceleration))

		Variant.Type.TYPE_VECTOR3, Variant.Type.TYPE_VECTOR3I:
			return firing_velocities_vector3(projectile_speed, to_target, BallisticSolutionsVector3Extensions.from_vector(target_velocity), BallisticSolutionsVector3Extensions.from_vector(projectile_acceleration), BallisticSolutionsVector3Extensions.from_vector(target_acceleration))

		Variant.Type.TYPE_VECTOR4, Variant.Type.TYPE_VECTOR4I:
			return firing_velocities_vector4(projectile_speed, to_target, BallisticSolutionsVector4Extensions.from_vector(target_velocity), BallisticSolutionsVector4Extensions.from_vector(projectile_acceleration), BallisticSolutionsVector4Extensions.from_vector(target_acceleration))

		_:
			_error("`Bsc.firing_velocities`: Unsupported type `" + type_string(type) + "`. Returning [].")
			return []


## See [method firing_velocities].
static func firing_velocities_vector4(projectile_speed: float, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Array[Vector4]:
	return Array(
		impact_times_vector4(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration)
			.map(func(impact_time: float) -> Vector4: return firing_velocity_vector4(impact_time, to_target, target_velocity, projectile_acceleration, target_acceleration)),
		TYPE_VECTOR4,
		"",
		null
	)


## See [method firing_velocities].
static func firing_velocities_vector3(projectile_speed: float, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO, projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) -> Array[Vector3]:
	return Array(
		firing_velocities_vector4(projectile_speed, BallisticSolutionsVector4Extensions.from_vector3(to_target), BallisticSolutionsVector4Extensions.from_vector3(target_velocity), BallisticSolutionsVector4Extensions.from_vector3(projectile_acceleration), BallisticSolutionsVector4Extensions.from_vector3(target_acceleration))
			.map(func(firing_velocity: Vector4) -> Vector3: return BallisticSolutionsVector3Extensions.from_vector4(firing_velocity)),
		TYPE_VECTOR3,
		"",
		null
	)


## See [method firing_velocities].
static func firing_velocities_vector2(projectile_speed: float, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) -> Array[Vector2]:
	return Array(
		firing_velocities_vector4(projectile_speed, BallisticSolutionsVector4Extensions.from_vector2(to_target), BallisticSolutionsVector4Extensions.from_vector2(target_velocity), BallisticSolutionsVector4Extensions.from_vector2(projectile_acceleration), BallisticSolutionsVector4Extensions.from_vector2(target_acceleration))
			.map(func(firing_velocity: Vector4) -> Vector2: return BallisticSolutionsVector2Extensions.from_vector4(firing_velocity)),
		TYPE_VECTOR2,
		"",
		null
	)
#endregion
