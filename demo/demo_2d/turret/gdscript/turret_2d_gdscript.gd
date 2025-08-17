class_name Turret2DGDScript extends Node2D


@export var projectile_packed_scene: PackedScene
@export var player: Player2D


var projectile_speed: float = 200
var projectile_acceleration: Vector2 = Vector2.ZERO


func create_projectiles() -> void:
	if player == null: return
	var to_target: Vector2 = player.global_position - global_position
	var target_velocity: Vector2 = player.velocity
	var target_acceleration: Vector2 = player.current_acceleration

	var projectile_velocities: Array[Vector2] = Bdc.velocities_vector2(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration)

	for projectile_velocity in projectile_velocities:
		create_projectile(projectile_velocity)


func create_projectile(velocity: Vector2) -> void:
	if projectile_packed_scene == null: return
	var new_projectile: Projectile2D = projectile_packed_scene.instantiate()
	new_projectile.global_position = global_position
	new_projectile.velocity = velocity
	new_projectile.acceleration = projectile_acceleration
	get_parent().add_child(new_projectile)


func _on_timer_timeout() -> void:
	create_projectiles()
