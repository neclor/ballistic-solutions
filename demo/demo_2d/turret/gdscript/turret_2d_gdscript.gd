class_name Turret2DGDScript extends Node2D


@export var projectile_packed_scene: PackedScene
@export var player: Player2D


@export var crosshair_1: Polygon2D
@export var crosshair_2: Polygon2D


var projectile_speed: float = 200
var projectile_acceleration: Vector2 = Vector2.ZERO


var impact_times: Array[float] = []
var to_target: Vector2 = Vector2.ZERO
var target_velocity: Vector2 = Vector2.ZERO
var target_acceleration: Vector2 = Vector2.ZERO


func _physics_process(_delta: float) -> void:
	if player == null: return

	to_target = player.global_position - global_position
	target_velocity = player.velocity
	target_acceleration = player.current_acceleration

	impact_times = Bsc.impact_times_vector2(projectile_speed, to_target, target_velocity, projectile_acceleration, target_acceleration)

	match impact_times.size():
		0:
			crosshair_1.position = Vector2.ZERO
			crosshair_2.position = Vector2.ZERO
		1:
			crosshair_1.position = to_target + Bsc.displacement_vector2(impact_times[0], target_velocity, target_acceleration)
			crosshair_2.position = Vector2.ZERO
		2:
			crosshair_1.position = to_target + Bsc.displacement_vector2(impact_times[0], target_velocity, target_acceleration)
			crosshair_2.position = to_target + Bsc.displacement_vector2(impact_times[1], target_velocity, target_acceleration)


func create_projectiles() -> void:
	if player == null: return

	for time in impact_times:
		create_projectile(Bsc.firing_velocity_vector2(time, to_target, target_velocity, projectile_acceleration, target_acceleration))


func create_projectile(velocity: Vector2) -> void:
	if projectile_packed_scene == null: return

	var new_projectile: Projectile2D = projectile_packed_scene.instantiate()
	new_projectile.global_position = global_position
	new_projectile.velocity = velocity
	new_projectile.acceleration = projectile_acceleration
	get_parent().add_child(new_projectile)


func _on_timer_timeout() -> void:
	create_projectiles()
