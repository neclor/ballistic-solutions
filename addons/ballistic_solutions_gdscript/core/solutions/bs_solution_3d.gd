class_name BsSolution3D extends BsSolution


##
##
## @tutorial(Ballistic Solutions): https://github.com/neclor/ballistic-solutions/blob/main/README.md


const _SCRIPT: GDScript = BsSolution3D


## The impact position relative to the projectile origin. [Vector3.ZERO] if no solution exists.
var position: Vector3: get = get_position
var _position: Vector3
## Returns the impact position relative to the projectile origin. [Vector3.ZERO] if no solution exists.
func get_position() -> Vector3: return _position

## The required firing velocity. [Vector3.ZERO] if no solution exists.
var velocity: Vector3: get = get_velocity
var _velocity: Vector3
## Returns the required firing velocity. [Vector3.ZERO] if no solution exists.
func get_velocity() -> Vector3: return _velocity

## The projectile speed derived from [member velocity]. [code]0.0[/code] if no solution exists.
var projectile_speed: float: get = get_projectile_speed
## Returns the projectile speed derived from [member velocity]. [code]0.0[/code] if no solution exists.
func get_projectile_speed() -> float: return _velocity.length()

## The projectile direction derived from [member velocity]. [Vector3.ZERO] if no solution exists.
var projectile_direction: Vector3: get = get_projectile_direction
## Returns the projectile direction derived from [member velocity]. [Vector3.ZERO] if no solution exists.
func get_projectile_direction() -> Vector3: return _velocity.normalized()

## The displacement from projectile origin to target at [code]t = 0[/code].
var to_target: Vector3: get = get_to_target
var _to_target: Vector3
## Returns the displacement from projectile origin to target at [code]t = 0[/code].
func get_to_target() -> Vector3: return _to_target

## The target velocity at [code]t = 0[/code].
var target_velocity: Vector3: get = get_target_velocity
var _target_velocity: Vector3
## Returns the target velocity at [code]t = 0[/code].
func get_target_velocity() -> Vector3: return _target_velocity

## The projectile acceleration.
var projectile_acceleration: Vector3: get = get_projectile_acceleration
var _projectile_acceleration: Vector3
## Returns the projectile acceleration.
func get_projectile_acceleration() -> Vector3: return _projectile_acceleration

## The target acceleration.
var target_acceleration: Vector3: get = get_target_acceleration
var _target_acceleration: Vector3
## Returns the target acceleration.
func get_target_acceleration() -> Vector3: return _target_acceleration


static func _new(time: float, position: Vector3, velocity: Vector3, to_target: Vector3, target_velocity: Vector3, projectile_acceleration: Vector3, target_acceleration: Vector3) -> BsSolution3D:
	var solution: BsSolution3D = BsSolution3D.new()
	solution._time = time
	solution._position = position
	solution._velocity = velocity
	solution._to_target = to_target
	solution._target_velocity = target_velocity
	solution._projectile_acceleration = projectile_acceleration
	solution._target_acceleration = target_acceleration
	return solution


#region best_by_direction
## Returns the [BsSolution3D] for the earliest valid interception using projectile direction. [br]
## [b]Returns:[/b] A [BsSolution3D] with [method BsSolution.is_valid] = [code]false[/code] if no interception is possible.
static func best_by_direction(projectile_direction: Vector3, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO, projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) -> BsSolution3D:
	var time: float = BsTime.best_by_direction_vector3(projectile_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)
	if is_nan(time):
		return _new(NAN, Vector3.ZERO, Vector3.ZERO, to_target, target_velocity, projectile_acceleration, target_acceleration)
	return _new(time,
		BsPosition.position_vector3(to_target, time, target_velocity, target_acceleration),
		BsVelocity.velocity_vector3(time, to_target, target_velocity, projectile_acceleration, target_acceleration),
		to_target, target_velocity, projectile_acceleration, target_acceleration)
#endregion


#region best_by_speed
## Returns the [BsSolution3D] for the earliest valid interception using projectile speed. [br]
## [b]Returns:[/b] A [BsSolution3D] with [method BsSolution.is_valid] = [code]false[/code] if no interception is possible.
static func best_by_speed(projectile_speed: float, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO, projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) -> BsSolution3D:
	var time: float = BsTime.best_by_speed_vector3(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration)
	if is_nan(time):
		return _new(NAN, Vector3.ZERO, Vector3.ZERO, to_target, target_velocity, projectile_acceleration, target_acceleration)
	return _new(time,
		BsPosition.position_vector3(to_target, time, target_velocity, target_acceleration),
		BsVelocity.velocity_vector3(time, to_target, target_velocity, projectile_acceleration, target_acceleration),
		to_target, target_velocity, projectile_acceleration, target_acceleration)
#endregion


#region all_by_direction
## Returns all [BsSolution3D] solutions using projectile direction, sorted by interception time. [br]
## [b]Returns:[/b] Empty array if no interception is possible.
static func all_by_direction(projectile_direction: Vector3, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO, projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) -> Array[BsSolution3D]:
	var times: Array[float] = BsTime.all_by_direction_vector3(projectile_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)
	var results: Array[BsSolution3D] = []
	for time: float in times:
		results.append(_new(time,
			BsPosition.position_vector3(to_target, time, target_velocity, target_acceleration),
			BsVelocity.velocity_vector3(time, to_target, target_velocity, projectile_acceleration, target_acceleration),
			to_target, target_velocity, projectile_acceleration, target_acceleration))
	return results
#endregion


#region all_by_speed
## Returns all [BsSolution3D] solutions using projectile speed, sorted by interception time. [br]
## [b]Returns:[/b] Empty array if no interception is possible.
static func all_by_speed(projectile_speed: float, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO, projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) -> Array[BsSolution3D]:
	var times: Array[float] = BsTime.all_by_speed_vector3(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration)
	var results: Array[BsSolution3D] = []
	for time: float in times:
		results.append(_new(time,
			BsPosition.position_vector3(to_target, time, target_velocity, target_acceleration),
			BsVelocity.velocity_vector3(time, to_target, target_velocity, projectile_acceleration, target_acceleration),
			to_target, target_velocity, projectile_acceleration, target_acceleration))
	return results
#endregion
