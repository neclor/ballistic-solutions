class_name Bullet2D extends RigidBody2D


const CONSTANT_FORCE: Vector2 = Vector2.DOWN * 980


func _ready() -> void:
	add_constant_force(CONSTANT_FORCE)


func _on_body_entered(_body: Node):
	queue_free()
