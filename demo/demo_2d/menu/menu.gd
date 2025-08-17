class_name Menu extends CanvasLayer


@onready var v_box_container: VBoxContainer = %VBoxContainer


func _on_show_hide_ui_pressed():
	v_box_container.visible = !v_box_container.visible
