extends Node2D


@onready var player: CharacterBody2D = %Player2D


func _on_player_speed_value_changed(value: float) -> void:
	player.speed = value


func _on_player_accelerate_vector_x_text_changed(new_text: String) -> void:
	player.acceleration.x = float(new_text)


func _on_player_accelerate_vector_y_text_changed(new_text: String) -> void:
	player.acceleration.y = float(new_text)
