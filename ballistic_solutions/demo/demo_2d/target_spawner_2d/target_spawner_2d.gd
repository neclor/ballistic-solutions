class_name TargetSpawner2D extends Node2D


signal spawned(target: Target2D)

const TRACE_2D = preload("uid://byey3vgs7dwkk")

const TARGET_2D: PackedScene = preload("uid://dmplshca2p8hv")
@export var target_initial_velocity: Vector2 = Vector2(1, 1) * 100


func _on_target_timer_timeout():
	var target: Target2D = TARGET_2D.instantiate()
	target.linear_velocity = target_initial_velocity
	target.global_position = global_position
	get_parent().add_child(target)
	spawned.emit(target)


func _on_trace_timer_timeout():
	var target: Target2D = TRACE_2D.instantiate()
	target.linear_velocity = target_initial_velocity
	target.global_position = global_position
	get_parent().add_child(target)
