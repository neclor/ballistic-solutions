@abstract class_name BsVelocity4D extends BsVelocity


## See [BsVelocity].


## See [method BsEquations4D.velocity].
static func velocity(time: float, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Vector4:
	return BsEquations4D.velocity(time, to_target, target_velocity, projectile_acceleration, target_acceleration)


## Computes the firing velocity required for the earliest valid interception using projectile speed. [br]
## [b]Returns:[/b] The required firing velocity vector. Returns a NaN vector if interception is impossible.
static func best_by_speed(projectile_speed: float, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Vector4:
	return velocity(BsTime4D.best_by_speed(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration), to_target, target_velocity, projectile_acceleration, target_acceleration)


## Computes the firing velocity required for the earliest valid interception using projectile direction. [br]
## [b]Returns:[/b] The required firing velocity vector. Returns a NaN vector if interception is impossible.
static func best_by_direction(projectile_direction: Vector4, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Vector4:
	return velocity(BsTime4D.best_by_direction(projectile_direction, to_target, target_velocity, projectile_acceleration, target_acceleration), to_target, target_velocity, projectile_acceleration, target_acceleration)


## Computes firing velocities for all valid interception times using projectile speed. [br]
## [b]Returns:[/b] An array of firing velocity vectors, one for each valid interception time.
static func all_by_speed(projectile_speed: float, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Array[Vector4]:
	var results: Array[Vector4] = []
	for time: float in BsTime4D.all_by_speed(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration):
		results.append(velocity(time, to_target, target_velocity, projectile_acceleration, target_acceleration))
	return results


## Computes firing velocities for all valid interception times using projectile direction. [br]
## [b]Returns:[/b] An array of firing velocity vectors, one for each valid interception time.
static func all_by_direction(projectile_direction: Vector4, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Array[Vector4]:
	var results: Array[Vector4] = []
	for time: float in BsTime4D.all_by_direction(projectile_direction, to_target, target_velocity, projectile_acceleration, target_acceleration):
		results.append(velocity(time, to_target, target_velocity, projectile_acceleration, target_acceleration))
	return results
