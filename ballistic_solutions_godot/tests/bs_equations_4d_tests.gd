@tool
class_name BsEquations4DTests extends EditorScript


func _is_equal_approx_vector4(a: Vector4, b: Vector4) -> bool:
	return is_equal_approx(a.x, b.x) and is_equal_approx(a.y, b.y) and is_equal_approx(a.z, b.z) and is_equal_approx(a.w, b.w)


func _assert(condition: bool, test_name: String) -> void:
	if condition: print("[PASS] ", test_name)
	else: push_error("[FAIL] " + test_name)


func _assert_projectile_hits_target(t: float, to_target: Vector4, target_velocity: Vector4, projectile_acceleration: Vector4, target_acceleration: Vector4, test_name: String) -> void:
	var projectile_velocity: Vector4 = BsEquations4D.velocity(t, to_target, target_velocity, projectile_acceleration, target_acceleration)
	var projectile_position: Vector4 = BsEquations4D.displacement(t, projectile_velocity, projectile_acceleration)
	var target_position: Vector4 = BsEquations4D.position(to_target, t, target_velocity, target_acceleration)

	_assert(_is_equal_approx_vector4(projectile_position, target_position), test_name)


func _run() -> void:
	displacement()
	position()
	velocity_negative_time_returns_nan()
	velocity_zero_time_non_zero_to_target_returns_nan()
	velocity_zero_time_zero_to_target_returns_zero()
	velocity()
	time_by_speed_no_solution()
	time_by_speed_round_trip_both_accelerations()
	time_by_direction_no_solution()
	time_by_direction_round_trip_both_accelerations()


func displacement() -> void:
	var result: Vector4 = BsEquations4D.displacement(2, Vector4.ONE, Vector4.ONE)
	_assert(_is_equal_approx_vector4(result, Vector4.ONE * 4), "displacement")


func position() -> void:
	var result: Vector4 = BsEquations4D.position(Vector4.ONE, 2, Vector4.ONE, Vector4.ONE)
	_assert(_is_equal_approx_vector4(result, Vector4.ONE * 5), "position")


func velocity_negative_time_returns_nan() -> void:
	var result: Vector4 = BsEquations4D.velocity(-1, Vector4.ONE)
	_assert(is_nan(result.x), "velocity_negative_time_returns_nan")


func velocity_zero_time_non_zero_to_target_returns_nan() -> void:
	var result: Vector4 = BsEquations4D.velocity(0, Vector4.ONE)
	_assert(is_nan(result.x), "velocity_zero_time_non_zero_to_target_returns_nan")


func velocity_zero_time_zero_to_target_returns_zero() -> void:
	var result: Vector4 = BsEquations4D.velocity(0, Vector4.ZERO)
	_assert(result == Vector4.ZERO, "velocity_zero_time_zero_to_target_returns_zero")


func velocity() -> void:
	var result: Vector4 = BsEquations4D.velocity(2, Vector4.ONE * 2, Vector4.ONE, Vector4.ONE, Vector4.ONE)
	_assert(_is_equal_approx_vector4(result, Vector4.ONE * 2), "velocity")


func time_by_speed_no_solution() -> void:
	var to_target: Vector4 = Vector4(15, 10, 0, 0)
	var target_velocity: Vector4 = Vector4(2, -1, 0, 0)
	var projectile_acceleration: Vector4 = Vector4(0, -9.8, 0, 0)
	var target_acceleration: Vector4 = Vector4(1, 0, 0, 0)
	var speed: float = 1.0

	var times: Array[float] = BsEquations4D.time_by_speed(speed, to_target, target_velocity, projectile_acceleration, target_acceleration)
	_assert(times.is_empty(), "time_by_speed_no_solution")


func time_by_speed_round_trip_both_accelerations() -> void:
	var to_target: Vector4 = Vector4(15, 10, 0, 0)
	var target_velocity: Vector4 = Vector4(2, -1, 0, 0)
	var projectile_acceleration: Vector4 = Vector4(0, -9.8, 0, 0)
	var target_acceleration: Vector4 = Vector4(1, 0, 0, 0)
	var speed: float = 20

	var times: Array[float] = BsEquations4D.time_by_speed(speed, to_target, target_velocity, projectile_acceleration, target_acceleration)
	_assert(times.size() == 2, "time_by_speed_round_trip_both_accelerations_count")

	for i: int in times.size():
		_assert_projectile_hits_target(times[i], to_target, target_velocity, projectile_acceleration, target_acceleration, "time_by_speed_round_trip_both_accelerations[%d]" % i)


func time_by_direction_no_solution() -> void:
	var direction: Vector4 = Vector4(1, 0, 0, 0)
	var to_target: Vector4 = Vector4(5, 10, 0, 0)
	var target_velocity: Vector4 = Vector4(2, -1, 0, 0)
	var projectile_acceleration: Vector4 = Vector4(0, -9.8, 0, 0)
	var target_acceleration: Vector4 = Vector4(1, 0, 0, 0)

	var times: Array[float] = BsEquations4D.time_by_direction(direction, to_target, target_velocity, projectile_acceleration, target_acceleration)
	_assert(times.is_empty(), "time_by_direction_no_solution")


func time_by_direction_round_trip_both_accelerations() -> void:
	var to_target: Vector4 = Vector4(15, 10, 0, 0)
	var target_velocity: Vector4 = Vector4(2, -1, 0, 0)
	var projectile_acceleration: Vector4 = Vector4(0, -9.8, 0, 0)
	var target_acceleration: Vector4 = Vector4(1, 0, 0, 0)
	var speed: float = 20

	var known_times: Array[float] = BsEquations4D.time_by_speed(speed, to_target, target_velocity, projectile_acceleration, target_acceleration)
	for ki: int in known_times.size():
		var known_time: float = known_times[ki]
		var direction: Vector4 = BsEquations4D.velocity(known_time, to_target, target_velocity, projectile_acceleration, target_acceleration).normalized()

		var times: Array[float] = BsEquations4D.time_by_direction(direction, to_target, target_velocity, projectile_acceleration, target_acceleration)
		_assert(not times.is_empty(), "time_by_direction_round_trip_both_accelerations_not_empty[%d]" % ki)

		for i: int in times.size():
			_assert_projectile_hits_target(times[i], to_target, target_velocity, projectile_acceleration, target_acceleration, "time_by_direction_round_trip_both_accelerations[%d][%d]" % [ki, i])
