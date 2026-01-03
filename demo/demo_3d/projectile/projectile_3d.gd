class_name Projectile3D extends CharacterBody3D


var acceleration: Vector3 = Vector3.ZERO


func _physics_process(delta: float) -> void:
	var step_accel: Vector3 = acceleration * delta / 2
	velocity += step_accel
	move_and_slide()
	velocity += step_accel

	var collision: KinematicCollision3D = move_and_collide(velocity * delta, true)
	if collision:
		queue_free()
