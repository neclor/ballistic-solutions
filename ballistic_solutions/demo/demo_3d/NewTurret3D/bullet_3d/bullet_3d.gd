class_name Bullet3D extends RigidBody3D


func _on_area_3d_body_entered(_body: Node3D):
	queue_free()
