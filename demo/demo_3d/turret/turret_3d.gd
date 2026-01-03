class_name Turret3D extends Node3D


@export var projectile_packed_scene: PackedScene
@export var target: Target3D


@export var projectile_speed: float = 200
@export var projectile_acceleration: Vector3 = Vector3(0, -9.8, 0)


func create_projectile(velocity: Vector3) -> void:
	if projectile_packed_scene == null: return

	var new_projectile: Projectile3D = projectile_packed_scene.instantiate()
	get_parent().add_child(new_projectile)
	new_projectile.global_position = global_position
	new_projectile.velocity = velocity
	new_projectile.acceleration = projectile_acceleration


func _on_timer_timeout() -> void:
	if target == null: return
	var to_target = target.global_position - global_position
	for velocity in Bsc.firing_velocities(projectile_speed, to_target, target.velocity, projectile_acceleration, target.acceleration):
		create_projectile(velocity)
