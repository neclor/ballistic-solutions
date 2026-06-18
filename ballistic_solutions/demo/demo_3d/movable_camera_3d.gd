class_name MovableCamera3D extends Camera3D


@export var move_speed: float = 200
@export var look_speed: float = 0.001


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
	var input_direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var vertical_direction: float = Input.get_axis("ctrl", "jump")
	var direction: Vector3 = input_direction.y * basis.z + input_direction.x * basis.x + vertical_direction * Vector3.UP

	position += direction.normalized() * move_speed * delta


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation.y += -event.relative.x * look_speed
		rotation.x = clampf(rotation.x + (-event.relative.y * look_speed), -PI / 2, PI / 2)
