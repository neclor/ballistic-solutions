@abstract class_name BsEquations extends BallisticSolutions


## Provides ballistic equations.


const _SCRIPT: String = "BsEquations"


## Computes displacement under constant acceleration. [br]
## [b]Returns:[/b] The displacement vector after [param time] has elapsed.
static func displacement(time: float, velocity: Vector4, acceleration: Vector4 = Vector4.ZERO) -> Vector4:
	return time * (velocity + acceleration * time / 2)


## Computes position after elapsed time under constant acceleration. [br]
## [b]Returns:[/b] The position vector after [param time] has elapsed.
static func position(position: Vector4, time: float, velocity: Vector4 = Vector4.ZERO, acceleration: Vector4 = Vector4.ZERO) -> Vector4:
	return position + displacement(time, velocity, acceleration)


## Computes all possible interception times between a projectile and a moving target using projectile direction. [br]
## [b]Returns:[/b] A sorted array of all valid interception times (t > 0). Empty if interception is impossible.
static func time_by_direction(projectile_direction: Vector4, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Array[float]:
	projectile_direction = projectile_direction.normalized()
	var relative_acceleration: Vector4 = projectile_acceleration - target_acceleration

	var p: Vector4 = relative_acceleration - projectile_direction.dot(relative_acceleration) * projectile_direction;
	var q: Vector4 = target_velocity - projectile_direction.dot(target_velocity) * projectile_direction;
	var r: Vector4 = to_target - projectile_direction.dot(to_target) * projectile_direction;

	var a: float = p.length_squared() / 4
	var b: float = -p.dot(q)
	var c: float = q.length_squared() - p.dot(r)
	var d: float = 2 * q.dot(r)
	var e: float = r.length_squared()

	var all_impact_times: Array[float] = Array(ResSolver.quartic(a, b, c, d, e).filter(func(i: float) -> bool: return i > 0), TYPE_FLOAT, "", null)
	all_impact_times.sort()
	return all_impact_times


## Computes all possible interception times for a given projectile and a moving target using projectile speed. [br]
## [b]Returns:[/b] A sorted array of all valid interception times (t > 0). Empty if interception is impossible.
static func time_by_speed(projectile_speed: float, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Array[float]:
	if projectile_speed < 0: _BsLogger.format_warning(_SCRIPT, time_by_speed.get_method(), "Negative `projectile_speed`")

	var relative_acceleration: Vector4 = projectile_acceleration - target_acceleration

	var a: float = relative_acceleration.length_squared() / 4
	var b: float = -relative_acceleration.dot(target_velocity)
	var c: float = target_velocity.length_squared() - relative_acceleration.dot(to_target) - projectile_speed * projectile_speed
	var d: float = 2 * target_velocity.dot(to_target)
	var e: float = to_target.length_squared()

	var all_impact_times: Array[float] = Array(ResSolver.quartic(a, b, c, d, e).filter(func(i: float) -> bool: return i > 0), TYPE_FLOAT, "", null)
	all_impact_times.sort()
	return all_impact_times


## See [method BsVelocity.firing_velocity].
static func velocity(impact_time: float, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Vector4:
	if impact_time < 0 or is_zero_approx(impact_time):
		_BsLogger.format_error(_SCRIPT, velocity.get_method(), "Zero or negative `impact_time`", "nan vector")
		return BsVector4Extensions.NAN_VECTOR
	return to_target / impact_time + target_velocity - (projectile_acceleration - target_acceleration) * impact_time / 2
