class_name BsSolution2D extends BsSolution


##
##
## @tutorial(Ballistic Solutions): https://github.com/neclor/ballistic-solutions/blob/main/README.md


const _SCRIPT: GDScript = BsSolution2D


## The impact position relative to the projectile origin. [Vector2.ZERO] if no solution exists.
var position: Vector2: get = get_position
var _position: Vector2
## Returns the impact position relative to the projectile origin. [Vector2.ZERO] if no solution exists.
func get_position() -> Vector2: return _position

## The required firing velocity. [Vector2.ZERO] if no solution exists.
var velocity: Vector2: get = get_velocity
var _velocity: Vector2
## Returns the required firing velocity. [Vector2.ZERO] if no solution exists.
func get_velocity() -> Vector2: return _velocity

## The projectile speed derived from [member velocity]. [code]0.0[/code] if no solution exists.
var projectile_speed: float: get = get_projectile_speed
## Returns the projectile speed derived from [member velocity]. [code]0.0[/code] if no solution exists.
func get_projectile_speed() -> float: return _velocity.length()

## The projectile direction derived from [member velocity]. [Vector2.ZERO] if no solution exists.
var projectile_direction: Vector2: get = get_projectile_direction
## Returns the projectile direction derived from [member velocity]. [Vector2.ZERO] if no solution exists.
func get_projectile_direction() -> Vector2: return _velocity.normalized()

## The displacement from projectile origin to target at [code]t = 0[/code].
var to_target: Vector2: get = get_to_target
var _to_target: Vector2
## Returns the displacement from projectile origin to target at [code]t = 0[/code].
func get_to_target() -> Vector2: return _to_target

## The target velocity at [code]t = 0[/code].
var target_velocity: Vector2: get = get_target_velocity
var _target_velocity: Vector2
## Returns the target velocity at [code]t = 0[/code].
func get_target_velocity() -> Vector2: return _target_velocity

## The projectile acceleration.
var projectile_acceleration: Vector2: get = get_projectile_acceleration
var _projectile_acceleration: Vector2
## Returns the projectile acceleration.
func get_projectile_acceleration() -> Vector2: return _projectile_acceleration

## The target acceleration.
var target_acceleration: Vector2: get = get_target_acceleration
var _target_acceleration: Vector2
## Returns the target acceleration.
func get_target_acceleration() -> Vector2: return _target_acceleration


static func _new(time: float, position: Vector2, velocity: Vector2, to_target: Vector2, target_velocity: Vector2, projectile_acceleration: Vector2, target_acceleration: Vector2) -> BsSolution2D:
	var solution: BsSolution2D = BsSolution2D.new()
	solution._time = time
	solution._position = position
	solution._velocity = velocity
	solution._to_target = to_target
	solution._target_velocity = target_velocity
	solution._projectile_acceleration = projectile_acceleration
	solution._target_acceleration = target_acceleration
	return solution


#region best_by_direction
## Returns the [BsSolution2D] for the earliest valid interception using projectile direction. [br]
## [b]Returns:[/b] A [BsSolution2D] with [method BsSolution.is_valid] = [code]false[/code] if no interception is possible.
static func best_by_direction(projectile_direction: Vector2, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) -> BsSolution2D:
	var time: float = BsTime.best_by_direction_vector2(projectile_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)
	if is_nan(time):
		return _new(NAN, Vector2.ZERO, Vector2.ZERO, to_target, target_velocity, projectile_acceleration, target_acceleration)
	return _new(time,
		BsPosition.position_vector2(to_target, time, target_velocity, target_acceleration),
		BsVelocity.velocity_vector2(time, to_target, target_velocity, projectile_acceleration, target_acceleration),
		to_target, target_velocity, projectile_acceleration, target_acceleration)
#endregion


#region best_by_speed
## Returns the [BsSolution2D] for the earliest valid interception using projectile speed. [br]
## [b]Returns:[/b] A [BsSolution2D] with [method BsSolution.is_valid] = [code]false[/code] if no interception is possible.
static func best_by_speed(projectile_speed: float, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) -> BsSolution2D:
	var time: float = BsTime.best_by_speed_vector2(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration)
	if is_nan(time):
		return _new(NAN, Vector2.ZERO, Vector2.ZERO, to_target, target_velocity, projectile_acceleration, target_acceleration)
	return _new(time,
		BsPosition.position_vector2(to_target, time, target_velocity, target_acceleration),
		BsVelocity.velocity_vector2(time, to_target, target_velocity, projectile_acceleration, target_acceleration),
		to_target, target_velocity, projectile_acceleration, target_acceleration)
#endregion


#region all_by_direction
## Returns all [BsSolution2D] solutions using projectile direction, sorted by interception time. [br]
## [b]Returns:[/b] Empty array if no interception is possible.
static func all_by_direction(projectile_direction: Vector2, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) -> Array[BsSolution2D]:
	var times: Array[float] = BsTime.all_by_direction_vector2(projectile_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)
	var results: Array[BsSolution2D] = []
	for time: float in times:
		results.append(_new(time,
			BsPosition.position_vector2(to_target, time, target_velocity, target_acceleration),
			BsVelocity.velocity_vector2(time, to_target, target_velocity, projectile_acceleration, target_acceleration),
			to_target, target_velocity, projectile_acceleration, target_acceleration))
	return results
#endregion


#region all_by_speed
## Returns all [BsSolution2D] solutions using projectile speed, sorted by interception time. [br]
## [b]Returns:[/b] Empty array if no interception is possible.
static func all_by_speed(projectile_speed: float, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) -> Array[BsSolution2D]:
	var times: Array[float] = BsTime.all_by_speed_vector2(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration)
	var results: Array[BsSolution2D] = []
	for time: float in times:
		results.append(_new(time,
			BsPosition.position_vector2(to_target, time, target_velocity, target_acceleration),
			BsVelocity.velocity_vector2(time, to_target, target_velocity, projectile_acceleration, target_acceleration),
			to_target, target_velocity, projectile_acceleration, target_acceleration))
	return results
#endregion
