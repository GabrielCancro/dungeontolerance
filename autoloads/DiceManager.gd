extends Node

var current_dice_drag = null
var safe_pos_dice_drag = Vector2()

func set_dice_drag(node):
	if current_dice_drag:
		current_dice_drag.position = safe_pos_dice_drag
		current_dice_drag = null
	if node:
		current_dice_drag = node
		safe_pos_dice_drag = node.position

func _process(delta: float) -> void:
	if current_dice_drag:
		current_dice_drag.position = get_viewport().get_mouse_position() + Vector2(10,15)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			set_dice_drag(null)
