class_name BsSolution4D extends BsSolution


## Represents a ballistic solution.


## The impact position relative to the projectile origin.
var position: Vector4: get = get_position
var _position: Vector4
func get_position() -> Vector4: return _position

## The distance to the impact position derived from [member position].
var distance_to_position: float: get = get_distance_to_position
func get_distance_to_position() -> float: return _position.length()

## The direction to the impact position derived from [member position].
var direction_to_position: Vector4: get = get_direction_to_position
func get_direction_to_position() -> Vector4: return _position.normalized()

## The required firing velocity.
var projectile_velocity: Vector4: get = get_projectile_velocity
var _projectile_velocity: Vector4
func get_projectile_velocity() -> Vector4: return _projectile_velocity

## The projectile speed derived from [member projectile_velocity].
var projectile_speed: float: get = get_projectile_speed
func get_projectile_speed() -> float: return _projectile_velocity.length()

## The projectile direction derived from [member projectile_velocity].
var projectile_direction: Vector4: get = get_projectile_direction
func get_projectile_direction() -> Vector4: return _projectile_velocity.normalized()

## The displacement from projectile origin to target at [code]t = 0[/code].
var to_target: Vector4: get = get_to_target
var _to_target: Vector4
func get_to_target() -> Vector4: return _to_target

## The distance to target at [code]t = 0[/code].
var distance_to_target: float: get = get_distance_to_target
func get_distance_to_target() -> float: return _to_target.length()

## The direction to target at [code]t = 0[/code].
var direction_to_target: Vector4: get = get_direction_to_target
func get_direction_to_target() -> Vector4: return _to_target.normalized()

## The target velocity at [code]t = 0[/code].
var target_velocity: Vector4: get = get_target_velocity
var _target_velocity: Vector4
func get_target_velocity() -> Vector4: return _target_velocity

## The target speed derived from [member target_velocity].
var target_speed: float: get = get_target_speed
func get_target_speed() -> float: return _target_velocity.length()

## The target direction derived from [member target_velocity].
var target_direction: Vector4: get = get_target_direction
func get_target_direction() -> Vector4: return _target_velocity.normalized()

## The acceleration vector of the projectile.
var projectile_acceleration: Vector4: get = get_projectile_acceleration
var _projectile_acceleration: Vector4
func get_projectile_acceleration() -> Vector4: return _projectile_acceleration

## The acceleration vector of the target.
var target_acceleration: Vector4: get = get_target_acceleration
var _target_acceleration: Vector4
func get_target_acceleration() -> Vector4: return _target_acceleration


## Returns the solution for the earliest valid interception using projectile speed. [br]
## [b]Returns:[/b] [code]null[/code] if no interception is possible.
static func best_by_speed(projectile_speed: float, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> BsSolution4D:
	var time: float = BsTime4D.best_by_speed(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration)
	return _new(time, to_target, target_velocity, projectile_acceleration, target_acceleration) if time > 0 and not is_nan(time) else null


## Returns the solution for the earliest valid interception using projectile direction. [br]
## [b]Returns:[/b] [code]null[/code] if no interception is possible.
static func best_by_direction(projectile_direction: Vector4, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> BsSolution4D:
	var time: float = BsTime4D.best_by_direction(projectile_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)
	return _new(time, to_target, target_velocity, projectile_acceleration, target_acceleration) if time > 0 and not is_nan(time) else null


## Returns all solutions using projectile speed, sorted by interception time. [br]
## [b]Returns:[/b] Empty array if no interception is possible.
static func all_by_speed(projectile_speed: float, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Array[BsSolution4D]:
	var results: Array[BsSolution4D] = []
	for time: float in BsTime4D.all_by_speed(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration):
		results.append(_new(time, to_target, target_velocity, projectile_acceleration, target_acceleration))
	return results


## Returns all solutions using projectile direction, sorted by interception time. [br]
## [b]Returns:[/b] Empty array if no interception is possible.
static func all_by_direction(projectile_direction: Vector4, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Array[BsSolution4D]:
	var results: Array[BsSolution4D] = []
	for time: float in BsTime4D.all_by_direction(projectile_direction, to_target, target_velocity, projectile_acceleration, target_acceleration):
		results.append(_new(time, to_target, target_velocity, projectile_acceleration, target_acceleration))
	return results


static func _new(time: float, to_target: Vector4, target_velocity: Vector4, projectile_acceleration: Vector4, target_acceleration: Vector4) -> BsSolution4D:
	var solution: BsSolution4D = BsSolution4D.new(true)
	solution._time = time
	solution._position = BsPosition4D.position(to_target, time, target_velocity, target_acceleration)
	solution._projectile_velocity = BsVelocity4D.velocity(time, to_target, target_velocity, projectile_acceleration, target_acceleration)
	solution._to_target = to_target
	solution._target_velocity = target_velocity
	solution._projectile_acceleration = projectile_acceleration
	solution._target_acceleration = target_acceleration
	return solution


func _init(internal_call: bool = false) -> void:
	if not internal_call: _BsLogger.error(BsSolution4D, _init, "Use factory methods instead of `new()`")
