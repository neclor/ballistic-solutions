class_name Turret2D extends Node2D


const BULLET_2D: PackedScene = preload("res://demo_2d/projectile/bullet_2d.tscn")


var bullet_speed: float = 200
var bullet_acceleration: Vector2 = Vector2.ZERO


@onready var player: CharacterBody2D = $"../Player2D"


func _on_timer_timeout() -> void:
	create_bullets()


func create_bullets() -> void:
	var to_target: Vector2 = player.global_position - global_position
	var target_velocity: Vector2 = player.velocity
	var target_acceleration: Vector2 = player.current_acceleration

	var bullet_velocities: Array[Vector2] = BDC.velocities_vector2(bullet_speed, to_target, target_velocity, bullet_acceleration, target_acceleration)

	for bullet_velocity in bullet_velocities:
		create_bullet(bullet_velocity)


func create_bullet(velocity: Vector2) -> void:
	var new_bullet: Bullet2D = BULLET_2D.instantiate()
	new_bullet.global_position = global_position
	new_bullet.init(velocity, bullet_acceleration)
	get_parent().add_child(new_bullet)


func _on_bullet_speed_value_changed(value: float) -> void:
	bullet_speed = value


func _on_bullet_accelerate_vector_x_text_changed(new_text: String) -> void:
	bullet_acceleration.x = float(new_text)


func _on_bullet_accelerate_vector_y_text_changed(new_text: String) -> void:
	bullet_acceleration.y = float(new_text)
