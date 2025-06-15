class_name Player2D extends CharacterBody2D


var speed: float = 100
var acceleration: Vector2 = Vector2.ZERO


var current_acceleration: Vector2
var direction: Vector2


func _physics_process(delta: float) -> void:
	direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down")).normalized()

	if direction != Vector2.ZERO:
		current_acceleration = Vector2.ZERO
		velocity = direction * speed
		move_and_slide()
	else:
		current_acceleration = acceleration
		var step_accel: Vector2 = current_acceleration * delta / 2
		velocity += step_accel
		move_and_slide()
		velocity += step_accel


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("bullet"):
		body.modulate = Color.AQUA
