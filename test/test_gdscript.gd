@tool
extends EditorScript


func _run() -> void:
	var projectile_speed: int = 10
	var to_target: Vector2 = Vector2(12, 9)
	var target_velocity: Vector2 = Vector2(-1, 2)
	var projectile_acceleration: Vector2 = Vector2(1, 0)
	var target_acceleration: Vector2 = Vector2(0, -1)

	# BsImpact2D: time + position + velocity in one call (quartic solved once)
	var impact: BsImpact2D = BsImpact2D.best_by_speed(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration)
	prints("Best impact — valid:", impact.is_valid, "| time:", impact.time, "| position:", impact.position, "| velocity:", impact.velocity)
	print("")

	# All impacts (fully typed)
	var impacts: Array[BsImpact2D] = BsImpact2D.all_by_speed(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration)
	prints("All impacts:", impacts.size())
	for imp: BsImpact2D in impacts:
		prints(" t=%.4f" % imp.time, "pos=", imp.position, "vel=", imp.velocity)
	print("")

	# Individual classes still work
	var velocities: Array[Vector2] = BsVelocity.all_by_speed_vector2(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration)
	prints("Firing velocities:", velocities)
	print("")

	for v: Vector2 in velocities:
		print(v)
		print(BsVelocity.all_by_direction_vector2(v, to_target, target_velocity, projectile_acceleration, target_acceleration))
		print("")

		prints(v.normalized())
		print(BsVelocity.all_by_direction_vector2(v.normalized(), to_target, target_velocity, projectile_acceleration, target_acceleration))
		print("")


	var projectile_direction: Vector2 = Vector2(0, -1)
	to_target = Vector2(-10, -10)
	target_velocity = Vector2(10, 0)
	projectile_acceleration = Vector2.ZERO
	target_acceleration = Vector2.ZERO

	print(BsVelocity.all_by_direction_vector2(projectile_direction, to_target, target_velocity, projectile_acceleration, target_acceleration))
	print("")

	projectile_direction = Vector2(1, -1)
	print(BsTime.all_by_direction_vector2(projectile_direction, to_target, target_velocity, projectile_acceleration, target_acceleration))
	print(BsVelocity.all_by_direction_vector2(projectile_direction, to_target, target_velocity, projectile_acceleration, target_acceleration))
