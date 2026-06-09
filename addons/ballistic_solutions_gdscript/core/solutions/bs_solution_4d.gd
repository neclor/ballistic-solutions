class_name BsSolution4D extends BsSolution


##
##
## @tutorial(Ballistic Solutions): https://github.com/neclor/ballistic-solutions/blob/main/README.md


const _SCRIPT: GDScript = BsSolution4D


## The impact position relative to the projectile origin. [Vector4.ZERO] if no solution exists.
var impact_position: Vector4: get = get_impact_position
var _impact_position: Vector4 = BsVector4Extensions.NAN_VECTOR
## Returns the impact position relative to the projectile origin. [Vector4.ZERO] if no solution exists.
func get_impact_position() -> Vector4: return _impact_position

## The required firing velocity. [Vector4.ZERO] if no solution exists.
var projectile_velocity: Vector4: get = get_projectile_velocity
var _projectile_velocity: Vector4 = BsVector4Extensions.NAN_VECTOR
## Returns the required firing velocity. [Vector4.ZERO] if no solution exists.
func get_projectile_velocity() -> Vector4: return _projectile_velocity

## The projectile speed derived from [member velocity]. [code]0.0[/code] if no solution exists.
var projectile_speed: float: get = get_projectile_speed
## Returns the projectile speed derived from [member velocity]. [code]0.0[/code] if no solution exists.
func get_projectile_speed() -> float: return _projectile_velocity.length()

## The projectile direction derived from [member velocity]. [Vector4.ZERO] if no solution exists.
var projectile_direction: Vector4: get = get_projectile_direction
## Returns the projectile direction derived from [member velocity]. [Vector4.ZERO] if no solution exists.
func get_projectile_direction() -> Vector4: return _projectile_velocity.normalized()

## The displacement from projectile origin to target at [code]t = 0[/code].
var to_target: Vector4: get = get_to_target
var _to_target: Vector4 = BsVector4Extensions.NAN_VECTOR
## Returns the displacement from projectile origin to target at [code]t = 0[/code].
func get_to_target() -> Vector4: return _to_target

var distance_to_target

var direction_to_target



## The target velocity at [code]t = 0[/code].
var target_velocity: Vector4: get = get_target_velocity
var _target_velocity: Vector4 = BsVector4Extensions.NAN_VECTOR
## Returns the target velocity at [code]t = 0[/code].
func get_target_velocity() -> Vector4: return _target_velocity

var target_speed
var target_direction

## The projectile acceleration.
var projectile_acceleration: Vector4: get = get_projectile_acceleration
var _projectile_acceleration: Vector4 = BsVector4Extensions.NAN_VECTOR
## Returns the projectile acceleration.
func get_projectile_acceleration() -> Vector4: return _projectile_acceleration

## The target acceleration.
var target_acceleration: Vector4: get = get_target_acceleration
var _target_acceleration: Vector4 = BsVector4Extensions.NAN_VECTOR
## Returns the target acceleration.
func get_target_acceleration() -> Vector4: return _target_acceleration


#region best_by_direction
## Returns the [BsSolution4D] for the earliest valid interception using projectile direction. [br]
## [b]Returns:[/b] A [BsSolution4D] with [method BsSolution.is_valid] = [code]false[/code] if no interception is possible.
static func best_by_direction(projectile_direction: Vector4, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> BsSolution4D:
	var time: float = BsTime.best_by_direction_vector4(projectile_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)
	if is_nan(time):
		return _new(NAN, BsVector4Extensions.NAN_VECTOR, BsVector4Extensions.NAN_VECTOR, to_target, target_velocity, projectile_acceleration, target_acceleration)
	return _new(time,
		BsPosition.position_vector4(to_target, time, target_velocity, target_acceleration),
		BsVelocity.velocity_vector4(time, to_target, target_velocity, projectile_acceleration, target_acceleration),
		to_target, target_velocity, projectile_acceleration, target_acceleration)
#endregion


#region best_by_speed
## Returns the [BsSolution4D] for the earliest valid interception using projectile speed. [br]
## [b]Returns:[/b] A [BsSolution4D] with [method BsSolution.is_valid] = [code]false[/code] if no interception is possible.
static func best_by_speed(projectile_speed: float, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> BsSolution4D:
	var time: float = BsTime.best_by_speed_vector4(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration)
	if is_nan(time):
		return _new(NAN, BsVector4Extensions.NAN_VECTOR, BsVector4Extensions.NAN_VECTOR, to_target, target_velocity, projectile_acceleration, target_acceleration)
	return _new(time,
		BsPosition.position_vector4(to_target, time, target_velocity, target_acceleration),
		BsVelocity.velocity_vector4(time, to_target, target_velocity, projectile_acceleration, target_acceleration),
		to_target, target_velocity, projectile_acceleration, target_acceleration)
#endregion


#region all_by_direction
## Returns all [BsSolution4D] solutions using projectile direction, sorted by interception time. [br]
## [b]Returns:[/b] Empty array if no interception is possible.
static func all_by_direction(projectile_direction: Vector4, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Array[BsSolution4D]:
	var times: Array[float] = BsTime.all_by_direction_vector4(projectile_direction, to_target, target_velocity, projectile_acceleration, target_acceleration)
	var results: Array[BsSolution4D] = []
	for time: float in times:
		results.append(_new(time,
			BsPosition.position_vector4(to_target, time, target_velocity, target_acceleration),
			BsVelocity.velocity_vector4(time, to_target, target_velocity, projectile_acceleration, target_acceleration),
			to_target, target_velocity, projectile_acceleration, target_acceleration))
	return results
#endregion


#region all_by_speed
## Returns all [BsSolution4D] solutions using projectile speed, sorted by interception time. [br]
## [b]Returns:[/b] Empty array if no interception is possible.
static func all_by_speed(projectile_speed: float, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) -> Array[BsSolution4D]:
	var times: Array[float] = BsTime.all_by_speed_vector4(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration)
	var results: Array[BsSolution4D] = []
	for time: float in times:
		results.append(_new(time,
			BsPosition.position_vector4(to_target, time, target_velocity, target_acceleration),
			BsVelocity.velocity_vector4(time, to_target, target_velocity, projectile_acceleration, target_acceleration),
			to_target, target_velocity, projectile_acceleration, target_acceleration))
	return results
#endregion


static func _new(time: float, position: Vector4, projectile_velocity: Vector4, to_target: Vector4, target_velocity: Vector4, projectile_acceleration: Vector4, target_acceleration: Vector4) -> BsSolution4D:
	var solution: BsSolution4D = BsSolution4D.new(true)
	solution._time = time
	solution._position = position
	solution._projectile_velocity = projectile_velocity
	solution._to_target = to_target
	solution._target_velocity = target_velocity
	solution._projectile_acceleration = projectile_acceleration
	solution._target_acceleration = target_acceleration
	return solution


func _init(internal_call: bool = false) -> void:
	if not internal_call: _BsLogger.format_error(_SCRIPT, _init, "")
