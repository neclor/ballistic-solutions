class_name Turret2D extends Node2D


const BULLET_2D: PackedScene = preload("uid://cx4uwxdunh5ir")
@export var bullet_speed: float = 1000


var target_counter: int = 0
var target: Target2D = null


func change_target(new_target: Target2D) -> void:
	target = new_target


func shoot() -> void:
	if target == null: return

	var velocities: Array[Vector2] = BsVelocity2D.all_by_speed(
		bullet_speed, 
		target.global_position - global_position, 
		target.linear_velocity, 
		Bullet2D.CONSTANT_FORCE, 
		target.constant_force
	)

	for vel in velocities:
		var bullet: Bullet2D = BULLET_2D.instantiate()
		bullet.global_position = global_position
		bullet.linear_velocity = vel.normalized() * bullet_speed
		get_parent().add_child(bullet)


func _on_timer_timeout():
	pass # Replace with function body.
