@tool
class_name Test extends  EditorScript


func _run() -> void:
	print("Ballistic Solutions Test")
	
	var projectile_speed: float = 50
	var to_target: Vector2 = Vector2(200, 0)
	var target_velocity: Vector2 = Vector2(-50, 0)
	var projectile_acceleration: Vector2 = Vector2(200, 0)
	var target_acceleration: Vector2 = Vector2(100, 0)
	
	
	print("tim", Bsc.impact_times_vector2(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration))
	print("pos", Bsc.impact_positions_vector2(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration))
	print("vel", Bsc.firing_velocities_vector2(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration))





func time() -> void:
	pass



func position() -> void:
	pass




func velocity() -> void:
	pass
