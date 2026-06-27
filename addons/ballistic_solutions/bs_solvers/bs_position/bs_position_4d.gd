@abstract class_name BsPosition4D extends BsPosition


## See [BsPosition].


## See [method BsEquations4D.displacement].
static func displacement(time: float, velocity: Vector4, acceleration: Vector4 = Vector4.ZERO) -> Vector4:
	return BsEquations4D.displacement(time, velocity, acceleration)


## See [method BsEquations4D.position].
static func position(position: Vector4, time: float, velocity: Vector4, acceleration: Vector4 = Vector4.ZERO) -> Vector4:
	return BsEquations4D.position(position, time, velocity, acceleration)


## Computes the impact position of the earliest valid interception using projectile speed. [br]
## [b]Returns:[/b] The impact position vector. Returns a NaN vector if interception is impossible.
static func best_by_speed(projectile_speed: float, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Vector4:
	return position(to_target, BsTime4D.best_by_speed(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration), target_velocity, target_acceleration)


## Computes the impact position of the earliest valid interception using projectile direction. [br]
## [b]Returns:[/b] The impact position vector. Returns a NaN vector if interception is impossible.
static func best_by_direction(projectile_direction: Vector4, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Vector4:
	return position(to_target, BsTime4D.best_by_direction(projectile_direction, to_target, target_velocity, projectile_acceleration, target_acceleration), target_velocity, target_acceleration)


## Computes all possible impact positions using projectile speed. [br]
## [b]Returns:[/b] An array of vectors representing all valid impact positions.
static func all_by_speed(projectile_speed: float, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Array[Vector4]:
	var results: Array[Vector4] = []
	for time: float in BsTime4D.all_by_speed(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration):
		results.append(position(to_target, time, target_velocity, target_acceleration))
	return results


## Computes all possible impact positions using projectile direction. [br]
## [b]Returns:[/b] An array of vectors representing all valid impact positions.
static func all_by_direction(projectile_direction: Vector4, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Array[Vector4]:
	var results: Array[Vector4] = []
	for time: float in BsTime4D.all_by_direction(projectile_direction, to_target, target_velocity, projectile_acceleration, target_acceleration):
		results.append(position(to_target, time, target_velocity, target_acceleration))
	return results
