extends Node

var current_dice_drag = null
var safe_pos_dice_drag = Vector2()

var COLORS = {"S":"ff0055","D":"0fe559","M":"e69aff"}

func set_dice_drag(node):
	if current_dice_drag:
		Effector.move_to(current_dice_drag,safe_pos_dice_drag)
		current_dice_drag = null
	if node:
		current_dice_drag = node
		safe_pos_dice_drag = node.position

func get_dice_drag():
	return current_dice_drag

func _process(delta: float) -> void:
	if GameManager.INPUT_BLOCKER_REF.visible: return
	if current_dice_drag:
		current_dice_drag.position = get_viewport().get_mouse_position() + Vector2(10,15) - GameManager.DICES_REF.position
		if current_dice_drag.global_position.x < 220: set_dice_drag(null)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			set_dice_drag(null)

func clear_dices():
	set_dice_drag(null)
	for dice in GameManager.DICES_REF.get_children():
		Effector.fade_down_and_free(dice)
		await GameManager.timeout(.1)

func add_random_dice():
	add_dice(["S","D","M"][randi()%3])
	var dice = preload("res://nodes/Dice.tscn").instantiate()

func add_dice(type):
	var dice = preload("res://nodes/Dice.tscn").instantiate()
	dice.set_type(type)
	var size = GameManager.DICES_REF.size - dice.size
	dice.position = Vector2(randf()*size.x,randf()*size.y)
	GameManager.DICES_REF.add_child(dice)
