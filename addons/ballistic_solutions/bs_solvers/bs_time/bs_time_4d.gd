@abstract class_name BsTime4D extends BsTime


## See [BsTime].


## Computes the earliest interception time using projectile speed. [br]
## [b]Returns:[/b] The earliest interception time (t ≥ 0). Returns [constant @GDScript.NAN] if no interception is possible.
static func best_by_speed(projectile_speed: float, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> float:
	var times: Array[float] = all_by_speed(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration)
	return NAN if times.is_empty() else times[0]


## Computes the earliest interception time using projectile direction. [br]
## [b]Returns:[/b] The earliest interception time (t ≥ 0). Returns [constant @GDScript.NAN] if no interception is possible.
static func best_by_direction(projectile_direction: Vector4, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> float:
	var times: Array[float] = all_by_direction(projectile_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)
	return NAN if times.is_empty() else times[0]


## See [method BsEquations4D.time_by_speed].
static func all_by_speed(projectile_speed: float, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Array[float]:
	return BsEquations4D.time_by_speed(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration)


## See [method BsEquations4D.time_by_direction].
static func all_by_direction(projectile_direction: Vector4, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Array[float]:
	return BsEquations4D.time_by_direction(projectile_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)
