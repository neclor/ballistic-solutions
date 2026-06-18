class_name BsSolution2D extends BsSolution


## See [BsSolution4D].




## See [member BsSolution4D.position].
var position: Vector2: get = get_position
var _position: Vector2
func get_position() -> Vector2: return _position

## See [member BsSolution4D.distance_to_position].
var distance_to_position: float: get = get_distance_to_position
func get_distance_to_position() -> float: return _position.length()

## See [member BsSolution4D.direction_to_position].
var direction_to_position: Vector2: get = get_direction_to_position
func get_direction_to_position() -> Vector2: return _position.normalized()

## See [member BsSolution4D.projectile_velocity].
var projectile_velocity: Vector2: get = get_projectile_velocity
var _projectile_velocity: Vector2
func get_projectile_velocity() -> Vector2: return _projectile_velocity

## See [member BsSolution4D.projectile_speed].
var projectile_speed: float: get = get_projectile_speed
func get_projectile_speed() -> float: return _projectile_velocity.length()

## See [member BsSolution4D.projectile_direction].
var projectile_direction: Vector2: get = get_projectile_direction
func get_projectile_direction() -> Vector2: return _projectile_velocity.normalized()

## See [member BsSolution4D.to_target].
var to_target: Vector2: get = get_to_target
var _to_target: Vector2
func get_to_target() -> Vector2: return _to_target

## See [member BsSolution4D.distance_to_target].
var distance_to_target: float: get = get_distance_to_target
func get_distance_to_target() -> float: return _to_target.length()

## See [member BsSolution4D.direction_to_target].
var direction_to_target: Vector2: get = get_direction_to_target
func get_direction_to_target() -> Vector2: return _to_target.normalized()

## See [member BsSolution4D.target_velocity].
var target_velocity: Vector2: get = get_target_velocity
var _target_velocity: Vector2
func get_target_velocity() -> Vector2: return _target_velocity

## See [member BsSolution4D.target_speed].
var target_speed: float: get = get_target_speed
func get_target_speed() -> float: return _target_velocity.length()

## See [member BsSolution4D.target_direction].
var target_direction: Vector2: get = get_target_direction
func get_target_direction() -> Vector2: return _target_velocity.normalized()

## See [member BsSolution4D.projectile_acceleration].
var projectile_acceleration: Vector2: get = get_projectile_acceleration
var _projectile_acceleration: Vector2
func get_projectile_acceleration() -> Vector2: return _projectile_acceleration

## See [member BsSolution4D.target_acceleration].
var target_acceleration: Vector2: get = get_target_acceleration
var _target_acceleration: Vector2
func get_target_acceleration() -> Vector2: return _target_acceleration


## See [method BsSolution4D.best_by_speed].
static func best_by_speed(projectile_speed: float, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) -> BsSolution2D:
	var time: float = BsTime2D.best_by_speed(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration)
	return _new(time, to_target, target_velocity, projectile_acceleration, target_acceleration) if time > 0 and not is_nan(time) else null


## See [method BsSolution4D.best_by_direction].
static func best_by_direction(projectile_direction: Vector2, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) -> BsSolution2D:
	var time: float = BsTime2D.best_by_direction(projectile_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)
	return _new(time, to_target, target_velocity, projectile_acceleration, target_acceleration) if time > 0 and not is_nan(time) else null


## See [method BsSolution4D.all_by_speed].
static func all_by_speed(projectile_speed: float, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) -> Array[BsSolution2D]:
	var results: Array[BsSolution2D] = []
	for time: float in BsTime2D.all_by_speed(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration):
		results.append(_new(time, to_target, target_velocity, projectile_acceleration, target_acceleration))
	return results


## See [method BsSolution4D.all_by_direction].
static func all_by_direction(projectile_direction: Vector2, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) -> Array[BsSolution2D]:
	var results: Array[BsSolution2D] = []
	for time: float in BsTime2D.all_by_direction(projectile_direction, to_target, target_velocity, projectile_acceleration, target_acceleration):
		results.append(_new(time, to_target, target_velocity, projectile_acceleration, target_acceleration))
	return results


static func _new(time: float, to_target: Vector2, target_velocity: Vector2, projectile_acceleration: Vector2, target_acceleration: Vector2) -> BsSolution2D:
	var solution: BsSolution2D = BsSolution2D.new(true)
	solution._time = time
	solution._position = BsPosition2D.position(to_target, time, target_velocity, target_acceleration)
	solution._projectile_velocity = BsVelocity2D.velocity(time, to_target, target_velocity, projectile_acceleration, target_acceleration)
	solution._to_target = to_target
	solution._target_velocity = target_velocity
	solution._projectile_acceleration = projectile_acceleration
	solution._target_acceleration = target_acceleration
	return solution


func _init(internal_call: bool = false) -> void:
	if not internal_call: _BsLogger.error(BsSolution2D, _init, "Use factory methods instead of `new()`")
