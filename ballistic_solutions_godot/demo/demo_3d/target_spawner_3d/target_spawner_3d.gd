class_name TargetSpawner3D extends Node3D


signal spawned(target: Target3D)
signal spawned_count(target: Target3D)


const TARGET_3D: PackedScene = preload("uid://cjarcpb57qiv8")
@export var target_initial_velocity: Vector3 = Vector3(1, 1, 0) * 20

var count: int = 0
var max_count: int = 10

func _on_timer_timeout() -> void:
	var target: NewTarget3D = TARGET_3D.instantiate()
	get_parent().add_child(target)
	target.global_position = global_position
	target.linear_velocity = target_initial_velocity
	spawned.emit(target)

	if count == 0: spawned_count.emit(target)
	count = (count + 1) % max_count
