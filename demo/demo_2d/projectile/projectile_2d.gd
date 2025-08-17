class_name Projectile2D extends CharacterBody2D


var acceleration: Vector2 = Vector2.ZERO


func change_color(color: Color) -> void:
	if modulate != Color.AQUA:
		modulate = color


func _physics_process(delta: float) -> void:
	var step_accel: Vector2 = acceleration * delta / 2
	velocity += step_accel
	move_and_slide()
	velocity += step_accel

	var collision: KinematicCollision2D = move_and_collide(velocity * delta, true)
	if collision:
		queue_free()
