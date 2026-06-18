class_name DemoScene2D extends Node2D


@export var player: Player2D
@export var turret_gdscript: Turret2DGDScript
@export var turret_csharp: Turret2DCSharp


func _on_player_speed_value_changed(value: float) -> void:
	player.speed = value


func _on_player_accelerate_vector_x_text_changed(new_text: String) -> void:
	player.acceleration.x = float(new_text)


func _on_player_accelerate_vector_y_text_changed(new_text: String) -> void:
	player.acceleration.y = float(new_text)


func _on_projectile_speed_value_changed(value: float) -> void:
	if turret_gdscript != null: turret_gdscript.projectile_speed = value
	if turret_csharp != null: turret_csharp.ProjectileSpeed = value


func _on_projectile_accelerate_vector_x_text_changed(new_text: String) -> void:
	if turret_gdscript != null: turret_gdscript.projectile_acceleration.x = float(new_text)
	if turret_csharp != null: turret_csharp.ProjectileAcceleration.x = float(new_text)


func _on_projectile_accelerate_vector_y_text_changed(new_text: String) -> void:
	if turret_gdscript != null: turret_gdscript.projectile_acceleration.y = float(new_text)
	if turret_csharp != null: turret_csharp.ProjectileAcceleration.y = float(new_text)
