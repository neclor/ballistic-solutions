@tool
extends EditorScript


func _run() -> void:
	var projectile_speed: int = 10
	var to_target: Vector2 = Vector2(12, 9)
	var target_velocity: Vector2 = Vector2(-1, 2)
	var projectile_acceleration: Vector2 = Vector2(1, 0)
	var target_acceleration: Vector2 = Vector2(0, -1)

	var velocities: Array[Vector2] = BsVelocity.all_firing_velocities_by_speed_vector2(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration)

	prints("Firing velocities:", velocities)
	print("")

	for v in velocities:
		print(v)
		print(BsVelocity.all_firing_velocities_by_direction_vector2(v, to_target, target_velocity, projectile_acceleration, target_acceleration))
		print("")

		prints(v.normalized())
		print(BsVelocity.all_firing_velocities_by_direction_vector2(v.normalized(), to_target, target_velocity, projectile_acceleration, target_acceleration))
		print("")


	var projectile_direction: Vector2 = Vector2(0, -1)
	to_target = Vector2(-10, -10)
	target_velocity = Vector2(10, 0)
	projectile_acceleration = Vector2.ZERO
	target_acceleration = Vector2.ZERO

	print(BsVelocity.all_firing_velocities_by_direction_vector2(projectile_direction, to_target, target_velocity, projectile_acceleration, target_acceleration))

	print("")

	projectile_direction = Vector2(1, -1)
	to_target = Vector2(-10, -10)
	target_velocity = Vector2(10, 0)
	projectile_acceleration = Vector2.ZERO
	target_acceleration = Vector2.ZERO

	print(BsTime.all_impact_times_by_direction_vector2(projectile_direction, to_target, target_velocity, projectile_acceleration, target_acceleration))
	print(BsVelocity.all_firing_velocities_by_direction_vector2(projectile_direction, to_target, target_velocity, projectile_acceleration, target_acceleration))
